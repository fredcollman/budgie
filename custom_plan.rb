require 'zeus/rails'

class CustomPlan < Zeus::Rails
  def test(*args)
  	ENV['GUARD_RSPEC_RESULTS_FILE'] = '/tmp/guard_rspec_results.txt'
  	super
  end

  def cucumber_environment
    ::Rails.env = ENV['RAILS_ENV'] = 'test'
    default_bundle

    require 'cucumber/rspec/disable_option_parser'
    require 'cucumber/cli/main'
    @cucumber_runtime = Cucumber::Runtime.new
  end

  def cucumber(argv=ARGV)
    cucumber_main = Cucumber::Cli::Main.new(argv.dup)
    had_failures = cucumber_main.execute!(@cucumber_runtime)
    exit_code = had_failures ? 1 : 0
    exit exit_code
  end
end

Zeus.plan = CustomPlan.new
