<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays the a link allowing users to accept the House Rules of a service. 
        </doc:purpose>
        <doc:context>
            Called by library_memberservice_policyurl
        </doc:context>
        <doc:notes>
            
            
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="SSOSERVICE | CURRENTSITESSOSERVICE" mode="library_sso_policyurl">
        <xsl:param name="ptrt" >
            <xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
        </xsl:param>
        
        <xsl:value-of select="$configuration/sso/url"/>
        <xsl:text>?c=login&amp;service=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&amp;ptrt=</xsl:text>
        <xsl:value-of select="$ptrt"/>
    </xsl:template>
    
</xsl:stylesheet>