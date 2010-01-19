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
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MYCONVERSATIONS_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">myconversations.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- <div><xsl:apply-templates select="DATE" mode="t_markallread"/></div> -->
	<div class="popup-banner"><img src="{$imagesource}banner_logo.gif" width="146" height="39" alt="collective" border="0" hspace="7" vspace="0" /></div>
	<xsl:call-template name="icon.heading">
	<xsl:with-param name="icon.heading.icon" select="0" />
	<xsl:with-param name="icon.heading.text">my conversations</xsl:with-param>
	<xsl:with-param name="icon.heading.colour">DA8A42</xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates select="POSTS" mode="c_myconversations"/>
	
	<div class="popup-footer">
		<div class="popup-footer-close">
			<a href="#" onClick="self.close()">close <img src="{$imagesource}icons/close_window_green.gif" alt="close this window" height="16" width="16" border="" /></a><!--TODO hide from non script -->
		</div>
	</div>
	
	</xsl:template>




	<!-- 
	<xsl:template match="POSTS" mode="r_myconversations">
	Use: Container for the post list and back and next links
	-->
	<xsl:template match="POSTS" mode="r_myconversations">

   	<xsl:apply-templates select="POST-LIST/POST[SITEID=9]" mode="c_myconversations"/>
	<div class="myconvo-next-back">
	<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td>&nbsp;<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="POST-LIST" mode="c_back"/></xsl:element></td>
		<td align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="POST-LIST" mode="c_next"/></xsl:element>&nbsp;</td>
	</tr>
	</table>
	</div>

	</xsl:template>


	<!-- 
	<xsl:template match="POST" mode="read_myconversations">
	Use: Container for all the posts - not using Read and unread
	-->
	<xsl:template match="POST" mode="c_myconversations">
				
		<!-- <div><xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="t_readmarker"/></div> -->
		<!-- <div><xsl:apply-templates select="." mode="t_markallabove"/></div> -->
		<!-- <div><xsl:apply-templates select="SITEID" mode="t_sitefrom"/></div> -->
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::POST) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="THREAD/@THREADID" mode="t_subject"/></strong>
			</xsl:element>
			</td>
			</tr><tr>
			<td class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="." mode="t_lastreply"/> | <xsl:value-of select="@COUNTPOSTS" /> posts
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
		<!-- <xsl:apply-templates select="." mode="t_lastreply"/> -->
	</xsl:template>


	<!-- 
	<xsl:template match="POST" mode="unread_myconversations">
	Use: Container for the posts marked 'Unread'
	-->
	<xsl:template match="POST" mode="unread_myconversations">
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
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText"><xsl:copy-of select="$arrow.left" />&nbsp;<xsl:value-of select="$m_newerpostings"/>
			</xsl:with-param>
			<xsl:with-param name="prev">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!-- 
	<xsl:template match="POST-LIST" mode="r_next">
	Use: Next link
	-->
	<xsl:template match="POST-LIST" mode="r_next">
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText">
				<xsl:value-of select="$m_olderpostings"/>&nbsp;<xsl:copy-of select="$arrow.right" /></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template> 


</xsl:stylesheet>
