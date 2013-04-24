users = data_bag("users")
users.each do |user_id|
  user = data_bag_item("users", user_id)

  home_dir = "/home/#{user['username']}"

  git "#{home_dir}/..." do
    repository 'git://github.com/ingydotnet/....git'
    reference 'master'
    action :sync
    user user["username"]
  end

  template "#{home_dir}/.../conf" do
    user user["username"]
    source "dotdotdot.conf.erb"
  end

  execute 'sync dotfiles' do
    user user['username']
    cwd home_dir
    command "#{home_dir}/.../bin/... super_update_install"
  end
end
