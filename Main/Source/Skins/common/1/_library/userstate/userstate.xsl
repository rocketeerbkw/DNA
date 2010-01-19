<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Provides simple mechanism to display content depending whether a user is logged in or not. 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
            'unauthorised' means a user hasn't accepted the policy for this site (e.g House Rules) however
            the memberservice (sso/id) has authenticated them as a valid user
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_userstate">
        <xsl:param name="loggedin"/>
        <xsl:param name="unauthorised"/>
        <xsl:param name="loggedout"/>
        
        <xsl:choose>
            <xsl:when test="/H2G2/VIEWING-USER/USER[USERNAME]/USERID">
                <xsl:copy-of select="$loggedin"/>
            </xsl:when>
            <xsl:when test="/H2G2/VIEWING-USER/SIGNINNAME">
                <xsl:copy-of select="$unauthorised"/>
            </xsl:when>
            <xsl:when test="/H2G2/VIEWING-USER/USER[not(USERNAME)]">
              <xsl:copy-of select="$unauthorised"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$loggedout"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>