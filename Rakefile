require 'rake'
require 'rake/clean'
require 'dotenv/tasks'


puts  Dir.glob("lib/remote_pair_chef/*.rb") {|f| require_relative f }

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

desc "Setup dotenv through a prompt"
task :dotenv_init do
  DotenvInit.build_dotenv
end

desc "Bootstrap EC2 instance"
task :bootstrap_ec2 do
  sh Ec2Server.new.bootstrap_command

  Rake::Task[:running_servers].invoke
end

desc "Re-run chef on existing EC2 instance(s)"
task :reload => [:dotenv] do
  Ec2Server.running_server_reload_commands.each do |command|
    sh(command)
  end

  Rake::Task[:running_servers].invoke
end

desc "Print running server dns names"
task :running_servers do
  puts "\n\n\n"

  Ec2Server.running_servers.each do |server|
    puts "Server: #{server.tags['Name']} (#{server.dns_name})"
  end
end

desc "Stop all running servers"
task :stop => :dotenv do
  Ec2Server.terminate_servers!
end

desc "Fires up and EC2 and creates :host and :pair users"
task :start => [:dotenv, :clobber, :setup_github_users, :bootstrap_ec2, :running_servers]

