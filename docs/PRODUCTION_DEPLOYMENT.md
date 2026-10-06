# Production deployment and screenshot validation

The migration is live at **https://romulodrumond.com/**. Production deployment and validation completed October 5, 2026 in Fortaleza (October 6 UTC), after explicit authorization to publish to production.

Open the [comparison gallery](production-screenshots/index.html): 24 local-versus-production pairs and 13 original-site-versus-production comparisons, using the actual personal content. No upstream demo screenshots are used.

## Published revision

- Source: [`db4f37174e4fc6c31c51fd2978a4d879e71ea36a`](https://github.com/RomuloDrumond/RomuloDrumond.github.io/commit/db4f37174e4fc6c31c51fd2978a4d879e71ea36a), on `master` and local `release/al-folio-v1.2`.
- Pages output: `c72768e5a2edfa9e1f95e7372c730d14d7dae2fe` on `gh-pages`.
- [Build/deploy run 37398244331](https://github.com/RomuloDrumond/RomuloDrumond.github.io/actions/runs/37398244331) and [Pages publication run 37398389036](https://github.com/RomuloDrumond/RomuloDrumond.github.io/actions/runs/37398389036): successful.
- Validated artifact: `blog-site`, ID `11384441537`, from the production build.

The release joins the reviewed migration with the existing production history, preserving newer Sheditor work from `b91040f`. Its tree is identical to the reviewed `f9385d3` tree; merging the history introduced no content or runtime changes. Production was updated with a regular fast-forward push, without force pushing. `CNAME` remains `romulodrumond.com`; `baseurl` remains empty. The separate preview repository is retained.

Before publication, the production source was `b91040febddd29e7494f09a38d05aa78137a616d` and Pages was `b094be7b2d59bb1c1476b197b92380b745960dcc`. The old homepage still had SHA256 `9b868c547dfd74da540eab513fee153aa7f38595127d160568f6032654970108`, matching the earlier baseline. These references identify the pre-migration state; no rollback was performed.

## Validation results

- Local and Linux CI `make check`: **1,970 preservation assertions passed**. Upstream migration audit: zero blocking and non-blocking findings. The sole layout override is acknowledged. Workflow lint and whitespace checks passed before publishing.
- Downloaded the exact Actions artifact and fetched all **249 publicly served files** through clean production HTTPS URLs. Every response was HTTP 200 and every SHA256 matched the artifact. This covers all 48 HTML pages, article/page/archive URLs, feed, sitemap, styles, scripts and media. The artifact also contains `.nojekyll`.
- All 17 desktop screenshot routes have matching sampled element geometry against local references, decoded images and no page overflow. The nine articles and four main pages also pass native 390 × 844 mobile checks. Three fresh mobile screenshot pairs have matching geometry.
- The 9 posts, 24 original post images, biography/profile/quote/socials, one publication, four repositories and all 7 iframe sources are preserved. Production retains the 24 code-copy controls and seven article sidebars. All original media bytes pass the preservation checks.
- All 17 checked page canonicals point to the original production URLs, with no preview prefix. Feed and archive files are included in the complete artifact hash verification. The AIVQ routes retain `noindex, nofollow` and are excluded from sitemap and search data.
- Search for “Spark” returns the article, and selecting it navigates to the production article URL. The mobile menu opens/closes and exposes only about, blog, publications and repositories. Light/dark switching preserves the green table header (`rgb(0, 152, 121)`).
- A TOC link navigates to the retained section anchor; the heading settles 80 CSS pixels below the top. Reading progress equals the current scroll position. Image zoom emits `open`, `opened`, `close`, and `closed`, and removes its overlay. Two time-separated GIF screenshots differ only within the visible GIF region; the original animation retains 229 frames.

See [artifact hashes](production-screenshots/artifact-checks.json), [metadata checks](production-screenshots/metadata-checks.json), [capture/interaction records](production-screenshots/captures.json), [pixel comparisons](production-screenshots/comparison.json) and [build checks](production-screenshots/checks.txt).

## Screenshot method and differences

The 17 desktop and seven focused comparisons cover the four main pages, all nine articles, Sheditor privacy, the three AIVQ routes, light/dark tables, code, search, mobile home/menu/article. The 13 original-site screenshots remain the pre-migration baseline. Desktop local references come from the reviewed tree; a fresh rebuilt local homepage reproduced its reference exactly. Mobile local and production screenshots were captured afresh.

Desktop viewports are 1536 × 960 CSS pixels, saved as 1280 × 800 PNGs. Mobile uses native 390 × 844 responsive viewports, saved as 780 × 1688 PNGs; this pass does not use the earlier iframe harness. These are viewport captures, not full-page screenshots. Fonts and images were allowed to settle. Browser-cache responses from the old deployment were refreshed before capture. When the browser's save operation failed, the PNG returned by the same native screenshot tool was written unchanged to disk.

The browser embedded different ICC color profiles in the two desktop sets. Pixel measurement converts each original PNG to sRGB before comparison; the evidence PNGs remain unchanged. One pair is pixel-identical; the largest mean RGB channel difference is **0.710 on the 0–255 scale**. The remaining differences include responsive-image encoding from macOS versus Linux, color conversion/rounding and transient caret/sidebar/progress/back-to-top states. For example, the original profile JPEG is identical but generated WebP hashes differ. No visual regression was observed in the checked routes and states. Matching sampled geometry and artifact hashes provide additional evidence beyond the screenshots.

## Remaining limits

Production clipboard read-back is blocked by the collaborative browser's background-tab focus restriction (`Document is not focused`). The earlier local copy test succeeded, and deployed code assets match the successful build, but production clipboard contents could not be independently read. Some hidden-tab UI actions required dispatching a click/input event on the real element and taking a rendering snapshot for CSS transitions to finish; this was recorded rather than treating a tool's click acknowledgement as proof.

External iframe playback and repository-card availability depend on their providers. All seven iframe sources are preserved, but this is not a video-playback certification. No current post opts into comments, so there is no existing comments embed to test; the production Disqus setting remains intact. Docker/devcontainer execution remains untested.

The post-deployment report and screenshots are maintained on `validation/al-folio-production`; publishing this evidence branch does not trigger the master-only deployment workflow or change the validated production revision.
