# frozen_string_literal: true

SPAM_NOTIFICATION_TYPE = 'SpamNotification'

class InvalidRequestError < StandardError
end

def validate_request_body(body)
  required_fields = %w[Type Description Email]
  required_fields.each do |required_field|
    raise InvalidRequestError.new("Missing required paramater '#{required_field}'.") if body[required_field].nil?
  end

  unless body['Type'] == SPAM_NOTIFICATION_TYPE
    raise InvalidRequestError.new("Alerts are only sent reports of type '#{SPAM_NOTIFICATION_TYPE}'.")
  end
end
