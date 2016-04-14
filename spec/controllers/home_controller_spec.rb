require 'rails_helper'

describe HomeController, type: :controller do
	it 'displays most recent entries' do
		allow(Entry).to receive(:most_recent).and_return(['transactions', 'go', 'here'])
		get :show
		expect(assigns(:entries)).to eq(['transactions', 'go', 'here'])
	end

	it 'performs an efficient query' do
		expect(Entry).to receive(:most_recent)
			.with(any_args, hash_including(load_tags: true))
		get :show
	end
end
