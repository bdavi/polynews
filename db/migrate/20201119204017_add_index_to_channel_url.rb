class AddIndexToChannelUrl < ActiveRecord::Migration[6.0]
  def change
    add_index :channels, :url, unique: true
  end
end
