.PHONY: serve build check
serve:
	bundle exec jekyll serve --host 127.0.0.1

build:
	JEKYLL_ENV=production bundle exec jekyll build
	touch _site/.nojekyll

check: build
	bundle exec ruby test/migration_test.rb
	bundle exec al-folio upgrade audit
	bundle exec al-folio upgrade overrides audit
