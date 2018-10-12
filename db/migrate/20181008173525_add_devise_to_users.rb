class AddDeviseToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
