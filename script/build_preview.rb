# Build a separate artifact without changing authored content or production output.
require 'fileutils'
require 'json'
require 'nokogiri'
require 'time'
require 'yaml'

Dir.chdir(File.expand_path('..', __dir__))
config = YAML.load_file('_config.preview.yml')
baseurl = config.fetch('baseurl')
abort 'Unexpected preview destination' unless baseurl == '/blog-v12-preview'
ENV['JEKYLL_ENV'] = 'production'
abort 'Preview build failed' unless system('bundle', 'exec', 'jekyll', 'build',
  '--config', '_config.yml,_config.preview.yml', '--destination', '_preview')

# Existing authored HTML and Markdown include root-relative links. Scope those
# links to this project site in the preview artifact, leaving their source intact.
prefix = lambda do |value|
  if value&.match?(%r{\A/(?!/)}) && value != baseurl && !value.start_with?("#{baseurl}/")
    "#{baseurl}#{value}"
  else
    value
  end
end
Dir['_preview/**/*.html'].each do |path|
  doc = Nokogiri::HTML(File.read(path))
  doc.css('[href], [src], [poster], [action]').each do |el|
    %w[href src poster action].each { |attr| el[attr] = prefix.call(el[attr]) if el[attr] }
  end
  doc.css('[srcset]').each do |el|
    el['srcset'] = el['srcset'].split(',').map do |candidate|
      url, *descriptor = candidate.strip.split
      [prefix.call(url), *descriptor].join(' ')
    end.join(', ')
  end
  robots = doc.at_css('meta[name=robots]') || Nokogiri::XML::Node.new('meta', doc)
  robots['name'] = 'robots'
  robots['content'] = 'noindex, nofollow'
  doc.at_css('head').add_child(robots) unless robots.parent
  File.write(path, doc.to_html)
end

# Never claim the production domain from the preview repository.
FileUtils.rm_f('_preview/CNAME')
FileUtils.touch('_preview/.nojekyll')
File.write('_preview/robots.txt', "User-agent: *\nDisallow: #{baseurl}/\n")
revision = IO.popen(['git', 'rev-parse', 'HEAD'], &:read).strip
File.write('_preview/preview-build.json', JSON.pretty_generate({
  source_revision: revision,
  built_at: Time.now.utc.iso8601,
  url: config.fetch('url') + baseurl + '/',
  purpose: 'Isolated al-folio migration deployment test'
}) + "\n")
puts "Preview artifact ready in _preview (#{revision})"
