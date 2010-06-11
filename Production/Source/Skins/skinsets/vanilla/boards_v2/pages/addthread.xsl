<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'ADDTHREAD']" mode="page">
        <xsl:variable name="idptrt" select="concat('/AddThread?inreplyto=', POSTTHREADUNREG/@POSTID)" />
        
        <xsl:choose>
	        <xsl:when test="POSTTHREADFORM">
	    		<xsl:apply-templates select="POSTTHREADFORM" mode="input_postthreadform" />
	    		<xsl:apply-templates select="POSTPREMODERATED" mode="input_moderated"/>
	    		<xsl:apply-templates select="POSTTHREADUNREG" mode="input_moderated"/>
	        </xsl:when>
	        <xsl:otherwise>
				<xsl:call-template name="library_header_h2">
					<xsl:with-param name="text">
						<xsl:text>Sorry...</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="not(/H2G2/VIEWING-USER/USER)">
						<p class="signin">You need to be 
						<a>
						<xsl:attribute name="href">
				            <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_loginurl">
				                <xsl:with-param name="ptrt" select="$idptrt" />
				            </xsl:apply-templates>	
				    	</xsl:attribute>
						signed in</a> to submit a reply.</p>
					</xsl:when>
				</xsl:choose>	        	
	        </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ADDTHREAD']" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li>
            <a href="{$root}/NF{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
                <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />
            </a>
        </li>
        <li class="current">
            <a href="{$root}/AddThread?forum={FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}&amp;article={FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" class="startanewdiscussion">
                <xsl:text>Reply to a message</xsl:text>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ADDTHREAD'][POSTTHREADFORM/@INREPLYTO = 0]" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li>
            <a href="{$root}/NF{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
                <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />
            </a>
        </li>
        <li class="current">
            <a href="{$root}/AddThread?forum={FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}&amp;article={FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" class="startanewdiscussion">
                <xsl:text>Start new discussion</xsl:text>
            </a>
        </li>
    </xsl:template>

</xsl:stylesheet>