# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g') # creates a RegExp to find all instances of 'id'
    $(this).before($(this).data('fields').replace(regexp, time)) #// inserts 'fields' before 'this' (the link) and replaces 'id' with 'time'
    event.preventDefault()
    $('.datepicker').datepicker({ dateFormat: "yy-mm-dd" })
    $('.person_picker').autocomplete({source: $('.person_picker').data('autocomplete-source')})

  $('.datepicker').datepicker({ dateFormat: "yy-mm-dd" })
  
