# frozen_string_literal: true

class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def service_success(details = nil)
    OpenStruct.new({ success?: true, details: details })
  end

  def service_failure(error)
    OpenStruct.new({ success?: false, error: error })
  end
end
