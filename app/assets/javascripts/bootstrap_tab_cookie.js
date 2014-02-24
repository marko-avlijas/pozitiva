$(function() { 
  $('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
    //save the latest tab using a cookie:
    $.cookie('last_tab', $(e.target).attr('href'));
  });

  //activate latest tab, if it exists:
  var lastTab = $.cookie('last_tab');
  if (lastTab) {
      $('ul.nav-tabs').children().removeClass('active');
      $('a[href='+ lastTab +']').parents('li:first').addClass('active');
      $('div.tab-content').children().removeClass('active');
      $(lastTab).addClass('active');
  }
});