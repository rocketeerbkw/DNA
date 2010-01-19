<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addthreadpage.xsl"/>
	<!--
	ADDTHREAD_MAINBODY
	
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ADDTHREAD_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ADDTHREAD_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<!-- title and search -->
		<div id="mainbansec">	
			<div class="banartical"><h3>Comment/ <strong>post a comment</strong></h3></div>				
			<xsl:call-template name="SEARCHBOX" />
			<div class="clear"></div>
		</div>
		
		<!-- step box -->
		<!--[FIXME: remove]
	<div class="steps">
		<xsl:choose>
			<xsl:when test="POSTPREMODERATED">
				<h3>Thanks for your comment</h3>
			</xsl:when>
			<xsl:when test="POSTTHREADFORM/PREVIEWBODY">
				<h3>step 2: preview your comment</h3>
				<p>You can edit your comment below - when you're happy with it, click publish</p>
			</xsl:when>
			<xsl:otherwise>
			    <h3>step 1: write a comment</h3>
				<p>Type your comment in the box below and click 'preview' to see what it will look like</p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
		-->
		
	<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
	<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
	<xsl:apply-templates select="ERROR" mode="c_addthread"/>
		

		
	</xsl:template>
	<!-- 
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
	Use: Presentation of an introduction to a particular thread - defined in the article XML
	-->
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						POSTTHREADFORM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
	Use: The presentation of the form that generates a post. It has a preview area - ie what the post
	will look like when submitted, and a form area.
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
		<div class="bodysec">
			<h4 class="instructhead">You are commenting on <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></a></h4>
			<xsl:apply-templates select="." mode="c_preview"/>
		</div>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
	Use: The presentation of the preview - this can either be an error or a normal display
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_preview"> 
		<xsl:apply-templates select="PREVIEWERROR" mode="c_addthread"/>
		<xsl:apply-templates select="." mode="c_previewbody"/>
	</xsl:template>
	<!-- 
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Use: presentation of the preview if it is an error
	-->
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
		<p><xsl:apply-imports/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
		<div class="commenth">Comment by <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="t_addthread"/></div>
		<div class="commentbox">
			<p class="posted"><xsl:copy-of select="$m_postedsoon"/></p>
			<!--
			<xsl:variable name="body_rendered">
				<xsl:apply-templates select="PREVIEWBODY" mode="convert_urls_to_links"/>
			</xsl:variable>
			<xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="t_addthread"/>
			-->
			<p><xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/></p>
		</div>
		
		<!--
		<div class="compreview">
			<p>
				<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
			</p>
		</div>
		-->
	</xsl:template>

	<xsl:template match="node()" mode="t_addthread">
		<xsl:apply-templates/>
	</xsl:template>	
	
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
		<div class="mainbodysec">
			<div class="formsec">	
			
				<xsl:apply-templates select="." mode="c_premoderationmessage"/>
				<xsl:apply-templates select="." mode="c_contententry"/>
			
				<div class="arrowlink">
					<p><xsl:apply-templates select="." mode="t_returntoconversation"/></p>
				</div>
			</div><!-- / formsec -->	
			<div class="hintsec">				
				<div class="hintbox">	
					<h3>HINTS AND TIPS</h3>
					<p><xsl:copy-of select="$m_UserEditWarning"/></p>
					
					<p><xsl:copy-of select="$m_UserEditHouseRulesDiscl"/></p>
				</div>
				<xsl:choose>
					<xsl:when test="/H2G2/SERVERNAME = $staging_server">
						<p class="arrowlink"><a href="http://www.bbc.co.uk/606/2/popups/smileys_staging.shtml" target="smileys" onClick="popupwindow(this.href,this.target,'width=623, height=502, resizable=yes, scrollbars=yes');return false;">How do I add a smiley?</a></p>
					</xsl:when>
					<xsl:otherwise>
						<p class="arrowlink"><a href="http://www.bbc.co.uk/606/2/popups/smileys.shtml" target="smileys" onClick="popupwindow(this.href,this.target,'width=623, height=502, resizable=yes, scrollbars=yes');return false;">How do I add a smiley?</a></p>
					</xsl:otherwise>
				</xsl:choose>
			</div><!-- /  additionsec -->	
		
		<div class="clear"></div>
		</div><!-- / mainbodysec -->
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
		<p><xsl:copy-of select="$m_userpremodmessage"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
		<p><xsl:copy-of select="$m_PostSitePremod"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
	<xsl:template match="INREPLYTO" mode="r_addthread">
		<p><b><xsl:value-of select="$m_messageisfrom"/></b><xsl:value-of select="USERNAME"/><br/>
		<xsl:apply-templates select="BODY"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	
		<xsl:if test="/H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED = 1">
			<p class="errortext alert">This comment has been blocked as it contains a word which other users may find offensive. Please edit your comment and post it again.<br/>&nbsp;<br/></p>
		</xsl:if>
	
		<xsl:apply-templates select="SECONDSBEFOREREPOST"/>
		<input type="hidden" name="subject" value="{/H2G2/FORUMSOURCE/ARTICLE/SUBJECT}"/>
		
		<div class="formbox">				
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
			<td width="35" valign="top">		
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="one" src="{$imagesource}1.gif" />
			</td>
			<td width="381">
			<div class="frow">
				<div class="labelone"><label for="comment">comment</label></div>
				<textarea name="body" id="comment" class="inputone" cols="15" rows="10" virtual="wrap">
				<xsl:value-of select="BODY"/>
				</textarea>		
			</div>						
			</td>
			</tr>
			</table>		
			
			<table border="0" cellpadding="0" cellspacing="0" width="100%" class="buttons">
			<tr>
				<td class="inputactionfl2" align="right" width="100%"><input value="Preview" type="submit" name="preview" class="inputpre" /></td>
				<td class="inputactionflr2"><input value="Publish" type="submit" name="post" class="inputpub" /></td>
			</tr>
			</table>
		</div>
	</xsl:template>
	
	
	<xsl:template match="SECONDSBEFOREREPOST">
		<xsl:variable name="minutestowait">
			<xsl:value-of select="floor(/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST div 60)" />
		</xsl:variable>
		
		<xsl:variable name="secondsstowait">
			<xsl:value-of select="/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST mod 60" />
		</xsl:variable>
	
		<p id="countdown"><strong>You must wait  <span id="minuteValue"><xsl:value-of select="$minutestowait"/></span> minutes  <span id="secondValue"><xsl:value-of select="$secondsstowait"/></span> secs before you can post again</strong></p>
	</xsl:template>
	
	
	
	<!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>

	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield"/>
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost"/>

	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost"/>

	<!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Use: Message displayed if reply is attempted when unregistered
	 -->
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
		<p><xsl:apply-imports/></p>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
		<div class="bodysec2 bodytxt">
			<xsl:call-template name="m_posthasbeenpremoderated"/>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
	Use: Presentation of the 'Post has been auto premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
		<div class="bodysec2 bodytxt">
			<xsl:call-template name="m_posthasbeenautopremoderated"/>
		</div>
	</xsl:template>
	
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
