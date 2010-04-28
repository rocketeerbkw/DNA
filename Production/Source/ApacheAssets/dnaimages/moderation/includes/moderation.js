// JavaScript Document
function durationChange() {
	statusObject = document.getElementById("statusSelect");
	textObject = document.getElementById("statusText");
	durationObject = document.getElementById("statusDuration");
	if (statusObject.selectedIndex == 1 | statusObject.selectedIndex == 2 | statusObject.selectedIndex == 3) {
		textObject.style.display = "block";
		durationObject.style.display = "block";
	}
	else {
		textObject.style.display = "none";
		durationObject.style.display = "none";
	}
}

function popupwindow(link, target, parameters) {
	popupWin = window.open(link,target,parameters);
}



