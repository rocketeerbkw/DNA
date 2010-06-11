<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template name="POST-MODERATION_MAINBODY">
	Author:	Andy Harris
	Context:     	/H2G2
	Purpose:	Main body template
	-->
	<xsl:template name="POST-MODERATION_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">moderateposts?modclassid=<xsl:value-of select="@CLASSID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/>&amp;alerts=<xsl:choose><xsl:when test="/H2G2/POSTMODERATION/@ALERTS = 1">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;referrals=<xsl:choose><xsl:when test="/H2G2/POSTMODERATION/@REFERRALS = 1">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;locked=<xsl:choose><xsl:when test="/H2G2/POSTMODERATION/@LOCKEDITEMS = 1">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<form action="moderateposts" method="post" id="moderationForm">
			<div id="mainContent">
				<xsl:apply-templates select="POSTMODERATION" mode="crumbtrail"/>
				<!--<xsl:call-template name="checkalerts_strip"/>-->
				<xsl:apply-templates select="POSTMODERATION" mode="lockedby_strip"/>
				<xsl:apply-templates select="POSTMODERATION" mode="post_list"/>
			</div>
			<xsl:if test="not(/H2G2/POSTMODERATION/POST[1]/@POSTID = /H2G2/POSTMODERATION/POST[2]/@POSTID) or /H2G2/POSTMODERATION/POST[1]/@POSTID = 0">
				<div id="processButtons">
					<input type="submit" value="Process &amp; Continue" name="next" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch" id="continueButton"/>
					<input type="submit" value="Process &amp; Return to Main" name="done" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home" id="returnButton"/>
				</div>
			</xsl:if>
      <input type="hidden" name="redirect" value="{$root}Moderate?newstyle=1"/>
			<input type="hidden" name="modclassid" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<input type="hidden" name="alerts" value="{POSTMODERATION/@ALERTS}"/>
			<input type="hidden" name="referrals" value="{POSTMODERATION/@REFERRALS}"/>
			<input type="hidden" name="fastmod" value="{POSTMODERATION/@FASTMOD}"/>
		</form>
	</xsl:template>
	<!-- 
		<xsl:template match="POSTMODERATION" mode="crumbtrail">
		Author:	Andy Harris
		Context:     	/H2G2/POSTMODERATION
		Purpose:	Adds the appropriate crumbtrail to the top of the page
	-->
	<xsl:template match="POSTMODERATION" mode="crumbtrail">
		<p class="crumbtrail">
			<a href="moderate?newstyle=1">
				<xsl:text>Main</xsl:text>
			</a>
			<xsl:choose>
				<xsl:when test="@ALERTS = 1">
					<xsl:text> &gt; Alerts re: Posts</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> &gt; Posts</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="/H2G2/FEEDBACK" mode="posts_feedback_strip"/>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="FEEDBACK" mode="posts_feedback_strip">
		Author:	Andy Harris
		Context:     	/H2G2/POSTMODERATION
		Purpose:	Adds the feedback strip to the top of the page containing number of posts processed
	-->
	<xsl:template match="FEEDBACK" mode="posts_feedback_strip">
		<xsl:choose>
			<xsl:when test="not(@PROCESSED = 0)">
				<span id="feedback-info">
					<xsl:value-of select="@PROCESSED"/>
					<xsl:text> posts have been processed</xsl:text>
				</span>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- 
		<xsl:template name="checkalerts_strip">
		Author:	Andy Harris
		Context:    	
		Purpose:	Adds the check alerts link to the top of the page. This is used on some other pages and just calls a chunk of javascript
	-->
	<xsl:template name="checkalerts_strip">
		<xsl:if test="not(@ALERTS = 1)">
			<a href="#" onclick="getAlerts('FORUMS', 'FORUMS-FASTMOD')" id="checkAlerts">
				<xsl:text>Check for alerts &gt; &gt;</xsl:text>
			</a>
			<div id="alertResponse"/>
		</xsl:if>
	</xsl:template>
	<!-- 
		<xsl:template match="POSTMODERATION" mode="lockedby_strip">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION
		Purpose:	Adds the locked by information to the top of the page for users other than super users (at the moment)
	-->
	<xsl:template match="POSTMODERATION" mode="lockedby_strip">
		<xsl:choose>
			<xsl:when test="$superuser = 1"/>
			<xsl:otherwise>
				<p id="lockedby">
					<xsl:text>Locked by </xsl:text>
					<xsl:value-of select="POST[1]/LOCKED/USER/USERNAME"/>
					<xsl:text> at </xsl:text>
					<xsl:apply-templates select="POST[1]/LOCKED/DATELOCKED/DATE" mode="mod-system-format"/>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
		<xsl:template match="POSTMODERATION" mode="post_list">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION
		Purpose:	Calls the template for working through the POSTs
	-->
	<xsl:template match="POSTMODERATION" mode="post_list">
		<xsl:apply-templates select="POST" mode="post_list"/>
	</xsl:template>
	<!-- 
		<xsl:template match="POST" mode="post_list">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	Calls the templates for individual chunks of the POST 
	-->
	<xsl:template match="POST" mode="post_list">
		<xsl:if test="not(/H2G2/POSTMODERATION/POST[1]/@POSTID = /H2G2/POSTMODERATION/POST[2]/@POSTID) or position() = 1 or /H2G2/POSTMODERATION/POST[1]/@POSTID = 0">
			<div class="infoBar">
				<xsl:if test="USER/STATUS">
					<div class="userInfoIcon">
					<xsl:apply-templates select="USER/STATUS" mode="user_status"/>
					<xsl:apply-templates select="USER/GROUPS" mode="user_groups"/>
					</div>
				</xsl:if>
				<xsl:apply-templates select="." mode="location_bar"/>
				<xsl:apply-templates select="." mode="user_info"/>
				<span class="clear"/>
			</div>
			<span class="clear"/>
		</xsl:if>
		<div class="postInfo">
			<xsl:if test="not(/H2G2/POSTMODERATION/POST[1]/@POSTID = /H2G2/POSTMODERATION/POST[2]/@POSTID) or position() = 1 or /H2G2/POSTMODERATION/POST[1]/@POSTID = 0">
				<xsl:apply-templates select="." mode="post_info"/>
			</xsl:if>
			<xsl:apply-templates select="ALERT" mode="complaintuser_info"/>
			<xsl:apply-templates select="ALERT" mode="complaint_info"/>
			<xsl:apply-templates select="ALERT/ALERTCOUNT" mode="complaint_multiple"/>
			<xsl:apply-templates select="REFERRED" mode="referringuser_info"/>
			<!--<xsl:apply-templates select="REFERRED" mode="referred_info"/>-->
      <xsl:if test="not(REFERRED)">
        <xsl:apply-templates select="NOTES" mode="notes"/>
      </xsl:if>
		</div>
		<xsl:if test="not(/H2G2/POSTMODERATION/POST[1]/@POSTID = /H2G2/POSTMODERATION/POST[2]/@POSTID) or /H2G2/POSTMODERATION/POST[1]/@POSTID = 0">
			<div class="tools">
				<xsl:apply-templates select="." mode="mod_form"/>
				<span class="clear"/>
				<xsl:if test="$test_IsEditor">
					<div class="editorToolBox">
						<xsl:apply-templates select="." mode="discussion_status"/>
            <xsl:choose>
              <xsl:when test="@ISPREMODPOSTING = 1 and not(@INREPLYTO)">
                <xsl:apply-templates select="@MODERATIONID" mode="move_via_modid"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="@THREADID" mode="move_discussion"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="." mode="lookup_ipaddress"/>
						<xsl:apply-templates select="." mode="distress_message"/>						
					</div>
				</xsl:if>
			</div>
		</xsl:if>
		<span class="clear"/>
	</xsl:template>
	<!-- 
		<xsl:template match="POST" mode="location_bar">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	Creates the location information for the POST. Also includes the collection of hidden form elements for this POST
	-->
	<xsl:template match="POST" mode="location_bar">
		<input type="hidden" name="PostID" value="{@POSTID}"/>
		<input type="hidden" name="ThreadID" value="{@THREADID}"/>
		<input type="hidden" name="ForumID" value="{@FORUMID}"/>
		<input type="hidden" name="ModID" value="{@MODERATIONID}"/>
		<input type="hidden" name="SiteID" value="{SITEID}"/>
		<p class="postInfoBar">
			<xsl:number/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="../@COUNT"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()/SITEID]/NAME"/>
			<xsl:text> &gt; </xsl:text>
			<xsl:choose>
				<xsl:when test="TOPICTITLE">
					<xsl:value-of select="TOPICTITLE"/>
				</xsl:when>
				<xsl:otherwise>No Topic Title</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="POST" mode="discussion_status">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	Creates the discussion status dropdown that editors and superuses only see
	-->
	<xsl:template match="POST" mode="discussion_status">
		<!-- This collection of variables and tests check to see if the user is an editor and also that this is the 
			first example of this thread appearing in the lists of posts contained on this page --> 
		<xsl:variable name="thread-id">
			<xsl:value-of select="@THREADID"/>
		</xsl:variable>
		<xsl:variable name="same-thread">
			<xsl:for-each select="/H2G2/POSTMODERATION/POST">
				<xsl:if test="@THREADID = $thread-id">
					<xsl:copy-of select="."/>	
				</xsl:if>								
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$test_IsEditor and (count(msxsl:node-set($same-thread)/POST) = 1 or @MODERATIONID = msxsl:node-set($same-thread)/POST[position() = 1]/@MODERATIONID)">
			<div class="threadStatus">
				<xsl:text>moderation status of conversation </xsl:text>
				<select name="threadmoderationstatus">
					<option value="0">
						<xsl:if test="MODERATION-STATUS = 0">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:text>use default</xsl:text>
					</option>
					<option value="2">
						<xsl:if test="MODERATION-STATUS = 2">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:text>post moderation</xsl:text>
					</option>
					<option value="3">
						<xsl:if test="MODERATION-STATUS = 3">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:text>pre moderation</xsl:text>
					</option>
				</select>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- 
		<xsl:template match="@THREADID" mode="move_discussion">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/@THREADID
		Purpose:	Creates a button to move the discussion
	-->
	<xsl:template match="@THREADID" mode="move_discussion">
		<xsl:if test="($test_IsEditor) or (/H2G2/VIEWING-USER/USER/GROUPS/HOSTS)">
			<div class="moveThread">
				<a onClick="popupwindow('/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/NAME}/MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP&amp;s_frommod=1','MoveThreadWindow','scrollbars=1,resizable=1,width=400,height=400');return false;" href="/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/NAME}/MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP&amp;s_frommod=1">
					<xsl:text>move discussion</xsl:text>
				</a>
			</div>
		</xsl:if>
	</xsl:template>
  <!-- 
		<xsl:template match="@THREADID" mode="move_discussion">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/@THREADID
		Purpose:	Creates a button to move the discussion
	-->
  <xsl:template match="@MODERATIONID" mode="move_via_modid">
    <xsl:if test="($test_IsEditor) or (/H2G2/VIEWING-USER/USER/GROUPS/HOSTS)">
      <div class="moveThread">
        <a onClick="window.open('/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/NAME}/NewMoveThread?ThreadModID={.}&amp;details=1','MoveThreadWindow','scrollbars=1,resizable=1,width=550,height=480');return false;" href="/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/NAME}/NewMoveThread?ThreadModID={.}&amp;details=1">
					<xsl:text>move discussion</xsl:text>
				</a>
			</div>
		</xsl:if>
	</xsl:template>

	<!--
		<xsl:template match="@POSTID" mode="lookup_ipaddress">
		Author: David Williams
		Context: /H2G2/POSTMODERATION/POST/@POSTID
		Purpose: Creates a button to lookup the associated ip address of a post
	-->
	<xsl:template match="POST" mode="lookup_ipaddress">
		<xsl:if test="($test_IsEditor) or (/H2G2/VIEWING-USER/USER/GROUPS/HOSTS)">
			<div class="moveThread">
				<!--<a onclick="window.open('/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/URLNAME}/iplookup?id={.}&amp;DestinationID=F0&amp;mode=POPUP&amp;s_frommod=1','IP Address Lookup Window','scrollbars=1,resizable=1,width=400,height=400')" href="/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/URLNAME}/iplookup?id={.}&amp;DestinationID=F0&amp;mode=POPUP&amp;s_frommod=1">-->
        <a onclick="window.open('/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/SITEID]/NAME}/iplookup?id={@POSTID}&amp;modid={@MODERATIONID}','','scrollbars=1,resizable=1,width=460,height=400');return false;" href="#">
					<xsl:text>lookup ip address</xsl:text>
				</a>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- 
		<xsl:template match="POST" mode="user_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	The user information for the user who created the post. Editors and superusers get more information that moderators
	-->
	<xsl:template match="POST" mode="user_info">
		<p class="postUserBar">
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<!--<xsl:apply-templates select="STATUS" mode="user_status"/>-->
					<xsl:value-of select="USER/USERNAME"/>
					<xsl:text> </xsl:text>
					<a href="memberdetails?userid={USER/USERID}" target="_blank">[member profile]</a>
				</xsl:when>
				<xsl:otherwise>member</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@ISPREMODPOSTING = 1">
					<xsl:text> - This is a pre moderated post and will not exist until you process or edit it - </xsl:text>
          <xsl:choose>
            <xsl:when test="@COMMENTFORUMURL">
              <a href="{@COMMENTFORUMURL}">
                <xsl:text>comment</xsl:text>
              </a>
            </xsl:when>
            <xsl:otherwise>
					<a href="/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/SITEID]/NAME}/F{@FORUMID}?thread={@THREADID}" target="_blank">
						<xsl:text>thread </xsl:text>		
						<xsl:value-of select="@THREADID"/>
					</a>
            </xsl:otherwise>
          </xsl:choose>
				</xsl:when>
				<xsl:when test="@COMMENTFORUMURL">
					<xsl:text> - see comment in context: </xsl:text>
					<a href="{@COMMENTFORUMURL}">
						<xsl:text>comment </xsl:text>
						<xsl:value-of select="@POSTID"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> - see post in context: </xsl:text>
					<a href="/dna/{/H2G2/SITE-LIST/SITE[@ID = current()/SITEID]/NAME}/F{@FORUMID}?thread={@THREADID}&amp;post={@POSTID}#p{@POSTID}" target="_blank">
						<xsl:text>post </xsl:text>
						<xsl:value-of select="@POSTID"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<a href="moderationhistory?PostID={@POSTID}" target="_blank">[post history]</a>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="POST" mode="post_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	Displays the actual content of the POST
	-->
	<xsl:template match="POST" mode="post_info">
		<xsl:choose>
			<xsl:when test="@INREPLYTO">
				<p class="postTitle">
					<xsl:value-of select="SUBJECT"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="firstPostTitle">
					<img src="{$asset-root}moderation/images/first_tag.gif" width="24" height="11" alt="First Post"/>
					<xsl:value-of select="SUBJECT"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<div class="postContent">
			<xsl:apply-templates select="TEXT"/>
		</div>
	</xsl:template>
	<!-- 
		<xsl:template match="ALERT" mode="complaintuser_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/ALERT
		Purpose:	Displays the details of the USER who made the complaint about the POST if there is one
	-->
	<xsl:template match="ALERT" mode="complaintuser_info">
		<p class="alertUserBar">
			<xsl:apply-templates select="USER/STATUS" mode="user_status"/>
			<xsl:apply-templates select="USER/GROUPS" mode="user_groups"/>
			<xsl:choose>
				<xsl:when test="USER/USERNAME">
					<xsl:value-of select="USER/USERNAME"/>		
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>*No username*</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:text> </xsl:text>
			<xsl:if test="$test_IsEditor">
				<!--<a href="inspectuser?FetchUserID={USER/USERID}&amp;FetchUser=Fetch+User" target="_blank">[member profile]</a>-->				  
				<xsl:choose>
					<xsl:when test="USER/USERID = 0 and USER/COMPLAINANTIDVIAEMAIL = -1">
						<xsl:text>[No member info]</xsl:text>
					</xsl:when>
					<xsl:when test="USER/USERID = 0 and not(USER/COMPLAINANTIDVIAEMAIL = -1)">
						<a href="memberdetails?userid={USER/COMPLAINANTIDVIAEMAIL}" target="_blank">[member profile from email]</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="memberdetails?userid={USER/USERID}" target="_blank">[member profile]</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>			
			<xsl:text> raised an alert (submitted at </xsl:text>
			<xsl:apply-templates select="DATEQUEUED/DATE"/>
			<xsl:text>)</xsl:text>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="ALERT" mode="complaint_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/ALERT
		Purpose:	Displays the content of the complaint about the POST if there is one
	-->
	<xsl:template match="ALERT" mode="complaint_info">
		<p class="alertContent">
			<xsl:apply-templates select="TEXT"/>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="ALERTCOUNT" mode="complaint_multiple">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/ALERT/ALERTCOUNT
		Purpose:	Displays if the post has multiple complaints about it
	-->
	<xsl:template match="ALERTCOUNT" mode="complaint_multiple">
		<xsl:if test="not(. = 1) and not(/H2G2/POSTMODERATION/POST[1]/@POSTID = /H2G2/POSTMODERATION/POST[2]/@POSTID)">
			<p class="alertMultiple">
				<a href="moderateposts?modclassid={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}&amp;alerts={/H2G2/POSTMODERATION/@ALERTS}&amp;referrals={/H2G2/POSTMODERATION/@REFERRALS}&amp;postfilterid={../../@POSTID}&amp;lockeditems=1&amp;fastmod={/H2G2/POSTMODERATION/@FASTMOD}" target="_blank">
					<xsl:text>Notice: Please click here to view all complaints for this post before making your decision!</xsl:text>
				</a>
			</p>
		</xsl:if>
	</xsl:template>
	<!-- 
		<xsl:template match="REFERRED" mode="referringuser_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/REFERRED
		Purpose:	Displays the details of the USER who made the referral of the POST if there is one
	-->
	<xsl:template match="REFERRED" mode="referringuser_info">
		<p class="referredUserBar">
			<xsl:apply-templates select="DATEREFERRED/DATE"/>
			<xsl:text> referred by </xsl:text>
			<xsl:value-of select="USER/USERNAME"/>
			<xsl:text> to </xsl:text>
			<xsl:value-of select="../LOCKED/USER/USERNAME"/>
      <xsl:text> because: </xsl:text>
      <xsl:apply-templates select="../NOTES" mode="referred_info"/>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="REFERRED" mode="referred_info">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST/REFERRED
		Purpose:	Displays the details of the referral of the POST if there is one
	-->
	<xsl:template match="REFERRED" mode="referred_info">
		<p class="referredContent">
			<xsl:value-of select="TEXT"/>
		</p>
	</xsl:template>

  <!-- Display Moderation Notes. -->
  <xsl:template match="NOTES" mode="referred_info">
    <p class="referredContent">
      <xsl:apply-templates select="."/>
    </p>
  </xsl:template>

  <!-- Display Moderation Notes. -->
  <xsl:template match="NOTES" mode="notes">
    <xsl:if test="string-length(.) > 0">
      <p class="referredUserBar">
        <xsl:apply-templates select="."/>
      </p>
    </xsl:if>
  </xsl:template>
  
	<!-- 
		<xsl:template match="POST" mode="mod_form">
		Author:	Andy Harris
		Context:    	/H2G2/POSTMODERATION/POST
		Purpose:	Creates the various elements of the moderation form for the post, what is included depends on the type of user and whether this is a complaint of a referral.
	-->
	<xsl:template match="POST" mode="mod_form">
		<xsl:variable name="currentSite">
			<xsl:value-of select="SITEID"/>
		</xsl:variable>
		<xsl:variable name="modid">
			<xsl:value-of select="@MODERATIONID"/>
		</xsl:variable>
		<div class="toolBox">
			<h2>Moderation Action</h2>
			<div class="postForm" id="form{@MODERATIONID}">
				<label class="hiddenLabel" for="Decision">Moderation decision for the post</label>
				<select class="type" name="Decision">
					<xsl:attribute name="id">Decision<xsl:number/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="../@ALERTS = 1">
							<option value="3" class="{@MODERATIONID}">Reject Alert &amp; Pass Post</option>
							<option value="8" class="{@MODERATIONID}">Uphold Alert &amp; Edit Post</option>
							<option value="4" class="{@MODERATIONID}">Uphold Alert &amp; Fail Post</option>
							<option value="2" class="{@MODERATIONID}">Refer</option>
							<!--<option value="acknowledge" class="{@MODERATIONID}">Acknowledge Alert &amp; Pass Post</option>
							<option value="7" class="{@MODERATIONID}">Hold</option>-->
						</xsl:when>
						<xsl:otherwise>
							<option value="3" class="{@MODERATIONID}">Pass</option>
							<option value="8" class="{@MODERATIONID}">Edit</option>
							<option value="4" class="{@MODERATIONID}">Fail</option>
							<option value="2" class="{@MODERATIONID}">Refer</option>
							<!--<option value="7" class="{@MODERATIONID}">Hold</option>-->
						</xsl:otherwise>
					</xsl:choose>
				</select>
				<div class="refer">
					<label class="hiddenLabel" for="ReferTo">This post is being referred to </label>
					<select name="ReferTo" class="referName">
						<xsl:attribute name="id">ReferTo<xsl:number/></xsl:attribute>
						<option class="{$modid}">or Refer to</option>
						<xsl:for-each select="/H2G2/REFEREE-LIST/REFEREE">
							<xsl:if test="SITEID = $currentSite">
								<option class="{$modid}" value="{USER/USERID}">
									<xsl:value-of select="USER/USERNAME"/>
								</option>
							</xsl:if>
						</xsl:for-each>
					</select>
				</div>
				<div class="fail">
					<label class="hiddenLabel">
					<xsl:attribute name="for">EmailType<xsl:number/></xsl:attribute>
					This post has been failed for 
					</label>
					<select class="failReason" name="EmailType">
						<xsl:attribute name="id">EmailType<xsl:number/></xsl:attribute>
						<option class="{$modid}">or Select failure reason</option>
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<xsl:for-each select="/H2G2/MOD-REASONS/MOD-REASON">
									<option class="{$modid}" value="{@EMAILNAME}">
										<xsl:value-of select="@DISPLAYNAME"/>
									</option>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="/H2G2/MOD-REASONS/MOD-REASON[@EDITORSONLY = 0]">
									<option class="{$modid}" value="{@EMAILNAME}">
										<xsl:value-of select="@DISPLAYNAME"/>
									</option>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</select>
				</div>
				<div class="edit">
					<label class="hiddenLabel" for="edit reason">This post has been edited for </label>
					<select class="editReason" name="editreason">
						<option class="{@MODERATIONID}">select edit reason</option>
						<option value="{/H2G2/MOD-REASONS/MOD-REASON[@EMAILNAME='URLInsert']/@EMAILNAME}" class="{@MODERATIONID}">
              <xsl:value-of select="/H2G2/MOD-REASONS/MOD-REASON[@EMAILNAME='URLInsert']/@DISPLAYNAME"/>
            </option>
            <option value="{/H2G2/MOD-REASONS/MOD-REASON[@EMAILNAME='PersonalInsert']/@EMAILNAME}" class="{@MODERATIONID}">
              <xsl:value-of select="/H2G2/MOD-REASONS/MOD-REASON[@EMAILNAME='PersonalInsert']/@DISPLAYNAME"/>
            </option>
            
            <!-- Allow Kids sites to have a free edit option. -->
						<xsl:if test="/H2G2/SITEOPTIONSLIST/SITEOPTIONS[@SITEID=current()/SITEID]/SITEOPTION[NAME='IsKidsSite']/VALUE='1'">
							<option value="{/H2G2/MOD-REASONS/MOD-REASON[@EMAILNAME='CustomInsert']/@EMAILNAME}" class="{@MODERATIONID}">
                Free Edit
              </option>
						</xsl:if>
					</select>
				</div>
				<div class="editText">
          <label class="hiddenLabel" for="editpostsubject">Edit the title</label>
          <input type="text" name="editpostsubject" size="40" value="{SUBJECT}"/>
					<label class="hiddenLabel" for="editposttext">Edit the post</label>
					<textarea rows="5" cols="40" name="editposttext" class="editArea">
						<xsl:choose>
							<xsl:when test="RAWTEXT">
								<xsl:copy-of select="RAWTEXT/node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="TEXT/node()"/>
							</xsl:otherwise>
						</xsl:choose>
						<!--<xsl:value-of select="TEXT"/>-->
						<xsl:text> </xsl:text>
					</textarea>
				</div>
				<div class="reasonText">
					<div class="textLabel">
						<xsl:text>Reason</xsl:text>
					</div>
					<label class="hiddenLabel" for="Notes"> why the post has been referred or put on hold</label>
					<textarea rows="5" cols="40" name="Notes" class="reasonArea">
						<xsl:attribute name="id">NotesArea<xsl:number/></xsl:attribute>
						<xsl:text>&nbsp;</xsl:text>
					</textarea>
				</div>
				<!--<div class="urlText">
					<div class="urlRemoved">
						<xsl:text>Removed URL(s)</xsl:text>
					</div>
					<label class="hiddenLabel" for="urlemailtext"> from the edited post</label>
					<textarea rows="5" cols="40" name="urlemailtext" class="urlRemoved">
						<xsl:attribute name="id">urlArea<xsl:number/></xsl:attribute>
						<xsl:text>&nbsp;</xsl:text>
					</textarea>
				</div>-->
				<div class="emailText">
					<div class="textLabel">
						<xsl:text>Removed URL(s) or Custom email text</xsl:text>
					</div>
					<label class="hiddenLabel" for="customemailtext"> for a custom failure reason</label>
					<textarea rows="5" cols="40" name="customemailtext">
						<xsl:attribute name="id">CustomEmailText<xsl:number/></xsl:attribute>
						<xsl:text>&nbsp;</xsl:text>
					</textarea>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="POST" mode="distress_message">
		<div class="distress">
			<xsl:text>Post distress message </xsl:text>
			<select name="distressmessageID">
				<option value="0">none selected</option>
				<xsl:for-each select="/H2G2/DISTRESSMESSAGES/DISTRESSMESSAGE">
					<option value="{@ID}">
						<xsl:value-of select="SUBJECT"/>
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>
	<xsl:template match="ENCAP | TIME | REVELATIONS | SUBJECT | BEFORETITLE | BEFORETEXT | AFTERTITLE | AFTERTEXT | OPTION1 | OPTION2 | OPTION3 | BODY | CREATOR | TAGLINE">
		<xsl:apply-templates/>
		<br/><br/>
	</xsl:template>
</xsl:stylesheet>
