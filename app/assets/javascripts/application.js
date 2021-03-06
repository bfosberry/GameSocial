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
//= require notifyjs_rails
//= require turbolinks
//= require jquery.datetimepicker
//= require autocomplete-rails
//= require wice_grid
//= require moment
//= require fullcalendar
//= require fullcalendar/gcal
//= require websocket_rails/main
//= require social-share-button
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

function maybeVisit(event, url){
  var source = getTarget(event);

  if (source.tagName == "TD") {
    document.location = url;
  }
}

function registerWebsocket(user_id) {
  var dispatcher = new WebSocketRails(document.location.host + '/websocket');
  channel = dispatcher.subscribe("user_" + user_id);

  channel.bind('notifications', function(notification) {
    handleNotification(notification)
  });
}

function handleNotification(notification) {
  $.notify(notification.title, {"className": "info", "position": "bottom right"});
}

$('#pageTabs a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

function getTarget(obj) {
  var targ;
  var e=obj;
  if (e.target) targ = e.target;
  else if (e.srcElement) targ = e.srcElement;
  if (targ.nodeType == 3) // defeat Safari bug
      targ = targ.parentNode;
  return targ;
}