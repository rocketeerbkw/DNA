<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlesearchphrase.xsl"/>

	<xsl:template name="ARTICLESEARCHPHRASE_MAINBODY">

		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLESEARCHPHRASE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">articlesearchphrase.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
	
					<h1 class="search"><img src="{$imagesource}search/searchheader.jpg" alt="Search for films" /></h1>
					<xsl:apply-templates select="ARTICLESEARCH" mode="normalsearch"/>
			

	</xsl:template>
	
	<xsl:template name="ARTICLESEARCH_MAINBODY">

		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ARTICLESEARCHPHRASE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">articlesearchphrase.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
	
					<h1 class="search"><img src="{$imagesource}search/searchheader.jpg" alt="Search for films" /></h1>
					<xsl:apply-templates select="ARTICLESEARCH" mode="normalsearch"/>
			

	</xsl:template>

	<xsl:template name="ARTICLESEARCH_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
			<xsl:text>BBC - British Film - Browse films</xsl:text>	
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="normalsearch">
		<!-- Search Box with Sort by -->
		<xsl:call-template name="ADVANCED_SEARCH" />
				
		<!-- <xsl:choose>
			<xsl:when test="PHRASES/@COUNT = 0 and not($test_IsEditor)">
				
			</xsl:when>
			<xsl:otherwise> -->
				<!-- a search has been submitted -->
				
				<!-- CV Have left this in to aid in testing. Remove when tag search functionality is in place -->
			<!-- 	<p id="yoursearch">You searched for
					<xsl:for-each select="PHRASES/PHRASE">
						<span class="searchphrase"><xsl:value-of select="NAME"/></span><xsl:if test="position() != last()"> + </xsl:if>
					</xsl:for-each>
				</p> -->
				
				<xsl:if test="@TOTAL=0">
					<!-- no results found -->
					<p>Your search returned <strong>no result</strong></p>
				</xsl:if>
				
				<xsl:if test="@TOTAL&gt;0">
						<!-- results found store in variable -->
						<xsl:variable name="searchterm">
							<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE"><xsl:value-of select="NAME"/><xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each>
						</xsl:variable>
						<xsl:variable name="params">
							<xsl:for-each select="/H2G2/PARAMS/PARAM">&amp;<xsl:value-of select="NAME"/>=<xsl:value-of select="VALUE"/></xsl:for-each>
							<xsl:if test="1">
							&amp;show=<xsl:value-of select="@SHOW"/>
							</xsl:if>
						</xsl:variable>
						<!-- pagination block -->
						<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>	
				</xsl:if>
					
				
				<xsl:choose>
					<xsl:when test="@TOTAL=0">
					<!-- CV if there is a chance that no results will be returned, will need to design HTML -->
					<!-- no results found -->
					<!-- help -->
					</xsl:when>
					<xsl:otherwise>
						<!-- results found -->
						<!-- list of article -->
						<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="r_articlesearchresults"/>
						<!-- pagination block -->
						<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>	
					</xsl:otherwise>
				</xsl:choose>		 
					
				<!-- <div class="clear"></div> -->
				
		<!-- 	</xsl:otherwise>
		</xsl:choose> -->
	
	</xsl:template>
	
	
	
	<xsl:attribute-set name="iARTICLESEARCHPHRASE_t_articlesearchbox"/>
	  <xsl:attribute-set name="mARTICLESEARCH_link_nextpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_previouspage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_firstpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_lastpage"/>
	
	
	<!-- <xsl:template match="ARTICLESEARCHPHRASE" mode="r_articlesearchresults">
		<xsl:apply-templates select="ARTICLESEARCH" mode="c_articlesearchresults"/>
	</xsl:template> -->
	
	<xsl:template match="ARTICLESEARCH" mode="r_articlesearchresults">
		<div id="filmcontainer">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members'">
				<xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='3001']" mode="r_articlesearchresults"/>
			</xsl:when>
			<xsl:otherwise>
					<!-- <xsl:choose>
					<xsl:when test="ARTICLE[1][ancestor::EXTRAINFO/STATUS]">
					<xsl:apply-templates select="ARTICLE[EXTRAINFO/STATUS[@type='1']]" mode="r_articlesearchresults"/>
					</xsl:when>
					<xsl:otherwise>
					<xsl:apply-templates select="ARTICLE" mode="r_articlesearchresults"/>
					</xsl:otherwise>
					</xsl:choose> CHANGED trent 15/05/2007 -->
					<xsl:choose>
						<xsl:when test="$test_IsEditor or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME = 'EDITOR'">
							<xsl:apply-templates select="ARTICLES/ARTICLE" mode="r_articlesearchresults"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ARTICLES/ARTICLE[STATUS=1]" mode="r_articlesearchresults"/>
							
						</xsl:otherwise>
					</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="r_articlesearchresults">
	
			<div class="filmbox">
			<!-- CV need to identify where this image will be entered and pass that node onto EXTRAINFO. For now, keeping
			        dummy image
			        <img><xsl:attribute name="src"><xsl:value-of select="{$imagesource}EXTRAINFO/THUMBNAIL" /></xsl:attribute></img>
			-->
			        
			<div class="image"><img src="http://www.bbc.co.uk/britishfilm/images/thumbnails/{@H2G2ID}_thumb.jpg" width="124" height="69" alt="{SUBJECT/text()}" /></div>
			<div class="text">
			<a class="filmname">
				<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', @H2G2ID)"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="SUBJECT/text()">
						<xsl:value-of select="SUBJECT/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_subjectempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
			<div class="filmlinks">
			<xsl:for-each select="EXTRAINFO/GENRE01 | EXTRAINFO/GENRE02 | EXTRAINFO/GENRE03">
				<xsl:if test=".!=''">
					<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={.}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="." />
										</xsl:with-param>
									</xsl:call-template></a> |
				</xsl:if>
			</xsl:for-each>
			<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={EXTRAINFO/THEME}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="EXTRAINFO/THEME" />
										</xsl:with-param>
									</xsl:call-template></a>
			</div>
		
				<xsl:variable name="avg_score"><xsl:value-of select="POLL/STATISTICS/@AVERAGERATING" /></xsl:variable>

				<xsl:choose>
							<xsl:when test="floor($avg_score) = 1">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($avg_score) = 2">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($avg_score) = 3">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($avg_score) = 4">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:when>

							<xsl:when test="floor($avg_score) = 5">
								<div class="filmrating">
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
									<img src="{$imagesource}fullstar.gif" alt="" />
								</div>
							</xsl:when>
							
							<xsl:otherwise>
								<div class="filmrating">
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
									<img src="{$imagesource}emptystar.gif" alt="" />
								</div>
							</xsl:otherwise>
						</xsl:choose>		

			<div class="filminfo">
				<!-- CV Seconds don't seem to be included in the design. Is this an oversight? -->
				<xsl:value-of select="EXTRAINFO/DIRECTOR" /> | <xsl:value-of select="EXTRAINFO/LENGTH_MIN" /> minutes <xsl:value-of select="EXTRAINFO/LENGTH_SEC" /> seconds
			</div>
			 
			
		
			</div>
		</div>
		
		
		
		
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
		
		<a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}" class="rank{$popularity}"><xsl:value-of select="NAME"/></a>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
	Use: Presentation of the related key phrases
	-->
	<xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
		<xsl:if test="position() &lt; 20">
			<a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}"><xsl:value-of select="NAME"/></a><xsl:text> </xsl:text>		
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
			<td><a href="{$root}ArticleSearchPhrase?contenttype={/H2G2/ARTICLEHOT-PHRASES/@ASSETCONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a></td>
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
	
	<!-- pagination navigation -->
	<xsl:template match="ARTICLESEARCH" mode="pagination_links">
		<xsl:variable name="pagenumber">
			<xsl:value-of select="floor(@SKIPTO div @SHOW) + 1" />
		</xsl:variable>
		<!-- <xsl:value-of select="$pagenumber"/> -->
		<xsl:variable name="pagetotal">
	  	  <xsl:value-of select="ceiling(@TOTAL div @SHOW)" />
		</xsl:variable>
	
		<div class="pagenumbers base">
			<xsl:apply-templates select="." mode="c_previouspage"/><!-- c_firstpage -->
			<xsl:text> </xsl:text>
			<!-- <xsl:apply-templates select="." mode="c_articleblocks"/> DNA standard -->
			<xsl:apply-templates select="." mode="t_article_search_page_numbers">
				<xsl:with-param name="currentpagenumber" select="$pagenumber"/>
			</xsl:apply-templates>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="." mode="c_nextpage"/>
		</div>
		<!-- <div class="clear"></div> -->

	</xsl:template>


	<xsl:variable name="artspsearchphrase"><text>&amp;phrase=film</text></xsl:variable>


	<!-- Create numbered links < [1 2 3 ... 20] > etc for search results -->
	<xsl:template match="ARTICLESEARCH" mode="t_article_search_page_numbers">
		<xsl:param name="currentpagenumber"/>
		<xsl:param name="creatinglinknumber" select="0"/>

		<xsl:choose>
			<xsl:when test="$currentpagenumber = ($creatinglinknumber + 1)">
				<span class="nounderline"><xsl:value-of select="$creatinglinknumber + 1"/></span>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={$creatinglinknumber * @SHOW}{$artspsearchphrase}&amp;articlestatus={@ARTICLESTATUS}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}"><xsl:value-of select="$creatinglinknumber + 1"/></a>
			</xsl:otherwise>
		</xsl:choose>
		

		<xsl:if test="@TOTAL &gt; (($creatinglinknumber + 1) * @SHOW)">
			<xsl:apply-templates select="." mode="t_article_search_page_numbers">				
				<xsl:with-param name="creatinglinknumber" select="$creatinglinknumber + 1"/>
				<xsl:with-param name="currentpagenumber" select="$currentpagenumber"/>
			</xsl:apply-templates>
		</xsl:if> 
	
	</xsl:template>



	<xsl:template match="ARTICLESEARCH" mode="r_articleblocks">
		<xsl:apply-templates select="." mode="c_articleblockdisplay">
		<!-- <xsl:with-param name="onlink" select="1"/> -->
		</xsl:apply-templates>
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
		<a href="#" class="selected" title="$pagenumber"><xsl:value-of select="$pagenumber"/></a><xsl:text>
		</xsl:text>
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
		<!-- <xsl:text>previous </xsl:text> -->
		<a><img src="{$imagesource}search/backarrow.gif" alt="Currently on first page of results" /></a>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_nextpage">
		<!-- <a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) + number(@SHOW)}{$artspsearchphrase}&amp;articlestatus=1&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_nextpage"><img src="{$imagesource}search/forwardarrow.gif" alt="next page" /></a> -->
		<a><img src="{$imagesource}search/forwardarrow.gif" alt="Currently on last page of results" /></a>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_firstpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) - number(@SHOW)}{$artspsearchphrase}&amp;articlestatus={@ARTICLESTATUS}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_previouspage"><img src="{$imagesource}search/backarrow.gif" alt="previous page" /></a>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_lastpage">
		<xsl:text> last</xsl:text>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="(@SKIPTO + @COUNT) &lt; @TOTAL">
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- override base files as need to have contenttype= in the querystring  -->
	<xsl:template match="ARTICLESEARCH" mode="link_nextpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) + number(@SHOW)}{$artspsearchphrase}&amp;articlestatus={@ARTICLESTATUS}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_nextpage">
			<img src="{$imagesource}search/forwardarrow.gif" alt="next page" /></a>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="link_previouspage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@SKIPTO) - number(@SHOW)}{$artspsearchphrase}&amp;articlestatus=1&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_previouspage">
			<img src="{$imagesource}search/backarrow.gif" alt="previous page" /></a>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;articlestatus=1&amp;skip=0{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<a href="{$root}ArticleSearch?show={@SHOW}&amp;skip={number(@TOTAL) - number(@SHOW)}{$artspsearchphrase}&amp;articlestatus=1&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_lastpage">
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
						<xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_articleblockdisplay">
					<xsl:with-param name="url"><xsl:value-of select="$onlink"/>
						<a href="{$root}ArticleSearch?skip={$skip}&amp;show={@SHOW}{$artspsearchphrase}&amp;articlestatus=1&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_off_articleblockdisplay">
							<xsl:call-template name="t_articleofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
							</xsl:call-template>
						</a><xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	
</xsl:stylesheet>


	
	
	
	
	
	
	
	
