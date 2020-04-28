module Github
  class Repository < Base
    property slug

    def initialize(@slug : String)
      @commits = [] of Commit
      @requested_commits = false
    end

    def url
      api_domain / "repos" / slug
    end

    def name
      slug.split('/', 2)[1]
    end

    def author
      slug.split('/', 2)[0]
    end

    memo commits, [] of Commit do
      response = request(url / "commits")

      if response.is_a? Array
        [] of Commit
      else
        response.as_a.map do |commit|
          Commit.from_json commit
        end
      end
    end

    memo content, [] of Github::File do
      Content.new(repo: self, path: "").fetch
    end
  end
end
