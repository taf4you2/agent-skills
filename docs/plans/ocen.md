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

## Pochodzenie wymagań i propozycji

Pierwotny opis obejmuje wyzwalacz „oceń”, wybór przedmiotu z kontekstu,
ocenę kierunku zmian, podatności i nieobsłużonych przypadków brzegowych,
wykorzystanie `diff-review` oraz inspiracje z internetu.

Po przeglądzie plan doprecyzowuje ocenę commitów przy czystym Git,
podział odpowiedzialności między skillami, dostępność w Claude Code
oraz zasady uruchamiania testów i linterów.

Rozszerzenia spoza pierwotnego opisu oznaczono jako **[P1]–[P9]**
w sekcji „Propozycje dodatkowe”. Pozostają częścią propozycji planu;
identyfikatory pozwalają wskazać, które zachować, zmienić lub usunąć.

## Wybór przedmiotu oceny

Stosować poniższą kolejność: jednoznacznie wskazany przedmiot lub zakres,
lokalne zmiany, zmiany na gałęzi względem bazy, a następnie plan lub
rozwiązanie z kontekstu. Dostępny plan może być punktem odniesienia
dla zmian, niezależnie od tego, jak wybrano zakres.

| Sytuacja | Działanie |
| --- | --- |
| Użytkownik wskazuje przedmiot, np. „oceń plan” | Ocenia wskazany przedmiot; pozostały kontekst służy jako pomoc. |
| Kontekst jednoznacznie wskazuje branch, commit lub PR | Ocenia wskazany zakres, podając bazę porównania. |
| Samo „oceń”, są lokalne zmiany | Ocenia staged, unstaged i nowe nieśledzone pliki. Cel ustala z rozmowy i dokumentacji. |
| Samo „oceń”, czysty Git, gałąź ma własne commity względem main | Ocenia `main...HEAD`, czyli zmiany od wspólnego przodka main i HEAD, oraz podaje bazę porównania. |
| Są zmiany oraz odpowiadający im plan | Ocenia zmiany i ich zgodność z planem; wskazuje również problemy samego planu. |
| Brak lokalnych zmian i zmian gałęzi, dostępny plan lub ostatnio omawiane rozwiązanie | Ocenia ten plan albo rozwiązanie. |
| Brak jednoznacznego przedmiotu | Zadaje jedno krótkie pytanie zamiast wybierać przypadkowy zakres. |

Jednoznacznie wskazany przedmiot lub zakres ma pierwszeństwo przed
domyślnym przeglądem lokalnych zmian. Gdy przedmiotem jest plan,
istniejące zmiany w kodzie mogą być kontekstem, ale nie zastępują oceny planu.

Domyślna baza to lokalnie dostępna gałąź `main`. Jeśli jej nie ma,
ustalić gałąź bazową z instrukcji projektu lub dostępnego lokalnie
odwołania do domyślnej gałęzi zdalnej, np. `origin/HEAD`. Nie wykonywać
automatycznego fetch. Gdy nie da się ustalić wiarygodnej bazy, zapytać
o nią. W raporcie zapisać użyte odwołanie, SHA bazy i SHA wspólnego
przodka. Jeśli własne commity nie dają zmian w diffie, zaznaczyć to
i przejść do dostępnego planu lub rozwiązania z kontekstu.

Raport zaczyna się zdaniem określającym przyjęty przedmiot, cel i zakres,
np. „Oceniam X względem celu Y; zakres obejmuje Z”.

## Podział odpowiedzialności między skillami

| Skill | Główne zastosowanie |
| --- | --- |
| `diff-review` / „diff” | Opis tego, co zmieniło się lokalnie względem HEAD, oraz wskazanie usterek. |
| `ocen` / „oceń” | Werdykt o kierunku planu lub zmian względem celu oraz wskazanie usterek; zakres wybierany z kontekstu i Git. |
| `code-review` | Szczegółowy przegląd zmian względem ustalonej bazy na dwóch osobnych osiach: standardy projektu i zgodność ze specyfikacją. |

