require 'spec_helper'

describe LeapauthHelper::GoogleAnalytics do
  describe '#render_init' do

    let(:property_id) { nil }

    before do
      (LeapauthHelper.config.google_property_id = property_id) if property_id.present?
      @init_string = LeapauthHelper::GoogleAnalytics.render_init()
    end

    context "when it does not have a Google property ID" do
      it "does not track things" do
        expect(@init_string).to eql ""
      end
    end

    context "when it has a Google property ID" do
      let(:property_id) { "FOOBAR" }

      it "renders the tracking script" do
        expect(@init_string).to match /<script.*>/
        expect(@init_string).to include "_gaq.push(['_setAccount',    'FOOBAR']);"
        expect(@init_string).to match /<\/script>/
      end
    end

  end
end
