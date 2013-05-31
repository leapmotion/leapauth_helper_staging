require 'spec_helper'

describe LeapauthHelper::Internal do
  describe "#hash_for_user method" do
    before do
      user_info = mock(:id => 2, :email => "remi@example.com", :username => "remi")
      @user_hash = LeapauthHelper::Internal.hash_for_user user_info
    end

    it "returns a hash with user data" do
      expect( "remi@example.com").to eql @user_hash[:email]
      expect(@user_hash[:expires_on] >= (2.weeks.from_now - 1.second).utc.to_i).to be_true
    end
  end
end
