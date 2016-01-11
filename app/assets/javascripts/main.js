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

  /* ****************** */
  /*   Frequency Page   */
  /* ****************** */
  
  var container = $(".text-display-container");
  var textarea_num = 0;
  var max_textareas = 3;
  $(".btn").click(function() {
    var name = $(this).text();
    var id = $(this).attr("href").replace("#", "");
    var novel = $(this).attr("data");
    getJson(novel, id, function(data) {
      if (data) {
        removeExtraTextareas(function() {
          var textarea = newTextArea(textarea_num, data).hide();
          container.append(textarea);
          textarea.show(600);
          textarea_num++;
        });
      } else {
        console.log("No information found for that person");
      }
    }, function(error) {
      console.log("checking that this error works " + error["status"]);
    });
  });

  // have to specify it this way in order to find new / dynamic buttons
  $(document).on('click', '.select-text-btn', function() {
    var number = $(this).attr("data-num");
    var textarea = $("textarea[data-num='"+number+"']");
    textarea.select();  // selects all of the text in the text area
    // getting around some kind of chrome issue (http://stackoverflow.com/questions/5797539/jquery-select-all-text-from-a-textarea)
    textarea.mouseup(function() {
      textarea.unbind("mouseup");
      return false;
    });
  });


  function getJson(novel, id, onSuccess, onFailure) {
    $.ajax({
      // TODO get the actual url
      url: "frequencies/"+novel+"/"+id,
      type: "GET",
      dataType: "json",
      success: function(data, textStatus, xhr) {
        onSuccess(data);
      },
      error: function(error) {
        onFailure(error)
      }
    });
  };

  function removeExtraTextareas(onRemoved) {
    var things = $(".frequency_group");
    if (things.length >= max_textareas ) {
      things.first().hide(600, function() {
        things.first().remove();
        onRemoved();
      });
    } else {
      onRemoved();
    }
  };

  // this should be pulled eventually from actual information
  // but for now using a placeholder as a ui proof of concept
  function newTextArea(number, data) {
    var textarea = $('<textarea data-num="'+number+'" class="frequency_text" readonly=true rows=12 contenteditable="true"></textarea>');
    var text = data["novel"] + "\n";
    text += data["display"] + "\n";
    text += "Unique words: " + data["unique_words"] + "\n";
    text += "All speeches: " + data["speeches"] + "\n===========\n";
    for (var key in data["words"]) {
      text += key + ": " + data["words"][key] + "\n";
    }
    textarea.append(text);
    var container = $('<div class="frequency_group"><button class="select-text-btn" data-num="'+number+'">Select All Text</button></div>');
    container.append(textarea);
    return container;
  };
});

$(document).ready(function() {
  $('.panel-novel-overview').affix({
  offset: {
  top: $('.panel-novel-overview').offset().top
  }
  });
});
