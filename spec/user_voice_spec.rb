require 'spec_helper'

class DummyUserVoiceTestClass; include LeapauthHelper::UserVoice; end

describe LeapauthHelper::UserVoice do
  let(:uservoice) { DummyUserVoiceTestClass.new }
  
  describe '#generate_uservoice_token' do
    it 'raises an error if email, display_name, or id are missing' do
      expect{ uservoice.generate_uservoice_token(nil,nil,nil)}.to raise_error UserVoiceError
      expect{ uservoice.generate_uservoice_token(nil,'email@example.com','Mr Rogers')}.to raise_error UserVoiceError
      expect{ uservoice.generate_uservoice_token('','','')}.to raise_error UserVoiceError
    end

    it 'calls CGI.escape so that the token is ready to roll' do
      CGI.should_receive(:escape).once.and_return('fake_token')
      expect(uservoice.generate_uservoice_token(12,'email@example.com', 'mr example')).to eql 'fake_token'
    end

    it 'generates a different token if you pass in extra goodies' do
      _id = 12
      email = 'email@example.com'
      display_name = 'mr whoever'
      without_extras = uservoice.generate_uservoice_token _id, email, display_name
      with_extras = uservoice.generate_uservoice_token _id, email, display_name, {:allow_forums => [1,2,3]}
      expect(without_extras).to_not eql with_extras
    end

    it 'generates the same token given the same input' do
      _id = 12
      email = 'email@example.com'
      display_name = 'mr whoever'
      first_time = uservoice.generate_uservoice_token _id, email, display_name
      second_time = uservoice.generate_uservoice_token _id, email, display_name
      expect(first_time).to eql second_time
    end

  end
end
