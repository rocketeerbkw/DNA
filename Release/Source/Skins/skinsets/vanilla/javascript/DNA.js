gloader.load(
	["glow", "1", "glow.events", "glow.dom"], 
	{
		async: true,
			onLoad: function(glow) {
				glow.ready(function() {
					glow.events.addListener(
						'.popup',
						'click',
						function () { 
							window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=600,height=500');
							return false; 
					}
				);
				glow.events.addListener(
					'#countdown',
					'load',
					countDown
				);
			})
		}
	}
);

function countDown() {
	var minutesSpan = document.getElementById("minuteValue");
	var secondsSpan = document.getElementById("secondValue");
	
	var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
	var seconds = new Number(secondsSpan.childNodes[0].nodeValue);
	
	var inSeconds = (minutes*60) + seconds;
	var timeNow = inSeconds - 1;
	
	if (timeNow >= 0){
		var scratchPad = timeNow / 60;
		var minutesNow = Math.floor(scratchPad);
		var secondsNow = (timeNow - (minutesNow * 60));
		
		var minutesText = document.createTextNode(minutesNow);
		var secondsText = document.createTextNode(secondsNow);
		
		minutesSpan.removeChild(minutesSpan.childNodes[0]);
		secondsSpan.removeChild(secondsSpan.childNodes[0]);
		
		minutesSpan.appendChild(minutesText);
		secondsSpan.appendChild(secondsText);
	}
}