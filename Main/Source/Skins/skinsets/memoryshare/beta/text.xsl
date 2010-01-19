<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">
	<xsl:variable name="m_userpagenav">Member Page</xsl:variable>
	<xsl:variable name="m_nickname">Nickname</xsl:variable>
	<xsl:variable name="m_nicknameis">Your Nickname is </xsl:variable>
	<xsl:variable name="m_updatedetails">Save my changes</xsl:variable>
	
	<!-- generic terms -->
	<xsl:variable name="m_user">member</xsl:variable>
	<xsl:variable name="m_users">members</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article">memory</xsl:variable>
	<xsl:variable name="m_articles">memories</xsl:variable>
	<xsl:variable name="m_articlea"> a </xsl:variable>
	<xsl:variable name="m_articleurl">memory</xsl:variable>
	<xsl:variable name="m_editedarticle">edited memory</xsl:variable>
	<xsl:variable name="m_editedarticles">edited memories</xsl:variable>
	<xsl:variable name="m_editedarticlea"> an </xsl:variable>
	<xsl:variable name="m_editedguide">edited site</xsl:variable>
	<xsl:variable name="m_posting">comment</xsl:variable>
	<xsl:variable name="m_postings">comments</xsl:variable>
	<xsl:variable name="m_postinga"> a </xsl:variable>
	<xsl:variable name="m_postingurl">posting</xsl:variable>
	<xsl:variable name="m_thread">conversation</xsl:variable>
	<xsl:variable name="m_threads">conversations</xsl:variable>
	<xsl:variable name="m_threada"> a </xsl:variable>
	<xsl:variable name="m_threadurl">conversation</xsl:variable>
	<!--
	<xsl:variable name="m_forum">Conversation Forum</xsl:variable>
	<xsl:variable name="m_forums">Conversation Forums</xsl:variable>
	<xsl:variable name="m_foruma"> a </xsl:variable>
	<xsl:variable name="m_journal">Journal</xsl:variable>
	<xsl:variable name="m_journals">Journals</xsl:variable>
	<xsl:variable name="m_journala"> a </xsl:variable>
	<xsl:variable name="m_journalposting">Journal Entry</xsl:variable>
	<xsl:variable name="m_journalpostings">Journal Entries</xsl:variable>
	<xsl:variable name="m_journalpostinga"> a </xsl:variable>
	-->
	<xsl:variable name="m_nosuchguideentry">no such memory</xsl:variable>
	<xsl:variable name="m_backtouserpage">Click here to go back to your Member Page</xsl:variable>
	
	
	<xsl:variable name="m_MABackTo">Back to </xsl:variable>
	<xsl:variable name="m_MAPSpace">'s Member Page</xsl:variable>

	
	<xsl:variable name="m_nextpageartsp">Next</xsl:variable>
	<xsl:variable name="m_previouspageartsp">Previous</xsl:variable>
	<xsl:variable name="m_nopreviouspageartsp">Next </xsl:variable>
	<xsl:variable name="m_nonextpageartsp">Previous </xsl:variable>	
	
	<xsl:variable name="m_firstpageartsp">first</xsl:variable>
	<xsl:variable name="m_lastpageartsp">last</xsl:variable>
	<xsl:variable name="m_nofirstpageartsp">no first</xsl:variable>
	<xsl:variable name="m_nolastpageartsp">no last</xsl:variable>	


	<xsl:variable name="m_noprevresults" select="$m_nonextpageartsp"/>
	<xsl:variable name="m_nomoreresults" select="$m_nopreviouspageartsp"/>
	<xsl:variable name="m_prevresults" select="$m_previouspageartsp"/>
	<xsl:variable name="m_nextresults" select="$m_nextpageartsp"/>

	<xsl:variable name="m_pagetitlestart">BBC Memoryshare - </xsl:variable>
	<xsl:variable name="m_frontpagetitle">BBC Memoryshare</xsl:variable>
	
	<!-- addthreadpage.xsl  -->
	<xsl:variable name="m_returntoconv">Go back without  <xsl:value-of select="$m_postingurl"/></xsl:variable>
	
	
	<xsl:template name="m_posthasbeenpremoderated">
		<p>Thank you for adding a comment to Memoryshare.<br/>
		<!--[FIXME: do we need this?]
		All contributions by new Memoryshare members are pre-moderated. This means that your first few articles or comments will not appear on the site immediately, as they need to be checked by a moderator first. After you have used Memoryshare for a while, you will become a trusted user and your contibutions will appear as soon as you post them.
		The BBC receives thousands of messages every day so please be patient.
		-->
		</p>
		<p>return to <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">memory</a></p>
	</xsl:template>
	
	<xsl:template name="m_posthasbeenautopremoderated">
		<p>Thank you for adding a comment to Memoryshare.<br/>
		<!--[FIXME: do we need this?]
		All contributions by new Memoryshare members are pre-moderated.  This means that your first few comments will not appear on the site immediately, as they need to be checked by a moderator first.   After you have used Memoryshare for a while, you will become a trusted user and your comments will appear on the site as soon as you post them.<br/>
		The BBC receives thousands of messages every day so please be patient.
		-->
		</p>
		<p>return to <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">memory</a></p>
		
		<!--
		<p>return to <a href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">comments</a></p>
		-->		
	</xsl:template>
	

	<!-- morepostspage.xsl -->
	<xsl:variable name="m_postedcolon">Posted: </xsl:variable>
	<xsl:variable name="m_latestreply">Latest reply: </xsl:variable>
	<xsl:variable name="m_noreplies">No replies</xsl:variable>
	<xsl:variable name="m_PostsBackTo">Back to </xsl:variable>
	<xsl:variable name="m_PostsPSpace">'s Member Page</xsl:variable>
	<xsl:variable name="m_forumownerempty">This section will display details of any <xsl:value-of select="$m_postings"/> you make to <xsl:value-of select="$m_threads"/>. This is really useful: by checking out this section you can keep track of <xsl:value-of select="$m_threads"/> you are involved in and can see if anyone has replied to your <xsl:value-of select="$m_postings"/>, and when.</xsl:variable>
	<xsl:variable name="m_forumviewerempty">This section will display details of any <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> makes, when they get around to talking to the rest of the Community. <xsl:value-of select="$m_threads"/> are really fun and are the best way to meet people, as well as the best way to get people to visit your own Member Page, so let's hope they join in soon.</xsl:variable>
	
	<!-- usercomplaintpopup.xsl -->
	<xsl:template name="m_complaintpopupseriousnessproviso">
    <xsl:text>This form is only for serious complaints about specific content on Memoryshare that breaks the site's </xsl:text>
    <a href="houserules" target="_blank">House Rules</a>
    <xsl:text>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material. For general feedback please contact us via the </xsl:text>
    <a href="help">Feedback Form.</a>
	</xsl:template>
	
	
	
