<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-categorypage.xsl"/>
	
	<xsl:variable name="parent_pccat" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGESPARENTCATEGORY"/>	
	<xsl:variable name="pccat" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
	<xsl:variable name="is_programme_challenge" select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[NODEID=$parent_pccat]"/>
	<xsl:variable name="programme_challenge_type">
		<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/@CONTENTTYPE"/>
	</xsl:variable>
	<xsl:variable name="programme_challenge_type_string">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$programme_challenge_type]/@label"/>
	</xsl:variable>	
	<xsl:variable name="programme_challenge_category_article_type">
		<xsl:value-of select="msxsl:node-set($type)/type[@group='programmechallenge' and @subtype='article']/@number"/>
	</xsl:variable>	
	<xsl:variable name="programme_challenge_name">
		<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/DISPLAYNAME"/>
	</xsl:variable>
	<!--
	<xsl:variable name="is_new">
		<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/@NEW='Y'"/>
	</xsl:variable>
	-->

	<xsl:variable name="cat_url" select="concat($root,'C',/H2G2/HIERARCHYDETAILS/@NODEID)"/>
	<xsl:variable name="page_size" select="20"/>
	<xsl:variable name="show_pages" select="10"/>
	<xsl:variable name="sortby" select="/H2G2/PARAMS/PARAM[NAME='s_sortby']/VALUE"/>
	
	<xsl:variable name="skip">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_skip']/VALUE">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_skip']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="show">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$page_size"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="CATEGORY_MAINBODY">
			<xsl:choose>
				<xsl:when test="not(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3])">
					<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_category"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_issue"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for taxonomy page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_category">
	Use: HIERARCHYDETAILS contains ancestry, displayname and member information
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_category">		
		<xsl:choose>
			<!-- when category is Programme Challenge category -->
			<xsl:when test="$is_programme_challenge">
				<!-- display extra moderator tool box -->
				<xsl:if test="$test_IsEditor=1 or $user_is_assetmoderator=1 or $user_is_moderator=1">
					<div class="moderatorbox">
						<a href="{$root}TypedArticle?aedit=new&amp;type={$programme_challenge_category_article_type}&amp;h2g2id={/H2G2/HIERARCHYDETAILS/ARTICLE/ARTICLEINFO/H2G2ID}">Add guideML to this category</a>						
					</div>
				</xsl:if>
		
				<h1><xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/ARTICLE/GUIDE/GRAPHICTITLE/IMG"/></h1>
				
				<div id="submitAv1" class="default">
					<!-- 2 columns -->
					<div class="col1">
						<div class="margins">
							<!-- blurb -->
							<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/ARTICLE/GUIDE/BODY"/>
							<div class="hozDots"></div>
							<xsl:apply-templates select="MEMBERS" mode="c_category"/>					
						</div>
					</div><!--// col1 -->
							
					<div class="col2">
						<div class="margins">
							<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/ARTICLE/GUIDE/COL2"/>
						</div>
					</div><!--// col2 -->
					<div class="clr"></div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/CLIP" mode="c_categoryclipped"/>
				<xsl:apply-templates select="ANCESTRY" mode="c_category"/>
				<b>
					<xsl:value-of select="DISPLAYNAME"/>
				</b>
				<br/>
				<br/>
				<xsl:apply-templates select="." mode="c_clip"/>
				<br/>
				<br/>
				<xsl:apply-templates select="MEMBERS" mode="c_category"/>			
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_categoryclipped">
	Description: message to be displayed after clipping a category
	 -->
	<xsl:template match="CLIP" mode="r_categoryclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_category">
	Use: Lists the crumbtrail for the current node
	 -->
	<xsl:template match="ANCESTRY" mode="r_category">
		<xsl:apply-templates select="ANCESTOR" mode="c_category"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_category">
	Use: One item within the crumbtrail
	 -->
	<xsl:template match="ANCESTOR" mode="r_category">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> /</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="HIERARCHYDETAILS" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="r_clip">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_category">
	Use: Holder for all the members of a node
	 -->
	<xsl:template match="MEMBERS" mode="r_category">
		<xsl:choose>
			<!-- when category is Programme Challenge category -->
			<xsl:when test="$is_programme_challenge">
				<xsl:apply-templates select="." mode="t_sortby"/>
				<xsl:apply-templates select="." mode="t_pagination"/>
				<ul>
					<xsl:choose>
						<xsl:when test="$sortby = 'Rating'">
							<xsl:apply-templates select="ARTICLEMEMBER" mode="r_category">
								<xsl:sort select="POLL/STATISTICS/@AVERAGERATING" order="descending"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="$sortby = 'Caption'">
							<xsl:apply-templates select="ARTICLEMEMBER" mode="r_category">
								<xsl:sort select="NAME" order="ascending"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ARTICLEMEMBER" mode="r_category">
								<xsl:sort select="DATECREATED/DATE/@SORT" data-type="number" order="descending"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
				<xsl:apply-templates select="." mode="t_pagination"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="SUBJECTMEMBER" mode="c_category"/>
				<xsl:apply-templates select="ARTICLEMEMBER" mode="c_category"/>
				<xsl:apply-templates select="NODEALIASMEMBER" mode="c_category"/>
				<xsl:apply-templates select="CLUBMEMBER" mode="c_category"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="MEMBERS" mode="t_sortby">
		<div class="assetNavFormBlock">
			<form name="sortByForm" id="sortByForm" method="GET">
				<xsl:attribute name="action">
					<xsl:value-of select="concat('C',/H2G2/HIERARCHYDETAILS/@NODEID)"/>
				</xsl:attribute>
				
				<label for="sortBy">Sort by:</label>						
				<select name="s_sortby" id="sortBy">
					<option value="DateUploaded">Most recent</option>
					<option value="Caption">
					<xsl:if test="$sortby='Caption'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					A-Z by title</option>
					<option value="Rating">
					<xsl:if test="$sortby='Rating'">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					Most rated</option>
				</select>
											
				<input type="submit" value="Go &gt;" style="width:40px;margin:0" />
				
			</form>
		</div>
	</xsl:template>
	
	<xsl:template match="MEMBERS" mode="t_pagination">
		<div class="paginationBlock">
			<xsl:apply-templates select="." mode="t_previouslink"/>
			<xsl:apply-templates select="." mode="t_pagelinks">
				<xsl:with-param name="pagenum" select="$skip div $show"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="t_nextlink"/>
		</div>
	</xsl:template>
	
	<xsl:template match="MEMBERS" mode="t_previouslink">
		<xsl:choose>
			<xsl:when test="$skip != 0">
				<span class="prev_active">
				<a href="{$cat_url}?s_skip={$skip - $show}&amp;s_show={$show}&amp;s_sortby={$sortby}">
					<b>previous</b>
				</a>
				|</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="prev_dormant">
					<b>previous</b>
				|</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="MEMBERS" mode="t_pagelinks">
		<xsl:param name="pagenum"/>
		<xsl:param name="n" select="1"/>
		
		<xsl:variable name="lowoffset" select="(ceiling(($pagenum + 1) div $show_pages) - 1) * $show_pages"/>
		<xsl:variable name="highoffset" select="$lowoffset + $show_pages"/>
		
		<xsl:variable name="nplusoffset" select="$n + $lowoffset"/>

		<xsl:choose>
			<xsl:when test="$nplusoffset = ($pagenum + 1)">
				<xsl:value-of select="$nplusoffset"/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$cat_url}?s_skip={($nplusoffset - 1) * $show}&amp;s_show={$show}&amp;s_sortby={$sortby}">
					<xsl:value-of select="$nplusoffset"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="ARTICLEMEMBERCOUNT &gt; ($nplusoffset * $show) and $nplusoffset &lt; $highoffset">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="." mode="t_pagelinks">
				<xsl:with-param name="pagenum" select="$pagenum"/>
				<xsl:with-param name="n" select="$n + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="MEMBERS" mode="t_nextlink">
			<xsl:choose>
			<xsl:when test="(ARTICLEMEMBERCOUNT - $skip) &gt; $show">
				<span class="next_active">|
				<a href="{$cat_url}?s_skip={$skip + $show}&amp;s_show={$show}&amp;s_sortby={$sortby}">
					<b>next</b>
				</a>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="next_dormant">|
					<b>next</b>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
	Use: Presentation of a node if it is a subject (contains other nodes)
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
		<xsl:apply-templates select="NAME" mode="t_nodename"/>
		<xsl:apply-templates select="NODECOUNT" mode="c_subject"/>
		<xsl:if test="SUBNODES/SUBNODE">
			<br/>
		</xsl:if>
		<xsl:apply-templates select="SUBNODES" mode="c_category"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODES" mode="r_category">
	Use: Presentation of the subnodes logical container
	 -->
	<xsl:template match="SUBNODES" mode="r_category">
		<xsl:apply-templates select="SUBNODE" mode="c_subnodename"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Use: Presenttaion of a subnode, ie the contents of a SUBJECTMEMBER node
	 -->
	<xsl:template match="SUBNODE" mode="r_subnodename">
		<font size="1">
			<xsl:apply-imports/>
			<xsl:text>, </xsl:text>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="zero_category">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="zero_subject">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="one_category">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="one_subject">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_category">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="many_subject">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
	Use: Presentation of an node if it is an article
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
		<xsl:choose>
			<!-- when category is Programme Challenge category -->
			<xsl:when test="$is_programme_challenge">
				<xsl:if test="(position() &gt;= $skip) and (position() &lt; ($skip + $page_size))">
					<li class="smallFB">
						<div class="imageHolder">
							<a href="{$root}A{H2G2ID}"><img src="{$imagesource}challenge/134/{H2G2ID}.jpg" width="134" height="134" alt="{NAME}"/></a>
						</div>
						<div class="content">
							<h2 class="fbHeader"><a href="{$root}A{H2G2ID}"><xsl:value-of select="NAME"/></a></h2>
							<xsl:if test="EXTRAINFO/AUTODESCRIPTION">
								<p><xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/></p>
							</xsl:if>
							<div class="starRating">user rating: 
								<xsl:choose>
									<xsl:when test="POLL/STATISTICS/@AVERAGERATING > 0" >
										<img src="{$imagesource}stars_{floor(POLL/STATISTICS/@AVERAGERATING)}.gif" alt="{floor(POLL/STATISTICS/@AVERAGERATING)}" width="65" height="12" />
									</xsl:when>
									<xsl:otherwise>
										not yet rated
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<div class="author">by <a href="{$root}U{EDITOR/USER/USERID}"><xsl:value-of select="EDITOR/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="EDITOR/USER/LASTNAME"/></a></div>
							<div class="description">
								<xsl:choose>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE=1">
											images
										</xsl:when>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE=2">
											audio
										</xsl:when>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE=3">
											video
										</xsl:when>
								</xsl:choose><span class="challenge">CHALLENGE</span><span></span></div>	
						</div>
						<div class="clr"></div>
					</li>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_category">
	Use: Presentation of a node if it is a nodealias
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_category">
		<xsl:apply-templates select="NAME" mode="t_nodealiasname"/>
		<xsl:apply-templates select="NODECOUNT" mode="c_nodealias"/>
		<xsl:if test="SUBNODES/SUBNODE">
			<br/>
		</xsl:if>
		<xsl:apply-templates select="SUBNODES" mode="c_category"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="zero_category">
	Use: Used if a NODEALIASMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="zero_nodealias">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="one_category">
	Use: Used if a NODEALIASMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="one_nodealias">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="many_category">
	Use: Used if a NODEALIASMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="many_nodealias">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="r_category">
	Use: Presentation of a node if it is a club
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_category">
		<xsl:apply-templates select="NAME" mode="t_clubname"/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION" mode="c_clubdescription"/>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="r_clubdesription">
	Use: Presentation of the club's description
	 -->
	<xsl:template match="DESCRIPTION" mode="r_clubdesription">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for issue page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_issue">
	Use: HIERARCHYDETAILS container used if the taxonomy is at a particular depth
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_issue">
		<xsl:apply-templates select="/H2G2/CLIP" mode="c_issueclipped"/>
		<xsl:apply-templates select="ANCESTRY" mode="c_issue"/>
		<font size="3">
			<b>
				<xsl:value-of select="DISPLAYNAME"/>
			</b>
		</font>
		<br/>
		<xsl:apply-templates select="." mode="c_clipissue"/>
		<br/>
		<b>
			<xsl:copy-of select="$m_catpagememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_numberofclubs"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_numberofarticles"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_subjectmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_nodealiasmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_clubmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_articlemembers"/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_issueclipped">
	Description: message to be displayed after clipping an issue
	 -->
	<xsl:template match="CLIP" mode="r_issueclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="HIERARCHYDETAILS" mode="r_clipissue">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="r_clipissue">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_issue">
	Use: Lists the crumbtrail for the current node
	 -->
	<xsl:template match="ANCESTRY" mode="r_issue">
		<xsl:apply-templates select="ANCESTOR" mode="c_issue"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_issue">
	Use: One item within the crumbtrail
	 -->
	<xsl:template match="ANCESTOR" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> /</xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
	Use: container for displaying the number of clubs there are in a node
	 -->
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
		<xsl:copy-of select="$m_numberofclubstext"/>
		 [<xsl:apply-imports/>]
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
	Use: container for displaying the number of articles there are in a node
	 -->
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
		<xsl:copy-of select="$m_numberofarticlestext"/>
		[<xsl:apply-imports/>]
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_subjectmembers">
	Use: Logical container for all subject members
	 -->
	<xsl:template match="MEMBERS" mode="r_subjectmembers">
		<xsl:copy-of select="$m_subjectmemberstitle"/>
		<xsl:apply-templates select="SUBJECTMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
	Use: display of a single subject member within the above logical container
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::SUBJECTMEMBER">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_nodealiasmembers">
	Use: Logical container for all subject members
	 -->
	<xsl:template match="MEMBERS" mode="r_nodealiasmembers">
		<xsl:apply-templates select="NODEALIASMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
	Use: display of a single subject member within the above logical container
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::NODEALIASMEMBER">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="short_clubmembers">
	Use: Logical container for all club members
	 -->
	<xsl:variable name="clubmaxlength">1</xsl:variable>
	<xsl:template match="MEMBERS" mode="short_clubmembers">
		<b>
			<xsl:copy-of select="$m_clubmemberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_issue"/>
		<xsl:apply-templates select="." mode="c_moreclubs"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="full_clubmembers">
	Use: Logical container for all club members
	 -->
	<xsl:template match="MEMBERS" mode="full_clubmembers">
		<b>
			<xsl:copy-of select="$m_clubmemberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_issue"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="r_issue">
	Use: Display of a single club member within the above logical container
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_issue">
		<xsl:apply-templates select="." mode="t_clubname"/>
		<br/>
		<xsl:apply-templates select="." mode="t_clubdescription"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="short_articlemembers">
	Use: Logical container for shortened list of article members
	 -->
	<xsl:variable name="articlemaxlength">3</xsl:variable>
	<xsl:template match="MEMBERS" mode="short_articlemembers">
		<b>
			<xsl:copy-of select="$m_articlememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_issue"/>
		<xsl:apply-templates select="." mode="c_morearticles"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="full_articlemembers">
	Use: Logical container for all article members
	 -->
	<xsl:template match="MEMBERS" mode="full_articlemembers">
		<b>
			<xsl:copy-of select="$m_articlememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Use: Display of a single article container within the above logical container
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
