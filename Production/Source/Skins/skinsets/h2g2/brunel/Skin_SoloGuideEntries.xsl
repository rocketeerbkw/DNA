<?xml version="1.0"  encoding='iso-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:local="#local-functions"
                xmlns:s="urn:schemas-microsoft-com:xml-data"
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

	<xsl:template name="SOLOGUIDEENTRIES_TITLE">
		<title>
			Users Solo Guide Entries Count
		</title>
	</xsl:template>

	<xsl:template name="SOLOGUIDEENTRIES_BAR">
		<xsl:call-template name="nuskin-homelinkbar">
			<xsl:with-param name="bardata">
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td width="14" rowspan="4">
							<img src="{$imagesource}t.gif" width="14" height="1" alt="" />
						</td>
						<td width="100%">
							<img src="{$imagesource}t.gif" width="611" height="30" alt="" />
						</td>
						<td width="14" rowspan="4">
							<img src="{$imagesource}t.gif" width="14" height="1" alt="" />
						</td>
					</tr>
					<tr>
						<td>
							<font xsl:use-attribute-sets="subheaderfont" class="postxt">
								<b>
									What is this
								</b>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<img src="{$imagesource}t.gif" width="1" height="5" alt="" />
						</td>
					</tr>
					<tr>
						<td>
							<img src="{$imagesource}t.gif" width="1" height="8" alt="" />
						</td>
					</tr>
				</table>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="SOLOGUIDEENTRIES_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Users Solo Guide Entries Count
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="SOLOGUIDEENTRIES_MAINBODY">
		<!--<xsl:apply-templates select="/H2G2" mode="ml-navbar"/>-->
		<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
		<xsl:apply-templates select="/H2G2/SOLOGUIDEENTRIES/SOLOUSERS" mode="solousers-table"/>
		<xsl:apply-templates select="/H2G2/SOLOGUIDEENTRIES" mode="previousnext"/>
	</xsl:template>

	<xsl:template match="SOLOGUIDEENTRIES" mode="previousnext">
		<div class="moreusers">
			<xsl:if test="@SKIP &gt; 0">
				<a href="{$root}SOLO?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
			</xsl:if>
			<xsl:if test="@MORE=1">
				<a href="{$root}SOLO?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="SOLOUSERS" mode="solousers-table">
		<div class="solousers">
			<table>
				<col class="solo-userid"/>
				<col class="solo-username"/>
				<col class="solo-count"/>
				<col class="solo-check"/>
				<tr>
					<th>User ID</th>
					<th>User Name</th>
					<th>Count</th>
					<xsl:if test="$test_IsEditor">
						<th>Check Groups</th>
					</xsl:if>
				</tr>
				<xsl:apply-templates select="SOLOUSER" mode="solouser-table"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="H2G2" mode="solo-navbar">
		<ul class="solo-navbar">
			<li>
				<xsl:if test="@TYPE='SOLOGUIDEENTRIES'">
					<xsl:attribute name="class">solo-navselected</xsl:attribute>
				</xsl:if>
				<a href="{$root}SOLO">Solo Guide Entry Counts</a>
			</li>
		</ul>
	</xsl:template>

	<xsl:template match="ERROR" mode="errormessage">
		<p>
			<xsl:value-of select="@TYPE"/> -
			<xsl:value-of select="ERRORMESSAGE"/>
		</p>
	</xsl:template>

	<xsl:template match="SOLOUSER" mode="solouser-table">
		<tr>
			<td>
				<a href="{$root}U{USER/USERID}">
					<xsl:value-of select="USER/USERID"/>
				</a>
			</td>
			<td>
				<xsl:apply-templates select="USER" mode="username" />
			</td>
			<td>
				<xsl:value-of select="ENTRY-COUNT"/>
			</td>
			<xsl:if test="$test_IsEditor">
				<td>
					<a href="{$root}SOLO?action=checkgroups&amp;userid={USER/USERID}">
						Check U<xsl:value-of select="USER/USERID"/>'s Prolific Scribe badge
					</a>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>

</xsl:stylesheet>
