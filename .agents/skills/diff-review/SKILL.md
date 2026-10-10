---
name: diff-review
description: Porównaj niezacommitowane zmiany z HEAD, opisz dodane, zmienione i usunięte elementy oraz oceń błędy, ryzyka i przypadki brzegowe. Użyj na polecenie „diff” lub „zrób diff”.
---

Porównaj bieżący stan plików roboczych z ostatnim commitem
bieżącej gałęzi (`HEAD`).

## Zakres

- Uwzględnij zmiany staged, unstaged oraz nowe nieśledzone pliki.
- Domyślnie obejmij wszystkie lokalne zmiany. Git nie pozwala
  wiarygodnie ustalić autorstwa niezacommitowanych modyfikacji.
- Wykonaj przegląd bez modyfikowania plików, indeksu i historii Git.

## Przebieg

1. Sprawdź instrukcje projektu i `git status --short` w katalogu
   głównym repozytorium. Zaznacz ewentualne konflikty scalania.
2. Ustal commit bazowy przez `git rev-parse --verify HEAD`.
   Jeśli `HEAD` nie istnieje, wyjaśnij brak commitu do porównania.
3. Zbierz zestawienie i różnice:
   - `git diff --stat HEAD`
   - `git diff --find-renames HEAD`
4. Wyszukaj nowe pliki przez `git ls-files --others --exclude-standard`.
   Przeczytaj ich zawartość i traktuj je jako dodatki.
   Pusty diff śledzonych plików nie oznacza braku nowych plików.
5. Przeczytaj kontekst zmienionego kodu oraz istotnych wywołań.
6. Oceń konkretne błędy, regresje, bezpieczeństwo i przypadki
   brzegowe wynikające ze zmian. Oddziel ustalenia od hipotez.

## Raport

- Podaj commit bazowy i zakres przeglądu.
- Zestaw dodane, zmienione i usunięte elementy według plików;
  zaznacz wykryte zmiany nazw.
- Dla problemów podaj wagę, plik i linię, scenariusz wystąpienia
  oraz proponowaną poprawkę.
- Jeśli nie wykryto problemów lub zmian, powiedz to wprost.
- Wskaż pominięte lub nieczytelne elementy, np. pliki binarne;
  nie przedstawiaj częściowego przeglądu jako pełnego.
- Podaj wykonane sprawdzenia; jeśli testów nie uruchomiono,
  zaznacz to.
