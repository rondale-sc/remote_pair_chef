require_relative 'ami_finder'

class Ec2Server
  attr_accessor :ssh_user, :image_id, :flavor,
                :tags, :identity_file, :ssh_key,
                :run_list

  def self.terminate_servers!
    running_servers.map{|server| server.destroy }
  end

  def self.running_server_reload_commands
    running_servers.map{|server| new.reload_command(server.dns_name)}
  end

  def self.running_servers
    server_list.select {|server|
      server.state == 'running' && server.tags['Name'] =~ /RPC_/
    }
  end

  def self.server_list
    require 'dotenv'
    require 'fog'
    Dotenv.load

    connection = Fog::Compute.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY']
    })

    connection.servers
  end
  private_class_method :server_list

  def initialize(opts = nil)
    opts ||= {}
    env    = opts.fetch(:env) { ENV }

    self.ssh_user      = opts[:ssh_user]      || env['SSH_USER']      || 'ubuntu'
    self.image_id      = opts[:image_id]      || env['IMAGE_ID']      || AmiFinder.latest_ami
    self.flavor        = opts[:flavor]        || env['FLAVOR']        || 'm1.small'
    self.tags          = opts[:tags]          || env['TAGS']          || "Name=RPC_#{Time.now.strftime('%Y%m%d%H%M')}"
    self.run_list      = opts[:run_list]      || env['RUN_LIST']      || "role[remote_pair]"
    self.identity_file = opts[:identity_file] || env['IDENTITY_FILE']
    self.ssh_key       = opts[:ssh_key]       || env['SSH_KEY']
  end

  def bootstrap_command
    command  = "knife ec2 server create "
    command += "--run-list '#{run_list}' "
    command += "--image #{image_id} "
    command += "--flavor #{flavor} "
    command += "--tags #{tags} "
    command += "--ssh-key #{ssh_key} " if ssh_key
    command += "--identity-file #{identity_file} " if identity_file
    command += "--ssh-user #{ssh_user}" if ssh_user

    command
  end

  def reload_command(server_ip)
    command =  "knife solo cook #{ssh_user}@#{server_ip} "
    command += "--run-list '#{run_list}' "
    command += "--identity-file #{identity_file} " if identity_file

    command
  end
end
