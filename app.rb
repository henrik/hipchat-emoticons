# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
# See README.

require "rubygems"
require "sinatra"
require "haml"
require "sass"
require "json"

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }

get '/' do
  # Cache in Varnish: http://devcenter.heroku.com/articles/http-caching
  headers 'Cache-Control' => 'public, max-age=3600'

  @standard_emoticons = standard_emoticons
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

    @standard = opts[:standard]
  end

  def url
    URI.join(BASE_URL, @path)
  end

  def string
    @standard ? shortcut : "(#{shortcut})"
  end

  def <=>(other)
    self.shortcut <=> other.shortcut
  end

end

def standard_emoticons
  emoticons_from_file("./standard_emoticons.json").map { |e| Emoticon.new(e, :standard => true) }
end

def secret_emoticons
  emoticons_from_file("./emoticons.json").map { |e| Emoticon.new(e, :standard => false) }.sort
end

def emoticons_from_file(file)
  raw = File.read(file)
  json = JSON.parse(raw)
  json["emoticon"]
end

