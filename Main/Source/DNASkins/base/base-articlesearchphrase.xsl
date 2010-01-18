<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:template name="ARTICLESEARCHPHRASE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
			<xsl:text>Search for articles</xsl:text>	
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCHPHRASE" mode="c_articlesearch">
		<form method="POST" action="{$root}ArticleSearchPhrase">
		<xsl:if test="/H2G2/PREVIEWMODE &gt; 0"><input type="hidden" name="_previewmode" value="1"/></xsl:if>
		<input type="hidden" name="contenttype" value="{ARTICLESEARCH/@CONTENTTYPE}"/>
			<xsl:apply-templates select="." mode="r_search"/>
		</form>
	</xsl:template>

	<xsl:template match="ARTICLESEARCHPHRASE" mode="t_articlesearchbox">
		<input type="text" name="phrase" value="" xsl:use-attribute-sets="iARTICLESEARCHPHRASE_t_articlesearchbox">
		<xsl:if test="PHRASES/PHRASE">
			<xsl:attribute name="value">
				<xsl:for-each select="PHRASES/PHRASE">
					<xsl:value-of select="TERM"/>
					<xsl:if test="not(position() = last())">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</xsl:if>
		</input>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCHPHRASE" mode="c_articlesearchresults">
		<xsl:apply-templates select="." mode="r_articlesearchresults"/>
	</xsl:template>
						
	<xsl:template match="ARTICLESEARCH" mode="c_articlesearchresults">
		<xsl:apply-templates select="." mode="r_articlesearchresults"/>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="c_articlesearchresults">
		<xsl:apply-templates select="." mode="r_articlesearchresults"/>
	</xsl:template>

	<xsl:template match="MEDIAASSET/@MEDIAASSETID" mode="c_articlethumb">
		<xsl:apply-templates select="." mode="r_articlethumb"/>
	</xsl:template>
	
	<xsl:template match="MEDIAASSET/@MEDIAASSETID" mode="r_articlethumb">
		<xsl:variable name="artspmediapath" select="concat($assetlibrary, ../FTPPATH)"/>
		
		<xsl:variable name="suffix">
		<xsl:choose>
			<xsl:when test="../MIMETYPE='image/jpeg'">jpg</xsl:when>
			<xsl:when test="../MIMETYPE='image/pjpeg'">jpg</xsl:when>
			<xsl:when test="../MIMETYPE='image/gif'">gif</xsl:when>
			<xsl:when test="../MIMETYPE='avi'">avi</xsl:when>
			<xsl:when test="../MIMETYPE='mp1'">mp1</xsl:when>
			<xsl:when test="../MIMETYPE='mp2'">mp2</xsl:when>
			<xsl:when test="../MIMETYPE='mp3'">mp3</xsl:when>				
			<xsl:when test="../MIMETYPE='mov'">mov</xsl:when>
			<xsl:when test="../MIMETYPE='wav'">wav</xsl:when>
			<xsl:when test="../MIMETYPE='wmv'">wmv</xsl:when>				
		</xsl:choose>
		</xsl:variable>
		<img src="{$artspmediapath}/{.}_thumb.{$suffix}" alt="{../../SUBJECT}" xsl:use-attribute-sets="imgaMEDIAASSETID_r_articlethumb" border="0" />
	</xsl:template>	
	
	<xsl:attribute-set name="imgaMEDIAASSETID_r_articlethumb">
	</xsl:attribute-set>
  <xsl:attribute-set name="mARTICLESEARCH_link_nextpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_previouspage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_firstpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_lastpage"/>
		
	<xsl:template match="ARTICLEHOT-PHRASES" mode="c_articlehotphrases">
		<xsl:apply-templates select="." mode="r_articlehotphrases"/>
	</xsl:template>

	<xsl:template match="ARTICLEHOT-PHRASE" mode="c_articlehotphrases">
		<xsl:apply-templates select="." mode="r_articlehotphrases"/>
	</xsl:template>

	<xsl:attribute-set name="mARTICLEHOT-PHRASE_r_articlehotphrases"/>

	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_articlehotphrases">
	<a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}" xsl:use-attribute-sets="mARTICLEHOT-PHRASE_r_articlehotphrases"><xsl:value-of select="TERM"/></a>
	</xsl:template>			
