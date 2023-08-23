class CreateFlows < ActiveRecord::Migration[7.0]
  def change
    create_table :flows do |t|
      t.integer :previousStock
      t.integer :newStock
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
