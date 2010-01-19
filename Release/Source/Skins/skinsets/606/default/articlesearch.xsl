<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlesearch.xsl"/>

	<xsl:template name="ARTICLESEARCH_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLESEARCH_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">articlesearch.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='predefinedtags'">
				<div id="mainbansec">
					<div class="banartical"><h3>Predefined tags</h3></div>
					<!--[FIXME: remove]
					<xsl:call-template name="SEARCHBOX" />
					-->

					<!--[FIXME: remove]
					<div class="clear"></div>
					<div class="searchline"><div></div></div>
					-->
				</div>
				<xsl:apply-templates select="ARTICLESEARCH" mode="predefinedtags"/>
				<!--[FIXME: remove]
				<xsl:call-template name="ADVANCED_SEARCH" />
				-->
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='top100'">
				<!-- Most popular tags (for editors) -->
				<div id="mainbansec">
					<div class="banartical"><h3>Top 100 tags</h3></div>
					<!--[FIXME: remove]
					<xsl:call-template name="SEARCHBOX" />
					-->

					<!--[FIXME: remove]
					<div class="clear"></div>
					<div class="searchline"><div></div></div>
					-->
				</div>
				<xsl:apply-templates select="ARTICLEHOT-PHRASES" mode="editorialtool"/>
				<!--[FIXME: remove]
				<xsl:call-template name="ADVANCED_SEARCH" />
				-->
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='searchbox' and (/H2G2/ARTICLESEARCH/PHRASES/@COUNT=0 or /H2G2/ARTICLESEARCH/@TOTAL=0)">
				<div id="mainbansec" class="searchbox">
					<!--
					<div class="banartical"><h3>Search 606</h3></div>
					-->
					<div class="searchboxWrapper">
						<form method="get" action="{$root}ArticleSearch">
							<input type="hidden" name="contenttype" value="-1"/>
							<input type="hidden" name="articlesortby" value="DateCreated"/>
							<input type="hidden" name="s_show" value="searchbox"/>
							<div id="searchboxIntro">
								<div class="inner">
									<h4>Can't find what you're looking for?</h4>
									<h3><img src="{$imagesource}refresh/search606.gif" alt="Search 606"/></h3>
								</div>
							</div>
							<div id="searchboxInput">
								<div class="inner">
									<label for="phrase" class="hidden">Search terms</label>
									<xsl:variable name="phrasevalue">
										<xsl:for-each select="PHRASES/PHRASE">
											<xsl:value-of select="TERM"/>
											<xsl:if test="position() != last()">
												<xsl:text> </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:variable>
									<input type="text" name="phrase" id="phrase">
										<xsl:attribute name="onclick">
										 	<xsl:text>if (this.value=='Enter your text here') { this.value = ''; }</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$phrasevalue != ''">
													<xsl:value-of select="$phrasevalue"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Enter your text here</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</input>
									<input type="submit" class="submit" name="s_usersubmit" id="submit" value="Search"/>
								</div>
							</div>
							<div class="clear"></div>
						</form>
					</div>

					<div class="searchboxBody">
						<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_usersubmit']">
							<!-- no results found -->
							<div class="noResults">
								<p>No articles have been described using this word or combination of words.</p>
								<p>Try searching again</p>
							</div>
						</xsl:if>

						<xsl:apply-templates select="ARTICLESEARCH" mode="search_hints"/>

						<div>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_usersubmit']">searchboxTipsNoResults</xsl:when>
									<xsl:otherwise>searchboxTips</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<h4>Search tips</h4>
							<ul>
								<li>You are searching across sports, teams, competitions and other subjects which members have entered when creating content.</li>
								<li>This is not a search across all words on a page.</li>
							</ul>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='browsePage'">
				<div id="mainbansec" class="crumbBar">
					<span class="crumbBrowse">Browse: </span>
					<a href="{$root}ArticleSearch?phrase={/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE}&amp;contenttype=-1"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE"/></a>
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE">
						<xsl:text> </xsl:text>
						<a href="{$root}ArticleSearch?phrase={/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE}&amp;contenttype=-1"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE"/></a>
					</xsl:if>
				</div>

				<xsl:call-template name="BROWSE_PAGE">
					<xsl:with-param name="sport" select="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE"/>
					<xsl:with-param name="type" select="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<div id="mainbansec" class="crumbBar">
					<span class="crumbBrowse">Browse: </span>
					<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
						<a href="{$root}ArticleSearch?phrase={TERM}&amp;contenttype=-1"><xsl:value-of select="TERM"/></a>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</div>
        <xsl:apply-templates select="ARTICLESEARCH" mode="search_hints"/>
        <xsl:apply-templates select="ARTICLESEARCH" mode="page_info_bar"/>
				<xsl:apply-templates select="ARTICLESEARCH" mode="result_tool_bar"/>
				<xsl:apply-templates select="ARTICLESEARCH" mode="normalsearch"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BROWSE_PAGE">
		<xsl:param name="sport"/>
		<xsl:param name="type"/>

		<xsl:choose>
			<xsl:when test="$sport='Football'">
				<xsl:choose>
					<xsl:when test="$type='European'">
						<xsl:call-template name="GENERATE_FOOTBALL_EUROPEAN_BROWSE_PAGE"/>
					</xsl:when>
					<xsl:when test="$type='International'">
						<xsl:call-template name="GENERATE_FOOTBALL_INTERNATIONAL_BROWSE_PAGE"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="GENERATE_FOOTBALL_BROWSE_PAGE"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$sport='Cricket'">
				<xsl:call-template name="GENERATE_CRICKET_BROWSE_PAGE"/>
			</xsl:when>
			<xsl:when test="$sport='Rugby union'">
				<xsl:call-template name="GENERATE_RUGBY_UNION_BROWSE_PAGE"/>
			</xsl:when>
			<xsl:when test="$sport='Rugby league'">
				<xsl:call-template name="GENERATE_RUGBY_LEAGUE_BROWSE_PAGE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GENERATE_OTHER_SPORTS_BROWSE_PAGE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="GENERATE_FOOTBALL_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Premier League']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Championship']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='League One']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='League Two']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Non League']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Scottish Premier']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Scottish League']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='International'][@sport='Football']" mode="generate_browse_list"/>
				<ul class="moreList">
					<li>
						<a href="{$root}ArticleSearch?s_show=browsePage&amp;s_sport=Football&amp;s_type=International">More International football</a>
					</li>
				</ul>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='European Football']" mode="generate_browse_list"/>
				<ul class="moreList">
					<li>
						<a href="{$root}ArticleSearch?s_show=browsePage&amp;s_sport=Football&amp;s_type=European">More European football</a>
					</li>
				</ul>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name=&quot;Women's Football&quot;]" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='More Non League Clubs']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Wales']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Northern Ireland']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Highland League']" mode="generate_browse_list"/>
			</td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_FOOTBALL_EUROPEAN_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Austrian'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Belgian'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Danish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Finnish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='French'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='German'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Greek'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Netherlands'][@sport='Football']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Italian'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Norwegian'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Portuguese'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Irish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Spanish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Swedish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Swiss'][@sport='Football']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Turkish'][@sport='Football']" mode="generate_browse_list"/>
			</td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_FOOTBALL_INTERNATIONAL_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MAJOR COMPETITIONS']" mode="generate_browse_list">
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MAJOR COMPETITIONS 2']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MAJOR COMPETITIONS 3']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MAJOR COMPETITIONS 4']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='TEAMS']" mode="generate_browse_list">
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='TEAMS 2']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='TEAMS 3']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='TEAMS 4']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
					<xsl:with-param name="linkHeading">no</xsl:with-param>
				</xsl:apply-templates>
			</td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_CRICKET_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='International'][@sport='Cricket']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='County cricket']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Minor Counties']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Competitions'][@sport='Cricket']" mode="generate_browse_list"/>
			</td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_RUGBY_UNION_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='International'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Premiership'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Magners League'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Super 14'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 2'][@sport='Rugby union']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 3'][@sport='Rugby union']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 4'][@sport='Rugby union']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MORE ENGLISH'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MORE IRISH'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MORE SCOTTISH'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='MORE WELSH'][@sport='Rugby union']" mode="generate_browse_list"/>
			</td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_RUGBY_LEAGUE_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Super League'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='International'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='NRL'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='Origin'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 2'][@sport='Rugby league']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 3'][@sport='Rugby league']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='COMPETITIONS 4'][@sport='Rugby league']" mode="generate_browse_list">
					<xsl:with-param name="hideTitle">yes</xsl:with-param>
				</xsl:apply-templates>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($competitions)/competition[@name='National League'][@sport='Rugby league']" mode="generate_browse_list"/>
			</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</table>
		<div class="browseFooter">
			<ul class="moreList">
				<li><a href="#top" class="arrow">back to the top</a></li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="GENERATE_OTHER_SPORTS_BROWSE_PAGE">
		<div class="browseHeader">
			<h3>Click on a team or competition below:</h3>
		</div>
		<table border="0" id="browsePage">
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='ATHLETICS']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='BOXING']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='CYCLING']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='GOLF']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='HORSE RACING']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='MOTORSPORT']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='SNOOKER']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='TENNIS']" mode="generate_browse_list"/>
			</td>
		</tr>
		<tr>
			<td colspan="4" class="rule"><hr/></td>
		</tr>
		<tr>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='OLYMPIC SPORTS']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='OTHER SPORTS AND EVENTS']" mode="generate_browse_list"/>
			</td>
			<td>
				<xsl:apply-templates select="msxsl:node-set($otherSportsBrowseData)/browsepage/group[@name='EVENTS AND PROGRAMMES']" mode="generate_browse_list"/>
			</td>
			<td>
				<ul class="moreList">
					<li>
						<h4>
							Still can't find what you want?
						</h4>
						<p>
							<a href="{$root}ArticleSearch?s_show=searchbox">Use the 606 search</a>
						</p>
					</li>
				</ul>
			</td>
		</tr>
		</table>
	</xsl:template>

	<xsl:template match="group" mode="generate_browse_list">
		<xsl:param name="hideTitle">no</xsl:param>
		<xsl:param name="linkHeading">yes</xsl:param>

		<xsl:if test="$hideTitle = 'no'">
			<h4>
				<xsl:choose>
					<xsl:when test="$linkHeading = 'yes'">
						<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={@phrase}&amp;phrase={@sport}">
							<xsl:value-of select="@name"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</h4>
		</xsl:if>
		<ul>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$hideTitle = 'no'">browseList</xsl:when>
					<xsl:otherwise>browseList noTitle</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="generate_browse_list"/>
		</ul>
	</xsl:template>

	<xsl:template match="link" mode="generate_browse_list">
		<li>
			<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={@phrase}&amp;phrase={../@sport}"><xsl:value-of select="text()"/></a>
		</li>
	</xsl:template>


	<xsl:template match="competition" mode="generate_browse_list">
		<xsl:param name="hideTitle">no</xsl:param>
		<xsl:param name="linkHeading">yes</xsl:param>

		<xsl:if test="$hideTitle = 'no'">
			<h4>
				<xsl:choose>
					<xsl:when test="$linkHeading = 'yes'">
						<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={@phrase}&amp;phrase={@sport}">
							<xsl:value-of select="@name"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</h4>
		</xsl:if>
		<ul>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$hideTitle = 'no'">browseList</xsl:when>
					<xsl:otherwise>browseList noTitle</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates mode="generate_browse_list"/>
		</ul>
	</xsl:template>

	<xsl:template match="team" mode="generate_browse_list">
		<li>
			<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={@phrase}&amp;phrase={../@sport}"><xsl:value-of select="@fullname"/></a>
		</li>
	</xsl:template>

	<xsl:template name="rss_search_link">
		<xsl:variable name="raw_href">
			<xsl:value-of select="$root"/>
			<xsl:text>xml/ArticleSearch?s_xml=rss</xsl:text>
			<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
				<xsl:text>&amp;phrase=</xsl:text>
				<xsl:value-of select="TERM"/>
			</xsl:for-each>
			<xsl:text>&amp;contenttype=</xsl:text>
			<xsl:value-of select="/H2G2/ARTICLESEARCH/@CONTENTTYPE"/>
			<xsl:text>&amp;articlesortby=DateCreated</xsl:text>
			<xsl:text>&amp;show=15</xsl:text>
		</xsl:variable>
		<a href="{$raw_href}"><img src="{$imagesource}feed.gif" width="16" height="16" alt="RSS"/></a>
		<xsl:text> | </xsl:text>
		<a href="http://news.bbc.co.uk/sport1/hi/help/rss/default.stm" target="_blank">Sport feeds</a>
		<!--[FIXME: hidden]
		<a href="{$raw_href}">
			<xsl:for-each select="/H2G2/ArticleSearch/PHRASES/PHRASE">
				<xsl:choose>
					<xsl:when test="TERM='article'">Articles</xsl:when>
					<xsl:when test="TERM='report'">Reports</xsl:when>
					<xsl:when test="TERM='profile'">Profiles</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="TERM"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="position() != last()">
					<xsl:text> + </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</a>
		-->
	</xsl:template>

	<!--
	Search Results
	-->
	<xsl:template match="ARTICLESEARCH" mode="normalsearch">
		<!--[FIXME: remove]
		<xsl:call-template name="ADVANCED_SEARCH" />
		<div class="searchline"><div></div></div>
		-->
		<xsl:choose>
			<xsl:when test="PHRASES/@COUNT = 0 and not($test_IsEditor)">
				<!-- no search has been made - only display list of all articles to editors -->
			</xsl:when>
			<xsl:otherwise>
				<!-- a search has been submitted -->

				<!-- words submitted-->
				<!--[FIXME: remove]
				<p id="yoursearch">You searched for
					<xsl:for-each select="PHRASES/PHRASE">
						<span class="searchphrase"><xsl:value-of select="NAME"/></span><xsl:if test="position() != last()"> + </xsl:if>
					</xsl:for-each>
				</p>
				-->

				<xsl:if test="@TOTAL=0">
					<!-- no results found -->
					<div class="bodysec2">
						<p id="noresults">No articles have been described using this word<br/> or combination of words.</p>

						<!-- test for search for tags that have been combined (e.g to prevent 'American Football' results appearing in searches for 'Football', 'American Football' is tagged as americanfootball - this means that you could have an RSS for 'football', 'hockey' and 'tennis' -->
						<xsl:choose>
							<xsl:when test="PHRASES/PHRASE/NAME/text()='american' and PHRASES/PHRASE/NAME/text()='football'">
								<p class="searchsuggestion">It looks like you were looking for <strong>american football</strong> content, please search again using the phrase <a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=americanfootball">americanfootball</a></p>
							</xsl:when>
							<xsl:when test="PHRASES/PHRASE/NAME/text()='ice' and PHRASES/PHRASE/NAME/text()='hockey'">
								<p class="searchsuggestion">It looks like you were looking for <strong>ice hockey</strong> content, please search again using the phrase <a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=icehockey">icehockey</a></p>
							</xsl:when>
							<xsl:when test="PHRASES/PHRASE/NAME/text()='table' and PHRASES/PHRASE/NAME/text()='tennis'">
								<p class="searchsuggestion">It looks like you were looking for <strong>table tennis</strong> content, please search again using the phrase <a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=tabletennis">tabletennis</a></p>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:if>

				<xsl:if test="@TOTAL&gt;0">
					<!--[FIXME: remove]
					<div class="bodysec3">
						/* results found */
						<xsl:variable name="searchterm">
							<xsl:for-each select="/H2G2/ArticleSearch/PHRASES/PHRASE"><xsl:value-of select="NAME"/><xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each>
						</xsl:variable>
						<xsl:variable name="params">
							<xsl:for-each select="/H2G2/PARAMS/PARAM">&amp;<xsl:value-of select="NAME"/>=<xsl:value-of select="VALUE"/></xsl:for-each>
							<xsl:if test="1">
							&amp;show=<xsl:value-of select="ARTICLESEARCH/@COUNT"/>
							</xsl:if>
						</xsl:variable>

						<div class="headingbox">
							<h3>Sort by</h3>
							<p class="links">

                            				/*[FIXME: remove]
							<xsl:choose>
								<xsl:when test="ARTICLESEARCH/@SORTBY='Caption'">
									a-z title
								</xsl:when>
								<xsl:otherwise>
									<a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=Caption{$params}">a-z title</a>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> | </xsl:text>
                            				*/
							<xsl:choose>
								<xsl:when test="ARTICLESEARCH/@SORTBY='DateCreated' or not(ARTICLESEARCH/@SORTBY)">
									date
								</xsl:when>
								<xsl:otherwise>
									<a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=DateCreated{$params}">date</a>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')">
							/* hide when displaying member pages as will not have ratings to sort by */
								<xsl:text> | </xsl:text>
								<xsl:choose>
									<xsl:when test="ARTICLESEARCH/@SORTBY='Rating'">
										rating
									</xsl:when>
									<xsl:otherwise>
										<a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=Rating{$params}">rating</a>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							</p>
						</div>

						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<xsl:variable name="sort">
									<xsl:if test="ARTICLESEARCH/@SORTBY">
										&amp;articlesortby=<xsl:value-of select="ARTICLESEARCH/@SORTBY"/>
									</xsl:if>

								</xsl:variable>

								<div class="editbox">
									<a href="{$root}xml/ArticleSearch?s_xml=rss&amp;phrase={$searchterm}&amp;contenttype=-1{$sort}">RSS</a>
								</div>
							</xsl:when>
						</xsl:choose>

						/* pagination block */
						<xsl:apply-templates select="/H2G2/ArticleSearch/ARTICLESEARCH" mode="pagination_links"/>
					</div>

					<div class="bodysecextra">
						<xsl:if test="$enable_rss='Y'">
							<div class="rssbox">
								<h3>RSS FEED</h3>

								<p>
									Subscribe to the following feed
								</p>

								<p class="feed">
									<xsl:call-template name="rss_search_link"/>
								</p>

								<p>
									<ul class="arrow">
										<li><a href="http://news.bbc.co.uk/sport1/hi/help/rss/default.stm">What is RSS?</a></li>
									</ul>
								</p>
							</div>
						</xsl:if>
					</div>
					-->
				</xsl:if>


				<div class="mainbodysec">
					<div class="bodysec">

						<div class="bodytext2">
							<xsl:choose>
								<xsl:when test="@TOTAL=0">
								<!-- no results found -->
								<!-- help -->
								<!--[FIXME: remove?]
								<xsl:comment>#include virtual="/606/2/includes/searchtext.ssi"</xsl:comment>
								-->

								</xsl:when>
								<xsl:otherwise>
								<!-- results found -->

									<!-- list of article -->
									<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="c_articlesearchresults"/>

									<!-- pagination block -->
									<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>

								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div><!-- / bodysec -->
					<div class="additionsec">
						<!--[FIXME: remove?]
						<div class="hintbox">
						 	<h3>HINTS &amp; TIPS</h3>

							<xsl:comment>#include virtual="/606/2/includes/searchtext_tips.ssi"</xsl:comment>

						</div>

						<xsl:call-template name="CREATE_ARTICLES_LISTALL" />
						-->
					</div><!-- /  additionsec -->

					<div class="clear"></div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:attribute-set name="iARTICLESEARCHPHRASE_t_articlesearchbox"/>


	<xsl:template match="ARTICLESEARCH" mode="r_articlesearchresults">
		<xsl:apply-templates select="ARTICLES" mode="c_articlesearchresults"/>
	</xsl:template>

	<xsl:template match="ARTICLES" mode="r_articlesearchresults">
		<ul class="searchResultsList">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members'">
				<xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='3001']" mode="r_articlesearchresults"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ARTICLE" mode="r_articlesearchresults"/>
			</xsl:otherwise>
		</xsl:choose>
		</ul>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="r_articlesearchresults">
		<xsl:variable name="oddoreven">
			<xsl:choose>
				<xsl:when test="position() mod 2 != 0">odd</xsl:when>
				<xsl:otherwise>even</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<li>
			<xsl:if test="position() = last()">
				<xsl:attribute name="class">last</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="EXTRAINFO/MANAGERSPICK/text()">
				<xsl:with-param name="oddoreven" select="$oddoreven"/>
			</xsl:apply-templates>

			<div class="articletitle">
				<a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="EXTRAINFO/TYPE/@ID='3001'">
							<xsl:value-of select="concat($root, 'U',EDITOR/USER/USERID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($root, 'A', @H2G2ID)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="SUBJECT/text()">
						<xsl:value-of select="SUBJECT/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_subjectempty"/>
					</xsl:otherwise>
				</xsl:choose>
				</a>
			</div>

			<div class="articleauthor">
                <xsl:text>by </xsl:text>
                <a href="{$root}U{EDITOR/USER/USERID}">
                    <xsl:value-of select="EDITOR/USER/USERNAME"/>
                    <xsl:if test="EDITOR/USER/USERNAME != concat('U', EDITOR/USER/USERID)">
                        <xsl:text> </xsl:text>
                        <span class="uid">(U<xsl:value-of select="EDITOR/USER/USERID"/>)</span>
                    </xsl:if>
                </a>
            </div>
				<xsl:choose>
					<xsl:when test="EXTRAINFO/TYPE/@ID='3001'">
						<div class="articledetals">Member page</div>
						<div> Date created: <xsl:value-of select="DATECREATED/DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@YEAR"/></div>
						<div> <em>Last updated: <xsl:value-of select="LASTUPDATED/DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="LASTUPDATED/DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="LASTUPDATED/DATE/@YEAR"/></em></div>
					</xsl:when>
					<xsl:otherwise>
						<!--[FIXME: remove]
						<div class="articledetals"><xsl:apply-templates select="EXTRAINFO/SPORT"/> <xsl:apply-templates select="EXTRAINFO/COMPETITION/text()"/> <xsl:apply-templates select="EXTRAINFO/TYPE"/></div>
						-->
						<!-- rating -->
						<xsl:if test="POLL/STATISTICS/@VOTECOUNT &gt; 0">
							<div class="articlerating">
								<img src="{$imagesource}stars/lists/neutral/{round(POLL/STATISTICS/@AVERAGERATING)}.gif" width="78" height="12" alt="{round(POLL/STATISTICS/@AVERAGERATING)} stars" /> average rating from <xsl:value-of select="POLL/STATISTICS/@VOTECOUNT"/> members
							</div>
						</xsl:if>
						<div class="articledate"><xsl:value-of select="DATECREATED/DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@YEAR"/></div>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION/text()" />
				<xsl:variable name="lastPostDate">
					<xsl:value-of select="FORUMLASTPOSTED/DATE/LOCAL/@DAY"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="FORUMLASTPOSTED/DATE/LOCAL/@MONTHNAME"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="FORUMLASTPOSTED/DATE/LOCAL/@YEAR"/>
					<xsl:text> at </xsl:text>
					<xsl:value-of select="FORUMLASTPOSTED/DATE/LOCAL/@HOURS"/>
					<xsl:text>:</xsl:text>
					<xsl:value-of select="FORUMLASTPOSTED/DATE/LOCAL/@MINUTES"/>
				</xsl:variable>
				
				<xsl:variable name="numberofposts">
				<xsl:value-of select="NUMBEROFPOSTS"/>
				</xsl:variable>
				
				<div>
					<font size="-1">
					<xsl:choose>
					<xsl:when test="($numberofposts = '1')">
					<xsl:value-of select="NUMBEROFPOSTS"/> comment
					</xsl:when>
					<xsl:otherwise>
					<xsl:value-of select="NUMBEROFPOSTS"/> comments
					</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="not($numberofposts = '0')">
							<xsl:text> | </xsl:text>Last Commented:<xsl:text> </xsl:text><xsl:value-of select="$lastPostDate" />
					</xsl:if>
							
					</font>
				</div>				
		</li>
	</xsl:template>


	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							HOT-PHRASES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	<!-- Count the number of phrases on the page -->
	<xsl:variable name="total-phrases" select="count(/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE)"/>
	<!-- Set the number of ranges you want -->
	<xsl:variable name="no-of-ranges" select="5"/>
	<!-- Work out how many phrases in each range: -->
	<xsl:variable name="hot-phrases-in-block" select="ceiling($total-phrases div $no-of-ranges)"/>
	<!-- Re-order the HOT-PHRASES so that the highest scoring appears first adding generate-id and position atts -->
	<xsl:variable name="hot-phrases">
		<xsl:for-each select="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE">
			<xsl:sort select="RANK" data-type="number" order="descending"/>
			<xsl:copy>
				<xsl:attribute name="position"><xsl:value-of select="position() mod $hot-phrases-in-block"/></xsl:attribute>
				<xsl:attribute name="generate-id"><xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:copy-of select="node()"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<!-- surround each range in the re-ordered node-set with a RANGE tag -->
	<xsl:variable name="ranked-hot-phrases">
		<xsl:for-each select="msxsl:node-set($hot-phrases)/ARTICLEHOT-PHRASE[@position=1]">
			<RANGE ID="{position()}">
				<xsl:copy-of select="."/>
				<xsl:for-each select="following-sibling::ARTICLEHOT-PHRASE[position() &lt; $hot-phrases-in-block]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</RANGE>
		</xsl:for-each>
	</xsl:variable>

	<xsl:key name="ranked-hot-phrases" match="ARTICLEHOT-PHRASE" use="RANK"/>

	<xsl:template match="ARTICLEHOT-PHRASES" mode="r_articlehotphrases">
		<xsl:apply-templates select="ARTICLEHOT-PHRASE" mode="c_articlehotphrases">
			<xsl:sort select="NAME" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_articlehotphrases">
		<xsl:variable name="popularity" select="$no-of-ranges + 1 - msxsl:node-set($ranked-hot-phrases)/RANGE[ARTICLEHOT-PHRASE[generate-id(current()) = @generate-id]]/@ID"/>

		<a href="{$root}ArticleSearch?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}" class="rank{$popularity}"><xsl:value-of select="NAME"/></a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
	Use: Presentation of the related key phrases
	-->
	<xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
		<xsl:if test="position() &lt; 20">
			<a href="{$root}ArticleSearch?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}"><xsl:value-of select="NAME"/></a><xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLEHOT-PHRASES" mode="editorialtool">
	Use: Presenatation of 100 most popular phrases to editors
	-->
	<xsl:template match="/H2G2/ARTICLEHOT-PHRASES" mode="editorialtool">
		<xsl:if test="$test_IsEditor">
			<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>position</th>
			<th>name</th>
			<th>rank</th>
			</tr>
			<xsl:for-each select="ARTICLEHOT-PHRASE">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><a href="{$root}ArticleSearch?contenttype={/H2G2/ARTICLEHOT-PHRASES/@ASSETCONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a></td>
			<td><xsl:value-of select="RANK"/></td>
			</tr>
			</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>


	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			NAVIGATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->


	<xsl:template match="ARTICLESEARCH" mode="search_hints">
		<xsl:variable name="currentPhraseCount" select="PHRASES/@COUNT"/>
		<xsl:variable name="currentPhrases">
			<xsl:for-each select="PHRASES/PHRASE">
				|<xsl:value-of select="TERM"/>
			</xsl:for-each>
		</xsl:variable>

		<!-- if current search matches one of the the searcHints, display the help message -->
		<xsl:for-each select="msxsl:node-set($searchHints)/hint">
			<!-- searchHints hint has same number of terms as current search -->
			<xsl:if test="$currentPhraseCount = count(./terms/term)">
				<!-- see if each searchHint term is one of the phrases in the current search. showHelp variable is empty if all terms match -->
				<xsl:variable name="showHelp">
					<xsl:for-each select="./terms/term">
						<xsl:choose>
							<xsl:when test="contains($currentPhrases, concat('|', .))">
								<xsl:text></xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>X</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>

				<xsl:if test="$showHelp = ''">
					<xsl:copy-of select="./message"/>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- pagination navigation -->
	<xsl:template match="ARTICLESEARCH" mode="page_info_bar">
		<xsl:variable name="pagenumber">
      <xsl:choose>
        <xsl:when test="@SHOW &gt; 0">
          <xsl:value-of select="floor(@SKIPTO div @SHOW) + 1" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pagetotal">
      <xsl:choose>
        <xsl:when test="@COUNT &gt; 0">
          <xsl:value-of select="ceiling(@TOTAL div @SHOW)" />
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
		</xsl:variable>

		<div id="pageInfoBar">
			<div>
				<xsl:text>Page</xsl:text>
				<xsl:value-of select="$pagenumber" />
				<xsl:text> of </xsl:text>
				<xsl:value-of select="$pagetotal" />
				<xsl:text> for </xsl:text>
				<xsl:for-each select="PHRASES/PHRASE">
					<xsl:value-of select="TERM"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="result_tool_bar">
		<xsl:variable name="searchterm">
			<xsl:for-each select="PHRASES/PHRASE"><xsl:value-of select="NAME"/><xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each>
		</xsl:variable>
		<xsl:variable name="params">
			<xsl:for-each select="/H2G2/PARAMS/PARAM">&amp;<xsl:value-of select="NAME"/>=<xsl:value-of select="VALUE"/></xsl:for-each>
			<xsl:if test="1">
			&amp;show=<xsl:value-of select="@SHOW"/>
			</xsl:if>
		</xsl:variable>

		<div id="resultToolBar">
			<div class="sortOptions">
				<span class="sortBy">Sort:</span>
				<xsl:choose>
					<xsl:when test="@SORTBY='DateCreated' or not(@SORTBY) or @SORTBY='' ">
						Date created
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}ArticleSearch?phrase={$searchterm}&amp;contenttype=-1">Date created</a>
					</xsl:otherwise>
				</xsl:choose>

        <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')">
          <!-- hide when displaying member pages as will not have ratings to sort by -->
          <xsl:text> | </xsl:text>
          <xsl:choose>
            <xsl:when test="@SORTBY='LastUpdated'">
              Most recently updated
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}ArticleSearch?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=LastUpdated{$params}">Most recently updated</a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

				<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')">
					<!-- hide when displaying member pages as will not have ratings to sort by -->
					<xsl:text> | </xsl:text>
					<xsl:choose>
						<xsl:when test="@SORTBY='Rating'">
							Highest rated
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}ArticleSearch?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=Rating{$params}">Highest rated</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

        <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')">
          <!-- hide when displaying member pages as will not have ratings to sort by -->
          <xsl:text> | </xsl:text>
          <xsl:choose>
            <xsl:when test="@SORTBY='LastPosted'">
              Last commented
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}ArticleSearch?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=LastPosted{$params}">Last commented</a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')">
          <!-- hide when displaying member pages as will not have ratings to sort by -->
          <xsl:text> | </xsl:text>
          <xsl:choose>
            <xsl:when test="@SORTBY='PostCount'">
              Most commented
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}ArticleSearch?phrase={$searchterm}&amp;contenttype=-1&amp;articlesortby=PostCount{$params}">Most commented</a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
			</div>
			<div class="rssFeed">
				<p>
					Subscribe to 606
				</p>
				<xsl:call-template name="rss_search_link"/>
			</div>
			<div class="clear"></div>
		</div>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="pagination_links">
		<xsl:variable name="pagenumber">
			<xsl:value-of select="floor(@SKIPTO div @SHOW) + 1" />
		</xsl:variable>

		<xsl:variable name="pagetotal">
	  	  <xsl:value-of select="ceiling(@TOTAL div @SHOW)" />
		</xsl:variable>

		<div class="page">
			<p>Page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" /></p>
			<div class="links">
				<div class="pagecol1">
					<!--[FIXME: hidden]
					<xsl:apply-templates select="." mode="c_firstpage"/>
					<xsl:text> | </xsl:text>
					-->
					<xsl:apply-templates select="." mode="c_previouspage"/>
				</div>
				<div class="pagecol2">
					<xsl:apply-templates select="." mode="c_articleblocks"/>
				</div>
				<div class="pagecol3">
					<xsl:apply-templates select="." mode="c_nextpage"/>
					<!--[FIXME: hidden]
					<xsl:text> | </xsl:text>
					<xsl:apply-templates select="." mode="c_lastpage"/>
					-->
				</div>
			</div>
			<div class="clear"></div>
		</div>
	</xsl:template>

	<!-- -->
	<xsl:template match="ARTICLESEARCH" mode="r_articleblocks">
		<xsl:apply-templates select="." mode="c_articleblockdisplay"/>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="on_articleblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!--
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_articleontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<strong><xsl:value-of select="$pagenumber"/></strong>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="ARTICLESEARCH" mode="off_articleblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!--
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_articleofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!--
	Use: Attribute sets for the links themselves
	-->
	<xsl:attribute-set name="mARTICLESEARCH_on_articleblockdisplay"/>
	<xsl:attribute-set name="mARTICLESEARCH_off_articleblockdisplay"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_nextpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_previouspage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_firstpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_lastpage"/>


	<xsl:template match="ARTICLESEARCH" mode="text_previouspage">
		<xsl:text>Previous </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_nextpage">
		<xsl:text>Next </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_firstpage">
		<xsl:text>First </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_lastpage">
		<xsl:text>Last </xsl:text>
	</xsl:template>


	<!-- override base files as need to have contenttype= in the querystring  -->
	<xsl:template match="ARTICLESEARCH" mode="link_nextpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) + number(@SHOW)}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpageartsp"/></a>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_previouspage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) - number(@SHOW)}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspageartsp"/></a>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip=0{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@TOTAL) - number(@SHOW)}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_lastpage">
			<xsl:copy-of select="$m_lastpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<!-- / override  -->


	<!-- override base files as needed to add contenttype and ArticleSortby to link -->
	<xsl:template match="ARTICLESEARCH" mode="displayblockartsp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @SHOW))"/>
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_articleblockdisplay">
					<xsl:with-param name="url">
						<xsl:call-template name="t_articleontabcontent">
							<xsl:with-param name="range" select="$PostRange"/>
							<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
						</xsl:call-template>
						<span class="bar"><xsl:text> | </xsl:text></span>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_articleblockdisplay">
					<xsl:with-param name="url"><xsl:value-of select="$onlink"/>
						<a href="{$root}ArticleSearch?skip={$skip}&amp;show={@SHOW}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_off_articleblockdisplay">
							<xsl:call-template name="t_articleofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
							</xsl:call-template>
						</a><span class="bar"><xsl:text> | </xsl:text></span>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- predefined tags - for editors to find content -->
	<xsl:template match="ARTICLESEARCHP" mode="predefinedtags">
	<table border="1" cellpadding="0" cellspacing="0" id="predefinedtags">
	<tr>
	<th>article type</th>
	<th>sport</th>
	<th>competition</th>
	<th>team</th>
	<th>date</th>
	</tr>
	<tr>
	<td valign="top">
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=user article">user&nbsp;article</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=staff article">staff&nbsp;article</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=event report">event&nbsp;report</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=player profile">player&nbsp;profile</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=team profile">team&nbsp;profile</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=staff article">staff&nbsp;article</a></li>
	</ul>

	<p>and/or</p>
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=article">article</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=report">report</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=profile">profile</a></li>
	</ul>

	<p>also</p>
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=member">member</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=sport">sport</a></li>
	</ul>
	</td>
	<td valign="top">
	<ul>
		<li><a href="{$root}articlesearch?contenttype=-1&amp;phrase=Football">Football</a></li>
		<li><a href="{$root}articlesearch?contenttype=-1&amp;phrase=Cricket">Cricket</a></li>
		<li><a href="{$root}articlesearch?contenttype=-1&amp;phrase=Rugby union">Rugby union</a></li>
		<li><a href="{$root}articlesearch?contenttype=-1&amp;phrase=Rugby league">Rugby league</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Tennis">Tennis</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Golf">Golf</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Motorsport">Motorsport</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Boxing">Boxing</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Athletics">Athletics</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Snooker">Snooker</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Horse racing">Horse racing</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cycling">Cycling</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Disability sport">Disability sport</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Othersport">Other</a></li>


		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=AmericanFootball">AmericanFootball</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Badminton">Badminton</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Baseball">Baseball</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Basketball">Basketball</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bowls">Bowls</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Darts">Darts</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Equestrian">Equestrian</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gaelic games">Gaelic games</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gymnastics">Gymnastics</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=IceHockey">IceHockey</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Netball">Netball</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Olympic games">Olympic games</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rowing">Rowing</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sailing">Sailing</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Shooting">Shooting</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sport Relief">Sport Relief</a></li>
    <li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sports Gaming">Sports Gaming</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sports Personality of the Year">Sports Personality of the Year</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sports Relief">Sports Relief</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Squash">Squash</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Swimming">Swimming</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=TableTennis">TableTennis</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Triathlon">Triathlon</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Weightlifting">Weightlifting</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Winter sports">Winter sports</a></li>

		<h3>Other sport</h3>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Othersport">Othersport</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Othersportusers">Othersportusers</a></li>
	</ul>
	</td>
	<td valign="top">
	<h3>football</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Premiership football">Premier League</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Championship football">Championship</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=League One football">League One</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=League Two football">League Two</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=English Non League football">English Non League</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=FA Cup football">FA Cup</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=League Cup football">League Cup</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scottish Premier football">Scottish Premier</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scottish League football">Scottish League</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scottish Cups football">Scottish Cups</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Welsh football">Welsh</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Irish football">Irish</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=International football">International football</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=European Football">European Football</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Africa">African</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Women football">Women</a></li>
	</ul>

	<h3>Cricket</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Test cricket">Test cricket</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=One-day internationals">One-day internationals</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=County cricket">County cricket</a></li>
	</ul>

	<h3>Rugby union</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Six Nations">Six Nations</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=International rugby">International rugby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=European club rugby">European club rugby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=English club rugby">English club rugby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Irish club rugby">Irish club rugby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scottish club rugby">Scottish club rugby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Welsh club rugby">Welsh club rugby</a></li>
	</ul>

	<h3>Rugby league</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Super League">Super League</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Challenge Cup">Challenge Cup</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Australian">Australian</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=International rugby league">International rugby league</a></li>
	</ul>

	<h3>Motorsport</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Formula One">Formula One</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rallying">Rallying</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Motorbikes">Motorbikes</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Speedway">Speedway</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Othertype">Othertype</a></li>
	</ul>

	<h3>other</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Othercompetition">Othercompetition</a></li>
	</ul>

	</td>
	<td valign="top">
	<h3>football</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Aberdeen">Aberdeen</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Accrington Stanley">Accrington Stanley</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Airdrie Utd">Airdrie Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Albion Rovers">Albion</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Aldershot">Aldershot</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Alloa">Alloa</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Altrincham">Altrincham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Arbroath">Arbroath</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Arsenal">Arsenal</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Aston Villa">Aston Villa</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ayr">Ayr</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Barnet">Barnet</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Barnsley">Barnsley</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Berwick">Berwick</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Birmingham">Birmingham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Blackburn">Blackburn</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Blackpool">Blackpool</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bolton">Bolton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Boston Utd">Boston Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bournemouth">Bournemouth</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bradford">Bradford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Brechin">Brechin</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Brentford">Brentford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Brighton">Brighton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bristol City">Bristol City</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bristol Rovers">Bristol Rovers</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Burnley">Burnley</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Burton Albion">Burton Albion</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bury">Bury</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cambridge Utd">Cambridge Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cardiff">Cardiff</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Carlisle">Carlisle</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Celtic">Celtic</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Charlton">Charlton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Chelsea">Chelsea</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cheltenham">Cheltenham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Chester">Chester</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Chesterfield">Chesterfield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Clyde">Clyde</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Colchester">Colchester</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Coventry">Coventry</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cowdenbeath">Cowdenbeath</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Crawley Town">Crawley Town</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Crewe">Crewe</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Crystal Palace">Crystal Palace</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Dag Red">Dag &amp; Red</a></li> <!-- check -->
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Darlington">Darlington</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Derby">Derby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Doncaster">Doncaster</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Dumbarton">Dumbarton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Dundee">Dundee</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Dundee Utd">Dundee Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Dunfermline">Dunfermline</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=East Fife">East Fife</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=East Stirling">East Stirling</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Elgin">Elgin</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=England">England</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Everton">Everton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Exeter">Exeter</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Falkirk">Falkirk</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Forest Green">Forest Green</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Forfar">Forfar</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Fulham">Fulham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gillingham">Gillingham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gravesend">Gravesend</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Grays Athletic">Grays Athletic</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gretna">Gretna</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Grimsby">Grimsby</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Halifax">Halifax</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hamilton">Hamilton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hartlepool">Hartlepool</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hearts">Hearts</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hereford">Hereford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hibernian">Hibernian</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Huddersfield">Huddersfield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hull">Hull</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Inverness CT">Inverness CT</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ipswich">Ipswich</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Kidderminster">Kidderminster</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Kilmarnock">Kilmarnock</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leeds">Leeds</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leicester">Leicester</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leyton Orient">Leyton Orient</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Lincoln City">Lincoln City</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Liverpool">Liverpool</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Livingston">Livingston</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Luton">Luton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Macclesfield">Macclesfield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Man City">Man City</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Man Utd">Man Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Mansfield">Mansfield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Middlesbrough">Middlesbrough</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Millwall">Millwall</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Milton Keynes Dons">Milton Keynes Dons</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Montrose">Montrose</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Morecambe">Morecambe</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Morton">Morton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Motherwell">Motherwell</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Newcastle">Newcastle</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Northampton">Northampton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Northern Ireland">Northern Ireland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Northwich">Northwich</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Norwich">Norwich</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Nottm Forest">Nottm Forest</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Notts County">Notts County</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Oldham">Oldham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Oxford Utd">Oxford Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Partick">Partick</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Peterborough">Peterborough</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Peterhead">Peterhead</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Plymouth">Plymouth</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Port Vale">Port Vale</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Portsmouth">Portsmouth</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Preston">Preston</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=QPR">QPR</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Queen of South">Queen of South</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Queens Park">Queens Park</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Raith">Raith</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rangers">Rangers</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Reading">Reading</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Republic of Ireland">Republic of Ireland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rochdale">Rochdale</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ross County">Ross County</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rotherham">Rotherham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Rushden  D'monds">Rushden &amp; D'monds</a></li><!-- check -->
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scotland">Scotland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scunthorpe">Scunthorpe</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sheff Utd">Sheff Utd</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sheff Wed">Sheff Wed</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Shrewsbury">Shrewsbury</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Southampton">Southampton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Southend">Southend</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Southport">Southport</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=St Albans">St Albans</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=St Johnstone">St Johnstone</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=St Mirren">St Mirren</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stafford Rangers">Stafford Rangers</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stenhousemuir">Stenhousemuir</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stevenage">Stevenage</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stirling">Stirling</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stockport">Stockport</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stoke">Stoke</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Stranraer">Stranraer</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sunderland">Sunderland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Swansea">Swansea</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Swindon">Swindon</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Tamworth">Tamworth</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Torquay">Torquay</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Tottenham">Tottenham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Tranmere">Tranmere</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wales">Wales</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Walsall">Walsall</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Watford">Watford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=West Brom">West Brom</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=West Ham">West Ham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Weymouth">Weymouth</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wigan">Wigan</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Woking">Woking</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wolverhampton">Wolverhampton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wrexham">Wrexham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wycombe">Wycombe</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Yeovil">Yeovil</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=York">York</a></li>
	</ul>

	<h3>Cricket</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Australia">Australia</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bangladesh">Bangladesh</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Derbyshire">Derbyshire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Durham">Durham</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=England">England</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Essex">Essex</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Glamorgan">Glamorgan</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gloucestershire">Gloucestershire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hampshire">Hampshire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=India">India</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ireland">Ireland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Kent">Kent</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Lancashire">Lancashire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leicestershire">Leicestershire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Middlesex">Middlesex</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=New Zealand">New Zealand</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Northants">Northants</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Nottinghamshire">Nottinghamshire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Pakistan">Pakistan</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scotland">Scotland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Somerset">Somerset</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=South Africa">South Africa</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sri Lanka">Sri Lanka</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Surrey">Surrey</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sussex">Sussex</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Warwickshire">Warwickshire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=West Indies">West Indies</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Worcestershire">Worcestershire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Yorkshire">Yorkshire</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Zimbabwe">Zimbabwe</a></li>
	</ul>

	<h3>Rugby union</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Australia">Australia</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bath">Bath</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Borders">Borders</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bristol">Bristol</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Cardiff Blues">Cardiff Blues</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Connacht">Connacht</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Edinburgh">Edinburgh</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=England">England</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=France">France</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Glasgow">Glasgow</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Gloucester">Gloucester</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Harlequins">Harlequins</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ireland">Ireland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Italy">Italy</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leicester">Leicester</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leinster">Leinster</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scarlets">Scarlets</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=London Irish">London Irish</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Munster">Munster</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=New Zealand">New Zealand</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Newcastle">Newcastle</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Newport-Gwent D'gons">Newport-Gwent D'gons</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Northampton">Northampton</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ospreys">Ospreys</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Sale">Sale</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Saracens">Saracens</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Scotland">Scotland</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=South Africa">South Africa</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Ulster">Ulster</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wales">Wales</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wasps">Wasps</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Worcester">Worcester</a></li>
	</ul>

	<h3>Rugby league</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Australia">Australia</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Bradford">Bradford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Castleford">Castleford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Catalans Dragons">Catalans Dragons</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Great Britain">Great Britain</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Harlequins RL">Harlequins RL</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Huddersfield">Huddersfield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Hull">Hull</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Leeds">Leeds</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=New Zealand">New Zealand</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Salford">Salford</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=St Helens">St Helens</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Wakefield">Wakefield</a></li>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Warrington">Warrington</a></li>
	</ul>

	<h3>Other</h3>
	<ul>
	<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=Otherteam">Otherteam</a></li>
	</ul>

	</td>
	<td valign="top">
	<h3>year</h3>
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=2006">2006</a></li>
	</ul>

	<h3>month</h3>
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=January">January</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=February">February</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=March">March</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=April">April</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=May">May</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=June">June</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=July">July</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=August">August</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=September">September</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=October">October</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=November">November</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=December">December</a></li>
	</ul>

	<h3>day</h3>
	<ul>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=1">1</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=2">2</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=3">3</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=4">4</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=5">5</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=6">6</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=7">7</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=8">8</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=9">9</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=10">10</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=11">11</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=12">12</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=13">13</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=14">14</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=15">15</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=16">16</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=17">17</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=18">18</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=19">19</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=20">20</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=21">21</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=22">22</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=23">23</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=24">24</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=25">25</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=26">26</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=27">27</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=28">28</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=29">29</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=30">30</a></li>
		<li><a href="{$root}ArticleSearch?contenttype=-1&amp;phrase=31">31</a></li>
	</ul>
	</td>
	</tr>
	</table>

	<!--
	todo:

	<p><em>could do this as a dynamic form interface to enable selection of combination of tags</em></p>

	-->

	</xsl:template>

</xsl:stylesheet>










