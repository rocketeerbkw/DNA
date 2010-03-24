<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">



<xsl:template name="MEDIA_ASSET_ARTICLE_STRONG_CONTENT_NOT_SIGNEDIN">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIA_ASSET_ARTICLE_STRONG_CONTENT_NOT_SIGNEDIN</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<h1><img src="{$imagesource}h1_contentadvice.gif" alt="content advice" width="179" height="26" /></h1>

	<div id="imageIndex" class="default">
		<div class="col1">
			<div class="margins">
					
				
				<p>The content on Comedy Soup comes from site users. Its tone is alternative and irreverant and some content is not suitable for a younger audience.</p>
				
				<p>This media contains: <strong><xsl:value-of select="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT_DESC" /></strong></p>
				
				<p>To view this page you will need to</p>
				<a href="{concat($sso_rootregister, 'SSO%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)}" class="button"><span><span><span>Create your membership</span></span></span></a>
				<br />
				<br />
				<p>Or, if you have already done that, simply</p>
				<a href="{concat($sso_rootlogin, 'SSO%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)}" class="button"><span><span><span>Sign in</span></span></span></a>
				<br /><br /><br />
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

<xsl:template name="MEDIA_ASSET_ARTICLE_STRONG_CONTENT_SIGNEDIN">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIA_ASSET_ARTICLE_STRONG_CONTENT_SIGNEDIN</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<!--
	 determine whether this is a programme challenge submission.
	 a pc article will have a PCCAT element in extra info
	 which holds the category id of the programme challenge
	-->
	<xsl:variable name="pccat">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/PCCAT"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/PCCAT"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="is_programme_challenge">
		<xsl:choose>
			<xsl:when test="$pccat != 0 and /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="programme_challenge_name" select=" /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]"/>
	
	<h1><img src="{$imagesource}h1_contentadvice.gif" alt="content advice" width="179" height="26" /></h1>

	<div id="imageIndex" class="default">
		<div class="col1">
			<div class="margins">
					
				<p>The content on Comedy Soup comes from site users. Its tone is alternative and irreverant and some content is not suitable for a younger audience.</p>
				
				<p>This media contains: <strong><xsl:value-of select="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT_DESC" /></strong></p>
				
				<p>Do you want to continue?</p>
				<a href="?s_select=yes" class="button"><span><span><span>Yes, carry on</span></span></span></a>
				&nbsp;
				<a href="{$root}" onclick="history.back();return false;" class="button"><span><span><span>No, go back</span></span></span></a>					
				<br /><br /><br />
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>

</xsl:template>



