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
	<xsl:variable name="limitentries" select="10"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERPAGE_MAINBODY">

	<xsl:choose>
		<xsl:when test="$test_IsEditor">
		

		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="66%" valign="top" class="postmain">
					<table width="100%" cellspacing="0" cellpadding="5" border="0">
						<tr>
							<td>
								<font xsl:use-attribute-sets="mainfont">
								<xsl:apply-templates select="PAGE-OWNER" mode="t_userpageintro"/>
									<xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/>
									<xsl:apply-templates select="ARTICLEFORUM" mode="c_userpage"/>
									<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES" mode="c_userpagerefs"/>
		<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_userpage"/>
																	<br/>
									<font size="3">
										<b>
											<xsl:value-of select="$m_journalentries"/>
										</b>
									</font>
									<xsl:apply-templates select="JOURNAL" mode="c_userpage"/>
									<br/>	
									</font>					
							</td>
						</tr>
					</table>
				</td>
				<td width="34%" valign="top" class="postside">
					<font xsl:use-attribute-sets="mainfont">
						<font size="3">
							<b>
								<xsl:value-of select="$m_recententries"/>
							</b>
						</font>
						<br/>
						<xsl:apply-templates select="RECENT-ENTRIES" mode="c_userpage"/>
						<br/>
						<font size="3">
							<b>
								<xsl:value-of select="$m_mostrecentedited"/>
							</b>
						</font><br/>
						<xsl:apply-templates select="RECENT-APPROVALS" mode="c_userpage"/>
						<br/><br/>
						<font xsl:use-attribute-sets="mainfont">
							<xsl:apply-templates select="RECENT-POSTS" mode="c_userpage"/>
						</font>
						<br/>
						<br/>
						<xsl:call-template name="m_entrysidebarcomplaint"/>
					</font><br/><br/>
				</td>
			</tr>
		</table>
		<xsl:call-template name="insert-articleerror"/>
		
		</xsl:when>
		<xsl:otherwise>
		<br/>
		<p>
		The BBC message boards do not support the Personal Space feature. <br /><br />

		Please follow this link to go back to the <a href="{$homepage}"><xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a>
		</p>
		</xsl:otherwise>
	</xsl:choose>
			
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
		<xsl:apply-templates select="FORUMTHREADS" mode="c_userpage"/>
		<xsl:apply-templates select="." mode="c_viewallthreadsup"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Description: Presentation of the 'Click to see more conversations' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
		<xsl:apply-imports/>
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
		<xsl:value-of select="$m_peopletalking"/>
		<br/>
		<xsl:apply-templates select="THREAD" mode="c_userpage"/>
		<br/>
		<!-- How to create two columned threadlists: -->
		<!--table cellpadding="0" cellspacing="0" border="0">
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
						<font xsl:use-attribute-sets="mainfont" size="1">
							<xsl:apply-templates select="."/>
						</font>
					</td>
					<td>
						<font xsl:use-attribute-sets="mainfont" size="1">
							<xsl:apply-templates select="following-sibling::THREAD[1]"/>
						</font>
					</td>
				</tr>
			</xsl:for-each>
		</table-->
	</xsl:template>
	<!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_userpage">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelinkup"/>
		&nbsp;<font size="1">(<xsl:value-of select="$m_lastposting"/>
			<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/>)</font>
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
		<font size="3">
			<b>References</b>
		</font>
		<br/>
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
		<xsl:apply-templates select="EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]" mode="c_userpagerefsbbc"/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
	Use: presentation of of the 'List of external non-BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
		<xsl:value-of select="$m_refsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]" mode="c_userpagerefsnotbbc"/>
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
		<xsl:apply-templates select="." mode="t_journalmessage"/>
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_moreuserpagejournals"/>
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_adduserpagejournalentry"/>
		<xsl:apply-templates select="JOURNALPOSTS/POST" mode="c_userpagejournalentries"/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Description: Presentation of the 'click here to see more entries' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Description: Presentation of the 'add a journal entry' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagejournalentries">
	Description: Presentation of a single Journal post
	 -->
	<xsl:template match="POST" mode="r_userpagejournalentries">
		<b>
			<xsl:value-of select="SUBJECT"/>
		</b>
		<br/>
		(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/>)
		<br/>
		<xsl:apply-templates select="TEXT" mode="t_journaltext"/>
		<br/>
		<xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
		<br/>
		<xsl:apply-templates select="@THREADID" mode="c_removejournalpostup"/>
		<br/>
		<xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/>
		<br/>
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
		<font size="3">
			<b>
				<xsl:copy-of select="$m_mostrecentconv"/>
			</b>
		</font>
		<br/>
		<xsl:apply-templates select="." mode="c_postlistempty"/>
		<xsl:apply-templates select="POST-LIST" mode="c_postlist"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<xsl:apply-templates select="POST[position() &lt;=$limitentries]" mode="c_userpage"/>
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<xsl:apply-templates select="POST[position() &lt;=$limitentries]" mode="c_userpage"/>
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
		<xsl:apply-templates select="ARTICLE[position() &lt;=$limitentries]" mode="c_userpagelist"/>
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
		<xsl:apply-templates select="ARTICLE[position() &lt;=$limitentries]" mode="c_userpagelist"/>
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
	<br/><xsl:value-of select="$m_fromsite"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="SITEID" mode="t_userpage"/>:<br/>
		<xsl:apply-templates select="H2G2-ID" mode="t_userpage"/><br/>
		<xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/><br/>
		(<xsl:apply-templates select="DATE-CREATED/DATE" mode="t_userpagearticle"/>) <br/>
		<xsl:apply-templates select="H2G2-ID" mode="c_uncancelarticle"/>
		<xsl:apply-templates select="STATUS" mode="t_userpagearticle"/>
		<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>
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
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
		<xsl:copy-of select="$m_editownerfull"/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$limitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
		<xsl:copy-of select="$m_editviewerfull"/>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$limitentries]" mode="c_userpagelist"/>
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
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
	Description: Presentation of the Page Owner object
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
		<font xsl:use-attribute-sets="mainfont">
			<b>
				<xsl:value-of select="$m_userdata"/>
			</b>
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
			<br/>
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
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Description: Presentation of the 'Add to my friends' link
	 -->
	<xsl:template match="USERID" mode="r_addtofriends">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="GROUPS" mode="r_userpage">
		<xsl:value-of select="$m_memberof"/>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="USER/GROUPS/*">
		<xsl:variable name="groupname" select="name()"/>
		<xsl:apply-templates select="msxsl:node-set($subbadges)/GROUPBADGE[@NAME = $groupname]"/>
	</xsl:template>
	<xsl:template match="GROUPBADGE">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
