class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :user_id
      t.string :title
      t.text :pub_key
      t.string :identifier
      t.boolean :binded, :default => false

      t.timestamps
    end
    add_index :keys, :user_id
    add_index :keys, :identifier
    add_index :keys, :binded
  end
end
