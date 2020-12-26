class RenameImageAltOnArticle < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :image_url, :primary_image_url
    rename_column :articles, :image_alt, :thumbnail_image_url
  end
end
