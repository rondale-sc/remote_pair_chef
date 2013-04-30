## Cookbook :: remote_pair_chef
## Recipe   :: wemux
#

include_recipe "tmux::default"

git "/usr/local/wemux" do
  repository 'git://github.com/zolrath/wemux.git'
  reference 'master'
  action :sync
end

link "/usr/local/bin/wemux" do
  to '/usr/local/wemux/wemux'
end

template "/usr/local/etc/wemux.conf" do
  source "wemux.conf.erb"
  mode '0755'
  variables users: data_bag("users")
end
