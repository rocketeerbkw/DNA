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

	<xsl:variable name="ml-userid">
		<xsl:value-of select="/H2G2/MORELINKS/@USERID"/>
	</xsl:variable>

	<xsl:template name="MORELINKS_TITLE">
		<title>
			Bookmarks for <xsl:value-of select="/H2G2/MORELINKS/LINKS-LIST/USER/USERNAME"/>
		</title>
	</xsl:template>
	
	<xsl:template name="MORELINKS_BAR">
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
									Bookmarks for <xsl:value-of select="/H2G2/MORELINKS/LINKS-LIST/USER/USERNAME"/>
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

	<xsl:template name="MORELINKS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				More Bookmarks
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="MORELINKS_MAINBODY">
		<!--<xsl:apply-templates select="/H2G2" mode="ml-navbar"/>-->
		<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
		<xsl:apply-templates select="/H2G2/MORELINKS/ACTIONRESULT" mode="ml-action"/>
		<xsl:apply-templates select="/H2G2/MORELINKS/LINKS-LIST" mode="links-table"/>
		<xsl:apply-templates select="/H2G2/MORELINKS/LINKS-LIST" mode="previousnext"/>
	</xsl:template>

	<xsl:template match="LINKS-LIST" mode="previousnext">
		<div class="morelinks">
				<xsl:if test="@SKIP &gt; 0">
					<a href="{$root}ML{$ml-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
				</xsl:if>
				<xsl:if test="@MORE=1">
					<a href="{$root}ML{$ml-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
				</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="LINKS-LIST" mode="links-table">
		<div class="morelinks">
			<table>
				<xsl:if test="$ownerisviewer=1">
					<col class="ml-action"/>
				</xsl:if>
				<col class="ml-linkid"/>
				<col class="ml-dnauid"/>
				<col class="ml-linktype"/>
				<col class="ml-linkdescription"/>
				<tr>
					<xsl:if test="$ownerisviewer=1">
						<th>Action</th>
					</xsl:if>
					<th>ID</th>
					<th>Link</th>
					<th>Type</th>
					<th>Description</th>
				</tr>
				<xsl:apply-templates select="LINK" mode="links-table"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="H2G2" mode="ml-navbar">
		<ul class="ml-navbar">
			<li>
				<xsl:if test="@TYPE='MORELINKS'">
					<xsl:attribute name="class">ml-navselected</xsl:attribute>
				</xsl:if>
				<a href="{$root}ML{$ml-userid}">Bookmarks</a>
			</li>
		</ul>
	</xsl:template>
	
	<xsl:template match="ERROR" mode="errormessage">
		<p>
			<xsl:value-of select="@TYPE"/> -
			<xsl:value-of select="ERRORMESSAGE"/>
		</p>
	</xsl:template>
	
	<xsl:template match="ACTIONRESULT" mode="ml-action">
		<div class="ml-actionresult">
			<xsl:choose>
				<xsl:when test="@ACTION='delete'">
					<p>
						You have removed the following <xsl:choose>
							<xsl:when test="count(LINK) &gt; 1">bookmarks</xsl:when>
							<xsl:otherwise>bookmark</xsl:otherwise>
						</xsl:choose> from your bookmarks list:
					</p>
					<div class="links">
						<table>
							<col class="ml-userid"/>
							<col class="ml-username"/>
							<tr>
								<th>ID</th>
								<th>Link</th>
								<th>Type</th>
								<th>Description</th>
							</tr>
							<xsl:apply-templates select="LINK" mode="ml-link-actions"/>
						</table>
					</div>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="LINK" mode="ml-link-actions">
		<tr>
			<td>
				<xsl:value-of select="@LINKID"/>
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
	
	<xsl:template match="LINK" mode="links-table">
		<tr>
			<xsl:if test="$ownerisviewer=1">
				<td>
					<a href="{$root}ML{$ml-userid}?linkid={@LINKID}&amp;dnaaction=delete">delete</a>
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@LINKID"/>
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
