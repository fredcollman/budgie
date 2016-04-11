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
			assert_redirected_to tag_path('redirect')
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

	context '.index' do
		it 'lists the tags' do
			tags = ['first', 'second'].map { |n| build(:tag, name: n) }
			allow(Tag).to receive_messages(all: tags)
			get :index
			expect(assigns(:tags)).to eq(tags)
		end
	end

	context '.destroy' do
		before :each do
			allow(Tag).to receive(:remove!)
		end

		it 'deletes the tag' do
			expect(Tag).to receive(:remove!).with('banana')
			delete :destroy, name: 'banana'
		end

		it 'shows a success message' do
			delete :destroy, name: 'success'
			expect(flash[:success]).to eq("Tag \"success\" has been deleted")
		end

		it 'redirects to the tags page' do
			delete :destroy, name: 'whatever'
			assert_redirected_to tags_path
		end
	end
end
