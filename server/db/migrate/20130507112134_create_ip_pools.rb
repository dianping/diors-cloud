class CreateIpPools < ActiveRecord::Migration
  def change
    create_table :ip_pools do |t|
      t.string :ip
      t.integer :status, :default => 1

      t.timestamps
    end

    add_index :ip_pools, :ip
    add_index :ip_pools, :status
  end
end
