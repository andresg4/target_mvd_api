class AddIndexToTargets < ActiveRecord::Migration[5.2]
  def change
    remove_index :targets, :title
    add_index    :targets, [:user_id, :title], unique: true
  end
end
