$(function() {

  // Notifications.

  var $notification = $(".notification");
  var notificationTimeout;
  function notify(text) {
    clearTimeout(notificationTimeout);
    $notification.text(text).fadeIn();
    notificationTimeout = setTimeout(function() { $notification.fadeOut() }, 1500);
  }


  // Clipboard.

  var clip = new ZeroClipboard(null, {
    moviePath: "/ZeroClipboard.swf",
    hoverClass: "hover"
  });

  clip.on("noflash", function() {
    $(".emoticon").hover(function() {
      $(this).toggleClass("hover");
    }).click(function() {
      prompt("Copy this:", $(this).data("shortcut"));
      return false;
    });
  });

  clip.on("load", function() {
    $(".emoticon").hover(function() {
      var text = $(this).data("shortcut");
      clip.setText(text);
      clip.glue(this);
    });
  });

  clip.on("complete", function(client, args) {
    notify("Copied " + args.text);
    // Let the browser steal back focus from Flash. Can't say I'm not proud ;p
    $("<input>").css({opacity: 0}).appendTo(this).focus().remove();
  });


  // Filter.

  var $filter = $(".filter");
  var $container = $(".emoticons");
  var $emoticons = $(".emoticon");

  var FILTERED_OUT_CLASS = "filtered-out";
  var FILTERING_CLASS = "filtering";

  // search = on pressing "(x)" to clear.
  $filter.on("keyup change search", filterFromField);
  $filter.parent("form").on("submit", preventSubmit);

  function filterFromField() {
    filterTo(this.value);
  }

  function filterTo(text) {
    if (!text) {
      stopFiltering();
    } else {
      $container.addClass(FILTERING_CLASS);

      $.each(shortcuts, function(index, shortcut) {
        var $emoticon = $emoticons.eq(index);
        var notMatched = shortcut.indexOf(text) === -1;
        $emoticon.toggleClass(FILTERED_OUT_CLASS, notMatched);
      });
    }
  }

  function stopFiltering() {
    $container.removeClass(FILTERING_CLASS);
    $emoticons.removeClass(FILTERED_OUT_CLASS);
  }


  function preventSubmit(e) {
    e.preventDefault();
  }

});
