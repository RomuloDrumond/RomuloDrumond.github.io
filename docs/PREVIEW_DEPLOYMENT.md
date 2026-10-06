# Isolated GitHub Pages deployment test

The staging target is the separate repository `RomuloDrumond/blog-v12-preview`,
branch `staging`. GitHub project sites inherit the account site's custom domain,
so its expected URL is <https://romulodrumond.com/blog-v12-preview/>. Its content
comes from its own `gh-pages` branch. It does not replace the account site's root.

`preview.yml` runs only in that exact repository on `staging`. It uses the same
Ruby, Node, Python, ImageMagick, production checks, artifact transport, and
`JamesIves/github-pages-deploy-action` as the production workflow. The production
publish job additionally requires the original repository and a push to `master`.
No cross-repository publishing token is used.

`make preview` builds `_preview` using `_config.preview.yml`, after which the
preview-only artifact step scopes legacy root-relative HTML/Markdown links to
the project path, adds `noindex, nofollow` to every HTML page, and removes `CNAME`.
Comments are disabled in preview. Authored source and the normal `_site` build
retain their production behavior. The preview validation rejects a CNAME,
indexable pages, escaped local links, missing assets, incorrect canonicals,
and AIVQ inclusion in search/sitemap. `/preview-build.json` records the source
revision used by the deployed build.

The remote check found commit `b91040f` after the migration baseline, adding
`/sheditor/privacy/`. That source is now copied unchanged and protected by a
content hash check. Original production refs recorded before staging:

- `master`: `b91040febddd29e7494f09a38d05aa78137a616d`
- `gh-pages`: `b094be7b2d59bb1c1476b197b92380b745960dcc`
- Home HTML SHA256: `9b868c547dfd74da540eab513fee153aa7f38595127d160568f6032654970108`

## Result: preview deployed and validated

The preview is live at <https://romulodrumond.com/blog-v12-preview/>. The
[GitHub Actions run](https://github.com/RomuloDrumond/blog-v12-preview/actions/runs/37391203770)
passed both build and deploy jobs for `17870fb388c28f7bb7e7a02f0adf25c03749c8a4`.
The deployed `preview-build.json` confirms that exact source revision. The
Linux runner passed 1,970 production preservation assertions, 3,129 preview
assertions, and clean migration/override audits. Workflow lint also passed locally.

The [comparison gallery](deployment-screenshots/index.html) contains **24 pairs**:
17 desktop pages (four main pages, all nine posts, Sheditor and three AIVQ pages),
plus light/dark tables, code, search, mobile home, mobile menu and a mobile article.
Twelve pairs are pixel-identical. All 17 sampled desktop layouts match exactly.
The six differing desktop captures differ only inside image regions; original
image hashes are unchanged. The focused captures also show small state-dependent
differences in the caret, selected sidebar entry, and reading-progress indicator.
The largest mean absolute channel difference across any pair is 0.262 on the
0–255 scale. This metric describes the captured viewport, not the entire page.

Capture details and limitations:

- Desktop viewports measured 1536 × 960 CSS pixels; the native browser saved
  1280 × 800 PNGs. Native viewport resizing timed out, so mobile captures use
  same-origin 390 × 844 iframes, matching the original migration procedure.
- Initial local screenshots contained capture noise. Repeating the unchanged
  home page reduced its mean channel difference from 4.419 to about 0.05.
  The final local set waits for fonts/images and a settled frame, with a warm-up
  snapshot before saving. No site CSS or content was altered to force a match.
- All nine posts and four main pages passed deployed mobile image-load and
  horizontal-overflow checks. Search returns the Spark post first and selecting
  it stays within the preview. Its pinned index still uses titles/descriptions.
  Browser text input was dispatched through the search component's normal input
  event because the background automation tab did not reliably retain typed text.
- Code bodies and copy controls are preserved. Deployed clipboard read-back
  could not be completed: the browser returned `Document is not focused`.
  The earlier local clipboard test passed; this remains a deployed interaction
  limitation rather than a claimed clipboard pass.
- All 50 HTTPS route/media checks passed, including all original media hashes.
  All 17 deployed canonical URLs and robots tags passed. All seven iframe
  sources match the originals. AIVQ remains absent from search and sitemap.
  Third-party playback and repository cards remain externally controlled.
- Staging deliberately uses a project path, site-wide `noindex`, and disabled
  comments. Final empty-baseurl production hosting, comments, and the production
  domain cutover still need their own post-deployment check.

Machine-readable evidence is in `deployment-screenshots/`: `captures.json`,
`comparison.json`, `http-checks.json` and `deployment-checks.json`. The recorded
production `master`, `gh-pages`, Pages configuration, and exact homepage SHA256
were rechecked after deployment and are **unchanged**. No push to the production
repository or merge was performed. The Docker image remains untested.

References: [GitHub project-domain behavior](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages),
[GitHub Pages API](https://docs.github.com/en/rest/pages/pages).
