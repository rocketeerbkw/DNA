
gloader.load(
    ["glow", "1.1.0", "glow.dom", "glow.widgets", "glow.widgets.Sortable", "glow.widgets.Overlay"],
    {
        async: true,
        onLoad: function(glow) {


            /* design tab - sort topic order */
            new glow.widgets.Sortable(
            '.dna-list-topic-col1,.dna-list-topic-col2'
         );

            new glow.widgets.Sortable(
            '.dna-list-topic-col'
        );


            //overlay
            var myNodeList = glow.dom.get("a.dna-link-overlay");

            myNodeList.each(function(i) {
                var href = glow.dom.get(this).attr("href");
                var topicid = glow.dom.get(this).attr("href");

                /* find anchor link */
                whichAnchor = function() {
                    var regexS = "([\\#][^]*)";
                    var regex = new RegExp(regexS);
                    var results = regex.exec(href);
                    if (results == null) return "";
                    else return results[0].replace("#", "");
                }

                var whichDiv = whichAnchor();

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

                var whichTopic = topic('s_edittopic');


                //display overlay when show link is clicked
                glow.events.addListener(this, "click", function() {
                   
                    var myOverlay = new glow.widgets.Overlay("#" + whichDiv, {
                        modal: true
                    });
                    myOverlay.show();
                    return false;
                });
            });



            // footer overlay : show/hide footer links
            glow.dom.get("#dna-footer-links").addClass("dna-off");
            glow.events.addListener("a.dna-add-footer-links", "click", function() {
                glow.dom.get("#dna-footer-color").addClass("dna-off");
                glow.dom.get("#dna-footer-links").removeClass("dna-off");
                return false;
            });

            // edit topic : show/hide step 2 and 3
            glow.dom.get("#dna-preview-edittopic-step2").addClass("dna-off");
            glow.dom.get("#dna-preview-edittopic-step3").addClass("dna-off");

            // edit topic : validate form
            glow.events.addListener("#dna-btn-next-1", "click", function() {
                if (glow.dom.get("#fp_title").val() == "") {
                    glow.dom.create('<span class="dna-error-text">Please add a topic promo title</span>').insertBefore("#fp_title");
                    glow.dom.get("#fp_title").addClass("dna-error-input");
                    return false;
                } else {
                    glow.dom.get("#dna-preview-edittopic-step1").addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step2").removeClass("dna-off");
                }
                return false;
            });

            glow.events.addListener("#dna-btn-next-2", "click", function() {
                if (glow.dom.get("#fp_imagename").val() != "" && glow.dom.get("#fp_imagealttext").val() == "") {
                    glow.dom.create('<span class="dna-error-text">Please add alt text for your image</span>').insertBefore("#fp_imagealttext");
                    glow.dom.get("#fp_imagealttext").addClass("dna-error-input");
                    return false;
                } else {
                    glow.dom.get("#dna-preview-edittopic-step1").addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step2").addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step3").removeClass("dna-off");
                }
                return false;
            });

            glow.events.addListener("#dna-btn-next-3", "click", function() {
                if (glow.dom.get("#topictitle").val() == "") {
                    glow.dom.create('<span class="dna-error-text">Please add a title topic</span>').insertBefore("#topictitle");
                    glow.dom.get("#topictitle").addClass("dna-error-input");
                    return false;
                }
            });

            // opening times
            var twentyfourseven = glow.dom.get("#twentyfourseven");
            var sametime = glow.dom.get("#sameeveryday");
            var difftime = glow.dom.get("#eachday");

            var sametimeselect = glow.dom.get("#dna-mb-openSame select");
            var difftimeselect = glow.dom.get("#dna-mb-openDiff select");
            var altrows = glow.dom.get("#dna-mb-openDiff tr");
            var closedallday = glow.dom.get("#dna-mb-openDiff table input");


            var iftwentyforseven = function() {
                sametimeselect.attr("disabled", "disabled");
                difftimeselect.attr("disabled", "disabled");
                closedallday.attr("disabled", "disabled");
                altrows.removeClass("even");
                altrows.addClass("off");
            }

            var ifsametime = function() {
                sametimeselect.removeAttr("disabled");
                difftimeselect.attr("disabled", "disabled");
                closedallday.attr("disabled", "disabled");
                altrows.removeClass("even");
                altrows.addClass("off");
            }

            var ifdifftime = function() {
                sametimeselect.attr("disabled", "disabled");
                difftimeselect.removeAttr("disabled");
                closedallday.removeAttr("disabled");
                altrows.removeClass("off");
            }

            //if open 24/7 is already checked
            if (twentyfourseven.checked = true) {
                sametimeselect.attr("disabled", "disabled");
                difftimeselect.attr("disabled", "disabled");
                closedallday.attr("disabled", "disabled");
                altrows.removeClass("even");
                altrows.addClass("off");
            }

            //if open 24/7 is clicked on
            glow.events.addListener(twentyfourseven, "click", function() {
                if (this.checked) {
                    iftwentyforseven();
                }
            });

            //if open same time every day is already checked
            if (sametime.checked = true) {
                ifsametime();
            }

            //if open same time every day is cliked on
            glow.events.addListener(sametime, "click", function() {
                if (this.checked) {
                    ifsametime();
                }
            });

            //if open different time every day is already checked
            if (difftime.checked = true) {
                ifdifftime();
            }

            //if open different time every day is clicked on
            glow.events.addListener(difftime, "click", function() {
                if (this.checked) {
                    ifdifftime();
                }
            });

            //if closed all day is checked
            var closeAllday = glow.dom.get("#dna-mb-openDiff table input");
            var myNodeList = glow.dom.get(closeAllday);
            myNodeList.each(function(i) {
                this == myNodeList[i];
                var id = glow.dom.get(this).attr("id");


                /* find checkbox */
                gup = function() {
                    var regexS = "([\\-][^]*)";
                    var regex = new RegExp(regexS);
                    var results = regex.exec(id);
                    if (results == null) return "";
                    else return results[0].replace("-", "");
                }

                var whichDay = gup();

                glow.events.addListener(this, "click", function() {
                    var openHours = glow.dom.get("#openhours-" + whichDay);
                    var openMinutes = glow.dom.get("#openMinutes-" + whichDay);
                    var closeHours = glow.dom.get("#closeHours-" + whichDay);
                    var closeMinutes = glow.dom.get("#closeMinutes-" + whichDay);


                    if (this.checked) {
                        openHours.attr("disabled", "disabled");
                        openMinutes.attr("disabled", "disabled");
                        closeHours.attr("disabled", "disabled");
                        closeMinutes.attr("disabled", "disabled");
                    } else {
                        difftimeselect.removeAttr("disabled");
                    }
                });

            });

        }
    });
