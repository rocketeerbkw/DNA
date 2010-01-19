<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Passes DATECREATED nodes to library_date_longformat
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            Checks to see if it can find a DATEPOSTED or DATECREATED node. If it can, tests whether
            the date is before the LASTUPDATED date. The last updated detail is then
            only shown when it is greater than the DATEPOSTED / DATECREATED date.
            
            If a DATEPOSTED or DATECREATED node cannot be found, then the LASTUPDATED node is
            transformed as normal.
            
            The intended result is that where possible, the Last Update value is only
            shown when it is relevant.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="LASTUPDATED" mode="library_itemdetail">
        
        <xsl:variable name="itemdetail_comparenode" select="preceding-sibling::DATEPOSTED | preceding-sibling::DATECREATED"></xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$itemdetail_comparenode">
                
                <!-- add an extra secod to get around article dates bug  + 00000000000001-->
                <xsl:if test="DATE/@SORT > ($itemdetail_comparenode/DATE/@SORT) ">
                    
                    <xsl:apply-templates select="DATE" mode="library_date_longformat">
                        <xsl:with-param name="label"> Last updated </xsl:with-param>
                        <xsl:with-param name="additional-classnames" select="'updated'" />
                    </xsl:apply-templates>
                    
                </xsl:if>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="DATE" mode="library_date_longformat">
                    <xsl:with-param name="longformat_label"> Last updated </xsl:with-param>
                </xsl:apply-templates>
                
                
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
</xsl:stylesheet>