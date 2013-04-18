## Cookbook :: remote_pair_chef
## Recipe   :: shared_tmux
#

include_recipe "tmux"

execute "Startup shared tmux session" do
  command "/usr/bin/tmux -S /tmp/pair new-session -d -s pairing"
  not_if { system('/usr/bin/tmux has -t pairing')  }
end

file '/tmp/pair' do
  owner 'ubuntu'
  mode '0777'
  action :create
end

