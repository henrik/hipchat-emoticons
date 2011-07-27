# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
#
# emoticons.json:
# Log into the chat in a browser and look for the response to a XHR
# request like https://accountname.hipchat.com/api/get_emoticons.
#
# default_emoticons.json:
# Just looked at the HTML and built a file to match emoticons.json.


require "rubygems"
require "sinatra"
require "haml"
require "sass"
require "json"

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }

get '/' do
  @default_emoticons = default_emoticons
  @secret_emoticons = secret_emoticons
  haml :index
end

class Emoticon
  include Comparable
  attr_reader :id, :shortcut, :path, :width, :height

  BASE_URL = "http://hipchat.com/img/emoticons/"

  def initialize(data, opts={})
    @id = data["id"]
    @path = data["path"]
    @shortcut = data["shortcut"]
    @width = data["width"].to_i
    @height = data["height"].to_i

    @default = opts[:default]
  end

  def url
    URI.join(BASE_URL, @path)
  end

  def string
    @default ? shortcut : "(#{shortcut})"
  end

  def <=>(other)
    self.shortcut <=> other.shortcut
  end

end

def default_emoticons
  emoticons_from_file("./default_emoticons.json").map { |e| Emoticon.new(e, :default => true) }
end

def secret_emoticons
  emoticons_from_file("./emoticons.json").map { |e| Emoticon.new(e, :default => false) }.sort
end

def emoticons_from_file(file)
  raw = File.read(file)
  json = JSON.parse(raw)
  json["emoticon"]
end

