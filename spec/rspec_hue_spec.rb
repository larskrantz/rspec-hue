require 'spec_helper'

describe RSpecHue do
	context "when configuring rspec settings" do
		def set_rspec_setting setting
			RSpec.configure do |config|
				config.send (setting.to_s + "=").to_sym, "foo_value"
			end
		end
		it "should be able to set :rspec_hue_light_id" do
			expect { set_rspec_setting :rspec_hue_light_id }.to_not raise_exception
		end
		it "should be able to set :rspec_hue_ip" do
			expect { set_rspec_setting :rspec_hue_ip }.to_not raise_exception
		end
		it "should be able to set :rspec_hue_failed_color" do
			expect { set_rspec_setting :rspec_hue_failed_color }.to_not raise_exception
		end
		it "should be able to set :rspec_hue_passed_color" do
			expect { set_rspec_setting :rspec_hue_passed_color }.to_not raise_exception
		end
		it "should be able to set :rspec_hue_api_user" do
			expect { set_rspec_setting :rspec_hue_api_user }.to_not raise_exception
		end
	end
	context "when corresponding to the formatter interface" do
		let(:controller) do
			c = double("controller")
			c.stub(:failed)
			c.stub(:passed)
			c
		end
		let(:formatter) { RSpecHue.new StringIO.new, controller: controller }
		it "should respond dump_summary" do
			expect { formatter.dump_summary 123,2,1,1 }.to_not raise_exception
		end
	end
end