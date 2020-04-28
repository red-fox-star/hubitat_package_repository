module Github
  class Error < Exception
  end

  class Config
    def self.instance
      @@instance ||= new
    end

    property oauth_token = ""
  end

  abstract class Base
    Log = ::Log.for(self)

    def api_domain
      Path["https://api.github.com"]
    end

    def headers
      HTTP::Headers.new.tap do |head|
        if Config.instance.oauth_token
          head["Authorization"] = "token #{Config.instance.oauth_token}"
        end
      end
    end

    def request(url)
      Log.debug { "requesting for #{url}" }
      response = HTTP::Client.get url.to_s, headers

      check_for_rate_limit response

      if response.status_code == 200
        JSON.parse response.body
      else
        raise Error.new("API returned invalid code #{response.status_code}")
      end
    end

    def check_for_rate_limit(response)
      Log.debug { "Rate Limit Remaining: #{response.headers["X-RateLimit-Remaining"]}" }
      if response.headers["X-RateLimit-Remaining"]? == "0"
        raise Error.new("Github Rate Limited")
      end
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
