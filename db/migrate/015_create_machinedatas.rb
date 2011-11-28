class CreateMachinedatas < ActiveRecord::Migration
  def self.up
    create_table :machinedatas do |t|
    end
  end

  def self.down
    drop_table :machinedatas
  end
end
