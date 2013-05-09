class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :ip
      t.string :uuid
      t.integer :status, :default => -1
      t.integer :project_id

      t.timestamps
    end

    add_index :machines, :ip
    add_index :machines, :uuid
    add_index :machines, :status
    add_index :machines, :project_id
  end
end
