<xsl:stylesheet version="1.0" xmlns:tom="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:parent="http://www.bbc.co.uk/dna/parent" xmlns:child="http://www.bbc.co.uk/dna/child" xmlns:childContent="http://www.bbc.co.uk/dna/childContent" exclude-result-prefixes="msxsl local s dt tom">

	<!-- 
	
	-->
	<xsl:template name="ARTICLESEARCH_FLASHXML">
		<xsl:param name="mod"/>
	    <xsl:apply-templates select="/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE" mode="flashxml_articlesearch"/>
	</xsl:template>
	
	<!-- 
	
	-->
    <!--[FIXME: remove?]
	<xsl:template match="ARTICLE" mode="flashxml_resource_articlesearch">
		<rdf:li rdf:resource="{$thisserver}{$root}A{@H2G2ID}"/>
	</xsl:template>
    -->
	<!-- 
	
	-->
	<xsl:template match="ARTICLE" mode="flashxml_articlesearch">
		<xsl:if test="DATERANGESTART/DATE">
			<parent:ARTICLE H2G2ID="{@H2G2ID}">
				<child:SUBJECT>
					<xsl:value-of select="SUBJECT"/>
				</child:SUBJECT>
				<child:EXTRAINFO>
					<childContent:AUTODESCRIPTION>
						<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
					</childContent:AUTODESCRIPTION>
					<childContent:STARTDATE>
						<xsl:choose>
							<xsl:when test="DATERANGESTART/DATE">
								<xsl:value-of select="concat(DATERANGESTART/DATE/@YEAR, DATERANGESTART/DATE/@MONTH, DATERANGESTART/DATE/@DAY, '000000')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>00000000000000</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:STARTDATE>
					<childContent:ENDDATE>
						<xsl:choose>
							<xsl:when test="DATERANGEEND/DATE">
								<xsl:value-of select="concat(DATERANGEEND/DATE/@YEAR, DATERANGEEND/DATE/@MONTH, DATERANGEEND/DATE/@DAY, '000000')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>00000000000000</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:ENDDATE>
					<childContent:TIMEINTERVAL>
						<xsl:choose>
							<xsl:when test="EXTRAINFO/TIMEINTERVAL">
								<xsl:value-of select="EXTRAINFO/TIMEINTERVAL"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</childContent:TIMEINTERVAL>
					<childContent:TYPEOFARTICLE>
						<!-- changed from echoing out the EXTRAINFO/TYPEOFARTICLE node to actually checking the authors groups -->
						<xsl:choose>
							<xsl:when test="EDITOR/USER/GROUPS/GROUP[NAME='EDITOR']">
								<xsl:text>_staff_memory</xsl:text>
							</xsl:when>
							<xsl:otherwise>	
								<xsl:text>_user_memory</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:TYPEOFARTICLE>
					<childContent:TYPEOFDATE>
						<!-- 1: specific date
							 2: date range
							 3: fuzzy date
						-->
						<xsl:choose>
							<xsl:when test="DATERANGESTART/DATE">
								<xsl:call-template name="GET_DATE_RANGE_TYPE">
									<xsl:with-param name="startdate" select="concat(DATERANGESTART/DATE/@DAY,$date_sep,DATERANGESTART/DATE/@MONTH,$date_sep,DATERANGESTART/DATE/@YEAR)"/>
									<xsl:with-param name="startday" select="DATERANGESTART/DATE/@DAY"/>
									<xsl:with-param name="startmonth" select="DATERANGESTART/DATE/@MONTH"/>
									<xsl:with-param name="startyear" select="DATERANGESTART/DATE/@YEAR"/>
									<xsl:with-param name="enddate" select="concat(DATERANGEEND/DATE/@DAY,$date_sep,DATERANGEEND/DATE/@MONTH,$date_sep,DATERANGEEND/DATE/@YEAR)"/>
									<xsl:with-param name="endday" select="DATERANGEEND/DATE/@DAY"/>
									<xsl:with-param name="endmonth" select="DATERANGEEND/DATE/@MONTH"/>
									<xsl:with-param name="endyear" select="DATERANGEEND/DATE/@YEAR"/>
									<xsl:with-param name="timeinterval" select="TIMEINTERVAL"/>
								</xsl:call-template>					
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>0</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:TYPEOFDATE>
					<childContent:ARTICLELINK>
						<xsl:text>A</xsl:text><xsl:value-of select="@H2G2ID"/>
					</childContent:ARTICLELINK>
					<childContent:USERID>
						<xsl:value-of select="EXTRAINFO/AUTHORUSERID"/>
					</childContent:USERID>
					<childContent:USERNAME>
						<xsl:choose>
							<xsl:when test="EDITOR/USER/USERID and EDITOR/USER/USERNAME != ''">
								<xsl:value-of select="EDITOR/USER/USERNAME"/>
							</xsl:when>
							<xsl:when test="EXTRAINFO/AUTHORNAME != ''">
								<xsl:value-of select="EXTRAINFO/AUTHORNAME"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="EXTRAINFO/AUTHORUSERNAME"/>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:USERNAME>
					<childContent:REALNAME>
						<xsl:choose>
							<xsl:when test="EDITOR/USER/USERID and EDITOR/USER/USERNAME != ''">
								<xsl:value-of select="EDITOR/USER/USERNAME"/>
							</xsl:when>
							<xsl:when test="EXTRAINFO/AUTHORNAME != ''">
								<xsl:value-of select="EXTRAINFO/AUTHORNAME"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="EXTRAINFO/AUTHORUSERNAME"/>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:REALNAME>
					<childContent:USERLINK>
						<xsl:choose>
							<xsl:when test="EDITOR/USER/USERID and EDITOR/USER/USERNAME != ''">
								<xsl:text>U</xsl:text><xsl:value-of select="EDITOR/USER/USERID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>U</xsl:text><xsl:value-of select="EXTRAINFO/AUTHORUSERID"/>
							</xsl:otherwise>
						</xsl:choose>
					</childContent:USERLINK>
					<childContent:ALTNAME>
						<xsl:value-of select="EXTRAINFO/ALTNAME"/>
					</childContent:ALTNAME>
				</child:EXTRAINFO>
			</parent:ARTICLE>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
