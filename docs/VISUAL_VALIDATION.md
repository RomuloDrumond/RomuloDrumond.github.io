# Before/after validation

Local candidate: **passed**. Production candidate: **pending deployment**.

Open the [interactive screenshot gallery](migration-screenshots/index.html), or serve it locally:

```sh
python3 -m http.server 4001 --bind 127.0.0.1 --directory docs/migration-screenshots
```

The gallery is then at <http://localhost:4001>. The working site preview is at <http://localhost:4000>.

## Capture scope

The 13 desktop pairs cover home, blog, publications, repositories and all nine authored posts. Before images are from the current personal site at `https://romulodrumond.com`; after images are from the actual local production build of this branch, with the same personal content. These are not upstream demo screenshots. Capture date: October 5, 2026.

Both sides use the shared browser's measured 1536 × 960 CSS-pixel viewport; its saved PNGs are 1280 × 800. The [capture manifest](migration-screenshots/captures.json) records routes, dimensions, image-load results, code-control counts and TOC counts. Native viewport resizing repeatedly timed out, so mobile checks used a real 390 × 844 CSS-pixel same-origin iframe in the same browser. This exercises actual responsive media queries; the viewport harness exists only in browser memory and is not part of the site. Mobile screenshots show that narrow viewport within the browser's outer frame.

The nine articles and four main pages were checked at mobile width. All images decoded successfully and the final layouts have no page-level horizontal overflow. The green table remains horizontally usable. Long caption URLs wrap rather than stretching the document. Mobile navigation expands/collapses and retains the four intended destinations.

## Visible differences and interaction checks

- Home retains the biography, picture, quote, 13px quote text and original 51.2px computed social-icon size. The Twitter destination now uses the upstream X icon.
- The blog stays chronological; existing illustrations provide thumbnails for five posts. No featured ranking was added.
- Seven structured posts have automatic section links and reading progress. The sidebar works while scrolling, and the article gets approximately its original reading width. Original anchor IDs are present.
- Existing highlighted code remains readable. All 24 blocks have copy controls; an actual copy action succeeded and copied Python code without the displayed line numbers.
- Search opens and querying “Spark” returns the Spark article. Its data has four navigation pages, nine posts, four social destinations and three theme actions. No AIVQ or retired demo route appears.
- Image zoom opens and closes. The Selenium GIF is the untouched 229-frame original; two time-separated screenshots show different frames. Canvas sampling is not used as animation proof because browsers may draw the animation's default frame into a canvas.
- The original green table styling survives in light and dark appearances. Theme switching works through the UI.
- The single real publication renders with all authors accessible and a corrected DOI link. The four repository cards and the profile card load. YouTube embed shells and the pointer-pointer embed render at the original routes; all seven iframe sources are unchanged.
- AIVQ pages load with the preserved content and canonical URLs, emit `noindex, nofollow`, and are absent from generated sitemap/search data.

The [validation log](migration-screenshots/checks.txt) records 1,939 preservation assertions, clean upstream migration/override audits, the upstream upgrade CLI smoke test and workflow lint. All nine article bodies were also compared with the original sources after accounting for figure API changes, heading levels and removed manual contents lists; no prose or code edits were found.

## Repeat on the real URL after deployment

No deployment or merge has been performed. Production validation must run **after this candidate is actually published**, rather than checking the old live site and treating it as the candidate.

1. Confirm that the deployed output corresponds to the reviewed branch. One quick marker is `/assets/css/custom.css`; its SHA256 for this candidate is `d8ff4ab5af5f6287f40d62b9c857fcbcd30ce87feaa773790c80231cf56a4e2c`.
2. Capture every route in `captures.json` on `https://romulodrumond.com` at the recorded desktop and mobile widths. Keep the existing “before” PNGs as the original baseline. Compare both original→deployed and local-candidate→deployed.
3. Repeat the focused home/blog/menu, light/dark table, code-copy, sidebar/progress, search, GIF/zoom, publication and repository checks. Wait for fonts and images to finish loading before saving full screenshots.
4. Check all article URLs, feed, pagination, year/tag archives and all three AIVQ routes over HTTPS. Inspect the robots tags, canonical URLs, sitemap and inline `ninja.data` search payload. Confirm `CNAME`/custom-domain resolution and that no demo content appears.
5. Record the deployed revision, capture date, screenshots and any differences in a separate `deployed/` evidence folder. Update this document's production status only after those checks pass.

The Docker image and Linux CI were not executed locally. External iframe playback and repository-card availability remain dependent on their third-party services. Desktop and mobile screenshot validation cannot substitute for a production-hosting check; that is why the production pass remains explicitly pending.
