class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
        t.column :CompanyID, :string
        t.column :CompanyName, :string
        t.column :Key1, :string
        t.column :Key2, :string
        t.column :Key3, :string
        t.column :Key4, :string
    end
  end

  def self.down
    drop_table :groups
  end
end
