users = data_bag("users")
users.each do |user_id|
  user = data_bag_item("users", user_id)

  home_dir = "/home/#{user['username']}"

  git home_dir do
    repository 'git://github.com/ingydotnet/....git'
    reference 'master'
    action :sync
  end

  remote_file "#{home_dir}/.../conf" do
    source 'https://gist.github.com/rondale-sc/23fa89650bc89b61294d/raw/2b427d3346100b59cf8f9a5d2e9c8288d80f572c/conf'
  end

  execute 'sync dotfiles' do
    user user['username']
    cwd home_dir
    command "#{home_dir}/.../bin/... supi"
  end
end
