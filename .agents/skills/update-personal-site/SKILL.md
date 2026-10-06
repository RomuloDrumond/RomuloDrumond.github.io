---
name: update-personal-site
description: Update the personal blog at romulodrumond.com, including content edits, al-folio upgrades, local previews, and requested GitHub Pages releases. Use for work in RomuloDrumond.github.io while preserving its content, URLs, and intentional customizations.
---

# Update personal site

Repository: the checkout containing this skill (`RomuloDrumond.github.io`).
Resolve repository-relative paths from that checkout's Git root.
Production: `https://romulodrumond.com/`.

## Establish the current baseline

- Inspect Git status, branch, remotes and current source revision. Preserve local changes. Work on an isolated branch or worktree for substantial updates.
- Fetch and inspect the current production branch before integrating or releasing. The original migration baseline missed a newer `/sheditor/privacy/` page; a historical assessment is not the current content inventory.
- Read the repository's `docs/MIGRATION.md`, `Makefile`, relevant tests and configuration. For browser comparisons read `docs/VISUAL_VALIDATION.md`; for publishing read [release-validation.md](references/release-validation.md) and the repository's deployment reports. Reports on `validation/al-folio-production` are historical evidence, not deployment instructions to replay.
- Determine the requested scope from the conversation: editing, local preview, isolated hosted preview, or production release. Carry forward authorization already given for this update. A past release or use of this skill does not authorize publishing a new update. Complete the candidate and checks before requesting any missing publication authorization.

## Preserve the site's intent

Unless the user intentionally changes them, preserve:

- Existing post/page URLs and heading fragments, `/blog/:year/:title/`, `/feed.xml`, pagination, yearly and tag/category archives. Keep `CNAME` as `romulodrumond.com`, production `url` as `https://romulodrumond.com`, and production `baseurl` empty.
- Authored posts, prose, code, original images, figure captions, widths, zoom, iframe sources, biography, profile photo, quote and social destinations. Preserve new work found after the recorded baseline, including `/sheditor/privacy/`.
- Navigation: about, blog, publications, repositories. Retired sample routes remain unlisted; do not restore inherited Einstein CV, project, news or bibliography content.
- The genuine publication and curated repositories. The migrated publication renderer expects a bare DOI, not an already prefixed `https://doi.org/` URL. Keep publication filtering deliberate when adding entries.
- `/aivq-media-store/`, `/aivq-media-store/privacy/`, `/aivq-media-store/terms/`: `nav: false`, `sitemap: false`, `noindex: true`, generated `noindex, nofollow`, and exclusion from generated search data. Check robots metadata, navigation, sitemap and search independently; these controls are not interchangeable.
- Green tables with borders/padding, small profile quote and social icons, readable article widths, and mobile caption wrapping. Table rules must not restyle Rouge's internal line-number tables.

The October 2026 migration inventory was nine posts, 24 post images, 16 figures, seven iframes, one publication and four curated repositories. These are historical preservation expectations, not permanent content limits.

## Make the change within the gem architecture

- Use the pinned dependencies in `Gemfile` and `Gemfile.lock`. At migration, the target was al-folio v1.2 with `al_folio_core` 1.0.15; re-read the lockfile before assuming these versions remain current.
- Keep runtime layouts, CSS and JavaScript gem-owned. The intentional override is `_layouts/default.liquid`, adding `page.noindex` metadata and the `assets/css/custom.css` link. Its reviewed checksum is in `.al-folio-overrides.yml`. Avoid copying the legacy runtime back into the site.
- For a theme upgrade, read the target release's upstream migration skill, `docs/ARCHITECTURE.md` and `docs/BOUNDARIES.md`. Verify the intended tag, rather than silently choosing upstream main. Review override differences before accepting new checksums:

  ```sh
  bundle exec al-folio upgrade audit
  bundle exec al-folio upgrade overrides audit
  bundle exec al-folio upgrade overrides diff _layouts/default.liquid
  ```

  Run `bundle exec al-folio upgrade overrides accept _layouts/default.liquid` only after reviewing and reconciling the new upstream file. Upstream's starter-only style contract rejected local layouts even though personal-site overrides are supported; use the applicable override audit.
- Use `_data/socials.yml`; biography links read that data. The profile quote uses `profile.more_info`, not legacy `profile.address`.
- Figures use `figure.liquid`; preserve explicit sizing and captions. The Selenium GIF needs `avoid_scaling=true` and its original animated file, without a static responsive source substituting for it.
- Automatic contents recognizes H2/H3 headings. Preserve existing fragment IDs when changing levels. Keep reading progress and code-copy controls working. Select thumbnails from the article's own media; do not invent featured/editorial selections.
- The migration's pinned `al_search` 1.0.3 indexes titles/descriptions, not full article bodies. Recheck behavior if upgrading it. Dark mode, math, syntax highlighting, RSS, image zoom and Distill predate the migration; do not describe them as newly added. Keep charts, notebooks and galleries available through supported page opt-ins.

## Build and validate

Use the repository's commands, rechecking their definitions if changed:

```sh
make check
make serve
```

`make check` builds production output, writes `_site/.nojekyll`, runs `test/migration_test.rb`, and audits migration/overrides. `make serve` starts a local server bound to `127.0.0.1`. Check for existing servers and serve the intended revision; do not assume an old process has reloaded the candidate. Verify the preview URL before handing it over.

For new or intentionally edited content, inspect hard-coded expectations in `test/migration_test.rb` and `test/preview_test.rb`, including post/image/feed counts, exact text and source hashes. Extend expectations for authorized additions or edits. Retain unchanged baseline routes, assets, code and anchors. Do not regenerate the whole historical `test/migration-baseline.json` from the candidate or remove checks merely to turn failures green.

Scale browser coverage to the change. A copy edit needs affected pages and shared smoke checks; theme, layout or workflow changes need broad coverage:

- Check all existing article routes for a theme migration, plus home, blog, publication, repositories, policies, figures/GIFs, code and embeds. Check feed/archive paths, canonicals, AIVQ protections and generated search data.
- Test desktop/mobile navigation, overflow and image decoding; light/dark styles and green tables; search navigation; code copying; image zoom; article contents links and reading progress.
- Use actual site content for before/after screenshots. Match viewport, scale, theme, scroll position and UI state; wait for fonts/images to settle. Include focused captures of changed regions below the fold.
- For browser operation prefer the host's shared preview tools. In T3, start with `preview_status`, then `preview_open` if necessary. Verify resulting state after interactions; a click acknowledgement alone does not prove success.
- Refresh stale cached pages before capturing deployed output. Compare PNGs in a common color space, preserving the original evidence images. Embedded ICC profiles and macOS/Linux image encoders can produce pixel differences despite matching source media and layout. Do not change site styling just to lower a screenshot difference score.
- Confirm GIF animation with time-separated frames inside the GIF region, zoom with actual open/close state, and copy with clipboard read-back when possible. Background-tab focus can block clipboard access or interactions. Report that limit; synthetic event checks are not equivalent to a real user interaction pass.

Do not infer full-page correctness from viewport captures, third-party playback from preserved iframe URLs, or a tested Docker environment from a native build.

## Hand back a concrete result

Report the skill task's actual changes, branch/revision, working preview and screenshot evidence, checks run, material limits and deployment status. Link a reviewable diff. Keep preview servers available for review unless asked to stop them, and state which remain running. Do not claim a server is available or a release is live without checking it in this run.

For an authorized hosted preview or production release, follow [release-validation.md](references/release-validation.md).
