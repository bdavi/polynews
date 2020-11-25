class AddColumnsToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :url, :string, null: false
    add_column :articles, :image_url, :string
    add_column :articles, :image_alt, :string
    add_column :articles, :scraped_content, :text
    add_column :articles, :processing_cache, :jsonb
  end
end
