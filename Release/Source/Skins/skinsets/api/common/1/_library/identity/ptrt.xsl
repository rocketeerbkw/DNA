<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Displays the SSO sign in / sign out typically found on user generated pages. 
		</doc:purpose>
		<doc:context>
			Called on request by skin
		</doc:context>
		<doc:notes>
			
			Make a general site config library stream, make individaul templates for
			LOGGEDINWELCOME, NOTLOGGEDINWELCOME and so on.
			
		</doc:notes>
	</doc:documentation>
	
	
	<xsl:template match="H2G2[@TYPE]" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root)"/>
		</xsl:call-template>
	</xsl:template>
	
	
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTBOX']" mode="library_identity_ptrt">
		<xsl:param name="urlidentification" />
		
		<xsl:variable name="contactdetails">
			<xsl:if test="contains(/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'CollectExtraDetails']/VALUE, 'phone') and $urlidentification = 'registerurl'">
            	<xsl:text>%3Fs_contact=1</xsl:text>
            </xsl:if>		
        </xsl:variable>
        
        <xsl:variable name="anchor">
        	<xsl:choose>
        		<xsl:when test="$urlidentification = 'settingsurl'">
        			<xsl:text>postcomments</xsl:text>
        		</xsl:when>
        		<xsl:otherwise>
        			<xsl:text>comments</xsl:text>
        		</xsl:otherwise>
        	</xsl:choose>
        </xsl:variable>
        
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat(COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL, $contactdetails, '%23', $anchor)"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'ARTICLE']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root, '/A', ARTICLE/H2G2ID, '%3Fs_sync=1')"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'THREADS']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root, '/F', FORUMTHREADS/@FORUMID)"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'MULTIPOSTS']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root, '/F', FORUMTHREADS/@FORUMID, '%3Fthread=', FORUMTHREADPOSTS/@THREADID)"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'USERDETAILS']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root)"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'FRONTPAGE']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root)"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE = 'USER-COMPLAINT'] | H2G2[@TYPE = 'USERCOMPLAINTPAGE']" mode="library_identity_ptrt">
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat($host, $root)"/>
		</xsl:call-template>
		<xsl:text>%2FUserComplaintPage%3FPostId=</xsl:text>
		<xsl:value-of select="USER-COMPLAINT-FORM/POST-ID | USERCOMPLAINT/@POSTID | USERCOMPLAINT/@H2G2ID"/>
    <xsl:choose>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_start']">
        <xsl:value-of select="concat('%26s_start=', number(/H2G2/PARAMS/PARAM[NAME = 's_start']/VALUE) + 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>%26s_start=2</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>