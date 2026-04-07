# Dokumentace Quiz Game

## Struktura projektu

### 📁 Kořenové soubory

- `config.ru` - Rack konfigurace pro spuštění Rails aplikace
- `Dockerfile` - Docker kontejner pro deployment
- `Gemfile` - Ruby závislosti (gems)
- `Rakefile` - Rake úlohy pro automatizaci
- `README.md` - Základní dokumentace projektu
- `Procfile.dev` - Konfigurace pro vývojové prostředí

### 📁 app/ - Hlavní aplikační logika

#### app/controllers/

- `application_controller.rb` - Základní controller pro celou aplikaci
- `dashboards_controller.rb` - Dashboard a přehled
- `passwords_controller.rb` - Správa hesel (reset, změna)
- `playthroughs_controller.rb` - Řízení herních průchodů/her
- `publics_controller.rb` - Veřejné stránky
- `registrations_controller.rb` - Registrace uživatelů
- `sessions_controller.rb` - Přihlašování/odhlašování
- `users_controller.rb` - Správa uživatelů
- `admin/` - Administrátorské controllery

#### app/models/

- `playthrough.rb` - Model pro herní průchod
  - Obsahuje skórovací systém (1 000 Kč - 1 000 000 Kč podle úrovně)
  - Generování 10 otázek (po jedné pro každou úroveň 1-10)
  - Odpovídání na otázky s kontrolou správnosti
  - Nápovědy: textová, 50:50, výměna otázky
  - Sledování stavu hry (in_progress, completed)
- `playthroughs_question.rb` - Propojení průchodu a otázek
- `question.rb` - Model otázky
- `question_option.rb` - Model možností odpovědí
- `user.rb` - Model uživatele
- `session.rb` - Model session/relace
- `current.rb` - Aktuální kontext aplikace

#### app/views/

- `admin/` - Administrátorské pohledy
- `dashboards/` - Pohledy pro dashboard
- `layouts/` - Layouty aplikace
- `passwords/` - Pohledy pro správu hesel
- `playthroughs/` - Pohledy pro herní průchod
- `publics/` - Veřejné stránky
- `registrations/` - Registrační formuláře
- `sessions/` - Přihlašovací formuláře
- `users/` - Uživatelské profily
- `pwa/` - Progressive Web App soubory
- `shared/` - Sdílené partial views

#### app/javascript/

- `application.js` - Hlavní JavaScript soubor
- `controllers/` - Stimulus/Hotwire controllery

#### app/assets/

- `builds/` - Zkompilované assety
- `images/` - Obrázky
- `stylesheets/` - CSS styly
- `tailwind/` - Tailwind CSS konfigurace

#### app/mailers/

- `application_mailer.rb` - Základní mailer
- `passwords_mailer.rb` - Emaily pro reset hesla

### 📁 config/ - Konfigurace aplikace

- `application.rb` - Hlavní konfigurace Rails aplikace
- `routes.rb` - Definice URL routes
- `database.yml` - Konfigurace databáze (SQLite)
- `puma.rb` - Konfigurace webového serveru
- `importmap.rb` - Import maps pro JavaScript
- `environments/` - Prostředí (development, test, production)
- `initializers/` - Inicializační skripty
- `locales/` - Jazykové překlady

### 📁 db/ - Databáze

- `schema.rb` - Aktuální schéma databáze
- `seeds.rb` - Seed data pro naplnění databáze
- `migrate/` - Migrace databáze
- `cable_schema.rb` - Schéma pro Action Cable
- `cache_schema.rb` - Schéma pro cache
- `queue_schema.rb` - Schéma pro fronty úloh

### 📁 data/

- `questions.json` - JSON soubor s otázkami pro import

### 📁 test/ - Testy

- `controllers/` - Testy controllerů
- `models/` - Testy modelů
- `system/` - Systémové/E2E testy
- `integration/` - Integrační testy
- `fixtures/` - Testovací data
- `helpers/` - Pomocné testovací metody

### 📁 bin/ - Spustitelné skripty

- `rails` - Rails command line interface
- `rake` - Rake úlohy
- `setup` - Setup skript pro nový projekt
- `dev` - Spuštění vývojového prostředí
- `docker-entrypoint` - Entrypoint pro Docker
- `ci` - CI/CD skript

### 📁 storage/ - Úložiště

- SQLite databázové soubory (development.sqlite3, test.sqlite3)
- Různé složky pro ukládání souborů

### 📁 public/ - Veřejné statické soubory

- Chybové stránky (400.html, 404.html, 500.html atd.)
- `robots.txt` - Konfigurace pro vyhledávače
- `site.webmanifest` - PWA manifest

### 📁 lib/ - Vlastní knihovny

- `tasks/` - Vlastní Rake úlohy

### 📁 vendor/ - Externí závislosti

- `javascript/` - Vendorované JavaScript knihovny

## Herní mechanika

### Skórovací systém

- Úroveň 10: 1 000 000 Kč
- Úroveň 9: 500 000 Kč
- Úroveň 8: 250 000 Kč
- Úroveň 7: 100 000 Kč
- Úroveň 6: 50 000 Kč
- Úroveň 5: 20 000 Kč
- Úroveň 4: 10 000 Kč
- Úroveň 3: 5 000 Kč
- Úroveň 2: 2 000 Kč
- Úroveň 1: 1 000 Kč

### Nápovědy

- **Textová nápověda** - Zobrazí pomocný text k otázce
- **50:50** - Odstraní dvě nesprávné odpovědi
- **Výměna otázky** - Vymění aktuální otázku za jinou stejné úrovně

### Generování otázek

- Každý průchod má 10 otázek (jedna pro každou úroveň 1-10)
- Otázky jsou vybírány náhodně z aktivních otázek pomocí SQL dotazu
- Používá se `ROW_NUMBER()` s `PARTITION BY level` pro výběr jedné náhodné otázky na úroveň

## Technologie

- **Framework**: Ruby on Rails
- **Databáze**: SQLite
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Deployment**: Docker, Kamal
