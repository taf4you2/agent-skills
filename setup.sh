#!/usr/bin/env bash
# Podłącza skille z tego repozytorium do projektu, w którym zostało sklonowane.
# Uruchom z katalogu projektu: agent-skills/setup.sh
# Można uruchamiać wielokrotnie, np. po git pull w sklonowanym repozytorium.
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
project=$(pwd -P)
clone=$(basename "$repo")
start='<!-- agent-skills:start -->'
end='<!-- agent-skills:end -->'

case $(uname -s) in
  MINGW* | MSYS* | CYGWIN*)
    echo "Na Windowsie uruchom: powershell -ExecutionPolicy Bypass -File $clone\\setup.ps1" >&2
    exit 1
    ;;
esac

if [[ $(dirname "$repo") != "$project" ]]; then
  echo "Uruchom skrypt z katalogu nadrzędnego wobec repozytorium: $(dirname "$repo")" >&2
  exit 1
fi

# Konfiguracja jest lokalna: wpisy w .git/info/exclude nie trafiają do commitów projektu.
exclude=''
if git rev-parse --git-dir >/dev/null 2>&1; then
  exclude=$(git rev-parse --git-path info/exclude)
  prefix=$(git rev-parse --show-prefix)
  mkdir -p "$(dirname "$exclude")"
  touch "$exclude"
  [[ -z $(tail -c1 "$exclude") ]] || echo >>"$exclude"
fi

ignore() {
  [[ -z $exclude ]] || grep -qxF "/$prefix$1" "$exclude" || echo "/$prefix$1" >>"$exclude"
}

# Nie nadpisuje niczego, co nie jest już właściwym linkiem.
link_skill() {
  local path=$1 target=$2
  if [[ -L $path && $(readlink "$path") == "$target" ]]; then
    return 0
  fi
  if [[ -e $path || -L $path ]]; then
    echo "Pominięto $path: ta ścieżka już istnieje" >&2
    return 1
  fi
  ln -s "$target" "$path"
}

ensure_import() {
  local file=$1 line=$2
  if [[ -s $file ]]; then
    grep -qxF "$line" "$file" && return 0
    printf '\n' >>"$file"
  elif [[ ! -e $file ]]; then
    ignore "$file"
  fi
  printf '%s\n' "$line" >>"$file"
}

update_agents_md() {
  local block tmp
  block="$start
$(awk '/^## /{on=($0=="## Polecenia własne")} on' "$repo/AGENTS.md")
$end"

  if [[ ! -e AGENTS.md ]]; then
    ignore AGENTS.md
    printf '%s\n' "$block" >AGENTS.md
  elif ! grep -qxF "$start" AGENTS.md; then
    printf '\n%s\n' "$block" >>AGENTS.md
  elif grep -qxF "$end" AGENTS.md; then
    tmp=$(mktemp)
    BLOCK=$block awk -v s="$start" -v e="$end" '
      $0==s {print ENVIRON["BLOCK"]; skip=1; next}
      skip {if ($0==e) skip=0; next}
      {print}' AGENTS.md >"$tmp"
    cat "$tmp" >AGENTS.md
    rm "$tmp"
  else
    echo "AGENTS.md ma znacznik początku bloku bez znacznika końca: $end" >&2
    exit 1
  fi
}

mkdir -p .agents/skills .claude/skills
ignore "$clone/"

# Usuwa linki do skilli, których po git pull już nie ma.
for path in .agents/skills/* .claude/skills/*; do
  if [[ -L $path && ! -e $path ]]; then
    case $(readlink "$path") in
      "../../$clone/.agents/skills/"* | ../../.agents/skills/*) rm "$path" ;;
    esac
  fi
done

# Codex i Gemini CLI czytają .agents/skills, Claude Code czyta .claude/skills.
for dir in "$repo"/.agents/skills/*/; do
  name=$(basename "$dir")
  link_skill ".agents/skills/$name" "../../$clone/.agents/skills/$name" || continue
  ignore ".agents/skills/$name"
  link_skill ".claude/skills/$name" "../../.agents/skills/$name" || continue
  ignore ".claude/skills/$name"
done

update_agents_md
ensure_import CLAUDE.md '@AGENTS.md'
ensure_import GEMINI.md '@./AGENTS.md'

echo "Gotowe: skille z $clone są podłączone do $project"
