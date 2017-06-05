# Markdown
set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    disable_indented_code_blocks: true,
    prettify: true,
    tables: true,
    with_toc_data: true,
    no_intra_emphasis: true

# Assets
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :fonts_dir, 'fonts'

# Activate the syntax highlighter
activate :syntax
ready do
  require './lib/multilang.rb'
end

activate :sprockets

activate :autoprefixer do |config|
  config.browsers = ['last 2 version', 'Firefox ESR']
  config.cascade  = false
  config.inline   = true
end

# Github pages require relative links
activate :relative_assets
set :relative_links, true

# Build Configuration
configure :build do
  # If you're having trouble with Middleman hanging, commenting
  # out the following two lines has been known to help
  activate :minify_css
  activate :minify_javascript
  # activate :relative_assets
  # activate :asset_hash
  # activate :gzip
end

# Deploy Configuration
# If you want Middleman to listen on a different port, you can set that below
set :port, 4567

def git_branch
  @git_branch ||=
    if ENV['GIT_BRANCH'] =~ %r{/(.*)$}
      $1
    else
      `git rev-parse --abbrev-ref HEAD`.strip
    end
end

def deploy_env
  if [nil, "master"].include? git_branch
    "dev"
  else
    git_branch
  end
end

def deploy_host
  ENV['DEPLOY_HOST'] || "edwig-#{deploy_env}.af83.priv"
end

activate :deploy do |deploy|
  deploy.deploy_method   = :sftp
  deploy.host            = deploy_host
  deploy.path            = '/var/www/edwig-docs'
end
