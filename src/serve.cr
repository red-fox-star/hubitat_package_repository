require "kemal"

require "base64"
require "digest"
require "http"
require "json"
require "log"

require "./hubitat/*"
require "./github/*"
require "./manifest_cache"

cache = ManifestCache.new

Log.builder.bind "*", :debug, Log::IOBackend.new 

get "/" do
  "hello world"
end

get "/gh/:user/:repo/*path" do |env|
  github_slug = "#{env.params.url["user"]}/#{env.params.url["repo"]}"
  path = env.params.url["path"]

  cache.get_or_set github_slug do
    Log.warn { "Cache miss for #{github_slug}" }
    generator = PackageManifest.new github_slug
    generator.manifest
  end
end

Kemal.run
