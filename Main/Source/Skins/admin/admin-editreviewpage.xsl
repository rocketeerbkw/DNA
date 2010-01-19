<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:template name="EDITREVIEW_HEADER">
		<xsl:choose>
			<xsl:when test="EDITREVIEWFORM/BLANKFORM">
				<xsl:apply-templates mode="header" select=".">
				<xsl:with-param name="title"><xsl:value-of select="$m_addnewreviewforum_title"/></xsl:with-param>
			</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title"><xsl:value-of select="$m_editreviewtitle"/>
				</xsl:with-param>
			</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="EDITREVIEW_SUBJECT">
		<xsl:choose>
		<xsl:when test="EDITREVIEWFORM/BLANKFORM">
			<xsl:call-template name="SUBJECTHEADER">
				<xsl:with-param name="text"><xsl:value-of select="$m_addnewreviewforum_title"/></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="SUBJECTHEADER">
				<xsl:with-param name="text"><xsl:value-of select="$m_editreviewtitle"/></xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="EDITREVIEW_MAINBODY">
		<font xsl:use-attribute-sets="mainfont">
			<br/>
			<xsl:apply-templates select="/H2G2/EDITREVIEWFORM" />
			<br/>
		</font>
	</xsl:template>
	<xsl:template match="EDITREVIEWFORM">
<xsl:choose>
<xsl:when test="ERROR/@TYPE='NOEDIT'">
<xsl:value-of select="ERROR"/>
</xsl:when>
<xsl:when test="ERROR/@TYPE='BADPARAM'">
<xsl:value-of select="ERROR"/>
</xsl:when>
<xsl:when test="ERROR/@TYPE='UPDATE'">
<xsl:value-of select="ERROR"/>
</xsl:when>
<xsl:when test="ERROR/@TYPE='VIEW'">
<xsl:value-of select="ERROR"/>
</xsl:when>
<xsl:when test="ERROR">
<xsl:value-of select="ERROR"/>
</xsl:when>
<xsl:when test="SUCCESS/@TYPE='UPDATE'">
Updated Successfully! <br/>
(Changes may not appear instantly!)<p/>
</xsl:when>
<xsl:when test="SUCCESS/@TYPE='ADDNEW'">
Added Successfully! <br/>
Go back to the review using the link below or update details here <p/>
</xsl:when>
</xsl:choose>

<br/>
<table cellpadding="10">
<tr><td>
	<form name="EditReviewForm" method="post" action="{$root}EditReview">
				
				<input type="hidden" name="mode">
					<xsl:attribute name="value"><xsl:value-of select="/H2G2/@MODE"/></xsl:attribute>
				</input>
				<input type="hidden" name="id" value="{REVIEWFORUM/@ID}"/>
			<table>
				<tr>
				<td>Forum Name:</td>
				<td>
					<input type="text" name="name" value="{REVIEWFORUM/FORUMNAME}"/>
				</td>
				</tr>
				<tr>
					<td>URL Name:</td> 
					<td><input type="text" name="url" value="{REVIEWFORUM/URLFRIENDLYNAME}"/></td>
				</tr>
				<tr>
					<td>Recommendable: </td>
					<td>
						<input type="radio" name="recommend" value="1">
						<xsl:if test="REVIEWFORUM/RECOMMENDABLE=1">
						<xsl:attribute name="checked"/>
						</xsl:if>
						</input> Yes
						<input type="radio" name="recommend" value="0">
						<xsl:if test="not(REVIEWFORUM/RECOMMENDABLE=1)">
							<xsl:attribute name="checked"/>
						</xsl:if>
						</input> No
					</td>
				</tr>
				<tr>
					<td>Incubate Time: </td>
					<td>
							<input type="text" name="incubate" size="3" value="{REVIEWFORUM/INCUBATETIME}"/>
					</td>
				</tr>
				<tr>
					<td>Article ID:</td>
					<td>
						<input type="text" name="h2g2id" value="{REVIEWFORUM/H2G2ID}"/>
					</td>
				</tr>
			</table>				
				<xsl:choose>
					<xsl:when test="BLANKFORM">
					<input type="hidden" name="action" value="doaddnew"/>
					<input type="submit" value="Add"/>
					</xsl:when>
					<xsl:otherwise>
					<input type="hidden" name="action" value="update"/>
					<input type="submit" value="Update"/>
					</xsl:otherwise>
				</xsl:choose>	
				
	</form>
	<br/>
	<xsl:if test="REVIEWFORUM and REVIEWFORUM/@ID > 0">
		<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute>Go Back to the Review Forum '<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>'</A>
	</xsl:if>   

</td></tr></table>
</xsl:template>
</xsl:stylesheet>