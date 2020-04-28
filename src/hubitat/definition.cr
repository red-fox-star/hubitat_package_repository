module Hubitat
  class Definition
    property name : String
    property author : String
    property namespace : String

    def self.from_source(file) : Definition?
      # locate the definition method
      start_of_definition = file.index "definition"
      return nil if start_of_definition.nil?

      # locate the ( after the definition method
      open_parenthesis = file.index "(", start_of_definition
      return nil unless open_parenthesis
      open_parenthesis += 1

      # weakly locate the end of the definition method
      close_parenthesis = file.index ")", start_of_definition
      return nil if close_parenthesis.nil?

      definition_block = file[open_parenthesis...close_parenthesis]

      # attempt to convert the definition block into a hash
      definition_hash = definition_block
        .gsub("\n","")
        .split(",").map do |keyvalue|
          keyvalue
            .gsub("\"","")
            .split(':', 2)
            .map(&.strip)
        end.to_h

      instance = new(
        name: definition_hash["name"],
        namespace: definition_hash["namespace"],
        author: definition_hash["author"]
      )

      manifest = file.index "manifest"
      instance.driver! if manifest && manifest < start_of_definition

      instance

    rescue KeyError
      return nil
    end

    def initialize(@name, @author, @namespace)
      @driver = false
    end

    def driver!
      @driver = true
    end

    def driver?
      @driver
    end

    def app?
      ! @driver
    end
  end
end
