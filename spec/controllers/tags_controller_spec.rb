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

		context 'when the tag already exists' do
			before(:each) do
				Tag.create!(name: 'duplicate')
			end

			it 'reloads the form with the original parameters' do
				params = { name: 'duplicate', description: 'still here' }
				post :create, { tag: params }
				assert_redirected_to new_tag_path(params)
			end

			it 'shows an error' do
				post :create, { tag: { name: 'duplicate' } }
	  		expect(flash[:error]).to eq('Tag "duplicate" already exists')
	  	end
		end
	end
end
