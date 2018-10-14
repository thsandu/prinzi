var PRINZI = {};

PRINZI.delete_smaller = function(selected_value) {
	var selection = document.getElementById("verfugbarkeit_ende");
	var option_value;
	var tmp_option;
	var select_new_index;
	for(var i = selection.options.length - 1; i >= 0; i--) {
		option_value = selection[i].value;
		tmp_option = selection[i];
		if(option_value < selected_value){
			// selection.remove(i);
			tmp_option.disabled = true;
		} else {
			tmp_option.disabled = false;
			select_new_index = i;

		}
	}
	selection.selectedIndex = select_new_index;
};

PRINZI.reset_ende_options

$(document).ready(function() {
// oncklick stunde
	var selection = document.getElementById("verfugbarkeit_start_4i");
	// var selection = $('verfugbarkeit_start_4i');
	var option_selected;
	var option_element;
	var tmp_option;
	var selected_index;
	var all_options;
	// var selection = document.querySelector("#verfugbarkeit_status");
	
	$(selection).on("change", function( event ){
		selected_index = selection.selectedIndex;
		PRINZI.delete_smaller(selection[selected_index].value);
	});
});