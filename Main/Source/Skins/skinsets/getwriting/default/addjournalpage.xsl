<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addjournal.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="ADDJOURNAL_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">addjournalpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	<xsl:apply-templates select="POSTJOURNALUNREG" mode="c_addjournal"/>
	<xsl:apply-templates select="POSTJOURNALFORM" mode="c_addjournal"/>

	</xsl:template>
	<xsl:template match="POSTJOURNALUNREG" mode="r_addjournal">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					POSTJOURNALFORM Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POSTJOURNALFORM">
	Use: Container for the header (preview / warning / intro) and the actual form. May contain
	a post / pre moderation message
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_addjournal">


	<xsl:apply-templates select="." mode="c_journalformheader"/>
	
	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	


	<div class="PageContent">
	
	<div class="titleBarNavBgSmall">
	<div class="titleBarNav">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	WRITE YOUR JOURNAL
	</xsl:element>
	</div>
	</div>
<!-- 	<div>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	* =required field
	</xsl:element>
	</div> -->
	
	<div class="box2">
	<xsl:apply-templates select="." mode="c_journalform"/>
	</div>
	</div>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox"><xsl:copy-of select="$form.journal.tips" /></div>
	</xsl:element>
	<br/>
	
	
	</xsl:element>
	
	</tr>
	</xsl:element>
	<!-- end of table -->	

	</xsl:if><!-- removed for site pulldown -->

	</xsl:template>



	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
	Use: Used if the header contains a warning
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
		<xsl:value-of select="$m_warningcolon"/>
		<xsl:value-of select="WARNING"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
	Use: Used if the header contains a preview
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
	<table width="410"><tr><td>
	<div class="PageContent">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:value-of select="SUBJECT"/></strong>
		<!-- <xsl:value-of select="$m_soon"/> -->
		<br/>
		<xsl:value-of select="PREVIEWBODY"/>
	</xsl:element>
	</div>	
	</td></tr></table>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="intro">
	Use: Used if the header contains an intro
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderintro">
		<!-- <xsl:copy-of select="$m_journalintroUI"/> -->
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="Form">
	Use: container for the actual jornal posting form
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalform">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">TITLE</div>
			<xsl:apply-templates select="SUBJECT" mode="t_addjournalpage"/>
			<br/>
			<div class="headinggeneric">JOURNAL</div>
			<xsl:apply-templates select="BODY" mode="t_addjournalpage"/>
			<br/>
			<div>
			<xsl:apply-templates select="." mode="t_previewbutton"/><xsl:text> </xsl:text><xsl:apply-templates select="." mode="t_submitbutton"/>
			</div>
			</xsl:element>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fPOSTJOURNALFORM_r_journalform"/>
	Use: Presentation attributes for the journal submit <form> element
	        (may be required for JavaScript)
	 -->
	<xsl:attribute-set name="fPOSTJOURNALFORM_r_journalform"/>
	<!--
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage"/>
	Use: Presentation attributes for the Journal Subject <input> field
	 -->
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage"/>
	<!--
	<xsl:attribute-set name="iBODY_t_addjournalpage"/>
	Use: Presentation attributes for the Journal Body <textarea> field
	 -->
	<xsl:attribute-set name="iBODY_t_addjournalpage">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
		<xsl:attribute name="wrap">VIRTUAL</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_previewbutton"/>
	Use: Presentation attributes for the journal preview submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_previewbutton" use-attribute-sets="form.preview"/>

	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_submitbutton"/>
	Use: Presentation attributes for the journal submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_submitbutton" use-attribute-sets="form.publish"/>

</xsl:stylesheet>
