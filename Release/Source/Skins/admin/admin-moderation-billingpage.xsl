<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<xsl:template match="H2G2[@TYPE='MODERATION-BILLING']">
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 Moderation: Billing</title>
			<style type="text/css">
				<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
			</style>
			<script language="JavaScript">
				<![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

// stop hiding -->
				]]>
			</script>
		</head>
		<body bgColor="lightblue">
			<div class="ModerationTools">
			<font face="Arial" size="2" color="black">
<!--				<h2 align="center">General Moderation</h2>-->
<H2>DNA Moderation Billing</H2>
					<font size="1">
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-1</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-2</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-3</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-4</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-5</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-6</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-7</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-8</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-9</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-10</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-11</xsl:with-param>
					</xsl:call-template>
					|
					<xsl:call-template name="createmodbillmonthlink">
					<xsl:with-param name="offset">-12</xsl:with-param>
					</xsl:call-template>
					</font>
					<br/>
					<a href="{$root}Moderate">Moderation home page</a>
					<form method="get" action="{$root}ModerationBilling">
					
					From: <input type="text" name="startdate"/>
					To: <input type="text" name="enddate"/>
					<input type="checkbox" name="recalc" value="1"/> Force recalculation
					<input type="submit" name="process" value="Get Stats For Date"/>
					</form>
				<xsl:apply-templates select="/H2G2/MODERATION-BILLING"/>
			</font>
			</div>
		</body>
	</html>
</xsl:template>
	<xsl:variable name="modthreadcolour">#000000</xsl:variable>
	<xsl:variable name="modarticlecolour">#FF0000</xsl:variable>
	<xsl:variable name="modgeneralcolour">#0000FF</xsl:variable>

	<xsl:template match="MODERATION-BILLING">
	Between <xsl:apply-templates select="START-DATE/DATE"/> and <xsl:apply-templates select="END-DATE/DATE"/><br/>

	<table border="1">
	<tr>
	<td rowspan="3">Site</td><td colspan="5" align="center"><font color="{$modthreadcolour}" size="2">Threads</font></td>
	</tr>
	<tr><td colspan="5" align="center"><font color="{$modarticlecolour}" size="2">Articles</font></td></tr>
	<tr><td colspan="5" align="center"><font color="{$modgeneralcolour}" size="2">General</font></td></tr>
	<tr>
	<td></td>
	<td><font size="2">Total</font></td>
	<td><font size="2">Passed</font></td>
	<td><font size="2">Failed</font></td>
	<td><font size="2">Referred</font></td>
	<td><font size="2">Complaints</font></td>
	</tr>
	<xsl:apply-templates select="BILL"/>
	</table>
	<b>Notes</b><br/>
	<font size="1">
	The percentage figures for passed, failed etc. are the percentage of the total items for that site. 
	The percentage figure for totals is the percentage of the total moderation items across all sites.
	</font>
	</xsl:template>



<xsl:template match="BILL">
<xsl:variable name="threadtotal"><xsl:value-of select="sum(../BILL/THREADTOTAL)"/></xsl:variable>
<xsl:variable name="articletotal"><xsl:value-of select="sum(../BILL/ARTICLETOTAL)"/></xsl:variable>
<xsl:variable name="generaltotal"><xsl:value-of select="sum(../BILL/GENERALTOTAL)"/></xsl:variable>
<tr>
<td rowspan="3"><!--xsl:apply-templates select="SITEID" mode="showfrom"/-->
<xsl:value-of select="$m_fromsite"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/SHORTNAME"/>
</td>

<td><font color="{$modthreadcolour}" size="2"><xsl:value-of select="THREADTOTAL"/>
<xsl:choose>
<xsl:when test="$threadtotal &gt; 0">
(<xsl:value-of select="format-number(round((THREADTOTAL div $threadtotal)*100),'0.00')"/>%)
</xsl:when>
<xsl:otherwise>
(0%)
</xsl:otherwise>
</xsl:choose>
</font>
</td>
<td><font color="{$modthreadcolour}" size="2"><xsl:apply-templates select="THREADPASSED"/></font></td>
<td><font color="{$modthreadcolour}" size="2"><xsl:apply-templates select="THREADFAILED"/></font></td>
<td><font color="{$modthreadcolour}" size="2"><xsl:apply-templates select="THREADREFERRED"/></font></td>
<td><font color="{$modthreadcolour}" size="2"><xsl:apply-templates select="THREADCOMPLAINT"/></font></td>
</tr>
<tr>
<td><font color="{$modarticlecolour}" size="2"><xsl:value-of select="ARTICLETOTAL"/>
<xsl:choose>
<xsl:when test="$articletotal &gt; 0">
(<xsl:value-of select="format-number(round((ARTICLETOTAL div $articletotal)*100),'0.00')"/>%)
</xsl:when>
<xsl:otherwise>
(0%)
</xsl:otherwise>
</xsl:choose>
</font>
</td>
<td><font color="{$modarticlecolour}" size="2"><xsl:apply-templates select="ARTICLEPASSED"/></font></td>
<td><font color="{$modarticlecolour}" size="2"><xsl:apply-templates select="ARTICLEFAILED"/></font></td>
<td><font color="{$modarticlecolour}" size="2"><xsl:apply-templates select="ARTICLEREFERRED"/></font></td>
<td><font color="{$modarticlecolour}" size="2"><xsl:apply-templates select="ARTICLECOMPLAINT"/></font></td>
</tr>
<tr>
<td><font color="{$modgeneralcolour}" size="2"><xsl:value-of select="GENERALTOTAL"/>
<xsl:choose>
<xsl:when test="$generaltotal &gt; 0">
(<xsl:value-of select="round((GENERALTOTAL div $generaltotal)*100)"/>%)
</xsl:when>
<xsl:otherwise>
(0%)
</xsl:otherwise>
</xsl:choose>
</font>
</td>
<td><font color="{$modgeneralcolour}" size="2"><xsl:apply-templates select="GENERALPASSED"/></font></td>
<td><font color="{$modgeneralcolour}" size="2"><xsl:apply-templates select="GENERALFAILED"/></font></td>
<td><font color="{$modgeneralcolour}" size="2"><xsl:apply-templates select="GENERALREFERRED"/></font></td>
</tr>

