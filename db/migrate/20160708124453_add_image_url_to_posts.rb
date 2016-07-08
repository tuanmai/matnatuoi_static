class AddImageUrlToPosts < ActiveRecord::Migration
  def change
    add_column :monologue_posts, :cover_image_url, :string
    add_column :monologue_posts, :cover_image_file, :string
  end
end
