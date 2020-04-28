module Github
  class Commit < Base

    property sha : String
    property message : String
    property tree : Tree
    property author : Person
    property committer : Person
    property date : String

    def self.from_json(json)
      new(
        sha: json["sha"].as_s,
        message: json["commit"]["message"].as_s,
        tree: Tree.from_json(json["commit"]["tree"]),
        author: Person.from_json(json["commit"]["author"]),
        committer: Person.from_json(json["commit"]["committer"]),
        date: json["commit"]["committer"]["date"].as_s
      )
    end

    def initialize(@sha, @message, @tree, @author, @committer, date)
      @date = date.split('T')[0]
    end

    def inspect(io : IO)
      io << "<Github::Commit "
      io << sha[0..8]
      io << " by: "
      io << author
      io << "; message: "
      io << message
      io << ">"
      io
    end
  end
end
