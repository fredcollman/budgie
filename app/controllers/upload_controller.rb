class UploadController < ApplicationController
  def upload
		f = params[:file]
		if f.nil?
			flash[:error] = "No file was found"
			redirect_to action: :show
		else
			begin
				Transaction.insert_many!(SantanderTxtReader.from_file(f))
				redirect_to '/'
			rescue TransactionParseError => e
				flash[:error] = "An error occurred uploading the file: " + e.message
				redirect_to action: :show
			end
		end
  end

  def show
  end
end
