$('.close-reveal-modal').trigger('reveal:close');

$('html').click(function() {
  //Hide the search results if visible
	$('#results-list').hide();
});

$('#results-list').click(function(event){
    event.stopPropagation();
});

$(document).on('page:fetch', function() {
  $("#loading-indicator").fadeIn();
});

$(document).on('page:change', function() {
  $("#loading-indicator").hide();
});

$(function(){
	$(".search-query").observe_field(1, function( ) {
	 	var form = $(this).parents("form");
		var url = form.attr("action");
		var formData = form.serialize();
		$.get(url, formData, function(html) {
			$("#results").html(html);
		});
	});
	
	$(".range-filter-events").observe_field(1, function( ) {
	 	var form = $(this).parents("form");
		var url = form.attr("action");
		var formData = form.serialize();
		$.get(url, formData, function(html) {
			$("#results").html(html);
		});
	});
	
	$(".filter-contacts-by-form").observe_field(1, function( ) {
	 	var form = $(this).parents("form");
		var url = form.attr("action");
		var formData = form.serialize();
		$.get(url, formData, function(html) {
			$("#results").html(html);
		});
	});
	
	$(".group-jumper").observe_field(1, function( ) {
		var data = {'group_id' : $(this).val()};
		var url = '/groups/jump_to';
		$.get(url, data, function(html) {
			$("#property_operator").html(html);
		});
	});
	
	$("#the_last_name_button").bind("click", function() {
		var data = {'search_choice' : 'last_name'};
		var url = '/checkin/search_choice';
		$.get(url, data, function(html) {
			$("#property_operator").html(html);
		});
	});
	
	$("#the_phone_number_last_4_button").bind("click", function() {
		var data = {'search_choice' : 'phone_number'};
		var url = '/checkin/search_choice';
		$.get(url, data, function(html) {
			$("#property_operator").html(html);
		});
	});
	
	$("#q_tag_tag_group_id_eq").observe_field(1, function( ) {
	 	var data = {'tag_group_id' : $(this).val()};
		var url = '/taggings/tag_group_selected';
		$.get(url, data, function(html) {
			$("#results").html(html);
		});
	});
	
	$(".live-search-household").observe_field(1, function( ) {
		var url = '/people/search_household';
		var data = { 'q' : $(this).val() };
		$.get(url, data);
	});
	$(".live-search-person").observe_field(1, function( ) {
		var url = '/people/search_person';
		var data = { 'q' : $(this).val(), 'duplicate_id' : $(this).data('duplicate-id') };
		$.get(url, data);
	});
	
	
	
	$(".property_selector").observe_field(1, function( ) {
		var data = $this.val();
		alert(data);
	});	
	
	$(".timepicker").timepicker({
		step:    5
	});
	
	$( '#toggle' ).click( function () {
	    $( 'input[type="checkbox"]:enabled' ).prop('checked', this.checked)
	  })
	
});
