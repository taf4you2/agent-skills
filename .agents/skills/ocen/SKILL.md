---
name: ocen
description: Oceń plan lub zmiany w projekcie — czy kierunek odpowiada celowi oraz czy rozwiązanie nie zawiera błędów, regresji, podatności i nieobsłużonych przypadków brzegowych. Przedmiot oceny ustal z kontekstu i stanu Git. Użyj na polecenie „oceń”, „ocen”, „oceń plan”, „oceń zmiany” lub „oceń względem main”.
---

Odpowiedz na dwa pytania: czy rozwiązujemy właściwy problem oraz czy
plan lub implementacja robi to poprawnie.

## Granice działania

- Domyślnie korzystaj wyłącznie z odczytu. Nie modyfikuj plików,
  indeksu ani historii Git; nie wykonuj stagingu, commitów, `git fetch`
  ani automatycznych poprawek.
- „Oceń” oznacza ocenę i rekomendacje, a nie zgodę na wprowadzanie zmian.
- Testy, lintery i buildy uruchamiaj tylko na wyraźną prośbę
  (sekcja „Sprawdzenia”).

## Ustal przedmiot i zakres

Zastosuj pierwszą pasującą regułę:

1. Użytkownik lub kontekst jednoznacznie wskazuje przedmiot albo zakres
   („oceń plan”, plik, commit, PR, „względem X”) — oceń go; resztę
   kontekstu traktuj pomocniczo. Przy ocenie planu istniejące zmiany
   w kodzie są kontekstem, a nie zamiennikiem oceny planu.
2. Gałąź ma własne commity względem bazy — oceń całość pracy: zmiany
   od wspólnego przodka razem z lokalnymi zmianami i nowymi plikami.
3. Są lokalne zmiany — oceń staged, unstaged i nowe nieśledzone pliki
   względem `HEAD`.
4. Brak zmian — oceń plan lub rozwiązanie omawiane w rozmowie albo
   odnaleziony plan.
5. Brak jednoznacznego przedmiotu lub kilku równorzędnych kandydatów —
   zadaj jedno krótkie pytanie zamiast wybierać przypadkowy zakres.

Jeśli wybrany zakres okaże się pusty, zaznacz to i przejdź do kolejnej
reguły. Dostępny plan jest punktem odniesienia dla zmian niezależnie od
tego, jak wybrano zakres.

**Baza:** lokalna gałąź `main`. Jeśli jej nie ma, użyj gałęzi bazowej
z instrukcji projektu lub lokalnego `origin/HEAD`
(`git symbolic-ref refs/remotes/origin/HEAD`). Gdy nie da się ustalić
wiarygodnej bazy, zapytaj o nią. Gałąź ma własne commity, gdy
`git rev-list --count <baza>..HEAD` jest większe od zera.

**Plan:** jawnie wskazany plik ma pierwszeństwo. W dalszej kolejności
plik otwarty w IDE (jeśli jego ścieżka lub treść jest w kontekście),
pasujące pliki `docs/plans/*` oraz plan dodany lub zmieniony
w ostatnim commicie. Nie zakładaj dostępu do stanu IDE.

**Cel:** ustal z rozmowy, instrukcji projektu, planu lub opisu zadania.
Oddziel wymagania potwierdzone od założeń. Brak specyfikacji nie blokuje
oceny technicznej; zaznacz wtedy ograniczenie oceny zgodności z celem.

## Zbierz zmiany

1. Uruchom `git status --short` w katalogu głównym repozytorium.
   Zaznacz konflikty scalania.
2. Sprawdź `git rev-parse --verify HEAD`. Jeśli `HEAD` nie istnieje,
   wyjaśnij brak bazy i oceń nowe pliki bez twierdzenia, że wykonano
   porównanie.
3. Zakres gałęzi: ustal `git merge-base <baza> HEAD`, a następnie
   `git diff --stat <merge-base>` i `git diff --find-renames <merge-base>`.
   Część niezacommitowaną wskaż przez `git diff --stat HEAD`.
   Zakres lokalny: `git diff --stat HEAD` i `git diff --find-renames HEAD`.
4. Nowe pliki znajdź przez `git ls-files --others --exclude-standard`
   i przeczytaj je. Pusty diff nie oznacza braku nowych plików.
