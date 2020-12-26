class AddCachedHasPrimaryImageToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :cached_has_primary_image, :boolean
  end
end
