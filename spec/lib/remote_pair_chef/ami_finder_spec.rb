require 'spec_helper'
require_relative '../../../lib/remote_pair_chef/ami_finder'

describe AmiFinder do
  let(:ubuntu_suite) { 'precise' }
  let(:raw_response) {File.read("spec/fixtures/canonical_response_20130417.txt")}

  subject(:ami_finder) {AmiFinder.new}

  def stub_cloud_image_request
    stub_request(:any,"http://cloud-images.ubuntu.com/query/#{ubuntu_suite}/server/released.current.txt").to_return(body: raw_response)
  end

  context "#initialize" do
    it "should save the provided suite on init" do
      ami_finder = AmiFinder.new('precise')
      expect(ami_finder.suite).to eql('precise')
    end

    it "defaults suite to precise (ubuntu 12.04)" do
      ami_finder = AmiFinder.new
      expect(ami_finder.suite).to eq('precise')
    end

    it "should save the provided AWS region on init" do
      ami_finder = AmiFinder.new('precise', 'us-east-1')

      expect(ami_finder.region).to eql('us-east-1')
    end
  end

  context "#latest_ami" do
    it "should return the latest ami for a given ubuntu release" do
      stub_cloud_image_request

      expect(ami_finder.latest_ami).to eq('ami-2efa9d47')
    end
  end

  context "#filtered_images" do
    it "should return only images for x86_64 with instance storage" do
      stub_cloud_image_request

      filter = {:arch => 'amd64',
                :region => 'us-east-1',
                :root_store => 'instance-store'}

      ami_finder.filter_images(filter).each do |image|
        expect(image[:arch]).to eql('amd64')
        expect(image[:region]).to eql('us-east-1')
        expect(image[:root_store]).to eql('instance-store')
      end
    end
  end

  context "#available_images" do
    it "each item should have keys and values" do
      stub_cloud_image_request

      result = ami_finder.available_images
      result.each do |image|
        expect { image.keys }.not_to raise_error
        expect { image.values }.not_to raise_error
      end
    end
  end

  context "#raw_image_data" do
    it "should get the cloud-image query API" do
      stub_cloud_image_request

      expect(ami_finder.raw_image_data).to eql(raw_response)
    end
  end
end
