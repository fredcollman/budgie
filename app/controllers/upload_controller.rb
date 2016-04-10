include ActionView::Helpers::TextHelper

class UploadController < ApplicationController
  def upload
  	begin
			f = params.fetch(:transaction).fetch(:file)
		rescue KeyError
			flash[:error] = "No file was found"
			redirect_to action: :show
		else
			begin
				result = upload_file(f)
				flash[:success] = "Uploaded #{pluralize(result[:inserted], 'transaction')}"
				if (result[:skipped] > 0)
					flash[:warn] = "Skipped #{pluralize(result[:skipped], 'duplicate transaction')}"
				end
				redirect_to '/'
			rescue TransactionParseError => e
				flash[:error] = "An error occurred uploading the file: " + e.message
				redirect_to action: :show
			end
		end
  end

  def upload_file(file)
  	Transaction.insert_many!(SantanderUploader.upload(file.tempfile))
  end

  def show
  end
end
