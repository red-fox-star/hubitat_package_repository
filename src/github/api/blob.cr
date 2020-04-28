require "base64"

module Github
  class Blob < Base
    property path : String
    property sha : String
    property url : String
    property size : Int32
    property mode : String

    def self.from_json(json)
      new(
        path: json["path"].as_s,
        sha: json["sha"].as_s,
        url: json["url"].as_s,
        size: json["size"].as_i,
        mode: json["mode"].as_s
      )
    end

    def initialize(@path, @sha, @url, @size, @mode)
    end

    memo contents, "" do
      Base64.decode_string request(url)["content"].as_s
    end

    def url
      ""
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
  end
end
