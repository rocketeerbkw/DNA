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
    
    <!-- a call-template inteface that returns the viewing users editor status -->
    <xsl:template name="library_userstate_editor">
        <xsl:param name="loggedin"/>
        <xsl:param name="loggedout"/>
        
        <xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_userstate_editor">
            <xsl:with-param name="true" select="$loggedin" />
            <xsl:with-param name="false" select="$loggedout" />
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- test whether super user or editor group is present, or status = 2 (superuser, who is also an editor) -->
    <xsl:template match="USER" mode="library_userstate_editor">
        <xsl:param name="true"/>
        <xsl:param name="false"/>
        
        <xsl:choose>
            <xsl:when test="GROUPS/EDITOR or GROUPS/GROUP[NAME='EDITOR'] or STATUS = 2">
                <xsl:copy-of select="$true"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$false"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>