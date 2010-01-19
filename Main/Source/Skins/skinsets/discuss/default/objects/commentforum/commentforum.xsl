<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a full DNA article
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="COMMENTFORUM" mode="object_commentforum">
        <div id="{@UID}">
            <xsl:call-template name="library_listitem_stripe" />
                        
            <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">
                    <xsl:value-of select="TITLE"/>
                    <span class="postcount">(<xsl:value-of select="@FORUMPOSTCOUNT"/>)</span>
                </xsl:with-param>
            </xsl:call-template>
            
            <p>
                <a href="{HOSTPAGEURL}">
                    <xsl:choose>
                        <xsl:when test="string-length(HOSTPAGEURL) > 79">
                            <xsl:value-of select="substring(HOSTPAGEURL, 0, 80)"/>
                            <br />
                            <xsl:value-of select="substring(HOSTPAGEURL, 80)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="HOSTPAGEURL"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </p>
            <p>
                <a class="uid">
                    <xsl:attribute name="href">
                        <xsl:value-of select="'/dna/'"/>
                        <xsl:value-of select="/H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[@ID = current()/SITEID]/NAME"/>
                        <xsl:text>/acs?dnauid=</xsl:text>
                        <xsl:value-of select="@UID"/>
                    </xsl:attribute>
                    
                    <xsl:value-of select="@UID"/>
                </a>
                <a class="uid-xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="'/dna/'"/>
                        <xsl:value-of select="/H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[@ID = current()/SITEID]/NAME"/>
                        <xsl:text>/acs?dnauid=</xsl:text>
                        <xsl:value-of select="@UID"/>
                        <xsl:text>&amp;skin=purexml</xsl:text>
                    </xsl:attribute>
                    
                    <xsl:text>as xml</xsl:text>
                </a>
                <xsl:apply-templates select="CLOSEDATE/DATE" mode="library_date_longformat">
                    <xsl:with-param name="label" select="'Closes '" />
                </xsl:apply-templates>
            </p>
            
            <xsl:apply-templates select="CLOSEDATE" mode="input_closedate_commentforum" />
            <xsl:apply-templates select="MODSTATUS" mode="input_modstatus_commentforum" />
            <xsl:apply-templates select="@CANWRITE" mode="input_canwrite_commentforum" />
        </div>
    </xsl:template>
</xsl:stylesheet>