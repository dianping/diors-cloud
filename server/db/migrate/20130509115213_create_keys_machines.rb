class CreateKeysMachines < ActiveRecord::Migration
  def change
    create_table :keys_machines, id: false do |t|
      t.integer :key_id
      t.integer :machine_id
    end

    add_index :keys_machines, :key_id
    add_index :keys_machines, :machine_id
  end
end
