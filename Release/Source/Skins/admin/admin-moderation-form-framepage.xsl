<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	template to match the frame that displays the moderation form in the bottom
	frame of a generalm moderation page
-->
	<xsl:template match='H2G2[@TYPE="MODERATION-FORM-FRAME"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 Moderation: Forum Postings</title>
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

function loadURLInDisplayFrame()
{
	var navName = navigator.appName;

	// can't get dumb-ass Netscape to work with this yet - Kim
	if (navName == 'Microsoft Internet Explorer')
	{
		// check the URL is not blank
		if (GeneralModerationForm.URL.value != '')
		{
			window.open(GeneralModerationForm.URL.value, 'ModerationDisplayFrame', 'status=1,resizable=1,scrollbars=1');
		}
	}
	else if (false)
	{
		if (window.document.forms[0].URL.value != '')
		{
			window.top.frames[0].location.replace(window.document.forms[0].URL.value);
		}
	}
	else
	{
		alert('Your browser is unable to load the page into the top frame. Please click on the link below to open it in a seperate window');
	}
	return true;
}

// stop hiding -->
				]]>
			</script>
		</head>
		<body bgColor="lightblue" onLoad="loadURLInDisplayFrame()">
			<div class="ModerationTools">
<!--				<h2 align="center">General Moderation</h2>-->
				<xsl:apply-templates select="/H2G2/GENERAL-MODERATION-FORM"/>
			</div>
		</body>
	</html>
</xsl:template>
<!--
	Template for the general moderation form
-->

