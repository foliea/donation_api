class CreateDonations < ActiveRecord::Migration[8.0]
  def change
    create_table :donations do |t|
      t.decimal :amount
      t.string :currency
      t.integer :project_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
