# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want.
 
These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.   

# Installation

```sh
# Assumes that your instance has been created and that have root privaleges on that box.
#
# FROM NODE
# chef
curl -L https://www.opscode.com/chef/install.sh | sudo bash
# clone repo
git clone https://github.com/rondale-sc/remote_pair_chef.git && cd remote_pair_chef
# run chef
sudo chef-solo -j chef-solo.json -c solo.rb
```
