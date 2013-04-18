require 'rake'
require 'rake/clean'
require 'dotenv/tasks'

require_relative 'lib/remote_pair_chef/create_user_data_bags'
require_relative 'lib/remote_pair_chef/ami_finder'

# Remove user databags at the beginning of next session.
# This ensures that users are never persisted to the next
# pairing session.
CLOBBER.add(File.expand_path("./data_bags/users/#{CreateUserDataBags::PREFIX}*.json"))

desc "Setup users from ENV"
task :setup_github_users do
  users = [ENV['RPC_HOST'], ENV['RPC_PAIR']]
  puts "Creating users #{users.join(',')}" if users.compact.length > 0

  CreateUserDataBags.new(users: users).create_users
end

desc "Bootstrap EC2 instance"
task :bootstrap_ec2 do
  ssh_user      = ENV['SSH_USER']         || 'ubuntu'
  image_id      = ENV['IMAGE_ID']         || AmiFinder.latest_ami
  flavor        = ENV['FLAVOR']           || 'm1.small'
  tags          = ENV['TAGS']             || "Name=RPC_#{Time.now.strftime('%Y%m%d%H%M')}"
  identity_file = ENV['IDENTITY_FILE']
  ssh_key       = ENV['SSH_KEY']

  command  = "knife ec2 server create --run-list 'role[remote_pair]' --yes "
  command += "--image #{image_id} "
  command += "--flavor #{flavor} "
  command += "--tags #{tags} "
  command += "--ssh-key #{ssh_key} " if ssh_key
  command += "--identity-file #{identity_file} " if identity_file
  command += "--ssh-user #{ssh_user}" if ssh_user

  sh command
end

desc "Fires up and EC2 and creates :host and :pair users"
task :start => [:dotenv, :clobber, :setup_github_users, :bootstrap_ec2]

