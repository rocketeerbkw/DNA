<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Library function for skin headers (e.g. h1, h2, h3...etc). Allows skins to be
            created that respond to setting a different base level. For instance, clients
            of the skin may wish all first level header elements to start at h2, instead of h1.
        </doc:purpose>
        <doc:context>
            Called using:
                        
            xsl:call-template name="library_header_h1"
                xsl:with-param name="text" select="'My Article'"
            xsl:call-template
            
            (depending on heading level required e.g "library_header_h4")
        </doc:context>
        <doc:notes>
            As mentioned above, this is a solution to deciding on the relevant heading level
            when a skin is likely to be incorporated into many other different designs and pages.
            
            Append the url with:
            
            ?s_baseHeadingLevel=[1..6]
            
            to set, e.g:
            
            s_baseHeadingLevel=3
            
            This will cause library_header_h1 to output an h3 element, library_header_h2
            to output h4 and so on.
            
            The default baseHeadingLevel is 1.
            
            All library_header templates accept XML in the 'text' parameter.
             
            Important: When a library_header attempts to output a header element great than 6,
            such as "h7", it defaults to the highest valid HTML level; h6. Similarly for
            negative numbers.
            
            Also allows CSS class name(s) to be passed as a string and added to the header
            element.
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:variable name="library_baseHeadingLevel">
        <xsl:choose>
            <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_baseHeadingLevel']/VALUE != ''">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_baseHeadingLevel']/VALUE"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    
    <xsl:template name="library_header">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:param name="headingLevel">1</xsl:param>
        
        <xsl:variable name="calculated" select="($library_baseHeadingLevel + ($headingLevel - 1))" />
        
        <xsl:choose>
            <xsl:when test="$calculated &lt; 1">
                <h1>
                    <xsl:copy-of select="$text"/>
                </h1>
            </xsl:when>
            <xsl:when test="$calculated > 5">
                <h6>
                    <xsl:copy-of select="$text"/>
                </h6>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{concat('h', $calculated)}">
                    
                    <xsl:if test="$class">
                        <xsl:attribute name="class">
                            <xsl:value-of select="$class"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <xsl:copy-of select="$text"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="library_header_h1">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="1" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="library_header_h2">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="2" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="library_header_h3">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="3" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="library_header_h4">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="4" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="library_header_h5">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="5" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="library_header_h6">
        <xsl:param name="text"/>
        <xsl:param name="class"/>
        <xsl:call-template name="library_header">
            <xsl:with-param name="text" select="$text" />
            <xsl:with-param name="headingLevel" select="6" />
            <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>