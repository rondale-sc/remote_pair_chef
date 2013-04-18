require_relative 'ami_finder'

class Ec2Server
  attr_accessor :ssh_user, :image_id, :flavor,
                :tags, :identity_file, :ssh_key,
                :run_list

  def self.running_server_reload_commands
    running_servers.each{|server| new.reload_command(server['Public IP'])}
  end

  def self.running_servers
    field_names, servers = `knife ec2 server list`.split("\n").map{|i| i.split(/\s+/)}

    servers.collect {|server|
      next unless server.last == 'running'
      next unless server[1] =~ /RPC_/

      field_names.zip(server)
    }.compact
  end

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
