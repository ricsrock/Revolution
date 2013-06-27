$('#myModal').html("<%= j render :partial => 'taggings/form', :tagging => @tagging %>")
tags = $('#tagging_tag_id').html()
$('#tagging_tag_group_id').change ->
  tag_group = $('#tagging_tag_group_id :selected').text()
  escaped_tag_group = tag_group.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
  options = $(tags).filter("optgroup[label='#{tag_group}']").html()
  if options
    $('#tagging_tag_id').html(options)
    $('#tagging_tag_id').parent().show()
  else
    $('#tagging_tag_id').empty()
    $('#tagging_tag_id').parent().hide()

$('.datepicker').datepicker({ dateFormat: "yy-mm-dd" })

