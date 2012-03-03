# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
# See README.

require "rubygems"
require "bundler"
Bundler.require :default, (ENV['RACK_ENV'] || "development").to_sym

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }


get '/' do
  # Cache in Varnish: http://devcenter.heroku.com/articles/http-caching
  headers 'Cache-Control' => 'public, max-age=3600'

  @standard_emoticons = EmoticonFile.standard.emoticons(params[:order])
  @secret_emoticons   = EmoticonFile.secret.emoticons(params[:order])
  @updated_at = [ EmoticonFile.standard.updated_at, EmoticonFile.secret.updated_at ].max
  haml :index
end


class EmoticonFile
  BY_RECENT    = "recent"

  def self.standard
    self.new("./standard_emoticons.json", :standard => true)
  end

  def self.secret
    self.new("./emoticons.json", :standard => false)
  end

  def initialize(file, opts={})
    @file = file
    @standard = opts[:standard]
  end

  def emoticons(order=nil)
    es = json.map { |e| Emoticon.new(e, :standard => @standard) }
    if @standard
      es  # Same order as in file.
    else
      if order == BY_RECENT
        es.reverse
      else  # Alphabetical.
        es.sort_by { |x| x.shortcut }
      end
    end
  end

  def updated_at
    File.mtime(@file)
  end

  private

  def json
    raw = File.read(@file)
    json = JSON.parse(raw)
    json["emoticon"]
  end
end

class Emoticon
  include Comparable
  attr_reader :id, :shortcut, :path, :width, :height

  BASE_URL = "http://hipchat.com/img/emoticons/"

  def initialize(data, opts={})
    @standard = opts[:standard]

    @id       = data["id"]
    @path     = data["path"]
    @width    = data["width"].to_i
    @height   = data["height"].to_i
    @shortcut = data["shortcut"]
    @shortcut.sub!(/^\((.+)\)$/, '\1') unless @standard
  end

  def url
    URI.join(BASE_URL, @path)
  end

  def string
    @standard ? shortcut : "(#{shortcut})"
  end

end
