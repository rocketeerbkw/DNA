<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addthreadpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:variable name="forumtype" select="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID" />
	<xsl:variable name="forumsubtype" select="msxsl:node-set($type)/type[@number=$forumtype or @selectnumber=$forumtype]/@subtype" />

	<xsl:template name="ADDTHREAD_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

	
	<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>		
	<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
	<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
	<xsl:apply-templates select="ERROR" mode="c_addthread"/>
	<script type="text/javascript" language="JavaScript">
		var domPath = document.theForm.body;
	</script>
	
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
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		
		<!-- <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="t_addthread"/> -->
		<!-- <xsl:copy-of select="$m_fsubject"/>  -->
		
		<table width="410" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		<div class="PageContent">
		
		<xsl:choose>
		<xsl:when test="$forumsubtype='creative'">
		<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">REVIEW</xsl:element></div>
		</xsl:when>
		<xsl:when test="$forumsubtype='advice'">
		<div class="titleBars" id="titleAdvice"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">COMMENT</xsl:element></div>
		</xsl:when>
		<xsl:when test="$forumsubtype='challenge'">
		<div class="titleBars" id="titleChallenge"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">JOIN THIS CHALLENGE</xsl:element></div>
		</xsl:when>
		<xsl:otherwise>
		<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">ADD COMMENT</xsl:element></div>
		</xsl:otherwise>
	<!-- 	<xsl:when test="$article_subtype='talkpage'">
		<div class="talktitlebar">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/></xsl:element>
		</div>
		</xsl:when> -->
		</xsl:choose>
		
		<div class="boxback">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:value-of select="SUBJECT"/></strong><br/>
		<strong><xsl:copy-of select="$m_postedsoon"/></strong><br />
		<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
		</xsl:element>
		</div>
		</div>
		</td>
		</tr>
		</table>
		
	</xsl:element>	
		
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
   <!-- <xsl:value-of select="$m_nicknameis"/><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/> -->
		
		<xsl:apply-templates select="." mode="c_premoderationmessage"/>
		<xsl:apply-templates select="." mode="c_contententry"/>
		<br/>
		<!-- <xsl:apply-templates select="." mode="t_returntoconversation"/> -->
		
	</xsl:template>
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
	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="headinggeneric"><xsl:value-of select="$m_messageisfrom"/></div>
		</xsl:element> 
	<div class="box2">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:value-of select="USERNAME"/></strong><br/>
		<xsl:apply-templates select="BODY"/>
		</xsl:element>
	 </div>
	 
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<div class="PageContent">
	
	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->



	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and @INREPLYTO!=0">
	<div class="titleBars" id="titleGroup1"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">ADD A COMMENT</xsl:element></div>
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">
	<div class="titleBars" id="titleGroup1"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">START A GROUP DISCUSSION</xsl:element></div>
	</xsl:when>
	<xsl:when test="$forumsubtype='creative'">
	<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">REVIEW</xsl:element></div>
	</xsl:when>
	<xsl:when test="$forumsubtype='advice'">
	<div class="titleBars" id="titleAdvice"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">ADD A COMMENT</xsl:element></div>
	</xsl:when>
	<xsl:when test="$forumsubtype='challenge'">
	<div class="titleBars" id="titleChallenge"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">JOIN THIS CHALLENGE</xsl:element></div>
	</xsl:when>
	<xsl:otherwise>
	<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">ADD COMMENT</xsl:element></div>
	</xsl:otherwise>
<!-- 	<xsl:when test="$article_subtype='talkpage'">
	<div class="talktitlebar">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/></xsl:element>
	</div>
	</xsl:when> -->
	</xsl:choose>
	
	<div class="box2">
	
	<xsl:apply-templates select="INREPLYTO" mode="c_addthread"/>
	
	<a name="edit" id="edit"></a>
		<div class="headinggeneric">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_fsubject"/>
		</xsl:element>
		</div>
		
		<xsl:if test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and not(/H2G2/FORUMTHREADS) and  @INREPLYTO=0 and $ownerisviewer=1 or /H2G2/FORUMSOURCE/@TYPE='clubjournal' and not(/H2G2/FORUMTHREADS) and @INREPLYTO=0 and $test_IsEditor">
		<input type="hidden" name="s_view" value="discussioncreated"/>
		</xsl:if>
		
		
		<xsl:apply-templates select="." mode="t_subjectfield"/>
		<br/>				
		
		<div class="headinggeneric">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_textcolon"/>
		</xsl:element>
		</div>
		
		<xsl:apply-templates select="." mode="t_bodyfield"/><br/>
		<br/>
		<div class="headinggeneric">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		Why not add a smiley to convey emotion(s)?
		</xsl:element>
		</div>
		<br/>
		<script type="text/javascript" language="JavaScript">
		<xsl:comment>
		drawEmoticons(checkType());
		</xsl:comment>
		</script>
		<br/>
		<br/>
		<div class="arrow1"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="{$root}smileys">full list of smileys and how to use them</a>
		</xsl:element></div>
		
	</div>	
	<div class="boxsection">
	
	<xsl:apply-templates select="." mode="t_previewpost"/>
	&nbsp;
	<a name="save"></a>
	<xsl:apply-templates select="." mode="t_submitpost"/><br/>
		
	<br/><b>NOTE: this whole page only available for editors.</b>
	
	</div>	

	</xsl:if><!-- end removed for site pulldown -->
	</div>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		
		<div class="rightnavboxheaderhint">

		

		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		HINTS AND TIPS
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">

		<xsl:choose>
		<xsl:when test="$forumsubtype='creative'">
		<xsl:copy-of select="$discuss.form.creative.tips" />
		</xsl:when>
		<xsl:when test="$forumsubtype='advice'">
		<xsl:copy-of select="$discuss.form.advice.tips" />
		</xsl:when>
		<xsl:when test="$forumsubtype='challenge'">
		<xsl:copy-of select="$discuss.form.challenge.tips" />
		</xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">
		<xsl:copy-of select="$discuss.form.group.tips" />
		</xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
		<xsl:copy-of select="$messages.form.group.tips" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:copy-of select="$discuss.form.creative.tips" />
		</xsl:otherwise>
		</xsl:choose>

		</xsl:element>


		</div>

		</xsl:if><!-- end removed for site pulldown -->

			
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	


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
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost" use-attribute-sets="form.preview"/>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost" use-attribute-sets="form.save"/>
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
