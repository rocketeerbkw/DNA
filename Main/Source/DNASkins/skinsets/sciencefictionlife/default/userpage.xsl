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
	<xsl:variable name="postlimitentries" select="10"/>
	<xsl:variable name="articlelimitentries" select="10"/>
	<xsl:variable name="clublimitentries" select="10"/>


	<!-- Page Level template -->
	<xsl:template name="USERPAGE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USERPAGE_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
		<xsl:with-param name="pagename">userpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		<xsl:apply-templates select="/H2G2" mode="c_displayuserpage"/>
	</xsl:template>

	<xsl:template match="H2G2" mode="r_displayuserpage">
		
		<xsl:apply-templates select="CLIP" mode="c_userpageclipped"/>


				<!-- USERNAME -->
				<div class="userprofile_topsection"><!-- TW username only now -->
					<h1><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" /></h1>
				</div>

			
				<!-- USER BIO -->
				<div class="userprofile_listitems">
					<h2><img src="{$imageRoot}images/userprofile/title_intro.gif" border="0" width="38" height="23" alt="Intro" /></h2>
					<p><xsl:apply-templates select="PAGE-OWNER" mode="t_userpageintro"/></p>

					<xsl:if test="$ownerisviewer = 0">
					<br />
					<p>The My Science Fiction Life site is now closed to contributions. From this page you can see an archive of all the recollections made by this user.</p>
					</xsl:if>

					<br />
					
					<!-- SC --><!-- Replaced text to remove intro -->
					<xsl:if test="$ownerisviewer = 1 and $test_introarticle">
						<xsl:choose>
							<xsl:when test="$test_IsEditor"><p><a href="{$root}useredit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Edit your intro</a></p></xsl:when>
							<xsl:otherwise><p>This is your personal space on My Science Fiction Life. This site is now closed to further contributions, which means you can no longer edit your Profile Introduction. However, you can <a href="{$root}useredit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">delete this profile introduction</a> if you wish - <a href="{$root}useredit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">click here to do so</a>.</p>
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:if> 
				
				<!-- SC -->
				<!-- Removed for site closure
				<xsl:if test="$test_introarticle">
					<xsl:variable name="complain_profileID" select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
					<p class="alert">Click <a href="UserComplaint?h2g2ID={$complain_profileID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?h2g2ID={$complain_profileID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" title="Alert the moderator to this profile"><img src="{$imageRoot}images/alert_white.gif" alt="Alert the moderator to this profile" width="15" height="15" /></a> if you see something on this page that breaks the <a href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">house rules</a>.</p>
				</xsl:if>
				-->
	
				
				</div>
			
					





			<div class="middlebackground"></div>

 			<div class="userprofile_white">
 
				<!-- RECOLLECTION TITLE IMAGE -->
				<div class="userprofile_listitems">
					<h2><img src="{$imageRoot}images/recollections_title.gif" border="0" width="97" height="21" alt="Recollections" /></h2>
					<xsl:choose>
						<xsl:when test="RECENT-POSTS/POST-LIST/POST[SITEID=$siteID]">
						<p>These are entries <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" /> has written in their Science Fiction Life</p>
						</xsl:when>
						<xsl:otherwise>
						<xsl:if test="not($ownerisviewer = 1)">
							<p><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" /> has not yet written any recollections</p>
						</xsl:if>
						<xsl:if test="$ownerisviewer = 1">
							<p>You have not yet written any recollections</p>
						</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</div>


				<div class="paddingbottom15px"></div>
				
				<xsl:if test="RECENT-POSTS/POST-LIST/POST[SITEID=$siteID]">
					<xsl:apply-templates select="RECENT-POSTS" mode="c_userpage"/>
				</xsl:if>

				<!-- cv  This code can be updated to list all article entries for an editor. The code is incomplete, so testing would be necessary 


				<xsl:if test="$test_IsEditor and RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID=$siteID]">
					<div class="userprofile_listitems">
						<h2>Article Pages</h2>
						<p>These are articles <xsl:value-of select="concat(/H2G2/PAGE-OWNER/USER/FIRSTNAMES, ' ',/H2G2/PAGE-OWNER/USER/LASTNAME)" /> has written.</p>
					</div>

					<div class="paddingbottom15px"></div>
					
					<xsl:if test="RECENT-POSTS/POST-LIST/POST[SITEID=$siteID]">
						<xsl:apply-templates select="RECENT-ENTRIES" mode="r_userpage"/>
					</xsl:if>
				</xsl:if>

				-->

				<div class="vspace45px"></div>
                <div class="boxtop"></div>

			</div>



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
	<xsl:template match="BODY" mode="r_userpageintro">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Default receiving template if none is provided in the skin
	-->
	<xsl:template match="BODY" mode="r_userpageintro">
		
			<xsl:apply-templates/>
		
		
	</xsl:template>



	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				ARTICLEFORUM Object for the userpage 
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_userpage">
	
		<!-- all my messages list -->
		<xsl:apply-templates select="FORUMTHREADS" mode="c_userpage"/>
		<!-- all my messages links -->
		<xsl:if test="FORUMTHREADS/@TOTALTHREADS >= 1">
		<div class="myspace-h">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:copy-of select="$arrow.right" />
			<xsl:apply-templates select="." mode="r_viewallthreadsup"/>
			</xsl:element>
		</div>
		</xsl:if>
		
	</xsl:template>


	<!--
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	 leave me a message
	-->
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	<div class="myspace-u">
	<div class="myspace-r">		
		<!-- my intro messages -->			
			<xsl:copy-of select="$myspace.messages.orange" />&nbsp;
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">messages</strong>
			</xsl:element>
	
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<!-- leave a message -->
			<div class="myspace-v"><xsl:copy-of select="$arrow.right" />
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_message_signin"/>
			</xsl:attribute>
			leave me a message
			</a>
			
			</div>
		</xsl:element>
	</div></div>
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
	<xsl:choose>
	<xsl:when test="$ownerisviewer = 1">
	<div class="myspace-b"><xsl:value-of select="$m_nomessagesowner" /></div>
	</xsl:when>
	<xsl:otherwise>
	<div class="myspace-b"><xsl:value-of select="$m_nomessages" /></div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
		<xsl:for-each select="THREAD[position()&lt;6]">
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="position() mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="." mode="c_userpage"/></strong>
			</xsl:element>
			</td>
			</tr><tr>
			<td class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				message from <a href="{$root}U{FIRSTPOST/USER/USERID}"><xsl:apply-templates select="FIRSTPOST/USER/USERNAME"/></a> | <xsl:apply-templates select="FIRSTPOST/DATE" mode="collective_long"/>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
		</xsl:for-each>		
	</xsl:template>
	
	<!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_userpage">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelinkup"/>		
		<!-- last posting <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/> -->
	</xsl:template>














	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			REFERENCES Object for the userpage
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_userpagerefs">
		<b>References</b>
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
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
	Description: Object is used if there are replies to a journal entry
	 -->
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
		<xsl:apply-templates select="../@THREADID" mode="t_journalentriesreplies"/>
	<!-- latest reply <xsl:value-of select="$m_latestreply"/><xsl:apply-templates select="../@THREADID" mode="t_journallastreply"/> -->
	</xsl:template>
	<xsl:template name="noJournalReplies">
		<xsl:value-of select="$m_noreplies"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Description: Display of the 'remove journal entry' link if appropriate
	 -->
	<xsl:template match="@THREADID" mode="r_removejournalpost">
		<xsl:apply-imports/>
	</xsl:template>



