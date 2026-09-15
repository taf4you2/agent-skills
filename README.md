# agent-skills

Kurator i agregator skilli dla agentów kodujących (Claude Code, Codex, Antigravity) — jedno miejsce, w którym trzymasz listę przydatnych skilli, ich zalecane zestawy dla różnych typów projektów oraz automatyczną synchronizację z ich źródłowymi repozytoriami.

## Co to jest

To repozytorium **nie definiuje skilli od zera** — zbiera i porządkuje najlepsze skille stworzone przez społeczność (Matt Pocock, Vercel Labs, Addy Osmani i inni), dodaje do nich:

- **automatyczną synchronizację** wybranych skilli przez GitHub Actions, żeby zawsze mieć aktualną wersję ich `SKILL.md`
- **wspólną strukturę folderów**, żeby te same skille działały w Claude Code, Codex i Antigravity bez ręcznego kopiowania

## Obsługiwane narzędzia

| Narzędzie | Skąd czyta skille |
|-----------|--------------------|
| **Claude Code** | `.agents/skills/<nazwa>/SKILL.md` (lub `.caveman/`, `.ponytail/` — legacy ścieżki) |
| **Codex** | `.agents/skills/<nazwa>/SKILL.md` |
| **Antigravity** | `AGENTS.md` w rootcie (index) i zagnieżdżone `AGENTS.md`/`SKILL.md` w `.agents/skills/` |

## Dostępne skille w tym repo

Te skille są już zsynchronizowane i gotowe do użycia (aktualizowane automatycznie co tydzień):

| Skill | Opis | Ścieżka (wspólna) |
|-------|------|---------|
| **caveman** | Tryb ultra-skompresowanej komunikacji — mniej tokenów, ta sama precyzja techniczna | [`.agents/skills/caveman/SKILL.md`](./.agents/skills/caveman/SKILL.md) |
| **ponytail** | Tryb "leniwego seniora" — YAGNI, minimalny kod, reużywanie zamiast pisania od nowa | [`.agents/skills/ponytail/SKILL.md`](./.agents/skills/ponytail/SKILL.md) |

Pełny indeks z opisami: [`AGENTS.md`](./AGENTS.md).

## Jak sklonować do projektu

### Opcja A: Globalnie (polecane, dostępne we wszystkich projektach)

```bash
git clone https://github.com/taf4you2/agent-skills ~/.agents/skills
```

Claude Code automatycznie znajdzie skille w `~/.agents/skills/`.

### Opcja B: Tylko w jednym projekcie (jako submodule)

```bash
cd mój-projekt
git submodule add https://github.com/taf4you2/agent-skills .agents/skills
```

### Opcja C: Skopiować pojedynczy skill

```bash
cd mój-projekt
mkdir -p .agents/skills/caveman
curl -fsSL https://raw.githubusercontent.com/taf4you2/agent-skills/main/.agents/skills/caveman/SKILL.md \
  -o .agents/skills/caveman/SKILL.md
```

## Rekomendowany zestaw globalny

```text
ponytail
caveman
systematic-debugging
verification-before-completion
source-driven-development
code-review
```

## Automatyczna synchronizacja

| Skill      | Źródło                                          | Harmonogram              |
|------------|--------------------------------------------------|---------------------------|
| `caveman`  | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | co poniedziałek, 00:00 UTC |
| `ponytail` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | co poniedziałek, 03:00 UTC |

Właściwe workflowy synchronizacji (`update-caveman.yml`, `update-ponytail.yml`) żyją na branchu `development`, nie na `main` — `main` zawiera tylko lekki dispatcher (`.github/workflows/trigger-sync.yml`), który co tydzień odpala je zdalnie przez `workflow_dispatch --ref development`. Dzięki temu `main` nie ma u siebie logiki CI, a mimo to pliki skilli na `main` aktualizują się automatycznie (workflow z `development` checkout'uje i pushuje do `main`).

Ręczne uruchomienie: zakładka **Actions** → wybrany workflow na branchu `development` → **Run workflow**, albo `gh workflow run update-caveman.yml --ref development`.

## Dodawanie nowego zsynchronizowanego skilla

Pracuj na branchu `development`:

1. Skopiuj jeden z istniejących workflow'ów (`.github/workflows/update-caveman.yml`)
2. Podmień źródłowy URL i ścieżkę docelową
3. Dodaj krok kopiujący pobrany `SKILL.md` do `.agents/skills/<nazwa>/SKILL.md`, żeby skill działał też w Codex
4. Dodaj wpis do [`AGENTS.md`](./AGENTS.md), żeby skill był widoczny dla Antigravity
5. Zostaw `permissions: contents: write`, `ref: main` w kroku checkout i `git pull --rebase origin main` przed `git push`, żeby workflow trafiał na `main`, nie na `development`
6. Dodaj wywołanie nowego workflow'a w `.github/workflows/trigger-sync.yml` na `main`, żeby dispatcher też go odpalał co tydzień


