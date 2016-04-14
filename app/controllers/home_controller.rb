class HomeController < ApplicationController
	def show
		@entries = Entry.most_recent 20, load_tags: true
	end
end
