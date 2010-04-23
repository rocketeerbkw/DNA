<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"
    exclude-result-prefixes="doc msxsl">
    
    

    <doc:documentation>
        <doc:properties common="true"/>
        <doc:purpose> Library function for user entered text blocks </doc:purpose>
        <doc:context> Called using: xsl:apply-templates select="TEXT" mode="library_Richtext" </doc:context>
        <doc:notes> Currently matches links, smileys, p's, headers and subheaders. This is like GuideML but is is NO NAMESPACE (for comments validation) </doc:notes>
    </doc:documentation>

    <xsl:template match="TEXT | RICHPOST" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        <xsl:apply-templates select="* | text()" mode="library_Richtext">
            <xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
        </xsl:apply-templates>
    </xsl:template>


</xsl:stylesheet>
