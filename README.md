[![Build Status](https://travis-ci.org/rondale-sc/remote_pair_chef.png)](https://travis-ci.org/rondale-sc/remote_pair_chef)

# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want. These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.

# Installation and Usage


#### \<TL;DR\>

Some preliminary setup is required but the TLDR is you'll be able to type:

```
rake start RPC_HOST=rondale-sc RPC_PAIR=rwjblue
```

And when you ssh into the box that is created by the above command you'll automatically be in a shared TMUX (through wemux) connection with your pair.  SSH key authentication is taken care of based off of the github user id's passed into the start command.

#### \</TL;DR\>

## Setting up your Environment

To run the main task you should setup a few environment variables. You can either use `dotenv` or just manually load them into your environment. Here is a short list of the variables that you will need:

* AWS_ACCESS_KEY_ID - See [Setting up AWS Access](https://github.com/rondale-sc/remote_pair_chef/wiki/AWS-Access)
* AWS_SECRET_ACCESS_KEY - See [Setting up AWS Access](https://github.com/rondale-sc/remote_pair_chef/wiki/AWS-Access)
* IDENTITY_FILE - Specify your ssh private key path here (Usually, `~/.ssh/id_rsa`).
* SSH_KEY - Specify the name of your key-pair within AWS

For convenience we've added a rake task to help you set this up.

![dotenv_init](http://i.imgur.com/TqOYmKK.png)

This will write a file at `.env` with these variables set inside.  RPC will then load these into your environment at run time.  If you don't feel comfortable writing your secrets to a file you can set these manually at runtime.  

## Usage

First clone this repo.  Eventually this will be available as a gem, but since we are developing at a rapid pace it isn't a great fit yet.

### The Start Task

The start rake task is the fundamental purpose of RPC.  It will allow you to quickly bootstrap a box with ease.  Let's talk about what's in the box!

Right now the box will include:

* Vim
* Git
* RVM (installed system-wide)
* sqlite
* chef-users (See [User Management](https://github.com/rondale-sc/remote_pair_chef/wiki/User-Management))
* Tmux

```sh
bundle install
rake start RPC_HOST=<GITHUB USERNAME> RPC_PAIR=<GITHUB USERNAME>
```

After that you'll be able to ssh into the box with the following command. 

```
# AWS ip is printed at the end of start.
ssh <RPC_HOST>@<AWS_ASSIGNED_IP_ADDRESS>

# then connect with tmux
tmux -S /tmp/pair attach
```

And there you have it a brand new (completely disposable) pairing instance.

### Additional Start variables

Any of these variables can be set in your `.env` file or directly on the command line:


* __IMAGE_ID__ - _default_ - Most recent ubuntu 12.04 release via a script that parses canonical's list.
* __FLAVOR__   - _default_ - 'm1.small'
* __TAGS__     - _default_ - "Name=RPC\_#{Time.now.strftime('%Y%m%d%H%M')}"
* __RUN_LIST__ - _default_ - "role[remote_pair"  (More to follow soon) 
* __SSH_USER__ - _default_ - "ubuntu"

### The Stop Task

The stop task will shutdown any servers started with RPC.

```sh
rake stop
```

# Contributions and what is on the horizon

1. Make into a gem.
2. Allow the deletion of users on existing instances. To enable the reuse of an instance between sessions with different users.
3. Give user a fine control of running instances (underway).  Specifically ways to find and terminate sessions upon completion.
4. Spit out the ssh command to log into the box at the conclusion of the bootstrap 
5. Your \<IDEA\> here.

Help is always welcome, and any interest is greatly appreciated.  That said, we are actively taking pull requests and will work with you to get them pushed through.  So just:

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
