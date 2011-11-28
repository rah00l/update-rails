class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
        t.column :ClusterName, :string
    end
  end

  def self.down
    drop_table :clusters
  end
end
