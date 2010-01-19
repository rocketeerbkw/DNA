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



	<xsl:template name="ADDTHREAD_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<!-- <xsl:value-of select="$m_posttoaforum"/> -->
				write a comment
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="ADDTHREAD_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

	 <table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge">
		 <xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'start_discussion'">start a new discussion</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_preview']/VALUE = 'yes'">preview</xsl:when>
						<xsl:otherwise>write&nbsp;a</xsl:otherwise>
					</xsl:choose>&nbsp;
					<xsl:choose>
						<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">message</xsl:when>
						<xsl:otherwise>comment</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
		</xsl:choose>
		 
		 
		  	</span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
	<!-- intro table -->

	<!-- head section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">

				<xsl:choose>
					<xsl:when test="/H2G2/FORUMSOURCE/USERPAGE/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
						<div class="whattodotitle"><strong>you are replying to</strong></div>
						<div class="biogname"><strong><a class="rightcol" href="{$root}F{/H2G2/POSTTHREADFORM/@FORUMID}?thread={/H2G2/POSTTHREADFORM/@THREADID}"><xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT" /></a></strong></div>
					</xsl:when>
					<xsl:otherwise>
						<div class="whattodotitle"><strong>you are  <xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_preview']/VALUE = 'yes'">previewing</xsl:when>
			<xsl:otherwise>writing</xsl:otherwise>
			</xsl:choose> a message for</strong></div>
						<div class="biogname"><strong><a class="rightcol" href="{$root}A{/H2G2/FORUMSOURCE/USERPAGE/USER/USERID}"><xsl:choose>
							<xsl:when test="string-length(/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES) &gt; 0">
								<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
							</xsl:otherwise>
						</xsl:choose></a></strong></div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'start_discussion'">
				<div class="whattodotitle"><strong>you are making the first comment in</strong></div>
				<div class="biogname"><strong>new discussion</strong></div>
			</xsl:when>
			<xsl:otherwise>
				<div class="whattodotitle"><strong>you are commenting on</strong></div>
				<div class="biogname"><strong><a class="rightcol"  href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></a></strong></div>
			</xsl:otherwise>
		</xsl:choose>
					 </td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="10"></td>
	  </tr>
	</table>
	<!-- end spacer -->
	<!-- END head section -->
	<!-- END intro table -->		
	    <table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            
          <td height="300" valign="top">
		<!-- SPACER -->
		<table width="371" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td height="8"></td>
		  </tr>
		</table>
		    <!-- END SPACER -->
	<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>		
	<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
	<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
	<xsl:apply-templates select="ERROR" mode="c_addthread"/>
	
	<script type="text/javascript" language="JavaScript">
		var domPath = document.theForm.body;
	</script>
	</td>
            <td><!-- 20px spacer column --></td>
          <td valign="top" width="244">
		  
			<!-- hints and tips -->
			<!-- top with angle -->
			<table width="244" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td height="42" width="50" valign="top" align="right" class="webboxbg"><div class="alsoicon"><img src="{$imagesource}furniture/myprofile/alsoicon.gif" width="25" height="24" alt="" /></div></td>
				<td width="122" valign="top" class="webboxbg"><div class="hints"><strong>hints and tips</strong></div></td>
				 <td width="72" valign="top" class="anglebg"><img src="/f/t.gif" width="72" height="1" alt="" class="tiny" /></td>
			  </tr>
			</table>
			<!-- END top with angle -->
			<!-- hint paragraphs -->
			<table width="244" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td height="42" width="244" valign="top" class="webboxbg">
				<xsl:choose>
					<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
						<xsl:copy-of select="$message_hints" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$comment_hints" />
					</xsl:otherwise>
				</xsl:choose>
				
				
				</td>
			  </tr>
			</table>
			<!-- END hint paragraphs -->
			<!-- END hints and tips -->
			<!-- BBC disclaimer -->
			<table width="244" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td height="42" width="244" valign="top" class="palebox">
				<xsl:copy-of select="$pleasenote_text" /></td>
			  </tr>
			</table>
			<table width="244" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td  width="244" valign="top" >&nbsp;</td>
			  </tr>
			</table>
			<!-- END BBC disclaimer -->
