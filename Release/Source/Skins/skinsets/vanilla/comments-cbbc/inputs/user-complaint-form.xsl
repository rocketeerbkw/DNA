<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    <xsl:template match="USER-COMPLAINT-FORM[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 1]] | USERCOMPLAINT[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 1]]" mode="input_user-complaint-form">
        <div class="content">
            <h2>Complain about a <xsl:call-template name="item_name"/></h2>
            <p>This page is only for serious complaints that break the <a href="{$houserulespopupurl}">House Rules</a>.</p>
            <p>The message you complain about will be looked at by CBBC, who will check if it breaks the <a href="{$houserulespopupurl}">House Rules</a>.</p>
            <p>If you have a general question, please post a message on the CBBC messageboards.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Register my Complaint</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Register my Complaint</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Register my Complaint</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>You are not signed in to this website. If you have a CBBC account, please sign into it as it will help us to deal with your complaint.</p>
                    <p class="action">
                      <a>
                      	<xsl:attribute name="href">
                         <xsl:choose>
	                		<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_loginurl">
                                  <xsl:with-param name="ptrt" select="concat($root,  '/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1], '&amp;s_start=2')" />
                              </xsl:apply-templates>
		                          
		                     </xsl:when>
		                     <xsl:otherwise>
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_loginurl">
                                  <xsl:with-param name="ptrt" select="concat('/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1])" />
                              </xsl:apply-templates>
		                     </xsl:otherwise>
		                  </xsl:choose>
		                  </xsl:attribute>
                          <xsl:text>Sign in</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>post</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>article</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>content item</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <xsl:template match="USER-COMPLAINT-FORM[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 2]] | USERCOMPLAINT[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 2]]" mode="input_user-complaint-form">
        <form action="UserComplaintPage" method="post" id="complaintForm"> 
            <div class="content">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <input type="hidden" value="{(POST-ID | @POSTID)[1]}" name="PostID"/>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <input type="hidden" value="{@H2G2ID}" name="h2g2ID"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="hidden" value="{@URL}" name="url"/>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                
            	<h2>Alerting CBBC</h2>
            	<p>Please choose which of the <a href="{$houserulespopupurl}">House Rules</a> you think this <xsl:call-template name="item_name"/> has broken. If you feel it breaks more than one rule, please choose the most serious one.<br />CBBC will then be alerted and will decide whether or not the comment should remain on the CBBC website.</p>
            </div>
            
            <div class="content">
              <h2>Reason for your complaint</h2>
              <p>
                I believe this <xsl:call-template name="item_name"/>  may break one of the <a href="{$houserulespopupurl}">House Rules</a> because it:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="contains personal details, such as a surname, phone number, email address or social networking username" name="s_complaintText"/><label for="dnaacs-cq-1">contains personal details, such as a surname, phone number, email address or social networking username</label>
                		<input type="radio" id="dnaacs-cq-2" value="has a link to a website outside CBBC" name="s_complaintText"/><label for="dnaacs-cq-2">has a link to a website outside CBBC</label>
                		<input type="radio" id="dnaacs-cq-3" value="seems to have been written by someone who is older than 15" name="s_complaintText"/><label for="dnaacs-cq-3">seems to have been written by someone who is older than 15</label>
                		<input type="radio" id="dnaacs-cq-4" value="(contains a mention of something which) is not suitable for children aged 6-12" name="s_complaintText"/><label for="dnaacs-cq-4">(contains a mention of something which) is not suitable for children aged 6-12</label>
                		<input type="radio" id="dnaacs-cq-5" value="was written by a person who is pretending to be someone else" name="s_complaintText"/><label for="dnaacs-cq-5">was written by a person who is pretending to be someone else</label>
                		<input type="radio" id="dnaacs-cq-7" value="is mean, argumentative or contains bullying" name="s_complaintText"/><label for="dnaacs-cq-7">is mean, argumentative or contains bullying</label>
                		<input type="radio" id="dnaacs-cq-8" value="contains swear words or other bad language" name="s_complaintText"/><label for="dnaacs-cq-8">contains swear words or other bad language</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="contains a coded message and/or is not written in English" name="s_complaintText"/><label for="dnaacs-cq-9">contains a coded message and/or is not written in English</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="doesn't stick to the original topic" name="s_complaintText"/><label for="dnaacs-cq-10">doesn't stick to the original topic</label>
                		<input type="radio" id="dnaacs-cq-11" value="is spam and/or it advertises something" name="s_complaintText"/><label for="dnaacs-cq-11">is spam and/or it advertises something</label>
                		<input type="radio" id="dnaacs-cq-12" value="describes or encourages dangerous behaviour" name="s_complaintText"/><label for="dnaacs-cq-12">describes or encourages dangerous behaviour</label>
                		<input type="radio" id="dnaacs-cq-13" value="contains an inappropriate username" name="s_complaintText"/><label for="dnaacs-cq-13">contains an inappropriate username</label>
                		<input type="radio" id="dnaacs-cq-14" value="breaks the law or allows/encourages unlawful activity" name="s_complaintText"/><label for="dnaacs-cq-14">breaks the law or allows/encourages unlawful activity</label>
                		<input type="radio" id="dnaacs-cq-6" value="Other" name="s_complaintText"/><label for="dnaacs-cq-6">breaks the rules for a reason not listed above</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Next Page"/>
              </p>
            </div>
            
        </form>
      <script>
        gloader.load(
        ["glow", "1", "glow.forms", "glow.dom"],
        {
        async: true,
        onLoad: function(glow) {
        var myForm = new glow.forms.Form("#complaintForm");
        myForm.addTests(
        "s_complaintText",
        ["custom", {
        arg: function(values, opts, callback, formData) {
        if (values[0] == "") {
        alert("Please choose a complaint reason");
        return;
        }
        else {
        callback(glow.forms.PASS, "");
        }
        }}]
        );

        glow.ready(function()
        glow.events.addListener(
        'a.close',
        'click',
        function(e) {
        e.stopPropagation();
        window.close();
        return false;
        }
        );
        )
        }
        }
        )
      </script>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM | USERCOMPLAINT" mode="input_user-complaint-form">
        <form id="UserComplaintForm" action="UserComplaintPage" method="post"> 
           <div class="content"> 
           	<p>Please write in the box below to tell us why you think the <xsl:call-template name="item_name"/> breaks this rule. When you are finished, click 'Send Complaint' so that it can be looked into by CBBC.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Other'">
                    I'd like to complain about this <xsl:call-template name="item_name"/> because:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Other'">
                        <xsl:text>I think this </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> because:</xsl:text>
                    	</xsl:if>
                    	<xsl:text> <!-- leave this!! --> </xsl:text>
                    </textarea> 
                </p>
           </div>
            
            <!-- Guidelines:
            Where a user is not signed In a email should be required, even for kids sites. 
            If a user is signed In, their registered email address will be used to avoid having to prompt the user for an email on an unsecure connection. 
            If a child is signed In on an account without an email, the site should use System messages to communicate with their users.
            -->
            <div class="content">
              <xsl:choose>
                <xsl:when test="/H2G2/VIEWING-USER/USER">
                  <!-- email address is not required in this instance -->
                </xsl:when>
                <xsl:otherwise>
                    <h3>Your email address</h3>
                    <p>
                      <em>We need your email address to deal with your complaint and inform you of CBBC's decision. We may also need to contact you directly if we require more information about your complaint.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Email address</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Hide this <xsl:call-template name="item_name"/> instantly.</label>
                    </p>
                </xsl:if>
                
                <p class="action">
                	<input type="hidden" name="s_complaintText" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                    <input type="hidden" name="complaintreason" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                    <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                    <xsl:choose>
                      <xsl:when test="@POSTID">
                        <input type="hidden" value="{(POST-ID | @POSTID)[1]}" name="PostID"/>
                      </xsl:when>
                      <xsl:when test="@H2G2ID">
                        <input type="hidden" value="{@H2G2ID}" name="h2g2ID"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="hidden" value="{@URL}" name="url"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="action" value="submit"/>
                    <input type="submit" value="Send Complaint" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Information</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              You have been blocked from using the online complaints system, please write to:<br />
              BBC Central Communities Team<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:value-of select="(ERRORMESSAGE | ERROR)[1]"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>Email verification</h2>
      <p>
        Your complaint has been submitted. It will not be seen by a moderator until you have verified your email address. This is to help prevent impersonation and spamming.
      </p>
      <p>
        You will shortly receive an email with a link to activate your complaint. Clicking this link will send your complaint to the moderators.
      </p>
      
      <p class="action">
        <a class="close">
          <xsl:attribute name="href">
            <xsl:call-template name="library_serialise_ptrt_out">
              <xsl:with-param name="string">
                 <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Continue browsing</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Complaint Successful</h2>
      <p>
        Your complaint has successfully been collected and forwarded onto the Moderation team. They will decide whether the <a href="{$houserulespopupurl}">House Rules</a> have been broken and will update you via your email address.
      </p>
      <p>
        Your Moderation Reference ID is: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Additionally, this post has been hidden.</p>
      </xsl:if>
      <p class="action">
        <a class="close">
          <xsl:attribute name="href">
            <xsl:call-template name="library_serialise_ptrt_out">
              <xsl:with-param name="string">
                <xsl:choose>
                  <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']">
                    <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>http://www.bbc.co.uk/</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Continue browsing</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>