class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false, default: ""
      t.integer :gender, null: false
      t.string :encrypted_password, null: false, default: ""

      t.timestamps
    end
  end
end
