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
	<xsl:import href="../../../base/base-articlesearchphrase.xsl"/>
    	<!--
	<xsl:variable name="root">/dna/<xsl:value-of select="/H2G2/SITE/NAME"/>/</xsl:variable>
    	-->
	<xsl:variable name="rootbase">/dna/</xsl:variable>
	<xsl:variable name="assetroot">/dna/actionnetwork/icandev/</xsl:variable>
	<xsl:variable name="mediaassethome">MediaAsset</xsl:variable>
	<xsl:variable name="localimagesourcepath">c:/mediaassetuploadqueue</xsl:variable>
	<xsl:variable name="libraryext">library/</xsl:variable>
	<xsl:variable name="imagesourcepath">http://downloads.bbc.co.uk/dnauploads/test/</xsl:variable>

	<xsl:variable name="THIS_SEARCH_URL">
	</xsl:variable>
	
	<!-- url to go back to the advanced search form and 'remember' the user's inputs -->
	<xsl:variable name="advanced_search_url">
		<xsl:value-of select="$articlesearchroot"/>
		<xsl:text>&amp;s_mode=advanced</xsl:text>
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DATE and /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY = 0">
				<xsl:text>&amp;startdate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DATE"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY and /H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY != 0">
				<xsl:text>&amp;startdate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DATE and /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY = 0">
				<xsl:text>&amp;enddate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DATE"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY and /H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY != 0">
				<xsl:text>&amp;enddate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE != 0">
			<xsl:text>&amp;datesearchtype=</xsl:text>
			<xsl:value-of select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
		</xsl:if>
		
		<!-- s_phrase hold the phrases that were entered into the keywords field
		     (as opposed to the location phrase(s)
		-->
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_phrase']">
				<xsl:text>&amp;phrase=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE"/>
				<xsl:text>&amp;s_phrase=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- locations and keywords are all lumped together -->
				<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
					<xsl:value-of select="concat('&amp;phrase=', NAME)"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- pass back s_location to advanced search for to 'remember' the location -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_location']">
			<xsl:text>&amp;s_location=</xsl:text>
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_location']/VALUE"/>
		</xsl:if>

		<!-- pass back s_locationuser to advanced search for to 'remember' the locationuser -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_locationuser']">
			<xsl:text>&amp;s_locationuser=</xsl:text>
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_locationuser']/VALUE"/>
		</xsl:if>

		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE='list'">
			<xsl:text>&amp;s_view_mode=list</xsl:text>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'DateUploaded'">
				<xsl:text>&amp;s_articlesortby=DateUploaded</xsl:text>
				<xsl:text>&amp;s_view_mode=list</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'Caption'">
				<xsl:text>&amp;s_articlesortby=Caption</xsl:text>
				<xsl:text>&amp;s_view_mode=list</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE">
				<xsl:text>&amp;s_articlesortby=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE"/>
			</xsl:when>
		</xsl:choose>
		
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE">
			<xsl:text>&amp;s_datemode=</xsl:text>
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE"/>
		</xsl:if>
	</xsl:variable>


	<xsl:template name="ARTICLESEARCH_SUBJECT"/>
	<xsl:template name="ARTICLESEARCH_CSS"/>
	<xsl:template name="ARTICLESEARCH_JAVASCRIPT"/>	

	<xsl:template name="ARTICLESEARCH_HEADER">		
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:choose>
					<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE = 'SEARCH' or /H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE = 'list'">
						<xsl:text>View memories</xsl:text>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Search</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="rsstype">SEARCH</xsl:with-param>
		</xsl:apply-templates>

		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_usersubmit']/VALUE and not(/H2G2/PARAMS/PARAM[NAME='s_change_datefields']/VALUE)">
			<xsl:call-template name="AUTOSUBMIT_META"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ARTICLESEARCH_MAINBODY">
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="s_mode" select="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE"/>
		<xsl:variable name="s_view_mode" select="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE"/>

		<form method="get" action="{$articlesearchservice}" id="browseForm">
			<div id="ms-list-timeline">
				<div id="ms-list-timeline-header">
					<xsl:comment> ms-list-timeline-header </xsl:comment>
				</div>

				<!-- 
					We need to pass the search we just did to the article page
					(but only if it isn't the default search)
					-->
				<xsl:variable name="saveSearchUrl">
					<xsl:call-template name="SEARCH_URL">
						<xsl:with-param name="xml" select="SKIPROOT"/>
					</xsl:call-template>
					<xsl:for-each select="/H2G2/PARAMS/PARAM">
						<xsl:if test="NAME != 's_last_search'">
							<xsl:text disable-output-escaping="yes">&amp;</xsl:text>
							<xsl:value-of select="NAME" />
							<xsl:text>=</xsl:text>
							<xsl:value-of select="VALUE" />
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<!-- This is used on the back button (only if not default) -->
				<xsl:variable name="escapedSaveSearchUrl">
					<xsl:if test="$saveSearchUrl != $articlesearchbase">
						<xsl:call-template name="URL_ESCAPE">
							<xsl:with-param name="s" select="$saveSearchUrl"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>
				<xsl:comment> saveSearchUrl: <xsl:value-of select="$saveSearchUrl" /> </xsl:comment>
				
				<xsl:choose>
					<xsl:when test="$s_mode = 'advanced' or (ERROR and /H2G2/PARAMS/PARAM[NAME='s_from']/VALUE='advanced_search') or /H2G2/PARAMS/PARAM[NAME='s_change_datefields']">
						<xsl:apply-templates select="/H2G2[@TYPE='ARTICLESEARCH']" mode="advanced_search"/>
					</xsl:when>
					<xsl:when test="$s_view_mode = 'list'">
						<!-- BROWSE MODE -->
						<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_usersubmit']/VALUE)">
							<!--xsl:call-template name="DRILL_DOWN"/-->
							<div id="noFlashContent">
								<xsl:apply-templates select="ARTICLESEARCH/ARTICLES">
									<xsl:with-param name="escapedSaveSearchUrl" select="$escapedSaveSearchUrl" />
								</xsl:apply-templates>
							</div>
							<xsl:comment>// noFlashContent</xsl:comment>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_usersubmit']/VALUE)">
							<div id="noFlashContent">
								<xsl:apply-templates select="ARTICLESEARCH/ARTICLES">
									<xsl:with-param name="escapedSaveSearchUrl" select="$escapedSaveSearchUrl" />
								</xsl:apply-templates>
							</div>
							<xsl:comment>// noFlashContent</xsl:comment>							
							
							<xsl:if test="$astotal &gt; 0">
								<xsl:call-template name="flash-timeline-script">
									<xsl:with-param name="layerId">ms-list-timeline</xsl:with-param>
									<xsl:with-param name="checkCookie">true</xsl:with-param>
									<xsl:with-param name="search"><xsl:value-of select="$saveSearchUrl" /></xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<div id="ms-list-timeline-footer">
					<xsl:comment> ms-list-timeline-footer </xsl:comment>
				</div>
			</div>
			<div id="ms-post-timline">
				<!-- Render the show all memories button if we're in a keyword or date search -->
				<xsl:if test="(count(/H2G2/ARTICLESEARCH/PHRASES/PHRASE) &gt; 1) or (/H2G2/ARTICLESEARCH/@DATESEARCHTYPE != 0)">
					<div id="show-all-memories">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$articlesearchbase" />
							</xsl:attribute>
							<span><xsl:comment> - </xsl:comment></span>
							<xsl:text>Show all memories</xsl:text>
						</a>
					</div>
				</xsl:if>
				<div id="ms-search">
					<div id="ms-search-form">
						<input type="text" name="phrase" id="k_phrase" class="text">
							<xsl:attribute name="value">
								<xsl:call-template name="CHOP">
									<xsl:with-param name="s">
										<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
											<xsl:if test="not(starts-with(NAME, '_'))">
												<xsl:value-of select="NAME"/>
												<xsl:value-of select="$keyword_sep_char_disp"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:with-param>
									<xsl:with-param name="n">2</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</input>
						<input type="image" src="/memoryshare/assets/images/search-button-1.png" class="search-button" />
					</div>
				</div>
				<input type="hidden" name="contenttype" value="-1"/>
				<input type="hidden" name="phrase" value="_memory"/>
				<input type="hidden" name="s_from" value="drill_down"/>
				<input type="hidden" name="show" value="8"/>
				<xsl:if test="$astotal &gt; 0">
					<input type="hidden" name="s_last_search">
						<xsl:attribute name="value">
							<xsl:call-template name="SEARCH_AUTOSUBMIT_URL"/>
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
			<div id="ms-features">
				<xsl:call-template name="feature-pod" />
				<xsl:call-template name="client-pod" />
			</div>
		</form>

		<xsl:variable name="decade">
			<xsl:call-template name="GET_DECADE"/>
		</xsl:variable>

		<xsl:variable name="year">
			<xsl:call-template name="GET_YEAR"/>
		</xsl:variable>

		<xsl:variable name="month">
			<xsl:call-template name="GET_MONTH"/>
		</xsl:variable>

		<xsl:variable name="day">
			<xsl:call-template name="GET_DAY"/>
		</xsl:variable>

		<script type="text/javascript">
		<xsl:text disable-output-escaping="yes">
		// &lt;![CDATA[

			var lastDecade = '</xsl:text><xsl:value-of select="$lastDecade" /><xsl:text disable-output-escaping="yes">';
			var decade = '</xsl:text><xsl:value-of select="$decade" /><xsl:text disable-output-escaping="yes">';
			var year = '</xsl:text><xsl:value-of select="$year" /><xsl:text disable-output-escaping="yes">';
			var month = '</xsl:text><xsl:value-of select="$month" /><xsl:text disable-output-escaping="yes">';
			var day = '</xsl:text><xsl:value-of select="$day" /><xsl:text disable-output-escaping="yes">';

			$(document).ready(function () {
				initArticleSearch();
			});

		//]]&gt;
		</xsl:text>
		</script>
	</xsl:template>

	<!-- 
		this constructs the url which the meta refresh redirects to.
		the purpose of this is to put in the actual parameters that articlesearch expects
		from inputs from the drop-downs, etc.
	-->
	<xsl:variable name="startdate">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_startdate']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_startdate']/VALUE"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART">
				<xsl:call-template name="IMPLODE_DATE">
					<xsl:with-param name="day" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
					<xsl:with-param name="month" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
					<xsl:with-param name="year" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="enddate">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_enddate']">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_enddate']/VALUE"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGEEND">
				<xsl:call-template name="IMPLODE_DATE">
					<xsl:with-param name="day" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
					<xsl:with-param name="month" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
					<xsl:with-param name="year" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="decade">
		<xsl:choose>
			<xsl:when test="$startdate != ''">
				<xsl:call-template name="PARSE_DATE_DECADE">
					<xsl:with-param name="date" select="$startdate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="year">
		<xsl:choose>
			<xsl:when test="$startdate != ''">
				<xsl:call-template name="PARSE_DATE_YEAR">
					<xsl:with-param name="date" select="$startdate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="month">
		<xsl:choose>
			<xsl:when test="$startdate != ''">
				<xsl:call-template name="PARSE_DATE_MONTH">
					<xsl:with-param name="date" select="$startdate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="day">
		<xsl:choose>
			<xsl:when test="$startdate != ''">
				<xsl:call-template name="PARSE_DATE_DAY">
					<xsl:with-param name="date" select="$startdate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template name="SEARCH_URL">
		<xsl:param name="xml">N</xsl:param>
		<xsl:param name="sortBy"></xsl:param>
		<xsl:param name="keywords">Y</xsl:param>
		<xsl:variable name="url">
			<xsl:choose>
				<xsl:when test="$xml='Y'">
					<xsl:value-of select="concat($feedroot, 'xml/')"/>
				</xsl:when>
				<xsl:when test="$xml='N'">
					<xsl:value-of select="$root"/>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="$articlesearchbase"/>
			
			<xsl:if test="/H2G2/ARTICLESEARCH/@SKIPTO and /H2G2/ARTICLESEARCH/@SKIPTO &gt; 0">
				<xsl:text>&amp;skip=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/@SKIPTO"/>
			</xsl:if>
			
			<xsl:if test="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE &gt; 0">
				<xsl:text>&amp;datesearchtype=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="not($sortBy) or ($sortBy = '')">
					<xsl:if test="/H2G2/ARTICLESEARCH/@DESCENDINGORDER and /H2G2/ARTICLESEARCH/@DESCENDINGORDER &gt; 0">
						<xsl:text>&amp;descendingorder=</xsl:text>
						<xsl:value-of select="/H2G2/ARTICLESEARCH/@DESCENDINGORDER"/>
					</xsl:if>			
					
					<xsl:if test="/H2G2/ARTICLESEARCH/@SORTBY and /H2G2/ARTICLESEARCH/@SORTBY != ''">
						<xsl:text>&amp;articlesortby=</xsl:text>
						<xsl:value-of select="/H2G2/ARTICLESEARCH/@SORTBY"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$sortBy = 'StartDate'">
					<xsl:text>&amp;articlesortby=StartDate&amp;descendingorder=1</xsl:text>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
				<xsl:text>&amp;startdate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
				<xsl:text>%2F</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
				<xsl:text>%2F</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
				<xsl:text>&amp;startday=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
				<xsl:text>&amp;startmonth=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
				<xsl:text>&amp;startyear=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
			</xsl:if>
			
			<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGEEND">
				<xsl:text>&amp;enddate=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
				<xsl:text>%2F</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
				<xsl:text>%2F</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
				<xsl:text>&amp;endday=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
				<xsl:text>&amp;endmonth=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
				<xsl:text>&amp;endyear=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
			</xsl:if>
			
			<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES and $keywords = 'Y'">
				<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
					<xsl:if test="TERM != '_memory'"> 
						<xsl:text>&amp;phrase=</xsl:text>
						<xsl:value-of select="TERM"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		
		<xsl:value-of select="$url"/>
	</xsl:template>
	
	<xsl:template name="SEARCH_AUTOSUBMIT_URL">
		<xsl:param name="xml">N</xsl:param>

		<xsl:variable name="url">
			<xsl:choose>
				<xsl:when test="$xml='Y'">
					<xsl:value-of select="concat($feedroot, 'xml/')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$root"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$articlesearchbase"/>
			
			<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_newsearch']/VALUE=1) or /H2G2/PARAMS/PARAM[NAME='s_startdate']/VALUE != ''">
				<xsl:choose>
					<xsl:when test="$startdate != '' and $startdate != '//' and $enddate != '' and $enddate != '//'">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_datesearchtype']">
								<xsl:text>&amp;datesearchtype=</xsl:text>
								<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_datesearchtype']/VALUE"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>&amp;datesearchtype=2</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>&amp;startdate=</xsl:text><xsl:value-of select="$startdate"/>
						<xsl:text>&amp;enddate=</xsl:text><xsl:value-of select="$enddate"/>
						<xsl:text>&amp;s_startdate=</xsl:text>
						<xsl:call-template name="FORMAT_DATE">
							<xsl:with-param name="date" select="$startdate"/>
						</xsl:call-template>
						<xsl:text>&amp;s_enddate=</xsl:text>
						<xsl:call-template name="FORMAT_DATE">
							<xsl:with-param name="date" select="$enddate"/>
						</xsl:call-template>
						<xsl:text>&amp;s_dateview=day</xsl:text>
					</xsl:when>
					<xsl:when test="$startdate != '' and $startdate != '//'">
						<xsl:text>&amp;datesearchtype=2</xsl:text>
						<xsl:text>&amp;startdate=</xsl:text><xsl:value-of select="$startdate"/>
						<xsl:text>&amp;s_startdate=</xsl:text>
						<xsl:call-template name="FORMAT_DATE">
							<xsl:with-param name="date" select="$startdate"/>
						</xsl:call-template>
						<xsl:text>&amp;s_dateview=day</xsl:text>
					</xsl:when>
					<xsl:when test="$day and $day != 'null' and $day != ''">
						<xsl:text>&amp;datesearchtype=2</xsl:text>
						<xsl:text>&amp;startday=</xsl:text><xsl:value-of select="$day"/>
						<xsl:text>&amp;startmonth=</xsl:text><xsl:value-of select="$month"/>
						<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="$year"/>
						<xsl:text>&amp;s_startdate=</xsl:text>
						<xsl:call-template name="IMPLODE_DATE">
							<xsl:with-param name="day" select="$day"/>
							<xsl:with-param name="month" select="$month"/>
							<xsl:with-param name="year" select="$year"/>
						</xsl:call-template>
						<xsl:text>&amp;s_dateview=day</xsl:text>
					</xsl:when>
					<xsl:when test="$month and $month != 'null' and $month != ''">
						<xsl:text>&amp;datesearchtype=2</xsl:text>
						<xsl:text>&amp;startday=1</xsl:text>
						<xsl:text>&amp;startmonth=</xsl:text><xsl:value-of select="$month"/>
						<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="$year"/>
						<xsl:text>&amp;endday=</xsl:text><xsl:value-of select="msxsl:node-set($months)/list/item[@m=number($month)]/@days"/>
						<xsl:text>&amp;endmonth=</xsl:text><xsl:value-of select="$month"/>
						<xsl:text>&amp;endyear=</xsl:text><xsl:value-of select="$year"/>
						<xsl:text>&amp;s_dateview=month</xsl:text>
					</xsl:when>
					<xsl:when test="$year and $year != 'null' and $year != ''">
						<xsl:text>&amp;datesearchtype=2</xsl:text>
						<xsl:text>&amp;startday=1</xsl:text>
						<xsl:text>&amp;startmonth=1</xsl:text>
						<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="$year"/>
						<xsl:text>&amp;endday=31</xsl:text>
						<xsl:text>&amp;endmonth=12</xsl:text>
						<xsl:text>&amp;endyear=</xsl:text><xsl:value-of select="$year"/>
						<xsl:text>&amp;s_dateview=year</xsl:text>
					</xsl:when>
					<xsl:when test="$decade and $decade != 'null' and $decade != ''">
						<xsl:text>&amp;datesearchtype=2</xsl:text>
						<xsl:text>&amp;startday=1</xsl:text>
						<xsl:text>&amp;startmonth=1</xsl:text>
						<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="$decade"/>
						<xsl:text>&amp;endday=31</xsl:text>
						<xsl:text>&amp;endmonth=12</xsl:text>
						<xsl:text>&amp;endyear=</xsl:text><xsl:value-of select="$decade+9"/>
						<xsl:text>&amp;s_dateview=decade</xsl:text>
					</xsl:when>
					<!--[FIXME: remove]
					<xsl:when test="($startdate = '' or $startdate = '//') and /H2G2/ARTICLESEARCH/PHRASES/PHRASE">
						<xsl:text>&amp;datesearchtype=0</xsl:text>
						<xsl:text>&amp;s_foo=6</xsl:text>
					</xsl:when>
					-->
					<xsl:otherwise>
						<!-- default view -->
						<xsl:text>&amp;s_dateview=century</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="$day and $day != 'null'"><xsl:text>&amp;s_day=</xsl:text><xsl:value-of select="$day"/></xsl:if>
				<xsl:if test="$month and $month != 'null'"><xsl:text>&amp;s_month=</xsl:text><xsl:value-of select="$month"/></xsl:if>
				<xsl:if test="$year and $year != 'null'"><xsl:text>&amp;s_year=</xsl:text><xsl:value-of select="$year"/></xsl:if>
				<xsl:if test="$decade and $decade != 'null'"><xsl:text>&amp;s_decade=</xsl:text><xsl:value-of select="$decade"/></xsl:if>
			</xsl:if>

			<!-- keywords. also save all of them in s_phrase -->
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_from']/VALUE = 'advanced_search'">
					<xsl:text>&amp;phrase=</xsl:text>
					<xsl:call-template name="REPLACE_STRING">
						<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE"/>
						<xsl:with-param name="what"><xsl:text> </xsl:text></xsl:with-param>
						<xsl:with-param name="replacement">%20</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&amp;s_phrase=</xsl:text>
					<xsl:call-template name="REPLACE_STRING">
						<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE"/>
						<xsl:with-param name="what"><xsl:text> </xsl:text></xsl:with-param>
						<xsl:with-param name="replacement">%20</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
						<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
							<xsl:value-of select="concat('&amp;phrase=', NAME)"/>
						</xsl:for-each>
						<xsl:text>&amp;s_phrase=</xsl:text>
						<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
							<xsl:value-of select="NAME"/>
							<xsl:if test="position() != last()">
								<xsl:text>%20</xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		
			<!-- convert s_location to phrase -->
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_location']">
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_PARAMS">
					<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_location']/VALUE"/>
					<xsl:with-param name="param">phrase</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_PARAMS">
					<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_location']/VALUE"/>
					<xsl:with-param name="param">s_location</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		
			<!-- convert s_locationuser to phrase -->
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_locationuser']">
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_PARAMS">
					<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_locationuser']/VALUE"/>
					<xsl:with-param name="param">phrase</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="SPLIT_KEYWORDS_INTO_PARAMS">
					<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_locationuser']/VALUE"/>
					<xsl:with-param name="param">s_locationuser</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			
			<!-- articlesortby -->
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']">
				<xsl:text>&amp;articlesortby=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE"/>
				<xsl:text>&amp;s_articlesortby=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE"/>
			</xsl:if>

			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_from']">
				<xsl:text>&amp;s_from=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_from']/VALUE"/>
			</xsl:if>
			
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']">
				<xsl:text>&amp;s_view_mode=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE"/>
			</xsl:if>
		</xsl:variable>

        <xsl:value-of select="$url"/>
    </xsl:template>

	<xsl:template name="AUTOSUBMIT_META">
		<xsl:variable name="url">
			<xsl:call-template name="SEARCH_AUTOSUBMIT_URL"/>
        	</xsl:variable>

		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_nometa']/VALUE=1">
				<code>[<xsl:value-of select="translate($url, '  &#xA;&#xD;', '')"/>]</code>
				<a href="{translate($url, '  &#xA;&#xD;', '')}">go</a>
			</xsl:when>
			<xsl:otherwise>
				<meta http-equiv="REFRESH" content="0;url={translate($url, '  &#xA;&#xD;', '')}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="initialView">
		<xsl:choose>
			<!--
			<xsl:when test="$startdate != '' and $startdate != '//' and $enddate != '' and $enddate != '//'">
				<xsl:text>day</xsl:text>
			</xsl:when>
			<xsl:when test="$startdate != '' and $startdate != '//'">
				<xsl:text>day</xsl:text>
			</xsl:when>
			-->
			<xsl:when test="$day and $day != 'null' and $day != ''">
				<xsl:text>day</xsl:text>
			</xsl:when>
			<xsl:when test="$month and $month != 'null' and $month != ''">
				<xsl:text>month</xsl:text>
			</xsl:when>
			<xsl:when test="$year and $year != 'null' and $year != ''">
				<xsl:text>year</xsl:text>
			</xsl:when>
			<xsl:when test="$decade and $decade != 'null' and $decade != ''">
				<xsl:text>decade</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- default view -->
				<xsl:text>century</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="ERROR" mode="articlesearch">
		<div class="alert">
			<xsl:choose>
				<xsl:when test="contains(ERRORMESSAGE, 'STARTDATE_INVALID')">
					<xsl:text>You have entered an invalid date</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>There has been an error</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLESEARCH</xsl:with-param>
		<xsl:with-param name="pagename">articlesearch.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<!-- Show current search phrases -->
		<!--
		<xsl:apply-templates select="PHRASES"/>
		-->

		<!-- Show hot phrases-->
		<!--
		<xsl:apply-templates select="ARTICLEHOT-PHRASES" mode="r_threadsearchphrasepage"/>
		-->

		<!--[FIXME: Search for users?]
		<xsl:variable name="search_form_action">		
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_searchtype']/VALUE = 'member'">Search</xsl:when>
				<xsl:otherwise>ArticleSearch</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		-->

	</xsl:template>
	
	<xsl:template name="DRILL_DOWN">
		<!--[FIXME: wrong place?]
		<xsl:apply-templates select="ERROR" mode="articlesearch"/>
		<xsl:call-template name="SEARCH_RSS_FEED"/>
		-->
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


			<div>
				<h2>View memories</h2>
				<p>Explore our timeline of memories either by browsing 
				around dates, or by searching for specific memories by 
				keyword and/or date.
				</p>
				<xsl:if test="$astotal &gt; 0">
					<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE = 'list')">
						<!-- write in the view as list link -->								
						<xsl:text disable-output-escaping="yes">
						&lt;script type="text/javascript"&gt;
						// &lt;![CDATA[
						if (bbcjs.plugins.flashVersion >= 8 &amp;&amp; !getViewHTMLCookie()) {
							document.write('You can also &lt;a href="#" onclick="viewAsListFromHTML()"&gt;view memories as a list&lt;/a&gt;.');
						}
						else if (bbcjs.plugins.flashVersion >= 8) {
							document.write('You can also &lt;a href="#" onclick="viewAsFlashTimeline()"&gt;view memories in a timeline&lt;/a&gt;.');
						}
						//]]&gt;
						&lt;/script&gt;
						</xsl:text>								
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="ERROR" mode="articlesearch"/>
			</div>
			<div>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$articlesearch_browse_mode = 2">right2</xsl:when>
						<xsl:otherwise>right</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
				<form method="get" action="{$articlesearchservice}" id="browseForm">
					<div>
						<input type="hidden" name="contenttype" value="-1"/>
						<input type="hidden" name="phrase" value="_memory"/>
						<input type="hidden" name="s_from" value="drill_down"/>
						<input type="hidden" name="show" value="8"/>
						<xsl:if test="$astotal &gt; 0">
							<input type="hidden" name="s_last_search">
								<xsl:attribute name="value">
									<xsl:call-template name="SEARCH_AUTOSUBMIT_URL"/>
								</xsl:attribute>
							</input>
						</xsl:if>
						<!--
						<input type="hidden" name="s_nometa" value="1"/>
						-->
					</div>				
					<div id="browseWrapper">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="$articlesearch_browse_mode = 2">delete</xsl:when>
								<xsl:otherwise>js</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<fieldset id="browse">
							<legend>Browse</legend>
							<select name="s_decade" id="s_decade" title="decade">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<!--
								<xsl:if test="not($decade) or $decade = 'null' or $decade = ''">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								-->
								<option class="nullOption" value="null">Decade</option>
								<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS">
									<xsl:with-param name="last" select="$lastDecade"/>
									<xsl:with-param name="selectedValue" select="$decade"/>
								</xsl:call-template>
							</select>

							<select name="s_year" id="s_year" title="year">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<!--
								<xsl:if test="not($decade) or $decade = 'null' or $decade = ''">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								-->

								<option class="nullOption" value="null">Year</option>
								<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS">
									<xsl:with-param name="decade" select="$decade"/>
									<xsl:with-param name="max" select="$decade + 9"/>
									<xsl:with-param name="selectedValue" select="$year"/>
								</xsl:call-template>
							</select>

							<select name="s_month" id="s_month" title="month">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<!--
								<xsl:if test="not($year) or $year = 'null' or $year = ''">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								-->

								<option class="nullOption" value="null">Month</option>
								<xsl:call-template name="DD_GENERATE_MONTH_OPTIONS">
									<xsl:with-param name="year" select="$year"/>
									<xsl:with-param name="selectedValue" select="$month"/>
								</xsl:call-template>
							</select>

							<select name="s_day" id="s_day" title="day">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
								<!--
								<xsl:if test="not($month) or $month = 'null' or $month = ''">
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								-->

								<option class="nullOption" value="null">Day</option>
								<xsl:call-template name="DD_GENERATE_DAY_OPTIONS">
									<xsl:with-param name="year" select="$year"/>
									<xsl:with-param name="month" select="$month"/>
									<xsl:with-param name="selectedValue" select="number($day)"/>
								</xsl:call-template>
							</select>
						</fieldset>
					</div>
					<noscript>
						<fieldset id="browse_d">
							<legend>Browse</legend>
							<select name="s_decade" id="s_decade_d" title="decade">
								<option class="nullOption" value="null">Decade</option>
								<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS_DUMB">
									<xsl:with-param name="selectedValue" select="$decade"/>
								</xsl:call-template>
							</select>

							<select name="s_year" id="s_year_d" title="year">
								<option class="nullOption" value="null">Year</option>
								<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS_DUMB">
									<xsl:with-param name="selectedValue" select="$year"/>
								</xsl:call-template>
							</select>

							<select name="s_month" id="s_month_d" title="month">
								<option class="nullOption" value="null">Month</option>
								<xsl:call-template name="DD_GENERATE_MONTH_OPTIONS_DUMB">
									<xsl:with-param name="selectedValue" select="$month"/>
								</xsl:call-template>
							</select>

							<select name="s_day" id="s_day_d" title="day">
								<option class="nullOption" value="null">Day</option>
								<xsl:call-template name="DD_GENERATE_DAY_OPTIONS_DUMB">
									<xsl:with-param name="selectedValue" select="number($day)"/>
								</xsl:call-template>
							</select>
						</fieldset>
					</noscript>
					<xsl:if test="$articlesearch_browse_mode = 1">
						<xsl:call-template name="CALENDAR_WIDGET"/>
					</xsl:if>
					<fieldset id="search">
						<legend>Search</legend>
						<div class="left">
							<label for="k_phrase">keyword (e.g. fishing)</label><br/>
							<input type="text" name="phrase" id="k_phrase">
								<xsl:attribute name="value">
									<xsl:call-template name="CHOP">
										<xsl:with-param name="s">
											<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
												<xsl:if test="not(starts-with(NAME, '_'))">
													<xsl:value-of select="NAME"/>
													<xsl:value-of select="$keyword_sep_char_disp"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:with-param>
										<xsl:with-param name="n">2</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</input>
						</div>
						<div class="right">
							<label for="s_startdate">date (e.g. 25/10/1976)</label>
							<br/>
							<input type="text" name="s_startdate" id="s_startdate">
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_startdate']">
											<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_startdate']/VALUE"/>
										</xsl:when>
										<xsl:when test="/H2G2/ARTICLESEARCH/DATERANGESTART">
											<xsl:variable name="is_next_day">
												<xsl:call-template name="IS_NEXT_DAY">
													<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
													<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
													<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
													<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
													<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
													<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:if test="$is_next_day='yes'">
												<xsl:call-template name="IMPLODE_DATE">
													<xsl:with-param name="day" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
													<xsl:with-param name="month" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
													<xsl:with-param name="year" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
												</xsl:call-template>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>						

						<input type="radio" name="s_newsearch" id="s_newsearch_0" value="0" class="radio">
							<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_newsearch']/VALUE=1)">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<xsl:text> </xsl:text>
						<label for="s_newsearch_0">within current date range</label>
						<xsl:text> </xsl:text>
						<input type="radio" name="s_newsearch" id="s_newsearch_1" value="1" class="radio">
							<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_newsearch']/VALUE=1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<xsl:text> </xsl:text>						
						<label for="s_newsearch_1">new search</label>

						<!--[FIXME: using cookies rather than this]
						<script language="javascript" type="text/javascript">
							<xsl:text>var _s_view_mode_checked = </xsl:text>
							<xsl:choose>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE='list'">
									<xsl:text>true;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>false;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<![CDATA[
							document.write('<p><input type="checkbox" name="s_view_mode" id="s_view_mode" value="list" ' + (_s_view_mode_checked? 'checked="checked"' : '')  + '/>');
							document.write(' <label for="s_view_mode">view as list</label></p>');
							]]>
						</script>
						<noscript>
							<input type="hidden" name="s_view_mode" value="list"/>
						</noscript>
						-->
					</fieldset>

					<div class="submitRow">
						<!-- only non-js clients use the s_usersubmit 2-step search -->
						<noscript>
							<div><input type="hidden" name="s_usersubmit" value="1"/></div>
						</noscript>
						<xsl:choose>
							<xsl:when test="$articlesearch_browse_mode = 2">
								<xsl:call-template name="CALENDAR_WIDGET">
									<xsl:with-param name="id">widgetBox2</xsl:with-param>
								</xsl:call-template>
								<input type="submit" value="Go" class="submit"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="submit" value="Go" class="submit"/>
								<p><a href="{$articlesearchservice}?s_mode=advanced">Advanced Search</a></p>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<xsl:if test="$articlesearch_browse_mode = 2">
						<div id="extraRow">
							<xsl:if test="$astotal &gt; 0">
								<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE = 'list')">
									<!-- write in the view as list link -->
									<xsl:text disable-output-escaping="yes">
									&lt;script type="text/javascript"&gt;
									// &lt;![CDATA[
										if (bbcjs.plugins.flashVersion >= 8 &amp;&amp; !getViewHTMLCookie()) {
											document.write('&lt;a href="#" onclick="viewAsListFromHTML()" class="switcher"&gt;View memories as a list&lt;/a&gt;');
										}
										else if (bbcjs.plugins.flashVersion >= 8) {
											document.write('&lt;a href="#" onclick="viewAsFlashTimeline()" class="switcher"&gt;View memories in a timeline&lt;/a&gt;');
										}
									//]]&gt;
									&lt;/script&gt;
									</xsl:text>
								</xsl:if>
							</xsl:if>
							<a href="{$articlesearchservice}?s_mode=advanced">Advanced Search</a>
							<p class="error">
								<xsl:apply-templates select="ERROR" mode="articlesearch"/>
							</p>
						</div>
					</xsl:if>
				</form>
			</div>
			<xsl:variable name="js_view_name">
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s">
						<xsl:call-template name="VIEW_NAME"/>
					</xsl:with-param>
					<xsl:with-param name="what">'</xsl:with-param>
					<xsl:with-param name="replacement">\'</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript"&gt;
			// &lt;![CDATA[
			if (dna_articlesearch_total > 0 &amp;&amp; !getViewHTMLCookie()) {
				document.write('&lt;div id="viewLabel"&gt;&lt;h3&gt;</xsl:text>
					<xsl:value-of select="$js_view_name"/>
			<xsl:text disable-output-escaping="yes">&lt;/h3&gt;&lt;/div&gt;');
			}
			//]]&gt;
			&lt;/script&gt;
			</xsl:text>
			<div id="helpLink">
				<a href="{$root}help">Help</a>
			</div>

	</xsl:template>

	<xsl:template name="CALENDAR_WIDGET">
		<xsl:param name="id">widgetBox</xsl:param>
		<div id="{$id}">
			<div class="calHolder" id="calHolder" style="display:none">
					<xsl:comment> Avoid self closing tag </xsl:comment>
			</div>
			<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript"&gt;
			// &lt;![CDATA[
				document.write('&lt;a href="#" id="trigger2" class="trigger" onclick="bbcjs.calendar.showHideCal(event); return false;"&gt;&lt;img src="{$imagesource}calendarIcon.gif" alt="calendar"/&gt;&lt;/a&gt;');
				bbcjs.calendar.cbFunc = "setBrowseDate";
				bbcjs.calendar.showWeeks = false;
			//]]&gt;
			&lt;/script&gt;
			</xsl:text>
		</div>
	</xsl:template>
	
	<xsl:template name="CONTEXT_INCLUDE">
		<xsl:param name="mode">SEARCH</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$mode = 'SEARCH'">
				<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_dateview']/VALUE = 'day'">
					<xsl:if test="not(/H2G2/ERROR)">
						<xsl:variable name="contextDate">
							<xsl:call-template name="IMPLODE_DATE">
								<xsl:with-param name="day" select="$day"/>
								<xsl:with-param name="month" select="$month"/>
								<xsl:with-param name="year" select="$year"/>
								<xsl:with-param name="delim">-</xsl:with-param>
								<xsl:with-param name="revFormat">yes</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>

						<xsl:comment>#include virtual="/cgi-perl-ssi/memoryshare/contextdata.pl?date=<xsl:value-of select="$contextDate"/>" </xsl:comment>
						<xsl:comment>@include virtual="/cgi-perl-ssi/memoryshare/contextdata.pl?date=<xsl:value-of select="$contextDate"/>" </xsl:comment>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$mode = 'ARTICLE'">
				<xsl:variable name="article_date_range_type">
					<xsl:call-template name="ARTICLE_DATE_RANGE_TYPE"/>
				</xsl:variable>
				
				<xsl:if test="$article_date_range_type != 0">
					<xsl:if test="not(/H2G2/ERROR)">
						<xsl:variable name="article_startday">
							<xsl:call-template name="ARTICLE_STARTDAY"/>
						</xsl:variable>

						<xsl:variable name="article_startmonth">
							<xsl:call-template name="ARTICLE_STARTMONTH"/>
						</xsl:variable>

						<xsl:variable name="article_startyear">
							<xsl:call-template name="ARTICLE_STARTYEAR"/>
						</xsl:variable>					
						<xsl:variable name="contextDate">
							<xsl:call-template name="IMPLODE_DATE">
								<xsl:with-param name="day" select="$article_startday"/>
								<xsl:with-param name="month" select="$article_startmonth"/>
								<xsl:with-param name="year" select="$article_startyear"/>
								<xsl:with-param name="delim">-</xsl:with-param>
								<xsl:with-param name="revFormat">yes</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>

						<xsl:comment>#include virtual="/cgi-perl-ssi/memoryshare/contextdata.pl?date=<xsl:value-of select="$contextDate"/>" </xsl:comment>
						<xsl:comment>@include virtual="/cgi-perl-ssi/memoryshare/contextdata.pl?date=<xsl:value-of select="$contextDate"/>" </xsl:comment>
					</xsl:if>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']" mode="advanced_search">
		<div id="topPage">
			<h2>Advanced search</h2>
			<p>What would you like to search for?</p>

			<xsl:apply-templates select="ERROR" mode="articlesearch"/>
		</div>
		
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
			</div>
			
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_filter']/VALUE = 'member'">
					<div class="inner">
						<form method="GET" action="Search" id="userSearchForm">
							<label for="user">
								Search here for a particular author. 
							</label>
							<br/>
							<input type="hidden" name="searchtype" value="USER"/>
							<input type="hidden" name="thissite" value="1"/>
							<input type="hidden" name="s_filter" value="member"/>

							<input type="text" name="searchstring" id="user" class="txt"/>
							<input type="submit" name="dosearch" value="Go" class="submit"/>
						</form>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<form method="get" action="{$articlesearchservice}" class="advancedSearchForm" id="advancedSearchForm">
						<div class="inner">						
							<input type="hidden" name="contenttype" value="-1"/>
							<input type="hidden" name="phrase" value="_memory"/>
							<input type="hidden" name="show" value="8"/>
							<input type="hidden" name="s_from" value="advanced_search"/>
							<!--
							<input type="hidden" name="s_nometa" value="1"/>
							-->
							<xsl:choose>
								<xsl:when test="$advanced_search_daterange = 'yes'">
									<p>
									Search here for memories relating to a specific date, or a date range, by UK location from the BBC site list, or by a keyword or keywords. 
									Or you can <a href="#memorycontent">search memory content</a>. 
									When you have entered your search options, select how you want the results to be displayed, and click 'Go'. 
									</p>
								</xsl:when>
								<xsl:otherwise>
									<p>
									Search here for memories relating to a specific date, by UK location from the BBC site list, or by a keyword or keywords. 
									Or you can <a href="#memorycontent">search memory content</a>. 
									When you have entered your search options, select how you want the results to be displayed, and click 'Go'. 
									</p>
								</xsl:otherwise>
							</xsl:choose>

							<fieldset>
								<legend class="lrg">Search for memories by date/keyword/location</legend>	
								<fieldset id="dateSelector">
									<legend>Date</legend>
									<xsl:choose>
										<xsl:when test="$advanced_search_daterange = 'yes'">
											<p>Please choose from</p>

											<input type="radio" class="radio" name="s_datemode" id="radSpecDate" value="Specific" onclick="javascript:datefieldsWriteAdvancedSearch('Specific')">
												<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE='Specific' or not(/H2G2/PARAMS/PARAM[NAME='s_datemode'])">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input><xsl:text> </xsl:text>
											<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE='Specific' or not(/H2G2/PARAMS/PARAM[NAME='s_datemode'])">
												<script type="text/javascript">
													var dfnOverride = 'Specific';
												</script>
											</xsl:if>

											<label for="radSpecDate">Search for a specific date (e.g. 25/10/1976)</label><br/>

											<input type="radio" class="radio" name="s_datemode" id="radRangeDate" value="Daterange" onclick="javascript:datefieldsWriteAdvancedSearch('Daterange')">
												<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE='Daterange'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input><xsl:text> </xsl:text>
											<label for="radRangeDate">Search for a date range (e.g. from 01/09/1975 to 25/10/1976)</label><br/>

											<p class="rAlign">
												<noscript>
													<input type="submit" name="s_change_datefields" value="Enter dates &gt;" class="submit"/>
												</noscript>
											</p>
										</xsl:when>
										<xsl:otherwise>
											<xsl:comment>KONKER1</xsl:comment>
											<script language="javascript" type="text/javascript">
												var dfnOverride = 'Specific';
											</script>
											<input type="hidden" name="s_datemode" id="radSpecDate" value="Specific"/>
										</xsl:otherwise>
									</xsl:choose>
								</fieldset>
							
								<script language="javascript" type="text/javascript">
									/*
										<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
										<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
										<xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
									*/
									<xsl:call-template name="DATEFIELDS_DATERANGE_JS_STR">
										<xsl:with-param name="startdate" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DATE"/>
										<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
										<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
										<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
										<xsl:with-param name="enddate" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DATE"/>
										<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
										<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
										<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
										<xsl:with-param name="datesearchtype" select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
										<xsl:with-param name="startname">s_startdate</xsl:with-param>
										<xsl:with-param name="endname">s_enddate</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="DATEFIELDS_SPECIFIC_JS_STR">
										<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
										<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
										<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
										<xsl:with-param name="startname">s_startdate</xsl:with-param>
									</xsl:call-template>
								</script>

								<!-- div into which javascript strings containing datefield markup is written into -->
								<div id="datefields">
									<noscript>
										<xsl:choose>
											<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE='Daterange' and $advanced_search_daterange = 'yes'">
												<xsl:call-template name="DATEFIELDS_DATERANGE">
													<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
													<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
													<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
													<xsl:with-param name="endday" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
													<xsl:with-param name="endmonth" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
													<xsl:with-param name="endyear" select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
													<xsl:with-param name="datesearchtype" select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
													<xsl:with-param name="startname">s_startdate</xsl:with-param>
													<xsl:with-param name="endname">s_enddate</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="DATEFIELDS_SPECIFIC">
													<xsl:with-param name="startday" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
													<xsl:with-param name="startmonth" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
													<xsl:with-param name="startyear" select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
													<xsl:with-param name="startname">s_startdate</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</noscript>
								</div>
							</fieldset>
							
							<label for="s_phrase"><b>Keywords</b> 
								<span>
								Looking for memories indexed by keywords? 
								Keywords may relate to a place or event or activity.
								
								If you want to search on more than one keyword, 
								separate them with a <xsl:value-of select="$keyword_sep_name"/> e.g. Glastonbury<xsl:value-of select="$keyword_sep_char_disp"/>festival<xsl:value-of select="$keyword_sep_char_disp"/>rain.
								</span>
							</label><br/>

							<input type="text" name="s_phrase" id="s_phrase">
								<xsl:attribute name="value">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_phrase']/VALUE"/>
								</xsl:attribute>
							</input>

							<!--[FIXME: proper markup/css not br-->
							<br/>
							<br/>
							<h4>Location (UK)</h4>
							<p>
							Looking for memories from a specific area in the UK?<br/>
							You can select from this list of BBC regional sites to find local memories.
							</p>

							<script type="text/javascript"> 
							<![CDATA[ 
								writeTabNav();
							]]>
							</script>
						</div>
						
						<xsl:variable name="mapUrl">
							<xsl:value-of select="$flashsource"/>
							<xsl:text>locationMap.swf</xsl:text>
							<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_location']">
								<xsl:text>?selectedLocale=</xsl:text>
								<xsl:call-template name="SPLIT_KEYWORDS">
									<xsl:with-param name="s" select="/H2G2/PARAMS/PARAM[NAME='s_location']/VALUE"/>
									<xsl:with-param name="outdelim" select="$keyword_sep_char_url_enc"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:variable>

						<div id="flashMapTarg">
							<script type="text/javascript">
							<xsl:text disable-output-escaping="yes">
							// &lt;![CDATA[								
								var mapUrl = "</xsl:text><xsl:value-of select="$mapUrl"/><xsl:text disable-output-escaping="yes">";
								var mapWidth = 437;
								var mapHeight = 350;

								if (bbcjs.plugins.flashVersion &gt;= 8) {
									var wilmap = new bbcjs.plugins.FlashMovie(mapUrl);
									wilmap.version = 8;
									wilmap.width = mapWidth;
									wilmap.height = mapHeight;
									wilmap.id = "WILMap";
									wilmap.name = "WILMap";
									wilmap.allowScriptAccess = "always";
									wilmap.loop = true; // taking this out will break the map in certain circs.

									bbcjs.addOnLoadItem('fnHideItem("noFlashContent")');
									wilmap.embed();
									//myEmbed(wilmap);

									// put this in to overcome javascript error in IE
									// which occurs when flash uses ExternalInterface
									WILMap = document.getElementById("WILMap");
								}
							//]]&gt;
							</xsl:text>
							</script>
						</div>

						<xsl:call-template name="GENERATE_COMBINED_LOCATION_RADIOS_NON_FLASH_CONTENT">
							<xsl:with-param name="selectedValue" select="/H2G2/PARAMS/PARAM[NAME='s_location']/VALUE"/>
							<xsl:with-param name="fieldName">s_location</xsl:with-param>
						</xsl:call-template>
						<br/>
						<div class="inner">
							<label for="locationuser" class="bld">Tell us more (e.g France, Paris or England, Portsmouth)</label><br/>
							<input type="text" name="s_locationuser" id="s_locationuser" class="txtWide">
								<xsl:attribute name="value">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_locationuser']/VALUE"/>
								</xsl:attribute>
							</input><br/>
						</div>
						<br/>
						<div class="inner">
							<fieldset>
								<legend>Sort results by</legend>
								<input type="radio" name="s_articlesortby" value="DateUploaded" id="sortByDate" class="radio">
										<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'DateUploaded'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
								</input><xsl:text> </xsl:text>
								<label for="sortByDate">Date memory was submitted</label><br/>

								<input type="radio" name="s_articlesortby" value="Caption" id="sortByAZ" class="radio">
										<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'Caption'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
								</input><xsl:text> </xsl:text>
								<label for="sortByAZ">A-Z of memory title</label><br/>

								<input type="radio" name="s_articlesortby" value="Startdate" id="sortByMemDate" class="radio">
										<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE = 'Startdate' or not(/H2G2/PARAMS/PARAM[NAME='s_articlesortby']/VALUE)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
								</input><xsl:text> </xsl:text>
								<label for="sortByMemDate">Memory date</label><br/>
							</fieldset>
							<noscript>
								<input type="hidden" name="s_usersubmit" value="1"/>
							</noscript>
							<p>
								<input type="submit" value="Go" class="submit"/>
							</p>
						</div>
					</form>
					<div class="hozRule"><hr/></div>
					<form method="GET" action="Search" class="advancedSearchForm" id="fullTextForm">
						<div class="inner">
							<input type="hidden" name="showapproved" value="1"/>
							<input type="hidden" name="showsubmitted" value="1"/>
							<input type="hidden" name="shownormal" value="1"/>
							<input type="hidden" name="searchtype" value="article"/>
							<input type="hidden" name="show" value="8"/>
							
							<label for="memContent" class="lrg" id="memorycontent">
								<b>Or search memory content</b> 
								<span>
								Use this search to search all memory content for specific words.  
								If you want to search on more than one word, 
								separate them with a space (e.g. Glastonbury festival rain) 
								but please note, it will only look for memories that contain all those words.<br/>
								Enter text and click 'Go'.
								</span>
							</label>

							<input type="text" name="searchstring" id="memContent" class="text"/>
               				<input type="submit" value="Go" class="submit" />
						</div>
					</form>
				</xsl:otherwise>
			</xsl:choose>
			<div class="barStrong"></div>
		</div>
	</xsl:template>

	<!--SEARCH RESULTS-->
	<xsl:template match="ARTICLES">
		<xsl:param name="escapedSaveSearchUrl" />
		<xsl:param name="url" select="'A'" />
		<!--xsl:param name="target">_top</xsl:param-->
		
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLES</xsl:with-param>
		<xsl:with-param name="pagename">articlesearch.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- pass some information to javascript -->
		<script type="text/javascript">
		<xsl:text disable-output-escaping="yes">
		// &lt;![CDATA[
			var dna_articlesearch_total = '</xsl:text><xsl:value-of select="$astotal"/>';
		<xsl:text disable-output-escaping="yes">
		//]]&gt;
		</xsl:text>
		</script>
		
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE='advanced')">			
			<xsl:choose>
				<xsl:when test="$astotal = 0">
					<ul>
						<li class="altrow">
							<p>Sorry, we couldn't find any memories for this search.  If you've used several words try separating the key phrases with commas.<br/>For instance, "manchester, football" or "bbc radio 1, john peel".</p>
							<p><a title="Would you like to add your own memory?">
									<xsl:attribute name="href">
										<!-- Magnetic North - added a new template that sends user straight to add a memory after login -->
										<xsl:call-template name="sso_typedarticle_signin2"/>
									</xsl:attribute>
									<xsl:text>Would you like to add your own memory?</xsl:text></a></p>
						</li>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="decade">
						<xsl:call-template name="GET_DECADE"/>
					</xsl:variable>

					<xsl:variable name="year">
						<xsl:call-template name="GET_YEAR"/>
					</xsl:variable>

					<xsl:variable name="month">
						<xsl:call-template name="GET_MONTH"/>
					</xsl:variable>

					<xsl:variable name="day">
						<xsl:call-template name="GET_DAY"/>
					</xsl:variable>

					<xsl:call-template name="sortOrderLayer">
						<xsl:with-param name="escapedSaveSearchUrl" select="$escapedSaveSearchUrl" />
					</xsl:call-template>

					<noscript>
						<div id="ms-list-filter">
							<div id="ms-list-filter-top">&nbsp;</div>
							<div id="ms-list-filter-inner">
								<fieldset id="browse">
									<legend>Filter memories by date</legend>
									<!-- 
									Non Javascript dropdowns have all the possible options 
									and a manual submit button.
									Javascript dropdowns will auto update as you select stuff
									-->
									<label for="s_decade_d">Decade</label>
									<select name="s_decade" id="s_decade_d" title="decade">
										<option class="nullOption" value="null">Decade</option>
										<xsl:call-template name="DD_GENERATE_DECADE_OPTIONS_DUMB">
											<xsl:with-param name="selectedValue" select="$decade"/>
										</xsl:call-template>
									</select>
									<label for="s_year_d">Year</label>
									<select name="s_year" id="s_year_d" title="year">
										<option class="nullOption" value="null">Year</option>
										<xsl:call-template name="DD_GENERATE_YEAR_OPTIONS_DUMB">
											<xsl:with-param name="selectedValue" select="$year"/>
										</xsl:call-template>
									</select>
									<label for="s_month_d">Month</label>
									<select name="s_month" id="s_month_d" title="month">
										<option class="nullOption" value="null">Month</option>
										<xsl:call-template name="DD_GENERATE_MONTH_OPTIONS_DUMB">
											<xsl:with-param name="selectedValue" select="$month"/>
										</xsl:call-template>
									</select>
									<label for="s_day_d">Day</label>
									<select name="s_day" id="s_day_d" title="day">
										<option class="nullOption" value="null">Day</option>
										<xsl:call-template name="DD_GENERATE_DAY_OPTIONS_DUMB">
											<xsl:with-param name="selectedValue" select="number($day)"/>
										</xsl:call-template>
									</select>
									<p id="filter-submit">
										<input type="hidden" name="s_usersubmit" value="1"/>
										<input type="image" src="/memoryshare/assets/images/list-filter-button.png" />
									</p>								
								</fieldset>
							</div>
							<div id="ms-list-filter-footer">&nbsp;</div>
						</div>
					</noscript>				
					<ul>
						<xsl:apply-templates select="ARTICLE" mode="article_list_item">
							<xsl:with-param name="fromSearch" select="$escapedSaveSearchUrl" />
						</xsl:apply-templates>
					</ul>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$astotal != 0">				
				<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links_revised"/>				
			</xsl:if>			
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="article_list_item_replace">
		<xsl:call-template name="REPLACE_STRING">
			<xsl:with-param name="s" select="."/>
			<xsl:with-param name="what">amp;</xsl:with-param>
			<xsl:with-param name="replacement"></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="AUTODESCRIPTION" mode="article_list_item">
		<xsl:choose>
			<xsl:when test="string-length(.) &gt; 110">
				<xsl:value-of select="substring(.,1,107)" />
				<xsl:text>...</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>				
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="article_list_item">		
		<xsl:param name="url" select="'A'" />
		<xsl:param name="fromSearch"></xsl:param>
		<xsl:param name="target">_top</xsl:param>
		
		<xsl:variable name="cur_list_article_type" select="EXTRAINFO/TYPE/@ID"/>

		<xsl:variable name="alternatingClassName">
			<xsl:if test="position() mod 2 = 1">
				<xsl:text>altrow </xsl:text>
			</xsl:if>			
		</xsl:variable>

		<xsl:variable name="memoryDayName">
			<xsl:choose>
				<xsl:when test="DATERANGESTART/DATE/@DAYNAME and DATERANGESTART/DATE/@DAYNAME != ''">
					<xsl:value-of select="DATERANGESTART/DATE/@DAYNAME" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="DATECREATED/DATE/@DAYNAME" />
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
			<xsl:if test="SUBJECT != ''">
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s">
						<xsl:value-of select="SUBJECT" />
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
		
		<li>
			<xsl:attribute name="class">
				<xsl:value-of select="$alternatingClassName" />
				<xsl:text>dow-</xsl:text>
				<xsl:value-of select="$memoryDayNumber" />
			</xsl:attribute>
      <span class="lv-icon">
        <a>
          <xsl:attribute name="class">
            <xsl:text>dow-</xsl:text>
            <xsl:value-of select="$memoryDayNumber" />
            <xsl:text>-medium-</xsl:text>
			<xsl:value-of select="$memoryStartLetter" />
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>
            <xsl:value-of select="$url"/>
            <xsl:value-of select="@H2G2ID"/>
            <xsl:value-of select="H2G2-ID"/>
            <xsl:if test="$fromSearch != ''">
              <xsl:text>?s_fromSearch=</xsl:text>
              <xsl:value-of select="$fromSearch" />
            </xsl:if>
            <!--[FIXME: what is this?]
							<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES/@PARAM">
								&amp;phrase=<xsl:value-of select="/H2G2/ARTICLESEARCH/PHRASES/@PARAM"/>
							</xsl:if>
							-->
          </xsl:attribute>
          <!--xsl:attribute name="target">
							<xsl:value-of select="$target"/>
						</xsl:attribute-->

          <!--[TODO: 	this is a workaround as memories could appear in lists, 
									but without the SUBJECT	when they are in moderation/hidden]
						-->
          <xsl:choose>
            <xsl:when test="SUBJECT != ''">
              <xsl:value-of select="SUBJECT" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>This memory is queued for moderation or has been removed</xsl:text>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:if test="msxsl:node-set($type)/type[@number=$cur_list_article_type]/@subtype='staff_memory'">
            <xsl:text> (Added by the BBC)</xsl:text>
          </xsl:if>
        </a>
      </span>
      <p>
        <strong>
          <span class="title">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$root"/>
                <xsl:value-of select="$url"/>
                <xsl:value-of select="@H2G2ID"/>
                <xsl:value-of select="H2G2-ID"/>
                <xsl:if test="$fromSearch != ''">
                  <xsl:text>?s_fromSearch=</xsl:text>
                  <xsl:value-of select="$fromSearch" />
                </xsl:if>
                <!--[FIXME: what is this?]
							<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES/@PARAM">
								&amp;phrase=<xsl:value-of select="/H2G2/ARTICLESEARCH/PHRASES/@PARAM"/>
							</xsl:if>
							-->
              </xsl:attribute>
              <!--xsl:attribute name="target">
							<xsl:value-of select="$target"/>
						</xsl:attribute-->

              <!--[TODO: 	this is a workaround as memories could appear in lists, 
									but without the SUBJECT	when they are in moderation/hidden]
						-->
              <xsl:choose>
                <xsl:when test="SUBJECT != ''">
                  <xsl:value-of select="SUBJECT" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>This memory is queued for moderation or has been removed</xsl:text>
                </xsl:otherwise>
              </xsl:choose>

              <xsl:if test="msxsl:node-set($type)/type[@number=$cur_list_article_type]/@subtype='staff_memory'">
                <xsl:text> (Added by the BBC)</xsl:text>
              </xsl:if>
            </a>
          </span>
        </strong>
        <xsl:text> </xsl:text>

        <!-- date -->
        <span class="lv-memory-date">
          <xsl:choose>
            <xsl:when test="DATERANGESTART/DATE/@DATE or (DATERANGESTART/DATE/@DAY and DATERANGESTART/DATE/@DAY != 0)">
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
                <xsl:with-param name="startdate" select="$startdate" />
                <xsl:with-param name="startday" select="$startday" />
                <xsl:with-param name="startmonth" select="$startmonth" />
                <xsl:with-param name="startyear" select="$startyear" />
                <xsl:with-param name="enddate" select="$enddate" />
                <xsl:with-param name="endday" select="$endday" />
                <xsl:with-param name="endmonth" select="$endmonth" />
                <xsl:with-param name="endyear" select="$endyear" />
                <xsl:with-param name="timeinterval" select="$timeinterval" />
                <xsl:with-param name="mode">LIST</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:comment> No date </xsl:comment>
            </xsl:otherwise>
          </xsl:choose>
        </span>
        <!-- summary -->
        <!--[TODO:	If the SUBJECT is empty, this implies that the article is in moderation/hidden.
						In such a case do not display the summary.
			-->
        <xsl:if test="SUBJECT != ''">
          <br/>
          <xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION" mode="article_list_item"/>
        </xsl:if>
      </p>			
		</li>
	</xsl:template>

	<xsl:template match="PHRASE" mode="search_link">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$articlesearchroot"/>
				<xsl:text>&amp;phrase=</xsl:text>
				<xsl:value-of select="NAME"/>
				<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE='list'">
					<xsl:text>&amp;s_view_mode=list</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>

	<!-- HOT PHRASES -->
	<xsl:template match="ARTICLEHOT-PHRASES" mode="r_threadsearchphrasepage">
		<xsl:if test=".!=''">
			<h2>Article tag cloud</h2>

			<xsl:apply-templates select="ARTICLEHOT-PHRASE" mode="r_threadsearchphrasepage"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_threadsearchphrasepage">
		<li>
			<xsl:value-of select="NAME"/> (<xsl:value-of select="RANK"/>)
		</li>
	</xsl:template>

	<xsl:template match="PHRASES">
		The Phrases you chose are:
		<xsl:apply-templates select="PHRASE"/>
	</xsl:template>

	<xsl:template match="PHRASE">
		<li>
			<xsl:value-of select="NAME"/>
		</li>
	</xsl:template>

	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="results_total">
		<xsl:param name="all">false</xsl:param>
		<!--[FIXME: adapt]
		<p>
			<xsl:text>Found </xsl:text>
			<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@TOTAL &gt; 1">
					<xsl:text> memories</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> memory</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		-->
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:text>Showing </xsl:text>
		<xsl:if test="$all='true'">
			<xsl:text>all </xsl:text>
		</xsl:if>
		<span id="astotal"><xsl:value-of select="$astotal"/></span>
		<xsl:choose>
			<xsl:when test="$astotal &gt; 1 or $astotal = 0">
				<xsl:text> memories</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> memory</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- pagination navigation -->
	<xsl:variable name="page_block_size">9</xsl:variable>
	
	<xsl:template match="ARTICLESEARCH" mode="pagination_links_revised">
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="total_pages">
			<xsl:value-of select="ceiling($astotal div @SHOW)" />
		</xsl:variable>

		<xsl:variable name="current_page">
			<xsl:value-of select="(@SKIPTO div @SHOW) + 1" />
		</xsl:variable>
		
		<xsl:variable name="block_start_page">
			<xsl:choose>
				<xsl:when test="$total_pages &lt;= $page_block_size">1</xsl:when>
				<!--
				<xsl:when test="$current_page &lt; $page_block_size">
					<xsl:value-of select="($current_page - ($current_page mod $page_block_size)) + 1"/>
				</xsl:when>
				-->
				<xsl:otherwise>
					<xsl:value-of select="($current_page - (($current_page - 1) mod $page_block_size))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="block_end_page">
			<xsl:choose>
				<xsl:when test="$total_pages &lt;= $page_block_size">
					<xsl:value-of select="$total_pages"/>
				</xsl:when>
				<xsl:when test="($block_start_page + $page_block_size - 1) &gt;= $total_pages">
					<xsl:value-of select="$total_pages"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$block_start_page + $page_block_size - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="as_search_params">
			<xsl:text>&amp;contenttype=-1</xsl:text>
			<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
				<xsl:text>&amp;phrase=</xsl:text><xsl:value-of select="TERM"/>
			</xsl:for-each>
			<xsl:if test="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE">
				<xsl:text>&amp;datesearchtype=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
			</xsl:if>
			<xsl:if test="/H2G2/ARTICLESEARCH/@TIMEINTERVAL != 0">
				<xsl:text>&amp;timeinterval=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/@TIMEINTERVAL"/>
			</xsl:if>
			<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
				<xsl:text>&amp;startday=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
				<xsl:text>&amp;startmonth=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
				<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
			</xsl:if>
			<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
				<xsl:text>&amp;endday=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
				<xsl:text>&amp;endmonth=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
				<xsl:text>&amp;endyear=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
			</xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_mode']">
				<xsl:text>&amp;s_mode=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE"/>
			</xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']">
				<xsl:text>&amp;s_view_mode=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE"/>
			</xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE">&amp;s_decade=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE"/></xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE">&amp;s_year=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE"/></xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE">&amp;s_month=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE"/></xsl:if>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE">&amp;s_day=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE"/></xsl:if>
			<xsl:if test="/H2G2/ARTICLESEARCH/@DESCENDINGORDER and /H2G2/ARTICLESEARCH/@DESCENDINGORDER &gt; 0">
				<xsl:text>&amp;descendingorder=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/@DESCENDINGORDER"/>
			</xsl:if>
			<xsl:if test="/H2G2/ARTICLESEARCH/@SORTBY and /H2G2/ARTICLESEARCH/@SORTBY != ''">
				<xsl:text>&amp;articlesortby=</xsl:text>
				<xsl:value-of select="/H2G2/ARTICLESEARCH/@SORTBY"/>
			</xsl:if>			
		</xsl:variable>
		
		<xsl:if test="$total_pages &gt; 1">
			<div id="ms-list-pagination">
				<ul>
					<xsl:apply-templates select="." mode="pagination_prev_revised">
						<xsl:with-param name="current_page" select="$current_page"/>
						<xsl:with-param name="total_pages" select="$total_pages"/>
						<xsl:with-param name="as_search_params" select="$as_search_params"/>
					</xsl:apply-templates>
					
					<xsl:apply-templates select="." mode="pagination_block_revised">
						<xsl:with-param name="block_start_page" select="$block_start_page"/>
						<xsl:with-param name="block_end_page" select="$block_end_page"/>
						<xsl:with-param name="current_page" select="$current_page"/>
						<xsl:with-param name="as_search_params" select="$as_search_params"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="." mode="pagination_next_revised">
						<xsl:with-param name="current_page" select="$current_page"/>
						<xsl:with-param name="total_pages" select="$total_pages"/>
						<xsl:with-param name="as_search_params" select="$as_search_params"/>
					</xsl:apply-templates>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="pagination_prev_revised">
		<xsl:param name="current_page"/>
		<xsl:param name="total_pages"/>
		<xsl:param name="as_search_params"/>

		<xsl:variable name="prev_page_skip" select="($current_page - 2) * @SHOW"/>

		<li class="prev">
			<xsl:choose>
				<xsl:when test="$current_page &gt; 1">
					<a href="{$articlesearchservice}?show={@SHOW}&amp;skip={$prev_page_skip}{$as_search_params}">
						<xsl:text>Previous</xsl:text>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Previous</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="pagination_next_revised">
		<xsl:param name="current_page"/>
		<xsl:param name="total_pages"/>
		<xsl:param name="as_search_params"/>
		
		<xsl:variable name="next_page_skip" select="$current_page * @SHOW"/>

		<li class="next">
			<xsl:choose>
				<xsl:when test="$current_page &lt; $total_pages">
					<a href="{$articlesearchservice}?show={@SHOW}&amp;skip={$next_page_skip}{$as_search_params}">
						<xsl:text>Next</xsl:text>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Next</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="pagination_block_revised">
			<xsl:param name="block_start_page"/>
			<xsl:param name="block_end_page"/>
			<xsl:param name="current_page"/>
			<xsl:param name="as_search_params"/>
			
			<xsl:variable name="first_page_skip" select="($block_start_page - 1) * @SHOW"/>
			
			<xsl:if test="$block_start_page &lt;= $block_end_page">
				<li>
					<xsl:if test="$block_start_page = $current_page">
						<xsl:attribute name="class">current</xsl:attribute>
					</xsl:if>
					<a href="{$articlesearchservice}?show={@SHOW}&amp;skip={$first_page_skip}{$as_search_params}">
						<xsl:value-of select="$block_start_page"/>
					</a>
				</li>
				
				<xsl:apply-templates select="." mode="pagination_block_revised">
					<xsl:with-param name="block_start_page" select="$block_start_page + 1"/>
					<xsl:with-param name="block_end_page" select="$block_end_page"/>
					<xsl:with-param name="current_page" select="$current_page"/>
					<xsl:with-param name="as_search_params" select="$as_search_params"/>
				</xsl:apply-templates>
			</xsl:if>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="pagination_links">
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="pagenumber">
			<xsl:value-of select="floor(@SKIPTO div @COUNT) + 1" />
		</xsl:variable>
		
		<xsl:variable name="pagetotal">
	  	  <xsl:value-of select="ceiling($astotal div @COUNT)" />
		</xsl:variable>
	
		<!--
		<p>
			<xsl:value-of select="@TOTAL"/> 
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="@TOTAL = 1">memory, </xsl:when>
				<xsl:otherwise>memories, </xsl:otherwise>
			</xsl:choose>
			
			page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" />
		</p>
		-->
		<!--[FIXME: adapt]
		<div class="links">
			<div class="pagecol1"><xsl:apply-templates select="." mode="c_firstpage"/> | <xsl:apply-templates select="." mode="c_previouspage"/> </div>
			<div class="pagecol2"><xsl:apply-templates select="." mode="c_articleblocks"/></div>   
			<div class="pagecol3"><xsl:apply-templates select="." mode="c_nextpage"/> | <xsl:apply-templates select="." mode="c_lastpage"/></div>
		</div>
		-->
		<span><xsl:text>Page: </xsl:text></span>
		<xsl:apply-templates select="." mode="c_articleblocks"/>
		<xsl:apply-templates select="." mode="c_nextpage"/>
	</xsl:template>

	<!-- overrides and additions from base-articlesearchphrase.xsl -->
	<xsl:template match="ARTICLESEARCH" mode="c_nextpage">
		<xsl:variable name="astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW and /H2G2/ARTICLESEARCH/@SKIPTO = 0">
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="(@SKIPTO + @COUNT) &lt; $astotal">
				<xsl:text> | </xsl:text>
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="as_searchparams">
		<xsl:text>&amp;contenttype=-1&amp;phrase=_memory</xsl:text>
		<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
			<xsl:text>&amp;phrase=</xsl:text><xsl:value-of select="TERM"/>
		</xsl:for-each>
		<xsl:if test="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE">
			<xsl:text>&amp;datesearchtype=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/@DATESEARCHTYPE"/>
		</xsl:if>
		<xsl:if test="/H2G2/ARTICLESEARCH/@TIMEINTERVAL != 0">
			<xsl:text>&amp;timeinterval=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/@TIMEINTERVAL"/>
		</xsl:if>
		<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
			<xsl:text>&amp;startday=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@DAY"/>
			<xsl:text>&amp;startmonth=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@MONTH"/>
			<xsl:text>&amp;startyear=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGESTART/DATE/@YEAR"/>
		</xsl:if>
		<xsl:if test="/H2G2/ARTICLESEARCH/DATERANGESTART">
			<xsl:text>&amp;endday=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@DAY"/>
			<xsl:text>&amp;endmonth=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@MONTH"/>
			<xsl:text>&amp;endyear=</xsl:text><xsl:value-of select="/H2G2/ARTICLESEARCH/DATERANGEEND/DATE/@YEAR"/>
		</xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_mode']">
			<xsl:text>&amp;s_mode=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE"/>
		</xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view_mode']">
			<xsl:text>&amp;s_view_mode=</xsl:text><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE"/>
		</xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE">&amp;s_decade=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_decade']/VALUE"/></xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE">&amp;s_year=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_year']/VALUE"/></xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE">&amp;s_month=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_month']/VALUE"/></xsl:if>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE">&amp;s_day=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_day']/VALUE"/></xsl:if>
	</xsl:variable>
	
	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="link_previouspage">
		<a href="{$articlesearchservice}?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}{$as_searchparams}">
			<xsl:copy-of select="$m_previouspageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="link_nextpage">
		<a href="{$articlesearchservice}?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}{$as_searchparams}">
			<xsl:copy-of select="$m_nextpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>	


	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="link_firstpage">
		<a href="{$articlesearchservice}?show={@COUNT}&amp;skip=0{$as_searchparams}">
			<xsl:copy-of select="$m_firstpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="link_lastpage">
		<a href="{$articlesearchservice}?show={@COUNT}&amp;skip={number(@TOTAL) - number(@COUNT)}{$as_searchparams}">
			<xsl:copy-of select="$m_lastpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="c_articleblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$as_artsp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblockartsp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTAL) and ($skip &lt; $as_artsp_upperrange)">
			<xsl:apply-templates select="." mode="c_articleblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

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
	
	
	<xsl:template match="ARTICLESEARCH" mode="text_previouspage">
		<xsl:text>previous </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_nextpage">
		<xsl:text>next </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_firstpage">
		<xsl:text>first </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_lastpage">
		<xsl:text>last </xsl:text>
	</xsl:template>
	




	<xsl:variable name="as_artspsplit" select="9"/>
	
	<!--tp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:variable name="as_artsp_lowerrange">
		<xsl:value-of select="floor(/H2G2/ARTICLESEARCH/@SKIPTO div ($as_artspsplit * /H2G2/ARTICLESEARCH/@COUNT)) * ($as_artspsplit * /H2G2/ARTICLESEARCH/@COUNT)"/>
	</xsl:variable>
	<!--tp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:variable name="as_artsp_upperrange">
		<xsl:value-of select="$as_artsp_lowerrange + (($as_artspsplit - 1) * /H2G2/ARTICLESEARCH/@COUNT)"/>
	</xsl:variable>
	
	<xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']/ARTICLESEARCH" mode="displayblockartsp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_articleblockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_articleontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$articlesearchservice}?skip={$skip}&amp;show={@COUNT}{$as_searchparams}" xsl:use-attribute-sets="mARTICLESEARCH_on_articleblockdisplay">
									<xsl:call-template name="t_articleontabcontent">
										<xsl:with-param name="range" select="$PostRange"/>
										<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
									</xsl:call-template>
								</a><xsl:text> </xsl:text> 
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_articleblockdisplay">
					<xsl:with-param name="url">
						<a href="{$articlesearchservice}?skip={$skip}&amp;show={@COUNT}{$as_searchparams}" xsl:use-attribute-sets="mARTICLESEARCH_off_articleblockdisplay">
							<xsl:call-template name="t_articleofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
							</xsl:call-template>
						</a><xsl:text> </xsl:text> 
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- RSS FEED LINK -->	
	<xsl:template name="SEARCH_RSS_FEED_META">
		<link rel="alternative" type="application/rdf+xml">
			<xsl:attribute name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:call-template name="VIEW_NAME"/>
			</xsl:attribute>
			<xsl:attribute name="href">
				<xsl:call-template name="SEARCH_URL">
					<xsl:with-param name="xml">Y</xsl:with-param>
				</xsl:call-template>
				<xsl:text>&amp;s_xml=</xsl:text>
				<xsl:value-of select="$rss_param"/>
				<xsl:text>&amp;sortby=dateuploaded</xsl:text>
				<xsl:text>&amp;s_client=</xsl:text>
				<xsl:value-of select="$client"/>
				<xsl:text>&amp;show=</xsl:text>
				<xsl:value-of select="$rss_show"/>
				<!--[FIXME: not needed]
				<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
					<xsl:value-of select="concat('&amp;phrase=', NAME)"/>
				</xsl:for-each>
				-->
			</xsl:attribute>
		</link>
	</xsl:template>
	
	<xsl:template name="SEARCH_RSS_FEED">
		<xsl:variable name="url">
			<xsl:call-template name="SEARCH_URL">
				<xsl:with-param name="xml">Y</xsl:with-param>
			</xsl:call-template>
			<xsl:text>&amp;s_xml=</xsl:text>
			<xsl:value-of select="$rss_param"/>
			<xsl:text>&amp;sortby=dateuploaded</xsl:text>
			<xsl:text>&amp;s_client=</xsl:text>
			<xsl:value-of select="$client"/>
			<xsl:text>&amp;show=</xsl:text>
			<xsl:value-of select="$rss_show"/>
			<!--[FIXME: not needed]
			<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
				<xsl:value-of select="concat('&amp;phrase=', NAME)"/>
			</xsl:for-each>
			-->
		</xsl:variable>

		<p id="rssBlock">
			<a href="{$url}" class="rssLink" id="rssLink">
				<xsl:call-template name="VIEW_NAME"/>
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

	<!-- tag clouds -->
	
	<!-- OLD STUFF -->
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
	
	<!--
	<xsl:template match="ARTICLEHOT-PHRASES" mode="r_articlehotphrases">
		<xsl:apply-templates select="ARTICLEHOT-PHRASE" mode="c_articlehotphrases">
			<xsl:sort select="NAME" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_articlehotphrases">
		<xsl:variable name="popularity" select="$no-of-ranges + 1 - msxsl:node-set($ranked-hot-phrases)/RANGE[ARTICLEHOT-PHRASE[generate-id(current()) = @generate-id]]/@ID"/>
		
		<a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}&amp;s_tab={/H2G2/PARAMS/PARAM[NAME='s_tab']/VALUE}" class="rank{$popularity}"><xsl:value-of select="NAME"/></a>
		<xsl:text> </xsl:text>
	</xsl:template>
	-->	
	
	<!-- NEW STUFF -->
	<!-- the maximum number of tags to display at one time -->
	<xsl:variable name="numt">10</xsl:variable>
	
	<!-- maximum/minumum % font sizes -->
	<xsl:variable name="maxf">280</xsl:variable>
	<xsl:variable name="minf">70</xsl:variable>
	
	<!-- number of font size classes -->
	<xsl:variable name="numf">8</xsl:variable>
	
	<!-- assumes that tags are ordered by rank descending in the src xml -->
	<xsl:variable name="maxr" select="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE[not(starts-with(TERM, $keyword_prefix_prelim))][1]/RANK"/>
	<xsl:variable name="minr" select="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE[not(starts-with(TERM, $keyword_prefix_prelim))][position() = last()]/RANK"/>

	<xsl:template match="ARTICLEHOT-PHRASES" mode="r_articlehotphrases">
		<xsl:apply-templates select="ARTICLEHOT-PHRASE[not(starts-with(TERM, $keyword_prefix_prelim))][position() &lt;= 20]" mode="c_articlehotphrases">
			<xsl:sort select="NAME" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_articlehotphrases">
		<!--
		<xsl:variable name="f" select="ceiling(((RANK div $maxr) * ($maxf - $minf)) + $minf)"/>
		-->
		<xsl:variable name="f" select="ceiling((RANK div $maxr) * $numf)"/>
		<!--
		<a href="{$articlesearchbase}&amp;phrase={TERM}" style="font-size:{$f}%"><xsl:value-of select="NAME"/></a>
		-->
		<a href="{$articlesearchbase}&amp;phrase={TERM}" class="tag{$f}"><xsl:value-of select="NAME"/></a>
		<xsl:text> </xsl:text>
	</xsl:template>	
	
	
	<xsl:attribute-set name="iARTICLESEARCHPHRASE_t_articlesearchbox"/>

	<xsl:template name="sortOrderLayer">
		<xsl:param name="escapedSaveSearchUrl"></xsl:param>
		<div id="sort-memories">
			<p>
				<xsl:text>Sort by: </xsl:text>
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLESEARCH/@SORTBY and /H2G2/ARTICLESEARCH/@SORTBY = 'StartDate'">
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="SEARCH_URL">
									<xsl:with-param name="xml" select="SKIPROOT"/>
									<xsl:with-param name="sortBy">lastUpdated</xsl:with-param>
								</xsl:call-template>								
							</xsl:attribute>
							<xsl:text>Recently added</xsl:text>
						</a>
						<xsl:text> / Date of memory</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Recently added / </xsl:text>
						<a>
							<xsl:attribute name="href">
								<xsl:call-template name="SEARCH_URL">
									<xsl:with-param name="xml" select="SKIPROOT"/>
									<xsl:with-param name="sortBy">StartDate</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:text>Date of memory</xsl:text>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</div>
	</xsl:template>
	
</xsl:stylesheet>