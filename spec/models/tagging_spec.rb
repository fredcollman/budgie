describe Tagging do
	it 'binds tags to entries' do
		entry = build(:entry)
		tag = build(:tag, name: 'bound')
		tagging = Tagging.new(entry: entry, tag: tag)
		expect(tagging.tag.name).to eq 'bound'
	end

	it 'prevents an entry from having duplicate tags' do
		entry = build(:entry)
		tag = build(:tag)
		Tagging.create(entry: entry, tag: tag)
		expect(Tagging.new(entry: entry, tag: tag)).to be_invalid
	end

	it 'allows multiple entries to have the same tag' do
		first = build(:entry, amount: 1)
		second = build(:entry, amount: 2)
		tag = build(:tag, name: 'shared')
		Tagging.create(entry: first, tag: tag)
		expect(Tagging.new(entry: second, tag: tag)).to be_valid
	end

	it 'allows an entry to have multiple tags' do
		first = build(:tag, name: 'first')
		second = build(:tag, name: 'second')
		entry = build(:entry)
		Tagging.create(entry: entry, tag: first)
		expect(Tagging.new(entry: entry, tag: second)).to be_valid
	end

	it 'has a composite primary key' do
		entry = build(:entry)
		tag = build(:tag)
		tagging = Tagging.create(entry: entry, tag: tag)
		expect(tagging.id).to eq([entry.id, tag.id])
	end
end