<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
	<!ENTITY laquo "&#171;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:str="http://exslt.org/strings" exclude-result-prefixes="msxsl local s dt str">
	<!--
	reduce_length truncates the text in a node-set to fall within the boundaries set out in $chars_per_page
	snip_content removes extraneous elements from the node-set
	 -->
	<xsl:import href="../../../base/base-articlepage.xsl"/>
	<xsl:template name="ARTICLE_CSS">
		<LINK href="{$csssource}life.css" rel="stylesheet"/>
	</xsl:template>
	<xsl:variable name="article_created_date">
		<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE" mode="article_mob"/>
	</xsl:variable>
	<xsl:template match="DATE" mode="article_mob">
		<xsl:variable name="month">
			<xsl:choose>
				<xsl:when test="@MONTHNAME='January'">Jan</xsl:when>
				<xsl:when test="@MONTHNAME='February'">Feb</xsl:when>
				<xsl:when test="@MONTHNAME='March'">Mar</xsl:when>
				<xsl:when test="@MONTHNAME='April'">Apr</xsl:when>
				<xsl:when test="@MONTHNAME='May'">May</xsl:when>
				<xsl:when test="@MONTHNAME='June'">Jun</xsl:when>
				<xsl:when test="@MONTHNAME='July'">Jul</xsl:when>
				<xsl:when test="@MONTHNAME='August'">Aug</xsl:when>
				<xsl:when test="@MONTHNAME='September'">Sep</xsl:when>
				<xsl:when test="@MONTHNAME='October'">Oct</xsl:when>
				<xsl:when test="@MONTHNAME='November'">Nov</xsl:when>
				<xsl:when test="@MONTHNAME='December'">Dec</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat(@DAY, ' ', $month, ' ', @YEAR)"/>
	</xsl:template>
	<!-- 
	variable holding the restructured article as a node-set
	-->
	<xsl:variable name="restructured_article" select="msxsl:node-set($divided_article)"/>
	<!-- 
	works out value of s_parameters and stores them as XML
	-->
	<xsl:variable name="page_parameters">
		<parameter name="s_id">
			<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
		</parameter>
		<parameter name="s_split">
			<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_split']"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_split']/VALUE"/></xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose></xsl:attribute>
		</parameter>
	</xsl:variable>
	<!-- 
	variables holding the id and section
	-->
	<xsl:variable name="s_id" select="msxsl:node-set($page_parameters)/parameter[@name='s_id']/@value"/>
	<xsl:variable name="s_split" select="msxsl:node-set($page_parameters)/parameter[@name='s_split']/@value"/>
	<!-- 
	tokenized full doc
	-->
	<xsl:variable name="tokenized_doc">
		<xsl:for-each select="$restructured_article/*">
			<section>
				<xsl:for-each select=".//text()">
					<xsl:call-template name="str:tokenize">
						<xsl:with-param name="string" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</section>
		</xsl:for-each>
	</xsl:variable>
	<!-- 
	tokenized full doc as a nodeset
	-->
	<xsl:variable name="document_as_tokens" select="msxsl:node-set($tokenized_doc)"/>
	<xsl:variable name="page_stats">
		<xsl:for-each select="$document_as_tokens/section">
			<section pages="{ceiling(count(token) div $words_per_page)}"/>
		</xsl:for-each>
	</xsl:variable>
	<!-- 
	calculates the page number of the current page
	-->
	<xsl:template name="find_current_page">
		<xsl:param name="section" select="1"/>
		<xsl:param name="counter" select="0"/>
		<xsl:variable name="this_section" select="$s_id"/>
		<xsl:variable name="this_split" select="$s_split"/>
		<xsl:choose>
			<xsl:when test="$section &lt; $this_section">
				<xsl:call-template name="find_current_page">
					<xsl:with-param name="section" select="$section + 1"/>
					<xsl:with-param name="counter" select="$counter + msxsl:node-set($page_stats)/section[position() = $section]/@pages"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$this_split + $counter"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	total number of pages in the doc
	-->
	<xsl:variable name="pages_in_doc" select="sum(msxsl:node-set($page_stats)/section/@pages)"/>

	<!-- 
	Link to the previous page in the article
	-->
	<xsl:template name="previous_article_page">
		<xsl:param name="content" select="'&laquo;'"/>
		<xsl:choose>
			<xsl:when test="$s_split = 1 and $s_id=1">
				<xsl:copy-of select="$content"/>
			</xsl:when>
			<xsl:when test="$s_split &gt; 1">
				<a xsl:use-attribute-sets="nprevious_page_article">
					<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', $article_dnaid, '?s_split=', $s_split - 1, '&amp;s_id=', $s_id)"/></xsl:attribute>
					<xsl:copy-of select="$content"/>
				</a>
			</xsl:when>
			<xsl:when test="$s_id &gt; 1">
				<a xsl:use-attribute-sets="nprevious_page_article">
					<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', $article_dnaid, '?s_split=', ceiling(count($document_as_tokens/section[position() = $s_id - 1 ]/token) div $words_per_page), '&amp;s_id=', $s_id - 1)"/></xsl:attribute>
					<xsl:copy-of select="$content"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="nprevious_page_article">
		<xsl:attribute name="class">pageLnk</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	Link to the next page in the article
	-->
	<xsl:template name="next_article_page">
		<xsl:param name="content" select="'&raquo;'"/>
		<xsl:param name="lastpage"/>
		<!-- lastpage='hide' if you want to hide it -->
		<xsl:variable name="splits_in_this_section" select="ceiling(count($document_as_tokens/section[position() = $s_id]/token) div $words_per_page)"/>
		<xsl:variable name="splits_in_next_section" select="ceiling(count($document_as_tokens/section[position() = $s_id + 1]/token) div $words_per_page)"/>
		<xsl:variable name="ids_in_doc" select="count($document_as_tokens/section)"/>
		<xsl:choose>
			<xsl:when test="$s_split &lt; $splits_in_this_section">
				<a href="{$root}A{$article_dnaid}?s_id={$s_id}&amp;s_split={$s_split + 1}" xsl:use-attribute-sets="nnext_article_page">
					<xsl:copy-of select="$content"/>
				</a>
			</xsl:when>
			<xsl:when test="($s_split = $splits_in_this_section) and ($s_id &lt; $ids_in_doc)">
				<a href="{$root}A{$article_dnaid}?s_id={$s_id + 1}&amp;s_split=1" xsl:use-attribute-sets="nnext_article_page">
					<xsl:copy-of select="$content"/>
				</a>
			</xsl:when>
			<xsl:when test="($s_split = $splits_in_this_section) and ($s_id = $ids_in_doc) and $lastpage != 'hide'">
				<xsl:copy-of select="$content"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="nnext_article_page">
		<xsl:attribute name="class">pageLnk</xsl:attribute>
	</xsl:attribute-set>
	<!--
	########################################
	Begin presentation of the article
	########################################
	-->
	<xsl:template name="ARTICLE_MAINBODY">
		
		<!--xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" mode="newbody"/-->
		<xsl:variable name="count_elements_in_article" select="count(/H2G2/ARTICLE/GUIDE//*)"/>
		<xsl:choose>
			<xsl:when test="($count_elements_in_article &gt; 200) and /H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE=3]">
				<div class="content">Sorry your article could not be displayed</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" mode="newbody"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CRUMBTRAILS" mode="LUE">
		<!-- AWFUL XSL - NEEDS UPDATING -->
		<xsl:variable name="LUE">
			<xsl:if test="CRUMBTRAIL/ANCESTOR[2]/NODEID='72'">
				<node dnaid="72">
					<xsl:value-of select="CRUMBTRAIL/ANCESTOR[2][NODEID='72']/NAME"/>
				</node>
			</xsl:if>
			<xsl:if test="CRUMBTRAIL/ANCESTOR[2]/NODEID='73'">
				<node dnaid="73">
					<xsl:value-of select="CRUMBTRAIL/ANCESTOR[2][NODEID='73']/NAME"/>
				</node>
			</xsl:if>
			<xsl:if test="CRUMBTRAIL/ANCESTOR[2]/NODEID='74'">
				<node dnaid="74">
					<xsl:value-of select="CRUMBTRAIL/ANCESTOR[2][NODEID='74']/NAME"/>
				</node>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="msxsl:node-set($LUE)/node">
			<a href="{$root}C{@dnaid}?s_show=search">
				<xsl:value-of select="."/>
			</a>
			<xsl:if test="position() != last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- 
	<xsl:template match="BODY" mode="newbody">
	Purpose: 
	-->

	<xsl:template match="BODY" mode="newbody">
		<xsl:variable name="current_page">
			<xsl:call-template name="find_current_page"/>
		</xsl:variable>
		<xsl:variable name="last_nodeset">
			<xsl:for-each select="$restructured_article/*[position()=last()]//text()">
				<xsl:call-template name="str:tokenize">
					<xsl:with-param name="string" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="pages_in_doc_loc">
			<xsl:choose>
				<xsl:when test="$current_page = $pages_in_doc">
					<xsl:value-of select="$pages_in_doc"/>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_id={count($restructured_article/*)}&amp;s_split={ceiling(count(msxsl:node-set($last_nodeset)/token) div $words_per_page)}" class="pageLnk">
						<xsl:value-of select="$pages_in_doc"/>
						<!-- +2 for the credits and article categorisation -->
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="article_subject" select="/H2G2/ARTICLE/SUBJECT"/>
		
		<div class="info">
			<b>
				<xsl:value-of select="$article_subject"/>
			</b>
			<br/>
			<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS">
			In: 
			<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="LUE"/>
				<br/>
			</xsl:if>
		</div>
		<div class="chapter">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE='category'">
					<xsl:text>Entry Categorisation:</xsl:text>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE='author'">
					<xsl:text>Written &amp; researched by:</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$restructured_article/*[position() = $s_id]/@TITLE"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<xsl:if test="$s_id != 'author' and $s_id != 'category'">
			<div class="topPaginate">
				<xsl:call-template name="previous_article_page"/>
				<xsl:text> </xsl:text>
				<!--a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="pageLnk">&laquo;</a-->
				<xsl:value-of select="$current_page"/> of <xsl:copy-of select="$pages_in_doc_loc"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="next_article_page"/>
			</div>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id'][VALUE='category']">
				<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="pda_article"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id'][VALUE='author']">
				<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR" mode="pda_article"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="msxsl:node-set($current_section)/BODY" mode="me"/>
			</xsl:otherwise>
		</xsl:choose>
		<div class="band2">
			<b>Entry Chapters:</b>
			<br/>
		</div>
		<xsl:for-each select="$restructured_article/*">
			<div>
				<xsl:attribute name="class"><xsl:choose><xsl:when test="count(preceding-sibling::*) mod 2 = 0">band1</xsl:when><xsl:otherwise>band2</xsl:otherwise></xsl:choose></xsl:attribute>
				<span class="chevron">&raquo;</span>
				<xsl:choose>
					<xsl:when test="(count(preceding-sibling::*) + 1) = $s_id">
						<xsl:value-of select="@TITLE"/>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}A{$article_dnaid}?s_id={position()}" class="bulletLnk">
							<xsl:value-of select="@TITLE"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			</div>
		</xsl:for-each>
		<div>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="count($restructured_article/*) mod 2 = 0">band1</xsl:when><xsl:otherwise>band2</xsl:otherwise></xsl:choose></xsl:attribute>
			<span class="chevron">&raquo;</span>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE='author'">
					<xsl:text>Credits</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}A{$article_dnaid}?s_id=author" class="bulletLnk">
						<xsl:text>Credits</xsl:text>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="count($restructured_article/*) mod 2 = 0">band2</xsl:when><xsl:otherwise>band1</xsl:otherwise></xsl:choose></xsl:attribute>
			<span class="chevron">&raquo;</span>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE='category'">
					<xsl:text>Entry Categorisation</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}A{$article_dnaid}?s_id=category" class="bulletLnk">
						<xsl:text>Entry Categorisation</xsl:text>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="CRUMBTRAILS" mode="pda_article">
		<div class="content">
			<xsl:apply-templates select="CRUMBTRAIL" mode="pda_article"/>
			<div align="center">---- End of entry ----<br/>
			</div>
		</div>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="CRUMBTRAIL" mode="pda_article">
		<xsl:apply-templates select="ANCESTOR[position() &gt; 1]" mode="pda_article"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ANCESTOR" mode="pda_article">
		<a href="{$root}C{NODEID}">
			<xsl:value-of select="NAME"/>
		</a>
		<xsl:if test="not(position()=last())"> &#47; </xsl:if>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="PAGEAUTHOR" mode="pda_article">
		<div class="content">
			<ul type="square">
				<!--xsl:apply-templates select="EDITOR/USER" mode="pda_article"/-->
				<xsl:apply-templates select="RESEARCHERS/USER" mode="pda_article"/>
			</ul>
		</div>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="USER" mode="pda_article">
		<li>
			<xsl:value-of select="USERNAME"/>
		</li>
	</xsl:template>
	<!--

	-->
	<xsl:template match="BODY" mode="me">
		<xsl:variable name="current_page">
			<xsl:call-template name="find_current_page"/>
		</xsl:variable>
		<xsl:variable name="text">
			<xsl:apply-templates select="descendant::text()" mode="builtin"/>
		</xsl:variable>
		<!--xsl:variable name="total_pages" select="ceiling(string-length($text) div $chars_per_page)"/-->
		
		<div class="content">
			<xsl:if test="$s_id=1 and $s_split=1">
				<xsl:text>Created: </xsl:text>
				<xsl:value-of select="$article_created_date"/>
				<br/>
			</xsl:if>
			<xsl:call-template name="snip_content">
				<xsl:with-param name="fragment" select="node()"/>
			</xsl:call-template>
			<xsl:call-template name="next_article_page">
				<xsl:with-param name="content">Continued page <xsl:value-of select="$current_page+1"/>/<xsl:value-of select="$pages_in_doc"/>
				</xsl:with-param>
				<xsl:with-param name="lastpage">hide</xsl:with-param>
			</xsl:call-template>
			<!--span class="chevron">&raquo;</span><a href="entry_02.shtml">Page 2 of 80</a-->
		</div>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="ARTICLEFORUM" mode="me">
		<div class="goto_articleforum_me">
			<a href="{$root}F{FORUMTHREADS/@FORUMID}">Go to Forum</a>
		</div>
	</xsl:template>
	<!-- ################################################################################################## -->
	<!--
	<xsl:template name="snip_content">
	Author:		Tom Whitehouse
	Purpose:	Reduces an XML nodeset to only include text within a given range and, using the mode="trim" matches below, removes extraneous elements, ie elements
				with no text() descendents.
	-->
	<xsl:template name="snip_content">
		<xsl:param name="fragment"/>
		
		<xsl:variable name="snippedtext">
			<xsl:call-template name="reduce_length">
				<xsl:with-param name="fragment" select="$fragment"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:apply-templates select="msxsl:node-set($snippedtext)" mode="trim"/>
		
	</xsl:template>
	<!--
	<xsl:template match="*" mode="trim">
	Author:		Tom Whitehouse
	Purpose:	Utilised by snip_content to remove empty html elements
	-->
	<xsl:template match="*" mode="trim">
		<xsl:if test="descendant::text()">
			<xsl:element name="{translate(name(), $uppercase, $lowercase)}">
				<xsl:apply-templates select="* | @* | text()" mode="trim"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SUBHEADER" mode="trim">
		<xsl:if test="descendant::text()">
			<b>
				<xsl:value-of select="."/>
			</b>
			<br/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="*" mode="trim">
	Author:		Tom Whitehouse
	Purpose:	Utilised by snip_content to remove empty html elements
	-->
	<xsl:template match="LINK" mode="trim">
		<xsl:if test="descendant::text() and not(@POPUP=1) and not(PICTURE)">
			<xsl:if test="@H2G2|@h2g2|@DNAID">
				<a xsl:use-attribute-sets="mLINK">
					<xsl:call-template name="dolinkattributes"/>
					<xsl:call-template name="bio-link"/>
				</a>
			</xsl:if>
			<xsl:if test="@HREF|@href">
				<xsl:apply-templates/>
			</xsl:if>
			<xsl:if test="@BIO|@bio">
				<a xsl:use-attribute-sets="mLINK">
					<xsl:call-template name="dolinkattributes"/>
					<xsl:call-template name="bio-link"/>
				</a>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--xsl:template match="@HREF|@H2G2|@DNAID" mode="trim">
		
		<xsl:attribute name="href"><xsl:apply-templates select="." mode="applyroot"/></xsl:attribute>
	</xsl:template-->
	<xsl:template match="FOOTNOTE" mode="trim">
		<xsl:if test="descendant::text()"> [<xsl:value-of select="."/>] </xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@*" mode="trim">
	Author:		Tom Whitehouse
	Purpose:	Used in conjunction with <xsl:template match="*" mode="trim"> so that attributes are not trimmed from the node-set
	-->
	<xsl:template match="@*" mode="trim">
		<xsl:copy/>
	</xsl:template>
	<!--
	<xsl:template match="br | BR" mode="trim">
	Author:		Tom Whitehouse
	Purpose:	Utilised by snip_content - allows any elements matched for this template to be displayed if its inside the chars_per_page level
	-->
	<xsl:template match="br | BR" mode="trim">
		<xsl:if test="preceding::text() and following::text()">
			<!-- If it falls somewhere within text - may be a dodgy rule. -->
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TABLE" mode="trim">
		<xsl:text>[ Tables are only available on the website ]</xsl:text>
	</xsl:template>
	<!-- ################################################################################################## -->
	<!-- ################################################################################################## -->
	<!--
	<xsl:template name="reduce_length">
	Author:		Tom Whitehouse
	Purpose:	receives a fragment, then inserts that fragment inside a <SNIP> wrapper, using the following templates
				all elements and attributes are output, however only strings which fall inside the appropriate limits for that
				page will be output. The limits are determined by $chars_per_page
	-->
	<xsl:template name="reduce_length">
		<xsl:param name="fragment"/>
		<xsl:param name="content">
			<SNIP>
				<xsl:copy-of select="$fragment"/>
			</SNIP>
		</xsl:param>
		<xsl:apply-templates select="msxsl:node-set($content)/SNIP/node()" mode="mark"/>
	</xsl:template>
	<!-- 
	<xsl:template match="*[ancestor::SNIP]">
	Purpose: All elements are output as normal when called by reduce_length
	-->
	<xsl:template match="*" mode="mark">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()" mode="mark"/>
		</xsl:copy>
	</xsl:template>
	<!-- 
	<xsl:template match="@*[ancestor::SNIP]">
	Purpose: All attributes are output as normal when called by reduce_length
	-->
	<xsl:template match="@*" mode="mark">
		<xsl:copy/>
	</xsl:template>
	<!--
	<xsl:template match="text()[ancestor::SNIP]">
	Author:		Tom Whitehouse
	Purpose:	Utilised by reduce_length and overrides the default text() match. Calculates the number of characters in 
				previous text() nodes. If the value of $chars_per_page lies within the current text() node it is truncated 
				at the appropriate place.
	-->
	<xsl:variable name="words_per_page" select="200"/>
	<xsl:variable name="all_words_in_id">
		<xsl:for-each select="/H2G2/ARTICLE/GUIDE//text()">
			<xsl:call-template name="str:tokenize">
				<xsl:with-param name="string" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:variable>
	<xsl:template match="text()" mode="tom">
		<xsl:value-of select="."/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="text()" mode="mark">
		<xsl:param name="current_page">
			<xsl:call-template name="find_current_page"/>
		</xsl:param>
		<xsl:variable name="start_point">
			<xsl:choose>
				<xsl:when test="$s_split">
					<xsl:value-of select="(($s_split -1) * $words_per_page) + 1"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="end_point" select="$start_point + $words_per_page - 1"/>
		<xsl:variable name="tokenized_text">
			<xsl:call-template name="str:tokenize">
				<xsl:with-param name="string" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ref_tokenized_text" select="msxsl:node-set($tokenized_text)"/>
		<xsl:variable name="preceding_tom"/>
		<xsl:variable name="preceding_tokenized_text">
			<xsl:for-each select="preceding::text()[not(.='&#xa;')][not(.='&#x9;')]">
				<xsl:call-template name="str:tokenize">
					<xsl:with-param name="string" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="tomtext">
			<xsl:apply-templates select="preceding::text()" mode="tom"/>
		</xsl:variable>
		<xsl:variable name="count_preceding_words" select="count(msxsl:node-set($preceding_tokenized_text)/token)"/>
		<xsl:variable name="count_preceding_and_self_words" select="$count_preceding_words + count(msxsl:node-set($ref_tokenized_text)/token)"/>
		<xsl:variable name="count_all_words_in_id" select="count(msxsl:node-set($all_words_in_id)/token)"/>
		<xsl:variable name="count_all_words_upto_current_id" select="count($document_as_tokens/section[position() &lt;= $s_id]/token)"/>
		<xsl:choose>
			<xsl:when test="($count_preceding_words &lt; $end_point)
							and
							($count_preceding_and_self_words &gt;= $start_point)">
				<xsl:apply-templates select="msxsl:node-set($ref_tokenized_text)/token" mode="test">
					<xsl:with-param name="count_preceding_words" select="$count_preceding_words"/>
					<xsl:with-param name="end_point" select="$end_point"/>
					<xsl:with-param name="start_point" select="$start_point"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[ancestor::TABLE]" mode="mark"/>
	<xsl:template match="token" mode="test">
		<xsl:param name="count_preceding_words"/>
		<xsl:param name="end_point"/>
		<xsl:param name="start_point"/>
		<xsl:variable name="position" select="count(preceding-sibling::token) + $count_preceding_words + 1"/>
		<xsl:if test="($position &lt;= $end_point) and ($position &gt;= $start_point)">
			<xsl:value-of select="concat(., ' ')"/>
		</xsl:if>
	</xsl:template>
	<!-- ################################################################################################## -->
	<xsl:variable name="article_dnaid">
		<xsl:choose>
			<xsl:when test="$restructured_article/ARTICLE">
				<xsl:value-of select="$restructured_article/ARTICLE/@DNAID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$restructured_article/HEADER/@DNAID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="article_title">
		<xsl:choose>
			<xsl:when test="$restructured_article/ARTICLE">
				<xsl:value-of select="$restructured_article/ARTICLE/@TITLE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$restructured_article/HEADER/@TITLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- 
	<xsl:variable name="divided_article">
	Purpose: Transforms the XML format of an H2G2 article to be a list of <HEADERS> which contains its related content.
			  The first element is <ARTICLE>
	-->
	<xsl:variable name="divided_article">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/BODY/HEADER">
				<xsl:if test="/H2G2/ARTICLE/GUIDE/BODY/node()[not(name()='PICTURE')][following-sibling::HEADER[not(preceding-sibling::HEADER)]]">
					<!-- If the very first node of an entry is a picture, ignore it -->
					<ARTICLE TITLE="{/H2G2/ARTICLE/SUBJECT}" DNAID="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
						<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY/node()[following-sibling::HEADER[not(preceding-sibling::HEADER)]]"/>
						<!-- Copy nodeset before the first header -->
					</ARTICLE>
				</xsl:if>
				<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/HEADER">
					<HEADER TITLE="{.}" DNAID="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
						<xsl:apply-templates select="following-sibling::node()[1][name()!='HEADER']" mode="restructure"/>
						<!-- apply templates to following siblings which have a name() of header -->
					</HEADER>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/BODY/A/HEADER">
				<xsl:if test="/H2G2/ARTICLE/GUIDE/BODY/node()[not(name()='PICTURE')][following-sibling::A[not(preceding-sibling::A/HEADER)]/HEADER]">
					<ARTICLE TITLE="{/H2G2/ARTICLE/SUBJECT}" DNAID="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
						<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY/node()[following-sibling::A[not(preceding-sibling::A/HEADER)]/HEADER]"/>
						<!-- Copy nodeset before the first A/HEADER occurence -->
					</ARTICLE>
				</xsl:if>
				<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/A/HEADER">
					<HEADER TITLE="{.}" DNAID="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
						<xsl:apply-templates select="../following-sibling::node()[1][name()!='A']" mode="restructureanchors"/>
					</HEADER>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<ARTICLE TITLE="{/H2G2/ARTICLE/SUBJECT}" DNAID="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY/node()"/>
				</ARTICLE>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- 
	<xsl:template match="* | text()" mode="restructure">
	Purpose: Applies templates to a following-sibling if it is not a <HEADER>
	-->
	<xsl:template match="* | text()" mode="restructure">
		<xsl:copy-of select="."/>
		<xsl:apply-templates select="following-sibling::node()[1][name()!='HEADER']" mode="restructure"/>
		<!-- apply templates to the following sibling which has a name() of header -->
	</xsl:template>
	<!-- 
	<xsl:template match="* | text()" mode="restructureanchors">
	Purpose: Applies templates to a following sibling if it is not an <A/> tag ********** should check for <HEADER here too ***********
	-->
	<xsl:template match="* | text()" mode="restructureanchors">
		<xsl:copy-of select="."/>
		<xsl:apply-templates select="following-sibling::node()[1][name()!='A']" mode="restructureanchors"/>
		<!-- apply templates to the following sibling which has a name() of header -->
	</xsl:template>
	<!-- 
	<xsl:variable name="current_section">
	Purpose: Creates a node-set, enclosed in a BODY tag, which contains the content to be displayed on this page *only*	
	-->
	<xsl:variable name="current_section">
		<BODY>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_id']">
					<xsl:copy-of select="$restructured_article/*[position() = $s_id]/node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$restructured_article/*[1]/node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</BODY>
	</xsl:variable>
	<xsl:template name="str:tokenize">
		<xsl:param name="string" select="''"/>
		<!--xsl:param name="delimiters" select="' &#x9;&#xA;'"/-->
		<xsl:param name="delimiters" select="' '"/>
		<xsl:choose>
			<xsl:when test="not($string)"/>
			<xsl:when test="not($delimiters)">
				<xsl:call-template name="str:_tokenize-characters">
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="str:_tokenize-delimiters">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="delimiters" select="$delimiters"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="str:_tokenize-characters">
		<xsl:param name="string"/>
		<xsl:if test="$string">
			<token>
				<xsl:value-of select="substring($string, 1, 1)"/>
			</token>
			<xsl:call-template name="str:_tokenize-characters">
				<xsl:with-param name="string" select="substring($string, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="str:_tokenize-delimiters">
		<xsl:param name="string"/>
		<xsl:param name="delimiters"/>
		<xsl:variable name="delimiter" select="substring($delimiters, 1, 1)"/>
		<xsl:choose>
			<xsl:when test="not($delimiter)">
				<token>
					<xsl:value-of select="$string"/>
				</token>
			</xsl:when>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:if test="not(starts-with($string, $delimiter))">
					<xsl:call-template name="str:_tokenize-delimiters">
						<xsl:with-param name="string" select="substring-before($string, $delimiter)"/>
						<xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:call-template name="str:_tokenize-delimiters">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="delimiters" select="$delimiters"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="str:_tokenize-delimiters">
					<xsl:with-param name="string" select="$string"/>
					<xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
