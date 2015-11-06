# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#game_event_start_time').datetimepicker({ minDate:0, format: 'Y-m-d H:i', inline: true, step: 15});
  $('#game_event_end_time').datetimepicker({ minDate:0, format: 'Y-m-d H:i', inline: true, step: 15});

$(document).ready(ready);
$(document).on('page:load', ready);
