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
	 
	 
		<h1 class="yourfilms">
		<xsl:choose>
				<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
					<img src="{$imagesource}title_addyourcomments.jpg" alt="Add your comments" />
				</xsl:when>
				<xsl:otherwise><!-- tips article -->
					<img src="{$imagesource}title_addyourtip.jpg" alt="Add your tip" />
				</xsl:otherwise>
		</xsl:choose>
		</h1>


				<div id="mainintro">
					
					





					<xsl:choose>
					<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
						<div><img src="{$imagesource}comment_top.gif" width="411" height="3" alt="" /></div>
						<div class="text">
							<h2><a class="filmname"><xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" /></a></h2>
							<div class="filmlinks">
							<xsl:for-each select="FORUMSOURCE/ARTICLE/GUIDE/GENRE01 | FORUMSOURCE/ARTICLE/GUIDE/GENRE02 | FORUMSOURCE/ARTICLE/GUIDE/GENRE03">
								<xsl:if test=".!=''">
									<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={.}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="." />
										</xsl:with-param>
									</xsl:call-template></a> |
								</xsl:if>
							</xsl:for-each>	
							<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={FORUMSOURCE/ARTICLE/GUIDE/THEME}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/THEME" />
										</xsl:with-param>
									</xsl:call-template></a>		
							</div>
							<div class="filmblurb"><xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/TAGLINE" /></div>
							<div class="filminfo">
							<xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/DIRECTOR" /> | <xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/LENGTH_MIN" /> minutes <xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/LENGTH_SEC" /> seconds
							</div>
						</div>
						
						<div id="synopsis">			
							<h2>Synopsis</h2>
							<p><xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/BODY" /></p>
						</div>

					</xsl:when>
					<xsl:otherwise><!-- tips article -->
					
						<!-- 
						<div><img src="{$imagesource}comment_top.gif" width="411" height="3" alt="" /></div>
						<div class="text">
							<h2>Tips</h2>
							<div class="filmlinks">
							
							
							</div>
							<div class="filmblurb"></div>
							<div class="filminfo">
							
							</div>
						</div>
						
						<div id="synopsis">			
							
						</div> -->

						</xsl:otherwise>
						</xsl:choose>
						
						<div id="talking">
							<h2 class="comments">
							<xsl:choose>
									<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
										<img src="{$imagesource}title_comment.jpg" alt="Comment" />
									</xsl:when>
									<xsl:otherwise><!-- tips article -->
										<img src="{$imagesource}title_tip.jpg" alt="Tip" />
									</xsl:otherwise>
							</xsl:choose>
							</h2>


							
							<!-- <div class="steps"> -->
								<xsl:choose>
									<xsl:when test="POSTPREMODERATED">
										<p class="commenttext">Thanks for your comment</p>
									</xsl:when>
									<xsl:when test="POSTTHREADFORM/PREVIEWBODY">
										<p class="commenttext">You can edit your comment below - when you're happy with it, click publish</p>
									</xsl:when>
									<xsl:otherwise>
									   <p class="commenttext"><xsl:choose>
																	<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
																		Write your comment in the box below
																	</xsl:when>
																	<xsl:otherwise><!-- tips article -->
																		Write your tip in the box below
																	</xsl:otherwise>
															</xsl:choose></p>
									</xsl:otherwise>
								</xsl:choose>
							<!-- </div> -->

	<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
	<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
	<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
	<xsl:apply-templates select="ERROR" mode="c_addthread"/>
	
								<p class="backlink"><a class="bold"><xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute><img src="{$imagesource}back_arrow.gif" width="10" height="9" />Go back without writing <xsl:choose>
																	<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
																		comment
																	</xsl:when>
																	<xsl:otherwise><!-- tips article -->
																		tip
																	</xsl:otherwise>
															</xsl:choose></a></p>
						
						</div>	
						</div>
						<div class="verticalspacer10px"> </div>
		
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
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
		
				
					<xsl:apply-templates select="." mode="c_premoderationmessage"/>
					<xsl:apply-templates select="." mode="c_contententry"/>
				
					<!-- <div class="arrowlink">
						<p><xsl:apply-templates select="." mode="t_returntoconversation"/></p>
					</div>
					-->
				


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

		<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 10"><!-- normal article -->
				<input type="hidden" name="subject" value="{/H2G2/FORUMSOURCE/ARTICLE/SUBJECT}"/>
			</xsl:when>
			<xsl:otherwise><!-- hack to add a subject into tips pages as they have no subject -->
				<input type="hidden" name="subject" value="Tips"/>
			</xsl:otherwise>
		</xsl:choose>
		
			<div class="frow">
				<textarea name="body" cols="35" rows="10" id="comment" class="addcomment" virtual="wrap">
				<xsl:value-of select="BODY"/>
				</textarea>		
			</div>						
			
			<div class="comment_floatright">
			<input value="PUBLISH" type="image" src="{$imagesource}button_submit.gif" id="submityourentry" alt="Submit your comment" name="post" />
			</div>

			
				<!-- <input value="PREVIEW" type="submit" name="preview" class="inputpre" />
				<input value="PUBLISH" type="submit" name="post" class="inputpub" /> -->
			
		
	</xsl:template>
	
	
	<xsl:template match="SECONDSBEFOREREPOST">
	<script type="text/javascript">
	function countDown() {
		var minutesSpan = document.getElementById("minuteValue");
		var secondsSpan = document.getElementById("secondValue");
		
		var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
		var seconds = new Number(secondsSpan.childNodes[0].nodeValue);
			
		var inSeconds = (minutes*60) + seconds;
		var timeNow = inSeconds - 1;			
			
		if (timeNow >= 0){
			var scratchPad = timeNow / 60;
			var minutesNow = Math.floor(scratchPad);
			var secondsNow = (timeNow - (minutesNow * 60));			
				
			var minutesText = document.createTextNode(minutesNow);
			var secondsText = document.createTextNode(secondsNow);
			
			minutesSpan.removeChild(minutesSpan.childNodes[0]);
			secondsSpan.removeChild(secondsSpan.childNodes[0]);
				
			minutesSpan.appendChild(minutesText);
			secondsSpan.appendChild(secondsText);
		}
	}
	</script>
	
	
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
