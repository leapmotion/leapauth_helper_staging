require 'spec_helper'

describe LeapauthHelper do
  before do
    @stash_config = {}.merge(LeapauthHelper.config.marshal_dump)
  end
  after do
    # we do this because changes done to the configuration 
    # during testing is destructive. it's like fixture reset
    LeapauthHelper.configure do |c|
      @stash_config.each do |k,v|
        c.send("#{k}=", v)
      end
    end
  end

  describe "#configure" do
    it 'has default config' do
      LeapauthHelper.configure do |config|
      end
      expect(LeapauthHelper.config.home).to eql 'test.leapmotion:3000'
    end

    it "stores configuration" do
      LeapauthHelper.configure do |config|
        config.this_url = 'http://whatever'
        config.that_param = 'rock it'
      end
      expect(LeapauthHelper.config.this_url).to eql 'http://whatever'
      expect(LeapauthHelper.config.that_param).to eql 'rock it'
    end

    it 'overwrites default config where specified' do
      LeapauthHelper.configure do |config|
        config.home = 'http://test.test.test'
      end
      expect(LeapauthHelper.config.home).to eql 'http://test.test.test'
    end
  end
end
