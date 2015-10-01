// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap
//= require jquery-ui
//= require turbolinks
//= require jquery.datetimepicker
//= require autocomplete-rails
//= require wice_grid
//= require moment
//= require fullcalendar
//= require fullcalendar/gcal
//= require_tree .

function create_calendar(id, events, view, start_time) {
  $(id).fullCalendar({
    header: {
      left:   'title',
      center: 'month agendaWeek agendaDay',
      right:  'today prev,next'
    },
    defaultView: view,
    timezone: "local",
    events: events
  });
  $(id).fullCalendar('gotoDate', start_time);
}
