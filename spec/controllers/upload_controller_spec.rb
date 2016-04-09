require 'rails_helper'

describe UploadController, type: :controller do
	def post_file
  	post :upload, { transaction: { file: fixture_file_upload('santander.txt', 'text/plain') } }
	end

	context 'with a valid file' do
		before(:each) do
  		allow(Transaction).to receive_messages(insert_many!: {inserted: 1, skipped: 0})
  	end

	  it 'redirects home' do
	  	post_file
	  	assert_redirected_to('/')
	  end

	  it 'uploads the file' do
	  	expect(SantanderTxtReader).to receive(:from_file)
	  	post_file
	  end

	  it 'bulk inserts into the database' do
	  	expect(Transaction).to receive(:insert_many!)
	  	post_file
	  end

	  it 'shows how many transactions were uploaded' do
	  	allow(Transaction).to receive_messages(insert_many!: {inserted: 30, skipped: 0})
	  	post_file
	  	expect(flash[:success]).to include('Uploaded 30 transactions')
	  end

	  it 'shows a warning if transactions were ignored' do
	  	allow(Transaction).to receive_messages(insert_many!: {inserted: 5, skipped: 1})
	  	post_file
	  	expect(flash[:warn]).to include('Skipped 1 duplicate transaction')
	  end

	  it 'only shows warning if transactions were ignored' do
	  	allow(Transaction).to receive_messages(insert_many!: {inserted: 5, skipped: 0})
	  	post_file
	  	expect(flash[:warn]).to be_nil
	  end
	end

	context 'with an invalid file' do
		def post_invalid_file
	  	allow(SantanderTxtReader).to receive(:from_file).and_raise(TransactionParseError)
	  	post_file
		end

	  it 'shows an error message' do
	  	expect { post_invalid_file }.not_to raise_error
	  	expect(flash[:error]).to include("An error occurred")
	  end

	  it 'redirects to the form' do
	  	expect { post_invalid_file }.not_to raise_error
	  	assert_redirected_to(action: :show)
	  end
	end

	context 'with no file' do
	  it 'shows an error message' do
	  	expect { post :upload }.not_to raise_error
	  	expect(flash[:error]).to include("No file was found")
	  end

	  it 'redirects to the form' do
	  	expect { post :upload }.not_to raise_error
	  	assert_redirected_to(action: :show)
	  end
	end
end
