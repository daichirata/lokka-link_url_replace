require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lokka::LinkUrlReplace do
  subject { Lokka::LinkUrlReplace::Replace }

  describe "[url:url]" do
    it "should be expanded" do
      stub_request(:get, "example.com").to_return(:body => mock_html)

      subject.replace!("[url:http://example.com]")
        .should eq("<a href=\"http://example.com\" target=\"_blank\">Mock Title</a>")
    end
  end

  describe "[twitter:twitter_id]" do
    it "should be expanded" do
      subject.replace!("[twitter:Example]")
        .should eq("<a href=\"https://twitter.com/#!/Example\" target=\"_blank\">@Example</a>")
    end
  end

  describe "[tweet:tweet_status_id]" do
    it "should be expanded" do
      stub_request(:get, "https://api.twitter.com/1/statuses/oembed.json?id=133640144317198338").to_return(:body => api_mock_html)

      subject.replace!("[tweet:133640144317198338]").should eq <<-JSON
          #{ JSON.parse(api_mock_html)['html'] }
          <script src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
      JSON
    end
  end

  describe "[github:repository_info]" do
    it "should be expanded" do
      subject.replace!("[github:daic-h/lokka-link_url_replace]")
        .should eq("<a href=\"https://github.com/daic-h/lokka-link_url_replace\" target=\"_blank\">daic-h/lokka-link_url_replace</a>")
    end
  end

  describe "[gist:gist_id]" do
    it "should be expanded" do
      subject.replace!("[gist:1000]")
        .should eq("<script src=\"https://gist.github.com/1000.js?file=import_twilist.rb\"></script>")
    end
  end

  describe "[atnd:atnd_ai]" do
    it "should be expanded" do
      stub_request(:get, "http://atnd.org/events/1000").to_return(:body => mock_html)

      subject.replace!("[atnd:1000]")
        .should eq("<a href=\"http://atnd.org/events/1000\" target=\"_blank\">Mock Title</a>")
    end
  end
end

