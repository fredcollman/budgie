require 'rails_helper'

describe TagsController, type: :controller do
	context '.create' do
		it 'adds a tag' do
			params = { name: 'My Tag', description: 'description goes here' }
			expect {
				post :create, { tag: params }
			}.to change(Tag, :count).by(1)
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
				assert_template :new
			end

			it 'shows an error' do
				post :create, { tag: { name: 'duplicate' } }
	  		expect(flash[:error]).to eq('Tag "duplicate" already exists')
	  	end
		end
	end

	context '.index' do
		it 'lists the tags' do
			expect(Tag).to receive_messages(all: ['something'])
			get :index
		end

		it 'news a tag if there are no tags' do
			allow(Tag).to receive_messages(all: [])
			expect(Tag).to receive(:new)
			get :index
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

	context '.update' do
		def update(old_name, params)
			patch :update, name: old_name, tag: params
		end

		it 'modifies the tag' do
			to_update = Tag.create!(name: 'and now', description: 'for')
			params = { name: 'something', description: 'completely different' }
			expect {
				update 'and now', params
			}.not_to change(Tag, :count)
			expect(Tag.first.name).to eq 'something'
		end

		it 'redirects to the page for that tag' do
			Tag.create!(name: 'original')
			update 'original', name: 'different'
			assert_template :show
			expect(assigns(:tag).name).to eq 'different'
		end

		context 'when the name clashes' do
			before(:each) do
				Tag.create!(name: 'duplicate')
				Tag.create!(name: 'original')
			end

			it 'reloads the form with the original parameters' do
				update 'original', name: 'duplicate', description: 'still here'
				assert_template :edit
				expect(assigns(:tag).name).to eq 'original'
			end

			it 'shows an error' do
				update 'original', name: 'duplicate'
	  		expect(flash[:error]).to eq('A tag with the name "duplicate" already exists')
	  	end
		end
	end
end
