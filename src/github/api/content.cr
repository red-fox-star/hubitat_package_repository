module Github
  class Content < Base
    def initialize(@repo : Repository, @path : String)
      @entries = [] of File | Directory
    end

    def fetch
      response = request api_domain / "repos" / @repo.slug / "contents"

      response.as_a.map do |entry|
        case entry["type"]
        when "file"
          Github::File.from_json entry
        when "dir"
          Github::Directory.from_json entry
          nil
        else
          nil
        end
      end.compact
    end

    def inspect(io : IO)
      io << "<Github::Content "
      io << " #{@entries.size} entries"
      io << ">"
      io
    end
  end
end
