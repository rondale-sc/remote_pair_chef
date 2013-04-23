#
# Cookbook Name:: remote_pair_chef
# Recipe:: users
#

include_recipe "user"

users = data_bag("users")

default_command = node["remote_pair_chef"]["default_ssh_command"]

users.each do |user_id|
  user = data_bag_item("users", user_id)

  user_account user["username"] do
    comment   user["comment"]
    password  user["password"]
    ssh_keys  user["ssh_keys"].map{|key| default_command + key}
  end

  git "/home/#{username}/..." do
    repository 'git://github.com/ingydotnet/....git'
    reference 'master'
    action :sync
  end

  remote_file "/home/#{username}/.../conf" do
    source 'https://gist.github.com/anonymous/bcc3a4b0a1ee9eec5afd/raw/68b4300ce62cadc4c4b41c85dcb10586c11eab0e/conf'
  end

  execute 'sync dotfiles' do
    user username
    comand '... supi'
  end
end
