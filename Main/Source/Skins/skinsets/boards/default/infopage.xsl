<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-infopage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="INFO_MAINBODY">
		<table width="100%" cellpadding="5" cellspacing="5" border="1">
			<tr>
				<td>
					<font size="2">
						<xsl:apply-templates select="INFO" mode="c_info"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="INFO" mode="r_info">
	Description: Presentation of the object holding the four different INFO blocks, the 
		TOTALREGUSERS and the APPROVEDENTRIES info with their respective text
	 -->
	<xsl:template match="INFO" mode="r_info">
		<table cellpadding="5" cellspacing="5" border="0">
		  <xsl:if test="TOTALREGUSERS">
		    <tr>
          <td>
            <font size="2">
              <strong>
                <xsl:value-of select="$m_totalregusers"/>
              </strong>
              <br/>
              <xsl:value-of select="TOTALREGUSERS"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$m_usershaveregistered"/>
            </font>
          </td>
        </tr>
		  </xsl:if>
		  <xsl:if test="TOTALREGUSERS">
        <tr>
          <td>
            <font size="2">
              <strong>
                <xsl:value-of select="$m_editedentries"/>
              </strong>
              <br/>
              <xsl:value-of select="$m_therearecurrently"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="APPROVEDENTRIES"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="$m_editedinguide"/>
            </font>
          </td>
        </tr>
		  </xsl:if>
			<xsl:if test="PROLIFICPOSTERS">
        <tr>
          <td>
            <xsl:apply-templates select="PROLIFICPOSTERS" mode="c_info"/>
          </td>
        </tr>
			</xsl:if>
		  <xsl:if test="ERUDITEPOSTERS">
        <tr>
          <td>
            <xsl:apply-templates select="ERUDITEPOSTERS" mode="c_info"/>
          </td>
        </tr>
		  </xsl:if>
		  <xsl:if test="RECENTCONVERSATIONS">
        <tr>
          <td>
            <xsl:apply-templates select="RECENTCONVERSATIONS" mode="c_info"/>
          </td>
        </tr>
		  </xsl:if>
			<xsl:if test="FRESHESTARTICLES">
        <tr>
          <td>
            <xsl:apply-templates select="FRESHESTARTICLES" mode="c_info"/>
          </td>
        </tr>
			</xsl:if>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
	Description: Presentation of the object holding the PROLIFICPOSTERS
		and its title text
	 -->
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
		<font size="2">
			<strong>
				<xsl:value-of select="$m_toptenprolific"/>
			</strong>
			<br/>
			<xsl:apply-templates select="PROLIFICPOSTER" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
	Description: Presentation of the PROLIFICPOSTER object
	 -->
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
		<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average_info"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
	Description: Presentation of the object holding the ERUDITEPOSTERS
		and its title text
	 -->
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
		<font size="2">
			<strong>
				<xsl:value-of select="$m_toptenerudite"/>
			</strong>
			<br/>
			<xsl:apply-templates select="ERUDITEPOSTER" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
	Description: Presentation of the ERUDITEPOSTER object
	 -->
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
		<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average_info"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
	Description: Presentation of the object holding the RECENTCONVERSATIONS
		and its title text
	 -->
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
		<font size="2">
			<strong>
				<xsl:value-of select="$m_toptwentyupdated"/>
			</strong>
			<br/>
			<xsl:apply-templates select="RECENTCONVERSATION" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
	Description: Presentation of the RECENTCONVERSATION object
	 -->
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
		<xsl:apply-templates select="." mode="t_info"/>
		<font size="1">
			(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_info"/>)
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
	Description: Presentation of the object holding the FRESHESTARTICLES
		and its title text
	 -->
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
		<font size="2">
			<strong>
				<xsl:value-of select="$m_toptenupdatedarticles"/>
			</strong>
			<br/>
			<xsl:apply-templates select="RECENTARTICLE" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENTARTICLE" mode="r_info">
	Description: Presentation of the RECENTARTICLE object
	 -->
	<xsl:template match="RECENTARTICLE" mode="r_info">
		<xsl:value-of select="H2G2ID"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_info"/>
		<font size="1">
			(<xsl:apply-templates select="DATEUPDATED/DATE" mode="t_info"/>)
			<xsl:apply-templates select="STATUS" mode="t_info"/>
		</font>
		<br/>
	</xsl:template>
</xsl:stylesheet>
