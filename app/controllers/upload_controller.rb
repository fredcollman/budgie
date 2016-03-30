class UploadController < ApplicationController
  def upload
		f = params[:file]
		begin
			Transaction.insert_many!(SantanderTxtReader.from_file(f))
			redirect_to '/'
		rescue TransactionParseError => e
			flash[:error] = "An error occurred uploading the file: " + e.message
			redirect_to action: :show
		end
  end

  def show
  end
end