</xsl:template>

<xsl:template match="THREADPASSED|THREADFAILED|THREADREFERRED|THREADCOMPLAINT">
<xsl:choose>
<xsl:when test="number(preceding-sibling::THREADTOTAL) > 0">
<xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::THREADTOTAL)),'0.00')"/>%)
</xsl:when>
<xsl:otherwise>0 (0%)</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="ARTICLEPASSED|ARTICLEFAILED|ARTICLEREFERRED|ARTICLECOMPLAINT">
<xsl:choose>
<xsl:when test="number(preceding-sibling::ARTICLETOTAL) > 0">
<xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::ARTICLETOTAL)),'0.00')"/>%)
</xsl:when>
<xsl:otherwise>0 (0%)</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="GENERALPASSED|GENERALFAILED|GENERALREFERRED">
<xsl:choose>
<xsl:when test="number(preceding-sibling::GENERALTOTAL) > 0">
<xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::GENERALTOTAL)),'0.00')"/>%)
</xsl:when>
<xsl:otherwise>0 (0%)</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="createmodbillmonthlink">
<xsl:param name="offset">-1</xsl:param>
<a>
	<xsl:attribute name="href">
		<xsl:value-of select="$root"/><xsl:text>ModerationBilling?startdate=</xsl:text>
		<xsl:call-template name="generatedate">
		<xsl:with-param name="offset"><xsl:value-of select="number($offset)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:text>&amp;enddate=</xsl:text>
		<xsl:call-template name="generatedate">
		<xsl:with-param name="offset"><xsl:value-of select="number($offset)+1"/></xsl:with-param>
		</xsl:call-template>
<!--		<xsl:choose>
			<xsl:when test="/H2G2/DATE/@MONTH = 1">
				<xsl:value-of select="concat(number(/H2G2/DATE/@YEAR)-1,'-12-01')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(/H2G2/DATE/@YEAR,'-',number(/H2G2/DATE/@MONTH)-1,'-01')"/>
			</xsl:otherwise>
		</xsl:choose>
-->
	</xsl:attribute>
	<xsl:call-template name="generatemonth"><xsl:with-param name="offset"><xsl:value-of select="$offset"/></xsl:with-param></xsl:call-template>
</a>
</xsl:template>
<xsl:template name="generatedate">
<xsl:param name="offset">-1</xsl:param>
<xsl:choose>
	<xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
		<xsl:value-of select="concat(number(/H2G2/DATE/@YEAR)-1,'-',number(/H2G2/DATE/@MONTH)+12+number($offset),'-01')"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat(/H2G2/DATE/@YEAR,'-',number(/H2G2/DATE/@MONTH)+number($offset),'-01')"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="generatemonth">
<xsl:param name="offset">-1</xsl:param>
<xsl:variable name="monthcount">
<xsl:choose>
	<xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
		<xsl:value-of select="number(/H2G2/DATE/@MONTH)+12+number($offset)"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="number(/H2G2/DATE/@MONTH)+number($offset)"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
	<xsl:when test="$monthcount = 1">January </xsl:when>
	<xsl:when test="$monthcount = 2">February </xsl:when>
	<xsl:when test="$monthcount = 3">March </xsl:when>
	<xsl:when test="$monthcount = 4">April </xsl:when>
	<xsl:when test="$monthcount = 5">May </xsl:when>
	<xsl:when test="$monthcount = 6">June </xsl:when>
	<xsl:when test="$monthcount = 7">July </xsl:when>
	<xsl:when test="$monthcount = 8">August </xsl:when>
	<xsl:when test="$monthcount = 9">September </xsl:when>
	<xsl:when test="$monthcount = 10">October </xsl:when>
	<xsl:when test="$monthcount = 11">November </xsl:when>
	<xsl:when test="$monthcount = 12">December </xsl:when>
</xsl:choose>
<xsl:choose>
	<xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
		<xsl:value-of select="number(/H2G2/DATE/@YEAR)-1"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="number(/H2G2/DATE/@YEAR)"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>