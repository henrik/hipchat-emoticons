require "net/https"
require "pp"
require "rubygems"
require "json"

BOOKMARKLET = 'prompt("Copy this:", JSON.stringify( { token: app.token_info.token, group_id: util.jid.group_id(app.current_user_jid), user_id: util.jid.user_id(app.current_user_jid) } ))'

desc "Updates emoticons.json."
task :default do

  `echo '#{BOOKMARKLET}' | pbcopy`
  puts "Copied bookmarklet to clipboard."

  `open -g https://hipchat.com/chat`
  puts "Opened chat in browser."
  puts " * Log in if necessary."
  puts " * Run the bookmarklet, copy its output."
  print " * Paste bookmarklet output: "
  raw_json = gets()

  json = JSON.parse(raw_json)
  json.merge!("format" => "json")
  params = json.map { |k,v| "#{k}=#{v}" }.join("&")

  http = Net::HTTP.new('www.hipchat.com', 443)
  http.use_ssl = true
  path = '/api/get_emoticons'
  response, data = http.post(path, params, {})

  json = JSON.parse(data)
  pretty = JSON.pretty_generate(json)

  file = "emoticons.json"
  puts pretty
  File.open(file, "w") { |f| f.puts pretty }
  puts "Wrote to #{file}."
end
