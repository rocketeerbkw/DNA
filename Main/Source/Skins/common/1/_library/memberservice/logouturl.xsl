<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            pagination
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
           working with the show, to and from, calculate the querystring
           
           this desperately needs to be split into its component parts correctly:
           
           logic layer 
            - work out the FORUMTHREAD type, its skip, step or from and to values and compute them into
              a collection of useful parameters for the skin.
              
           site layer
            - take params and work into relelvant links etc
             
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="VIEWING-USER" mode="library_memberservice_logouturl">
        <xsl:param name="ptrt" />
        
        <xsl:apply-templates select="/H2G2/SSOSERVICE | /H2G2/CURRENTSITESSOSERVICE" mode="library_sso_logouturl">
            <xsl:with-param name="ptrt" select="$ptrt" /> 
        </xsl:apply-templates>
    </xsl:template>
    
    
    <xsl:template match="VIEWING-USER[/H2G2/SITE/IDENTITYSIGNIN = 1]" mode="library_memberservice_logouturl">
        <xsl:param name="ptrt" />
        
        <xsl:apply-templates select="." mode="library_identity_logouturl">
            <xsl:with-param name="ptrt" select="$ptrt" />            
        </xsl:apply-templates>
    </xsl:template>
    
</xsl:stylesheet>