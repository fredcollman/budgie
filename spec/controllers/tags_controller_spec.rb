require 'rails_helper'

describe TagsController, type: :controller do
	context '.create' do
		it 'adds a tag' do
			params = { name: 'My Tag', description: 'description goes here' }
			expect(Tag).to receive(:create!).with(params).and_return(double("tag").as_null_object)
			post :create, { tag: params }
		end

		it "redirects to the tag's page" do
			post :create, { tag: { name: 'redirect' } }
			assert_redirected_to '/tags/redirect'
		end
	end
end
