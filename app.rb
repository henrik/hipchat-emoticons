# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
# See README.

require "set"
require "rubygems"
require "bundler"
Bundler.require :default, (ENV['RACK_ENV'] || "development").to_sym

set :haml, :format => :html5, :attr_wrapper => %{"}
set :views, lambda { root }


get '/' do
  # Cache in Varnish: http://devcenter.heroku.com/articles/http-caching
  headers 'Cache-Control' => 'public, max-age=3600'

  @file       = EmoticonFile.new
  @emoticons  = @file.emoticons(params[:order])
  @updated_at = @file.updated_at
  haml :index
end

class EmoticonFile

  BY_RECENT = "recent"

  def initialize
    @file = "./emoticons.json"
  end

  def emoticons(order=nil)
    es = json.map { |e| Emoticon.new(e) }

    # The file can have duplicates, e.g. ":)" and ":-)". Only keep the first.
    known_images = Set.new
    es.reject! { |e|
      if known_images.include?(e.path)
        true
      else
        known_images << e.path
        false
      end
    }

    if order == BY_RECENT
      es.reverse
    else  # Alphabetical.
      es.sort_by { |x| x.shortcut }
    end
  end

  def updated_at
    File.mtime(@file)
  end

  private

  def json
    raw = File.read(@file)
    json = JSON.parse(raw)
  end

end

class Emoticon
  include Comparable
  attr_reader :shortcut, :path, :width, :height

  BASE_URL = "https://dujrsrsgsd3nh.cloudfront.net/img/emoticons/"

  def initialize(data, opts={})
    @standard = opts[:standard]

    @path     = data["image"]
    @width    = data["width"].to_i
    @height   = data["height"].to_i
    @shortcut = data["shortcut"]
  end

  def url
    URI.join(BASE_URL, @path)
  end

end
