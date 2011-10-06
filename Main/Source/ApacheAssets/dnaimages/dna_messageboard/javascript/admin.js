(function() {

    var glow, $, addListener;

    gloader.load(
        ["glow", "1", "glow.dom", "glow.events", "glow.widgets", "glow.widgets.Sortable", "glow.widgets.Overlay"],
        {
            async: true,
            onLoad: function(g) {
                glow = g;
                $ = glow.dom.get;
                addListener = glow.events.addListener;
                glow.ready(init);
            }
        }
    );



    function init() {

        if (typeof identity !== 'undefined') {
            glow.events.addListener(identity, 'login', function() {
                window.location.reload();
            });
        }


        // RE-ORDER TOPIC
        $(".dna-topic-position").addClass("dna-off");

        // find index of each 'li' element
        Array.prototype.find = function(searchStr) {
            var returnArray = false;
            for (i = 0; i < this.length; i++) {
                if (typeof (searchStr) == "function") {
                    if (searchStr.test(this[i])) {
                        if (!returnArray) { returnArray = [] }
                        returnArray.push(i);
                    }
                } else {
                    if (this[i] === searchStr) {
                        if (!returnArray) { returnArray = [] }
                        returnArray.push(i);
                    }
                }
            }
            return returnArray;
        }

        // create sortable instance : 1 column
        var mySortable = new glow.widgets.Sortable(".dna-list-topic-col", {
            draggableOptions: { handle: "h5" },
            onSort: function() {
                var order = [];
                $(".dna-list-topic-col > *").sort().each(function() {
                    order.push($(this).text());
                    var index = order.find($(this).text());
                    index = parseFloat(index);
                    index = index + 1;
                    $(this).get(".dna-topic-pos").attr("value", index)
                });
            }
        });

        // create sortable instance : 2 columns
        var mySortable = new glow.widgets.Sortable(".dna-list-topic-col1,.dna-list-topic-col2", {
            draggableOptions: { handle: "h5" },
            onSort: function() {
                var order1 = [];
                $(".dna-list-topic-col1 > *").sort().each(function() {
                    order1.push($(this).text());
                    var index1 = order1.find($(this).text());
                    index1 = parseFloat(index1);
                    index1 = (2 * index1) + 1;
                    $(this).get(".dna-topic-pos").attr("value", index1)
                });
                var order2 = [];
                $(".dna-list-topic-col2 > *").sort().each(function() {
                    order2.push($(this).text());
                    var index2 = order2.find($(this).text());
                    index2 = parseFloat(index2);
                    index2 = (2 * index2) + 2;
                    $(this).get(".dna-topic-pos").attr("value", index2)
                });
            }
        });

        $(".dna-list-topic-col h5").css("cursor", "move");
        $(".dna-list-topic-col1 h5").css("cursor", "move");
        $(".dna-list-topic-col2 h5").css("cursor", "move");


        // OVERLAY
        var myNodeList = $("a.dna-link-overlay");

        myNodeList.each(function(i) {
            var href = $(this).attr("href");

            // find value of paramaters in query string
            function topic(name) {
                name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
                var regexS = "[\\?&]" + name + "=([^&#]*)";
                var regex = new RegExp(regexS);
                var results = regex.exec(href);
                if (results == null)
                    return "";
                else
                    return results[1];
            }

            var seditTopic = topic('s_edittopic');
            var topicId = topic('topicid');
            var editKey = topic('editkey');

            // display overlay when show link with class of 'dna-link-overlay' is clicked on
            addListener(this, "mousedown", function() {


                var whichAnchor = href.split("#");
                if (whichAnchor.length > 1)
                    whichDiv = whichAnchor[1];

                // overlay divs are hidden by default 
                addListener;

                $("#" + whichDiv).removeClass("dna-off");

                // edit topic : show/hide step 2 and 3
                $("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                $("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");

                // edit topic : validate form
                addListener("#dna-btn-next-1-" + seditTopic, "mousedown", function() {
                    if ($("#fp_title-" + seditTopic).val() == "" || $("#fp_title-" + seditTopic).val() == " ") {
                        glow.dom.create('<span class="dna-error-text">Please add a topic promo title</span>').insertBefore("#fp_title-" + seditTopic);
                        $("input#fp_title-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else {
                        $("#dna-preview-edittopic-step1-" + seditTopic).addClass("dna-off");
                        $("#dna-preview-edittopic-step2-" + seditTopic).removeClass("dna-off");
                    }
                    return false;
                });


                addListener("#dna-btn-next-2-" + seditTopic, "mousedown", function() {
                    if ($("#fp_imagename-" + seditTopic).val() != "" && $("#fp_imagealttext-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add alt text for your image</span>').insertBefore("#fp_imagealttext-" + seditTopic);
                        $("#fp_imagealttext-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else if ($("#fp_imagename-" + seditTopic).val() == "" && $("#fp_imagealttext-" + seditTopic).val() == "") {
                        $("#fp_templatetype-" + seditTopic).attr("checked", "checked");
                        $("#fp_imagealttext-" + seditTopic).removeClass("dna-error-input");
                        $("span.dna-error-text").remove();
                        $("#dna-preview-edittopic-step1-" + seditTopic).addClass("dna-off");
                        $("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                        $("#dna-preview-edittopic-step3-" + seditTopic).removeClass("dna-off");
                    } else {
                        $("#dna-preview-edittopic-step1-" + seditTopic).addClass("dna-off");
                        $("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                        $("#dna-preview-edittopic-step3-" + seditTopic).removeClass("dna-off");
                    }
                    return false;
                });

                addListener("#dna-btn-next-3-" + seditTopic, "mousedown", function() {
                    if ($("#topictitle-" + seditTopic).val() == "" || $("#topictitle-" + seditTopic).val() == " ") {
                        glow.dom.create('<span class="dna-error-text">Please add a title topic</span>').insertBefore("#topictitle-" + seditTopic);
                        $("#topictitle-" + seditTopic).addClass("dna-error-input");
                        return false;
                    }
                    return false;
                });

                addListener("#dna-btn-back-2-" + seditTopic, "mousedown", function() {
                    $("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                    $("#dna-preview-edittopic-step1-" + seditTopic).removeClass("dna-off");
                });

                addListener("#dna-btn-back-3-" + seditTopic, "mousedown", function() {
                    $("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");
                    $("#dna-preview-edittopic-step2-" + seditTopic).removeClass("dna-off");
                });


                // validate fields
                addListener(".dna-buttons input", "mousedown", function() {
                    // about messageboard - introductory text
                    if ($("#mbabouttext").val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add an introductory text</span>').insertBefore("#mbabouttext");
                        $("#mbabouttext").addClass("dna-error-input");
                        return false;
                    }
                });
                addListener(".dna-buttons input", "mousedown", function() {
                    // about messageboard - opening times text
                    if ($("#mbopeningtimes").val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add opening/closing times</span>').insertBefore("#mbopeningtimes");
                        $("#mbopeningtimes").addClass("dna-error-input");
                        return false;
                    }

                });
                addListener(".dna-buttons input", "mousedown", function() {
                    // welcome message
                    if ($("#mbwelcome").val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add your welcome message</span>').insertBefore("#mbwelcome");
                        $("#mbwelcome").addClass("dna-error-input");
                        return false;
                    }
                });


                addListener(".dna-buttons input", "mousedown", function() {
                    var whichForm = $("#" + whichDiv + " form").attr("name");
                    document.forms[whichForm].action = 'messageboardadmin_design?s_mode=design';
                });


                // footer overlay : show/hide footer links
                $("#dna-footer-links").addClass("dna-off");
                addListener("a.dna-add-footer-links", "click", function() {
                    $("#dna-footer-color").addClass("dna-off");
                    $("#dna-footer-links").removeClass("dna-off");
                    return false;
                });


                // show overlay
                var myOverlay = new glow.widgets.Overlay("#" + whichDiv, {
                    modal: true
                });

                myOverlay.show();

                function resetForm() {
                    var whichForm = $("#" + whichDiv + " form").attr("name");
                    document.forms[whichForm].reset();
                    $("textarea, input").removeClass("dna-error-input");
                    $(".dna-error-text").addClass("dna-off");

                    $("#dna-footer-color").removeClass("dna-off");
                    $("#dna-footer-links").addClass("dna-off");
                }

                // reset the form when the overlay is closed by clicking the mask
                addListener(myOverlay, "hide", function(event) {
                    resetForm();
                });

                // hide the overlay when 'cancel' is clicked on
                if (myOverlay.isShown) {
                    addListener("a.dna-btn-cancel", "mousedown", function() {
                        resetForm;
                        myOverlay.hide();
                        return false;
                    });
                }

                return false;
            });
        });

        // OVERLAY : this overlay will be displayed when the admin page is reloaded once the 'PUBLISH THIS MBOARD' form is submitted.
        function params(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regexS = "[\\?&]" + name + "=([^&#]*)";
            var regex = new RegExp(regexS);
            var results = regex.exec(document.location.href);
            if (results == null)
                return "";
            else
                return results[1];
        }

        var cmd = params('cmd');

        if (cmd == 'PUBLISHMESSAGEBOARD') {
            // overlay divs are hidden by default 
            $("#dna-publish-mb-yes").removeClass("dna-off");

            // show overlay
            var publishOverlay = new glow.widgets.Overlay("#dna-publish-mb-yes", {
                modal: true
            });

            publishOverlay.show();
        }


        // loading gif when publish is clicked
        addListener(".dna-publish-mboard", "submit", function() {
            $("#dna-publish-form").addClass("dna-off");
            $("#dna-publish-loading").removeClass("dna-off");
        });

        // OPENING TIMES
        var twentyfourseven = $("#twentyfourseven");
        var sametime = $("#sameeveryday");
        var difftime = $("#eachday");
        var sametimeselect = $("#dna-mb-openSame select");
        var difftimeselect = $("#dna-mb-openDiff select");
        var altrows = $("#dna-mb-openDiff tr");
        var closedallday = $("#dna-mb-openDiff table input");

        // closed all day checkboxes are available only when JS is enabled
        $(".closed").removeClass("dna-off");

        function iftwentyforseven() {
            sametimeselect.attr("disabled", "disabled");
            difftimeselect.attr("disabled", "disabled");
            closedallday.attr("disabled", "disabled");
            altrows.removeClass("even");
            altrows.addClass("off");
        }

        function ifsametime() {
            sametimeselect.removeAttr("disabled");
            difftimeselect.attr("disabled", "disabled");
            closedallday.attr("disabled", "disabled");
            altrows.removeClass("even");
            altrows.addClass("off");
        }

        function ifdifftime() {
            sametimeselect.attr("disabled", "disabled");
            difftimeselect.removeAttr("disabled");
            closedallday.removeAttr("disabled");
            altrows.removeClass("off");
        }

        // if open 24/7 is clicked on
        addListener(twentyfourseven, "click", function() {
            if (this.checked) {
                iftwentyforseven();
            }
        });

        // if open same time every day is cliked on
        addListener(sametime, "click", function() {
            if (this.checked) {
                ifsametime();
            }
        });

        // if open different time every day is clicked on
        addListener(difftime, "click", function() {
            if (this.checked) {
                ifdifftime();
            }
        });

        // show closed all day check box
        $(".closed").removeClass("dna-off");

        // if closed all day is checked
        closedallday.each(function(i) {
            var id = $(this).attr("id");

            addListener(this, "click", function() {
                var closeDay = id.split("-");
                if (closeDay.length > 1)
                    whichDay = closeDay[1];

                var openHours = document.getElementById("openhours-" + whichDay);
                var openMinutes = document.getElementById("openMinutes-" + whichDay);
                var closeHours = document.getElementById("closeHours-" + whichDay);
                var closeMinutes = document.getElementById("closeMinutes-" + whichDay);

                if (this.checked) {
                    openHours.options[0].selected = true;
                    openMinutes.options[0].selected = true;
                    closeHours.options[0].selected = true;
                    closeMinutes.options[0].selected = true;
                } else {
                    difftimeselect.removeAttr("disabled");
                }
            });

        });


        // replace target=blank for links that open in new window
        var openNewWindow = $("a.dna-openNewWindow");

        openNewWindow.each(function(i) {
            var href = $(this).attr("href");

            addListener(this, "click", function() {
                window.open(href, "previewMessageboard");
                return false;
            });
        });

        // mbadmin : click on opening times link to message board schedule page
        var openTimeTable = $(".dna-open-time");
        $(openTimeTable).css("cursor", "pointer");

        addListener(openTimeTable, "mousedown", function() {
            window.location = "/dna/mbarchers/admin/MessageBoardSchedule";
            return false;
        });

        //UserList functions
        ///////////////////////
        if (document.getElementById("applyToAll")) {
            var applyToAllObj = document.getElementById("applyToAll");
            var applyToCheckBoxList = $(".dna-userlist .applyToCheckBox");
            addListener(applyToCheckBoxList, "mousedown", function() {
                applyToAllObj.checked = false;
            });

            addListener(applyToAllObj, "mousedown", function() {
                for (i = 0; i < applyToCheckBoxList.length; i++) {
                    applyToCheckBoxList[i].checked = !applyToAllObj.checked;
                }
            });
        }

        if (document.getElementById("modStatusForm")) {
            document.getElementById("durationContainer").style.display = "none";
            document.getElementById("duration").selectedIndex = 0;

            document.getElementById("hideAllPostsContainer").style.display = "none";
            document.getElementById("hideAllPosts").checked = false;

            var statusDropDown = document.getElementById("userStatusDescription");
            addListener(statusDropDown, "change", function() {
                var selected = document.getElementById("userStatusDescription").value;

                document.getElementById("durationContainer").style.display = "none";
                document.getElementById("duration").selectedIndex = 0;

                document.getElementById("hideAllPostsContainer").style.display = "none";
                document.getElementById("hideAllPosts").checked = false;


                if (selected == "Premoderated" || selected == "Postmoderated") {
                    document.getElementById("durationContainer").style.display = "block";
                }
                if (selected == "Deactivated") {
                    document.getElementById("hideAllPostsContainer").style.display = "block";
                }

            });

            var selected = document.getElementById("userStatusDescription").value;
            if (selected == "Premoderated" || selected == "Postmoderated") {
                document.getElementById("durationContainer").style.display = "block";
            }
            if (selected == "Deactivated") {
                document.getElementById("hideAllPostsContainer").style.display = "block";
            }

            var ignoreValidation = false;


            if (document.getElementById("ApplyNickNameReset")) {
                var resetUsernameObj = document.getElementById("ApplyNickNameReset");
                addListener(resetUsernameObj, "mousedown", function() {
                    ignoreValidation = true;
                });
            }

            

            var applyActionObj = document.getElementById("modStatusForm");
            addListener(applyActionObj, "submit", function() {

                var numberSelected = 0;
                for (i = 0; i < applyToCheckBoxList.length; i++) {
                    if (applyToCheckBoxList[i].checked)
                    { numberSelected++; }
                }
                if (numberSelected == 0) {
                    alert("Please select a user to apply the action to.");
                    return false;
                }

                if (ignoreValidation) {
                    return true;
                }

                var selected = document.getElementById("userStatusDescription").value;

                if (document.getElementById("reasonChange").value == "") {
                    alert("Please provide a valid reason for this change for auditing purposes.");
                    return false;
                }
                return true;

            });

        }

        addListener(
			'.popup',
			'click',
			function(e) {
			    window.open(this.href, this.target, 'status=no,scrollbars=yes,resizable=yes,width=800,height=550');
			    return false;
			}
		);

    }
})();


/******************************************/
// Terms filter validation
/******************************************/
function dnaterms_markAllRadio(type) {
    var inputs = document.getElementsByTagName("input");
    for (var index = 0; index < inputs.length; index++) {
        if (inputs[index].type == 'radio' && inputs[index].value == type) {
            inputs[index].checked = 'checked';
        }


    }
}

function dnaterms_unMarkAllRadioButtons() {
    var inputs = document.getElementsByTagName("input");
    for (var index = 0; index < inputs.length; index++) {
        if (inputs[index].name == 'action_modclassid_all') {
            inputs[index].checked = false;
        }


    }
}

function dnaterms_validateForm(theForm) {
    var errorStyle = "2px solid red";
    var error = document.getElementById("dnaTermErrorDiv");
    if (error == null) {
        error = new Div();
    }
    var serverResponse = document.getElementById("serverResponse");
    if (serverResponse != null) {
        serverResponse.style.display = "none";
    }
    error.style.display = "none";
    theForm.reason.style.border = "";
    theForm.termtext.style.border = "";
   

    with (theForm) {
        termtext.value = termtext.value.replace(/^\s*/, "").replace(/\s*$/, "")
        if (termtext.value == '') {
            error.innerHTML = "<p>Terms cannot be empty.</p>";
            termtext.style.border = errorStyle;
            error.style.display = "block";

            return false;
        }
        
        reason.value = reason.value.replace(/^\s*/, "").replace(/\s*$/, "")
        if (reason.value == '') {
            error.innerHTML = "<p>Import reason cannot be empty.</p>";
            reason.style.border = errorStyle;
            error.style.display = "block";
            return false;
        }

        

    }

    theForm.reason.style.border = "";
    theForm.termtext.style.border = "";
    error.style.display = "none";
    return confirm("Are you sure you want make this update?");
}

function commentforumlist_divToggle(div) {
    var ele = document.getElementById(div);
    if (ele.style.display == "block") {
        ele.style.display = "none";
    }
    else {
        ele.style.display = "block";
    }
}

function commentforumlist_toggle(divTerms, textArea) {
    var ele = document.getElementById(divTerms);
    var text = document.getElementById(divTerms);
    var termHolder = document.getElementById(textArea);
    termHolder.value = "";
    if (ele.style.display == "block") {
        ele.style.display = "none";
    }
    else {
        ele.style.display = "block";
    }
}

function commentforumlist_termToggle(divTerms, term, theForm) {
    var ele = document.getElementById(divTerms);
    ele.style.display = "block";

    theForm.termtext.value = term;

}