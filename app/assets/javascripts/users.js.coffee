# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#user_person_name').autocomplete
    source: $('#user_person_name').data('autocomplete-source')