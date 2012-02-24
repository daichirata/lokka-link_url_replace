module Lokka
  module LinkUrlReplace
    def self.registered(app)
      %w(posts posts/* pages pages/*).each do |sub_url|
        app.before("/admin/#{sub_url}") do
          if request.request_method =~ /POST|PUT/ && (body = (params[:post] && params[:post][:body]))
            Replace.replace!(body)
          end
        end
      end
    end

    module Replace
      require 'open-uri'

      @@patterns = []

      def self.replace!(body)
        @@patterns.each do |pattern|
          pattern.call(body)
        end
      end

      def self.replace_pattarn(suffix, &block)
        regexp = Regexp.compile("[#{suffix}:(.*?)\]", nil, "u")

        @@patterns << lambda do |body|
          body.force_encoding("utf-8").gsub!(regexp) { block.call($1) }
        end
      end

      # Example:
      #   [url:http://lokka.org]
      #
      #   <a href="http://lokka.org">Lokka - CMS for Cloud</a>
      #
      replace_pattarn :url do |url|
        title = open(url, "r") { |o| o.read.scan(/<title>(.*)<\/title>/i).join("") } rescue url
        "<a href=\"#{url}\" target=\"_blank\">#{title}</a>"
      end

      # Example:
      #   [github:komagata/lokka]
      #
      #   <a href="https://github.com/komagata/lokka" target="_blank">komagata/lokka</a>
      #
      replace_pattarn :github do |url|
        name, repo = url.split("/")
        "<a href=\"https://github.com/#{name}/#{repo}\" target=\"_blank\">#{url}</a>"
      end

      #
      # [TODO]
      #
      # Example:
      #   [twitter:Daic_h]
      #
      #   <a href="https://github.com/komagata/lokka" target="_blank">komagata/lokka</a>
      #

      #
      # [TODO]
      #
      # Example:
      #   [gist:1804145]
      #
      #   <script src="https://gist.github.com/1804145.js?file=import_twilist.rb"></script>
      #
    end
  end
end
