<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="doc msxsl">
    
    <doc:documentation>
        <doc:purpose>
            Generates a json block 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
            e.g call using:
            <![CDATA[
            
            <xsl:call-template name="library_json">
                <xsl:with-param name="data">
                    <targetForm>myForm</targetForm>
                    <timeBetweenComments>8</timeBetweenComments>
                    <viewingUser><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></viewingUser>
                </xsl:with-param>
            </xsl:call-template>
            
            ]]>
            
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_json">
        <xsl:param name="data" />
        
        <xsl:param name="nodeset" />
        
        <xsl:variable name="prepare">
            <json><xsl:copy-of select="$data"/></json>
        </xsl:variable>
        
        <xsl:choose>
            
            <xsl:when test="$data">
                <xsl:call-template name="library_json">
                    <xsl:with-param name="nodeset" select="msxsl:node-set($prepare)"/>
                </xsl:call-template>
            </xsl:when>
            
            <!--when we've been passed a node set-->
            <xsl:when test="$nodeset">
                <xsl:apply-templates select="$nodeset" mode="library_json"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="json" mode="library_json">
        <xsl:text>{</xsl:text>
        <xsl:apply-templates select="*" mode="library_json"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="json/child::*" mode="library_json">
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>: '</xsl:text>
        <xsl:call-template name="library_string_escapeapostrophe">
            <xsl:with-param name="str" select="."/>
        </xsl:call-template>
        <xsl:text>'</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>