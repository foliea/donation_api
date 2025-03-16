class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :api_token

      t.timestamps
    end
    add_index :users, :api_token, unique: true
  end
end
