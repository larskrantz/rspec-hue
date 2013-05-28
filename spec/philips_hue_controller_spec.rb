require 'spec_helper'

describe PhilipsHueController do
	let(:bulb) { double("Bulb") }
	let(:failed_color) { { bri: 183, ct: 500, xy: [ 0.6731, 0.3215 ] } }
	let(:passed_color) { { bri: 57, ct: 500, xy: [ 0.408, 0.517 ] } }
	let(:controller) { PhilipsHueController.new bulb: bulb, failed_color: failed_color, passed_color: passed_color }

	context "when telling controller to light bulb for failing test" do
		it "the bulb should receive update with failcolor" do
			bulb.should_receive(:update).with(failed_color)
			controller.failed
		end
	end
	context "when telling controller to light bulb for passing test" do
		it "the bulb should receive update with passcolor" do
			bulb.should_receive(:update).with(passed_color)
			controller.passed
		end
	end
end