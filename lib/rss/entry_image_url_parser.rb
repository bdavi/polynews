# frozen_string_literal: true

module RSS
  class EntryImageUrlParser
    BLACKLIST_PATTERNS = [/pixel/, /logo/, /blank/, /usatoday-newstopstories/].freeze
    REPAIR_PREFIXES = %w[http: http://].freeze

    class << self
      delegate :valid_url?, to: UrlValidator
    end

    def self.url_for(entry, methods)
      methods
        .map { |method| fetch_raw_url(entry, method) }
        .map { |url| apply_any_needed_repairs(url) }
        .compact
        .reject { |url| blacklisted?(url) }
        .first
    end

    def self.fetch_raw_url(entry, method)
      entry.respond_to?(method) ? entry.send(method.to_sym) : nil
    end

    def self.apply_any_needed_repairs(url)
      return url if valid_url?(url)

      REPAIR_PREFIXES.each do |prefix|
        repaired = "#{prefix}#{url}"
        return repaired if valid_url?(repaired)
      end

      nil
    end

    def self.blacklisted?(url)
      BLACKLIST_PATTERNS.any? { |pattern| pattern.match?(url) }
    end
  end
end
