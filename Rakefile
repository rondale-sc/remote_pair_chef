require 'rake'
require 'rake/clean'

CLOBBER.add(File.expand_path("./data_bags/users/*.json"))

desc "Fires up and EC2 and creates :host and :pair users"
task :start => :clobber do
  users = [ENV['rpc_host'], ENV['rpc_pair']]
  path = File.expand_path(File.join(__FILE__, "..", "data_bags", "users"))
  cu = CreateUsers.new(path: path,  users: users)
  cu.create_users
end

class CreateUsers
  require 'json'

  def initialize(opts)
    @users = opts.delete(:users)
    @path = opts.delete(:path)
  end

  def create_users
    @users.compact.each do |u|
      create_user_data_bag(u)   
    end
  end

  def create_user_data_bag(user)
    File.open("#{@path}/#{user}.json", "w") do |f|
      f.write(user_json(user)) 
    end
  end

  def user_json(user)
    { id: user,
      comment: user,
      home: "home/#{user}",
      ssh_keys: get_keys(user) }.to_json
  end

  def get_keys(user)
    require 'net/http'
    require 'uri'
    uri = URI.parse("https://api.github.com/users/#{user}/keys")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    JSON.parse(http.request(request).body).map {|k| k["key"] }
  end
end
