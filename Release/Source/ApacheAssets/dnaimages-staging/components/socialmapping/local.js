

$(function() {
	
	if (!window.runonce) {
		
		//Mark can't stop laughing
		window.runonce = true;
				
		var baseFeed = "/dna/pmblog/blogsummary?dna_list_ns=movabletype?skin=purexml";
		var mcFeed = "/dna/pmblog/MC";
		
		var uniqueList = {};
		var mapping = {};
		var lookups = {};
		lookups['forumtitle'] = {};
		
		var canvasWidth = window.innerWidth;
		var canvasTop = window.innerHeight;
		
		var centreX = canvasWidth / 2;
		var centreY = canvasTop / 2;
		
		console.log(centreX);
		console.log(centreY);
		
		$('body').append('<div id="canvas" style="width: 100%; height:100%"></div>');
		var doc = $('#canvas');
		//var canvas = $('body');
		
		//console.log(baseFeed);
		doc.append('<ul id="dataset"></ul>');
		var dataset = $('#dataset');
		
		$.get(baseFeed, function(data) {
			$(data).contents("h2g2").children("recentcomments").children("post").each(function(i, el){
				
				var userid = $(el).contents("user").children("userid").text(); 
				var username = $(el).contents("user").children("username").text(); 
				
				//console.log();
				
				dataset.append('<li id="userid-'+ userid +'" style="position:absolute"><h2>'+ username +'</h2><ul></ul></li>');
				
				var node = $('#userid-' + userid);
				var nodeUl = $('#userid-' + userid + ' ul');
				
				var segment = i ;
				//var angle = ((2*Math.PI) / 5) * segment;
				var angle = (((2*Math.PI) / 5) * segment) + (Math.PI*1.5);
				
				var spatialDistance = 300;
				
				console.log(angle);
				console.log(Math.cos(angle) * spatialDistance);
				console.log(Math.sin(angle) * (spatialDistance / 2));
				
				var leftDifference = Math.round((centreX + (Math.cos(angle) * spatialDistance)) - 150);
				var topDifference = Math.round(centreY + (Math.sin(angle) * (spatialDistance / 1.5)));
				
				
				var percentageLeft = (100 / canvasWidth) * leftDifference;
				var percentageTop = (100 / canvasTop) * topDifference;
				
				//var leftDifference = centreX + (Math.cos(angle) * spatialDistance);
				//var topDifference = centreY + (Math.sin(angle) * spatialDistance);
				
				console.log({left: leftDifference, top: topDifference});
				
				//node[0].style.left = leftDifference + "px"; 
				//node[0].style.top = topDifference + "px"; 
				
				//node.css('left', leftDifference + "px"); 
				//node.css('top', topDifference + "px"); 
				 
				
				node.css('left', percentageLeft + "%"); 
				node.css('top', percentageTop + "%");
				 
				
				mapping[userid] = {};
				
				$.get(mcFeed + userid + "?skin=purexml", function(data) {
					
					//blank the list
					uniqueList = {};
					
					$(data).contents("h2g2").children("morecomments").children("comments-list").children("comments").children("comment").each(function(j, el){
						
							
							
						
						var forumtitle = $(el).contents("forumtitle").text();
						
						if (!uniqueList[forumtitle]) {
							
							uniqueList[forumtitle] = true;
							
							var url = $(el).contents("url").text();
							var comment = $(el).contents("text").text();
							var forumpostcount = $(el).contents("forumpostcount").text();
							
							//nodeUl.append('<li><a href="'+ url +'"><strong>'+ forumtitle + '</strong><blockquote>' + comment +'</blockquote></a></li>');
							nodeUl.append('<li><a href="'+ url +'"><strong>'+ forumtitle + '</strong></a></li>');
							
							mapping[userid]['forumtitle'] = forumtitle;
							mapping[userid]['url'] = url;
							mapping[userid]['comment'] = comment;
							mapping[userid]['forumpostcount'] = forumpostcount;
							
							lookups['forumtitle'][forumtitle] = {};
							lookups['forumtitle'][forumtitle]["url"] = url;
							lookups['forumtitle'][forumtitle]["comment"] = comment;
							lookups['forumtitle'][forumtitle]["userid"] = userid;
							lookups['forumtitle'][forumtitle]["username"] = username;
							lookups['forumtitle'][forumtitle]["forumpostcount"] = forumpostcount;
							
							//console.log($(el).contents("forumtitle").text());
						}
					})
				});
				
				
			});
		});
		
		setTimeout(function() {
			
			console.log(mapping)
			console.log(lookups)
		}, 1000);
		
	}
	
});