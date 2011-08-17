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
	    		<xsl:when test="OBJECT-TYPE = 'forum'">post</xsl:when>
	    		<xsl:when test="OBJECT-TYPE = 'entry'">article</xsl:when>
	    		<xsl:when test="OBJECT-TYPE = 'forumcomplaint'">alert</xsl:when>
	    		<xsl:when test="OBJECT-TYPE = 'entrycomplaint'">article alert</xsl:when>
	    		<xsl:when test="OBJECT-TYPE = 'generalcomplaint'">general complaint</xsl:when>
	    		<xsl:when test="OBJECT-TYPE = 'nickname'">nickname</xsl:when>
          <xsl:when test="OBJECT-TYPE = 'exlink'">ex-link</xsl:when>
          <xsl:when test="OBJECT-TYPE = 'exlinkcomplaint'">ex-link alert</xsl:when>
          
        </xsl:choose>
	    	<xsl:if test="@TOTAL != 1">
	    		<xsl:text>s</xsl:text>
	    	</xsl:if>
	    </xsl:variable>
    <xsl:variable name="selfObject" select="OBJECT-TYPE" />
    <xsl:variable name="combinedTotal">
      <xsl:value-of select="number(parent::MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE=$selfObject and STATE ='queued' and @FASTMOD='0']/@TOTAL) + @TOTAL"/>
    </xsl:variable>
    
    <xsl:variable name="lowestDate">
      <xsl:choose>
        <xsl:when test="(STATE = 'queued' and  @FASTMOD ='1')">
          <xsl:choose>
            <xsl:when test="DATE/@YEAR != '1'">
              <xsl:value-of select="DATE/@RELATIVE"/>
            </xsl:when>
            <xsl:when test="parent::MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE=$selfObject and STATE ='queued' and @FASTMOD='0']/DATE/@YEAR != '1'">
              <xsl:value-of select="parent::MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE=$selfObject and STATE ='queued' and @FASTMOD='0']/DATE/@RELATIVE"/>
            </xsl:when>
          </xsl:choose>

        </xsl:when>
        <xsl:when test="DATE/@YEAR != '1'">
          <xsl:value-of select="DATE/@RELATIVE"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
	    <!-- STATE = 'queuedreffered' -->
		<xsl:if test="(STATE = 'queued' and  @FASTMOD ='1') or STATE = 'lockedreffered'">
			<xsl:if test="(OBJECT-TYPE != 'entry' and OBJECT-TYPE != 'entrycomplaint') or $dashboardtype='community' or $dashboardtype = 'all'">
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
                <xsl:with-param name="total" select="$combinedTotal" />
							</xsl:call-template>
						</xsl:if>	
						<xsl:if test="STATE = 'lockedreffered'">
							<xsl:call-template name="moderationsummarylink">
								<xsl:with-param name="referraltype" select="$referraltype" />
							</xsl:call-template>
						</xsl:if>	
					</th>
					<td class="time">
					  <xsl:value-of select="$lowestDate" />
					</td> 
				</tr>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="moderationsummarylink">
		<xsl:param name="referraltype" />
		
		<!-- this is messy need to re-factor -->
		<xsl:choose>
			<xsl:when test="@TOTAL > 0">
				<xsl:choose>
					<xsl:when test="contains($referraltype,'general') and (not($dashboardtype = 'all') and not($dashboardtype = 'community'))">
						<!-- don't show anything -->
					</xsl:when>
					<xsl:otherwise>
					<a target="_blank">
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="$referraltype = 'post' or $referraltype = 'posts'">
									<xsl:text>/dna/moderation/moderateposts?referrals=1&amp;locked=1</xsl:text>
								</xsl:when>
								<xsl:when test="$referraltype = 'alert' or $referraltype = 'alerts'">
									<xsl:text>/dna/moderation/moderateposts?referrals=1&amp;alerts=1&amp;locked=1</xsl:text>
								</xsl:when>
								<xsl:when test="$referraltype = 'article' or $referraltype = 'articles'">
									<xsl:text>/dna/moderation/moderatearticle?referrals=1&amp;locked=1</xsl:text>
								</xsl:when>
								<xsl:when test="$referraltype = 'article alert' or $referraltype = 'article alerts'">
									<xsl:text>/dna/moderation/moderatearticle?referrals=1&amp;alerts=1&amp;locked=1</xsl:text>
								</xsl:when>
								<xsl:when test="$referraltype = 'general complaint' or $referraltype = 'general complaints'">
									<xsl:text>/dna/moderation/ModerateGeneral?referrals=1&amp;alerts=1&amp;locked=1</xsl:text>
								</xsl:when>
							</xsl:choose>
              <xsl:if test="@FASTMOD = '1'">
                <xsl:text>&amp;fastmod=1</xsl:text>
              </xsl:if>
						</xsl:attribute>
						<xsl:value-of select="@TOTAL" />&#160;
						<xsl:value-of select="$referraltype" />
						<xsl:text> referred for your decision</xsl:text>
					</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($referraltype,'general') and (not($dashboardtype = 'all') and not($dashboardtype = 'community'))">
						<!-- don't show anything -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@TOTAL" />&#160;
						<xsl:value-of select="$referraltype" />
						<xsl:text> referred for your decision</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="moderationsummary">
		<xsl:param name="referraltype" />
    <xsl:param name="total" />

    <xsl:value-of select="$total" />&#160;
		<xsl:value-of select="$referraltype" />
		<xsl:text> queued to moderators</xsl:text>
	</xsl:template>	

</xsl:stylesheet>	
