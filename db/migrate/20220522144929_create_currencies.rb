class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.integer :amount
      t.integer :decimals
      t.string :symbol
      t.string :desc
      t.float :conversion

      t.timestamps
    end
  end
end
