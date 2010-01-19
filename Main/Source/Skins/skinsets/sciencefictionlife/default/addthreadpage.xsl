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
	<xsl:with-param name="message">ADDTHREAD_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		


	


		<!--@cv@! ARTICLE INFORMATION: YEAR, TITLE, BLURB -->
		<div class="topmiddle_booktitle">


		     <div class="piccontainer">
				<xsl:choose>
					<xsl:when test="FORUMSOURCE/ARTICLE/GUIDE/IMAGE_LOC != ''"><img src="{$imageRoot}{FORUMSOURCE/ARTICLE/GUIDE/IMAGE_LOC}" alt="{FORUMSOURCE/ARTICLE/GUIDE/CREATOR}" width="160" height="150" border="0" /></xsl:when>
					<xsl:otherwise><img src="{$imageRoot}images/genericentry_2.jpg" border="0" width="136" height="146" alt="{FORUMSOURCE/ARTICLE/GUIDE/CREATOR}" /></xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="textcontainer">
				<p class="date"><xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/PRODUCTION_YEAR"/></p>
				<h1>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '30'">Book</xsl:if>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '31'">Comic</xsl:if>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '32'">Film</xsl:if>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '33'">Radio</xsl:if>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '34'">TV</xsl:if>
					<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '35'">Other</xsl:if>: <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>.</h1>
				

				<p class="titletext"><xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/SUM_UP"/></p>
				

				<!-- WATCH CLIP @cv@05B -->

				<xsl:if test="FORUMSOURCE/ARTICLE/GUIDE/MOVIE_LOC != ''">
					<table class="medialink">
						<tr><th></th><th></th></tr>
						<tr>
							<td>
								<a title="Watch clip from the original">
							<xsl:attribute name="href"><xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/MOVIE_LOC/CLIP/@LOC" /><!-- ?size=4x3&amp;bgc=C0C0C0&amp;nbram=1 --></xsl:attribute> 
							<xsl:attribute name="onclick">window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')</xsl:attribute>
							<xsl:attribute name="target">avaccess</xsl:attribute>
							<img src="{$imageRoot}images/medialinkarrow.gif" border="0" width="32" height="24" alt="Watch clip from the original" /></a>
							</td>
							<td>
								<a title="Watch clip from the original">
							<xsl:attribute name="href"><xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/MOVIE_LOC/CLIP/@LOC" /><!-- ?size=4x3&amp;bgc=C0C0C0&amp;nbram=1 --></xsl:attribute> 
							<xsl:attribute name="onclick">window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')</xsl:attribute>
							<xsl:attribute name="target">avaccess</xsl:attribute>
							<xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/MOVIE_LOC/CLIP" /></a>
							</td>
						</tr>
					</table>
				</xsl:if>

			</div>
			<div class="boxtop"> </div>
			<div class="clear"></div>
		</div> 
		<xsl:if test="POSTTHREADFORM/@INREPLYTO = '0' and $test_IsEditor">
			<p class="info">To contribute your recollection, please answer the questions below. All entries that follow the <a href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</a> will be published, and selected recollections will make it onto our science fiction timeline.</p>
		</xsl:if>

			<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>	
			<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>						<!-- @cv@20 -->
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
										<!-- PREVIEW @cv@! took the preview option out for right now --><!-- <xsl:apply-templates select="." mode="c_preview"/> -->
		<!-- FORM @cv@20 -->
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
		<div class="myspace-b">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<strong><xsl:value-of select="SUBJECT"/></strong><br /><br />
			<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
			</xsl:element>
		</div>
													<!-- not in design <div class="smalltext">by <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="t_addthread"/> | <xsl:copy-of select="$m_postedsoon"/></div> -->		
	</xsl:template>






	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
		
	<!-- <b><xsl:value-of select="$m_nicknameis"/></b>&nbsp;<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/> -->

		<noscript><p class="info" style="color:red;">You cannot submit a recollection because you do not have javascript enabled. <BR/>Please enable Javascript to submit a recollection.</p>
		<p class="info" style="color:red;">You can find more information, including how to enable Javascript, on <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml">BBC Webwise</a></p>

		<p class="info" style="color:red;">If you are not able to enable Javascript for any reason, you can still add your recollection by giving your answers <a href="http://www.bbc.co.uk/mysciencefictionlife/contribute/addrecollection.shtml">here</a>.</p>

		<p class="info" style="color:red;">However, please be aware:<br />
		<ul class="errorlist">
			<li>Your recollection won't appear on the site immediately; it could take several days to add it to the site</li>
			<li>Unfortunately, your recollection will not appear on your user profile page.</li>
		</ul>
		</p>

		<p class="info" style="color:red;">Your contribution is nonetheless valuable to us.</p>

