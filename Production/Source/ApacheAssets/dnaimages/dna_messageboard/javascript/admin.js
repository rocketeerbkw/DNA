(function() {

    var glow, $, addListener;

    gloader.load(
        ["glow", "1.1.0", "glow.dom", "glow.widgets", "glow.widgets.Sortable", "glow.widgets.Overlay"],
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
                $("#" + whichDiv).removeClass("dna-off");

                // edit topic : show/hide step 2 and 3
                $("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                $("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");

                // edit topic : validate form
                addListener("#dna-btn-next-1-" + seditTopic, "mousedown", function() {
                    if ($("#fp_title-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a topic promo title</span>').insertBefore("#fp_title-" + seditTopic);
                        $("input#fp_title-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else if ($("#fp_text-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a topic promo description</span>').insertBefore("#fp_text-" + seditTopic);
                        $("textarea#fp_text-" + seditTopic).addClass("dna-error-input");
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
                        $("#fp_templatetype-" + seditTopic).attr("checked", false);
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
                    if ($("#topictitle-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a title topic</span>').insertBefore("#topictitle-" + seditTopic);
                        $("#topictitle-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else if ($("#topictext-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a topic description</span>').insertBefore("#topictext-" + seditTopic);
                        $("textarea#topictext-" + seditTopic).addClass("dna-error-input");
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
            var publishOverlay= new glow.widgets.Overlay("#dna-publish-mb-yes", {
                modal: true
            });

            publishOverlay.show();
        }


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
        var openNewWindow = $(".dna-openNewWindow");
        var href = $(openNewWindow).attr("href");

        addListener(openNewWindow, "click", function() {
            window.open(href);
            return false;
        });


        // mbadmin : click on opening times link to message board schedule page
        var openTimeTable = $(".dna-open-time");
        $(openTimeTable).css("cursor", "pointer");

        addListener(openTimeTable, "mousedown", function() {
            window.location = "/dna/mbarchers/admin/MessageBoardSchedule";
            return false;
        });
    }
})();