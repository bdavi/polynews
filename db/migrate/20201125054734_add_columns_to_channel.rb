class AddColumnsToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :image_url, :string
    add_column :channels, :scraping_content_selector, :string
  end
end
