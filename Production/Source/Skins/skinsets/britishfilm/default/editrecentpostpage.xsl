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
			<xsl:with-param name="title">Edit Notice/Event Text</xsl:with-param>
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
		
		<div id="mainbansec">	
			<div class="banartical"><h3>Articles/ <strong>delete a comment</strong></h3></div>				
			<div class="clear"></div>
			<div class="searchline"><div></div></div>
		</div><!-- / mainbansec -->
			
		
		<!-- message/title -->
		<xsl:apply-templates select="POST-EDIT-FORM" mode="message"/>
				
		<div class="mainbodysec">
			<div class="bodysec">
				
				<xsl:apply-templates select="ERROR"/>
				<xsl:apply-templates select="POST-EDIT-FORM" mode="confirm_delete"/>
							
			</div><!-- / bodysec -->	
			<div class="additionsec">	
				<div class="hintbox">	
					<h3>HINTS &amp; TIPS</h3>
					<p><strong>Deleting comments</strong></p>
					
					<p>You are in charge of your own space - if you see an offensive comment, you can delete it</p>
		
					<p>Reasonable debate is allowed - please don't delete a comment just because you don't agree with it</p>
		
					<p>If you are not sure, or feel a comment warrants further attention, you can refer it to a moderator instead</p>
							
				</div>  	
			</div><!-- /  additionsec -->	
		
			<div class="clear"></div>
		</div><!-- / mainbodysec -->
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
					<a href="{$root}F{FORUM-ID}?thread={THREAD-ID}"><img src="{$imagesource}btn_return_comments.gif" width="153" height="22" alt="return to comments" /></a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}"><img src="{$imagesource}btn_return_article.gif" width="153" height="22" alt="return to article" /></a>
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
							<a href="{$root}F{FORUM-ID}?thread={THREAD-ID}"><img src="{$imagesource}btn_return_article.gif" width="153" height="22" alt="return to comments" /></a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}"><img src="{$imagesource}btn_return_article.gif" width="153" height="22" alt="return to article" /></a>
						</xsl:otherwise>
					</xsl:choose>
				</div><!-- delete-->
				<div class="flr"><a href="{$root}EditRecentPost?Hide=1&amp;PostID={POST-ID}&amp;H2G2ID={/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}&amp;s_return={/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE}&amp;s_h2g2id={/H2G2/PARAMS/PARAM[NAME = 's_h2g2id']/VALUE}"><img src="{$imagesource}btn_delete.gif" width="76" height="22" alt="delete" /></a></div>
				<div class="clear"></div>
			</div>
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
	
<xsl:template match="ERROR">
	<p class="alert"><xsl:value-of select="."/></p>
</xsl:template>

</xsl:stylesheet>
