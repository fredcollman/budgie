class TagsController < ApplicationController
	def new
	end

	def create
		@tag = Tag.create!(tag_params)
		redirect_to tag_path(@tag)
	end

private
	def tag_params
		params.require(:tag).permit(:name, :description)
	end
end
