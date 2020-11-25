# frozen_string_literal: true

module Matchers
  # Tests that an attribute is being validated as an url.
  #
  # Basic usage:
  # it { is_expected.to validate_url_format_of :url }
  #
  # When allowing blank:
  # it { is_expected.to validate_url_format_of(:url).allow_blank }
  #
  # With a custom message
  # it { is_expected.to validate_url_format_of(:url).with_message('message') }
  def validate_url_format_of(attr)
    ValidateUrlFormatOfMatcher.new(attr)
  end

  class ValidateUrlFormatOfMatcher
    INVALID_URLS = [
      '...example',
      'example.',
      'example.com',
      'htp://example',
      'http://examp   le.com',
      'ftp://example.com/some-file.txt'
    ].freeze

    DEFAULT_ATTRIBUTE_ERROR_MESSAGE = 'is an invalid URL'

    attr_reader :attr, :_allow_blank, :_message, :_match_failure_messages

    def initialize(attr)
      @attr = attr
      @_message = DEFAULT_ATTRIBUTE_ERROR_MESSAGE
      @_match_failure_messages = []
    end

    def matches?(subject)
      _run_invalid_url_match(subject)
      _run_blank_match(subject)
      _match_failure_messages.blank?
    end

    def does_not_match?(subject)
      _causes_validation_error?(INVALID_URLS.first, subject)
    end

    def allow_blank
      @_allow_blank = true
      self
    end

    def with_message(message)
      @_message = message
      self
    end

    def description
      "validate that #{attr} must be a valid url"
    end

    def failure_message
      _match_failure_messages.join('. ')
    end

    def failure_message_when_negated
      "Set ##{attr} to '#{INVALID_URLS.first}' and received validation error"
    end

    private

    def _failure_message_invalid_url(url)
      "Set ##{attr} to '#{url}' but did not receive validation error"
    end

    def _causes_validation_error?(url, subject)
      subject.public_send("#{attr}=", url)
      subject.valid?
      subject.errors[attr].include?(_message)
    end

    def _run_invalid_url_match(subject)
      INVALID_URLS.each do |invalid_url|
        next if _causes_validation_error?(invalid_url, subject)

        _match_failure_messages << _failure_message_invalid_url(invalid_url)
        break
      end
    end

    def _run_blank_match(subject)
      return if _allow_blank ^ _causes_validation_error?('', subject)

      _match_failure_messages << _failure_message_blank_behavior
    end

    def _failure_message_blank_behavior
      if _allow_blank
        "Set ##{attr} to '' and received validation error"
      else
        "Set ##{attr} to '' but did not receive validation error"
      end
    end
  end
end
