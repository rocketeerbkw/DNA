gloader.load(
	["glow", "1", "glow.events", "glow.dom", "glow.forms"], 
		{
			async: true,
			onLoad: function(glow) {
				glow.ready(function() {
					
					//speed bump countdown
					var bumper;
					
					if (glow.dom.get('p').hasClass('countdown'))
					{
						bumper = glow.dom.get('p.countdown');
					}
	                    
	                if (bumper != null)//remove null
	                {
						var speedBumpTimeLeft = glow.dom.get('span#totalSeconds').text();
		        	   
				        speedBumpTime = setInterval(function() 
			            {
			        		--speedBumpTimeLeft;
			        		
			        		var speedBumpMinsLeft = Math.floor(speedBumpTimeLeft/60);
			        		var speedBumpSecsLeft = speedBumpTimeLeft % 60;
			        		var minsText = 'minutes';
			        		
			        		if (speedBumpMinsLeft == 1)
			        		{
			        			minsText = 'minute';
			        		}
			                
			                bumper.html('<strong>You must wait ' + speedBumpMinsLeft + ' ' + minsText + ' ' + speedBumpSecsLeft + ' secs before you can post again</strong>');
			                
			                if (speedBumpTimeLeft == 0)
			                {
			                    clearInterval(self.speedBumpTime);
			                    bumper.empty();
			                }
			                
			            }, 1000);
                    }
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
		            	'#dna-boards-cancel-blocked',
		                'click',
		                 function () { 
			             	history.go(-2);
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