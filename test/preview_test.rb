# Assert that the artifact cannot claim production's domain or link out of staging.
require 'digest'
require 'json'
require 'nokogiri'
require 'uri'
require 'yaml'

Dir.chdir(File.expand_path('..', __dir__))
config = YAML.load_file('_config.preview.yml')
prefix = config.fetch('baseurl')
origin = config.fetch('url')
failures = []
checks = 0
check = lambda do |condition, message|
  checks += 1
  failures << message unless condition
end
check.call(!File.exist?('_preview/CNAME'), 'Preview must not contain CNAME')
check.call(File.file?('_preview/.nojekyll'), 'Preview must bypass GitHub Jekyll rebuild')
baseline = JSON.parse(File.read('test/migration-baseline.json'))
baseline['assets'].reject { |path, _| path == 'CNAME' }.each do |path, hash|
  check.call(File.file?("_preview/#{path}") && Digest::SHA256.file("_preview/#{path}").hexdigest == hash, "Preview asset changed: #{path}")
end
baseline['posts'].each do |post|
  path = "_preview#{post['url']}index.html"
  check.call(File.file?(path), "Missing preview article: #{post['url']}")
end

Dir['_preview/**/*.html'].each do |path|
  doc = Nokogiri::HTML(File.read(path))
  check.call(doc.at_css('meta[name=robots]')&.[]('content') == 'noindex, nofollow', "Preview is indexable: #{path}")
  canonical = doc.at_css('link[rel=canonical]')&.[]('href')
  check.call(canonical&.start_with?("#{origin}#{prefix}/"), "Wrong preview canonical: #{path}")
  check.call(!doc.to_html.include?('disqus.com/embed.js'), "Production comments active: #{path}")
  doc.css('[href], [src], [srcset], [poster], [action]').each do |el|
    refs = %w[href src poster action].filter_map { |attr| el[attr] }
    refs += el['srcset'].to_s.split(',').map { |v| v.strip.split.first }
    refs.compact.grep(%r{\A/(?!/)}).each do |ref|
      check.call(ref.start_with?("#{prefix}/"), "Link escapes preview: #{ref} in #{path}")
      target = URI::DEFAULT_PARSER.unescape(ref.split(/[?#]/).first.delete_prefix(prefix))
      check.call(File.file?("_preview#{target}") || File.file?("_preview#{target}/index.html"), "Missing preview link: #{ref}")
    end
  end
end
home = Nokogiri::HTML(File.read('_preview/index.html'))
search = home.css('script').map(&:text).find { |s| s.include?('ninja.data') }
check.call(search && !search.include?('/aivq-media-store/'), 'AIVQ appears in preview search')
baseline['posts'].each do |post|
  check.call(search&.include?("#{prefix}#{post['url']}"), "Search leaves preview: #{post['url']}")
end
sitemap = File.read('_preview/sitemap.xml')
check.call(!sitemap.include?('/aivq-media-store/'), 'AIVQ appears in preview sitemap')
feed = Nokogiri::XML(File.read('_preview/feed.xml')).remove_namespaces!
check.call(feed.css('entry').length == 9, 'Preview feed lost articles')
feed.css('entry link').each do |link|
  check.call(link['href'].start_with?("#{origin}#{prefix}/blog/"), 'Feed links outside preview')
end
abort failures.uniq.join("\n") unless failures.empty?
puts "Preview checks passed (#{checks} assertions): isolation, noindex, routes, media, links, search and feed."
