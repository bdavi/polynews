# frozen_string_literal: true

# Validator which ensures an attribute is a valid url
#
# Example usage:
# validates :attribute, url: true
#
# With custom message:
# validates :attribute, url: { message: 'some message' }
#
# When allowing nil:
# validates :attribute, url: { allow_nil: true }
class UrlValidator < ActiveModel::EachValidator
  DEFAULT_MESSAGE = 'is an invalid URL'

  VALID_URI_KINDS = [URI::HTTP, URI::HTTPS].freeze

  attr_reader :_message, :_allow_nil

  def initialize(options)
    @_message = options[:message] || DEFAULT_MESSAGE
    @_allow_nil = options[:allow_nil] || false
    super
  end

  def validate_each(record, attribute, value)
    return if _allow_nil && value.nil?
    return if _valid_url?(value)

    record.errors[attribute] << _message
  end

  private

  def _valid_url?(value)
    uri = begin
      URI.parse(value)
    rescue URI::InvalidURIError
      false
    end

    VALID_URI_KINDS.include?(uri.class)
  end
end
