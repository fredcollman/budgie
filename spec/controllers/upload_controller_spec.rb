require 'rails_helper'

describe UploadController, type: :controller do
	context 'upload' do
		def post_file
	  	post :upload, { file: fixture_file_upload('santander.txt', 'text/plain') }
		end

		def post_invalid_file
	  	allow(SantanderTxtReader).to receive(:from_file).and_raise(TransactionParseError)
	  	post_file
		end

	  it 'accepts a file' do
	  	allow(Transaction).to receive(:insert_many!)
	  	post_file
	  	assert_redirected_to('/')
	  end

	  it 'can upload a file' do
	  	expect(SantanderTxtReader).to receive(:from_file)
	  	post_file
	  end

	  it 'bulk inserts into the database' do
	  	expect(Transaction).to receive(:insert_many!)
	  	post_file
	  end

	  it 'redirects if the file is invalid' do
	  	expect { post_invalid_file }.not_to raise_error
	  	assert_redirected_to(action: :show)
	  end

	  it 'shows an error message if the file is invalid' do
	  	expect { post_invalid_file }.not_to raise_error
	  	expect(flash[:error]).to include("An error occurred")
	  end

	  it 'redirects if no file is given' do
	  	expect { post :upload }.not_to raise_error
	  	assert_redirected_to(action: :show)
	  end

	  it 'shows an error message if no file is given' do
	  	expect { post :upload }.not_to raise_error
	  	expect(flash[:error]).to include("No file was found")
	  end
	end
end
