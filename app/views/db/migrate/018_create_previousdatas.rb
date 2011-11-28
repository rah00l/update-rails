class CreatePreviousdatas < ActiveRecord::Migration
  def self.up
    create_table :previousdatas do |t|
      
    end
  end

  def self.down
    drop_table :previousdatas
  end
end
