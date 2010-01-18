<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas- microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../base/base-morepostspage.xsl" />
	
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
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOREPOSTS_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message"
					>MOREPOSTS_MAINBODY test variable = <xsl:value-of
					select="$current_article_type" /></xsl:with-param>
			<xsl:with-param name="pagename">morepostspage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td height="10">
					<!-- crumb menu -->
					<div class="crumbtop">
						<span class="textmedium"><a>
								<xsl:choose>
									<xsl:when test="$ownerisviewer = 1">
										<xsl:attribute name="href">
											<xsl:value-of
												select="concat($root,'U',VIEWING-USER/USER/USERID)" />
										</xsl:attribute>
										<strong>my profile</strong>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="href">
											<xsl:value-of
												select="concat($root,'U',/H2G2/POSTS/POST-LIST/USER/USERID)"
											 />
										</xsl:attribute>
										<strong><xsl:choose>
												<xsl:when
													test="string-length(/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/LASTNAME" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/USERNAME" />
												</xsl:otherwise>
											</xsl:choose>'s profile</strong>
									</xsl:otherwise>
								</xsl:choose>
							</a> |</span>
						<span class="textxlarge">
							<xsl:choose>
								<xsl:when test="$ownerisviewer=1">all my comments</xsl:when>
								<xsl:otherwise>all comments</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
					<!-- END crumb menu -->
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="20" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
				</td>
			</tr>
			<tr>
				<td valign="top" width="371">

					<table border="0" cellpadding="0" cellspacing="0" width="371">

						<tr>
							<td class="topbg" height="69" valign="top">
								<div class="biogname">
									<strong>
										<xsl:choose>
											<xsl:when test="$ownerisviewer = 1">all my comments</xsl:when>
											<xsl:otherwise>all comments</xsl:otherwise>
										</xsl:choose>
									</strong>
								</div>
								<div class="topboxcopy">Below is a list of comments <xsl:choose>
										<xsl:when test="$ownerisviewer = 1">you have </xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when
													test="string-length(/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/LASTNAME"
													 />&nbsp;has		
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="/H2G2/POSTS/POST-LIST/USER/USERNAME"
													 />&nbsp;has
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose> made.<br />Click the subject to read the message</div>
							</td>
						</tr>
					</table>
				</td>
				<td class="topbg" valign="top" width="20" />
				<td class="topbg" valign="top"> </td>
			</tr>
			<tr>
				<td colspan="3" valign="top" width="635">
					<img height="27"
						src="{$imagesource}furniture/writemessage/topboxangle.gif"
						width="635" />
				</td>
			</tr>
		</table>
		<!-- spacer -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td height="10" />
			</tr>
		</table>
		<!-- end spacer -->
		<!-- END head section -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
				<td>
					<img alt="" class="tiny" height="10" src="/f/t.gif" width="20" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
				</td>
			</tr>
			<tr>
				<td height="300" valign="top">
					<!-- LEFT COL MAIN CONTENT -->
					<!-- previous / page x of x / next table -->
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<tr>
							<td height="2" width="371">
								<img alt="" class="tiny" height="2"
									src="{$imagesource}furniture/blackrule.gif" width="371" />
							</td>
						</tr>
						<tr>
							<td height="8" />
						</tr>
						<tr>
							<td valign="top" width="371">
								<table border="0" cellpadding="0" cellspacing="0" width="371">
									<tr>
										<td width="60">
											<div class="textmedium">
												<strong>
													<xsl:apply-templates mode="r_prevmoreposts"
														select="POSTS" />
												</strong>
											</div>
										</td>
										<td align="center" width="251"
											></td>
										<td align="right" width="60">
											<div class="textmedium">
												<strong>
													<xsl:apply-templates mode="r_nextmoreposts"
														select="POSTS" />
												</strong>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td height="18" width="371">
								<img alt="" class="tiny" height="2"
									src="{$imagesource}furniture/blackrule.gif" width="371" />
							</td>
						</tr>
					</table>
					<!-- END previous / page x of x / next table -->
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<xsl:apply-templates mode="c_morepostspage" select="POSTS" />
					</table>
					<!-- previous / page x of x / next table -->
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<tr>
							<td height="18" width="371">
								<img alt="" class="tiny" height="2"
									src="{$imagesource}furniture/blackrule.gif" width="371" />
							</td>
						</tr>
						<tr>
							<td valign="top" width="371">
								<table border="0" cellpadding="0" cellspacing="0" width="371">
									<tr>
										<td width="60">
											<div class="textmedium">
												<strong>
													<xsl:apply-templates mode="r_prevmoreposts"
														select="POSTS" />
												</strong>
											</div>
										</td>
										<td align="center" width="251"
											></td>
										<td align="right" width="60">
											<div class="textmedium">
												<strong>
													<xsl:apply-templates mode="r_nextmoreposts"
														select="POSTS" />
												</strong>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td height="18" width="371">
								<img alt="" class="tiny" height="2"
									src="{$imagesource}furniture/blackrule.gif" width="371" />
							</td>
						</tr>
					</table>
					<xsl:choose>
						<xsl:when test="$ownerisviewer = 1">
							<div class="textmedium"><strong>
									<a><xsl:attribute name="href">
											<xsl:value-of
												select="concat($root,'U',/H2G2/POSTS/POST-LIST/USER/USERID)"
											 />
										</xsl:attribute>back to my profile</a>
								</strong>&nbsp;<img alt="" height="7"
									src="{$imagesource}furniture/myprofile/arrowdark.gif"
									width="4" /><br /><br /></div>
						</xsl:when>
						<xsl:otherwise>
							<div class="textmedium"><strong>
									<a><xsl:attribute name="href">
											<xsl:value-of
												select="concat($root,'U',/H2G2/POSTS/POST-LIST/USER/USERID)"
											 />
										</xsl:attribute>back to <xsl:choose>
											<xsl:when
												test="string-length(/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES) &gt; 0">
												<xsl:value-of
													select="/H2G2/POSTS/POST-LIST/USER/FIRSTNAMES"
													 />&nbsp;
												<xsl:value-of
													select="/H2G2/POSTS/POST-LIST/USER/LASTNAME" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="/H2G2/POSTS/POST-LIST/USER/USERNAME" />
											</xsl:otherwise>
										</xsl:choose> 's profile</a>
								</strong>&nbsp;<img alt="" height="7"
									src="{$imagesource}furniture/myprofile/arrowdark.gif"
									width="4" /><br /><br /></div>
						</xsl:otherwise>
					</xsl:choose>
					<!-- END previous / page x of x / next table -->
					<!-- END LEFT COL MAIN CONTENT -->
				</td>
				<td><!-- 20px spacer column --></td>
				<td valign="top">
					<!-- hints and tips -->
					<!-- top with angle -->
					<table border="0" cellpadding="0" cellspacing="0" width="244">
						<tr>
							<td align="right" class="webboxbg" height="42" valign="top"
								width="50">
								<div class="alsoicon">
									<img alt="" height="24"
										src="{$imagesource}furniture/myprofile/alsoicon.gif"
										width="25" />
								</div>
							</td>
							<td class="webboxbg" valign="top" width="122">
								<div class="hints">
									<strong>hints and tips</strong>
								</div>
							</td>
							<td class="anglebg" valign="top" width="72">
								<img alt="" class="tiny" height="1" src="/f/t.gif" width="72" />
							</td>
						</tr>
					</table>
					<!-- END top with angle -->
					<!-- hint paragraphs -->
					<table border="0" cellpadding="0" cellspacing="0" width="244">
						<tr>
							<td class="webboxbg" height="42" valign="top" width="244">
								<xsl:copy-of select="$commentlist_hints" />
							</td>
						</tr>
					</table>
					<!-- END hint paragraphs -->
					<!-- END hints and tips -->
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
		<xsl:apply-templates mode="c_morepostlistempty" select="." />
		<xsl:apply-templates mode="c_morepostspage" select="POST-LIST" />
	</xsl:template>
	
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlistempty">
		<xsl:copy-of select="$m_forumownerempty" />
	</xsl:template>
	
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlistempty">
		<xsl:copy-of select="$m_forumviewerempty" />
	</xsl:template>
	
	<!--
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
		<xsl:copy-of select="$m_forumownerfull" />
		<!-- only show filmnetwork conversations -->
		<xsl:apply-templates mode="c_morepostspage"
			select="POST[SITEID = /H2G2/SITE-LIST/SITE[NAME = 'filmnetwork']/@ID]" />
	</xsl:template>
	
	<!--
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
		<xsl:copy-of select="$m_forumviewerfull" />
		<!-- only show filmnetwork conversations -->
		<xsl:apply-templates mode="c_morepostspage"
			select="POST[SITEID = /H2G2/SITE-LIST/SITE[NAME = 'filmnetwork']/@ID]" />
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morepostspage">
	Description: Presentation of a single post in a list
	 -->
	<xsl:template match="POST" mode="r_morepostspage">
		<xsl:if test="THREAD/FORUMTITLE !=
			concat(../USER/FIRSTNAMES, ' ' ,
			../USER/LASTNAME)">
			<tr>
				<td valign="top" width="371">
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when
								test="count(preceding-sibling::POST[SITEID=$site_number]) mod 2 = 0"
								>lightband</xsl:when>
							<xsl:otherwise>darkband</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<div class="titlecentcol">
						<img align="middle" alt="" height="5"
							src="{$imagesource}furniture/myprofile/bullett.gif" width="5" />
						<strong>&nbsp;<xsl:apply-templates mode="t_morepostspagesubject"
								select="THREAD/@THREADID" />
							<xsl:if test="THREAD/SUBJECT=''">
								<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}"
									xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a>
							</xsl:if></strong>
					</div>
					<div class="commentsTimes">
						<xsl:if test="THREAD/LASTUSERPOST"><!-- tw added this if to remove no comment stuff from here rather then later -->
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">you</xsl:when>
								<xsl:otherwise><xsl:value-of
										select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
										 />&nbsp;<xsl:value-of
										select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
								</xsl:otherwise>
							</xsl:choose>&nbsp;commented <xsl:apply-templates
								mode="r_userpagepostdate"
								select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" />
							<xsl:if test="HAS-REPLY > 0">&nbsp;|</xsl:if>
						</xsl:if>
						<xsl:apply-templates mode="c_userpagepostlastreply" select="." />
					</div>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<xsl:apply-imports />
	</xsl:template>

	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/LASTUSERPOST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<xsl:apply-templates select="." />
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
	Description: Presentation of the 'last reply to post' date
	 -->
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
		<xsl:apply-templates mode="t_lastreplytext" select="."
			 />&nbsp;
		<xsl:apply-templates mode="t_morepostspostlastreply"
			select="." />
	</xsl:template>
	
	<!--
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
		<xsl:apply-imports />
	</xsl:template>
	
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
				<xsl:copy-of select="$previous.arrow" />&nbsp;<xsl:apply-imports />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_newerpostings" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@MORE=1]">
				<xsl:apply-imports />
				<xsl:text>&nbsp;</xsl:text>
				<xsl:copy-of select="$next.arrow" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_olderpostings" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>