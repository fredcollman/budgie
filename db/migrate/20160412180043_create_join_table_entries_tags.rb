class CreateJoinTableEntriesTags < ActiveRecord::Migration
  def change
  	create_join_table :entries, :tags
  end
end
