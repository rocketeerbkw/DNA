<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="MESSAGEBOARDTRANSFER_JAVASCRIPT">
		
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDTRANSFER_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MESSAGEBOARDTRANSFER_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Board Transfer
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDTRANSFER_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MESSAGEBOARDTRANSFER_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Board Transfer
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MESSAGEBOARDTRANSFER_MAINBODY">
		<xsl:choose>
			<xsl:when test="@PAGE='OPTIONS'">
				<xsl:apply-templates select="MESSAGEBOARDTRANSFER" mode="options"/>
			</xsl:when>
			<xsl:when test="@PAGE='BACKUPOPTIONS'">
				<xsl:apply-templates select="MESSAGEBOARDTRANSFER" mode="backupOptions"/>
			</xsl:when>
			<xsl:when test="@PAGE='BACKUPRESULT'">
				<xsl:apply-templates select="MESSAGEBOARDTRANSFER" mode="backupResult"/>
			</xsl:when>
			<xsl:when test="@PAGE='RESTOREOPTIONS'">
				<xsl:apply-templates select="MESSAGEBOARDTRANSFER" mode="restoreOptions"/>
			</xsl:when>
			<xsl:when test="@PAGE='RESTORERESULT'">
				<xsl:apply-templates select="MESSAGEBOARDTRANSFER" mode="restoreResult"/>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="ERRORS/ERROR"/>
	</xsl:template>
	<!-- ***********************************
		MESSAGEBOARD TRANSFER SELECT OPTIONS!!!
	 *********************************** -->
	<xsl:template match="MESSAGEBOARDTRANSFER" mode="options">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_setup.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Message boards Transfer</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h2 class="adminFormHeader" style="margin:0px;">Choose your message boards transfer option</h2>
					<br/><br/><br/>					
					<div style="text-align:center;">
						<div class="buttonThreeD">
							<a href="mbtransfer?backup=1">Backup</a>
						</div>
						<div class="buttonThreeD">
							<a href="mbtransfer?restore=1">Restore</a>
						</div>
					</div>
				</div>
				<div class="footer">
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!-- ***********************************
		MESSAGEBOARD TRANSFER BACKUP!!!
	 *********************************** -->
	<xsl:template match="MESSAGEBOARDTRANSFER" mode="backupOptions">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_setup.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Message boards Transfer</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h2 class="adminFormHeader" style="margin:0px;">Back Up Message Board '<xsl:value-of select="SITE/SHORTNAME"/>'?</h2>
					<br/>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<form method="GET" action="mbtransfer">
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="mbtransfer">&lt;&lt; Back to start</a>
							</div>
						</span>
						<input type="hidden" name="backup" value="1"/>
						<input type="submit" name="createbackupxml" value="Create backup XML &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
					</form>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="MESSAGEBOARDTRANSFER" mode="backupResult">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_setup.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Message boards Transfer</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h2 class="adminFormHeader" style="margin:0px;">Back Up Message Board '<xsl:value-of select="SITE/SHORTNAME"/>'</h2>
					<br/>
					<br/>
	Cut and paste the XML below into the Restore tool on the destination site<br/>
					<br/>
					<textarea readonly="1" cols="60" rows="20" class="inputBG">
						<xsl:value-of select="BACKUPTEXT"/>
					</textarea>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="mbtransfer">&lt;&lt; Back to start</a>
						</div>
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="mbtransfer?restore=1">Go to restore tool &gt;&gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!-- ***********************************
		MESSAGEBOARD TRANSFER RESTORE!!!
	 *********************************** -->
	<xsl:template match="MESSAGEBOARDTRANSFER" mode="restoreOptions">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_setup.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Message boards Transfer</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h2 class="adminFormHeader" style="margin:0px;">Restore Message Board '<xsl:value-of select="SITE/SHORTNAME"/>'</h2>
					<br/>
					<form method="POST" action="mbtransfer">
						<br/>
						<input type="hidden" name="restore" value="1"/>
						<span class="adminText">Paste your restore XML into here:</span>
						<br/>
						<textarea cols="60" rows="20" name="restoreXML"/>
						<br/>
						<br/>
						<xsl:apply-templates select="GROUP[@NAME='Editor']"/>
						<br/>
						<br/>
						<input type="submit" name="restorebackupxml" value="Restore from backup XML" class="buttonThreeD" style="margin-left:250px;"/>
					</form>
					<br/>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="mbtransfer">&lt;&lt; Back to start</a>
						</div>
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="mbtransfer?backup=1">Go to backup tool &gt;&gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="MESSAGEBOARDTRANSFER/GROUP[@NAME='Editor']">
		<span class="adminText">Choose an editor that will become the owner of the created items:</span><br />
		<select name="editor">
			<xsl:apply-templates select="MEMBER"/>
		</select>
		<br/>
	</xsl:template>
	<xsl:template match="MESSAGEBOARDTRANSFER/GROUP/MEMBER">
		<option value="{ID}">
			<xsl:value-of select="USERNAME"/> (<xsl:value-of select="ID"/>)</option>
	</xsl:template>
	<xsl:template match="MESSAGEBOARDTRANSFER" mode="restoreResult">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_setup.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Message boards Transfer</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h2 class="adminFormHeader" style="margin:0px;">Restore Result:</h2>
					<br/><br/>
					<xsl:apply-templates select="ERROR" mode="siteconfig"/>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="mbtransfer">&lt;&lt; Back to start</a>
						</div>
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="mbtransfer?backup=1">Go to backup tool &gt;&gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
