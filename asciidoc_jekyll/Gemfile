source "https://rubygems.org"

# gem "bundler"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
# gem "kramdown-parser-gfm"
gem "jekyll"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
# gem "minima", github: "jekyll/minima"
gem "minimal-mistakes-jekyll"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
gem 'jekyll-sitemap'
#group :jekyll_plugins do
    gem 'jekyll-minifier'
    gem 'jekyll-paginate-v2'
    gem 'jekyll-postfiles'
    gem 'asciidoctor-diagram'
    gem 'asciidoctor-diagram-plantuml'
    gem "jekyll-asciidoc"
    #gem "jekyll-remote-theme"
    #gem 'jekyll-typogrify'
    gem 'jekyll-analytics' # included in minima
    gem "jekyll-feed" # included in minima
    gem 'jekyll-seo-tag' # included in minima
    #gem "jekyll-archives"
#end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
    gem "tzinfo"
    gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", :platforms => [:jruby]
