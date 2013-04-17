# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want.

These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.

# Usage

To run the main task you should setup a few environment variables. You can either use `dotenv` or just manually load them into your environment.

Here is a short list of the variables that you will most likely need:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* IDENTITY_FILE - Specify your ssh private key path here (Usually, `~/.ssh/id_rsa.pem`).
* SSH_KEY - Specify the name of your key-pair within AWS

```sh
bundle install

rake start RPC_HOST=<GITHUB USERNAME> RPC_PAIR=<GITHUB USERNAME>
```
