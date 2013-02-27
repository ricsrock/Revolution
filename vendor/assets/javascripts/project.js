$('.close-reveal-modal').trigger('reveal:close');

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
});
