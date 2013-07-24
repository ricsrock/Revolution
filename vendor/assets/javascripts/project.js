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
	
	// $("#print-label").click(function( ) {
	// 	// var label = dymo.label.framework.openLabelXml(labelXml);
	// 
	//     // label.setObjectText(“Address”, “DYMOn828 San Pablo AvenAlbany CA 94706”);
	// 	// $.get("lib/assets/labels/AddressTest.label", function(labelXml)
	// 	// {
	// 		var labelXml = '<?xml version="1.0" encoding="utf-8"?>\
	// 		<DieCutLabel Version="8.0" Units="twips">\
	// 		  <PaperOrientation>Landscape</PaperOrientation>\
	// 		  <Id>Address</Id>\
	// 		  <PaperName>30252 Address</PaperName>\
	// 		  <DrawCommands>\
	// 		    <RoundRectangle X="0" Y="0" Width="1581" Height="5040" Rx="270" Ry="270"/>\
	// 		  </DrawCommands>\
	// 		  <ObjectInfo>\
	// 		    <TextObject>\
	// 		      <Name>TEXT</Name>\
	// 		      <ForeColor Alpha="255" Red="0" Green="0" Blue="0"/>\
	// 		      <BackColor Alpha="0" Red="255" Green="255" Blue="255"/>\
	// 		      <LinkedObjectName></LinkedObjectName>\
	// 		      <Rotation>Rotation0</Rotation>\
	// 		      <IsMirrored>False</IsMirrored>\
	// 		      <IsVariable>False</IsVariable>\
	// 		      <HorizontalAlignment>Left</HorizontalAlignment>\
	// 		      <VerticalAlignment>Middle</VerticalAlignment>\
	// 		      <TextFitMode>AlwaysFit</TextFitMode>\
	// 		      <UseFullFontHeight>True</UseFullFontHeight>\
	// 		      <Verticalized>False</Verticalized>\
	// 		      <StyledText>\
	// 		        <Element>\
	// 		          <String>t</String>\
	// 		          <Attributes>\
	// 		            <Font Family="Lucida Grande" Size="13" Bold="False" Italic="False" Underline="False" Strikeout="False"/>\
	// 		            <ForeColor Alpha="255" Red="0" Green="0" Blue="0"/>\
	// 		          </Attributes>\
	// 		        </Element>\
	// 		        <Element>\
	// 		          <String>he text</String>\
	// 		          <Attributes>\
	// 		            <Font Family="Lucida Grande" Size="13" Bold="False" Italic="False" Underline="False" Strikeout="False"/>\
	// 		            <ForeColor Alpha="255" Red="0" Green="0" Blue="0"/>\
	// 		          </Attributes>\
	// 		        </Element>\
	// 		      </StyledText>\
	// 		    </TextObject>\
	// 		    <Bounds X="331.2" Y="57.59995" Width="4622.4" Height="1435.2"/>\
	// 		  </ObjectInfo>\
	// 		</DieCutLabel>';
	// 	    var label = dymo.label.framework.openLabelXml(labelXml);
	// 	    // label.setObjectText(“Address”, “DYMOn828 San Pablo AvenAlbany CA 94706”);
	// 	    // label.print(“DYMO LabelWriter 450 Turbo”);
	// 		// alert(labelXml);
	// 	// });
	// 	var printers = dymo.label.framework.getPrinters();
	// 	if (printers.length == 0)
	// 	    throw "No DYMO printers are installed. Install DYMO printers.";
	// 
	// 	var printerName = "";
	// 	for (var i = 0; i < printers.length; ++i)
	// 	{
	// 	    var printer = printers[i];
	// 	    if (printer.printerType == "LabelWriterPrinter")
	// 	    {
	// 	        printerName = printer.name;
	// 	        break;
	// 	    }
	// 	}
	//     label.print(printerName);
	// 	// alert(printerName);
	// });
});
