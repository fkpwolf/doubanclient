class AddTypeToCache < ActiveRecord::Migration
  def self.up
    add_column :caches, :content_type, :string
  end

  def self.down
    remove_column :caches, :content_type
  end
end
