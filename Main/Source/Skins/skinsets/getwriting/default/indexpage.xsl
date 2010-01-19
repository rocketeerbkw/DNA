<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-indexpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:variable name="searchgroup" select="msxsl:node-set($type)/type[@number=$searchtype or @selectnumber=$searchtype]/@group" />
	<xsl:variable name="searchtype" select="/H2G2/INDEX/SEARCHTYPES/TYPE" />
	<xsl:variable name="searchtypeurl" select="msxsl:node-set($type)/type[@number=$searchtype or @selectnumber=$searchtype]/@subtype" />
	<xsl:variable name="searchtypename" select="msxsl:node-set($type)/type[@number=$searchtype or @selectnumber=$searchtype]/@label" />
	
	<xsl:template name="INDEX_MAINBODY">
	
	<xsl:apply-templates select="INDEX" mode="c_index"/>

	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INDEX Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="INDEX" mode="r_index">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">INDEX</xsl:with-param>
	<xsl:with-param name="pagename">index.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<!-- <xsl:if test="$test_IsEditor"> --><!-- removed for site pulldown -->




	<xsl:choose>
	<xsl:when test="SEARCHTYPES/TYPE=1001">
	
	<xsl:variable name="letter" select="translate(@LETTER,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
	<!-- /// groups layout -->
	<div class="PromoMain">
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="70">
			<img src="{$graphics}icons/az/large/large_{$letter}.gif" alt="{@LETTER}" width="70" height="80" border="0"/>
			</td>
			<td width="497">
			<div class="box">
			<table width="497" cellspacing="0" cellpadding="0" border="0">
			<tr><td colspan="2" class="boxheading">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
			GROUP NAME
			</xsl:element>
			
			</td></tr>
				<xsl:apply-templates select="INDEXENTRY[not(SUBJECT='A Club for Editors')]" mode="c_index"/>
			</table>
			</div>
			</td>
		</tr>
		</table>
	</div><br/><br/>
	</xsl:when>
	<xsl:otherwise>
	
	<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
	<div class="PageContent">
	
