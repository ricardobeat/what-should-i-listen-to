(function() {
  var makeNoise;

  makeNoise = function(opacity) {
    var canvas, ctx, n, noise, x, y, _ref, _ref2;
    if (opacity == null) opacity = 0.2;
    if (!document.createElement('canvas').getContext) return false;
    if ((window.localStorage != null) && window.localStorage["noise-" + opacity]) {
      noise = window.localStorage["noise-" + opacity];
    } else {
      canvas = document.createElement('canvas');
      ctx = canvas.getContext('2d');
      canvas.width = 45;
      canvas.height = 45;
      for (x = 0, _ref = canvas.width; 0 <= _ref ? x < _ref : x > _ref; 0 <= _ref ? x++ : x--) {
        for (y = 0, _ref2 = canvas.height; 0 <= _ref2 ? y < _ref2 : y > _ref2; 0 <= _ref2 ? y++ : y--) {
          n = Math.round(Math.random() * 60);
          ctx.fillStyle = "rgba(" + ([n, n, n, opacity].join(',')) + ")";
          ctx.fillRect(x, y, 1, 1);
        }
      }
      noise = canvas.toDataURL('image/png');
      if (window.localStorage != null) {
        window.localStorage["noise-" + opacity] = noise;
      }
    }
    return document.getElementsByTagName('html')[0].style.backgroundImage = "url(" + noise + ")";
  };

  makeNoise(.2);

  jQuery(function($) {
    var artist, errorMessage, phrase, phrases, recommend, showRecommendation, username;
    recommend = $('#recommend');
    artist = $('#artist');
    username = $('#username');
    errorMessage = $('#errorMessage');
    if (window.localStorage && localStorage.username) {
      username.val(localStorage.username);
    }
    phrases = ["I need to know.", "I have no idea.", "Hmmmmm...", "How about..."];
    phrase = phrases[~~(Math.random() * phrases.length)];
    recommend.text(phrase);
    showRecommendation = function(result) {
      if (!result) {
        errorMessage.show();
      } else {
        errorMessage.hide();
      }
      artist.html(("<a href=\"http://grooveshark.com/#/search?q=" + (escape(result)) + "\">" + result + "</a>") || 'The Beatles');
      recommend.text('Try again');
      return recommend.addClass('used');
    };
    recommend.click(function(e) {
      var user;
      e.preventDefault();
      user = username.val();
      user && window.localStorage && (localStorage.username = user);
      user || (user = 'superbife');
      $.ajax({
        url: "/recommend/" + user,
        success: showRecommendation,
        error: showRecommendation,
        type: 'GET',
        dataType: 'text'
      });
      return (typeof _gaq !== "undefined" && _gaq !== null) && _gaq.push(['_trackEvent', 'What should I listen to?', 'Recommendation', user]);
    });
    return recommend.next('form').submit(function(e) {
      e.preventDefault();
      return recommend.click();
    });
  });

}).call(this);
