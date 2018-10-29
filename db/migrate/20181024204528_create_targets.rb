class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.string :title
      t.integer :radius
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.references :topic, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :targets, [:latitude, :longitude]
    add_index :targets, :title, unique: true
  end
end
