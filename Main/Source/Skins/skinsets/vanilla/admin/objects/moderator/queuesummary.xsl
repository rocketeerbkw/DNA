<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="MODERATION-QUEUE-SUMMARY" mode="objects_moderator_queuesummary">
	    
		<xsl:variable name="referraltype">
	    	<xsl:choose>
	    		<xsl:when test="OBJECTTYPE = 'forum'">post</xsl:when>
	    		<xsl:when test="OBJECTTYPE = 'entry'">article</xsl:when>
	    		<xsl:when test="OBJECTTYPE = 'forumcomplaint'">alert</xsl:when>
	    		<xsl:when test="OBJECTTYPE = 'entrycomplaint'">article alert</xsl:when>
	    		<xsl:when test="OBJECTTYPE = 'generalcomplaint'">general complaint</xsl:when>
	    		<xsl:when test="OBJECTTYPE = 'nickname'">nickname</xsl:when>
	    	</xsl:choose>
	    	<xsl:if test="@TOTAL != 1">
	    		<xsl:text>s</xsl:text>
	    	</xsl:if>
	    </xsl:variable> 
	    
		<xsl:if test="STATE = 'queuedreffered' or STATE = 'queued' or STATE = 'lockedreffered'">
			<xsl:if test="(OBJECTTYPE != 'entry' and OBJECTTYPE != 'entrycomplaint') or $dashboardtype='community' ">
			    <tr>
					<th>
						<xsl:if test="STATE = 'queuedreffered'">
							<xsl:call-template name="moderationsummarylink">
								<xsl:with-param name="referraltype" select="$referraltype" />
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="STATE = 'queued'">
							<xsl:call-template name="moderationsummary">
								<xsl:with-param name="referraltype" select="$referraltype" />
							</xsl:call-template>
						</xsl:if>	
						<xsl:if test="STATE = 'lockedreffered'">
							<xsl:call-template name="moderationsummarylink">
								<xsl:with-param name="referraltype" select="$referraltype" />
								<xsl:with-param name="islocked"> locked </xsl:with-param>
							</xsl:call-template>
						</xsl:if>	
					</th>
					<td>
						<xsl:if test="DATE/@YEAR != 1">
							<xsl:value-of select="DATE/LOCAL/@RELATIVE" />
						</xsl:if>
					</td> 
				</tr>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="moderationsummarylink">
		<xsl:param name="referraltype" />
		<xsl:param name="islocked" />
		
		<xsl:choose>
			<xsl:when test="@TOTAL > 0">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="$referraltype = 'posts'">
								<xsl:text>/dna/moderation/moderateposts?referrals=1</xsl:text>
							</xsl:when>
							<xsl:when test="$referraltype = 'alerts'">
								<xsl:text>/dna/moderation/moderateposts?referrals=1&amp;alerts=1</xsl:text>
							</xsl:when>
							<xsl:when test="$referraltype = 'articles'">
								<xsl:text>/dna/moderation/moderatearticles?referrals=1</xsl:text>
							</xsl:when>
							<xsl:when test="$referraltype = 'article alerts'">
								<xsl:text>/dna/moderation/moderatearticles?referrals=1&amp;alerts=1</xsl:text>
							</xsl:when>
							<xsl:when test="$referraltype = 'general complaints'">
								<xsl:text>/dna/moderation/moderatearticles?referrals=1&amp;alerts=1</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="@TOTAL" />&#160;
					<xsl:text> referred </xsl:text>
					<xsl:value-of select="$islocked" />
					<xsl:value-of select="$referraltype" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@TOTAL" />&#160;
				<xsl:text> referred </xsl:text>
				<xsl:value-of select="$islocked" />
				<xsl:value-of select="$referraltype" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="moderationsummary">
		<xsl:param name="referraltype" />
		
		<xsl:value-of select="@TOTAL" />&#160;
		<xsl:value-of select="$referraltype" />
		<xsl:text> queued to moderators</xsl:text>
	</xsl:template>	

</xsl:stylesheet>	
