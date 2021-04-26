require "resolv"
require "sinatra"
require "whois"

error do
  halt 500, env["sinatra.error"]
end

get "/" do
  ip = env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]
  halt ip
end

get "/details" do
  ip = env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]

  dns = Resolv::DNS.new
  names = dns.getnames(ip).map(&:to_s)

  whois = Whois::Client.new
  begin
    whois_result = whois.lookup(names.first)
  rescue Whois::ServerNotFound
    whois_result = "UNAVAILABLE"
  end

  halt "IP: " + ip + "<br>Names: " + names.join(", ") + "<br><br>Whois: #{whois_result}"
end
