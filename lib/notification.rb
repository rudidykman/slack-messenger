# frozen_string_literal: true

require_relative './slack_api'

class Notification
  def initialize(message:, from_name:)
    @message = message
    @from_name = from_name
  end

  def send
    SlackApi.new.send_message(message: @message, username: @from_name)
  end
end
