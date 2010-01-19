<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Output an ssi statement 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            todo: Expand library/ssi to later provide the ability to double escape ssi vars
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_ssi_escaped">
        <xsl:param name="statement" />
        
        <xsl:comment>#set var="statement.start" value="&lt;!-"</xsl:comment>
        <xsl:comment>#set var="statement.end" value="-&gt;"</xsl:comment>
        <xsl:comment>#set var="statement.hyphen" value="-"</xsl:comment>
        
        <xsl:comment>#echo encoding="none" var="statement.start"</xsl:comment>
        <xsl:comment>#echo encoding="none" var="statement.hyphen"</xsl:comment>
        <xsl:copy-of select="$statement" />
        <xsl:comment>#echo encoding="none" var="statement.hyphen"</xsl:comment>
        <xsl:comment>#echo encoding="none" var="statement.end"</xsl:comment>
    </xsl:template>
</xsl:stylesheet>