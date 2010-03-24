<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morecommentspage.xsl"/>
	<!--
	MOREPOSTS_MAINBODY"
		POSTS
		POST-LIST
			owner_morepostlistempty
			viewer_morepostlistempty
			owner_morepostlist
			viewer_morepostlist
		POST		
	-->
	
	<xsl:variable name="morecommentsPreviousLabel">Newer</xsl:variable>
	<xsl:variable name="morecommentsNextLabel">Older</xsl:variable>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MORECOMMENTS_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<tr>
				<td id="crumbtrail">
					<h5>You are here &gt; 
						<a href="{$homepage}">
							<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a> &gt; Your comments
					</h5>
				</td>
			</tr>
			<tr>
				<td class="pageheader">
					<table width="635" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td id="subject">
								<h1>
									<xsl:choose>
										<xsl:when test="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER/USERNAME">
											<xsl:apply-templates select="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER" mode="username" />'s comments</xsl:when>
										<xsl:otherwise>
											<xsl:text>Comments</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</h1>
							</td>
							<td id="rulesHelp">
								<p>
									<a href="{$houserulespopupurl}" onclick="popupwindow('HouseRules', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380')" target="popwin" title="This link opens in a new popup window">House rules</a>  | <a href="{$faqpopupurl}" onclick="popupwindow('Help', 'popwin', 'status=1,resizable=1,scrollbars=1,toolbar=1,width=550,height=380')" target="popwin" title="This link opens in a new popup window">Help</a>
								</p>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="635">
					<table cellspacing="0" cellpadding="0" border="0" width="630">
						<tr>
							<td id="discussionTitle">
								<br/>
								<p>User ID: U<xsl:value-of select="/H2G2/MORECOMMENTS/@USERID"/>
								</p>
								<hr width="500" align="left" class="line"/>
								<p>
									<xsl:choose>
										<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/MORECOMMENTS/@USERID">
											<xsl:choose>
												<xsl:when test="MORECOMMENTS/COMMENTS-LIST/COMMENTS">
													<xsl:text>All your comments are listed here.</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													You have not posted any comments yet.
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER/USERNAME">
													<xsl:text>All </xsl:text>
													<xsl:apply-templates select="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER" mode="username" />
													<xsl:text>'s comments are listed here.</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													This user has not posted any comments yet.
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
									
									<xsl:text> You can also </xsl:text>
									<a href="MP{/H2G2/MORECOMMENTS/@USERID}">
										<xsl:text>view a list of </xsl:text>
										<xsl:choose>
											<xsl:when test="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER/USERNAME">
												<xsl:apply-templates select="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER" mode="username" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>this user</xsl:text>												
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text>'s message board posts</xsl:text>
									</a>.
								</p>
								<br/>
								<!-- editor link for viewing more info about user -->
                <xsl:apply-templates select="MORECOMMENTS" mode="t_morepostsPSlink"/>
                <xsl:apply-templates select="MORECOMMENTS" mode="t_moderateuserlink"/>
              </td>
						</tr>
					</table>
				</td>
			</tr>
			<xsl:if test="MORECOMMENTS/COMMENTS-LIST/COMMENTS">
				<tr>
					<td align="center">
						<table width="625" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td valign="top" class="tablenavbarTop" colspan="3">
									<div class="tablenavtext">
									<xsl:if test="$ownerisviewer=1">
									<a href="MP{/H2G2/SYSTEMMESSAGEMAILBOX/@USERID}" id="morepostsbutton-on">Your Discussions</a> 
									</xsl:if>
									
									<xsl:if test="(/H2G2/SITEOPTION/NAME='UseSystemMessages' and /H2G2/SITEOPTION/VALUE='1') and $ownerisviewer=1">
										<xsl:choose>
											<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'mbnewsround' or /H2G2/CURRENTSITEURLNAME = 'mbcbbc'">
												<a href="smm" id="smmbutton">Messages from the Mods</a>
											</xsl:when>
											<xsl:otherwise>
												<a href="smm" id="smmbutton">Moderation Notifications</a>
											</xsl:otherwise>
										</xsl:choose>			
									</xsl:if>
										
	
										<xsl:apply-templates select="MORECOMMENTS" mode="c_prevmoreposts"/>&nbsp;|
										<xsl:apply-templates select="MORECOMMENTS" mode="c_nextmoreposts"/>
									</div>
								</td>
							</tr>
							<xsl:apply-templates select="MORECOMMENTS" mode="c_morecommentspage"/>
							<tr>
								<td valign="top" class="tablenavbarBtm" colspan="3">
									<div class="tablenavtext">
										<xsl:apply-templates select="MORECOMMENTS" mode="c_prevmoreposts"/>&nbsp;|
										<xsl:apply-templates select="MORECOMMENTS" mode="c_nextmoreposts"/>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td class="discussions">
					&nbsp;
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_morepostspage">
	Description: Presentation of the object holding the latest conversations the user
	has contributed to
	 -->
	<xsl:template match="COMMENTS-LIST" mode="r_morepostspage">
		<xsl:apply-templates select="." mode="c_morecommentslistempty"/>
		<xsl:apply-templates select="." mode="c_morecommentspage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_morecommentslistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="COMMENTS-LIST" mode="owner_morecommentslistempty">
		<tr class="MPoldrow">
			<td class="MPdiscussion" valign="top" colspan="3">
				<p>
					<xsl:text>You have not left any comments yet.</xsl:text>
					<br/>
					<br/>
					<xsl:text>Any comments you leave will be listed here so that you can easily get back to them.</xsl:text>
				</p>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="COMMENTS-LIST" mode="viewer_morecommentlistempty">
		<tr class="MPoldrow">
			<td class="MPdiscussion" valign="top" colspan="3">
				<p>This person has not left any comments yet.</p>
			</td>
		</tr>
	</xsl:template>
	<!--
		<xsl:template match="POST-LIST" mode="owner_morecommentslist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="COMMENTS" mode="owner_morecommentslist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<xsl:apply-templates select="COMMENT" mode="c_morecommentspage"/>
	</xsl:template>
	<!--
		<xsl:template match="POST-LIST" mode="viewer_morecommentslist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="COMMENTS" mode="viewer_morecommentslist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<xsl:apply-templates select="COMMENT" mode="c_morecommentspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morecommentspage">
	Description: Presentation of a single post in a list
	 -->
	<!-- <xsl:template match="COMMENT" mode="r_morepostspage"> -->
	<xsl:template match="COMMENT" mode="r_morecommentspage">
				<tr class="MPnewrow">
					<!--<td class="MPnew" valign="top" width="49">
						<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETNEW}" width="49" height="35" alt="New!"/>
					</td>-->
					<td class="MPdiscussion" valign="top" width="620">
						<p>
							<span class="strong">
								<a>
									<xsl:call-template name="morecommentspermalinkhref"/>
									<xsl:choose>
										<xsl:when test="FORUMTITLE/text()">
												<xsl:text>Re: </xsl:text>
												<xsl:value-of select="FORUMTITLE"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>(no subject)</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</span>
							<span class="small">
								<br/>
								<xsl:text>Comment made </xsl:text>
								<xsl:apply-templates select="DATEPOSTED/DATE" mode="r_morecommentspagepostdate"/>.
								<!--
								<xsl:text> in </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morecommentspagesitename"/>
								-->
							</span>
						</p>
						<p>
							<br />
							<xsl:apply-templates select="TEXT/text()" mode="text_crop">
								<xsl:with-param name="suffix">
									<xsl:text>... </xsl:text>
									<a>
										<xsl:call-template name="morecommentspermalinkhref"/>
										Read more &gt; 
									</a>
								</xsl:with-param>
							</xsl:apply-templates>
						</p>
						<!-- 	<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/> -->
					</td>
					<td valign="top" width="0">
						
					</td>
				</tr>
	</xsl:template>

	
	<!--
		<xsl:template match="SITEID" mode="t_morecommentspageforumname">
	Taken from base
	Purpose:	 Creates the text and presentation for the name of the originating forum
	-->
	<!-- -->
	<xsl:template match="SITEID" mode="t_morecommentspageforumname">
		<a href="{$thisserver}/dna/{translate(/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/NAME,$uppercase,$lowercase)}/F{THREAD/@FORUMID}">
			<xsl:value-of select="THREAD/FORUMTITLE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_morepostspagesitename">
	Taken from base
	Purpose:	 Creates the text and presentation for the name of the originating site
	-->
	<xsl:template match="SITEID" mode="t_morecommentspagesitename">
		<a href="{$thisserver}/dna/{/H2G2/SITE-LIST/SITE[@ID=current()]/NAME}">
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_morecommentspagemessages">
	Description: Presentation of the amount of messages in each thread
	 -->
	<xsl:template match="COMMENT" mode="r_morecommentspagemessages">
		<span class="small">
			<xsl:text> (</xsl:text>
			<xsl:choose>
				<xsl:when test="@COUNTPOSTS = 1">
					<xsl:apply-templates select="@COUNTPOSTS" mode="r_morecommentspagemessages"/> message</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@COUNTPOSTS" mode="r_morecommentspagemessages"/> messages</xsl:otherwise>
			</xsl:choose>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morecommentspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morecommentspagepostdate">
		
		<xsl:choose>
			<xsl:when test="./@RELATIVE != ''">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>just this minute</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
			<!--<xsl:apply-imports/>-->
		
	</xsl:template>
	
	<!--
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="COMMENT" mode="r_postunsubscribemorecommentspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
		<xsl:apply-imports/>
	</xsl:template>
  <!--
	<xsl:template match="MORECOMMENTS" mode="t_morepostsPSlink">
	Taken from the base file
	Purpose:	 Creates the 'back to personal space' link
	-->
  <xsl:template match="MORECOMMENTS" mode="t_morepostsPSlink">
    <xsl:if test="$test_IsEditor = 1">
      <p class="strong">
        <a href="{$root}U{@USERID}" xsl:use-attribute-sets="mPOSTS_morepostsPSlink">
          More information on this user
        </a>
      </p>
      <br/>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template match="MORECOMMENTS" mode="t_moderateuserlink">
	Taken from the base file
	Purpose:	 Creates the 'moderate user' link
	-->
  <xsl:template match="MORECOMMENTS" mode="t_moderateuserlink">
    <xsl:if test="$test_IsEditor = 1">
      <p class="strong">
        <a href="{$root}MemberList?UserID={@USERID}" xsl:use-attribute-sets="mPOSTS_moderateuserlink">
          Moderate this user
        </a>
      </p>
      <br/>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template match="MORECOMMENTS" mode="c_prevmoreposts">
	Purpose:	 Calls the container for the 'previous posts' link if there is one
	-->
	<xsl:template match="MORECOMMENTS" mode="c_prevmoreposts">
		<xsl:choose>
			<xsl:when test="./COMMENTS-LIST[@SKIP &gt; 0]">
				<xsl:apply-templates select="." mode="r_prevmoreposts"/>
			</xsl:when>
			<xsl:otherwise>
				<span class="off">
					<xsl:value-of select="$morecommentsPreviousLabel"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
	Purpose:	 Creates the 'previous posts' link
	-->
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
		<a href="{$root}MC{./@USERID}?show={./COMMENTS-LIST/@SHOW}&amp;skip={number(./COMMENTS-LIST/@SKIP) - number(./COMMENTS-LIST/@SHOW)}">
			<xsl:value-of select="$morecommentsPreviousLabel"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="c_nextmoreposts">
	Purpose:	 Calls the container for the 'more posts' link if there is one
	-->
	<xsl:template match="MORECOMMENTS" mode="c_nextmoreposts">
		<xsl:choose>
			<xsl:when test="COMMENTS-LIST[@MORE=1]">
				<xsl:apply-templates select="." mode="r_nextmoreposts"/>
			</xsl:when>
			<xsl:otherwise>
				<span class="off">
					<xsl:value-of select="$morecommentsNextLabel"/>

				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
	Purpose:	 Creates the 'more posts' link
	-->
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
		<a href="{$root}MC{./@USERID}?show={COMMENTS-LIST/@SHOW}&amp;skip={number(./COMMENTS-LIST/@SKIP) + number(./COMMENTS-LIST/@SHOW)}">
			<xsl:value-of select="$morecommentsNextLabel"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_morepostspostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the date for the last reply text
	-->
	<xsl:template match="COMMENT" mode="t_morepostspostlastreply">
		<a>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/>&amp;latest=1</xsl:attribute>
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
		</a>
	</xsl:template>
	<!--
		<xsl:template match="POST" mode="t_morepostspostlastreply">
		Author:		Richard Hodgson
		Context:    /H2G2/POSTS/POST-LIST/POST
		Purpose:	Creates the href attribute for HTML anchors to navigate to the
					correct comments sssi page.
	-->
	<xsl:template name="morecommentspermalinkhref">
		<xsl:variable name="showCount" select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[SECTION = 'CommentForum' and NAME = 'DefaultShow']/VALUE"/>
		<xsl:variable name="pageNumber" select="(floor(POSTINDEX div $showCount))"/>
		<xsl:variable name="dnafrom" select="$showCount * $pageNumber"/>
		<xsl:variable name="dnato" select="$dnafrom + $showCount"/>
		
		<xsl:attribute name="href">
			<xsl:value-of select="URL"></xsl:value-of>
			<xsl:text>?dnafrom=</xsl:text>
			<xsl:value-of select="$dnafrom"/>
			<xsl:text>&amp;dnato=</xsl:text>
			<xsl:value-of select="$dnato"/>
			<xsl:text>#dnaacs</xsl:text>
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>