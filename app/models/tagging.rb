class Tagging < ActiveRecord::Base
	self.table_name = 'entries_tags'
	self.primary_keys = :entry_id, :tag_id

	belongs_to :entry
	belongs_to :tag

	validates :tag, uniqueness: { scope: :entry }
end