`ocen` korzysta z pomysłów istniejących skilli, lecz nie uruchamia
automatycznie obu dodatkowych przeglądów. Wyraźne polecenie użytkownika
decyduje o wyborze skilla; sam fakt wskazania gałęzi nie powinien
zastępować polecenia „oceń” uruchomieniem `code-review`.
Ten podział zostanie opisany również w README, bez zmiany zachowania
istniejących skilli.

## Inspiracje i ponowne wykorzystanie

Podstawą obsługi lokalnych zmian jest istniejący
[`diff-review`](../../.agents/skills/diff-review/SKILL.md).
Przejęte zostaną zasady zbierania zmian oraz raportowania problemów.
`ocen` pozostanie samodzielny, aby można było kopiować go do innych
projektów bez obowiązkowej instalacji drugiego skilla.

| Źródło | Elementy do wykorzystania |
| --- | --- |
| [Lokalny code-review](../../.agents/skills/code-review/SKILL.md) | Oddzielne rozpatrywanie standardów projektu i zgodności ze specyfikacją, identyfikowanie brakujących wymagań oraz nieuzasadnionego rozszerzenia zakresu. |
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
- [ ] Doprecyzować granice względem `diff-review` i `code-review`.
- [ ] Zacząć od jednego samodzielnego pliku, bez dodatkowych skryptów.

### 2. Ustalanie celu

- [ ] Czytać odpowiedni kontekst rozmowy, instrukcje projektu i wskazane
  wymagania lub plan.
- [ ] Dla „oceń plan” uwzględnić również plik otwarty w IDE, jeśli agent
  otrzymuje jego ścieżkę lub zawartość, pasujące pliki `docs/plans/*`
  oraz plan dodany lub zmieniony w ostatnim commicie [P7]. Jawnie
  wskazany plik ma pierwszeństwo. Przy kilku równorzędnych kandydatach
  zapytać o wybór; nie zakładać dostępu do stanu IDE.
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
- [ ] Przy czystym Git uwzględnić commity gałęzi względem `main`
  i porównanie od wspólnego przodka; obsłużyć brak dostępnej bazy.
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
- [ ] Uwzględnić sekrety w diffie, nowe zależności i ich źródła,
  zmiany uprawnień oraz konfiguracji CI [P8].
- [ ] Dostosować głębokość analizy do ryzyka zmian i ujawnić ograniczenia
  zakresu przeglądu. Dla dużych diffów zastosować zasady [P9].
- [ ] Stosować zasady uruchamiania sprawdzeń opisane poniżej.

### 5. Raport oparty na dowodach

- [ ] Zacząć od określenia przedmiotu, celu i zakresu oraz krótkiego
  werdyktu: „dobry kierunek”, „wymaga korekt”, „wymaga zmiany podejścia”
  albo „brak danych do oceny” [P4].
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
- [ ] Opisać w README podział między trzema skillami oraz instalację
  `ocen` w Claude Code.
- [ ] Dodać śledzony przez Git link katalogu `.claude/skills/ocen`
  wskazujący na `../../.agents/skills/ocen`, aby udostępnić jedną definicję
  w obu strukturach. Sprawdzić rozwiązanie linku w świeżym checkout.
  Instalację globalną opisać jako opcjonalny link lub kopię do
  `~/.claude/skills/ocen`; nie modyfikować globalnej konfiguracji
  w ramach implementacji.

### 7. Weryfikacja

- [ ] Uruchomić `scripts/quick_validate.py` z systemowego skilla
  `skill-creator` w Codex. W tym środowisku plik istnieje pod
  `/home/wojtek/.codex/skills/.system/skill-creator/scripts/quick_validate.py`;
  w innych środowiskach znaleźć go względem lokalizacji `SKILL.md`
  pakietu, bez zakładania identycznej ścieżki. Wymaga Python i PyYAML.
