class RulesController < ApplicationController
	def index
	end

	def new
		@rule = Rule.new
		@rule_types = Rule.types
	end

	def create
		@rule = Rule.create!(rule_params)
		redirect_to action: 'index'
	end

private
	def rule_params
		params.require(:rule).permit(:name, :matching_regex, :tag_name)
	end
end
