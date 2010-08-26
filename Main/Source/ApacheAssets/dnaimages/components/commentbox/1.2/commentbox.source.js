/**
 * DNA Comments Component
 * TODO This needs a bit of a refactor. 
 */

var dna = dna || {};

// Glow <1 && >1 joinery
dna.lang = {

	g: window.glow || false,
	$: (window.glow) ? glow.dom.get : false,	
	/**
	 * @description Connects Glow library with internal aliases
	 * @param {Glow} glow
	 */
	register: function(glow) {

		dna.error.lang(glow);
		dna.utils.lang(glow);
		dna.comments.lang(glow);
		
		// TODO expand this out to be a generic queue system for lazy execution
		dna.comments.processQueue();
	}
}

/*
 * DNA Error Surfacing
 */
dna.error = function () {
	
	var g = dna.lang.g,
		$ = dna.lang.$;
	/*
	 * Bank of all error types and associated messages
	 */
	var bank = {
		//Comment specific
		500: "We are currently experiencing problems accepting ",
		404: "Could not send your comment, please check your Internet Connection.",
		404: "Could not send your comment, please check your Internet Connection.",
		couldNotSendComment: "There was a problem sending your comment, please try again.",
		
		//Dna specific
		XmlParseError: "You comment included invalid HTML and could not be added. Please try entering your message again.",
		profanityblocked: "Your comment was failed by the profanity filter.",
		invalidcomment: "Type your comment into the text area and then press 'Post Comment'.",
		
		unknown: "There has been an unexpected problem. Please reload the page and try again."
	};
	
	/*
	 * Processes an error using the Bank key
	 */
	function handle(errorObject) {
		
		var type = errorObject.status || errorObject.error.errorType;
		
		//such a hack...
		if (type == 'XmlParseError') {
			
			inline("Your comment contains some HTML that has been mistyped.", errorObject.error.errorMessage);
			
		} else {
			if (bank[type]) {
				notify(bank[type]);
			} else {
				notify(bank.unknown);
			}
		}
	}
	
	
	/*
	 * Surfaces an inline error to the user
	 */
	function inline(helper, message) {

		var data = {
				helper: helper,
				message: message
			},
			
			errorElement = $('#dna-error'),
			
			html = '<h4>There has been a problem...</h4><p>{helper}</p><p class="error-message">{message}</p>';
		
		if (!errorElement[0]) {
			
			errorElement = g.dom.create('<div id="dna-error" class="error"></div>').insertAfter( g.dom.get('#dna-commentbox-submit').parent());
		}
		
		errorElement.html(g.lang.interpolate(html, data));
	}
	
	
	
	/*
	 * Surfaces the error to the user, currently just uses alert() 
	 */
	function notify(message) {
		alert(message);
	}
	
	/**
	 * a hack to connect Glow after asyn load
	 * @param {Object} glow
	 */
	function lang(glow) {
		g = glow;
		$ = glow.dom.get;
	}
	
	return {
		notify: notify,
		handle: handle,
		lang: lang
	}
}();

/*
 * DNA Utilities
 * Generic methods for common actions
 */
