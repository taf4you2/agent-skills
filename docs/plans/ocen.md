# Plan implementacji skilla `ocen`

Status: propozycja do przeglądu i bieżących zmian. Skill nie jest jeszcze zaimplementowany.

## Cel

Skill uruchamiany poleceniem „oceń” lub „ocen” ustala przedmiot oceny
z rozmowy i stanu projektu. Ocenia zarówno kierunek rozwiązania względem
celu, jak i poprawność planu lub implementacji: błędy, regresje, potencjalne
podatności oraz pominięte przypadki brzegowe.

Odpowiada na dwa pytania:

- Czy rozwiązujemy właściwy problem?
- Czy proponowane lub wdrożone rozwiązanie robi to poprawnie?

## Wybór przedmiotu oceny

| Sytuacja | Działanie |
| --- | --- |
| Użytkownik wskazuje przedmiot, np. „oceń plan” | Ocenia wskazany przedmiot; pozostały kontekst służy jako pomoc. |
| Samo „oceń”, są lokalne zmiany | Ocenia staged, unstaged i nowe nieśledzone pliki. Cel ustala z rozmowy i dokumentacji. |
| Są zmiany oraz odpowiadający im plan | Ocenia zmiany i ich zgodność z planem; wskazuje również problemy samego planu. |
| Brak lokalnych zmian, ostatnio omawiano plan lub rozwiązanie | Ocenia ten plan albo rozwiązanie. |
| Kontekst wskazuje branch, commit lub PR | Ocenia wskazany zakres, podając bazę porównania. |
| Brak jednoznacznego przedmiotu | Zadaje jedno krótkie pytanie zamiast wybierać przypadkowy zakres. |

Jednoznacznie wskazany przedmiot lub zakres ma pierwszeństwo przed
domyślnym przeglądem lokalnych zmian. Gdy przedmiotem jest plan,
istniejące zmiany w kodzie mogą być kontekstem, ale nie zastępują oceny planu.

Raport zaczyna się zdaniem określającym przyjęty przedmiot, cel i zakres,
np. „Oceniam X względem celu Y; zakres obejmuje Z”.

## Inspiracje i ponowne wykorzystanie

Podstawą obsługi lokalnych zmian jest istniejący
[`diff-review`](../../.agents/skills/diff-review/SKILL.md).
Przejęte zostaną zasady zbierania zmian oraz raportowania problemów.
`ocen` pozostanie samodzielny, aby można było kopiować go do innych
projektów bez obowiązkowej instalacji drugiego skilla.

