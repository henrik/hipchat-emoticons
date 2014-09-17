require "open-uri"
require "rubygems"
require "json"

desc "Updates emoticons.json."
task :default do
  begin
    token = File.read(File.expand_path "~/.hipchat-token").strip
  rescue Errno::ENOENT
    raise("Get your API token from https://auctionet.hipchat.com/account/api and put it in ~/.hipchat-token")
  end

  url = "https://api.hipchat.com/v2/emoticon?type=global&max-results=1000&auth_token=#{token}"

  json = open(url).read
  data = JSON.parse(json)
  items = data["items"]

  # Sort newest (highest id) last.
  items.sort_by! { |item| item["id"] }

  # We could get width and height by requesting details for
  # each emoticon, but that's slow and can be throttled.
  items.map! { | item|
    {
      url: item["url"],
      shortcut: "(#{item["shortcut"]})",
    }
  }

  non_api_items = JSON.parse(File.read("non_api_emoticons.json"))

  pretty = JSON.pretty_generate(non_api_items + items)

  file = "emoticons.json"
  File.open(file, "w") { |f| f.puts pretty }
  puts "Wrote to #{file}."
end
