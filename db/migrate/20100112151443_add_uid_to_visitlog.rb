class AddUidToVisitlog < ActiveRecord::Migration
  def self.up
    add_column :visitlogs, :uid, :string
  end

  def self.down
    remove_column :visitlogs, :uid
  end
end
