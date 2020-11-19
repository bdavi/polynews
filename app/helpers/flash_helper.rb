# frozen_string_literal: true

module FlashHelper
  FlashType = Struct.new(:alert_class, :icon_class)

  FLASH_MAP = {
    'error' => FlashType.new('danger', 'fas fa-bug'),
    'notice' => FlashType.new('primary', 'fas fa-info-circle'),
    'alert' => FlashType.new('warning', 'fas fa-exclamation-circle'),
    'success' => FlashType.new('success', 'fas fa-check-circle')
  }.freeze

  def displayable_flash_types
    FLASH_MAP.keys
  end

  def flash_alert_class(type)
    FLASH_MAP.fetch(type).alert_class
  end

  def flash_icon_class(type)
    FLASH_MAP.fetch(type).icon_class
  end
end
