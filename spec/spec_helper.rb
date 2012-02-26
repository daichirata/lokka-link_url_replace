# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path(File.dirname(__FILE__) + '/Gemfile')

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require :default if defined?(Bundler)

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'lokka/link_url_replace'

require 'webmock/rspec'

def mock_html
  @mock_html ||= open(File.expand_path(File.dirname(__FILE__) + '/mock/mock.html')).read
end

def api_mock_html
  @api_mock_html ||= open(File.expand_path(File.dirname(__FILE__) + '/mock/api_mock.html')).read
end






