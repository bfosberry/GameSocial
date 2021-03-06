# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#event_start_time').datetimepicker({ minDate:0, format: 'Y-m-d H:i', inline: true, step: 30});
  $('#event_end_time').datetimepicker({ minDate:0, format: 'Y-m-d H:i', inline: true, step: 30});

$(document).ready(ready);
$(document).on('page:load', ready);
