<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	
<!--===============Imported Files=====================-->
<xsl:import href="../../../base/base-extra.xsl"/>
<!--===============Imported Files=====================-->

<xsl:include href="articlesearch.xsl"/>

<xsl:include href="acs.xsl"/>
<xsl:include href="usercomplaintpopup.xsl"/>

<xsl:output method="html" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO-8859-1"/>

<xsl:variable name="csslink">
	<xsl:call-template name="insert-css"/>
</xsl:variable>
  <xsl:variable name="root">
    <xsl:text>/dna/</xsl:text>
    <xsl:value-of select="$staging_root"/>
    <xsl:choose>
      <xsl:when test="/H2G2/SITE/NAME">
        <xsl:value-of select="/H2G2/SITE/NAME"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>/acs/</xsl:text>
  </xsl:variable>

  <xsl:variable name="scriptlink">
	<xsl:call-template name="insert-javascript"/>
</xsl:variable>

  <xsl:variable name="boardpath">
    <xsl:choose>
      <xsl:when test="/H2G2/@TYPE = 'MESSAGEBOARDADMIN'">
        <xsl:apply-templates select="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE='12']/SITECONFIG" mode="boardpathserver"/>
      </xsl:when>
      <xsl:when test="/H2G2/@TYPE = 'TEXTBOXELEMENTPAGE'">
        <xsl:apply-templates select="/H2G2/TEXTBOXPAGE/SITECONFIG" mode="boardpathserver"/>
      </xsl:when>
      <xsl:when test="/H2G2/@TYPE = 'FRONTPAGETOPICELEMENTBUILDER'">
        <xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/SITECONFIG" mode="boardpathserver"/>
      </xsl:when>
      <xsl:when test="/H2G2/@TYPE = 'MESSAGEBOARDPROMOPAGE'">
        <xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/SITECONFIG" mode="boardpathserver"/>
      </xsl:when>
      <!--<xsl:when test="/H2G2/@TYPE = 'TOPICBUILDER'">
				<xsl:apply-templates select="/H2G2/TOPIC_PAGE/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>-->
      <xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
        <xsl:apply-templates select="/H2G2/FRONTPAGELAYOUTCOMPONENTS/SITECONFIG" mode="boardpathserver"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/H2G2/SITECONFIG" mode="boardpathserver"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="SITECONFIG" mode="boardpathserver">
    <xsl:choose>
      <xsl:when test="contains(/H2G2/SERVERNAME, 'OPS')">
        <xsl:copy-of select="PATHDEV/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="PATHLIVE/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:variable name="imagesource">
    <xsl:value-of select="$boardpath"/><xsl:text>images/</xsl:text>
  </xsl:variable>


  <!--===============Body Content Template (Global Content Stuff) Content table=====================-->
	<xsl:template match="H2G2" mode="r_bodycontent">
		<xsl:call-template name="insert-mainbody"/>
	</xsl:template>
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<xsl:template name="popup-template">
		<html>
			<xsl:call-template name="insert-header"/>
			<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
				<xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">
					<xsl:attribute name="onload"><xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">previewmode();</xsl:if></xsl:attribute>
				</xsl:if>
				<xsl:call-template name="insert-mainbody"/>
			</body>
		</html>
	</xsl:template>
	<!--===============Popup Template (Popup page Stuff)=====================-->

  <xsl:template match="H2G2[@TYPE='SERVERTOOBUSY']">
    <html>
      <head>
        <title>Server Too Busy</title>
      </head>
      <body>
        <h1>Server Too Busy</h1>
        <p>The server is currently very busy and is unable to process your request. Please try again soon.</p>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='SERVERTOOBUSY' and REQUESTTYPE='COMMENTBOX']">
    <p>Comments are currently unavailable</p>
  </xsl:template>
  
</xsl:stylesheet>