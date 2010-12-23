<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="MODERATIONQUEUES" mode="objects_moderator_queuedreffered">
		<xsl:choose>
			<xsl:when test="not(MODERATION-QUEUE-SUMMARY)">
				<p>There are no referred items.</p>
			</xsl:when>
			<xsl:when test="parent::MODERATORHOME/@ISREFEREE != '1'">
				<p>You are not a referee for this <xsl:value-of select="$dashboardtype" /></p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="queuetotal"><xsl:apply-templates select="MODERATION-QUEUE-SUMMARY[STATE = 'lockedreffered']" mode="objects_moderator_queueitems" /></xsl:variable>
				<p>
					<xsl:choose>
						<xsl:when test="$queuetotal = 0">
							There are no items requiring your attention.
						</xsl:when>
						<xsl:otherwise>
							These items require your attention.
						</xsl:otherwise>
					</xsl:choose>
				</p>
				<xsl:choose>
					<xsl:when test="$dashboardtype = 'blog' and /H2G2/MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Blog']/TOTAL > 0">
						<p><xsl:text>Clicking on a link will show all alerts or comments locked to you.</xsl:text></p>
					</xsl:when>
					<xsl:when test="$dashboardtype = 'messageboard' and /H2G2/MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Messageboard']/TOTAL > 0">
						<p><xsl:text>Clicking on a link will show all alerts or posts locked to you.</xsl:text></p>
					</xsl:when>
					<xsl:when test="$dashboardtype = 'community' and /H2G2/MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Community']/TOTAL > 0">
						<p><xsl:text>Clicking on a link will show all alerts, posts, articles or general complaints locked to you.</xsl:text></p>
					</xsl:when>
					<xsl:when test="$dashboardtype = 'story' and /H2G2/MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'EmbeddedComments']/TOTAL > 0">
						<p><xsl:text>Clicking on a link will show all alerts or comments locked to you.</xsl:text></p>
					</xsl:when>
				</xsl:choose>	
				<div>
					<table>
						<tbody>
							<xsl:apply-templates select="MODERATION-QUEUE-SUMMARY[STATE = 'lockedreffered']" mode="objects_moderator_queuesummary" />
						</tbody>
					</table>
				</div>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="MODERATION-QUEUE-SUMMARY" mode="objects_moderator_queueitems">
		<xsl:value-of select="sum(@TOTAL)" />
	</xsl:template>
	
</xsl:stylesheet>