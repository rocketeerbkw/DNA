
gloader.load(
    ["glow", "1.1.0", "glow.dom", "glow.widgets", "glow.widgets.Sortable", "glow.widgets.Overlay"],
    {
        async: true,
        onLoad: function(glow) {

            /* design tab - sort topic order */
            new glow.widgets.Sortable(
                '.dna-list-topic-col1,.dna-list-topic-col2',
                {
                    draggableOptions: {
                        handle: 'h5'
                    }
                }
            );

            new glow.widgets.Sortable(
            '.dna-list-topic-col',
                {
                    draggableOptions: {
                        handle: 'h5'
                    }
                }
            );

            glow.dom.get(".dna-list-topic-col h5").css("cursor", "move");
            glow.dom.get(".dna-list-topic-col1 h5").css("cursor", "move");
            glow.dom.get(".dna-list-topic-col2 h5").css("cursor", "move");


            //overlay
            var myNodeList = glow.dom.get("a.dna-link-overlay");

            myNodeList.each(function(i) {
                var href = glow.dom.get(this).attr("href");

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
 
                //display overlay when show link is clicked
                glow.events.addListener(this, "click", function() {
                    var whichAnchor = href.split("#");
                    whichDiv = whichAnchor[1];

                  

                    glow.dom.get("#" + whichDiv).removeClass("dna-off");

                    // edit topic : show/hide step 2 and 3
                    glow.dom.get("#dna-preview-edittopic-step2-" + seditTopic).addClass("dna-off");
                    glow.dom.get("#dna-preview-edittopic-step3-" + seditTopic).addClass("dna-off");


                    // edit topic : validate form
                    glow.events.addListener("#dna-btn-next-1-" + seditTopic, "click", function() {
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

                    glow.events.addListener("#dna-btn-next-2-" + seditTopic, "click", function() {
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

                    glow.events.addListener("#dna-btn-next-3-" + seditTopic, "click", function() {
                        if (glow.dom.get("#topictitle-" + seditTopic).val() == "") {
                            glow.dom.create('<span class="dna-error-text">Please add a title topic</span>').insertBefore("#topictitle-" + seditTopic);
                            glow.dom.get("#topictitle-" + seditTopic).addClass("dna-error-input");
                            return false;
                        }
                    });

                    var myOverlay = new glow.widgets.Overlay("#dna-preview-editheader", {
                        modal: true
                    });

                    myOverlay.show();
                    return false;

                    if (myOverlay.isShown) {
                        glow.events.addListener("a.dna-btn-cancel", "click", function() {
                            myOverlay.hide();
                            return false;
                        });
                    }


                });
            });


            // footer overlay : show/hide footer links
            glow.dom.get("#dna-footer-links").addClass("dna-off");
            glow.events.addListener("a.dna-add-footer-links", "click", function() {
                glow.dom.get("#dna-footer-color").addClass("dna-off");
                glow.dom.get("#dna-footer-links").removeClass("dna-off");
                return false;
            });


            // opening times
            var twentyfourseven = glow.dom.get("#twentyfourseven");
            var sametime = glow.dom.get("#sameeveryday");
            var difftime = glow.dom.get("#eachday");
            var sametimeselect = glow.dom.get("#dna-mb-openSame select");
            var difftimeselect = glow.dom.get("#dna-mb-openDiff select");
            var altrows = glow.dom.get("#dna-mb-openDiff tr");
            var closedallday = glow.dom.get("#dna-mb-openDiff table input");

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

            //if open 24/7 is already checked
            if (twentyfourseven.checked = true) {
                iftwentyforseven();
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

            //show closed all day check box
            glow.dom.get(".closed").removeClass("dna-off");

            //if closed all day is checked
            closedallday.each(function(i) {
                var id = glow.dom.get(this).attr("id");


                glow.events.addListener(this, "click", function() {
                    var closeDay = id.split("-");
                    if (closeDay.length > 1)
                        whichDay = closeDay[1];

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
