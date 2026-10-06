# Migration to al-folio v1.2

The migration starts from personal commit `154712e`, a clean checkout verified on October 5, 2026. The target is upstream v1.2, `b95d6d61a1b0663529094b1b5f4fbe8aa41f8a04`. Upstream `main` has advanced since the assessment; this migration deliberately uses the verified stable tag.

The supplied assessment HTML path was missing. Its HTML source was recovered from `/private/tmp/build-blog-report.py`; the detailed local/upstream audit files and Git history from the October 2 assessment were also available and read. The earlier assessment compared the live blog with the upstream demo. The new evidence compares the live personal blog with the built migration candidate.

## Architecture and maintenance

`Gemfile`, its committed lockfile, and `_config.yml` retain the v1.2 gem architecture and exact `al_*` / `al_folio_*` pins. The theme is `al_folio_core` 1.0.15. Legacy layouts, includes, Sass, JavaScript, build helpers and unused example drafts were removed. Runtime CSS and JavaScript are supplied by the gems; no local Tailwind build or copied Bootstrap runtime is needed.

Read before changing the runtime:

- [Upstream migration skill](https://github.com/alshedivat/al-folio/blob/v1.2/.agents/skills/al-folio-v1-migration/SKILL.md)
- [Architecture](https://github.com/alshedivat/al-folio/blob/v1.2/docs/ARCHITECTURE.md)
- [Ownership boundaries](https://github.com/alshedivat/al-folio/blob/v1.2/docs/BOUNDARIES.md)

One gem file is overridden: `_layouts/default.liquid`. Its only additions are the existing `page.noindex` robots tag and a link to `assets/css/custom.css`. `.al-folio-overrides.yml` records the reviewed upstream checksum. Recheck that override on every gem upgrade:

```sh
bundle exec al-folio upgrade audit
bundle exec al-folio upgrade overrides audit
bundle exec al-folio upgrade overrides diff _layouts/default.liquid
# Only after reviewing the new upstream file:
bundle exec al-folio upgrade overrides accept _layouts/default.liquid
```

The upstream starter's `lint:style-contract` forbids local layout files in upstream itself. Its architecture documentation explicitly permits overrides in personal sites, so this repository uses the override audit rather than copying that incompatible starter-only rule.

## Preserved content and behavior

- Nine authored posts, their filenames, titles, dates, descriptions, tags, prose, code and seven iframe sources. Post URLs remain `/blog/:year/:title/`. Existing heading anchor IDs survive the heading-level adjustments.
- All 24 post images, the original profile image, favicon and genuine publication preview are byte-for-byte intact. All 16 figure includes use `figure.liquid`; original width choices are explicit. The Selenium GIF uses `avoid_scaling=true`, retains animation and is excluded from WebP generation. Static images still get responsive WebP variants.
- Domain `romulodrumond.com`, `CNAME`, empty `baseurl`, production canonical URLs, `/feed.xml`, `/blog/page/2/`, yearly and tag/category archive URL patterns.
- Biography, profile photo, quote and four social destinations. `profile.address` became `profile.more_info`; socials moved to `_data/socials.yml`; the biography's LinkedIn interpolation reads that data. X now supplies the upstream icon for the existing Twitter account. The RSS icon remains hidden while the feed remains available.
- Green table headers, cell borders/padding, 13px quote and 0.8em social icons, and unobtrusive code backgrounds. The table rules avoid Rouge's internal line-number table. Long caption URLs wrap on mobile.
- The one genuine publication remains filtered to 2022; all seven Einstein examples were removed. Its DOI was normalized to the bare identifier required by the new renderer, fixing a doubled `https://doi.org/` link. All four curated repositories and the GitHub profile remain.
- Navigation stays about, blog, publications and repositories. `/cv/`, `/projects/` and `/teaching/` remain unlisted placeholders; the nine legacy project/news URLs and `/_pages/dropdown/` resolve to unlisted retirement pages. No inherited example content is exposed in navigation, search or sitemap.
- The three AIVQ Markdown files are completely unchanged, including `nav: false`, `sitemap: false`, `noindex: true` and their exact routes. Generated pages emit `noindex, nofollow` and retain production canonicals. They are absent from the sitemap and the search payload.

## Reader improvements

Search/navigation uses the pinned `al_search` 1.0.3 palette. It indexes titles and descriptions, not full article bodies. Copy buttons work on the existing code examples. Seven structured long posts gain an automatic sidebar; existing manual opening lists were removed and H1/H2 section headings became H2/H3 so the core's TOC recognizes them. Original fragment IDs stay unchanged. The sidebar has extra desktop space so article text retains approximately its prior width; mobile stacks it above the article.

Reading progress and back-to-top are enabled. Five posts use their existing lead illustrations as thumbnails. No post was marked featured or editorially ranked. Charts, notebooks, galleries, math and Distill remain available through the starter's bundled plugins and per-page opt-ins. Dark mode, math, syntax highlighting, RSS, image zoom and Distill already existed before this migration.

## Validation and publishing boundary

`make check` builds the actual candidate and checks routes, original asset hashes, all figures/captions/sizes, heading anchors, rendered code, iframe sources, social/navigation links, genuine publication/repositories, canonical/feed/archive paths, AIVQ/retired-page exclusion, generated local asset links and absence of inherited Einstein content. The fixture records preservation expectations from `154712e`; it is not generated from the candidate.

Upstream's `integration_upgrade_cli.sh` was run successfully against the pinned gems. The migration audit reports zero blocking and zero non-blocking findings; the one override is acknowledged. `actionlint` validates the adapted workflow. Browser validation and screenshot evidence are detailed in [VISUAL_VALIDATION.md](VISUAL_VALIDATION.md).

The workflow builds PRs without publishing, uploads `_site`, and permits the separate publish job only for a push to `master`. The publish job targets the existing `gh-pages` branch; production configuration and CNAME are never rewritten. `make build` writes `.nojekyll` for the generated Pages branch. No workflow, deployment, merge or remote push was triggered during the migration.

The build was exercised on macOS with Ruby 4.0.6, Bundler 4.0.6, Jekyll 4.4.1 and ImageMagick 7.1.2. A later authorized deployment test also passed on Linux in a separate GitHub repository; see [PREVIEW_DEPLOYMENT.md](PREVIEW_DEPLOYMENT.md) for the deployed preview, preserved newer Sheditor policy, and local-versus-deployed screenshots. The updated Docker/devcontainer was not executed. External embeds and repository-card services can independently change or become unavailable. Production root deployment remains pending; repeat the recorded routes, viewports and interactions after the actual domain cutover.
