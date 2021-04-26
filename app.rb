require "sinatra"

error do
  halt 500, env["sinatra.error"]
end

get "/" do
  ip = env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"]
  halt ip
end
