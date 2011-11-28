class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
        t.column :CompanyID, :string
        t.column :CompanyName, :string
        t.column :Address, :string
    end
  end

  def self.down
    drop_table :shops
  end
end
