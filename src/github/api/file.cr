module Github
  class File < Base
    def self.from_json(json)
      new(
        name: json["name"].as_s,
        path: json["path"].as_s,
        sha: json["sha"].as_s,
        url: json["url"].as_s,
        size: json["size"].as_i,
        download_url: json["download_url"].as_s
      )
    end

    property name, path, sha, size, url, download_url

    def initialize(
      @name : String,
      @path : String,
      @sha : String,
      @url : String,
      @size : Int32,
      @download_url : String,
    )
      @content = ""
    end

    memo content, "" do
      @content = Base64.decode_string request(@url)["content"].as_s
    end

    def inspect(io : IO)
      io << "<Github::"
      io << self.class.name
      io << ' '
      io << path
      io << ' '
      io << size
      io << ">"
      io
    end
# {
#   "type": "file",
#   "encoding": "base64",
#   "size": 5362,
#   "name": "README.md",
#   "path": "README.md",
#   "content": "encoded content ...",
#   "sha": "3d21ec53a331a6f037a91c368710b99387d012c1",
#   "url": "https://api.github.com/repos/octokit/octokit.rb/contents/README.md",
#   "git_url": "https://api.github.com/repos/octokit/octokit.rb/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
#   "html_url": "https://github.com/octokit/octokit.rb/blob/master/README.md",
#   "download_url": "https://raw.githubusercontent.com/octokit/octokit.rb/master/README.md",
#   "_links": {
#     "git": "https://api.github.com/repos/octokit/octokit.rb/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
#     "self": "https://api.github.com/repos/octokit/octokit.rb/contents/README.md",
#     "html": "https://github.com/octokit/octokit.rb/blob/master/README.md"
#   }
# }
  end
end
