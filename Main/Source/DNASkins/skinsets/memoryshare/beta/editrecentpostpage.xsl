<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		Templates for the Edit Recent Post page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
		EDITRECENTPOST_HEADER	
		Determines the title of the page
	-->
	<xsl:template name="EDITRECENTPOST_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Comments</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<!--
		EDITRECENTPOST_MAINBODY
		Displays the content of the page
	-->
<xsl:template name="EDITRECENTPOST_MAINBODY">
		
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITRECENTPOST_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">editrecentpostpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

	<div id="topPage">
		<h3>Articles/delete a comment</h3>

		<!-- message/title -->
		<xsl:apply-templates select="POST-EDIT-FORM" mode="message"/>

		<xsl:apply-templates select="ERROR"/>
		<xsl:apply-templates select="POST-EDIT-FORM" mode="confirm_delete"/>
	</div>
	<div class="tear"><hr/></div>
</xsl:template>
	
	
<xsl:template match="POST-EDIT-FORM" mode="message">
	<xsl:choose>
		<xsl:when test="MESSAGE/@TYPE='HIDE-OK' or HIDDEN=7">
		 	<p class="commenttxt">The comment has been successfully deleted</p>
		</xsl:when>
		<xsl:when test="HIDDEN=0">
			<p class="commenttxt">Are you sure you want to delete this comment?</p>
		</xsl:when>
		<xsl:otherwise>
			<p class="commenttxt"><xsl:value-of select="MESSAGE"/></p>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>
	
<xsl:template match="POST-EDIT-FORM" mode="confirm_delete">
	<xsl:choose>
		<xsl:when test="MESSAGE/@TYPE='HIDE-OK'">
		 	<hr />
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE='multiposts'">
					<a href="{$root}F{FORUM-ID}?thread={THREAD-ID}">return to comments</a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}">return to memory</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="HIDDEN=0 or HIDDEN=7">
			<div class="commenth">comment by <a href="{$root}U{AUTHOR/USER/USERID}"><xsl:value-of select="AUTHOR/USER/USERNAME"/></a></div> 
			<div class="commentbox">
				<p class="posted">posted <xsl:value-of select="DATE-POSTED/DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="DATE-POSTED/DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="DATE-POSTED/DATE/@YEAR"/></p>
				<p>
				<xsl:value-of select="TEXT"/>
				</p>
			</div>	
			
			<div class="frow">
				<div class="fl"><!-- return -->
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE='multiposts'">
							<a href="{$root}F{FORUM-ID}?thread={THREAD-ID}">return to comments</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}">return to article</a>
						</xsl:otherwise>
					</xsl:choose>
				</div><!-- delete-->
				<div class="flr"><a href="{$root}EditRecentPost?Hide=1&amp;PostID={POST-ID}&amp;H2G2ID={/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}&amp;s_return={/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE}&amp;s_h2g2id={/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}">delete</a></div>
				<div class="clear"></div>
			</div>
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
	
<xsl:template match="ERROR">
	<p class="alert"><xsl:value-of select="."/></p>
</xsl:template>

</xsl:stylesheet>
