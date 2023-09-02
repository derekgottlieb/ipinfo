workers Integer(ENV["WEB_CONCURRENCY"] || 2)
threads_count = Integer(ENV["RAILS_MAX_THREADS"] || 5)
threads threads_count, threads_count

preload_app!

APP_DIR = ENV["APP_DIR"] || "/usr/src/app"
rackup "config.ru"
port 3000
environment ENV["RACK_ENV"] || "development"
directory APP_DIR

lowlevel_error_handler do |e|
  [500, {}, ["<h1>We need more monkeys!</h1>\n\nAn error has occurred, and engineers have been informed. Please reload the page.\n"]]
end
