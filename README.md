# RspecHue

RspecHue is a formatter for RSpec that will show the status of your tests to the entire office using [Philips Hue][].

## Installation

Add this line to your application's Gemfile:

```bash
gem 'rspec-hue'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install rspec-hue
```
## Usage

RspecHue depends on the [Huey](https://github.com/Veraticus/huey) gem that will auto-discover your [Philips Hue][] using [SSDP](http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol). 
Or if you want, you can configure it to use a static ip-address.

On first usage, you will have to press the link button on your Hue when prompted, or right before running your first test with the Hue formatter.

### Configuration
You'll have to configure the formatter using RSpec.configure, usually in your spec_helper.rb.
This is the minimal required configuration for RspecHue (not really, Huey will find a bulb, but I wouldn't count on it):

```ruby
RSpec.configure do |config|
    config.rspec_hue_light_id = 1 
end
```

Available settings are:

```ruby
RSpec.configure do |config|
    config.rspec_hue_light_id = "light name" # could be name or an id, depending on how you named your lights
    # optional settings: 
    config.rspec_hue_ip = "10.0.1.92" # Will disable auto-discover and use this static ip
    config.rspec_hue_api_user = "29b6dc6100397272a74dd2a1f6f545b" # if you want to use another api user in your Hue 
    # The default colors, could be overridden. 
    # See mention below for color syntax.
    config.rspec_hue_failed_color = { bri: 183, ct: 500, xy: [ 0.6731, 0.3215 ] } # red, default for failing specs
    config.rspec_hue_passed_color =  { bri: 57, ct: 500, xy: [ 0.408, 0.517 ] } # green, default for passing specs
end
```
### Enabling in RSpec
In your .rspec add:

```ruby
    --format RspecHue
```
### Light ids explained
The config.rspec\_hue\_light_id refers either to an light id or a light name. See the [Hue dev docs](http://developers.meethue.com/1_lightsapi.html#11_get_all_lights).
Name can be easily be changed from the iPhone App or the Mac [Colors for Hue](https://itunes.apple.com/se/app/colors-for-hue/id581915465?mt=12).


### Colors
See [Hue dev docs](http://developers.meethue.com/1_lightsapi.html#16_set_light_state) or [Huey#bulbs](https://github.com/Veraticus/huey#bulbs).
You could also set the color, using your iPhone Hue-app or the Mac [Colors for Hue](https://itunes.apple.com/se/app/colors-for-hue/id581915465?mt=12), and then check the parameters using the Hue [REST-interface](http://developers.meethue.com/1_lightsapi.html#14_get_light_attributes_and_state) (there seems to be a 100s cache for this call, so if it doesn't change, wait and refresh).

## Office configuration
In our office, we have one lamp per developer and we named them after the developer's name. Then, we configure as:

```ruby
RSpec.configure do |config|
    config.rspec_hue_light_id = `git config user.name`.strip
end
```

This will pull the name from the developer's git config and use it to find hers/his light.

RSpecHue will not break tests if the Hue isn't found, or if the rspec\_hue\_light\_id isn't accessible, but will output an one-liner error message.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[Philips Hue]: http://www.meethue.com/
