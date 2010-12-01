<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitename" select="/H2G2/SITECONFIG/BOARDSSOLINK/node()"/>
	<xsl:variable name="sitedisplayname" select="/H2G2/SITECONFIG/BOARDNAME/node()"/>
	<xsl:variable name="root">/dna/<xsl:copy-of select="/H2G2/SITECONFIG/BOARDROOT/node()"/>
	</xsl:variable>
	<xsl:variable name="sso_assets_path">
		<xsl:copy-of select="/H2G2/SITECONFIG/SSOPATH/node()"/>
	</xsl:variable>
	<xsl:variable name="sso_serviceid_link">
		<xsl:copy-of select="/H2G2/SITECONFIG/SSOLINK/node()"/>
	</xsl:variable>
	<xsl:variable name="isAdmin">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='MESSAGEBOARDSCHEDULE' or /H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='TYPED-ARTICLE' or /H2G2/@TYPE='INDEX' or /H2G2/@TYPE='SITECONFIG-EDITOR'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="imagesource">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				/dnaimages/boards/images/			
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="/H2G2/SITECONFIG/IMGSRC/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
</xsl:stylesheet>
