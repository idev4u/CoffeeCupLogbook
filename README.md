# Tally GO! Coffee

A small Rails 8 app for tracking coffee consumption.
Built with ERB, TailwindCSS, Hotwire, and the Rails asset pipeline.

## Goals

Tally GO! is here to count cups. Nothing more.

It’s meant to stay small. No dashboards, no analytics, no clever features.
Just fast logging and a simple interface.

If it ever stops being simple, it’s wrong.

## Setup

```bash
git clone git@github.com:idev4u/CoffeeCupLogbook.git
cd CoffeeCupLogbook
bundle install
bin/rails db:setup
bin/dev
```

The app runs on:

```
http://localhost:3000
```

## Structure

Tailwind entrypoint:

```
app/assets/stylesheets/application.tailwind.css
```

Layout:

```
app/views/layouts/application.html.erb
```

Navbar:

```
app/views/layouts/_navbar.html.erb
```

Assets:

```
app/assets/images/
```

## Deployment

Uses Kamal for deployment.
SQLite database stored on a mounted volume outside the container.

Backup accessory example:

```yaml
accessories:
  backup:
    image: <your docker hub user>/cupcounter
    host: homeserver.local
    directories:
      - "/Users/<your account>/storage/local_s3/cupcounter:/rails/storage"
    env:
      clear:
        DB_PATH: /rails/storage/production.sqlite3
        BACKUP_DIR: /rails/storage/backups
        BACKUP_KEEP: 5
    cmd: "bash -lc 'while true; do /rails/bin/backup_sqlite; sleep 86400; done'"
```

---

## Support

If you want to support the work on Tally Go!, you can do so here:

<a href="https://buymeacoffee.com/idev4u" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-black.png" width="150" alt="Buy Me A Coffee">
</a>

---

[more details](docs/extend_details.md)