<xsl:template name="m_regwaittransfer">
    <p>
      Please wait while you are transferred to your Member Page.
      <a xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{NEWREGISTER/USERID}">Click here</a> if nothing happens after a few seconds.
      </p>
</xsl:template>
	
<xsl:variable name="m_regwaittransfer">
    <p>
      Please wait while you are transferred to your Member Page. 
      <a xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{/H2G2/NEWREGISTER/USERID}">Click here</a> if nothing happens after a few seconds.
    </p>
</xsl:variable>
	
<xsl:template name="m_passthroughnewuser">
	<!-- This is a generic message when someone has just registered while doing a passthrough -->
	Welcome. You're now registered; you can now visit your member page, where you can submit a profile about yourself and become a full member of Memoryshare.<br/>
 </xsl:template>
	
<!-- userpage.xsl -->	
<xsl:template name="m_userpagehidden">
<xsl:choose>
<xsl:when test="$test_OwnerIsViewer = 1">
<p>Your profile has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden1" HREF="{$root}HouseRules">House Rules</A> in some way - you have been sent an email explaining why.</p>
<p>You can easily re-write your profile so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit profile' link, make any changes to ensure that your profile doesn't break the rules, and click on 'Publish'.</p>
</xsl:when>
<xsl:otherwise>
<p>This Personal Space Introduction has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden2" HREF="{$root}HouseRules">House Rules</A> in some way. We will show it as soon as the author has made the necessary amendments. </p>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="m_userpagereferred">
<xsl:choose>
<xsl:when test="$test_OwnerIsViewer = 1">
<p>Your profile has been temporarily hidden, because a member of our moderation team has referred it to the community team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</p>
<p>Please do not try to edit your Introduction in the meantime, as this will only mean it gets checked by the Moderation Team twice.</p>
</xsl:when>
<xsl:otherwise>
<p>This profile has been temporarily hidden, because a member of our moderation team has referred it to the community team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</p>
</xsl:otherwise>
</xsl:choose>
</xsl:template>




