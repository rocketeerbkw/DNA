<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Adds a stripe (odd / even) css class to 
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            Where possible, the odd/even expression should work from the sort attributes
            passed in the DNA XML.
            
            e.g. ARTICLEMEMBER SORTORDER="12"
            
            Problems:
            
            Because in a RECENT-POSTLIST the element this is used on is POST/THREAD then it
            doesn't get the correct position using the fallback trick.
            
            Could be remedied with ancestor-or-self?
             - works and not sure how. gosh, xpath is clever
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_listitem_stripe">
        <xsl:param name="additional-classnames" select="''" />
        
        <xsl:choose>
            <xsl:when test="@POSTID and @messingabout">
                <!-- DNA has passed us a usable sort number (i.e primary key) -->
                ###<xsl:value-of select="count(preceding::POST)"/>###
                <xsl:if test="10 mod 2 != 0">
                    
                    <xsl:attribute name="class">
                        
                        <xsl:if test="$additional-classnames != 0">
                            <xsl:value-of select="$additional-classnames"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        
                        <xsl:text>test-even</xsl:text>
                        
                    </xsl:attribute>
                    
                </xsl:if> 
                
            </xsl:when>
            <xsl:when test="@SORTORDER">
                <!-- DNA has passed us a usable sort number (i.e primary key) -->
                
                    
                    <xsl:attribute name="class">
                        
                        <xsl:if test="$additional-classnames != 0">
                            <xsl:value-of select="$additional-classnames"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        
                        <xsl:if test="@SORTORDER mod 2 != 0">
                            <xsl:text>stripe2</xsl:text>
                        </xsl:if> 
                        
                    </xsl:attribute>
                    
            </xsl:when>
            <xsl:when test="@INDEX">
                <!-- DNA has passed us a usable sort number (i.e primary key) -->
                
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="@INDEX mod 2 != 0">
                                <xsl:if test="$additional-classnames != 0">
                                    <xsl:value-of select="$additional-classnames"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:text>stripe</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$additional-classnames"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                
            </xsl:when>
            <xsl:otherwise>
                
                <!-- No sort attribute, use the position trick -->
                    
                    <xsl:attribute name="class">

                        <xsl:if test="$additional-classnames != 0">
                            <xsl:value-of select="$additional-classnames"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        
                        <xsl:if test="(count(ancestor-or-self::*/preceding-sibling::*)) mod 2 != 0">
                            <xsl:text>stripe</xsl:text>
                        </xsl:if>
                        
                    </xsl:attribute>
                    
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>