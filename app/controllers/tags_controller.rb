class TagsController < ApplicationController
	def new
		@name = params[:name]
		@description = params[:description]
	end

	def create
		begin
			@tag = Tag.create!(tag_params)
			redirect_to tag_path(@tag)
		rescue ActiveRecord::RecordInvalid => e
			flash[:error] = "Tag \"#{tag_params[:name]}\" already exists"
			redirect_to new_tag_path(tag_params)
		end
	end

	def show
		@tag = Tag.find_by_name(params[:name])
	end

	def index
		@tags = Tag.all
	end

private
	def tag_params
		params.require(:tag).permit(:name, :description)
	end
end
