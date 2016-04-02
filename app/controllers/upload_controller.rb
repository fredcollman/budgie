class UploadController < ApplicationController
  def upload
  	begin
			f = params.fetch(:transaction).fetch(:file)
		rescue KeyError
			flash[:error] = "No file was found"
			redirect_to action: :show
		else
			begin
				Transaction.insert_many!(SantanderTxtReader.from_file(f.tempfile.set_encoding('utf-8')))
				flash[:success] = "File uploaded sucessfully"
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
