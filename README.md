# agent-skills

Zbiór skilli dla agentów kodujących (Claude Code, Codex, Antigravity) oraz krótkich materiałów pomocniczych do pracy w repozytoriach — jedno miejsce, w którym trzymasz listę przydatnych skilli, ich zalecane zestawy dla różnych typów projektów, automatyczną synchronizację z ich źródłowymi repozytoriami i wspólne konwencje pracy.

## Co to jest

To repozytorium zbiera i porządkuje skille stworzone przez społeczność (Matt Pocock, Vercel Labs, Addy Osmani i inni) oraz zawiera własne skille `diff-review`, `conventionals` i `ocen`. Dodaje do nich:

- **automatyczną synchronizację** wybranych skilli przez GitHub Actions, żeby zawsze mieć aktualną wersję ich `SKILL.md`
- **wspólną strukturę folderów**, żeby te same skille działały w Claude Code, Codex i Antigravity bez ręcznego kopiowania
- **materiały pomocnicze**, które ujednolicają codzienną pracę, np. zasady pisania wiadomości commitów

## Obsługiwane narzędzia

| Narzędzie | Skąd czyta skille |
|-----------|--------------------|
| **Claude Code** | `.claude/skills/<nazwa>/SKILL.md` (projekt) lub `~/.claude/skills/<nazwa>/SKILL.md` (globalnie) — **nie** `.agents/skills/`, patrz sekcja niżej |
| **Codex** | `.agents/skills/<nazwa>/SKILL.md` |
| **Antigravity** | `AGENTS.md` w rootcie (index) i zagnieżdżone `AGENTS.md`/`SKILL.md` w `.agents/skills/` |

