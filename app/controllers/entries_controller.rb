class EntriesController < ApplicationController
	def tag_entry
		Entry.find_by_id!(params[:entry_id]).tag_with(params[:tag][:name])
		render nothing: true
	end
end