<!-- my conversation -->

	<!--
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest conversations the user
	has contributed to
	 -->
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
		<!-- default text if no entries have been made -->
		<xsl:apply-templates select="." mode="c_postlistempty"/>
		<!-- the list of recent entries -->
		<xsl:apply-templates select="POST-LIST" mode="c_postlist"/>
		<br/>
	</xsl:template>


	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
		
		<!-- 
		<xsl:if test="count(./POST[SITEID=$siteID])&lt;=1 and count(./POST[SITEID!=$siteID])&gt;=1">
			<div class="userprofile_listitems"><p><xsl:value-of select="$m_forumownerempty" /></p></div>
		</xsl:if> -->
	
		<!-- <xsl:copy-of select="$m_forumownerfull"/> intro text -->

		<xsl:apply-templates select="(POST[SITEID=$siteID][/H2G2/PAGE-OWNER/USER/USERID = FIRSTPOSTER/USER/USERID])[position() &lt; 11]" mode="c_userpage" />



		<!-- VIEW ALL ENTRIES -->
		<!-- <xsl:if test="count(./POST[SITEID=$siteID][/H2G2/PAGE-OWNER/USER/USERID = ./POST/FIRSTPOSTER/USER/USERID])&gt;=1"> -->
		<xsl:if test="count(./POST[SITEID=$siteID]) &gt; 10">

			<div class="mostrecentview"><strong>
				<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/><xsl:text> </xsl:text>
				<img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" />
			</strong></div>		
		
		</xsl:if> 
		
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
		
		<!-- <xsl:copy-of select="$m_forumviewerfull"/> -->
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries][SITEID=$siteID]" mode="c_userpage"/>
		<!-- all my conversations link -->
	

		<!-- <xsl:if test="count(./POST[SITEID=$siteID][/H2G2/PAGE-OWNER/USER/USERID = ./POST/FIRSTPOSTER/USER/USERID])&gt;=1"> -->
		<xsl:if test="count(./POST[SITEID=$siteID]) &gt; 10">
		

			<div class="mostrecentview"><strong>
				<p><xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/><xsl:text> </xsl:text>
				<img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" /></p>
			</strong></div>		
		
		</xsl:if>
		
	</xsl:template>

	

	<!--
	<xsl:template match="@THREADID" mode="t_userpagepostsubject">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/@THREADID
	Purpose:	 Calls the correct type of the SUBJECT link
	-->
	<xsl:template match="@THREADID" mode="t_userpagepostsubject">
		
			<a xsl:use-attribute-sets="maTHREADID_LinkOnSubjectAB">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="."/></xsl:attribute>
				<xsl:apply-templates select="../SUBJECT" mode="userpage"/>
			</a>

	</xsl:template>

	<!--
	<xsl:template match="SUBJECT" mode="userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/SUBJECT
	Purpose:	 Creates the SUBJECT link
	-->
	<xsl:template match="SUBJECT" mode="userpage">
		<xsl:choose>
			<xsl:when test=".=''">
				<xsl:value-of select="$m_nosubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
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
		<div class="userprofile_listitems">
			<p><xsl:copy-of select="$m_forumownerempty"/></p>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
		<div class="userprofile_listitems">
			<p><xsl:copy-of select="$m_forumviewerempty"/></p>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
	Description: Presentation of a single post in a list
	 -->
	
 <xsl:template match="POST-LIST/POST" mode="r_userpage"> 


		<!-- <xsl:value-of select="$m_fromsite"/> -->
		<!-- <xsl:apply-templates select="SITEID" mode="t_userpage"/>: -->


