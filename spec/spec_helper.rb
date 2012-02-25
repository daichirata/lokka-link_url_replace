# -*- coding: utf-8 -*-
require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path(File.dirname(__FILE__) + '/Gemfile')

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require :default if defined?(Bundler)

require 'webmock/rspec'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'lokka/link_url_replace'

