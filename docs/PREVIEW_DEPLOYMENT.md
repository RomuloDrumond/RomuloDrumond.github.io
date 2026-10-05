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

Local checks: 1,970 production preservation assertions, 3,129 preview assertions,
clean migration/override audits, and clean workflow lint. Remote build and
local-versus-deployed screenshot results will be recorded after publication of
the isolated preview. Production root deployment remains outside this test.

References: [GitHub project-domain behavior](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages),
[GitHub Pages API](https://docs.github.com/en/rest/pages/pages).
