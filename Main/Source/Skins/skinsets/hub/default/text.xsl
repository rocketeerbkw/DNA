<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:variable name="sitedisplayname">DNA Hub</xsl:variable>

<xsl:variable name="m_searchtheguide">Search the Knowledge Base</xsl:variable>
<xsl:variable name="m_searchsubject">Search the DNA Hub</xsl:variable>
<xsl:variable name="alt_searchtheguide">Search the Knowledge Base</xsl:variable>
<xsl:template name="m_clickhelpbrowse"></xsl:template>
<xsl:template name="m_registerslug"></xsl:template>
<xsl:variable name="m_nickname">Nickname:&nbsp;</xsl:variable>
<xsl:variable name="m_emailaddr">Email&nbsp;Address:&nbsp;</xsl:variable>
<xsl:variable name="m_skin">Skin:&nbsp;</xsl:variable>
<xsl:variable name="m_usermode">User&nbsp;Mode:&nbsp;</xsl:variable>
<xsl:variable name="m_normal">Normal</xsl:variable>
<xsl:variable name="m_expert">Expert</xsl:variable>
<xsl:variable name="m_password">Password:&nbsp;</xsl:variable>
<xsl:variable name="m_newpassword">New&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_oldpassword">Current&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_confirmpassword">Confirm&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_changepasswordexternal"></xsl:variable>
<xsl:template name="m_welcomebackuser">
You are currently logged in as <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,20)" /><xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 20">..</xsl:if>.</xsl:template>
<xsl:variable name="m_showolder"> No Older</xsl:variable>
<xsl:variable name="m_shownewer">No Newer </xsl:variable>
<xsl:template name="m_registertodiscuss"></xsl:template>
<xsl:variable name="m_memberof"></xsl:variable>


<xsl:template name="m_cantpostnotregistered">
		<P>We're sorry, but you can't post to <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> until you've registered with a DNA site.</P>
		<UL>
			<LI>
				<P>If you already have an account, please <A href="{$sso_nopostsigninlink}">click here to sign in</A>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as <xsl:value-of select="$m_usera"/> <xsl:value-of select="$m_user"/>, please create an account with <A HREF="http://www.bbc.co.uk/dna/h2g2/Register">h2g2</A>. You will be able to use this account to contribute to the Hub.</P>
			</LI>
		</UL>
		<P>Alternatively, <A>
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A>.</P>
</xsl:template>

<xsl:template name="m_complaintpopupseriousnessproviso">
This form is only for serious complaints about specific content on the DNA Hub that breaks the site's <A xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" HREF="{$root}HouseRules" TARGET="_blank">House Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.
<br/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><br/>
For general comments please post to the relevant <xsl:value-of select="$m_thread"/> on the Hub, or to <a xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" target="_blank" href="{$root}Feedback">DNA Feedback</a> for general feedback.
<hr/><br/>
</xsl:template>

<xsl:template name="m_postingcomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_posting"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>'.
</xsl:template>

<xsl:template name="m_articlecomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_article"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>'.
</xsl:template>

</xsl:stylesheet>
