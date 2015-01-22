require 'rspec'
require 'philips_hue_controller'

class RspecHue

	# ::RSpec::Core::Formatters.register self,
 #    :example_passed,
 #    :example_pending,
 #    :example_failed,
 #    :example_group_started,
 #    :example_group_finished,
 #    :dump_summary,
 #    :seed

	::RSpec::Core::Formatters.register self,
		:example_failed,
    :dump_summary

	attr_reader :output, :failure_count, :bulb_controller

	class << self
		def configure_rspec_for_settings
			RSpec.configure do |c|
				c.add_setting :rspec_hue_light_id
				c.add_setting :rspec_hue_ip
				c.add_setting :rspec_hue_failed_color
				c.add_setting :rspec_hue_passed_color
				c.add_setting :rspec_hue_api_user
			end
		end
	end

	def initialize(output, additional_args = {})
		@output = output || StringIO.new
		@additional_args = additional_args
		@failure_count = 0

		@bulb_controller = @additional_args.fetch(:controller) { setup_philips_hue_controller }
	end

	def example_passed(notification)
  end

  def example_pending(notification)
  end

  def example_failed(notification)
    @failure_count += 1
  end

	def dump_summary(summary)
		init_bulb_controller

		if failed?
			bulb_controller.failed
		else
			bulb_controller.passed
		end
	end


	private

	def init_bulb_controller
		@bulb_controller = @additional_args.fetch(:controller) { setup_philips_hue_controller }
	end

	def failed?
		@failure_count > 0
	end

	def setup_philips_hue_controller
		options = { bulb_id_to_use: RSpec.configuration.rspec_hue_light_id, output: output }
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
end

# Must call to add setting-possibilty to RSpec
RspecHue.configure_rspec_for_settings
