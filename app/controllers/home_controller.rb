class HomeController < ApplicationController
	def show
		@transactions = Transaction.most_recent(20)
		render json: @transactions
	end
end