dna.utils = function() {
	
		var g = dna.lang.g,
			$ = dna.lang.$;
		
		/*
		 * Removes all newline, tabs and double space characters from
		 * str - useful for making incoming JSON data valid.
		 */
		function cleanWhitespace(str) {
			return str.replace(/(\n|\r|\t|\s\s)/gi, "");
		}
		
		/*
		 * Converts newlines to "<br />" element.
		 */
		function newlineToBr(str) {
			return str.replace(/(\n|\r)/gi, "<br />");
		}
		
		/*
		 *  Returns an object literal of each key=value pair found
		 *  in the page querystring, or an empty object if none are
		 *  found.
		 */
		function getQuerystring() {
			
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
		}
		
		/*
		 * Launches a popup window to the width, height
		 * and url specified. If called multiple times it will recycle
		 * the same window.
		 */
		function popup (url, w, h) {
			var w = window.open(url,'name','status=1,resizable=1,scrollbars=1,height=' + h + ',width=' + w);
			if (window.focus) {w.focus()}
			
			return false;
		}
		
		/*
		 * Some generic cookie getters and setters
		 */
		var cookie = {
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
		};
		/*
		 * Wraps text using a br element. Avoids text jumping out of containers
		 * in Firefox Win/Osx. (n.b. All other browsers appear to wrap long words,
		 * such as URLs, on to a new line)
		 * 
		 * Required - Glow node list of targets, max length of a word.
		 * 
		 * This method has a flaw, any word matched with a length greater than
		 * 2*matchLength will still only get split once.
		 */
		function wrapText (nodeList, matchLength) {
			
			// Only do this is if it Firefox
			if (g.env.gecko) {
				
				//Define the following regex pattern, where n is the matchLength
				//var pattern = /(\S){n,}/gmi;
				var pattern = new RegExp("(\\S){" + matchLength + ",}", "gmi");
				
				$(nodeList).each(function(i) {
				
					//Run the regex on the innerHTML of this node
				    var matches = pattern.exec(this.text);
					
					if (matches) {
						//If there are matches, iterate through them.
					    for (var i=0, l=matches.length; i < l; i++) {
							//Don't operate on any small left over matches found
					        if (matches[i].length >= matchLength) {
								// Split the match and insert the <br /> between the two parts
					            var replace = matches[i].slice(0, matchLength) + '<br />' + matches[i].slice(matchLength, matches[i].length);
								
								// Replace the treated contents
					            this.text = this.text.replace(matches[i], replace);
					        }
					    }
					}
				});
			}
		}
		
		function tagSoupToXml(str) {
			
			var re = /\s&\s/gi;
			var newstr = str.replace(re, " &amp; ");
			
			
			return newstr;
		}
		
		/**
		 * a hack to connect Glow after asyn load
		 * @param {Object} glow
		 */
		function lang(glow) {
			g = glow;
			$ = glow.dom.get;
		}
		
		return {
				cleanWhitespace: cleanWhitespace,
				newlineToBr: newlineToBr,
				getQuerystring: getQuerystring,
				popup: popup,
				wrapText: wrapText,
				cookie: cookie,
				tagSoupToXml: tagSoupToXml,
				lang: lang
			}
}();
	
	/*
	 * DNA Comments Object
	 * All associated methods to implement and handle the DNA
	 * commentbox
	 */

