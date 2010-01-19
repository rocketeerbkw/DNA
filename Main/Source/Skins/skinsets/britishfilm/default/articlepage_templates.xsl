<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:if test="/H2G2/@TYPE='ARTICLE'">

				<h1 class="yourfilms"><img src="{$imagesource}yourfilms.jpg" alt="Your films" /></h1>
	
				<div id="mainintro">
				
					<!-- CV Conditional: Only embed youTube if code is submitted -->
					<xsl:if test="GUIDE/VIDEOLINK">
						<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_core.js" type="text/javascript" language="JavaScript"></script>
						<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_img.js" type="text/javascript" language="JavaScript"></script>
						<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_css.js" type="text/javascript" language="JavaScript"></script>
						<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_win.js" type="text/javascript" language="JavaScript"></script>
						<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_plugins.js" type="text/javascript" language="JavaScript"></script>
						<script src="http://www.bbc.co.uk/webwise/support.js" type="text/javascript"></script>

							<div class="image">
								<!-- CV Don't know what this image tag should do. Should it be included if youTube code is not submitted? -->
								<!-- <img src="/images/home/quantumsandwich.jpg" alt="The Quantum Sandwich" /> -->
								<script language="JavaScript" type="text/javascript">
									<xsl:comment>
									var myFlashMovie = new bbcjs.plugins.FlashMovie("<xsl:value-of select="GUIDE/VIDEOLINK" />" ,8, 411, 338);
									myFlashMovie.lowversion = '<p>BBC Mini Movies uses Flash and will play embeded flash video. You need to download or upgrade your Flash player to view this console. You can find out more about this at <![CDATA[<<bbcjs.plugins.wwguides.flash>>]]>.</p>';
									myFlashMovie.flashvars = '';
									myFlashMovie.noflash = myFlashMovie.lowversion;
									myFlashMovie.embed();									
									</xsl:comment>
								</script>
								<!-- End Flash embed -->
								<noscript>
								<p>BBC Mini Movies uses Flash and will launch in a pop-up window. You need Javascript enabled on your browser to view this console. You can find out more about this at <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml" >BBC Webwise</a>.</p>
								</noscript>
								<!-- <xsl:apply-templates select="GUIDE/VIDEOLINK" mode="copy" /> -->
							</div>
					</xsl:if>
					
					<div class="text">
						
						<h2 class="articleTitle"><xsl:value-of select="SUBJECT" /></h2>
						
						<!-- Film Rating -->
						<xsl:choose>
							<xsl:when test="floor($poll_average_score) = 1">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($poll_average_score) = 2">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($poll_average_score) = 3">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($poll_average_score) = 4">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($poll_average_score) = 5">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
								</div>
							</xsl:when>
							
							<xsl:otherwise>
								<div class="filmrating">
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:otherwise>
						</xsl:choose>				
						
						<div class="filmlinks">
							<xsl:for-each select="GUIDE/GENRE01 | GUIDE/GENRE02 | GUIDE/GENRE03">
								<xsl:if test=".!=''">

									<!-- we do calls to get readable search term back in here -->
									<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={.}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="." />
										</xsl:with-param>
									</xsl:call-template></a> |
								</xsl:if>
							</xsl:for-each>	
							<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={GUIDE/THEME}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="GUIDE/THEME" />
										</xsl:with-param>
									</xsl:call-template></a>		
						</div>
						
						<div class="filmblurb"><xsl:value-of select="GUIDE/TAGLINE" /></div>
	
						<div class="filminfo">
							<!-- CV Seconds don't seem to be included in the design. Is this an oversight? -->
							<xsl:value-of select="GUIDE/DIRECTOR" /> | <xsl:value-of select="GUIDE/LENGTH_MIN" /> minutes <xsl:value-of select="GUIDE/LENGTH_SEC" /> seconds
						</div>

						
						
						<!-- Rate this article -->
						<xsl:apply-templates select="/H2G2/POLL-LIST" mode="c_articlepage"/>


						<a href="/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk/dna/britishfilm/" onClick="popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk/dna/britishfilm/','Mailer')" target="Mailer" class="emailafriend"><img src="{$imagesource}emailtoafriend.gif" alt="Email to a friend" /></a>
						<div class="filminfo"><!-- USER COMPLAIN -->
							 &nbsp;<a href="dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?s_start=1&amp;h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')"><img align="absmiddle" border="0" src="{$imagesource}reportcomment.gif" alt="!"/></a> Alert a moderator
						</div>
					</div>
					
				</div>
				<div id="synopsis">			
					<h2>Synopsis</h2>
					<p><xsl:apply-templates select="GUIDE/BODY" /></p>
				</div>

				<xsl:if test="string-length(GUIDE/RELATEDLINKS) &gt; 0">
				<div id="relatedlinks">
					<h2>Related links</h2>
					<p><xsl:apply-templates select="GUIDE/RELATEDLINKS" /></p>
				</div>
				</xsl:if>

				<div id="articlewrapper">
				    <div id="talking">
				        <!-- comments closed down -->
				    <!--<h2><img src="{$imagesource}addyourcomments.jpg" alt="Add your comments" /></h2>-->
					<!--<div class="addyourtipcontainer"><a href="{$root}Addthread?forum={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}&amp;action=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="addyourtip"><img src="{$imagesource}addyourtip_btn.jpg" alt="" align="absmiddle" />Add your comment</a></div>-->
					
					<xsl:for-each select="../ARTICLEFORUM/FORUMTHREADPOSTS/POST">
					<!-- Comment -->
					<div class="quote">
					<!-- <div class="quote last"> -->
						<h3>
						<span>Comment by <strong><xsl:value-of select="USER/USERNAME" /></strong></span>
						<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></h3>
						<p class="posted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></p>
						<p class="commenttext"><xsl:value-of select="TEXT" /></p>
					</div>
					</xsl:for-each>
	
					<xsl:if test="../ARTICLEFORUM/FORUMTHREADPOSTS/POST">
					 <!-- comments closed down -->
					<!--<div class="addyourtipcontainer"><a href="{$root}Addthread?forum={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}&amp;action=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="addyourtip"><img src="{$imagesource}addyourtip_btn.jpg" alt="" align="absmiddle" />Add your comment</a></div>-->
					
					<p class="houserules">Click <img src="{$imagesource}reportcomment.gif" alt="!" align="absmiddle" /> on a comment that breaks the <a href="/dna/britishfilm/houserules" class="bold">house rules</a>.</p>
					</xsl:if>
				</div>
				</div>
	
		</xsl:if>
	
		<!-- SUBMIT YOUR FILM -->
		<xsl:if test="GUIDE/RIGHTCOL_SUBMIT = 'on'">
			<xsl:apply-templates select="GUIDE/RIGHTCOL_SUBMIT" mode="rightcol" />
		</xsl:if>
		
		<!-- BROWSE -->
		<xsl:if test="GUIDE/RIGHTCOL_BROWSE = 'on'">
			<xsl:apply-templates select="GUIDE/RIGHTCOL_BROWSE" mode="rightcol" />	
		</xsl:if>

		<!-- TIPS -->
		<xsl:if test="GUIDE/RIGHTCOL_TIPS = 'on'">
			<xsl:apply-templates select="GUIDE/RIGHTCOL_TIPS" mode="rightcol" />
		</xsl:if>

		<!-- LINKS -->
		<xsl:if test="GUIDE/RIGHTCOL_LINKS = 'on'">
			<xsl:apply-templates select="GUIDE/RIGHTCOL_LINKS" mode="rightcol" />
		</xsl:if>		
		
	



