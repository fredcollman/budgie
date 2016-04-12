class HomeController < ApplicationController
	def show
		@entries = Entry.most_recent(20)
	end
end
