module Github
  class Directory < Base
    def self.from_json(json)
      new(
        name: json["name"].as_s,
        path: json["path"].as_s,
        sha: json["sha"].as_s
      )
    end

    def initialize(
      @name : String,
      @path : String,
      @sha : String
    )
    end

  # {
  #   "type": "dir",
  #   "size": 0,
  #   "name": "octokit",
  #   "path": "lib/octokit",
  #   "sha": "a84d88e7554fc1fa21bcbc4efae3c782a70d2b9d",
  #   "url": "https://api.github.com/repos/octokit/octokit.rb/contents/lib/octokit",
  #   "git_url": "https://api.github.com/repos/octokit/octokit.rb/git/trees/a84d88e7554fc1fa21bcbc4efae3c782a70d2b9d",
  #   "html_url": "https://github.com/octokit/octokit.rb/tree/master/lib/octokit",
  #   "download_url": null,
  #   "_links": {
  #     "self": "https://api.github.com/repos/octokit/octokit.rb/contents/lib/octokit",
  #     "git": "https://api.github.com/repos/octokit/octokit.rb/git/trees/a84d88e7554fc1fa21bcbc4efae3c782a70d2b9d",
  #     "html": "https://github.com/octokit/octokit.rb/tree/master/lib/octokit"
  #   }
  # }
  end
end
