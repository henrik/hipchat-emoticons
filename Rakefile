require "pp"
require "rubygems"
require "json"
require "cgi"

# slant.png workaround :\ https://github.com/henrik/hipchat-emoticons/pull/10
# Doubly escaped for Ruby + JS.
BOOKMARKLET = 'alert("Close this dialog and copy the URL, then go back to the terminal!"); re = new RegExp("^"+config.group_id+"/");' +
              'es = config.emoticons.filter(function(x) { return !x.file.match(re) }).map(function(x) { delete x.regex; if (x.file == "slant.png") x.shortcut = ":\\\\"; return x; });' +
              'location.hash = JSON.stringify(es)'

desc "Updates emoticons.json."
task :default do

  IO.popen("pbcopy", "w") { |f| f << BOOKMARKLET }
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
