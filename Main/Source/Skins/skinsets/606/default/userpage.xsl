<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userpage.xsl"/>
	<!--
	<xsl:variable name="limiteentries" select="10"/>
	Use: sets the number of recent conversations and articles to display
	 -->
	<xsl:variable name="postlimitentries" select="5"/>
	<xsl:variable name="articlelimitentries" select="5"/>
	<xsl:variable name="clublimitentries" select="10"/>
	<xsl:variable name="morearticlesshow" select="1000"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERPAGE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USERPAGE_MAINBODY <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">userpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register'">
			<p id="newmember">
				<meta http-equiv="refresh" content="0;url={$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_display=register"/>
				Welcome, this is the first time that you have come to the site - you will need to <a href="{$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_display=register">set&nbsp;up&nbsp;your&nbsp;profile</a> before you can add any content to the site.
			</p>
			</xsl:when>
			<xsl:otherwise>
				
				<!-- don't display page to banned users-->
				<xsl:choose>
					<xsl:when test="/H2G2/PAGE-OWNER/USER/MODERATIONSTATUS/@ID=4 and not(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)">
						<!-- BANNED USER - content hidden from everyone except editors -->
					</xsl:when>
					<xsl:otherwise>
						
						<xsl:if test="/H2G2/PAGE-OWNER/USER/MODERATIONSTATUS/@ID=4 and /H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
						 	<div class="editbox">This user has been <strong>RESTRICTED</strong> - the page will appear blank to all users that are not editors</div>
						</xsl:if>
					
						<xsl:apply-templates select="/H2G2" mode="c_displayuserpage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="H2G2" mode="r_displayuserpage">
		
		<xsl:if test="/H2G2/@TYPE='USERPAGE' or /H2G2/ARTICLE-MODERATION-FORM">
			<!-- don't diplay this on TYPEDARTICLE as information pulled in from typedarticlepage.xsl instead  -->
			<xsl:call-template name="USERPAGE_BANNER" />
		</xsl:if>
		
		
	<div class="mainbodysec">		
	<div class="bodysec">	
				
		<!-- INTRO -->
		<a name="intro"></a>	
		<div class="stepsheadbox"><h3>INTRO</h3> <p class="links"><a href="#comments">comments</a>  |  <a href="#articles">articles</a> | <a href="#reports">reports</a> | <a href="#profiles">profiles</a></p></div> 
		
		<!-- only display box if content in it -->
		<xsl:if test="not(/H2G2/ARTICLE/SUBJECT='Article Pending Moderation') and (/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST1 or /H2G2/ARTICLE/GUIDE/SPORTINGINTEREST2 or /H2G2/ARTICLE/GUIDE/SPORTINGINTEREST3 or /H2G2/ARTICLE/GUIDE/FAVOURITEPLAYER/text() or /H2G2/ARTICLE/GUIDE/TEAMPLAYEDIN/text() or /H2G2/ARTICLE/GUIDE/FAVOURITEMATCH/text())">	
			
			<div class="matchstats"> 								
				
				<dl>
					<!-- Teams supported / sporting interests -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST1 or /H2G2/ARTICLE/GUIDE/SPORTINGINTEREST2 or /H2G2/ARTICLE/GUIDE/SPORTINGINTEREST3">
						<dt>Teams / sports followed:</dt>
						<dd><xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST1"/>
						
							<xsl:if test="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST2/text()">, <xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST2"/></xsl:if>
							
							<xsl:if test="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST3/text()">, <xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORTINGINTEREST3"/></xsl:if>
						<div class="clear"></div></dd>
					</xsl:if>
					
					<!-- Favourite player -->
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/FAVOURITEPLAYER/text()"/>
					
					<!-- Team played in -->
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAMPLAYEDIN/text()"/>
					
					<!-- Favourite match -->
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/FAVOURITEMATCH/text()"/>
									
				</dl>				
			</div>
		</xsl:if>
		
			
		<!-- intro text -->
		<xsl:apply-templates select="PAGE-OWNER" mode="t_userpageintro"/>
		
		<!-- intro text - on preview page and moderation page -->
		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/ARTICLE-MODERATION-FORM">
		
			<div class="quotetext">			
				<h4>More about me:</h4>
				<img height="14" hspace="0" vspace="0" border="0" width="17" alt="quote" align="left" src="{$imagesource}quotetop.gif" />
				<p><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/></p>
				<img height="14" hspace="0" vspace="0" border="0" width="17" alt="quote" align="right" src="{$imagesource}quotebot.gif" /><br clear="all" />
			</div>
		
		</xsl:if>
		 
	
	
	<xsl:if test="/H2G2/@TYPE='USERPAGE'">
		<div class="mbx">			
			<div class="flemail">
				 <div class="email"><a onClick="popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">send to a friend</a></div>
			</div>
			<xsl:if test="not($ownerisviewer=1)">
				<div class="flrcomplain">
					<div class="butcomplain"><a href="/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?s_start=1&amp;h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="ComplaintPopup" onclick="popupwindow('{$root}UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=588,height=560')">complain about this article</a></div>
				</div>
			</xsl:if>			
			<div class="clear"></div>
		</div>	
		<hr />	
	</xsl:if>
	
	<xsl:if test="$test_IsEditor">
		<div class="editbox">
			<a href="{$root}moderationhistory?h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">moderation history: A<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></a> <br />
			<!-- <a href="{$root}inspectuser?userid={/H2G2/PAGE-OWNER/USER/USERID}">inspectuser: U<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/></a> -->
