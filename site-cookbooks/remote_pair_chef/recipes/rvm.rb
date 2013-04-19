#
# Cookbook Name:: remote_pair_chef
# Recipe:: rvm
#

users = data_bag("users")

# Set users into RVM user group
node.default['rvm']['group_users'] = users

include_recipe "rvm::system"
