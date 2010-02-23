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
    
    <xsl:template match="NOTLOGGEDINWELCOME" mode="library_siteconfig_unauthorisedwelcome">
    	<xsl:param name="ptrt" select="''"/>
        <!-- <xsl:text>You are currently signed in</xsl:text> 
    	<xsl:if test="/H2G2/VIEWING-USER/SIGNINNAME and /H2G2/VIEWING-USER/SIGNINNAME/text() != ''">
    		<xsl:text> as </xsl:text><xsl:value-of select="/H2G2/VIEWING-USER/SIGNINNAME"/>
    	</xsl:if>
        <xsl:text> but have not yet completed the registration process. </xsl:text> -->
        <xsl:text>You are a registered user but we need to check some details with you.</xsl:text>
        <xsl:apply-templates select="LINKTOSIGNIN" mode="library_siteconfig_inline_unauthorised">
        	<xsl:with-param name="ptrt" select="$ptrt"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>