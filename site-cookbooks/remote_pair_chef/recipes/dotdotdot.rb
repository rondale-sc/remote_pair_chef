## Cookbook :: remote_pair_chef
## Recipe   :: dotdotdot
#

include_recipe "tmux::default"

git "/home/#{Chef::Config[:something_that_ends_up_being_rondale-sc]}/..." do
  repository 'git://github.com/ingydotnet/....git'
  reference 'master'
  action :sync
end

remote_file "/home/#{same_as_above}/.../conf" do
  source 'https://gist.github.com/anonymous/bcc3a4b0a1ee9eec5afd/raw/68b4300ce62cadc4c4b41c85dcb10586c11eab0e/conf'
  # ^ actually should be a config arg, but something this might be an OK default
end

execute 'sync dotfiles' do
  command '... supi'
end
