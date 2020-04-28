module Github
  class Tree < Base
    property sha : String
    property url : String

    def self.from_json(json)
      new(
        json["sha"].as_s,
        json["url"].as_s
      )
    end

    def initialize(@sha, @url)
      @entries = [] of Blob
      @entries_fetched = false
    end

    def inspect(io : IO)
      io << "<Github::Tree "
      io << sha[0..8]
      io << ">"
      io
    end

    memo entries, [] of Blob do
      response = request url
      response["tree"].as_a.map do |entry|
        Blob.from_json entry
      end
    end
  end
end
