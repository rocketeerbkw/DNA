<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="TERMSFILTERADMIN_HEADER">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TERMSFILTERADMIN_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA - Terms Filter Admin
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="TERMSFILTERADMIN_SUBJECT">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TERMSFILTERADMIN_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
        Terms Filter Admin
      </xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="TERMSFILTERADMIN_CSS">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TERMSFILTERADMIN_CSS">
		<style type="text/css"> 
			@import "/dnaimages/boards/includes/fonts.css" ;
		</style>
		<link href="/dnaimages/adminsystem/includes/dna_admin.css" rel="stylesheet" type="text/css"/>
		<style type="text/css">
			#lhn {width: 190px; float:left;}
			#lhn {padding: 5px; margin:3px;}
			#lhn li.selected {background:#dddddd;}
			
			#mainArea {width:540px; float:left; padding: 5px; margin:3px; border-left: 1px solid #0000cc;}
			#mainArea th {width:200px;}
		</style>
	</xsl:template>
	<!--
=================================================
=================================================
	TERMSFILTERADMIN templates 
=================================================
=================================================
-->
	<xsl:variable name="modClassTerms">
		<xsl:choose>
			<xsl:when test="not(/H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID = 0)">
				<xsl:value-of select="/H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="TERMSFILTERADMIN_MAINBODY">
		<div id="topNav">
			<div id="bbcLogo">
				<img src="{$dnaAdminImgPrefix}/images/config_system/shared/bbc_logo.gif" alt="BBC"/>
			</div>
			<h1>DNA admin</h1>
		</div>
    
		<div style="width:770px; float:left;">
			<div id="subNav" style="background:#f4ebe4 url({$dnaAdminImgPrefix}/images/config_system/shared/icon_mod_man.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h2>Terms Filter Administration</h2>
				</div>
			</div>
      <div style="float:right;">
        <a href="termsfilteradmin?action=REFRESHCACHE&amp;modclassid={@CLASSID}" style="font-size:10pt" onclick="return confirm('Are you sure?\r\nThis will cause the live filters to be refreshed.');">Refresh Live Filter</a>
      </div>
			<ul id="lhn">
				<p style="margin-bottom:10px; color:#000000; font-weight:bold;">Moderation Classes</p>
				<xsl:apply-templates select="TERMSFILTERADMIN/MODERATION-CLASSES/MODERATION-CLASS" mode="lefthandNav_terms"/>
			</ul>
			<div id="mainArea">
        
				<xsl:apply-templates select="TERMSFILTERADMIN" mode="mainContent"/>
			</div>
      
		</div>
	</xsl:template>
	<xsl:template match="MODERATION-CLASS" mode="lefthandNav_terms">
		<li>
			<xsl:if test="($modClassTerms = @CLASSID)">
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
			<a href="{$root}termsfilteradmin?modclassid={@CLASSID}">
				<xsl:value-of select="NAME"/>
			</a>
		</li>
	</xsl:template>
	<xsl:template match="TERMSFILTERADMIN" mode="mainContent">
    <xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_update']/VALUE = 'yes'">
				<xsl:apply-templates select="TERMSFILTER-LISTS" mode="termsUpdate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="TERMSLIST" mode="termsList"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
 
	<xsl:template match="TERMSLIST" mode="termsList">

		<table>
			<thead>
				<tr>
					<th>Term</th>
					<th>Action</th>
					<th colspan="2">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
        <xsl:for-each select="TERM">
          <xsl:sort select="."/>
          <xsl:call-template name="TERMSFILTER"/>
        </xsl:for-each>
			</tbody>
		</table>
    <p>
        <a href="{$root}termsfilterimport?">Import More Terms</a>
    </p>
	</xsl:template>
  
	<xsl:template name="TERMSFILTER">
		<tr>
			<td>
				<xsl:value-of select="."/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@ACTION = 'Refer'">
						<p style="font-style:italic; color:#000000;">Send message to moderation</p>
					</xsl:when>
          <xsl:when test="@ACTION = 'ReEdit'">
            <p style="font-style:italic; color:#000000;">Ask user to re-edit word</p>
          </xsl:when>
					<xsl:otherwise>
						<p style="font-style:italic; color:#000000;">Take no action</p>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<a href="{$root}termsfilterimport?s_termid={@ID}&amp;modclassid={../@MODCLASSID}">edit</a>
			</td>
			<td>
        &nbsp;
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
