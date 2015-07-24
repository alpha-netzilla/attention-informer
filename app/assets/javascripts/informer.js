
function pie_graph(){
	var canvas = document.getElementById("pie_graph")
	var ctx = canvas.getContext("2d");

	count_ratio = $('#ratio').data("ratio");
	contact = $('#contact').data("contact");

	var pieData = [{
		value: count_ratio,
		color: "#ff0066",//#F7464A
		highlight: "#ff60af",
		label: "Negative"
	},
	{
		value: 100 - count_ratio,
		color: "#0066ff",
		highlight: "#60afff",
		label: "Positive"
	}];

	window.myPie = new Chart(ctx).Pie(pieData,{
		animationEasing: "easeOutQuart",
		animateRotate : true,
		segmentStrokeWidth : 1,
		animationSteps : 80,
		percentageInnerCutout : 17,
		segmentStrokeColor : "#888888",
	});


	if(count_ratio >= 5) {
		$("#attention").show()
		//$.get('../twilio/auth', {to: <%= contact %> });
	}
};


function load_begin() {
	$("#loading").hide();
	$("#attention").hide();
	$("#loading").show()
}


function load_end() {
	$("#loading").hide();
	$("#attention").hide();
	pie_graph();
}

function ajax() {
	$(document).ajaxStart (load_begin);
  $(document).ajaxComplete (load_end);
	$(document).ajaxError (function(event, xhr, options) {
    $("#loading").html("ERROR: " + event);
	});
};


function scrollbar() {
	$('#positive').perfectScrollbar();
	$('#negative').perfectScrollbar();
}

function prepare() {
	ajax();
	scrollbar();
};


$(document).ready(prepare);
$(document).on('page:load', prepare);


