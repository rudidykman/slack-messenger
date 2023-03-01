# frozen_string_literal: true

require_relative './slack_api'

class SpamNotification
  def initialize(description, email)
    @description = description
    @email = email
  end

  def send_alert
    message = "Spam report received for email #{@email}. Description: '#{@description}'."
    SlackApi.new.send_message(message)
  end
end
