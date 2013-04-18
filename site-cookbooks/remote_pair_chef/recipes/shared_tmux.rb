## Cookbook :: remote_pair_chef
## Recipe   :: shared_tmux
#

include_recipe "remote_pair_chef::users"
include_recipe "tmux"

file '/tmp/pair' do
  owner 'pair'
  mode '0777'
  action :create
end

execute "Startup shared tmux session" do
  user "pair"
  command "/usr/bin/tmux -S /tmp/pair new-session -d -s pairing"
  not_if { system('/usr/bin/tmux has -t pairing')  }
end

