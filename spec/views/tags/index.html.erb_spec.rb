describe 'tags/index.html.erb' do
	context 'with tags' do
		it 'shows the tags' do
			assign(:tags, build_list(:tag, 2))
			render
			# if this changes, update the "User deletes tag" scenario
			expect(rendered).to have_css '.tag', count: 2
		end

		it 'links to the tag detail pages' do
			tag = build(:tag, name: 'detail')
			assign(:tags, [tag])
			render
			expect(rendered).to have_link('detail', href: tag_path(tag))
		end
	end

	context 'with no tags' do
		it 'shows the new tag form if there are no tags' do
			assign(:tag, Tag.new)
			render
			assert_template partial: '_form'
		end
	end
end
