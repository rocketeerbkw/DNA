function showButtons(divId) {
	if (document.getElementById) {
		document.getElementById(divId).style.color='#000000';
	} else if (document.all){ 
		document.all[divId].style.color='#000000';
	}
}

function hideButtons(divId) {
	if (document.getElementById) {
		document.getElementById(divId).style.color='#999999';

	} else if (document.all){ 
		document.all[divId].style.color='#999999';
	}
}

function showDropdowns(selectName) {
	var selects = new Array;
	
	for (i = 0; i < document.schedule.elements.length; i++){
		if (document.schedule.elements[i].type == 'select-one'){
			selects.push(document.schedule.elements[i]);
		}
	}
	
	if (selectName == 'sameTime'){
		for (i = 0; i < 4; i++) {
			selects[i].disabled = false;
		}
	}
	else {
		for (i = 4; i < selects.length; i++) {
			selects[i].disabled = false;
		}
	}
}

function hideDropdowns(selectName) {
	var selects = new Array;
	
	for (i = 0; i < document.schedule.elements.length; i++){
		if (document.schedule.elements[i].type == 'select-one'){
			selects.push(document.schedule.elements[i]);
		}
	}
	
	if (selectName == 'sameTime'){
		for (i = 0; i < 4; i++) {
			selects[i].disabled = true;
		}
	}
	else {
		for (i = 4; i < selects.length; i++) {
			selects[i].disabled = true;
		}
	}
}

function showCheckboxes() {
	var checks = new Array;
	
	for (i = 0; i < document.schedule.elements.length; i++){
		if (document.schedule.elements[i].type == 'checkbox'){
			checks.push(document.schedule.elements[i]);
		}
	}
	
	for (i = 0; i < checks.length; i++) {
		checks[i].disabled = false;
	}
	
}

function hideCheckboxes() {
	var checks = new Array;
	
	for (i = 0; i < document.schedule.elements.length; i++){
		if (document.schedule.elements[i].type == 'checkbox'){
			checks.push(document.schedule.elements[i]);
		}
	}
	
	for (i = 0; i < checks.length; i++) {
		checks[i].disabled = true;
	}
	
}

function twentyfoursevenSelected() {
	hideButtons('sameTime');
	hideButtons('differentTime');
	hideDropdowns('sameTime');
	hideDropdowns('differentTime');
	hideCheckboxes();
}

function sameeverydaySelected() {
	showButtons('sameTime');
	hideButtons('differentTime');
	showDropdowns('sameTime');
	hideDropdowns('differentTime');
	hideCheckboxes();
}

function eachdaySelected() {
	hideButtons('sameTime');
	showButtons('differentTime');
	hideDropdowns('sameTime');
	showDropdowns('differentTime');
	showCheckboxes();
}

function intialise () {
	if (document.schedule.updatetype[0].defaultChecked == true) {
		twentyfoursevenSelected();
	}
	else if (document.schedule.updatetype[1].defaultChecked == true) {
		sameeverydaySelected();
	}
	else {
		eachdaySelected();
	}
	
}

     function findTime(HO_select, MO_select, HC_select, MC_select, Time_div, closedAllday)
     {
     var hoursOpen = document.getElementById(HO_select).value * 1;
     var minsOpen = document.getElementById(MO_select).value * 1;
     var hoursClose = document.getElementById(HC_select).value * 1;
     var minsClose = document.getElementById(MC_select).value * 1;
     
     
              
     if (minsOpen != 0) {hoursOpen = hoursOpen + 1};
      
	if (hoursOpen == 23 && hoursOpen < hoursClose) {hoursOpen = 0};
    
     var hoursCalc = hoursClose - hoursOpen;
         
     if (minsOpen == 15) 
     {
     minsOpen = 45;
     } else {
     if (minsOpen == 45) {minsOpen = 15};
     }   
     
     var minsCalc = minsClose + minsOpen;
     
     if (minsCalc == 60) {
     hoursCalc = hoursCalc + 1;
     minsCalc = 00;
     }
     
 	if (minsCalc == 75){
     hoursCalc = hoursCalc + 1;
     minsCalc = 15;
     }  
     
      if (minsCalc == 90){
     hoursCalc = hoursCalc + 1;
     minsCalc = 30;
     }  
     
     document.getElementById(Time_div).innerHTML = "Open for " + hoursCalc + " hrs " + minsCalc + " mins" 
     
     	if (hoursCalc < 0) {document.getElementById(Time_div).innerHTML = "you have set the board to open after it closes!"}; 
     	
     	if (hoursOpen == 00 && hoursClose == 00 && minsOpen == 00 && minsClose == 00) {document.getElementById(Time_div).innerHTML = "Open for 24 hrs 00 mins"};  
     	
      if (document.getElementById(closedAllday).checked) {document.getElementById(Time_div).innerHTML = "Closed all day"};
     
}
function timeLoader() {

findTime('7HoursOpen_select', '7MinsOpen_select', '7HoursClose_select', '7MinsClose_select', '7Time_div', '7ClosedAllDay');
findTime('0HoursOpen_select', '0MinsOpen_select', '0HoursClose_select', '0MinsClose_select', '0Time_div', '0ClosedAllDay');
findTime('1HoursOpen_select', '1MinsOpen_select', '1HoursClose_select', '1MinsClose_select', '1Time_div', '1ClosedAllDay');
findTime('2HoursOpen_select', '2MinsOpen_select', '2HoursClose_select', '2MinsClose_select', '2Time_div', '2ClosedAllDay');
findTime('3HoursOpen_select', '3MinsOpen_select', '3HoursClose_select', '3MinsClose_select', '3Time_div', '3ClosedAllDay');
findTime('4HoursOpen_select', '4MinsOpen_select', '4HoursClose_select', '4MinsClose_select', '4Time_div', '4ClosedAllDay');
findTime('5HoursOpen_select', '5MinsOpen_select', '5HoursClose_select', '5MinsClose_select', '5Time_div', '5ClosedAllDay');
findTime('6HoursOpen_select', '6MinsOpen_select', '6HoursClose_select', '6MinsClose_select', '6Time_div', '6ClosedAllDay');

}

