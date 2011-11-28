class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
    t.column :noofhours, :int
    t.column :created_at ,:datetime
    t.column :updated_at ,:datetime
    end
  end

  def self.down
    drop_table :configurations
  end
end
