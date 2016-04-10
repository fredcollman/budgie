class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
    	t.string :name, null: false, limit: 30, index: true
    	t.text :description
    end
  end
end
