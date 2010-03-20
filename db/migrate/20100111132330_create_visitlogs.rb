class CreateVisitlogs < ActiveRecord::Migration
  def self.up
    create_table :visitlogs do |t|
      t.string :id
      t.string :ip
      t.date :last_visit

      t.timestamps
    end
  end

  def self.down
    drop_table :visitlogs
  end
end
