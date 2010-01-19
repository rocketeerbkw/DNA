<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-myconversationspopup.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MYCONVERSATIONS_MAINBODY">
		<xsl:apply-templates select="DATE" mode="t_markallread"/>
		<br/>
		<xsl:apply-templates select="POSTS" mode="c_myconversations"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTS" mode="r_myconversations">
	Use: Container for the post list and back and next links
	-->
	<xsl:template match="POSTS" mode="r_myconversations">
		<xsl:apply-templates select="POST-LIST/POST" mode="c_myconversations"/>
		<xsl:apply-templates select="POST-LIST" mode="c_back"/>
		<xsl:apply-templates select="POST-LIST" mode="c_next"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="read_myconversations">
	Use: Container for the posts marked 'Read'
	-->
	<xsl:template match="POST" mode="read_myconversations">
		Read!!
		<br/>
		<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="t_readmarker"/>
		<br/>
		<xsl:apply-templates select="." mode="t_markallabove"/>
		<br/>
		<xsl:apply-templates select="SITEID" mode="t_sitefrom"/>
		<br/>
		<xsl:apply-templates select="THREAD/@THREADID" mode="t_subject"/>
		<br/>
		<xsl:apply-templates select="." mode="t_lastuserpost"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="t_lastreply"/>
		<hr/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="unread_myconversations">
	Use: Container for the posts marked 'Unread'
	-->
	<xsl:template match="POST" mode="unread_myconversations">
		Unread!!
		<br/>
		<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="t_unreadmarker"/>
		<br/>
		<xsl:apply-templates select="." mode="t_markallabove"/>
		<br/>
		<xsl:apply-templates select="SITEID" mode="t_sitefrom"/>
		<br/>
		<xsl:apply-templates select="THREAD/@THREADID" mode="t_subject"/>
		<br/>
		<xsl:apply-templates select="." mode="t_lastuserpost"/>
		<br/>
		<xsl:apply-templates select="." mode="t_lastreply"/>
		<br/>
		<hr/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST-LIST" mode="r_back">
	Use: Back link
	-->
	<xsl:template match="POST-LIST" mode="r_back">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST-LIST" mode="r_next">
	Use: Next link
	-->
	<xsl:template match="POST-LIST" mode="r_next">
		<xsl:apply-imports/>
		<br/>
	</xsl:template> 
</xsl:stylesheet>
