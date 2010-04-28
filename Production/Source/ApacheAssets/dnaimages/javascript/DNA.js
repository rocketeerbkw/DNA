gloader.load(
	["glow", "1", "glow.events", "glow.dom", "glow.forms"], 
		{
			async: true,
			onLoad: function(glow) {
				glow.ready(function() {
					glow.events.addListener(
						'.popup',
						'click',
						function (e) { 
							window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=800,height=500');
							return false; 
						}
					);
					
					glow.events.addListener(
		            	'#dna-boards-cancel',
		                'click',
		                 function () { 
			             	history.back();
		                 }
                    );
                    
                    glow.events.addListener(
						'a.close',
						'click',
						function(e) { 
							e.stopPropagation();
							window.close();
							return false;
						}
					);
					
					glow.events.addListener(
						'#countdown',
						'load',
						function() {
							minutesSpan = glow.dom.get('#minuteValue');
							secondsSpan = glow.dom.get('#secondValue')
							minutes = minutesSpan.text;
						    seconds = secondsSpan.text;
						    inSeconds = (minutes*60) + seconds;
						    timeNow = inSeconds - 1;
						    
						    if (timeNow > 0){
						      scratchPad = timeNow / 60;
						      minutesNow = Math.floor(scratchPad);
						      secondsNow = (timeNow - (minutesNow * 60));
						      
						      minutesSpan.text(minutesNow);
						      secondsSpan.text(secondsNow);
						    }
						}
					);
					if (typeof identity !== 'undefined') {
						glow.events.addListener(identity,'logout',function(){
							(glow.dom.get('li#mydiscussions')) ? glow.dom.get('li#mydiscussions').hide() : '';
							(glow.dom.get('ul.admin')) ? glow.dom.get('ul.admin').remove() : '';
							(glow.dom.get('.dna-boards-moderation')) ? glow.dom.get('.dna-boards-moderation').remove() : '';
						});
						
						glow.events.addListener(identity,'login',function(){
							window.location.reload();
						});
					}
				})
			}
		}
	);

//this is for messageboards only
function countDown() {
    var minutesSpan = document.getElementById("minuteValue");
    var secondsSpan = document.getElementById("secondValue");
    
    var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
    var seconds = new Number(secondsSpan.childNodes[0].nodeValue);
    
    var inSeconds = (minutes*60) + seconds;
    var timeNow = inSeconds - 1;
    
    if (timeNow > 0){
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