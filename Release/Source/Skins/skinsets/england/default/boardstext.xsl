<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
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
	<xsl:variable name="m_nofirstpagethreads">First</xsl:variable>
	<xsl:variable name="m_lastpagethreads"> Last </xsl:variable>
	<xsl:variable name="m_nolastpagethreads">Last</xsl:variable>
	<xsl:variable name="m_previouspagethreads">&lt;&lt; Previous </xsl:variable>
	<xsl:variable name="m_nopreviouspagethreads">&lt;&lt; Previous</xsl:variable>
	<xsl:variable name="m_nextpagethreads"> Next &gt;&gt;</xsl:variable>
	<xsl:variable name="m_nonextpagethreads">Next &gt;&gt;</xsl:variable>
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
	<xsl:variable name="m_ptclicktostartnewconv">Return to the messageboard</xsl:variable>
	<xsl:variable name="m_ptclicktowritereply">Return to the messageboard</xsl:variable>
	<xsl:variable name="m_morepoststitle">
		<xsl:choose>
			<xsl:when test="/H2G2/POSTS/POST-LIST/USER/USERNAME">
				<xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERNAME"/>'s page</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="m_postawaitingmoderation">	
		This posting has been temporarily hidden, because a member of our Moderation Team has referred it to the Hosts for a decision as to whether it contravenes the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
	</xsl:template>
	<xsl:template name="m_postawaitingpremoderation">
		This posting is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a>).
	</xsl:template>
	<xsl:template name="m_postremoved">
		This posting has been hidden during moderation because it broke the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House Rules</a> in some way.
	</xsl:template>
	<xsl:template name="m_postcomplaint">
		This <xsl:value-of select="$m_posting"/> has been temporarily hidden by a member of the Community Team and referred to the Moderation Team for a decision as to whether it contravenes the <a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
	</xsl:template>
</xsl:stylesheet>
