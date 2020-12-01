class AddCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false, index: { unique: true }
      t.integer :sort_order, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
