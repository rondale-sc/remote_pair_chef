# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want.
 
These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.   

# Usage

```sh
bundle install
librarian-chef install

knife solo bootstrap <HOST> --run-list 'role[remote_pair]'
```