<!-- INDIVIDUAL ENTRIES -->


						<div class="goback">
        			       <!--  <a href="#"><xsl:value-of select="THREAD/FORUMTITLE" /></a>:  -->
							<p><xsl:value-of select="THREAD/FORUMTITLE" />: 
							<a>
								<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/></xsl:attribute>
								<xsl:value-of select="THREAD/SUBJECT" />
							<img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" /></a></p>
						</div>
						


						<div class="paddingbottom8px"></div>
						<div class="commentgreybox">
							<div class="commentmedia">
								<div class="commentdate">
								Added: <xsl:value-of select="concat(THREAD/DATEFIRSTPOSTED/DATE/@DAY, '/', THREAD/DATEFIRSTPOSTED/DATE/@MONTH, '/', THREAD/DATEFIRSTPOSTED/DATE/@YEAR)" />
								</div>
							</div>
						</div>

						<div class="paddingbottom15px"></div>


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
	<a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}" xsl:use-attribute-sets="npostunsubscribe1"><xsl:copy-of select="$m_removeme"/></a>
	</xsl:template>

	<!-- my portfolio -->
	<xsl:template match="RECENT-ENTRIES" mode="r_userpage">
		<!-- <xsl:apply-templates select="." mode="c_userpagelistempty"/> -->
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_userpagelist"/>
	</xsl:template>

	<xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
	
		<!-- list of reviews -->
		<!-- <xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries][not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9]" mode="c_userpagelist_a"/> -->
		<xsl:apply-templates select="ARTICLE" mode="c_userpagelist" />

		<!-- if no reviews -->
		<xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE !=''])"><div class="myspace-b"><xsl:copy-of select="$m_ownerreviewempty" /></div></xsl:if>

