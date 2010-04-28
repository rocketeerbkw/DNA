<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Generates a username in an anchor pointing to their profile page
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER" mode="object_user_linked">
        
        <xsl:choose>
        	<xsl:when test="GROUPS/EDITOR or GROUPS/GROUP/NAME = 'EDITOR' or STATUS = 2">
        		<a href="MP{USERID}" class="user linked editor" title="This user has Editor status">
        			<xsl:value-of select="USERNAME"/>
        			<span class="userid">
        				<xsl:text> (U</xsl:text>
        				<xsl:value-of select="USERID"/>
        				<xsl:text>)</xsl:text>
        			</span></a>
        	</xsl:when>
        	<xsl:when test="GROUPS/GROUP[NAME = 'NOTABLES']">
        		<a href="MP{USERID}" class="user linked notable" title="This user has Notable status">
        			<xsl:value-of select="USERNAME"/>
        			<span class="userid">
        				<xsl:text> (U</xsl:text>
        				<xsl:value-of select="USERID"/>
        				<xsl:text>)</xsl:text>
        			</span></a>
        	</xsl:when>
        	<xsl:otherwise>
        		<a href="MP{USERID}" class="user linked">
		           <xsl:value-of select="USERNAME"/>
        			<span class="userid">
        				<xsl:text> (U</xsl:text>
	        			<xsl:value-of select="USERID"/>
	        			<xsl:text>)</xsl:text>
        			</span></a>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>