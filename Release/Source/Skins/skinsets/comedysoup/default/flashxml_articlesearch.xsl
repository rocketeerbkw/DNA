<xsl:stylesheet version="1.0" xmlns:tom="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:parent="http://www.bbc.co.uk/dna/parent" xmlns:child="http://www.bbc.co.uk/dna/child" xmlns:childContent="http://www.bbc.co.uk/dna/childContent" exclude-result-prefixes="msxsl local s dt tom">

	<!-- 
	
	-->
	<xsl:template name="ARTICLESEARCH_FLASHXML">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_gen']/VALUE = '1'">
				<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="flashxml_articlesearchphrase_gen"/>
			</xsl:when>
			<xsl:otherwise>
	    		<xsl:apply-templates select="/H2G2/SITECONFIG/TOPPICKS" mode="flashxml_articlesearchphrase"/>
	    	</xsl:otherwise>
	    </xsl:choose>
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
	<xsl:template match="TOPPICKS" mode="flashxml_articlesearchphrase">
    	<xsl:copy-of select="ARTICLESEARCH"/>     
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="flashxml_articlesearchphrase_gen">
		<ARTICLESEARCHPHRASE>
			<xsl:apply-templates select="ARTICLES/ARTICLE" mode="flashxml_articlesearchphrase_gen"/>
		</ARTICLESEARCHPHRASE>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="flashxml_articlesearchphrase_gen">
		<ARTICLE H2G2ID="{@H2G2ID}">
			<MEDIAASSET MEDIAASSETID="{MEDIAASSET/@MEDIAASSETID}" CONTENTTYPE="{MEDIAASSET/@CONTENTTYPE}">
				<xsl:copy-of select="MEDIAASSET/FTPPATH"/>
				<xsl:copy-of select="MEDIAASSET/MIMETYPE"/>
			</MEDIAASSET>
			<xsl:copy-of select="SUBJECT"/>
			<EXTRAINFO>
				<xsl:copy-of select="EXTRAINFO/AUTODESCRIPTION"/>
				<xsl:copy-of select="EXTRAINFO/PCCAT"/>
				<xsl:copy-of select="EXTRAINFO/ASPECTRATIO"/>
			</EXTRAINFO>
			<POLL>
				<xsl:copy-of select="POLL/STATISTICS"/>
			</POLL>
			<EDITOR>
				<USER>
					<xsl:copy-of select="EDITOR/USER/USERID"/>
					<xsl:copy-of select="EDITOR/USER/FIRSTNAMES"/>
					<xsl:copy-of select="EDITOR/USER/LASTNAME"/>
					<xsl:copy-of select="EDITOR/USER/USERNAME"/>
				</USER>
			</EDITOR>
			<LASTUPDATED>
				<DATE SORT="{LASTUPDATED/DATE/@SORT}"/>
			</LASTUPDATED>
		</ARTICLE>
	</xsl:template>
</xsl:stylesheet>
