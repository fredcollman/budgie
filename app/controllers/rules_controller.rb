class RulesController < ApplicationController
	def index
	end

	def new
		@rule = Rule.new
		@rule_types = Rule.types
	end
end
