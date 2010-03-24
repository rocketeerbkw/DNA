var selectedIe=null;
var selectedMoz=null;
var agt=navigator.userAgent.toLowerCase();
var isOpera = (agt.indexOf("opera") != -1);

if (isOpera){
	alert("Sorry - This doesn't work in Opera (because the DOM is rubbish).\n\nPlease use Moz or IE, who've both implemented their own weird ways of using selected text.");
} else if (document.selection) { //ie select method
	selectedIe = true
} else if (window.getSelection) { //moz & co select method
	selectedMoz = true
} else {
	alert("Sorry, your browser appears to be rubbish\n\nPlease use Moz or IE.");
}

//Formatting functions
function format(node,type){ 
	if (selectedIe){ //ie formatting
		txtarea = document.selection.createRange().text;
		if (txtarea) {
			if(type=="openclose"){ 
				document.selection.createRange().text = "<" + node + ">" + txtarea + "</" + node + ">";
			} else if (type=="link") {
				href=prompt("Please enter the url you want the selected text to link to:\n(Including the full http:// if required)","");
				document.selection.createRange().text = "<a href='" + href + "'>" + txtarea + "</a>";
			} 
		} else {
			alert("Please select some text to format")
		}
	} else if (selectedMoz) { //moz formatting
		txtarea = document.textandimage.text;
		if (txtarea) {
			selLength = txtarea.textLength;
			selStart = txtarea.selectionStart;
			selEnd = txtarea.selectionEnd;
			var s1 = (txtarea.value).substring(0,selStart);
			var s2 = (txtarea.value).substring(selStart, selEnd);
			var s3 = (txtarea.value).substring(selEnd, selLength);
			if(type=="openclose"){
				txtarea.value = s1 + "<" + node + ">" + s2 + "</" + node + ">" + s3;
			} else if (type=="link") {
				href=prompt("Please enter the url you want the selected text to link to:\n(Including the full http:// if required)","");
				txtarea.value = s1 + "<a href='" + href + "'>" + s2 + "</a>" + s3;
			} 
		}
	}
}


function promoSelected() {
	document.choosetype.page.value = "choosetemplate";
}

function guideMLSelected() {
	document.choosetype.page.value = "textandimage";
}
 