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
				<p>These items require your attention.</p>
				<div>
					<table>
						<tbody>
							<xsl:apply-templates select="MODERATION-QUEUE-SUMMARY[STATE = 'queuedreffered']" mode="objects_moderator_queuesummary" />
						</tbody>
					</table>
				</div>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>