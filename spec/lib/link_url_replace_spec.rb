require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lokka::LinkUrlReplace do
  it "" do
    stub_request(:get, "example.com").to_return(:body => "something")

    uri = URI.parse("http://example.com")
    result = Net::HTTP.get(uri).should == "something"
  end
end

