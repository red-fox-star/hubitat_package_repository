module Hubitat
  class File
    def self.from(github file)
      definition = Definition.from_source file.content

      if definition
        return new definition, url: file.download_url
      else
        raise "Could not parse file... is it a hubitat driver or application?"
      end
    end

    property url

    def initialize(@definition : Definition, @url : String)
    end

    delegate namespace, author, name, driver?, app?, to: @definition

    def inspect(io : IO)
      io << "<Hubitat::#{self.class.name}"
      io << " "
      io << namespace
      io << "."
      io << name
      io << " by: "
      io << author
      io << ">"
    end
  end
end
