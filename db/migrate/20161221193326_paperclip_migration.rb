require 'paperclip'
class PaperclipMigration < ActiveRecord::Migration[5.0]
  def self.up
    change_table :posts do |t|
      add_column :receipt_file_name, :string
      add_column :receipt_content_type, :string
      add_column :receipt_file_size, :integer
      add_column :receipt_updated_at, :datetime
    end
  end

  def self.down
    remove_attachment :posts, :image
  end
end