</xsl:template>











<xsl:template name="EDITORIAL_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	

		<!-- <div><h3><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></h3></div>
		

	

		
			<div>
				<xsl:if test="$current_article_type=3">
					<xsl:attribute name="class">bodytext2</xsl:attribute>
				</xsl:if>
			
				<div> -->
					<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY"/>
			<!-- 	</div>			
			</div>-->

			<xsl:if test="$current_article_type = 12">
				<!-- <div>
					Discussion section will go here. TIPS PAGES
				</div> -->
				<div id="articlewrapper">
				    <div id="talking">
				        <!-- tips closed down -->
				    <!--<h2 ><img src="{$imagesource}addyourtips.gif" alt="Add your tips" /></h2>-->
					<!--<div class="addyourtipcontainer"><a href="{$root}Addthread?forum={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}&amp;action=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="addyourtip"><img src="{$imagesource}addyourtip_btn.jpg" alt="" align="absmiddle" />Add your tip</a></div>-->
					
					<xsl:for-each select="../ARTICLEFORUM/FORUMTHREADPOSTS/POST">
					<!-- Comment -->
					<div class="quote">
					<!-- <div class="quote last"> -->
						<h3>
						<span>Comment by <strong><xsl:value-of select="USER/USERNAME" /></strong></span>
						<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></h3>
						<p class="posted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></p>
						<p class="commenttext"><xsl:value-of select="TEXT" /></p>
					</div>
					</xsl:for-each>
	
					<xsl:if test="../ARTICLEFORUM/FORUMTHREADPOSTS/POST">
					    <!-- tips closed down -->
					<!--<div class="addyourtipcontainer"><a href="{$root}Addthread?forum={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}&amp;action=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="addyourtip"><img src="{$imagesource}addyourtip_btn.jpg" alt="" align="absmiddle" />Add your tip</a></div>-->
					
					<p class="houserules">Click <img src="{$imagesource}reportcomment.gif" alt="!" align="absmiddle" /> on a comment that breaks the <a href="/dna/britishfilm/houserules" class="bold">house rules</a>.</p>
					</xsl:if>
				</div>
				</div>
			</xsl:if> 
			
		


	
			
				<!-- DYNAMIC LIST / FAVORITES (?)-->
				<xsl:if test="/H2G2/ARTICLE/GUIDE/DYNAMICLIST = 'on' and /H2G2/DYNAMIC-LISTS/LIST/ITEM-LIST/ITEM[position() &lt;= 3]">
					<xsl:apply-templates select="DYNAMIC-LISTS" mode="rightcol" />
				</xsl:if>
				
				<!-- SUBMIT YOUR FILM -->
				<xsl:if test="GUIDE/RIGHTCOL_SUBMIT = 'on'">
					<xsl:apply-templates select="GUIDE/RIGHTCOL_SUBMIT" mode="rightcol" />
				</xsl:if>
				
				<!-- BROWSE -->
				<xsl:if test="GUIDE/RIGHTCOL_BROWSE = 'on'">
					<xsl:apply-templates select="GUIDE/RIGHTCOL_BROWSE" mode="rightcol" />	
				</xsl:if>

				<!-- TIPS -->
				<xsl:if test="GUIDE/RIGHTCOL_TIPS = 'on'">
					<xsl:apply-templates select="GUIDE/RIGHTCOL_TIPS" mode="rightcol" />
				</xsl:if>

				<!-- LINKS -->
				<xsl:if test="GUIDE/RIGHTCOL_LINKS = 'on'">
					<xsl:apply-templates select="GUIDE/RIGHTCOL_LINKS" mode="rightcol" />
				</xsl:if>
							

	
	
