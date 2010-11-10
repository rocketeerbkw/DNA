<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_admin">
	
		<xsl:variable name="dashboardmodstatus">
			<xsl:text>This </xsl:text><xsl:value-of select="$dashboardtype" /><xsl:text> is </xsl:text>
			<xsl:choose>
				<xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/MODERATIONSTATUS = 0"> 
					<xsl:text>reactively moderated</xsl:text>
				</xsl:when>
				<xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/MODERATIONSTATUS = 1"> 
					<xsl:text>post-moderated</xsl:text>
				</xsl:when>	
				<xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/MODERATIONSTATUS = 2"> 
					<xsl:text>pre-moderated</xsl:text>
				</xsl:when>	
			</xsl:choose>
		</xsl:variable>
		
		<ul class="dna-list-links">
			<xsl:if test="$dashboardtype = 'blog' or $dashboardtype = 'story'">
				<li><a href="/dna/{$dashboardtypename}/admin/commentforumlist">Manage your entries/stories</a></li>
			</xsl:if>
			<xsl:if test="$dashboardtype = 'messageboard'">
				<li><a href="/dna/{$dashboardtypename}/admin/mbadmin?s_mode=admin">Manage your messageboard</a></li>
			</xsl:if>			
			<li><a href="/dna/{$dashboardtypename}/admin/MessageBoardSchedule">Opening times</a></li>
			<li><xsl:value-of select="$dashboardmodstatus" /><br /><br />
				To change your moderation status, contact the <a href="bbccommunities@bbc.co.uk">Moderation Services team</a>.
			</li>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>