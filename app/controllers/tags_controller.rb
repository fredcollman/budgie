class TagsController < ApplicationController
	def new
		@tag = Tag.new
	end

	def create
		@tag = Tag.new(tag_params)
		begin
			@tag.save!
			redirect_to tag_path(@tag)
		rescue ActiveRecord::RecordInvalid => e
			flash.now[:error] = "Tag \"#{@tag.name}\" already exists"
			render :new
		end
	end

	def show
		@tag = Tag.find_by_name(params[:name])
	end

	def index
		@tags = Tag.all
		@tag = Tag.new if @tags.blank?
	end

	def destroy
		Tag.remove!(params[:name])
		flash[:success] = "Tag \"#{params[:name]}\" has been deleted"
		redirect_to tags_path
	end

private
	def tag_params
		params.require(:tag).permit(:name, :description)
	end
end
