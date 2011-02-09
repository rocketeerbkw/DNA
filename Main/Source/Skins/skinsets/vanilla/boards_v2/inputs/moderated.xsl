<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page. For posts that are moderated in some way.
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
	<xsl:template match="POSTPREMODERATED" mode="input_moderated">
		<div>
			<h2>Moderated user</h2>
			<p class="closed">
				Your post has been placed in a moderation queue, and will be reviewed by a moderator before posting. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
			</p>
			<p class="closed">
				<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$root" /><xsl:text>/NF</xsl:text><xsl:value-of select="/H2G2[@TYPE = 'POSTTOFORUM']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID" />
					<xsl:if test="@THREAD"><xsl:text>?thread=</xsl:text><xsl:value-of select="@THREAD" /></xsl:if>
				</xsl:attribute>
					Back to the discussion
				</a>
			</p>
		</div>
	</xsl:template>
	
	<xsl:template match="POSTTHREADUNREG[@RESTRICTED = 1]" mode="input_moderated">
		<div>
			<h2>Moderated user</h2>
			<p class="closed">
				Unfortunately you are currently restricted from posting to this forum. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
			</p>
			<p class="closed">
				<a href="{$root}/NF{/H2G2[@TYPE = 'POSTTOFORUM']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
					Back to the discussion
				</a>
			</p>
		</div>
	</xsl:template>
    
</xsl:stylesheet>