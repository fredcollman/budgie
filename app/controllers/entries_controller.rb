class EntriesController < ApplicationController
	def tag_entry
		Entry.find_by_id!(params[:id]).tag_with(params[:name])
		redirect_to :root
	end
end
