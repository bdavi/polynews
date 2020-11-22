# frozen_string_literal: true

module Features
  def have_flash(kind, text)
    within(".flash.alert-#{kind}") do
      have_text(text)
    end
  end

  def form_error_messages
    all('.invalid-feedback').map(&:text)
  end
end
