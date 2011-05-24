<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlepage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ARTICLE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">ARTICLE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">articlepage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		
		<xsl:apply-templates select="ARTICLE" mode="c_articlepage"/>
		
		<xsl:if test="$test_IsEditor">
            <div class="editbox" style="margin-top:10px;">
                <xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_skiptomod"/>
                <xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
                <xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/MODERATIONSTATUS" mode="c_articlepage"/>
            </div>
		</xsl:if>
		
	</xsl:template>
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_articleclipped">
	Description: message to be displayed after clipping an article
	 -->
	<xsl:template match="CLIP" mode="r_articleclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	Description: message to be displayed if the viewer is not registered
	 -->
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
		<xsl:copy-of select="$m_unregisteredslug"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
	Description: Presentation of link that skips to the moderation section
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
	Description: Presentation of the article moderation form
	Visible to: Moderators
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
		<table bgColor="lightblue" cellspacing="2" cellpadding="2" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-imports/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="add_tag">
	Use: Presentation for the link to add an article to the taxonomy
	 -->
	<xsl:template match="ARTICLE" mode="add_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="edit_tag">
	Use: Presentation for the link to edit the taxonomy nodes
	 -->
	<xsl:template match="ARTICLE" mode="edit_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLE" mode="r_articlepage">
		
		<xsl:choose>
			
			<xsl:when test="ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP/@NAME='Restricted'">
				<div class="bodytext">
					<p>This user has been banned for repeatedly breaking <a href="{$root}houserules">house rules</a></p>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype = 'user_article'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'match_report'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'event_report'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'player_profile'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'team_profile'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'staff_article'">
				<xsl:call-template name="ARTICLE" />
				<!-- <xsl:call-template name="STAFF_ARTICLE" /> -->
			</xsl:when>
			<xsl:when test="$current_article_type = 3001"><!-- personal space - used when being moderated -->
				<xsl:call-template name="USERPAGE_MAINBODY" />
			</xsl:when>
			<xsl:when test="$current_article_type = 4"><!-- popup -->
				<xsl:call-template name="POPUP_ARTICLE" />
			</xsl:when>
			<xsl:otherwise>				
				<!--<xsl:call-template name="EDITORIAL_ARTICLE" />-->
        <xsl:call-template name="ARTICLE" />
			</xsl:otherwise>
		</xsl:choose>
		 
		<!--
		<xsl:if test="/H2G2/PHRASES">
		<h2>Phrases/Tags</h2>
		<ul>
			<xsl:for-each select="/H2G2/PHRASES/PHRASE">
			<li><xsl:value-of select="/H2G2/PHRASES/PHRASE/NAME"/></li>
			</xsl:for-each>
		</ul>
		</xsl:if>
		-->
		
		<!--
		Tag this article to the taxonomy
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="add_tag"/>
		-->
		
		<!--
		Edit the tagging of this article
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="edit_tag"/>
		-->
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Description: Presentation of the 'subscribe to this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Description: Presentation of the 'unsubscribe from this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="INTRO" mode="r_articlepage">
	Description: Presentation of article INTRO (not sure where this exists)
	 -->
	<xsl:template match="INTRO" mode="r_articlepage">
		<font xsl:use-attribute-sets="mainfont">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
	Description: Presentation of the footnote object 
	 -->
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
	Description: Presentation of the numeral within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
		<font size="1">
			<sup>
				<xsl:apply-imports/>
			</sup>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Description: Presentation of the text within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="FOOTNOTE">
		<font size="1">
			<sup>
				<xsl:apply-imports/>
			</sup>
		</font>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_article">
		<b>
			<font size="3">
				Discussion
			</font>
		</b>
		<br/>
		<xsl:apply-templates select="FORUMTHREADS" mode="c_article"/>
		<xsl:apply-templates select="." mode="c_viewallthreads"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_article">
		<xsl:value-of select="$m_peopletalking"/>
		<br/>
		<br/>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
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
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_article">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		<br/>
		<font size="1">(<xsl:value-of select="$m_lastposting"/>
			<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>)</font>
		<br/>
		<br/>
	</xsl:template>
	
	
	<xsl:template match="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS">
	<div class="headbox" id="commentheadbox">
		<h3>Latest <xsl:if test="@TOTALPOSTCOUNT &gt; 10"> 10</xsl:if> comments </h3>
		
		
		<xsl:choose>
			<xsl:when test="@TOTALPOSTCOUNT &gt; 10">
				<p class="links"><a href="{$root}F{@FORUMID}?thread={POST/@THREAD}&amp;show={$multiposts_posts_per_page}">view all <xsl:value-of select="@TOTALPOSTCOUNT"/> comments</a></p>
			</xsl:when>
			<xsl:otherwise>
				<p class="links">&nbsp;</p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
    <div class="subtext">Read members' comments or add your own</div>
      <!-- Stop comments if they exist, editor or superuser, user is author of article and site option set.-->
    <xsl:variable name="SiteOption_AuthorCanClose" select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='ArticleAuthorCanCloseThreads' and SITEID=/H2G2/CURRENTSITE]/VALUE" />
    <xsl:variable name="test_AuthorCanClose" select="$SiteOption_AuthorCanClose &gt; 0 and /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID = /H2G2/VIEWING-USER/USER/USERID" />
    <xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@DEFAULTCANWRITE=1 and /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMPOSTCOUNT &gt; 0 and ($test_IsEditor or $test_AuthorCanClose)">
		<div class="editbox">
			<a href="{$root}F{@FORUMID}?thread={POST/@THREAD}&amp;cmd=closethread">close these comments</a> 
		</div>
	</xsl:if>
	
	<!-- comments -->
	<xsl:apply-templates select="POST" mode="r_multiposts">
		<xsl:sort select="@INDEX" order="descending"/>
	</xsl:apply-templates>
	
					
	<!-- view all comments -->
	<xsl:if test="@TOTALPOSTCOUNT &gt; 10">
		<div class="arrowlink">
			<strong><a href="{$root}F{@FORUMID}?thread={POST/@THREAD}&amp;show={$multiposts_posts_per_page}">view all <xsl:value-of select="@TOTALPOSTCOUNT"/> comments</a></strong> | <a href="#top">back to the top</a>
		</div>
	</xsl:if>

    <!-- Logic for handling thread auto closure messages. -->
    <xsl:variable name="closeafter" select="20"/>
    <xsl:variable name="test_AuthorIsEditor" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']"/>
    <xsl:variable name="postlimit" select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='PostLimit' and SITEID=/H2G2/CURRENTSITE]/VALUE"/>
    <xsl:choose>
      <xsl:when test="@DEFAULTCANWRITE='1'">
          <xsl:if test="not($test_AuthorIsEditor) and $postlimit &gt; 0 and $postlimit - @TOTALPOSTCOUNT  &gt; 0 and $postlimit - @TOTALPOSTCOUNT &lt; $closeafter ">
            <div class="subtext">
              This article will close for comments after <xsl:value-of select="$postlimit - @TOTALPOSTCOUNT"/> more comments.
            </div>
          </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test = "not($test_AuthorIsEditor) and $postlimit &gt; 0 and (@TOTALPOSTCOUNT &gt; $postlimit or @TOTALPOSTCOUNT = $postlimit) ">
            <div class="subtext">This article has now been closed to comments. Please visit another 606 thread or start a new one to continue the debate elsewhere.</div>
          </xsl:when>
          <xsl:otherwise>
            <div class="subtext">This article has now been closed to comments. Please visit another 606 thread or start a new one to continue the debate elsewhere.</div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
		<font size="3">
			<b>
				<xsl:copy-of select="$m_entrydata"/>
			</b>
		</font>
		<br/>
		<xsl:copy-of select="$m_idcolon"/> A<xsl:value-of select="H2G2ID"/>
		<br/>
		<xsl:apply-templates select="STATUS/@TYPE" mode="c_articlestatus"/>
		<xsl:apply-templates select="PAGEAUTHOR" mode="c_article"/>
		<xsl:copy-of select="$m_datecolon"/>
		<xsl:apply-templates select="DATECREATED/DATE" mode="short1"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_editbutton"/>
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_clip"/>
		<xsl:apply-templates select="RELATEDMEMBERS" mode="c_relatedmembersAP"/>
		<!--Editorial Tools-->
		<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="c_returntoeditors"/>
		<xsl:apply-templates select="H2G2ID" mode="c_categoriselink"/>
		<xsl:apply-templates select="H2G2ID" mode="c_recommendentry"/>
		<!-- End of Editorial Tools-->
		<xsl:apply-templates select="SUBMITTABLE" mode="c_submit-to-peer-review"/>
		<xsl:apply-templates select="REFERENCES" mode="c_articlerefs"/>
		<xsl:apply-templates select="H2G2ID" mode="c_removeself"/>
		<br/>
		<br/>
		<font size="1">
			<xsl:copy-of select="$m_complainttext"/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:copy-of select="$m_status"/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
		<font size="3">
			<b>Return to editors</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<font size="3">
			<b>Categorise</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name from the authors' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
		<font size="3">
			<b>Remove self from list</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_recommendentry">
	Use: presentation of the 'recommend article' link
	-->
	<xsl:template match="H2G2ID" mode="r_recommendentry">
		<font size="3">
			<b>Recommend</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
	Use: presentation of position in the peer review process
	-->
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
		<font size="3">
			<b>Review Status</b>
			<br/>
		</font>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Use: presentation for the 'edit article' of edit link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
		<font size="3">
			<b>Edit</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLE" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="ARTICLE" mode="r_clip">
		<font size="3">
			<b>Clippings</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Use: presentation of all related articles container
	-->
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
		<xsl:apply-templates select="RELATEDCLUBS" mode="c_relatedclubsAP"/>
		<xsl:apply-templates select="RELATEDARTICLES" mode="c_relatedarticlesAP"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
	Use: presentation of the list of related articles container
	-->
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
		<font size="3">
			<b>Related Articles</b>
		</font>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_relatedarticlesAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
	Use: presentation of the list of related clubs container
	-->
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
		<font size="3">
			<b>Related Clubs</b>
		</font>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_relatedclubsAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
	Use: presentation of a single related club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_articlerefs">
		<font size="3">
			<b>References</b>
		</font>
		<br/>
		<xsl:apply-templates select="ENTRIES" mode="c_articlerefs"/>
		<xsl:apply-templates select="USERS" mode="c_articlerefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_bbcrefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_nonbbcrefs"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRIES" mode="r_articlerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refentries"/>
		</b>
		<br/>
		<xsl:apply-templates select="ENTRYLINK" mode="c_articlerefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
	Use: presentation of each individual entry link
	-->
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refresearchers"/>
		</b>
		<br/>
		<xsl:apply-templates select="USERLINK" mode="c_articlerefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USERLINK" mode="r_articlerefs">
	Use: presentation of each individual link to a user in the references section
	-->
	<xsl:template match="USERLINK" mode="r_articlerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
	Use: Presentation of the container listing all bbc references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
		<b>
			<xsl:value-of select="$m_otherbbcsites"/>
		</b>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_bbcrefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
	Use: Presentation of the container listing all external references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
		<b>
			<xsl:value-of select="$m_refsites"/>
		</b>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_nonbbcrefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsext">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_nonbbcrefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							PAGEAUTHOR Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="PAGEAUTHOR" mode="r_article">
		<xsl:apply-templates select="RESEARCHERS" mode="c_article"/>
		<xsl:apply-templates select="EDITOR" mode="c_article"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RESEARCHERS" mode="r_article">
	Use: presentation of the researchers for an article, if they exist
	-->
	<xsl:template match="RESEARCHERS" mode="r_article">
		<xsl:value-of select="$m_researchers"/>
		<xsl:apply-templates select="USER" mode="c_researcherlist"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
	<xsl:template match="EDITOR" mode="r_article">
		<xsl:value-of select="$m_editor"/>
		<xsl:apply-templates select="USER" mode="c_articleeditor"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="CRUMBTRAILS" mode="r_article">
	Use: Presentation of the crumbtrails section
	-->
	<xsl:template match="CRUMBTRAILS" mode="r_article">
		<xsl:apply-templates select="CRUMBTRAIL" mode="c_article"/>
	</xsl:template>
	<!-- 
	<xsl:template match="CRUMBTRAIL" mode="r_article">
	Use: Presentation of an individual crumbtrail
	-->
	<xsl:template match="CRUMBTRAIL" mode="r_article">
		<xsl:apply-templates select="ANCESTOR" mode="c_article"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ANCESTOR" mode="r_article">
	Use: Presentation of an individual link in a crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="r_article">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> / </xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							SUBJECT Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template match="SUBJECT">
		<h4 class="topsech">
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE' and $article_subtype='match_report'">
					<!-- when previewing page in typed articles can't use SUBJECT yet (as SUBJECT has not yet been constructed) - so need to work out what SUBJECT will be from teams and scores -->
					<xsl:value-of select="$hometeam"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/GUIDE/HOMETEAMSCORE/text()" /> - <xsl:value-of select="/H2G2/ARTICLE/GUIDE/AWAYTEAMSCORE/text()" /><xsl:text> </xsl:text><xsl:value-of select="$awayteam"/>
				</xsl:when>
				<xsl:when test="$article_subtype='team_profile'">
					<xsl:value-of select="$team"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./text()" />
				</xsl:otherwise>
			</xsl:choose>
		</h4>
	</xsl:template>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							GUIDE Objects
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<xsl:template match="GUIDE/MANAGERSPICK">
	<xsl:choose>
		<xsl:when test="text()">
			<p class="pick"><img src="{$imagesource}managerpick/{$sport_converted}.gif" width="19" height="19" alt=""  />Managers' pick</p>
		</xsl:when>
		<xsl:otherwise>
			<p class="pick"><img src="/f/t.gif" width="19" height="19" alt="" />&nbsp;</p>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/ARTICLELINK/text()">
		<div class="rellinks">
			<h3>MY RELATED LINKS</h3>
			<ul class="arrow">
				<li><a>
						<xsl:attribute name="href">
							<xsl:if test="not(starts-with(., 'http'))">
								<xsl:text>http://</xsl:text>
							</xsl:if>
							<xsl:value-of select="." />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="../../ARTICLELINKTITLE/text()">
								<xsl:value-of select="../../ARTICLELINKTITLE/text()" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="." mode="long_link"/>
							</xsl:otherwise>
						</xsl:choose>
					</a></li>
			</ul>
		   <p class="disclaimer">
		   The BBC is not responsible for the content of external internet sites
		   </p>
		   
		   <xsl:if test="/H2G2/@TYPE='ARTICLE' and $article_subtype!='staff_article'">
			   <ul class="arrow">
					<li><a href="/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?s_start=1&amp;h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" target="ComplaintPopup" onclick="popupwindow('{$root}UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=588,height=560')">complain about this link</a></li>
				</ul>
		   </xsl:if>
		  </div>
		
	</xsl:template>
	
	
	
	
	
	<!--
	===================================================================== 
	SPORT 
	scenarios:
		want to display 13 sports + 1 other = mainsports
		want to display 33 sports + 1 other = includeothersports
		want to display all sport			= includeothersportsusers
	===================================================================== 
	-->
	
	<xsl:template match="GUIDE/SPORT" mode="mainsports">
		<xsl:choose>
			<xsl:when test="text() and not(text()='Othersport')">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				Other Sport
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/SPORT" mode="includeothersports">
		<xsl:choose>
			<xsl:when test="text() and not(text()='Othersport')">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:when test="../OTHERSPORT/text()='Othersportusers'">
				Other Sport
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="../OTHERSPORT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/SPORT" mode="includeothersportsusers">
		<xsl:choose>
			<!-- is it one of the 13 sports? -->
			<xsl:when test="text() and not(text()='Othersport')">
				<xsl:value-of select="." />
			</xsl:when>
			<!-- is it one of the 33 sports -->
			<xsl:when test="../OTHERSPORT/text()">
				<xsl:choose>
					<!-- no -->
					<xsl:when test="../OTHERSPORT/text()='Othersportusers'">
						<xsl:apply-templates select="../OTHERSPORTUSERS"/>
					</xsl:when>
					<!-- yes -->
					<xsl:otherwise>
						<xsl:apply-templates select="../OTHERSPORT"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- must be something else -->
			<xsl:otherwise>
				<xsl:apply-templates select="../OTHERSPORTUSERS"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/SPORT" mode="crumblink">
		<xsl:choose>
			<!-- is it one of the 13 sports? -->
			<xsl:when test="text() and not(text()='Othersport')">
				<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={.}"><xsl:value-of select="." /></a>
			</xsl:when>
			<!-- is it one of the 33 sports -->
			<xsl:when test="../OTHERSPORT/text()">
				<xsl:choose>
					<!-- no -->
					<xsl:when test="../OTHERSPORT/text()='Othersportusers'">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$root" />
								<xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
								<xsl:apply-templates select="../OTHERSPORTUSERS">
									<xsl:with-param name="forHref">yes</xsl:with-param>
								</xsl:apply-templates>
							</xsl:attribute>
							<xsl:apply-templates select="../OTHERSPORTUSERS"/>
						</a>
					</xsl:when>
					<!-- yes -->
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$root" />
								<xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
								<xsl:apply-templates select="../OTHERSPORT">
									<xsl:with-param name="forHref">yes</xsl:with-param>
								</xsl:apply-templates>
							</xsl:attribute>
							<xsl:apply-templates select="../OTHERSPORT"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- must be something else -->
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$root" />
						<xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
						<xsl:apply-templates select="../OTHERSPORTUSERS">
							<xsl:with-param name="forHref">yes</xsl:with-param>
						</xsl:apply-templates>
					</xsl:attribute>
					<xsl:apply-templates select="../OTHERSPORTUSERS"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="GUIDE/OTHERSPORT">
		<xsl:param name="forHref">no</xsl:param>

		<xsl:choose>
			<xsl:when test="text()">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:when test="$forHref = 'yes'">
				<xsl:text>OtherSport</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Other Sport</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/OTHERSPORTUSERS">
		<xsl:param name="forHref">no</xsl:param>

		<xsl:choose>
			<xsl:when test="text()">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:when test="$forHref = 'yes'">
				<xsl:text>OtherSport</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Other Sport</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
	===================================================================== 
	/ END SPORT
	===================================================================== 
	-->
	
	<!-- article (type=10 and 15) -->
	<xsl:template match="GUIDE/COMPETITION/text()" mode="topsec">
		<xsl:choose>
			<xsl:when test="not(.='Othercompetition')">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/COMPETITION/text()" mode="crumblink">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="not(.='Othercompetition')">
                <xsl:variable name="href">
                    <xsl:value-of select="$root" />
                    <xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
                    <xsl:value-of select="translate(., ' ', '+')" />
                    <xsl:choose>
                        <xsl:when test="../../SPORT='Othersport'">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../OTHERSPORT"/>
                        </xsl:when>
                        <xsl:when test="../../SPORT">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../SPORT"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
					<xsl:value-of select="." />
				</a>
			</xsl:when>
			<xsl:otherwise>
                <xsl:variable name="href">
                    <xsl:value-of select="$root" />
                    <xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
                    <xsl:value-of select="translate(../following-sibling::OTHERCOMPETITION/text(), ' ', '+')" />
                    <xsl:choose>
                        <xsl:when test="../../SPORT='Othersport'">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../OTHERSPORT"/>
                        </xsl:when>
                        <xsl:when test="../../SPORT">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../SPORT"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
					<xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template match="GUIDE/TEAM/text()" mode="topsec">
		<!-- only add a pipe if there is a competition -->
		<xsl:if test="../preceding-sibling::COMPETITION/text() or ../preceding-sibling::OTHERCOMPETITION/text()">
		<xsl:text> </xsl:text>
		</xsl:if>
		
		<!-- display team or otherteam -->
		<xsl:choose>
			<xsl:when test="not(.='Otherteam')">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../preceding-sibling::OTHERTEAM/text()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="GUIDE/OTHERCOMPETITION/text()" mode="matchreport_disabilitysport">
		<xsl:if test="$article_subtype ='match_report' and  $sport='Disability sport'">
		<dt>Competition:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
		</dd>
		</xsl:if>
	</xsl:template>
		
	<!-- used for auto tagging of competitions and names -->
	<xsl:template match="GUIDE/TEAM/text()" mode="variablevalue">
		<xsl:choose>
			<xsl:when test="not(.='Otherteam')">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../preceding-sibling::OTHERTEAM/text()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

   <!-- Handles embedded images within the Article -->
  <xsl:template match="GUIDE/BODY/IMG">
    <!-- Only allow editors to embed images-->
    <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP/@NAME='Editor'">
      <xsl:if test="@SRC and @SRC != ''">
        <IMG SRC="{@SRC}" WIDTH="{@WIDTH}" HEIGHT="{@HEIGHT}" ALT="{@ALT}"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Handles an IMAGE article attribute.-->
  <xsl:template match="GUIDE/IMAGE">
    <xsl:if test="IMG/@SRC and IMG/@SRC != ''">
      <IMG SRC="{IMG/@SRC}" WIDTH="{IMG/@WIDTH}" HEIGHT="{IMG/@HEIGHT}" ALT="{IMG/@ALT}"/>
    </xsl:if>
  </xsl:template>
  
	<xsl:template match="GUIDE/EMPURL">
    <xsl:if test=". and . != ''">
        <div id="emp" class="player" style="margin-top:10px;">
          <p>
            In order to see this content you need to have both <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml" title="BBC Webwise article about enabling javascript">Javascript</a> enabled and <a href="http://www.bbc.co.uk/webwise/askbruce/articles/download/howdoidownloadflashplayer_1.shtml" title="BBC Webwise article about downloading">Flash</a> installed. Visit <a href="http://www.bbc.co.uk/webwise/" >BBC Webwise</a> for full instructions. If you're reading via RSS, you'll need to visit the blog to access this content.
          </p>
        </div>
        <script type="text/javascript" src="http://www.bbc.co.uk/emp/swfobject.js"></script>
        <script type="text/javascript" src="http://www.bbc.co.uk/emp/embed.js"></script>
        <script type="text/javascript">
          var emp = new bbc.Emp();
          emp.setWidth("400");
          emp.setHeight("300");
          emp.setDomId("emp");
          emp.setPlaylist("<xsl:value-of select="."/>");
          emp.write();
        </script>
    </xsl:if>
    </xsl:template>

  <xsl:template match="GUIDE/YOUTUBEURL">
    <!-- embed the player -->
    <xsl:if test=". and . != ''">
      <div style="margin-top:10px;">
        <div id="ytapiplayer">
          <p>
            In order to see this content you need to have both <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml" title="BBC Webwise article about enabling javascript">Javascript</a> enabled and <a href="http://www.bbc.co.uk/webwise/askbruce/articles/download/howdoidownloadflashplayer_1.shtml" title="BBC Webwise article about downloading">Flash</a> installed. Visit <a href="http://www.bbc.co.uk/webwise/" >BBC Webwise</a> for full instructions. If you're reading via RSS, you'll need to visit the blog to access this content.
          </p>
        </div>
        <script src="http://swfobject.googlecode.com/svn/tags/rc3/swfobject/src/swfobject.js" type="text/javascript"></script>
        <script type="text/javascript">
        // allowScriptAccess must be set to allow the Javascript from one
        // domain to access the swf on the youtube domain
        var params = { allowScriptAccess: "always", bgcolor: "#cccccc" };
        // this sets the id of the object or embed tag to 'myytplayer'.
        // You then use this id to access the swf and make calls to the player's API
        var atts = { id: "myytplayer" };
        swfobject.embedSWF("<xsl:value-of select="."/>&amp;border=0&amp;enablejsapi=1&amp;playerapiid=ytplayer",
        "ytapiplayer", "400", "300", "8", null, null, params, atts);
        </script>
      </div>
    </xsl:if>
  </xsl:template>
	
	

	<!-- match report article (type=11) -->
	<xsl:template match="GUIDE/DATEDAY/text()">
		<dt>Date:</dt>
		<dd><a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." /><xsl:text> </xsl:text><xsl:value-of select="../../DATEMONTH/text()" /><xsl:text> </xsl:text><xsl:value-of select="../../DATEYEAR/text()" />
				</xsl:attribute>
				<xsl:value-of select="." /><xsl:text> </xsl:text><xsl:value-of select="../../DATEMONTH/text()" /><xsl:text> </xsl:text><xsl:value-of select="../../DATEYEAR/text()" />
			</a>
		</dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/VENUE/text()">
		<dt>Venue:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
		</dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/ATTENDANCE/text()">
		<dt>Attendance:</dt>
		<dd><xsl:value-of select="." /></dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/PLAYEROFTHEMATCH/text()">
		<dt>Player of the match:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
		</dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/TEAMLIST">
		<xsl:if test="./text()">
			<div class="bodytext">
				<p><strong>Team list</strong><br />
				<xsl:apply-templates select="." mode="text"/></p>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- retain line breaks -->
	<xsl:template match="GUIDE/TEAMLIST" mode="text">
	<xsl:apply-templates/>
	</xsl:template>
	
	
	<!-- event report article (type=12) -->
	<xsl:template match="GUIDE/COMPETITOR1/text()">
		<dt>Competitors:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/COMPETITOR2/text()"/></dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/COMPETITOR2/text()">
		<xsl:text> v </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
			</xsl:attribute>
			<xsl:value-of select="." />
		</a>
	</xsl:template>
	
	<xsl:template match="GUIDE/STAROFTHESHOW/text()">
		<dt>Star of the show:</dt>
		<dd>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
		</dd>
	</xsl:template>
	
	
	<xsl:template match="GUIDE/COMPETITION/text()" mode="matchstats">
		<dt>Competition:</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="not(.='Othercompetition')">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
						</xsl:attribute>
						<xsl:value-of select="." />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
						</xsl:attribute>
						<xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>
	
	
	
	
	
	<!-- player profile (type=13) -->
	<xsl:template match="GUIDE/PLAYERDOB/text()">
		<dt>Date of birth:</dt>
		<dd><xsl:value-of select="." /></dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/CURRENTTEAM/text()">
		<dt>Current team:</dt>
		<dd><xsl:value-of select="." /></dd>
	</xsl:template>
	
	<!-- team profile (type=14) -->
	<xsl:template match="GUIDE/HOMEVENUE/text()">
		<dt>Home venue:</dt>
		<dd><xsl:value-of select="." /></dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/MANAGERCOACH/text()">
		<dt>Manager/coach:</dt>
		<dd><xsl:value-of select="." /></dd>
	</xsl:template>
	
	<xsl:template match="GUIDE/HONOURS">
	<xsl:if test="text()">
		<div class="bodytext">
			<p><strong>Honours</strong><br />
			<xsl:apply-templates select="." mode="text"/></p>
		</div>
	</xsl:if>
	</xsl:template>
	
	<!-- retain line breaks -->
	<xsl:template match="GUIDE/HONOURS" mode="text">
	<xsl:apply-templates/>
	</xsl:template>
	
	
	
	<!-- userpage (type=3001) -->
	<xsl:template match="GUIDE/FAVOURITEPLAYER/text()">
		<dt>Favourite player:</dt>
		<dd><xsl:value-of select="." /><div class="clear"></div></dd>
	</xsl:template>
	
	
	<xsl:template match="GUIDE/TEAMPLAYEDIN/text()">
		<dt>Team played in:</dt>
		<dd><xsl:value-of select="." /><div class="clear"></div></dd>
	</xsl:template>
	
	
	
	<xsl:template match="GUIDE/FAVOURITEMATCH/text()">
		<dt>Favourite match:</dt>
		<dd><xsl:value-of select="." /><div class="clear"></div></dd>
	</xsl:template>
	
	
	<xsl:template match="GUIDE/TEAMPLAYEDINLINK/text()">
		<li><a>
				<xsl:attribute name="href">
					<xsl:if test="not(starts-with(., 'http'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="../../TEAMPLAYEDIN" />
			</a></li>
	</xsl:template>
	
	<xsl:template match="GUIDE/FAVOURITEMATCHLINK/text()">
		<li><a>
				<xsl:attribute name="href">
					<xsl:if test="not(starts-with(., 'http'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="../../FAVOURITEMATCH" />
			</a></li>
	</xsl:template>
	
	
	<xsl:template match="GUIDE/EXTERNALLINK1/text()">
		<li><a>
				<xsl:attribute name="href">
					<xsl:if test="not(starts-with(., 'http'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="../../EXTERNALLINK1TITLE/text()">
						<xsl:value-of select="../../EXTERNALLINK1TITLE/text()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="long_link" />
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="text()" mode="long_link">
		<xsl:attribute name="title"><xsl:value-of select="." /></xsl:attribute>
		<xsl:value-of select="substring(.,1,32)" />
	</xsl:template>
	
	<xsl:template match="GUIDE/EXTERNALLINK2/text()">
		<li><a>
				<xsl:attribute name="href">
					<xsl:if test="not(starts-with(., 'http'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="../../EXTERNALLINK2TITLE/text()">
						<xsl:value-of select="../../EXTERNALLINK2TITLE/text()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="long_link" />
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template match="GUIDE/EXTERNALLINK3/text()">
		<li><a>
				<xsl:attribute name="href">
					<xsl:if test="not(starts-with(., 'http'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="../../EXTERNALLINK3TITLE/text()">
						<xsl:value-of select="../../EXTERNALLINK3TITLE/text()" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="long_link" />
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</li>
	</xsl:template>
	
	
	<!-- // end userpage -->
	
	
	<!-- editorial page (type=1) -->
	
	<xsl:template match="GUIDE/INTROTEXT">
		<h4 class="instructhead"><xsl:value-of select="./text()" /></h4>
	</xsl:template>
	
	<!-- // end editorial page  -->

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POLLING Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POLL-LIST" mode="r_articlepage">
	Use: Presentation of one or more Polls
	-->
	<xsl:template match="POLL-LIST" mode="r_articlepage">
		<xsl:apply-templates select="POLL[1]" mode="c_articlepage"/>
		
		<xsl:apply-templates select="POLL[1]" mode="c_hide"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POLL" mode="results_articlepage">
	Use: Template invoked when a user has already voted
	-->
	<xsl:template match="POLL" mode="results_articlepage">
		<div class="ratebox">
			<h3>RATE THIS ARTICLE</h3>
			
			<div class="ratem">
			
				<xsl:call-template name="RATE_BARS" />
			
				<xsl:apply-templates select="USER-VOTE" mode="c_display"/>
				<xsl:apply-templates select="USER-VOTE" mode="c_changevote"/>
			
			</div>
		 </div>
		
	</xsl:template>
	<!-- 
	<xsl:template match="POLL" mode="results_articlepage">
	Use: Template invoked when a user is not signed in
	-->
	<xsl:template match="POLL" mode="signedout_articlepage">
		<div class="ratebox">
			<h3>RATE THIS ARTICLE</h3>
			
			<div class="ratem">
			
				<xsl:call-template name="RATE_BARS" />
			
				<!-- <div class="arrowlink">
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="not(/H2G2/VIEWING-USER/IDENTITY)">
										<xsl:value-of select="concat($idURL, 'users/login?target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, $referrer, '%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($idURL, 'users/dash/more?target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, $referrer, '%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<strong>Sign in if you want to vote</strong></a>
				</div> -->
			
			</div>
		 </div>
				
	</xsl:template>
	
	<xsl:template name="RATE_BARS">
		<h4>Rate Breakdown</h4>
		<ul>
				<li>
					<div class="fl">5 <xsl:choose><xsl:when test="$option5percent &gt; 0"><img src="{$imagesource}bar.gif" width="{round($option5percent)}" height="6" alt="{$option5percent}%" border="0" vspace="0" hspace="5" /></xsl:when><xsl:otherwise><img src="/f/t.gif" width="100" height="6"/></xsl:otherwise></xsl:choose></div><div class="flr"><xsl:value-of select="$poll_count5"/> votes</div>
					<div class="clear"></div>
				</li>
				<li>
					<div class="fl">4 <xsl:choose><xsl:when test="$option4percent &gt; 0"><img src="{$imagesource}bar.gif" width="{round($option4percent)}" height="6" alt="{$option4percent}%" border="0" vspace="0" hspace="5" /></xsl:when><xsl:otherwise><img src="/f/t.gif" width="100" height="6"/></xsl:otherwise></xsl:choose></div><div class="flr"><xsl:value-of select="$poll_count4"/> votes</div>
					<div class="clear"></div>
				</li>
				<li>
					<div class="fl">3 <xsl:choose><xsl:when test="$option3percent &gt; 0"><img src="{$imagesource}bar.gif" width="{round($option3percent)}" height="6" alt="{$option3percent}%" border="0" vspace="0" hspace="5" /></xsl:when><xsl:otherwise><img src="/f/t.gif" width="100" height="6"/></xsl:otherwise></xsl:choose></div><div class="flr"><xsl:value-of select="$poll_count3"/> votes</div>
					<div class="clear"></div>
				</li>
				<li>
					<div class="fl">2 <xsl:choose><xsl:when test="$option2percent &gt; 0"><img src="{$imagesource}bar.gif" width="{round($option2percent)}" height="6" alt="{$option2percent}%" border="0" vspace="0" hspace="5" /></xsl:when><xsl:otherwise><img src="/f/t.gif" width="100" height="6"/></xsl:otherwise></xsl:choose></div><div class="flr"><xsl:value-of select="$poll_count2"/> votes</div>
					<div class="clear"></div>
				</li>
				<li>
					<div class="fl">1 <xsl:choose><xsl:when test="$option1percent &gt; 0"><img src="{$imagesource}bar.gif" width="{round($option1percent)}" height="6" alt="{$option1percent}%" border="0" vspace="0" hspace="5" /></xsl:when><xsl:otherwise><img src="/f/t.gif" width="100" height="6"/></xsl:otherwise></xsl:choose></div><div class="flr"><xsl:value-of select="$poll_count1"/> votes</div>
					<div class="clear"></div>
				</li>				
			</ul>
			
			<p>average rating:<br />
			<strong><xsl:value-of select="$poll_average_score"/> from <xsl:value-of select="$votes_cast"/> votes</strong></p>
			
			<xsl:if test="/H2G2/POLL-LIST/POLL and (/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">
				<!-- <p><em>You cannot vote as you wrote this article.</em></p> -->
			</xsl:if>
	</xsl:template>
	
	<!-- 
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
	Use: Att set for the 'submit poll' button
	-->
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">RATE</xsl:attribute>
		<xsl:attribute name="class">inputsubmit</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- 
	<xsl:template match="POLL" mode="form_articlepage">
	Use: Template invoked when displaying a poll's submission form
	-->
	<xsl:template match="POLL" mode="form_articlepage">
		<div class="ratebox">
		<h3>RATE THIS ARTICLE</h3>
		<ul id="rateform">
			<li><input type="radio" name="response" value="5" id="five" checked="checked" /> <label for="five">5<img src="{$imagesource}5stars.gif" alt="[5 stars]" width="80" height="12" /></label></li>
			<li><input type="radio" name="response" value="4" id="four" /> <label for="four">4<img src="{$imagesource}4stars.gif" alt="[4 stars]" width="63" height="12" /></label></li>
			<li><input type="radio" name="response" value="3" id="three" /> <label for="three">3<img src="{$imagesource}3stars.gif" alt="[3 stars]" width="47" height="12" /></label></li>
			<li><input type="radio" name="response" value="2" id="two" /> <label for="two">2<img src="{$imagesource}2stars.gif" alt="[2 stars]" width="30" height="12" /></label></li>
			<li><input type="radio" name="response" value="1" id="one" /> <label for="one">1<img src="{$imagesource}1star.gif" alt="[1 star]" width="13" height="12" /></label></li>					
		</ul>
		
		<xsl:apply-templates select="." mode="t_submitcontentrating"/>
		  
	  </div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="POLL" mode="hidden_articlepage"/>
	Use: Invoked when a poll has been hidden
	-->
	<xsl:template match="POLL" mode="hidden_articlepage"/>
	<!-- 
	<xsl:template match="POLL" mode="r_hide">
	Use: Presentation of the 'Hide' box - presented to editors
	-->
	<xsl:template match="POLL" mode="r_hide">
	<div class="editbox" id="editPoll">			
		<p><xsl:text>Hide this poll: </xsl:text>
		<xsl:apply-templates select="." mode="t_hidepollradio"/><br />
		<xsl:text>Unhide this poll: </xsl:text>
		<xsl:apply-templates select="." mode="t_unhidepollradio"/>
		</p>
		<xsl:apply-templates select="." mode="t_submithidepoll"/>
	</div>	
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="iPOLL_t_hidepollradio"/>
	Use: Att set for hiding poll radio button
	-->
	<xsl:attribute-set name="iPOLL_t_hidepollradio"/>
	<!-- 
	<xsl:attribute-set name="iPOLL_t_unhidepollradio"/>
	Use: Att set for unhiding poll radio button
	-->
	<xsl:attribute-set name="iPOLL_t_unhidepollradio"/>
	<!-- 
	<xsl:attribute-set name="iPOLL_t_submithidepoll">
	Use: Att set for submitting the hide feature
	-->
	<xsl:attribute-set name="iPOLL_t_submithidepoll"/>
	<!-- 
	<xsl:template match="USER-VOTE" mode="r_display">
	Use: display of the users previous vote
	-->
	<xsl:template match="USER-VOTE" mode="r_display">
		<p>You gave this article <strong><xsl:value-of select="@CHOICE"/> out of 5</strong></p>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-VOTE" mode="r_changevote">
	Use: Link to change a vote once already cast
	-->
	<xsl:template match="USER-VOTE" mode="r_changevote">
		
		<div id="changerating"><a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_show=vote"><img src="{$imagesource}refresh/btn_change_rating.gif" width="134" height="22" alt="change your rating" /></a></div>
		<br clear="all" class="clearall"/>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="ERROR" mode="r_articlepoll">
	Use: Presentation of the error message
	-->
	<xsl:template match="ERROR" mode="r_articlepoll">
		<div class="warningBox">
			<p class="warning">
			<b>ERROR</b><br />
			<xsl:choose>
				<xsl:when test="@CODE=0">Unspecified error</xsl:when>
				<xsl:when test="@CODE=1">Invalid value in the cmd parameter</xsl:when>
				<xsl:when test="@CODE=2">One or more invalid parameters found </xsl:when>
				<xsl:when test="@CODE=3">Invalid poll id</xsl:when>
				<xsl:when test="@CODE=4">You must be logged in to vote</xsl:when>
				<xsl:when test="@CODE=5">Access denied</xsl:when>
				<xsl:when test="@CODE=6">Page Author is not allowed to vote</xsl:when>
			</xsl:choose>
			</p>
		</div>
	</xsl:template>
	<!-- 
	<xsl:template match="POLL" mode="poll_count">
	Use: calculates how many votes a particular option has received
	-->
	<xsl:template match="POLL" mode="poll_count">
		<xsl:param name="index"/>
		<xsl:choose>
			<xsl:when test="OPTION-LIST/USERSTATUS/OPTION[@INDEX=$index]">
				<xsl:value-of select="sum(OPTION-LIST/USERSTATUS/OPTION[@INDEX=$index]/@COUNT)"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	Calculating totals for each option...
	-->
	<xsl:variable name="poll_count1">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL[1]" mode="poll_count">
			<xsl:with-param name="index">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count2">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL[1]" mode="poll_count">
			<xsl:with-param name="index">2</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count3">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL[1]" mode="poll_count">
			<xsl:with-param name="index">3</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count4">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL[1]" mode="poll_count">
			<xsl:with-param name="index">4</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count5">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL[1]" mode="poll_count">
			<xsl:with-param name="index">5</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<!-- 
	Calculating the total number of votes cast 
	-->
	<xsl:variable name="votes_cast" select="$poll_count1 + $poll_count2 + $poll_count3 + $poll_count4 + $poll_count5"/>
	<!-- 
	Calculating the average of all votes cast
	-->
	<xsl:variable name="poll_average_score">
		<xsl:choose>
			<xsl:when test="$votes_cast = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number((($poll_count1*1) + ($poll_count2*2) + ($poll_count3*3) + ($poll_count4*4) + ($poll_count5*5)) div $votes_cast, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- 
	Calculating the percentages of all votes
	-->
	<xsl:variable name="option1percent">
		<xsl:choose>
			<xsl:when test="$poll_count1 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count1 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option2percent">
		<xsl:choose>
			<xsl:when test="$poll_count2 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count2 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option3percent">
		<xsl:choose>
			<xsl:when test="$poll_count3 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count3 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option4percent">
		<xsl:choose>
			<xsl:when test="$poll_count4 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count4 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option5percent">
		<xsl:choose>
			<xsl:when test="$poll_count5 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count5 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
</xsl:stylesheet>
