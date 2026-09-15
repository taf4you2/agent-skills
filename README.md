# agent-skills

Kurator i agregator skilli dla agentów kodujących (Claude Code, Codex, Antigravity) — jedno miejsce, w którym trzymasz listę przydatnych skilli, ich zalecane zestawy dla różnych typów projektów oraz automatyczną synchronizację z ich źródłowymi repozytoriami.

## Co to jest

To repozytorium **nie definiuje skilli od zera** — zbiera i porządkuje najlepsze skille stworzone przez społeczność (Matt Pocock, Vercel Labs, Addy Osmani i inni), dodaje do nich:

- **`skillList.md`** — pełną listę rekomendowanych skilli z linkami do źródeł
- **`skill-zestawy.md`** — gotowe zestawy skilli dopasowane do typu projektu
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
| **systematic-debugging** | Ustalanie przyczyny źródłowej błędów przed poprawką | [`.agents/skills/systematic-debugging/SKILL.md`](./.agents/skills/systematic-debugging/SKILL.md) |
| **verification-before-completion** | Uruchamianie testów i kontroli przed uznaniem zadania za zakończone | [`.agents/skills/verification-before-completion/SKILL.md`](./.agents/skills/verification-before-completion/SKILL.md) |
| **source-driven-development** | Sprawdzanie bibliotek i API w dokumentacji źródłowej zamiast zgadywania | [`.agents/skills/source-driven-development/SKILL.md`](./.agents/skills/source-driven-development/SKILL.md) |
| **code-review** | Sprawdzanie zmian pod kątem standardów projektu i specyfikacji | [`.agents/skills/code-review/SKILL.md`](./.agents/skills/code-review/SKILL.md) |

Pełny indeks z opisami: [`AGENTS.md`](./AGENTS.md). Pozostałe skille z [`skillList.md`](./skillList.md) są na razie tylko referencjami do zewnętrznych repozytoriów (nie są jeszcze zsynchronizowane lokalnie).

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

Pełne zestawy dla frontend desktop (Angular+Wails+Go), backendu (C#/TS), UI/UX i architektury — patrz [`skill-zestawy.md`](./skill-zestawy.md).

## Automatyczna synchronizacja

| Skill      | Źródło                                          | Harmonogram              |
|------------|--------------------------------------------------|---------------------------|
| `caveman`  | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | co poniedziałek, 00:00 UTC |
| `ponytail` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | co poniedziałek, 03:00 UTC |

Można też uruchomić ręcznie w zakładce **Actions** → wybrany workflow → **Run workflow**.

## Dodawanie nowego zsynchronizowanego skilla

1. Skopiuj jeden z istniejących workflow'ów (`.github/workflows/update-caveman.yml`)
2. Podmień źródłowy URL i ścieżkę docelową
3. Dodaj krok kopiujący pobrany `SKILL.md` do `.agents/skills/<nazwa>/SKILL.md`, żeby skill działał też w Codex
4. Dodaj wpis do [`AGENTS.md`](./AGENTS.md), żeby skill był widoczny dla Antigravity
5. Dodaj `permissions: contents: write` i `git pull --rebase origin main` przed `git push`, żeby uniknąć konfliktów z innymi workflow'ami
