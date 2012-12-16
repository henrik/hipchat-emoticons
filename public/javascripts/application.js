$(function() {

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
