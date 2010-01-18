<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:template name="SUB-ALLOCATION_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">Allocate Recommended Entries to Sub Editors</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SUB-ALLOCATION_MAINBODY">
		<table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" valign="top" width="75%">
					<br/>
					<font face="{$fontface}" color="{$mainfontcolour}">
						<!-- put the rest inside a table to give it some space around the borders -->
						<table width="100%" cellpadding="2" cellspacing="2" border="0">
							<tr valign="top">
								<td>
									<!-- now for the main part of the page -->
									<!-- the whole thing is one big form -->
									<xsl:apply-templates select="SUB-ALLOCATION-FORM"/>
								</td>
							</tr>
						</table>
						<br clear="all"/>
					</font>
				</td>
				<td width="25%" align="left" valign="top">
					<xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	Template for the SUB-ALLOCATION-FORM used to allocated
	recommended entries to sub editors
-->
	<xsl:template match="SUB-ALLOCATION-FORM">
	<!-- put in the javascript specific to this form -->
	<script language="javascript">
		<xsl:comment>
			submit = 0;
			function checkSubmit()
			{
				submit += 1;
				if (submit > 2) { alert("<xsl:value-of select="$m_donotpress"/>"); return (false); }
				if (submit > 1) { alert("<xsl:value-of select="$m_SubAllocationBeingProcessedPopup"/>"); return (false); }
				return (true);
			}

			function confirmAllocate(currentAllocations)
			{
				if (currentAllocations == 0 || confirm('This Sub still has some unreturned allocations, are you sure you wish to allocate more Entries to them?')) return (true);
				else return (false);
			}

			function allocate(subID)
			{
				if (checkSubmit())
				{
					document.forms.SubAllocationForm.Command.value = 'Allocate';
					document.forms.SubAllocationForm.SubID.value = subID;
					return (true);
				}
				else return (false);
			}

			function autoAllocate(subID, amount)
			{
				if (checkSubmit())
				{
					document.forms.SubAllocationForm.Command.value = 'AutoAllocate';
					document.forms.SubAllocationForm.SubID.value = subID;
					document.forms.SubAllocationForm.Amount.value = amount;
					return (true);
				}
				else return (false);
			}
			
			function deallocate()
			{
				if (checkSubmit())
				{
					document.forms.SubAllocationForm.Command.value = 'Deallocate';
					return (true);
				}
				else return (false);
			}

			function sendNotificationEmails()
			{
				if (checkSubmit())
				{
					document.forms.SubAllocationForm.Command.value = 'NotifySubs';
					return (true);
				}
				else return (false);
			}
	//	</xsl:comment>
	</script>
	<!-- first display any report messages and errors -->
	<!-- check for errors first and show them in the warning colour -->
	<font xsl:use-attribute-sets="WarningMessageFont">
		<xsl:for-each select="ERROR">
			<xsl:choose>
				<xsl:when test="@TYPE='NO-ENTRIES-SELECTED'">
					There were no entries selected to allocate
				</xsl:when>
				<xsl:when test="@TYPE='INVALID-SUBEDITOR-ID'">
					The Sub-Editor ID was invalid.
				</xsl:when>
				<xsl:when test="@TYPE='ZERO-AUTO-ALLOCATE'">
					Auto-Allocate was set to zero
				</xsl:when>
				<xsl:when test="@TYPE='EMAIL-FAILURE'">
					Auto-Allocate was set to zero
				</xsl:when>
				<xsl:otherwise>
					An unknown error occurred.
				</xsl:otherwise>
			</xsl:choose>
			<br/>
		</xsl:for-each>
	</font>
	<!-- show number successfully allocated -->
	<xsl:if test="SUCCESSFUL-ALLOCATIONS">
		<font xsl:use-attribute-sets="mainfont">
			Successfully allocated: <xsl:value-of select="SUCCESSFUL-ALLOCATIONS/@TOTAL"/><br/>
		</font>
	</xsl:if>
	<!-- show failed allocations in warning colour (probably red) if there are any -->
	<xsl:if test="FAILED-ALLOCATIONS">
		<xsl:choose>
			<xsl:when test="number(FAILED-ALLOCATIONS/@TOTAL) > 0">
				<font xsl:use-attribute-sets="WarningMessageFont">
					Failed to allocate: <xsl:value-of select="FAILED-ALLOCATIONS/@TOTAL"/><br/>
					<xsl:for-each select="FAILED-ALLOCATIONS/ALLOCATION">
						Entry: <a target="_blank"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="H2G2-ID"/></xsl:attribute><xsl:value-of select="SUBJECT"/></a>, was allocated to <xsl:apply-templates select="USER"/> on <xsl:apply-templates select="DATE-ALLOCATED/DATE" mode="short"/><br/>
					</xsl:for-each>
				</font>
			</xsl:when>
			<xsl:otherwise>
				<font xsl:use-attribute-sets="mainfont">
					Failed to allocate: <xsl:value-of select="FAILED-ALLOCATIONS/@TOTAL"/><br/>
				</font>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<!-- show number successfully deallocated -->
	<xsl:if test="SUCCESSFUL-DEALLOCATIONS">
		<font xsl:use-attribute-sets="mainfont">
			Successfully deallocated: <xsl:value-of select="SUCCESSFUL-DEALLOCATIONS/@TOTAL"/><br/>
		</font>
	</xsl:if>
	<!-- show failed deallocations in warning colour (probably red) if there are any -->
	<xsl:if test="FAILED-DEALLOCATIONS">
		<xsl:choose>
			<xsl:when test="number(FAILED-DEALLOCATIONS/@TOTAL) > 0">
				<font xsl:use-attribute-sets="WarningMessageFont">
					Failed to deallocate: <xsl:value-of select="FAILED-DEALLOCATIONS/@TOTAL"/><br/>
					<xsl:for-each select="FAILED-DEALLOCATIONS/DEALLOCATION">
						Entry: <a target="_blank"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="H2G2-ID"/></xsl:attribute><xsl:value-of select="SUBJECT"/></a>, was returned by <xsl:apply-templates select="USER"/> on <xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/><br/>
					</xsl:for-each>
				</font>
			</xsl:when>
			<xsl:otherwise>
				<font xsl:use-attribute-sets="mainfont">
					Failed to deallocate: <xsl:value-of select="FAILED-DEALLOCATIONS/@TOTAL"/><br/>
				</font>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="NOTIFICATIONS-SENT">
		<font xsl:use-attribute-sets="mainfont">Total notification emails sent to Subs: <xsl:value-of select="NOTIFICATIONS-SENT/@TOTAL"/></font><br/>
	</xsl:if>
	<!-- create the form HTML -->
	<form name="SubAllocationForm" method="post" action="{$root}AllocateSubs">
		<xsl:call-template name="skinfield"/>
		<input type="hidden" name="Command" value="Allocate"/>
		<input type="hidden" name="SubID" value="0"/>
		<input type="hidden" name="Amount" value="0"/>
		<font xsl:use-attribute-sets="mainfont">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr valign="top">
					<!-- left hand sidebar with subs listing -->
					<td width="100">
						<font xsl:use-attribute-sets="mainfont">
							<table border="0" cellspacing="2" cellpadding="0">
								<!-- put the heading in it's own row -->
								<tr>
									<td colspan="7" align="center"><font xsl:use-attribute-sets="mainfont"><font size="+1"><b>Sub Editors</b></font></font></td>
								</tr>
								<!-- put the send notifications button under the title -->
								<tr>
									<td colspan="7" align="center">
										<xsl:if test="number(UNNOTIFIED-SUBS) &gt; 0"><xsl:attribute name="bgcolor">red</xsl:attribute></xsl:if>
										<input type="submit" value="Send Notifications" onClick="sendNotificationEmails()"/>
									</td>
								</tr>
								<!-- now place the colum headings -->
								<tr valign="top">
									<td>
										<font xsl:use-attribute-sets="mainfont"><b>Sub</b></font>
									</td>
									<td>&nbsp;</td>
									<td>
										<font xsl:use-attribute-sets="mainfont"><b>Current</b></font>
									</td>
									<td>&nbsp;</td>
									<td align="center">
										<font xsl:use-attribute-sets="mainfont"><b>Notified</b></font>
									</td>
									<td>&nbsp;</td>
									<td align="center">
										<font xsl:use-attribute-sets="mainfont"><b>Allocate</b></font>
									</td>
								</tr>
								<!-- do the actual table contents -->
								<xsl:for-each select="SUB-EDITORS/USER-LIST/USER">
									<tr valign="top">
										<td>
											<font xsl:use-attribute-sets="mainfont">
												<a href="{$root}InspectUser?UserID={USERID}"><xsl:apply-templates select="USERNAME" mode="truncated"/></a>
											</font>
										</td>
										<td>&nbsp;</td>
										<td align="center">
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="ALLOCATIONS"/>
											</font>
										</td>
										<td>&nbsp;</td>
										<td align="center">
											<font xsl:use-attribute-sets="mainfont">
												<xsl:apply-templates select="DATE-LAST-NOTIFIED/DATE" mode="short"/>
											</font>
										</td>
										<td>&nbsp;</td>
										<td align="left" width="200">
											<font xsl:use-attribute-sets="mainfont">
												<input type="submit" value="Allocate" alt="{$alt_AllocateEntriesToThisSub}">
													<xsl:attribute name="id">AllocateButton<xsl:value-of select="USERID"/></xsl:attribute>
													<xsl:attribute name="onClick">if (confirmAllocate(<xsl:value-of select="ALLOCATIONS"/>)) allocate(<xsl:value-of select="USERID"/>); else (false)</xsl:attribute>
												</input>
												&nbsp;
												<input type="submit" alt="{$alt_AllocateEntriesToThisSub}">
													<xsl:attribute name="id">AutoAllocateButton<xsl:value-of select="USERID"/></xsl:attribute>
													<xsl:attribute name="onClick">if (confirmAllocate(<xsl:value-of select="ALLOCATIONS"/>)) autoAllocate(<xsl:value-of select="USERID"/>, <xsl:value-of select="SUB-QUOTA"/>); else (false)</xsl:attribute>
													<xsl:attribute name="value">Auto <xsl:value-of select="SUB-QUOTA"/></xsl:attribute>
												</input>
											</font>
										</td>
									</tr>
								</xsl:for-each>
							</table>
						</font>
					</td>
					<!-- central section with recommended articles
						 => two sections, top for unallocated, bottom for allocated recommendations
					-->
					<td valign="top">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<font xsl:use-attribute-sets="mainfont">
										<table border="0" cellspacing="2" cellpadding="0">
											<!-- put the heading in it's own row -->
											<tr>
												<td colspan="7" align="center"><font xsl:use-attribute-sets="mainfont"><font size="+1"><b>Recommendations Awaiting Allocation</b></font></font></td>
											</tr>
											<!-- and put a nice gap after it -->
											<tr>
												<td colspan="7">&nbsp;</td>
											</tr>
											<!-- now place the colum headings -->
											<tr valign="top">
												<td><font xsl:use-attribute-sets="mainfont"><b>ID</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Subject</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Author</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Selected</b></font></td>
											</tr>
											<!-- do the actual table contents -->
											<xsl:for-each select="UNALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/ARTICLE">
												<tr valign="top">
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}A{H2G2-ID}">A<xsl:value-of select="H2G2-ID"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}A{H2G2-ID}"><xsl:value-of select="SUBJECT"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}U{AUTHOR/USER/USERID}"><xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<input type="checkbox" name="EntryID">
																<xsl:attribute name="value"><xsl:value-of select="ENTRY-ID"/></xsl:attribute>
															</input>
														</font>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</font>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<font xsl:use-attribute-sets="mainfont">
										<table border="0" cellspacing="2" cellpadding="0">
											<!-- put the heading in it's own row -->
											<tr>
												<td colspan="11" align="center"><font xsl:use-attribute-sets="mainfont"><font size="+1"><b>Allocations Waiting to be Returned</b></font></font></td>
											</tr>
											<!-- and put a nice gap after it -->
											<tr>
												<td colspan="11">&nbsp;</td>
											</tr>
											<!-- now place the colum headings -->
											<tr valign="top">
												<td><font xsl:use-attribute-sets="mainfont"><b>ID</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Subject</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Author</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Sub</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Notified</b></font></td>
												<td>&nbsp;</td>
												<td><font xsl:use-attribute-sets="mainfont"><b>Deallocate</b></font></td>
											</tr>
											<!-- do the actual table contents -->
											<xsl:for-each select="ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/ARTICLE">
												<tr valign="top">
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}SubbedArticleStatus{H2G2-ID}">A<xsl:value-of select="H2G2-ID"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}A{H2G2-ID}"><xsl:value-of select="SUBJECT"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}U{AUTHOR/USER/USERID}"><xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<a target="_blank" href="{$root}InspectUser?UserID={SUBEDITOR/USER/USERID}"><xsl:apply-templates select="SUBEDITOR/USER/USERNAME" mode="truncated"/></a>
														</font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont"><xsl:choose><xsl:when test="NOTIFIED/text() = 1">Yes</xsl:when><xsl:otherwise>No</xsl:otherwise></xsl:choose></font>
													</td>
													<td>&nbsp;</td>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<input type="checkbox" name="DeallocateID">
																<xsl:attribute name="value"><xsl:value-of select="ENTRY-ID"/></xsl:attribute>
															</input>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td colspan="9">
												<font size="2">
												<xsl:if test="number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) &gt; 0">
												<A href="{$root}AllocateSubs?show={ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT}&amp;skip={number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) - number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT)}">Older allocations</A> | 
												</xsl:if>
												<xsl:if test="number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@MORE) = 1">
												<A href="{$root}AllocateSubs?show={ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT}&amp;skip={number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) + number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT)}">More recent entries</A>
												</xsl:if>
												</font>
												</td>
												<td colspan="2" align="right">
													<input type="submit" value="Deallocate" onClick="deallocate()"/>
												</td>
											</tr>
										</table>
									</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</font>
	</form>
</xsl:template>	

</xsl:stylesheet>