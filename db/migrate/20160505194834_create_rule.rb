class CreateRule < ActiveRecord::Migration
  def change
    create_table :rules do |t|
    	t.string :name, null: false, limit: 30
    	t.text :matching_regex
    	t.string :tag_name, limit: 30
    end
  end
end
