class RemoveFilePathsFromBooks < ActiveRecord::Migration[7.2]
  def change
    remove_column :books, :cover_image, :string
    remove_column :books, :file_path, :string
  end
end
