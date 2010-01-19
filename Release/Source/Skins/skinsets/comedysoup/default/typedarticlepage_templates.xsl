<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<!-- preview, create and edit buttons -->
<xsl:template name="SUBMIT_BUTTONS">
	<div class="acceptance">					
			<div>
				<xsl:if test="not($article_type_group='mediasset')">
					<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
				</xsl:if>
				<xsl:apply-templates select="." mode="c_articleeditbutton"/>
				<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
			</div>
		</div>
</xsl:template>

<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">submit</xsl:attribute>
	<xsl:attribute name="onclick">return validateForm()</xsl:attribute>
</xsl:attribute-set>


<!-- form used for create/edit profile:  TYPE = 3001 -->
<xsl:template name="PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$userintrofields}"/>
	<input type="hidden" name="type" value="3001"/>
	<input type="hidden" name="TITLE">
	<xsl:attribute name="value">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
	</xsl:attribute>
	</input>
	
	<h1><img src="{$imagesource}h1_yourpersonalspacecreateeditprofile.gif" alt="your personal space: create/edit profile" width="466" height="26" /></h1>
	<div class="profileHeader">
		<span class="user"><span><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" /><xsl:text> </xsl:text> <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" /></span></span>
		<span class="date">member since:<xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAYNAME" /> <xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" /></span>
		<div class="clr"></div>	
	</div>	
	
	<div id="ps_profile_yours" class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
					<div id="uploadForm">
					
						<div class="formRow">
							<label for="biog">Biog</label><br />
							<p>This is where you can tell other users a bit about yourself. It's completely up to you what you write - it can be a straight biography or a pack of lies, comedy you love, comedy you've done, your ambitions, the name of your cat - you choose.</p>
							<xsl:apply-templates select="." mode="t_articlebody"/><br />
						</div>
						
						<div class="formRow">
							<h2>Web Links</h2>
							<p>This is where you can link to your own website or blog, or sites you like. You need a title and the url (address of the site) for each one.</p>
							<fieldset id="blogLinks">
								<div>
								<!-- link 1 -->
								<label for="bioglinks1title">Page Title</label><br />
								<input type="text" name="BIOGLINKS1TITLE" id="bioglinks1title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS1TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="bioglinks1url">Address (url)</label><br />
								<input type="text" name="BIOGLINKS1URL" id="bioglinks1url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS1URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								
								<!-- link 2 -->
								<label for="bioglinks2title">Page Title</label><br />
								<input type="text" name="BIOGLINKS2TITLE" id="bioglinks2title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS2TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="bioglinks2url">Address (url)</label><br />
								<input type="text" name="BIOGLINKS2URL" id="bioglinks2url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS2URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								
								<!-- link 3 -->
								<label for="bioglinks3title">Page Title</label><br />
								<input type="text" name="BIOGLINKS3TITLE" id="bioglinks3title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS3TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="bioglinks3url">Address (url)</label><br />
								<input type="text" name="BIOGLINKS3URL" id="bioglinks3url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='BIOGLINKS3URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
							</div>
							</fieldset>
						</div>
						
						<xsl:call-template name="SUBMIT_BUTTONS" />
						
					</div>
					
					<p><b>add content that you wish to create a personal space</b></p>
					
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<!-- Arrow list component -->
					<ul class="arrowList">
						<!-- <li class="arrow"><a href="insert_url">My contacts</a></li> -->
						<!-- <li class="arrow"><a href="insert_url">My messages</a></li> -->
						<li class="backArrow"><a href="{$root}{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME}">Back to your personal space</a></li>
					</ul>
					<!--// Arrow list component -->
					
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
	
</xsl:template>



