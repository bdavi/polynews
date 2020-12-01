class AddCategoryToChannel < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :category, foreign_key: true
  end
end