<xsl:template name="m_userpagependingpremoderation">
<xsl:choose>
<xsl:when test="$test_OwnerIsViewer = 1">
<p>New members' contributions are pre-moderated for a short initial period. This is to ensure new members are posting within house rules. Your profile is now queued for moderation, and will be visible as soon as a member of our moderation team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>).</p>
</xsl:when>
<xsl:otherwise>
<p>This profile is currently queued for moderation, and will be visible as soon as a member of our moderation team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>).</p>

</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="m_psintroowner">
<p>
This is your 'About You' space which you can update by clicking on the edit profile link below.
</p>
<p>
Use this space to tell us something about yourself so that other members have some context for your memories. But please but don't include anything you don't want others to see!
</p>
</xsl:template> 


<xsl:template name="m_psintroviewer">
<p>This is the 'About You' space for <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>. <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> hasn't written anything by way of an introduction yet, but hopefully that will soon change.</p>

<p>If you are a Memoryshare member and you haven't written anything for your own 'About You' space, you can go to Your Memories and tell us something about yourself so that other members have some context for your memories. But please but don't include anything you don't want others to see!</p>
</xsl:template>


<xsl:template name="m_articlepremodblurb">
<p>Your contributions are currently being pre-moderated. This means that you can create and edit normally, but they will not be visible until they have been approved by a moderator. This will take less than one hour, usually much less.</p>
</xsl:template>

<!-- articlepage.xsl-->
<xsl:template name="m_articlehiddentext">
	<div id="ms-std">
		<div id="ms-std-header">
			<xsl:comment> </xsl:comment>
		</div>
		<div id="ms-std-content">
	<xsl:choose>
		<xsl:when test="$test_OwnerIsViewer = 1">
			<p>Your <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}HouseRules">House Rules</A> in some way.</p>
			<p>You can easily re-write your memory so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'edit this <xsl:value-of select="$article_type_group"/>' button, make any changes to ensure that your memory doesn't break the rules, and click on 'Preview' then 'Publish'.</p>
			
			<p><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Edit this memory</a></p>
		</xsl:when>
		<xsl:otherwise>
			<p>This memory has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write it so that it doesn't break the rules, so let's hope they do just that.</p>
		</xsl:otherwise>
	</xsl:choose>
		</div>
		<div id="ms-std-footer">
			<xsl:comment> </xsl:comment>
		</div>
	</div>
</xsl:template>

<xsl:template name="m_articlereferredtext">
	<div id="ms-std">
		<div id="ms-std-header">
			<xsl:comment> </xsl:comment>
		</div>
		<div id="ms-std-content">
			<xsl:choose>
				<xsl:when test="$test_OwnerIsViewer = 1">
					<p>
						Your memory has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
					</p>
					<p>Please do not try to edit your memory in the meantime, as this will only mean it gets checked by the Moderation Team twice.</p>
				</xsl:when>
				<xsl:otherwise>
					<p>
						This memory has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div id="ms-std-footer">
			<xsl:comment> </xsl:comment>
		</div>
	</div>
