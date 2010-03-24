<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-searchpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SEARCH_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>View memories</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="rsstype">FULLTEXT_SEARCH</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="SEARCH_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">SEARCH_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">searchpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<!-- display tag search box rather than DNA search -->
		<!--[FIXME: remove]
		<xsl:call-template name="ADVANCED_SEARCH" />
		<h3>
			Advanced search
			<xsl:choose>
				<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='ARTICLE'"> : Search all memory content</xsl:when>
				<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='USER'"> : Author search</xsl:when>
			</xsl:choose>
		</h3>
		-->
		<xsl:variable name="back_to_advanced_search_url">
			<xsl:value-of select="$articlesearchservice"/>
			<xsl:text>?contenttype=-1&amp;s_mode=advanced</xsl:text>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE">
				<xsl:text>&amp;s_filter=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE"/>
			</xsl:if>
		</xsl:variable>

		<div id="topPage">
			<xsl:choose>
				<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE != 'USER'">
					<h2>Search memory content</h2>
					<p><a href="{$back_to_advanced_search_url}">&lt;&lt;Back to advanced search</a></p>
				</xsl:when>
				<xsl:otherwise>
					<h2>Advanced search</h2>
					<p>What would you like to search for?</p>
					<p><a href="{$back_to_advanced_search_url}">&lt;&lt;Back</a></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="tear"><hr/></div>

		<div class="padWrapper">
			<div class="tabNav">
				<ul>
					<li>
						<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE = 'member')">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$articlesearchservice}?s_mode=advanced&amp;s_filter=article"><span>Memories</span></a>
					</li>
					<li>
						<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE = 'member'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$articlesearchservice}?s_mode=advanced&amp;s_filter=member"><span>Author</span></a>
					</li>
				</ul>
				<div class="clr"></div>
			</div>


			<div class="inner">
				<form action="Search" method="get" id="userSearchForm">
					<input type="hidden" name="searchtype" value="{/H2G2/SEARCH/SEARCHRESULTS/@TYPE}"/>
					<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='ARTICLE'">
						<input type="hidden" name="showapproved" value="1"/>
						<input type="hidden" name="showsubmitted" value="1"/>
						<input type="hidden" name="shownormal" value="1"/>
						<input type="hidden" name="s_filter" value="article"/>
						<input type="hidden" name="show" value="8"/>
						<label for="user">
							Use this search to search all memory content for specific words.  
							If you want to search on more than one word, 
							separate them with a space (e.g. Glastonbury festival rain) 
							but please note, it will only look for memories that contain all those words. 
							Enter text and click 'Go'.
						</label>
						<br/>
					</xsl:if>
					<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='USER'">
						<input type="hidden" name="thissite" value="1"/>
						<input type="hidden" name="s_filter" value="member"/>
						<label for="user">
							Search here for a particular author.
						</label>
						<br/>
					</xsl:if>
					
					<input type="text" name="searchstring" id="user" value="{/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM}"/>
					<input type="submit" name="dosearch" value="Go" class="submit"/>
				</form>
			</div>
			
			<xsl:comment>
			[<xsl:value-of select="$site_number"/>][<xsl:value-of select="count(ARTICLERESULT[SITEID=$site_number])"/>]
			</xsl:comment>
			
			<!-- CALL RESULTS -->
			<xsl:choose>
				<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='ARTICLE' and /H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT[SITEID=$site_number]">
					<xsl:apply-templates select="/H2G2/SEARCH/SEARCHRESULTS" mode="results_search_article"/>
				</xsl:when>
				<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='USER' and /H2G2/SEARCH/SEARCHRESULTS/USERRESULT">
					<xsl:apply-templates select="/H2G2/SEARCH/SEARCHRESULTS" mode="results_search_user"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="/H2G2/SEARCH/SEARCHRESULTS" mode="noresults_search"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<!--[FIXME: redundant]
	<xsl:template match="SEARCH" mode="r_searchform">
		<xsl:apply-templates select="." mode="c_searchtype"/>
		<xsl:apply-templates select="." mode="c_resultstype"/>
		<xsl:apply-templates select="." mode="t_searchinput"/>
		<xsl:apply-templates select="." mode="t_searchsubmit"/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_c_searchform"/>
	<xsl:attribute-set name="mSEARCH_t_searchinput"/>
	<xsl:attribute-set name="mSEARCH_t_searchsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template match="SEARCH" mode="r_searchtype">
		<xsl:apply-templates select="." mode="t_searcharticles"/>
		<xsl:apply-templates select="." mode="t_searchusers"/>
		<xsl:apply-templates select="." mode="t_searchforums"/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_t_searcharticles">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=false; document.advsearch.showsubmitted.disabled=false; document.advsearch.shownormal.disabled=false;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_searchusers">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_searchforums">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="SEARCH" mode="r_resultstype">
		<xsl:copy-of select="$m_allresults"/>
		<xsl:apply-templates select="." mode="t_allarticles"/>

		<xsl:copy-of select="$m_recommendedresults"/>
		<xsl:apply-templates select="." mode="t_submittedarticles"/>

		<xsl:copy-of select="$m_editedresults"/>
		<xsl:apply-templates select="." mode="t_editedarticles"/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_t_allarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_submittedarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_editedarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	-->
	
	<xsl:template match="SEARCHRESULTS" mode="noresults_search">
		<div class="userList">
			<div class="paginationWrapper">
				<div class="barStrong">
					<p class="left">
					</p>
					<p class="right">
					</p>
					<div class="clr"></div>
				</div>
			
				<div class="barMid">
					<h2>You searched for &quot;<xsl:value-of select="SEARCHTERM"/>&quot;</h2>
					<div class="clr"></div>
				</div>
			</div>
			<div class="barPale">
				<p class="left">
					<xsl:text>&nbsp;</xsl:text>
				</p>
				<p class="right">
				</p>
			</div>
			
			<div class="noResults">
				<p>
					<xsl:text>No results were found</xsl:text>
				</p>
				<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE='ARTICLE'">
					<p>
						<xsl:text>Would you like to </xsl:text>
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="sso_typedarticle_signin">
									<xsl:with-param name="s_datemode">Specific</xsl:with-param>
								</xsl:call-template>														
							</xsl:attribute>
							add a memory
						</a>
						<xsl:text>?</xsl:text>
					</p>
				</xsl:if>
			</div>

			<div class="paginationWrapperBottom">
				<div class="barStrong">
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="SEARCHRESULTS" mode="results_search_article">
		<xsl:param name="url" select="'A'" />
		<xsl:param name="target">_top</xsl:param>
	
		<!--[FIXME: do we really want this here?]
		<xsl:call-template name="DRILL_DOWN"/>
		-->

		<div id="noFlashContent">
			<div class="padWrapper">
				<div class="paginationWrapper">
					<div class="barStrong">
						<p class="left">
						</p>
						<p class="right">
						</p>
						<div class="clr"></div>
					</div>
					<div class="barMid">
						<h2 class="left">
							<xsl:text>You searched for </xsl:text> &quot;<xsl:value-of select="SEARCHTERM"/>&quot;
						</h2>
						<p class="right">
						</p>
						<div class="clr"></div>
					</div>
					<div class="barPale">
						<p class="left">
							<xsl:text>&nbsp;</xsl:text>
						</p>
						<p class="right">
							<xsl:choose>
								<xsl:when test="SKIP != 0">
									<xsl:apply-templates select="SKIP" mode="link_previous"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="SKIP" mode="nolink_previous"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> | </xsl:text>
							<xsl:choose>
								<xsl:when test="MORE != 0 and count(ARTICLERESULT[SITEID=$site_number]) &gt;= number(COUNT)">
									<xsl:apply-templates select="MORE" mode="link_more"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="MORE" mode="nolink_more"/>
								</xsl:otherwise>
							</xsl:choose>
						</p>
						<div class="clr"></div>
					</div>
				</div>
		
				<div class="resultsList">
					<ul>
						<xsl:for-each select="ARTICLERESULT[SITEID=$site_number]">
							<xsl:variable name="cur_list_article_type" select="EXTRAINFO/TYPE/@ID"/>
							<li>
								<xsl:if test="position() = last()">
									<xsl:attribute name="class">last</xsl:attribute>
								</xsl:if>
								<h3>
									<a>
										<xsl:attribute name="href">
											<xsl:value-of select="$root"/>
											<xsl:value-of select="$url"/>
											<xsl:value-of select="H2G2ID"/>
										</xsl:attribute>
										<xsl:attribute name="target">
											<xsl:value-of select="$target"/>
										</xsl:attribute>
										<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
									</a>
								</h3>
								<p>
									<!-- author link-->	
									<xsl:choose>
										<xsl:when test="EXTRAINFO/ALTNAME != ''">
											<!--this is a celebrity artcile-->
											<xsl:choose>
												<xsl:when test="EDITOR/USER/USERID">
													<a href="{$root}U{EDITOR/USER/USERID}"><xsl:value-of select="EDITOR/USER/USERNAME"/></a>
												</xsl:when>
												<xsl:otherwise>
													<a href="{$root}U{EXTRAINFO/AUTHORUSERID}"><xsl:value-of select="EXTRAINFO/AUTHORUSERNAME"/></a>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:text> on behalf of </xsl:text>
											<xsl:value-of select="EXTRAINFO/ALTNAME" />
										</xsl:when>
										<xsl:otherwise>
											<!--this is not a celebrity article-->
											<xsl:choose>
												<xsl:when test="EDITOR/USER/USERID">
													<a href="{$root}U{EDITOR/USER/USERID}"><xsl:value-of select="EDITOR/USER/USERNAME"/></a>
												</xsl:when>
												<xsl:otherwise>
													<a href="{$root}U{EXTRAINFO/AUTHORUSERID}"><xsl:value-of select="EXTRAINFO/AUTHORUSERNAME"/></a>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>

									<!-- date -->
									<xsl:if test="DATERANGESTART/DATE/@DATE or (DATERANGESTART/DATE/@DAY and DATERANGESTART/DATE/@DAY != 0)">
										<xsl:variable name="startdate" select="DATERANGESTART/DATE/@DATE"/>
										<xsl:variable name="startday" select="DATERANGESTART/DATE/@DAY"/>
										<xsl:variable name="startmonth" select="DATERANGESTART/DATE/@MONTH"/>
										<xsl:variable name="startyear" select="DATERANGESTART/DATE/@YEAR"/>
										<xsl:variable name="enddate" select="DATERANGEEND/DATE/@DATE"/>
										<xsl:variable name="endday" select="DATERANGEEND/DATE/@DAY"/>
										<xsl:variable name="endmonth" select="DATERANGEEND/DATE/@MONTH"/>
										<xsl:variable name="endyear" select="DATERANGEEND/DATE/@YEAR"/>
										<xsl:variable name="timeinterval" select="EXTRAINFO/TIMEINTERVAL"/>

										<xsl:call-template name="MEMORY_DATE">
											<xsl:with-param name="startday" select="$startday"/>
											<xsl:with-param name="startmonth" select="$startmonth"/>
											<xsl:with-param name="startyear" select="$startyear"/>
											<xsl:with-param name="endday" select="$endday"/>
											<xsl:with-param name="endmonth" select="$endmonth"/>
											<xsl:with-param name="endyear" select="$endyear"/>
											<xsl:with-param name="timeinterval" select="$timeinterval"/>
										</xsl:call-template>

										<!--[FIXME: refactor]
										<xsl:variable name="date_range_type">
											<xsl:call-template name="GET_DATE_RANGE_TYPE">
													<xsl:with-param name="startday" select="$start_day"/>
													<xsl:with-param name="startmonth" select="$start_month"/>
													<xsl:with-param name="startyear" select="$start_year"/>
													<xsl:with-param name="endday" select="$end_day"/>
													<xsl:with-param name="endmonth" select="$end_month"/>
													<xsl:with-param name="endyear" select="$end_year"/>
													<xsl:with-param name="timeinterval" select="$time_interval"/>
											</xsl:call-template>
										</xsl:variable>

										<xsl:choose>
											<xsl:when test="$date_range_type = 1">
												of <xsl:value-of select="$start_day" />/<xsl:value-of select="$start_month" />/<xsl:value-of select="$start_year" />
											</xsl:when>
											<xsl:when test="$date_range_type = 2">
												of <xsl:value-of select="$start_day" />/<xsl:value-of select="$start_month" />/<xsl:value-of select="$start_year" /> - <xsl:value-of select="$end_day" />/<xsl:value-of select="$end_month" />/<xsl:value-of select="$end_year" />
											</xsl:when>
											<xsl:when test="$date_range_type = 3">
												of <xsl:value-of select="$time_interval" /> day<xsl:if test="$time_interval &gt; 1">s</xsl:if> between <xsl:value-of select="$start_day" />/<xsl:value-of select="$start_month" />/<xsl:value-of select="$start_year" /> and <xsl:value-of select="$end_day" />/<xsl:value-of select="$end_month" />/<xsl:value-of select="$end_year" />
											</xsl:when>
										</xsl:choose>
										-->
									</xsl:if>
								</p>
								<p>
									<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION"/>
								</p>
							</li>
						</xsl:for-each>
					</ul>
				</div>

				<div class="paginationWrapperBottom">
					<div class="barStrong">
						<p class="rAlign">
							<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>
						</p>
					</div>
				</div>
			</div>
		</div><xsl:comment>// noFlashContent </xsl:comment>

		<xsl:call-template name="FULLTEXT_SEARCH_RSS_FEED"/>
	</xsl:template>
	
	<xsl:template match="SEARCHRESULTS" mode="results_search_user">
		<xsl:param name="url" select="'U'" />
		<xsl:param name="target">_top</xsl:param>
		
		<div class="userList">
			<div class="paginationWrapper">
				<div class="barStrong">
					<h2 class="left">You searched for &quot;<xsl:value-of select="SEARCHTERM"/>&quot;</h2>
					<!--[FIXME: does not work]
					<p class="right">
						<a href="#">Next&gt;</a>
					</p>
					-->
					<div class="clr"></div>
				</div>
			</div>
			<ul>
				<xsl:for-each select="USERRESULT">
					<li>
						<xsl:attribute name="class">
							<xsl:text>member</xsl:text>
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0">
									<xsl:text>liB</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>liA</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$root"/>
								<xsl:value-of select="$url"/>
								<xsl:value-of select="USERID"/>
							</xsl:attribute>
							<xsl:attribute name="target">
								<xsl:value-of select="$target"/>
							</xsl:attribute>
							<xsl:apply-templates mode="nosubject" select="USERNAME"/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
			<div class="paginationWrapperBottom">
				<div class="barStrong">
					<!--[FIXME: does not work]
					<p class="rAlign">
						<a href="#">Next&gt;</a>
					</p>
					-->
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<!-- PAGINATION -->
	
	<xsl:template match="SKIP" mode="nolink_previous">
		<xsl:value-of select="$m_noprevresults"/>
	</xsl:template>
	<xsl:template match="SKIP" mode="link_previous">
		<a xsl:use-attribute-sets="mSKIP_link_previous">
			<xsl:attribute name="href">
				<xsl:value-of select="$root"/>
				<xsl:text>Search?searchstring=</xsl:text>
				<xsl:value-of select="../SAFESEARCHTERM"/>
				<xsl:text>&amp;searchtype=</xsl:text>
				<xsl:value-of select="../@TYPE"/>
				<xsl:text>&amp;skip=</xsl:text>
				<xsl:value-of select="number(.) - number(../COUNT)"/>
				<xsl:text>&amp;show=</xsl:text>
				<xsl:value-of select="../COUNT"/>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">
					<xsl:text>&amp;showapproved=1</xsl:text>
				</xsl:if>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">
					<xsl:text>&amp;shownormal=1</xsl:text>
				</xsl:if>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">
					<xsl:text>&amp;showsubmitted=1</xsl:text>
				</xsl:if>
				<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE">
					<xsl:text>&amp;s_filter=</xsl:text>
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="$m_prevresults"/>
		</a>
	</xsl:template>
	
	<xsl:template match="MORE" mode="nolink_more">
		<xsl:value-of select="$m_nomoreresults"/>
	</xsl:template>
	<xsl:template match="MORE" mode="link_more">
		<a xsl:use-attribute-sets="mMORE_link_more">
			<xsl:attribute name="href">
				<xsl:value-of select="$root"/>
				<xsl:text>Search?searchstring=</xsl:text>
				<xsl:value-of select="../SAFESEARCHTERM"/>
				<xsl:text>&amp;searchtype=</xsl:text>
				<xsl:value-of select="../@TYPE"/>
				<xsl:text>&amp;skip=</xsl:text>
				<xsl:value-of select="number(../SKIP) + number(../COUNT)"/>
				<xsl:text>&amp;show=</xsl:text>
				<xsl:value-of select="../COUNT"/>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">
					<xsl:text>&amp;showapproved=1</xsl:text>
				</xsl:if>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">
					<xsl:text>&amp;shownormal=1</xsl:text>
				</xsl:if>
				<xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">
					<xsl:text>&amp;showsubmitted=1</xsl:text>
				</xsl:if>
				<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE">
					<xsl:text>&amp;s_filter=</xsl:text>
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="$m_nextresults"/>
		</a>
	</xsl:template>
		
	<!-- pagination navigation -->
	<xsl:template match="SEARCHRESULTS" mode="pagination_links">
		<xsl:variable name="pagenumber">
			<xsl:value-of select="floor(@SKIPTO div @COUNT) + 1" />
		</xsl:variable>
		
		<xsl:variable name="total">
			<!--[FIXME: total not available in Search ??]
	  		<xsl:value-of select="ceiling(@TOTAL div @COUNT)" />
	  		-->
	  		<xsl:text>?</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="pagetotal">
			<!--[FIXME: total not available in Search ??]
	  		<xsl:value-of select="ceiling(@TOTAL div @COUNT)" />
	  		-->
	  		<xsl:text>?</xsl:text>
		</xsl:variable>
	
		<div class="page">
			<!--[FIXME: not possible due to missing TOTAL]
			<p>
				<xsl:value-of select="$total"/> 
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="$total = 1">memory, </xsl:when>
					<xsl:otherwise>memories, </xsl:otherwise>
				</xsl:choose>
				
				page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" />
			</p>
			-->
			<div class="links">
				<div class="pagecol1"><xsl:apply-templates select="SKIP" mode="c_previous"/> </div>
				<div class="pagecol2">&#160;</div>   
				<div class="pagecol3"><xsl:apply-templates select="MORE" mode="c_more"/></div>
			</div>
			<div class="clear"></div>
		</div>
	</xsl:template>
	
	<xsl:template match="ARTICLERESULT" mode="r_search">
		<!--[FIXME: remove]
		<p><xsl:apply-templates select="SUBJECT" mode="t_subjectlink"/><br/>
		<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION/text()"/><br />
		<em><xsl:value-of select="SCORE"/>% | type = <xsl:value-of select="TYPE/text()"/>| status = <xsl:value-of select="STATUS/text()"/><br/>
		Date create: <xsl:value-of select="DATECREATED/DATE/@RELATIVE"/><br />
		Date updated: <xsl:value-of select="LASTUPDATED/DATE/@RELATIVE"/><br /></em>
		</p>
		-->
	</xsl:template>
	<xsl:template match="USERRESULT" mode="r_search">
		<!--[FIXME: redundant]
		<p>
			<xsl:apply-templates select="USERNAME" mode="t_userlink"/>
		</p>
		-->
	</xsl:template>
	<xsl:template match="FORUMRESULT" mode="r_search">
		<p>
			<xsl:apply-templates select="SUBJECT" mode="t_postlink"/>
		</p>
	</xsl:template>
	
	<xsl:template name="FULLTEXT_SEARCH_RSS_FEED_META">
		<link rel="alternative" type="application/rdf+xml">
			<xsl:attribute name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Search for </xsl:text>
				<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($feedroot, 'xml/')"/>
				<xsl:text>Search?searchstring=</xsl:text>
				<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM"/>
				<xsl:text>&amp;searchtype=</xsl:text>
				<xsl:value-of select="../@TYPE"/>
				<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">
					<xsl:text>&amp;showapproved=1</xsl:text>
				</xsl:if>
				<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">
					<xsl:text>&amp;shownormal=1</xsl:text>
				</xsl:if>
				<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">
					<xsl:text>&amp;showsubmitted=1</xsl:text>
				</xsl:if>
				<xsl:text>&amp;s_xml=</xsl:text>
				<xsl:value-of select="$rss_param"/>
				<xsl:text>&amp;s_client=</xsl:text>
				<xsl:value-of select="$client"/>
				<xsl:text>&amp;show=</xsl:text>
				<xsl:value-of select="$rss_show"/>
			</xsl:attribute>
		</link>
	</xsl:template>
	
	<xsl:template name="FULLTEXT_SEARCH_RSS_FEED">
		<xsl:variable name="url">
			<xsl:value-of select="concat($feedroot, 'xml/')"/>
			<xsl:text>Search?searchstring=</xsl:text>
			<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM"/>
			<xsl:text>&amp;searchtype=</xsl:text>
			<xsl:value-of select="../@TYPE"/>
			<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">
				<xsl:text>&amp;showapproved=1</xsl:text>
			</xsl:if>
			<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">
				<xsl:text>&amp;shownormal=1</xsl:text>
			</xsl:if>
			<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">
				<xsl:text>&amp;showsubmitted=1</xsl:text>
			</xsl:if>
			<xsl:text>&amp;s_xml=</xsl:text>
			<xsl:value-of select="$rss_param"/>
			<xsl:text>&amp;s_client=</xsl:text>
			<xsl:value-of select="$client"/>
			<xsl:text>&amp;show=</xsl:text>
			<xsl:value-of select="$rss_show"/>
        </xsl:variable>

    	<p id="rssBlock">
      		<a href="{$url}" class="rssLink" id="rssLink">
        		<xsl:text>RSS Feed</xsl:text>
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
