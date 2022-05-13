class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :symbol
      t.integer :decimals
      t.string :description

      t.timestamps
    end
  end
end
