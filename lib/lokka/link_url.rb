module Lokka
  module LinkUrl
    def self.registered(app)
      app.before do
        if body = (params[:post] && params[:post][:body])
          body.force_encoding("utf-8").gsub!(/\[url:(.*?)\]/u){ LinkUrl::Util.link($1) }
        end
      end
    end

    module Util
      require 'open-uri'

      def self.link(url)
#        title = URI.parse(url)).body.scan(/<title>(.*)<\/title>/i).join("").force_encoding("utf-8")
        title = open(url, "r"){|o| o.read.scan(/<title>(.*)<\/title>/i).join("")} rescue url
        "<a href=\"#{url}\" target=\"_blank\">#{title}</a>"
      end
    end
  end
end
