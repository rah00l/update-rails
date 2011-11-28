class CreateReceivedentries < ActiveRecord::Migration
  def self.up
    create_table :receivedentries do |t|
    end
  end

  def self.down
    drop_table :receivedentries
  end
end
