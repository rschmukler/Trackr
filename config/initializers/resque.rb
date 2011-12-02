ENV["REDISTOGO_URL"] ||= "redis://quaere:99d65f1ea90b43fbfd9f7834dfc76743@viperfish.redistogo.com:9005/"
uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
