require 'net/http'
require 'uri'

class AmiFinder
  attr_accessor :suite, :region

  def self.latest_ami
    AmiFinder.new.latest[:ami]
  end

  def initialize(suite = 'precise', region = 'us-east-1')
    self.suite, self.region = suite, region
  end

  def latest
    filter_images(:arch => 'amd64',
                  :region => 'us-east-1',
                  :root_store => 'instance-store').first
  end

  def filter_images(filter)
    available_images.select{|image|
      filter.all?{|key, value| image[key] == value}
    }
  end

  def available_images
    raw_image_data.split("\n").map{|i| build_image_hash(i)}
  end

  def raw_image_data
    uri = URI.parse("http://cloud-images.ubuntu.com/query/#{suite}/server/released.current.txt")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    response.body
  end

  private

  def build_image_hash(image)
    field_list = [:suite, :build_name, :label,
                  :serial, :root_store, :arch,
                  :region, :ami, :aki, :ari]

    Hash[field_list.zip(image.split("\t"))]
  end
end
