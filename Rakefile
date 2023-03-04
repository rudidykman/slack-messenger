# frozen_string_literal: true

require_relative 'lib/handler'
require_relative 'lib/slack_api'

task :test do
  ENV['RUBY_ENV'] = 'test'
  ruby 'test/handler_test.rb'
end

task :invoke do
  payload = File.open('payload.json').read
  handler(event: { 'body' => payload }, context: {})
end

task :channel_id, [:channel_name] do |_task, args|
   channel = SlackApi.new.channels.find { |c| c['name'] == args[:channel_name] }
   puts channel['id']
end
