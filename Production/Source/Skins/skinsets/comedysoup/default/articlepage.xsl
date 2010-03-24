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
		<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_skiptomod"/>
		<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
		<!-- <xsl:apply-templates select="ARTICLE" mode="c_unregisteredmessage"/> -->
		
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
		<p><xsl:copy-of select="$m_unregisteredslug"/></p>
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
	
	
	<!-- 
	####################################################################
					OVERRIDE BASE FILE PREMODERATION CODE
					call my templates instead of theirs
	####################################################################
	-->
	
	<xsl:template name="m_articleawaitingpremoderationtext">
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="r_articlepage"/>
	</xsl:template>
	
	<!-- 
	####################################################################
	/END: OVERRIDE BASE FILE PREMODERATION CODE
	####################################################################
	-->
	
	
	
	
	<xsl:template match="ARTICLE" mode="r_articlepage">
		<xsl:choose>
			<xsl:when test="$article_type_group = 'mediasset'">
			<!-- Article with a media asset -->
				<xsl:choose>
					<xsl:when test="(/H2G2/PARAMS/PARAM[NAME='s_fromedit']/VALUE='1') and (/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1) and /H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN">
						<!-- Article with a image media asset that has just been submitted -->
						<xsl:call-template name="IMAGE_ASSET_ARTICLE_SUBMITTED" />
					</xsl:when>
					<xsl:when test="(/H2G2/PARAMS/PARAM[NAME='s_fromedit']/VALUE='1') and (/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2 or /H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3)  and /H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN">
						<!-- Article with a audio or video media asset that has just been submitted -->
						<xsl:call-template name="AV_ASSET_ARTICLE_SUBMITTED" />
					</xsl:when>
					<xsl:when test="GUIDE/STRONG_CONTENT='on'">
						<!-- Article with a media asset that is 'strong content' -->
						
						<xsl:choose>
							<!-- user is not signed in -->
							<xsl:when test="not(/H2G2/VIEWING-USER/USER)">
								<xsl:call-template name="MEDIA_ASSET_ARTICLE_STRONG_CONTENT_NOT_SIGNEDIN" />
							</xsl:when>
							<!-- user is signed in and has selected 'yes'-->
							<xsl:when test="/H2G2/VIEWING-USER/USER and /H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='yes'">
								<xsl:call-template name="MEDIA_ASSET_ARTICLE" />
							</xsl:when>
							<!-- user is signed in but has not yet selected 'yes'-->
							<xsl:otherwise>
								<xsl:call-template name="MEDIA_ASSET_ARTICLE_STRONG_CONTENT_SIGNEDIN" />
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:when>
					<xsl:when test="$test_IsEditor=1 or $user_is_assetmoderator=1 or $user_is_moderator=1">
						<!-- Article with a media asset that is being viewed by an editor or moderator -->
						<xsl:call-template name="MEDIA_ASSET_ARTICLE" />
					</xsl:when>
					<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=3">
						<!-- Article with a media asset that is in moderation -->
						<xsl:call-template name="MEDIAASSET_ARTICLE_AWAITING_MODERATION" />
					</xsl:when>
					<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=2 or /H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN=1">
						<!-- Article with a media asset that is that has been reffered or failed -->
						<xsl:call-template name="MEDIAASSET_ARTICLE_NOT_PASSED" />
					</xsl:when>
					<xsl:otherwise>
						<!-- Article with a media asset that has passed moderation -->
						<xsl:call-template name="MEDIA_ASSET_ARTICLE" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$article_type_group = 'assetlibrary'">
				<xsl:call-template name="ASSET_LIBRARY_ARTICLE" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="EDITORIAL_ARTICLE" />
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		<br/>
	</xsl:template>
	<!--
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_article">
	<div class="box">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		<br/>
		<xsl:value-of select="TOTALPOSTS" /> comments | <xsl:value-of select="$m_lastposting"/>:<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>
	</div>
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
			<b>Favourites</b>
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
	
	<xsl:template match="ARTICLE" mode="r_categorise">
		
	</xsl:template>
	
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
		<xsl:apply-templates select="POLL" mode="c_articlepage"/>
		<xsl:apply-templates select="POLL" mode="c_hide"/>
	
	</xsl:template>
	<!-- 
	<xsl:template match="POLL" mode="results_articlepage">
	Use: Template invoked when a user has already voted
	-->
	<xsl:template match="POLL" mode="results_articlepage">
		<h2>Rating breakdown</h2>
		
		<xsl:apply-templates select="ERROR" mode="c_articlepoll"/>
		
		<!-- Alistair: turn this into a resuable template!! -->
		<table class="ratingResults" cellpadding="0" cellspacing="0" border="0">
		<tr>
		<th class="rating" valign="middle">5</th>
		<td class="percent" valign="middle"><span class="ratingBarWrapper"><xsl:choose><xsl:when test="$option5percent &gt; 0"><img src="{$imagesource}rating_bar.gif" width="{round($option5percent * 0.7)}" height="6" alt="{$option5percent}%"/></xsl:when><xsl:otherwise><img src="/f/t.gif" width="70" height="6"/></xsl:otherwise></xsl:choose></span></td>
		<td class="votes" valign="middle"><xsl:value-of select="$poll_count5"/> votes</td>
		</tr>
		<tr>
		<th class="rating" valign="middle">4</th>
		<td class="percent" valign="middle"><span class="ratingBarWrapper"><xsl:choose><xsl:when test="$option4percent &gt; 0"><img src="{$imagesource}rating_bar.gif" width="{round($option4percent * 0.7)}" height="6" alt="{$option4percent}%"/></xsl:when><xsl:otherwise><img src="/f/t.gif" width="70" height="6"/></xsl:otherwise></xsl:choose></span></td>
		<td class="votes" valign="middle"><xsl:value-of select="$poll_count4"/> votes</td>
		</tr>
		<tr>
		<th class="rating" valign="middle">3</th>
		<td class="percent" valign="middle"><span class="ratingBarWrapper"><xsl:choose><xsl:when test="$option3percent &gt; 0"><img src="{$imagesource}rating_bar.gif" width="{round($option3percent * 0.7)}" height="6" alt="{$option3percent}%"/></xsl:when><xsl:otherwise><img src="/f/t.gif" width="70" height="6"/></xsl:otherwise></xsl:choose></span></td>
		<td class="votes" valign="middle"><xsl:value-of select="$poll_count3"/> votes</td>
		</tr>
		<tr>
		<th class="rating" valign="middle">2</th>
		<td class="percent" valign="middle"><span class="ratingBarWrapper"><xsl:choose><xsl:when test="$option2percent &gt; 0"><img src="{$imagesource}rating_bar.gif" width="{round($option2percent * 0.7)}" height="6" alt="{$option2percent}%"/></xsl:when><xsl:otherwise><img src="/f/t.gif" width="70" height="6"/></xsl:otherwise></xsl:choose></span></td>
		<td class="votes" valign="middle"><xsl:value-of select="$poll_count2"/> votes</td>
		</tr>
		<tr>
		<th class="rating" valign="middle">1</th>
		<td class="percent" valign="middle"><span class="ratingBarWrapper"><xsl:choose><xsl:when test="$option1percent &gt; 0"><img src="{$imagesource}rating_bar.gif" width="{round($option1percent * 0.7)}" height="6" alt="{$option1percent}%"/></xsl:when><xsl:otherwise><img src="/f/t.gif" width="70" height="6"/></xsl:otherwise></xsl:choose></span></td>
		<td class="votes" valign="middle"><xsl:value-of select="$poll_count1"/> votes</td>
		</tr>
		</table>
						
		<xsl:apply-templates select="USER-VOTE" mode="c_display"/>
		<xsl:apply-templates select="USER-VOTE" mode="c_changevote"/>

	</xsl:template>
	<!-- 
	<xsl:template match="POLL" mode="results_articlepage">
	Use: Template invoked when a user is not signed in
	-->
	<xsl:template match="POLL" mode="signedout_articlepage">
		<h2>Rate this submission</h2>
		<xsl:apply-templates select="ERROR" mode="c_articlepoll"/>
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='signedout'"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RATE_SUBMISSION_INPUTS" />
				<input type="hidden" name="s_show" value="signedout"/>
				<xsl:apply-templates select="." mode="t_submitcontentrating"/>
			</xsl:otherwise>
		</xsl:choose>
				
		<div class="arrow"><a href="{concat($sso_rootlogin, 'SSO%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)}">Sign in if you want to vote</a></div>					
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
	Use: Att set for the 'submit poll' button
	-->
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Rate</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:template match="POLL" mode="form_articlepage">
	Use: Template invoked when displaying a poll's submission form
	-->
	<xsl:template match="POLL" mode="form_articlepage">
		<xsl:apply-templates select="ERROR" mode="c_articlepoll"/>
		<h2>Rate this submission</h2>
		
		<xsl:if test="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT='on'">
			<input type="hidden" name="s_select" value="yes"/><!-- This is needed so that viewers do not see the warning page after voting -->
		</xsl:if>
		
		<xsl:call-template name="RATE_SUBMISSION_INPUTS" />
		
		<xsl:apply-templates select="." mode="t_submitcontentrating"/>
		
		<xsl:apply-templates select="USER-VOTE" mode="c_display"/>
		
	</xsl:template>
	
	
	<xsl:template name="RATE_SUBMISSION_INPUTS">
		<ul class="radioList">		
			<li><input type="radio" name="response" value="5" id="radio5" /><label for="radio5">5<img src="{$imagesource}stars_5.gif" alt="" width="65" height="12" /></label></li>
			<li><input type="radio" name="response" value="4" id="radio4" /><label for="radio4">4<img src="{$imagesource}stars_4.gif" alt="" width="65" height="12" /></label></li>
			<li><input type="radio" name="response" value="3" id="radio3" /><label for="radio3">3<img src="{$imagesource}stars_3.gif" alt="" width="65" height="12" /></label></li>
			<li><input type="radio" name="response" value="2" id="radio2" /><label for="radio2">2<img src="{$imagesource}stars_2.gif" alt="" width="65" height="12" /></label></li>
			<li><input type="radio" name="response" value="1" id="radio1" /><label for="radio1">1<img src="{$imagesource}stars_1.gif" alt="" width="65" height="12" /></label></li>
		</ul>
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
		<p id="yourvote">You gave this media <xsl:value-of select="@CHOICE"/> out of 5</p>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-VOTE" mode="r_changevote">
	Use: Link to change a vote once already cast
	-->
	<xsl:template match="USER-VOTE" mode="r_changevote">
		<xsl:variable name="viewstrongcontent">
			<xsl:if test="/H2G2/ARTICLE/GUIDE/STRONG_CONTENT='on'">&amp;s_select=yes</xsl:if>
		</xsl:variable><!-- This is needed so that viewers do not see the warning page after changing their vote -->
		
		<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_show=vote{$viewstrongcontent}" class="button"><span><span><span><xsl:copy-of select="$change_poll"/></span></span></span></a>
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
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count2">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">2</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count3">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">3</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count4">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">4</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count5">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
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
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							MEDIAASSETINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
		
	<xsl:template match="MEDIAASSET" mode="image_displaymediaasset_article">
		<img src="{$articlemediapath}{@MEDIAASSETID}_article.{$articlemediasuffix}{$moderationsuffix}" alt="{/H2G2/ARTICLE/SUBJECT}" xsl:use-attribute-sets="imgMEDIAASSET_image_displaymediaasset" border="0" />	
	</xsl:template>
	
	<xsl:template match="MEDIAASSET" mode="image_displaymediaasset_raw">
		<img src="{$articlemediapath}{@MEDIAASSETID}_raw.{$articlemediasuffix}{$moderationsuffix}" alt="{/H2G2/ARTICLE/SUBJECT}" xsl:use-attribute-sets="imgMEDIAASSET_image_displaymediaasset" border="0" />	
	</xsl:template>
	
	
	
	
</xsl:stylesheet>
