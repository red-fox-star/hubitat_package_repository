module Github
  class Person < Base
    property name : String
    property email : String

    def self.from_json(json)
      new(
        json["name"].as_s,
        json["email"].as_s
      )
    end

    def initialize(@name, @email)
    end

    def inspect(io : IO)
      io << "<Github::Person \""
      io << name
      io << "\" "
      io << email
      io << ">"
      io
    end
  end
end
