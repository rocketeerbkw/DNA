<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">
	<xsl:import href="../../../base/base-miscpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	LOGOUT_MAINBODY Page - Level  template
	Use: Page presented after you logout
	-->
	<xsl:template name="SIMPLEPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_frontpagetitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="LOGOUT_MAINBODY">
		
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">LOGOUT_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<div id="topPage">
			<h2>Signed out</h2>
			<!--xsl:copy-of select="$m_logoutblurb"/-->
			<p>You have just logged out. The next time you visit on this computer we won't automatically recognise you.</p>
			<p>To log in again, go to the front page and follow the link.</p>
		</div>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SIMPLEPAGE_MAINBODY Page - Level  template
	Use: Usually consists of a simple message / GuideML article
	-->
	<xsl:template name="SIMPLEPAGE_MAINBODY">	
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">SIMPLEPAGE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<div id="ms-std">
			<div id="ms-std-header">
				<xsl:comment> ms-std-header </xsl:comment>
			</div>
			<div id="ms-std-content">
				<p>
					<xsl:apply-templates select="ARTICLE/GUIDE"/>
					<xsl:apply-templates select="ARTICLE/USERACTION" mode="t_simplepage"/>
				</p>
			</div>
			<div id="ms-std-footer">
				<xsl:comment> ms-std-footer </xsl:comment>
			</div>
		</div>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NOTFOUND_MAINBODY Page - Level  template
	Use: Page presented when an incorrect URL is entered 
	-->
	<xsl:template name="NOTFOUND_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">NOTFOUND_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<div id="ms-std">
			<div id="ms-std-header">
				<xsl:comment> ms-std-header </xsl:comment>
			</div>
			<div id="ms-std-content">
				<xsl:copy-of select="$m_notfoundbody"/>
			</div>
			<div id="ms-std-footer">
				<xsl:comment> ms-std-footer </xsl:comment>
			</div>
		</div>
	</xsl:template>

	<!-- Magnetic North - override base -->
	<xsl:variable name="m_notfoundbody">
		<p>
			We're sorry, but the page you requested does not exist. This could be because the URL
			<a xsl:use-attribute-sets="nm_notfoundbody1" title="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk{$root}" name="back1" href="#footnote1"><sup>1</sup></a>
			is wrong, or because the page you are looking for has been removed from the site.
		</p>
		<blockquote>
			<hr/>
			<p>				
				<a xsl:use-attribute-sets="nm_notfoundbody2" href="#back1"><sup>1</sup></a>
				<a name="footnote1"><xsl:comment> footnote1 </xsl:comment></a>
				That's the address of the web page that we can't find - it should begin with
				http://www.bbc.co.uk<xsl:value-of select="$root"/>
			</p>
		</blockquote>
	</xsl:variable>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	ERROR_MAINBODY Page - Level  template
	Use: Page displayed when user makes certain errors
	-->
	<xsl:template name="ERROR_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">ERROR_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<div id="ms-std">
			<div id="ms-std-header">
				<xsl:comment> ms-std-header </xsl:comment>
			</div>
			<div id="ms-std-content">
				<xsl:apply-templates select="ERROR" mode="t_errorpage"/>
			</div>
			<div id="ms-std-footer">
				<xsl:comment> ms-std-footer </xsl:comment>
			</div>
		</div>
	</xsl:template>

	<!-- Magnetic North override base -->
	<xsl:template name="m_unregistereduserediterror">
		<p>
			We're sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've signed in.
		</p>
		<ul>
			<li>If you already have an account, please <a xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">login</a>.</li>
			<li>If you haven't already signed up, please <a xsl:use-attribute-sets="nm_unregistereduserediterror2" href="{$sso_noarticleregisterlink}">create an account</a>.<br/>Creating your membership is free and will enable you to share your memories with the rest of the Memoryshare community.</li>
		</ul>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SUBSCRIBE_MAINBODY Page - Level  template
	Use: Page displayed after user subscribes to a conversation / article
	-->
	<xsl:template name="SUBSCRIBE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">SUBSCRIBE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<h1><img src="{$imagesource}h1_error.gif" alt="sorry: there has been an error" width="353" height="26" /></h1>
		<xsl:apply-templates select="SUBSCRIBE-RESULT" mode="t_subscribepage"/>
			<br/><br/>
		<xsl:apply-templates select="RETURN-TO" mode="t_subscribepage"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SITECHANGE_MAINBODY Page - Level  template
	Use: Page displayed when user tries to leave a 'walled garden' site 
	-->
	<xsl:template name="SITECHANGE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">SITECHANGE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<font xsl:use-attribute-sets="mainfont">
			<xsl:copy-of select="$m_sitechangemessage"/>
		</font>
	</xsl:template>

	<!--override from base-miscpage.xsl-->
	<xsl:template match="USERACTION" mode="t_simplepage">
		<xsl:choose>
			<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=1">
				<xsl:call-template name="m_guideentrydeleted_override"/>
			</xsl:when>
			<xsl:otherwise>
				<apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--[FIXME: can this be done better?]-->
	<xsl:template name="m_guideentrydeleted_override">
		Your memory has been deleted. 
		
		<!--[FIXME: remove]
		If you want to restore any deleted <xsl:value-of select="$m_articles"/> you can view them 
		<a use-attribute-sets="nm_guideentrydeleted">
			<xsl:attribute name="href">MA<xsl:value-of select="USERID"/>&amp;type=3</xsl:attribute>
			on this page</a>.
		-->
	</xsl:template>
</xsl:stylesheet>
