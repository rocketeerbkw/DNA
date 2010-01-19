<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../../base/base-articlepage.xsl" />
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
		<xsl:apply-templates mode="c_articlepage" select="ARTICLE" />
		<xsl:apply-templates mode="c_skiptomod" select="ARTICLE-MODERATION-FORM" />
		<xsl:apply-templates mode="c_modform" select="ARTICLE-MODERATION-FORM" />
	</xsl:template>

	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
		<xsl:apply-imports />
	</xsl:template>

	<!--
	<xsl:template match="CLIP" mode="r_articleclipped">
	Description: message to be displayed after clipping an article
	 -->
	<xsl:template match="CLIP" mode="r_articleclipped">
		<b>
			<xsl:apply-imports />
		</b>
		<br />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	Description: message to be displayed if the viewer is not registered
	 -->
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
	Description: Presentation of link that skips to the moderation section
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
	Description: Presentation of the article moderation form
	Visible to: Moderators
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
		<table bgColor="lightblue" border="0" cellpadding="2" cellspacing="2">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-imports />
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="add_tag">
	Use: Presentation for the link to add an article to the categories
	 -->
	<xsl:template match="ARTICLE" mode="add_tag">
		<a
			href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;nodeid=1&amp;tagmode=1"
			> add to categories </a>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="edit_tag">
	Use: Presentation for the link to edit the categories nodes
	 -->
	<xsl:template match="ARTICLE" mode="edit_tag">
		<a
			href="{$root}tagitem?action=remove&amp;tagitemtype=1&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;tagorigin={/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[position()=last()]/NODEID}"
			> remove from categories</a>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLE" mode="r_articlepage">
	Description:	applies the correct template mode depending
					on the type of film (credit, film, declined
					notes, frontpage, etc). It uses the $article_type_group
					variable defined in types.xsl
	 -->
	<xsl:template match="ARTICLE" mode="r_articlepage">
		<xsl:choose>
			<!-- FILM PRESENATION-->
			<xsl:when test="$article_type_group = 'film'">
				<!-- check for details filled in etc -->
				<xsl:choose>
					<!-- S_DETAILS=NO submission created but the contact details have not been provided -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'no'">
						<xsl:call-template name="NODETAILS_FORM" />
					</xsl:when>
					<!-- S_DEATILS=YES contact details have been provided -->
					<xsl:when
						test="/H2G2/PARAMS/PARAM[NAME = 's_showcontract']/VALUE = 'yes'">
						<xsl:call-template name="FILM_CONTRACT_FORM" />
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes'">
						<!-- TRANSFER PAGE  -->
						<xsl:call-template name="FILM_TRANSFER_PAGE" />
					</xsl:when>
					<xsl:otherwise>
						<!-- films are either evaluated using the approved or unapproved mode 
							 for now we are continuing to check for status 5 (declined), however
							 that will be phased out. It won't hurt to leave it in. If you take it
							 out, be sure to test -->
						<xsl:choose>
							<xsl:when
								test="(ARTICLEINFO/STATUS/@TYPE = 3 or ARTICLEINFO/STATUS/@TYPE = 5) and $article_type_group = 'film'">
								<xsl:apply-templates mode="filmsubmission_nonapproved"
									select="." />
							</xsl:when>
							<xsl:when test="ARTICLEINFO/STATUS/@TYPE = 1">
								<xsl:apply-templates mode="filmsubmission_approved" select="."
								 />
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- DECLINE FILM PRESENTATION -->
			<xsl:when test="$article_type_group = 'declined'">
				<xsl:apply-templates mode="filmsubmission_nonapproved" select="." />
			</xsl:when>
			<!-- CREDIT PRESENATION -->
			<xsl:when test="$article_type_group = 'credit'">
				<xsl:apply-templates mode="filmsubmission_approved" select="." />
			</xsl:when>
			<!-- NOTES PRESENATION -->
			<xsl:when test="$article_type_group = 'notes'">
				<xsl:apply-templates mode="filmsubmission_notes" select="." />
			</xsl:when>
			<xsl:when
				test="($article_type_group = 'article') and ($article_subtype = 'discussion')">
				<xsl:apply-templates mode="discussion_pages" select="." />
			</xsl:when>
			<!-- FRONTPAGE PRESENATION -->
			<xsl:when test="$article_type_group = 'frontpage'">
				<xsl:apply-templates mode="frontpage" select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$article_type_group = 'category'">
					<xsl:attribute name="style">margin-top:10px</xsl:attribute>
				</xsl:if>
				<xsl:if test="$current_article_type = 63">
					<div class="crumbtop">
						<span class="textmedium"><strong><a HREF="{$root}dna/magazine"
									>magazine</a> | </strong>
							<xsl:apply-templates mode="r_article"
								select="ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[position() &gt; 2]"
							 /> | </span>
						<span class="textxlarge">
							<xsl:value-of select="SUBJECT" />
						</span>
					</div>
				</xsl:if>
				<xsl:apply-templates select="GUIDE/BODY" />
			</xsl:otherwise>
		</xsl:choose>
		<!-- show edit button to editors or unapproved films -->
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="filmsubmission_nonapproved">
	Description: call to the film_nonapproved template. the bulk 
				 of the work is done here
	-->
	<xsl:template match="ARTICLE" mode="filmsubmission_nonapproved">
		<xsl:call-template name="FILM_NONAPPROVED" />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="filmsubmission_approved">
	Description: call to the film_approved template. the bulk 
				 of the work is done here
	-->
	<xsl:template match="ARTICLE" mode="filmsubmission_approved">
		<xsl:call-template name="FILM_APPROVED" />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="filmsubmission_notes">
	Description: call to the film_approved template. the bulk 
				 of the work is done here
	-->
	<xsl:template match="ARTICLE" mode="filmsubmission_notes">
		<xsl:call-template name="FILM_NOTES" />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="discussion_pages">
	Description:	Discussion page layout
	 -->
	<xsl:template match="ARTICLE" mode="discussion_pages">
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td height="10">
					<!-- crumb menu -->
					<div class="crumbtop">
						<span class="textmedium"><a href="{$root}discussion">
								<strong>discussion</strong>
							</a> |</span>
						<span class="textxlarge">
							<xsl:value-of select="/H2G2/ARTICLE/SUBJECT" />
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
								<img alt="" height="10" src="/f/t.gif" width="1" />

								<div class="whattodotitle">
									<strong>This discussion is about <br /></strong>
								</div>
								<div class="biogname">
									<strong>
										<xsl:value-of select="/H2G2/ARTICLE/SUBJECT" />
									</strong>
								</div>
								<div class="topboxcopy">
									<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" />
								</div>
							</td>
						</tr>
					</table>
				</td>
				<td class="topbg" valign="top" width="20" />
				<td class="topbg" valign="top" />
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

					<xsl:if test="count(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST) > 5">
						<!-- next prev -->
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
											<td width="140">
												<div class="textsmall">
													<strong></strong>
												</div>
											</td>
											<td align="center" width="101">
												<div class="textsmall">
													<strong></strong>
												</div>
											</td>
											<td align="right" width="130">
												<div class="textsmall">
													<strong>
														<a
															href="{$root}F{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}"
															xsl:use-attribute-sets="mARTICLEFORUM_r_viewallthreads"
															>more comments</a>&nbsp;<img alt="" height="7"
															src="{$imagesource}furniture/myprofile/arrowdark.gif"
															width="4" />
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
					</xsl:if>
					<xsl:apply-templates mode="article"
						select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS" />
					<!--  comments table -->
					<xsl:call-template name="MORE_COMMENTS" />
					<!-- alert moderator -->
					<xsl:if test="count(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST) > 0">
						<xsl:call-template name="ALERT_MODERATORS" />
					</xsl:if>
				</td>
				<td valign="top" width="20" />
				<td valign="top">

					<table border="0" cellpadding="0" cellspacing="0" width="244">
						<tr>
							<td class="darkestbg" valign="top">
								<div class="rightcolsubmit">
									<a xsl:use-attribute-sets="maFORUMID_empty_article">
										<xsl:attribute name="href">
											<xsl:call-template name="sso_addcomment_signin" />
										</xsl:attribute>
										<img alt="add your comments" height="47"
											src="{$imagesource}furniture/addyourcomments1.gif"
											width="197" />
									</a>
								</div>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="24">
						<tr>
							<td height="10" />
						</tr>
					</table>
					<!-- key with 1 elements -->
					<table border="0" cellpadding="0" cellspacing="0" class="quotepanelbg"
						width="244">
						<tr>
							<td rowspan="2" width="22" />
							<td valign="top" width="30">
								<div class="textmedium"
									style="margin:0px 0px 0px 0px; padding:16px 0px 18px 0px; border:0px;">
									<strong>key</strong>
								</div>
							</td>
							<td valign="top" width="192" />
						</tr>
						<tr>
							<td valign="top" width="30">
								<img alt="{$alert_moderatortext}" height="16"
									src="{$imagesource}furniture/keyalert.gif" width="17" />
							</td>
							<td valign="top">
								<div class="textsmall"
									style="margin:0px 0px 0px 0px; padding:2px 0px 15px 0px; border:0px;">
									<xsl:value-of select="$alert_moderatortext" />
								</div>
							</td>
						</tr>
					</table>
					<!-- end key -->
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="frontpage">
	Description: Front page layout
	 -->
	<xsl:template match="ARTICLE" mode="frontpage">
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td>
					<xsl:apply-templates select="GUIDE/BODY" />
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Description: Presentation of the 'subscribe to this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Description: Presentation of the 'unsubscribe from this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!--
	<xsl:template match="INTRO" mode="r_articlepage">
	Description: Presentation of article INTRO (not sure where this exists)
	 -->
	<xsl:template match="INTRO" mode="r_articlepage">
		<font xsl:use-attribute-sets="mainfont">
			<b>
				<xsl:apply-templates />
			</b>
		</font>
		<br />
	</xsl:template>

	<!--
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
	Description: Presentation of the footnote object 
	 -->
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
	Description: Presentation of the numeral within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
		<font size="1">
			<sup>
				<xsl:apply-imports />
			</sup>
		</font>
	</xsl:template>

	<!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Description: Presentation of the text within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
		<xsl:apply-imports />
	</xsl:template>
	<xsl:template match="FOOTNOTE">
		<font size="1">
			<sup>
				<xsl:apply-imports />
			</sup>
		</font>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEFORUM Object main article template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLEFORUM" mode="discussions_and_comments">
	Description: Determines if article uses comments or discussions
				 and depending will apply the correct forum template
				 
	 -->
	<!-- ALISTAIR: the following section decides if to evaluate the forum as a discussion or comment. You need to adjust the HTML to fit the new design -->
	<xsl:template match="ARTICLEFORUM" mode="discussions_and_comments">
		<xsl:choose>
			<!-- comments view of posts -->
			<xsl:when test="FORUMTHREADPOSTS">
				<table border="0" cellpadding="0" cellspacing="0" class="profileTitle"
					width="371">
					<tr>
						<td valign="top" width="371">
							<h2>
								<img alt="comments" height="34"
									src="{$imagesource}furniture/heading_comments.gif" width="172"
								 />
							</h2>
						</td>
					</tr>
				</table>
				<xsl:if
					test="$article_type_group = 'film' and /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD
					!= ''">
					<!-- email alert box -->
					<table border="0" cellpadding="0" cellspacing="0"
						class="largeEmailBox">
						<tr class="textMedium manageEmails">
							<td class="emailImageCell">
								<img alt="" height="20" id="manageIcon"
									src="http://www.bbc.co.uk/filmnetwork/images/furniture/manage_alerts.gif"
									width="25" />
							</td>
							<td>
								<strong>
									<a
										href="F{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}&amp;s_alertsRefresh=5"
										>subscribe/unsubscribe to receive email alerts for new
										comments on this film <img alt="" height="7"
											src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
											width="4" />
									</a>
								</strong>
							</td>
						</tr>
						<tr class="profileMoreAbout moreEmails">
							<td class="emailInfoImage">
								<img alt="" height="18"
									src="http://www.bbc.co.uk/filmnetwork/images/furniture/more_alerts.gif"
									width="18" />
							</td>
							<td>
								<a href="sitehelpemailalerts"> more about email alerts&nbsp;
										<img alt="" height="7"
										src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
										width="4" />
								</a>
							</td>
						</tr>
					</table>
				</xsl:if>
				<!-- comments tabe-->
				<xsl:apply-templates mode="article" select="FORUMTHREADPOSTS" />
				<xsl:if test="$article_type_group = 'film'">
					<!-- send someone a message -->
					<table border="0" cellpadding="0" cellspacing="0"
						style="margin-top:8px;" width="371">
						<tr>
							<td class="alerteditors" valign="top">
								<div class="alerteditorhead">
									<strong>send someone a message</strong>
								</div>
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<tr>
							<td valign="top">
								<div class="alerteditorbody">You can message anyone whose name
									appears as a link by clicking through to their profile
								page.</div>
							</td>
						</tr>
					</table>
				</xsl:if>
				<!-- alert editors -->
				<table border="0" cellpadding="0" cellspacing="0" width="371">
					<tr>
						<td class="alerteditors" valign="top">
							<div class="alerteditorhead">
								<strong>alert editors</strong>
							</div>
						</td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="371">
					<tr>
						<td valign="top">
							<div class="alerteditorbody">If you were involved with this film
								and notice any errors on this page, please <strong>
									<a
										href="mailto:filmnetwork@bbc.co.uk?subject=Comment For A{$userpage_article_number}, {/H2G2/ARTICLE/SUBJECT}"
										title="email the editors">email the editors</a>
								</strong>.</div>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="FORUMTHREADS">
				<!-- BEGIN discussion header -->
				<h2 class="image top bottom">
					<img alt="discussion" height="34"
						src="{$imagesource}furniture/heading_discussion.gif" width="161" />
				</h2>
				<!-- start a new discusion link - need to add code to check if logged in. -->
				<div id="startANewDiscussion">
					<!--
						<a href="{/H2G2/PAGEUI/DISCUSS/@LINKHINT}&amp;s_view=start_discussion">start a new discussion&nbsp;<img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt=""/></a>
					-->
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER">
									<xsl:value-of
										select="concat(/H2G2/PAGEUI/DISCUSS/@LINKHINT, '&amp;s_view=start_discussion')"
									 />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="concat($sso_rootlogin, /H2G2/PAGEUI/DISCUSS/@LINKHINT, '&amp;s_view=start_discussion')"
									 />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute> start a new discussion </a>
					<xsl:copy-of select="$arrow.right" />
				</div>
				<!-- discussion table-->
				<xsl:apply-templates mode="c_article" select="FORUMTHREADS" />
				<!-- all related discussions-->
				<xsl:if test="FORUMTHREADS/@TOTALTHREADS &gt; 10">
					<div id="allRelatedDiscussions">
						<xsl:element name="{$text.base}" use-attribute-sets="text.base">
							<a href="{$root}F{FORUMTHREADS/THREAD/@FORUMID}">
								<strong>all related discussions</strong>
							</a>&nbsp;<xsl:copy-of select="$arrow.right" />
						</xsl:element>
					</div>
				</xsl:if>
				<!-- DEBUGGING CODE -->
				<xsl:if
					test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
					<div class="debug">
						<strong>/H2G2/ARTICLEFORUM/FORUMTHREADS</strong><br />
							@FORUMID:<xsl:value-of select="FORUMTHREADS/@FORUMID" /><br />
							@SKIPTO:<xsl:value-of select="FORUMTHREADS/@SKIPTO" /><br />
							@COUNT:<xsl:value-of select="FORUMTHREADS/@COUNT" /><br />
							@TOTALTHREADS:<xsl:value-of select="FORUMTHREADS/@TOTALTHREADS"
						 /><br /> @FORUMPOSTCOUNT:<xsl:value-of
							select="FORUMTHREADS/@FORUMPOSTCOUNT" /><br />
						<table border="1" cellpadding="2" cellspacing="0"
							style="font-size:100%;">
							<caption>FORUMTHREADS/THREAD</caption>
							<tr>
								<th>position()</th>
								<th>THREADID</th>
								<th>SUBJECT</th>
								<th>TOTALPOSTS</th>
								<th>DATEPOSTED/DATE</th>
								<th>FIRSTPOST</th>
								<th>LASTPOST</th>
							</tr>
							<xsl:for-each select="FORUMTHREADS/THREAD">
								<tr>
									<td>
										<xsl:value-of select="position()" />
									</td>
									<td>
										<xsl:value-of select="THREADID" />
									</td>
									<td>
										<a href="{$root}F{@FORUMID}?thread={THREADID}">
											<xsl:value-of select="SUBJECT" />
										</a>
									</td>
									<td>
										<xsl:value-of select="TOTALPOSTS" />
									</td>
									<td><xsl:value-of select="DATEPOSTED/DATE/@DAY"
											 />&nbsp;<xsl:value-of
											select="DATEPOSTED/DATE/@MONTHNAME"
											 />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@YEAR"
											 /><xsl:text> </xsl:text><xsl:value-of
											select="DATEPOSTED/DATE/@HOURS" />:<xsl:value-of
											select="DATEPOSTED/DATE/@MINUTES" />:<xsl:value-of
											select="DATEPOSTED/DATE/@SECONDS" /> - <xsl:value-of
											select="DATEPOSTED/DATE/@RELATIVE" /></td>
									<td>
										<xsl:value-of select="FIRSTPOST/DATE/@RELATIVE" />
									</td>
									<td>
										<xsl:value-of select="LASTPOST/DATE/@RELATIVE" />
									</td>
								</tr>
							</xsl:for-each>
						</table>
					</div>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_article">
	Description: 
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_article">
		<xsl:apply-templates mode="c_article" select="FORUMTHREADS" />
		<xsl:apply-templates mode="c_viewallthreads" select="." />
		<br />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="article">
	Description: Decide to show post if they exist
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="article">
		<xsl:choose>
			<xsl:when test="POST">
				<xsl:apply-templates mode="full_article" select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$registered=1">
						<xsl:apply-templates mode="empty_article" select="." />
					</xsl:when>
					<xsl:otherwise>
						<div class="bullet">
							<a xsl:use-attribute-sets="maFORUMID_empty_article">
								<xsl:attribute name="href">
									<xsl:call-template name="sso_addcomment_signin" />
								</xsl:attribute>
								<img alt="add your comments" height="30" name="addyourcomments"
									src="{$imagesource}furniture/drama/addyourcomments1.gif"
									width="301" />
							</a>
						</div>
						<br />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
		<xsl:apply-imports />
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="empty_article">
		<div style="margin-top:6px;margin-bottom:6px;">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:copy-of select="$arrow.right" />
				<strong>
					<a xsl:use-attribute-sets="maFORUMID_empty_article">
						<xsl:attribute name="href">
							<xsl:call-template name="sso_addcomment_signin" />
						</xsl:attribute> add your comments </a>
				</strong>
			</xsl:element>
		</div>
		<br />
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_article">
		<table border="0" cellpadding="0" cellspacing="0" id="forumthreads"
			width="371">
			<tr>
				<th class="discussiontitle" width="165">discussion title</th>
				<th class="discussioncomments" width="87">comments</th>
				<th class="discussionlastcomment">last comment</th>
			</tr>
			<xsl:apply-templates mode="r_article" select="THREAD" />
		</table>
	</xsl:template>

	<!--
 	<xsl:template match="THREAD" mode="r_article">
 	Description: Presentation of each individual discussion thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_article">
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="position(  ) mod 2 = 0">commentstoprow</xsl:when>
					<xsl:otherwise>commentssubrow</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<td class="discussiontitle">
				<xsl:apply-templates mode="t_threadtitlelink" select="@THREADID" />
			</td>
			<td class="discussioncomments">
				<xsl:value-of select="TOTALPOSTS" />
			</td>
			<td class="discussionlastcomment">
				<a href="{$root}F{@FORUMID}?thread={@THREADID}#p{LASTPOST/@POSTID}">
					<xsl:value-of select="DATEPOSTED/DATE/@RELATIVE" />
				</a>
			</td>
		</tr>
	</xsl:template>

	<!--
 	<xsl:template match="@FORUMID" mode="addthread">
 	Description: 
 	-->
	<xsl:template match="@FORUMID" mode="addthread">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top">
					<div class="addyourcomments">
						<a
							onmouseout="swapImage('addyourcomments', '{$imagesource}furniture/drama/addyourcomments1.gif')"
							onmouseover="swapImage('addyourcomments', '{$imagesource}furniture/drama/addyourcomments2.gif')">
							<xsl:attribute name="href">
								<xsl:call-template name="sso_addcomment_signin" />
							</xsl:attribute>
							<img alt="add your comments" height="30" name="addyourcomments"
								src="{$imagesource}furniture/drama/addyourcomments1.gif"
								width="301" />
						</a>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
 	<xsl:template match="FORUMTHREADPOSTS" mode="full_article">
 	Description: show posts
 	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="full_article">
		<!-- add your comments -->
		<div style="margin-top:6px;margin-bottom:6px;">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:copy-of select="$arrow.right" />
				<strong>
					<a xsl:use-attribute-sets="maFORUMID_empty_article">
						<xsl:attribute name="href">
							<xsl:call-template name="sso_addcomment_signin" />
						</xsl:attribute> add your comments </a>
				</strong>
			</xsl:element>
		</div>
		<xsl:variable name="postnumber1">
			<xsl:choose>
				<xsl:when
					test="($article_type_group = 'article') and ($article_subtype = 'discussion')"
					> 20 </xsl:when>
				<xsl:otherwise> 5 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="article"
			select="POST[position() &lt;= $postnumber1]">
			<xsl:sort order="descending" select="@POSTID" />
		</xsl:apply-templates>
		<!-- view all comments -->
		<xsl:if
			test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT &gt; 5 ">
			<div id="moreComentsInConveration">
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<a
						href="F{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}&amp;reverseorder=1">
						<strong>view all comments</strong>
					</a>&nbsp;<xsl:copy-of select="$arrow.right" />
				</xsl:element>
			</div>
		</xsl:if>
		<div class="commentsFollowingLinks">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<a xsl:use-attribute-sets="maFORUMID_empty_article">
					<xsl:attribute name="href">
						<xsl:call-template name="sso_addcomment_signin" />
					</xsl:attribute> add your comments </a>&nbsp;<xsl:copy-of
					select="$arrow.right" />
			</xsl:element>
			<!-- alert moderator - break house rules -->
			<xsl:if test="count(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST) > 0">
				<div class="textxsmall">Click <img alt="!" height="16"
						id="alertmoderators"
						src="{$imagesource}furniture/icon_alertmoderators.gif" width="16" />
					on a comment that breaks the <a href="{root}houserules">house
					rules</a></div>
			</xsl:if>
		</div>
	</xsl:template>

	<!--
 	<xsl:template match="POST" mode="article">
 	Description: Presentation of each individual post  listed at the bottom of the article
 	-->
	<xsl:template match="POST" mode="article">
		<div class="post">
			<table border="0" cellpadding="0" cellspacing="0" width="371">
				<xsl:if test="USER/GROUPS/ADVISOR or USER/GROUPS/EDITOR">
					<xsl:attribute name="class">industryPanelReply</xsl:attribute>
				</xsl:if>
				<tr>
					<td class="commentstoprow" valign="top" width="342">
						<div class="commentstitle"><span class="textsmall">comment
								by</span>&nbsp;<span class="textmedium">
								<strong>
									<xsl:choose>
										<xsl:when test="TEXT != 'This post has been Removed'">
											<xsl:apply-templates mode="articlecomment" select="USER"
											 />
										</xsl:when>
										<xsl:otherwise>Moderated Comment</xsl:otherwise>
									</xsl:choose>
								</strong>
							</span></div>
					</td>
					<td class="commentstoprow" valign="top" width="29">
						<xsl:apply-templates mode="c_complainmp" select="@HIDDEN" />
					</td>
				</tr>
				<tr>
					<td class="commentssubrow" colspan="2" valign="top" width="371">
						<xsl:if test="TEXT != 'This post has been Removed'">
							<div class="commentsposted">posted&nbsp;<xsl:value-of
									select="DATEPOSTED/DATE/@RELATIVE" /></div>
						</xsl:if>
						<div class="commentuser">
							<xsl:apply-templates select="TEXT" />
						</div>
						<xsl:apply-templates mode="c_editmp" select="@POSTID" />
					</td>
				</tr>
			</table>
			<xsl:if test="USER/GROUPS/ADVISER or USER/GROUPS/EDITOR">
				<table border="0" cellpadding="0" cellspacing="0"
					class="industryPanelDetails" width="371">
					<tr>
						<td class="industryPanelIcon" valign="top">
							<img alt="" height="30"
								src="{$imagesource}furniture/icon_indust_prof.gif" width="31" />
						</td>
						<td class="industryPanelMember">
							<xsl:apply-templates mode="articlecomment" select="USER" /> is <xsl:choose>
								<xsl:when test="USER/GROUPS/ADVISER">
									<xsl:value-of select="USER/TITLE" /> and a member of Film
									Network's <a href="{$root}industrypanel">Industry Panel</a>. </xsl:when>
								<xsl:otherwise> a member of the Film Network editorial team.
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</table>
			</xsl:if>
		</div>
	</xsl:template>

	<!--
 	<xsl:template match="USER" mode="articlecomment">
 	Description: grabs the first and last name of the user
 	-->
	<xsl:template match="USER" mode="articlecomment">
		<a href="{$root}U{USERID}">
			<xsl:choose>
				<xsl:when test="string-length(FIRSTNAMES) &gt; 0">
					<xsl:value-of select="FIRSTNAMES" />&nbsp; <xsl:value-of
						select="LASTNAME" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="USERNAME" />
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
 	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
 	Description: 
 	-->
	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
		<font size="3">
			<b>
				<xsl:copy-of select="$m_entrydata" />
			</b>
		</font>
		<br />
		<xsl:copy-of select="$m_idcolon" /> A<xsl:value-of select="H2G2ID" />
		<br />
		<xsl:apply-templates mode="c_articlestatus" select="STATUS/@TYPE" />
		<xsl:apply-templates mode="c_article" select="PAGEAUTHOR" />
		<xsl:copy-of select="$m_datecolon" />
		<xsl:apply-templates mode="short1" select="DATECREATED/DATE" />
		<br />
		<br />
		<xsl:apply-templates mode="c_editbutton" select="." />
		<xsl:apply-templates mode="c_clip" select="/H2G2/ARTICLE" />
		<xsl:apply-templates mode="c_relatedmembersAP" select="RELATEDMEMBERS" />
		<!--Editorial Tools-->
		<xsl:apply-templates mode="c_returntoeditors"
			select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" />
		<xsl:apply-templates mode="c_categoriselink" select="H2G2ID" />
		<xsl:apply-templates mode="c_recommendentry" select="H2G2ID" />
		<!-- End of Editorial Tools-->
		<xsl:apply-templates mode="c_submit-to-peer-review" select="SUBMITTABLE" />
		<xsl:apply-templates mode="c_articlerefs" select="REFERENCES" />
		<xsl:apply-templates mode="c_removeself" select="H2G2ID" />
		<br />
		<br />
		<font size="1">
			<xsl:copy-of select="$m_complainttext" />
		</font>
	</xsl:template>

	<!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:copy-of select="$m_status" />
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
		<font size="3">
			<b>Return to editors</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<font size="3">
			<b>Categorise</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name from the authors' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
		<font size="3">
			<b>Remove self from list</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="H2G2ID" mode="r_recommendentry">
	Use: presentation of the 'recommend article' link
	-->
	<xsl:template match="H2G2ID" mode="r_recommendentry">
		<font size="3">
			<b>Recommend</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
	Use: presentation of position in the peer review process
	-->
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
		<font size="3">
			<b>Review Status</b>
			<br />
		</font>
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Use: presentation for the 'edit article' of edit link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
		<font size="3">
			<b>Edit</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLE" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="ARTICLE" mode="r_clip">
		<font size="3">
			<b>Clippings</b>
		</font>
		<br />
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Use: presentation of all related articles container
	-->
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
		<xsl:apply-templates mode="c_relatedclubsAP" select="RELATEDCLUBS" />
		<xsl:apply-templates mode="c_relatedarticlesAP" select="RELATEDARTICLES" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
	Use: presentation of the list of related articles container
	-->
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
		<font size="3">
			<b>Related Articles</b>
		</font>
		<br />
		<xsl:apply-templates mode="c_relatedarticlesAP" select="ARTICLEMEMBER" />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
	Use: presentation of the list of related clubs container
	-->
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
		<font size="3">
			<b>Related Clubs</b>
		</font>
		<br />
		<xsl:apply-templates mode="c_relatedclubsAP" select="CLUBMEMBER" />
		<br />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
	Use: presentation of a single related club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
		<xsl:apply-imports />
		<br />
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
		<br />
		<xsl:apply-templates mode="c_articlerefs" select="ENTRIES" />
		<xsl:apply-templates mode="c_articlerefs" select="USERS" />
		<xsl:apply-templates mode="c_bbcrefs" select="EXTERNAL" />
		<xsl:apply-templates mode="c_nonbbcrefs" select="EXTERNAL" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ENTRIES" mode="r_articlerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refentries" />
		</b>
		<br />
		<xsl:apply-templates mode="c_articlerefs" select="ENTRYLINK" />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
	Use: presentation of each individual entry link
	-->
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refresearchers" />
		</b>
		<br />
		<xsl:apply-templates mode="c_articlerefs" select="USERLINK" />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="USERLINK" mode="r_articlerefs">
	Use: presentation of each individual link to a user in the references section
	-->
	<xsl:template match="USERLINK" mode="r_articlerefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
	Use: Presentation of the container listing all bbc references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
		<b>
			<xsl:value-of select="$m_otherbbcsites" />
		</b>
		<br />
		<xsl:apply-templates mode="c_bbcrefs" select="EXTERNALLINK" />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
	Use: Presentation of the container listing all external references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
		<b>
			<xsl:value-of select="$m_refsites" />
		</b>
		<br />
		<xsl:apply-templates mode="c_nonbbcrefs" select="EXTERNALLINK" />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsext">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_nonbbcrefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							PAGEAUTHOR Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="PAGEAUTHOR" mode="r_article">
		<xsl:apply-templates mode="c_article" select="RESEARCHERS" />
		<xsl:apply-templates mode="c_article" select="EDITOR" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="RESEARCHERS" mode="r_article">
	Use: presentation of the researchers for an article, if they exist
	-->
	<xsl:template match="RESEARCHERS" mode="r_article">
		<xsl:value-of select="$m_researchers" />
		<xsl:apply-templates mode="c_researcherlist" select="USER" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
	<xsl:template match="EDITOR" mode="r_article">
		<xsl:value-of select="$m_editor" />
		<xsl:apply-templates mode="c_articleeditor" select="USER" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<xsl:apply-imports />
		<br />
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
		<xsl:apply-templates mode="c_article" select="CRUMBTRAIL" />
	</xsl:template>
	
	<!-- 
	<xsl:template match="CRUMBTRAIL" mode="r_article">
	Use: Presentation of an individual crumbtrail
	-->
	<xsl:template match="CRUMBTRAIL" mode="r_article">
		<xsl:apply-templates mode="c_article" select="ANCESTOR" />
		<br />
	</xsl:template>
	
	<!-- 
	<xsl:template match="ANCESTOR" mode="r_article">
	Use: Presentation of an individual link in a crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="r_article">
		<xsl:apply-imports />
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="r_categorise"> </xsl:template>

	<xsl:template name="editorbox">

		<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							EDITOR BOX Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
		<!-- EDITOR BOX - this is not in any of the designs but needs to be there for editord to perfom all the many work arounds....-->
		<xsl:if test="$test_IsEditor">
			<br />
			<br />
			<div class="filmedit">
				<table border="0" cellpadding="5" cellspacing="5" width="100%">
					<tr>
						<td bgcolor="#CAE4ED" colspan="2">
							<div class="textmedium">
								<h3>Editorial tool box</h3>
							</div>
						</td>
					</tr>
					<tr>
						<td bgcolor="#CAE4ED" valign="top" width="50%">
							<div class="textmedium">
								<strong>Edit this page</strong>
								<div>
									<a
										href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"
										>Edit with typed article</a>
								</div>
								<div>
									<a href="{$root}UserEdit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"
										>Edit with useredit</a>
								</div>
								<br />
								<br />
								<div>
									<!-- only editors can add notes and notes can only be added to a film (not credit, note, etc)  -->
									<xsl:if
										test="$test_IsEditor and $article_type_group = 'film' and not(/H2G2/ARTICLE/EXTRAINFO/NOTESID[text()])">

										<form action="/dna/filmnetwork/TypedArticle?acreate=new"
											method="post">
											<!-- you need the msxml nodes from the original article -->
											<input name="_msxml" type="hidden"
												value="{$filmmakersnotes}" />
											<input name="acreate" type="hidden" value="new" />
											<input name="_msstage" type="hidden" value="1" />
											<!-- this is the type number of the article you want to create -->
											<!-- Stacey added choose statement to say if it's type 30 ie drama  make 90
					or if 31 ie comedy  make 91
					-->
											<xsl:variable name="note_type">
												<xsl:choose>
													<xsl:when test="$current_article_type =30">90</xsl:when>
													<xsl:when test="$current_article_type =31">91</xsl:when>
													<xsl:when test="$current_article_type =32">92</xsl:when>
													<xsl:when test="$current_article_type =33">93</xsl:when>
													<xsl:when test="$current_article_type =34">94</xsl:when>
													<xsl:when test="$current_article_type =35"
													>95</xsl:when>
												</xsl:choose>
											</xsl:variable>
											<input name="type" type="hidden" value="{$note_type}" />
											<!-- then need to make notes form and notes viewing template -->
											<!-- NOGO NOTES FORM-->
											<!-- form is created here in nonapproved view   pre filled in to post to new form -->
											<input name="title" type="hidden"
												value="{/H2G2/ARTICLE/SUBJECT}" />
											<input name="body" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/BODY}" />
											<input name="HID" type="hidden"
												value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" />
											<!-- these are the nodes that you want to copy -->
											<input name="DIRECTORSNAME" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/DIRECTORSNAME}" />
											<input name="FILMLENGTH_MINS" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/FILMLENGTH_MINS}" />
											<input name="YEARPRODUCTION" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/YEARPRODUCTION}" />
											<input name="REGION" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/REGION}" />
											<input name="DESCRIPTION" type="hidden"
												value="{/H2G2/ARTICLE/GUIDE/DESCRIPTION}" />
											<input name="STATUS" type="hidden" value="3" />
											<input name="acreate" type="submit"
												value="add filmmakers notes" />
										</form>
										<!-- end editors -->
									</xsl:if>
								</div>
							</div>
						</td>
						<td bgcolor="#CAE4ED" valign="top" width="50%">
							<div class="textmedium">
								<strong>Create New pages</strong>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=1"
										>General Editorial Page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=60"
										>Discussion Page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=61"
										>Filmmakers Guide Page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=63"
										>Magazine Feature</a>
								</div>
								<br />
								<br />
							</div>
						</td>
					</tr>
					<tr>
						<td bgcolor="#CAE4ED" valign="top">
							<div class="textmedium">
								<strong>Create new Front pages</strong>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=10"
										>Discussion Front Page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=11"
										>Filmmakers Guide Front page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=12">Film
										Submission Front page</a>
								</div>
								<div>
									<a href="{$root}TypedArticle?acreate=new&amp;type=13"
										>About Front page</a>
								</div>
								<br />
								<br />
							</div>
						</td>
						<td bgcolor="#CAE4ED" valign="top">
							<div class="textmedium">
								<strong>Categorisation</strong>
								<div>
									<a href="{$root}editcategory">Edit category</a>
								</div>
								<div>
									<a
										href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;nodeid=1&amp;tagmode=1"
										>Add to categories</a>
								</div>
								<xsl:if
									test="string-length(/H2G2/HIERARCHYDETAILS/ARTICLE/ARTICLEINFO/H2G2ID) &gt; 0">
									<div>
										<a
											href="{$root}TypedArticle?aedit=new&amp;type=4001&amp;h2g2id={/H2G2/HIERARCHYDETAILS/ARTICLE/ARTICLEINFO/H2G2ID}"
											>Add guideML to this category</a>
									</div>
								</xsl:if>
							</div>
						</td>
					</tr>
					<tr>
						<td bgcolor="#CAE4ED" valign="top">
							<div class="textmedium">
								<strong>General page tools</strong>
								<div>
									<a href="{$root}editfrontpage">Edit the home page</a>
								</div>
								<div>
									<a href="{$root}NamedArticles">Named Articles</a>
								</div>
								<div>
									<a href="{$root}inspectuser">Edit user (inspectuser)</a>
								</div>
								<div>
									<a href="{$root}siteadmin">Site Admin</a>
								</div>
								<br />
								<br />
								<div>
									<form action="siteconfig" method="post"
										xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
										<input name="_msxml" type="hidden" value="{$configfields}" />
										<input title="edit site config" type="submit"
											value="edit site config" />
									</form>
								</div>
							</div>
						</td>
						<td bgcolor="#CAE4ED" valign="top">
							<div class="textmedium">
								<strong>Lists</strong>
								<div>
									<a
										href="{$root}Index?user=on&amp;type=30&amp;type=31&amp;type=32&amp;type=33&amp;type=34&amp;type=35&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;s_display=submissions_awaiting"
										>Submissions - Awaiting </a>
								</div>
								<div>
									<a
										href="{$root}Index?user=on&amp;type=50&amp;type=51&amp;type=52&amp;type=53&amp;type=54&amp;type=55&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;s_display=submissions_declined"
										>Submissions - Declined</a>
								</div>
								<div>
									<a
										href="{$root}Index?official=on&amp;type=30&amp;type=31&amp;type=32&amp;type=33&amp;type=34&amp;type=35&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;s_display=films"
										>All Films - by date created</a>
								</div>
								<div>
									<a
										href="{$root}Index?official=on&amp;user=on&amp;submitted=on&amp;type=70&amp;type=71&amp;type=72&amp;type=73&amp;type=74&amp;type=75&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;s_display=credits"
										>All Credits - by date created</a>
								</div>
								<div>
									<a href="{$root}info?cmd=conv&amp;show=20">Recent
									Comments</a>
								</div>
								<div>
									<a href="{$root}info?cmd=art&amp;show=100">Info Recent
										Articles (100)</a>
								</div>
								<div>
									<a href="{$root}info?cmd=conv&amp;show=100">Info Recent
										Conversations (100)</a>
								</div>
								<div>
									<a href="{$root}info">Info</a>
								</div>
								<div>
									<a href="{$root}newusers">Newusers</a>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<br />
			<br />
		</xsl:if>
	</xsl:template>

	<xsl:template name="MORE_COMMENTS">
		<!--  comments table -->
		<xsl:variable name="postnumber">
			<xsl:choose>
				<xsl:when
					test="($article_type_group = 'article') and ($article_subtype = 'discussion')"
					> 20 </xsl:when>
				<xsl:otherwise> 5 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="count(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST) > $postnumber">
			<table border="0" cellpadding="0" cellspacing="0" width="371">
				<tr>
					<td valign="top" width="371">
						<div class="morecommments">
							<strong>
								<a
									href="{$root}F{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}"
									xsl:use-attribute-sets="mARTICLEFORUM_r_viewallthreads"> more
									comments</a>
							</strong>&nbsp;<img alt="" height="7"
								src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
							 />
						</div>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ALERT_MODERATORS">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td align="right" valign="top" width="29">
					<img alt="{$alert_moderatortext}" height="16"
						src="{$imagesource}furniture/drama/commentsexclam2.gif" width="16"
					 />
				</td>
				<td width="342">
					<div class="textxsmall">
						<xsl:value-of select="$alert_moderatortext" />
						<br />
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="getAvailableMonth">
		<xsl:param name="filmmonth" />
		<xsl:choose>
			<xsl:when test="$filmmonth = '01'">Jan</xsl:when>
			<xsl:when test="$filmmonth = '02'">Feb</xsl:when>
			<xsl:when test="$filmmonth = '03'">Mar</xsl:when>
			<xsl:when test="$filmmonth = '04'">Apr</xsl:when>
			<xsl:when test="$filmmonth = '05'">May</xsl:when>
			<xsl:when test="$filmmonth = '06'">Jun</xsl:when>
			<xsl:when test="$filmmonth = '07'">Jul</xsl:when>
			<xsl:when test="$filmmonth = '08'">Aug</xsl:when>
			<xsl:when test="$filmmonth = '09'">Sep</xsl:when>
			<xsl:when test="$filmmonth = '10'">Oct</xsl:when>
			<xsl:when test="$filmmonth = '11'">Nov</xsl:when>
			<xsl:otherwise>Dec</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="checkDateOK">
		<xsl:param name="checkday" />
		<xsl:param name="checkmonth" />
		<xsl:param name="checkyear" />

		<xsl:choose>
			<xsl:when test="$checkyear &lt; /H2G2/DATE/@YEAR">no<!-- Don't display link, year past --></xsl:when>
			<xsl:when test="$checkyear > /H2G2/DATE/@YEAR">yes</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$checkmonth &lt; /H2G2/DATE/@MONTH">no<!-- Don't display link, month past --></xsl:when>
					<xsl:when test="$checkmonth > /H2G2/DATE/@MONTH">yes</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$checkday &lt; /H2G2/DATE/@DAY">no<!-- Don't display link, day past --></xsl:when>
							<xsl:otherwise>yes</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template name="ARTICLE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ARTICLE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart" />
				<xsl:choose>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
						<xsl:copy-of select="$m_articlehiddentitle" />
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
						<xsl:copy-of select="$m_articlereferredtitle" />
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
						<xsl:copy-of select="$m_articleawaitingpremoderationtitle" />
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
						<xsl:copy-of select="$m_legacyarticleawaitingmoderationtitle" />
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
						<xsl:copy-of select="$m_articledeletedtitle" />
					</xsl:when>
					<xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
						<xsl:copy-of select="$m_nosuchguideentry" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ARTICLE/SUBJECT" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!--
       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                                               POLLING Object

       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

       ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       -->
	<!--
	<xsl:template match="ERROR" mode="r_articlepoll">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Error object for content rating
	-->
	<xsl:template match="ERROR" mode="r_articlepoll">
		<table border="0" cellpadding="0" cellspacing="0" width="244">
			<tr>
				<td class="rightcolbgtop" width="244">
					<div class="textlightmedium">
						<strong />
					</div>
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="244">
			<tr>
				<td>
					<div class="textbrightsmall">
						<xsl:choose>
							<xsl:when test="@CODE=0">Unspecified error</xsl:when>
							<xsl:when test="@CODE=1">Invalid value in the cmd parameter</xsl:when>
							<xsl:when test="@CODE=2">One or more invalid parameters found </xsl:when>
							<xsl:when test="@CODE=3">Invalid poll id</xsl:when>
							<xsl:when test="@CODE=4">User needs to be logged in before
								operation can be performed</xsl:when>
							<xsl:when test="@CODE=5">Access denied</xsl:when>
							<xsl:when test="@CODE=6">Page Author is not allowed to
							vote</xsl:when>
						</xsl:choose>
					</div>
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="244">
			<tr>
				<td height="6" />
			</tr>
		</table>
	</xsl:template>

	<!-- 
       <xsl:template match="POLL-LIST" mode="r_articlepage">
       Use: Presentation of one or more Polls
       -->
	<xsl:attribute-set name="mPOLL_c_articlepage">
		<xsl:attribute name="name">rateForm</xsl:attribute>
		<xsl:attribute name="id">rateForm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="POLL-LIST" mode="r_articlepage">
		<xsl:apply-templates mode="c_articlepage" select="POLL" />
	</xsl:template>

	<xsl:template match="POLL-LIST" mode="hide_articlepage_poll">
		<xsl:apply-templates mode="c_hide" select="POLL" />
	</xsl:template>

	<!-- 
      <xsl:template match="POLL" mode="results_articlepage">
      Use: Template invoked when a user has already voted
       -->
	<xsl:template match="POLL" mode="results_articlepage">
		<xsl:apply-templates mode="c_articlepoll" select="ERROR" />
		<table border="0" cellpadding="0" cellspacing="0" width="244">
			<tr>
				<td class="rightcolbgtop" width="244">
					<div class="textlightmedium">
						<strong>rating breakdown</strong>
					</div>
				</td>
			</tr>
		</table>
		<div class="rightcolboxspecial">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<div class="textbrightsmall">5&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td width="100">
						<table border="1" bordercolor="#A5BBC4" cellpadding="0"
							cellspacing="0" width="100">
							<tr>
								<td width="100">
									<table border="0" cellpadding="0" cellspacing="0" width="100">
										<tr>
											<td>
												<img alt="" border="0" height="4"
													src="{$imagesource}furniture/drama/graphline2.gif"
													width="{$option5percent}" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<div class="textbrightsmall"
								>&nbsp;&nbsp;&nbsp;<xsl:value-of
								select="$poll_count5" /> &nbsp;vote<xsl:if
								test="$poll_count5 != 1">s</xsl:if></div>
					</td>
				</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<div class="textbrightsmall">4&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td width="100">
						<table border="1" bordercolor="#A5BBC4" cellpadding="0"
							cellspacing="0" width="100">
							<tr>
								<td width="100">
									<table border="0" cellpadding="0" cellspacing="0" width="100">
										<tr>
											<td>
												<img alt="" border="0" height="4"
													src="{$imagesource}furniture/drama/graphline2.gif"
													width="{$option4percent}" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<div class="textbrightsmall"
								>&nbsp;&nbsp;&nbsp;<xsl:value-of
								select="$poll_count4" /> &nbsp;vote<xsl:if
								test="$poll_count4 != 1">s</xsl:if></div>
					</td>
				</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<div class="textbrightsmall">3&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td width="100">
						<table border="1" bordercolor="#A5BBC4" cellpadding="0"
							cellspacing="0" width="100">
							<tr>
								<td width="100">
									<table border="0" cellpadding="0" cellspacing="0" width="100">
										<tr>
											<td>
												<img alt="" border="0" height="4"
													src="{$imagesource}furniture/drama/graphline2.gif"
													width="{$option3percent}" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<div class="textbrightsmall"
								>&nbsp;&nbsp;&nbsp;<!-- <xsl:value-of select="$option3percent"/>
                                        <xsl:text>%</xsl:text> --><xsl:value-of
								select="$poll_count3" /> &nbsp;vote<xsl:if
								test="$poll_count3 != 1">s</xsl:if></div>
					</td>
				</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<div class="textbrightsmall">2&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td width="100">
						<table border="1" bordercolor="#A5BBC4" cellpadding="0"
							cellspacing="0" width="100">
							<tr>
								<td width="100">
									<table border="0" cellpadding="0" cellspacing="0" width="100">
										<tr>
											<td>
												<img alt="" border="0" height="4"
													src="{$imagesource}furniture/drama/graphline2.gif"
													width="{$option2percent}" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<div class="textbrightsmall"
								>&nbsp;&nbsp;&nbsp;<xsl:value-of
								select="$poll_count2" /> &nbsp;vote<xsl:if
								test="$poll_count2 != 1">s</xsl:if></div>
					</td>
				</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<div class="textbrightsmall">1&nbsp;&nbsp;&nbsp;</div>
					</td>
					<td width="100">
						<table border="1" bordercolor="#A5BBC4" cellpadding="0"
							cellspacing="0" width="100">
							<tr>
								<td width="100">
									<table border="0" cellpadding="0" cellspacing="0" width="100">
										<tr>
											<td>
												<img alt="" border="0" height="4"
													src="{$imagesource}furniture/drama/graphline2.gif"
													width="{$option1percent}" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<div class="textbrightsmall"
								>&nbsp;&nbsp;&nbsp;<xsl:value-of
								select="$poll_count1" /> &nbsp;vote<xsl:if
								test="$poll_count1 != 1">s</xsl:if></div>
					</td>
				</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0" width="196">
				<tr>
					<td height="13" valign="middle" width="196">
						<img alt="" height="1"
							src="{$imagesource}furniture/drama/rightcoldashunderline.gif"
							width="196" />
					</td>
				</tr>
			</table>
			<xsl:if
				test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
				<span class="textlightsmall">
					<strong>You are not able to rate your own film.</strong>
				</span>
			</xsl:if>
			<xsl:apply-templates mode="c_display" select="USER-VOTE" />
			<xsl:apply-templates mode="c_changevote" select="USER-VOTE" />
			<!-- links to see comments and add comments -->
			<xsl:call-template name="RATING_COMMENTS" />
		</div>
	</xsl:template>
	
	<!-- 
       <xsl:template match="POLL" mode="signedout_articlepage">
       Use: Template invoked when a user is not signed in
       -->
	<xsl:template match="POLL" mode="signedout_articlepage">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='signedout'">
				<table border="0" cellpadding="0" cellspacing="0" width="244">
					<tr>
						<td class="rightcolbgtoporange" width="244">
							<div class="textwhitemedium">
								<strong>Sorry...</strong>
							</div>
						</td>
					</tr>
				</table>
				<div class="rightcolboxspecialorange">
					<div class="textbrightsmall">To rate a film you need to be a Film
						Network Member. Being a member will also allow you to add comments.</div>
					<table border="0" cellpadding="0" cellspacing="0" width="196">
						<tr>
							<td height="13" valign="middle" width="196">
								<img alt="" height="1"
									src="{$imagesource}furniture/drama/rightcoldashunderline.gif"
									width="196" />
							</td>
						</tr>
					</table>
					<span class="textbrightsmall">
						<strong>
							<a class="rightcol"
								href="{concat($sso_rootlogin, 'SSO%3Fpa=articlepoll%26pt=dnaid%26dnaid=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)}"
								>sign in&nbsp;<img alt="" height="7"
									src="{$imagesource}furniture/arrowlight.gif" width="4" /></a>
						</strong>
					</span>
					<br />
					<span class="textbrightsmall">
						<strong>
							<a class="rightcol"
								href="http://www.bbc.co.uk/cgi-perl/signon/mainscript.pl?service=filmnetwork&amp;c=register&amp;ptrt=http://www.bbc.co.uk/dna/filmnetwork/SSO?s_return=logout"
								>create you membership&nbsp;<img alt="" height="7"
									src="{$imagesource}furniture/arrowlight.gif" width="4" /></a>
						</strong>
					</span>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<table border="0" cellpadding="0" cellspacing="0" width="244">
					<tr>
						<td class="rightcolbgtop" width="244">
							<div class="textlightmedium">
								<strong>rate this film</strong>
							</div>
						</td>
					</tr>
				</table>
				<div id="pollError" />
				<div class="rightcolboxspecial">
					<div class="textbrightsmall">
						<input name="response" type="radio" value="5" /> 5 <img alt=""
							border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10" /><br />
						<input name="response" type="radio" value="4" /> 4 <img alt=""
							border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
						<input checked="checked" name="response" type="radio" value="3" /> 3
							<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
						<input name="response" type="radio" value="2" /> 2 <img alt=""
							border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
						<input name="response" type="radio" value="1" /> 1 <img alt=""
							border="0" height="9"
							src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
							 />&nbsp;<img alt="" border="0" height="9"
							src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
						 /><br />
					</div>
					<input name="s_show" type="hidden" value="signedout" />
					<table border="0" cellpadding="0" cellspacing="0" width="196">
						<tr>
							<td height="13" valign="middle" width="196">
								<img alt="" height="1"
									src="{$imagesource}furniture/drama/furniture/drama/rightcoldashunderline.gif"
									width="196" />
							</td>
						</tr>
					</table>
					<span class="textbrightsmall">
						<input alt="rate film" border="0"
							onclick="validatePoll();return false;"
							src="{$imagesource}furniture/drama/poll_ratefilm.gif" type="image"
							value="Vote" />
					</span>
					<br />
					<!-- links to see comments and add comments -->
					<xsl:call-template name="RATING_COMMENTS" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
       <xsl:attribute-set name="iPOLL_t_submitcontentrating">
       Use: Att set for the 'submit poll' button
       -->
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Vote</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- 
       <xsl:template match="POLL" mode="form_articlepage">
       Use: Template invoked when displaying a poll's submission form
       -->
	<xsl:template match="POLL" mode="form_articlepage">
		<xsl:apply-templates mode="c_articlepoll" select="ERROR" />
		<table border="0" cellpadding="0" cellspacing="0" width="244">
			<tr>
				<td class="rightcolbgtop" width="244">
					<div class="textlightmedium">
						<strong>rate this film</strong>
					</div>
				</td>
			</tr>
		</table>
		<div class="rightcolboxspecial">
			<div class="textbrightsmall">
				<input name="response" type="radio" value="5" /> 5 <img alt=""
					border="0" height="9" src="{$imagesource}furniture/drama/btn_on_b.gif"
					width="10" />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10" /><br />
				<input name="response" type="radio" value="4" /> 4 <img alt=""
					border="0" height="9" src="{$imagesource}furniture/drama/btn_on_b.gif"
					width="10" />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
				<input checked="checked" name="response" type="radio" value="3" /> 3
					<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
				<input name="response" type="radio" value="2" /> 2 <img alt=""
					border="0" height="9" src="{$imagesource}furniture/drama/btn_on_b.gif"
					width="10" />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_on_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
				<input name="response" type="radio" value="1" /> 1 <img alt=""
					border="0" height="9" src="{$imagesource}furniture/drama/btn_on_b.gif"
					width="10" />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10"
					 />&nbsp;<img alt="" border="0" height="9"
					src="{$imagesource}furniture/drama/btn_off_b.gif" width="10" /><br />
			</div>
			<table border="0" cellpadding="0" cellspacing="0" width="196">
				<tr>
					<td height="13" valign="middle" width="196">
						<img alt="" height="1"
							src="{$imagesource}furniture/drama/furniture/drama/rightcoldashunderline.gif"
							width="196" />
					</td>
				</tr>
			</table>
			<span class="textbrightsmall">
				<input alt="rate film" border="0"
					src="{$imagesource}furniture/drama/poll_ratefilm.gif" type="image"
					value="Vote" />
			</span>
			<br />
			<!-- links to see comments and add comments -->
			<xsl:call-template name="RATING_COMMENTS" />
		</div>
	</xsl:template>
	
	<!-- 
       <xsl:template match="POLL" mode="hidden_articlepage"/>
       Use: Invoked when a poll has been hidden
       -->
	<xsl:template match="POLL" mode="hidden_articlepage" />

	<!-- 
       <xsl:template match="POLL" mode="r_hide">
       Use: Presentation of the 'Hide' box - presented to editors
       -->
	<xsl:template match="POLL" mode="r_hide">
		<div id="hidePoll">
			<p>
				<xsl:text>Hide this poll: </xsl:text>
				<xsl:apply-templates mode="t_hidepollradio" select="." />
				<br />
				<xsl:text>Unhide this poll: </xsl:text>
				<xsl:apply-templates mode="t_unhidepollradio" select="." />
			</p>
			<xsl:apply-templates mode="t_submithidepoll" select="." />
		</div>
	</xsl:template>
	
	<!-- 
       <xsl:attribute-set name="iPOLL_t_hidepollradio"/>
       Use: Att set for hiding poll radio button
       -->
	<xsl:attribute-set name="iPOLL_t_hidepollradio" />
	
	<!-- 
       <xsl:attribute-set name="iPOLL_t_unhidepollradio"/>
       Use: Att set for unhiding poll radio button
       -->
	<xsl:attribute-set name="iPOLL_t_unhidepollradio" />

	<!-- 
       <xsl:attribute-set name="iPOLL_t_submithidepoll">
       Use: Att set for submitting the hide feature
       -->
	<xsl:attribute-set name="iPOLL_t_submithidepoll" />
	
	<!-- 
       <xsl:template match="USER-VOTE" mode="r_display">
       Use: display of the users previous vote
       -->

	<xsl:template match="USER-VOTE" mode="r_display">
		<span class="textbrightsmall">you gave this film <xsl:value-of
				select="@CHOICE" /> out of 5</span>
		<br />
	</xsl:template>
	
	<!-- 
       <xsl:template match="USER-VOTE" mode="r_changevote">
       Use: Link to change a vote once already cast
       -->
	<xsl:template match="USER-VOTE" mode="r_changevote">
		<span class="textbrightsmall">
			<strong>
				<a class="rightcol"
					href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_show=vote"> change
					your vote&nbsp;<img alt="" height="7"
						src="{$imagesource}furniture/arrowlight.gif" width="4" />
				</a>
			</strong>
		</span>
	</xsl:template>
	
	<!-- 
       <xsl:template match="ERROR" mode="r_articlepoll">
       Use: Presentation of the error message
       -->

	<xsl:template match="ERROR" mode="r_articlepoll">
	</xsl:template>
	
	<!-- 
       <xsl:template match="POLL" mode="poll_count">
       Use: calculates how many votes a particular option has received
       -->
	<xsl:template match="POLL" mode="poll_count">
		<xsl:param name="index" />
		<xsl:choose>
			<xsl:when test="OPTION-LIST/USERSTATUS/OPTION[@INDEX=$index]">
				<xsl:value-of
					select="sum(OPTION-LIST/USERSTATUS/OPTION[@INDEX=$index]/@COUNT)" />
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
       Calculating totals for each option...
       -->
	<xsl:variable name="poll_count1">
		<xsl:apply-templates mode="poll_count" select="/H2G2/POLL-LIST/POLL">
			<xsl:with-param name="index">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="poll_count2">
		<xsl:apply-templates mode="poll_count" select="/H2G2/POLL-LIST/POLL">
			<xsl:with-param name="index">2</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="poll_count3">
		<xsl:apply-templates mode="poll_count" select="/H2G2/POLL-LIST/POLL">
			<xsl:with-param name="index">3</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="poll_count4">
		<xsl:apply-templates mode="poll_count" select="/H2G2/POLL-LIST/POLL">
			<xsl:with-param name="index">4</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="poll_count5">
		<xsl:apply-templates mode="poll_count" select="/H2G2/POLL-LIST/POLL">
			<xsl:with-param name="index">5</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	
	<!-- 
       Calculating the total number of votes cast 
       -->
	<xsl:variable name="votes_cast"
		select="$poll_count1 + $poll_count2 + $poll_count3 + $poll_count4 + $poll_count5" />
	
	<!-- 
       Calculating the average of all votes cast
       -->
	<xsl:variable name="poll_average_score">
		<xsl:choose>
			<xsl:when test="$votes_cast = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="format-number((($poll_count1*1) + ($poll_count2*2) + ($poll_count3*3) + ($poll_count4*4) + ($poll_count5*5)) div $votes_cast, '#.00')"
				 />
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
				<xsl:value-of
					select="format-number(($poll_count1 div $votes_cast) * 100, '#.00')"
				 />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="option2percent">
		<xsl:choose>
			<xsl:when test="$poll_count2 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="format-number(($poll_count2 div $votes_cast) * 100, '#.00')"
				 />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="option3percent">
		<xsl:choose>
			<xsl:when test="$poll_count3 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="format-number(($poll_count3 div $votes_cast) * 100, '#.00')"
				 />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="option4percent">
		<xsl:choose>
			<xsl:when test="$poll_count4 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="format-number(($poll_count4 div $votes_cast) * 100, '#.00')"
				 />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="option5percent">
		<xsl:choose>
			<xsl:when test="$poll_count5 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="format-number(($poll_count5 div $votes_cast) * 100, '#.00')"
				 />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Trent Williams
			 Use: show average vote text and buttons 
		-->
	<xsl:template match="/H2G2/POLL-LIST/POLL/OPTION-LIST" mode="average_vote">
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="middle">
					<div class="articleratingdots2">average rating from <xsl:value-of
							select="$votes_cast" /> member<xsl:if
							test="$votes_cast &gt; 1">s</xsl:if>&nbsp;</div>
				</td>
				<td>
					<div class="articleratingdots2">
						<xsl:choose>
							<xsl:when test="$poll_average_score &gt; 0.2">
								<xsl:choose>
									<xsl:when test="$poll_average_score &gt; 0.6">
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_on_w.gif"
											width="11" />
									</xsl:when>
									<xsl:otherwise>
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_onhalf_w.gif"
											width="11" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" border="0" height="11"
									src="{$imagesource}furniture/drama/btn_off_w.gif" width="11"
								 />
							</xsl:otherwise>
						</xsl:choose> &nbsp; <xsl:choose>
							<xsl:when test="$poll_average_score &gt; 1.2">
								<xsl:choose>
									<xsl:when test="$poll_average_score &gt; 1.6">
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_on_w.gif"
											width="11" />
									</xsl:when>
									<xsl:otherwise>
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_onhalf_w.gif"
											width="11" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" border="0" height="11"
									src="{$imagesource}furniture/drama/btn_off_w.gif" width="11"
								 />
							</xsl:otherwise>
						</xsl:choose> &nbsp; <xsl:choose>
							<xsl:when test="$poll_average_score &gt; 2.2">
								<xsl:choose>
									<xsl:when test="$poll_average_score &gt; 2.6">
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_on_w.gif"
											width="11" />
									</xsl:when>
									<xsl:otherwise>
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_onhalf_w.gif"
											width="11" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" border="0" height="11"
									src="{$imagesource}furniture/drama/btn_off_w.gif" width="11"
								 />
							</xsl:otherwise>
						</xsl:choose> &nbsp; <xsl:choose>
							<xsl:when test="$poll_average_score &gt; 3.2">
								<xsl:choose>
									<xsl:when test="$poll_average_score &gt; 3.6">
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_on_w.gif"
											width="11" />
									</xsl:when>
									<xsl:otherwise>
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_onhalf_w.gif"
											width="11" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" border="0" height="11"
									src="{$imagesource}furniture/drama/btn_off_w.gif" width="11"
								 />
							</xsl:otherwise>
						</xsl:choose> &nbsp; <xsl:choose>
							<xsl:when test="$poll_average_score &gt; 4.2">
								<xsl:choose>
									<xsl:when test="$poll_average_score &gt; 4.6">
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_on_w.gif"
											width="11" />
									</xsl:when>
									<xsl:otherwise>
										<img alt="" border="0" height="11"
											src="{$imagesource}furniture/drama/btn_onhalf_w.gif"
											width="11" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" border="0" height="11"
									src="{$imagesource}furniture/drama/btn_off_w.gif" width="11"
								 />
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>

</xsl:stylesheet>