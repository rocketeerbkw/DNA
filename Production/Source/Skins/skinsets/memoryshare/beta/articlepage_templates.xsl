<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">
	<xsl:template name="ARTICLE">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLE</xsl:with-param>
		<xsl:with-param name="pagename">articlepage_templates.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<xsl:variable name="inDeleteMode">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_confirm_del']/VALUE=1">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="memoryDayName">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLE/DATERANGESTART/DATE/@DAYNAME and DATERANGESTART/DATE/@DAYNAME != ''">
					<xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@DAYNAME" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLE/DATECREATED/DATE/@DAYNAME" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:comment>
			<xsl:value-of select="$memoryDayName" />
		</xsl:comment>

		<xsl:variable name="memoryDayNumber">
			<xsl:choose>
				<xsl:when test="$memoryDayName = 'Monday'">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Tuesday'">
					<xsl:text>2</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Wednesday'">
					<xsl:text>3</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Thursday'">
					<xsl:text>4</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Friday'">
					<xsl:text>5</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Saturday'">
					<xsl:text>6</xsl:text>
				</xsl:when>
				<xsl:when test="$memoryDayName = 'Sunday'">
					<xsl:text>7</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>1</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="noQuotes">
			<xsl:if test="/H2G2/ARTICLE/SUBJECT != ''">
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s">
						<xsl:value-of select="/H2G2/ARTICLE/SUBJECT" />
					</xsl:with-param>
					<xsl:with-param name="what">"</xsl:with-param>
					<xsl:with-param name="replacement"></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="noOpenBrackets">
			<xsl:if test="$noQuotes != ''">
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s">
						<xsl:value-of select="$noQuotes" />
					</xsl:with-param>
					<xsl:with-param name="what">(</xsl:with-param>
					<xsl:with-param name="replacement"></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="noCloseBrackets">
			<xsl:if test="$noOpenBrackets != ''">
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s">
						<xsl:value-of select="$noOpenBrackets" />
					</xsl:with-param>
					<xsl:with-param name="what">)</xsl:with-param>
					<xsl:with-param name="replacement"></xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="memoryStartLetter">
			<xsl:choose>
				<xsl:when test="$noCloseBrackets != ''">
					<xsl:value-of select="translate(substring($noCloseBrackets,1,1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>t</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

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

		<xsl:variable name="clientSearchUrl">
			<xsl:value-of select="$articlesearchroot" />
			<xsl:text>&amp;phrase=%22</xsl:text>
			<xsl:value-of select="$article_visibletag_url_escaped" />
			<xsl:text>%22&amp;phrase=</xsl:text>
			<xsl:value-of select="$client_keyword_prefix" />
			<xsl:value-of select="$article_client" />
		</xsl:variable>
		
		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[
			var clientSearchUrl = "</xsl:text>
			<xsl:value-of select="$clientSearchUrl" />
			<xsl:text disable-output-escaping="yes">";
			//]]&gt;
			</xsl:text>
		</script>
		
		<div id="ms-memory">
			<div id="ms-memory-left">
				<div id="ms-memory-content">
					<xsl:attribute name="class">
						<xsl:text>dow-</xsl:text>
						<xsl:value-of select="$memoryDayNumber" />
					</xsl:attribute>
					<xsl:if test="$inDeleteMode = '1'">
						<xsl:attribute name="style">
							<xsl:text>min-height:130px;</xsl:text>
						</xsl:attribute>						
					</xsl:if>
				  <div id="ms-memory-content-header">
					<div id="ms-memory-lrg-icon">
					  <xsl:element name="span">
						  <xsl:attribute name="class">
							  <xsl:text>dow-</xsl:text>
							  <xsl:value-of select="$memoryDayNumber" />
							  <xsl:text>-large-</xsl:text>
							  <xsl:value-of select="$memoryStartLetter" />
						  </xsl:attribute>
						  <xsl:comment> icon </xsl:comment>
					  </xsl:element>
					</div>
					<!-- title of memory -->
					<h2>
					  <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
					</h2>

					<p>
					  <!-- author link-->
					  <xsl:call-template name="ARTICLE_AUTHOR"/>

					  <!-- date -->
					  <xsl:call-template name="ARTICLE_DATE"/>
					</p>
				  </div>
				  <xsl:choose>
                      <xsl:when test="$inDeleteMode = '0'">
						<div id="ms-memory-inner-content">					  
						  <!-- content -->
						  <p class="memoryBody">
							  <xsl:variable name="body_rendered">
								  <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
							  </xsl:variable>
       						  <xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
						  </p>
						  
						  <xsl:if test="$typedarticle_embed = 'yes' and ($typedarticle_embed_admin_only = 'no' or $test_MediaAssetOwnerIsHost)">
							  <!--start embedded mediaasset -->
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
													  <xsl:text>&amp;rel=0</xsl:text>
													  <!-- hides related videos at the end -->
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
							  <!--end embedded mediaasset -->
						  </xsl:if>
							
						  <div id="ms-memory-bottom">
							  <div id="ms-memory-info">
								  <p>
									  <xsl:call-template name="AUTHOR_MORE_LINK"/>
								  </p>
								  <p>
									  This memory was added <strong>
										  <xsl:call-template name="LongDate">
											  <xsl:with-param name="day">
												  <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" />
											  </xsl:with-param>
											  <xsl:with-param name="month">
												  <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTH" />
											  </xsl:with-param>
											  <xsl:with-param name="year">
												  <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" />
											  </xsl:with-param>
										  </xsl:call-template>
									  </strong>
								  </p>
								  <p class="keywords">
									  <strong>Keywords:</strong>
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
								  </p>
							  </div>

							  <xsl:variable name="aStartDate">
								  <xsl:if test="/H2G2/ARTICLE/DATERANGESTART">
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@DAY"/>
									  <xsl:text>/</xsl:text>
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@MONTH"/>
									  <xsl:text>/</xsl:text>
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGESTART/DATE/@YEAR"/>
								  </xsl:if>
							  </xsl:variable>
							  <xsl:variable name="aEndDate">
								  <xsl:if test="/H2G2/ARTICLE/DATERANGEEND">
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@DAY"/>
									  <xsl:text>/</xsl:text>
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@MONTH"/>
									  <xsl:text>/</xsl:text>
									  <xsl:value-of select="/H2G2/ARTICLE/DATERANGEEND/DATE/@YEAR"/>
								  </xsl:if>
							  </xsl:variable>

							  <div class="add-related">
								  <div id="related-button-holder">
									  <a class="add-related-button">
										  <xsl:attribute name="href">
											  <xsl:value-of select="$root" />
											  <xsl:text>TypedArticle?acreate=new</xsl:text>
											  <xsl:text>&amp;s_memory_title=</xsl:text>
											  <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
											  <xsl:text>&amp;s_memory_keywords=</xsl:text>
											  <xsl:call-template name="KEYWORDS_COMMA_SEP" />
											  <xsl:if test="$aStartDate!=''">
												  <xsl:text>&amp;s_memory_startdate=</xsl:text>
												  <xsl:value-of select="$aStartDate"/>
												  <xsl:choose>
													  <xsl:when test="$aStartDate!=$aEndDate">
														  <xsl:text>&amp;s_memory_enddate=</xsl:text>
														  <xsl:value-of select="$aEndDate"/>
														  <xsl:text>&amp;s_datemode=Daterange</xsl:text>
													  </xsl:when>
													  <xsl:otherwise>
														  <xsl:text>&amp;s_datemode=Specific</xsl:text>
													  </xsl:otherwise>
												  </xsl:choose>
											  </xsl:if>
											  <xsl:choose>
												  <xsl:when test="/H2G2/ARTICLE/GUIDE/LOCATIONUSER != ''">
													  <xsl:text>&amp;s_memory_locationnonuk=</xsl:text>
													  <xsl:call-template name="URL_ESCAPE">
														  <xsl:with-param name="s" select="/H2G2/ARTICLE/GUIDE/LOCATIONUSER"/>
													  </xsl:call-template>
												  </xsl:when>
												  <xsl:otherwise>
													  <xsl:if test="/H2G2/ARTICLE/GUIDE/LOCATION">
														  <xsl:text>&amp;s_memory_locationuk=</xsl:text>
														  <xsl:call-template name="URL_ESCAPE">
															  <xsl:with-param name="s" select="substring-after(/H2G2/ARTICLE/GUIDE/LOCATION, ',')"/>
														  </xsl:call-template>														  
													  </xsl:if>													  
												  </xsl:otherwise>
											  </xsl:choose>
										  </xsl:attribute>
										  <span>
											  <xsl:comment> </xsl:comment>
										  </span>Add a related memory
									  </a>
								  </div>
								  <div id="ms-memory-clientl">
									  More memories from: <a href="{$clientSearchUrl}" title="{$article_client}">
										  <img src="/memoryshare/assets/images/{$article_logo1}" alt="{$article_client}" />
									  </a>
								  </div>
							  </div>
						  </div>						  
						</div>
                      </xsl:when>
                      <xsl:otherwise>
						  <div id="ms-memory-inner-content">
							  <p>
								  <xsl:text>Are you sure you want to delete this memory?</xsl:text>
								  <br/>
								  <br/>
								  <a href="{$root}Edit?id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;cmd=delete">Yes</a>
								  <xsl:text> </xsl:text>
								  <a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">No</a>								  
							  </p>
						  </div>
					  </xsl:otherwise>
				  </xsl:choose>
                  <div id="ms-memory-content-footer"><xsl:comment> ms-memory-content-footer </xsl:comment></div>
				</div>

				<xsl:if test="$inDeleteMode = '0'">
					<div id="ms-follow-memory">
						<xsl:if test="not(/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'])">
							<ul>
								<!-- complain and house rules-->
								<!-- currently cannot complain about staff articles -->
								<xsl:if test="/H2G2/@TYPE='ARTICLE'">
									<li class="first">
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="concat($root, 'houserules')"/>
											</xsl:attribute>
											<xsl:text>House rules</xsl:text>
										</a>
									</li>
									<xsl:if test="$article_subtype != 'staff_memory' or $article_allow_complain_about_host = 'yes'">
										<li>
											<a id="lnkComplain" title="Complain about this memory" href="/dna/memoryshare/comments/UserComplaintPage?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_start=1&amp;s_ptrt={$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" onclick="popupwindow('{$root}UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=800,height=600')">
												<xsl:text>Complain about this memory</xsl:text>
											</a>
										</li>
									</xsl:if>
								</xsl:if>

								<!-- edit -->
								<!-- only person that can edit the article is the article's owner -->
								<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE'">
									<li>
										<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
											<xsl:text>Edit memory</xsl:text>
										</a>
									</li>
								</xsl:if>

								<!-- only person that can edit the media asset is the article's owner -->
								<xsl:if test="$article_edit_media_asset = 'yes'">
									<xsl:if test="$typedarticle_embed = 'yes' and ($typedarticle_embed_admin_only = 'no' or $test_IsAdminUser) and /H2G2/MEDIAASSETINFO/MEDIAASSET">
										<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE'">
											<li>
												<a href="{$root}MediaAsset?action=update&amp;id={/H2G2/MEDIAASSETINFO/ID}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;externallink=1">
													<xsl:text>Edit media asset</xsl:text>
												</a>
											</li>
										</xsl:if>
									</xsl:if>
								</xsl:if>

								<!-- delete -->
								<!-- can only delete if user is the memories author or they are admin user -->
								<xsl:if test="($test_OwnerIsViewer=1) and /H2G2/@TYPE='ARTICLE' or $test_IsAdminUser">
									<li>
										<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_confirm_del=1">
											<xsl:text>Delete memory</xsl:text>
										</a>
									</li>
								</xsl:if>
							</ul>
						</xsl:if>
					</div>
				</xsl:if>

				<xsl:call-template name="feature-pod" />

			</div>
					
			<div id="ms-memory-right">
				<xsl:if test="$inDeleteMode = '0'">
					<!--  Start of right share mem pod content -->
					<div class="ms-right-pod" id="share-memory">
						<div class="ms-right-pod-top-2">
							<div class="ms-pod-content">
								<h3>Share this memory</h3>
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
							</div>
						</div>
						<div class="ms-right-pod-bottom-1"></div>
					</div>
					<!--  End of right share mem pod content -->

					<!--  Start of right pod context content -->
					<xsl:call-template name="CONTEXT_INCLUDE">
						<xsl:with-param name="mode">ARTICLE</xsl:with-param>
					</xsl:call-template>

					<!--  End of right pod context content -->
				
					<!--  Note: Related memories go here - they are generated in Javascript -->
				</xsl:if>
				<!-- client pod -->
				<xsl:call-template name="client-pod">
					<xsl:with-param name="outerDivId">client-smaller</xsl:with-param>
					<xsl:with-param name="innerDivClass">ms-right-pod-top-2</xsl:with-param>
				</xsl:call-template>
			</div>			
		</div>
		<div class="clearer"><xsl:comment> clearer </xsl:comment></div>

		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[
			var currentArticleId = "A</xsl:text>
			<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID" />
			<xsl:text disable-output-escaping="yes">";
			var fromSearchUrl = "</xsl:text>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_fromSearch']">
				<xsl:variable name="jsFromSearch">
					<xsl:if test="not(starts-with(/H2G2/PARAMS/PARAM[NAME='s_fromSearch']/VALUE,$root))">
						<xsl:value-of select="$root"/>
					</xsl:if>
					<xsl:call-template name="escape-quot-string">
						<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_fromSearch']/VALUE" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of disable-output-escaping="yes" select="$jsFromSearch" />
			</xsl:if>
			<xsl:text disable-output-escaping="yes">";
			var decadeSearchUrl = "</xsl:text>
			<xsl:apply-templates select="/H2G2/ARTICLE" mode="decadeSearch"/>
			<xsl:text disable-output-escaping="yes">";

			//]]&gt;
		</xsl:text>
		</script>
		
	</xsl:template>

	<xsl:template name="AUTHOR_MORE_LINK">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW']">
				<a href="{$root}MA{/H2G2/VIEWING-USER/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
					<xsl:text>More memories from </xsl:text>
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME and /H2G2/VIEWING-USER/USER/USERNAME != ''">
							<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
						</xsl:when>
						<xsl:otherwise>
							MA<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
					<xsl:text>More memories from </xsl:text>
					<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
				</a>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template name="ARTICLE_AUTHOR">
		<xsl:choose>
			<xsl:when test="$test_IsCeleb = 1">
				<!--this is a celebrity artcile-->
				BBC 
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-PREVIEW']">
						<a href="{$root}MA{/H2G2/VIEWING-USER/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME and /H2G2/VIEWING-USER/USER/USERNAME != ''">
									<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
								</xsl:when>
								<xsl:otherwise>
									MA<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
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
						<a href="{$root}MA{/H2G2/VIEWING-USER/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME and /H2G2/VIEWING-USER/USER/USERNAME != ''">
									<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
								</xsl:when>
								<xsl:otherwise>
									MA<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">
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
						<xsl:text></xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory of </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<a href="{$articlesearchroot}&amp;startdate={$startday}/{$startmonth}/{$startyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:call-template name="LongDate">
						<xsl:with-param name="day">
							<xsl:value-of select="$startday" />
						</xsl:with-param>
						<xsl:with-param name="month">
							<xsl:value-of select="$startmonth" />
						</xsl:with-param>
						<xsl:with-param name="year">
							<xsl:value-of select="$startyear" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
			</xsl:when>
			<xsl:when test="$date_range_type = 2">
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text></xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory of </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<a href="{$articlesearchroot}&amp;startdate={$startday}/{$startmonth}/{$startyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:call-template name="LongDate">
						<xsl:with-param name="day">
							<xsl:value-of select="$startday" />
						</xsl:with-param>
						<xsl:with-param name="month">
							<xsl:value-of select="$startmonth" />
						</xsl:with-param>
						<xsl:with-param name="year">
							<xsl:value-of select="$startyear" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
				<xsl:text> - </xsl:text>
        <a href="{$articlesearchroot}&amp;startdate={$endday}/{$endmonth}/{$endyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:call-template name="LongDate">
						<xsl:with-param name="day">
							<xsl:value-of select="$endday" />
						</xsl:with-param>
						<xsl:with-param name="month">
							<xsl:value-of select="$endmonth" />
						</xsl:with-param>
						<xsl:with-param name="year">
							<xsl:value-of select="$endyear" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
			</xsl:when>
			<xsl:when test="$date_range_type = 3">
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text></xsl:text>
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
					<xsl:call-template name="LongDate">
						<xsl:with-param name="day">
							<xsl:value-of select="$startday" />
						</xsl:with-param>
						<xsl:with-param name="month">
							<xsl:value-of select="$startmonth" />
						</xsl:with-param>
						<xsl:with-param name="year">
							<xsl:value-of select="$startyear" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
				<xsl:text> and </xsl:text>
				<a href="{$articlesearchroot}&amp;startdate={$endday}/{$endmonth}/{$endyear}&amp;datesearchtype=2&amp;s_dateview=day">
					<xsl:call-template name="LongDate">
						<xsl:with-param name="day">
							<xsl:value-of select="$endday" />
						</xsl:with-param>
						<xsl:with-param name="month">
							<xsl:value-of select="$endmonth" />
						</xsl:with-param>
						<xsl:with-param name="year">
							<xsl:value-of select="$endyear" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$mode = 'LIST'">
						<xsl:text></xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>'s memory. No date</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text></xsl:text>
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

		<div id="ms-preferences">
			<div id="ms-pref-header">
				<xsl:comment> ms-pref-header </xsl:comment>
			</div>
			<div id="ms-pref-content">
				<h2>
					<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
				</h2>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTROTEXT"/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</div>
			<div id="ms-pref-footer">
				<xsl:comment> ms-pref-footer </xsl:comment>
			</div>
		</div>

		

		<!--[FIXME: remove?]	
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and $current_article_type=3">
			<xsl:call-template name="ADVANCED_SEARCH" />
			<br />
		</xsl:if>
		-->

		<!--div class="padWrapper">
		<div class="inner3_4">
        
		</div>
		</div-->

		<!--xsl:call-template name="SEARCH_RSS_FEED"/-->
    
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

	<xsl:template name="KEYWORDS_COMMA_SEP">
		<xsl:if test="/H2G2/@TYPE='ARTICLE' and /H2G2/PHRASES/@COUNT">
			<xsl:for-each select="/H2G2/PHRASES/PHRASE">
				<xsl:if test="not(starts-with(NAME, '_')) and not(NAME = 'user_memory') and not(NAME = 'staff_memory') and not (NAME = 'BBC Memoryshare')">
					<xsl:if test="position() != 1">
						<xsl:text>,</xsl:text>
					</xsl:if>
					<xsl:value-of select="NAME"/>
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
	  <!--  Magnetic North Removed -->
      <!-- don't display in typedarticle as breaks submit button -->
	  <!--a name="commentbox"></a>
      <div class="barStrong">
        <h3>Please add a comment</h3>
      </div>
      <div class="inner">
        <xsl:choose>
          <xsl:when test="/H2G2/SITE-CLOSED=0 or $test_IsEditor">
            <xsl:choose>
              <xsl:when test="/H2G2/VIEWING-USER/USER">
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
      </div-->
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
