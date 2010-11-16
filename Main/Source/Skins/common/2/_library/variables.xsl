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
    
    <xsl:variable name="root">
        <xsl:choose>
            <xsl:when test="/H2G2/FORUMTHREADPOSTS/@HOSTPAGEURL">
                
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:text>/dna/</xsl:text>
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
		
	<xsl:variable name="cbbc">
		<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
			<xsl:text>&amp;cbbc=true</xsl:text>
		</xsl:if>	
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
                <xsl:variable name="adjustedclosed">
                  <xsl:choose>
                    <xsl:when test="$closed = 0">
                      <xsl:value-of select="2400"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$closed"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                  <!-- I don't know WHY I have to do this... will figure out later -->
                  <xsl:when test="(string($open) = 'NaN') or (string($adjustedclosed) = 'NaN')">
                    <xsl:value-of select="false()"/>
                  </xsl:when>
                  <xsl:when test="$open = 0 and $adjustedclosed = 0">
                    <xsl:value-of select="true()"/>
                  </xsl:when>
                  <xsl:when test="$now &gt; $open and $now &lt; $adjustedclosed">
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
    
    <xsl:variable name="blq_header_siteoption">
	    <xsl:apply-templates select="/H2G2/SITE" mode="library_siteoptions_get">
	    	<xsl:with-param name="name" select="'CustomBarlesquePath'"/>
	    </xsl:apply-templates>
    </xsl:variable>
    
	<xsl:variable name="autogennames">
	    <xsl:apply-templates select="/H2G2/SITE" mode="library_siteoptions_get">
	        <xsl:with-param name="name" select="'AutoGeneratedNames'"/>
	    </xsl:apply-templates>	
	</xsl:variable>  
	
	<xsl:variable name="autogenname_required">
		<xsl:value-of select="boolean(/H2G2/SITE/SITEOPTIONS/SITEOPTION[@GLOBAL='0'][NAME = 'AutoGeneratedNames'] and (/H2G2/VIEWING-USER/USER/SITESUFFIX ='' or not(/H2G2/VIEWING-USER/USER/SITESUFFIX)))" />
	</xsl:variable>
	
	<xsl:variable name="autogennamesurl">
		<xsl:if test="$autogennames != ''">
			<xsl:value-of select="concat($autogennames, '%3Fonwardto=')" />
		</xsl:if>
	</xsl:variable>
    
    <xsl:variable name="imagewidth"><xsl:text>223</xsl:text></xsl:variable>
    <xsl:variable name="imageheight"><xsl:text>125</xsl:text></xsl:variable>
    
    <xsl:variable name="signin-discussion-text">to take part in a discussion.</xsl:variable>
    
    <xsl:variable name="moderationinfourl">http://www.bbc.co.uk/messageboards/popups/checking_messages.shtml#B</xsl:variable>
    
    <xsl:variable name="faqsurl">
    	<xsl:choose>
    		<xsl:when test="/H2G2/SITE/IDENTITYPOLICY = 'http://identity/policies/dna/kids'">
    			http://www.bbc.co.uk/cbbc/mb/help.shtml
    		</xsl:when>
			<xsl:otherwise>
				<!-- Default to adult -->
				<xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html</xsl:text>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
    
    <xsl:variable name="houserulesurl">
    	<xsl:choose>
    		<xsl:when test="/H2G2/SITE/IDENTITYPOLICY = 'http://identity/policies/dna/kids'">
    			http://www.bbc.co.uk/cbbc/mb/rules.shtml
    		</xsl:when>
			<xsl:when test="/H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/over13'">
				<xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_teens.html</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/schools'">
				<xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_schools.html</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- Default to adult -->
				<xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>
    
    
    <!-- DASHBOARD variables -->
    <xsl:variable name="dashboardtype">
    	<xsl:choose>
    		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 1">blog</xsl:when>
    		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 2">messageboard</xsl:when>
    		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 3">community</xsl:when>
    		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 4">story</xsl:when>
    		<xsl:otherwise>all</xsl:otherwise>
    	</xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="dashboardtypename">
    	<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/NAME" />
    </xsl:variable>
    
    <xsl:variable name="dashboardposttype">
    	<xsl:choose>
    		<xsl:when test="$dashboardtype = 'blog' or $dashboardtype = 'story'">comment</xsl:when>
    		<xsl:when test="$dashboardtype = 'messageboard' or $dashboardtype = 'community'">post</xsl:when>
    		<xsl:otherwise>post</xsl:otherwise>
    	</xsl:choose>    	
    </xsl:variable>
    
    <xsl:variable name="dashboarddays">
    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_days']/VALUE">
    		<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_days']/VALUE" />
    	</xsl:if>  	
    </xsl:variable>    
    
    <xsl:variable name="dashboardtypeid">
    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE">
    		<xsl:text>&amp;s_type=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE" />
    	</xsl:if>
    </xsl:variable>      
    
	<xsl:variable name="dashboardsiteid">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE">&amp;s_siteid=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE" /></xsl:if>
	</xsl:variable>    
    
    <xsl:variable name="dashboardsiteuser">
    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_userid']/VALUE">
    		<xsl:text>&amp;s_userid=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_userid']/VALUE" />
    	</xsl:if>
    </xsl:variable>
    
</xsl:stylesheet>