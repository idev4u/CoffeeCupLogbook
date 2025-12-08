# Coffee Budget (Cupcounter)

A small Rails 8.1 application for tracking coffee consumption, built with ERB, TailwindCSS and the Rails asset pipeline.  
Includes a custom navbar and a subtle tile-pattern background inspired by coffee beans.

---

## 🚀 Tech Stack

- **Ruby on Rails 8.1**
- **TailwindCSS via tailwindcss-rails gem**
- **Hotwire (Turbo + Stimulus)**
- **ERB views**
- **Rails Asset Pipeline** for images
- **PostgreSQL** (optional, depending on setup)

---

## 📦 Installation

Clone the repository:

```bash
git clone <your-repo-url>
cd cupcounter
````

Install Ruby gems:

```bash
bundle install
```

Set up the database:

```bash
bin/rails db:setup
```

Start the server:

```bash
bin/dev
```

Your app is now available at:

```
http://localhost:3000
```

---

## 🎨 TailwindCSS

This project uses **tailwindcss-rails**, which integrates Tailwind without a Node.js toolchain.

To locate the Tailwind entrypoint:

```
app/assets/stylesheets/application.tailwind.css
```

You can add Tailwind layers and custom CSS there.

---

## 🖼️ Background Pattern (Coffee Beans)

The app uses a subtle repeating coffee-bean pattern as a full-screen background.

Place the pattern image in:

```
app/assets/images/coffee_pattern.png
```

### Background Integration

This is implemented in `application.html.erb` using a fixed overlay:

```erb
<div
  class="absolute inset-0 bg-repeat bg-[length:260px] opacity-10 -z-10 min-h-screen"
  style="background-image: url('<%= asset_path("coffee_pattern.png") %>');">
</div>
```

Advantages:

* Works without Tailwind configuration
* Rails resolves fingerprinted assets
* Fully responsive
* Subtle design via `opacity-10`

---

## 🧭 Navbar

The navbar lives in:

```
app/views/layouts/_navbar.html.erb
```

It includes:

* Logo (coffee beans)
* App title ("Coffee Budget")
* Desktop navigation
* Mobile burger menu (with Tailwind classes)
* Responsive layout with `flex`, `gap`, and `justify-between`

---

## 📁 Layout Structure

The global layout file is:

```
app/views/layouts/application.html.erb
```

It includes:

* full-screen patterned background
* navbar
* main container
* flash message styling
* content yield

---

## 🔧 Asset Handling

Images are stored in:

```
app/assets/images/
```

Use Rails helpers such as:

```erb
<%= image_tag "coffee_beans.png" %>
<%= asset_path "coffee_pattern.png" %>
```

Rails fingerprints asset URLs automatically in production.

---

## 📚 Development Commands

Start Tailwind build + Rails server (via foreman):

```bash
bin/dev
```

Run tests:

```bash
bin/rails test
```

Lint with Rubocop (if installed):

```bash
bundle exec rubocop
```

---
## backup sqlite db 

first things first don't store the sqlite3 file in the container because with every restart the file is gone.
so change the volume section in config/deploy.yml

```yaml
volumes: 
  # Host-Storage (inkl. production.sqlite3) -> /rails/storage im Container
  - "/Users/apprunner/storage/local_s3/cupcounter:/rails/storage"
```

execute the script local to test it
```zsh
DB_PATH=storage/production.sqlite3 \
BACKUP_DIR="./backups" \
BACKUP_KEEP=5 \
bin/backup_sqlite.sh
```

thanks to kamal accessories your are able to deploy side car container for maintanace task
to do this add this section for a backup contianer
```yaml
accessories:
  backup:
    image: normansutorius/cupcounter
    host: homeserver.local
    directories:
      - "/Users/apprunner/storage/local_s3/cupcounter:/rails/storage"
    env:
      clear:
        DB_PATH: /rails/storage/production.sqlite3
        BACKUP_DIR: /rails/storage/backups
        BACKUP_KEEP: 5
    cmd: "bash -lc 'while true; do /rails/bin/backup_sqlite; sleep 86400; done'"
```
and if it urgent you can exceute the aliases:
```yaml
backup_now: accessory exec backup "/rails/bin/backup_sqlite"
backup_logs: accessory logs backup
```

## ☕ Credits

Background pattern drawn using AI generation.
Rails + Tailwind integration refined with ChatGPT assistance.

## debug database
```zsh
kamal console 
```

```ruby
Logbook.all.each do | lb |
  puts lb.cup_type+"::"+lb.id.to_s+":"+lb.created_at.to_s
end
```