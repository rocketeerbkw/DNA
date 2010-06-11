<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for the users More Comments page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Provides the comment profile solution
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="page">  
    	<xsl:apply-templates select="MORECOMMENTS" mode="page"/>
    </xsl:template>
	
	<xsl:template match="MORECOMMENTS" mode="page">
		<xsl:variable name="loggedInUser" select="/H2G2/VIEWING-USER/USER/USERID"/>
		<xsl:call-template name="library_header_h2">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="COMMENTS-LIST/COMMENTS">
						<span class="dna-invisible">
							<xsl:text>Profile for </xsl:text>
						</span>
						<xsl:value-of select="COMMENTS-LIST/USER/USERNAME"/>
						<xsl:text> (U</xsl:text><xsl:value-of select="COMMENTS-LIST/USER/USERID"/><xsl:text>) </xsl:text>
						<span>
							<a href="{$root}/MC{COMMENTS-LIST/USER}">permalink</a>
						</span>
						<!--<xsl:if test="COMMENTS-LIST/USER/USERID = $loggedInUser">
							<a href="{$root-rss}/MC{COMMENTS-LIST/USER}" class="rsslink" title="View as RSS feed">
								<span></span>
							</a>
						</xsl:if>
						<span class="clear"> </span>-->
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Comments</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>   
		
		<p>
			<xsl:if test="COMMENTS-LIST/COMMENTS">
				<xsl:text>Listed below are comments made by </xsl:text>
				<xsl:choose>
					<xsl:when test="COMMENTS-LIST/USER/USERID = $loggedInUser">
						<strong> you</strong>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="COMMENTS-LIST/USER/USERNAME"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> between </xsl:text>
				<xsl:apply-templates select="COMMENTS-LIST/COMMENTS/COMMENT[position() = last()]/DATEPOSTED/DATE" mode="library_date_longformat"/>
				<xsl:text> and </xsl:text>
				<xsl:apply-templates select="COMMENTS-LIST/COMMENTS/COMMENT[position() = 1]/DATEPOSTED/DATE" mode="library_date_longformat"/>
				
				<xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/MORECOMMENTSLABEL" mode="library_siteconfig_morecommentslabel" />
			</xsl:if>
			
		</p>
		
		<p>
			<xsl:text>You can also view a </xsl:text>
			<a href="{$root}/MP{(COMMENTS-LIST/USER | @USERID)[1]}">
				<xsl:text>list of </xsl:text>
				<xsl:choose>
					<xsl:when test="COMMENTS-LIST/USER">
						<xsl:value-of select="COMMENTS-LIST/USER/USERNAME"/>
					</xsl:when>
					<xsl:otherwise>this user</xsl:otherwise>
				</xsl:choose>
				<xsl:text>'s posts</xsl:text>
			</a>
			<xsl:text>.</xsl:text>
		</p>
		
		<xsl:call-template name="library_userstate_editor">
			<xsl:with-param name="loggedin">
				<p class="dna-boards-moderation">
					<xsl:apply-templates select="(COMMENTS-LIST/USER | @USERID)[1]" mode="moderation_cta_moderateuser">
						<xsl:with-param name="label">Moderate this user</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="(COMMENTS-LIST/USER | @USERID)[1]" mode="moderation_cta_inspectuser">
						<xsl:with-param name="label">Inspect this user</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="(COMMENTS-LIST/USER | @USERID)[1]" mode="moderation_cta_viewalluserposts">
						<xsl:with-param name="label">View all comments for this user</xsl:with-param>
					</xsl:apply-templates>
				</p>
			</xsl:with-param>
		</xsl:call-template>
		
		<xsl:apply-templates select="COMMENTS-LIST" mode="library_pagination_comments-list" />
		
		<xsl:apply-templates select="COMMENTS-LIST" mode="object_comments-list" />
		
		<xsl:apply-templates select="COMMENTS-LIST" mode="library_pagination_comments-list" />
		
	</xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="breadcrumbs">
      <li>
          <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
      </li>
      <li class="current">
          <a href="{$root}/MP{MORECOMMENTS/@USERID}">
              <xsl:text>Profile for </xsl:text>
              <xsl:choose>
                <xsl:when test="MORECOMMENTS/COMMENTS-LIST/USER/USERNAME"><xsl:value-of select="MORECOMMENTS/COMMENTS-LIST/USER/USERNAME"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat('U', MORECOMMENTS/@USERID)"/></xsl:otherwise>
              </xsl:choose>
          </a>
      </li>
    </xsl:template>
    

</xsl:stylesheet>