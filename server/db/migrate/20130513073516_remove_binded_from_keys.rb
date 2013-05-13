class RemoveBindedFromKeys < ActiveRecord::Migration
  def up
    remove_column :keys, :binded
  end

  def down
    add_column :keys, :binded
  end
end
