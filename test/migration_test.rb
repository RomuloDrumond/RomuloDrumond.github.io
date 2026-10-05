# Run after `make build`: bundle exec ruby test/migration_test.rb
# The fixture records routes, media and code from the pre-migration 154712e.
require 'json'
require 'digest'
require 'nokogiri'
require 'uri'
require 'yaml'

root = File.expand_path('..', __dir__)
Dir.chdir(root)
baseline = JSON.parse(File.read('test/migration-baseline.json'))
failures = []
checks = 0
check = lambda do |condition, message|
  checks += 1
  failures << message unless condition
end
read_page = lambda do |url|
  path = File.join('_site', url.delete_prefix('/'), 'index.html')
  check.call(File.file?(path), "Missing route: #{url}")
  Nokogiri::HTML(File.file?(path) ? File.read(path) : '')
end
canonical = lambda do |page, url|
  check.call(page.at_css('link[rel=canonical]')&.[]('href') == "https://romulodrumond.com#{url}", "Canonical changed: #{url}")
end
normalize = ->(text) { text.strip.gsub(/\s+/, ' ') }

check.call(Dir['_posts/*.md'].size == 9, 'Expected nine authored posts')
check.call(Dir['assets/img/posts/**/*'].count { |p| File.file?(p) } == 24, 'Expected 24 post images')
check.call(Digest::SHA256.file('_pages/sheditor-privacy.md').hexdigest == '6e45412eba1216f09252bcebefca383b75041db88a4cf8365ea8f7c8559d477d', 'Sheditor policy changed from remote b91040f')
canonical.call(read_page.call('/sheditor/privacy/'), '/sheditor/privacy/')
check.call(File.file?('_site/.nojekyll'), 'Generated Pages site must bypass a second Jekyll build')
baseline['assets'].merge(baseline['aivq']).each do |path, sha|
  check.call(File.file?(path) && Digest::SHA256.file(path).hexdigest == sha, "Original content changed: #{path}")
end
baseline['assets'].each do |path, sha|
  generated = File.join('_site', path)
  check.call(File.file?(generated) && Digest::SHA256.file(generated).hexdigest == sha, "Original asset not published intact: #{path}")
end

baseline['posts'].each do |post|
  page = read_page.call(post['url'])
  canonical.call(page, post['url'])
  check.call(page.at_css('.post-title')&.text == post['title'], "Post title changed: #{post['url']}")
  check.call(page.css('iframe').map { |e| e['src'] } == post['iframes'], "Iframe changed: #{post['url']}")
  post['heading_ids'].each do |id|
    check.call(page.at_xpath("//*[@id=#{id.inspect}]"), "Heading anchor missing: #{post['url']}##{id}")
  end
  code_blocks = page.css('pre').reject { |e| e.ancestors.any? { |a| a['class'].to_s.split.include?('gutter') } }.map { |e| normalize.call(e.text) }
  post['code'].each do |code|
    check.call(code_blocks.include?(normalize.call(code)), "Code block changed: #{post['url']} (#{code.lines.first&.strip})")
  end
  post['figures'].each do |figure|
    img = page.css('img').find { |e| e['src'] == "/#{figure['path']}" }
    check.call(img, "Missing figure: #{figure['path']}")
    next unless img
    check.call(img['width'] == (figure['width'] || 'auto'), "Figure width changed: #{figure['path']}")
    check.call(img.key?('data-zoomable'), "Zoom disabled: #{figure['path']}")
    caption = img.ancestors('figure').first&.at_css('figcaption')&.text
    expected_caption = Nokogiri::HTML.fragment(figure['caption'].to_s).text
    check.call(normalize.call(caption.to_s) == normalize.call(expected_caption), "Caption changed: #{figure['path']}")
    if figure['path'].end_with?('.gif')
      check.call(img.parent.css('source').empty?, 'Animated GIF must use its original file')
    end
  end
  Array(post['tags']).each do |tag|
    slug = tag.downcase.gsub(/[^\p{Alnum}]+/, '-').sub(/-$/, '')
    canonical.call(read_page.call("/blog/tag/#{slug}/"), "/blog/tag/#{slug}/")
  end
