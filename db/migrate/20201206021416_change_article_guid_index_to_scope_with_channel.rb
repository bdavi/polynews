class ChangeArticleGuidIndexToScopeWithChannel < ActiveRecord::Migration[6.0]
  def change
    remove_index :articles, name: 'index_articles_on_guid'
    add_index :articles, [ :guid, :channel_id ], unique: true
  end
end
