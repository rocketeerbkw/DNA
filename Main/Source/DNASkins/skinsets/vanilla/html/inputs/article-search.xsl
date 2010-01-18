<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0" 
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
    exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article search form
        </doc:purpose>
        <doc:context>
        
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']" mode="input_article_search_advanced">   
      <div class="articlesearch advanced">
        
      </div>
    </xsl:template>
    
    <xsl:variable name="advanced_search_url">
		<xsl:value-of select="concat($articlesearchroot, '&amp;s_mode=advanced')"/>
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DATE and /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY = 0">
				<xsl:value-of select="concat('&amp;startdate=', /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DATE)"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY and /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY != 0">
				<xsl:value-of select="concat('&amp;startdate=', /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY, '/', /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH, '/', /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR)"/>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DATE and /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY = 0">
				<xsl:value-of select="concat('&amp;enddate=', /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DATE)"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY and /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY != 0">
				<xsl:value-of select="concat('&amp;enddate=', /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY, '/', /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH, '/', /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR)"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE != 0">
			<xsl:text></xsl:text>
			<xsl:value-of select="concat('&amp;datesearchtype=', /H2G2/ARTICLESEARCH/@DATESEARCHTYPE)"/>
		</xsl:if>
		<!-- s_phrase hold the phrases that were entered into the keywords field
		     (as opposed to the location phrase(s)
		-->
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_phrase']">
				<xsl:value-of select="concat('&amp;phrase=', /H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE, '&amp;s_phrase=', /H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE)"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- locations and keywords are all lumped together -->
				<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
					<xsl:value-of select="concat('&amp;phrase=', NAME)"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<!-- pass back s_location to advanced search for to 'remember' the location -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_location']">
			<xsl:text></xsl:text>
			<xsl:value-of select="concat('&amp;s_location=', /H2G2/PARAMS/PARAM[NAME='s_location']/VALUE)"/>
		</xsl:if>
		<!-- pass back s_locationuser to advanced search for to 'remember' the locationuser -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_locationuser']">
			<xsl:value-of select="concat('&amp;s_locationuser=', /H2G2/PARAMS/PARAM[NAME='s_locationuser']/VALUE)"/>
		</xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE='list'">
			<xsl:text>&amp;s_view_mode=list</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'DateUploaded'">
				<xsl:text>&amp;s_articlesortby=DateUploaded&amp;s_view_mode=list</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'Caption'">
				<xsl:text>&amp;s_articlesortby=Caption&amp;s_view_mode=list</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE">
				<xsl:value-of select="concat('&amp;s_articlesortby=', /H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE)"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE">
			<xsl:value-of select="concat('&amp;s_datemode=', /H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE)"/>
		</xsl:if>
	</xsl:variable>
</xsl:stylesheet>
