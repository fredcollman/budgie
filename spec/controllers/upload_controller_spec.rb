require 'rails_helper'

describe UploadController, type: :controller do
	context '.upload_file' do
		def upload_fake_file
	  	subject.upload_file(double("file").as_null_object)
		end

		before(:each) do
  		allow(Entry).to receive_messages(insert_many!: {inserted: 1, skipped: 0})
		end

	  it 'uploads the file' do
	  	expect(SantanderUploader).to receive(:upload)
	  	upload_fake_file
	  end

	  it 'enforces rules' do
	  	allow(SantanderUploader).to receive_messages(upload: ['entries'])
	  	allow(Rule).to receive_messages(all: ['rules'])
	  	expect(Enforcer).to receive(:enforce).with(['rules'], ['entries'])
	  	upload_fake_file
	  end

	  it 'bulk inserts into the database after enforcing rules' do
	  	allow(Enforcer).to receive_messages(enforce: ['updated', 'entries'])
	  	expect(Entry).to receive(:insert_many!).with(['updated', 'entries'])
	  	upload_fake_file
	  end
	end

  context 'with a valid file' do
		def upload_transactions(inserted, skipped)
	  	allow(subject).to receive_messages(upload_file: {inserted: inserted, skipped: skipped})
			post :upload, { transaction: { file: nil }}
		end

	  it 'redirects home' do
	  	upload_transactions(1, 0)
	  	assert_redirected_to('/')
	  end

	  it 'shows how many transactions were uploaded' do
	  	upload_transactions(30, 0)
	  	expect(flash[:success]).to include('Uploaded 30 transactions')
	  end

	  it 'shows a warning if transactions were ignored' do
	  	upload_transactions(5, 1)
	  	expect(flash[:warn]).to include('Skipped 1 duplicate transaction')
	  end

	  it 'only shows warning if transactions were ignored' do
	  	upload_transactions(5, 0)
	  	expect(flash[:warn]).to be_nil
	  end
	end

	context 'with an invalid file' do
		def upload_invalid_file
	  	allow(subject).to receive(:upload_file).and_raise(TransactionParseError)
	  	post :upload, { transaction: { file: nil }}
		end

	  it 'shows an error message' do
	  	expect { upload_invalid_file }.not_to raise_error
	  	expect(flash[:error]).to include("An error occurred")
	  end

	  it 'redirects to the form' do
	  	expect { upload_invalid_file }.not_to raise_error
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
