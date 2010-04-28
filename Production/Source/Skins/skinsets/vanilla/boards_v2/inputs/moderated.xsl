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
			<h3>Moderated user</h3>
			<p>
				Your post has been placed in a moderation queue, and will be reviewed by a moderator before posting. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
			</p>
			<p>
				<a href="{$root}/NF{/H2G2[@TYPE = 'ADDTHREAD']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
					Back to the discussion
				</a>
			</p>
		</div>
	</xsl:template>
	
	<xsl:template match="POSTTHREADUNREG[@RESTRICTED = 1]" mode="input_moderated">
		<div>
			<h3>Moderated user</h3>
			<p>
				Unfortunately you are currently restricted from posting to this forum. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
			</p>
			<p>
				<a href="{$root}/NF{/H2G2[@TYPE = 'ADDTHREAD']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
					Back to the discussion
				</a>
			</p>
		</div>
	</xsl:template>
    
</xsl:stylesheet>