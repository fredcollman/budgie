class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.date :date, null: false
    	t.text :description, null: false
    	t.decimal :amount, precision: 8, scale: 2, null:false
    end
  end
end
