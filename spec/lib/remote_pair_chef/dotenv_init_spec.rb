require 'spec_helper'
require_relative '../../../lib/remote_pair_chef/dotenv_init.rb'

require 'tmpdir'

describe DotenvInit do
  context "#interrogate" do
    let(:highline) { HighLine.new(StringIO.new,StringIO.new) }

    before do
      highline.stub(:ask).and_return("test_aws_access_key_id",
                                     "test_aws_secret_access_key",
                                     "test_identity_file",
                                     "test_ssh_key"
                                    )
    end

    it "asks the user for their AWS access key id." do
      di = DotenvInit.new(highline:highline)
      di.interrogate

      expect(di.captures[:aws_access_key_id]).to eq("test_aws_access_key_id")
    end

    it "asks the user for their AWS_SECRET_ACCESS_KEY" do
      di = DotenvInit.new(highline:highline)
      di.interrogate

      expect(di.captures[:aws_secret_access_key]).to eq("test_aws_secret_access_key")
    end

    it "asks the user for their IDENTITY_FILE" do
      di = DotenvInit.new(highline:highline)
      di.interrogate

      expect(di.captures[:identity_file]).to eq("test_identity_file")
    end

    it "asks the user for their SSH_KEY" do
      di = DotenvInit.new(highline:highline)
      di.interrogate

      expect(di.captures[:ssh_key]).to eq("test_ssh_key")
    end
  end

  context "#write_file" do
    let(:captures) do
      { :aws_access_key_id     => "test_aws_access_key_id",
        :aws_secret_access_key => "test_aws_secret_access_key",
        :identity_file         => "test_identity_file",
        :ssh_key               => "test_ssh_key"}
    end
    let(:tmp_dir) { Dir.mktmpdir }

    it "should write captured_vars to file" do
      di = DotenvInit.new
      di.captures = captures
      di.write_file("#{tmp_dir}/.env")

      expect(File.read("#{tmp_dir}/.env")).to eq(File.read('spec/fixtures/dotenv_init_write_file.txt'))
    end
  end

  context ".build_dotenv" do
    it "runs the methods necessary to create .env" do
      DotenvInit.any_instance.should_receive(:interrogate)
      DotenvInit.any_instance.should_receive(:write_file)
      DotenvInit.build_dotenv
    end
  end
end
