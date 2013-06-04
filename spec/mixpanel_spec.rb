require 'spec_helper'

describe LeapauthHelper::Mixpanel do
  let (:testclass) { LeapauthHelper::Mixpanel.new("My Site") }

  describe '#render_init' do
    it "initializes MixPanel correctly" do
      init_string = testclass.render_init

      expect(init_string).to match /Site:\s+\'My Site\'/
      expect(init_string).to match /<script.*>/
      expect(init_string).to match /<\/script>/
      expect(init_string).to match /#{LeapauthHelper.config.mixpanel_token}/
    end

    it "calls Mixpanel People Analytics if it has user data, with the user data it has" do
      user = OpenStruct.new(:email => "user@example.com", :sign_in_count => 1)
      testclass = LeapauthHelper::Mixpanel.new("My Site", user)
      init_string = testclass.render_init
      expect(init_string).to include "mixpanel.people.set({ $email: 'user@example.com' });"
      expect(init_string).to_not include "mixpanel.people.set({ $created: "
    end
  end

  describe '#track' do
    it 'appends event to a list of events' do
      testclass.track('event1', {"whatever" => 'yo'})
      expect(testclass.instance_variable_get('@leapauth_helper_mixpanel_events')).to have(1).event
      expect(testclass.instance_variable_get('@leapauth_helper_mixpanel_events').first).to eql ['event1',{"whatever" => "yo"}]
    end
  end

  describe '#render_events' do
    it 'renders the javascript to track the recorded events' do
      JSON.generate({});
      testclass.instance_variable_set('@leapauth_helper_mixpanel_events', [['my_event', {"attr1" => "val1"}],
                                                                           ['my_event', {"attr2" => "val2"}]])
      js = testclass.render_events
      expect(js).to match /mixpanel.track.*mixpanel.track/ # we see it twice
      expect(js).to match /attr1.*attr2/
      expect(js).to match /val1.*val2/
    end
  end

  describe '#track_link' do
    it 'renders a call to the mixpanel track_link' do
      link_tracker = testclass.track_link('.the-link', 'The Event Name', {whatever: 'blah'})
      expect(link_tracker).to include "mixpanel.track_links('.the-link', 'The Event Name',"
      expect(link_tracker).to match /whatever.*blah/
    end

    it 'renders a call to the mixpanel track_link without options' do
      link_tracker = testclass.track_link('.the-link', 'The Event Name')
      expect(link_tracker).to include "mixpanel.track_links('.the-link', 'The Event Name')"
    end

  end

  describe '#track_form' do
    it "outputs a JavaScript call to the MixPanel API" do
      form_tracker = testclass.track_form('.the-form', 'The Event Name', {whatever: 'blah'})

      expect(form_tracker).to include "mixpanel.track_forms('.the-form', 'The Event Name',"
      expect(form_tracker).to match /whatever.*blah/
    end

    it "outputs a JavaScript call to the MixPanel API without options" do
      form_tracker = testclass.track_form('.the-form', 'The Event Name')
      expect(form_tracker).to include "mixpanel.track_forms('.the-form', 'The Event Name')"
    end
  end
  
end
