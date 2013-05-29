require 'rspec'
require 'philips_hue_controller'

class RspecHue 
	def initialize output, additional_args = {}
		@output = output || StringIO.new
		@bulb_controller = additional_args.fetch(:controller) { setup_philips_hue_controller }
	end
	def dump_summary(duration, example_count, failure_count, pending_count)
		if failure_count > 0 
			bulb_controller.failed
		else
			bubl_controller.passed
		end
	end
	def method_missing(m, *args, &block) end

	def self.configure()
		RSpec.configure do |c|
			c.add_setting :rspec_hue_light_id
			c.add_setting :rspec_hue_ip
			c.add_setting :rspec_hue_failed_color
			c.add_setting :rspec_hue_passed_color
			c.add_setting :rspec_hue_api_user
		end
	end

	private
	def setup_philips_hue_controller
		options = {bulb_id: RSpec.configuration.rspec_hue_light_id }
		failed_color = RSpec.configuration.rspec_hue_failed_color
		passed_color = RSpec.configuration.rspec_hue_passed_color
		hue_ip = RSpec.configuration.rspec_hue_ip
		api_user = RSpec.configuration.rspec_hue_api_user
		options[:failed_color] = failed_color unless failed_color.nil?
		options[:passed_color] = passed_color unless passed_color.nil?
		options[:hue_ip] = hue_ip unless hue_ip.nil?
		options[:api_user] = api_user unless api_user.nil?
		PhilipsHueController.new options
	end
	def bulb_controller
		@bulb_controller
	end
end	

RspecHue.configure
