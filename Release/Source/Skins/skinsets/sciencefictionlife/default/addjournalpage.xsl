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
	<xsl:with-param name="message">ADDJOURNAL_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
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
	
			<div class="generic-c">
			<xsl:call-template name="box.crumb">
				<xsl:with-param name="box.crumb.href" select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)" />
				<xsl:with-param name="box.crumb.value">my space</xsl:with-param>
				<xsl:with-param name="box.crumb.title">write a weblog entry</xsl:with-param>
			</xsl:call-template>
			</div>

			<xsl:call-template name="box.heading">
				<xsl:with-param name="box.heading.value" select="/H2G2/VIEWING-USER/USER/USERNAME" />
			</xsl:call-template>

			<!-- STEP1,2,3 -->
			<div class="generic-b">

			<xsl:choose>
			<xsl:when test="POSTJOURNALFORM/PREVIEWBODY">
				<table cellpadding="0" cellspacing="0" border="0">
				<tr><td>
					<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>step 2: preview your entry</strong></xsl:element><br />
					<xsl:element name="{$text.base}" use-attribute-sets="text.base">If you are happy with your weblog entry click "publish", otherwise edit it using the boxes below and click "preview" again.</xsl:element>
				</td>
				<td align="right">
				<a href="#edit"><xsl:element name="img" use-attribute-sets="anchor.edit" /></a><br /><a href="#publish"><xsl:element name="img" use-attribute-sets="anchor.publish" /></a>
				</td>
				</tr></table>					
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>step 1: write your entry</strong></xsl:element><br />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">Use the boxes below to write a weblog entry. A weblog is an online journal. Click "preview" to see how your entry will look.</xsl:element>
			</xsl:otherwise>
			</xsl:choose>
			</div>
	
		<!--<xsl:call-template name="postpremoderationmessage"/>-->
	
		<xsl:apply-templates select="." mode="c_journalformheader"/>
		<a name="edit"></a>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<!-- FORM HEADER -->
		<xsl:if test="PREVIEWBODY">
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your weblog entry</strong>
				</xsl:element>
			</div>
		</xsl:if>

		<div class="form-wrapper">		
		<xsl:apply-templates select="." mode="c_journalform"/>
		</div>

		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element><xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
			<xsl:attribute name="id">myspace-s-c</xsl:attribute>

			<!-- my intro tips heading -->
			<div class="myspace-r-a">
				<xsl:copy-of select="$myspace.tips.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints &amp; tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_addjournal" />
			<div class="useredit-u">
				<font size="1">
					<xsl:copy-of select="$m_UserEditWarning"/><br /><br />
					<xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
				</font>
			</div><xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
		</tr>
		</table>
		
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
	Use: Used if the header contains a warning
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
	<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:value-of select="$m_warningcolon"/>
		<xsl:value-of select="WARNING"/>
		</xsl:element>
	</div>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
	Use: Used if the header contains a preview
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
	<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			This is what your weblog entry will look like:<br /><br />
			<strong><xsl:value-of select="SUBJECT"/></strong><br />
			<xsl:apply-templates select="PREVIEWBODY"/>
		</xsl:element>
	</div>
	<br />
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

	<table cellspacing="0" cellpadding="0" border="0" width="390">
		<tr><td class="form-label">
		<xsl:copy-of select="$icon.step.one" />
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<label for="addjornal-subject">subject</label>
			</xsl:element>
		</td><td>	
			<xsl:apply-templates select="SUBJECT" mode="t_addjournalpage"/>
		</td></tr>
		<tr><td class="form-label" valign="top">
		<xsl:copy-of select="$icon.step.two" />
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<label for="addjornal-body">entry</label>
			</xsl:element>
		</td><td>	
			<xsl:apply-templates select="BODY" mode="t_addjournalpage"/>
		</td></tr>
		<tr><td>&nbsp;<a name="publish"></a></td><td>	
			<xsl:apply-templates select="." mode="t_previewbutton"/><xsl:apply-templates select="." mode="t_submitbutton"/>
		</td></tr>
	</table>
			
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
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage">
		<xsl:attribute name="id">addjournal-subject</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iBODY_t_addjournalpage"/>
	Use: Presentation attributes for the Journal Body <textarea> field
	 -->
	<xsl:attribute-set name="iBODY_t_addjournalpage">
		<xsl:attribute name="cols">30</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">VIRTUAL</xsl:attribute>
		<xsl:attribute name="id">addjournal-body</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_previewbutton"/>
	Use: Presentation attributes for the journal preview submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_previewbutton" use-attribute-sets="form.preview" />
<!--		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_previewjournal"/></xsl:attribute>
	</xsl:attribute-set>-->
	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_submitbutton"/>
	Use: Presentation attributes for the journal submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_submitbutton" use-attribute-sets="form.publish" />
	<!--xsl:attribute name="value"><xsl:value-of select="$m_storejournal"/></xsl:attribute>
	</xsl:attribute-set>-->
</xsl:stylesheet>