- [ ] Jeśli pakiet lub jego zależności nie są dostępne, bez instalowania
  dodatkowych narzędzi sprawdzić ograniczony zestaw: delimitery
  frontmatteru, pola `name: ocen` i niepusty `description`, treść
  instrukcji bez pozostałości szablonu oraz poprawność lokalnych linków.
  Zaznaczyć, że to kontrola podstawowa, a nie uruchomienie walidatora YAML.
- [ ] Sprawdzić zachowanie na scenariuszach z następnej sekcji.
- [ ] Sprawdzić, czy przegląd pozostawia pliki projektu, indeks
  i historię Git bez zmian.
- [ ] Sprawdzić dostępność `.claude/skills/ocen/SKILL.md` przez link.

## Uruchamianie testów i linterów podczas oceny

Domyślnie `ocen` wykonuje analizę przez odczyt. Nie uruchamia testów,
linterów ani buildów; wskazuje potrzebne sprawdzenia i proponuje
odpowiednie polecenia, wyraźnie oznaczając je jako niewykonane.

Na wyraźne polecenie użytkownika uruchamia adekwatne sprawdzenia.
Jeśli mogą tworzyć artefakty, wykonuje je w izolowanej kopii aktualnego
stanu projektu, która uwzględnia również oceniane lokalne zmiany,
zamiast w ocenianym katalogu roboczym. Nie używa trybów automatycznego
naprawiania lintera. Raport podaje polecenia, środowisko, wyniki oraz
ograniczenia wynikające z izolacji lub niedostępnych zależności.

Ta zasada dotyczy działania skilla `ocen`. Walidacja jego definicji
w trakcie implementacji pozostaje częścią etapu 7.

## Dostępność w Claude Code

Kanoniczna definicja pozostaje w `.agents/skills/ocen/SKILL.md`.
Projektowy punkt dostępu to `.claude/skills/ocen/SKILL.md`, udostępniony
przez link katalogu. Jeśli środowisko nie obsługuje linków, README
opisze kopię katalogu jako wariant instalacyjny i konieczność jej
aktualizacji po zmianach źródła.

