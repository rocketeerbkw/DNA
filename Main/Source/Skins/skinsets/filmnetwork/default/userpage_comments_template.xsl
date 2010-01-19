<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- 
     #####################################################################################
	   COMMENT section of a user page
     ##################################################################################### 
	-->
	<xsl:template name="USER_COMMENTS">
		<!-- second section header -->
		<a name="comments" />
		<table border="0" cellpadding="0" cellspacing="0" class="profileTitle"
			width="371">
			<tr>
				<td valign="top" width="371">
					<h2>
						<img alt="comments" height="24"
							src="{$imagesource}furniture/myprofile/heading_comments.gif"
							width="153" />
					</h2>
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div class="textmedium">
						<strong>
							<xsl:choose>
								<xsl:when
									test="count(/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID=$site_number]) > 0">
									<xsl:choose>
										<xsl:when test="$ownerisviewer = 1"
											>Below is a list of comments you have made. Click the subject to read the comment or 'last comment' to read the last comment made on that subject.</xsl:when>
										<xsl:otherwise>Below is a list of comments 
											<xsl:choose>
												<xsl:when
													test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"
													 />
												</xsl:otherwise>
											</xsl:choose> has made. Click the subject to read the comment or 'last comment' to read the last comment made on that subject.
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$ownerisviewer = 1"
											>Links to comments you make will appear here.</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when
													test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"
													 />
												</xsl:otherwise>
											</xsl:choose> is yet to make a comment
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</strong>
					</div>
					<!-- 12px Spacer table -->
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<tr>
							<td height="12" />
						</tr>
					</table>
					<!-- END 12px Spacer table -->
					<!-- comments content table -->
					<xsl:apply-templates mode="r_userpage" select="RECENT-POSTS" />
					<div class="profileMoreAbout">
						<a href="{root}SiteHelpProfile#comments"
								>more about comments&nbsp;<img alt="" height="7"
								src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
							 /></a>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest conversations the user
	has contributed to
 	-->
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
		<!-- default text if no entries have been made -->
		<xsl:apply-templates mode="c_postlistempty" select="." />
		<!-- the list of recent entries -->
		<xsl:apply-templates mode="c_postlist" select="POST-LIST" />
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<!-- intro text -->
			<xsl:apply-templates mode="c_userpage"
				select="POST[@PRIVATE=0][not(/H2G2/ARTICLE/ARTICLEINFO/FORUMID = THREAD/@FORUMID)][SITEID=$site_number][position() &lt;=$postlimitentries]"
			 />
		</table>
		<xsl:choose>
			<xsl:when test="count(./POST[SITEID=$site_number])&gt;5">
				<!-- all my coversations link -->
				<xsl:apply-templates mode="c_morepostslink" select="USER/USERID" />
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<xsl:apply-templates mode="c_userpage"
				select="POST[position() &lt;=$postlimitentries][SITEID=$site_number]"
			 />
		</table>
		<!-- all my conversations link -->
		<xsl:choose>
			<xsl:when test="count(./POST)&gt;5">
				<!-- all my coversations link -->
				<xsl:apply-templates mode="c_morepostslink" select="USER/USERID" />
			</xsl:when>
			<xsl:otherwise>
				<br />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="USERID" mode="r_morepostslink">
	Description: Presentation of a link to 'see all posts'
	 -->
	<xsl:template match="USERID" mode="r_morepostslink">
		<!-- more comments table 
	Alistair: Need to get this to link to list of all comments-->
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="morecommments"><a
							href="{root}MP{/H2G2/PAGE-OWNER/USER/USERID}">
							<strong>more comments</strong>
						</a>&nbsp;<img alt="" height="7"
							src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
					 /></div>
				</td>
			</tr>
		</table>
		<!-- END more comments table -->
	</xsl:template>

	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
		<div class="box2">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"
			> </xsl:element>
		</div>
	</xsl:template>

	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
		<div class="box2">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"
			> </xsl:element>
		</div>
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
	Description: Presentation of a single post in a list
	 -->
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
		<xsl:if test="THREAD/FORUMTITLE !=
			concat(/H2G2/RECENT-POSTS/POST-LIST/USER/FIRSTNAMES, ' ' ,
			/H2G2/RECENT-POSTS/POST-LIST/USER/LASTNAME)">
			<tr>
				<td valign="top" width="371">
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when
								test="count(preceding-sibling::POST[SITEID=$site_number]) mod 2 = 0"
								>even</xsl:when>
							<xsl:otherwise>odd</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<div class="titlecentcol">
						<img align="absmiddle" alt="" height="5"
							src="{$imagesource}furniture/myprofile/bullett.gif" width="5" />
						<strong>&nbsp;<xsl:apply-templates mode="t_userpagepostsubject"
								select="THREAD/@THREADID" /></strong>
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
	<xsl:template match="DATE" mode="r_userpagepostdate">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the post date link
	-->
	<xsl:template match="DATE" mode="r_userpagepostdate">
		<a class="textdark">
			<xsl:attribute name="HREF"><xsl:value-of select="$root" />F<xsl:value-of
					select="../../../@FORUMID" />?thread=<xsl:value-of
					select="../../../@THREADID" />&amp;post=<xsl:value-of
					select="../../@POSTID" />#p<xsl:value-of select="../../@POSTID" /></xsl:attribute>
			<xsl:apply-templates select="." />
		</a>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_userpagepostdate">
	Description: Presentation of when the user posted date
	 -->
	<xsl:template match="POST" mode="r_userpagepostdate">
		<xsl:apply-imports />
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_userpagepostlastreply">
	Description: Presentation of the 'reply to a user posting' date
	 -->
	<xsl:template match="POST" mode="r_userpagepostlastreply">
		<xsl:apply-templates mode="t_lastreplytext" select="." />
		<xsl:text>  </xsl:text>
		<xsl:apply-templates mode="t_userpagepostlastreply" select="." />
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the 'last reply' date link
	-->
	<xsl:template match="POST" mode="t_userpagepostlastreply">
		<xsl:if test="HAS-REPLY > 0">
			<!-- |&nbsp; -->
			<xsl:apply-templates mode="LatestPost" select="THREAD/REPLYDATE/DATE" />
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the 'last reply' date link
	-->
	<xsl:template match="DATE" mode="LatestPost">
		<xsl:param name="attributes" />
		<a class="textdark">
			<xsl:attribute name="HREF"><xsl:value-of select="$root" />F<xsl:value-of
					select="../../@FORUMID" />?thread=<xsl:value-of
					select="../../@THREADID" /><xsl:variable name="thread"
					select="../../@THREADID" />#last</xsl:attribute>
			<xsl:apply-templates select="." />
		</a>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
		<a
			href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}"
			xsl:use-attribute-sets="npostunsubscribe1">
			<xsl:copy-of select="$m_removeme" />
		</a>
	</xsl:template>

	<!-- my portfolio -->
	<xsl:template match="RECENT-ENTRIES" mode="r_userpage">
		<xsl:param name="recententriestype" />

		<xsl:apply-templates mode="c_userpagelistempty" select="." />

		<xsl:apply-templates mode="c_userpagelist" select="ARTICLE-LIST">
			<xsl:with-param name="recententriestype">
				<xsl:value-of select="$recententriestype" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

</xsl:stylesheet>
