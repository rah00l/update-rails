class CreatePreviousrecords < ActiveRecord::Migration
  def self.up
    create_table :previousrecords do |t|
        t.column :Date, :date
        t.column :Xcash, :int
        t.column :Xcredit,:int
        t.column :ShopID, :string
    end
  end

  def self.down
    drop_table :previousrecords
  end
end
