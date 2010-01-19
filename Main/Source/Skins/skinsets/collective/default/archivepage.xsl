<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ARCHIVE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ARCHIVE_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">archivepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- EDIT -->
	<xsl:if test="$test_IsEditor">
	<p>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="generic-n">
	<tr>
	<td class="generic-n-2">
	<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0" /><xsl:text>  </xsl:text><xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:copy-of select="$arrow.right" /> <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a>
	</xsl:element>
	</td>
	</tr>
	</table>
	</p>
	</xsl:if>
		
	<!-- PAGE TITLE -->
	<div class="generic-c">
		<table width="600" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>	
	<xsl:choose>
	<xsl:when test="$current_article_type='100'">
		<xsl:call-template name="box.crumb">
		<xsl:with-param name="box.crumb.href" select="concat($root,'browse')" />
		<xsl:with-param name="box.crumb.value">archive</xsl:with-param>
		<xsl:with-param name="box.crumb.title" select="$article_type_label" />
	</xsl:call-template>
	</xsl:when>
	<xsl:when test="$current_article_type='101'">
	<xsl:call-template name="box.crumb">
		<xsl:with-param name="box.crumb.href" select="concat($root,'browse')" />
		<xsl:with-param name="box.crumb.value">archive</xsl:with-param>
		</xsl:call-template>
	<xsl:call-template name="box.crumb">
		<xsl:with-param name="box.crumb.href" select="concat($root,'backissues')" />
		<xsl:with-param name="box.crumb.value">back issues</xsl:with-param>
		<xsl:with-param name="box.crumb.title" select="$article_type_label" />
	</xsl:call-template>
	</xsl:when>
	</xsl:choose>	
		
			

	</td>
	<td align="right">
	<xsl:copy-of select="$content.by" />
	</td></tr></table>	
	</div>
	
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	<!-- CONTENT -->
	<xsl:apply-templates select="ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW"/>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3" />
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<div id="myspace-s-b">
	
	<div class="myspace-r">
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<strong class="white">newsletter sign up</strong>
	</xsl:element>
	</div>
	
	<div class="myspace-l">	
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
	<div class="orange"><strong>Stay in the loop</strong></div>
	Keep up with the latest 
	reviews and features in each weekly issue.
	<!-- <br/><br/>
	See examples (left ). -->
	</xsl:element>
	</div>
	
	</div>
	<div id="myspace-s-d">
	<div class="myspace-k">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
	<strong>newsletter sign up</strong><br/>
	Enter your email address below. 
	<FORM METHOD="post" ACTION="http://www.bbc.co.uk/cgi-bin/cgiemail/collective/newsletter/newsletter.txt" NAME="bbcform">
	<INPUT TYPE="hidden" NAME="success" VALUE="http://www.bbc.co.uk/dna/collective/newsletter-thanks" />
	<INPUT TYPE="text" SIZE="20" NAME="required_email" VALUE="your email" /> 
	<INPUT TYPE="hidden" NAME="HEADING" VALUE="Newsletter" /> <br/>
	<INPUT TYPE="image" SRC="{$imagesource}/buttons/submit.gif" HEIGHT="23" WIDTH="98" BORDER="0" VALUE="submit" />
	</FORM>
	
	</xsl:element>
	</div>
	</div>

	<div class="reference-g">
	<div class="myspace-r">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:copy-of select="$icon.collective" /><xsl:text>  </xsl:text><strong class="white">new to collective?</strong>
	</xsl:element>
	</div>
	
	<div class="generic-h">
	
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
	As well as reading each issue you can:</xsl:element>
	<div class="myspace-t">Join discussions</div>
	<div class="myspace-t">Publish reviews and weblogs</div>
	<div class="myspace-t">Win CDs, DVDs and books</div>
	<div class="myspace-t">Submit photos and music</div>
	<div class="myspace-t">Get exclusive gig invites</div>

	<br/>
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
	<div><a>
			<xsl:attribute name="href">
			<xsl:choose>
				<xsl:when test="PAGEUI/MYHOME[@VISIBLE=1]"><xsl:value-of select="concat($root,'U',VIEWING-USER/USER/USERID)" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$sso_signinlink" /></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	<xsl:copy-of select="$arrow.right" />  become a member </a></div>
	<div><a href="{$root}community"><xsl:copy-of select="$arrow.right" /> community page</a></div>
	</xsl:element>


	
	</div>
	<br/>
	</div>
	
	
	
	</xsl:element>
	</tr>
	</table>

	
	
	<!-- EDIT -->
	<xsl:if test="$test_IsEditor">
	<p>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="generic-n">
	<tr>
	<td class="generic-n-2">
	<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0" /><xsl:text>  </xsl:text><xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:copy-of select="$arrow.right" /> <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a>
	</xsl:element>
	</td>
	</tr>
	</table>
	</p>
	</xsl:if>

	</xsl:template>
	
</xsl:stylesheet>
