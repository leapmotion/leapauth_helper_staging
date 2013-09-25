require 'spec_helper'

describe LeapauthHelper::GoogleTagManager do
  describe '#render_init' do

    let(:container_id) { nil }

    before do
      (LeapauthHelper.config.gtm_container_id = container_id) if container_id.present?
      @init_string = LeapauthHelper::GoogleTagManager.render_init()
    end

    context "when it does not have a Google Tag Manager Container ID" do
      it "does not do GTM things" do
        expect(@init_string).to eql ""
      end
    end

    context "when it has a Google Tag Manager Container ID" do
      let(:container_id) { "FOOBAR" }

      it "renders the GTM script" do
        expect(@init_string).to include "src='//www.googletagmanager.com/ns.html?id=FOOBAR'"
      end
    end

  end
end
