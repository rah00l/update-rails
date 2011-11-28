class CreateCountercollections < ActiveRecord::Migration
  def self.up
    create_table :countercollections do |t|
        t.column :ShopID,:string
        t.column :Date, :date
        t.column :Cash, :int
        t.column :Exp, :int
        t.column :HC, :int
        t.column :Credit, :int
        t.column :Short_Ext, :int
        t.column :Openingbal, :int
        t.column :KEY1, :int
        t.column :KEY2, :int
        t.column :KEY3, :int
        t.column :KEY4, :int
        t.column :Outstanding, :int
        t.column :status,:string
        
    end
  end

  def self.down
    drop_table :countercollections
  end
end