<xsl:template name="EMAIL_OR_POST">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EMAIL_OR_POST</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
		
	<xsl:variable name="email_or_post_email"> - choose this option if you want to email your work to us.</xsl:variable>
	<xsl:variable name="email_or_post_post"> - choose this option if you want to send us a cd with your work on.</xsl:variable>
	<xsl:variable name="email_or_post_embed"> - choose this option if you want to embed a video hosted on YouTube, Google Video or MySpace Video.</xsl:variable>
			
	<!-- 
	determine if this is a programme challenge submission.
	new programme challenges submissions will have an extra s_param (s_pccat) indicating
	which category this is to be submitted to.
	or if a article is being edited, it will have a PCCAT element in EXTRAINFO
	
	additionally test whether this category is associated with a programmechallenge
	as defined in the PROGRAMMECHALLENGESCONFIG section of siteconfig
	-->
	<xsl:variable name="pccat">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"/></xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/PCCAT"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/PCCAT"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="is_programme_challenge">
		<xsl:choose>
			<xsl:when test="$pccat!=0 and /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="programme_challenge_name" select=" /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/DISPLAYNAME"/>

	<xsl:variable name="auto_add_to_cat" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGESAUTOADDTOCAT"/>
		
	<!-- title -->
	<h1>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='audio'">
				<img src="{$imagesource}h1_audio_emailorpost.gif" alt="submit your audio (email or post?)" width="635" height="26" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='video'">
				<img src="{$imagesource}h1_video_emailorpost.gif" alt="submit your video (email or post?)" width="635" height="26" />
			</xsl:when>
		</xsl:choose>
 	</h1>
	
	<xsl:if test="$is_programme_challenge=1">
		<h2 class="orange">
			<xsl:value-of select="$programme_challenge_name"/> challenge
		</h2>
		<input type="hidden" name="s_pccat" value="{$pccat}"/>
		<xsl:if test="$auto_add_to_cat=1">
			<input type="hidden" name="node" value="{$pccat}"/>
		</xsl:if>
	</xsl:if>	
	
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<!-- col1-->
		<div class="col1">
			<div class="margins">
						
				<p>There are 
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='video' and /H2G2/SITECONFIG/EMBEDEDVIDEOCONFIG/ENABLED='Y'">
					three
					</xsl:when>
					<xsl:otherwise>
					two
					</xsl:otherwise>
				</xsl:choose>
				ways you can get your 
				
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='audio'">
					audio
					</xsl:when>
					<xsl:otherwise>
					video or animation
					</xsl:otherwise>
				</xsl:choose>
				
				 to us.</p>
				
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='audio'">		
						<p><a href="TypedArticle?acreate='new'&amp;type=11&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=1&amp;contenttype=2&amp;s_display=2&amp;s_show=email&amp;s_pccat={$pccat}" class="button"><span><span><span>email</span></span></span></a> <xsl:value-of select="$email_or_post_email"/> <br />
						<br />
						or<br />
						<br />
						<a href="TypedArticle?acreate='new'&amp;type=11&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=1&amp;contenttype=2&amp;s_display=2&amp;s_show=post&amp;s_pccat={$pccat}" class="button"><span><span><span>post</span></span></span></a> <xsl:value-of select="$email_or_post_post"/></p>
					
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='video'">
						
						<p><a href="TypedArticle?acreate='new'&amp;type=12&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=1&amp;contenttype=3&amp;s_display=3&amp;s_show=email&amp;s_pccat={$pccat}" class="button"><span><span><span>email</span></span></span></a> <xsl:value-of select="$email_or_post_email"/><br />
						<br />
						or<br />
						<br />
						<a href="TypedArticle?acreate='new'&amp;type=12&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=1&amp;contenttype=3&amp;s_display=3&amp;s_show=post&amp;s_pccat={$pccat}" class="button"><span><span><span>post</span></span></span></a> <xsl:value-of select="$email_or_post_post"/><br/>						
						<xsl:if test="/H2G2/SITECONFIG/EMBEDEDVIDEOCONFIG/ENABLED='Y'">
							<br/>
							or<br />
							<br />
							<a href="TypedArticle?acreate='new'&amp;type=12&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=0&amp;contenttype=3&amp;s_display=3&amp;s_show=embed&amp;s_pccat={$pccat}" class="button"><span><span><span>embed</span></span></span></a> <xsl:value-of select="$email_or_post_embed"/>
						</xsl:if>
						</p>
					</xsl:when>
				</xsl:choose>
				
			</div>
		</div><!--// col1 -->
		<!-- col2-->
		<div class="col2">
			<div class="margins">
				<xsl:comment>#include virtual="/comedysoup/includes/submityourstuff.ssi"</xsl:comment>
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
	
