#
# Cookbook Name:: rubygems
# Recipe:: users
#

include_recipe "user"

users = data_bag("users")
users.each do |user_name|
  user = data_bag_item("users", user_name)

  user_account user["username"] do
    comment   user["comment"]
    password  user["password"]
    ssh_keys  user["ssh_keys"]
  end
end

