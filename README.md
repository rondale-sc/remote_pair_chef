# Remote Pair Chef

This repo contains all the recipes for installing a brand spanking new dev box.  More information to follow as to what exactly that means.  For now, take a look if you want.

These recipes are designed to be deployed to an instance (generally an AWS instance) running UBUNTU.

# Installation and Usage


## Setting up your Environment

To run the main task you should setup a few environment variables. You can either use `dotenv` or just manually load them into your environment.

Here is a short list of the variables that you will need:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* IDENTITY_FILE - Specify your ssh private key path here (Usually, `~/.ssh/id_rsa.pem`).
* SSH_KEY - Specify the name of your key-pair within AWS

For convenience we've added a rake task to help you set this up.

run `rake dotenv_init`

![dotenv_init](http://i.imgur.com/V75DCqF.png)

This will write a file at `.env` with these variables set inside.  RPC will then load these into your environment at run time.  If you don't feel comfortable writing your secrets to a file you can set these manually at runtime.  

### AWS access key and secret access key

These variables can be created easily via your EC2 console.  Once you are logged in you should drop the menu down in the top right corner and click `Security Credentials`

![security_credentials_1](http://i.imgur.com/UNVJGxm.png)

Once you've clicked that you should find the link to `Create a new Access Key`.  Once you've done that you can just paste them into the prompts when requested by `rake dotenv_init`.  Remember to never share these with anyone, and to cycle them regularly.


## Usage

First clone this repo.  Eventually this will be available as a gem, but since we are developing at a rapid pace it isn't a great fit yet.

### The Start Task

The start rake task is the fundamental purpose of RPC.  It will allow you to quickly bootstrap a box with ease.  Let's talk about what's in the box!

Right now the box will include:

* Vim
* Git
* RVM (installed system-wide)
* sqlite
* chef-users (I'll explain in a minute)
* Tmux

```sh
bundle install
rake start RPC_HOST=<GITHUB USERNAME> RPC_PAIR=<GITHUB USERNAME>
```

After that you'll be able to ssh into the box with the following command. 

```
ssh <RPC_HOST>@<AWS_ASSIGNED_IP_ADDRESS>

# then connect with tmux
tmux -S /tmp/pair attach
```

And there you have it a brand new (completely disposable) pairing instance.

### Additional Start variables

Any of these variables can be set in your `.env` file or directly on the command line:

```
* IMAGE_ID - DEFAULT: Most recent ubuntu 12.04 release via a script that parses canonical's list.
* FLAVOR   - DEFAULT: 'm1.small'
* TAGS     - DEFAULT: "Name=RPC\_#{Time.now.strftime('%Y%m%d%H%M')}"
* RUN_LIST - DEFAULT: "role[remote_pair"  (More to follow soon) 
* SSH_USER - DEFAULT: "ubuntu"
```

### chef-users (an explanation) 

Chef-Users is way for you to specify how users are created.  The first job `start` has is to create json files that contain information about the host and pair users.  

It creates the host and pair user based off of their github id's which you pass in.  This handles all the tedious user management stuff.  It does the following for each user specified:

* uses `adduser` to build the user
* builds their `.ssh` file and changes ownership to that user
* adds all of their public SSH keys to the `~/.ssh/authorized_keys` file (via GitHub's API)

We also create a `pairing` user which we'll use to connect the two users over TMUX.  We create this third user in order to ensure that the user that owns the TMUX session doesn't have sudo.


# Contributions and what is on the horizon

1. Make into a gem.
2. Allow the deletion of users on existing instances. To enable the reuse of an instance between sessions with different users.
3. Give user a fine control of running instances (underway).  Specifically ways to find and terminate sessions upon completion.
4. Spit out the ssh command to log into the box at the conclusion of the bootstrap 
5. Your <IDEA> here.

Help is always welcome, and any interest is greatly appreciated.  That said, we are actively taking pull requests and will work with you to get them pushed through.  So just:

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
