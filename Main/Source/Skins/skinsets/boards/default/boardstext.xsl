<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" version="1.0" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="m_pagetitlestart">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				BBC - <xsl:copy-of select="/H2G2/SITECONFIG/BOARDNAME"/> - Administration				
			</xsl:when>
			<xsl:otherwise>
				BBC - <xsl:copy-of select="/H2G2/SITECONFIG/BOARDNAME"/> - 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_replytothispost">Join in this discussion</xsl:variable>
	<xsl:variable name="alt_newconversation">
		<img src="{$imagesource}startnewdiscussion.gif" alt="Start new discussion" width="142" height="20" border="0"/>
	</xsl:variable>
	<xsl:variable name="alt_nowshowing">Boing! </xsl:variable>
	<xsl:variable name="alt_show"/>
	<xsl:variable name="alt_complain">Complain about this message</xsl:variable>
	<xsl:variable name="m_by"/>
	<xsl:variable name="m_postblockprev"/>
	<xsl:variable name="m_postblocknext"/>
	<xsl:variable name="m_fsubject"> </xsl:variable>
	<xsl:variable name="m_textcolon">Message:</xsl:variable>
	<xsl:variable name="m_returntoconv">
		<img src="{$imagesource}cancel_button.gif" alt="Cancel" width="104" height="23" border="0"/>
	</xsl:variable>
	<xsl:template name="m_complaintpopupseriousnessproviso">	</xsl:template>
	<xsl:variable name="m_postingcomplaintdescription">	</xsl:variable>
	<xsl:variable name="m_firstpagethreads"> First </xsl:variable>
	<xsl:variable name="m_nofirstpagethreads">
		<span class="off"> First </span>
	</xsl:variable>
	<xsl:variable name="m_lastpagethreads"> Last </xsl:variable>
	<xsl:variable name="m_nolastpagethreads">
		<span class="inactive"> Last </span>
	</xsl:variable>
	<xsl:variable name="m_previouspagethreads">&lt;&lt; Previous </xsl:variable>
	<xsl:variable name="m_nopreviouspagethreads">
		<span class="off">&lt;&lt; Previous </span>
	</xsl:variable>
	<xsl:variable name="m_nextpagethreads"> Next &gt;&gt;</xsl:variable>
	<xsl:variable name="m_nonextpagethreads">
		<span class="off">Next &gt;&gt;</span>
	</xsl:variable>
	<xsl:variable name="m_threadpostblockprev"/>
	<xsl:variable name="m_threadpostblocknext"/>
	<xsl:variable name="alt_previouspage">Previous</xsl:variable>
	<xsl:variable name="alt_nextpage">Next</xsl:variable>
	<!-- Multipostspage stuff -->
	<xsl:variable name="alt_nonewerpost">
		<span class="off">Last</span>
	</xsl:variable>
	<xsl:variable name="alt_shownewest">Last</xsl:variable>
	<xsl:variable name="alt_showoldestconv">First</xsl:variable>
	<xsl:variable name="alt_showingoldest">
		<span class="off">First</span>
	</xsl:variable>
	<xsl:variable name="alt_showpostings"> Next &gt;</xsl:variable>
	<xsl:variable name="alt_nonewconvs">
		<span class="off"> Next &gt;</span>
	</xsl:variable>
	<xsl:variable name="m_noolderconv">
		<span class="off">&lt; Previous </span>
	</xsl:variable>
	<!-- Where are these from? -->
	<xsl:variable name="m_MoveThread">Move Discussion</xsl:variable>
	<!--SSO paths through messageboards-->
	<xsl:variable name="m_ptclicktostartnewconv">Return to the message boards</xsl:variable>
	<xsl:variable name="m_ptclicktowritereply">Return to the message boards</xsl:variable>
	<xsl:variable name="m_morepoststitle">
		<xsl:choose>
			<xsl:when test="/H2G2/POSTS/POST-LIST/USER/USERNAME">
				<xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERNAME"/>'s page</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="m_postcomplaint">
		This <xsl:value-of select="$m_posting"/> has been temporarily hidden by a member of the Community Team and referred to the Moderation Team for a decision as to whether it contravenes the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House ules</a> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
	</xsl:template>	
	<xsl:template name="m_postawaitingmoderation">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/NAME = 'mbcbbc' or /H2G2/SITE/NAME = 'mbnewsround'">This message is waiting to be checked by the mods and it will be live as soon as possible.</xsl:when>
			<xsl:otherwise>This posting has been temporarily hidden, because a member of our Moderation Team has referred it to the Hosts for a decision as to whether it contravenes the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_postawaitingpremoderation"> 
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/NAME = 'mbcbbc' or /H2G2/SITE/NAME = 'mbnewsround'">This message is waiting to be checked by the mods and it will be live as soon as possible.</xsl:when>
			<xsl:otherwise>This posting is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a>).</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_postremoved">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/NAME = 'mbcbbc' or /H2G2/SITE/NAME = 'mbnewsround'">Oops! This message broke the <a xsl:use-attribute-sets="nm_postremoved" TARGET="_blank" HREF="/cbbc/mb/rules.shtml">House Rules</a></xsl:when>
			<xsl:otherwise>This posting has been hidden during moderation because it broke the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House Rules</a> in some way.</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	<xsl:template name="m_posthasbeenpremoderated">
<font size="2">
Thank you for posting to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards.<br/>
Your message will be checked before it appears on the board to make sure it doesn't break our  <a href="{$houserulespopupurl}" onclick="popupwindow('{$houserulespopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">House Rules.</a><br/>
The BBC receives thousands of messages every day so please be patient.<br/><br/>	
		<xsl:choose>
			<xsl:when test="number(@NEWCONVERSATION)=1">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
</font>		
	</xsl:template>	
	<xsl:template name="m_posthasbeenqueued">
<font size="2">
Thank you for posting to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards.<br/>
Your message has been placed in a queue and will appear on the board shortly. If the boards are particularly busy this might take a few minutes.<br/>
The BBC receives thousands of messages every day so please be patient.<br/><br/>	
		<xsl:choose>
			<xsl:when test="@THREAD">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}#p{@POST}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
</font>		
	</xsl:template>	
	<xsl:template name="m_posthasbeenautopremoderated">
<font size="2">
Thank you for posting to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards.<br/>
All posts by new message board members are pre-moderated.  This means that your first few postings will not appear on the message board immediately, as they need to be checked by a moderator first.   After you have used the BBC message boards for a while, you will become a trusted user and your posts will appear on the board as soon as you post them.<br/>
The BBC receives thousands of messages every day so please be patient.<br/><br/>	
		<xsl:choose>
			<xsl:when test="number(@NEWCONVERSATION)=1">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
</font>		
	</xsl:template>
  <xsl:template name="m_usernamenotsetyet">
    <font size="2">
      <br/>
Your current nickname is <b>U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/></b>. This is the name that will appear on the message boards. If you would like a different Nickname you can 
	<a>
		<xsl:attribute name="href">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = '1'">
					<xsl:value-of select="$id_settingslink" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($root, 'UserDetails')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	change it</a>.
    </font>
  </xsl:template>
</xsl:stylesheet>
