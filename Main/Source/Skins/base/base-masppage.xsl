<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<!--
	<xsl:template name="MEDIAASSETSEARCHPHRASE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MEDIAASSETSEARCHPHRASE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
			<xsl:text>Search for your asset</xsl:text>	
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="c_search">
		<form method="POST" action="{$root}MediaAssetSearchPhrase">
		<xsl:if test="/H2G2/PREVIEWMODE &gt; 0"><input type="hidden" name="_previewmode" value="1"/></xsl:if>
		<input type="hidden" name="contenttype" value="{ASSETSEARCH/@CONTENTTYPE}"/>
			<xsl:apply-templates select="." mode="r_search"/>
		</form>
	</xsl:template>
	
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="t_searchbox">
		<input type="text" name="phrase" value="" xsl:use-attribute-sets="iMEDIAASSETSEARCHPHRASE_t_searchbox">
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
	
	<xsl:attribute-set name="iMEDIAASSETSEARCHPHRASE_t_searchbox">
		<xsl:attribute name="size">30</xsl:attribute>
	</xsl:attribute-set>
	
  <xsl:attribute-set name="mARTICLESEARCH_link_nextpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_linkpreviouspage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_lastpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_firstpage"/>
		
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="c_masp">
		<xsl:apply-templates select="." mode="r_masp"/>
	</xsl:template>
	
	
	<xsl:template match="ASSETSEARCH" mode="c_masp">
		<xsl:apply-templates select="." mode="r_masp"/>
	</xsl:template>
	
	<xsl:template match="ASSET" mode="c_masp">
		<xsl:apply-templates select="." mode="r_masp"/>
	</xsl:template>
	
	<xsl:template match="@ASSETID" mode="c_thumb">
		<xsl:apply-templates select="." mode="r_thumb"/>
	</xsl:template>

	<xsl:variable name="masptags">
		<xsl:for-each select="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/PHRASE">
			<xsl:value-of select="concat('&amp;s_tag', '=', TERM)"></xsl:value-of>
		</xsl:for-each>
	</xsl:variable>
		
	<xsl:template match="@ASSETID" mode="r_thumb">
		<xsl:variable name="maspmediapath" select="concat($assetlibrary, ../FTPPATH)"/>
		
		<xsl:variable name="suffix">
		<xsl:choose>
			<xsl:when test="../MIMETYPE='image/jpeg'">jpg</xsl:when>
			<xsl:when test="../MIMETYPE='image/jpg'">jpg</xsl:when>
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
		<a href="{$root}MediaAsset?id={.}{$masptags}" ><img src="{$maspmediapath}/{.}_thumb.{$suffix}" alt="{../SUBJECT}" xsl:use-attribute-sets="imgaASSETID_r_thumb" border="0" /></a>
	</xsl:template>		
	

	
	<xsl:attribute-set name="imgaASSETID_r_thumb">
	</xsl:attribute-set>
	
	<xsl:template match="@ASSETID" mode="c_viewmedia">
		<xsl:apply-templates select="." mode="r_viewmedia"/>
	</xsl:template>
	
	<xsl:template match="@ASSETID" mode="r_viewmedia">
		<xsl:variable name="suffix">
		<xsl:choose>
			<xsl:when test="../MIMETYPE='image/jpeg'">jpg</xsl:when>
			<xsl:when test="../MIMETYPE='image/pjpeg'">jpg</xsl:when>
			<xsl:when test="../MIMETYPE='image/gif'">gif</xsl:when>
		</xsl:choose>
		</xsl:variable>
		<a href="{$root}MediaAsset?id={.}{$masptags}" xsl:use-attribute-sets="maASSETID_r_viewmedia"><xsl:copy-of select="$m_viewmedia"/></a>
	</xsl:template>	
	
	<xsl:variable name="m_viewmedia">View media</xsl:variable>	
	<xsl:attribute-set name="maASSETID_r_viewmedia"></xsl:attribute-set>
	
	
	<xsl:template match="USER" mode="c_assetauthor">
		<xsl:apply-templates select="." mode="r_assetauthor"/>
	</xsl:template>
	
	<xsl:template match="USER" mode="r_assetauthor">
		<a href="{$root}u{USERID}" xsl:use-attribute-sets="mUSER_r_assetauthor"><xsl:apply-templates select="." mode="username"/></a>
	</xsl:template>	

	<xsl:attribute-set name="mUSER_r_assetauthor"></xsl:attribute-set>
			
	<xsl:template match="PHRASES" mode="c_maspsearch">
		<xsl:apply-templates select="." mode="r_maspsearch"/>
	</xsl:template>
	
	<xsl:template match="PHRASE" mode="c_maspsearch">
		<xsl:apply-templates select="." mode="r_maspsearch"/>
	</xsl:template>
	
	<xsl:template match="PHRASE" mode="r_maspsearch">
		<a href="{$root}MediaAssetSearchPhrase?contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}&amp;phrase={TERM}" xsl:use-attribute-sets="maPHRASE_r_maspsearch">
			<xsl:value-of select="TERM"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="maPHRASE_r_maspsearch"></xsl:attribute-set>	
	
	<!--
	<xsl:template match="HOT-PHRASES" mode="c_masp">
	Author:		Emile Chasseaud
	Context:      /H2G2
	Purpose:	 Creates the hot phrases object 
	-->
	<xsl:template match="HOT-PHRASES" mode="c_masp">
		<xsl:apply-templates select="." mode="r_masp"/>
	</xsl:template>
	<!--
	<xsl:template match="HOT-PHRASE" mode="c_masp">
	Author:		Emile Chasseaud
	Context:       /H2G2/HOTPHRASES
	Purpose:	 Creates the hot phrase object 
	-->
	<xsl:template match="HOT-PHRASE" mode="c_masp">
		<xsl:apply-templates select="." mode="r_masp"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="mHOT-PHRASE_r_masp"/>
	Author:		Emile Chasseaud
	Purpose:	 Creates the link attribute set
	-->
	<xsl:attribute-set name="mHOT-PHRASE_r_masp"/>
	<!--
	<xsl:template match="HOT-PHRASE" mode="r_masp">
	Author:		Emile Chasseaud
	Context:      /H2G2/HOTPHRASES
	Purpose:	 Creates the hot phrase link
	-->	
	<xsl:template match="HOT-PHRASE" mode="r_masp">
	<a href="{$root}MediaAssetSearchPhrase?contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}&amp;phrase={TERM}" xsl:use-attribute-sets="mHOT-PHRASE_r_masp"><xsl:value-of select="TERM"/></a>
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							NAVIGATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

