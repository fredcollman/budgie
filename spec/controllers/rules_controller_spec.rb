describe RulesController do
	context '.new' do
		it 'passes the allowed rule types' do
			allow(Rule).to receive_messages(types: ['some', 'types'])
			get :new
			expect(assigns(:rule_types)).to eq ['some', 'types']
		end
	end
end