require 'rspec'
require 'huey'

class RHue #< RSpec::Core::Formatters::BaseTextFormatter
	def initialize output = nil
		@output = output || StringIO.new
	end
	def dump_summary(duration, example_count, failure_count, pending_count)
		huey_init
		if failure_count > 0 
			failed
		else
			passed
		end
	end
	def method_missing(m, *args, &block) end
	def self.configure()
		RSpec.configure do |c|
			c.add_setting :rspec_hue_lamp_id
		end
	end
	private
	def huey_init
		@bulb_id_to_use = RSpec.configuration.rspec_hue_lamp_id
	 	# Must do this, othwerwise Huey starts pushing out debug messages
	 	Huey::Config.logger = ::Logger.new(nil)
		begin		
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
			@bulb = Huey::Bulb.find(bulb_id_to_use)
			@bulb.on = true
			@bulb.transitiontime = 1
		rescue Huey::Errors::CouldNotFindHue
			output.puts "----> RHue: No Philips Hue found, skipping"
			null_bulb
		rescue Huey::Errors::PressLinkButton
			output.puts "----> RHue: Not authorized to Philips Hue, press linkbutton on Hue, then press enter here to continue, or q and enter to skip."
			if STDIN.tty?
				input = gets.strip 
				unless input.downcase == "q"
					huey_init
				else
					null_bulb
				end
			else
				null_bulb
			end
		end
	end
	def output 
		@output
	end
	def bulb_id_to_use
		@bulb_id_to_use
	end
	def null_bulb
		require 'ostruct'
		@bulb = OpenStruct.new
	end
	def bulb
		@bulb
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
	RHue.configure
end