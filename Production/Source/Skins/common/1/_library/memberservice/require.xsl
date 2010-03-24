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
           
           The ptrt can be overridden with param 'ptrt'
           
        </doc:notes>
    </doc:documentation>
    
    <!-- named template so correct context is always kept -->
    <xsl:template name="library_memberservice_require">
        <xsl:param name="ptrt">
            <xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
        </xsl:param>
        
        <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_require" >
            <xsl:with-param name="ptrt" select="$ptrt" />
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- user needs to login-->
    <xsl:template match="VIEWING-USER" mode="library_memberservice_require" >
        <xsl:param name="ptrt"/>
        <xsl:attribute name="href">
            <xsl:apply-templates select="." mode="library_memberservice_loginurl">
                <xsl:with-param name="ptrt" select="$ptrt" />
            </xsl:apply-templates>
        </xsl:attribute>
    </xsl:template>
    
    <!-- user needs to complete policy-->
    <xsl:template match="VIEWING-USER[SIGNINNAME] | VIEWING-USER[USER[not(USERNAME)]]" mode="library_memberservice_require" >
        <xsl:param name="ptrt"/>
        <xsl:attribute name="href">
            <xsl:apply-templates select="." mode="library_memberservice_policyurl">
                <xsl:with-param name="ptrt" select="$ptrt" />
            </xsl:apply-templates>
        </xsl:attribute>
    </xsl:template>
    
    <!-- don't do anything, user is logged in-->
    <xsl:template match="VIEWING-USER[USER[USERNAME]]" mode="library_memberservice_require">
        
    </xsl:template>
    
</xsl:stylesheet>