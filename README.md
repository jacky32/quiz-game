Aplikace je dostupná na <https://czu.broniek.eu>, zdrojový kód na <https://github.com/jacky32/quiz-game>.

Aplikace je napsána v Ruby on Rails frameworku, funguje jako monolith aplikace. To znamená, že nemá striktně oddělený frontend a backend, ale oboje spravuje jeden server. Frontend je pak psán s pomocí TailwindCSS a pluginem DaisyUI, který zjednodušuje stylování pomocí předdefinovaných komponent.

Struktura:

- app/ - zde se nachází "funkční" část aplikace
- app/views/ - HTML šablony, které renderují content jednotlivých stránek
- app/controllers/ - controllery, které reagují na jednotlivé činnosti uživatelů, vracejí konkrétní views a pracují s modely
- app/models/ - modely, které jsou základem funkčnosti aplikace a simulují objekty v databázi
- public/ - soubory, které jsou přístupné veřejnosti
- data/questions.json - jednotlivé otázky, které jsou nahrány do aplikace
