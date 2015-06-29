$(document).ready(function () {

  var openDropdown = function ($menu, $container) {
    closeAllExistingDropdowns();
    $menu.css('top', $container.outerHeight());
    var anchor = $menu.data('dropdown-anchor');
    if (anchor === 'right') {
      $menu.css('right', 0);
    }
    $menu.addClass('active');
    $('<div class="cross-site-screen-action">')
      .on('click', function () { closeDropdown($menu); })
      .on('mouseover', function () { closeDropdown($menu); })
      .appendTo('body');
  };

  var closeDropdown = function ($menu) {
    $('.cross-site-screen-action').remove();
    $menu.removeClass('active');
  };

  var closeAllExistingDropdowns = function () {
    var $closeAreas = $('.cross-site-screen-action');
    if ($closeAreas.length === 0) { return; }
    $closeAreas.click();
  };

  var toggleDropdownOnParent = function ($target, onlyOpen) {
    var $container = $target.parents('.cross-site-dropdown');
    if ($container.length === 0) { return; }
    var $menu = $container.find('.cross-site-dropdown-menu');
    if ($menu === 0) { return; }
    if ($menu.hasClass('active')) {
      if (!onlyOpen) {
        closeDropdown($menu);
      }
    }
    else {
      openDropdown($menu, $container);
    }
  };

  var bindEvents = function () {
    // Bind to body as some sites load header HTML asynchronously,
    // e.g. documentation.
    $('body')
      .on('click', '.cross-site-dropdown-toggle', function (e) {
        var $target = $(e.target);
        toggleDropdownOnParent($target);
      })
      .on('mouseover', '.cross-site-dropdown-toggle', function (e) {
        var $target = $(e.target);
        var onlyOpen = true;
        toggleDropdownOnParent($target, onlyOpen);
      })
      .on('click', '.cross-site-narrow-nav-toggle', function () {
        var $nav = $('.cross-site-nav');
        if ($nav.hasClass('active')) {
          $nav.removeClass('active');
        }
        else {
          $nav.addClass('active');
        }
      });
  };

  bindEvents();

});
