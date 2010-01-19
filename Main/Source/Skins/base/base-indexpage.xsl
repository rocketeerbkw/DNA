<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="INFO_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="INDEX_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_indextitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="INFO_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="INDEX_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_indextitle"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="c_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Calls the container for the INDEX object
	-->
	<xsl:template match="INDEX" mode="c_index">
		<xsl:apply-templates select="." mode="r_index"/>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="c_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Selects the correct type of INDEX to be dispalyed
	-->
	<xsl:template match="INDEXENTRY" mode="c_index">
		<xsl:choose>
			<xsl:when test="STATUS='APPROVED'">
				<xsl:apply-templates select="." mode="approved_index"/>
			</xsl:when>
			<xsl:when test="STATUS='UNAPPROVED'">
				<xsl:apply-templates select="." mode="unapproved_index"/>
			</xsl:when>
			<xsl:when test="STATUS='SUBMITTED'">
				<xsl:apply-templates select="." mode="submitted_index"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="t_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/INDEXENTRY/H2G2ID
	Purpose:	 Displays the H2G2ID as text
	-->
	<xsl:template match="H2G2ID" mode="t_index">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/INDEXENTRY/SUBJECT
	Purpose:	 Displays the SUBJECT as a link
	-->
	<xsl:template match="SUBJECT" mode="t_index">
		<a href="{$root}A{../H2G2ID}" xsl:use-attribute-sets="mSUBJECT_t_index">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="c_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@MORE
	Purpose:	 Chosses whether the next link is a link or explanatory text
	-->
	<xsl:template match="@MORE" mode="c_index">
		<xsl:choose>
			<xsl:when test=". &gt; 0">
				<xsl:apply-templates select="." mode="more_index"/>
			</xsl:when>
			<xsl:when test=". = 0">
				<xsl:apply-templates select="." mode="nomore_index"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="c_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@SKIP
	Purpose:	 Chosses whether the previous link is a link or explanatory text
	-->
	<xsl:template match="@SKIP" mode="c_index">
		<xsl:choose>
			<xsl:when test=". &gt; 0">
				<xsl:apply-templates select="." mode="previous_index"/>
			</xsl:when>
			<xsl:when test=". = 0">
				<xsl:apply-templates select="." mode="noprevious_index"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="more_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@MORE
	Purpose:	 Creates the next link
	-->
	<xsl:template match="@MORE" mode="more_index">
		<xsl:variable name="showtype">
			<xsl:if test="../@APPROVED">&amp;official=on</xsl:if>
			<xsl:if test="../@UNAPPROVED">&amp;user=on</xsl:if>
			<xsl:if test="../@SUBMITTED">&amp;submitted=on</xsl:if>
		</xsl:variable>
		<a href="{$root}Index?let={../@LETTER}{$showtype}&amp;show={../@COUNT}&amp;skip={number(../@SKIP) + number(../@COUNT)}">
			<xsl:copy-of select="$m_moreindexentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="nomore_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@MORE
	Purpose:	 Creates the no next link explanatory text
	-->
	<xsl:template match="@MORE" mode="nomore_index">
		<xsl:value-of select="$m_nomoreentries"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="previous_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@SKIP
	Purpose:	 Creates the previous link
	-->
	<xsl:template match="@SKIP" mode="previous_index">
		<xsl:variable name="showtype">
			<xsl:if test="../@APPROVED">&amp;official=on</xsl:if>
			<xsl:if test="../@UNAPPROVED">&amp;user=on</xsl:if>
			<xsl:if test="../@SUBMITTED">&amp;submitted=on</xsl:if>
		</xsl:variable>
		<a href="{$root}Index?let={../@LETTER}{$showtype}&amp;show={../@COUNT}&amp;skip={number(../@SKIP) - number(../@COUNT)}">
			<xsl:copy-of select="$m_previousindexentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="noprevious_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX/@SKIP
	Purpose:	 Creates the no previous link explanatory text
	-->
	<xsl:template match="@SKIP" mode="noprevious_index">
		<xsl:value-of select="$m_nopreventries"/>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="c_indexstatus">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Creates the form element to change the index type
	-->
	<xsl:template match="INDEX" mode="c_indexstatus">
		<form method="get" action="{$root}Index" xsl:use-attribute-sets="fINDEX_c_indexstatus">
			<input type="hidden" name="let" value="{@LETTER}"/>
			<xsl:apply-templates select="." mode="r_indexstatus"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="t_approvedbox">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Creates the input element for the approved checkbox
	-->
	<xsl:template match="INDEX" mode="t_approvedbox">
		<input type="checkbox" name="official" xsl:use-attribute-sets="iINDEX_t_approvedbox">
			<xsl:if test="@APPROVED">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="t_unapprovedbox">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Creates the input element for the unapproved checkbox
	-->
	<xsl:template match="INDEX" mode="t_unapprovedbox">
		<input type="checkbox" name="user" xsl:use-attribute-sets="iINDEX_t_unapprovedbox">
			<xsl:if test="@UNAPPROVED">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="t_submittedbox">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Creates the input element for the submitted checkbox
	-->
	<xsl:template match="INDEX" mode="t_submittedbox">
		<input type="checkbox" name="submitted" xsl:use-attribute-sets="iINDEX_t_submittedbox">
			<xsl:if test="@SUBMITTED">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="t_submit">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Creates the input element for the submit button
	-->
	<xsl:template match="INDEX" mode="t_submit">
		<input name="submit" xsl:use-attribute-sets="iINDEX_t_submit"/>
	</xsl:template>
	
	<xsl:attribute-set name="fINDEX_c_indexstatus"/>
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	<xsl:attribute-set name="iINDEX_t_submit"/>
	<xsl:template match="INDEX" mode="c_indexblocks">
		
		<xsl:apply-templates select="." mode="r_indexblocks"/>
	</xsl:template>
	<xsl:template match="INDEX" mode="c_blockdisplay">
		<xsl:param name="skip" select="$index_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblock_index">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTAL) and ($skip &lt; $index_upperrange)">
			<xsl:apply-templates select="." mode="c_blockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="mINDEX_r_blockdisplaynext"/>
	<xsl:attribute-set name="mINDEX_r_blockdisplayprev"/>
	<xsl:variable name="m_indexblockprev">previous</xsl:variable>
	<xsl:variable name="m_indexblocknext">next</xsl:variable>
	<!-- indexsplit is the numbers of tabs that appear on one page-->
	<xsl:attribute-set name="mINDEX_on_blockdisplay"/>
	<xsl:attribute-set name="mINDEX_off_blockdisplay"/>
	<xsl:variable name="indexsplit" select="8"/>
	<!--mp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="index_lowerrange" select="floor(/H2G2/INDEX/@SKIP div ($indexsplit * /H2G2/INDEX/@COUNT)) * ($indexsplit * /H2G2/INDEX/@COUNT)"/>
	<!--mp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="index_upperrange" select="$index_lowerrange + (($indexsplit - 1) * /H2G2/INDEX/@COUNT)"/>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblockmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:variable name="i_showtype">
			<xsl:if test="/H2G2/INDEX/@APPROVED">&amp;official=on</xsl:if>
			<xsl:if test="/H2G2/INDEX/@UNAPPROVED">&amp;user=on</xsl:if>
			<xsl:if test="/H2G2/INDEX/@SUBMITTED">&amp;submitted=on</xsl:if>
		</xsl:variable>
		<xsl:variable name="i_letter">
			<xsl:choose>
				<xsl:when test="/H2G2/INDEX/@LETTER=''">all</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/INDEX/@LETTER"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="i_group">
			<xsl:if test="/H2G2/INDEX/@GROUP">
				<xsl:value-of select="concat('&amp;group=', /H2G2/INDEX/@GROUP)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="i_orderby">
			<xsl:if test="/H2G2/INDEX/@ORDERBY">
				<xsl:value-of select="concat('&amp;orderby=', /H2G2/INDEX/@ORDERBY)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="i_type">
			<xsl:if test="/H2G2/INDEX/SEARCHTYPES/TYPE">
				<xsl:value-of select="concat('&amp;type=', /H2G2/INDEX/SEARCHTYPES/TYPE)"/>
			</xsl:if>
		</xsl:variable>
	<xsl:template match="INDEX" mode="displayblock_index">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		
		<xsl:choose>
			<xsl:when test="@SKIP = $skip">
				<xsl:apply-templates select="." mode="on_blockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}index?let={$i_letter}{$i_group}{$i_showtype}{$i_orderby}{$i_type}&amp;skip={$skip}" xsl:use-attribute-sets="mINDEX_on_blockdisplay">
							<xsl:call-template name="t_ontabindex">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div /H2G2/INDEX/@COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_blockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}index?let={$i_letter}{$i_group}{$i_showtype}{$i_orderby}{$i_type}&amp;skip={$skip}" xsl:use-attribute-sets="mINDEX_off_blockdisplay">
							<xsl:call-template name="t_offtabindex">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div /H2G2/INDEX/@COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_offtabindex">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_ontabindex">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
<xsl:template match="INDEX" mode="c_indexblockprev">
		<xsl:if test="($index_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_indexblockprev"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="INDEX" mode="r_indexblockprev">
		<a href="{$root}index?let={$i_letter}{$i_group}{$i_showtype}{$i_orderby}{$i_type}&amp;skip={$index_lowerrange - @COUNT}" xsl:use-attribute-sets="mINDEX_r_blockdisplayprev">
			<xsl:copy-of select="$m_indexblockprev"/>
			
			
		</a>
	</xsl:template>
	<xsl:template match="INDEX" mode="c_indexblocknext">
		<xsl:if test="(($index_upperrange + @COUNT) &lt; @TOTAL)">
			<xsl:apply-templates select="." mode="r_indexblocknext"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="INDEX" mode="r_indexblocknext">
		<a href="{$root}index?let={$i_letter}{$i_group}{$i_showtype}{$i_orderby}{$i_type}&amp;skip={$index_upperrange + @COUNT}" xsl:use-attribute-sets="mINDEX_r_blockdisplaynext">
			<xsl:copy-of select="$m_indexblocknext"/>
			
		</a>
	</xsl:template>

</xsl:stylesheet>