</xsl:template>


<xsl:template name="m_articleawaitingpremoderationtext">
	<div class="bodytext">
	<xsl:choose>
		<xsl:when test="$test_OwnerIsViewer = 1">
			<p>Your memories are being pre-moderated and will only appear after they have been approved by a Moderator. Your <xsl:value-of select="$m_article"/> is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext1" HREF="{$root}HouseRules">House Rules</A>).</p>
		</xsl:when>
		<xsl:otherwise>
			<p>This memory is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</p>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>

<xsl:template name="m_articledeletedbody">
	<div class="bodytext">
		<p>
		This memory has been removed by the author or by a moderator.
		</p>
		<p>
		We apologise for this interruption to your surfing. 
		</p>
	</div>
</xsl:template>

<xsl:variable name="default_subscribe_form_header">Subscribe to the Memoryshare newsletter</xsl:variable>
<xsl:variable name="default_subscribe_form_intro">
	<p>Sign up for the Memoryshare newsletter and we'll keep you up to date with all the most important developments on the service and on the calls for memories from BBC programmes. It's not a regular newsletter so we promise to only send one out when we've actually have something worth saying. It may include information about other BBC services, links or events we think might be of interest to you.</p>
</xsl:variable>
<!--xsl:variable name="default_subscribe_form_intro">
	<p>Sign up for the Memoryshare newsletter and we'll keep you up to date with all the most important developments on the service and on the calls for memories from BBC programmes. It's not a regular newsletter so we promise to only send one out when we've actually have something worth saying. It may include information about other BBC services, links or events we think might be of interest to you.</p>
	<p><strong>The BBC won't contact you for marketing purposes, or promote new services to you unless you specifically agree to be contacted for these purposes.</strong></p>
	<p>To subscribe to the Memoryshare newsletter, please type in your <label for="subscribe_email">email address</label> below and click the subscribe button.</p>
</xsl:variable-->

		<xsl:variable name="default_subscribe_form">
	<SUBSCRIBE_NEWSLETTERFORM>
		<HEADER>Subscribe to the Memoryshare newsletter</HEADER>
		<INTRO>
		Sign up for the Memoryshare newsletter and we'll keep you up to date with all the most important developments on the service and on the calls for memories from BBC programmes. It's not a regular newsletter so we promise to only send one out when we've actually have something worth saying. It may include information about other BBC services, links or events we think might be of interest to you.<br/><br/>
<b>The BBC won?t contact you for marketing purposes, or promote new services to you unless you specifically agree to be contacted for these purposes.</b><br/><br/>

	To subscribe to the Memoryshare newsletter, please type in your email address below and click the subscribe button.
		</INTRO>
	</SUBSCRIBE_NEWSLETTERFORM>
</xsl:variable>

<xsl:variable name="default_unsubscribe_form_header">Unsubscribe to the Memoryshare newsletter</xsl:variable>
<xsl:variable name="default_unsubscribe_form_intro">
	<p>To unsubscribe from the Memoryshare newsletter, please type in your <label for="unsubscribe_email">email address</label> and click the unsubscribe button.</p>
</xsl:variable>	
	
<xsl:variable name="default_unsubscribe_form">
	<UNSUBSCRIBE_NEWSLETTERFORM>
		<HEADER>Unsubscribe from the Memoryshare newsletter</HEADER>
		<INTRO>
		 To unsubscribe from the Memoryshare newsletter, please type in your email address and click the unsubscribe button.
		</INTRO>
	</UNSUBSCRIBE_NEWSLETTERFORM>
</xsl:variable>

</xsl:stylesheet>
