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

	<div class="soupContent">
		<xsl:choose>
			<xsl:when test="/H2G2/POSTTHREADFORM/INREPLYTO">
				<h1><img src="{$imagesource}h1_replytoamessage.gif" alt="reply to a message" width="224" height="26" /></h1>
			</xsl:when>
			<xsl:otherwise>
				<h1><img src="{$imagesource}h1_leaveamessage.gif" alt="leave a message" width="224" height="26" /></h1>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<div id="yourPortfolio" class="personalspace">
			<div class="inner">
				<div class="col1">
					<div class="margins">
						<xsl:choose>
							<xsl:when test="/H2G2/POSTTHREADFORM/INREPLYTO">
								<h2><xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/></h2>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="not(/H2G2/POSTTHREADFORM/PREVIEWBODY)"><!-- hide h2 when previewing content -->
									<h2>Create a brand new message</h2>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>	
						<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
						<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
						<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
						<xsl:apply-templates select="ERROR" mode="c_addthread"/>
						
					</div>
				</div><!--// col1 -->
			
				<div class="col2">
					<div class="margins">
						<div class="contentBlock">
						<!-- Arrow list component -->
						<ul class="arrowList">
							<li class="backArrow"><a href="{$root}U{/H2G2/FORUMSOURCE/USERPAGE/USER/USERID}">Back to 
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
							your
							</xsl:when>
							<xsl:otherwise>
							their
							</xsl:otherwise>
						</xsl:choose>
						 
						personal space</a></li>
							<li class="arrow"><a href="{$root}yourspace">Help</a></li>
						</ul>
						<!--// Arrow list component -->
					</div>
										
						<a href="{$root}submityourstuff" class="button twoline"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
					</div>
				</div><!--// col2 -->
				<div class="clr"></div>
			</div>
		</div>
	</div>
	
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
		<xsl:apply-templates select="." mode="c_preview"/>
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
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	<div class="emphasisBox">
		<h2><xsl:value-of select="SUBJECT"/></h2>
		<div class="hozDots"></div>
		<p><xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/></p> 
	</div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	<input type="hidden" name="clip" value="1"/>
		<xsl:apply-templates select="." mode="c_premoderationmessage"/>
		<xsl:apply-templates select="." mode="c_contententry"/>
		<xsl:apply-templates select="." mode="r_addthreadreturnpage"/>
	</xsl:template>
			
	<!-- back link -->
	<xsl:template match="POSTTHREADFORM" mode="r_addthreadreturnpage">
		<div class="backArrow"><xsl:apply-templates select="." mode="t_returntoconversation"/></div>
	</xsl:template>
	<xsl:variable name="m_returntoentry">Go back without posting</xsl:variable>
	<xsl:variable name="m_returntoconv">Go back without posting</xsl:variable>
	
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
		<xsl:copy-of select="$m_userpremodmessage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
		<xsl:copy-of select="$m_PostSitePremod"/>
	</xsl:template>
	<!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
	<xsl:template match="INREPLYTO" mode="r_addthread">
	
	<xsl:value-of select="$m_messageisfrom"/>
	
	<xsl:value-of select="USERNAME"/>
	<br/>
	<xsl:apply-templates select="BODY"/>

	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
		<div class="formRow">
			<label for="title">Title* <em>(max 25 charcters)</em></label><br />
			<xsl:apply-templates select="." mode="t_subjectfield"/><br />
		</div>
		<div class="formRow">
			<label for="comment">Comment</label><br />
			<xsl:apply-templates select="." mode="t_bodyfield"/><br />
		</div>
		<div class="acceptance">					
			<div>
				<xsl:apply-templates select="." mode="t_previewpost"/>
				&nbsp;
				<xsl:apply-templates select="." mode="t_submitpost"/>
			</div>
		</div>
	</xsl:template>
	<xsl:variable name="alt_previewmess">Preview</xsl:variable>
	<xsl:variable name="alt_postmess">Publish</xsl:variable>
	
	
	<!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry">
		<xsl:attribute name="id">uploadForm</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
		<xsl:attribute name="id">title</xsl:attribute>
	</xsl:attribute-set>
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
		<xsl:attribute name="id">comment</xsl:attribute>
	</xsl:attribute-set>
	
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
	<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
		<xsl:call-template name="m_posthasbeenpremoderated"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
