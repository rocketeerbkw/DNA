<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="mCONTENT_r_signifcontent"/>
	<!--
	<xsl:template name="CONTENTSIGNIF_HEADER">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Creates the title for the page which sits in the html header
	-->
	<xsl:template name="CONTENTSIGNIF_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				Content Significance Builder Prototype
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIF_SUBJECT">
	Author:      James Conway
	Context:      	H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="CONTENTSIGNIF_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Content Significance Builder Prototype
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIF_JAVASCRIPT">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Includes javascript for the page. 
	-->
	<xsl:template name="CONTENTSIGNIF_JAVASCRIPT">
	</xsl:template>
	<!--
	<xsl:template name="CONTENTSIGNIF_CSS">
	Author:      James Conway
	Context:      H2G2
	Purpose:	Includes CSS for the page. 
	-->	
	<xsl:template name="CONTENTSIGNIF_CSS">
	</xsl:template>
	<!--
	<xsl:template match="SIGNIFCONTENT" mode="t_signifcontent">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT
	Purpose:	Returns information for each TYPE of significant content. 
	-->	
	<xsl:template match="SIGNIFCONTENT" mode="c_signifcontent">
		<xsl:apply-templates select="." mode="r_signifcontent"/>
	</xsl:template>
	<!--
	<xsl:template match="SIGNIFCONTENT" mode="t_signifcontent">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT
	Purpose:	Returns information for each TYPE of significant content. 
	-->	
	<xsl:template match="SIGNIFCONTENT" mode="c_content">
		<form method="post" action="{$root}ContentSignif">
			
			<xsl:apply-templates select="." mode="r_content"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="SIGNIFCONTENT" mode="t_signifcontent">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT
	Purpose:	Returns information for each TYPE of significant content. 
	-->	
	<xsl:template match="SIGNIFCONTENT" mode="c_decrementbutton">
		<xsl:apply-templates select="." mode="r_decrementbutton"/>
	</xsl:template>
	<!--
	<xsl:template match="SIGNIFCONTENT" mode="r_decrementbutton">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT
	Purpose:	Returns information for each TYPE of significant content. 
	-->	
	<xsl:template match="SIGNIFCONTENT" mode="r_decrementbutton">
		<input name="decrementcontentsignif" xsl:use-attribute-sets="mSIGNIFCONTENT_r_decrementbutton"/>
	</xsl:template>
	
	<xsl:attribute-set name="mSIGNIFCONTENT_r_decrementbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Decrement Site's Content Significance Tables</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="TYPE" mode="t_signifcontent">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT/TYPE
	Purpose:	Returns heading and ordered list of significant content for the content TYPE. 
	-->		
	<xsl:template match="TYPE" mode="c_signifcontent">
		<xsl:apply-templates select="." mode="r_signifcontent"/>
	</xsl:template>
	<!--
	<xsl:template match="CONTENT" mode="c_signifcontent">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT/TYPE/CONTENT
	Purpose:	Returns a list item containing a CONTENT item. 
	-->		
	<xsl:template match="CONTENT" mode="c_signifcontent">
		<xsl:apply-templates select="." mode="r_signifcontent"/>
	</xsl:template>
	<!--
	<xsl:template match="TYPE[@ID='1']/CONTENT" mode="t_contentlink">
	Author:      James Conway
	Context:      H2G2/SIGNIFCONTENT/TYPE[@ID='1']/CONTENT
	Purpose:	Returns a link to a user CONTENT object. 
	-->
	<xsl:template match="CONTENT" mode="r_signifcontent">
		<xsl:choose>
			<xsl:when test="../@ID='1'">
				<a href="{$root}U{ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>
			</xsl:when>
			<xsl:when test="../@ID='2'">
				<a href="{$root}A{ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>
			</xsl:when>
			<xsl:when test="../@ID='3'">				
				<a href="{$root}C{ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>
			</xsl:when>
			<xsl:when test="../@ID='4'">				
				<a href="{$root}F{ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>			
			</xsl:when>
			<xsl:when test="../@ID='5'">				
				<a href="{$root}G{ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>
			</xsl:when>
			<xsl:when test="../@ID='6'">				
				<a href="{$root}F{FORUMID}?thread={ID}" xsl:use-attribute-sets="mCONTENT_r_signifcontent">
					<xsl:value-of select="TITLE"/>
				</a>			
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>