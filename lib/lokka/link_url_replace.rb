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
        regexp = %r|\[#{suffix}:(.*?)\]|

        @@patterns << lambda do |body|
          body.force_encoding("utf-8").gsub!(regexp) { block.call($1) }
        end
      end

      def self.get_title(url)
        open(url, "r") { |o| o.read.scan(/<title>(.*)<\/title>/i).join("") } rescue url
      end

      # Example: [url:http://lokka.org]
      #   <a href="http://lokka.org">Lokka - CMS for Cloud</a>
      replace_pattarn :url do |url|
        "<a href=\"#{url}\" target=\"_blank\">#{get_title(url)}</a>"
      end

      # Example: [twitter:Daic_h]
      #   <a href=\"https://twitter.com/#!/Daic_h\" target=\"_blank\">@Daic_h</a>
      replace_pattarn :twitter do |user_name|
        "<a href=\"https://twitter.com/#!/#{user_name}\" target=\"_blank\">@#{user_name}</a>"
      end

      # Example: [tweet:133640144317198338]
      replace_pattarn :tweet do |status|
        result =
          JSON.parse(open("https://api.twitter.com/1/statuses/oembed.json?id=#{status}").read)

        <<-HTML
          #{result["html"]}
          <script src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
        HTML
      end

      # Example: [github:komagata/lokka]
      #   <a href="https://github.com/komagata/lokka" target="_blank">komagata/lokka</a>
      replace_pattarn :github do |url|
        name, repo = url.split("/")
        "<a href=\"https://github.com/#{name}/#{repo}\" target=\"_blank\">#{url}</a>"
      end

      # Example: [gist:1804145]
      #   <script src="https://gist.github.com/1804145.js?file=import_twilist.rb"></script>
      replace_pattarn :gist do |gist_id|
        "<script src=\"https://gist.github.com/#{gist_id}.js?file=import_twilist.rb\"></script>"
      end

      # Example: [atnd:18331]
      #   <a href="http://atnd.org/events/18331"target="_blank">Lokkathon #3 : ATND</a>
      replace_pattarn :atnd do |atnd_id|
        "<a href=\"http://atnd.org/events/#{atnd_id}\" target=\"_blank\">#{get_title(url)}</a>"
      end
    end
  end
end