</xsl:template>



<!-- form used for createng an article with a media asset -->
<xsl:template name="MEDIA_ASSET_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIA_ASSET_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	
	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
			<input type="hidden" name="s_show" value="email"/>
			<input type="hidden" name="SUBMISSION_METHOD" value="email"/>
		</xsl:when>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
			<input type="hidden" name="s_show" value="post"/>
			<input type="hidden" name="SUBMISSION_METHOD" value="post"/>
		</xsl:when>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed' and /H2G2/SITECONFIG/EMBEDEDVIDEOCONFIG/ENABLED='Y'">
			<input type="hidden" name="s_show" value="embed"/>
			<input type="hidden" name="SUBMISSION_METHOD" value="embed"/>
		</xsl:when>
	</xsl:choose>
	<input type="hidden" name="s_display" value="{$contenttype}"/>
	<input type="hidden" name="hasasset" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	<xsl:choose>
		<xsl:when test="$contenttype=1">
			<input type="hidden" name="manualupload" value="0"/>
		</xsl:when>
		<xsl:when test="$contenttype=2">
			<input type="hidden" name="manualupload" value="1"/>
			<input type="hidden" name="s_media" value="1"/>
		</xsl:when>
		<xsl:when test="$contenttype=3">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed'">
					<input type="hidden" name="manualupload" value="1"/>
					<input type="hidden" name="s_media" value="1"/>
					<input type="hidden" name="externallink" value="1"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="hidden" name="manualupload" value="1"/>
					<input type="hidden" name="s_media" value="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="$contenttype=1">
			<input type="hidden" name="_msxml" value="{$imagearticlefields}"/>
		</xsl:when>
		<xsl:when test="$contenttype=2">
			<input type="hidden" name="_msxml" value="{$audioarticlefields}"/>
		</xsl:when>
		<xsl:when test="$contenttype=3">
			<input type="hidden" name="_msxml" value="{$videoarticlefields}"/>
		</xsl:when>
	</xsl:choose>
	
	<input type="hidden" name="contenttype" value="{$contenttype}"/>
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	
	<!-- 
	determine if this is a programme challenge submission.
	new programme challenges submissions will have an extra s_param (s_pccat) indicating
	which category this is to be submitted to.
	or if a article is being edited, it will have a PCCAT element in EXTRAINFO
	
	additionally test whether this category is associated with a programmechallenge
	as defined in the PROGRAMMECHALLENGESCONFIG section of siteconfig
	-->
	<xsl:variable name="pccat">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"/></xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/PCCAT"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/PCCAT"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="is_programme_challenge">
		<xsl:choose>
			<xsl:when test="$pccat!=0 and /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="programme_challenge_name" select=" /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/DISPLAYNAME"/>

	<xsl:variable name="auto_add_to_cat" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGESAUTOADDTOCAT"/>

	<!-- hidden variable to populate PCCAT element in EXTRAINFO -->
	<xsl:if test="$is_programme_challenge=1">
		<input type="hidden" name="pccat" value="{$pccat}"/>
	</xsl:if>
	
	<!-- title -->
	<h1>
		<xsl:choose>
			<xsl:when test="$contenttype=1">
				<!-- image -->
				<img src="{$imagesource}h1_submityourimage.gif" alt="submit your image (ohhhhhh errr...)" width="343" height="26" />
			</xsl:when>
			<xsl:when test="$contenttype=2 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
				<!-- email audio -->
				<img src="{$imagesource}h1_email_audio.gif" alt="submit by email: audio" width="270" height="26" /> 
			</xsl:when>
			<xsl:when test="$contenttype=2 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
				<!-- post audio -->
				<img src="{$imagesource}h1_post_audio.gif" alt="submit by post: audio" width="255" height="26" /> 
			</xsl:when>
			<xsl:when test="$contenttype=3 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
				<!-- email video -->
				<img src="{$imagesource}h1_email_video.gif" alt="submit by email: video/animation" width="395" height="26" />
			</xsl:when>
			<xsl:when test="$contenttype=3 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
				<!-- post video -->
				<img src="{$imagesource}h1_post_video.gif" alt="submit by post: video/animation" width="387" height="26" />
			</xsl:when>
			<xsl:when test="$contenttype=3 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed'">
				<!-- post video -->
				<img src="{$imagesource}h1_embed_video.gif" alt="submit by embed: video/animation" width="387" height="26" />
			</xsl:when>
			<xsl:otherwise>
				edit page
			</xsl:otherwise>
		</xsl:choose>
	</h1>
	
	<xsl:if test="$is_programme_challenge=1">
		<h2 class="orange">
			<xsl:value-of select="$programme_challenge_name"/> challenge
		</h2>
		<input type="hidden" name="s_pccat" value="{$pccat}"/>		
		<xsl:if test="$auto_add_to_cat=1">
			<input type="hidden" name="node" value="{$pccat}"/>
		</xsl:if>
	</xsl:if>
	
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<!-- col1-->
		<div class="col1">
			<div class="margins">
				<!-- error -->
				<xsl:if test="*/ERRORS or /H2G2/PROFANITYERRORINFO">
				<div class="warningBox">
					<p class="warning">
					<strong>ERROR</strong><br />
					
					<xsl:if test="/H2G2/PROFANITYERRORINFO">
					Your submission information contains a blocked phrase. You must remove any profanities before your item can be submitted.<br />
					</xsl:if>
					<xsl:for-each select="MULTI-REQUIRED/ERRORS">
						<xsl:choose>
							<xsl:when test="ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								<xsl:text></xsl:text>
								<xsl:choose>
									<xsl:when test="../@NAME='TITLE'">You must provide a title<br/></xsl:when>
									<xsl:when test="../@NAME='BODY'">You must provide a description<br/></xsl:when>
									<xsl:when test="../@NAME='MEDIAASSETKEYPHRASES'">You must provide a key phrase<br/></xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>

					</xsl:for-each>
					<xsl:for-each select=" MULTI-ELEMENT/ERRORS">
						<xsl:choose>
							<xsl:when test="ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								<xsl:text></xsl:text>
								<xsl:choose>
									<xsl:when test="../@NAME='SUBMISSIONAGREEMENT'">You must agree to the submission agreement</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>

					</xsl:for-each>
					<xsl:if test="*/ERRORS">
					<br/>You must do this before your item can be submitted.
					</xsl:if>
					</p>
				</div>
				</xsl:if>
				
				
				<!-- progress tabs -->
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
						<xsl:if test="$contenttype=2 or $contenttype=3">
							<div class="calHeader">
								<ul class="uploadProgress">
									<li class="step1 selected">Step 1: about your media</li>
									<li class="step2">Step 2: email your media</li>
								</ul>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
						<xsl:if test="$contenttype=2 or $contenttype=3">
							<div class="calHeader">
								<ul class="uploadProgress">
									<li class="step1 selected">Step 1: about your media</li>
									<li class="step2">Step 2: post your media</li>
								</ul>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed'">
						<xsl:if test="$contenttype=3">
							<div class="calHeader">
								<ul class="uploadProgress">
									<li class="step1 selected">Step 1: about your media</li>
									<li class="step2">&nbsp;</li>
								</ul>
							</div>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
				
				
				<div id="uploadForm">
					<div class="formRow">
						<label for="title">Title* <em>(max 25 characters)</em></label><br />
						<xsl:apply-templates select="." mode="t_articletitle"/><br />
					</div>
					
					<!-- Choose an image to upload -->
					<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE']">
						<xsl:apply-templates select="." mode="c_assetupload"/>
					</xsl:if>
					
					<!-- Mime type -->
					<xsl:apply-templates select="MULTI-REQUIRED[@NAME='MIMETYPE']" mode="c_taassetmimetype"/>
					
					
					<!-- duration -->
					<xsl:if test="$contenttype=2 or $contenttype=3">
						<div class="formRow">
							<label for="duration">Duration*</label><br />
							<fieldset id="duration">
								<div>
									<input type="text" name="duration_mins" class="duration">
										<xsl:attribute name="value">
											<xsl:value-of select="MULTI-ELEMENT[@NAME='DURATION_MINS']/VALUE-EDITABLE"/>
											</xsl:attribute>
									</input><span class="durationtext">min&nbsp;</span>
									<input type="text" name="duration_secs" class="duration">
										<xsl:attribute name="value">
											<xsl:value-of select="MULTI-ELEMENT[@NAME='DURATION_SECS']/VALUE-EDITABLE"/>
											</xsl:attribute>
									</input><span class="durationtext">secs</span><br/>
								</div>
							</fieldset>
						</div>
					</xsl:if>
					
					<!-- aspect ratio -->
					<xsl:if test="$contenttype=3 and not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed')">
						<div class="formRow">
							<label for="aspectratio">Aspect Ratio*</label><br />
							<select name="ASPECTRATIO">
								<option value="">select a size</option>
								<option value="4 x 3"><xsl:if test="MULTI-ELEMENT[@NAME='ASPECTRATIO']/VALUE-EDITABLE = '4 x 3'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>4x3</option>			
								<option value="16 x 9"><xsl:if test="MULTI-ELEMENT[@NAME='ASPECTRATIO']/VALUE-EDITABLE = '16 x 9'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>16x9</option>		
							</select><br />
						</div>
					</xsl:if>
					
					<xsl:if test="$contenttype=3 and /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed'">
						<div class="formRow">
							<label for="externallinkurl">External link*</label><br/>
							<input type="text" name="externallinkurl" xsl:use-attribute-sets="iMULTI-STAGE_t_articletitle">
								<xsl:attribute name="value">
									<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
								</xsl:attribute>
							</input>
						</div>
						<p class="supportText">
							Copy and paste your video's URL into this box. For example:<br/>
							http://www.youtube.com/watch?v=abC_D1e2F3G<br/>
							or<br/>
							http://vids.myspace.com/index.cfm?fuseaction=vids.individual&amp;videoid=123456789<br/>
							or<br/>
							http://video.google.com/videoplay?docid=1234567891234567889&amp;hl=en
						</p>
					</xsl:if>
									
					<div class="formRow">
						<label for="description">Description*</label><br />
						<xsl:apply-templates select="." mode="t_articlebody"/><br/>
					</div>
					
					<div class="hozDots"></div>
					
					<!-- key phrases-->
					<xsl:apply-templates select="." mode="c_assettags"/>
					
					<p class="supportText">You can add more than one key phrase - just leave a space between each word. If you want to include more than one word in a phrase, use inverted commas. eg: table bottle "cork screw" glass. <strong>This should be a list of words, not a complete sentence.</strong></p>
					
					<div class="hozDots"></div>
					
					<div class="formRow">						
						<label for="relatedLinks">Related Links</label>
						<fieldset id="relatedLinks">
							<div>
								<!-- link 1 -->
								<label for="relatedlinks1title">Page Title</label><br />
								<input type="text" name="RELATEDLINKS1TITLE" id="relatedlinks1title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS1TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="relatedlinks1url">Address (url)</label><br />
								<input type="text" name="RELATEDLINKS1URL" id="relatedlinks1url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS1URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								
								<!-- link 2 -->
								<label for="relatedlinks2title">Page Title</label><br />
								<input type="text" name="RELATEDLINKS2TITLE" id="relatedlinks2title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS2TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="relatedlinks2url">Address (url)</label><br />
								<input type="text" name="RELATEDLINKS2URL" id="relatedlinks2url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS2URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								
								<!-- link 3 -->
								<label for="relatedlinks3title">Page Title</label><br />
								<input type="text" name="RELATEDLINKS3TITLE" id="relatedlinks3title" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS3TITLE']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
								<label for="relatedlinks3url">Address (url)</label><br />
								<input type="text" name="RELATEDLINKS3URL" id="relatedlinks3url" class="relatedLinks">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS3URL']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input><br />
							</div>
						</fieldset>
						
					</div>
					
					<div class="formRow">
						<p><b>If you would like to give anyone who you've worked with a credit, 
						please do so in this box. If not leave it blank.</b></p>
						<textarea name="REFERENCES" rows="4" cols="50">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='REFERENCES']/VALUE-EDITABLE"/>
					</textarea><br />
					</div>
					
					<div class="formRow">
						<p><b>Please read the <a href="{$root}termsofcontribution" target="_blank">Comedy Soup submissions agreement</a>, and then tick the box below*</b></p>
						<input type="checkbox" name="SUBMISSIONAGREEMENT" id="confirm">
							<xsl:if test="MULTI-ELEMENT[@NAME='SUBMISSIONAGREEMENT']/VALUE-EDITABLE = 'on'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>	
						</input>
						<!-- <input type="hidden" name="SUBMISSIONAGREEMENT"/> -->
						<label for="confirm"><span>I have read the Comedy Soup submissions agreement and agree to it.</span></label>
					</div>
					
					<xsl:call-template name="SUBMIT_BUTTONS" />
				</div>
			</div>
		</div><!--// col1 -->
		<!-- col2-->
		<div class="col2">
			<div class="margins">
				
				<xsl:comment>#include virtual="/comedysoup/includes/submityourstuff.ssi"</xsl:comment>
				
				<div class="contentBlock">
					<h2>Comedy Soup submission agreement</h2>
					<p>Read the <a href="{$root}termsofcontribution">terms of contribution</a> to Comedy Soup, and find out more about <a href="{$root}copyright">copyright</a>. </p>
				</div>
				
				<div class="contentBlock">
					<h2>* You must complete all of these fields</h2>
				</div>
				
				<xsl:if test="$contenttype=3">
					<xsl:apply-templates select="/H2G2/SITECONFIG/BBCTHREE" />
				</xsl:if>
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
	
