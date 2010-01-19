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
			<xsl:choose>
				<xsl:when test="@AUTOSINBIN = 1">
					<p>
						All posts by new messageboard members are pre-moderated.  This means that your first few postings will not appear on the messageboard immediately, as they need to be checked by a moderator first.   
					</p>
					<p>
						After you have used the BBC messageboards for a while, you will become a trusted user and your posts will appear on the board as soon as you post them.
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p>
						Your message will be checked before it appears on the board to make sure it doesn't break our  <a href="{$houserulespopupurl}" class="popup">House Rules.</a><br/>
					</p>
				</xsl:otherwise>
			</xsl:choose>
			<p>
				The BBC receives thousands of messages every day so please be patient.
			</p>
			<p>
				<a href="{$root}/F{/H2G2[@TYPE = 'ADDTHREAD']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
					Back to the <xsl:value-of select="$discussion"/>
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
				<a href="{$root}/F{/H2G2[@TYPE = 'ADDTHREAD']/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
					Back to the <xsl:value-of select="$discussion"/>
				</a>
			</p>
		</div>
	</xsl:template>
    
</xsl:stylesheet>