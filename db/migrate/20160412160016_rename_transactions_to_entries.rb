class RenameTransactionsToEntries < ActiveRecord::Migration
  def change
  	rename_table :transactions, :entries
  end
end
