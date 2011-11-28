class CreateShortExtras < ActiveRecord::Migration
  def self.up
    create_table :short_extras do |t|
      t.column :date, :date
      t.column :cluster_name, :string
      t.column :shop_name, :string
      t.column :group_id, :string
      t.column :short_extra, :integer
      t.column :comp_coll, :integer
      t.column :key_coll, :integer
    end
  end

  def self.down
    drop_table :short_extras
  end
end
