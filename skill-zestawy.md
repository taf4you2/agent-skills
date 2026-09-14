# Zestawy skilli do day-to-day development

## 1. Globalne skille

Skille, które warto mieć dostępne praktycznie w każdym projekcie.

### Core

- `ponytail`
  - Ogranicza overengineering.
  - Preferuje YAGNI, standard library, natywne możliwości platformy i minimalną liczbę abstrakcji.
  - Dobry jako stała warstwa nad pozostałymi skillami.

- `caveman`
  - Skraca komunikację agenta.
  - Ogranicza zbędne wyjaśnienia, powtórzenia i filler.
  - Dobry do codziennego kodowania, debugowania i code review.

- `systematic-debugging`
  - Szukanie root cause przed wprowadzaniem poprawki.
  - Przydatny przy bugach, failing testach i problemach integracyjnych.

- `verification-before-completion`
  - Testy, build, lint i inne kontrole przed uznaniem zadania za zakończone.

- `source-driven-development`
  - Sprawdzanie bibliotek i API w dokumentacji źródłowej zamiast zgadywania.

- `code-review`
  - Review zmian pod kątem standardów projektu, poprawności i jakości.

### Rekomendowany zestaw globalny

```text
ponytail
caveman
systematic-debugging
verification-before-completion
source-driven-development
code-review
```

---

## 2. Frontend desktop: Angular + Wails + Go

Zestaw do implementacji aplikacji desktopowej z frontendem w Angularze i komunikacją przez Wails do Go.

### Core

- `ponytail`
- `caveman`
- `systematic-debugging`
- `verification-before-completion`
- `source-driven-development`
- `agent-browser`
- `codebase-design`

### Opcjonalnie

- `ui-ux-pro-max`
  - Gdy implementacja obejmuje również decyzje UI/UX.

- `security-and-hardening`
  - Jeśli desktop komunikuje się z API, obsługuje auth, dane użytkownika, tokeny lub uprawnienia.

### Rekomendowany zestaw

```text
angular-wails-go/
├── ponytail
├── caveman
├── systematic-debugging
├── verification-before-completion
├── source-driven-development
├── agent-browser
└── codebase-design
```

### Przykładowa preferowana prostota

Zamiast:

```text
Angular
↓
FrontendCommandBus
↓
DesktopBridgeAdapter
↓
WailsTransportService
↓
GoCommandDispatcher
↓
ApplicationMediator
↓
HandlerFactory
↓
real function
```

preferować, jeśli wymagania nie uzasadniają dodatkowych warstw:

```text
Angular service
↓
Wails binding
↓
Go function
```

---

## 3. Backend: C# + TypeScript

Zestaw do backendów, API i usług pisanych w C# i TypeScript.

### Core

- `ponytail`
- `caveman`
- `systematic-debugging`
- `code-review`
- `verification-before-completion`
- `source-driven-development`
- `security-and-hardening`

### Opcjonalnie

- `tdd`
  - Jeśli pracujesz test-first w cyklu red → green → refactor.

- `domain-modeling`
  - Jeśli backend ma rozbudowaną domenę biznesową, dużo reguł, encji i procesów.

### Rekomendowany zestaw

```text
backend-csharp-typescript/
├── ponytail
├── caveman
├── systematic-debugging
├── code-review
├── verification-before-completion
├── source-driven-development
└── security-and-hardening
```

Opcjonalnie:

```text
tdd
domain-modeling
```

### Szczególna rola Ponytail

W C# warto używać Ponytail jako hamulca przed niepotrzebnym:

```text
interface
abstract factory
provider
adapter
facade
mediator
repository
manager
service
helper
```

jeśli prostsze rozwiązanie spełnia wymagania.

---

## 4. Projektowanie frontendu / UI / UX

Ten zestaw jest przeznaczony głównie do projektowania ekranów, design systemu i audytu interfejsu.

### Design

- `ui-ux-pro-max`
  - Główny skill do:
    - UI,
    - UX,
    - accessibility,
    - design systemów,
    - audytu interfejsu.

### Weryfikacja

- `agent-browser`
  - Testowanie rzeczywistego UI.
  - Formularze.
  - Flow użytkownika.
  - Screenshoty.
  - Kontrola efektu po implementacji.

### Opcjonalnie

- `codebase-design`
  - Jeśli podczas projektowania trzeba również ustalić strukturę komponentów i modułów.

- `ponytail lite`
  - Przydatny przy implementacji designu.
  - Przy czystym projektowaniu UI lepiej używać ostrożniej.

### Rekomendowany zestaw do designu

```text
frontend-design/
├── ui-ux-pro-max
└── agent-browser
```

### Rekomendowany zestaw do implementacji designu

```text
frontend-ui-implementation/
├── ui-ux-pro-max
├── agent-browser
├── ponytail
├── caveman
└── codebase-design
```

---

## 5. Architektura

Do sesji stricte architektonicznych lepiej używać osobnego zestawu.

### Główny skill

- `codebase-design`
  - Projektowanie:
    - modułów,
    - interfejsów,
    - granic odpowiedzialności.

### Dodatkowa kontrola prostoty

- `ponytail lite`
  - Pilnuje, żeby poprawna architektura nie zamieniła się w overengineering.

### Tryb komunikacji

- `caveman lite` lub `off`
  - Przy architekturze warto zachować więcej kontekstu i wyjaśnień decyzji.

### Ręcznie

- `improve-codebase-architecture`
  - Audyt istniejącej architektury.
  - Planowanie większej refaktoryzacji.
  - Nie jako skill aktywny przy każdym zadaniu.

### Jeśli domena jest złożona

- `domain-modeling`
  - Model domeny.
  - Terminologia.
  - `CONTEXT.md`.
  - ADR.

### Rekomendowany zestaw

```text
architecture/
├── codebase-design
├── ponytail-lite
└── caveman-lite
```

Ręcznie:

```text
improve-codebase-architecture
```

Opcjonalnie:

```text
domain-modeling
```

---

# Finalny podział

## Global

```text
ponytail
caveman
systematic-debugging
verification-before-completion
source-driven-development
code-review
```

## Angular + Wails + Go

```text
codebase-design
systematic-debugging
verification-before-completion
source-driven-development
agent-browser
```

Opcjonalnie:

```text
ui-ux-pro-max
security-and-hardening
```

## Backend C# / TypeScript

```text
systematic-debugging
code-review
verification-before-completion
source-driven-development
security-and-hardening
```

Opcjonalnie:

```text
tdd
domain-modeling
```

## UI / UX

```text
ui-ux-pro-max
agent-browser
```

Przy implementacji:

```text
ponytail
caveman
codebase-design
```

## Architektura

```text
codebase-design
ponytail-lite
caveman-lite
```

Ręcznie:

```text
improve-codebase-architecture
```

Opcjonalnie:

```text
domain-modeling
```

---

# Proponowana organizacja w VS Code

## Globalnie

```text
~/.agents/skills/
├── ponytail/
├── caveman/
├── systematic-debugging/
├── verification-before-completion/
├── source-driven-development/
└── code-review/
```

## W projekcie Angular + Wails + Go

```text
PROJECT/
└── .agents/
    └── skills/
        ├── codebase-design/
        ├── agent-browser/
        ├── ui-ux-pro-max/
        └── security-and-hardening/
```

Dzięki temu uniwersalne skille są dostępne we wszystkich projektach, a skille zależne od konkretnego typu aplikacji pozostają w repozytorium projektu.
