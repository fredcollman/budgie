require 'rails_helper'

describe HomeController, type: :controller do
	it 'displays entries' do
		allow(Entry).to receive_messages(most_recent: ["some transaction"])
		get :show
		expect(assigns(:entries)).to eq(["some transaction"])
	end

	it 'displays multiple entries' do
		allow(Entry).to receive_messages(most_recent: [1, 2, 3])
		get :show
		expect(assigns(:entries)).to eq([1, 2, 3])
	end

	it 'displays most recent entries' do
		expect(Entry).to receive(:most_recent).with(20)
		get :show
	end
end