class AddCachedArticleColumnsToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :cached_article_last_published_at, :datetime
    add_column :groups, :cached_article_count, :integer, null: false, default: 0
  end
end
