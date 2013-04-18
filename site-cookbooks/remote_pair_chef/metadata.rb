name             "remote_pair_chef"
maintainer       "Jon Jackson"
maintainer_email "jonathan.jackson1@me.com"
license          "All rights reserved"
description      "Remote Pair Chef"
long_description "Remote Pair Chef"
version          "0.1.0"

recipe "remote_pair_chef::default", "Sets up users and starts tmux session."
recipe "remote_pair_chef::shared_tmux", "Start shared tmux session"
recipe "remote_pair_chef::users", "User setup and configuration"

depends "tmux"
depends "user"
