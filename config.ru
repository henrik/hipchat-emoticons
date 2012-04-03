require "./app"

require "sass/plugin/rack"
Sass::Plugin.options[:template_location] = "."
Sass::Plugin.options[:css_location] = "./public"
use Sass::Plugin::Rack

run Sinatra::Application