> **Uwaga (Claude Code):** to repo trzyma pliki skilli pod `.agents/skills/` (dla Codex/Antigravity) oraz pod legacy ścieżkami `.caveman/`, `.ponytail/`. Claude Code nie skanuje żadnej z tych lokalizacji automatycznie — żeby skill był widoczny, jego `SKILL.md` musi fizycznie leżeć (lub być zlinkowany) pod `.claude/skills/<nazwa>/SKILL.md`. Zobacz [„Submodule + Claude Code”](#submodule--claude-code) niżej.

## Dostępne skille w tym repo

Poniższe skille są gotowe do użycia. `caveman` i `ponytail` są aktualizowane automatycznie co tydzień; `grug` jest kopią z [replete/grug](https://github.com/replete/grug), aktualizowaną ręcznie; `diff-review`, `conventionals` i `ocen` są utrzymywane lokalnie w tym repozytorium.

| Skill | Opis | Ścieżka (wspólna) |
|-------|------|---------|
| **caveman** | Tryb ultra-skompresowanej komunikacji — mniej tokenów, ta sama precyzja techniczna | [`.agents/skills/caveman/SKILL.md`](./.agents/skills/caveman/SKILL.md) |
| **ponytail** | Tryb "leniwego seniora" — YAGNI, minimalny kod, reużywanie zamiast pisania od nowa | [`.agents/skills/ponytail/SKILL.md`](./.agents/skills/ponytail/SKILL.md) |
| **grug** | Praktyczne porady programistyczne w stylu Grug Brained Developer — prostota i ograniczanie złożoności | [`.agents/skills/grug/SKILL.md`](./.agents/skills/grug/SKILL.md) |
| **diff-review** | Porównanie niezacommitowanych zmian z `HEAD` oraz ocena błędów, ryzyk i przypadków brzegowych | [`.agents/skills/diff-review/SKILL.md`](./.agents/skills/diff-review/SKILL.md) |
| **conventionals** | Przygotowanie wiadomości według Conventional Commits bez wykonywania commita | [`.agents/skills/conventionals/SKILL.md`](./.agents/skills/conventionals/SKILL.md) |
| **ocen** | Ocena planu lub zmian: kierunek względem celu oraz błędy, podatności i pominięte przypadki brzegowe | [`.agents/skills/ocen/SKILL.md`](./.agents/skills/ocen/SKILL.md) |

Pełny indeks z opisami: [`AGENTS.md`](./AGENTS.md).

### Skille z pstack

Wybrane skille z [pstack](https://github.com/cursor/plugins/tree/main/pstack) (Lauren Tan, MIT), skopiowane bez zmian z `cursor/plugins` @ `e5136d8` i aktualizowane ręcznie. Wybrano tylko te, które nie zależą od Cursora (subagentów z mapowaniem modeli, `~/.cursor/rules`, pluginu `cursor-team-kit`). Licencja jest w [`THIRD_PARTY_LICENSES.md`](./THIRD_PARTY_LICENSES.md) — przy kopiowaniu skilli do innego projektu dołącz jej treść. `.claude/skills/<nazwa>` to link do `.agents/skills/<nazwa>`.

| Skill | Opis |
|-------|------|
| **tdd** | Najpierw test, który pada, potem poprawka — tylko przy tanim, lokalnym teście |
| **blast-radius** | Co zmiana może zepsuć poza diffem, z dowodem z uruchomionego kodu |
| **technical-writing** | Standard pisania dokumentacji, RFC, README, opisów PR i commitów (Diátaxis, styl Google) |
| **unslop** | Usuwanie śladów tekstu pisanego przez AI |
| **in-your-own-words** | Agent opisuje własnymi słowami cel i problem przed startem |
| **sharpen** | Doprecyzowanie zadania: podejście eksperta i to, o co naprawdę chodzi |
| **benchmark-checklist** | Weryfikacja pomiaru wydajności przed raportem |
| **correct** | Zamiana powtarzanych błędów agentów w architekturę, typy, lint lub testy |
| **typescript-best-practices** | Dobre praktyki przy plikach `.ts`/`.tsx` |
| **principle-\*** | Zasady inżynierskie: `test-behavior-not-implementation`, `foundational-thinking`, `model-the-domain`, `type-system-discipline`, `boundary-discipline`, `explain-the-number`, `encode-lessons-in-structure`, `migrate-callers-then-delete-legacy-apis`, `sequence-verifiable-units`, `make-operations-idempotent` |

Wszystkie mają w nagłówku `disable-model-invocation: true`, więc w Claude Code agent nie uruchomi ich sam — wywołujesz je ręcznie, np. `/tdd`, `/blast-radius`, `/principle-model-the-domain`. W pstack zasady `principle-*` ładuje automatycznie `poteto-mode`, którego tu nie ma.

Skille odwołują się do siebie nawzajem (np. `technical-writing` → `unslop`, `typescript-best-practices` → `principle-type-system-discipline`), więc kopiuj je razem. Dwa odwołania prowadzą do skilli, których tu nie ma: `principle-prove-it-works` (jego rolę pełni `verification-before-completion`) i `principle-build-the-lever`.

### Użycie `grug`

Wpisz **„/grug”**, **„/grugmode”** lub **„grug mode”**, np. `/grug czy ten projekt potrzebuje mikroserwisów?`. Agent udziela praktycznych porad programistycznych w charakterystycznym, prostym angielskim stylu gruga, z naciskiem na ograniczanie złożoności.

Tryb pozostaje aktywny w kolejnych odpowiedziach aż do polecenia **„stop grug”** lub **„normal mode”**. W tym repo `.claude/skills/grug` jest linkiem do `.agents/skills/grug`, więc Claude Code korzysta z tego samego pliku co Codex. Po skopiowaniu skilla do innego projektu dodaj do jego `AGENTS.md` regułę uruchamiania z sekcji „Polecenia własne” tego repozytorium.

Źródło: [replete/grug](https://github.com/replete/grug). Oryginalny `SKILL.md` zachowano bez zmian; licencja MIT znajduje się w [`.agents/skills/grug/LICENSE`](./.agents/skills/grug/LICENSE).

### Użycie `diff-review`

Wpisz w rozmowie z agentem **„diff”** lub **„zrób diff”**. Reguła w [`AGENTS.md`](./AGENTS.md) kieruje agenta do skilla `diff-review`.

Przegląd porównuje bieżące pliki z ostatnim commitem bieżącej gałęzi (`HEAD`), uwzględniając zmiany staged, unstaged oraz nowe nieśledzone pliki. Raport opisuje dodane, zmienione i usunięte elementy, wskazuje konkretne problemy i przypadki brzegowe oraz proponuje poprawki. Sam przegląd nie modyfikuje plików ani historii Git.

Po skopiowaniu skilla do innego projektu dodaj do jego `AGENTS.md` regułę uruchamiania z sekcji „Polecenia własne” tego repozytorium.

### Użycie `conventionals`

Wpisz **„conventionals”** lub **„napisz treść commita według Conventional Commits”**. Agent przygotuje gotową do skopiowania wiadomość w formacie `type(scope): description`, z opcjonalną treścią i stopkami.

Jeśli nie wskażesz zakresu, wiadomość opisze zmiany staged; gdy ich nie ma, obejmie zmiany robocze i nowe nieśledzone pliki. Skill dobiera typ i zakres do zmian, uwzględnia konwencje projektu oraz oznacza zmiany łamiące kompatybilność. Nie wykonuje stagingu, commita ani pushowania.

Po skopiowaniu skilla do innego projektu dodaj do jego `AGENTS.md` regułę uruchamiania z sekcji „Polecenia własne” tego repozytorium.

### Użycie `ocen`

Wpisz **„oceń”** (lub **„ocen”**). Agent sam ustali, co ocenić:

| Sytuacja | Co jest oceniane |
|----------|------------------|
| „oceń plan”, „oceń zmiany”, „oceń względem develop” | Wskazany przedmiot lub zakres |
| Gałąź ma własne commity względem `main` | Całość pracy od wspólnego przodka z `main` razem z lokalnymi zmianami; raport oddziela część niezacommitowaną |
| Są tylko lokalne zmiany | Zmiany staged, unstaged i nowe nieśledzone pliki względem `HEAD` |
| Brak zmian | Plan lub rozwiązanie z rozmowy albo pasujący plan z `docs/plans/` |
| Kontekst niejednoznaczny | Agent zadaje jedno pytanie |

Raport zaczyna się od przedmiotu, celu, zakresu i werdyktu („dobry kierunek”, „wymaga korekt”, „wymaga zmiany podejścia” albo „brak danych do oceny”). Następnie wymienia problemy według istotności — z osobno podaną wagą i pewnością, miejscem, scenariuszem i kierunkiem poprawki — a sugestie ulepszeń pokazuje oddzielnie. Skill nie wprowadza poprawek, nie robi stagingu ani commitów. Testy i lintery uruchamia tylko na wyraźną prośbę, np. „oceń i uruchom testy”, i wtedy wymienia pliki, które sprawdzenia utworzyły lub zmieniły.

**Kiedy który skill:**

| Skill | Do czego |
|-------|----------|
| `diff-review` („diff”) | Co zmieniło się lokalnie względem `HEAD` i jakie są w tym usterki |
| `ocen` („oceń”) | Czy plan lub zmiany idą w dobrą stronę względem celu, plus usterki; zakres wybierany z kontekstu |
| `code-review` | Szczegółowy przegląd względem ustalonej bazy na dwóch osiach: standardy projektu i zgodność ze specyfikacją |

**Claude Code:** w tym repo `.claude/skills/ocen` to link do `.agents/skills/ocen`, więc skill jest widoczny po otwarciu repozytorium. W innym projekcie (po skopiowaniu katalogu lub użyciu repo jako submodule) utwórz link w projekcie albo globalnie:

```bash
# w projekcie, gdy skill leży w .agents/skills/ocen
mkdir -p .claude/skills && ln -s ../../.agents/skills/ocen .claude/skills/ocen

# globalnie, wskazując na własną kopię repozytorium
ln -s /ścieżka/do/agent-skills/.agents/skills/ocen ~/.claude/skills/ocen
```

Jeśli system nie obsługuje linków, skopiuj katalog i aktualizuj kopię po zmianach źródła. Dodaj też do `AGENTS.md` projektu regułę uruchamiania z sekcji „Polecenia własne” tego repozytorium.

## Materiały pomocnicze

| Dokument | Opis |
|----------|------|
| [`.conventional-commits/conventional-commits.md`](./.conventional-commits/conventional-commits.md) | Praktyczna ściągawka po Conventional Commits: format wiadomości, typy commitów, breaking changes, stopki i przykłady |

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


