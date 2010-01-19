<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<!-- # # ################################################## -->
	<!--
	The top level containing frame for general moderation page - contains a frame
	that displays the page complained about, and a frame that displays the moderation form
-->
<xsl:template match='H2G2[@TYPE="MODERATION-TOP-FRAME"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 Moderation: General Complaints</title>
			<style type="text/css">
				<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
			</style>
		</head>
		<frameset rows="*,160" border="0" framespacing="1" frameborder="1">
			<frame src="{MODERATION-FRAME/@URL}" name="ModerationDisplayFrame" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" scrolling="auto"/>
			<xsl:choose>
				<xsl:when test="string-length(MODERATION-FRAME/NEXT) > 0">
					<frame name="ModerationFormFrame" marginheight="0" marginwidth="1" leftmargin="0" topmargin="0" scrolling="auto">
						<xsl:attribute name="src">ModerationFormFrame?Next=<xsl:value-of select="MODERATION-FRAME/NEXT"/>&amp;Referrals=<xsl:value-of select="MODERATION-FRAME/@REFERRALS"/><xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_newstyle']/VALUE = 1">&amp;s_newstyle=1</xsl:if></xsl:attribute>	
						
					</frame>
				</xsl:when>
				<xsl:otherwise>
					<frame name="ModerationFormFrame" marginheight="0" marginwidth="1" leftmargin="0" topmargin="0" scrolling="auto">
						<xsl:attribute name="src">ModerationFormFrame?Referrals=<xsl:value-of select="MODERATION-FRAME/@REFERRALS"/><xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_newstyle']/VALUE = 1">&amp;s_newstyle=1</xsl:if></xsl:attribute>	
					</frame>
				</xsl:otherwise>
			</xsl:choose>
		</frameset>
	</html>
</xsl:template>

</xsl:stylesheet>