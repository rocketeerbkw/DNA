<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="m_userpagenav">Member Page</xsl:variable>
	<xsl:variable name="m_nickname">Nickname</xsl:variable>
	<xsl:variable name="m_nicknameis">Your Nickname is </xsl:variable>
	<xsl:variable name="m_updatedetails">Save my changes</xsl:variable>
	
	<!-- generic terms -->
	<xsl:variable name="m_user">member</xsl:variable>
	<xsl:variable name="m_users">members</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article">article</xsl:variable>
	<xsl:variable name="m_articles">articles</xsl:variable>
	<xsl:variable name="m_articlea"> an </xsl:variable>
	<xsl:variable name="m_articleurl">article</xsl:variable>
	<xsl:variable name="m_editedarticle">edited article</xsl:variable>
	<xsl:variable name="m_editedarticles">edited articles</xsl:variable>
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
	<xsl:variable name="m_nosuchguideentry">no such <xsl:value-of select="$m_article"/></xsl:variable>
	<xsl:variable name="m_backtouserpage">Click here to go back to your Member Page</xsl:variable>
	
	
	<xsl:variable name="m_MABackTo">Back to </xsl:variable>
	<xsl:variable name="m_MAPSpace">'s Member Page</xsl:variable>
	
	
	
	<!-- addthreadpage.xsl  -->
	<xsl:variable name="m_returntoconv">Go back without  <xsl:value-of select="$m_postingurl"/></xsl:variable>
	
	
	<xsl:template name="m_posthasbeenpremoderated">
		<p>Thank you for adding a comment to 606.<br/>
		All contributions by new 606 members are pre-moderated. This means that your first few articles or comments will not appear on the site immediately, as they need to be checked by a moderator first. After you have used the 606 for a while, you will become a trusted user and your contibutions will appear as soon as you post them.
		The BBC receives thousands of messages every day so please be patient.</p>
	
		<p>return to <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">article</a></p>
	</xsl:template>
	
	<xsl:template name="m_posthasbeenautopremoderated">
		<p>Thank you for adding a comment to 606.<br/>
		All contributions by new 606 members are pre-moderated.  This means that your first few comments will not appear on the site immediately, as they need to be checked by a moderator first.   After you have used the 606 for a while, you will become a trusted user and your comments will appear on the site as soon as you post them.<br/>
		The BBC receives thousands of messages every day so please be patient.</p>
		
		<p>return to <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">article</a></p>
		
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
		This form is only for serious complaints about specific content that breaks the site's <A xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" HREF="{$root}HouseRules">House Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.<br/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<hr/>
	</xsl:template>
	
	
	
<xsl:template name="m_regwaittransfer">
<p>Please wait while you are transferred to your Member Page. 
<A xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{NEWREGISTER/USERID}">Click here</A> if nothing happens after a few seconds.</p>
</xsl:template>
	
<xsl:variable name="m_regwaittransfer">
Please wait while you are transferred to your Member Page. 
<a xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{/H2G2/NEWREGISTER/USERID}">Click here</a> if nothing happens after a few seconds.
	</xsl:variable>
	
<xsl:template name="m_passthroughnewuser">
		<!-- This is a generic message when someone has just registered while doing a passthrough -->
Welcome. You're now registered; you can now visit your member page, where you can submit a profile about yourself and become a full member of 606.<br/>
 </xsl:template>
	
<!-- userpage.xsl -->	
<xsl:template name="m_userpagehidden">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
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
<xsl:when test="$ownerisviewer = 1">
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
<xsl:when test="$ownerisviewer = 1">
<p>New members' contributions are pre-moderated for a short initial period. This is to ensure new members are posting within house rules. Your profile is now queued for moderation, and will be visible as soon as a member of our moderation team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>).</p>
</xsl:when>
<xsl:otherwise>
<p>This profile is currently queued for moderation, and will be visible as soon as a member of our moderation team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>).</p>

</xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template name="m_psintroowner">
<p>This is the profile for your member page - an extremely useful space to have.</p>

<p>You can submit an introduction about you, and upload links of your choice - it's where people can come along and find out all about you. You can also access all your most recent contributions from your member page, including articles written and commented on. It is basically your personal nerve centre.</p>

<p>You can get to this page at any time by clicking on the 'Member Page' button on the left-hand side.</p>
</xsl:template> 


<xsl:template name="m_psintroviewer">
<p>This is the profile of <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>. Unfortunately <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> doesn't seem to have found the time to write anything by way of an introduction yet, but hopefully that will soon change.</p>

<p>By the way, if you've registered but haven't yet written a profile for your member page, this is what your space looks like to visitors. You can change this by clicking on the 'Member Page' button on the left-hand side, and editing your profile.</p>
</xsl:template>


<xsl:template name="m_articlepremodblurb">
<p>Your contributions are currently being pre-moderated. This means that you can create and edit normally, but they will not be visible until they have been approved by a moderator. This will take less than one hour, usually much less.</p>
</xsl:template>

<!-- articlepage.xsl-->
<xsl:template name="m_articlehiddentext">
	<div class="bodytext">
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<p>Your <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}HouseRules">House Rules</A> in some way.</p>
			<p>You can easily re-write your <xsl:value-of select="$m_article"/> so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'edit this <xsl:value-of select="$article_type_group"/>' button, make any changes to ensure that your <xsl:value-of select="$m_article"/> doesn't break the rules, and click on 'preview' then 'publish'.</p>
			
			<p><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"><img src="{$imagesource}edit_{$article_type_group}.gif" width="118" height="23" alt="edit this {$article_type_group}"/></a></p>
		</xsl:when>
		<xsl:otherwise>
			<p>This <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write it so that it doesn't break the rules, so let's hope they do just that.</p>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>

<xsl:template name="m_articlereferredtext">
	<div class="bodytext">
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<p>Your <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</p>
			<p>Please do not try to edit your <xsl:value-of select="$m_article"/> in the meantime, as this will only mean it gets checked by the Moderation Team twice.</p>
		</xsl:when>
		<xsl:otherwise>
			<p>This <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</p>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>


<xsl:template name="m_articleawaitingpremoderationtext">
	<div class="bodytext">
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<p>Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator. Your <xsl:value-of select="$m_article"/> is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext1" HREF="{$root}HouseRules">House Rules</A>).</p>
		</xsl:when>
		<xsl:otherwise>
			<p>This <xsl:value-of select="$m_article"/> is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</p>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>

<xsl:template name="m_articledeletedbody">
	<div class="bodytext">
		<p>This <xsl:value-of select="$m_article"/> has been removed by a moderator because it broke the <a href="http://www.bbc.co.uk/dna/606/houserules">house rules</a> in some way.</p>
		<p>We apologise for this interruption to your surfing.</p>
	</div>
</xsl:template>


</xsl:stylesheet>
