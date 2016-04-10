describe 'tags/show.html.erb' do
	it 'formats the description as paragraphs' do
		assign(:tag, Tag.new(name: 'name', description: 'multiple\nlines'))
		render
		expect(rendered).to have_css('p', 2)
	end
end
