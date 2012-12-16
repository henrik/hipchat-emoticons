require "pp"
require "rubygems"
require "json"
require "cgi"

BOOKMARKLET = 'alert("Close this dialog and copy the URL, then go back to the terminal!"); re = new RegExp("^"+config.group_id+"/");' +
              'es = linkify.emoticons.filter(function(x) { return !x.image.match(re) }).map(function(x) { delete x.regex; return x; });' +
              'location.hash = JSON.stringify(es)'

desc "Updates emoticons.json."
task :default do

  `echo '#{BOOKMARKLET}' | pbcopy`
  puts "Copied bookmarklet to clipboard."

  `open -g https://hipchat.com/chat`
  puts "Opened chat in browser."
  puts " * Log in if necessary."
  puts " * Run the bookmarklet, do what it says."
  print " * Hit Return when done:"
  gets
  raw_json = `pbpaste`.split('#', 2).last

  # May contain HTML entities.
  raw_json = CGI.unescapeHTML(raw_json)

  json = JSON.parse(raw_json)

  pretty = JSON.pretty_generate(json)

  file = "emoticons.json"
  puts pretty
  File.open(file, "w") { |f| f.puts pretty }
  puts "Wrote to #{file}."
end
