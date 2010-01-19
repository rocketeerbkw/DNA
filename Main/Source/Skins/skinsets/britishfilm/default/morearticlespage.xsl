<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
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
	<xsl:template name="MOREPAGES_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">MOREPAGES_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">morearticlespage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

		<div class="banartical"><h3>Member page / <strong>
		
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
		
		</strong></h3></div>		
		<div class="clear"></div>
		
		<h3 class="memberhead">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
		</h3>
		<div class="memberdate">
			&nbsp;<!-- data not available in xml -->
		</div>
	
	
		
		
		

		<h4 class="instructhead">Below is a list of all 
		
		<!-- who's? -->
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">
				your
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="PAGE-OWNER/USER/USERNAME/node()"/>'s
			</xsl:otherwise>
		</xsl:choose>
		 
		 <!-- type of article-->
		 <xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
					articles
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
					reports
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
					profiles
				</xsl:when>
				<xsl:otherwise>
					article, reports and profiles
				</xsl:otherwise>
			</xsl:choose>
		
		</h4>		
		
	
				
			<div class="headingbox">
				<h3>Sort by</h3>
				<xsl:variable name="filterby">
							<xsl:choose>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
									articles
								</xsl:when>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
									reports
								</xsl:when>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
									profiles
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
				<p class="links">
				<a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter={$filterby}&amp;show={$morearticlesshow}&amp;s_sort=title">a-z title</a> | 
						<a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter={$filterby}&amp;show={$morearticlesshow}&amp;s_sort=sport">sport</a> | 
						<a href="{$root}MA{/H2G2/PAGE-OWNER/USER/USERID}?type=2&amp;s_filter={$filterby}&amp;show={$morearticlesshow}&amp;s_sort=date">date</a>
				</p>
				</div>
					
	
			<div class="bodytext">	
	
				<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/>
				
			</div>
			
			<xsl:apply-templates select="ARTICLES" mode="t_backtouserpage"/>
		
		
		
	
				 
				
	<xsl:call-template name="ADVANCED_SEARCH" />

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
	
	
	<ul class="bodylist striped">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
				<!-- sort by SUBJECT (a-z title) -->
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=10 or EXTRAINFO/TYPE/@ID=15]" mode="r_morearticlespage">
							<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=11  or EXTRAINFO/TYPE/@ID=12]" mode="r_morearticlespage">
							<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=13  or EXTRAINFO/TYPE/@ID=14]" mode="r_morearticlespage">
							<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number]" mode="c_morearticlespage">
							<xsl:sort select="SUBJECT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'sport'">
				<!-- sort by EXTRAINFO/SPORT (sport) -->
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=10 or EXTRAINFO/TYPE/@ID=15]" mode="r_morearticlespage">
							<xsl:sort select="EXTRAINFO/SPORT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=11  or EXTRAINFO/TYPE/@ID=12]" mode="r_morearticlespage">
							<xsl:sort select="EXTRAINFO/SPORT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=13  or EXTRAINFO/TYPE/@ID=14]" mode="r_morearticlespage">
							<xsl:sort select="EXTRAINFO/SPORT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number]" mode="c_morearticlespage">
							<xsl:sort select="EXTRAINFO/SPORT" data-type="text" order="ascending"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- default - sort by date -->
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'articles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=10 or EXTRAINFO/TYPE/@ID=15]" mode="r_morearticlespage"/>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'reports'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=11  or EXTRAINFO/TYPE/@ID=12]" mode="r_morearticlespage"/>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_filter']/VALUE = 'profiles'">
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=13  or EXTRAINFO/TYPE/@ID=14]" mode="r_morearticlespage"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="ARTICLE[SITEID=$site_number]" mode="r_morearticlespage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		</ul>
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
	Description: Presentation of each of the ARTCLEs in the ARTICLE-LIST
	 -->
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
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
			<xsl:apply-templates select="SUBJECT" mode="article_list_item"/>
			<!-- <xsl:apply-templates select="EXTRAINFO/AUTHORUSERID"/> -->
			
			<div class="articledetals">
				<xsl:apply-templates select="EXTRAINFO/SPORT"/> <xsl:apply-templates select="EXTRAINFO/COMPETITION/text()"/> <xsl:apply-templates select="EXTRAINFO/TYPE"/>
			</div>
			<div class="articledate">published <xsl:apply-templates select="DATE-CREATED" mode="t_morearticlespage"/></div> 
			<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION/text()"/>
		</li>
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
