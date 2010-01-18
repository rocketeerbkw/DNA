<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="ARTICLE">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLE</xsl:with-param>
		<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<div id="memory">
			<xsl:attribute name="class">
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/TYPEOFARTICLE"/>
			</xsl:attribute>
      
      			<div id="topPage">			
				<div class="clr"><hr/></div>
			</div>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_fromedit']">
					<div id="topPage">
						<h2>Thank you</h2>
					</div>
					<div class="tear"><hr/></div>		

					<div class="padWrapper">
						<div class="inner3_4">
							Thank you for your contribution to Memoryshare. If you want to you can add another memory, search for other people's memories or see your own contributions by clicking on one of the links below.
							<br/>
							<br/>
							<a href="{$root}TypedArticle?acreate=new" target="_top">Add another memory</a>
							|
							<a href="{$root}/ArticleSearch?contenttype=-1&amp;hrase=_memory&amp;show=10" target="_top">View memories</a>
							|
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="concat($root, 'U', /H2G2/VIEWING-USER/USER/USERID)"/>
								</xsl:attribute>
								<xsl:text>View your memories</xsl:text>
							</a>
							
							<form id="subscribeForm" onsubmit="return checkEmail('subscribe_email')" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" method="post" name="form1">
								<fieldset>
									<input type="hidden" value="{$host}{$root}newslettersubthanks" name="success"/>
									<input type="hidden" value="Newsletter" name="heading"/>
									<input type="hidden" value="subscribe" name="option"/>
									<legend>
										<acronym id="newsletter" title="Newsletter">Subscribe to the Memoryshare newsletter</acronym>
									</legend>
									<label for="subscribe_email">
										<br/>
										Sign up for the Memoryshare newsletter and we'll keep you up to date with all the most important developments on the service and on the calls for memories from BBC programmes. It's not a regular newsletter so we promise to only send one out when we've actually have something worth saying. It may include information about other BBC services, links or events we think might be of interest to you. 
										<br/>
										<br/>
										<b>The BBC won?t contact you for marketing purposes, or promote new services to you unless you specifically agree to be contacted for these purposes.</b>
										<br/>
										<br/>
										To subscribe to the Memoryshare newsletter, please type in your email address below and click the subscribe button.
										<br/>
									</label>
									<br/>
									<input id="subscribe_email" class="txt" type="text" name="email"/>
									<input class="submit" type="submit" value="Subscribe" name="Submit"/>
								</fieldset>
							</form>
							<form id="UnsubscribeForm" onsubmit="return checkEmail('unsubscribe_email')" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" method="post" name="form1">
								<fieldset>
									<input type="hidden" value="{$host}{$root}newsletterunsubthanks" name="success"/>
									<input type="hidden" value="Newsletter" name="heading"/>
									<input type="hidden" value="unsubscribe" name="option"/>
									<legend>Unsubscribe from the Memoryshare newsletter</legend>
									<label for="unsubscribe_email">
										<br/>
										To unsubscribe from the Memoryshare newsletter, please type in your email address and click the unsubscribe button.
										<br/>
									</label>
									<br/>
									<input id="unsubscribe_email" class="txt" type="text" name="email"/>
									<input class="submit" type="submit" value="Unsubscribe" name="Submit"/>
								</fieldset>
							</form>
						</div>
					</div>
					
					<div class="barStrong"><div class="clr"><hr/></div></div>
    				
					<xsl:call-template name="SEARCH_RSS_FEED"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_confirm_del']/VALUE=1">
							<div class="pageOpen">
								<div class="inner">
									<div class="inner2">
										<!-- title of memory -->
										<h2><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></h2>

										<h3>
											<!-- author link-->
											<xsl:call-template name="ARTICLE_AUTHOR"/>
											
											<!-- date -->
											<xsl:call-template name="ARTICLE_DATE"/>
										</h3>
										<p>
										Are you sure you want to delete this memory?
										</p>
										<p>
											<a href="{$root}Edit?id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;cmd=delete">Yes</a>
											<xsl:text> </xsl:text>
											<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">No</a>
										</p>
									</div>
								</div>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="pageOpen">
								<div class="inner">
									<div class="inner2">
                        				<!-- client logo -->
                        				<xsl:if test="$article_show_client_logo = 'yes'">
                        					<xsl:variable name="article_client">
                        						<xsl:choose>
                        							<xsl:when test="/H2G2/ARTICLE/GUIDE/CLIENT/text() = concat($client_keyword_prefix, 'vanilla')">
                        								<xsl:value-of select="$vanilla_client"/>
                        							</xsl:when>
                        							<xsl:otherwise>
                        								<xsl:value-of select="substring-after(/H2G2/ARTICLE/GUIDE/CLIENT/text(), $client_keyword_prefix)"/>
                        							</xsl:otherwise>
                        						</xsl:choose>
                        					</xsl:variable>
                        					<xsl:variable name="article_visibletag" select="msxsl:node-set($clients)/list/item[client=$article_client]/visibletag"/>
                        					<xsl:variable name="article_visibletag_url_escaped">
                        						<xsl:call-template name="URL_ESCAPE">
                        							<xsl:with-param name="s" select="$article_visibletag"/>
                        						</xsl:call-template>
                        					</xsl:variable>
                        					<xsl:variable name="article_logo1" select="msxsl:node-set($clients)/list/item[client=$article_client]/logo1"/>
                        					<div id="clientLogo">
                        						<p>Memory from</p>
                        						<a href="{$articlesearchroot}&amp;phrase=%22{$article_visibletag_url_escaped}%22&amp;phrase={$client_keyword_prefix}{$article_client}"><img src="{$imagesource}{$article_logo1}" alt="{$article_visibletag}"/></a>
                        					</div>
                        				</xsl:if>
                        				
										<!-- title of memory -->
										<h2>
											<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
										</h2>
										
                      					<h3>
                        					<!-- author link-->
                        					<xsl:call-template name="ARTICLE_AUTHOR"/>
                        					
                        					<!-- date -->
                        					<xsl:call-template name="ARTICLE_DATE"/>
                      					</h3>
                      					
                        				<!-- content -->
										<p>
											<xsl:variable name="body_rendered">
												<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
											</xsl:variable>
											<xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
										</p>
										
										<!--start embedded mediaasset -->
										<xsl:if test="$typedarticle_embed = 'yes' and ($typedarticle_embed_admin_only = 'no' or $test_MediaAssetOwnerIsHost)">
											<xsl:choose>
												<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
													<xsl:if test="/H2G2/MEDIAASSET and /H2G2/MEDIAASSET/EXTRAELEMENTXML/EXTERNALLINKURL and /H2G2/MEDIAASSET/EXTRAELEMENTXML/EXTERNALLINKURL != ''">
														<p>
															<img src="{$imagesource}mediaassetPlaceholder.gif" alt="Embedded Media"/>
														</p>
														<!--
														<p>
															<xsl:value-of select="/H2G2/MEDIAASSET/EXTRAELEMENTXML/EXTERNALLINKURL"/>
														</p>
														-->
													</xsl:if>
												</xsl:when>
												<xsl:otherwise>
													<xsl:variable name="externallinktype" select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKTYPE"/>
													
													<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET and $externallinktype != 'Unknown' and $externallinktype != ''">
														<xsl:choose>
															<xsl:when test="$externallinktype = 'YouTube'">
																<xsl:variable name="mediaasset_url">
																	<xsl:value-of select="$youtube_base_url"/>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID"/>
																	<xsl:text>&amp;rel=0</xsl:text><!-- hides related videos at the end -->
																</xsl:variable>
																<div id="mediaasset">
																	<script language="JavaScript" type="text/javascript">
																		insertFlashVideo('<xsl:value-of select="$mediaasset_url"/>', 400, 329);
																	</script>
																</div>
															</xsl:when>
															<xsl:when test="$externallinktype = 'Google'">
																<xsl:variable name="mediaasset_url">
																	<xsl:value-of select="$googlevideo_base_url"/>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID"/>
																	<xsl:text>&amp;hl=en</xsl:text>
																</xsl:variable>
																<div id="mediaasset">
																	<script language="JavaScript" type="text/javascript">
																		insertFlashVideo('<xsl:value-of select="$mediaasset_url"/>', 400, 326);
																	</script>
																</div>
															</xsl:when>
															<xsl:when test="$externallinktype = 'MySpace'">
																<xsl:variable name="mediaasset_url">
																	<xsl:value-of select="$myspacevideo_base_url"/>
																</xsl:variable>
																<xsl:variable name="mediaasset_flashvars">
																	<xsl:text>m=</xsl:text>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKID"/>
																	<xsl:text>&amp;type=video&amp;cp=1</xsl:text>
																</xsl:variable>
																<div id="mediaasset">
																	<script language="JavaScript" type="text/javascript">
																		insertFlashVideo('<xsl:value-of select="$mediaasset_url"/>', 430, 322, '<xsl:value-of select="$mediaasset_flashvars"/>');
																	</script>
																</div>
															</xsl:when>
															<xsl:when test="$externallinktype = 'Flickr'">
																<xsl:variable name="mediaasset_url">
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/FLICKR/FARMPATH"/>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/FLICKR/SERVER"/>
																	<xsl:text>/</xsl:text>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/FLICKR/ID"/>
																	<xsl:text>_</xsl:text>
																	<xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/FLICKR/SECRET"/>
																	<!--
																	<xsl:text>_m</xsl:text>
																	-->
																	<xsl:choose>
																		<xsl:when test="contains(/H2G2/MEDIAASSETINFO/MEDIAASSET/EXTERNALLINKURL, '.gif')">.gif</xsl:when>
																		<xsl:otherwise>.jpg</xsl:otherwise>
																	</xsl:choose>
																</xsl:variable>
																<a>
																	<xsl:attribute name="href">
																		<xsl:value-of select="$mediaasset_url"/>
																	</xsl:attribute>
																	<img>
																		<xsl:attribute name="src">
																			<xsl:value-of select="$mediaasset_url"/>
																		</xsl:attribute>
																	</img>
																</a>
															</xsl:when>
														</xsl:choose>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<!--end embedded mediaasset -->

									</div>
								</div>
							</div>

							<div class="memorySummary">
								<dl>
									<!-- date created and last edited -->
									<dt>This memory was added on:</dt>
									<dd>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" />
										<xsl:text>/</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTH" />
										<xsl:text>/</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" />
									</dd>
									<dt>Last updated:</dt>
									<dd>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@DAY" />
										<xsl:text>/</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@MONTH" />
										<xsl:text>/</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@YEAR" />
										<xsl:text> </xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@HOURS" />
										<xsl:text>:</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@MINUTES" />
										<xsl:text>:</xsl:text>
										<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE/@SECONDS" />
									</dd>

									<!-- location -->
									<dt>Location:</dt>
									<dd>
										<xsl:call-template name="SPLIT_KEYWORDS_INTO_LINKS">
											<xsl:with-param name="s" select="/H2G2/ARTICLE/GUIDE/LOCATION"/>
										</xsl:call-template>
										
										<xsl:text> </xsl:text>
										
										<xsl:if test="/H2G2/ARTICLE/GUIDE/LOCATIONUSER/text()">
											<xsl:call-template name="SPLIT_KEYWORDS_INTO_LINKS">
												<xsl:with-param name="s" select="/H2G2/ARTICLE/GUIDE/LOCATIONUSER"/>
											</xsl:call-template>
										</xsl:if>
									</dd>
									<br/>
									<!-- keywords -->
									<dt>Keywords:</dt>
									<dd>
                      					<xsl:choose>
											<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
												<!-- in preview mode act on the keywords guide entry as system has not yet parsed it into a PHRASES node -->
												<xsl:call-template name="SPLIT_KEYWORDS_INTO_LINKS">
													<xsl:with-param name="s" select="/H2G2/ARTICLE/GUIDE/KEYWORDS"/>
												</xsl:call-template>
												<xsl:if test="$typedarticle_visibletag = 'yes'">
													<xsl:text> </xsl:text>
													<xsl:call-template name="SPLIT_KEYWORDS_INTO_LINKS">
														<xsl:with-param name="s" select="/H2G2/ARTICLE/GUIDE/VISIBLECLIENT"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="RELATED_TAGS" />
											</xsl:otherwise>
										</xsl:choose>
									</dd>
								</dl>
							</div>

							<div class="padWrapper">
								<xsl:if test="not(/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'])">
									<p class="commentOptions">
										<!-- comment -->
										<xsl:if test="/H2G2/@TYPE='ARTICLE'">
											<a href="#commentbox" id="commentTextBoxLink">Comment on this memory</a>
										</xsl:if>

										<!-- complain and house rules-->
										<!-- currently cannot complain about staff articles -->
										<xsl:if test="/H2G2/@TYPE='ARTICLE'">
											<xsl:text> | </xsl:text>
											<a>
												<xsl:attribute name="href">
													<xsl:value-of select="concat($root, 'houserules')"/>
												</xsl:attribute>
												<xsl:text>House rules</xsl:text>
											</a>
											<xsl:if test="$article_subtype != 'staff_memory' or $article_allow_complain_about_host = 'yes'">
												<xsl:text> | </xsl:text>
												<a href="{$root}comments/UserComplaintPage?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_start=1" target="ComplaintPopup" onclick="popupwindow('{$root}UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=588,height=560')">
													<xsl:text>Complain about this memory</xsl:text>
												</a>
											</xsl:if>
										</xsl:if>

										<!-- edit -->
										<!-- only person that can edit the article is the article's owner -->
										<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE'">
											<xsl:text> | </xsl:text>
											<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
												<xsl:text>Edit memory</xsl:text>
											</a>
										</xsl:if>
										
										<!-- only person that can edit the media asset is the article's owner -->
										<xsl:if test="$article_edit_media_asset = 'yes'"> 
											<xsl:if test="$typedarticle_embed = 'yes' and ($typedarticle_embed_admin_only = 'no' or $test_IsAdminUser) and /H2G2/MEDIAASSETINFO/MEDIAASSET">
												<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE'">
													<xsl:text> | </xsl:text>
													<a href="{$root}MediaAsset?action=update&amp;id={/H2G2/MEDIAASSETINFO/ID}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;externallink=1">
														<xsl:text>Edit media asset</xsl:text>
													</a>
												</xsl:if>
											</xsl:if>
										</xsl:if>

										<!-- delete -->
										<!-- can only delete if user is the memories author or they are admin user -->
										<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE' or $test_IsAdminUser">
											<xsl:text> | </xsl:text>
											<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_confirm_del=1">
												<xsl:text>Delete memory</xsl:text>
											</a>
										</xsl:if>
									</p>
								</xsl:if>
								
								<!-- social bookmarking links -->
								<xsl:call-template name="SOCIAL_LINKS">
									<xsl:with-param name="url">
										<xsl:value-of select="concat($host, $root, 'A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
									</xsl:with-param>
									<xsl:with-param name="title">
										<xsl:value-of select="$m_pagetitlestart"/>
										<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
									</xsl:with-param>
								</xsl:call-template>

								<!-- comments  -->
								<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS"/>

								<!-- add a comment -->
								<xsl:call-template name="COMMENT_ON_ARTICLE" />

								<div class="barStrong"></div>
								
								<div id="articleContext">
									<xsl:call-template name="CONTEXT_INCLUDE">
										<xsl:with-param name="mode">ARTICLE</xsl:with-param>
									</xsl:call-template>
								</div>
							</div>

							<!-- rss link -->
							<xsl:call-template name="FORUM_RSS_FEED"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="ARTICLE_AUTHOR">
		<xsl:choose>
			<xsl:when test="$test_IsCeleb = 1">
				<!--this is a celebrity artcile-->
				BBC 
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW']">
						<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME and /H2G2/VIEWING-USER/USER/USERNAME != ''">
									<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
								</xsl:when>
								<xsl:otherwise>
									U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
							<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> on behalf of </xsl:text>
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/ALTNAME" />
			</xsl:when>
			<xsl:otherwise>
				<!--this is not a celebrity article-->
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW']">
						<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME and /H2G2/VIEWING-USER/USER/USERNAME != ''">
									<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
								</xsl:when>
								<xsl:otherwise>
									U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
							<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ARTICLE_STARTDAY">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGESTART">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@DAY" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTDAY and /H2G2/ARTICLE/EXTRAINFO/STARTDAY != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/STARTDAY" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTDATE and /H2G2/ARTICLE/EXTRAINFO/STARTDATE != ''">
				<xsl:call-template name="PARSE_DATE_DAY">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/STARTDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ARTICLE_STARTMONTH">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGESTART">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@MONTH" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTMONTH and /H2G2/ARTICLE/EXTRAINFO/STARTMONTH != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/STARTMONTH" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTDATE and /H2G2/ARTICLE/EXTRAINFO/STARTDATE != ''">
				<xsl:call-template name="PARSE_DATE_MONTH">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/STARTDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ARTICLE_STARTYEAR">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGESTART">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@YEAR" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTYEAR and /H2G2/ARTICLE/EXTRAINFO/STARTYEAR != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/STARTYEAR" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/STARTDATE and /H2G2/ARTICLE/EXTRAINFO/STARTDATE != ''">
				<xsl:call-template name="PARSE_DATE_YEAR">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/STARTDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ARTICLE_ENDDAY">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGEEND">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@DAY" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDDAY and /H2G2/ARTICLE/EXTRAINFO/ENDDAY != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/ENDDAY" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDDATE and /H2G2/ARTICLE/EXTRAINFO/ENDDATE != ''">
				<xsl:call-template name="PARSE_DATE_DAY">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/ENDDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ARTICLE_ENDMONTH">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGEEND">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@MONTH" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDMONTH and /H2G2/ARTICLE/EXTRAINFO/ENDMONTH != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/ENDMONTH" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDDATE and /H2G2/ARTICLE/EXTRAINFO/ENDDATE != ''">
				<xsl:call-template name="PARSE_DATE_MONTH">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/ENDDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ARTICLE_ENDYEAR">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/DATERANGEEND">
				<xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@YEAR" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDYEAR and /H2G2/ARTICLE/EXTRAINFO/ENDYEAR != 0">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/ENDYEAR" />
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/ENDDATE and /H2G2/ARTICLE/EXTRAINFO/ENDDATE != ''">
				<xsl:call-template name="PARSE_DATE_YEAR">
					<xsl:with-param name="date" select="/H2G2/ARTICLE/EXTRAINFO/ENDDATE"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ARTICLE_TIMEINTERVAL">
		<!--
		<xsl:if test="($startdate and $startdate != '') or ($startday and $startday != '')">
		-->
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLE/TIMEINTERVAL">
					<xsl:value-of select="/H2G2/ARTICLE/TIMEINTERVAL" />
				</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TIMEINTERVAL">
					<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TIMEINTERVAL" />
				</xsl:when>
			</xsl:choose>
		<!--
		</xsl:if>
		-->
	</xsl:template>
	
	<xsl:template name="ARTICLE_DATE_RANGE_TYPE">
		<xsl:if test="/H2G2/ARTICLE/DATERANGESTART or /H2G2/ARTICLE/EXTRAINFO/STARTDAY or /H2G2/ARTICLE/EXTRAINFO/STARTDATE">
			<xsl:variable name="startday">
				<xsl:call-template name="ARTICLE_STARTDAY"/>
			</xsl:variable>

			<xsl:variable name="startmonth">
				<xsl:call-template name="ARTICLE_STARTMONTH"/>
			</xsl:variable>

			<xsl:variable name="startyear">
				<xsl:call-template name="ARTICLE_STARTYEAR"/>
			</xsl:variable>

			<xsl:variable name="endday">
				<xsl:call-template name="ARTICLE_ENDDAY"/>
			</xsl:variable>

			<xsl:variable name="endmonth">
				<xsl:call-template name="ARTICLE_ENDMONTH"/>
			</xsl:variable>

			<xsl:variable name="endyear">
				<xsl:call-template name="ARTICLE_ENDYEAR"/>
			</xsl:variable>

			<xsl:variable name="timeinterval">
				<xsl:call-template name="ARTICLE_TIMEINTERVAL"/>
			</xsl:variable>

			<xsl:call-template name="GET_DATE_RANGE_TYPE">
				<xsl:with-param name="startday" select="$startday" />
				<xsl:with-param name="startmonth" select="$startmonth" />
				<xsl:with-param name="startyear" select="$startyear" />
				<xsl:with-param name="endday" select="$endday" />
				<xsl:with-param name="endmonth" select="$endmonth" />
				<xsl:with-param name="endyear" select="$endyear" />
				<xsl:with-param name="timeinterval" select="$timeinterval" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="ARTICLE_DATE">
		<xsl:if test="/H2G2/ARTICLE/DATERANGESTART or /H2G2/ARTICLE/EXTRAINFO/STARTDAY or /H2G2/ARTICLE/EXTRAINFO/STARTDATE">
			<xsl:variable name="startday">
				<xsl:call-template name="ARTICLE_STARTDAY"/>
			</xsl:variable>

			<xsl:variable name="startmonth">
				<xsl:call-template name="ARTICLE_STARTMONTH"/>
			</xsl:variable>

			<xsl:variable name="startyear">
				<xsl:call-template name="ARTICLE_STARTYEAR"/>
			</xsl:variable>

			<xsl:variable name="endday">
				<xsl:call-template name="ARTICLE_ENDDAY"/>
			</xsl:variable>

			<xsl:variable name="endmonth">
				<xsl:call-template name="ARTICLE_ENDMONTH"/>
			</xsl:variable>

			<xsl:variable name="endyear">
				<xsl:call-template name="ARTICLE_ENDYEAR"/>
			</xsl:variable>

			<xsl:variable name="timeinterval">
				<xsl:call-template name="ARTICLE_TIMEINTERVAL"/>
			</xsl:variable>

			<xsl:call-template name="MEMORY_DATE">
				<xsl:with-param name="startday" select="$startday" />
				<xsl:with-param name="startmonth" select="$startmonth" />
				<xsl:with-param name="startyear" select="$startyear" />
				<xsl:with-param name="endday" select="$endday" />
				<xsl:with-param name="endmonth" select="$endmonth" />
				<xsl:with-param name="endyear" select="$endyear" />
				<xsl:with-param name="timeinterval" select="$timeinterval" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="MEMORY_DATE">
		<xsl:param name="startdate"></xsl:param>
		<xsl:param name="startday"></xsl:param>
		<xsl:param name="startmonth"></xsl:param>
		<xsl:param name="startyear"></xsl:param>
		<xsl:param name="enddate"></xsl:param>
		<xsl:param name="endday"></xsl:param>
		<xsl:param name="endmonth"></xsl:param>
		<xsl:param name="endyear"></xsl:param>
		<xsl:param name="timeinterval"></xsl:param>
		<xsl:param name="mode">DETAIL</xsl:param>

		<xsl:variable name="date_range_type">
			<xsl:call-template name="GET_DATE_RANGE_TYPE">
				<xsl:with-param name="startdate" select="$startdate" />
				<xsl:with-param name="startday" select="$startday" />
				<xsl:with-param name="startmonth" select="$startmonth" />
				<xsl:with-param name="startyear" select="$startyear" />
				<xsl:with-param name="enddate" select="$enddate" />
				<xsl:with-param name="endday" select="$endday" />
				<xsl:with-param name="endmonth" select="$endmonth" />
				<xsl:with-param name="endyear" select="$endyear" />
				<xsl:with-param name="timeinterval" select="$timeinterval" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$date_range_type = 1">
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text>'s memory of </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory of </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<a href="{$articlesearchroot}&amp;startdate={$startday}/{$startmonth}/{$startyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:value-of select="$startday" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear" />
				</a>
			</xsl:when>
			<xsl:when test="$date_range_type = 2">
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text>'s memory of </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory of </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<a href="{$articlesearchroot}&amp;startdate={$startday}/{$startmonth}/{$startyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:value-of select="$startday" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear" />
				</a>
				<xsl:text> - </xsl:text>
				<a href="{$articlesearchroot}&amp;startdate={$endday}/{$endmonth}/{$endyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:value-of select="$endday" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear" />
				</a>
			</xsl:when>
			<xsl:when test="$date_range_type = 3">
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text>'s memory of </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory of </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$timeinterval" />
				<xsl:text> day</xsl:text>
				<xsl:if test="$timeinterval &gt; 1">
					<xsl:text>s</xsl:text>
				</xsl:if>
				<xsl:text> between </xsl:text>
				<a href="{$articlesearchroot}&amp;startdate={$startday}/{$startmonth}/{$startyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:value-of select="$startday" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startmonth" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$startyear" />
				</a>
				<xsl:text> and </xsl:text>
				<a href="{$articlesearchroot}&amp;startdate={$endday}/{$endmonth}/{$endyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:value-of select="$endday" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endmonth" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="$endyear" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>'s memory. No date </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- EDITORIAL_ARTICLE used for creating named articles:
	dynamic list pages: type = 1
	houserules: type = 2
	searchhelp: type = 3
	-->
	<xsl:template name="EDITORIAL_ARTICLE">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">EDITORIAL_ARTICLE</xsl:with-param>
		<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

    <div id="topPage">
      <h2>
        <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
      </h2>
    </div>
    <div class="tear"><hr /></div>
    

		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTROTEXT"/>

		<!--[FIXME: remove?]	
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and $current_article_type=3">
			<xsl:call-template name="ADVANCED_SEARCH" />
			<br />
		</xsl:if>
		-->

    <div class="padWrapper">
      <div class="inner3_4">
        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
      </div>
    </div>
    <div class="barStrong"><div class="clr"><hr /></div></div>

    <xsl:call-template name="SEARCH_RSS_FEED"/>
    
		<!--[FIXME: remove?]	
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and not($current_article_type=3)">
			<xsl:call-template name="ADVANCED_SEARCH" />
		</xsl:if>
		-->
	</xsl:template>

	<xsl:template name="RELATED_TAGS">
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/PHRASES/@COUNT">
		  <xsl:for-each select="/H2G2/PHRASES/PHRASE">
			  <xsl:if test="not(starts-with(NAME, '_')) and not(NAME = 'user_memory') and not(NAME = 'staff_memory')">
          		  <a href="{$articlesearchroot}&amp;phrase={TERM}">
				    <xsl:value-of select="NAME"/>
			    </a>
          <xsl:text> </xsl:text>
          <!--
          [FIXME: might need to put comma spaces between keywords, but it's complicated so I'm going to leave it for now]
          <xsl:if test="following-sibling::node()/">
            <xsl:text>, </xsl:text>            
          </xsl:if>
          -->
			  </xsl:if>
		  </xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template name="RELATED_META_KEYWORDS">
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/PHRASES/@COUNT">
			<div class="rellinks" id="relatedtags">
				<h3>Related keywords</h3>

				<ul>
					<xsl:for-each select="/H2G2/PHRASES/PHRASE">
						<xsl:if test="not(starts-with(TERM, '_'))">
							<li>
								<a href="{$articlesearchroot}&amp;phrase={TERM}">
									<xsl:value-of select="TERM"/>
								</a>
							</li>
						</xsl:if>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template name="RELATED_DYNAMIC_LISTS">
		<h3>RELATED CONTENT</h3>
	</xsl:template>
	-->

	<xsl:template name="COMMENT_ON_ARTICLE">
    <xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@DEFAULTCANWRITE=1">
      <!-- don't display in typedarticle as breaks submit button -->
      <a name="commentbox"></a>
      <div class="barStrong">
        <h3>Please add a comment</h3>
      </div>
      <div class="inner">
        <xsl:choose>
          <xsl:when test="/H2G2/SITE-CLOSED=0 or $test_IsEditor">
            <xsl:choose>
              <xsl:when test="/H2G2/VIEWING-USER/USER">
                <!-- display textarea for commenting if signed in -->
                <p>
                  Your comment must adhere to <a href="#">House rules</a>
                </p>
                <form method="post" action="{$root}AddThread" name="theForm" id="addCommentForm"> 
                  <xsl:choose>
                    <xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT=0">
                      <input type="hidden" name="threadid" value="0"/>
                      <input type="hidden" name="inreplyto" value="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" name="threadid" value="{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}"/>
                      <input type="hidden" name="inreplyto" value="{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@POSTID}"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="forum" value="{ARTICLEINFO/FORUMID}"/>
                  <input type="hidden" name="action" value="A{ARTICLEINFO/H2G2ID}"/>
                  <input type="hidden" name="subject" value="{SUBJECT}"/>
                    <textarea wrap="virtual" name="body" id="commentTextBox" class="inputone" rows="5"></textarea><br />
                  <p class="rAlign">
                    <input type="submit" value="Preview" name="preview" class="submit" />
                    <input type="submit" value="Publish" name="post" class="submit" />
                  </p>
                </form>
              </xsl:when>
              <xsl:otherwise>
                <!-- must sign in to comment -->
                <p>
                  <a href="{$sso_signinlink}" class="strong">Sign in if you want to comment</a>
                </p>
              </xsl:otherwise>
            </xsl:choose>


            <hr class="section" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="siteclosed" />
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
	</xsl:template>
	
	<!-- RSS FEED LINK -->
	<xsl:template name="FORUM_RSS_FEED_META">
		<link rel="alternative" type="application/rdf+xml">
			<xsl:attribute name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
				<xsl:text> - </xsl:text>
				<xsl:text>Latest comments</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="$feedroot"/>
				<xsl:text>xml/F</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID"/>
				<xsl:text>&amp;thread=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD"/>
				<xsl:text>&amp;s_xml=</xsl:text>
				<xsl:value-of select="$rss_param"/>
				<xsl:text>&amp;s_client='</xsl:text>
				<xsl:value-of select="$client"/>
				<xsl:text>&amp;show='</xsl:text>
				<xsl:value-of select="$rss_show"/>
			</xsl:attribute>
		</link>
	</xsl:template>
	
	<xsl:template name="FORUM_RSS_FEED">
		<xsl:variable name="url">
			<xsl:value-of select="$feedroot"/>
			<xsl:text>xml/F</xsl:text>
			<xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID"/>
			<xsl:text>&amp;thread=</xsl:text>
			<xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD"/>
			<xsl:text>&amp;s_xml=</xsl:text>
			<xsl:value-of select="$rss_param"/>
			<xsl:text>&amp;s_client='</xsl:text>
			<xsl:value-of select="$client"/>
			<xsl:text>&amp;show='</xsl:text>
			<xsl:value-of select="$rss_show"/>
		</xsl:variable>

		<p id="rssBlock">
			<a href="{$url}" class="rssLink" id="rssLink">
				<xsl:text>Latest comments </xsl:text>
			</a>
			<xsl:text> | </xsl:text>
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/rsshelp"/>
				</xsl:attribute>
				<xsl:text>What is RSS?</xsl:text>
			</a>
      			<xsl:text> | </xsl:text>
			<a href="{$root}help#feeds">
				<xsl:text>Memoryshare RSS feeds</xsl:text>
			</a>
		</p>
	</xsl:template>
</xsl:stylesheet>