end

%w[/ /blog/ /blog/page/2/ /blog/2022/ /blog/2023/ /blog/2025/ /publications/ /repositories/].each do |url|
  canonical.call(read_page.call(url), url)
end

search = read_page.call('/').css('script').map(&:text).select { |text| text.include?('ninja.data') }.join
check.call(!search.empty?, 'Inline search data was not generated')
sitemap = File.read('_site/sitemap.xml')
(%w[/aivq-media-store/ /aivq-media-store/privacy/ /aivq-media-store/terms/ /cv/ /projects/ /teaching/] + baseline['retired_routes']).each do |url|
  page = read_page.call(url)
  canonical.call(page, url)
  check.call(page.at_css('meta[name=robots]')&.[]('content') == 'noindex, nofollow', "Missing noindex: #{url}")
  check.call(!sitemap.include?("https://romulodrumond.com#{url}"), "Unlisted route in sitemap: #{url}")
  check.call(!search.include?(url), "Unlisted route in search: #{url}")
end
baseline['posts'].each { |p| check.call(search.include?(p['url']), "Post missing from search: #{p['url']}") }

home = read_page.call('/')
nav = home.css('#navbar a.nav-link').map { |e| e['href'] }
check.call(nav == %w[/ /blog/ /publications/ /repositories/], "Navigation changed: #{nav.inspect}")
check.call(home.text.include?(%q[Don't forget to think about people; in the end, it's all about them.]), 'Profile quote missing')
check.call(home.css('a').any? { |e| e['href'] == 'https://www.linkedin.com/in/romulo-drumond' }, 'Biography LinkedIn link broken')
check.call(home.css('.contact-icons a').size == 4, 'Expected four social links')
check.call(home.css('.contact-icons a').none? { |e| e['href'].to_s.include?('feed.xml') }, 'RSS icon should remain hidden')

publication = read_page.call('/publications/')
check.call(publication.css('.bibliography > li').size == 1, 'Expected exactly one publication')
check.call(publication.text.include?('Pattern classification based on regional models'), 'Genuine publication missing')
check.call(publication.css('a').any? { |a| a['href'] == 'https://doi.org/10.1016/j.asoc.2022.109592' }, 'Publication DOI link is malformed')
repos = read_page.call('/repositories/')
YAML.load_file('_data/repositories.yml')['github_repos'].each do |repo|
  check.call(repos.css('a').any? { |e| e['href'] == "https://github.com/#{repo}" }, "Missing curated repository: #{repo}")
end
feed = Nokogiri::XML(File.read('_site/feed.xml'))
feed.remove_namespaces!
check.call(feed.css('entry').size == 9, 'Feed must retain nine posts')
baseline['posts'].each do |post|
  check.call(feed.css('entry link').any? { |e| e['href'] == "https://romulodrumond.com#{post['url']}" }, "Post missing from feed: #{post['url']}")
end

# Check every generated local asset/link, including responsive images and archive links.
Dir['_site/**/*.html'].each do |path|
  page = Nokogiri::HTML(File.read(path))
  check.call(!page.text.match?(/Albert Einstein|Brownian Movement/), "Inherited demo in #{path}")
  check.call(!page.to_html.include?('polyfill.io'), "Obsolete polyfill in #{path}")
  page.css('[src], link[href], a[href], source[srcset]').each do |el|
    refs = [el['src'], el['href']]
    refs += el['srcset'].to_s.split(',').map { |v| v.strip.split.first }
    refs.compact.grep(%r{\A/(?!/)}).each do |ref|
      target = File.join('_site', URI::DEFAULT_PARSER.unescape(ref.split(/[?#]/).first.delete_prefix('/')))
      exists = File.file?(target) || File.file?(File.join(target, 'index.html'))
      check.call(exists, "Broken local reference #{ref} in #{path}")
    end
  end
end
abort failures.uniq.join("\n") unless failures.empty?
puts "Migration checks passed (#{checks} assertions): routes, content, images, code, embeds, canonicals, feed, archives, AIVQ, search and local links."
