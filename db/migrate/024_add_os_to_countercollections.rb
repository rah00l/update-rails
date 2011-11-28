class AddOsToCountercollections < ActiveRecord::Migration
  def self.up
    add_column :countercollections, :os,:integer, :default => 0
    #add_column :counterdatas, :os,:integer, :default => 0
  end

  def self.down
    remove_column :countercollections, :os,:integer
    #remove_column :counterdatas, :os,:integer
  end
end