</td>
          </tr>
        </table>
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
		
		<!-- <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="t_addthread"/> -->
		<!-- <xsl:copy-of select="$m_fsubject"/>  -->
		


		<table width="371" border="0" cellspacing="0" cellpadding="0">
		   <tr> 
			<td width="371" valign="top" class="commentstoprow"><div class="commentstitle"><span class="textmedium"><strong><xsl:value-of select="SUBJECT"/></strong></span></div></td>
		  </tr>
		  <tr> 
			<td valign="top" class="commentssubrow" width="371">
			<div class="commentsposted">posted <span class="textdark">soon</span></div>
			<div class="commentuser"><xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/></div></td>
		  </tr>
		  <tr> 
			<td width="371" height="8"></td>
		  </tr>
		<!-- <strong><xsl:value-of select="SUBJECT"/></strong><br/>
		<strong><xsl:copy-of select="$m_postedsoon"/></strong><br />
		<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/> -->

		</table>
		
		
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
   <!-- <xsl:value-of select="$m_nicknameis"/><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/> -->
   <table width="371" border="0" cellpadding="0" cellspacing="0"> 
			  <tr>
				<td width="2" valign="top" class="darkestbg"><img src="/f/t.gif" width="2" height="2" alt="" class="tiny" /></td>
				<td width="367" valign="top" class="darkestbg"><img src="/f/t.gif" width="367" height="2" alt="" class="tiny" /></td>
				<td width="2" valign="top" class="darkestbg"><img src="/f/t.gif" width="2" height="2" alt="" class="tiny" /></td>
			  </tr>
			  <tr>
				<td class="darkestbg" width="2"></td>
				<td valign="top" width="367">

		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr><td colspan="2" height="5"></td></tr>
		<tr><td width="10">&nbsp;</td><td>
		<input type="hidden" name="s_preview" value="yes" />
				<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
			
				<!-- <xsl:if test="string-length(/H2G2/POSTTHREADFORM/SUBJECT) &lt; 1"> -->
					<img src="{$imagesource}furniture/title.gif" width="87" height="34" alt="comments" /><br/>
					<div class="textmedium">Write your message title in the box below.<br />
				<img src="/f/t.gif" width="1" height="3" alt="" class="tiny" /></div>
					<input name="subject" type="text" size="50" ><xsl:attribute name="value"><xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT" /></xsl:attribute></input>
					<br/>
			<!-- <input type="hidden" name="skin" value="purexml" /> -->
			<table width="347" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="15"><img src="{$imagesource}furniture/wherebeenbar.gif" width="347" height="1" class="tiny" alt="" /></td>
			</tr>
			</table>	
				<!-- </xsl:if> -->
				
			<!-- <div class="charcount">max 360 characters (approx 52 words)</div> -->
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'start_discussion'">
				<img src="{$imagesource}furniture/title.gif" width="87" height="34" alt="title" /><br/>
				<img src="/f/t.gif" width="1" height="2" alt="" class="tiny" />
				<div class="textmedium">Please give your new discussion a short title:</div>
				<xsl:apply-templates select="." mode="t_subjectfield"/>
				<table width="347" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="15"><img src="{$imagesource}furniture/wherebeenbar.gif" width="347" height="1" class="tiny" alt="" /></td>
				</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="subject"><xsl:attribute name="value"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></xsl:attribute></input>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
				<img src="{$imagesource}furniture/message.gif" width="162" height="34" alt="message" /><br />
				<img src="/f/t.gif" width="1" height="2" alt="" class="tiny" />
			<div class="textmedium">Write your message in the box below.</div>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$imagesource}furniture/comments.gif" width="177" height="34" alt="comments" /><br />				
				<img src="/f/t.gif" width="1" height="2" alt="" class="tiny" />
				<div class="textmedium">Write your comment in the box below.</div>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:apply-templates select="." mode="c_premoderationmessage"/>
		<xsl:apply-templates select="." mode="c_contententry"/>
		
		<!-- <xsl:apply-templates select="." mode="t_returntoconversation"/> -->
		</td></tr></table>
		<table width="300" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td height="8"></td>
		  </tr>
		</table>
		</td>
			<td class="darkestbg"></td>
			  </tr>
			  <tr>
				<td width="2" valign="top" class="darkestbg" height="30"><img src="/f/t.gif" width="2" height="1" alt="" class="tiny" /></td>
				<td width="357" valign="top" class="darkestbg">
					<div class="formbutton" style="margin-left:16px"><input type="image" src="{$imagesource}furniture/writemessage/send1.gif"  title="send" name="post" /></div>			
				</td>
				<td width="2" valign="top" class="darkestbg"><img src="/f/t.gif" width="2" height="1" alt="" class="tiny" /></td>
			  </tr>
			</table>

			<div class="goback"><xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
				<a href="{$root}U{/H2G2/FORUMSOURCE/USERPAGE/USER/USERID}"><strong>go back without writing message</strong></a>&nbsp;<img src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4" height="7" alt=""/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><strong>go back without writing comment</strong></a>&nbsp;<img src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4" height="7" alt=""/>
			</xsl:otherwise>
		</xsl:choose></div>
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
		<xsl:apply-templates select="." mode="t_bodyfield"/>	
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
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
		<xsl:attribute name="id">discussionTitle</xsl:attribute>
		<xsl:attribute name="size">40</xsl:attribute>
		<xsl:attribute name="maxlength">50</xsl:attribute>
	</xsl:attribute-set>
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
		<xsl:attribute name="id">bodyField</xsl:attribute>
	</xsl:attribute-set>
	
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
