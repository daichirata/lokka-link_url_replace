module Lokka
  module LinkUrlReplace
    def self.registered(app)
      %w(posts posts/* pages pages/*).each do |suburl|
        app.before("/admin/#{suburl}") do
          if @request.env['REQUEST_METHOD'] =~ /POST|PUT/ && (body = (params[:post] && params[:post][:body]))
            body.force_encoding("utf-8").gsub!(/\[url:(.*?)\]/u){ LinkUrlReplace::Util.replace($1) }
          end
        end
      end
    end

    module Util
      require 'open-uri'

      def self.replace(url)
        title = open(url, "r"){|o| o.read.scan(/<title>(.*)<\/title>/i).join("")} rescue url
        "<a href=\"#{url}\" target=\"_blank\">#{title}</a>"
      end
    end
  end
end
