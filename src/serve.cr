require "dotenv"
Dotenv.load if File.exists? ".env"

require "kemal"
require "markd"

require "base64"
require "digest"
require "http"
require "json"
require "log"

require "./hubitat/*"
require "./github/*"
require "./manifest_cache"

cache = ManifestCache.new(cache: Kemal.config.env == "production")

Log.builder.bind "*", :debug, Log::IOBackend.new

Github::Config.instance.oauth_token = ENV["PERSONAL_ACCESS_TOKEN"]? || ""

def github_redirect(path)
  new_path = Path["/g"]
  new_path /= path.gsub("/tree/master","")
  new_path.to_s
end

readme = File.read("readme.md")
readme_html = Markd.to_html(readme)

get "/" do
  readme_html
end

get "/g/:user/:repo/*path" do |env|
  github_slug = "#{env.params.url["user"]}/#{env.params.url["repo"]}"
  path = URI.encode env.params.url["path"]

  env.response.content_type = "application/json"

  cache.get_or_set "#{github_slug}/#{path}" do
    Log.warn { "Cache miss for #{github_slug}" }
    generator = PackageManifest.new github_slug, path
    generator.manifest
  end

rescue e : Github::Error
  halt env, status_code: 400, response: "Failed to query github api for details: #{env.params.url} - #{e.message}"
end

get "/https:/github.com/*path" do |env|
  env.redirect github_redirect env.params.url["path"]
end

serve_static false

Kemal.run(
  (ENV["PORT"]? || 3000).to_i
)