<xsl:choose>
	<xsl:when test="$searchgroup='challenge' or $searchgroup='advice'">
	<img src="{$graphics}/icons/icon_{$searchtypeurl}.gif" alt="{$searchtypename}" width="38" height="38" border="0"/>
	<img src="{$graphics}titles/search/t_all{$searchtypeurl}.gif" alt="{$searchtypename}" width="205" height="39" border="0"/>
	<hr class="line"/>
	</xsl:when>
	<xsl:when test="$searchgroup='creative'">
			<img src="{$graphics}/icons/icon_{$searchtypeurl}.gif" alt="{$searchtypename}" width="38" height="38" border="0"/>
			<img src="{$graphics}titles/search/t_all{$searchtypeurl}.gif" alt="{$searchtypename}" width="205" height="39" border="0"/>
			
			<hr class="line"/>
			
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			click on  a letter to see all item listed alphabetically
			</xsl:element>
			
			<!-- a-z list -->
			<div class="alphabox">
			<xsl:call-template name="alphaindex">
			<xsl:with-param name="showtype">&amp;user=on</xsl:with-param>
			<xsl:with-param name="type">&amp;type=<xsl:value-of select="$searchtype" /></xsl:with-param>
			</xsl:call-template>
			</div>
	
	</xsl:when>
	<xsl:when test="contains($searchtypeurl,'minicourse')">
	<table>
	<tr>
	<td><img src="{$graphics}/titles/learn/t_{$searchtypeurl}.gif" alt="{$searchtypename}" border="0"/></td>
	<td align="right"><img src="{$graphics}/icons/icon_{$searchtypeurl}.gif" alt="{$searchtypename}" border="0"/></td>
	</tr>
	</table>
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>

		<!-- prev next -->
		
		<!-- <div class="prevnextbox">
		<table width="390" cellspacing="0" cellpadding="2" border="0">
		<tr>
		<td class="uppercase"><strong><xsl:value-of select="/H2G2/INDEX/@LETTER" /></strong></td>
		<td><xsl:apply-templates select="@SKIP" mode="c_index"/> | <xsl:apply-templates select="@MORE" mode="c_index"/></td>
		
		</tr>
		</table>
		</div> -->
			
			
		<div class="box">
		<table width="390" cellspacing="0" cellpadding="2" border="0">		
		<xsl:choose>
		<xsl:when test="$searchgroup='challenge' or $searchgroup='advice'">
			<xsl:apply-templates select="INDEXENTRY" mode="c_sortindex">
			<xsl:sort select="H2G2ID" data-type="number" order="descending"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="INDEXENTRY" mode="c_index"/>
		</xsl:otherwise>
		</xsl:choose>
		</table>
		</div>
						
		<!-- <div class="prevnextbox">
		<table width="390" cellspacing="0" cellpadding="2" border="0">
		<tr>
		<td class="uppercase"><strong><xsl:value-of select="/H2G2/INDEX/@LETTER" /></strong></td>
		<td><xsl:apply-templates select="@SKIP" mode="c_index"/> | <xsl:apply-templates select="@MORE" mode="c_index"/></td>
		
		</tr>
		</table>
		</div> -->
		
		</div>
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:choose>
		<!-- MINI-COURSE TIPS -->
		<xsl:when test="contains($searchtypeurl,'minicourse')">
		
		<xsl:apply-templates select="/H2G2/SITECONFIG/TIMETABLE" />
		
			<div class="rightnavboxheaderhint">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			MINI-COURSE TIPS</xsl:element></div>
			
			<div class="rightnavbox">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$index.minicourse.tips" />
			</xsl:element>
			</div>
			<br/>
			<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
		</xsl:when>
		<xsl:when test="$searchtype=57 or $searchtype=58">
			<div class="rightnavboxheaderhint">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			TOOLS &amp; QUIZZES TIPS</xsl:element></div>
			
			<div class="rightnavbox">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$index.toolsquizzes.tips" />
			</xsl:element>
			</div>
			
			<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
			<br/>
		</xsl:when>
		<xsl:when test="$searchtype=53">
		</xsl:when>
		<xsl:when test="$searchgroup='creative'">
		<xsl:variable name="url" select="translate($searchtypeurl,'-','')" />
		<div class="PromoIndex" id="promo{$searchtypeurl}">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		To read the most recent works for review, visit the '<a href="{$root}{$url}"><xsl:value-of select="$searchtypename" /></a>' Review Circle.
		</xsl:element>
		</div>
		</xsl:when>
		</xsl:choose>
							
		</xsl:element>
		</tr>
		</xsl:element>
	<!-- end of table -->	
	
	<xsl:if test="not(contains($searchtypeurl,'minicourse'))">
	<!-- SEARCHBOX -->
	<div class="searchback">
	<table cellspacing="0" cellpadding="0" border="0">
	<tr>
	<td rowspan="2" valign="top"><xsl:copy-of select="$icon.browse.brown" /></td>
	<td colspan="4">
	<div class="heading1">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Advanced Search
	</xsl:element>
	</div>
	
	<div class="searchtext">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Search the writing categories by keyword, user name, title or genre (e.g. poetry, scripts, etc.)
	</xsl:element>
	</div>
	</td>
	</tr>
	<tr>
	<td>
	<div class="searchtext">
	<label for="category-search">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">i am searching for:&nbsp;
	</xsl:element>
	</label>
	</div>
	</td>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:call-template name="c_search_dna" />
	</xsl:element>
	</td>
	</tr>
	</table>
	</div>
	</xsl:if>
