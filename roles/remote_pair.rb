name "remote_pair"
description "All setup needed to make a new remote pairing system."
run_list(
  "recipe[vim]",
  "recipe[git::default]",
  "recipe[rvm::system]",
  "recipe[tmux::default]",
  "recipe[sqlite::default]",
  "recipe[remote_pair_chef::users]"
)

