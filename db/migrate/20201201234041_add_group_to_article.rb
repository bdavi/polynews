class AddGroupToArticle < ActiveRecord::Migration[6.0]
  def change
    add_reference :articles, :group, foreign_key: true
  end
end
