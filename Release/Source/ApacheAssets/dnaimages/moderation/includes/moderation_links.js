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
    //hideClass("edit");
    //hideClass("editText");
    hideClass("reasonText");
    //hideClass("urlText");
    hideClass("emailText");
    //hideClass("failReason");

    addEventToClass("type", "change", decisionChange, false)
    addEventToClass("failReason", "change", failChange, false);
    addEventToClass("referName", "change", referChange, false);
    //addEventToClass("editReason", "change", editChange, false);

    var allDecisions = getElementsByClass("type");
    for (var i = 0; i < allDecisions.length; i++) {
        showCorrectForm(allDecisions[i]);
    }

    var modForm = document.getElementById("LinksModerationForm");
    addEvent(modForm, 'submit', checkSubmission, false);
}

//The submission checking function checks the decision dropdowns and then cross checks against the
//edit and refer dropdowns to make sure they have been properly selected.
function checkSubmission(e) {
    var allDecisions = getElementsByClass("type");
    for (var i = 0; i < allDecisions.length; i++) {
        if (!checkDecision(allDecisions[i])) {
            if (window.event) {
                window.event.returnValue = false;
            }
            if (e && e.preventDefault) {
                e.preventDefault();
            }
        }
    }
}

//Part of the submission check, this function takes each decision dropdown and makes sure it's partner
//edit and failure dropdowns have been correctly selected from. 
//It shows an alert and then takes the user to the incorrect dropdown and cancels the submission if
//there is a problem
function checkDecision(decisionSelect) {
    var changedForm = document.getElementById('form' + decisionSelect.options[0].className);

   // var editSelect = getChildByClassName(changedForm, 'editReason');

    var failureSelect = getChildByClassName(changedForm, 'failReason');
    var failureValue = failureSelect.value;

    var referSelect = getChildByClassName(changedForm, 'referName');
    var referValue = referSelect.value;
    var referNotes = getChildByClassName(changedForm, 'reasonArea');

    var decisionChoice = decisionSelect.value;

    switch (decisionChoice) {
        // decision is pass 
        case "3":
            return true;
            break;

        // decision is edit and fail 
        case "6":
            return true;
            break;

        // decision is fail 
        case "4":
            if (failureSelect.options[0].selected == 1) {
                alert("You have not given a failure reason");
                failureSelect.style.display = "block";
                failureSelect.focus();
                return false;
            }
            else {
                return true;
            }
            break;

        // decision is refer 
        case "2":
            if (referSelect.options[0].selected == 1) {
                alert("You have not given a referral name");
                referSelect.focus();
                return false;
            }
            else if (referNotes.value == ' ' | referNotes.value == '') {
                alert("You have not given a referral reason");
                referNotes.focus();
                return false;
            }
            else {
                return true;
            }
            break;
    }
}

//This is the main function which deals with each of the seperate decision areas and shows the correct
//form fields depending on which decision has been selected
function showCorrectForm(decisionSelect) {
    //First we get a pointer to the correct area of the form
    var changedForm = document.getElementById('form' + decisionSelect.options[0].className);

    //Then we get pointers and values for the various chunks of that part of the form
    var referSelect = getChildByClassName(changedForm, 'referName');
    var referText = getChildByClassName(changedForm, 'reasonText');

    var failureSelect = getChildByClassName(changedForm, 'failReason');
    var failureValue = failureSelect.value;

    //var urlText = getChildByClassName(changedForm, 'urlText');
    var emailText = getChildByClassName(changedForm, 'emailText');

    //Finally we gather a decision value which we run a case statement on 
    var decisionChoice = decisionSelect.value;

    switch (decisionChoice) {
        // decision is pass 
        case "3":
            referSelect.style.display = "none";
            referText.style.display = "none";
            //urlText.style.display = "none";
            
            referSelect.options[0].selected = 1;
            failureSelect.options[0].selected = 1;
            failureSelect.style.display = "block"; //always show the fail reason and default it to first option
            break;

        

        // decision is fail 
        case "4":

            referText.style.display = "none";
            referSelect.style.display = "none"
            failureSelect.style.display = "block";

            
            referSelect.options[0].selected = 1;
            break;

        // decision is refer 
        case "2":
            
            
            referText.style.display = "block";
            referSelect.style.display = "block"

            failureSelect.options[0].selected = 1;
            failureSelect.style.display = "none";
            break;
    }

    return;
}



//If the decision dropdown is changed we capture the event and call the form changer function
function decisionChange(e) {
    if (window.event) {
        var eventSource = window.event.srcElement;
    }
    else {
        var eventSource = e.target;
    }

    showCorrectForm(eventSource);
}

//If the failure dropdown is changed we capture the event and change the value of the decision dropdown
//We then call the form changer function now that the decision dropdown has the correct value
function failChange(e) {
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
        decisionObject.value = 3; //revert back to pass if no fail option chosen
    }
    else {
        decisionObject.value = 4;
    }

    showCorrectForm(decisionObject);
}

//If the refer dropdown is changed we capture the event and change the value of the decision dropdown
//We then call the form changer function now that the decision dropdown has the correct value
function referChange(e) {
    if (window.event) {
        var eventSource = window.event.srcElement;
    }
    else {
        var eventSource = e.target;
    }

    var changedForm = document.getElementById('form' + eventSource.options[0].className);
    var decisionObject = getChildByClassName(changedForm, 'type');
    decisionObject.value = 2;

    showCorrectForm(decisionObject);
}



//This is a cross browser addEvent function
function addEvent(element, event, func, useCapture) {
    if (element == null) {
        alert(event);
    }
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
    if (node == null)
        node = document;
    if (tag == null)
        tag = '*';
    var els = node.getElementsByTagName(tag);
    var elsLen = els.length;
    var pattern = new RegExp("(^|\\s)" + searchClass + "(\\s|$)");
    for (var i = 0, j = 0; i < elsLen; i++) {
        if (pattern.test(els[i].className)) {
            classElements[j] = els[i];
            j++;
        }
    }
    return classElements;
}

//This function allows you to find the first child of an element with a particular class name
function getChildByClassName(sourceElement, name) {
    if (sourceElement == null) {
        alert(name);
    }
    
    var descendents = sourceElement.getElementsByTagName('*');

    for (var i = 0; i < descendents.length; i++) {
        if (descendents[i].className == name) {
            return descendents[i];
        }
    }
}

//This function finds all elements of a class and hides them
function hideClass(className) {
    classObjects = getElementsByClass(className);
    for (var i = 0; i < classObjects.length; i++) {
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
