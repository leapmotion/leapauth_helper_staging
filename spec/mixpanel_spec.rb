require 'spec_helper'

class DummyClass; include LeapauthHelper::Mixpanel; end

describe LeapauthHelper::Mixpanel do
  let (:testclass) { DummyClass.new }

  describe '#mixpanel_init' do
    it "initializes MixPanel correctly" do
      site_name = "My Site"
      init_string = testclass.mixpanel_init(site_name)

      expect(init_string).to match /Site:\s+\'#{site_name}\'/
      expect(init_string).to match /<script.*>/
      expect(init_string).to match /<\/script>/
      expect(init_string).to match /#{LeapauthHelper.config.mixpanel_token}/
    end
  end

  describe '#mixpanel_track' do
    it 'appends event to a list of events' do
      testclass.mixpanel_track('event1', {"whatever" => 'yo'})
      expect(testclass.instance_variable_get('@leapauth_helper_mixpanel_events')).to have(1).event
      expect(testclass.instance_variable_get('@leapauth_helper_mixpanel_events').first).to eql ['event1',{"whatever" => "yo"}]
    end
  end

  describe '#mixpanel_render_events' do
    it 'renders the javascript to track the recorded events' do
      testclass.instance_variable_set('@leapauth_helper_mixpanel_events', [['my_event', {"attr1" => "val1"}],
                                                                           ['my_event', {"attr2" => "val2"}]])
      js = testclass.mixpanel_render_events
      expect(js).to match /mixpanel.track.*mixpanel.track/ # we see it twice
      expect(js).to match /attr1.*attr2/
      expect(js).to match /val1.*val2/
    end
  end

  describe '#mixpanel_track_link' do
    it 'renders a call to the mixpanel track_link' do
      link_tracker = testclass.mixpanel_track_link('.the-link', 'The Event Name', {whatever: 'blah'})
      expect(link_tracker).to include 'mixpanel.track_links'
      expect(link_tracker).to include '.the-link'
      expect(link_tracker).to include 'The Event Name'
    end
  end

  describe '#mixpanel_track_form' do
    it "outputs a JavaScript call to the MixPanel API" do
      form_tracker = testclass.mixpanel_track_form('.the-form', 'The Event Name', {whatever: 'blah'})
      # expect(form_tracker).to match /mixpanel\.track_forms\(.*\'\.the-form\'.*\'The Event Name\'.*\{\}\s+\)/
      expect(form_tracker).to match /mixpanel\.track_forms/
      expect(form_tracker).to match /\'\.the-form\'/
      expect(form_tracker).to match /\'The Event Name\'/
    end
  end
  
end
