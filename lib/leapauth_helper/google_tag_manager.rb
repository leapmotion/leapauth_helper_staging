module LeapauthHelper
  class GoogleTagManager
    def self.render_init(enabled = true)
      if LeapauthHelper.config.gtm_container_id.present? && enabled
        "<noscript><iframe src='//www.googletagmanager.com/ns.html?id=#{LeapauthHelper.config.gtm_container_id}'
        height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','#{LeapauthHelper.config.gtm_container_id}');</script>"
      else
        "<script>dataLayer={push:function(e){console.log('dataLayer.push() called:');console.log(e);}};</script>"
      end.html_safe
    end
  end
end
