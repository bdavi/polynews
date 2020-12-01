# frozen_string_literal: true

module Features
  include FlashHelper

  def have_flash(kind, text)
    alert_class = FlashHelper::FLASH_MAP[kind.to_s].alert_class

    within(".flash.alert-#{alert_class}") do
      have_text(text)
    end
  end

  def form_error_messages
    all('.invalid-feedback').map(&:text)
  end
end
