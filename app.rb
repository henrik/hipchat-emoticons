# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
# See README.

require "rubygems"
require "bundler"
Bundler.require :default, (ENV['RACK_ENV'] || "development").to_sym

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }

module Sorting
  RECENT = "recent"
end

get '/' do
  # Cache in Varnish: http://devcenter.heroku.com/articles/http-caching
  headers 'Cache-Control' => 'public, max-age=3600'

  @standard_emoticons = standard_emoticons
  @secret_emoticons = secret_emoticons(params[:order])
  @updated_on = [ File.mtime("./emoticons.json"), File.mtime("./standard_emoticons.json") ].max
  haml :index
end

class Emoticon
  include Comparable
  attr_reader :id, :shortcut, :path, :width, :height

  BASE_URL = "http://hipchat.com/img/emoticons/"

  def initialize(data, opts={})
    @standard = opts[:standard]

    @id = data["id"]
    @path = data["path"]
    @shortcut = data["shortcut"]
    @shortcut.sub!(/^\((.+)\)$/, '\1') unless @standard
    @width = data["width"].to_i
    @height = data["height"].to_i
  end

  def url
    URI.join(BASE_URL, @path)
  end

  def string
    @standard ? shortcut : "(#{shortcut})"
  end

end

def standard_emoticons
  emoticons_from_file("./standard_emoticons.json").map { |e| Emoticon.new(e, :standard => true) }
end

def secret_emoticons(order)
  emoticons = emoticons_from_file("./emoticons.json").map { |e| Emoticon.new(e, :standard => false) }
  case order
  when Sorting::RECENT
    emoticons = emoticons.reverse
  else  # Alphabetical.
    emoticons = emoticons.sort_by { |x| x.shortcut }
  end
  emoticons
end

def emoticons_from_file(file)
  raw = File.read(file)
  json = JSON.parse(raw)
  json["emoticon"]
end
