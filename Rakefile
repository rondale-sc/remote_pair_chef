require 'rake'
require 'rake/clean'

require_relative 'lib/remote_pair_chef/create_user_data_bags.rb'

# Remove user databags at the beginning of next session.
# This ensures that users are never persisted to the next
# pairing session.
CLOBBER.add(File.expand_path("./data_bags/users/*.json"))

desc "Fires up and EC2 and creates :host and :pair users"
task :start => :clobber do
  users = [ENV['rpc_host'], ENV['rpc_pair']]
  path = File.expand_path(File.join(__FILE__, "..", "data_bags", "users"))
  cu = CreateUserDataBags.new(path: path,  users: users)
  cu.create_users
end

