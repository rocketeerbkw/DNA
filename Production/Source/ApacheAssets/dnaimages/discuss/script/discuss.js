
var dna = dna || function() {};

dna.utils = dna.utils || function() {
	var g = glow,
		$ = g.dom.get
		days = {
			0: 'Sunday',
			1: 'Monday',
			2: 'Tuesday',
			3: 'Wednesday',
			4: 'Thursday',
			5: 'Friday',
			6: 'Saturday'
		},
		months = {
			 0: 'January',
			 1: 'February',
			 2: 'March',
			 3: 'April',
			 4: 'May',
			 5: 'June',
			 6: 'July',
			 7: 'August',
			 8: 'September',
			 9: 'October',
			10: 'November',
			11: 'December',
		}
		;
	
	/*
	 * Removes all newline, tabs and double space characters from
	 * str - useful for making incoming JSON data valid.
	 */
	function cleanWhitespace(str) {
		return str.replace(/(\n|\r|\t|\s\s)/gi, "");
	}
	
	function filterByAttribute (selector, attribute, value) {
		return $(selector).filter(function() {
			return this[attribute] == value;
		});
	}
	
	function daySuffix(day) {
		switch (day) {
			case 1 || 01: return 'st'; break;
			case 2 || 02: return 'nd'; break;
			case 3 || 03: return 'rd'; break;
			default: return 'th'; break;
		}
	}

	
	return {
		cleanWhitespace: cleanWhitespace,
		filterByAttribute: filterByAttribute,
		days: days,
		months: months,
		daySuffix: daySuffix
	}
}();

dna.discuss = function () {
	
	var	g = glow,
		$ = g.dom.get,
		bind = g.events.addListener,
		xhr = g.net.get;
	
	
	function ready() {
		
		
		// date thing first
		enhance.date();
	}
	
	var enhance = {
		date: function () {
			var targetNodes = $('div.commentforumlist span.date');
			
			targetNodes.each(function(i){
			
				
				//$(targetNodes[i]).;
				// hide the form
				// store the yyyymmdd in the form txt
				// 
				
				$(targetNodes[i]).parent().next().css('display', 'none');
				
				g.dom.create('<span class="clickToEdit">click to edit</span>').appendTo(targetNodes[i]);
				
				bind($(targetNodes[i]), 'click', function() {
					
					var el = $(this);
					
					var dateForm = $(this).parent().next()
					var dateField = dateForm.get('.text');
					
					var txt = g.dom.create('<input type="text" name="123" value="'+ dateField.val() +'" class="text"/>').insertAfter(el);
					
					bind(txt, 'blur', function() {
						
						dateField.val(txt.val());
								
						txt.remove();
						el.css('display', '');
						
						//console.log(dateForm);
						g.net.post('json/commentforumlist',
						{
							dnauid:			dateForm[0].dnauid.value,
							dnaaction:		dateForm[0].dnaaction.value,
							dnasiteid:		dateForm[0].dnasiteid.value,
							dnahostpage:	dateForm[0].dnahostpage.value,
							dnaskip:		dateForm[0].dnaskip.value,
							dnashow:		dateForm[0].dnashow.value,
							
							dnanewforumclosedate: dateField.val()
						},
						{
							onLoad: function(response) {
								//Evaluate the response and get the JSON responseObjectect from it.
								var responseObject = glow.data.decodeJson(dna.utils.cleanWhitespace(response.text()), {safeMode:false});
								
								//console.log(responseObject);
								
								if (responseObject && responseObject.error && responseObject.error.errorMessage) {
									
									alert("Your changes were not saved. The reason given by the server was: " + responseObject.error.errorMessage);
								} else {
									
									var d = new Date(),
										year = dateField.val().substr(0, 4),
										month = dateField.val().substr(4, 2) - 1,
										day = dateField.val().substr(6, 2);
									
									//console.log(year);
									//console.log(month);
									//console.log(day);
									
									
									d.setFullYear(year, month, day);
									
									//var newMonth = d.toString().split(' ')[1];
									//TODO bug - loose a day on the way to dna :S
									var prettyDate = dna.utils.days[d.getDay()] + ', ' + day + dna.utils.daySuffix(day) + ' ' + dna.utils.months[d.getMonth()] + ' ' + d.getFullYear();
									
									el[0].innerHTML = 'Closes ' + prettyDate + '<span class="clickToEdit">click to edit</span>';
								}
							}
						});
						
					});
					
					txt[0].focus();
					
				//	console.log(txt);
					
					el.css('display', 'none');
					
				})
				
				
			});
			
		}
	}
	
	return {
		ready: ready
		}
}();


glow.ready(function() {
	
	dna.discuss.ready();
});