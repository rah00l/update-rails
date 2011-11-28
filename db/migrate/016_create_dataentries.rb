class CreateDataentries < ActiveRecord::Migration
  def self.up
    create_table :dataentries do |t|
        t.column :ShopID, :string
        t.column :Date, :date
        t.column :GroupID, :string
        t.column :MachineNo, :string
        t.column :MachineName, :string
        t.column :ScreenIN, :string
        t.column :ScreenOUT, :string
        t.column :MeterIN, :string
        t.column :MeterOUT, :string
        t.column :Machineshort, :string
        t.column :Shortreason, :string
        t.column :status, :string, :default=>'0'
    end
  end

  def self.down
    drop_table :dataentries
  end
end