<!-- 		<xsl:apply-templates select="." mode="c_morearticles"/>
 -->
	</xsl:template>

	<!-- TODO:23 doesn't this duplicate the above template ? -->
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer doesn`t owns
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
		<!-- list of reviews -->
		<div class="myspace-j"><strong><xsl:value-of select="$m_memberormy"/> published reviews</strong></div>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries][not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9]" mode="c_userpagelist"/>

		<!-- if no reviews -->
		<xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9][not(EXTRAINFO/TYPE/@ID='3001')]!=''])"><div class="myspace-b"><xsl:copy-of select="$m_reviewempty" /></div></xsl:if>

		<!-- list of pages -->
		<div class="myspace-j"><strong><xsl:value-of select="$m_memberormy"/> other pages</strong></div>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries][EXTRAINFO/TYPE/@ID='2'][SITEID=9]" mode="c_userpagelist"/>
		
		<!-- if no pages -->
		<xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[EXTRAINFO/TYPE/@ID='2'][SITEID=9]!=''])"><div class="myspace-b"><xsl:copy-of select="$m_pageempty" /></div></xsl:if>
		
		<!-- all reviews link -->
		<xsl:apply-templates select="." mode="c_morearticles"/>

		<!--xsl:call-template name="insert-moreartslink"/-->
		<!-- <xsl:apply-templates select="." mode="c_morearticles"/> -->
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
			<div class="myspace-h">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:copy-of select="$arrow.right" />
		<xsl:apply-imports/>
			</xsl:element>
			</div>		
	</xsl:template>

	<!--
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer owns
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
		<div class="myspace-b"><xsl:copy-of select="$m_artownerempty"/></div>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer doesn`t own
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
	<!-- 	<div class="myspace-b"><xsl:copy-of select="$m_artviewerempty"/></div> -->
	</xsl:template>

	 
	 
	<!--
	<xsl:template match="ARTICLE" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the ARTICLE container
	-->
	<xsl:template match="ARTICLE" mode="c_userpagelist">
		<xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">

			<xsl:apply-templates select="." mode="r_userpagelist"/>

		</xsl:if>
	</xsl:template> 
	 

	 
	<xsl:template match="ARTICLE" mode="r_userpagelist">

		<xsl:if test="self::ARTICLE[position() &lt;=$postlimitentries][SITEID=$siteID]">
		
		<div class="goback">
			<p>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', H2G2-ID)" /></xsl:attribute>
					<xsl:value-of select="FORUMTITLE" />: <xsl:value-of select="SUBJECT" /><img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" />
				</a>
			</p>
		</div>
		<div class="userprofile_listitems">
			<p><xsl:value-of select="substring(EXTRAINFO/AUTODESCRIPTION,1,100)" />...</p>
		</div>

		<!-- <xsl:comment>start anchor and date</xsl:comment> -->
		<div class="paddingbottom8px"></div>
			<div class="anchordateblock">
			<!-- @cv@! need to build logic to select comic, book, film, etc -->
			<!-- @cv@! need to build href -->
			<p>Added: <xsl:value-of select="concat(DATE-CREATED/DATE/@DAY, '/', DATE-CREATED/DATE/@MONTH, '/', DATE-CREATED/DATE/@YEAR)" /></p>
		</div>
		<!-- <xsl:comment> end anchor and date </xsl:comment> -->

	</xsl:if>
	
	</xsl:template>
	<!-- <xsl:template match="TYPE" mode="t_test">
		<xsl:value-of select="@ID" />
	</xsl:template> -->
	<!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Description: Presentation of the 'uncancel this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
		(<xsl:apply-imports/>)
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="c_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Edit this article' link container
	-->
	<xsl:template match="H2G2-ID" mode="c_editarticle">
		<xsl:if test="($ownerisviewer = 1) and (../STATUS = 1 or ../STATUS = 3 or ../STATUS = 4) "><!-- and (../EDITOR/USER/USERID = $viewerid) -->
			<xsl:apply-templates select="." mode="r_editarticle"/>
		</xsl:if>
	</xsl:template>	
	<!--
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	Description: Presentation of the 'edit this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	<!-- edit article -->
	<!-- uses m_edit for image -->
		<a href="{$root}TypedArticle?aedit=new&amp;h2g2id={.}" xsl:use-attribute-sets="mH2G2-ID_r_editarticle">
			<xsl:copy-of select="$m_editme"/>
		</a>
	</xsl:template>