<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							NAVIGATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

<xsl:template match="ARTICLESEARCH" mode="c_articleblocks">
	<xsl:apply-templates select="." mode="r_articleblocks"/>
</xsl:template>	

<xsl:template match="ARTICLESEARCH" mode="c_articleblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$artsp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblockartsp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTAL) and ($skip &lt; $artsp_upperrange)">
			<xsl:apply-templates select="." mode="c_articleblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="artspsearchphrase">
		<xsl:for-each select="/H2G2/ARTICLESEARCHPHRASE/PHRASES/PHRASE">
			<xsl:text>&amp;phrase=</xsl:text><xsl:value-of select="TERM"/>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="ARTICLESEARCH" mode="displayblockartsp">
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
								<a href="{$root}ArticleSearchPhrase?skip={$skip}&amp;show={@COUNT}{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_on_articleblockdisplay">
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
						<a href="{$root}ArticleSearchPhrase?skip={$skip}&amp;show={@COUNT}{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_off_articleblockdisplay">
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
	<!-- tpsplit is the numbers of tabs that appear on one page-->
	<xsl:variable name="artspsplit" select="10"/>
	<!--tp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="artsp_lowerrange">
				<xsl:value-of select="floor(/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@SKIPTO div ($artspsplit * /H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@COUNT)) * ($artspsplit * /H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@COUNT)"/>
	</xsl:param>
	<!--tp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="artsp_upperrange">
		<xsl:value-of select="$artsp_lowerrange + (($artspsplit - 1) * /H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@COUNT)"/>
	</xsl:param>
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
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_articleontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<xsl:variable name="m_articlepostblockprev">prev</xsl:variable>
	<xsl:variable name="m_articlepostblocknext">next</xsl:variable>
	<xsl:attribute-set name="mARTICLESEARCH_on_articleblockdisplay"/>
	<xsl:attribute-set name="mARTICLESEARCH_off_articleblockdisplay"/>
	<xsl:attribute-set name="mARTICLESEARCH_r_articleblockdisplayprev"/>
	<xsl:attribute-set name="mARTICLESEARCH_r_articleblockdisplaynext"/>
	
<xsl:template match="ARTICLESEARCH" mode="c_previouspage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>
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
	
	<xsl:template match="ARTICLESEARCH" mode="link_previouspage">
		<a href="{$root}ArticleSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_nextpage">
	
		<a href="{$root}ArticleSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>	
	<xsl:variable name="m_nextpageartsp">Next</xsl:variable>
	<xsl:variable name="m_previouspageartsp">Previous</xsl:variable>
	<xsl:variable name="m_nopreviouspageartsp">No next </xsl:variable>
	<xsl:variable name="m_nonextpageartsp">No previous </xsl:variable>	
	
	<xsl:template match="ARTICLESEARCH" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspageartsp"/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpageartsp"/>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="c_lastpage">
		<xsl:choose>
			<xsl:when test="(@SKIPTO + @COUNT) &lt; @TOTAL">
				<xsl:apply-templates select="." mode="link_lastpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_lastpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH" mode="c_firstpage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_firstpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_firstpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		

	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<a href="{$root}ArticleSearchPhrase?show={@COUNT}&amp;skip=0{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<a href="{$root}ArticleSearchPhrase?show={@COUNT}&amp;skip={number(@TOTAL) - number(@COUNT)}{$artspsearchphrase}" xsl:use-attribute-sets="mARTICLESEARCH_link_lastpage">
			<xsl:copy-of select="$m_lastpageartsp"/></a><xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpageartsp"/>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpageartsp"/>
	</xsl:template>

	<xsl:variable name="m_firstpageartsp">First</xsl:variable>
	<xsl:variable name="m_lastpageartsp">Last</xsl:variable>
	<xsl:variable name="m_nofirstpageartsp">No first</xsl:variable>
	<xsl:variable name="m_nolastpageartsp">No last</xsl:variable>	
							
</xsl:stylesheet>
