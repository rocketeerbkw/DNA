<?xml version="1.0"  encoding='iso-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xmr-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

	<xsl:variable name="mr-userid">
		<xsl:value-of select="/H2G2/MOREROUTES/@USERID"/>
	</xsl:variable>

	<xsl:template name="MOREROUTES_TITLE">
		<title>
			Routes for <!-- <xsl:value-of select="/H2G2/MOREROUTES/ROUTES-LIST/USER/USERNAME"/> -->
			<xsl:apply-templates select="/H2G2/MOREROUTES/ROUTES-LIST/USER" mode="username" />
		</title>
	</xsl:template>
	
	<xsl:template name="MOREROUTES_BAR">
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
									Routes for <!-- <xsl:value-of select="/H2G2/MOREROUTES/ROUTES-LIST/USER/USERNAME"/> -->
									<xsl:apply-templates select="/H2G2/MOREROUTES/ROUTES-LIST/USER" mode="username" />
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

	<xsl:template name="MOREROUTES_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				More Routes
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="MOREROUTES_MAINBODY">
		<!--<xsl:apply-templates select="/H2G2" mode="mr-navbar"/>-->
		<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
		<xsl:apply-templates select="/H2G2/MOREROUTES/ACTIONRESULT" mode="mr-action"/>
		<xsl:apply-templates select="/H2G2/MOREROUTES/ROUTES-LIST" mode="routes-table"/>
		<xsl:apply-templates select="/H2G2/MOREROUTES/ROUTES-LIST" mode="previousnext"/>
	</xsl:template>

	<xsl:template match="ROUTES-LIST" mode="previousnext">
		<div class="moreroutes">
				<xsl:if test="@SKIP &gt; 0">
					<a href="{$root}ML{$mr-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
				</xsl:if>
				<xsl:if test="@MORE=1">
					<a href="{$root}ML{$mr-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
				</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="ROUTES-LIST" mode="routes-table">
		<div class="moreroutes">
			<table>
				<xsl:if test="$ownerisviewer=1">
					<col class="mr-action"/>
				</xsl:if>
				<col class="mr-routeid"/>
				<col class="mr-dnauid"/>
				<col class="mr-routetype"/>
				<col class="mr-routedescription"/>
				<tr>
					<xsl:if test="$ownerisviewer=1">
						<th>Action</th>
					</xsl:if>
					<th>ID</th>
					<th>Link</th>
					<th>Type</th>
					<th>Description</th>
				</tr>
				<xsl:apply-templates select="ROUTE" mode="routes-table"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="H2G2" mode="mr-navbar">
		<ul class="mr-navbar">
			<li>
				<xsl:if test="@TYPE='MOREROUTES'">
					<xsl:attribute name="class">mr-navselected</xsl:attribute>
				</xsl:if>
				<a href="{$root}MR{$mr-userid}">Routes</a>
			</li>
		</ul>
	</xsl:template>
	
	<xsl:template match="ERROR" mode="errormessage">
		<p>
			<xsl:value-of select="@TYPE"/> -
			<xsl:value-of select="ERRORMESSAGE"/>
		</p>
	</xsl:template>
	
	<xsl:template match="ACTIONRESULT" mode="mr-action">
		<div class="mr-actionresult">
			<xsl:choose>
				<xsl:when test="@ACTION='delete'">
					<p>
						You have removed the following <xsl:choose>
							<xsl:when test="count(ROUTE) &gt; 1">routes</xsl:when>
							<xsl:otherwise>route</xsl:otherwise>
						</xsl:choose> from your routes list:
					</p>
					<div class="routes">
						<table>
							<col class="mr-userid"/>
							<col class="mr-username"/>
							<tr>
								<th>ID</th>
								<th>Link</th>
								<th>Type</th>
								<th>Description</th>
							</tr>
							<xsl:apply-templates select="ROUTE" mode="mr-route-actions"/>
						</table>
					</div>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="ROUTE" mode="mr-route-actions">
		<tr>
			<td>
				<xsl:value-of select="@ROUTEID"/>
			</td>
			<td>
				<a href="{$root}{@DNAUID}">
					<xsl:value-of select="@DNAUID"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="@TYPE"/>
			</td>
			<td>
				<xsl:value-of select="DESCRIPTION"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="ROUTE" mode="routes-table">
		<tr>
			<xsl:if test="$ownerisviewer=1">
				<td>
					<a href="{$root}MR{$mr-userid}?routeid={@ROUTEID}&amp;dnaaction=delete">delete</a>
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@ROUTEID"/>
			</td>
			<td>
				<a href="{$root}{@DNAUID}">
					<xsl:value-of select="@DNAUID"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="@TYPE"/>
			</td>
			<td>
				<xsl:value-of select="DESCRIPTION"/>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
