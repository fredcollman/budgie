describe RulesController do
	context '.new' do
		it 'passes the allowed rule types' do
			allow(Rule).to receive_messages(types: ['some', 'types'])
			get :new
			expect(assigns(:rule_types)).to eq ['some', 'types']
		end
	end

	context '.create' do
		it 'adds a rule' do
			params = { 
				name: 'Some Rule',
				matching_regex: 'regex'
			}
			expect {
				post :create, { rule: params }
			}.to change(Rule, :count).by(1)
		end

		it 'redirects to the rules page' do
			post :create, { rule: { name: 'redirect' } }
			assert_redirected_to rules_path
		end
	end
end