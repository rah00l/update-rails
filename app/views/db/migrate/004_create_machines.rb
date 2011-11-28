class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
        t.column :CompanyID, :string
        t.column :GroupID, :string
        t.column :MachineNo, :string
        t.column :MachineName, :string
        
    end
  end

  def self.down
    drop_table :machines
  end
end
