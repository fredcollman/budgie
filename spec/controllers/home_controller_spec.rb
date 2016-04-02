require 'rails_helper'

describe HomeController, type: :controller do
	it 'displays transactions' do
		allow(Transaction).to receive_messages(most_recent: ["some transaction"])
		get :show
		expect(assigns(:transactions)).to eq(["some transaction"])
	end

	it 'displays multiple transactions' do
		allow(Transaction).to receive_messages(most_recent: [1, 2, 3])
		get :show
		expect(assigns(:transactions)).to eq([1, 2, 3])
	end

	it 'displays most recent transactions' do
		expect(Transaction).to receive(:most_recent).with(20)
		get :show
	end
end