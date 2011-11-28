class AddOsToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :os,:integer, :default => 0
  end

  def self.down
    remove_column :shops, :os
  end
end
