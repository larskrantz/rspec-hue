require 'huey'
require 'ostruct'

class PhilipsHueController
	def initialize options = {}
		@configuration = default_options.merge options
		if configuration[:bulb].nil?
			init_philips_hue
		else
			@bulb = passed_bulb_or_null_bulb
		end
	end
	def failed
		bulb.update(configuration[:failed_color])		
	end
	def passed
		bulb.update(configuration[:passed_color])		
	end
	private
	def configuration
		@configuration
	end
	def default_options
		{ 
			hue_ip: nil,
			ssdp_ip: '239.255.255.250',
			ssdp_port: 1900,
			ttl: 3,
			api_user: '29b6dc6100397272a74dd2a1f6f545b',
			bulb_transition_time: 1,
			output: StringIO.new,
			bulb_id: nil,
			bulb: nil,
			failed_color: { bri: 183, ct: 500, xy: [ 0.6731, 0.3215 ] },
			passed_color: { bri: 57, ct: 500, xy: [ 0.408, 0.517 ] }
		}
	end
	def output
		configuration[:output]
	end
	def bulb
		@bulb
	end
	def passed_bulb_or_null_bulb
		configuration.fetch(:bulb, OpenStruct.new )
	end
	def init_bulb
		if configuration[:bulb_id_to_use].nil?
			@bulb = passed_bulb_or_null_bulb
		else
			@bulb = Huey::Bulb.find(configuration[:bulb_id_to_use])
		end
		@bulb.on = true
		@bulb.transitiontime = configuration[:bulb_transition_time]
	end
	def init_philips_hue
	 	# Must do this, othwerwise Huey starts pushing out debug messages
	 	Huey::Config.logger = ::Logger.new(nil)
		begin		
			Huey.configure do |config|
				if configuration[:hue_ip].nil?
					config.ssdp = true
					# For discovering the Hue hub, usually you won't have to change this.
				 	config.ssdp_ip = configuration[:ssdp_ip]
				  	# Also for discovering the Hue hub.
				  	config.ssdp_port = configuration[:ssdp_port]

					# If you get constant errors about not being able to find the Hue hub and you're sure
					# it's connected, increase this.
					config.ssdp_ttl = configuration[:ssdp_ttl]
				else
					config.hue_ip = configuration[:hue_ip]
				end
				# Change this if you don't like the included uuid.
				config.uuid = configuration[:api_user]
				init_bulb
			end
		rescue Huey::Errors::CouldNotFindHue
			output.puts "----> RHue: No Philips Hue found, skipping"
			@bulb = passed_bulb_or_null_bulb
		rescue Huey::Errors::PressLinkButton
			output.puts "----> RHue: Not authorized, press linkbutton on Philips Hue, then press enter here to continue, or q and enter to skip."
			if STDIN.tty?
				input = gets.strip 
				unless input.downcase == "q"
					init_philips_hue
				else
					@bulb = passed_bulb_or_null_bulb
				end
			else
				@bulb = passed_bulb_or_null_bulb
			end
		end
	end
end