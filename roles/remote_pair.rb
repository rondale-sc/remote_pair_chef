name "remote_pair"
description "All setup needed to make a new remote pairing system."
run_list(
  "recipe[vim]",
  "recipe[git::default]",
  "recipe[sqlite::default]",
  "recipe[remote_pair_chef::default]"
  "recipe[dotdotdot]",
)

