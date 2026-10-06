# Hosted preview and production validation

Read the current `.github/workflows/deploy.yml`, `.github/workflows/preview.yml`, `script/build_preview.rb`, `_config.preview.yml`, `docs/PREVIEW_DEPLOYMENT.md` and `docs/PRODUCTION_DEPLOYMENT.md` before publishing. The details below describe the October 2026 setup; verify the current remote, workflow guards and Pages settings.

## Isolated hosted preview

- The separate repository is `RomuloDrumond/blog-v12-preview`, source branch `staging`, output branch `gh-pages`. Its workflow must be guarded by both repository and branch.
- GitHub project Pages inherited the account site's custom domain. The verified preview URL was `https://romulodrumond.com/blog-v12-preview/`; do not assume a github.io hostname. Verify the actual Pages configuration.
- Run `make check` then `make preview`. The latter builds `_preview`, scopes legacy root-relative links in the generated artifact, removes `CNAME`, sets site-wide `noindex, nofollow`, disables comments and runs preview-specific tests. Keep those transformations out of authored source and production `_site`.
- Validate preview path containment, assets, canonical URLs, search navigation, no CNAME, robots metadata and AIVQ exclusions. `preview-build.json` identifies the source revision for the preview artifact.
- Publish only if the current request authorizes a hosted preview. Record the production refs before publishing; recheck that production refs, Pages configuration and root content remain unchanged afterward.
- Repeat local-versus-hosted screenshots for affected routes and interactions. A project-prefix preview does not validate the production empty-baseurl cutover.

## Production release

- Publication requires authorization for this update. A request to validate locally or deploy the isolated preview does not authorize production. If permission is missing, present the checked revision, diff and preview so approval is the final step.
- Fetch current remote history again before integration. Preserve newer source content; use a normal merge/fast-forward as appropriate. Do not force-push or replace production history to make the candidate fit. Rebuild and recheck if the integrated tree changes.
- At migration, `deploy.yml` built PRs and manual runs without publishing. Production publication required repository `RomuloDrumond/RomuloDrumond.github.io`, event `push`, and branch `master`, and wrote to `gh-pages`. A push or merge to `master` is therefore a deployment action. Verify guards still enforce this separation before pushing anything.
- Run `make check`; run `actionlint` when workflows change. Validate preview tests if preview plumbing changes. Record tested source SHA and existing production source/output refs.
- After the authorized release, verify both the build/deploy workflow and the subsequent GitHub Pages publication finish successfully for the intended revision. A green build alone is not confirmation that the public domain serves it.
- Download the artifact from that exact successful run (`blog-site` in the migration workflow). Check `.nojekyll`, `CNAME`, production domain and empty-baseurl behavior. Compare HTTPS status and SHA256 of artifact files with their public URLs where practical. Directory `index.html` files should be checked through their public routes. Hidden deployment markers such as `.nojekyll` belong in the artifact check rather than a blanket public-URL requirement.
- Validate real-domain canonical/feed/archive URLs, AIVQ robots metadata and sitemap/search exclusions, and absence of preview paths. Compare screenshots against the tested local candidate using matching capture conditions; rerun affected mobile and interactive checks.
- Bound waiting by the workflow state. On failed jobs inspect the logs and stop treating the release as successful. Avoid repeated deploy attempts without understanding the failure. Do not invent success from an accepted push, old cached HTML or previous evidence.

## Evidence and limitations

Record source revision, artifact identity, workflow links, capture URL/viewport/theme/scroll state, actual interactions and any limitations. Keep source screenshots intact; normalize copies to sRGB for measurement. Compare measured geometry and rendered content alongside pixels. Animation, focus/caret state and responsive-image encoders can create legitimate differences.

The previous run compared 249 public files and 24 local-versus-production screenshot pairs, plus 13 original-site comparisons. Those counts and the reported 1,970 assertions are historical results, not thresholds to hard-code or claims to repeat for another release.

Production clipboard read-back was blocked by background-tab focus in that run; the local copy test passed. Preserve this distinction if it recurs. All seven iframe sources were retained, but that did not certify third-party playback. Docker/devcontainer execution was not tested.

Keep substantial post-release evidence on a separate non-deploying branch when useful, as `validation/al-folio-production` did, so adding screenshots does not trigger another production release. Recheck workflow guards first. Never silently publish evidence or change a deployed revision just to record a validation report.
