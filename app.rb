# By Henrik Nyh <henrik@nyh.se> 2011-07-27 under the MIT license.
# See README.

# Load requirements.

require "rubygems"
require "bundler"
Bundler.require :default, (ENV['RACK_ENV'] || "development").to_sym


# Configure.

set :haml, format: :html5, attr_wrapper: %{"}


# Control.

get "/css" do
  scss :screen
end

get "/" do
  # Cache in Varnish: http://devcenter.heroku.com/articles/http-caching
  headers 'Cache-Control' => 'public, max-age=3600'

  @file       = EmoticonFile.new("./emoticons.json")
  @emoticons  = @file.emoticons(params[:order])
  @emeriti    = EmoticonFile.new("./emeriti.json").emoticons
  @all_emoticons = @emoticons + @emeriti
  @updated_at = @file.updated_at
  haml :index
end

helpers do
  def partial(template, locals={})
    haml :"_#{template}", {}, locals
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def emeriti
  []
end


# Models.

require "set"

class EmoticonFile
  BY_RECENT = "recent"

  def initialize(file)
    @file = file
  end

  def emoticons(order=nil)
    es = json.map { |e| Emoticon.new(e) }

    # The file can have duplicates, e.g. ":)" and ":-)". Only keep the first.
    known_urls = Set.new
    uniques = []
    es.each do |e|
      uniques << e unless known_urls.include?(e.url)
      known_urls << e.url
    end

    if order == BY_RECENT
      uniques.reverse
    else  # Alphabetical.
      uniques.sort_by { |x| x.shortcut }
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
  attr_reader :shortcut, :url

  def initialize(data)
    @url     = data["url"]
    @shortcut = data["shortcut"]
  end
end
