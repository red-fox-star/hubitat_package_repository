module Github
  abstract class Base
    Log = ::Log.for(self)

    def api_domain
      Path["https://api.github.com"]
    end

    def request(url)
      Log.debug { "requesting for #{url}" }
      response = HTTP::Client.get url.to_s

      JSON.parse response.body
    end

    macro memo(name, default_value, &block)
      {%
        type = default_value
        basename = name.id
        flag = basename + "_fetched"
        value = basename + "_value"
      %}

      @{{ value }} = {{ default_value }}
      @{{ flag }} = false

      def {{ basename }}
        if @{{ flag }}
          @{{ value }}
        else
          @{{ flag }} = true
          @{{ value }} = {{ yield }}
        end
      end
    end
  end
end
