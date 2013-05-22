#
## Cookbook :: remote_pair_chef
## Recipe :: default
#

include_recipe "remote_pair_chef::users"
include_recipe "remote_pair_chef::rvm"
include_recipe "remote_pair_chef::wemux"
include_recipe "remote_pair_chef::vim-creeper"
