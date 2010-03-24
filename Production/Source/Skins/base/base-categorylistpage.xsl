<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="FRONTPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="CATEGORYLIST_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				page title
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="CATEGORYLIST" mode="c_categorylist">
		<xsl:apply-templates select="." mode="r_categorylist"/>
	</xsl:template>
	<xsl:template name="t_title">
		<table width="760" cellspacing="0" cellpadding="0" border="0" class="title-container">
			<tr>
				<td align="right" class="maintitle">
					<table width="750" cellspacing="0" cellpadding="3" border="0">
						<tr>
							<td>
								<font size="5">
									<strong>
										<xsl:choose>
											<xsl:when test="CATEGORYLISTNODES">
													Edit Category List
											</xsl:when>
											<xsl:otherwise>
													Category List Overview
											</xsl:otherwise>
										</xsl:choose>
									</strong>
								</font>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="t_content">
		<table width="100%" cellspacing="10" cellpadding="0" border="0" class="content">
			<tr>
				<td>
					<font size="2">
						<xsl:call-template name="ACTIONINFO">
							<xsl:with-param name="mode">
								<xsl:value-of select="@MODE"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:apply-templates select="CATEGORYLISTNODES"/>
						<xsl:apply-templates select="USERCATEGORYLISTS"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
		<xsl:template match="CATEGORYLISTNODES">
	Author:		Ki
	Context:      /H2G2
	Purpose:	Box edit
	-->
	<xsl:template match="CATEGORYLISTNODES">
		<b>Your box is called <b>
				<xsl:value-of select="DESCRIPTION"/>
			</b>
			<br/>
		Your box ID is <b>
				<xsl:value-of select="GUID"/>
			</b>
		</b>
		<br/>
		<br/>
		<xsl:if test="NODECOUNT > 0">
			<table width="100%" border="1" rules="rows" cellpadding="2">
				<xsl:for-each select="CATEGORY">
					<tr>
						<td align="left">
						Node ID:<xsl:value-of select="@NODEID"/> - <xsl:value-of select="DISPLAYNAME"/>
						</td>
						<td align="right">
							<font size="2">
								<a href="categorylist?cmd=remove&amp;id={../GUID}&amp;nodeid={@NODEID}">
									<b>Remove</b>
								</a>
							</font>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<br/>
		</xsl:if>
		<form name="rename" method="get" action="{$root}categorylist">
			<input type="hidden" name="id" value="{GUID}"/>
			<input type="hidden" name="cmd" value="rename"/>
		Rename Category:<textarea name="description" cols="50" rows="1"/>
			<input type="submit" value="Rename"/>
		</form>
		<font size="2">
			<a href="editcategory?catlistid={GUID}&amp;nodeid=2045">
				<b>Add Node</b>
			</a>
			<br/>
		</font>
		<br/>
		<font size="2">
			<a href="CategoryList?">
				<b>Back To Lists</b>
			</a>
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USERCATEGORYLISTS">
	Author:		Ki
	Context:      /H2G2
	Purpose:	Box overview
	-->
	<xsl:template match="USERCATEGORYLISTS">
	
	Hello, <a href="{$root}u{LIST/OWNER/USERID}">
			<xsl:value-of select="LIST/OWNER/USERNAME"/>
		</a>, these are your boxes.
		<br/>
		<xsl:for-each select="LIST">
			<table width="100%" border="0" rules="rows" cellpadding="10" class="list-content">
				<tr>
					<td align="left">
					<font size="2">
						<b>Box name: <xsl:value-of select="DESCRIPTION"/>
						</b>
						<br/>
					Box ID : <xsl:value-of select="GUID"/>
						<br/>
					Date Created: <xsl:value-of select="CREATEDDATE/DATE/@RELATIVE"/>
						<br/>
					Last Updated: <xsl:value-of select="LASTUPDATED/DATE/@RELATIVE"/>
						<br/>
					Number Of Nodes: <xsl:value-of select="CATEGORYLISTNODES/NODECOUNT"/>
						<br/>
						<br/>
					URL : <textarea name="URL" cols="55" rows="2" readonly="1">www.bbc.co.uk<xsl:value-of select="$root"/>fcl?id=<xsl:value-of select="GUID"/>
						</textarea>
					
					<ul>	
						<li><a href="fcl?id={GUID}">
								<b>View as Fast List</b>
							</a></li>
						<li><a href="categorylist?id={GUID}">
								<b>Edit List</b>
							</a></li>
							<li><a href="categorylist?id={GUID}&amp;cmd=delete">
							<b>Delete List</b>
							</a></li>
							
						</ul>
						</font>
					</td>
				</tr>
			</table>
		</xsl:for-each>
		<br/>
		<form name="create" method="get" action="{$root}categorylist">
			<input type="hidden" name="cmd" value="create"/>
		Create New List:<textarea name="description" cols="50" rows="1"/>
			<input type="submit" value="Create"/>
		</form>
		<br/>
	</xsl:template>
	<xsl:template name="ACTIONINFO">
		<xsl:param name="mode"/>
		<xsl:if test="$mode!='VIEW'">
			<br/>
			<font size="2">
				<b>
					<xsl:choose>
						<xsl:when test="$mode='ADD'">
							<xsl:choose>
								<xsl:when test="ERROR">
						Add Node failed - <xsl:value-of select="ERROR"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
						Added Node '<xsl:value-of select="ADDEDNODE/@NODEID"/>' To List '<xsl:value-of select="ADDEDNODE/@GUID"/>' OK!<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$mode='REMOVE'">
							<xsl:choose>
								<xsl:when test="ERROR">
						Remove Node failed - <xsl:value-of select="ERROR"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
						Removed Node '<xsl:value-of select="REMOVEDNODE/@NODEID"/>' From List '<xsl:value-of select="REMOVEDNODE/@GUID"/>' OK!<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$mode='DELETE'">
							<xsl:choose>
								<xsl:when test="ERROR">
						Delete Cat List Failed - <xsl:value-of select="ERROR"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
						Deleted List '<xsl:value-of select="DELETEDCATEGORYLIST/@GUID"/>' OK!<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$mode='CREATE'">
							<xsl:choose>
								<xsl:when test="ERROR">
						Create Cat List Failed - <xsl:value-of select="ERROR"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
						Created List '<xsl:value-of select="CREATEDCATEGORYLIST/@GUID"/>' OK!<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$mode='RENAME'">
							<xsl:choose>
								<xsl:when test="ERROR">
						Rename Cat List Failed - <xsl:value-of select="ERROR"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
						Renamed List '<xsl:value-of select="RENAMEDCATEGORYLIST/@GUID"/>' to '<xsl:value-of select="RENAMEDCATEGORYLIST/@DESCRIPTION"/>' OK!<br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</b>
			</font>
			<br/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
