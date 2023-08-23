class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :isbn
      t.string :title
      t.integer :stock

      t.timestamps
    end
  end
end
