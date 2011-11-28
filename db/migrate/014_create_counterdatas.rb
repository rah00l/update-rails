class CreateCounterdatas < ActiveRecord::Migration
  def self.up
    create_table :counterdatas do |t|
    end
  end

  def self.down
    drop_table :counterdatas
  end
end
