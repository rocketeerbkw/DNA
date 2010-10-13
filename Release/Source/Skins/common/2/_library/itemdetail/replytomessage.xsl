<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Handles "in reply to this message text and link
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail/user.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="POST/@INREPLYTO" mode="library_itemdetail_replytomessage">
		<xsl:variable name="skip">
			<xsl:value-of select="floor(parent::POST/@INREPLYTOINDEX div ancestor::FORUMTHREADPOSTS/@COUNT)*ancestor::FORUMTHREADPOSTS/@COUNT" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="parent::POST/@INREPLYTOINDEX">
				<xsl:text>, in reply to </xsl:text><a href="{concat($root, '/NF', ancestor::FORUMTHREADPOSTS/@FORUMID, '?thread=', ancestor::FORUMTHREADPOSTS/@THREADID, '&amp;skip=', $skip, '#p', .)}"> message <xsl:value-of select="parent::POST/@INREPLYTOINDEX+1" /></a>.
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>, in reply to </xsl:text> <a href="{concat($root, '/NF', ancestor::FORUMTHREADPOSTS/@FORUMID, '?thread=', ancestor::FORUMTHREADPOSTS/@THREADID, '&amp;skip=', $skip, '#p', .)}"> this message</a>.
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
</xsl:stylesheet>