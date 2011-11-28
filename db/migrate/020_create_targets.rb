class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :targets do |t|
        t.column :Date, :date
        t.column :Shop_Name, :string
        t.column :Target_value, :string
    end
  end

  def self.down
    drop_table :targets
  end
end