<xsl:template match="GENERAL-MODERATION-FORM">
	<script language="JavaScript">
		<![CDATA[
			<!-- hide this script from non-javascript-enabled browsers
			function IsEmpty(str)
			{
				for (var i = 0; i < str.length; i++)
				{
					var ch = str.charCodeAt(i);
					if (ch > 32)
					{
						return false;
					}
				}

				return true;
			}

			function CheckGeneralModerationForm()
			{
				if (GeneralModerationForm.Decision.value == 2) //refer to
				{ 
					if (IsEmpty(GeneralModerationForm.notes.value))
					{
						alert('Notes box should be filled if the complaint is referred');
						GeneralModerationForm.notes.focus();
						return false;
					}
				}

				return true;
			}
			// stop hiding -->
		]]>
	</script>
	<xsl:if test="MESSAGE">
		<font face="Arial" size="2" color="black">
			<xsl:choose>
				<xsl:when test="MESSAGE/@TYPE = 'NONE-LOCKED'">
					<b>You currently have no complaints of this type allocated to you for moderation. Select a type and click 'Process' to be 
					allocated the next complaint of that type waiting to be moderated.</b>
					<br/>
				</xsl:when>
				<xsl:when test="MESSAGE/@TYPE = 'EMPTY-QUEUE'">
					<b>Currently there are no complaints of the specified type awaiting moderation.</b>
					<br/>
				</xsl:when>
				<xsl:when test="MESSAGE/@TYPE = 'NO-ARTICLE'">
					<b>You have no complaint allocated to you for moderation currently. Click on 'Process' below 
					to be allocated the next complaint requiring moderation.</b>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="MESSAGE"/></b>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</font>
	</xsl:if>
	<form action="{$root}ModerateGeneral" method="post" name="GeneralModerationForm" onSubmit="return CheckGeneralModerationForm()">
		<input type="hidden" name="URL"><xsl:attribute name="value"><xsl:value-of select="URL"/></xsl:attribute></input>
		<input type="hidden" name="ModID"><xsl:attribute name="value"><xsl:value-of select="MODERATION-ID"/></xsl:attribute></input>
		<input type="hidden" name="Referrals"><xsl:attribute name="value"><xsl:value-of select="@REFERRALS"/></xsl:attribute></input>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_newstyle']/VALUE = 1">
			<input type="hidden" name="newstyle" value="1"/>
		</xsl:if>
		<font face="Arial" size="2" color="black">
			<input type="hidden" name="ComplainantID" value="{COMPLAINANT-ID}"/>
			<input type="hidden" name="CorrespondenceEmail" value="{CORRESPONDENCE-EMAIL}"/>
			<table width="100%" border="0">
				<tr>
					<td valign="top" align="left" colspan="2" nowrap="nowrap">
						<font face="Arial" size="2" color="black">
							Complaint from 
							<xsl:choose>
								<xsl:when test="string-length(CORRESPONDENCE-EMAIL) > 0">
									<a href="mailto:{CORRESPONDENCE-EMAIL}"><xsl:value-of select="CORRESPONDENCE-EMAIL"/></a>
								</xsl:when>
								<xsl:when test="number(COMPLAINANT-ID) > 0">Researcher <a href="{$root}U{COMPLAINANT-ID}">U<xsl:value-of select="COMPLAINANT-ID"/></a></xsl:when>
								<xsl:otherwise>Anonymous Complainant</xsl:otherwise>
							</xsl:choose>
							 about page <a target="_blank" href="{URL}"><xsl:value-of select="substring(URL, 1, 50)"/></a>
						</font>
					</td>
					<td valign="top" align="left" rowspan="2" nowrap="nowrap">
						<font face="Arial" size="2" color="black">
							<a target="_top">
								<xsl:attribute name="href">Moderate<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_newstyle']/VALUE = 1">?newstyle=1</xsl:if></xsl:attribute>
								<xsl:text>Moderation Home Page</xsl:text>	
							</a>
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="left">
						<font face="Arial" size="2" color="black">
							<xsl:apply-templates select="SITEID" mode="showfrom_mod_offsite_line" />
						</font>
					</td>
				</tr>
				<tr>
					<td valign="top" align="left"><font face="Arial" size="2" color="black">Complaint:</font></td>
					<td valign="top" align="left"><font face="Arial" size="2" color="black">Notes:</font></td>
					<td valign="top" rowspan="2" align="left">
						<table>
							<tr>
								<td valign="top" align="left">
									<font face="Arial" size="2" color="black">
										<select name="Decision">
							<!--				<option value="0">No Decision</option>-->
											<option value="3" selected="selected">
												<xsl:value-of select="$m_modrejectgeneralcomplaint"/>
											</option>
											<option value="4">
												<xsl:value-of select="$m_modacceptgeneralcomplaint"/>
											</option>
											<option value="2">Refer</option>
										</select>
										<br/>
										<select name="ReferTo" onChange="javascript:if (selectedIndex != 0) Decision.selectedIndex = 2">
											<xsl:apply-templates select="/H2G2/REFEREE-LIST">
											<xsl:with-param name="SiteID" select="SITEID" />
											</xsl:apply-templates>
										</select>
									</font>
								</td>
							</tr>
							<tr>
								<td valign="top" align="left">
									<font face="Arial" size="2" color="black">
										<input type="submit" name="Next" value="Process" title="Process this Entry and then fetch the next one"/>
									</font>
								</td>
							</tr>
							<tr>
								<td valign="top" align="left">
									<font face="Arial" size="2" color="black">
										<input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process this Entry and go to Moderation Home"/>
									</font>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" align="left"></td>
				</tr>
				<tr>
					<td valign="top" align="left">
						<font face="Arial" size="2" color="black">
							<textarea name="ComplaintText" cols="45" rows="5" wrap="virtual"><xsl:value-of select="COMPLAINT-TEXT"/></textarea>
						</font>
					</td>
					<td valign="top" align="left">
						<font face="Arial" size="2" color="black">
							<textarea id="notes" cols="30" name="notes" rows="5" wrap="virtual"><xsl:value-of select="NOTES"/></textarea>
						</font>
					</td>
					<td></td>
				</tr>
			</table>
		</font>
	</form>
</xsl:template>
	
	<!-- This is a piece of old functionality that I have just copied from the way the skins used to work. It's very old legacy code but needed for general
		complaints in the old moderation system-->
<!--
	<xsl:template match='H2G2[@TYPE="REDIRECT-TARGET"]'>
	Generic:	Yes
	Purpose:	Use this to redirect to specified target frame.
-->
<xsl:template match="H2G2[@TYPE='REDIRECT-TARGET']">
	<HTML>
		<HEAD>
		</HEAD>
		<BODY ONLOAD="Anchor.click()" BGCOLOR="{$bgcolour}" TEXT="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" LINK="{$linkcolour}" VLINK="{$vlinkcolour}" ALINK="{$alinkcolour}">
			<FONT FACE="{$fontface}" SIZE="2">
				<A ID="Anchor">
					<xsl:attribute name="TARGET"><xsl:value-of select="//REDIRECT-TO-TARGET"/></xsl:attribute>
					<xsl:attribute name="HREF"><xsl:value-of select="//REDIRECT-TO"/></xsl:attribute>
					<xsl:value-of select="$m_clickifnotredirected"/>
				</A>
			</FONT>
		</BODY>
	</HTML>
</xsl:template>

</xsl:stylesheet>