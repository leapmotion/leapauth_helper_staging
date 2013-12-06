require 'spec_helper'

describe LeapauthHelper::GoogleTagManager do
  describe '#render_init' do

    let(:container_id) { nil }

    before do
      (LeapauthHelper.config.gtm_container_id = container_id) if container_id.present?
      @init_string = LeapauthHelper::GoogleTagManager.render_init()
    end

    shared_examples_for "a rendered script" do
      it "returns an HTML-safe string" do
        expect(@init_string).to be_html_safe
      end
    end

    context "when it does not have a Google Tag Manager Container ID" do
      it "creates a mock dataLayer object" do
        expect(@init_string).to include "dataLayer={push:function(e)"
      end

      it_behaves_like "a rendered script"
    end

    context "when it has a Google Tag Manager Container ID" do
      let(:container_id) { "FOOBAR" }

      it "renders the GTM script" do
        expect(@init_string).to include "src='//www.googletagmanager.com/ns.html?id=FOOBAR'"
      end

      it_behaves_like "a rendered script"
    end

  end
end
