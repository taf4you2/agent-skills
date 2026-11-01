# Podlacza skille z tego repozytorium do projektu, w ktorym zostalo sklonowane.
# Uruchom z katalogu projektu:
#   powershell -ExecutionPolicy Bypass -File agent-skills\setup.ps1
# Mozna uruchamiac wielokrotnie, np. po git pull w sklonowanym repozytorium.
# Plik ma pozostac w ASCII: Windows PowerShell 5.1 czyta skrypty bez BOM w kodowaniu ANSI.
$ErrorActionPreference = 'Stop'

$repo = $PSScriptRoot
$project = (Get-Location).ProviderPath
$clone = Split-Path $repo -Leaf
$start = '<!-- agent-skills:start -->'
$end = '<!-- agent-skills:end -->'
$utf8 = New-Object System.Text.UTF8Encoding($false)

if ((Split-Path $repo -Parent) -ne $project) {
    throw "Uruchom skrypt z katalogu nadrzednego wobec repozytorium: $(Split-Path $repo -Parent)"
}

function Invoke-Git($arguments) {
    # W PowerShell 5.1 stderr programu przy ustawieniu Stop konczy sie wyjatkiem.
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $output = & git @arguments 2>$null
        if ($LASTEXITCODE -eq 0) { return "$output" }
        return $null
    } finally {
        $ErrorActionPreference = $previous
    }
}

# Konfiguracja jest lokalna: wpisy w .git/info/exclude nie trafiaja do commitow projektu.
$exclude = $null
$prefix = ''
if ((Get-Command git -ErrorAction SilentlyContinue) -and (Invoke-Git @('rev-parse', '--git-dir'))) {
    # Git zwraca sciezke wzgledna lub, np. w worktree, bezwzgledna.
    $exclude = [IO.Path]::Combine($project, (Invoke-Git @('rev-parse', '--git-path', 'info/exclude')))
    $prefix = Invoke-Git @('rev-parse', '--show-prefix')
    New-Item -ItemType Directory -Force -Path (Split-Path $exclude) | Out-Null
    if (-not (Test-Path -LiteralPath $exclude)) { [IO.File]::WriteAllText($exclude, '', $utf8) }
}

function Add-Ignore($path) {
    if (-not $exclude) { return }
    $entry = "/$prefix$path"
    $text = [IO.File]::ReadAllText($exclude)
    if (($text -split '\r?\n') -ccontains $entry) { return }
    if ($text -and -not $text.EndsWith("`n")) { $text += "`n" }
    [IO.File]::WriteAllText($exclude, "$text$entry`n", $utf8)
}

function Get-Entry($path) {
    # Get-ChildItem, bo Get-Item i Test-Path nie widza uszkodzonych linkow.
    $name = Split-Path $path -Leaf
    Get-ChildItem -LiteralPath (Split-Path $path) -Force | Where-Object { $_.Name -eq $name }
}

function Test-Link($item) {
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function Get-LinkTarget($item) {
    return (@($item.Target)[0] -replace '^\\\\\?\\', '')
}

# Nie nadpisuje niczego, co nie jest juz wlasciwym linkiem.
function Add-SkillLink($relative, $target) {
    $path = Join-Path $project $relative
    $item = Get-Entry $path
    if ($item) {
        if ((Test-Link $item) -and (Get-LinkTarget $item) -eq $target) { return $true }
        Write-Warning "Pominieto ${relative}: ta sciezka juz istnieje"
        return $false
    }
    # Junction nie wymaga uprawnien administratora ani trybu deweloperskiego.
    $type = if ($env:OS -eq 'Windows_NT') { 'Junction' } else { 'SymbolicLink' }
    New-Item -ItemType $type -Path $path -Target $target | Out-Null
    return $true
}

function Add-Import($file, $line) {
    $path = Join-Path $project $file
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Ignore $file
        [IO.File]::WriteAllText($path, "$line`n", $utf8)
        return
    }
    $text = [IO.File]::ReadAllText($path)
    if (($text -split '\r?\n') -ccontains $line) { return }
    $separator = if ($text) { "`n" } else { '' }
    [IO.File]::WriteAllText($path, "$text$separator$line`n", $utf8)
}

function Update-AgentsMd {
    $inside = $false
    $commands = foreach ($line in [IO.File]::ReadAllLines((Join-Path $repo 'AGENTS.md'))) {
        if ($line.StartsWith('## ')) { $inside = $line -match '^## Polecenia w\S+e$' }
        if ($inside) { $line }
    }
    $block = @($start) + $commands + @($end)
    $path = Join-Path $project 'AGENTS.md'

    if (-not (Test-Path -LiteralPath $path)) {
        Add-Ignore 'AGENTS.md'
        [IO.File]::WriteAllText($path, (($block -join "`n") + "`n"), $utf8)
        return
    }

    $text = [IO.File]::ReadAllText($path)
    $newline = if ($text.Contains("`r`n")) { "`r`n" } else { "`n" }
    $lines = $text -split '\r?\n'
    if ($lines -cnotcontains $start) {
        [IO.File]::WriteAllText($path, ($text + $newline + ($block -join $newline) + $newline), $utf8)
    } elseif ($lines -cnotcontains $end) {
        throw "AGENTS.md ma znacznik poczatku bloku bez znacznika konca: $end"
    } else {
        $skip = $false
        $result = foreach ($line in $lines) {
            if ($line -ceq $start) { $block; $skip = $true; continue }
            if ($skip) { if ($line -ceq $end) { $skip = $false }; continue }
            $line
        }
        [IO.File]::WriteAllText($path, ($result -join $newline), $utf8)
    }
}

foreach ($dir in '.agents\skills', '.claude\skills') {
    $full = Join-Path $project ($dir -replace '\\', [IO.Path]::DirectorySeparatorChar)
    New-Item -ItemType Directory -Force -Path $full | Out-Null

    # Usuwa linki do skilli, ktorych po git pull juz nie ma, lub do przeniesionego projektu.
    foreach ($item in Get-ChildItem -LiteralPath $full -Force) {
        if (-not (Test-Link $item)) { continue }
        $target = Get-LinkTarget $item
        if ($target -match '[\\/]\.agents[\\/]skills[\\/][^\\/]+$' -and -not (Test-Path -LiteralPath $target)) {
            # Bez -Recurse: usuwa sam link, nigdy zawartosci katalogu docelowego.
            $item.Delete()
        }
    }
}
Add-Ignore "$clone/"

# Codex i Gemini CLI czytaja .agents/skills, Claude Code czyta .claude/skills.
foreach ($skill in Get-ChildItem -LiteralPath (Join-Path $repo (Join-Path '.agents' 'skills')) -Directory) {
    $name = $skill.Name
    foreach ($tool in '.agents', '.claude') {
        if (-not (Add-SkillLink (Join-Path $tool (Join-Path 'skills' $name)) $skill.FullName)) { break }
        Add-Ignore "$tool/skills/$name"
    }
}

Update-AgentsMd
Add-Import 'CLAUDE.md' '@AGENTS.md'
Add-Import 'GEMINI.md' '@./AGENTS.md'

Write-Output "Gotowe: skille z $clone sa podlaczone do $project"
