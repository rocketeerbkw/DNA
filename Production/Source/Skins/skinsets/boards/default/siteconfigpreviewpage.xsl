<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-siteconfigpreviewpage.xsl"/>
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_CSS">
		<LINK TYPE="text/css" REL="stylesheet" HREF="/dnaimages/boards/includes/messageboards.css"/>
		<xsl:if test="string(/H2G2/SITECONFIG/CSSLOCATION)">
			<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/SITECONFIG/CSSLOCATION/node()}"/>
		</xsl:if>
		<style type="text/css"> 
			@import "/dnaimages/boards/includes/fonts.css" ;
		</style>
	</xsl:template>
		<!--
	*******************************************************************************************
	*******************************************************************************************
	The site config preview page is used to create many of the messageboard administration pages. It does this by using the 
	multi-stage mechanism to separate out the fields which appear on each page. This means that the xsl file is made up of 
	three sections. The first section covers the XML expression of the fields which the pages control. The second section is a 
	list of templates which can be called to create links to those form pages and the third part are the form pages themselves.
	
	The naming convention across these three sections means that the XML matching the link and the page all have the same 
	prefix before the underscore. So asset_fields works with asset_link and asset_page.
	
	In addition to these three different types of templates there are two pages generated from here which are simply lists of links. 
	These are assetselection_siteconfig and featureselection_siteconfig and found at the end of the page.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	SECTION ONE
	This collection of variables containing XML are used to describe the fields that the siteconfig system is used to set.
	
	There is one for each of the form pages so that validation can be assigned on a page by page basis.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:variable name="asset_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>						
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="barley_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>	
						<ELEMENT NAME='BARLEYVARIANT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
						<ELEMENT NAME='SITEHOME'></ELEMENT>
						<ELEMENT NAME='BLQ-NAV-COLOR'></ELEMENT>
						<ELEMENT NAME='BLQ-FOOTER-COLOR'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="board_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>						
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='BOARDROOT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="code_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>					
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="css_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>					
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'>a</ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="emoticon_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>						
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="external_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>	
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="extext_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>						
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="feature_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>				
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="image_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>					
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="linkpath_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>					
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="nav_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>						
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='PATHDEV'></ELEMENT>
						<ELEMENT NAME='PATHLIVE'></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="path_fields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='ASSETCOMPLAIN'></ELEMENT>
						<ELEMENT NAME='ASSETNEW'></ELEMENT>			
						<ELEMENT NAME='BARLEYVARIANT'></ELEMENT>
						<ELEMENT NAME='BARLEYSEARCHCOLOUR'></ELEMENT>
						<ELEMENT NAME='BOARDNAME'></ELEMENT>
						<ELEMENT NAME='BOARDROOT'></ELEMENT>
						<ELEMENT NAME='BOARDSSOLINK'></ELEMENT>
						<ELEMENT NAME='CODEBANNER'></ELEMENT>
						<ELEMENT NAME='CSSLOCATION'></ELEMENT>
						<ELEMENT NAME='EMOTICONLOCATION'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOME'></ELEMENT>
						<ELEMENT NAME='EXTERNALHOMEURL'></ELEMENT>
						<ELEMENT NAME='EXTEXTTITLE'></ELEMENT>
						<ELEMENT NAME='EXTEXTBODY'></ELEMENT>
						<ELEMENT NAME='EXTEXTPREVIEW'></ELEMENT>
						<ELEMENT NAME='FEATURESMILEYS'></ELEMENT>
						<ELEMENT NAME='IMAGEBANNER'></ELEMENT>
						<ELEMENT NAME='LINKPATH'></ELEMENT>
						<ELEMENT NAME='NAVCRUMB'></ELEMENT>
						<ELEMENT NAME='NAVLHN'></ELEMENT>
						<ELEMENT NAME='PATHDEV'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='PATHLIVE'><VALIDATE TYPE='EMPTY'/></ELEMENT>
						<ELEMENT NAME='PATHSSOTYPE'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
		<!--
	*******************************************************************************************
	*******************************************************************************************
	SECTION TWO
	This collection of templates can be called to provide links to the different forms.
	
	They accept a variety of parameters which can be used to set the return path (return), if the submit button has a class 
	(submitClass) and w text is used for the button (link).
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template name="asset_link">
		<xsl:param name="return"/>
		<xsl:param name="link">Asset names</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$asset_fields}"/>
			<input type="hidden" name="_msstage" value="0"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="dataFakeLink"/>
		</form>
	</xsl:template>
	<xsl:template name="barley_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Manage page template type...</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$barley_fields}"/>
			<input type="hidden" name="_msstage" value="1"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="board_link">
		<xsl:param name="return"/>
		<xsl:param name="link">Edit Board Settings</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$board_fields}"/>
			<input type="hidden" name="_msstage" value="2"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="link"/>
		</form>
	</xsl:template>
	<xsl:template name="code_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Banner Code</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$code_fields}"/>
			<input type="hidden" name="_msstage" value="3"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="css_link">
		<xsl:param name="return"/>
		<xsl:param name="link">CSS filename</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$css_fields}"/>
			<input type="hidden" name="_msstage" value="4"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="dataFakeLink"/>
		</form>
	</xsl:template>
	<xsl:template name="emoticon_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Edit Emoticon Location</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$extext_fields}"/>
			<input type="hidden" name="_msstage" value="5"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="external_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">External Homepage</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$extext_fields}"/>
			<input type="hidden" name="_msstage" value="6"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="extext_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Edit Explanatory Text</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$extext_fields}"/>
			<input type="hidden" name="_msstage" value="7"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="feature_link">
		<xsl:param name="return"/>
		<xsl:param name="link">Edit Features</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$feature_fields}"/>
			<input type="hidden" name="_msstage" value="8"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="dataFakeLink"/>
		</form>
	</xsl:template>
	<xsl:template name="image_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Banner Image</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$image_fields}"/>
			<input type="hidden" name="_msstage" value="9"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="linkpath_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Edit link path...</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$linkpath_fields}"/>
			<input type="hidden" name="_msstage" value="10"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<xsl:template name="nav_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Manage site navigation...</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$nav_fields}"/>
			<input type="hidden" name="_msstage" value="11"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
		</form>
	</xsl:template>
	<xsl:template name="path_link">
		<xsl:param name="submitClass">link</xsl:param>
		<xsl:param name="return"/>
		<xsl:param name="link">Edit Paths</xsl:param>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_finishreturnto" value="{$return}"/>
			<input type="hidden" name="_msxml" value="{$path_fields}"/>
			<input type="hidden" name="_msstage" value="12"/>
			<input type="hidden" name="_msfinish" value="no"/>
			<input type="submit" value="{$link}" class="{$submitClass}"/>
		</form>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SITECONFIGPREVIEW-EDITOR_MAINBODY">
		<xsl:if test="$test_IsEditor = 1">
			<!--<xsl:apply-templates select="SITECONFIG-EDIT" mode="errors"/>-->
			<xsl:apply-templates select="SITECONFIG-EDIT" mode="siteconfig"/>
		</xsl:if>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	This main template uses the value of any s_view parameters or the @STAGE attribute in the page XML to decide which 
	form page you are presented with. Although there is a success page this is generally not used in the boards admin system
	as we make extensive use of the return paths to send users back to other pages. 
	
	This is also where the call to the error	popup lives. The template that it calls is contained in HTMLOutput.
	
	Following this template there is one with the mode initial_siteconfig which is what the user sees if they just use the 
	previewsiteconfig URL but this isn't actually used in the system and so this page is simply a list of the links. This page has 
	been	used as a shortcut for debugging in the past.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template match="SITECONFIG-EDIT" mode="siteconfig">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'features'">
				<xsl:apply-templates select="." mode="featureselection_siteconfig"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'assets'">
				<xsl:apply-templates select="." mode="assetselection_siteconfig"/>
			</xsl:when>
			<xsl:when test="not(MULTI-STAGE/MULTI-ELEMENT)">
				<xsl:apply-templates select="." mode="initial_siteconfig"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@FINISH = 'YES'">
				<xsl:apply-templates select="." mode="success_siteconfig"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 1">
				<xsl:apply-templates select="." mode="asset_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 2">
				<xsl:apply-templates select="." mode="barley_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 3">
				<xsl:apply-templates select="." mode="board_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 4">
				<xsl:apply-templates select="." mode="code_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 5">
				<xsl:apply-templates select="." mode="css_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 6">
				<xsl:apply-templates select="." mode="emoticon_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 7">
				<xsl:apply-templates select="." mode="external_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 8">
				<xsl:apply-templates select="." mode="extext_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 9">
				<xsl:apply-templates select="." mode="feature_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 10">
				<xsl:apply-templates select="." mode="image_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 11">
				<xsl:apply-templates select="." mode="linkpath_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 12">
				<xsl:apply-templates select="." mode="nav_page"/>
			</xsl:when>
			<xsl:when test="MULTI-STAGE/@STAGE = 13">
				<xsl:apply-templates select="." mode="path_page"/>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="error_popup"/>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="initial_siteconfig">
		<xsl:call-template name="asset_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="barley_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="board_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="code_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="css_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="emoticon_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="external_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="extext_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="feature_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="image_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="linkpath_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="nav_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
		<br/>
		<xsl:call-template name="path_link">
			<xsl:with-param name="return">previewsiteconfig?_previewmode=1</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	SECTION THREE
	This collection of templates are the ones which create the form pages themselves
	
	Each has a form for the submission of values for the fields that form is meant to control. There are also hidden inputs for 
	each of the other fields which pass any previously submitted information through the process without changing it.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template match="SITECONFIG-EDIT" mode="asset_page">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Asset management / Icons</h1>
			</div>
		</div>
		<div id="instructional">You can check and preview all of your icon <!--and emoticon -->assets in this area.</div>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="1"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$asset_fields}"/>
			<input type="hidden" name="s_returnto" value="previewsiteconfig?_previewmode=1&amp;s_view=assets"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<!--<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>-->
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h3 class="adminFormHeader">Icons</h3> &nbsp;<a href="/dnaimages/boards/standards_popup.html" target="_blank" onclick="openPreview('/dnaimages/boards/standards_popup.html', 600, 400); return false;" style="color:#333333;">View style guide for icons</a>
						<p><strong>Note: </strong> If you are using Vanilla skins, this icon will not be used. Please set your Complain image using CSS.</p>
						<br/>
						<br/>
						<p>'Complain about this message' filename:</p>
						<input type="text" name="ASSETCOMPLAIN" style="width:300px;" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<div style="padding:5px; border:dashed #000000 1px; width: 39px;margin:5px 0px;">
							<img src="{$boardpath}images/{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}" width="29" height="20" alt="Complain"/>
						</div>
						<!--<p>'New Message' filename:</p>
						<input type="text" name="ASSETNEW" style="width:300px;" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<div style="padding:5px; border:dashed #000000 1px; width: 59px;margin:5px 0px;">
							<img src="{$boardpath}images/{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}" width="49" height="35" alt="New"/>
						</div>-->
						<br/>
						<input name="_mscancel" type="submit" value="Preview &gt; &gt;" class="buttonThreeD" style="margin-left:300px;"/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save asset settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="barley_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="2"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$barley_fields}"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<!--<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>-->
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / BBC Page Layout Template Settings</h1>
				</div>
			</div>
			<div id="instructional">
				<p>These settings allow you to choose the BBC Page Layout template to use and change the colour of the search box.</p>
      </div>
      <div id="vanilla-instructional">
        <p><strong>Important: </strong> If you are using Vanilla skins, these settings will not be used. <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE}">Click here</a> for layout options. </p>
      </div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">Layout template variant</h4>
						<p>The BBC Page Layout Template variant to be used on this board (see <a href="http://guidelines.gateway.bbc.co.uk/newmedia/standards/approved.html#barley">Guidelines</a> for full details)</p>
						<select name="BARLEYVARIANT" class="inputBG">
							<option value="none">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = ''">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								None
							</option>
							<option value="radio">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'radio'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								Radio
							</option>
							<option value="music">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'music'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								Music
							</option>
							<option value="schools">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'schools'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								Schools
							</option>
							<option value="kids">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'kids'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								Kids
							</option>
							<option value="cbeebies">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'cbeebies'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								CBeebies
							</option>
							<option value="international">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE = 'international'">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								International
							</option>
						</select>
						<br/>
						<br/>
						<h4 class="adminSubtitle">Search Box Colour</h4>
						<p>The hex value of the colour on the top right hand search box.  This should be consistent with the colour used in the rest of the site.</p>
						<input type="text" name="BARLEYSEARCHCOLOUR" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save page layout template settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="board_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="3"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$board_fields}"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<!--<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>-->
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Initial Board Settings</h1>
				</div>
			</div>
			<div id="instructional">
				<p>These settings are for use by the DNA team</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">Board Name</h4>
						<p>
							<em>A name for the board. It will appear on the browser window title and the breadcrumb trail</em>
							<br/>
							<input type="text" name="BOARDNAME" class="inputBG">
								<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE"/></xsl:attribute>
							</input>
						</p>
						<br/>
						<h4 class="adminSubtitle">Board URL</h4>
						<p>
							<em>The root URL the messageboard will be located at, ie ‘cult/’</em>
							<br/>
							http://www.bbc.co.uk/dna/
							<input type="text" name="BOARDROOT" class="inputBG">
								<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE"/></xsl:attribute>
							</input>
						</p>
						<br/>
						<h4 class="adminSubtitle">Board SSO Link</h4>
						<p>
							<em>The Service ID link used for the messageboard’s SSO service. This will usually be the same as the board name.</em>
							<br/>
							<input type="text" name="BOARDSSOLINK" class="inputBG">
								<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE"/></xsl:attribute>
							</input>
						</p>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="code_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="4"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$code_fields}"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<!--<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>-->
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Create banner HTML</h1>
				</div>
			</div>
			<div id="instructional">
				<p>You can create an HTML banner and paste it in here.</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">Banner HTML</h4>
						<p><strong>Note: </strong> If you are using Vanilla skins, this banner will not be used. Please set your banner using CSS.</p>
						<textarea rows="10" cols="80" name="CODEBANNER" class="inputBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE"/>
						</textarea>
						<br/>
						<input name="_mscancel" type="submit" value="Preview &gt; &gt;" class="buttonThreeD" style="float:right;margin:10px 60px 10px 10px;"/>
						<br/>
						<br/>
						<br/>
						<div style="padding:5px; border:dashed #000000 1px; width: 655px">
							<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE"/>
						</div>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save banner HTML &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="css_page">
		<form action="{$root}previewsiteconfig" method="post">
      <input type="hidden" name="siteid" value="{/H2G2/CURRENTSITE}"/>
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="5"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$css_fields}"/>
			<input type="hidden" name="s_returnto" value="previewsiteconfig?_previewmode=1&amp;s_view=assets"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<!--<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>-->
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / CSS File</h1>
				</div>
			</div>
			<div id="instructional">
				<p>You can check and preview the CSS file.</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">CSS File</h4>
						<br/>
						<div>
              <p><strong>Some notes about the CSS files in Vanilla skins</strong></p>
              <p>In the new Vanilla skins, the CSS file handles all styling and page layout. Thesefore this file will be radically different from the CSS files you used previously.</p>
              <p>All "base" layout styles are contained in <em>generic.css</em>, which is part of DNA and included in all messageboard skins. You may override any styles in generic.css using CSS inheritance.</p>
						</div>
						<p>Filename:</p>
						<input type="text" name="CSSLOCATION" class="inputBG" size="70">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE"/></xsl:attribute>
						</input> &nbsp;
						<!--<span class="buttonThreeD">
							<a href="{$root}F{/H2G2/TOPICLIST/TOPIC/FORUMID}?_previewmode=1" target="_blank">Launch full preview</a>
						</span>-->
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{$root}previewsiteconfig?_previewmode=1&amp;{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save CSS file settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="emoticon_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="6"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$emoticon_fields}"/>
			<input type="hidden" name="s_returnto" value="previewsiteconfig?_previewmode=1&amp;s_view=assets"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<!--<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>-->
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Emoticon Images</h1>
				</div>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<p>Emoticons are currently switched 
							<xsl:choose>
								<xsl:when test="/H2G2/SITECONFIG/FEATURESMILEYS = 1">
									<xsl:text> on.</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text> off.</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							(<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=features">change this</a>)
						</p>
						<input type="radio" name="EMOTICONLOCATION" value="0">
							<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE = 0">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						Use default icons
						<br/>
						<input type="radio" name="EMOTICONLOCATION" value="1">
							<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						Use own icons (these should be located in your assets directory in images/emoticons).
						<div style="padding:5px; margin:5px 0px;">
							<xsl:variable name="previewsmileysource">
								<xsl:choose>
									<xsl:when test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE = 1">
										<xsl:value-of select="$imagesource"/>
										<xsl:text>emoticons/</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>/dnaimages/boards/images/emoticons/</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<table cellpadding="5" cellspacing="5" style="border: 1px #000000 dotted;" width="370">
								<tr>
									<td>
										<p>Hug</p>
										<img src="{$previewsmileysource}f_hug.gif" alt="Hug Emoticon"/>
									</td>
									<td>
										<p>Laugh</p>
										<img src="{$previewsmileysource}f_laugh.gif" alt="Laugh Emoticon"/>
									</td>
									<td>
										<p>OK</p>
										<img src="{$previewsmileysource}f_ok.gif" alt="Okay Emoticon"/>
									</td>
									<td>
										<p>Smooch</p>
										<img src="{$previewsmileysource}f_smooch.gif" alt="Smooch Emoticon"/>
									</td>
									<td>
										<p>Whistle</p>
										<img src="{$previewsmileysource}f_whistle.gif" alt="Whistle Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Peace Dove</p>
										<img src="{$previewsmileysource}f_peacedove.gif" alt="Peace Dove Emoticon"/>
									</td>
									<td>
										<p>Star</p>
										<img src="{$previewsmileysource}f_star.gif" alt="Star Emoticon"/>
									</td>
									<td>
										<p>Ale</p>
										<img src="{$previewsmileysource}f_ale.gif" alt="Ale Emoticon"/>
									</td>
									<td>
										<p>Bubbly</p>
										<img src="{$previewsmileysource}f_bubbly.gif" alt="Bubbly Emoticon"/>
									</td>
									<td>
										<p>Big Grin</p>
										<img src="{$previewsmileysource}f_biggrin.gif" alt="Big Grin Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Blush</p>
										<img src="{$previewsmileysource}f_blush.gif" alt="Blush Emoticon"/>
									</td>
									<td>
										<p>Cool</p>
										<img src="{$previewsmileysource}f_cool.gif" alt="Cool Emoticon"/>
									</td>
									<td>
										<p>Doh!</p>
										<img src="{$previewsmileysource}f_doh.gif" alt="Doh! Emoticon"/>
									</td>
									<td>
										<p>Erm</p>
										<img src="{$previewsmileysource}f_erm.gif" alt="Erm Emoticon"/>
									</td>
									<td>
										<p>Grr</p>
										<img src="{$previewsmileysource}f_grr.gif" alt="Grr Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Love Blush</p>
										<img src="{$previewsmileysource}f_loveblush.gif" alt="Love Blush Emoticon"/>
									</td>
									<td>
										<p>Sad</p>
										<img src="{$previewsmileysource}f_sadface.gif" alt="Sad Emoticon"/>
									</td>
									<td>
										<p>Smiley</p>
										<img src="{$previewsmileysource}f_smiley.gif" alt="Smiley Emoticon"/>
									</td>
									<td>
										<p>Steam</p>
										<img src="{$previewsmileysource}f_steam.gif" alt="Steam Emoticon"/>
									</td>
									<td>
										<p>Winking</p>
										<img src="{$previewsmileysource}f_winkeye.gif" alt="Winking Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Gift</p>
										<img src="{$previewsmileysource}f_gift.gif" alt="Gift Emoticon"/>
									</td>
									<td>
										<p>Rose</p>
										<img src="{$previewsmileysource}f_rose.gif" alt="Rose Emoticon"/>
									</td>
									<td>
										<p>Devil</p>
										<img src="{$previewsmileysource}f_devil.gif" alt="Devil Emoticon"/>
									</td>
									<td>
										<p>Magic</p>
										<img src="{$previewsmileysource}f_magic.gif" alt="Magic Emoticon"/>
									</td>
									<td>
										<p>Yikes!</p>
										<img src="{$previewsmileysource}f_yikes.gif" alt="Yikes Emoticon"/>
									</td>
								</tr>
							</table>
						</div>
						<br/>
						<input name="_mscancel" type="submit" value="Preview &gt; &gt;" class="buttonThreeD" style="margin-left:300px;"/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=assets">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save asset settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="external_page">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>External Homepage</h1>
			</div>
		</div>
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="7"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$external_fields}"/>
			<input type="hidden" name="s_returnto" value="messageboardadmin"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<!--<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>-->
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<p>External Homepage:</p>
						<p>Is this messageboard using a homepage external to the DNA system?</p>
						<input type="radio" name="EXTERNALHOME" value="0">
							<xsl:if test="not(MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE = 1)">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>&nbsp;No
						<br/>
						<input type="radio" name="EXTERNALHOME" value="1">
							<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>&nbsp;Yes
						<br/>
						<p>External Homepage URL:</p>
						<input type="text" name="EXTERNALHOMEURL" style="width:300px;" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save homepage settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="extext_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="8"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$extext_fields}"/>
			<input type="hidden" name="s_returnto">
				<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'messageboardadmin'">messageboardadmin?updatetype=8</xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</input>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<!--<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>-->
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Instructional Text</h1>
				</div>
			</div>
			<div id="instructional">
				<p>This instructional text appears on the page where users compose a new message or a reply</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">Discussion title text</h4>
						<p>
							<em>Change the text below to describe how to use the discussion title box</em>
							<br/>
							<input type="text" name="EXTEXTTITLE" class="inputBG" style="width:600px;">
								<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE/node()"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>Write a short snappy title to kick off a discussion. e.g. What's the best gig you've been to?</xsl:otherwise></xsl:choose></xsl:attribute>
							</input>
						</p>
						<h4 class="adminSubtitle">Message box text</h4>
						<p>
							<em>Change the text below to describe how to use the message box</em>
							<br/>
							<input type="text" name="EXTEXTBODY" class="inputBG" style="width:600px;">
								<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE/node()"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>To create paragraphs, just press Return on your keyboard when needed.</xsl:otherwise></xsl:choose></xsl:attribute>
							</input>
						</p>
						<h4 class="adminSubtitle">Preview text</h4>
						<p>
							<em>Change the text below to describe how to use the preview box</em>
							<br/>
							<input type="text" name="EXTEXTPREVIEW" class="inputBG" style="width:600px;">
								<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE/node()"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>If you are satisfied with your message, proceed by clicking on Post message.</xsl:otherwise></xsl:choose></xsl:attribute>
							</input>
						</p>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a>
									<xsl:attribute name="href"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'messageboardadmin'">messageboardadmin?updatetype=8</xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:otherwise></xsl:choose></xsl:attribute>
									&lt; &lt; Back
								</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save changes &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="feature_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="9"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$feature_fields}"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<!--<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>-->
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Feature Manager / Emoticons</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<p>Enabling emoticons will mean that text emoticons are replaced with graphic smilies - so, :-) will become <img src="http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/f_smiley.gif" height="16" width="16" alt=""/>.</p>
						<p>
							<input type="radio" name="FEATURESMILEYS" value="1">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE = 1">
									<xsl:attribute name="checked">yes</xsl:attribute>
								</xsl:if>
							</input>&nbsp;Yes
							<br/>
							<input type="radio" name="FEATURESMILEYS" value="0">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE = 0">
									<xsl:attribute name="checked">yes</xsl:attribute>
								</xsl:if>
							</input>&nbsp;No
						</p>
						<br/>
						<p>You are currently using these emoticons (<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=assets">Change this</a>):</p>
						<div style="padding:5px; margin:5px 0px;">
							<xsl:variable name="previewsmileysource">
								<xsl:choose>
									<xsl:when test="/H2G2/SITECONFIG/EMOTICONLOCATION = 1">
										<xsl:value-of select="$imagesource"/>
										<xsl:text>emoticons/</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>/dnaimages/boards/images/emoticons/</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<table cellpadding="5" cellspacing="5" style="border: 1px #000000 dotted;" width="370">
								<tr>
									<td>
										<p>Hug</p>
										<img src="{$previewsmileysource}f_hug.gif" alt="Hug Emoticon"/>
									</td>
									<td>
										<p>Laugh</p>
										<img src="{$previewsmileysource}f_laugh.gif" alt="Laugh Emoticon"/>
									</td>
									<td>
										<p>OK</p>
										<img src="{$previewsmileysource}f_ok.gif" alt="Okay Emoticon"/>
									</td>
									<td>
										<p>Smooch</p>
										<img src="{$previewsmileysource}f_smooch.gif" alt="Smooch Emoticon"/>
									</td>
									<td>
										<p>Whistle</p>
										<img src="{$previewsmileysource}f_whistle.gif" alt="Whistle Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Peace Dove</p>
										<img src="{$previewsmileysource}f_peacedove.gif" alt="Peace Dove Emoticon"/>
									</td>
									<td>
										<p>Star</p>
										<img src="{$previewsmileysource}f_star.gif" alt="Star Emoticon"/>
									</td>
									<td>
										<p>Ale</p>
										<img src="{$previewsmileysource}f_ale.gif" alt="Ale Emoticon"/>
									</td>
									<td>
										<p>Bubbly</p>
										<img src="{$previewsmileysource}f_bubbly.gif" alt="Bubbly Emoticon"/>
									</td>
									<td>
										<p>Big Grin</p>
										<img src="{$previewsmileysource}f_biggrin.gif" alt="Big Grin Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Blush</p>
										<img src="{$previewsmileysource}f_blush.gif" alt="Blush Emoticon"/>
									</td>
									<td>
										<p>Cool</p>
										<img src="{$previewsmileysource}f_cool.gif" alt="Cool Emoticon"/>
									</td>
									<td>
										<p>Doh!</p>
										<img src="{$previewsmileysource}f_doh.gif" alt="Doh! Emoticon"/>
									</td>
									<td>
										<p>Erm</p>
										<img src="{$previewsmileysource}f_erm.gif" alt="Erm Emoticon"/>
									</td>
									<td>
										<p>Grr</p>
										<img src="{$previewsmileysource}f_grr.gif" alt="Grr Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Love Blush</p>
										<img src="{$previewsmileysource}f_loveblush.gif" alt="Love Blush Emoticon"/>
									</td>
									<td>
										<p>Sad</p>
										<img src="{$previewsmileysource}f_sadface.gif" alt="Sad Emoticon"/>
									</td>
									<td>
										<p>Smiley</p>
										<img src="{$previewsmileysource}f_smiley.gif" alt="Smiley Emoticon"/>
									</td>
									<td>
										<p>Steam</p>
										<img src="{$previewsmileysource}f_steam.gif" alt="Steam Emoticon"/>
									</td>
									<td>
										<p>Winking</p>
										<img src="{$previewsmileysource}f_winkeye.gif" alt="Winking Emoticon"/>
									</td>
								</tr>
								<tr>
									<td>
										<p>Gift</p>
										<img src="{$previewsmileysource}f_gift.gif" alt="Gift Emoticon"/>
									</td>
									<td>
										<p>Rose</p>
										<img src="{$previewsmileysource}f_rose.gif" alt="Rose Emoticon"/>
									</td>
									<td>
										<p>Devil</p>
										<img src="{$previewsmileysource}f_devil.gif" alt="Devil Emoticon"/>
									</td>
									<td>
										<p>Magic</p>
										<img src="{$previewsmileysource}f_magic.gif" alt="Magic Emoticon"/>
									</td>
									<td>
										<p>Yikes!</p>
										<img src="{$previewsmileysource}f_yikes.gif" alt="Yikes Emoticon"/>
									</td>
								</tr>
							</table>
						</div>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save emoticon settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="image_page">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Asset Management / Banner</h1>
			</div>
		</div>
		<div id="instructional">
			<p>You can add a filename here, or create one in HTML</p>
		</div>
		<!--<div id="vanilla-instructional">
  		<p><strong>Important: </strong> If you are using Vanilla skins, these settings will not be used. <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE}">Click here</a> for layout options. </p>
		</div>-->
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<h4 class="adminSubtitle">Banner</h4>
					<p>
							Set the location for the banner to be used globally across all messageboard pages or <xsl:call-template name="code_link">
								<xsl:with-param name="link">create one in HTML</xsl:with-param>
								<xsl:with-param name="return">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/>
								</xsl:with-param>
								<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
							</xsl:call-template>
							<p><strong>Note: </strong> If you are using Vanilla skins, you may not code a banner in HTML. Please either use an image asset, or CSS.</p>
							<br/>
							Filename:  e.g. banner.gif
					</p>
					<form action="{$root}previewsiteconfig" method="post">
						<input type="hidden" name="_previewmode" value="1"/>
						<input type="hidden" name="action" value="update"/>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="_msstage" value="10"/>
						<input type="hidden" name="_msfinish" value="yes"/>
						<input type="hidden" name="_msxml" value="{$image_fields}"/>
						<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
						<!--Page 1 Asset-->
						<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
						<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
						<!--Page 2 Barley-->
						<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
						<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
						<!--Page 3 Board-->
						<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
						<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
						<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
						<!--Page 4 Banner Code-->
						<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
						<!--Page 5 CSS-->
						<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
						<!--Page 6 Emoticon Page-->
						<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
						<!--Page 7 External Home Page-->
						<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
						<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
						<!--Page 8 ExText-->
						<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
						<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
						<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
						<!--Page 9 Feature-->
						<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
						<!--Page 10 Banner Image-->
						<!--<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>-->
						<!--Page 11 Link Path-->
						<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
						<!--Page 12 Nav-->
						<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
						<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
						<!--Page 13 Path-->
						<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
						<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
						<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
						<input type="text" name="IMAGEBANNER" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<div style="padding:5px; border:dashed #000000 1px; width: 655px">
							<img src="{$boardpath}images/{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}" width="645" height="50" alt="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE} Board"/>
						</div>
						<br/>
						<input name="_mscancel" type="submit" value="Preview &gt; &gt;" class="buttonThreeD" style="margin-left:530px;"/>
						<br/>
						<div class="shadedDivider" style="width:720px;margin:0px;">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save banner settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput" style="margin-right:40px;"/>
						<br/>
						<br/>
					</form>
				</div>
				<div class="footer">
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="linkpath_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="11"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$linkpath_fields}"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<!--<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>-->
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Homepage / Edit Link Path</h1>
				</div>
			</div>
			<div id="instructional">
				<p>The link path will appear at the top of all page on the messageboard, but you can choose to switch it off on the messageboard homepage.</p>
			</div>
			<div id="vanilla-instructional">
  			<p><strong>Important: </strong> If you are using Vanilla skins, these settings will not be used. <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE}">Click here</a> for layout options. </p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<p>
							Enable link path on messageboard home?<br/>
							<br/>
							<input type="radio" name="LINKPATH" value="1">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE = 1">
									<xsl:attribute name="checked">yes</xsl:attribute>
								</xsl:if>
							</input>&nbsp;Yes
							<br/>
							<input type="radio" name="LINKPATH" value="0">
								<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE = 0">
									<xsl:attribute name="checked">yes</xsl:attribute>
								</xsl:if>
							</input>&nbsp;No
						</p>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="nav_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="12"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$nav_fields}"/>
			<input type="hidden" name="s_returnto">
				<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'messageboardadmin'">messageboardadmin?updatetype=10</xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</input>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<!--<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>-->
			<!--Page 13 Path-->
			<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Site Navigation</h1>
				</div>
			</div>
			<div id="instructional">
				<p>The messageboard system cannot automatically recreate the left hand navigation bar.  You could enter all of the links below, or choose only to link back to the rest of the site’s homepage by entering just one link.</p>
			</div>
			<div id="vanilla-instructional">
			  <p><strong>Important: </strong> If you are using Vanilla skins, these settings will not be used. <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE}">Click here</a> for layout options. </p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h4 class="adminSubtitle">Crumb navigation</h4>
						<p>
							<em>
					A short list of HTML links to appear above the left hand navigation. 
					<br/>
					A ‘carriage return’ will create a &lt;br&gt; when it appears on the page
				</em>
						</p>
						<textarea type="text" name="NAVCRUMB" rows="5" cols="75" class="adminBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE"/>
						</textarea>
						<h4 class="adminSubtitle">Left hand navigation</h4>
						<p>
							<em>
					A list of HTML links. 
					<br/>
					A ‘carriage return’ will create a &lt;br&gt; when it appears on the page
				</em>
						</p>
						<textarea type="text" name="NAVLHN" rows="5" cols="75" class="adminBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE"/>
						</textarea>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save navigation settings &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="path_page">
		<form action="{$root}previewsiteconfig" method="post">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="action" value="update"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<input type="hidden" name="_msstage" value="13"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="_msxml" value="{$path_fields}"/>
			<input type="hidden" name="s_returnto">
				<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'messageboardadmin'">messageboardadmin?updatetype=9</xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:otherwise></xsl:choose></xsl:attribute>
			</input>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="editkey" value="{/H2G2/SITECONFIG-EDITKEY}"/>
			<!--Page 1 Asset-->
			<input type="hidden" name="ASSETCOMPLAIN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETCOMPLAIN']/VALUE-EDITABLE}"/>
			<input type="hidden" name="ASSETNEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETNEW']/VALUE-EDITABLE}"/>
			<!--Page 2 Barley-->
			<input type="hidden" name="BARLEYVARIANT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYVARIANT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BARLEYSEARCHCOLOUR" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BARLEYSEARCHCOLOUR']/VALUE-EDITABLE}"/>
			<!--Page 3 Board-->
			<input type="hidden" name="BOARDNAME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDNAME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDROOT" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDROOT']/VALUE-EDITABLE}"/>
			<input type="hidden" name="BOARDSSOLINK" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='BOARDSSOLINK']/VALUE-EDITABLE}"/>
			<!--Page 4 Banner Code-->
			<input type="hidden" name="CODEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CODEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 5 CSS-->
			<input type="hidden" name="CSSLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='CSSLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 6 Emoticon Page-->
			<input type="hidden" name="EMOTICONLOCATION" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EMOTICONLOCATION']/VALUE-EDITABLE}"/>
			<!--Page 7 External Home Page-->
			<input type="hidden" name="EXTERNALHOME" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOME']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTERNALHOMEURL" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTERNALHOMEURL']/VALUE-EDITABLE}"/>
			<!--Page 8 ExText-->
			<input type="hidden" name="EXTEXTTITLE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTTITLE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTBODY" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTBODY']/VALUE-EDITABLE}"/>
			<input type="hidden" name="EXTEXTPREVIEW" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='EXTEXTPREVIEW']/VALUE-EDITABLE}"/>
			<!--Page 9 Feature-->
			<input type="hidden" name="FEATURESMILEYS" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='FEATURESMILEYS']/VALUE-EDITABLE}"/>
			<!--Page 10 Banner Image-->
			<input type="hidden" name="IMAGEBANNER" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='IMAGEBANNER']/VALUE-EDITABLE}"/>
			<!--Page 11 Link Path-->
			<input type="hidden" name="LINKPATH" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='LINKPATH']/VALUE-EDITABLE}"/>
			<!--Page 12 Nav-->
			<input type="hidden" name="NAVCRUMB" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVCRUMB']/VALUE-EDITABLE}"/>
			<input type="hidden" name="NAVLHN" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='NAVLHN']/VALUE-EDITABLE}"/>
			<!--Page 13 Path-->
			<!--<input type="hidden" name="PATHDEV" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHLIVE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}"/>
			<input type="hidden" name="PATHSSOTYPE" value="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE}"/>-->
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Asset Management / Asset Locations</h1>
				</div>
			</div>
			<div id="instructional">
				<p>You need to host the messageboard assets (images and the CSS file) on your own dev and live web space.  We have provided default files for some assets, which you can replace if you want.  </p>
				<br/>
				<p>When you enter a filename for an image in this system, DNA will look for the picture in the web location you enter below.  If an image does not appear in the previews, check you’ve typed the correct file name and path.</p>
				<br/>
				<p>When you launch the board, all assets must be moved from dev to live.</p>
			</div>
			<div id="vanilla-instructional">
  			<p><strong class="ok">Note: </strong> These settings are used in new Vanilla skins, as well as old-style messageboards. </p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<br/>
						<p>
							File path to your <strong>development</strong> web directory:
							<br/>
							<em>This will probably start with ‘http://dev…’ </em>
						</p>
						<input type="text" name="PATHDEV" class="inputBG" style="width:500px;">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<br/>
						<br/>
						<p>
							<img src="{$adminimagesource}config_testimage.gif" width="104" height="70" alt="Test image"/>
						</p>
						<br/>
						<div style="padding:5px; border:dashed #000000 1px;width:114px;">
							<img src="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHDEV']/VALUE-EDITABLE}config_testimage.gif" width="104" height="70" alt="Test Image"/>
						</div>
						<br/>
						<br/>
						<p>
							File path to your <strong>live</strong> web directory:
							<br/>
							<em>This will probably start with ‘http://www.bbc.co.uk/…’</em>
						</p>
						<input type="text" name="PATHLIVE" class="inputBG" style="width:500px;">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<br/>
						<br/>
						<p>
							<img src="{$adminimagesource}config_testimage.gif" width="104" height="70" alt="Test image"/>
						</p>
						<br/>
						<div style="padding:5px; border:dashed #000000 1px;width:114px;">
							<img src="{MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHLIVE']/VALUE-EDITABLE}config_testimage.gif" width="104" height="70" alt="Test Image"/>
						</div>
						<br/>
						<input name="_mscancel" type="submit" value="Preview &gt; &gt;" class="buttonThreeD" style="margin-left:370px;"/>
						<br/>
						<br/>
						<br/>
						<p>
							Which type of Single Sign-on service are you using?
						</p>
						<input type="radio" name="PATHSSOTYPE" value="0">
							<xsl:if test="not(MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE = 1)">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<xsl:text>&nbsp;Adult</xsl:text>
						<br/>
						<input type="radio" name="PATHSSOTYPE" value="1">
							<xsl:if test="MULTI-STAGE/MULTI-ELEMENT[@NAME='PATHSSOTYPE']/VALUE-EDITABLE = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<xsl:text>&nbsp;Kids</xsl:text>
						<br/>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a>
									<xsl:attribute name="href"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'messageboardadmin'">messageboardadmin?updatetype=8</xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:otherwise></xsl:choose></xsl:attribute>
									&lt; &lt; Back
								</a>
							</div>
						</span>
						<input name="update" type="submit" value="Save asset locations &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	These two templates create the pages which provide access to the different asset configuration pages and the features 
	configuration pages.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template match="SITECONFIG-EDIT" mode="assetselection_siteconfig">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Asset Management</h1>
			</div>
		</div>
		<div id="instructional">
			<p>You need to host all of the image and CSS and other assets the messageboard uses.</p>
			<p>This area allows you to specify locations and file names of these assets and then preview them.</p>
		</div>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<table border="0" class="dataStriped" summary="Features that can be enabled on the board" style="width:720px;">
						<thead>
							<tr class="dataHeader">
								<th scope="col" width="40%">Asset</th>
								<th scope="col">Location/Status</th>
							</tr>
						</thead>
						<tbody>
							<tr class="stripeOne">
								<td scope="row">	CSS File</td>
								<td class="dataLeftLine">
									<xsl:call-template name="css_link">
										<xsl:with-param name="link">Set filename</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets&amp;s_finishreturnto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/>
										</xsl:with-param>
									</xsl:call-template>
								</td>
							</tr>
							<tr class="stripeTwo">
								<td scope="row">	Asset Locations</td>
								<td class="dataLeftLine">
									<xsl:call-template name="path_link">
                      <xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets</xsl:with-param>
                      <xsl:with-param name="link">Manage asset locations</xsl:with-param>
                      <xsl:with-param name="submitClass">datafakelink</xsl:with-param>
                    </xsl:call-template>
								</td>
							</tr>
							<tr class="stripeOne">
								<td scope="row">	Emoticons</td>
								<td class="dataLeftLine">
									<xsl:call-template name="emoticon_link">
										<xsl:with-param name="link">Set location</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets</xsl:with-param>
										<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
									</xsl:call-template>
								</td>
							</tr>
							<tr class="stripeTwo">
								<td scope="row">Banner</td>
								<td class="dataLeftLine">
									<xsl:call-template name="image_link">
										<xsl:with-param name="link">Set filename</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets</xsl:with-param>
										<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="code_link">
										<xsl:with-param name="link">Code in HTML</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets</xsl:with-param>
										<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
									</xsl:call-template>
									<strong>Note: </strong>If you are using Vanilla skins, you may not code a banner in HTML. Either use a banner image (set filename above) or use CSS to style the  <strong>div id="header" (div#header) </strong> element.
								</td>
							</tr>
							<tr class="stripeOne">
								<td scope="row">	Icons</td>
								<td class="dataLeftLine">
									<xsl:call-template name="asset_link">
										<xsl:with-param name="link">Set filenames</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=assets</xsl:with-param>
									</xsl:call-template>
									<strong>Note: </strong>If you are using Vanilla skins, the 'Complain about this message' image should be set using CSS on the <strong>p class="flag" (p.flag)</strong>  element. 
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div class="buttonThreeD" style="margin-left:320px;">
						<a href="{$root}messageboardadmin?updatetype=12">&lt; &lt; Back</a>
					</div>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="featureselection_siteconfig">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_features.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Feature Manager</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<p>Choose which features you would like enabled on the board </p>
					<br/>
					<table border="0" class="dataStriped" summary="Features that can be enabled on the board" style="width:720px;">
						<thead>
							<tr class="dataHeader">
								<th scope="col">Feature</th>
								<th colspan="2" scope="col" id="dataStatusTH">Status	</th>
							</tr>
						</thead>
						<tbody>
							<tr class="stripeOne">
								<td scope="row">	Emoticons</td>
								<td class="dataStatus">
									<xsl:choose>
										<xsl:when test="/H2G2/SITECONFIG/FEATURESMILEYS = 1">On</xsl:when>
										<xsl:otherwise>Off</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:call-template name="feature_link">
										<xsl:with-param name="link">Edit Settings</xsl:with-param>
										<xsl:with-param name="return">previewsiteconfig?_previewmode=1&amp;s_view=features</xsl:with-param>
									</xsl:call-template>
								</td>
							</tr>
						</tbody>
					</table>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD" style="margin-left:320px;">
							<a href="{$root}messageboardadmin?updatetype=11">&lt; &lt; Back</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton">
		<xsl:attribute name="value">Submit Changes &gt;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
	<xsl:template match="SITECONFIG-EDIT" mode="success_siteconfig">
		<h3>Your changes to the messageboard configuration have been made.</h3>
		<xsl:apply-templates select="." mode="initial_siteconfig"/>
	</xsl:template>
	<!--<xsl:template match="SITECONFIG-EDIT" mode="errors">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT/ERRORS"/>
	</xsl:template>
	<xsl:template match="ERRORS">
		<strong>
			<xsl:value-of select="../@NAME"/>
			<xsl:text> : </xsl:text>
			<xsl:value-of select="ERROR/@TYPE"/>
		</strong>
	</xsl:template>-->
</xsl:stylesheet>
