<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-smmpage.xsl"/>
	<xsl:template name="SYSTEMMESSAGEMAILBOX_JAVASCRIPT">
	
	</xsl:template>
	<xsl:template name="SYSTEMMESSAGEMAILBOX_CSS">
	
	</xsl:template>
	<!--
	SYSTEMMESSAGEMAILBOX_MAINBODY
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SYSTEMMESSAGEMAILBOX_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<tr>
				<td id="crumbtrail">
					<h5>You are here &gt; 
						<a href="{$homepage}">
							<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a> &gt; Your discussions
					</h5>
				</td>
			</tr>
			<tr>
				<td width="635">
					<table cellspacing="0" cellpadding="0" border="0" width="630">
						<tr>
							<td id="discussionTitle">
								<br/>
								<p>User ID: U<xsl:value-of select="/H2G2/SYSTEMMESSAGEMAILBOX/@USERID"/>
								</p>
								<hr width="630" align="left" class="line"/>
								<xsl:choose>
									<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'mbnewsround' or /H2G2/CURRENTSITEURLNAME = 'mbcbbc'">
										<p class="strong">Your Messages from the Mods are listed below</p>
									</xsl:when>
									<xsl:otherwise>
										<p class="strong">Your Moderation Notifications are listed below</p>
									</xsl:otherwise>
								</xsl:choose>								
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center">
					<table width="625" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td valign="top" class="tablenavbarTop" colspan="3">
								<div class="tablenavtext"><a href="MP{/H2G2/SYSTEMMESSAGEMAILBOX/@USERID}" id="morepostsbutton">Your Discussions</a> 
								<xsl:choose>
									<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'mbnewsround' or /H2G2/CURRENTSITEURLNAME = 'mbcbbc'">
										<a href="smm" id="smmbutton-on">Messages from the Mods</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="smm" id="smmbutton-on">Moderation Notifications</a>
									</xsl:otherwise>
								</xsl:choose>	
									<xsl:apply-templates select="/H2G2/SYSTEMMESSAGEMAILBOX" mode="c_pagination"/>
								</div>
							</td>
						</tr>
						<xsl:apply-templates select="/H2G2/SYSTEMMESSAGEMAILBOX" mode="c_systemmessagemailbox"/>
					</table>
				</td>
			</tr>
			<tr>
				<td class="discussions">
					&nbsp;
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="POSTS" mode="r_morepostspage">
	Description: Presentation of the object holding the latest conversations the user
	has contributed to
	 -->
	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="r_systemmessagemailbox">
		<xsl:apply-templates select="MESSAGE" mode="c_systemmessagemailbox"/>
	</xsl:template>

	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="r_pagination">
		<p>
			<xsl:apply-templates select="." mode="t_pagination_pagecount"/>
			<xsl:apply-templates select="." mode="t_pagination_firstpage"/>
			<xsl:apply-templates select="." mode="t_pagination_prevpage"/>
			<xsl:apply-templates select="." mode="t_pagination_nextpage"/>
			<xsl:apply-templates select="." mode="t_pagination_lastpage"/>
		</p>
	</xsl:template>
	
	<xsl:template match="MESSAGE" mode="r_systemmessagemailbox">
		<tr class="MPnewrow">
		<xsl:apply-templates select="BODY" mode="c_systemmessagemailbox"/>
		<!--xsl:apply-templates select="DATEPOSTED" mode="c_systemmessagemailbox"/-->
		</tr>
	</xsl:template>

	<xsl:template match="BODY" mode="r_systemmessagemailbox">
	<td class="SMMmessage" valign="top">
		<p>
		<xsl:call-template name="cr-to-br">
			<xsl:with-param name="text" select="."/>
		</xsl:call-template>
		</p>
		<xsl:apply-templates select="../@MSGID" mode="c_systemmessagemailbox"/>
	</td>
	</xsl:template>
	
	<xsl:template match="@MSGID" mode="r_systemmessagemailbox">
		<p><xsl:apply-templates select="." mode="t_deletesystemmessage"/></p>
	</xsl:template>
			
	<xsl:attribute-set name="maMSGID_t_deletesystemmessage">
		<xsl:attribute name="class">deletesmmbutton</xsl:attribute>
	</xsl:attribute-set>
	
	<!--xsl:template match="DATEPOSTED" mode="r_systemmessagemailbox">
	<td class="MPdate" valign="top" width="180">
		<p>
			<xsl:text>Date posted: </xsl:text>
			<xsl:apply-templates select="DATE" mode="c_systemmessagemailbox"/>
		</p>
	</td>
	</xsl:template-->
	
	<!--xsl:template match="DATE" mode="r_systemmessagemailbox">
			<xsl:value-of select="@DAYNAME"/> -
			<xsl:value-of select="@DAY"/> -
			<xsl:value-of select="@MONTH"/> -
			<xsl:value-of select="@YEAR"/>
	</xsl:template-->

</xsl:stylesheet>
