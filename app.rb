# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.

require "rubygems"
require "sinatra"
require "haml"
require "sass"
require "json"

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }

get '/' do
  haml :index
end
