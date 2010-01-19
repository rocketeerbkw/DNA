<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="boomboom-template">
		<xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="iso-8859-1"?&gt;</xsl:text>
		<data>
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE='MOREPAGES'">
					<xsl:apply-templates select="descendant::ARTICLE">
						<xsl:sort select="DATERANGEEND/DATE/@SORT" order="descending" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="descendant::ARTICLE"/>
				</xsl:otherwise>
			</xsl:choose>
		</data>
	</xsl:template>

	<xsl:template match="ARTICLE">
		<xsl:if test="(EXTRAINFO/STARTDATE != '') and ((not (SITEID)) or SITEID=$site_number) and (SUBJECT != '')">
			<memory>
				<xsl:attribute name="id">
					<xsl:choose>
						<xsl:when test="@H2G2ID">
							<xsl:value-of select="@H2G2ID"/>
						</xsl:when>
						<xsl:when test="H2G2-ID">
							<xsl:value-of select="H2G2-ID"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="createddate">
					<xsl:value-of select="EXTRAINFO/DATECREATED"/>
				</xsl:attribute>
				<xsl:attribute name="startdate">
					<xsl:value-of select="substring(DATERANGESTART/DATE/@SORT, 0, 9)"/>
				</xsl:attribute>
				<xsl:if test="count(DATERANGEEND) > 0 and DATERANGEEND/DATE/@SORT != DATERANGESTART/DATE/@SORT">
					<xsl:attribute name="enddate">
						<xsl:value-of select="substring(DATERANGEEND/DATE/@SORT, 0, 9)"/>
					</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:value-of select="SUBJECT"/>
				</title>
				<author>
					<xsl:choose>
						<xsl:when test="EXTRAINFO/ALTNAME != ''">
							<xsl:value-of select="EXTRAINFO/ALTNAME"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="EDITOR/USER/USERNAME"/>
						</xsl:otherwise>
					</xsl:choose>
				</author>
			</memory>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
