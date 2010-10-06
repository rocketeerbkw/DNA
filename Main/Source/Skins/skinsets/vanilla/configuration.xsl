<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Provide site specific configuration details for xsl
        </doc:purpose>
        <doc:context>
            First included in required/required.xsl
        </doc:context>
        <doc:notes>
            Simply stored as xml. Did consider using a proper xml file and
            calling it via document() however memory overhead is unreliable
            / undocumented especially across large scale deployments.
            
            Access at runtime by using $configuration/
        </doc:notes>
    </doc:documentation>
    
    
   
    <xsl:variable name="skin">
        <configuration>
            <general>
                <siteName>Vanilla</siteName>
                <skinAuthor>Richard Hodgson</skinAuthor>
                <titleSeperator> - </titleSeperator>
            </general>
            <assetPaths>
                <css>/_assets/css/</css>
                <images>/_assets/img/</images>
                <xsl:choose>
                	<xsl:when test="/H2G2/SITECONFIG/V2_BOARDS/EMOTICON_LOCATION != ''"><smileys><xsl:value-of select="/H2G2/SITECONFIG/V2_BOARDS/EMOTICON_LOCATION" /></smileys></xsl:when>
                	<xsl:otherwise><smileys>http://www.bbc.co.uk/dnaimages/boards/images/emoticons/f_</smileys></xsl:otherwise>
                </xsl:choose>
                <javascript>/_assets/js/</javascript>
            </assetPaths>
            <xsl:copy-of select="$globalconfiguration"/>
        </configuration>
    </xsl:variable>
    
</xsl:stylesheet>