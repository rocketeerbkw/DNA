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
        glow.dom.get(".dna-topic-position").addClass("dna-off");

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
                glow.dom.get(".dna-list-topic-col > *").sort().each(function() {
                    order.push(glow.dom.get(this).text());
                    var index = order.find(glow.dom.get(this).text());
                    index = 1 + index;
                    glow.dom.get(this).get(".dna-topic-pos").attr("value", index)
                });
            }
        });

        // create sortable instance : 2 columns
        var mySortable = new glow.widgets.Sortable(".dna-list-topic-col1,.dna-list-topic-col2", {
            draggableOptions: { handle: "h5" },
            onSort: function() {
                var order = [];
                glow.dom.get(".dna-list-topic-col1 > *").sort().each(function() {
                    order.push(glow.dom.get(this).text());
                    var index = order.find(glow.dom.get(this).text());
                    index = 1 + index;
                    glow.dom.get(this).get(".dna-topic-pos").attr("value", index)
                });
                glow.dom.get(".dna-list-topic-col2 > *").sort().each(function() {
                    order.push(glow.dom.get(this).text());
                    var index = order.find(glow.dom.get(this).text());
                    index = 2 + index;
                    glow.dom.get(this).get(".dna-topic-pos").attr("value", index)
                });
            }
        });

        glow.dom.get(".dna-list-topic-col h5").css("cursor", "move");
        glow.dom.get(".dna-list-topic-col1 h5").css("cursor", "move");
        glow.dom.get(".dna-list-topic-col2 h5").css("cursor", "move");

        // OVERLAY
        var myNodeList = glow.dom.get("a.dna-link-overlay");

        myNodeList.each(function(i) {
            var href = glow.dom.get(this).attr("href");

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
            glow.events.addListener(this, "mousedown", function() {

                var whichAnchor = href.split("#");
                if (whichAnchor.length > 1)
                    whichDiv = whichAnchor[1];

                // overlay divs are hidden by default 
                glow.dom.get("#" + whichDiv).removeClass("dna-off");

                // edit topic : show/hide step 2 and 3
                glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                glow.dom.get("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");

                // edit topic : validate form
                glow.events.addListener("#dna-btn-next-1-" + seditTopic, "mousedown", function() {
                    if (glow.dom.get("#fp_title-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a topic promo title</span>').insertBefore("#fp_title-" + seditTopic);
                        glow.dom.get("input#fp_title-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else {
                        glow.dom.get("#dna-preview-edittopic-step1-" + seditTopic).addClass("dna-off");
                        glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).removeClass("dna-off");
                    }
                    return false;
                });

                glow.events.addListener("#dna-btn-next-2-" + seditTopic, "mousedown", function() {
                    if (glow.dom.get("#fp_imagename-" + seditTopic).val() != "" && glow.dom.get("#fp_imagealttext-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add alt text for your image</span>').insertBefore("#fp_imagealttext-" + seditTopic);
                        glow.dom.get("#fp_imagealttext-" + seditTopic).addClass("dna-error-input");
                        return false;
                    } else {
                        glow.dom.get("#dna-preview-edittopic-step1-" + seditTopic).addClass("dna-off");
                        glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                        glow.dom.get("#dna-preview-edittopic-step3-" + seditTopic).removeClass("dna-off");
                    }
                    return false;
                });

                glow.events.addListener("#dna-btn-next-3-" + seditTopic, "mousedown", function() {
                    if (glow.dom.get("#topictitle-" + seditTopic).val() == "") {
                        glow.dom.create('<span class="dna-error-text">Please add a title topic</span>').insertBefore("#topictitle-" + seditTopic);
                        glow.dom.get("#topictitle-" + seditTopic).addClass("dna-error-input");
                        return false;
                    }
                });

                glow.events.addListener("#dna-btn-back-2-" + seditTopic, "mousedown", function() {
                    glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step1-" + seditTopic).removeClass("dna-off");
                });

                glow.events.addListener("#dna-btn-back-3-" + seditTopic, "mousedown", function() {
                    glow.dom.get("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).removeClass("dna-off");
                });


                // show overlay
                var myOverlay = new glow.widgets.Overlay("#" + whichDiv, {
                    modal: true
                });

                myOverlay.show();

                // footer overlay : show/hide footer links
                glow.dom.get("#dna-footer-links").addClass("dna-off");
                glow.events.addListener("a.dna-add-footer-links", "click", function() {
                    glow.dom.get("#dna-footer-color").addClass("dna-off");
                    glow.dom.get("#dna-footer-links").removeClass("dna-off");
                    return false;
                });

                // hide the overlay when 'cancel' is clicked on
                if (myOverlay.isShown) {
                    glow.events.addListener("a.dna-btn-cancel", "mousedown", function() {
                        myOverlay.hide();
                        return false;
                    });
                }

                return false;
            });
        });

        // OPENING TIMES
        var twentyfourseven = glow.dom.get("#twentyfourseven");
        var sametime = glow.dom.get("#sameeveryday");
        var difftime = glow.dom.get("#eachday");
        var sametimeselect = glow.dom.get("#dna-mb-openSame select");
        var difftimeselect = glow.dom.get("#dna-mb-openDiff select");
        var altrows = glow.dom.get("#dna-mb-openDiff tr");
        var closedallday = glow.dom.get("#dna-mb-openDiff table input");

        // closed all day checkboxes are available only when JS is enabled
        glow.dom.get(".closed").removeClass("dna-off");

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
        glow.events.addListener(twentyfourseven, "click", function() {
            if (this.checked) {
                iftwentyforseven();
            }
        });

        // if open same time every day is cliked on
        glow.events.addListener(sametime, "click", function() {
            if (this.checked) {
                ifsametime();
            }
        });

        // if open different time every day is clicked on
        glow.events.addListener(difftime, "click", function() {
            if (this.checked) {
                ifdifftime();
            }
        });

        // show closed all day check box
        glow.dom.get(".closed").removeClass("dna-off");

        // if closed all day is checked
        closedallday.each(function(i) {
            var id = glow.dom.get(this).attr("id");

            glow.events.addListener(this, "click", function() {
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
        var openNewWindow = glow.dom.get(".dna-openNewWindow");
        var href = glow.dom.get(openNewWindow).attr("href");

        glow.events.addListener(openNewWindow, "click", function() {
            window.open(href);
            return false;
        });


        // mbadmin : click on opening times link to message board schedule page
        var openTable = $(".dna-open-time");
        $(openTable).css("cursor", "pointer");

        glow.events.addListener(openTable, "click", function() {
            window.location = "/dna/mbarchers/admin/MessageBoardSchedule";
            return false;
        });

    }
})();