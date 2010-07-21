// JavaScript Document
/********************************************************************************************/
/****The following deals with the form manipulation and checking for the post moderation*****/
/********************************************************************************************/

//This adds the onload event to prepare the form
addEvent(window, 'load', initialiseForm, false);

//This function hides the unwanted form elements then adds events to the necessary form elemenst
//It then runs through all of the decision dropdowns to make sure that the correct parts of the
//form are showing
//Finally it adds the submission checking event
function initialiseForm() {
	addEventToClass("type", "change", decisionChange, false)
	addEventToClass("failReason", "change", failChange, false);
  }

//If the decision dropdown is changed we capture the event and call the form changer function
function decisionChange(e){
  if (window.event) {
    var eventSource = window.event.srcElement;
  }
  else {
    var eventSource = e.target;
    }

    var changedForm = document.getElementById('form' + eventSource.options[0].className);
    var decisionObject = getChildByClassName(changedForm, 'type');
    var failReasonObject = getChildByClassName(changedForm, 'failReason');
    if (decisionObject.options[decisionObject.selectedIndex].value == 3) {//selected pass
        failReasonObject.options[0].selected = true;
    }

}

//If the failure dropdown is changed we capture the event and change the value of the decision dropdown
//We then call the form changer function now that the decision dropdown has the correct value
function failChange(e){
  if (window.event) {
    var eventSource = window.event.srcElement;
  }
  else {
    var eventSource = e.target;
  }

  var changedForm = document.getElementById('form' + eventSource.options[0].className);
  var decisionObject = getChildByClassName(changedForm, 'type');
  var failReasonValue = eventSource.value;
  if (eventSource.options[0].selected) {
      decisionObject.value = 3;//revert back to pass if no fail option chosen
  }
  else {
      decisionObject.value = 4;
  }
}



//This is a cross browser addEvent function
function addEvent(element, event, func, useCapture){
  if (element.addEventListener) {
    element.addEventListener(event, func, useCapture);
    return true;
  }
  else if (element.attachEvent) {
    var r = element.attachEvent('on' + event, func);
    return r;
  }
  else {
    element['on' + event] = func;
  }
}

//This is a function which allows you to get elements by class name
function getElementsByClass(searchClass, node, tag) {
	var classElements = new Array();
	if ( node == null )
		node = document;
	if ( tag == null )
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
	for (var i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}

//This function allows you to find the first child of an element with a particular class name
function getChildByClassName(sourceElement, name){
  var descendents = sourceElement.getElementsByTagName('*');
  
  for (var i=0; i < descendents.length; i++) {
    if (descendents[i].className == name){
      return descendents[i];
    }
  }
}

//This function finds all elements of a class and hides them
function hideClass(className) {
	classObjects = getElementsByClass(className);
	for (var i=0; i < classObjects.length; i++) {
		classObjects[i].style.display = "none";
	}	
	return true;
}

//This function adds an event to all elements of a particular class
function addEventToClass(className, event, func, useCapture) {
  var classObjects = getElementsByClass(className);
  
  for (var i = 0; i < classObjects.length; i++) {
    addEvent(classObjects[i], event, func, useCapture);
  }  
  return true;
}
