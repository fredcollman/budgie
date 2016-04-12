describe EntriesController do
	it 'can tag an entry' do
		entry = create(:entry)
		allow(Entry).to receive_messages(find_by_id!: entry)
		expect(entry).to receive(:tag_with).with('grapefruit')
		post :tag_entry, entry_id: entry.id, tag_name: 'grapefruit'
	end
end
