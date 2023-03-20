# frozen_string_literal: true

class UnauthorizedError < StandardError
  def initialize(error_message = nil)
    super(error_message || 'Unauthorized')
  end
end

class InvalidRequestError < StandardError
  def initialize(error_message = nil)
    super(error_message || 'Invalid request')
  end
end
