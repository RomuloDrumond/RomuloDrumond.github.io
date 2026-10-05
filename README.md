# Romulo Drumond's blog

Personal Jekyll site at [romulodrumond.com](https://romulodrumond.com), migrated to the [al-folio v1.2 starter](https://github.com/alshedivat/al-folio/tree/v1.2). Runtime components come from the pinned gems in `Gemfile`.

Use Ruby from `.ruby-version`, Node.js (for JavaScript minification), and ImageMagick. Then:

```sh
bundle config set --local path vendor/bundle
bundle install
make check
make serve
```

Preview: <http://127.0.0.1:4000>. `make check` creates a production build, verifies the migration contracts, and runs upstream's migration/override audits. A plain `make serve` uses Jekyll's development URLs; for reviewing production canonicals locally, serve the production output:

```sh
python3 -m http.server 4000 --bind 127.0.0.1 --directory _site
```

The devcontainer uses the root `Dockerfile`. Notebook authors also need `pip install -r requirements.txt`; current posts do not require Python at build time.

See [migration decisions and checks](docs/MIGRATION.md) and [before/after screenshot evidence](docs/VISUAL_VALIDATION.md). All screenshots compare this site's own content.

CI builds and validates pull requests and uploads the generated site. Only a push to `master` publishes to the existing `gh-pages` branch. Manual workflow runs produce build artifacts without publishing. Keep `CNAME`, the production URL, and empty `baseurl` intact.
