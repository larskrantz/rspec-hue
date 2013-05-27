require 'rspec/core/formatters/base_text_formatter'
require 'huey'

class RHue < RSpec::Core::Formatters::BaseTextFormatter
	def dump_summary(duration, example_count, failure_count, pending_count)
		huey_init
		if failure_count > 0 
			failed
		else
			passed
		end
	end

	private
	def huey_init
		unless @huey_is_configured
			Huey.configure do |config|
				config.ssdp = true
				# For discovering the Hue hub, usually you won't have to change this.
			 	config.ssdp_ip = '239.255.255.250'
			  	# Also for discovering the Hue hub.
			  	config.ssdp_port = 1900

				# If you get constant errors about not being able to find the Hue hub and you're sure
				# it's connected, increase this.
				config.ssdp_ttl = 3

				# Change this if you don't like the included uuid.
				config.uuid = '29b6dc6100397272a74dd2a1f6f545b'
			end
			@huey_is_configured = true
		end
	end
	def bulb
		bulb = Huey::Bulb.find('Lasses')
		bulb.transitiontime = 1
		bulb
	end
	def failed
		bulb.bri = 183
		bulb.ct = 500
		bulb.xy = [ 0.6731, 0.3215 ]
		bulb.commit
	end
	def passed
		bulb.bri = 57
		bulb.ct = 500
		bulb.xy = [ 0.408, 0.517 ]
		bulb.commit
	end		
end