# Conventional Commits – dobre praktyki

**Conventional Commits** to lekka konwencja pisania wiadomości commitów (specyfikacja 1.0.0). Nadaje historii strukturę, którą da się czytać maszynowo: z commitów można automatycznie generować changelog, wyznaczać kolejną wersję w SemVer i wyzwalać release'y.

## Format

```
<typ>[(zakres)][!]: <opis>

[treść / body]

[stopka / footer(s)]
```

Elementy:

- **typ**: wymagany, małymi literami.
- **zakres (scope)**: opcjonalny rzeczownik w nawiasie, określający część systemu, np. `(api)`, `(parser)`, `(deps)`.
- **`!`**: opcjonalny znacznik zmiany łamiącej kompatybilność.
- **opis**: wymagany, po dwukropku i spacji.
- **body**: opcjonalne, oddzielone pustą linią.
- **footer**: opcjonalny, oddzielony pustą linią, w formacie git trailerów (`Token: wartość` lub `Token #wartość`).

## Typy i kiedy ich używać

Sama specyfikacja definiuje tylko `feat` i `fix`. Pozostałe typy to de facto standard z konwencji Angulara (`@commitlint/config-conventional`):

| Typ | Kiedy | SemVer |
|---|---|---|
| `feat` | nowa funkcjonalność widoczna dla użytkownika lub API | MINOR |
| `fix` | naprawa błędu | PATCH |
| `perf` | poprawa wydajności bez zmiany zachowania | PATCH (zwykle) |
| `refactor` | zmiana kodu, która ani nie naprawia błędu, ani nie dodaje funkcji | – |
| `docs` | tylko dokumentacja (README, komentarze, docstringi) | – |
| `style` | formatowanie, białe znaki, średniki, bez wpływu na logikę | – |
| `test` | dodanie lub poprawa testów | – |
| `build` | system budowania, zależności (npm, Maven, Dockerfile) | – |
| `ci` | konfiguracja CI (GitHub Actions, GitLab CI) | – |
| `chore` | prace porządkowe, które nie pasują gdzie indziej (np. `.gitignore`) | – |
| `revert` | cofnięcie wcześniejszego commita | zależnie od cofanego |

Dowolny typ z `!` albo z `BREAKING CHANGE` w stopce daje **MAJOR**.

### Typowe dylematy

- **`fix` czy `refactor`?** Jeśli zmienia się zachowanie, które było błędne, to `fix`. Jeśli zachowanie jest identyczne, a zmienia się tylko struktura kodu, to `refactor`.
- **`refactor` czy `perf`?** Jeśli celem i efektem jest szybkość lub mniejsze zużycie pamięci, to `perf`.
- **`style` a CSS.** `style` oznacza styl kodu, nie wygląd aplikacji. Zmiana wyglądu przycisku to `feat` albo `fix`.
- **`build` czy `chore`?** Aktualizacja zależności i konfiguracji bundlera to `build` (często `build(deps):`). `chore` zostaw na drobne rzeczy bez wpływu na build.
- **`test` przy naprawie buga.** Jeśli naprawiasz bug i dodajesz test regresyjny, całość to jeden `fix`. `test` stosuj, gdy commit dotyczy wyłącznie testów.

## Opis (subject line)

- Pisz w **trybie rozkazującym**: `add`, `fix`, `remove`, a nie `added` czy `fixes`. Zdanie powinno pasować do wzoru „If applied, this commit will…”.
- Zaczynaj **małą literą** (tak domyślnie wymaga commitlint) i **bez kropki** na końcu.
- Trzymaj całą pierwszą linię w **~50–72 znakach**.
- Opisuj **co** się zmienia, a nie jak. Źle: `fix: change if condition`. Dobrze: `fix(cart): prevent negative item quantity`.
- Unikaj pustych opisów w rodzaju `fix: bug`, `chore: updates`, `feat: wip`.

## Body

- Tłumaczy **dlaczego** i jaki był kontekst, bo „co” widać w diffie.
- Łam linie na ~72 znakach.
- Może mieć wiele akapitów.
- Pomiń je, gdy opis w pełni wystarcza.

## Stopka (footer)

- Tokeny zapisuje się z myślnikami zamiast spacji: `Reviewed-by:`, `Co-authored-by:`, `Refs: #123`, `Closes #123`.
- Jedyny wyjątek to `BREAKING CHANGE:`, pisane wielkimi literami ze spacją. `BREAKING-CHANGE:` jest równoważnym synonimem.
- Breaking change można oznaczyć samym `!` (`feat(api)!: drop v1 endpoints`), samą stopką albo oboma. Stopka jest lepsza, bo pozwala opisać migrację.

## Revert

```
revert: feat(auth): add refresh token rotation

This reverts commit 1a2b3c4.
Refs: 1a2b3c4
```

## Dobre praktyki ogólne

1. **Jeden commit to jedna logiczna zmiana.** Jeśli commit pasuje do dwóch typów, np. `feat` i `refactor`, zwykle warto go podzielić (`git add -p` bardzo pomaga).
2. **Ustal w zespole listę typów i zakresów.** Zapisz ją w `CONTRIBUTING.md` i w konfiguracji commitlinta. Zakresy powinny odpowiadać modułom i pakietom, a nie nazwiskom czy ticketom.
3. **Przy squash-merge liczy się tytuł PR.** To on staje się commitem na głównej gałęzi, więc waliduj tytuły PR, np. akcją `amannn/action-semantic-pull-request`.
4. **Numer ticketu umieszczaj w stopce, nie w opisie.** Lepiej `Refs: PROJ-123` niż `feat: PROJ-123 add export`.
5. **Nie oznaczaj jako `feat` rzeczy wewnętrznych.** `feat` trafia do changeloga i podbija wersję, więc używaj go tylko dla zmian istotnych dla użytkowników lub konsumentów API.
6. **Bądź konsekwentny z językiem.** Najczęściej wszystko jest po angielsku, bo narzędzia i changelogi tego oczekują.

## Narzędzia

- **commitlint** z **husky** lub **lefthook**: walidacja wiadomości w hooku `commit-msg`.
- **commitizen** (`cz commit`): interaktywny kreator commitów.
- **semantic-release** i **release-please**: automatyczne wersjonowanie, tagi i release notes.
- **git-cliff** i **conventional-changelog**: generowanie `CHANGELOG.md`.

## Ściągawka przykładów

```
feat(search): add fuzzy matching for product names
fix(api): return 404 instead of 500 for missing user
perf(db): add index on orders.created_at
refactor(payments): extract Stripe client into adapter
docs: document local setup with Docker Compose
test(cart): cover discount stacking edge cases
build(deps): bump axios from 1.6.0 to 1.7.2
ci: cache pnpm store in GitHub Actions
chore: remove unused .editorconfig rules
feat(api)!: require API key for all endpoints
```
