<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
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
				<xsl:value-of select="$m_morepagestitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="MOREPAGES_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">MOREPAGES_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">morearticlespage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

    <div id="topPage">
      <div class="innerWide">
        <h2>All Memories</h2>

    <!--[FIXME: remove?]-->
    <h3>
      <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
    </h3>
    
		<!--[FIXME: remove]
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
				all articles
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
				all reports
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
				all profiles
			</xsl:when>
			<xsl:otherwise>
				all article, reports and profiles
			</xsl:otherwise>
		</xsl:choose>
		-->

		<p>
			<xsl:text>Below is a list of all </xsl:text>
			<!-- who's? -->
			<xsl:choose>
				<xsl:when test="$test_OwnerIsViewer=1">
					<xsl:text>your</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="PAGE-OWNER/USER/USERNAME/node()"/>
					<xsl:text>'s</xsl:text>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:text> memories</xsl:text>
		</p>

        <xsl:apply-templates select="ARTICLES" mode="t_backtouserpage"/>
      </div>
    </div>
    
    <div class="tear">
      <hr/>
    </div>

    <xsl:variable name="sortMethod">
      <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
    </xsl:variable>
    
    <div class="padWrapper">
      <div class="tabNav" id="tabNavPagination">
        <ul>
          <li>
            <xsl:if test="not($sortMethod = 'title')">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;&amp;show={$morearticlesshow}&amp;s_sort=date">
              <span>View by date submitted</span>
            </a>
          </li>
          <li>
            <xsl:if test="$sortMethod = 'title'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;&amp;show={$morearticlesshow}&amp;s_sort=title">
              <span>View by a-z</span>
            </a>
          </li>
        </ul>
        <div class="clr"/>
      </div>

      <div class="barStrong">
        <p class="left">
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </p>
        <p class="right">
          <xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="r_morearticlespagination"/>
        </p>
      </div>

      <div class="resultsList">      

		    <xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/>
    		   		
      </div>

      
      <div class="barStrong">
        <p class="left">
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </p>
        <p class="right">
          <xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="r_morearticlespagination"/>
        </p>
        <div class="clr">
          <hr/>
        </div>
      </div>
    </div>
    <p id="rssBlock">
      <a href="{$feedroot}xml/MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter=articles&amp;s_xml={$rss_param}&amp;s_client={$client}&amp;show={$rss_show}" class="rssLink" id="rssLink">
        <xsl:text>Latest memories</xsl:text>
      </a>
      <xsl:text> | </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/rsshelp"/>
        </xsl:attribute>
        What is RSS?
      </a>
	<xsl:text> | </xsl:text>
	<a href="{$root}help#feeds">
		<xsl:text>Memoryshare RSS feeds</xsl:text>
	</a>
    </p>
  </xsl:template>

  <xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespagination">
  	<xsl:variable name="s_sort_param">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE">
			<xsl:text>&amp;s_sort=</xsl:text>
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE"/>
  		</xsl:if>
  	</xsl:variable>
  	
    <xsl:choose>
      <xsl:when test="@SKIPTO &gt; 0">
        <a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}&amp;type=2&amp;show=20&amp;skip={@SKIPTO - $morearticlesshow}{$s_sort_param}">Previous</a>
      </xsl:when>
      <xsl:otherwise>Previous</xsl:otherwise>
    </xsl:choose>
    <xsl:text> | </xsl:text>
    <xsl:choose>
      <xsl:when test="@MORE = 1">
        <a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}&amp;type=2&amp;show=20&amp;skip={@SKIPTO + $morearticlesshow}{$s_sort_param}">Next</a>
      </xsl:when>
      <xsl:otherwise>Next</xsl:otherwise>
    </xsl:choose>
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
		<ul class="resultList">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
					<!-- sort by SUBJECT (a-z title) -->
					<!-- was mode="c_morearticlespage" -->
					<xsl:apply-templates select="ARTICLE[SITEID=$site_number]" mode="article_list_item">
						<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<!-- default - sort by date -->
					<!-- was mode="r_morearticlespage (??) -->
					<xsl:apply-templates select="ARTICLE[SITEID=$site_number]" mode="article_list_item"/>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
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
