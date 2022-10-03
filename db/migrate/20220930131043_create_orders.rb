class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :merchant_id, null: false
      t.integer :shopper_id, null: false
      t.decimal :amount, precision: 15, scale: 3, null: false
      t.datetime :completed_at, default: nil

      t.timestamps
    end

    add_index :orders, :merchant_id
    add_index :orders, :shopper_id
    add_index :orders, :completed_at

    add_foreign_key :orders, :merchants
    add_foreign_key :orders, :shoppers
  end
end
