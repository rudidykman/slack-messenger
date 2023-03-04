# frozen_string_literal: true

require_relative 'slack_api'

def get_channel_id(channel_name)
  channels = SlackApi.new.get_channels
  channels.each do |channel|
    if channel['name'] == channel_name
      puts channel['id']
      return
    end
  end
end
