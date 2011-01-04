class CreateCaches < ActiveRecord::Migration
  def self.up
    create_table :caches do |t|
      t.string :subject
      t.string :fix
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :caches
  end
end
