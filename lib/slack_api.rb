# frozen_string_literal: true

class SlackApi
  def initialize
    @initialized = true
  end

  def send_message(message)
    puts "Sending Slack message: #{message}"
  end
end