dna.comments = function (){
		
		var g = dna.lang.g,
			$ = dna.lang.$;
		
		//Path to where assets live
		var	assetPath = "/dnaimages/components/shared",
		
			//optionally passed into apply
			viewingUser = '',
			viewingUserGroup = '',
		
			// Holders for the various elements
			formEl = false,
			textEl = false,
			submitEl = false,
			noComments = false;
		
		/* 
		 * Attach the onsubmit listener to the form
		 */
		function AddEvents(f) {
				
				//Grab the form element and store it.
				formEl = $(f);
				
				if (formEl[0]) {
					
					//Look up textarea and submit buttons in the dom
					// - storing references may be bad if the host page
					//   changes the dom during the course of the session.
					textEl = $("#dna-commentbox-text");
					submitEl = $("#dna-commentbox-submit");
	
					//Call the preview button setup.
					preview.addButton();
					
					/*
					 * replace (to get json response)
					 * THIS NEEDS REWORKING - RH
					 */
					var hack = formEl[0].action;
					formEl[0].action = hack.replace(/\/comments\/acs/, "/json/acs");
					
					//Use glow to add the onsubmit listener to the form
					g.events.addListener(
						formEl,
						'submit',
						function (ev) {
							
							//As soon as the submit button is pressed, disable anymore user interaction.
							// (stop repeated submit button clicks)
							ui.disable();
							
							//Show the loading chrome.
							loader.add();
							
							//Trigger the xhr request
							post.send();
							
							//Stop the form following its built in nature of submitting.
							return false;
						}
					);
				}
		}
		
		/*
		 * Run some operations to check for previous comment postings.
		 */
		function cleanUp() {
			
			//DNA will tag on some error parameters if it has redirected the user back to the page.
			var qs = dna.utils.getQuerystring();
			
			if (qs.dnaerrortype) {
				dna.error.handle(qs.dnaerrortype);
			}
			
			//The countdown may need resuming, if the user is trying to post too soon.
			countdown.check();
			
		}
		
		/*
		 * Allows for the ui to be switched on and off, disabling or
		 * enabling user interaction.
		 * 
		 * Also features method to reset 
		 */
		var ui = {
			/*
			 * Stops the user posting and entering anymore text
			 */
			disable: function() {
				submitEl.addClass('disabled');
				submitEl[0].disabled = true;
				submitEl[0].blur();
				
				previewEl.addClass('disabled');
				previewEl[0].disabled = true;
				
				textEl.addClass('disabled');
				textEl[0].disabled = true;
			},
			
			/*
			 * Enables the comment form for use
			 */
			enable: function() {
				submitEl.removeClass('disabled');
				submitEl[0].disabled = false;
				
				previewEl.removeClass('disabled');
				previewEl[0].disabled = false;
				
				textEl.removeClass('disabled');
				textEl[0].disabled = false;
			},
			
			/*
			 * Blank the textarea where the user types the comment.
			 */
			resetCommentText: function () {
				textEl[0].value = '';
			}
		};
		
		/*
		 * User chrome - adds a loading animation typically during xhr
		 * requests.
		 * TODO - this should really be an element added with a class name toggle?
		 */
		var loader = {
			add: function() {
				g.dom.create('<img src="'+ assetPath +'/img/loader-paleblue.gif" id="dna-commentbox-loader" />').insertAfter(submitEl);
			},
			remove: function() {
				$('#dna-commentbox-loader').remove();
			}
		};
		
		/*
		 * Handles the countdown feature. Introduced to discourage mass posting and comment
		 * spamming. Works out a countdown and then stores it in a cookie.
		 */
		var countdown = {

			/*
			 * Timer reference
			 */
			timer: false,
			
			check: function() {
				var seconds = dna.utils.cookie.get().dnaCountdown;
				if (seconds > 0) {
					countdown.start(seconds);
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
				
				dna.utils.cookie.set('dnaCountdown', seconds, 1);
				
				//Define the tick logic (occurs each second)
				var tick = function() {
					
					//Update the cookie with the seconds left
					dna.utils.cookie.set('dnaCountdown', --seconds, 1);
					
					//If theres an update callback, execute it passing in the current seconds count.
					if (countdown.onUpdate) {countdown.onUpdate(seconds);}
				};
				
				//Run the tick for the first time manually
				tick();
			
				//Logic for the timer.
				var evaluate = function() {
					
					//Test whether the countdown is complete.
					if (new Date().getTime() > expire) {
						
						//Stop the countdown
						countdown.stop();
						
						//Erase the cookie with the countdown value in.
						dna.utils.cookie.set('dnaCountdown', '', -1);
						
					} else {
						
						//Countdown isn't complete, process another Tick
						tick();
					}
				}
				
				//Trigger the countdown, using the logic defined above.
				countdown.timer = setInterval(evaluate, 1000);
			},
			
			/*
			 * Halts the running timer, runs an onStop callback if one
			 * has been specified.
			 */
			stop: function() {
				//Use the timer reference to stop the setInterval.
				clearInterval(countdown.timer);
				
				//Run the callback if it is present.
				if (countdown.onStop) {countdown.onStop();}
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
					g.dom.create('<span id="dna-commentbox-countdown">Post successful.</span>').insertAfter(submitEl);
					
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
				ui.enable();
			}
		};
		
		/*
		 * Prepares the request and handles the response.
		 */
		var post = {
			
			/*
			 * Create and send the comment post request
			 */
			send: function () {
				
				//Grab the url from the form action attribute in the dom
				var	url = formEl[0].action,
					commentText = dna.utils.tagSoupToXml(textEl[0].value);
				
				//Send the request
				g.net.post(
					url,
					{
						//The comment text itself
						dnacomment: commentText,
						
						//The comment forum uid, grabbed from the dnauid hidden value
						dnauid: formEl.children().children().filter(function() { return this.name == 'dnauid'})[0].value,
						
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
						onLoad: post.processResponse,
						
						//Specify the error handler
						onError: post.onError
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
				var responseObject = g.data.decodeJson(dna.utils.cleanWhitespace(response.text()), {safeMode:false});
				
				
				//Check for errors
				if (responseObject.error.errorType) {
					
					//Errors were detected so pass them through the handler
					post.onError(responseObject);
					
				//Check this isn't a duplication (dna errors this silently)	
				} /*else if ($('#comment' + responseObject.id)[0]) {
					
					//Remove the loading chrome animation
					loader.remove();
					
					//The comment already exists
					dna.error.notify('You already said that in comment ' + responseObject.id);
					
					//No need to run the countdown if the post was unsuccessful.
					countdown.stop();
					
				}*/ else {
					
					//No errors, pass through response to update the dom 
					updateDom(responseObject);
					
					//If there is an onSuccess callback then run it.
					if (post.onSuccess) {post.onSuccess();}
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
				loader.remove();
				
				//No need to run the countdown if the post was unsuccessful.
				countdown.stop();
				
				//Open the ui to the user again.
				ui.enable();
				
				//Send the error through to the dna error handler.
				// (use the response status or the error object) 
				//dna.error.handle(obj.status || obj.error.errorType);
				dna.error.handle(obj);
			},
			
			/*
			 * Predefined callback called when the xhr request is successful.
			 */
			onSuccess: function() {
				
				//Remove the loading chrome animation
				loader.remove();
				
				//Post occurred successfully, stop the user from posting for a while.
				countdown.start(countdown.seconds || defaultCountdown);
			}
		};
		
		
		function updateDom(o) {
				
				var ul;
				
				preview.remove();
				
				//make sure we only look at the dom once.
				noCommentsEl = formEl.parent().get('p.dna-commentbox-nocomments');
				
				if (noCommentsEl[0]) {
										
					ul = g.dom.create('<ul class="collections forumthreadposts"></ul>').insertBefore(noCommentsEl);
					
					noCommentsEl.remove();
					
				} else {
					
					ul = formEl.parent().get("ul.forumthreadposts").sort().slice(0, 1);
				}
				
				g.dom.create(o.html).addClass((ul.children().length % 2) ? "stripe" : '').appendTo(ul);
				
				ui.resetCommentText();
								
			
		};
		
		var preview = {
			addButton: function() {
				g.dom.create('<input type="button" id="dna-commentbox-preview" value="Preview"/>').insertBefore(submitEl);
				
				previewEl = $('#dna-commentbox-preview');
				
				g.events.addListener(previewEl, 'click', preview.generate);
			},
			
			generate: function() {
				
				var el = $('#dna-commentbox-previewArea');
				
				if (!el[0]) {
					g.dom.create('<ul class="collections forumthreadposts" id="dna-commentbox-previewArea"></ul>').insertAfter(formEl);
					previewAreaEl = el = $('#dna-commentbox-previewArea');
				}
				
				var s = new Date();
				
				var month = s.toString().split(' ')[1];
				
				var d = {
					text:  dna.utils.newlineToBr(textEl[0].value),
					viewingUserGroup: viewingUserGroup,
					name: viewingUser,
					count: previewAreaEl.prev().prev().prev().get("li").length + 1,
					time: s.getHours() + ':' + ((s.getMinutes() < 10) ? '0' : '') + s.getMinutes() + ' ' + ((s.getHours() < 12) ? 'am' : 'pm'),
					date: s.getDate() + ' ' + month + ' ' + s.getFullYear()					
				};
				
				var t = '<li class="{viewingUserGroup}"><span class="comment-number">{count}. </span><cite>At <a href="#postcomment" class="time">{time}</a> on <span class="date">{date}</span>, <span class="vcard"><span class="fn"><a href="#dna-commentbox-previewArea">{name}</a></span></span> wrote:</cite><p class="comment-text">{text}</p><p class="flag"></p></li>';
				
				el[0].innerHTML = g.lang.interpolate(t, d);
				
			},
			
			remove: function() {
				$('#dna-commentbox-previewArea').remove();
			}
		};
		
		/*******
		 * Gloader compatibility
		 */
		// internal register of queue'd comment instances
		var registerQueue = [];
		
		/**
		 * Queues new comment lists
		 * @param {Object} options A list of options to init a new comments list, targetForm is required (an id)
		 */
		function queue(options) {
			if (options.targetForm) {

				// add to the queue
				registerQueue[registerQueue.length] = options;
			} else {
				throw new Error("DNA Comments: A target form is a required parameter.");
			}
		}
		
		/**
		 * Processes an comment lists in the queue waiting to be initiated
		 */
		function processQueue() {
			if (registerQueue.length > 0) {
				
				for (var i = 0, l = registerQueue.length; i < l; i++) {
					
					dna.comments.apply(registerQueue[i]);
				}
			}
		}
		
		/**
		 * a hack to connect Glow after asyn load
		 * @param {Object} glow
		 */
		function lang(glow) {
			g = glow;
			$ = glow.dom.get;
		}
	
	//api
	return {
		
		apply: function (options) {
			
			if (options.targetForm) {
				
				//defaultCountdown = options.timeBetweenComments || 120;
				defaultCountdown = 20;
				viewingUser = options.viewingUser;
				viewingUserGroup = options.viewingUserGroup;
				
				$('.popup').each(function() {
					g.events.addListener(this, 'click', function() {
						dna.utils.popup(this.href, 694, 546);
						return false;
					});
				});
				
				AddEvents(options.targetForm);
				
				cleanUp();
				
				dna.utils.wrapText("#comments p.comment-text", 65);
				
			} else {
				throw new Error("DNA Comments: A target form is a required parameter.");
			}
		},
		
		ui: {
			disable: ui.disable,
			enable: ui.enable
		},
		
		countdown: {
			onUpdate: countdown.onUpdate,
			onStop: countdown.onStop
		},
		
		loader: {
			add: loader.add,
			remove: loader.remove
		},
		
		post: {
			send: post.send,
			onError: post.onError,
			processResponse: post.processResponse,
			onSuccess: post.onSuccess
		},
		
		preview: {
			generate: preview.generate,
			remove: preview.remove
		},
		
		updateDom: updateDom,
		queue: queue,
		processQueue: processQueue,
		lang: lang
	}
}();