<xsl:template match="ASSETSEARCH" mode="c_mediablocks">
	<xsl:apply-templates select="." mode="r_mediablocks"/>
</xsl:template>	

<xsl:template match="ASSETSEARCH" mode="c_mediablockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$masp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblockmasp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTAL) and ($skip &lt; $masp_upperrange)">
			<xsl:apply-templates select="." mode="c_mediablockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="displayblocktp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:variable name="maspsearchphrase">
		<xsl:for-each select="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/PHRASE">
			<xsl:text>&amp;phrase=</xsl:text><xsl:value-of select="TERM"/>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="ASSETSEARCH" mode="displayblockmasp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_mediablockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_mediaontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}MediaAssetSearchPhrase?skip={$skip}&amp;show={@COUNT}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_on_mediablockdisplay">
									<xsl:call-template name="t_mediaontabcontent">
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
				<xsl:apply-templates select="." mode="off_mediablockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}MediaAssetSearchPhrase?skip={$skip}&amp;show={@COUNT}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_off_mediablockdisplay">
							<xsl:call-template name="t_mediaofftabcontent">
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
	<xsl:variable name="maspsplit" select="10"/>
	<!--tp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="masp_lowerrange">
				<xsl:value-of select="floor(/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@SKIPTO div ($maspsplit * /H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@COUNT)) * ($maspsplit * /H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@COUNT)"/>
	</xsl:param>
	<!--tp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="masp_upperrange">
		<xsl:value-of select="$masp_lowerrange + (($maspsplit - 1) * /H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@COUNT)"/>
	</xsl:param>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_mediaofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_mediaontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<xsl:variable name="m_mediapostblockprev">prev</xsl:variable>
	<xsl:variable name="m_mediapostblocknext">next</xsl:variable>
	<xsl:attribute-set name="mASSETSEARCH_on_mediablockdisplay"/>
	<xsl:attribute-set name="mASSETSEARCH_off_mediablockdisplay"/>
	<xsl:attribute-set name="mASSETSEARCH_r_mediablockdisplayprev"/>
	<xsl:attribute-set name="mASSETSEARCH_r_mediablockdisplaynext"/>
	
<xsl:template match="ASSETSEARCH" mode="c_previouspage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ASSETSEARCH" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="(@SKIPTO + @COUNT) &lt; @TOTAL">
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ASSETSEARCH" mode="link_previouspage">
		<a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspagemasp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ASSETSEARCH" mode="link_nextpage">
	
		<a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpagemasp"/></a><xsl:text> </xsl:text>
	</xsl:template>	
	<xsl:variable name="m_nextpagemasp">Next</xsl:variable>
	<xsl:variable name="m_previouspagemasp">Previous</xsl:variable>
	<xsl:variable name="m_nopreviouspagemasp">No next</xsl:variable>
	<xsl:variable name="m_nonextpagemasp">No previous</xsl:variable>	
	
	<xsl:template match="ASSETSEARCH" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspagemasp"/>
	</xsl:template>
	<xsl:template match="ASSETSEARCH" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpagemasp"/>
	</xsl:template>

	<xsl:template match="ASSETSEARCH" mode="c_lastpage">
		<xsl:choose>
			<xsl:when test="(@SKIPTO + @COUNT) &lt; @TOTAL">
				<xsl:apply-templates select="." mode="link_lastpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_lastpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ASSETSEARCH" mode="c_firstpage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_firstpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_firstpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		

	<xsl:template match="ASSETSEARCH" mode="link_firstpage">
		<a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip=0&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpagemasp"/></a><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ASSETSEARCH" mode="link_lastpage">
		<a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip={number(@TOTAL) - number(@COUNT)}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}" xsl:use-attribute-sets="mASSETSEARCH_link_lastpage">
			<xsl:copy-of select="$m_lastpagemasp"/></a><xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="ASSETSEARCH" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpagemasp"/>
	</xsl:template>

	<xsl:template match="ASSETSEARCH" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpagemasp"/>
	</xsl:template>

	<xsl:variable name="m_firstpagemasp">First</xsl:variable>
	<xsl:variable name="m_lastpagemasp">Last</xsl:variable>
	<xsl:variable name="m_nofirstpagemasp">No first</xsl:variable>
	<xsl:variable name="m_nolastpagemasp">No last</xsl:variable>	
					
</xsl:stylesheet>
