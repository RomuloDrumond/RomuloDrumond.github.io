.PHONY: serve build check preview
serve:
	bundle exec jekyll serve --host 127.0.0.1

build:
	JEKYLL_ENV=production bundle exec jekyll build
	touch _site/.nojekyll

check: build
	bundle exec ruby test/migration_test.rb
	bundle exec al-folio upgrade audit
	bundle exec al-folio upgrade overrides audit

preview:
	bundle exec ruby script/build_preview.rb
	bundle exec ruby test/preview_test.rb
