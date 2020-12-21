class RemoveArticleProcesssingCache < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :processing_cache, :jsonb
  end
end