Lokalizacje projektową `.claude/skills/`, globalną `~/.claude/skills/`
oraz obsługę linków katalogów opisuje
[oficjalna dokumentacja Claude Code](https://code.claude.com/docs/en/skills).
README powinien też wyjaśnić, jak udostępnić skill po skopiowaniu
pojedynczego katalogu lub użyciu tego repo jako submodule; link w tym
repo nie tworzy automatycznie punktu dostępu w projekcie nadrzędnym.

## Scenariusze akceptacyjne

| Scenariusz | Oczekiwany wynik |
| --- | --- |
| „Oceń plan”, dostępny plan, istnieją również zmiany w kodzie | Plan pozostaje przedmiotem oceny; zmiany mogą dostarczyć kontekstu. |
| „Oceń”, zmiany staged i unstaged oraz nowe pliki | Wszystkie lokalne zmiany wchodzą do zakresu. |
| „Oceń”, wyłącznie nowe nieśledzone pliki | Nowe pliki zostają ocenione mimo pustego diffu śledzonych plików. |
| „Oceń”, czysty Git, gałąź ma zmiany względem main | Oceniony zostaje `main...HEAD`; raport podaje bazę i wspólnego przodka. |
| „Oceń”, czysty Git, brak zmian gałęzi i plan w rozmowie | Oceniony zostaje plan z rozmowy. |
| „Oceń plan”, nowa sesja, jeden pasujący plan w docs/plans lub dodany w ostatnim commicie | Agent odnajduje i ocenia plan bez wymagania wcześniejszej rozmowy. |
| „Oceń plan”, kilka równorzędnych planów | Agent zadaje jedno pytanie o wybór planu. |
| Brak lokalnej main i wiarygodnej alternatywnej bazy | Agent pyta o bazę, zamiast przyjmować przypadkową gałąź. |
| Repozytorium bez pierwszego commita | Agent wyjaśnia brak bazy i ocenia dostępne nowe pliki, bez twierdzenia, że wykonał porównanie z HEAD. |
| Brak zmian i niejednoznaczny kontekst | Agent zadaje jedno pytanie o przedmiot oceny. |
| „Oceń względem main” | Raport podaje zakres i bazę porównania z main. |
| Poprawnie napisany kod realizuje inne zachowanie niż plan | Raport wskazuje rozbieżność z celem. |
| Edge case opisany w komentarzu, ale nieobsłużony w kodzie | Raport wskazuje brak obsługi; komentarz nie zamyka problemu. |
| Potencjalna podatność bez wystarczającego dowodu | Raport oznacza hipotezę i brakujące dane, zamiast przedstawiać ją jako potwierdzony błąd. |
| Ograniczony przegląd albo brak uruchomionych testów | Raport ujawnia ograniczenia i wykonane sprawdzenia. |
| „Oceń” bez prośby o testy lub linter | Sprawdzenia nie są uruchamiane; raport proponuje potrzebne polecenia. |
| „Oceń i uruchom testy”, testy tworzą artefakty | Testy działają w izolowanej kopii ocenianego stanu; projekt roboczy, indeks i historia pozostają bez zmian. |
| Duży diff z lockfile i plikami generowanymi | Kod i konfiguracja są analizowane według ryzyka; zależności i źródła w lockfile podlegają kontroli, a ograniczenia analizy plików generowanych są ujawnione. |
| Nowy sekret lub zmiana uprawnień w CI | Raport wskazuje konkretne ryzyko; nie powiela wartości sekretu. |
| Instalacja projektowa w Claude Code | Punkt dostępu .claude/skills/ocen/SKILL.md prowadzi do kanonicznej definicji. |

## Propozycje dodatkowe

- **[P1] Zgodność zmian z planem:** sprawdzać brakujące wymagania,
  odstępstwa i nieuzasadnione rozszerzenie zakresu, gdy plan jest dostępny.
- **[P2] Waga i pewność:** rozdzielać wagę problemu od pewności ustalenia.
- **[P3] Dokumentacja a obsługa:** udokumentowanie problemu nie oznacza
  jego obsłużenia; liczy się rzeczywiste zachowanie planu lub implementacji.
- **[P4] Werdykt:** podawać krótką, uzasadnioną ocenę kierunku.
- **[P5] Przegląd bez poprawek:** polecenie „oceń” tworzy ocenę
  i rekomendacje; nie uruchamia automatycznych poprawek, stagingu
  ani commitów.
- **[P6] Gotowość rozwiązania:** gdy mają zastosowanie, sprawdzać
  kompatybilność kontraktów API, migracje, możliwość utraty danych,
  wycofanie zmiany, timeouty, ponowienia, duplikaty operacji, częściowy
  sukces i wyścigi. Braki testów wiązać z konkretnym scenariuszem.
- **[P7] Odkrywanie planu:** poza rozmową uwzględniać dostępny kontekst
  IDE, pasujące pliki `docs/plans/*` i plan z ostatniego commita.
- **[P8] Konkretne obszary bezpieczeństwa:** sprawdzać sekrety w diffie,
  zmiany zależności i ich źródeł, uprawnienia oraz konfigurację CI.
  Nie powielać wykrytych wartości sekretów w raporcie.
- **[P9] Duże diffy:** analizować najpierw zmiany o najwyższym ryzyku.
  Pomijać pełną analizę powtarzalnej treści plików generowanych
  i lockfile'ów, lecz uwzględniać ich obecność w zakresie i raporcie.
  W lockfile sprawdzać istotne zmiany wersji, źródeł i integralności
  zależności w powiązaniu z manifestem; plików generowanych nie pomijać,
  jeśli zawierają istotne zmiany zachowania lub bezpieczeństwa.

## Docelowy zakres plików

- Nowy `.agents/skills/ocen/SKILL.md`.
- Nowy link katalogu `.claude/skills/ocen` do kanonicznej definicji.
- Aktualizacja indeksu i reguł w `AGENTS.md`.
- Aktualizacja opisu i przykładów w `README.md`.

Ten dokument jest planem. Powyższe zmiany będą realizowane dopiero
w ramach implementacji skilla.