<a href="{$root}inspectuser?userid={/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">inspectuser: U<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/></a>
		
		</div>
	</xsl:if>
	
	
	</div><!-- / bodysec -->	
	<div class="additionsec">	
	
		<!-- my links -->
		<xsl:if test="/H2G2/ARTICLE/GUIDE/TEAMPLAYEDINLINK/text() or /H2G2/ARTICLE/GUIDE/FAVOURITEMATCHLINK/text() or /H2G2/ARTICLE/GUIDE/EXTERNALLINK1/text() or /H2G2/ARTICLE/GUIDE/EXTERNALLINK2/text() or /H2G2/ARTICLE/GUIDE/EXTERNALLINK3/text()">
			<div class="linksbox">	
			 	<h3>MY LINKS</h3>						
				<ul class="arrow">
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAMPLAYEDINLINK/text()"/>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/FAVOURITEMATCHLINK/text()"/>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/EXTERNALLINK1/text()"/>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/EXTERNALLINK2/text()"/>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/EXTERNALLINK3/text()"/>
						
				</ul>	
				 <p class="disclaimer">
				   The BBC is not responsible for the content of external internet sites
				 </p>			
			</div>
		</xsl:if>
		
		<div class="badges">	
		 	<h3>MY BADGES</h3>
								
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="member" align="left" src="{$imagesource}bdg_member.gif" />
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBCTESTER">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="tester" align="left" src="{$imagesource}bdg_tester.gif" />
			</xsl:if>
			
			<!--
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="steward" align="left" src="{$imagesource}bdg_steward.gif" />
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="guide" align="left" src="{$imagesource}bdg_guide.gif" />
			-->
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/SCOUTS">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="scout" align="left" src="{$imagesource}bdg_scout.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/EDITOR and /H2G2/PAGE-OWNER/USER/GROUPS/MODERATOR and /H2G2/PAGE-OWNER/USER/GROUPS/REFEREE">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="manager" align="left" src="{$imagesource}bdg_manager.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/NOTABLES">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="presenter" align="left" src="{$imagesource}bdg_presenter.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBCSTAFF">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_journalist.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/GROOBERS or /H2G2/PAGE-OWNER/USER/GROUPS/CLUBMONITOR">
			<img height="54" hspace="6" vspace="5" border="0" width="54" alt="West Jesmond AFC" align="left" src="{$imagesource}bdg_jesmond_afc.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP1">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group1.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP2">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group2.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP3">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group3.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP4">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group4.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP5">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group5.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP6">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group6.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP7">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group7.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP8">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group8.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP9">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group9.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP10">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group10.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP11">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group11.gif" />
			</xsl:if>
			
			<xsl:if test="/H2G2/PAGE-OWNER/USER/GROUPS/BBC606GROUP12">
				<img height="54" hspace="6" vspace="5" border="0" width="54" alt="journalist" align="left" src="{$imagesource}bdg_BBC606Group12.gif" />
			</xsl:if>
			
			<div class="clear"></div>
			<p class="arrowlink"><a href="{$root}badges" target="badges" onClick="popupwindow(this.href,this.target,'width=623, height=502, resizable=yes, scrollbars=yes');return false;">What do these badges mean?</a></p>
							
		</div> 
		
		<xsl:if test="not(/H2G2/@TYPE='TYPED-ARTICLE')">
			<div class="hintbox">	
				<h3>MEMBER PAGE HINTS AND TIPS</h3>

				<p>Your profile is for people to learn more about you - include your sporting and non-sporting interests</p>

				<p>Your member page houses all the content you create  - use it to access all your latest contributions</p>

				<!-- Edit intro - only when site open -->
				<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
					<p class="hintlink">
						<a href="{$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Edit profile</a>
					</p>
				</xsl:if>


				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<p>You can change your nickname (as it appears to other users) at any time</p>
						<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
							<p class="hintlink">
								<a><xsl:attribute name="href"><xsl:value-of select="$userdetailslink"/></xsl:attribute>Change my 
								<!-- if site option is seected to display nickname -->nickname</a>
							</p>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<p>You can change your name (as it appears to other users) at any time</p>
						<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
							<p class="hintlink">
								<a><xsl:attribute name="href"><xsl:value-of select="$id_settingslink"/></xsl:attribute>Change my name</a>
							</p>
						</xsl:if>					
					</xsl:otherwise>
				</xsl:choose>
			</div>  
		</xsl:if>
		
	</div><!-- /  additionsec -->	

	<div class="clear"></div>
	</div><!-- / mainbodysec -->
		
	
	
	
	<xsl:if test="not(/H2G2/@TYPE='TYPED-ARTICLE' or /H2G2/ARTICLE-MODERATION-FORM)">
		<!-- hide this when being previewed in typed-article -->
		
		<!--[FIXME: remove]
		<xsl:call-template name="ADVANCED_SEARCH" />
		-->
	
		<xsl:variable name="no_context_text">
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						You currently have no
					</xsl:when>
					<xsl:otherwise>
						There are currently no
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
			<xsl:if test="/H2G2/SITE-CLOSED=1">
				<xsl:call-template name="siteclosed" />
			</xsl:if>
			
			
			<!-- COMMENTS -->
			<a name="comments"></a>
			<div class="mainbodysec">
				<div class="bodysec">	
				
				<div class="stepsheadbox">
					<h3>COMMENTS</h3> <p class="links"><a href="#intro">intro</a>  |  <a href="#articles">articles</a> | <a href="#reports">reports</a> | <a href="#profiles">profiles</a></p>
				</div> 			
				
				
				<xsl:choose>
					<xsl:when test="count(/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID=$site_number])&lt;1">
						<!-- if no comments -->
						<p class="nocontent"><xsl:value-of select="$no_context_text"/> comments</p>
					</xsl:when>
					<xsl:otherwise>
						
						<div class="bodytext">	
							<ul class="striped bodylist">	
					
						<!-- if some comments -->
						<xsl:for-each select="/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID= $site_number][position() &lt;=$postlimitentries]">
							<li><a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" class="strong">RE: <xsl:value-of select="THREAD/FORUMTITLE" /></a><br />
							
							<!-- page owners last post -->
							<xsl:if test="THREAD/LASTUSERPOST"><!-- tw added this if to remove no comment stuff from here rather then later -->
								<xsl:value-of select="$m_postedcolon"/> <xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_userpagepostdate"/>
								<xsl:text> | </xsl:text>
							</xsl:if>
							
							<!-- last reply-->
							<xsl:choose>
								<xsl:when test="HAS-REPLY=1">
									<xsl:value-of select="$m_latestreply"/> <a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;latest=1"><xsl:value-of select="THREAD/REPLYDATE/DATE/@RELATIVE"/></a>
									
									
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$m_noreplies"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> | </xsl:text>
							
							<!-- number of comments -->
								<xsl:value-of select="@COUNTPOSTS"/> comment<xsl:if test="not(@COUNTPOSTS=1)">s</xsl:if></li>	
						</xsl:for-each>
						
							</ul>
							
							
							<!-- all comments -->
							<xsl:if test="count(/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID=$site_number])&gt;$postlimitentries">
								<p><strong>&gt; <a href="MP{/H2G2/PAGE-OWNER/USER/USERID}">All comments</a></strong></p>
							</xsl:if>
						</div>
											
						
					</xsl:otherwise>
				</xsl:choose>
				
				</div><!-- / bodysec -->	
				<div class="additionsec">	
				
					<div class="hintbox">	
						<h3>COMMENTS TIPS</h3>
							<p><xsl:copy-of select="$m_UserEditWarning"/></p>
					
							<p><xsl:copy-of select="$m_UserEditHouseRulesDiscl"/></p>
					</div>  
				
				
				</div><!-- /  additionsec -->	
				
				<div class="clear"></div>
			</div><!-- / mainbodysec -->
			
			
			<!-- ARTICLES -->
			<a name="articles"></a>
			<div class="mainbodysec">
				<div class="bodysec">	
				
				<div class="stepsheadbox">
					<h3>ARTICLES</h3> <p class="links"><a href="#intro">intro</a>  |  <a href="#comments">comments</a>  |  <a href="#reports">reports</a> | <a href="#profiles">profiles</a></p>
				</div> 			
				
				
				<xsl:choose>
					<xsl:when test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15])&lt;1">
						<!-- none -->
						<p class="nocontent"><xsl:value-of select="$no_context_text"/> articles</p>
					</xsl:when>
					<xsl:otherwise>
						
						<div class="bodytext">	
							<!-- some -->
							<ul class="striped bodylist">
							<xsl:apply-templates select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15][position() &lt;=$articlelimitentries]" mode="users_article"/>
							</ul>
							
							<!-- more -->
							<xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID!= 3001][EXTRAINFO/TYPE/@ID!= 11][EXTRAINFO/TYPE/@ID!= 12])&gt;$articlelimitentries">
								<p><strong><a href="MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter=articles&amp;show={$morearticlesshow}">&gt; All articles</a></strong></p>
							</xsl:if>
						</div>
											
					</xsl:otherwise>
				</xsl:choose>
				
				
				</div><!-- / bodysec -->	
				<div class="additionsec">	
				
					<div class="hintbox">	
						<h3>ARTICLES TIPS</h3>
						<p>Choose a subject you are knowledgeable about.</p>
						
						<p>Check your facts - getting the basics wrong devalues your article.</p>
						
						<p>Keep it lively.</p>
						
						<p>Don't be frightened of being opinionated.</p>
						
												
					<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
						<p>
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<a>
									<xsl:attribute name="href">
										<xsl:call-template name="sso_typedarticle_signin">
											<xsl:with-param name="type" select="15"/>
										</xsl:call-template>
									</xsl:attribute>
									&gt; Write an article
								</a>
								
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:attribute name="href">
										<xsl:call-template name="sso_typedarticle_signin">
											<xsl:with-param name="type" select="10"/>
										</xsl:call-template>
									</xsl:attribute>
									&gt; Write an article
								</a>
							
							</xsl:otherwise>
						</xsl:choose>
						</p>
					</xsl:if>
					
					</div>  
				
				
				</div><!-- /  additionsec -->	
				
				<div class="clear"></div>
			</div>
			
			
			<!-- MATCH REPORTS -->
			<a name="reports"></a>
			<div class="mainbodysec">
				<div class="bodysec">	
				
				<div class="stepsheadbox">
					<h3>REPORTS</h3> <p class="links"><a href="#intro">intro</a>  | <a href="#comments">comments</a>  |  <a href="#articles">articles</a> | <a href="#profiles">profiles</a></p>
				</div> 			
				
				
				<xsl:choose>
					<xsl:when test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 11 or EXTRAINFO/TYPE/@ID=12])&lt;1">
						<!-- none -->
						<p class="nocontent"><xsl:value-of select="$no_context_text"/> reports</p>
					</xsl:when>
					<xsl:otherwise>
						
						<div class="bodytext">	
							<!-- some -->
							<ul class="striped bodylist">
							<xsl:apply-templates select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 11 or EXTRAINFO/TYPE/@ID=12][position() &lt;=$articlelimitentries]" mode="users_article"/>
							</ul>
							
							<!-- more -->
							<xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 11 or EXTRAINFO/TYPE/@ID=12])&gt;$articlelimitentries">
								<p><strong><a href="MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter=reports&amp;show={$morearticlesshow}">&gt; All reports</a></strong></p>
							</xsl:if>
						</div>
											
					</xsl:otherwise>
				</xsl:choose>
				
				</div><!-- / bodysec -->	
				<div class="additionsec">	
				
					<div class="hintbox">	
						<h3>REPORT TIPS</h3>
						<p><strong>Match articles</strong></p>
						<p>Keep each paragraph short and concise. Try to get the main details - goals, sendings off etc - into the first 3-4 paragraphs.</p>
						
						<p>Don't be afraid to offer your own opinions.</p>
						
						<p>Mention things like the atmosphere, the mood among fans, your matchday experience etc. </p>
						
						<p><strong>Event articles</strong></p>
						<p>Concentrate on getting the basics such as the teams/players names and the score correct.</p>
						
						<p>Put the most important thing that happened in the opening paragraph.</p>
						
						<p>Keep it lively.</p>
						
						<p>Mention things unique to your game - odd happenings in the crowd or from the players - it adds colour to your piece.</p>
						
						<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
						<p><a>
							<xsl:attribute name="href">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="11"/>
								</xsl:call-template>
							</xsl:attribute>
							&gt; Write a match article
							</a><br />
							<a>
							<xsl:attribute name="href">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="12"/>
								</xsl:call-template>
							</xsl:attribute>
							&gt; Write an event article
							</a>
						</p>
						</xsl:if>
					</div>  
				
				
				</div><!-- /  additionsec -->	
				
				<div class="clear"></div>
			</div>
			
			
			<!-- PROFILES -->
			<a name="profiles"></a>
			<div class="mainbodysec">
				<div class="bodysec">	
				
				<div class="stepsheadbox">
					<h3>PROFILES</h3> <p class="links"><a href="#intro">intro</a>  | <a href="#comments">comments</a>  |  <a href="#articles">articles</a> | <a href="#reports">reports</a></p>
				</div> 			
				
				<xsl:choose>
					<xsl:when test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 13 or EXTRAINFO/TYPE/@ID=14])&lt;1">
						<!-- none -->
						<p class="nocontent"><xsl:value-of select="$no_context_text"/> profiles</p>
					</xsl:when>
					<xsl:otherwise>
						
						<div class="bodytext">	
							<!-- some -->
							<ul class="striped bodylist">
							<xsl:apply-templates select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 13 or EXTRAINFO/TYPE/@ID=14][position() &lt;=$articlelimitentries]" mode="users_article"/>
							</ul>
							
							<!-- more -->
							<xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 13 or EXTRAINFO/TYPE/@ID=14])&gt;1">
								<p><strong><a href="MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter=profiles&amp;show={$morearticlesshow}">&gt; All profiles</a></strong></p>
							</xsl:if>
						</div>
											
					</xsl:otherwise>
				</xsl:choose>
				
				</div><!-- / bodysec -->	
				<div class="additionsec">	
				
					<div class="hintbox">	
						<h3>PROFILE TIPS</h3>
							<p><strong>Player profiles</strong></p>
							
							<p>Think about what kind of information you've looked for when your club signs or is linked with a player.</p>
							
							<p>Try to keep your player profiles as up-to-date as possible by updating them regularly.</p>
							
							<p>Don't be afraid to offer your opinions.</p> 

							
							<p><strong>Team profiles</strong></p>
							
							<p>Try to make your team profile informative, interesting and accurate.</p>

							<p>You can edit your profile to reflect the latest news and information - change in manager, for example.</p>
							
							<p>Don't be afraid to offer your opinions.</p>

							
							<xsl:if test="$ownerisviewer=1 and (/H2G2/SITE-CLOSED=0 or $test_IsEditor)">
							<p><a>
							<xsl:attribute name="href">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="13"/>
								</xsl:call-template>
							</xsl:attribute>
							&gt; Write a player profile
							</a><br />
							<a>
							<xsl:attribute name="href">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="14"/>
								</xsl:call-template>
							</xsl:attribute>
							&gt; Write a team profile
							</a>
							</p>
							</xsl:if>
					
					</div>  
				
				
				</div><!-- /  additionsec -->	
				
				<div class="clear"></div>
			</div>
			
			
			<xsl:if test="/H2G2/SITE-CLOSED=1">
				<xsl:call-template name="siteclosed" />
			</xsl:if>
			
	</xsl:if>
		
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_userpageclipped">
	Description: message to be displayed after clipping a userpage
	 -->
	<xsl:template match="CLIP" mode="r_userpageclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_taguser">
	Use: Presentation of the link to tag a user to the taxonomy
	 -->
	<xsl:template match="ARTICLE" mode="r_taguser">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						ARTICLEFORUM Object for the userpage 
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_userpage">
		<br/>
		<br/>
		<xsl:apply-templates select="FORUMTHREADS" mode="c_userpage"/>
		<xsl:apply-templates select="." mode="c_viewallthreadsup"/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Description: Presentation of the 'Click to see more conversations' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	Description: Presentation of the 'Be the first person to talk about this article' link 

	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
		<b>
			<font size="1">
				<xsl:value-of select="$m_peopletalking"/>
			</font>
		</b>
		<br/>
		<br/>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<xsl:apply-templates select="." mode="c_userpage"/>
						</font>
					</td>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<xsl:apply-templates select="following-sibling::THREAD[1]" mode="c_userpage"/>
						</font>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_userpage">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelinkup"/>
		<br/>
		<font size="1">(<xsl:value-of select="$m_lastposting"/>
			<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/>)</font>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object for the userpage
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_userpagerefs">
		<font size="3">
			<b>References</b>
		</font>
		<br/>
		<xsl:apply-templates select="ENTRIES" mode="c_userpagerefs"/>
		<xsl:apply-templates select="USERS" mode="c_userpagerefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_userpagerefsbbc"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_userpagerefsnotbbc"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
		<xsl:value-of select="$m_refentries"/>
		<br/>
		<xsl:apply-templates select="ENTRYLINK" mode="c_userpagerefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
	Use: presentation of each individual entry link
	-->
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
	<xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
		<xsl:value-of select="$m_refresearchers"/>
		<br/>
		<xsl:apply-templates select="USERLINK" mode="c_userpagerefs"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USERLINK" mode="r_userpagerefs">
	Use: presentation of each individual link to a user in the references section
	-->
	<xsl:template match="USERLINK" mode="r_userpagerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
	Use: presentation of of the 'List of external BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
		<xsl:value-of select="$m_otherbbcsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_userpagerefsbbc"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
	Use: presentation of of the 'List of external non-BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
		<xsl:value-of select="$m_refsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_userpagerefsnotbbc"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							JOURNAL Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="JOURNAL" mode="r_userpage">
	Description: Presentation of the object holding the userpage journal
	 -->
	<xsl:template match="JOURNAL" mode="r_userpage">
		<font size="3">
			<b>
				<xsl:value-of select="$m_journalentries"/>
			</b>
		</font>
		<xsl:apply-templates select="." mode="t_journalmessage"/>
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_adduserpagejournalentry"/>
		<xsl:apply-templates select="JOURNALPOSTS/POST" mode="c_userpagejournalentries"/>
		<br/>
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_moreuserpagejournals"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Description: Presentation of the 'click here to see more entries' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Description: Presentation of the 'add a journal entry' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagejournalentries">
	Description: Presentation of a single Journal post
	 -->
	<xsl:template match="POST" mode="r_userpagejournalentries">
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="head">
					<font size="2">
						<b>
							<xsl:value-of select="SUBJECT"/>
						</b>
						<br/>(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/>)
					</font>
				</td>
			</tr>
			<tr>
				<td class="body">
					<font size="2">
						<xsl:apply-templates select="TEXT" mode="t_journaltext"/>
						<br/>
						<xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
						<br/>
						<xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/>
						<br/>
						<xsl:apply-templates select="@THREADID" mode="c_removejournalpostup"/>
					</font>
				</td>
			</tr>
		</table>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
	Description: Object is used if there are replies to a journal entry
	 -->
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
		(<xsl:apply-templates select="../@THREADID" mode="t_journalentriesreplies"/>,
				<xsl:value-of select="$m_latestreply"/>
		<xsl:apply-templates select="../@THREADID" mode="t_journallastreply"/>)
	</xsl:template>
	<xsl:template name="noJournalReplies">
		(<xsl:value-of select="$m_noreplies"/>)
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Description: Display of the 'remove journal entry' link if appropriate
	 -->
	<xsl:template match="@THREADID" mode="r_removejournalpost">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							RECENT-POSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest conversations the user
	has contributed to
	 -->
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
		<xsl:apply-templates select="." mode="c_postlistempty"/>
		<xsl:apply-templates select="POST-LIST" mode="c_postlist"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries]" mode="c_userpage"/>
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries]" mode="c_userpage"/>
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_morepostslink">
	Description: Presentation of a link to 'see all posts'
	 -->
	<xsl:template match="USERID" mode="r_morepostslink">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
		<xsl:copy-of select="$m_forumownerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
		<xsl:copy-of select="$m_forumviewerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
	Description: Presentation of a single post in a list
	 -->
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
		<xsl:value-of select="$m_fromsite"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="SITEID" mode="t_userpage"/>:
		<br/>
		<xsl:apply-templates select="THREAD/@THREADID" mode="t_userpagepostsubject"/>
		<br/>
		(<xsl:apply-templates select="." mode="c_userpagepostdate"/>)
		<br/>
		(<xsl:apply-templates select="." mode="c_userpagepostlastreply"/>)
		<br/>
		<xsl:apply-templates select="." mode="c_postunsubscribeuserpage"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagepostdate">
	Description: Presentation of when the user posted date
	 -->
	<xsl:template match="POST" mode="r_userpagepostdate">
		<xsl:value-of select="$m_postedcolon"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagepostlastreply">
	Description: Presentation of the 'reply to a user posting' date
	 -->
	<xsl:template match="POST" mode="r_userpagepostlastreply">
		<xsl:apply-templates select="." mode="t_lastreplytext"/>
		<xsl:apply-templates select="." mode="t_userpagepostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						RECENT-ENTRIES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest articles
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="r_userpage">
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_userpagelistempty"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer owns
	 -->
	<xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
		<xsl:copy-of select="$m_artownerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_morearticles"/>
		<!--xsl:call-template name="insert-moreartslink"/-->
		<xsl:call-template name="c_createnewarticle"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer doesn`t owns
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
		<xsl:copy-of select="$m_artviewerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<!--xsl:call-template name="insert-moreartslink"/-->
		<xsl:apply-templates select="." mode="c_morearticles"/>
	</xsl:template>
	<!--
	<xsl:template name="r_createnewarticle">
	Description: Presentation of the 'create a new article' link
	 -->
	<xsl:template name="r_createnewarticle">
		<xsl:param name="content" select="$m_clicknewentry"/>
		<xsl:copy-of select="$content"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
	Description: Presentation of the 'click to see more articles' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer owns
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
		<xsl:copy-of select="$m_artownerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer doesn`t own
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
		<xsl:copy-of select="$m_artviewerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	Description: Presentation of a single article item within a list
	 -->
	<xsl:template match="ARTICLE" mode="r_userpagelist">
		<xsl:value-of select="$m_fromsite"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="SITEID" mode="t_userpage"/>:<br/>
		<xsl:apply-templates select="H2G2-ID" mode="t_userpage"/>
		<br/>
		<xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/>
		<br/>
		(<xsl:apply-templates select="DATE-CREATED/DATE" mode="t_userpagearticle"/>) 
		<xsl:apply-templates select="H2G2-ID" mode="c_uncancelarticle"/>
		<xsl:apply-templates select="STATUS" mode="t_userpagearticle"/>
		<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Description: Presentation of the 'uncancel this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
		(<xsl:apply-imports/>)
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	Description: Presentation of the 'edit this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_editarticle">
		<font size="1">
			<b>(<xsl:apply-imports/>)</b>
		</font>
		<br/>
	</xsl:template>
	
	
	<!--
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	Description: Presentation of a single article item within a list
	 -->
	<xsl:template match="ARTICLE" mode="users_article">
		<xsl:variable name="oddoreven">
			<xsl:choose>
				<xsl:when test="position() mod 2 != 0">odd</xsl:when>
				<xsl:otherwise>even</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li>
			<xsl:attribute name="class">
				<xsl:value-of select="$oddoreven"/>
			</xsl:attribute>
			<xsl:apply-templates select="EXTRAINFO/MANAGERSPICK/text()">
				<xsl:with-param name="oddoreven" select="$oddoreven"/>
			</xsl:apply-templates>
		
		<div class="articletitle"><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/><xsl:if test="not(SUBJECT/text())"><a href="A{H2G2-ID}">ARTICLE AWAITING MODERATION</a></xsl:if></div>
		<!-- <xsl:apply-templates select="EXTRAINFO/AUTHORUSERID"/> -->
		<div class="articledetals">
			<xsl:apply-templates select="EXTRAINFO/SPORT"/> <xsl:apply-templates select="EXTRAINFO/COMPETITION/text()"/> <xsl:apply-templates select="EXTRAINFO/TYPE"/>
		</div>
		
		
		<div class="articledate">published <xsl:apply-templates select="DATE-CREATED" mode="t_morearticlespage"/></div>
		<xsl:if test="SUBJECT/text()">
            <xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION/text()" />
        </xsl:if>
		 </li>
	</xsl:template>
	
	
	
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							EXTRA Objects
							
		<EXTRAINFO>
		  <TYPE ID="13" /> 
		  <AUTODESCRIPTION>Defacto lingo est igpay atinlay. Marquee selectus non provisio incongruous feline nolo contendre. Gratuitous octopus ...</AUTODESCRIPTION> 
		  <AUTHORNAME>Alistair Duggin</AUTHORNAME> 
		  <AUTHORUSERID>1090498240</AUTHORUSERID> 
		  <COMPETITION>premiership</COMPETITION> 
		  <DATECREATED>20060711130300</DATECREATED> 
		  <LASTUPDATED>20060711130652</LASTUPDATED> 
		  <SPORT>football</SPORT> 
		  <TEAM>arsenal</TEAM> 
		  <TYPEOFARTICLE>player profile</TYPEOFARTICLE> 
		 </EXTRAINFO>
	
	<xsl:template match="EXTRAINFO/SPORT">
		<xsl:value-of select="." /><xsl:text> | </xsl:text>
	</xsl:template>
							
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						RECENT-APPROVALS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
	Description: Presentation of the Edited Articles Object
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
		<xsl:apply-templates select="." mode="c_approvalslistempty"/>
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_approvalslist"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
		<xsl:copy-of select="$m_editownerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
		<xsl:copy-of select="$m_editviewerfull"/>
		<br/>
		<br/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Description: Presentation of the 'See more edited articles' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty">
		<xsl:copy-of select="$m_editownerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty">
		<xsl:copy-of select="$m_editviewerempty"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							PAGE-OWNER Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!--
	<xsl:template match="PAGE-OWNER" mode="t_userpageintro">
	Author:		Tom Whitehouse (originally in base) overridden by Alistair Duggin
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Creates the correct text for introductioon to the userpage
	-->
	<xsl:template match="PAGE-OWNER" mode="t_userpageintro">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
				<div class="intro"><xsl:call-template name="m_userpagehidden"/></div>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
				<div class="intro"><xsl:call-template name="m_userpagereferred"/></div>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
				<div class="intro"><xsl:call-template name="m_userpagependingpremoderation"/></div>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
				<div class="intro"><xsl:call-template name="m_legacyuserpageawaitingmoderation"/></div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$test_introarticle">
					
						<div class="quotetext">			
							<h4>More about me:</h4>
							<img height="14" hspace="0" vspace="0" border="0" width="17" alt="quote" align="left" src="{$imagesource}quotetop.gif" />
							<p><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/></p>
							<img height="14" hspace="0" vspace="0" border="0" width="17" alt="quote" align="right" src="{$imagesource}quotebot.gif" /><br clear="all" />
						</div>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<div class="intro"><xsl:call-template name="m_psintroowner"/></div>
							</xsl:when>
							<xsl:otherwise>
								<div class="intro"><xsl:call-template name="m_psintroviewer"/></div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
	Description: Presentation of the Page Owner object
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
		<font size="3">
			<b>
				<xsl:value-of select="$m_userdata"/>
			</b>
		</font>
		<font xsl:use-attribute-sets="mainfont">
			<br/>
			<xsl:value-of select="$m_researcher"/>
			<xsl:value-of select="USER/USERID"/>
			<br/>
			<xsl:value-of select="$m_namecolon"/>
			<xsl:value-of select="USER/USERNAME"/>
			<br/>
			<xsl:apply-templates select="USER/USERID" mode="c_inspectuser"/>
			<xsl:apply-templates select="." mode="c_editmasthead"/>
			<xsl:apply-templates select="USER/USERID" mode="c_addtofriends"/>
			<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_clip"/>
			<xsl:apply-templates select="USER/GROUPS" mode="c_userpage"/>
		</font>
	</xsl:template>
	
	<!--
	<xsl:template match="USERID" mode="r_inspectuser">
	Description: Presentation of the 'Inspect this user' link
	 -->
	<xsl:template match="USERID" mode="r_inspectuser">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
	Description: Presentation of the 'Edit my Introduction' link
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Description: Presentation of the 'Add to my friends' link
	 -->
	<xsl:template match="USERID" mode="r_addtofriends">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="PAGE-OWNER" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="PAGE-OWNER" mode="r_clip">
		<font size="3">
			<b>Clippings</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="GROUPS" mode="r_userpage">
	Description: Presentation of the GROUPS object
	 -->
	<xsl:template match="GROUPS" mode="r_userpage">
		<xsl:value-of select="$m_memberof"/>
		<br/>
		<xsl:apply-templates/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USER/GROUPS/*">
	Description: Presentation of the group name
	 -->
	<xsl:template match="USER/GROUPS/*">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Watched User Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
	Description: Presentation of the WATCHED-USER-LIST object
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
		<font size="3">
			<b>
				<xsl:value-of select="$m_friends"/>
			</b>
		</font>
		<br/>
		<xsl:apply-templates select="." mode="t_introduction"/>
		<br/>
		<xsl:apply-templates select="USER" mode="c_watcheduser"/>
		<xsl:apply-templates select="." mode="c_friendsjournals"/>
		<xsl:apply-templates select="." mode="c_deletemany"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_watcheduser">
	Description: Presentation of the WATCHED-USER-LIST/USER object
	 -->
	<xsl:template match="USER" mode="r_watcheduser">
		<xsl:apply-templates select="." mode="t_watchedusername"/>
		<br/>
		<xsl:apply-templates select="." mode="t_watcheduserpage"/>
		<br/>
		<xsl:apply-templates select="." mode="t_watcheduserjournal"/>
		<br/>
		<xsl:apply-templates select="." mode="c_watcheduserdelete"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Description: Presentation of the 'Delete' link
	 -->
	<xsl:template match="USER" mode="r_watcheduserdelete">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
	Description: Presentation of the 'Views friends journals' link
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
	Description: Presentation of the 'Delete many friends' link
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							PRIVATEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="PRIVATEFORUM" mode="r_userpage">
	Use: Presentation of the Private forum object
	 -->
	<xsl:template match="PRIVATEFORUM" mode="r_userpage">
		<font size="3">
			<b>
				<xsl:value-of select="$m_privatemessages"/>
			</b>
		</font>
		<br/>
		<xsl:apply-templates select="." mode="t_intromessage"/>
		<br/>
		<br/>
		<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="c_privateforum"/>
		<br/>
		<xsl:apply-templates select="." mode="t_leavemessagelink"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_privateforum">
	Use: Presentation of an individual thread within a private forum
	 -->
	<xsl:template match="THREAD" mode="r_privateforum">
		<xsl:apply-templates select="SUBJECT" mode="t_privatemessage"/>
		<br/>
		(<xsl:copy-of select="$m_privatemessagelatestpost"/>
		<xsl:apply-templates select="DATEPOSTED" mode="t_privatemessage"/>)
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							USERCLUBACTIONLIST Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_userpage">
		<font size="3">
			<strong>
				<xsl:copy-of select="$m_actionlistheader"/>
			</strong>
		</font>
		<br/>
		<xsl:apply-templates select="." mode="c_yourrequests"/>
		<xsl:apply-templates select="." mode="c_invitations"/>
		<xsl:apply-templates select="." mode="c_previousactions"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_yourrequests">
	Use: Presentation of any club requests the user has made 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_yourrequests">
		<xsl:copy-of select="$m_yourrequests"/>
		<br/>
		<xsl:apply-templates select="CLUBACTION" mode="c_yourrequests"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_invitations">
	Use: Presentation of any club invitations the user has recieved 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_invitations">
		<xsl:copy-of select="$m_invitations"/>
		<br/>
		<xsl:apply-templates select="CLUBACTION" mode="c_invitations"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_previousactions">
	Use: Presentation of any previous club request actions the user the made 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_previousactions">
		<xsl:copy-of select="$m_previousactions"/>
		<br/>
		<xsl:apply-templates select="CLUBACTION" mode="c_previousactions"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_yourrequests">
	Use: Presentation of each individual club request the user has made 
	 -->
	<xsl:template match="CLUBACTION" mode="r_yourrequests">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_actiondescription"/>
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/>
		(<xsl:apply-templates select="DATEREQUESTED" mode="t_date"/>)
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_invitations">
	Use: Presentation of each individual club invitations the user has received 
	 -->
	<xsl:template match="CLUBACTION" mode="r_invitations">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_actiondescription"/>
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/>
		by
		<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
		(<xsl:apply-templates select="DATEREQUESTED" mode="t_date"/>),
		[<xsl:apply-templates select="@ACTIONID" mode="t_acceptlink"/>] 
		[<xsl:apply-templates select="@ACTIONID" mode="t_rejectlink"/>]
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_previousactions">
	Use: Presentation of each previous club actions the user has made 
	 -->
	<xsl:template match="CLUBACTION" mode="r_previousactions">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_actiondescription"/>
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/>
		(<xsl:apply-templates select="DATEREQUESTED" mode="t_date"/>).
		<xsl:apply-templates select="." mode="c_resulttext"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="auto_resulttext">
	Use: Presentation of the automatic response result text 
	 -->
	<xsl:template match="CLUBACTION" mode="auto_resulttext">
		The request was processed automatically.
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="accept_resulttext">
	Use: Presentation of the accepted by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="accept_resulttext">
		Accepted by 
		<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="by_resulttext">
	Use: Presentation of the made by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="by_resulttext">
		by
		<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="selfdecline_resulttext">
	Use: Presentation of the you declined result text 
	 -->
	<xsl:template match="CLUBACTION" mode="selfdecline_resulttext">
		You declined
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="decline_resulttext">
	Use: Presentation of the declined by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="decline_resulttext">
		Declined by
		<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								LINKS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="LINKS" mode="r_userpage">
		<xsl:apply-templates select="." mode="t_folderslink"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								USERMYCLUBS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="USERMYCLUBS" mode="r_userpage">
		<font size="3">
			<strong>
				Clubs:
			</strong>
		</font>
		<br/>
		<xsl:apply-templates select="CLUBSSUMMARY" mode="c_userpage"/>
		<hr/>
	</xsl:template>
	<xsl:template match="CLUBSSUMMARY" mode="r_userpage">
		<xsl:apply-templates select="CLUB" mode="c_userpage"/>
		<xsl:apply-templates select="." mode="t_more"/>
	</xsl:template>
	<xsl:template match="CLUB" mode="r_userpage">
		<xsl:apply-templates select="NAME" mode="t_clublink"/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template name="USERPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USERPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="ARTICLE/SUBJECT">
						<xsl:value-of select="$m_pagetitlestart"/>
						<!--<xsl:value-of select="ARTICLE/SUBJECT"/>--> U<xsl:value-of select="PAGE-OWNER/USER/USERID"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleowner"/>
								<!--
								<xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>.
								-->
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleviewer"/>
								<xsl:value-of select="PAGE-OWNER/USER/USERID"/>.</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>



</xsl:stylesheet>
