# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want.

These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.

# Usage

Run from local box:

```sh
bundle install

# get current AMI from: http://cloud-images.ubuntu.com/releases/precise/release/

knife ec2 server create -r 'role[remote_pair]' --image ami-2efa9d47 --flavor m1.small --ssh-user ubuntu
```
