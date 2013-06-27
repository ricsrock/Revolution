# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#tagging_tag_id').parent().hide()
  tags = $('#tagging_tag_id').html()
  $('#tagging_tag_group_id').change ->
    tag_group = $('#tagging_tag_group_id :selected').text()
    escaped_tag_group = tag_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(tags).filter("optgroup[label='#{escaped_tag_group}']").html()
    if options
      $('#tagging_tag_id').html(options)
      $('#tagging_tag_id').parent().show()
    else
      $('#tagging_tag_id').empty()
      $('#tagging_tag_id').parent().hide()
