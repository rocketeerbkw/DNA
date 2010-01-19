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
	<xsl:import href="../../../base/base-morearticlespage.xsl"/>
	<!--
	MOREPAGES_MAINBODY
		insert-showeditedlink
		insert-shownoneditedlink
		insert-showcancelledlink
		ARTICLE-LIST
		- - - -  defined in userpage.xsl - - - - - 
		
		insert-prevmorepages
		insert-nextmorepages
		insert-backtouserpagelink
	-->
	
	
	<!-- QUESTION - what is the most articles you can show on this page? 
	
	i.e. 
	http://dnadev.national.core.bbc.co.uk/dna/research/MA1090498240?type=2&s_filter=articles&show=100
	
	- Because I am filtering out different types of article in the XSL you  can't rely on the pagination (can get pages that have a next but no articles)
	-->
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOREPAGES_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<!--xsl:value-of select="$m_morepagestitle"/-->
				<xsl:call-template name="MOREPAGES_PAGE_TITLE" />				
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="MOREPAGES_PAGE_TITLE">
		<xsl:param name="doBold">false</xsl:param>
		<xsl:text>All </xsl:text>
		<!-- who's? -->
		<xsl:choose>
			<xsl:when test="$test_OwnerIsViewer=1">
				<xsl:text>your</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$doBold='true'">
					<xsl:text disable-output-escaping="yes">&lt;strong&gt;</xsl:text>
				</xsl:if>
				<xsl:value-of select="PAGE-OWNER/USER/USERNAME/node()"/>
				<xsl:if test="$doBold='true'">
					<xsl:text disable-output-escaping="yes">&lt;/strong&gt;</xsl:text>
				</xsl:if>
				<xsl:text>'s</xsl:text>				
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text> memories</xsl:text>		
	</xsl:template>
	
	<xsl:template name="MOREPAGES_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">MOREPAGES_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">morearticlespage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[
				var authorArticleCount = 0;
			//]]&gt;
			</xsl:text>
		</script>

		<div id="ms-list-timeline">
			<div id="ms-list-timeline-header">
				<xsl:comment> ms-list-timeline-header </xsl:comment>
			</div>

			<xsl:variable name="sortMethod">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
			</xsl:variable>

			<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/>

			<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="r_morearticlespagination"/>
			
			<div id="ms-list-timeline-footer">
				<xsl:comment> ms-list-timeline-footer </xsl:comment>
			</div>
		</div>

		<div id="ms-post-timline">
			<div id="show-all-memories">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$articlesearchroot" />
					</xsl:attribute>
					<span>
						<xsl:comment> - </xsl:comment>
					</span>
					<xsl:text>Show all memories</xsl:text>
				</a>
			</div>
			<xsl:comment> ms-post-timline </xsl:comment>
		</div>
		<div id="ms-features">
			<xsl:call-template name="feature-pod" />
			<xsl:call-template name="client-pod" />
		</div>
		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[
				$(document).ready(function () {
					initMoreArticles();
				});
			//]]&gt;
			</xsl:text>
		</script>		
  </xsl:template>

  <xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespagination">
  	<xsl:variable name="s_sort_param">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE">
			<xsl:text>&amp;s_sort=</xsl:text>
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
  		</xsl:if>
  	</xsl:variable>

	  <xsl:if test="(@SKIPTO &gt; 0) or (@MORE = 1)">
          <div id="ms-list-pagination">
			  <ul>
				  <li>
					<xsl:choose>
						<xsl:when test="@SKIPTO &gt; 0">			  
							<a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}&amp;type=2&amp;show=8&amp;skip={@SKIPTO - $morearticlesshow}{$s_sort_param}">Previous</a>			  
						</xsl:when>
						<xsl:otherwise>Previous</xsl:otherwise>
					</xsl:choose>
				  </li>
				  <li>
					  <xsl:text> | </xsl:text>
				  </li>
				  <li>
					<xsl:choose>
						<xsl:when test="@MORE = 1">
							<a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}&amp;type=2&amp;show=8&amp;skip={@SKIPTO + $morearticlesshow}{$s_sort_param}">Next</a>
						</xsl:when>
						<xsl:otherwise>Next</xsl:otherwise>
					</xsl:choose>
				  </li>
			  </ul>
          </div>
	  </xsl:if>
	</xsl:template>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE-LIST Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
	Description: Presentation of the object holding the list of articles
	 -->
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
		<xsl:variable name="thisUrl">
			<xsl:value-of select="$root" />
			<xsl:text>MA</xsl:text>
			<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID" />
			<xsl:text>&amp;type=2&amp;show=8&amp;skip=</xsl:text>
			<xsl:value-of select="@SKIPTO" />
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE">
				<xsl:text>&amp;s_sort=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="thisUrlEscaped">
			<xsl:call-template name="URL_ESCAPE">
				<xsl:with-param name="s" select="$thisUrl"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="remoteAuthorMemoriesUrl">
			<!--xsl:text>AuthorMemories.aspx?UserId=</xsl:text>
			<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID" /-->
			<xsl:text>MA</xsl:text>
			<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID" />
			<xsl:text>&amp;type=2</xsl:text>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE">
				<xsl:text>&amp;s_sort=</xsl:text>
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
			</xsl:if>			
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="count(ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15]) &lt; 1">
				<ul id="noResults">
					<li>
						<xsl:choose>
							<xsl:when test="$test_OwnerIsViewer=1">
								<p>You haven't shared any of your memories yet.</p>
							</xsl:when>
							<xsl:otherwise>
								<p>
									<xsl:text disable-output-escaping="yes">&lt;strong&gt;</xsl:text>
									<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME/node()"/>
									<xsl:text disable-output-escaping="yes">&lt;/strong&gt;</xsl:text>
									<xsl:text> hasn't shared any memories yet.</xsl:text>
								</p>
							</xsl:otherwise>
						</xsl:choose>						
					</li>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<script type="text/javascript">
				<xsl:text disable-output-escaping="yes">
				// &lt;![CDATA[				
					authorArticleCount = </xsl:text>
				<xsl:value-of select="count(ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15])" />
				<xsl:text disable-output-escaping="yes">;
				//]]&gt;
				</xsl:text>
				</script>				
				<ul class="resultList">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
							<!-- sort by SUBJECT (a-z title) -->
							<!-- was mode="c_morearticlespage" -->
							<xsl:apply-templates select="ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15]" mode="article_list_item">
								<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<!-- default - sort by date -->
							<!-- was mode="r_morearticlespage (??) -->
							<xsl:apply-templates select="ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID= 10 or EXTRAINFO/TYPE/@ID=15]" mode="article_list_item">
								<xsl:with-param name="fromSearch" select="$thisUrlEscaped" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</ul>

				<xsl:call-template name="flash-timeline-script">
					<xsl:with-param name="layerId">ms-list-timeline</xsl:with-param>
					<xsl:with-param name="checkCookie">true</xsl:with-param>
					<xsl:with-param name="search" select="$remoteAuthorMemoriesUrl" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
	Description: Presentation of each of the ARTCLEs in the ARTICLE-LIST
	 -->
	 <!--[FIXME: redundant?] -->
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
    <ul>
      <xsl:variable name="oddoreven">
        <xsl:choose>
          <xsl:when test="position() mod 2 != 0">odd</xsl:when>
          <xsl:otherwise>even</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <li>
        <xsl:attribute name="class">
          <xsl:value-of select="$oddoreven"/>
        </xsl:attribute>
        <!--[FIXME: remove]
			<xsl:apply-templates select="EXTRAINFO/MANAGERSPICK/text()">
				<xsl:with-param name="oddoreven" select="$oddoreven"/>
			</xsl:apply-templates>
			-->
        <xsl:apply-templates select="SUBJECT" mode="article_list_item"/>
        <!-- <xsl:apply-templates select="EXTRAINFO/AUTHORUSERID"/> -->

        <!--[FIXME: adapt]
			<div class="articledetals">
				<xsl:apply-templates select="EXTRAINFO/SPORT"/> <xsl:apply-templates select="EXTRAINFO/COMPETITION/text()"/> <xsl:apply-templates select="EXTRAINFO/TYPE"/>
			</div>
			-->
        <div class="articledate">
          published <xsl:apply-templates select="DATE-CREATED" mode="t_morearticlespage"/>
        </div>
        <xsl:value-of select="EXTRAINFO/AUTODESCRIPTION/text()"/>
      </li>
    </ul>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="ARTICLES" mode="r_previouspages">
	Use: Creates a 'More recent' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_previouspages">
	<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_newerentries"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLES" mode="r_morepages">
	Use: Creates a 'Older' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_morepages">
	<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@MORE=1]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_olderentries"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
	Use: Creates a link to load a morepages page showing only cancelled entries
		  created by the viewer
	-->
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'back to the userpage' link
	-->
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
		<p><strong><a href="{$root}U{@USERID}" xsl:use-attribute-sets="mARTICLES_t_backtouserpage">
			<xsl:copy-of select="$m_FromMAToPSText"/>
		</a></strong></p>
	</xsl:template>
	
	
	<!--
	<xsl:template match="SUBJECT" mode="t_morearticlespage">
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/SUBJECT
	Purpose:	 Creates the link to the ARTICLE page using the SUBJECT
	-->
	<xsl:template match="SUBJECT" mode="article_list_item">
		<div class="articletitle"><a href="{$root}A{../H2G2-ID}" xsl:use-attribute-sets="mSUBJECT_t_morearticlespage">
			<xsl:choose>
				<xsl:when test="./text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$m_subjectempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</a></div>
	</xsl:template>
</xsl:stylesheet>
