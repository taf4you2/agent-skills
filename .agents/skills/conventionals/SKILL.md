---
name: conventionals
description: Przygotuj treść wiadomości commita według Conventional Commits bez wykonywania commita. Użyj na polecenie „conventionals” lub prośbę o tekst, opis albo wiadomość do commita według tej konwencji.
---

Napisz gotową do skopiowania wiadomość commita według Conventional
Commits. Wynikiem jest tekst w rozmowie, bez wykonywania commita.

## Granice działania

- Korzystaj wyłącznie z odczytu. Nie modyfikuj plików, indeksu ani
  historii Git; nie wykonuj `git add`, `git commit`, amend ani push.
- Prośba o treść wiadomości nie jest zgodą na wykonanie commita.

## Ustal zakres

1. Jeśli użytkownik wskazał zakres, podał diff lub opis zmian,
   przygotuj wiadomość dla tych zmian.
2. W przeciwnym razie sprawdź `git status --short` oraz
   `git diff --cached`. Jeśli są zmiany staged, oprzyj wiadomość
   wyłącznie na nich; nie włączaj zmian unstaged z tych samych plików.
3. Jeśli nie ma zmian staged, sprawdź `git diff` oraz nowe pliki
   z `git ls-files --others --exclude-standard`. Przeczytaj ich
   zawartość i zaznacz, że propozycja dotyczy zmian roboczych.
4. Przeczytaj potrzebny kontekst. Jeśli nie ma zmian ani opisu,
   poinformuj o tym zamiast wymyślać wiadomość. Przy nierozwiązanych
   konfliktach wyjaśnij, że końcowy zakres zmian jest nieustalony.

## Zasady wiadomości

- Uwzględnij instrukcje projektu, konfigurację commitlint i istniejący
  styl wiadomości. Jeśli projekt zawiera
  `.conventional-commits/conventional-commits.md`, przeczytaj go.
- Format nagłówka: `type(scope)!: description`.
  `scope` i `!` są opcjonalne; po dwukropku umieść spację.
- Dobierz typ do rzeczywistego efektu: `feat` dla nowej funkcjonalności,
  `fix` dla naprawy błędu, `docs` dla samej dokumentacji, `refactor`
  dla przebudowy bez zmiany zachowania. W razie potrzeby użyj `perf`,
  `test`, `build`, `ci`, `style`, `chore` lub `revert`.
- Zakres ma wskazywać moduł lub część projektu; pomiń go, jeśli
  nie wnosi informacji.
- Opis pisz w trybie rozkazującym, zaczynając małą literą,
  bez kropki na końcu. Celuj w nagłówek do 72 znaków.
- Zachowaj język wskazany przez użytkownika; w pozostałych przypadkach
  dopasuj język do historii repozytorium, a przy braku wzorca użyj
  angielskiego.
- Dodaj body tylko gdy pomaga wyjaśnić powód lub istotny kontekst;
  oddziel je pustą linią i łam linie około 72 znaków.
- Przy rzeczywistej zmianie łamiącej kompatybilność użyj `!` lub
  stopki `BREAKING CHANGE:` opisującej zmianę i potrzebną migrację.
- Dodawaj numery zadań, autorów i informacje o testach tylko gdy
  wynikają z dostępnych danych; nie wymyślaj stopek ani wyników testów.

## Wynik

Zwróć jedną proponowaną wiadomość w bloku `text`, bez komendy powłoki.
Gdy zmiany obejmują niezależne zadania, zaproponuj osobne wiadomości
i krótko wyjaśnij podział, bez stagingu ani wykonywania commitów.
