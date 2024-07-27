window.turnstileCallback = function () {
  // Is the Turnstile container present?
  if ($("#cf-turnstile-container").length > 0) {
    // Cloudflare Turnstile callback to handle challenges.
    let turnstileSiteKey = document.querySelector(
      "meta[name='turnstile-site-key']"
    ).content;
    turnstile.render("#cf-turnstile-container", {
      sitekey: turnstileSiteKey,
      theme: "light",
      size: parseInt(screen.width) > 299 ? "normal" : "compact",
      callback: function(token) {
        let token_tag = document.getElementById("cf-turnstile-response");

        if (token_tag) {
          document.getElementById("cf-turnstile-response").value = token;
        }
      }
    });
  }
};

$(function () {
  $(document).ready(function () {
    turnstileCallback();
    
    function adjustMainHeight() {
      var windowHeight = $(window).height();
      var bodyHeight = $('body').height();

        var headerHeight = $('header').outerHeight(true);
        var footerHeight = $('footer').outerHeight(true);

      if (windowHeight > bodyHeight) {
          var additionalHeight = windowHeight - headerHeight - footerHeight;
          $('main').css('min-height', additionalHeight + 'px');

          var mainHeight = $('main').outerHeight(true);
          var bannerHeight = $('.banner').outerHeight(true);
          var mainContainerHeight = $('.main-content-block .container').outerHeight(true);
          var additionalPadding = mainHeight - bannerHeight - mainContainerHeight;

          $('.main-content-block').css('padding', `${additionalPadding/2}px 0`);
      }
      else {
          $('main').css('min-height', 'inherit');
      }
    }
    adjustMainHeight();

    $(window).resize(function() {
        adjustMainHeight();
    });
  });
});