<br/>
	
	</xsl:otherwise>
	</xsl:choose>
	
	<!-- removed for site pulldown --><!-- </xsl:if> -->
		
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="approved_index">
	Description: Presentation of the individual entries 	for the 
		approved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="approved_index">
		<tr valign="top">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::INDEXENTRY) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_index"/></strong><br/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:template>
	
		<!--
	<xsl:template match="INDEXENTRY" mode="approved_index">
	Description: Presentation of the individual entries 	for the 
		approved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="c_sortindex">
		<tr valign="top">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="position() mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_index"/></strong><br/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION"/>
		</xsl:element>
		</td>
		<td align="right">
		<xsl:variable name="imgcolour">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::INDEXENTRY) mod 2 = 0">editorspick2</xsl:when>
		<xsl:otherwise>editorspick1</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="article_selected">
		<xsl:with-param name="status" select="EXTRAINFO/TYPE/@ID" />
		<xsl:with-param name="img" select="$imgcolour" />
		</xsl:call-template>
		</td>
		</tr>
	</xsl:template>
	
	
	<!--
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
	Description: Presentation of the individual entries 	for the 
		unapproved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
		<tr valign="top">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::INDEXENTRY) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$searchtype=53">
		<td><img src="{$imagesource}learn/thecraft/thumbnails/{EXTRAINFO/DESCRIPTION/TEXTONLY}.jpg" alt="" width="62" height="34" border="0" /></td>
		</xsl:if>
		<xsl:if test="$searchtype=55 or $searchtype=54 or $searchtype=50">
		<td><img src="{$imagesource}learn/minicourse/thumbnails/{EXTRAINFO/DESCRIPTION/TEXTONLY}.jpg" alt="" width="62" height="34" border="0" /></td>
		</xsl:if>
		<xsl:if test="$searchtype=57">
		<td><img src="{$imagesource}learn/toolsandquizzes/thumbnails/{EXTRAINFO/DESCRIPTION/TEXTONLY}.jpg" alt="" width="62" height="34" border="0" /></td>
		</xsl:if>
		<td valign="middle">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_index"/></strong><br/>
		</xsl:element>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION/text()"/>
		</xsl:element>
		<xsl:if test="$searchtype=53">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{EXTRAINFO/DESCRIPTION/TEXTONLY}">text only</a></div>
		</xsl:element>	
		</xsl:if>
		</td>
		<td align="right">
		
		<xsl:variable name="imgcolour">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::INDEXENTRY) mod 2 = 0">editorspick2</xsl:when>
		<xsl:otherwise>editorspick1</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="article_selected">
		<xsl:with-param name="status" select="EXTRAINFO/TYPE/@ID" />
		<xsl:with-param name="img" select="$imgcolour" />
		</xsl:call-template>
		</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	Description: Presentation of the individual entries 	for the 
		submitted articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="submitted_index">
		<tr valign="top">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::INDEXENTRY) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td valign="middle">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_index"/></strong><br/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION"/>
		</xsl:element>
		</td>
		<td align="right">
		<xsl:call-template name="article_selected">
		<xsl:with-param name="status" select="STATUS" />
		</xsl:call-template>
		</td>
		</tr>
	</xsl:template>
<!--
	<xsl:template match="@MORE" mode="more_index">
	Description: Presentation of the 'Next Page' link
	 -->
	<xsl:template match="@MORE" mode="more_index">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/><xsl:copy-of select="$next.arrow" />
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="nomore_index">
	Description: Presentation of the 'No more pages' text
	 -->
	<xsl:template match="@MORE" mode="nomore_index">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="previous_index">
	Description: Presentation of the 'Previous Page' link
	 -->
	<xsl:template match="@SKIP" mode="previous_index">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:copy-of select="$previous.arrow" /> <xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="noprevious_index">
	Description: Presentation of the 'No previous pages' text
	 -->
	<xsl:template match="@SKIP" mode="noprevious_index">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="r_indexstatus">
	Description: Presentation of the index type selection area
	 -->
	<xsl:template match="INDEX" mode="r_indexstatus">
		<xsl:apply-templates select="." mode="t_approvedbox"/>
		<xsl:copy-of select="$m_editedentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_unapprovedbox"/>
		<xsl:value-of select="$m_guideentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submittedbox"/>
		<xsl:value-of select="$m_awaitingappr"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	Description: Attiribute set for the 'Approved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	Description: Attiribute set for the 'Unapproved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	Description: Attiribute set for the 'Submitted' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submit"/>
	Description: Attiribute set for the submit button
	 -->
	<xsl:attribute-set name="iINDEX_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:copy-of select="$m_refresh"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
