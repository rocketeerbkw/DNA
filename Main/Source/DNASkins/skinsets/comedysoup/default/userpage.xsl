<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userpage.xsl"/>
	
	<!--
	Use: sets the number of recent conversations and articles to display
		-->
	<xsl:variable name="limiteentries" select="1"/>
	<xsl:variable name="postlimitentries" select="5"/>
	<xsl:variable name="articlelimitentries" select="1"/>

		<xsl:variable name="privateforumid">
		<!-- What is it. Used when/for... -->
		<xsl:value-of select="/H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID"/>
	</xsl:variable>

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


		<xsl:apply-templates select="/H2G2" mode="c_displayuserpage"/>
		
		
	</xsl:template>
	
	
	<xsl:template match="H2G2" mode="r_displayuserpage">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<h1>
					<img src="{$imagesource}h1_yourpersonalspace.gif" alt="your personal space" width="241" height="26" />
					<xsl:call-template name="USERRSSICON_NONAME">
						<xsl:with-param name="feedtype">general</xsl:with-param>
						<xsl:with-param name="userid" select="/H2G2/PAGE-OWNER/USER/USERID"/>
					</xsl:call-template>
				</h1>
			</xsl:when>
			<xsl:otherwise>
				<h1>
					<img src="{$imagesource}h1_theirpersonalspace.gif" alt="their personal space" width="241" height="26" /><span class="clr"></span>
					<xsl:call-template name="USERRSSICON_NONAME">
						<xsl:with-param name="feedtype">general</xsl:with-param>
						<xsl:with-param name="userid" select="/H2G2/PAGE-OWNER/USER/USERID"/>
						<xsl:with-param name="firstnames" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES"/>
						<xsl:with-param name="lastname" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME"/>
					</xsl:call-template>
				</h1>
			</xsl:otherwise>
		</xsl:choose>
		
	
		<div class="profileHeader">
			<span class="user"><span><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" /><xsl:text> </xsl:text> <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" /></span>
				<xsl:if test="$ownerisviewer = 1">
					<xsl:text> </xsl:text>(<a href="{$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit my biog</a>)
				</xsl:if>
				<xsl:if test="$ownerisviewer=0 and $registered=1">				
					<xsl:text> </xsl:text>(<a href="Watch{$viewerid}?add=1&amp;adduser={PAGE-OWNER/USER/USERID}">add to my contact list</a>)		
				</xsl:if>
			</span>
			
			<span class="date">member since:<xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAYNAME" /> <xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" /></span>
			<div class="clr"></div>	
		</div>	
		
		
		<div class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
					<xsl:choose>
						<xsl:when test="$ownerisviewer = 1">
							<h2>My biography</h2>
						</xsl:when>
						<xsl:otherwise>
							<h2>Biography</h2>
						</xsl:otherwise>
					</xsl:choose>
				
					<p><xsl:apply-templates select="PAGE-OWNER" mode="t_userpageintro"/></p>
					
					
					<xsl:if test="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL[text()] or /H2G2/ARTICLE/GUIDE/BIOGLINKS2URL[text()] or /H2G2/ARTICLE/GUIDE/BIOGLINKS3URL[text()]">
					<h2>Web Links</h2>
					</xsl:if>
					<p>
					<!-- link 1 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/BIOGLINKS1TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS1URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					
					<!-- link 2 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/BIOGLINKS2TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS2URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					
					<!-- link 3 -->
					<xsl:if test="/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL[text()]">
						<a target="_new">
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="starts-with(/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL, 'http')">
										<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://</xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="/H2G2/ARTICLE/GUIDE/BIOGLINKS3TITLE[text()]">
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3TITLE" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3TITLE" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL" /></xsl:attribute>
									<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BIOGLINKS3URL" />
								</xsl:otherwise>
							</xsl:choose>
						</a><br />
					</xsl:if>
					</p>

					<xsl:if test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/PAGE-OWNER/USER/USERID">
						<h2>Your conversations</h2>
						<ul class="messagesList allMessages">
							<xsl:apply-templates select="/H2G2/RECENT-POSTS" mode="c_userpage"/>
						</ul>
					</xsl:if>
					
					<div class="odd">
						<h2>Messages left for <xsl:apply-templates select="/H2G2/PAGE-OWNER/USER/USERNAME" mode="t_multiposts_nolink"/>
							<xsl:if test="not(/H2G2/VIEWING-USER/USER/USERID=/H2G2/PAGE-OWNER/USER/USERID)">
								&nbsp;<span class="small">(<a><xsl:attribute name="href"><xsl:call-template name="sso_message_signin"/></xsl:attribute>leave a message</a>)</span>
							</xsl:if>
						</h2>
						<!--
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/PAGE-OWNER/USER/USERID">
								<h2>Messages left for you by other members</h2>
							</xsl:when>
							<xsl:otherwise>
								<h2>Messages left for this person by other members</h2>
							</xsl:otherwise>
						</xsl:choose>
						-->

						<ul class="messagesList allMessages">
							<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS" mode="t_threadspage_userpage"/>
						</ul>
					</div>
					
					<p><a href="/dna/comedysoup/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="_blank" onclick="popupwindow('/dna/comedysoup/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=620,height=480');return false;" xsl:use-attribute-sets="maHIDDEN_r_complainmp"><img src="{$imagesource}icon_complain_white.gif" alt="" width="16" height="16" /> &nbsp; Complain about this page</a></p>
					
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<div class="contentBlock">
						<!-- Arrow list component -->
						<ul class="arrowList">
							<xsl:variable name="userid" select="PAGE-OWNER/USER/USERID"/>
							<xsl:variable name="forumid" select="ARTICLE/ARTICLEINFO/FORUMID"/>
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<li class="arrow"><a href="UAMA{$userid}?s_display=submissionlog&amp;s_fid={$forumid}">Submission Log</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All your video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All your images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All your audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All your challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
									<li class="arrow"><a href="F{$forumid}">Messages</a></li>
								</xsl:when>
								<xsl:otherwise>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All their video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All their images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All their audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All their challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
									<li class="arrow"><a href="F{$forumid}">Messages</a><xsl:text> </xsl:text><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="c_leaveamessage"/></li>
								</xsl:otherwise>
							</xsl:choose>	
						</ul>
						<!--// Arrow list component -->
					</div>

				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
		
					

		<xsl:call-template name="insert-articleerror"/>
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
		no messages <!-- <xsl:apply-imports/> -->
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:value-of select="$m_peopletalking"/>
		</xsl:element>
		<br/>
		<table cellpadding="2" cellspacing="0" border="0" >
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
					<xsl:apply-templates select="." mode="c_userpage"/>
						
					</td>
					<td>
					<xsl:apply-templates select="following-sibling::THREAD[1]" mode="c_userpage"/>
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
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelinkup"/>
		<br />
		(<xsl:value-of select="$m_lastposting"/><xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/>)</xsl:element>
	</xsl:template>
	
	
	<!--
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	 leave me a message
	-->
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
		<span class="small">(<a><xsl:attribute name="href"><xsl:call-template name="sso_message_signin"/></xsl:attribute>leave a message</a>)</span>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object for the userpage
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_userpagerefs">
	<!-- 
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>References</b>
		</xsl:element>
		<br/>
	-->
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
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>
				<xsl:value-of select="$m_journalentries"/>
			</b>
		</xsl:element>
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
		<table  cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="head">
					<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
						<b>
							<xsl:value-of select="SUBJECT"/>
						</b>
						<br/>(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/>)
					</xsl:element>
				</td>
			</tr>
			<tr>
				<td class="body">
					<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
						<xsl:apply-templates select="TEXT" mode="t_journaltext"/>
						<br/>
						<xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
						<br/>
						<xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/>
						<br/>
						<xsl:apply-templates select="@THREADID" mode="c_removejournalpostup"/>
					</xsl:element>
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
		<xsl:apply-templates select="POST-LIST" mode="c_postlist"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries]" mode="c_userpage"/>
		<!--
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
		-->
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries]" mode="c_userpage"/>
		<!--
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
		-->
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
	<!--
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
	 -->
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
		<xsl:if test="SITEID=/H2G2/CURRENTSITE and THREAD/LASTUSERPOST">
			<li class="forumThreadUserpage">
				<div class="headerRow">
					<h3 class="standardHeader starIcon"><xsl:apply-templates select="THREAD/@THREADID" mode="t_userpagepostsubject"/><xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}">No Subject</a></xsl:if></h3>
					<div class="complain"></div>
					<div class="clr"></div>
				</div>
				<div class="detailsRow">
					<div class="author">Last post:</div>
					<div class="date"><xsl:apply-templates select="." mode="c_userpagepostdate"/><xsl:text> </xsl:text></div>
					<div class="clr"></div>
				</div>

				<!--
				<xsl:if test="$test_IsEditor">
					<div class="editbox">
						<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/>
						<xsl:apply-templates select="." mode="c_hidethread"/>
					</div>
				</xsl:if>
				-->
			</li>
		</xsl:if>
	</xsl:template>
	 
	<!--
	<xsl:template match="POST" mode="r_userpagepostdate">
	Description: Presentation of when the user posted date
	 -->
	<xsl:template match="POST" mode="r_userpagepostdate">
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
		

		<h3>Video:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='12'][SITEID=$site_number]" mode="c_userpagelist"/></div>
		
		<h3>Images:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='10'][SITEID=$site_number]" mode="c_userpagelist"/></div>

		<h3>Audio:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='11'][SITEID=$site_number]" mode="c_userpagelist"/></div>

		<br />
		<div><xsl:apply-templates select="." mode="c_morearticles"/></div>

	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer doesn`t owns
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
		<h3>Video:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='12'][SITEID=$site_number]" mode="c_userpagelist"/></div>
		
		<h3>Images:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='13'][SITEID=$site_number]" mode="c_userpagelist"/></div>

		<h3>Audio:</h3>
		<div><xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='11'][SITEID=$site_number]" mode="c_userpagelist"/></div>

		<br />
		<div><xsl:apply-templates select="." mode="c_morearticles"/></div>
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

	<div><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/> | time:<xsl:apply-templates select="DATE-CREATED/DATE" mode="t_userpagearticle"/></div>
		
		
		<!--<xsl:apply-templates select="H2G2-ID" mode="c_uncancelarticle"/>-->
		<!--<xsl:apply-templates select="STATUS" mode="t_userpagearticle"/>-->
		<!--<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>-->
		<!-- <xsl:value-of select="$m_fromsite"/> -->
		<!--<xsl:apply-templates select="SITEID" mode="t_userpage"/>:<br/>
		<xsl:apply-templates select="H2G2-ID" mode="t_userpage"/>
		<br/>-->
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
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>(<xsl:apply-imports/>)</b>
		</xsl:element>
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
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
	Description: Presentation of the Page Owner object
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>
				<xsl:value-of select="$m_userdata"/>
			</b>
		</xsl:element>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
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
		</xsl:element>
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
	
	

	<xsl:template match="PAGE-OWNER" mode="r_clip">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>Clippings</b>
		</xsl:element>
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
	<xsl:template match="GROUPS" mode="r_userpage">
	Description: Presentation of the GROUPS object
	 -->
	 
	<!--
	<xsl:template match="GROUPS" mode="r_userpage">
		<xsl:value-of select="$m_memberof"/>
		<br/>
		<xsl:apply-templates/>
		<br/>	
	</xsl:template>
-->
	
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
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<b>
				<xsl:value-of select="$m_friends"/>
			</b>
		</xsl:element>
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
	<!--
	<xsl:template match="PRIVATEFORUM" mode="r_userpage">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_privatemessages"/>
		</xsl:element>
		<br/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="." mode="t_intromessage"/>
		<br/>
		<br/>
		<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="c_privateforum"/>
		</xsl:element>
	</xsl:template>
	 -->
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
	<!--
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<strong>
				<xsl:copy-of select="$m_actionlistheader"/>
			</strong>
		</xsl:element>
		<br/>
		<xsl:apply-templates select="." mode="c_yourrequests"/>
		<xsl:apply-templates select="." mode="c_invitations"/>
		<xsl:apply-templates select="." mode="c_previousactions"/>
		<br/>
		<hr/>
	-->
		
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


	
	
</xsl:stylesheet>
