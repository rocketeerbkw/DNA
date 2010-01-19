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
	<xsl:template name="INDEX_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">INDEX_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">indexpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
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
		<!-- <xsl:apply-templates select="." mode="c_indexstatus"/> -->
		
		
		<div class="next-back">
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
		<td><div class="navtext"><xsl:apply-templates select="@SKIP" mode="c_index"/></div></td>
		<td></td>
		<td align="right"><div class="navtext"><xsl:apply-templates select="@MORE" mode="c_index"/></div></td>
		</tr>
		</table>
		</div>
		
		<div class="browse-folder-d">
		<div class="browse-folder">
		<strong>
		<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
		<xsl:choose>
			<xsl:when test="/H2G2/INDEX/@APPROVED">editorial</xsl:when>
			<xsl:when test="/H2G2/INDEX/@UNAPPROVED">member</xsl:when>
			<xsl:when test="/H2G2/INDEX/@SUBMITTED">member</xsl:when>
		</xsl:choose>
		
		<xsl:if test="SEARCHTYPES">
		<xsl:text>  </xsl:text>
		<xsl:variable name="num" select="SEARCHTYPES/TYPE"/>
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@label" />'s
		</xsl:if>
		
		</xsl:element>
		</strong>
		<br />
		</div></div>	
		
		<!-- browse letter -->
		<div>
		<xsl:choose>
			<xsl:when test="/H2G2/INDEX/@APPROVED"><xsl:attribute name="class">browse-folder-editor</xsl:attribute></xsl:when>
			<xsl:when test="/H2G2/INDEX/@UNAPPROVED"><xsl:attribute name="class">browse-folder-member</xsl:attribute></xsl:when>
			<xsl:when test="/H2G2/INDEX/@SUBMITTED"><xsl:attribute name="class">browse-folder-member</xsl:attribute></xsl:when>
		</xsl:choose>
		<div class="browse-folder">
		<strong><xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:value-of select="/H2G2/INDEX/@LETTER" />
		</xsl:element></strong>
		</div>
		</div>
		
		<div class="browse-indent">
		<xsl:choose>
		<xsl:when test="@UNAPPROVED and not(SEARCHTYPES)">
		<xsl:apply-templates select="INDEXENTRY[not(EXTRAINFO/TYPE/@ID=1)and not(EXTRAINFO/TYPE/@ID=3001)]" mode="c_index"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="INDEXENTRY" mode="c_index"/>
		</xsl:otherwise>
		</xsl:choose>
		</div>
	
		<div class="next-back">
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
		<td><div class="navtext"><xsl:apply-templates select="@SKIP" mode="c_index"/></div></td>
		<td></td>
		<td align="right"><div class="navtext"><xsl:apply-templates select="@MORE" mode="c_index"/></div></td>
		</tr>
		</table>
		</div>
		
		
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="approved_index">
	Description: Presentation of the individual entries 	for the 
		approved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="approved_index">
	<!-- <xsl:apply-templates select="H2G2ID" mode="t_index"/> -->
	<!-- EDITOR REVIEWS -->		
	<div class="browse-page-editor">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="SUBJECT" mode="t_index"/><xsl:text>  </xsl:text> 
	<xsl:call-template name="article_subtype">
	<xsl:with-param name="pagetype">nouser</xsl:with-param>
	</xsl:call-template>
	</xsl:element></div>

	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
	Description: Presentation of the individual entries 	for the 
		unapproved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
	<!-- <xsl:apply-templates select="H2G2ID" mode="t_index"/> -->
    <!-- MEMBER REVIEWS -->
	<div class="browse-page-member">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="SUBJECT" mode="t_index"/><xsl:text>  </xsl:text> 
	<xsl:call-template name="article_subtype">
	<xsl:with-param name="pagetype">nouser</xsl:with-param>
	<xsl:with-param name="searchtypenum" select="/H2G2/INDEX/SEARCHTYPES/TYPE"/>
	</xsl:call-template>
	</xsl:element></div>
	
	</xsl:template>
	
	<!--
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	Description: Presentation of the individual entries 	for the 
		submitted articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	<!-- <xsl:apply-templates select="H2G2ID" mode="t_index"/> -->
	<!-- MEMBER REVIEWS -->
	<div><xsl:apply-templates select="SUBJECT" mode="t_index"/></div>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="more_index">
	Description: Presentation of the 'Next Page' link
	 -->
	<xsl:template match="@MORE" mode="more_index">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-imports/>&nbsp;<xsl:copy-of select="$arrow.next" />
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="nomore_index">
	Description: Presentation of the 'No more pages' text
	 -->
	<xsl:template match="@MORE" mode="nomore_index">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="previous_index">
	Description: Presentation of the 'Previous Page' link
	 -->
	<xsl:template match="@SKIP" mode="previous_index">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="noprevious_index">
	Description: Presentation of the 'No previous pages' text
	 -->
	<xsl:template match="@SKIP" mode="noprevious_index">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
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
