<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:variable name="host">
        <xsl:choose>
            <xsl:when test="$configuration/host/url and not($configuration/host/url = '')"><xsl:value-of select="$configuration/host/url"/></xsl:when>
            <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE != ''">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>http://www.bbc.co.uk</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

  <xsl:variable name="sslhost">
    <xsl:choose>
      <xsl:when test="$configuration/host/sslurl and not($configuration/host/sslurl = '')">
        <xsl:value-of select="$configuration/host/sslurl"/>
      </xsl:when>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sslhost']/VALUE != ''">
        <!-- not implemented -->
        <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_sslhost']/VALUE" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>https://www.bbc.co.uk</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
    
    <xsl:variable name="root">
        <xsl:choose>
            <xsl:when test="/H2G2/FORUMTHREADPOSTS/@HOSTPAGEURL">
                
            </xsl:when>
            <xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/SERVERNAME = 'NARTHUR5'">
						<xsl:choose>
							<xsl:when test="$serverenvironment = 'int'">/dna/int/</xsl:when>
							<xsl:when test="$serverenvironment = 'test'">/dna/test/</xsl:when>
							<xsl:when test="$serverenvironment = 'stable'">/dna/stable/</xsl:when>
							<xsl:otherwise>/dna/</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>/dna/</xsl:otherwise>
				</xsl:choose>

                <xsl:choose>
                    <xsl:when test="/H2G2/SITE/NAME">
                        <xsl:value-of select="/H2G2/SITE/NAME"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="/H2G2/URLSKINNAME">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="/H2G2/URLSKINNAME"/>
                </xsl:if>
                <!--
                -->             
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="root-xml">
        <xsl:choose>
            <xsl:when test="/H2G2/FORUMTHREADPOSTS/@HOSTPAGEURL">
                
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:text>/dna/</xsl:text>
                <!--cater for staging instance-->
                <xsl:if test="/H2G2/SERVERNAME = 'NMSDNA0'">
                    <xsl:text>staging/</xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="/H2G2/SITE/NAME">
                        <xsl:value-of select="/H2G2/SITE/NAME"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="/H2G2/URLSKINNAME">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="/H2G2/URLSKINNAME"/>
                </xsl:if>
                <xsl:text>-xml</xsl:text>
                <!--
                -->             
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="root-base">
        <xsl:choose>
            <xsl:when test="/H2G2/FORUMTHREADPOSTS/@HOSTPAGEURL">
                
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:text>/dna/</xsl:text>
                <!--cater for staging instance-->
                <xsl:if test="/H2G2/SERVERNAME = 'NMSDNA0'">
                    <xsl:text>staging/</xsl:text>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="/H2G2/SITE/NAME">
                        <xsl:value-of select="/H2G2/SITE/NAME"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
	
	<xsl:variable name="root-rss">
		<xsl:value-of select="concat($root-base, '/rss')"/>
	</xsl:variable>
    
    <xsl:variable name="siteClosed">
        <xsl:choose>
            <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'] or /H2G2/VIEWING-USER/USER/STATUS = 2">
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:when test="/H2G2/SITE/SITECLOSED = 1">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:when test="/H2G2/SITE/OPENCLOSETIMES/*">
                <xsl:variable name="dayOfWeek">
                    <xsl:choose>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Sunday'">1</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Monday'">2</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Tuesday'">3</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Wednesday'">4</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Thursday'">5</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Friday'">6</xsl:when>
                        <xsl:when test="/H2G2/DATE/@DAYNAME = 'Saturday'">7</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="now" select="number(concat(format-number(/H2G2/DATE/@HOURS, '00'), format-number(/H2G2/DATE/@MINUTES, '00')))"/>
                <xsl:variable name="open" select="number(concat(format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 0][TIME/@DAYTYPE = $dayOfWeek]/TIME/@HOURS, '00'), format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 0][TIME/@DAYTYPE = $dayOfWeek]/TIME/@MINUTES, '00')))"/>
                <xsl:variable name="closed" select="number(concat(format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 1][TIME/@DAYTYPE = $dayOfWeek]/TIME/@HOURS, '00'), format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 1][TIME/@DAYTYPE = $dayOfWeek]/TIME/@MINUTES, '00')))"/>
                <xsl:choose>
                    <!-- I don't know WHY I have to do this... will figure out later -->
                    <xsl:when test="(string($open) = 'NaN') or (string($closed) = 'NaN')">
                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    <xsl:when test="$open = 0 and $closed = 0">
                        <xsl:value-of select="true()"/>
                    </xsl:when>
                    <xsl:when test="$now &gt; $open and $now &lt; $closed">
                        <xsl:value-of select="false()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="true()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

	<xsl:variable name="aerian-base">/h2g2/</xsl:variable>
	<xsl:variable name="aerian-base-entry">/h2g2/entry/</xsl:variable>
	<xsl:variable name="aerian-base-user">/h2g2/user/</xsl:variable>
	<xsl:variable name="aerian-base-forum">/h2g2/forum/</xsl:variable>
	<xsl:variable name="aerian-base-categories">/h2g2/categories/</xsl:variable>
	<xsl:variable name="blobs-root">http://www.bbc.co.uk/h2g2/blobs/</xsl:variable>
	<xsl:variable name="blob-gif-root">http://www.bbc.co.uk/dna/h2g2/brunel/</xsl:variable>
	<xsl:variable name="smilies-post-root">http://www.bbc.co.uk/dna/h2g2/blobs/smileys/post</xsl:variable>
	<xsl:variable name="smilies-buttons-root">http://www.bbc.co.uk/dna/h2g2/blobs/smileys/buttons</xsl:variable>

</xsl:stylesheet>