</xsl:template>

<!-- form used for createng an editorial article -->
<xsl:template name="EDITORIAL_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$articlefields}"/>
	
	<div id="uploadForm">	
		<div class="formRow">
			Title:<br/>
			<xsl:apply-templates select="." mode="t_articletitle"/><br/>
		</div>
		
		<div class="formRow">
			Graphic Title<br />
			<input type="text" name="GRAPHICTITLE" class="imageTitle">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='GRAPHICTITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input><br />
		</div>
		
		<div id="typedarticleEditorsForm" class="default">
			<div class="col1">
				<div class="margins">
					
					<div class="formRow">
						Main Column:<br/>
						<xsl:apply-templates select="." mode="t_articlebody"/>
					</div>
					
					<xsl:call-template name="SUBMIT_BUTTONS" />
					
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<div class="formRow">
						COL2<br />
						<textarea type="text" name="col2" id="col2textarea">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='COL2']/VALUE-EDITABLE"/>
						</textarea><br />
					</div>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
</xsl:template>


<!-- form used for createng an category article -->
<xsl:template name="CATEGORY_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">CATEGORY_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$categoryarticlefields}"/>
	
	<div id="uploadForm">	
		<div class="formRow">
			Title:<br/>
			<xsl:apply-templates select="." mode="t_articletitle"/><br/>
		</div>
		
		<div class="formRow">
			Graphic Title<br />
			<input type="text" name="GRAPHICTITLE" class="imageTitle">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='GRAPHICTITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input><br />
		</div>
		
		<div id="typedarticleEditorsForm" class="default">
			<div class="col1">
				<div class="margins">
					
					<div class="formRow">
						Main Column:<br/>
						<xsl:apply-templates select="." mode="t_articlebody"/>
					</div>
					
					<xsl:call-template name="SUBMIT_BUTTONS" />
					
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<div class="formRow">
						COL2<br />
						<textarea type="text" name="col2" id="col2textarea">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='COL2']/VALUE-EDITABLE"/>
						</textarea><br />
					</div>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
</xsl:template>



	

	
</xsl:stylesheet>
