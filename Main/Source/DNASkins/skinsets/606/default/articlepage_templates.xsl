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
	
	
	
	<!-- page title and search box -->
	<xsl:if test="/H2G2/@TYPE='ARTICLE'">
		<!-- don't diplay this on TYPEDARTICLE or moderation form - search box will break form - and page has own page title  -->
		<div id="mainbansec">
			<div class="crumbBar">
				<span class="crumbBrowse">Browse: </span>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SPORT" mode="crumblink"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COMPETITION/text()" mode="crumblink"/>
				<xsl:if test="string-length($team) &gt; 0">
					<xsl:text> </xsl:text>

					<xsl:variable name="href">
						<xsl:value-of select="$root" />
						<xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
						<xsl:value-of select="translate($team, ' ', '+')" />
						<xsl:choose>
						    <xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Othersport'">
								<xsl:text>&amp;phrase=</xsl:text>
								<xsl:value-of select="/H2G2/ARTICLE/GUIDE/OTHERSPORT"/>
						    </xsl:when>
							<xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT">
								<xsl:text>&amp;phrase=</xsl:text>
								<xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORT"/>
						    </xsl:when>
						</xsl:choose>
					</xsl:variable>

					<a>
						<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
						<xsl:value-of select="$team" />
					</a>
				</xsl:if>
				
				<xsl:if test="string-length($team2) &gt; 0 and $team2 != $team">
					<xsl:text> </xsl:text>
					<xsl:variable name="href">
						<xsl:value-of select="$root" />
						<xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
						<xsl:value-of select="translate($team2, ' ', '+')" />
						<xsl:choose>
						    <xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT='Othersport'">
							<xsl:text>&amp;phrase=</xsl:text>
							<xsl:value-of select="/H2G2/ARTICLE/GUIDE/OTHERSPORT"/>
						    </xsl:when>
						    <xsl:when test="/H2G2/ARTICLE/GUIDE/SPORT">
							<xsl:text>&amp;phrase=</xsl:text>
							<xsl:value-of select="/H2G2/ARTICLE/GUIDE/SPORT"/>
						    </xsl:when>
						</xsl:choose>
					</xsl:variable>

					<a>
						<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
						<xsl:value-of select="$team2" />
					</a>
				</xsl:if>
				
				<xsl:if test="$article_subtype ='player_profile'">
					<xsl:text> </xsl:text>
					<a>
						<xsl:attribute name="href"><xsl:value-of select="$root" />ArticleSearch?contenttype=-1&amp;phrase=<xsl:value-of select="SUBJECT" /></xsl:attribute>
						<xsl:value-of select="SUBJECT" />
					</a>
				</xsl:if>
				
							
			</div>
			<!--[FIXME: remove]
			<xsl:call-template name="SEARCHBOX" />
			
			<div class="clear"></div>
			<div class="searchline"><div></div></div>
			-->
		</div>
	</xsl:if>
	
	
	<div class="mainbodysec" id="{$sport_converted}">
		
	<div class="bodysec">	
		<!-- sport -->
		<!--[FIXME: remove]
		<h3 class="sectionstrap"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SPORT" mode="includeothersportsusers"/></h3>
		-->
		<!-- Managers pick and user rating -->
		<div class="rating">
			<p class="pick"><xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/> comment<xsl:if test="not(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT=1)">s</xsl:if></p>
			
			<p class="userrate">
				<xsl:choose>
					<xsl:when test="floor($poll_average_score) &gt; 0">
						<img src="{$imagesource}stars.2/{$sport_converted}/{round($poll_average_score)}.gif" align="right" width="179" height="18" alt="user rating: {round($poll_average_score)} star" />
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}stars.2/{$sport_converted}/not_rated.gif" align="right" width="179" height="18" alt="user rating: not rated yet" />
					</xsl:otherwise>
				</xsl:choose>
				</p>
		</div>
		<!-- title -->
		<xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/>
		<div class="topsec">
			<!-- competition -->
			<xsl:if test="not($article_type_group='report')">
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COMPETITION/text()" mode="topsec"/>
			</xsl:if>
			
			<!-- team -->
			<xsl:if test="$article_type_group='article' or $article_subtype='player_profile'">
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="topsec"/>
			</xsl:if>
			
			<!-- author link and date-->
			<div>
                <xsl:text>by </xsl:text>
                <a href="{root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
                    <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
                    <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME != concat('U', /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">
                        <xsl:text> </xsl:text>
                        <span class="uid">(U<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/>)</span>
                    </xsl:if>
                </a>
			<xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" /></div>
		</div>
			
		<div class="matchstats2">
			<dl>
				<!-- reports -->
				
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COMPETITOR1/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/DATEDAY/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/VENUE/text()"/>
				<xsl:if test="$article_type_group='report'">
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COMPETITION/text()" mode="matchstats"/>
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/OTHERCOMPETITION/text()" mode="matchreport_disabilitysport"/>
				</xsl:if>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/ATTENDANCE/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/PLAYEROFTHEMATCH/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/STAROFTHESHOW/text()"/>
						
				<!-- player profile -->
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/PLAYERDOB/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CURRENTTEAM/text()"/>
				
			
				<!-- team profile -->
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/HOMEVENUE/text()"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/MANAGERCOACH/text()"/>
			</dl>
		</div>

		<!-- don't show comment button when in preview -->
		<xsl:if test="not(/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW')">
		    <div class="commentbutton">
			<a href="#commentbox"><img src="{$imagesource}refresh/commentOnThisArticleButton.gif" width="147" height="24" alt="comment on the article" id="comment_on_article"/></a>
		    </div>
		</xsl:if>

		<!--[FIXME: remove]
		<hr class="section" />
		-->
		
		<!-- team profile -->
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/HONOURS"/>
		
		<!-- content -->
		<div class="bodytext">
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/IMAGE"/>
      <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/EMPURL"/>
      <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/YOUTUBEURL"/>
			<p>
			<xsl:if test="$article_subtype='team_profile'">
			<strong>More info</strong><br />
			</xsl:if>
            <xsl:variable name="body_rendered">
                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
            </xsl:variable>
            <xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
            </p>
		</div>
		
		<!-- match report -->
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAMLIST"/>
		
		<!-- edit -->
		<xsl:if test="($ownerisviewer=1 or $test_IsEditor=1) and /H2G2/@TYPE='ARTICLE'">
			<div  id="editarticle">
			<p>Made a mistake? Or would you like to update it?</p>
			
			<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER">
							<xsl:value-of select="$root"/>TypedArticle?aedit=new&amp;type=<xsl:value-of select="$current_article_type"/>&amp;h2g2id=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$sso_registerlink"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<img src="{$imagesource}edit_{$article_type_group}.gif" width="118" height="23" alt="edit {$article_type_group}"/></a>
			</div>
		</xsl:if>
		
		
		
		<!-- send to a friend and complain -->
		<xsl:if test="/H2G2/@TYPE='ARTICLE'">
			<div class="mbx">			
				<div class="articlelinks">
					<a href="#commentbox" class="commentlink">comment on this article</a> | <xsl:if test="$article_subtype!='staff_article'"><a href="{$root}comments/UserComplaintPage?s_start=1&amp;h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="ComplaintPopup" onclick="popupwindow('{$root}comments/UserComplaintPage?s_start=1&amp;h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=588,height=560')">alert a moderator</a> | </xsl:if> <a onClick="popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">
						<!--[FIXME: removed]
						<img src="{$imagesource}email2.gif" alt=""/>
						-->
						<xsl:text>send to a friend</xsl:text>
					</a>
				</div>
			</div>
		</xsl:if>
		
		<!-- comments  -->
		<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS"/>
		
		<!-- add a comment -->
		<xsl:call-template name="COMMENT_ON_ARTICLE" />
		
	</div><!-- / bodysec -->	
	<div class="additionsec">				
        <xsl:if test="not(/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW')">
            <xsl:apply-templates select="/H2G2/POLL-LIST" mode="c_articlepage"/>
            <!--[FIXME: remove]
            <xsl:call-template name="RELATED_TAGS" />
            -->
            <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/ARTICLELINK/text()"/>
            <!--[FIXME: remove]
            <xsl:call-template name="RELATED_DYNAMIC_LISTS" />
            -->
            
            
        <!-- 
            ============================================================
                    RELATED BBC LINKS
            ============================================================ 
        -->
            
            <xsl:apply-templates select="msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]" mode="related_bbc_links"/>
            
        <!-- 
            ============================================================
                    END RELATED BBC LINKS
            ============================================================ 
        -->
            
            <!--[FIXME: remove/adapt]
            <xsl:call-template name="CREATE_ARTICLES" />
            -->
        </xsl:if>	
	</div><!-- /  additionsec -->	
				 
				 
	<div class="clear"></div>
	</div><!-- / mainbodysec -->
</xsl:template>


<!-- EDITORIAL_ARTICLE used for creating named articles:
dynamic list pages: type = 1
houserules: type = 2
-->
<xsl:template name="EDITORIAL_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	<div id="mainbansec">
		<div class="banartical"><h3><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></h3></div>
		<!--[FIXME: remove]
		<xsl:call-template name="SEARCHBOX" />
		
		<div class="clear"></div>
		<div class="searchline"><div></div></div>
		-->
	</div>
				
	<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTROTEXT"/>
	
	<div class="mainbodysec">
		<div class="bodysec">	
		
			<div class="bodytext">
				<xsl:if test="$current_article_type=3">
					<xsl:attribute name="class">bodytext2</xsl:attribute>
				</xsl:if>
			
				<div id="guidemlwrapper">
					<xsl:variable name="body_rendered">
						<p><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/></p>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
				</div>			
			</div>
			
		</div><!-- / bodysec -->	
		<div class="additionsec">	
	
			<xsl:choose>
				<xsl:when test="$current_article_type=1">
					<!-- dynamic lists -->
					<div class="hintbox">	
					 	<h3>HINTS &amp; TIPS</h3>
						<p>This list shows the most recent content that has been rated most highly by 606 members</p>
			
						<p>Can't find what you're looking for? Why not write it yourself!</p>
					</div>  
				
					<xsl:call-template name="CREATE_ARTICLES_LISTALL" />	
				</xsl:when>
				<xsl:when test="$current_article_type=2">
				<!-- house rules-->
					<!-- no right hand content -->
				</xsl:when>
				<xsl:when test="$current_article_type=3">
				<!-- search -->
					<div class="hintbox">	
					 	<h3>HINTS &amp; TIPS</h3>
						<xsl:comment>#include virtual="/606/2/includes/searchtext_tips.ssi"</xsl:comment>
					</div>
				
					<xsl:call-template name="CREATE_ARTICLES_LISTALL" />
				</xsl:when>
			</xsl:choose>
	
			
		</div><!-- /  additionsec -->	
		 
		 
	<div class="clear"></div>
	</div><!-- / mainbodysec -->
</xsl:template>

<!-- POPUP_ARTICLE used for creating popu articles:
type = 4
-->
<xsl:template name="POPUP_ARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">POPUP_ARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
    <div id="popban">
        <img src="http://www.bbc.co.uk/606/2/images/banner_popup.gif" width="412" height="45" alt="606: comment - debate - create" id="banner"/><br />
    </div>
	
    <h1>
        <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
    </h1>
	
    <div id="popupbody">
        <xsl:variable name="body_rendered">
            <p><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/></p>
        </xsl:variable>
        <xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
        <br/>
    </div><!-- / popupbody -->	
    <div id="popfoot">
        <a href="http://www.bbc.co.uk/terms/" target="_blank">Terms of Use</a>
        <script language="JavaScript" type="text/javascript">
        <!-- Hide from older browsers
        document.write('| <A href="javascript:self.close()">c\lose window</a>&nbsp;&nbsp;')
        // Stop hiding from old browsers -->
        </script>
    </div>
</xsl:template>


<xsl:template name="CREATE_ARTICLES">
	<xsl:if test="(/H2G2/SITE-CLOSED=0 or $test_IsEditor) and /H2G2/@TYPE='ARTICLE'">

	<div id="writeownhr"></div>

	<div class="writeown">
		<h3>WRITE YOUR OWN</h3>
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				 <p>Do you agree with this article? Why not write your own?</p>
				 <a>
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="15"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="type" select="10"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<strong>Create an article</strong>
				</a>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				 <p>Do you agree with this match report? Why not write your own?</p>
				 <a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="11"/>
						</xsl:call-template>
					</xsl:attribute>
					<strong>Create a match report</strong>
				</a>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				 <p>Do you agree with this event report? Why not write your own?</p>
				 <a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="12"/>
						</xsl:call-template>
					</xsl:attribute>
					<strong>Create a event report</strong>
				</a>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				 <p>Do you agree with this player profile? Why not write your own?</p>
				 <a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="13"/>
						</xsl:call-template>
					</xsl:attribute>
					<strong>Create a player profile</strong>
				</a>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				 <p>Do you agree with this team profile? Why not write your own?</p>
				 <a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="14"/>
						</xsl:call-template>
					</xsl:attribute>
					<strong>Create a team profile</strong>
				</a>
			</xsl:when>
		</xsl:choose>	
	</div>

	<ul class="links" id="writearticles">	
		<xsl:if test="not($article_type_group='article')">
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<li><a>
						<xsl:attribute name="href">
							<xsl:call-template name="sso_typedarticle_signin">
								<xsl:with-param name="type" select="15"/>
							</xsl:call-template>
						</xsl:attribute>
						&gt; Write an article
						</a>
					</li>
				</xsl:when>
				<xsl:otherwise>
				<li><a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="10"/>
						</xsl:call-template>
					</xsl:attribute>
					&gt; Write an article
					</a>
				</li>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="not($article_subtype='match_report')">
			<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="11"/>
					</xsl:call-template>
				</xsl:attribute>
				&gt; Write a match report
				</a>
			</li>
		</xsl:if>
		<xsl:if test="not($article_subtype='event_report')">	
			<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="12"/>
					</xsl:call-template>
				</xsl:attribute>
				&gt; Write an event report
				</a>
			</li>
		</xsl:if>
		<xsl:if test="not($article_subtype='player_profile')">
			<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="13"/>
					</xsl:call-template>
				</xsl:attribute>
				&gt; Write a player profile
				</a>
			</li>
		</xsl:if>
		<xsl:if test="not($article_subtype='team_profile')">
			<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="14"/>
					</xsl:call-template>
				</xsl:attribute>
				&gt; Write a team profile
				</a>
			</li>
		</xsl:if>
	</ul>

	<hr />
	</xsl:if>
</xsl:template>

<xsl:template name="RELATED_TAGS">
	<xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/PHRASES/@COUNT">
		<div class="rellinks" id="relatedtags">
			<h3>RELATED TAGS</h3>
			
			<ul>
				<xsl:for-each select="/H2G2/PHRASES/PHRASE">
				<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={TERM}"><xsl:value-of select="TERM"/></a></li>
				</xsl:for-each>
			</ul>
			
			<p id="tagdesc">A "tag" is like a keyword or category label. Tags help you find content... <a href="{$root}searchhelp">more</a></p>
			
			
		</div>
	</xsl:if>
</xsl:template>

<xsl:template name="RELATED_DYNAMIC_LISTS">
	
	<!--  25 DYNAMIC LISTS
	
	ARTICLETYPES:
		article
		report
		profile
		
	SPORTS:
		football	
		cricket
		rugbyunion
		rugbyleague
		golf
		tennis
		motorsport
		boxing
		athletics
		horseracing
	
	COMPETITIONS (FOOTBALL):
		Premiership
		Championship
		League One
		League Two
		English Non League
		Scottish Premier
		Scottish League
		Welsh
		Irish
		International
		European
		
	ALL
		every article links to 'Best of 606 / favourite'
		
	-->
	
	<div class="relcontent">			   
	   <h3>RELATED CONTENT</h3>
	   	<h4>606</h4>
		<ul class="arrow first">
			<!-- articletype -->
			<xsl:if test="$article_type_group='article'">
				<li><a href="{$root}articles">Highest rated - Articles</a></li>
			</xsl:if>
			
			<xsl:if test="$article_type_group='report'">
				<li><a href="{$root}reports">Highest rated - Match &amp; event reports</a></li>
			</xsl:if>
			
			<xsl:if test="$article_type_group='profile'">
				<li><a href="{$root}profiles">Highest rated - Team &amp; player profiles</a></li>
			</xsl:if>
		
			<!-- sport -->
			<xsl:if test="$sport_converted='football'">
				<li><a href="{$root}football">Highest rated - Football</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='cricket'">
				<li><a href="{$root}cricket">Highest rated - Cricket</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='rugbyunion'">
				<li><a href="{$root}rugbyunion">Highest rated - Rugby union</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='rugbyleague'">
				<li><a href="{$root}rugbyleague">Highest rated - Rugby league</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='golf'">
				<li><a href="{$root}golf">Highest rated - Golf</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='tennis'">
				<li><a href="{$root}tennis">Highest rated - Tennis</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='motorsport'">
				<li><a href="{$root}motorsport">Highest rated - Motorsport</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='boxing'">
				<li><a href="{$root}boxing">Highest rated - Boxing</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='athletics'">
				<li><a href="{$root}athletics">Highest rated - Athletics</a></li>
			</xsl:if>
			<xsl:if test="$sport_converted='horseracing'">
				<li><a href="{$root}horseracing">Highest rated - Horse racing</a></li>
			</xsl:if>
	
		<!-- competition -->
		<xsl:if test="$sport_converted='football'">
			<xsl:if test="$competition='Premiership' or $competition='Premier League'">
				<li><a href="{$root}footballpremiership">Highest rated - Premier League football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='Championship'">
				<li><a href="{$root}footballchampionship">Highest rated - Championship football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='League One'">
				<li><a href="{$root}footballleagueone">Highest rated - League One football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='League Two'">
				<li><a href="{$root}footballleaguetwo">Highest rated - League Two football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='English Non League'">
				<li><a href="{$root}footballenglishnonleague">Highest rated - Non-league football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='Scottish Premier'">
				<li><a href="{$root}footballscottishpremier">Highest rated - Scottish Premier football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='Scottish League'">
				<li><a href="{$root}footballscottishleague">Highest rated - Scottish League football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='Welsh'">
				<li><a href="{$root}footballwelsh">Highest rated - Welsh football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='Irish'">
				<li><a href="{$root}footballirish">Highest rated - Irish football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='International'">
				<li><a href="{$root}footballinternational">Highest rated - International football</a></li>
			</xsl:if>
			
			<xsl:if test="$competition='European'">
				<li><a href="{$root}footballeuropean">Highest rated - European football</a></li>
			</xsl:if>
		</xsl:if>
			
			<li><a href="{$root}favourites">Best of 606</a></li>
		
		</ul>
		<h4>BBC SPORT</h4>
		<xsl:variable name="team_link" select="msxsl:node-set($competitions)/competition[@converted=$sport_converted]/team[@fullname=$team]/@link"/>
		<xsl:variable name="awayteam_link" select="msxsl:node-set($competitions)/competition[@converted=$sport_converted]/team[@fullname=$awayteam]/@link"/>
		<xsl:variable name="competition_link" select="msxsl:node-set($competitions)/competition[@name=$competition]/@link"/>
		<ul class="arrow">
			<!-- try to do link to team -->
			<xsl:if test="$team_link">
				<li>
					<a href="{$team_link}"><xsl:value-of select="$team"/></a>
				</li>
			</xsl:if>
			
			<!-- try to do link to away team -->
			<xsl:if test="$awayteam_link">
				<li>
					<a href="{$awayteam_link}"><xsl:value-of select="$awayteam"/></a>
				</li>
			</xsl:if>

			<!-- try to do link to competition -->
			<xsl:if test="$competition_link">
				<li>
					<a href="{$competition_link}"><xsl:value-of select="$competition"/></a>
				</li>
			</xsl:if>

			<!-- always have at least link to sport page -->
			<li>
				<xsl:copy-of select="msxsl:node-set($sports_info)/sports/sport[@converted=$sport_converted]/a"/>
			</li>
		</ul>
	  </div>
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
						
						<div class="txt"><label for="text"><strong>Your comments: enter text below</strong></label></div>
						<div class="mbx"><textarea wrap="virtual" name="body" id="text" class="inputone" cols="20" rows="6"></textarea></div>
											
						<xsl:choose>
							<xsl:when test="/H2G2/SERVERNAME = $staging_server">
								<p class="arrowlink"><a href="http://www.bbc.co.uk/606/2/popups/smileys_staging.shtml" target="smileys" onClick="popupwindow(this.href,this.target,'width=623, height=502, resizable=yes, scrollbars=yes');return false;">How do I add a smiley?</a></p>
							</xsl:when>
							<xsl:otherwise>
								<p class="arrowlink"><a href="http://www.bbc.co.uk/606/2/popups/smileys.shtml" target="smileys" onClick="popupwindow(this.href,this.target,'width=623, height=502, resizable=yes, scrollbars=yes');return false;">How do I add a smiley?</a></p>
							</xsl:otherwise>
						</xsl:choose>
						
						<div class="mtx">
						<input type="submit" value="Preview" name="preview" class="inputpre2" />
						<input type="submit" value="Send" name="post" class="inputsubmit2" />
						</div>
						</form>
						
						
						
						<p class="reserverights">We reserve the right to edit your comments</p>
					</div>
				
				</xsl:when>
				<xsl:otherwise>
					<!-- must sign in to comment -->
					<br />
					<div class="arrowlink">
						<a href="{$sso_signinlink}" class="strong">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:attribute name="href">
									<xsl:value-of select="$sso_signinlink" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="href">
									<xsl:choose>
										<xsl:when test="not(/H2G2/VIEWING-USER/IDENTITY)">
											<xsl:value-of select="$id_signinlink" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$id_morelink" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>							
							</xsl:otherwise>	
						</xsl:choose>
						Sign in if you want to comment</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		
			<!--[FIXME: remove]			
			<hr class="section" />
			-->
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
	<xsl:template match="team" mode="related_bbc_links">
		<div class="relbbc">			   
		   	<h3>RELATED BBC LINKS</h3>
			<!-- promo 1 -->
			<xsl:apply-templates select="relatedpromo" mode="related_bbc_links">
				<xsl:with-param name="promo" select="1"/>
			</xsl:apply-templates>
			
			<!-- promo 2 -->
			<xsl:apply-templates select="msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team2]/relatedpromo" mode="related_bbc_links">
				<xsl:with-param name="promo" select="2"/>
			</xsl:apply-templates>
			
			
			<div class="clear"></div>
			
			<xsl:variable name="team_link" select="msxsl:node-set($competitions)/competition[@converted=$sport_converted]/team[@fullname=$team]/@link"/>
			<xsl:variable name="awayteam_link" select="msxsl:node-set($competitions)/competition[@converted=$sport_converted]/team[@fullname=$awayteam]/@link"/>
			<xsl:variable name="competition_link" select="msxsl:node-set($competitions)/competition[@name=$competition]/@link"/>
			<ul class="arrow">
				<!-- try to do link to team -->
				<xsl:if test="$team_link">
					<li>
						<a href="{$team_link}"><xsl:value-of select="$team"/></a>
					</li>
				</xsl:if>

				<!-- try to do link to away team -->
				<xsl:if test="$awayteam_link">
					<li>
						<a href="{$awayteam_link}"><xsl:value-of select="$awayteam"/></a>
					</li>
				</xsl:if>

				<!-- try to do link to competition -->
				<xsl:if test="$competition_link">
					<li>
						<a href="{$competition_link}"><xsl:value-of select="$competition"/></a>
					</li>
				</xsl:if>

				<!-- always have at least link to sport page -->
				<li>
					<xsl:copy-of select="msxsl:node-set($sports_info)/sports/sport[@converted=$sport_converted]/a"/>
				</li>
			</ul>
			
		</div>
	</xsl:template>
	
	
	<xsl:template match="relatedpromo" mode="related_bbc_links">
	<xsl:param name="promo"/>
	
	<!-- only display promo 2 if the promo is different than promo 1 - I'm testing for the image to decide if promos are the same -->
	
	<xsl:if test="$promo=1 or ($promo=2 and msxsl:node-set($teamsbysport)/sports/sport[@type=$sport]/team[@fullname=$team]/relatedpromo/image != image)">
	<p>
		<a href="{url}">
			<img height="66" class="imgfl" hspace="0" vspace="0" border="0" width="66" alt="" src="{$imagesource}relatedpromos/{image}.gif" />
			<strong><xsl:value-of select="@type"/></strong><br />
			<xsl:value-of select="text"/>
		</a>
	</p>
	</xsl:if>
	
	
	</xsl:template>

		<!-- code to covert urls to links -->	
		<xsl:variable name="url_prefix">http://</xsl:variable>
		<xsl:variable name="links_max_length">28</xsl:variable>
		
		<xsl:template match="text()" mode="convert_urls_to_links" priority="1.0">
			<xsl:variable name="ret">
				<xsl:call-template name="CONVERT_URLS_TO_LINKS">
					<xsl:with-param name="text" select="."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:copy-of select="msxsl:node-set($ret)"/>
		</xsl:template>
		<xsl:template match="LINK | A | a" mode="convert_urls_to_links" priority="1.0">
			<xsl:apply-templates select="." />
		</xsl:template>
		<xsl:template match="@*|node()" mode="convert_urls_to_links">
			<xsl:copy>	
				<xsl:apply-templates select="@*|node()" mode="convert_urls_to_links"/>
			</xsl:copy>
		</xsl:template>
		
		<xsl:template name="CONVERT_URLS_TO_LINKS">
			<xsl:param name="text"/>
			
			<xsl:choose>
				<xsl:when test="contains($text, $url_prefix)">
					<xsl:variable name="pre_text">
						<xsl:call-template name="CONVERT_URLS_TO_LINKS">
							<xsl:with-param name="text">
								<xsl:value-of select="substring-before($text, $url_prefix)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="url">
	                    			
						<xsl:choose>
							<xsl:when test="contains(concat($url_prefix, substring-after($text, $url_prefix)), ' ')">
								<xsl:value-of select="substring-before(concat($url_prefix, substring-after($text, $url_prefix)), ' ')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($url_prefix, substring-after($text, $url_prefix))"/>
							</xsl:otherwise>
						</xsl:choose>
	                    			
	                    			<!--
						<xsl:call-template name="GET_FIRST_WORD">
							<xsl:with-param name="text" select="concat($url_prefix, substring-after($text, $url_prefix))"/>
						</xsl:call-template>
						-->
					</xsl:variable>
					<xsl:variable name="post_text">
						<xsl:call-template name="CONVERT_URLS_TO_LINKS">
							<xsl:with-param name="text">
	                            				
								<xsl:value-of select="substring-after(concat($url_prefix, substring-after($text, $url_prefix)), ' ')"/>
	                            				
	                            				<!--
	                        				<xsl:call-template name="GET_REST_WORDS">
	                        			    		<xsl:with-param name="text" select="concat($url_prefix, substring-after($text, $url_prefix))"/>
								</xsl:call-template>
								-->
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="contains($url, 'bbc.co.uk')">_self</xsl:when>
							<xsl:otherwise>_blank</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="label">
						<xsl:call-template name="TRUNCATE_TEXT">
							<xsl:with-param name="text" select="$url"/>
							<xsl:with-param name="new_length" select="$links_max_length"/>
							<xsl:with-param name="start_from">8</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					
					<xsl:copy-of select="msxsl:node-set($pre_text)"/>
					<xsl:text> </xsl:text>
					<a href="{$url}" target="{$target}"><xsl:value-of select="$label"/></a>
	                		<xsl:text> </xsl:text>
					<xsl:copy-of select="msxsl:node-set($post_text)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
		
	    <xsl:template name="GET_FIRST_WORD">
	        <xsl:param name="text"/>
	        <xsl:param name="ret"/>
	
	        <xsl:choose>
	            <xsl:when test="starts-with($text, ' ') or starts-with($text, '&#xA;') or starts-with($text, '&#xD;') or string-length($text)=0">
	                <xsl:value-of select="$ret"/>
	            </xsl:when>
	            <xsl:otherwise>
	                <xsl:call-template name="GET_FIRST_WORD">
	                    <xsl:with-param name="text" select="substring($text, 2)"/>
	                    <xsl:with-param name="ret" select="concat($ret, substring($text, 1, 1))"/>
	                </xsl:call-template>
	            </xsl:otherwise>
	        </xsl:choose>
	    </xsl:template>
		
	    <xsl:template name="GET_REST_WORDS">
	        <xsl:param name="text"/>
	
	        <xsl:choose>
	            <xsl:when test="starts-with($text, ' ') or starts-with($text, '&#xA;') or starts-with($text, '&#xD;') or string-length($text)=0">
	                <xsl:value-of select="$text"/>
	            </xsl:when>
	            <xsl:otherwise>
	                <xsl:call-template name="GET_REST_WORDS">
	                    <xsl:with-param name="text" select="substring($text, 2)"/>
	                </xsl:call-template>
	            </xsl:otherwise>
	        </xsl:choose>
	    </xsl:template>
	
		<xsl:template name="TRUNCATE_TEXT">
			<xsl:param name="text"/>
			<xsl:param name="new_length"/>
			<xsl:param name="start_from">0</xsl:param>
			
			<xsl:variable name="ret">
				<xsl:choose>
					<xsl:when test="string-length($text) &gt; ($start_from + $new_length)">
						<xsl:value-of select="substring($text, $start_from, $new_length)"/>
						<xsl:text>...</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($text, $start_from)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="$ret"/>
		</xsl:template>

</xsl:stylesheet>