<!-- MEDIA_ASSET_ARTICLE 
used for the layout of an article with a media asset - the final layout when an asset has passed moderation or when being viewed by an editor  -->
<xsl:template name="MEDIA_ASSET_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIA_ASSET_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!--
	 determine whether this is a programme challenge submission.
	 a pc article will have a PCCAT element in extra info
	 which holds the category id of the programme challenge
	-->
	<xsl:variable name="pccat">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/PCCAT"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/PCCAT"/></xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="is_programme_challenge">
		<xsl:choose>
			<xsl:when test="$pccat != 0 and /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="programme_challenge_name" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/DISPLAYNAME"/>
	<xsl:variable name="auto_add_to_cat" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGESAUTOADDTOCAT"/>
	<xsl:variable name="h2g2id" select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
			
	<!-- page title -->
	<h1>
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1 or $current_article_type=10">
				<img src="{$imagesource}h1_imagesubmission.gif" alt="image submission" width="634" height="26" />
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2 or $current_article_type=11">
				<img src="{$imagesource}h1_audiosubmission.gif" alt="audio submission" width="634" height="26" />
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 or $current_article_type=12">
				<img src="{$imagesource}h1_videosubmission.gif" alt="video submission" width="634" height="26" />
			</xsl:when>
		</xsl:choose>
	</h1>
	
	<xsl:if test="$test_IsEditor=1 or $user_is_assetmoderator=1 or $user_is_moderator=1">
		<div class="moderatorbox">
		<xsl:if test="/H2G2/ARTICLE/GUIDE/TALENTCOMPETITION='on'">
				<p><strong>THIS IS ENTERED FOR THE TALENT COMPETITION</strong></p>
		</xsl:if>
		<p>
			Article number: <strong><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></strong><br />
			<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID">
			Mediaasset number: <xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID"/>
			</xsl:if>
			<xsl:if test="/H2G2/ARTICLE/EXTRAINFO/SUBMISSION_METHOD">
			<br />Submission method: <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/SUBMISSION_METHOD"/>
			</xsl:if>

			<!--
			<xsl:choose>
				<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID">
					<form name="updatemediaasset" method="post" action="{$root}MediaAsset">
						<input type="hidden" name="id" value="{/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID}"/>
						<input type="hidden" name="_msxml" value="{$updateassetfields}"/>
						<input type="hidden" name="action" value="update"/>
						<input type="hidden" name="s_articleid" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
						<input type="submit" value="Edit Media Asset"/>
					</form>
				</xsl:when>
				<xsl:otherwise>
					No media asset asset available
				</xsl:otherwise>
			</xsl:choose>
			-->
			
		</p>
		</div>
	</xsl:if>
	
	<xsl:if test="$test_IsEditor=1 or $user_is_assetmoderator=1 or $user_is_moderator=1">
	<!-- moderation status for editores-->
		<div class="editbox">
			<p>Moderation Status: 
			<xsl:choose>
				<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=1">
				Failed
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=2">
				Refered
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=3">
				In moderation
				</xsl:when>
				<xsl:when test="/H2G2/@type='TYPED-ARTICLE'">
				In moderation
				</xsl:when>
				<xsl:otherwise>
				Passed
				</xsl:otherwise>
			</xsl:choose>(<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN"/>)</p>
		
			<xsl:if test="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT='on'">
				<p>Content advice: <xsl:value-of select="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT_DESC" /></p>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="$is_programme_challenge=1">
					<xsl:choose>
						<xsl:when test="not($auto_add_to_cat=1)">
							<p><a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat($root,'editcategory?action=doaddarticle&amp;h2g2id=',$h2g2id,'&amp;nodeid=',$pccat)"/>
								</xsl:attribute>
								Add to challenge category (<xsl:value-of select="$pccat"/>)
							</a></p>
						</xsl:when>
						<xsl:otherwise>
							Article automatically added to category <xsl:value-of select="$pccat"/>.<br/>
							(PROGRAMMECHALLENGESAUTOADDTOCAT in siteconfig set to 1)
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:if>
	
	<xsl:if test="$test_IsEditor=1 or $user_is_assetmoderator=1 or $user_is_moderator=1">
        <!-- 
            if this is a video submission in moderation mode, write out the contents
            of the .asx (wmv format) or .ram (ra format) file for editors.
        -->
		<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 or $current_article_type=12">
		    <xsl:variable name="aspectratio">
			<xsl:choose>
			    <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ASPECTRATIO='16 x 9'">16x9</xsl:when>
			    <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ASPECTRATIO='4 x 3'">4x3</xsl:when>
			</xsl:choose>
		    </xsl:variable>

		    <xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='wmv' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='video/x-ms-wmv'">
			    <div class="moderatorbox">
				Filename: <strong><xsl:value-of select="concat(/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'_',$aspectratio,'_bb.asx')"/></strong><br/>
						<div class="hozDots"></div>
				<code>
				    &lt;ASX version = "3.0"&gt;<br/>
				    <br/>
				    &#160;&lt;ENTRY&gt;<br/>
				    <br/>
				    &#160;&lt;TITLE&gt;<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>&lt;/TITLE&gt;<br/>
				    <br/>
				    &#160;&#160;&lt;AUTHOR&gt;<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/OWNER/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/OWNER/USER/LASTNAME"/>&lt;/AUTHOR&gt;<br/>
				    <br/>
				    &#160;&#160;&lt;COPYRIGHT&gt;<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/OWNER/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/OWNER/USER/LASTNAME"/>&lt;/COPYRIGHT&gt;<br/>
				    <br/>
				    &#160;&#160;&#160;&lt;REF HREF="<xsl:value-of select="concat('mms://wm.bbc.net.uk/comedysoup/video/bb/',/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'_',$aspectratio,'_bb.wmv')"/>"/&gt;<br/>
				    <br/>
				    <br/>
				    &#160;&lt;/ENTRY&gt;<br/>
				    <br/>
				    &lt;/ASX&gt;
				</code>
			    </div>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='rm' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='application/vnd.rn-realmedia'">
			    <div class="moderatorbox">
				Filename: <strong><xsl:value-of select="concat(/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'_',$aspectratio,'_bb.ram')"/></strong><br/>
						<div class="hozDots"></div>
				<code>
				    <xsl:value-of select="concat('rtsp://rm.bbc.co.uk/comedysoup/video/bb/',/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'_',$aspectratio,'_bb.rm')"/>
				</code>
			    </div>
			</xsl:when>
		    </xsl:choose>
		</xsl:if>
    	</xsl:if>
		
	<!-- 2 columns -->
	<div class="default">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
				<xsl:attribute name="id">imageArticle</xsl:attribute>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
				<xsl:attribute name="id">audioArticle</xsl:attribute>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
				<xsl:attribute name="id">videoArticle</xsl:attribute>
			</xsl:when>
		</xsl:choose>
		<div class="col1">
			<div class="margins">
				<div>
					<xsl:choose><!-- this class changes the size of the image area -->
						<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1 or (/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 and /H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed')">
							<xsl:attribute name="class">largeFB</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">mediumFB</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<!-- article title -->
					
					<h2 class="mainHeader">
						<xsl:if test="$is_programme_challenge=1">
							<span class="orange">
								<xsl:value-of select="$programme_challenge_name"/>:
							</span>
						</xsl:if>
						<xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/>					
					</h2>
					
					<!-- image -->
					<xsl:variable name="raw_class">
						imageHolder
						<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 and /H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed'">
							<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE"/>
						</xsl:if>
					</xsl:variable>
					<div>
						<xsl:attribute name="class">
							<xsl:value-of select="translate(normalize-space($raw_class), '&#xA;&#9;&#10;', '')"/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
								<a href="{$articlemediapath}{/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID}_raw.{$articlemediasuffix}{$moderationsuffix}"><xsl:apply-templates select="/H2G2/MEDIAASSETINFO/MEDIAASSET" mode="image_displaymediaasset_article"/></a>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
								<img src="{$imagesource}audio_asset_187x187.gif" width="187" height="187" alt="audio placeholder"/>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 and /H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed'">
								<!-- embed the video rather than show a thumbnail -->
								<xsl:variable name="v_url">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='YouTube'">
											<xsl:value-of select="concat($youtube_video_base_url, /H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID)"/>
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='Google'">
											<xsl:value-of select="concat($google_video_base_url, /H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID, '&amp;hl=en')"/>
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='MySpace'">
											<xsl:value-of select="$myspace_video_base_url"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="v_width">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='YouTube'">
											400
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='Google'">
											400
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='MySpace'">
											400
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="v_height">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='YouTube'">
											329
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='Google'">
											326
										</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='MySpace'">
											322
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="v_flashvars">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='YouTube'"></xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='Google'"></xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE='MySpace'">
											m=<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID"/>&amp;type=video&amp;cp=1
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<script language="JavaScript" type="text/javascript">
									var video = new bbcjs.plugins.FlashMovie("<xsl:value-of select="normalize-space($v_url)"/>");
									video.version = 6;
									video.width = <xsl:value-of select="normalize-space($v_width)"/>;
									video.height = <xsl:value-of select="normalize-space($v_height)"/>;
									video.flashvars = '<xsl:value-of select="normalize-space($v_flashvars)"/>';
									video.id = 'VideoPlayback';
									
									video.embed();
								</script>
								<noscript>
									We can't detect if you have flash or not, please go to the
									<a href="http://www.bbc.co.uk/webwise/askbruce/articles/download/whatpluginsdoineed_1.shtml">BBC WebWise</a>
									and follow the instructions for Flash Player.
								</noscript>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
								<img src="{$imagesource}video/187/{/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID}.jpg" width="187" height="187" alt="video placeholder"/>
							</xsl:when>
						</xsl:choose>
					</div>
					<div class="content"><br />
						<!-- created by -->
						<div class="author">created by <a href="{root}U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" /></a></div><br />
						<!-- Published by -->
						<div class="info"><b>Submitted:</b> <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" />/<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTH" />/<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" /></div>
						
						<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2 or /H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3" >
							<!-- Duration -->
							<div class="info"><b>Duration:</b><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DURATION_MINS"/>:<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DURATION_SECS"/>min</div>
							<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3 and not(/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed')" >
								<!-- Aspect Ratio -->
								<div class="info"><b>Aspect Ratio:</b><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/ASPECTRATIO"/></div>
							</xsl:if>
						</xsl:if>
						
						<!-- user rating -->
						
							<div class="starRating">user rating: 
								<xsl:choose>
									<xsl:when test="$poll_average_score > 0" >
										<img src="{$imagesource}stars_{floor($poll_average_score)}.gif" alt="{floor($poll_average_score)}" width="65" height="12" />
									</xsl:when>
									<xsl:otherwise>
										not yet rated
									</xsl:otherwise>
								</xsl:choose>
							</div>
						
						<!-- link to mediaasset -->
						<xsl:choose>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
								<!-- image link -->
								<a href="{$articlemediapath}{/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID}_raw.{$articlemediasuffix}{$moderationsuffix}" class="button"><span><span><span>View full size</span></span></span></a>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
								<!-- audio link -->
								<xsl:variable name="media">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='rm' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='application/vnd.rn-realmedia'">&amp;nbram=1</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='ra' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='audio/x-pn-realaudio'">&amp;nbram=1</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='wma' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='audio/x-ms-wma'">&amp;nbwm=1</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<a href="{concat('http://www.bbc.co.uk/mediaselector/check/comedysoup/richmedia/audio/',/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'?bgc=FF005A&amp;size=au',$media )}" onclick="window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')" target="avaccesswin" class="button"><span><span><span>Play Audio Clip</span></span></span></a>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
								<!-- video link -->
								<xsl:variable name="aspectratio">
									<xsl:choose>
										<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ASPECTRATIO='16 x 9'">16x9</xsl:when>
										<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ASPECTRATIO='4 x 3'">4x3</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="media">
									<xsl:choose>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='rm' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='application/vnd.rn-realmedia'">&amp;bbram=1</xsl:when>
										<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='wmv' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='video/x-ms-wmv'">&amp;bbwm=1</xsl:when>
									</xsl:choose>
								</xsl:variable>	
								
								<xsl:if test="not(/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed')">
									<a href="{concat('http://www.bbc.co.uk/mediaselector/check/comedysoup/richmedia/video/',/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID,'?bgc=FF005A&amp;size=',$aspectratio,$media )}" onclick="window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')" target="avaccesswin" class="button"><span><span><span>Play Video Clip</span></span></span></a>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
						
						<xsl:if test="not(/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTRAELEMENTXML/SUBMISSION_METHOD='embed')">
							<br /><br />
						</xsl:if>
					
						<!-- plugin link -->
						<xsl:choose>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='wmv' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='video/x-ms-wmv' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='wma' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='audio/x-ms-wma'">
								<div class="info">Requires <a href="http://www.microsoft.com/windows/windowsmedia/mp10/default.aspx">Windows media player</a></div>
							</xsl:when>
							<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='rm' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='application/vnd.rn-realmedia' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='ra' or /H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='audio/x-pn-realaudio'">
								<div class="info">Requires <a href="/webwise/askbruce/articles/download/howdoidownloadrealplayer_1.shtml">Real Player</a></div>
							</xsl:when>
						</xsl:choose>
					</div>
					<div class="clr"></div>
				</div>
				
				<div class="hozDots"></div>
				
				<p>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
					
				</p>
				
				<div class="hozDots"></div>
				<!-- Related links -->
				
				<xsl:if test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL[text()] or /H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL[text()] or /H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL[text()]">
					<h2>Related links:</h2>
				</xsl:if>
				<p>
					<!-- link 1 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS1URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					
					<!-- link 2 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS2URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					
					<!-- link 3 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/RELATEDLINKS3URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					</p>
				
				
				<!-- Additional credits -->
				<xsl:if test="/H2G2/ARTICLE/GUIDE/REFERENCES[text()]">
					<h2>Additional credits:</h2>
				</xsl:if>
				
				<p>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/REFERENCES"/>	
				</p>
				
				<!-- add to favourites (clipping) link -->
				<!--
				<p>
					<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_clip"/>
				</p>
				-->
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:if test="$is_programme_challenge">
					<xsl:apply-templates select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/GUIDE"/>
				</xsl:if>
				
				<div class="contentBlock">		
					<xsl:apply-templates select="/H2G2/POLL-LIST" mode="c_articlepage"/>
				</div>
				<!--
				<div class="contentBlock">
					<h2>Add this entry to your personal space</h2>
					<a href="insert_url" class="button"><span><span><span>Add</span></span></span></a>
				</div>
				-->
				<div class="contentBlock">
					<h2>Like this submission?</h2>
					<a onClick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer" class="button"><span><span><span>Send to a friend</span></span></span></a>
				</div>
				
				<!-- if video display the bbc three promo -->
				<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
					<xsl:apply-templates select="/H2G2/SITECONFIG/BBCTHREE" />
				</xsl:if>
				
				<div class="contentBlock">
					<h2>BBC Stuff</h2>
					<p>Want to build a feature of your own? We've got plenty of <a href="{$root}MediaAssetSearchPhrase">raw material</a> to get you started.</p>
				</div>
				
				<div class="contentBlock">
					<a href="{$root}submityourstuff" class="button twoline"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
				</div>
				
				<div class="contentBlock">
					<p><a href="/dna/comedysoup/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="_blank" onclick="popupwindow('/dna/comedysoup/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=620,height=480');return false;" xsl:use-attribute-sets="maHIDDEN_r_complainmp"><img src="{$imagesource}icon_complain_white.gif" alt="" width="16" height="16" /> &nbsp; Complain about this page</a></p>
				</div>
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
	
</xsl:template>



<xsl:template name="IMAGE_ASSET_ARTICLE_SUBMITTED">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">IMAGE_ASSET_ARTICLE_SUBMITTED</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<h1><img src="{$imagesource}h1_done.gif" alt="done!" width="74" height="26" /></h1>
	
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<div class="col1">
			<div class="margins">
				
				<xsl:choose>
					<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
						<!-- user viewing own article -->
						<h2>Your image is on its way to us!</h2>
				
						<p>Your image will be checked over by the moderation team and, if 
						it's approved, it will go up on the site. You don't need to do 
						anything else.</p>
						
						<div class="hozDots"></div>
						
						<p>You can keep an eye on the progress of your submission in your <a href="{$root}U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">personal space</a>.</p>
					</xsl:when>
					<xsl:otherwise>
						<!-- user viewing someone elses article -->
						<h2>This piece of work has not yet been approved for publication</h2>
					</xsl:otherwise>
				</xsl:choose>
				
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
				<div class="contentBlock">
					<h2>What are other people up to?</h2>
					<p>Have a look at <a href="{$root}thelatest">the latest</a> stuff.</p>
				</div>
				
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
	
	
</xsl:template>

<xsl:template name="AV_ASSET_ARTICLE_SUBMITTED">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">AV_ASSET_ARTICLE_SUBMITTED</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID and not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed')">
			<!-- user viewing own article -->
			<h1><img src="{$imagesource}h1_sendittous.gif" alt="send it to us (say something funny)" width="288" height="26" /></h1>
		</xsl:when>
		<xsl:otherwise>
			<!-- user viewing someone elses article -->
			<h1><img src="{$imagesource}h1_done.gif" alt="done!" width="74" height="26" /></h1>
		</xsl:otherwise>
	</xsl:choose>
	
	
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<div class="col1">
			<div class="margins">
				<xsl:choose>
					<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
						<!-- user viewing own article -->
						
						
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
								<!-- EMAIL -->
								<div class="calHeader">
									<ul class="uploadProgress">
										<li class="step1">Step 1: about your media</li>
										<li class="step2 selected">Step 2: email your media</li>
									</ul>
								</div>
								<p><strong>You can now send us your media as an email attachment.</strong></p>
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
								<!-- POST -->
								<div class="calHeader">
									<ul class="uploadProgress">
										<li class="step1">Step 1: about your media</li>
										<li class="step2 selected">Step 2: post your media</li>
									</ul>
								</div>
								
								<p><strong>You can now post your media to us.</strong></p>
							</xsl:when>
						</xsl:choose>
						
						
						<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='embed')">
							<div class="hozDots"></div>

							<p>We can only accept the following file types:<br />
							<xsl:choose>
								<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
								.rm, .ra, .wma
								</xsl:when>
								<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
								.rm, .wmv
								</xsl:when>
							</xsl:choose>
							</p>

							<div class="hozDots"></div>
						</xsl:if>

						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='email'">
								<!-- EMAIL -->
								<p><b>Use the following link to send us your media:</b></p>
								<a href="mailto:comedysoup.submit@bbc.co.uk?subject=A{ARTICLEINFO/H2G2ID} | {/H2G2/MEDIAASSETINFO/ID} | U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}" class="button"><span><span><span>Email your media</span></span></span></a>
				
								<br />
								<br />
								
								
								<p>If the above link doesn't work (if you have web based email like Hotmail or Yahoo), send 
								us your file along with your reference number to the following email address:</p>
								
								<div class="referenceBlockColumns">
									<div class="col1">
										<div class="referenceBlock">
											<div class="label">Your reference number is:</div>
											<div class="referenceNo">A<xsl:value-of select="ARTICLEINFO/H2G2ID" /></div>
										</div>
									</div>
									<div class="col2">
										<br />
										<b><a href="mailto:comedysoup.submit@bbc.co.uk?subject=A{ARTICLEINFO/H2G2ID} | {/H2G2/MEDIAASSETINFO/ID} | U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">comedysoup.submit@bbc.co.uk</a></b>
									</div>
									<div class="clr"></div>
								</div>	
								<div class="hozDots"></div>
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='post'">
								<!-- POST -->
								<p><b>Send it to the following address along with your reference number:</b></p>
						
								<div class="referenceBlockColumns">
									<div class="col1">
										<div class="referenceBlock">
											<div class="label">Your reference number is:</div>
											<div class="referenceNo">A<xsl:value-of select="ARTICLEINFO/H2G2ID" /></div>
										</div>
									</div>
									<div class="col2">
										ComedySoup<br />
										MC1 D3 Media Centre,<br />
										BBC Media Village,<br />
										201 Wood Lane,<br />
										London. W12 7TQ<br />
									</div>
									<div class="clr"></div>
								</div>	
								<p>Please also include your <strong>email address</strong> so we can contact you if there's a problem.</p>
								
								<div class="hozDots"></div>								
							</xsl:when>
						</xsl:choose>
						
						
						<h2>What happens next?</h2>
						
						<p>Your piece will be checked over by the moderation team and, if it's approved, it will go up on the site. you don't need to do anything else.</p>
						
						<p>You can keep an eye on the progress of your submission in your <a href="{$root}U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">personal space</a>.</p>
					</xsl:when>
					<xsl:otherwise>
						<!-- user viewing someone elses article -->
						<h2>This piece of work has not yet been approved for publication</h2>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:comment>#include virtual="/comedysoup/includes/submityourstuff.ssi"</xsl:comment>
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

<xsl:template name="MEDIAASSET_ARTICLE_AWAITING_MODERATION">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIAASSET_ARTICLE_AWAITING_MODERATION</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<h1><img src="{$imagesource}h1_done.gif" alt="done!" width="74" height="26" /></h1>
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<div class="col1">
			<div class="margins">
				<xsl:choose>
					<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
						<!-- user viewing own article -->
						<p>You work is currently in moderation - go to your <a href="{$root}U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">personal space</a> to check its progress</p>
					</xsl:when>
					<xsl:otherwise>
						<!-- user viewing someone elses article -->
						<h2>This piece of work has not yet been approved for publication</h2>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
				<div class="contentBlock">
					<h2>What are other people up to?</h2>
					<p>Have a look at <a href="{$root}thelatest">the latest</a> stuff.</p>
				</div>
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

<xsl:template name="MEDIAASSET_ARTICLE_NOT_PASSED">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEDIAASSET_ARTICLE_NOT_PASSED</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<h1><img src="{$imagesource}h1_done.gif" alt="done!" width="74" height="26" /></h1>
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<div class="col1">
			<div class="margins">
				<!-- <p>This article has been REFFERED, FAILED or HELD</p> -->
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
				<div class="contentBlock">
					<h2>What are other people up to?</h2>
					<p>Have a look at <a href="{$root}thelatest">the latest</a> stuff.</p>
				</div>
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

<xsl:template name="EDITORIAL_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<h1><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/GRAPHICTITLE/IMG"/></h1>
	<!-- 2 columns -->
	<div id="submitAv1" class="default">
		<div class="col1">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COL2"/>
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

<xsl:template name="ASSET_LIBRARY_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ASSET_LIBRARY_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- title -->
	<h1><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/GRAPHICTITLE/IMG"/></h1>
	<!-- 2 columns -->
	<div id="creativeArchiveSections" class="assets">
		<div class="col1">
			<div class="margins">
			<ul class="assetNav3Col">
				<li><a href="{$root}MediaAssetSearchPhrase?contenttype=3">Video assets</a></li>
				<li><a href="{$root}MediaAssetSearchPhrase?contenttype=1">Images assets</a></li>
				<li class="last"><a href="{$root}MediaAssetSearchPhrase?contenttype=2">Audio assets</a></li>
				<div class="clr"></div>
			</ul>
			
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
				
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COL2"/>
				
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
</xsl:template>

</xsl:stylesheet>
