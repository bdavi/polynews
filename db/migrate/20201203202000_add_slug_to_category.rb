class AddSlugToCategory < ActiveRecord::Migration[6.0]
  def up
    add_column :categories, :slug, :string
    ActiveRecord::Base.connection.execute(<<~SQL)
      UPDATE categories
      SET slug = id
    SQL
    change_column :categories, :slug, :string, null: false
    add_index :categories, :slug, unique: true
  end

  def down
    remove_column :categories, :slug
  end
end
