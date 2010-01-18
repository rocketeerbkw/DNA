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
		<!--<xsl:value-of select="COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL"/>-->
		<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="concat(COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL, '%3Fs_sync=1%23comments')"/>
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
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_step']">
			<xsl:value-of select="concat('&amp;s_step=', number(/H2G2/PARAMS/PARAM[NAME = 's_step']/VALUE) + 1)"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>