5. Przeczytaj kontekst zmienionego kodu oraz istotne miejsca wywołań.
6. Przy dużym diffie zacznij od zmian o najwyższym ryzyku: autoryzacja,
   uprawnienia, dane, konfiguracja, granice zaufania. W lockfile'ach
   i plikach generowanych pomiń pełną analizę powtarzalnej treści,
   ale sprawdź zmiany wersji, źródeł i integralności zależności względem
   manifestu oraz istotne zmiany zachowania.

## Oceń

- **Kierunek:** zgodność z celem i planem (brakujące wymagania,
  odstępstwa, nieuzasadnione rozszerzenie zakresu), kompletność,
  uzasadnienie podejścia, zbędna złożoność, pominięte zależności.
- **Poprawność:** błędy, regresje, obsługa awarii, wpływ na dane,
  przypadki brzegowe (null, zero, puste dane, wartości graniczne
  i domyślne), brakujące sprawdzenia.
- **Bezpieczeństwo:** podatności z konkretnym scenariuszem ataku,
  usunięte lub osłabione zabezpieczenia, konfiguracje łatwe do błędnego
  użycia, sekrety w diffie, nowe zależności i ich źródła, uprawnienia,
  konfiguracja CI. Nie powielaj wartości wykrytych sekretów.
- **Gotowość, gdy ma zastosowanie:** kompatybilność kontraktów API,
  migracje, utrata danych, wycofanie zmiany, timeouty, ponowienia,
  duplikaty operacji, częściowy sukces, wyścigi.
- **Plan:** wykonalność, kolejność kroków, założenia, sposób
  potwierdzenia sukcesu.

Zasady:

- Komentarz lub dokumentacja opisująca problem nie oznacza jego obsługi;
  liczy się rzeczywiste zachowanie planu lub kodu.
- Odróżniaj błąd planu od błędu jego realizacji.
- Przed zgłoszeniem zweryfikuj każde ustalenie w kodzie i usuń
  duplikaty. Niepotwierdzone ustalenie oznacz jako hipotezę i podaj
  brakujące dane.
- Brak testów wiąż z konkretnym niezweryfikowanym scenariuszem,
  a nie z ogólnym „dodaj testy”.
- Głębokość analizy dopasuj do ryzyka zmian.

## Sprawdzenia

Domyślnie nie uruchamiaj testów, linterów ani buildów. Zaproponuj
potrzebne polecenia i oznacz je jako niewykonane.

Na wyraźną prośbę uruchom je w bieżącym katalogu roboczym:

- Przed uruchomieniem i po nim zapisz `git status --porcelain --ignored`.
  Wymień pliki utworzone lub zmienione przez sprawdzenia; nie usuwaj
  ich, zaproponuj sposób posprzątania.
- Nie używaj automatycznego naprawiania lintera ani formatowania
  w trybie zapisu.
- Zaznacz, że ponowna modyfikacja pliku zmienionego już przed
  uruchomieniem nie jest widoczna w statusie Git.

## Raport

1. Zacznij zdaniem „Oceniam X względem celu Y; zakres obejmuje Z”.
   Przy porównaniu z gałęzią podaj użyte odwołanie, SHA bazy i SHA
   wspólnego przodka.
2. Podaj werdykt: „dobry kierunek”, „wymaga korekt”, „wymaga zmiany
   podejścia” albo „brak danych do oceny”, z krótkim uzasadnieniem.
3. Wymień problemy według istotności. Dla każdego podaj osobno wagę
   i pewność, miejsce (plik i linia lub punkt planu), warunki
   wystąpienia, skutek, dowód lub oznaczenie hipotezy oraz kierunek
   poprawki. Przy zakresie gałęzi zaznacz, czy problem dotyczy części
   niezacommitowanej.
4. Sugestie ulepszeń pokaż osobno od usterek.
5. Podaj wykonane sprawdzenia, informację, czy uruchomiono testy,
   oraz ograniczenia przeglądu, np. pominięte pliki binarne lub
   nieczytelne. Nie przedstawiaj częściowego przeglądu jako pełnego.

Jeśli w sprawdzonym zakresie nie ma problemów, powiedz to wprost.
