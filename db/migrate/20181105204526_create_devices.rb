class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :device_id, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :devices, :device_id, unique: true
  end
end
