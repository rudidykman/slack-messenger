# frozen_string_literal: true

require_relative 'lib/handler'
require_relative 'lib/helpers'

task :test do
  ENV['RUBY_ENV'] = 'test'
  ruby 'test/handler_test.rb'
end

task :invoke do
  payload = File.open('payload.json').read
  alert(event: { 'body' => payload }, context: {})
end

task :get_channel_id, [:channel_name] do |task, args|
  get_channel_id(args[:channel_name])
end
