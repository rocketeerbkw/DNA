<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER-COMPLAINT-FORM[/H2G2/PARAMS/PARAM[NAME = 's_start']/VALUE]" mode="input_user-complaint-form">
        <div class="content">
            <h2>Complain about a message</h2>
            <p>This form is only to be used for serious complaints about specific content that breaks the <a href="{$houserulespopupurl}">House Rules</a>, such as unlawful, harassing, abusive, threatening, obscene, sexually explicit, racially offensive, or otherwise objectionable material.</p>
            <p>If you have a general comment or question please do not use this form, post a message to the discussion.</p>
            <p>The message you complain about will be sent to a moderator, who will decide whether it breaks the <a href="{$houserulespopupurl}">House Rules</a>. You will be informed of their decision by email. </p>
            <p class="action">
                <a href="?PostId={POST-ID}">Register my Complaint</a>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM" mode="input_user-complaint-form">
        <form id="UserComplaintForm" action="{$root}/UserComplaint" method="post"> 
            
            <div class="content">
                <input type="hidden" value="POST" name="Type"/>
                <input type="hidden" value="{POST-ID}" name="PostID"/>
                
                <h2>Complain about a message</h2>
                <p>This form is only for serious complaints about specific content that breaks the site's <a href="{$houserulespopupurl}">House Rules</a>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.</p>
                <p>For general comments please post to the relevant Conversation on the site.</p>
            </div>
            
            <div class="content">
                <h2>Reason for your complaint</h2>
                
                <h3 style="display:none;">I believe this post may break one of the <a href="{$houserulespopupurl}">House Rules</a> because it:</h3>
                <p class="options">
                    <input type="radio" id="dnaacs-cq-1" value="Is defamatory or libellous" name="ComplaintText"/><label for="dnaacs-cq-1">Is defamatory or libellous</label>
                    <input type="radio" id="dnaacs-cq-2" value="Is in contempt of court" name="ComplaintText"/><label for="dnaacs-cq-2">Is in contempt of court</label>
                    <input type="radio" id="dnaacs-cq-3" value="Incites people to commit a crime" name="ComplaintText"/><label for="dnaacs-cq-3">Incites people to commit a crime</label>
                    <input type="radio" id="dnaacs-cq-4" value="Breaks a court injunction" name="ComplaintText"/><label for="dnaacs-cq-4">Breaks a court injunction</label>
                    <input type="radio" id="dnaacs-cq-5" value="Is in breach of copyright (plagiarism)" name="ComplaintText"/><label for="dnaacs-cq-5">Is in breach of copyright (plagiarism)</label>
                    <input type="radio" id="dnaacs-cq-7" value="Contains offensive language" name="ComplaintText"/><label for="dnaacs-cq-7">Contains offensive language</label>
                    <input type="radio" id="dnaacs-cq-8" value="Is spam" name="ComplaintText"/><label for="dnaacs-cq-8">Is spam</label>
                    <input type="radio" id="dnaacs-cq-9" value="Is off-topic chat that is completely unrelated to the discussion topic" name="ComplainText"/><label for="dnaacs-cq-9">Is off-topic chat that is completely unrelated to the discussion topic</label>
                    <input type="radio" id="dnaacs-cq-10" value="Contains personal information such as a phone number or personal email address" name="ComplaintText"/><label for="dnaacs-cq-10">Contains personal information such as a phone number or personal email address</label>
                    <input type="radio" id="dnaacs-cq-11" value="Advertises or promotes products or services" name="ComplaintText"/><label for="dnaacs-cq-11">Advertises or promotes products or services</label>
                    <input type="radio" id="dnaacs-cq-12" value="Is not in English" name="ComplaintText"/><label for="dnaacs-cq-12">Is not in English</label>
                    <input type="radio" id="dnaacs-cq-13" value="Contains a link to an external website which breaks our editorial guidelines" name="ComplaintText"/><label for="dnaacs-cq-13">Contains a link to an external website which breaks our <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Editorial Guidelines</a></label>
                    <input type="radio" id="dnaacs-cq-14" value="Contains an inappropriate username" name="ComplaintText"/><label for="dnaacs-cq-14">Contains an inappropriate username</label>
                    <input type="radio" id="dnaacs-cq-6" value="Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive" name="ComplaintText"/><label for="dnaacs-cq-6">Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive</label>
                </p>
                
                <p class="options">
                    <input type="radio" id="dnaacs-cq-15" value="Other" name="ComplaintText"/><label for="dnaacs-cq-15">Other, provide details of the reason below</label>
                    <textarea id="reason" rows="10" cols="40" name="ComplaintText"></textarea> 
                </p>
                
            </div>
            
            <div class="content">
                <h2>Send your complaint</h2>
                <p>
                    We require your email address to identify your complaint and also provide you with updates.
                </p>
                <p>
                    <label for="emailaddress">Email address</label>
                    <input type="text" name="EmailAddress" id="emailaddress" value="" class="textbox"/>
                </p>
                
            <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2)">
                <p>
                    <input type="checkbox" value="1" name="HidePost" id="hidePost"/>
                    <label for="hidePost"> Hide this message instantly</label>.
                </p>
            </xsl:if>
                
                <p class="action">
                    <em>
                        Note: If you disagree with a comment please <strong>do not submit a complaint</strong>, add your comment to the discussion instead.
                    </em>
                    <input type="submit" value="Send Complaint" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR]" mode="input_user-complaint-form">
        <div class="content">
            <h2>Information</h2>
            <p><xsl:value-of select="ERROR"/></p>
        </div>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL']" mode="input_user-complaint-form">
        <div class="content">
            <h2>Complaint Successful</h2>
            <p>Your complaint has successfully been collected and forwarded onto the Moderation team. They will decide whether the <a href="{$houserulespopupurl}">House Rules</a> have been broken and will update you via your email address.</p>
            <p>Your Moderation Reference ID is: <strong><xsl:value-of select="MODERATION-REFERENCE"/></strong></p>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>