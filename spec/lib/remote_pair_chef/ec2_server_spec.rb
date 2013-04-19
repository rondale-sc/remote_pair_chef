require 'spec_helper'

require_relative '../../../lib/remote_pair_chef/ec2_server'

describe Ec2Server do

  let(:default_image_id) {'ami12345'}
  let(:default_tags)     {"Name=RPC_#{Time.now.strftime('%Y%m%d%H%M')}"}

  subject(:server) { Ec2Server.new }

  before do
    AmiFinder.stub(:latest_ami => default_image_id)
  end

  context "#initialize" do

    context "uses default values" do
      it { expect(server.ssh_user).to eql('ubuntu')           }
      it { expect(server.image_id).to eql(default_image_id)   }
      it { expect(server.flavor).to   eql('m1.small')         }
      it { expect(server.tags).to     eql(default_tags)       }
      it { expect(server.run_list).to eql('role[remote_pair]')}
      it { expect(server.region).to eql("us-east-1") }
    end

    context "allows passing values" do
      let(:options) { Hash.new {|h,k| h[k] = 'test_' + k.to_s}}
      subject(:server) { Ec2Server.new(options)}

      it { expect(server.ssh_user).to      eql('test_ssh_user')      }
      it { expect(server.image_id).to      eql('test_image_id')      }
      it { expect(server.flavor).to        eql('test_flavor')        }
      it { expect(server.tags).to          eql('test_tags')          }
      it { expect(server.run_list).to      eql('test_run_list')      }
      it { expect(server.identity_file).to eql('test_identity_file') }
      it { expect(server.ssh_key).to       eql('test_ssh_key')       }
      it { expect(server.region).to        eql("test_region") }
    end

    context "allows using values from ENV" do
      let(:env) { Hash.new {|h,k| h[k] = 'test_' + k}}
      subject(:server) { Ec2Server.new(env: env)}

      it { expect(server.image_id).to      eql('test_IMAGE_ID')      }
      it { expect(server.ssh_user).to      eql('test_SSH_USER')      }
      it { expect(server.flavor).to        eql('test_FLAVOR')        }
      it { expect(server.tags).to          eql('test_TAGS')          }
      it { expect(server.run_list).to      eql('test_RUN_LIST')      }
      it { expect(server.identity_file).to eql('test_IDENTITY_FILE') }
      it { expect(server.ssh_key).to       eql('test_SSH_KEY') }
      it { expect(server.region).to        eql('test_REGION') }
    end
  end

  context "#bootstrap_command" do
    it "returns the knife bootstrap command to be run" do
      expect(server.bootstrap_command).to eql("knife ec2 server create --run-list 'role[remote_pair]' --image ami12345 --flavor m1.small --tags #{default_tags} --ssh-user ubuntu --region us-east-1")
    end
  end

  context "#reload_command" do
    let(:default_server_id) {'ec2-1231231-12312-123.blah.com'}

    it "accepts the server DNS/IP to reload" do
      expect(server.reload_command(default_server_id)).to eql("knife solo cook ubuntu@ec2-1231231-12312-123.blah.com --run-list 'role[remote_pair]' ")
    end
  end
end