</noscript>
    	<!-- <xsl:apply-templates select="." mode="c_premoderationmessage"/> TW -->
		
		<!-- FORM BOX @cv@20 -->
		<a name="edit"></a>
		
		<!-- TITLE AND COMMENT TEXT ENTRY -->
		<div>
			<xsl:apply-templates select="." mode="c_contententry"/>
		</div>
		
		

		
		
	</xsl:template>



	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$m_userpremodmessage"/>
		</xsl:element>
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
		<b><xsl:value-of select="$m_messageisfrom"/></b><xsl:choose>
			<xsl:when test="EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="USERNAME" /></xsl:otherwise>
		</xsl:choose> 
		<div><xsl:apply-templates select="BODY"/></div>		
	</xsl:template>
	
	
	
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">

	<xsl:choose>
		<xsl:when test="$test_IsEditor"><!-- site closed -->


			<xsl:choose>
				<xsl:when test="@INREPLYTO='0'">

					<div class="boxbot"></div>


					<div class="redtextwarning" id="manmessage"  style="display:none">Unfortunately we've not yet been able to process your entry, because some of the information we need is missing. Please complete the areas highlighted in red.
					<div class="vspace20px"> </div>
					</div>
					
					<!--LIST ITEM START-->
					<div class="unsuccesful_listitems"> 
						<h2 class="firstnoerror"><label for="encapsulated" title="Encapsulated"><img src="{$imageRoot}images/title_encapsulated2.gif" border="0" alt="Encapsulated" /><span style="display:none" id="mandatoryFields"><img src="{$imageRoot}images/errorreddot.gif" border="0" alt="Mandatory field" /></span></label></h2>
						<p>Would you recommend this? Why?</p>
						<p><textarea cols="45" rows="5" name="encap" id="encapsulated"></textarea></p>
					</div>
					<!--LIST ITEM ENDS-->

				  
					<!--LIST ITEM START-->
					<div class="unsuccesful_listitems"> 
						<h2><label for="timeandspace" title="Time and Space"><img src="{$imageRoot}images/title_timeandspace.gif" border="0" alt="Time and Space" /><span style="display:none" id="mandatoryFields2"><img src="{$imageRoot}images/errorreddot.gif" border="0" alt="Mandatory field" /></span></label></h2>
						<p>What year did you first come across this, and where were you at the time? How old were you? </p>
						<p><textarea name="time" id="timeandspace" cols="45" rows="3"></textarea></p>
					</div>
					<!--LIST ITEM ENDS-->
				 

					<!--LIST ITEM START-->
					<div class="unsuccesful_listitems"> 
						<h2><label for="recollectionsandrevelations" title="Recollection and revelations"><img src="{$imageRoot}images/title_recollections.gif" border="0"  alt="Recollection and revelations" /><span style="display:none" id="mandatoryFields3"><img src="{$imageRoot}images/errorreddot.gif" border="0" alt="Mandatory field" /></span></label></h2>
						<p>How did you discover it? How did it influence, inspire or change you? Did it change your view of the world?</p>
						<p><textarea name="revelations" id="recollectionsandrevelations" cols="45" rows="7"></textarea></p>
					</div>
					<!--LIST ITEM ENDS-->

				  
					<!--LIST ITEM START-->
					<div class="unsuccesful_listitems"> 
						<h2><label for="sumupyourentry" title="Sum up your entry"><img src="{$imageRoot}images/title_sumupyourentry.gif" border="0"  alt="Sum up your entry" /><span style="display:none" id="mandatoryFields4"><img src="{$imageRoot}images/errorreddot.gif" border="0" alt="Mandatory field" /></span></label></h2>

						<p>Describe your memory in a word or short phrase - no more than three words</p>
						<p>
						<input type="text" size="59"  name="subject" id="sumupyourentry" maxlength="55" />
						<!-- <textarea name="subject" id="sumupyourentry" cols="45" rows="3"></textarea> -->
						</p>
					</div>
					
					<!--LIST ITEM ENDS-->
				  

					<!--BEFORE THIS START-->
					<div class="unsuccesful_listitems"> 
						<h2><img src="{$imageRoot}images/title_beforethis.gif" border="0"  alt="Before this...(optional)" /></h2>
						<p>What work came before this for you?<br /><br /></p>

						<h3><label for="beforeTitle">Title</label></h3>
						<p><input type="text" size="59"  name="beforetitle" id="beforethistitle" /></p>
						<h3><label for="beforethistellusmore">Tell us more</label></h3>
						<p><textarea name="beforetext" id="beforethistellusmore" cols="45" rows="3"></textarea></p>
					</div>
					<!--BEFORE THIS ENDS-->
				  

					<!--AFTER THIS START-->
					<div class="unsuccesful_listitems"> 
						<h2><img src="{$imageRoot}images/title_afterthis.gif" border="0"  alt="after this...(optional)" /></h2>
						<p>What work came after this for you?<br /><br /></p>
						<h3><label for="afterthistitle">Title</label></h3>
						<p><input type="text" size="59"  name="aftertitle" id="afterthistitle" /></p>
						<h3><label for="afterthistellusmore">Tell us more</label></h3>
						<p><textarea name="aftertext" id="afterthistellusmore" cols="45" rows="3"></textarea></p> 
					
					<!--AFTER THIS ENDS-->

						<!-- <div class="vspace10px"> </div>
						<p>The BBC is making a programme all about people's Science Fiction lives, and the works that are important to them. Your contribution may be of interest to the team.</p>
						<div class="vspace10px"> </div>
						<table width="400" border="0" cellspacing="0" cellpadding="2">
						<tr>
						<td valign="top"><input type="checkbox" name="emailcheckbox" id="emailcheckbox"/></td>
						<td><p><label for="emailcheckbox" title="email check box">Please tick this box if you're happy for the BBC to contact you by email should we wish to follow this up further.</label></p></td>
						</tr>

						</table>
						<div class="vspace10px"> </div>
						<div class="boxtop"></div> -->

					</div>

					<!-- v5

					<div class="boxtop"></div>
					<div class="sciencefictionconnection">
						<h2><img src="{$imageRoot}images/unsuccesful_page/title_sciencefictionconnect.gif" alt="Science Fiction connections...(optional)" /></h2>
					</div>
					<div class="sciencefictionconnection">
						<p>What other Science Fiction would you connect this work to? From the menu below you can choose up to three works, currently featured in our Science Fiction timeline. If your related works aren't yet featured on the site, remember you can <a><xsl:attribute name="href"><xsl:value-of select="concat($root, $create_member_article)" /></xsl:attribute>submit them for inclusion</a>.</p></div>
				  
				  
					<div class="paddingbottom30px"></div>
					
					-->

					<!-- OPTION 123 START v5 

					<div class="options">  

						<h3><label for="option1">Option 1</label></h3>
						
						<p class="paddingleft10px">
							<select name="option1" id="option1">
								<option>Select a work</option>
								<xsl:copy-of select="H2G2/FORUMSOURCE/ARTICLE/GUIDE/ARTICLE_LIST" />
							</select>
						</p>


						<h3><label for="option2">Option 2</label></h3>
						<p class="paddingleft10px">
							<select name="option2" id="option2">
								<option>Select a work</option>
								<xsl:copy-of select="H2G2/FORUMSOURCE/ARTICLE/GUIDE/ARTICLE_LIST" />
							</select>
						</p>

						
						<h3><label for="option3">Option 3</label></h3>
						<p class="paddingleft10px">
							<select name="option3" id="option3">
								<option>Select a work</option>
								<xsl:copy-of select="H2G2/FORUMSOURCE/ARTICLE/GUIDE/ARTICLE_LIST" />
							</select>
						</p>


					</div>
					
					-->

					<!-- OPTION 123 END -->

				

					<!-- make text field hidden so it still exists -->
					<input type="hidden" name="body"/>
					<input type="hidden" name="post" value="1"/>
					<input type="hidden" name="style" value="1"/>
					<input type="hidden" name="creator"><xsl:attribute name="value"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/CREATOR" /></xsl:attribute></input>
					<input type="hidden" name="tagline"><xsl:attribute name="value"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/SUM_UP" /></xsl:attribute></input>

					<!-- submit button writen by javascript to ensure javascript must be turned on to allow for submission of a recolloction -->
					<p class="scifisubmit">
					<script language="JavaScript" type="text/javascript">
					<xsl:comment><![CDATA[ 

					document.write('<a href="#" onclick="return submitForm();"><img src="/mysciencefictionlife/images/submityourentry.gif" id="submityourentry" alt="Submit your Entry" name="post" /></a>');


					]]>	<xsl:text>//</xsl:text></xsl:comment>
					</script>
					<noscript><p class="info" style="color:red;">You cannot submit a recollection because you do not have javascript enabled. <BR/>Please enable Javascript to submit a recollection.</p>
			<p class="info" style="color:red;">You can find more information, including how to enable Javascript, on <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml">BBC Webwise</a></p>

			<p class="info" style="color:red;">If you are not able to enable Javascript for any reason, you can still add your recollection by giving your answers <a href="http://www.bbc.co.uk/mysciencefictionlife/contribute/addrecollection.shtml">here</a>.</p>

			<p class="info" style="color:red;">However, please be aware:<br />
			<ul>
				<li>Your recollection won't appear on the site immediately; it could take several days to add it to the site</li>
				<li>Unfortunately, your recollection will not appear on your user profile page.</li>
			</ul>
			</p>

			<p class="info" style="color:red;">Your contribution is nonetheless valuable to us.</p>

		</noscript>

					</p>

				</xsl:when>
				<xsl:otherwise>

					
							<div class="listitems">
								<h2><label for="comment" title="Comment"><img src="{$imageRoot}images/comment_form/title_comment.gif" border="0"  alt="Comment" /></label></h2>

								<p>Write your comment in the box below</p>
								<p><textarea name="body" cols="46" rows="10" id="comment"></textarea></p>


								<div class="comment_floatright"><input type="image" src="{$imageRoot}images/submit.gif" id="submityourentry" alt="Submit your Entry" name="post" /></div>
								<div class="paddingbottom15px"></div>
								<div class="goback">
									<p><a><xsl:attribute name="href"><xsl:value-of select="$root" />F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID" />?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID" /></xsl:attribute>Go back without writing comment<img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" /></a></p>
								</div>

								<input type="hidden" xsl:use-attribute-sets="iPOSTTHREADFORM_t_subjectfield" name="subject"/>
								<div class="paddingbottom15px"></div>
								<div class="paddingbottom8px"></div>

							</div>

						


				</xsl:otherwise>
			</xsl:choose>

		</xsl:when>
		<xsl:otherwise>
			<div class="listitems"><p class="info"><strong>This site closed to new contributions in April 2007. You can still browse all of the content and recollections here on the site as an archive for the foreseeable future.</strong></p></div>
		</xsl:otherwise>
	</xsl:choose>
	
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
		<xsl:attribute name="id">sumupyourentry</xsl:attribute>
		<xsl:attribute name="size">45</xsl:attribute>
		<xsl:attribute name="rows">3</xsl:attribute>
	</xsl:attribute-set>
	
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
		<xsl:attribute name="cols">45</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">addthread-body</xsl:attribute>
	</xsl:attribute-set>
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost" use-attribute-sets="form.preview" />

	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost" use-attribute-sets="form.publish" />

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
		<!-- chelsea go to scifitext.xsl search for m_posthasbeenpremoderated and add link back in  remove editor link is all -->
		<xsl:call-template name="m_posthasbeenpremoderated"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:apply-imports/>
	</xsl:template>


	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_subjectfield">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the subject field element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_subjectfield">
		<input xsl:use-attribute-sets="iPOSTTHREADFORM_t_subjectfield" name="subject"/>
	</xsl:template>

	


</xsl:stylesheet>