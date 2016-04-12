class Tagging < ActiveRecord::Base
	self.table_name = 'entries_tags'

	belongs_to :entry
	belongs_to :tag

	validates :tag, uniqueness: { scope: :entry }
end