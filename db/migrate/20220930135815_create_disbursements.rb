class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.integer :merchant_id, null: false
      t.integer :week, null: false
      t.integer :year, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false

      t.timestamps
    end

    add_index :disbursements, [:merchant_id, :week, :year], unique: true
    add_foreign_key :disbursements, :merchants
  end
end