<!-- my editorial -->
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
	Description: Presentation of the Edited Articles Object
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
		<font size="2"><xsl:apply-templates select="." mode="c_approvalslistempty"/></font>
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_approvalslist"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
		<!--<xsl:copy-of select="$m_editviewerfull"/>-->
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Description: Presentation of the 'See more edited articles' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
			<div class="myspace-h">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:copy-of select="$arrow.right" />
					<xsl:apply-imports/>
			</xsl:element>
			</div>		
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
			<b><xsl:value-of select="$m_userdata"/></b>
			<br/>
			<xsl:value-of select="$m_researcher"/>
			<xsl:value-of select="USER/USERID"/>
			<br/>
			<xsl:value-of select="$m_namecolon"/>
			<xsl:choose>
								<xsl:when test="USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="USER/USERNAME" /></strong></em></span></xsl:when>
								<xsl:otherwise><xsl:value-of select="USER/USERNAME" /></xsl:otherwise>
								</xsl:choose>

			<br/>
			<xsl:apply-templates select="USER/USERID" mode="c_inspectuser"/>
			<xsl:apply-templates select="." mode="c_editmasthead"/>
			<xsl:apply-templates select="USER/USERID" mode="c_addtofriends"/>
			<xsl:apply-templates select="USER/GROUPS" mode="c_userpage"/>		
	</xsl:template>
	


		<xsl:template match="PAGE-OWNER" mode="c_usertitle">
		<div class="myspace-o">
		<table cellpadding="0" cellspacing="0" border="0"  width="600" class="myspace-a-a">
		<tr>
		<td>
			<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
				<strong><xsl:value-of select="USER/USERNAME" /></strong>
			</xsl:element>
		</td>
		<td align="right" class="myspace-a-a">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE">
				member since: <strong><xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE" mode="collective_long"/></strong>
			</xsl:if>
			</xsl:element>
		</td>
		</tr>
		</table>
		</div>
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
		
			<b>
				<xsl:value-of select="$m_friends"/>
			</b>
		
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
	<xsl:template match="USER" mode="r_watcheduser">test
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
								LINKS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="LINKS" mode="r_userpage">
		<xsl:apply-templates select="." mode="t_folderslink"/>
		<br/>
		<hr/>
	</xsl:template>
	

	<!-- POPUPCONVERSATIONS LINK -->
	<xsl:variable name="popupconvheight">340</xsl:variable>
	<xsl:variable name="popupconvwidth">277</xsl:variable>
	<xsl:template name="popupconversationslink">
		<xsl:param name="content" select="."/>
		<xsl:variable name="userid">
			<xsl:choose>
				<xsl:when test="@USERID">
					<xsl:value-of select="@USERID"/>
				</xsl:when>
				<xsl:when test="$registered=1">
					<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$userid > 0">
			<xsl:variable name="upto">
				<xsl:choose>
					<xsl:when test="@UPTO">
						<xsl:value-of select="@UPTO"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$curdate"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="target">
				<xsl:choose>
					<xsl:when test="@TARGET">
						<xsl:value-of select="@TARGET"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>conversation</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="width">
				<xsl:choose>
					<xsl:when test="$popupconvwidth">
						<xsl:value-of select="$popupconvwidth"/>
					</xsl:when>
					<xsl:when test="@WIDTH">
						<xsl:value-of select="@WIDTH"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>170</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="height">
				<xsl:choose>
					<xsl:when test="$popupconvheight">
						<xsl:value-of select="$popupconvheight"/>
					</xsl:when>
					<xsl:when test="@HEIGHT">
						<xsl:value-of select="@HEIGHT"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>400</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="poptarget">
				<xsl:choose>
					<xsl:when test="@POPTARGET">
						<xsl:value-of select="@POPTARGET"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>popupconv</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<a onClick="popupwindow('{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1','{$poptarget}','width={$width},height={$height},resizable=yes,scrollbars=yes');return false;" href="{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1" target="{$poptarget}">
				<xsl:copy-of select="$content"/>
			</a>
		</xsl:if>
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
						<!-- <xsl:value-of select="ARTICLE/SUBJECT"/> --> <xsl:choose>
								<xsl:when test="PAGE-OWNER/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="PAGE-OWNER/USER/USERNAME" /></strong></em></span></xsl:when>
								<xsl:otherwise><xsl:value-of select="PAGE-OWNER/USER/USERNAME" /></xsl:otherwise>
								</xsl:choose><!--  - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/> -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleowner"/>
								<xsl:choose>
								<xsl:when test="PAGE-OWNER/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="PAGE-OWNER/USER/USERNAME" /></strong></em></span></xsl:when>
								<xsl:otherwise><xsl:value-of select="PAGE-OWNER/USER/USERNAME" /></xsl:otherwise>
								</xsl:choose>.</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleviewer"/>
								<!-- <xsl:value-of select="PAGE-OWNER/USER/USERID"/>-->.</xsl:otherwise> 
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>