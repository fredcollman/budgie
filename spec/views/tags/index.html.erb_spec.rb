describe 'tags/index.html.erb' do
	context 'with tags' do
		it 'shows the tags' do
			assign(:tags, build_list(:tag, 2))
			render
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
			render
			assert_template partial: '_new_tag_form'
		end
	end
end
