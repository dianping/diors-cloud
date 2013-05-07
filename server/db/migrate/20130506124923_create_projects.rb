class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.string :token
      t.integer :owner_id

      t.timestamps
    end

    add_index :projects, :name
    add_index :projects, :slug, unique: true
    add_index :projects, :token
    add_index :projects, :owner_id
  end
end
