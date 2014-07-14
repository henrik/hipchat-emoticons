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
  //
  // Plugins like FlashBlock won't trigger "no Flash" detection, so we use
  // a `clip.flashActuallyWorks = true` value instead.
  //
  // If only the clip handles hover/blur effects, the effect appears sluggish.
  // If both the clip and the actual element handle them, it jumps as focus shifts.
  // A slight timeout removes that jump.

  var clip = new ZeroClipboard(null, { moviePath: "/ZeroClipboard.swf" });

  var activeEmoticons = $(".active-emoticons .emoticon");
  var emoticonsEmeriti = $(".emoticons-emeriti .emoticon");

  // Emeriti don't use the flash, since it makes it difficult to save images.
  // Should be rare that you need the "copy shortcut" functionality for them.
  emoticonsEmeriti.click(function() {
    showNonFlashCopyPrompt(this);
  });

  activeEmoticons.hover(hover, blur);
  clip.on("mouseover", hover);
  clip.on("mouseout", blur);

  activeEmoticons.click(function() {
    if (!clip.flashActuallyWorks) {
      showNonFlashCopyPrompt(this);
    }
    return false;
  });

  clip.on("load", function() {
    clip.flashActuallyWorks = true;

    activeEmoticons.hover(function() {
      clip.setText($(this).data("shortcut"));
      clip.glue(this);
    });
  });

  clip.on("complete", function(client, args) {
    notify("Copied " + args.text);
    // Let the browser steal back focus from Flash. Can't say I'm not proud ;p
    // http://stackoverflow.com/questions/938403/keyboard-focus-being-stolen-by-flash
    $("<input>").css({opacity: 0}).appendTo(this).focus().remove();
  });

  function hover() {
    clearTimeout(this.hoverTimeout);
    $(this).addClass("hover");
  }

  function blur() {
    this.hoverTimeout = setTimeout($.proxy(actuallyBlur, this), 10);
  }

  function actuallyBlur() {
    $(this).removeClass("hover");
  }

  function showNonFlashCopyPrompt(element) {
    prompt("Copy this:", $(element).data("shortcut"));
  }


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
