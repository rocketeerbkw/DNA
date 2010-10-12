<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Library function for user and date information
        </doc:purpose>
        <doc:context>
            Called using:
            xsl:apply-templates select="POST" mode="library_itemdetail"
        </doc:context>
        <doc:notes>
            Currently matches POST, ARTICLEINFO
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="ARTICLEINFO" mode="library_itemdetail" >
        
        <div class="itemdetail">
            <xsl:apply-templates select="USER | PAGEAUTHOR/EDITOR/USER" mode="library_itemdetail"/>
            <xsl:apply-templates select="DATEPOSTED | LASTUPDATED | DATECREATED | LASTUPDATED" mode="library_itemdetail"/>
            <xsl:apply-templates select="@INDEX" mode="library_itemdetail"/>
        </div>
        
    </xsl:template>
	
	<xsl:template match="POST" mode="library_itemdetail" >
		
		<div class="itemdetail">
			<xsl:apply-templates select="USER | PAGEAUTHOR/EDITOR/USER" mode="library_itemdetail"/>
			<xsl:apply-templates select="DATEPOSTED | DATECREATED" mode="library_itemdetail"/>
			<xsl:apply-templates select="@INDEX" mode="library_itemdetail"/>
		</div>
		
	</xsl:template>
    
</xsl:stylesheet>