class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :description
      t.string :guid, null: false, index: { unique: true }
      t.belongs_to :channel, null: false, foreign_key: true
      t.text :content
      t.datetime :published_at

      t.timestamps
    end
  end
end
