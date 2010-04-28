var dna = function () {
	
	var g = glow;
	var $ = g.dom.get;
	
	/*
	 * DNA Error Surfacing
	 */
	
	var error = {
		/*
		 * Bank of all error types and associated messages
		 */
		bank: {
			//Comment specific
			500: "We are currently experiencing problems accepting comments.",
			404: "Could not send your comment, please check your Internet Connection.",
			couldNotSendComment: "There was a problem sending your comment, please try again.",
			
			//Dna specific
			XmlParseError: "You comment included invalid HTML and could not be added. Please try entering your message again.",
			profanityblocked: "Your comment was failed by the profanity filter.",
			invalidcomment: "Type your comment into the text area and then press 'Post Comment'.",
			
			unknown: "There has been an unexpected problem. Please reload the page and try again."
		},
		
		/*
		 * Processes an error using the Bank key
		 */
		handle: function(type) {
			if (error.bank[type]) {
				error.notify(error.bank[type]);
			} else {
				error.notify(error.bank.unknown);
			}
		},
		
		/*
		 * Surfaces the error to the user, currently just uses alert() 
		 */
		notify: function(message) {
			alert(message);
		}
	};
	
	
	/*
	 * DNA Utilities
	 * Generic methods for common actions
	 */
	var utils = {
		
		/*
		 * Removes all newline, tabs and double space characters from
		 * str - useful for making incoming JSON data valid.
		 */
		cleanWhitespace: function(str) {
			return str.replace(/(\n|\r|\t|\s\s)/gi, "");
		},
		
		/*
		 * Converts newlines to "<br />" element.
		 */
		newlineToBr: function(str) {
			return str.replace(/(\n|\r)/gi, "<br />");
		},
		
		/*
		 *  Returns an object literal of each key=value pair found
		 *  in the page querystring, or an empty object if none are
		 *  found.
		 */
		getQuerystring: function() {
			
			var querystring = '';
			var data = {};
			
			if (querystring = window.location.search) {
				
				//An array of each of the key=value pairs
				var pairs = querystring.substring(1).split("&");
				var keyvalues = [];
				
				for (var i=0, l=pairs.length; i < l; i++) {
					
					//Populate with the key and value
					keyvalues = pairs[i].split("=");
					
					//Add to the return object
					data[keyvalues[0]] = keyvalues[1];
				}
			}
			
			//Return any key=value pairs found, or the empty object
			return data;
		},
		
		/*
		 * Launches a popup window to the width, height
		 * and url specified. If called multiple times it will recycle
		 * the same window.
		 */
		popup: function (url, w, h) {
			var w = window.open(url,'name','status=1,resizable=1,scrollbars=1,height=' + h + ',width=' + w);
			if (window.focus) {w.focus()}
			
			return false;
		},
		
		/*
		 * Some generic cookie getters and setters
		 */
		cookie: {
			/*
			 * Returns an object literal of each cookie key=value pair, or
			 * an empty if none are found.
			 */
			get: function() {
				//get array of each name value pair
				var cookies = document.cookie.split(';');
				var data = {};
				
				
				if (cookies) {
						var cookie = [];
						for (var i=0, l=cookies.length; i < l; i++) {
							
							//Get an array of the cookie name and value
							cookie = cookies[i].split('=');
							
							//Add to the return object
							data[cookie[0]] = cookie[1];
						}
				}
				
				return data;
			},
			
			/*
			 * Set a cookie, returns true or false depending on success
			 * 
			 * Required: name, value
			 * Optional: daysToLive, path
			 */
			set: function(name, value, daysToLive, path) {
				
				var expires = "";
				
				//Check if an expiry length is set.
				if (daysToLive) {
					
					//Make a new Date instance
					var d = new Date();
					
					//Set the Date instance to now + daysToLive
					d.setTime(d.getTime() + (daysToLive*24*60*60*1000));
					
					//Bulid the expires string using the Date specified above.
					var expires = "; expires=" + d.toGMTString();
				}
				
				//Check if a path has been specified
				if (!path) {
					
					//Default to the current document as the path
					path = window.location.pathname
				}
				
				//Build the cookie string and apply.
				document.cookie = name + "=" + value + expires + "; path=" + path;
				
				//Check that the cookie was set by seeing if we can cookie.get it
				//and compare its value.
				if (dna.utils.cookie.get()[name] == value) {
					return true;
				} else {
					return false;
				}
			}
		}
	};
	
	/*
	 * DNA Comments Object
	 * All associated methods to implement and handle the DNA
	 * commentbox
	 */
	var comments = {
		
		//Path to where assets live
		assetPath: "/dnaimages/components/shared",
		
		//optionally passed into comments.apply
		viewingUser: '',
		viewingUserGroup: '',
		
		/*
		 * Holders for the various elements
		 */
		formEl: false,
		textEl: false,
		submitEl: false,
		noComments: false,
		
		/* 
		 * Attach the onsubmit listener to the form
		 */
		AddEvents: function(f) {
				
				//Grab the form element and store it.
				comments.formEl = $(f);
				
				if (comments.formEl[0]) {
					
					//Look up textarea and submit buttons in the dom
					// - storing references may be bad if the host page
					//   changes the dom during the course of the session.
					comments.textEl = $("#dna-commentbox-text");
					comments.submitEl = $("#dna-commentbox-submit");
	
					//Call the preview button setup.
					comments.preview.addButton();
					
					/*
					 * replace (to get json response)
					 * THIS NEEDS REWORKING - RH
					 */
					var hack = comments.formEl[0].action;
					comments.formEl[0].action = hack.replace(/vanilla/, "vanilla-json");
					
					//Use glow to add the onsubmit listener to the form
					g.events.addListener(
						comments.formEl,
						'submit',
						function (ev) {
							
							//As soon as the submit button is pressed, disable anymore user interaction.
							// (stop repeated submit button clicks)
							dna.comments.ui.disable();
							
							//Show the loading chrome.
							dna.comments.loader.add();
							
							//Trigger the xhr request
							dna.comments.post.send();
							
							//Stop the form following its built in nature of submitting.
							return false;
						}
					);
				}
		},
		
		/*
		 * Run some operations to check for previous comment postings.
		 */
		cleanUp: function() {
			
			//DNA will tag on some error parameters if it has redirected the user back to the page.
			var qs = utils.getQuerystring();
			
			if (qs.dnaerrortype) {
				dna.error.handle(qs.dnaerrortype);
			}
			
			//The countdown may need resuming, if the user is trying to post too soon.
			comments.countdown.check();
			
		},
		
		/*
		 * Allows for the ui to be switched on and off, disabling or
		 * enabling user interaction.
		 * 
		 * Also features method to reset 
		 */
		ui: {
			/*
			 * Stops the user posting and entering anymore text
			 */
			disable: function() {
				comments.submitEl.addClass('disabled');
				comments.submitEl[0].disabled = true;
				comments.submitEl[0].blur();
				
				comments.previewEl.addClass('disabled');
				comments.previewEl[0].disabled = true;
				
				comments.textEl.addClass('disabled');
				comments.textEl[0].disabled = true;
			},
			
			/*
			 * Enables the comment form for use
			 */
			enable: function() {
				comments.submitEl.removeClass('disabled');
				comments.submitEl[0].disabled = false;
				
				comments.previewEl.removeClass('disabled');
				comments.previewEl[0].disabled = false;
				
				comments.textEl.removeClass('disabled');
				comments.textEl[0].disabled = false;
			},
			
			/*
			 * Blank the textarea where the user types the comment.
			 */
			resetCommentText: function () {
				comments.textEl[0].value = '';
			}
		},
		
		/*
		 * User chrome - adds a loading animation typically during xhr
		 * requests.
		 * TODO - this should really be an element added with a class name toggle?
		 */
		loader: {
			add: function() {
				g.dom.create('<img src="'+ comments.assetPath +'/img/loader-paleblue.gif" id="dna-commentbox-loader" />').insertAfter(comments.submitEl);
			},
			remove: function() {
				$('#dna-commentbox-loader').remove();
			}
		},
		
		/*
		 * Handles the countdown feature. Introduced to discourage mass posting and comment
		 * spamming. Works out a countdown and then stores it in a cookie.
		 */
		countdown: {
			
			/*
			 * Timer reference
			 */
			timer: false,
			
			check: function() {
				var seconds = utils.cookie.get().dnaCountdown;
				if (seconds > 0) {
					comments.countdown.start(seconds);
				}
			},
			
			/*
			 * Start the countdown. Requires the seconds to count down to.
			 */
			start: function(seconds) {
				
				//Make a new instance of Date
				var d = new Date();
				
				//Find the current time
				var cur = d.getTime();
				
				//Work out the extra time needed.
				var difference = (seconds * 1000);
				
				//Add the current time and extra to find out when the countdown will expire
				var expire = cur + difference;
				
				utils.cookie.set('dnaCountdown', seconds, 1);
				
				//Define the tick logic (occurs each second)
				var tick = function() {
					
					//Update the cookie with the seconds left
					utils.cookie.set('dnaCountdown', --seconds, 1);
					
					//If theres an update callback, execute it passing in the current seconds count.
					if (dna.comments.countdown.onUpdate) {dna.comments.countdown.onUpdate(seconds);}
				};
				
				//Run the tick for the first time manually
				tick();
			
				//Logic for the timer.
				var evaluate = function() {
					
					//Test whether the countdown is complete.
					if (new Date().getTime() > expire) {
						
						//Stop the countdown
						comments.countdown.stop();
						
						//Erase the cookie with the countdown value in.
						utils.cookie.set('dnaCountdown', '', -1);
						
					} else {
						
						//Countdown isn't complete, process another Tick
						tick();
					}
				}
				
				//Trigger the countdown, using the logic defined above.
				comments.countdown.timer = setInterval(evaluate, 1000);
			},
			
			/*
			 * Halts the running timer, runs an onStop callback if one
			 * has been specified.
			 */
			stop: function() {
				//Use the timer reference to stop the setInterval.
				clearInterval(comments.countdown.timer);
				
				//Run the callback if it is present.
				if (dna.comments.countdown.onStop) {dna.comments.countdown.onStop();}
			},
			
			/*
			 * Built in onUpdate callback that updates the countdown copy text. This can be
			 * overwritten via the api.
			 */
			onUpdate: function(secondsRemaining) {
				
				//Grab the element from the dom if it is there.
				var countdownElement = $('#dna-commentbox-countdown');
				
				//No element exists
				if (!countdownElement[0]) {
					
					//Create the span and attach it to the dom.
					g.dom.create('<span id="dna-commentbox-countdown">Post successful.</span>').insertAfter(comments.submitEl);
					
					//Grab the reference to it now it has been created.
					countdownElement = $("#dna-commentbox-countdown");
				}
				
				//Update the text inside the element to reflect the number of seconds left.
				countdownElement[0].innerHTML = "You must wait " + secondsRemaining + " seconds until you can make another comment.";
			},
			
			/*
			 * Predefined onStop handler to remove the countdown text.
			 */
			onStop: function() {
				//Remove the element containing the text from the dom.
				$('#dna-commentbox-countdown').empty();
				
				//Release the ui to the user.
				dna.comments.ui.enable();
			}
		},
		
		/*
		 * Prepares the request and handles the response.
		 */
		post: {
			
			/*
			 * Create and send the comment post request
			 */
			send: function () {
				
				//Grab the url from the form action attribute in the dom
				var url = comments.formEl[0].action;
				
				//Send the request
				g.net.post(
					url,
					{
						//The comment text itself
						dnacomment: comments.textEl[0].value,
						
						//The comment forum uid, grabbed from the dnauid hidden value
						dnauid: comments.formEl.children().children().filter(function() { return this.name == 'dnauid'})[0].value,
						
						//Set the dna action
						dnaaction: 'add',
						
						//Tell dna not to force a page redirect
						dnaur: 0,
						
						//Enable richtext posting (HTML in the comments)
						dnapoststyle: 1,
						
						//Notify the skin its being called via a xhr request
						// (interim solution to integration problems)
						s_xhr: 1
					},
					{
						//Tell glow how to process the response
						load: dna.comments.post.processResponse,
						
						//Specify the error handler
						error: dna.comments.post.onError
					}
				);
			},
			
			/*
			 * Process the response from the dna backend.
			 * 
			 * The response from dna should contain a single JSON object that looks
			 * approximately like the following:
			 * 		{
			 * 			error:  {
			 * 						errorType: (string) A dna error type,
			 * 						errorMessage: (string) The generated dna error message
			 * 					}
			 * 			id:		(int) the id of the comment represented in the html below,
			 * 			html: 	(string) a html snippet ready for dom insertion featuring either the new comment,
			 * 							 or the most recent comment if the was an error posting.
			 * 		}
			 */
			processResponse: function(response) {
				
				//Evaluate the response and get the JSON responseObjectect from it.
				var responseObject = glow.data.decodeJson(utils.cleanWhitespace(response.text()), {safeMode:false});
				
				
				//Check for errors
				if (responseObject.error.errorType) {
					
					//Errors were detected so pass them through the handler
					dna.comments.post.onError(responseObject);
					
				//Check this isn't a duplication (dna errors this silently)	
				} else if ($('#comment' + responseObject.id)[0]) {
					
					//Remove the loading chrome animation
					dna.comments.loader.remove();
					
					//The comment already exists
					dna.error.notify('You already said that in comment ' + responseObject.id);
					
					//No need to run the countdown if the post was unsuccessful.
					comments.countdown.stop();
					
				} else {
					
					//No errors, pass through response to update the dom 
					dna.comments.updateDom(responseObject);
					
					//If there is an onSuccess callback then run it.
					if (dna.comments.post.onSuccess) {dna.comments.post.onSuccess();}
				}
				
			},
			
			/*
			 * Error handling for failed / broken DNA responses.
			 * Used when a response fails to return and also when dna sends
			 * back an error.
			 * 
			 * Expects either the XHR response or the dna return object
			 */
			onError: function(obj) {
				
				//Remove the loading chrome animation
				dna.comments.loader.remove();
				
				//No need to run the countdown if the post was unsuccessful.
				comments.countdown.stop();
				
				//Open the ui to the user again.
				dna.comments.ui.enable();
				
				//Send the error through to the dna error handler.
				// (use the response status or the error object) 
				dna.error.handle(obj.status || obj.error.errorType);
			},
			
			/*
			 * Predefined callback called when the xhr request is successful.
			 */
			onSuccess: function() {
				
				//Remove the loading chrome animation
				dna.comments.loader.remove();
				
				//Post occurred successfully, stop the user from posting for a while.
				comments.countdown.start(dna.comments.countdown.seconds || comments.defaultCountdown);
			}
		},
		
		
		updateDom: function(o) {
				
				var ul;
				
				dna.comments.preview.remove();
				
				//make sure we only look at the dom once.
				comments.noCommentsEl = comments.formEl.parent().get('p.dna-commentbox-nocomments');
				
				if (comments.noCommentsEl[0]) {
										
					ul = g.dom.create('<ul class="collections forumthreadposts"></ul>').insertBefore(comments.noCommentsEl);
					
					comments.noCommentsEl.remove();
					
				} else {
					
					ul = comments.formEl.parent().get("ul.forumthreadposts").sort().slice(0, 1);
				}
				 
				g.dom.create(o.html).addClass((ul.children().length % 2) ? "stripe" : '').appendTo(ul);
				
				comments.ui.resetCommentText();
								
			
		},
		
		preview: {
			addButton: function() {
				g.dom.create('<input type="button" id="dna-commentbox-preview" value="Preview"/>').insertBefore(comments.submitEl);
				
				comments.previewEl = $('#dna-commentbox-preview');
				
				g.events.addListener(comments.previewEl, 'click', dna.comments.preview.generate);
			},
			
			generate: function() {
				
				var el = $('#dna-commentbox-previewArea');
				
				if (!el[0]) {
					g.dom.create('<ul class="collections forumthreadposts" id="dna-commentbox-previewArea"></ul>').insertAfter(comments.formEl);
					comments.previewAreaEl = el = $('#dna-commentbox-previewArea');
				}
				
				var s = new Date();
				
				var month = s.toString().split(' ')[1];
				
				var d = {
					text:  utils.newlineToBr(comments.textEl[0].value),
					viewingUserGroup: comments.viewingUserGroup,
					name: comments.viewingUser,
					count: comments.previewAreaEl.prev().prev().prev().get("li").length + 1,
					time: s.getHours() + ':' + s.getMinutes() + ' ' + ((s.getHours() < 12) ? 'am' : 'pm'),
					date: s.getDate() + ' ' + month + ' ' + s.getFullYear()					
				};
				
				var t = '<li class="{viewingUserGroup}"><span class="comment-number">{count}. </span><cite>At <a href="#postcomment" class="time">{time}</a> on <span class="date">{date}</span>, <span class="vcard"><span class="fn"><a href="#">{name}</a></span></span> wrote:</cite><p class="comment-text">{text}</p><p class="flag"></p></li>';
				
				el[0].innerHTML = g.lang.interpolate(t, d);
				
			},
			
			remove: function() {
				$('#dna-commentbox-previewArea').remove();
			}
		}		
	};
	
	
	
	//api
	return {
		
		error: error,
		
		utils: {
			cleanWhitespace: utils.cleanWhitespace,
			getQuerystring: utils.getQuerystring,
			popup: utils.popup,
			cookie: utils.cookie
		},
		comments: {
			apply: function (options) {
				
				if (options.targetForm) {
					
					comments.defaultCountdown = options.timeBetweenComments || 120;
					comments.viewingUser = options.viewingUser;
					comments.viewingUserGroup = options.viewingUserGroup;
					
					$('.popup').each(function() {
						glow.events.addListener(this, 'click', function() {
							dna.utils.popup(this.href, 694, 546);
							return false;
						});
					});
					
					comments.AddEvents(options.targetForm);
					
					comments.cleanUp();
				} else {
					throw new Error("DNA Comments: A target form is a required parameter.");
				}
			},
			
			ui: {
				disable: comments.ui.disable,
				enable: comments.ui.enable
			},
			
			countdown: {
				onUpdate: comments.countdown.onUpdate,
				onStop: comments.countdown.onStop
			},
			
			loader: {
				add: comments.loader.add,
				remove: comments.loader.remove
			},
			
			post: {
				send: comments.post.send,
				onError: comments.post.onError,
				processResponse: comments.post.processResponse,
				onSuccess: comments.post.onSuccess
			},
			
			preview: {
				generate: comments.preview.generate,
				remove: comments.preview.remove
			},
			
			updateDom: comments.updateDom
		}
	}
}();