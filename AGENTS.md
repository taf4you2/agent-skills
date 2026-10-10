# Skille dostępne w tym repozytorium

Ten plik jest indeksem, nie zlepkiem treści — każdy skill ma swoją pełną definicję w osobnym pliku.

- **caveman** — ultra-skompresowana komunikacja, mniej tokenów przy tej samej precyzji technicznej → [`.agents/skills/caveman/SKILL.md`](./.agents/skills/caveman/SKILL.md)
- **ponytail** — tryb "leniwego seniora": YAGNI, minimalny kod, reużywanie zamiast pisania od nowa → [`.agents/skills/ponytail/SKILL.md`](./.agents/skills/ponytail/SKILL.md)
- **diff-review** — porównanie niezacommitowanych zmian z `HEAD` oraz ocena błędów, ryzyk i przypadków brzegowych → [`.agents/skills/diff-review/SKILL.md`](./.agents/skills/diff-review/SKILL.md)
- **conventionals** — przygotowanie wiadomości według Conventional Commits bez wykonywania commita → [`.agents/skills/conventionals/SKILL.md`](./.agents/skills/conventionals/SKILL.md)

Narzędzia wspierające zagnieżdżone `AGENTS.md` (np. Antigravity) mogą ładować pliki skilli bezpośrednio z `.agents/skills/`.

## Polecenia własne

Gdy użytkownik wydaje polecenie „diff” lub „zrób diff”, przeczytaj
`.agents/skills/diff-review/SKILL.md` i wykonaj opisany tam przegląd.

Gdy użytkownik wydaje polecenie „conventionals” lub prosi o treść
wiadomości commita według Conventional Commits, przeczytaj
`.agents/skills/conventionals/SKILL.md` i przygotuj sam tekst wiadomości.
Nie wykonuj commita.