| Źródło | Elementy do wykorzystania |
| --- | --- |
| [Superpowers: szablon recenzenta](https://github.com/obra/superpowers/blob/main/skills/requesting-code-review/code-reviewer.md) | Porównanie implementacji z wymaganiami, rozróżnienie błędu planu od błędu wykonania, kompatybilność, migracje i konkretny werdykt. |
| [Trail of Bits: differential-review](https://github.com/trailofbits/skills/blob/main/plugins/differential-review/skills/differential-review/SKILL.md) | Priorytet dla zmian o wysokim ryzyku, analiza wywołującego kodu, historia usuniętych zabezpieczeń, konkretne scenariusze ataku oraz jawne ograniczenia przeglądu. |
| [Trail of Bits: sharp-edges](https://github.com/trailofbits/skills/blob/main/plugins/sharp-edges/skills/sharp-edges/SKILL.md) | Niebezpieczne wartości domyślne, konfiguracje łatwe do błędnego użycia, zachowanie dla null, zera i pustych danych oraz błędy omijające zabezpieczenia. |
| [Anthropic: workflow code-review](https://github.com/anthropics/claude-code/blob/main/plugins/code-review/commands/code-review.md) | Weryfikacja ustaleń przed raportowaniem, ograniczanie fałszywych alarmów i usuwanie duplikatów. |

Źródła są inspiracją do własnych instrukcji. Nie wymagają instalowania
zewnętrznych pakietów ani przejęcia całych workflowów. Filtr Anthropic
pomijający problemy zależne od konkretnych danych wejściowych nie zostanie
przejęty, ponieważ ograniczałby ocenę przypadków brzegowych.

## Etapy implementacji

### 1. Utworzenie definicji

- [ ] Utworzyć `.agents/skills/ocen/SKILL.md` z wymaganym frontmatter:
  `name: ocen` i opisem zastosowania.
- [ ] Opisać uruchamianie przez „oceń”, „ocen” oraz doprecyzowania,
  np. „oceń plan”, „oceń zmiany”, „oceń względem main”.
- [ ] Zapisać reguły wyboru przedmiotu i zakresu oceny.
- [ ] Zacząć od jednego samodzielnego pliku, bez dodatkowych skryptów.

### 2. Ustalanie celu

- [ ] Czytać odpowiedni kontekst rozmowy, instrukcje projektu i wskazane
  wymagania lub plan.
- [ ] Oddzielać wymagania potwierdzone od założeń.
- [ ] Nie blokować przeglądu technicznego z powodu braku specyfikacji;
  wskazywać ograniczenia oceny zgodności z celem.

### 3. Zbieranie zmian

- [ ] Oprzeć procedurę na `diff-review`: status Git, baza `HEAD`, diff,
  nowe nieśledzone pliki, usunięcia i zmiany nazw.
- [ ] Uwzględniać zmiany staged i unstaged; pusty diff śledzonych plików
  nie oznacza braku nowych plików.
- [ ] Obsłużyć konflikty scalania, brak pierwszego commita oraz elementy
  nieczytelne lub niedostępne do analizy.
- [ ] Dla zakresu wskazanego przez użytkownika ustalić i podać właściwą
  bazę porównania.
- [ ] Czytać istotny kontekst i miejsca wywołania zmienionego kodu.

### 4. Ocena kierunku i poprawności

- [ ] Ocenić kierunek: zgodność z celem, kompletność, uzasadnienie
  podejścia, zbędną złożoność, pominięte zależności i wyjście poza zakres.
- [ ] Ocenić poprawność: błędy, regresje, podatności, przypadki brzegowe,
  obsługę awarii, wpływ na dane i brakujące sprawdzenia.
- [ ] Dla planu sprawdzić wykonalność, kolejność kroków, założenia
  i sposób potwierdzenia sukcesu.
- [ ] Dla implementacji sprawdzić rzeczywiste zachowanie kodu i zgodność
  z wymaganiami; odróżniać problem planu od problemu jego realizacji.
- [ ] Dostosować głębokość analizy do ryzyka zmian i ujawnić ograniczenia
  zakresu przeglądu.

### 5. Raport oparty na dowodach

- [ ] Zacząć od określenia przedmiotu, celu i zakresu oraz krótkiego
  werdyktu: „dobry kierunek”, „wymaga korekt”, „wymaga zmiany podejścia”
  albo „brak danych do oceny”.
- [ ] Uporządkować problemy według istotności.
- [ ] Dla każdego problemu podać miejsce w kodzie lub punkt planu,
  warunki wystąpienia, skutek, dowód lub oznaczenie hipotezy oraz zalecany
  kierunek poprawki.
- [ ] Pokazywać sugestie ulepszeń osobno od usterek.
- [ ] Podawać wykonane sprawdzenia, w tym informację, czy uruchomiono
  testy, oraz ograniczenia oceny.
- [ ] Gdy nie znaleziono problemów, powiedzieć to wprost w odniesieniu
  do sprawdzonego zakresu.

### 6. Uruchamianie i dokumentacja

- [ ] Uzupełnić `AGENTS.md` o wpis w indeksie i regułę dla „oceń”/„ocen”,
  także z doprecyzowaniem „plan” lub „zmiany”.
- [ ] Uzupełnić `README.md` o opis oraz przykłady użycia.

### 7. Weryfikacja

- [ ] Uruchomić walidator skilla `quick_validate.py` z pakietu
  `skill-creator`.
- [ ] Sprawdzić zachowanie na scenariuszach z następnej sekcji.
- [ ] Sprawdzić, czy przegląd pozostawia pliki projektu, indeks
  i historię Git bez zmian.

## Scenariusze akceptacyjne

| Scenariusz | Oczekiwany wynik |
| --- | --- |
| „Oceń plan”, dostępny plan, istnieją również zmiany w kodzie | Plan pozostaje przedmiotem oceny; zmiany mogą dostarczyć kontekstu. |
| „Oceń”, zmiany staged i unstaged oraz nowe pliki | Wszystkie lokalne zmiany wchodzą do zakresu. |
| „Oceń”, wyłącznie nowe nieśledzone pliki | Nowe pliki zostają ocenione mimo pustego diffu śledzonych plików. |
| „Oceń”, czysty Git i plan w rozmowie | Oceniony zostaje plan z rozmowy. |
| Repozytorium bez pierwszego commita | Agent wyjaśnia brak bazy i ocenia dostępne nowe pliki, bez twierdzenia, że wykonał porównanie z HEAD. |
| Brak zmian i niejednoznaczny kontekst | Agent zadaje jedno pytanie o przedmiot oceny. |
| „Oceń względem main” | Raport podaje zakres i bazę porównania z main. |
| Poprawnie napisany kod realizuje inne zachowanie niż plan | Raport wskazuje rozbieżność z celem. |
| Edge case opisany w komentarzu, ale nieobsłużony w kodzie | Raport wskazuje brak obsługi; komentarz nie zamyka problemu. |
| Potencjalna podatność bez wystarczającego dowodu | Raport oznacza hipotezę i brakujące dane, zamiast przedstawiać ją jako potwierdzony błąd. |
| Ograniczony przegląd albo brak uruchomionych testów | Raport ujawnia ograniczenia i wykonane sprawdzenia. |

## Dodatkowe zasady oceny

- Udokumentowanie problemu nie oznacza jego obsłużenia: liczy się
  rzeczywiste zachowanie planu lub implementacji.
- Gdy mają zastosowanie, sprawdzać kompatybilność kontraktów API,
  migracje, możliwość utraty danych i wycofania zmiany.
- Gdy dotyczą rozwiązania, analizować timeouty, ponowienia, duplikaty
  operacji, częściowy sukces i wyścigi.
- Braki testów wiązać z konkretnym niezweryfikowanym scenariuszem,
  zamiast ogólnego zalecenia „dodaj testy”.
- Rozdzielać wagę problemu od pewności ustalenia.
- Polecenie „oceń” tworzy ocenę i rekomendacje; nie uruchamia
  automatycznych poprawek, stagingu ani commitów.

## Docelowy zakres plików

- Nowy `.agents/skills/ocen/SKILL.md`.
- Aktualizacja indeksu i reguł w `AGENTS.md`.
- Aktualizacja opisu i przykładów w `README.md`.

Ten dokument jest planem. Powyższe zmiany będą realizowane dopiero
w ramach implementacji skilla.
