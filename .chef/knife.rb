cookbook_path ["cookbooks", "site-cookbooks"]
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:aws_access_key_id] = "#{ENV['AWS_ACCESS_KEY_ID']}"
knife[:aws_secret_access_key] = "#{ENV['AWS_SECRET_ACCESS_KEY']}"

knife[:solo] = true
