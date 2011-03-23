<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'SYSTEMMESSAGEMAILBOX']" mode="page">
		<h2>Moderation Notifications</h2>
		
		<xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
		
		<xsl:if test="VIEWING-USER/USER">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'UseSystemMessages']/VALUE != '1'">
					<p>Moderation Notifications are not enabled for this site.</p>
				</xsl:when>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'mbcbbc'">
					<p>Your Messages from the Mods are listed below.</p>
				</xsl:when>
				<xsl:when test="not(SYSTEMMESSAGEMAILBOX/MESSAGE)">
					<p>You do not have any Moderation Notifications.</p>
				</xsl:when>
				<xsl:otherwise>
					<p>Your Moderation Notifications are listed below.</p>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:if>
		
		<xsl:apply-templates select="SYSTEMMESSAGEMAILBOX" mode="library_pagination_systemmessages" />
		
		<ul class="collections forumthreadposts">
			<xsl:apply-templates select="SYSTEMMESSAGEMAILBOX/MESSAGE" mode="object_smm-message"/>
		</ul>
		
		<xsl:apply-templates select="SYSTEMMESSAGEMAILBOX " mode="library_pagination_systemmessages" />
	
    </xsl:template>
    
</xsl:stylesheet>
    