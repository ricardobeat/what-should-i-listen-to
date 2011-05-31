(function() {
  var makeNoise;
  makeNoise = function(opacity) {
    var canvas, ctx, n, noise, x, y, _ref, _ref2;
    if (opacity == null) {
      opacity = 0.2;
    }
    if (!document.createElement('canvas').getContext) {
      return false;
    }
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
    var button, phrase, phrases;
    console.log($);
    button = $('#recommend');
    phrases = ["I need to know.", "I have no idea.", "Hmmmmm...", "How about..."];
    phrase = phrases[~~(Math.random() * phrases.length)];
    button.text(phrase);
    return button.click(function() {
      return alert('opa');
    });
  });
}).call(this);
