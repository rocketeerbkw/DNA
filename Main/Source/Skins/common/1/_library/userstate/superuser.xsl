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
            
        </doc:notes>
    </doc:documentation>
    
    <!-- a call-template inteface that returns the viewing users superuser status -->
    <xsl:template name="library_userstate_superuser">
        <xsl:param name="loggedin"/>
        <xsl:param name="loggedout"/>
        
        <xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_userstate_superuser">
            <xsl:with-param name="true" select="$loggedin" />
            <xsl:with-param name="false" select="$loggedout" />
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- test whether user status = 2 (superuser) -->
    <xsl:template match="USER" mode="library_userstate_superuser">
        <xsl:param name="true"/>
        <xsl:param name="false"/>
        
        <xsl:choose>
            <xsl:when test="STATUS = 2">
                <xsl:copy-of select="$true"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$false"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>