<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays the SSO sign in / sign out typically found on user generated pages. 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
            Make a general site config library stream, make individaul templates for
            LOGGEDINWELCOME, NOTLOGGEDINWELCOME and so on.
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="SSOSERVICE | CURRENTSITESSOSERVICE" mode="library_sso_registerurl">
        <xsl:param name="ptrt" >
            <xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
        </xsl:param>
        
        <xsl:value-of select="$configuration/sso/url"/>
        <xsl:text>?c=register&amp;service=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&amp;ptrt=</xsl:text>
        <xsl:value-of select="$ptrt"/>
    </xsl:template>
    
</xsl:stylesheet>