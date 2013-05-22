## Cookbook :: remote_pair_chef
## Recipe   :: vim-creeper
#

git "clone vim-creeper" do
  repository 'git://github.com/rondale-sc/vim-creeper.git'
  reference 'master'
  action :sync
end

users = data_bag("users")
users.each do |user_id|
  execute "bootstrap vim-creeper" do
    home_dir = "/home/#{user["username"]}"
    cwd home_dir
    command "HOME=#{home_dir} && curl https://raw.github.com/rondale-sc/vim-creeper/master/bootstrap.sh | bash"
  end
end
