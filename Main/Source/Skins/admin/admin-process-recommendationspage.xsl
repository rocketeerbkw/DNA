<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template match='H2G2[@TYPE="PROCESS-RECOMMENDATION"]'>
		<html>
			<head>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<title>Process Recommendation</title>
				<script language="JavaScript">
					<xsl:comment>
submit=0;
function submitAndRefreshParent(form)
{
	submit += 1;
	if (submit &gt; 1) { alert("Request is being processed, please be patient"); return false; }
	else
	{
		// submit the form, then wait a second and refresh the parent window, if any
		form.submit();
		if (window.opener != null)
		{
			window.setTimeout('window.opener.location.reload()', 1000);
		}
	}
}
//				</xsl:comment>
				</script>
			</head>
			<body xsl:use-attribute-sets="body">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="PROCESS-RECOMMENDATION-FORM"/>
				</font>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="PROCESS-RECOMMENDATION-FORM">
	<form name="ProcessRecommendationForm" method="post" action="{$root}ProcessRecommendation" onSubmit="submitAndRefreshParent(this)">
			<!--<input type="text" name="skin"/><br/>-->
			<input type="hidden" name="mode"><xsl:attribute name="value"><xsl:value-of select="/H2G2/@MODE"/></xsl:attribute></input>
			<!-- don't show the form if we have no details -->
			<xsl:if test="SUBMISSION/@SUCCESS=1">
				The recommendation has been accepted.
			</xsl:if>
			
			<xsl:if test="number(RECOMMENDATION-ID) &gt; 0">
				<input type="hidden" name="RecommendationID"><xsl:attribute name="value"><xsl:value-of select="number(RECOMMENDATION-ID)"/></xsl:attribute></input>
				<input type="hidden" name="h2g2ID"><xsl:attribute name="value"><xsl:value-of select="number(H2G2-ID)"/></xsl:attribute></input>
				<xsl:if test="number(H2G2-ID) != 0">
						<a target="_blank"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>A<xsl:value-of select="H2G2-ID"/></a>
						<xsl:text> : </xsl:text><b><xsl:value-of select="SUBJECT"/></b>
						<xsl:text> by </xsl:text><a href="mailto:{EDITOR/USER/EMAIL-ADDRESS}"><xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/></a>
					<br/><br/>
					<xsl:text>Recommended by </xsl:text>
					<xsl:apply-templates select="SCOUT/USER"/>
					<xsl:text> on </xsl:text>
					<xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
				</xsl:if>
				<br/><br/>
				Comments:<br/>
				<textarea name="Comments" wrap="virtual" cols="40" rows="5">
					<xsl:value-of select="COMMENTS"/>
				</textarea>
				<br/>
				<table>
				<tr>
				<td>
				<br/><b>Email to Scout</b><br/><br/>
				Email:
				<input type="text" name="ScoutEmail">
					<xsl:attribute name="value"><xsl:value-of select="SCOUT/USER/EMAIL-ADDRESS"/></xsl:attribute>
				</input><br/>
				Subject:
				<input type="text" name="ScoutEmailSubject" size="30">
					<xsl:attribute name="value">
						<xsl:value-of select="SCOUT-EMAIL/SUBJECT"/>
					</xsl:attribute>
				</input>
				<br/>
				Text:<br/>
				<textarea name="ScoutEmailText" wrap="virtual" cols="40" rows="10">
					<xsl:value-of select="SCOUT-EMAIL/TEXT"/>
				</textarea>
				</td>
				<td>
				<xsl:if test="FUNCTIONS/ACCEPT">
					<br/>
					<br/><b>Email to Author</b><br/><br/>
				Email:
				<input type="text" name="AuthorEmail">
					<xsl:attribute name="value"><xsl:value-of select="EDITOR/USER/EMAIL-ADDRESS"/></xsl:attribute>
				</input><br/>
					Subject:
					<input type="text" name="AuthorEmailSubject" size="30">
						<xsl:attribute name="value">
							<xsl:value-of select="AUTHOR-EMAIL/SUBJECT"/>
						</xsl:attribute>
					</input>
					<br/>
					Text:<br/>
					<textarea name="AuthorEmailText" wrap="virtual" cols="40" rows="10">
						<xsl:value-of select="AUTHOR-EMAIL/TEXT"/>
					</textarea>
				</xsl:if>
				<br/><br/>
				</td>
				</tr>
				</table>
			</xsl:if>
			<xsl:if test="FUNCTIONS/ACCEPT">
				<input type="submit" name="cmd" value="Accept"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="FUNCTIONS/REJECT">
				<input type="submit" name="cmd" value="Reject"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="FUNCTIONS/CANCEL">
				<input type="submit" value="Cancel" onClick="window.close()"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="FUNCTIONS/FETCH">
<!--
				<br/><br/>
				Fetch by ID: 
				<input type="text" name="FetchID"/>
				<input type="submit" name="cmd" value="Fetch"/>
-->
			</xsl:if>
	</form>
</xsl:template>
</xsl:stylesheet>