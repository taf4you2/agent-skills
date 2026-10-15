# Skille dostępne w tym repozytorium

Ten plik jest indeksem, nie zlepkiem treści — każdy skill ma swoją pełną definicję w osobnym pliku.

- **caveman** — ultra-skompresowana komunikacja, mniej tokenów przy tej samej precyzji technicznej → [`.agents/skills/caveman/SKILL.md`](./.agents/skills/caveman/SKILL.md)
- **ponytail** — tryb "leniwego seniora": YAGNI, minimalny kod, reużywanie zamiast pisania od nowa → [`.agents/skills/ponytail/SKILL.md`](./.agents/skills/ponytail/SKILL.md)
- **grug** — praktyczne porady programistyczne w stylu Grug Brained Developer: prostota i ograniczanie złożoności → [`.agents/skills/grug/SKILL.md`](./.agents/skills/grug/SKILL.md)
- **diff-review** — porównanie niezacommitowanych zmian z `HEAD` oraz ocena błędów, ryzyk i przypadków brzegowych → [`.agents/skills/diff-review/SKILL.md`](./.agents/skills/diff-review/SKILL.md)
- **conventionals** — przygotowanie wiadomości według Conventional Commits bez wykonywania commita → [`.agents/skills/conventionals/SKILL.md`](./.agents/skills/conventionals/SKILL.md)
- **ocen** — ocena planu lub zmian: kierunek względem celu oraz błędy, podatności i pominięte przypadki brzegowe; zakres ustalany z kontekstu i Git → [`.agents/skills/ocen/SKILL.md`](./.agents/skills/ocen/SKILL.md)

### Z pstack (cursor/plugins)

- **tdd** — najpierw test, który pada, potem poprawka; tylko przy tanim, lokalnym teście → [`.agents/skills/tdd/SKILL.md`](./.agents/skills/tdd/SKILL.md)
- **blast-radius** — co zmiana może zepsuć poza diffem, z dowodem z uruchomionego kodu → [`.agents/skills/blast-radius/SKILL.md`](./.agents/skills/blast-radius/SKILL.md)
- **technical-writing** — standard pisania dokumentacji, RFC, README, opisów PR i commitów → [`.agents/skills/technical-writing/SKILL.md`](./.agents/skills/technical-writing/SKILL.md)
- **unslop** — usuwanie śladów tekstu pisanego przez AI → [`.agents/skills/unslop/SKILL.md`](./.agents/skills/unslop/SKILL.md)
- **in-your-own-words** — agent opisuje własnymi słowami cel i problem użytkownika przed startem → [`.agents/skills/in-your-own-words/SKILL.md`](./.agents/skills/in-your-own-words/SKILL.md)
- **sharpen** — doprecyzowanie zadania: podejście eksperta i to, o co naprawdę chodzi → [`.agents/skills/sharpen/SKILL.md`](./.agents/skills/sharpen/SKILL.md)
- **benchmark-checklist** — weryfikacja pomiaru wydajności przed raportem → [`.agents/skills/benchmark-checklist/SKILL.md`](./.agents/skills/benchmark-checklist/SKILL.md)
- **correct** — zamiana powtarzanych błędów agentów w architekturę, typy, lint lub testy → [`.agents/skills/correct/SKILL.md`](./.agents/skills/correct/SKILL.md)
- **typescript-best-practices** — dobre praktyki przy czytaniu i edycji plików `.ts`/`.tsx` → [`.agents/skills/typescript-best-practices/SKILL.md`](./.agents/skills/typescript-best-practices/SKILL.md)
- **principle-test-behavior-not-implementation** — testy sprawdzają zachowanie widoczne dla użytkownika, nie wnętrze kodu → [`.agents/skills/principle-test-behavior-not-implementation/SKILL.md`](./.agents/skills/principle-test-behavior-not-implementation/SKILL.md)
- **principle-foundational-thinking** — najpierw struktury danych i typy, potem logika → [`.agents/skills/principle-foundational-thinking/SKILL.md`](./.agents/skills/principle-foundational-thinking/SKILL.md)
- **principle-model-the-domain** — modelowanie domeny przy logice ze stanem i wielu rozgałęzieniach → [`.agents/skills/principle-model-the-domain/SKILL.md`](./.agents/skills/principle-model-the-domain/SKILL.md)
- **principle-type-system-discipline** — niepoprawne stany niemożliwe do zapisania, parsowanie danych na granicy → [`.agents/skills/principle-type-system-discipline/SKILL.md`](./.agents/skills/principle-type-system-discipline/SKILL.md)
- **principle-boundary-discipline** — walidacja tylko na brzegach systemu, w środku zaufanie do typów → [`.agents/skills/principle-boundary-discipline/SKILL.md`](./.agents/skills/principle-boundary-discipline/SKILL.md)
- **principle-explain-the-number** — co ogranicza zmierzoną liczbę i czy mierzy właściwą rzecz → [`.agents/skills/principle-explain-the-number/SKILL.md`](./.agents/skills/principle-explain-the-number/SKILL.md)
- **principle-encode-lessons-in-structure** — powtarzaną regułę zapisz jako lint, flagę lub skrypt, nie jako kolejny tekst → [`.agents/skills/principle-encode-lessons-in-structure/SKILL.md`](./.agents/skills/principle-encode-lessons-in-structure/SKILL.md)
- **principle-migrate-callers-then-delete-legacy-apis** — przenieś wywołania i usuń stare API w jednym kroku, bez warstw kompatybilności → [`.agents/skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md`](./.agents/skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md)
- **principle-sequence-verifiable-units** — praca w małych krokach, z których każdy kończy się sprawdzalnym stanem → [`.agents/skills/principle-sequence-verifiable-units/SKILL.md`](./.agents/skills/principle-sequence-verifiable-units/SKILL.md)
- **principle-make-operations-idempotent** — operacje dają ten sam stan końcowy mimo awarii i ponownych uruchomień → [`.agents/skills/principle-make-operations-idempotent/SKILL.md`](./.agents/skills/principle-make-operations-idempotent/SKILL.md)

Narzędzia wspierające zagnieżdżone `AGENTS.md` (np. Antigravity) mogą ładować pliki skilli bezpośrednio z `.agents/skills/`.

## Polecenia własne

Gdy użytkownik wydaje polecenie „/grug”, „/grugmode” lub „grug mode”,
przeczytaj `.agents/skills/grug/SKILL.md` i zastosuj opisany tam tryb.
Tryb trwa do wyraźnego zakończenia, np. „stop grug” lub „normal mode”.

Gdy użytkownik wydaje polecenie „diff” lub „zrób diff”, przeczytaj
`.agents/skills/diff-review/SKILL.md` i wykonaj opisany tam przegląd.

Gdy użytkownik wydaje polecenie „conventionals” lub prosi o treść
wiadomości commita według Conventional Commits, przeczytaj
`.agents/skills/conventionals/SKILL.md` i przygotuj sam tekst wiadomości.
Nie wykonuj commita.

Gdy użytkownik wydaje polecenie „oceń” lub „ocen”, także
z doprecyzowaniem, np. „oceń plan”, „oceń zmiany” lub „oceń względem
main”, przeczytaj `.agents/skills/ocen/SKILL.md` i wykonaj opisaną tam
ocenę. Nie wprowadzaj poprawek bez osobnej prośby.
