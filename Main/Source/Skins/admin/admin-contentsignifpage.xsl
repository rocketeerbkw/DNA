<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="CONTENTSIGNIFADMIN_HEADER">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Creates the title for the page which sits in the html header
	-->
	<xsl:template name="CONTENTSIGNIFADMIN_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				Content Significance Admin Page 
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIFADMIN_SUBJECT">
	Author:      James Conway
	Context:      	H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="CONTENTSIGNIFADMIN_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Content Significance Admin
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIFADMIN_JAVASCRIPT">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Includes javascript for the page. 
	-->
	<xsl:template name="CONTENTSIGNIFADMIN_JAVASCRIPT">
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIFADMIN_CSS">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Includes CSS for the page. 
	-->	
	<xsl:template name="CONTENTSIGNIFADMIN_CSS">
		<style type="text/css"> 
			label {
				width: 50%;
			}
			input {
				display: block; 
			}
			form input.submitbutton {
				display: block; 
				width: 35em; 
				margin-top: 10px; 
			}
			div#content_contentsignifsitesettings {
				margin-left: 10px; 
			}
			div#nav_siteadminpages {
				margin-left: 10px; 
			}
			div#nav_siteadminpages ul {
				list-style: none;
			}
			div#nav_siteadminpages ul  li {
				display: inline;
			}
		</style>
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIFADMIN_MAINBODY">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Returns content area of the page: DNA site list, h1 and a form containing site specific ContentSignif settings. 
	-->
	<xsl:template name="CONTENTSIGNIFADMIN_MAINBODY">

		<xsl:apply-templates select="SITE-LIST"/>
		
		<div id="content_contentsignifsitesettings">
			<h1><xsl:text>Content Significance Admin Page</xsl:text></h1>
			
			<form method="post" action="{$root}ContentSignifAdmin">
			
				<xsl:apply-templates select="CONTENTSIGNIFSETTINGS" mode="r_admin"/>
				
				<input type="submit" name="updatesitesettings" value="Update Site Content Significance Settings" class="submitbutton"/>
				<input type="submit" name="decrementcontentsignif" value="Decrement Site's Content Significance Tables" class="submitbutton"/>
			</form>
		</div>
	</xsl:template>
	<!--
	<xsl:key name="setting_actionidkey" match="SETTING" use="ACTION/ID"/>
	Author:      James Conway
	Context:      global
	Purpose:	Returns SETTINGs with ACTION/ID used in method call. 
	-->	
	<xsl:key name="setting_actionidkey" match="SETTING" use="ACTION/ID"/>
	<!--
	<xsl:template match="SITE-LIST">
	Author:      James Conway
	Context:      H2G2/SITE-LIST
	Purpose:	If the logged-in user is a superuser an unordered list of links to other sites' ContentSignifAdmin page is returned.
	-->		
	<xsl:template match="SITE-LIST">
		<xsl:if test="$superuser = 1">
			<div id="nav_siteadminpages">
				<ul>
					<xsl:apply-templates select="SITE"/>
				</ul>				
			</div>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SITE">
	Author:      James Conway
	Context:      H2G2/SITE-LIST/SITE
	Purpose:	Returns list item containing the site's SHORTNAME linked to the site's ContentSignifAdmin page. 
	-->	
	<xsl:template match="SITE">
		<li> | <a href="/dna/{NAME}/ContentSignifAdmin"><xsl:value-of select="SHORTNAME"/></a></li>
	</xsl:template>
	<xsl:template match="SITE[last()]">
		<li> | <a href="/dna/{NAME}/ContentSignifAdmin"><xsl:value-of select="SHORTNAME"/></a> | </li>
	</xsl:template>
	<!--
	<xsl:template match="CONTENTSIGNIFSETTINGS">
	Author:      James Conway
	Context:      H2G2/CONTENTSIGNIFSETTINGS
	Purpose:	For each ACTION returns a h2 (containing action's DESCRIPTION) and associated SETTINGS. 
	-->	
	<xsl:template match="CONTENTSIGNIFSETTINGS" mode="r_admin">
		<xsl:for-each select="SETTING/ACTION[not(ID=preceding::SETTING/ACTION/ID)]">
			<h2><xsl:value-of select="DESCRIPTION"/></h2>
			<xsl:apply-templates select="key('setting_actionidkey', ID)" mode="r_admin"/> <!-- will apply-templates to SETTING nodes that have ID passed in. -->
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template match="SETTING">
	Author:      James Conway
	Context:      H2G2/CONTENTSIGNIFSETTINGS/SETTING
	Purpose:	Returns label - input text box pair for the SETTING. N.B. Label attribute "for" must match input attribute "id". 
	-->	
	<xsl:template match="SETTING" mode="r_admin">
		<label for="{@TYPE}_{ACTION/ID}_{ITEM/ID}"><xsl:value-of select="ITEM/DESCRIPTION"/><xsl:text> </xsl:text><xsl:apply-templates select="@TYPE" mode="r_setting"/></label>
		<input type="text" value="{VALUE}" id="{@TYPE}_{ACTION/ID}_{ITEM/ID}" name="{@TYPE}_{ACTION/ID}_{ITEM/ID}"/>
	</xsl:template>
	<!--
	<xsl:template match="SETTING/@TYPE" mode="r_setting">
	Author:      James Conway
	Context:      H2G2/CONTENTSIGNIFSETTINGS/SETTING/@TYPE
	Purpose:	Returns text describing the type of setting.
	-->
	<xsl:template match="SETTING/@TYPE" mode="r_setting">
		<xsl:choose>
			<xsl:when test=".='i'">
				increment
			</xsl:when>
			<xsl:when test=".='d'">
				decrement
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
