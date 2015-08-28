$(document).ready(function() {
  $('.show_hide').click(function(e) {
    // there is a more graceful way to do this but I'm going with the quick route
    if ($(this).text() == "hide") {
      $(this).text("show");
      $('.'+this.id).addClass(this.id+'_hidden');
      $('.'+this.id).removeClass(this.id);
    } else {
      $(this).text("hide");
      $('.'+this.id+'_hidden').addClass(this.id);
      $('.'+this.id+'_hidden').removeClass(this.id+'_hidden');
    }
  });

  $('#myTab a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  });

  $("#female").click(function(){
      $('input:checkbox.female').not(this).prop('checked', this.checked);
  });

  // $('.said_tooltip').tooltip();
});
