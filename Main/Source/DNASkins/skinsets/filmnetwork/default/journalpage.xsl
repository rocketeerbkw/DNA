<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-journalpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="JOURNAL_MAINBODY">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="JOURNAL" mode="c_journalpage"/>
			<br/>
			<xsl:apply-templates select="JOURNAL" mode="c_prevjournalpage"/>
			<xsl:apply-templates select="JOURNAL" mode="c_nextjournalpage"/>
			<xsl:apply-templates select="JOURNAL" mode="t_userpagelinkjournalpage"/>
		</font>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					JOURNAL Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="JOURNAL" mode="r_journalpage">
	Use: Container for the JOURNAL object
	-->
	<xsl:template match="JOURNAL" mode="r_journalpage">
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_journalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNALPOSTS" mode="r_journalpage">
	Use: Container for the JOURNALPOSTS object
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_journalpage">
		<xsl:apply-templates select="POST" mode="c_journalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_journalpage">
	Use: Template for the POST object
	-->
	<xsl:template match="POST" mode="r_journalpage">
		<b><xsl:value-of select="SUBJECT"/></b>
		<br/>
		<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_journalpage"/>
		<br/>
		<xsl:apply-templates select="TEXT" mode="t_journalpage"/>
		<br/>
		<xsl:apply-templates select="LASTREPLY" mode="c_journalpage"/>
		<br/>
		<xsl:apply-templates select="@POSTID" mode="t_discusslinkjournalpage"/>
		<br/>
		<xsl:apply-templates select="@THREADID" mode="c_removelinkjournalpage"/>
		<br/><br/><div align="center" style="color:#999999;">------------------------------------------------------------------</div><br/><br/>
	</xsl:template>
	<!-- 
	<xsl:template match="LASTREPLY" mode="replies_journalpage">
	Use: Template for the LASTREPLY object if there are replies
	-->
	<xsl:template match="LASTREPLY" mode="replies_journalpage">
		<xsl:apply-templates select="@COUNT" mode="t_journalpage"/>
		<br/>
		<xsl:copy-of select="$m_lastreplyjournalpage"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="DATE" mode="t_journalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="LASTREPLY" mode="noreplies_journalpage">
	Use: Template for the LASTREPLY object if theere are no replies
	-->
	<xsl:template match="LASTREPLY" mode="noreplies_journalpage">
		<xsl:copy-of select="$m_norepliesjournalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
	Use: Template for the 'Remove the posts' link
	-->
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
	Use: Template for the 'Previous posts' link
	-->
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
	Use: Template for the 'Next posts' link
	-->
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
