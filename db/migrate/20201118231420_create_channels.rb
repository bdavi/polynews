class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :last_build_date
      t.text :description

      t.timestamps
    end
  end
end
