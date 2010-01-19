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
                <siteName>Boards</siteName>
                <skinAuthor>Richard Hodgson, Laura Porter</skinAuthor>
                <titleSeperator> - </titleSeperator>
            </general>
            <assetPaths>
                <css>/_assets/css/</css>
                <images>/_assets/img/</images>
                <smileys>http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/f_</smileys>
                <javascript>/_assets/js/</javascript>
            </assetPaths>
            <xsl:copy-of select="$globalconfiguration"/>
        </configuration>
    </xsl:variable>
    
</xsl:stylesheet>