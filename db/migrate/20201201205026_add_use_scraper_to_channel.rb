class AddUseScraperToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :use_scraper, :boolean, null: false, default: false
  end
end
