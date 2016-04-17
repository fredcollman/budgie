describe 'tags/index.html.erb' do
	it 'shows the no tags view if there are no tags' do
		assign(:tags, [])
		assign(:tag, Tag.new)
		render
		assert_template partial: '_form'
	end
end
