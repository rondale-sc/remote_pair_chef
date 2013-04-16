#
# Cookbook Name:: remote_pair
# Recipe:: default
#
# Copyright 2013
#
# All rights reserved - Do Not Redistribute

# install packages
#
%w{ vim htop wget }.each do |pkg|
  package pkg do
    action :install
  end
end
