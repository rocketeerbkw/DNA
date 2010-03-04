<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morepostspage.xsl"/>
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
	
	
	<xsl:variable name="morepostsPreviousLabel">Newer</xsl:variable>
	<xsl:variable name="morepostsNextLabel">Older</xsl:variable>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOREPOSTS_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<tr>
				<td id="crumbtrail">
					<h5>You are here &gt; 
						<a href="{$homepage}">
							<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a> &gt; Your discussions
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
										<xsl:when test="/H2G2/POSTS/POST-LIST/USER/USERNAME">
											<xsl:apply-templates select="/H2G2/POSTS/POST-LIST/USER" mode="username"/>'s discussions</xsl:when>
										<xsl:otherwise>Posts</xsl:otherwise>
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
								<p>User ID: U<xsl:value-of select="/H2G2/POSTS/@USERID"/>
								</p>
								<hr width="500" align="left" class="line"/>
								<p>
								
								
									<xsl:choose>
										<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/POSTS/@USERID">
											<xsl:choose>
												<xsl:when test="POSTS/POST-LIST/POST">
													<xsl:text>All your posts are listed here.</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													You have not made any posts yet.
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="POSTS/POST-LIST/USER/USERNAME">
													<xsl:text>All </xsl:text>
													<xsl:apply-templates select="POSTS/POST-LIST/USER" mode="username" />
													<xsl:text>'s posts are listed here.</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													This user has not made any posts yet.
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
									
									<xsl:text> You can also </xsl:text>
									<a href="MC{POSTS/@USERID}">
										<xsl:text>view a list of </xsl:text>
										<xsl:choose>
											<xsl:when test="POSTS/POST-LIST/USER/USERNAME">
												<xsl:apply-templates select="POSTS/POST-LIST/USER" mode="username" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>this user</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text>'s comments</xsl:text>
									</a>.
								</p>
								<br/>
                <xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
                <xsl:apply-templates select="POSTS" mode="t_moderateuserlink"/>
              </td>
						</tr>
					</table>
				</td>
			</tr>
			<xsl:if test="POSTS/POST-LIST/POST">
				
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
											<xsl:when test="/H2G2/SITE/NAME = 'mbcbbc' or /H2G2/SITE/NAME = 'mbnewsround'">
												<a href="smm" id="smmbutton">Messages from the Mods</a>
											</xsl:when>
											<xsl:otherwise>
												<a href="smm" id="smmbutton">Moderation Notifications</a>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
										
	
										<xsl:apply-templates select="POSTS" mode="c_prevmoreposts"/>&nbsp;|
										<xsl:apply-templates select="POSTS" mode="c_nextmoreposts"/>
									</div>
								</td>
							</tr>
							<xsl:apply-templates select="POSTS" mode="c_morepostspage"/>
							<tr>
								<td valign="top" class="tablenavbarBtm" colspan="3">
									<div class="tablenavtext">
										<xsl:apply-templates select="POSTS" mode="c_prevmoreposts"/>&nbsp;|
										<xsl:apply-templates select="POSTS" mode="c_nextmoreposts"/>
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
	<xsl:template match="POSTS" mode="r_morepostspage">
	Description: Presentation of the object holding the latest conversations the user
	has contributed to
	 -->
	<xsl:template match="POSTS" mode="r_morepostspage">
		<xsl:apply-templates select="." mode="c_morepostlistempty"/>
		<xsl:apply-templates select="POST-LIST" mode="c_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlistempty">
		<tr class="MPoldrow">
			<td class="MPdiscussion" valign="top" colspan="3">
				<p>
					<xsl:text>You have not yet posted any messages.</xsl:text>
					<br/>
					<br/>
					<xsl:text>Any messages you do post will be listed here so that you can easily get back to them. This page will also tell you when someone has replied to one of your messages.</xsl:text>
				</p>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlistempty">
		<tr class="MPoldrow">
			<td class="MPdiscussion" valign="top" colspan="3">
				<p>This person has not yet posted any messages.</p>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<xsl:apply-templates select="POST" mode="c_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<xsl:apply-templates select="POST" mode="c_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morepostspage">
	Description: Presentation of a single post in a list
	 -->
	<!-- <xsl:template match="POST[SITEID = /H2G2/CURRENTSITE]" mode="r_morepostspage"> -->


	<xsl:template match="POST[(/H2G2/SITE/NAME = 'mbcbbc') or (/H2G2/SITE/NAME = 'mbnewsround')]" mode="r_morepostspage">
		<xsl:if test="SITEID = /H2G2/SITE/@ID">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/POSTS/POST-LIST/USER/USERID and @COUNTPOSTS > @LASTPOSTCOUNTREAD">
				<tr class="MPnewrow">
					<!--<td class="MPnew" valign="top" width="49">
						<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETNEW}" width="49" height="35" alt="New!"/>
					</td>-->
					<td class="MPdiscussion" valign="top" width="396">
						<p>
							<xsl:choose>
								<xsl:when test="string(THREAD/SUBJECT)">
									<span class="strong">
										<xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/>
									</span>
								</xsl:when>
								<xsl:otherwise>
									<span class="strong">
										<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xsl:use-attribute-sets="mTHREADID_t_morepostssubject">No subject</a>
									</span>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="." mode="r_morepostspagemessages"/>
							<span class="small">
								<br/>
								<xsl:text>from </xsl:text>
								<xsl:apply-templates select="." mode="t_morepostspageforumname"/>
								<xsl:text> in </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morepostspagesitename"/>
							</span>
							<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
						</p>
						<!-- 	<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/> -->
					</td>
					<td class="MPdate" valign="top" width="180">
						<p>
							<xsl:text>New posts: </xsl:text>
							<xsl:value-of select="@COUNTPOSTS - @LASTPOSTCOUNTREAD"/>
							<br/>
							<xsl:apply-templates select="." mode="c_morepostspagepostlastreply"/>
						</p>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="MPoldrow">
					<!--<td class="MPnew" valign="top" width="20">
						&nbsp;</td>-->
					<td class="MPdiscussion" valign="top" width="425">
						<p>
							<xsl:choose>
								<xsl:when test="string(THREAD/SUBJECT)">
									<xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/>
								</xsl:when>
								<xsl:otherwise>
									<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xsl:use-attribute-sets="mTHREADID_t_morepostssubject">No subject</a>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="." mode="r_morepostspagemessages"/>
							<span class="small">
								<br/>
								<xsl:text>from </xsl:text>
								<xsl:apply-templates select="." mode="t_morepostspageforumname"/>
								<xsl:text> in </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morepostspagesitename"/>
							</span>
							<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
						</p>
						<!-- 	<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/> -->
					</td>
					<td class="MPdate" valign="top" width="180">
						<p>
							<xsl:text>New posts: 0</xsl:text>
							<br/>
							<xsl:apply-templates select="." mode="c_morepostspagepostlastreply"/>
						</p>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>
	

	<xsl:template match="POST[(/H2G2/SITE/NAME != 'mbcbbc') and (/H2G2/SITE/NAME != 'mbnewsround')]" mode="r_morepostspage">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/POSTS/POST-LIST/USER/USERID and @COUNTPOSTS > @LASTPOSTCOUNTREAD">
				<tr class="MPnewrow">
					<!--<td class="MPnew" valign="top" width="49">
						<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETNEW}" width="49" height="35" alt="New!"/>
					</td>-->
					<td class="MPdiscussion" valign="top" width="396">
						<p>
							<xsl:choose>
								<xsl:when test="string(THREAD/SUBJECT)">
									<span class="strong">
										<xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/>
									</span>
								</xsl:when>
								<xsl:otherwise>
									<span class="strong">
										<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xsl:use-attribute-sets="mTHREADID_t_morepostssubject">No subject</a>
									</span>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="." mode="r_morepostspagemessages"/>
							<span class="small">
								<br/>
								<xsl:text>from </xsl:text>
								<xsl:apply-templates select="." mode="t_morepostspageforumname"/>
								<xsl:text> in </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morepostspagesitename"/>
							</span>
							<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
						</p>
						<!-- 	<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/> -->
					</td>
					<td class="MPdate" valign="top" width="180">
						<p>
							<xsl:text>New posts: </xsl:text>
							<xsl:value-of select="@COUNTPOSTS - @LASTPOSTCOUNTREAD"/>
							<br/>
							<xsl:apply-templates select="." mode="c_morepostspagepostlastreply"/>
						</p>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="MPoldrow">
					<!--<td class="MPnew" valign="top" width="20">
						&nbsp;</td>-->
					<td class="MPdiscussion" valign="top" width="425">
						<p>
							<xsl:choose>
								<xsl:when test="string(THREAD/SUBJECT)">
									<xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/>
								</xsl:when>
								<xsl:otherwise>
									<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xsl:use-attribute-sets="mTHREADID_t_morepostssubject">No subject</a>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="." mode="r_morepostspagemessages"/>
							<span class="small">
								<br/>
								<xsl:text>from </xsl:text>
								<xsl:apply-templates select="." mode="t_morepostspageforumname"/>
								<xsl:text> in </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morepostspagesitename"/>
							</span>
							<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
						</p>
						<!-- 	<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/> -->
					</td>
					<td class="MPdate" valign="top" width="180">
						<p>
							<xsl:text>New posts: 0</xsl:text>
							<br/>
							<xsl:apply-templates select="." mode="c_morepostspagepostlastreply"/>
						</p>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!--
	<xsl:template match="SITEID" mode="t_morepostspageforumname">
	Taken from base
	Purpose:	 Creates the text and presentation for the name of the originating forum
	-->
	<!-- -->
	<xsl:template match="POST" mode="t_morepostspageforumname">
		<a href="{$thisserver}/dna/{translate(/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/NAME,$uppercase,$lowercase)}/F{THREAD/@FORUMID}">
			<xsl:value-of select="THREAD/FORUMTITLE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_morepostspagesitename">
	Taken from base
	Purpose:	 Creates the text and presentation for the name of the originating site
	-->
	<xsl:template match="SITEID" mode="t_morepostspagesitename">
		<a href="{$thisserver}/dna/{/H2G2/SITE-LIST/SITE[@ID=current()]/NAME}">
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_morepostspagemessages">
	Description: Presentation of the amount of messages in each thread
	 -->
	<xsl:template match="POST" mode="r_morepostspagemessages">
		<span class="small">
			<xsl:text> (</xsl:text>
			<xsl:choose>
				<xsl:when test="@COUNTPOSTS = 1">
					<xsl:apply-templates select="@COUNTPOSTS" mode="r_morepostspagemessages"/> message</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@COUNTPOSTS" mode="r_morepostspagemessages"/> messages</xsl:otherwise>
			</xsl:choose>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<br/>
		<span class="small">
			<xsl:text>Last contribution: </xsl:text>
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
	Description: Presentation of the 'last reply to post' date
	 -->
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
		Latest post: <xsl:apply-templates select="." mode="t_morepostspostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
		<xsl:apply-imports/>
	</xsl:template>
  <!--
	<xsl:template match="POSTS" mode="t_morepostsPSlink">
	Taken from the base file
	Purpose:	 Creates the 'back to personal space' link
	-->
  <xsl:template match="POSTS" mode="t_morepostsPSlink">
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
	<xsl:template match="POSTS" mode="t_moderateuserlink">
	Taken from the base file
	Purpose:	 Creates the 'moderate user' link
	-->
  <xsl:template match="POSTS" mode="t_moderateuserlink">
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
	<xsl:template match="POSTS" mode="c_prevmoreposts">
	Purpose:	 Calls the container for the 'previous posts' link if there is one
	-->
	<xsl:template match="POSTS" mode="c_prevmoreposts">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
				<xsl:apply-templates select="." mode="r_prevmoreposts"/>
			</xsl:when>
			<xsl:otherwise>
				<span class="off"><xsl:value-of select="$morepostsPreviousLabel"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Purpose:	 Creates the 'previous posts' link
	-->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
		<a href="{$root}MP{./@USERID}?show={./POST-LIST/@COUNT}&amp;skip={number(./POST-LIST/@SKIPTO) - number(./POST-LIST/@COUNT)}">
			<xsl:value-of select="$morepostsPreviousLabel"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_nextmoreposts">
	Purpose:	 Calls the container for the 'more posts' link if there is one
	-->
	<xsl:template match="POSTS" mode="c_nextmoreposts">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@MORE=1]">
				<xsl:apply-templates select="." mode="r_nextmoreposts"/>
			</xsl:when>
			<xsl:otherwise>
				<span class="off"><xsl:value-of select="$morepostsNextLabel"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Purpose:	 Creates the 'more posts' link
	-->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
		<a href="{$root}MP{./@USERID}?show={./POST-LIST/@COUNT}&amp;skip={number(./POST-LIST/@SKIPTO) + number(./POST-LIST/@COUNT)}">
			<xsl:value-of select="$morepostsNextLabel"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_morepostspostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the date for the last reply text
	-->
	<xsl:template match="POST" mode="t_morepostspostlastreply">
		<a>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/>&amp;latest=1</xsl:attribute>
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
