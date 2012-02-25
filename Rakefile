task :default => :spec

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/lib/*_spec.rb'
    spec.rspec_opts = ['-cfs']
  end
rescue LoadError => e
  warn e
end