</xsl:template>






<xsl:template name="COMMENT_ON_ARTICLE">
	<xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@DEFAULTCANWRITE=1"><!-- don't display in typedarticle as breaks submit button -->
	<a name="commentbox"></a>
	<div class="headbox2"><h3>Comment on this article</h3></div>
	
	<xsl:choose>
		<xsl:when test="/H2G2/SITE-CLOSED=0 or $test_IsEditor">
		
			<xsl:choose>
				<xsl:when test="/H2G2/VIEWING-USER/USER">
					<!-- display textarea for commenting if signed in -->
					<div class="formadd"> 	
						<form method="post" action="{$root}AddThread" name="theForm">
						<xsl:choose>
							<xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT=0">
								<input type="hidden" name="threadid" value="0"/>
								<input type="hidden" name="inreplyto" value="0"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="threadid" value="{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}"/>
								<input type="hidden" name="inreplyto" value="{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@POSTID}"/>
							</xsl:otherwise>
						</xsl:choose>
						<input type="hidden" name="forum" value="{ARTICLEINFO/FORUMID}"/>
						<input type="hidden" name="action" value="A{ARTICLEINFO/H2G2ID}"/>
						<input type="hidden" name="subject" value="{SUBJECT}"/>
						
						<div class="txt"><label for="text">Your comments: enter text below</label></div>
						<div class="mbx"><textarea wrap="virtual" name="body" id="text" class="inputone" cols="20" rows="6"></textarea></div>
						
						<div class="mtx">
						<input type="submit" value="PREVIEW" name="preview" class="inputpre2" />
						<input type="submit" value="SEND" name="post" class="inputsubmit2" />
						</div>
						</form>
						
						
						
						<p class="reserverights">We reserve the right to edit your comments</p>
					</div>
				
				</xsl:when>
				<xsl:otherwise>
					<!-- must sign in to vote -->
					<br />
					<div class="arrowlink">
						<a href="{$sso_signinlink}" class="strong">Sign in if you want to comment</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		
			
			<hr class="section" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="siteclosed" />
		</xsl:otherwise>
	</xsl:choose>
	
	</xsl:if>
</xsl:template>

<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							RELATED BBC LINKS	
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!-- 
	see sitevars.xsl for the following variables that are used for this functionality
	
	&teamsbysport (xml node-set)
	
	$hometeam
	$awayteam
	$currenttem
	$team (the source value of this varies depending on the type of article)
	$team2 (on a match report this is the value of the $awayteam, on a player profile it is $currentteam) 
	
	-->
<!-- 	<xsl:template match="team" mode="related_bbc_links">
		<div class="relbbc">			   
		   	<h3>RELATED BBC LINKS</h3>
			
			<xsl:apply-templates select="relatedpromo" mode="related_bbc_links">
				<xsl:with-param name="promo" select="1"/>
			</xsl:apply-templates>
			
			
			<xsl:apply-templates select="msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team2]/relatedpromo" mode="related_bbc_links">
				<xsl:with-param name="promo" select="2"/>
			</xsl:apply-templates>
			
			
			<div class="clear"></div>
		</div>
	</xsl:template> -->
	
	
<!-- 	<xsl:template match="relatedpromo" mode="related_bbc_links">
	<xsl:param name="promo"/>
	
	
	<xsl:if test="$promo=1 or ($promo=2 and msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image != image)">
	<p>
		<a href="{url}">
			<img height="66" class="imgfl" hspace="0" vspace="0" border="0" width="66" alt="" src="{$imagesource}relatedpromos/{image}.gif" />
			<strong><xsl:value-of select="@type"/></strong><br />
			<xsl:value-of select="text"/>
		</a>
	</p>
	</xsl:if>
	
	
	</xsl:template> -->

	<xsl:template match="VIDEOLINK" mode="copy">
		<xsl:copy-of select="."/>
		<!-- <xsl:copy>
			<xsl:for-each select="child::*">
				<xsl:copy>
					<xsl:apply-templates />
				</xsl:copy><br />
			</xsl:for-each> 
 		</xsl:copy> -->
	</xsl:template>

</xsl:stylesheet>