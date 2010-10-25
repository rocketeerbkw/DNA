<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Logic layer for moderation status.
        </doc:purpose>
        <doc:context>
            Called when wanting to make an output based on moderation status
        </doc:context>
        <doc:notes>
            The moderation status can mean different things in different contexts. For instance, status
            number 1 associated with USER may mean something else from POST.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="MODERATIONSTATUS" mode="moderation_cta_moderationstatus">
     		<form method="get" action="{$root}/F{@ID}">
          <input type="hidden" name="cmd" value="UpdateForumModerationStatus"/>

          <xsl:apply-templates select="." mode="radiobuttons">
            <xsl:with-param name="title">Forum moderation status:</xsl:with-param>
          </xsl:apply-templates>

          <input type="submit" name="UpdateForumModerationStatus" value="Update"/>
        </form>
    </xsl:template>
    
    <xsl:template match="MODERATIONSTATUS" mode="radiobuttons">
		<xsl:param name="title"/>
		<p class="dna-boards-moderation">
		  <xsl:value-of select="$title"/>
		</p>
			<div>
			  <input type="radio" name="status" value="0">
          <xsl:if test=". = 0">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:text> Undefined </xsl:text>
        <input type="radio" name="status" value="1">
          <xsl:if test=". = 1">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:text> Unmoderated </xsl:text>
        <input type="radio" name="status" value="2">
						<xsl:if test=". = 2">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<xsl:text> Postmoderated </xsl:text>
					<input type="radio" name="status" value="3">
						<xsl:if test=". = 3">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<xsl:text> Premoderated </xsl:text>
			</div>
	</xsl:template>
    
</xsl:stylesheet>