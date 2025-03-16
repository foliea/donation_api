class AddForeignKeyToDonations < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :donations, :projects, column: :project_id
  end
end
