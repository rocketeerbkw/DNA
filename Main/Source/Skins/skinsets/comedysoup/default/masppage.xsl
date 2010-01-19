<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-masppage.xsl"/>
	
	<!-- 
	<xsl:attribute-set name="iMEDIAASSETSEARCHPHRASE_t_searchbox"/>
	Use: Search for an asset search box
	-->
	<xsl:attribute-set name="iMEDIAASSETSEARCHPHRASE_t_searchbox">
		<xsl:attribute name="id">soupSearch</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:attribute-set name="imgaASSETID_r_thumb"/>
	Use: thumbnail on the search results page
	-->
	<xsl:attribute-set name="imgaASSETID_r_thumb"/>
	<xsl:attribute-set name="mASSETSEARCH_link_previouspage"/>
	<xsl:attribute-set name="mASSETSEARCH_link_nextpage"/>
	<xsl:attribute-set name="mASSETSEARCH_link_firstpage"/>
	<xsl:attribute-set name="mASSETSEARCH_link_lastpage"/>
	
	<!-- asset library tabs-->
	<xsl:template name="search_by_asset_type">
		<xsl:param name="type"/>
			<a href="{$root}MediaAssetSearchPhrase?contenttype={$type}">
			<xsl:if test="$type=/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE or $type=/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE">
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
				<xsl:choose>
					<xsl:when test="$type=1">
						<xsl:text>Image assets</xsl:text>
					</xsl:when>
					<xsl:when test="$type=2">
						<xsl:text>Audio assets</xsl:text>
					</xsl:when>
					<xsl:when test="$type=3">
						<xsl:text>Video assets</xsl:text>
					</xsl:when>
					<xsl:otherwise>All assets</xsl:otherwise>
				</xsl:choose>
			</a>
	</xsl:template>
	
	<xsl:variable name="contenttypetext">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=1">
				<xsl:text>image</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=2">
				<xsl:text>audio</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=3">
				<xsl:text>video</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MEDIAASSETSEARCHPHRASE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">MEDIAASSETSEARCHPHRASE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">maspage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<!-- Page Title -->
		<h1>
			<xsl:choose>
				<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@COUNT=0">
				<!-- INDEX PAGE -->
					<xsl:choose>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=3">
							<img src="{$imagesource}/h1_videoassetsyoucanuse.gif" alt="video assets you can use (use these to make your own comedy)" width="545" height="26" />
						</xsl:when>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=2">
							<img src="{$imagesource}/h1_audioassetsyoucanuse.gif" alt="audio assets you can use (use these to make your own comedy)" width="553" height="26" />
						</xsl:when>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=1">
							<img src="{$imagesource}/h1_imageassetsyoucanuse.gif" alt="image assets you can use (use these to make your own comedy)" width="552" height="26" />
						</xsl:when>
						<xsl:otherwise>
						assets you can use <!-- todo: need as a graphic -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- RESULTS PAGE PAGE -->
					<xsl:choose>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=3">
							<img src="{$imagesource}/h1_videoassetsyoucanuseresults.gif" alt="video assets you can use: results" width="390" height="26" />
						</xsl:when>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=2">
							<img src="{$imagesource}/h1_audioassetsyoucanuseresults.gif" alt="audio assets you can use: results" width="392" height="26" />
						</xsl:when>
						<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=1">
							<img src="{$imagesource}/h1_imageassetsyoucanuseresults.gif" alt="image assets you can use: results" width="399" height="26" />
						</xsl:when>
						<xsl:otherwise>
						assets you can use:results <!-- todo: need as a graphic -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</h1>
		
		<!-- columns -->
		<div class="assets">
		<div class="col1">
			<div class="margins">
				<!-- MAIN CONTENT COLUMN -->
				
				<!-- 3 column asset nav component -->
				<ul class="assetNav3Col">
					<li>
						<xsl:call-template name="search_by_asset_type">
							<xsl:with-param name="type" select="3"/>
						</xsl:call-template>
					</li>
					<li>
						<xsl:call-template name="search_by_asset_type">
							<xsl:with-param name="type" select="1"/>
						</xsl:call-template>
					</li>
					<li class="last">
						<xsl:call-template name="search_by_asset_type">
							<xsl:with-param name="type" select="2"/>
						</xsl:call-template>
					</li>
					<div class="clr"></div>
				</ul>
				<!--// 3 column asset nav component -->
				
				
				<xsl:apply-templates select="/H2G2/MEDIAASSETSEARCHPHRASE" mode="c_search"/>
				
				<xsl:choose>
					<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@COUNT=0">
						<!-- INDEX PAGE -->
						<br />
						<div class="hozDots"></div>
						<h2>Current popular key phrases for <xsl:value-of select="$contenttypetext"/> assets</h2>
						<div class="dynamicKeyPhraseBox">
							<xsl:apply-templates select="/H2G2/HOT-PHRASES" mode="c_masp"/>
						</div>
						
						<xsl:apply-templates select="/H2G2/MEDIAASSETSEARCHPHRASE" mode="c_masp"/>
					
					</xsl:when>
					<xsl:otherwise>
						<!-- RESULTS PAGE PAGE -->
						<xsl:apply-templates select="/H2G2/MEDIAASSETSEARCHPHRASE" mode="c_masp"/>
					</xsl:otherwise>
				</xsl:choose>
		
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
			<!-- PROMO COLUMN -->
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
				
				<xsl:choose>
					<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@COUNT=0">
					<!--
					<div class="contentBlock">
						<h2>Add to the asset library</h2>
						<p>You can add your own <xsl:value-of select="$contenttypetext"/> to the asset library for other people to use. <a href="insert_url">Find out</a> how to do it.</p>
					</div>
					-->
					</xsl:when>
					<xsl:otherwise>
						<div class="contentBlock">
							<h2>Key phrases related to 
								'<xsl:for-each select="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/PHRASE">
									<span class="orange"><xsl:value-of select="NAME"/></span><xsl:if test="position() != last()">, </xsl:if>
								</xsl:for-each>':
							</h2>
							<p>
							<xsl:choose>
								<xsl:when test="/H2G2/HOT-PHRASES/HOT-PHRASE/TERM">
									<xsl:apply-templates select="/H2G2/HOT-PHRASES/HOT-PHRASE" mode="related"/>
								</xsl:when>
								<xsl:otherwise>
									none
								</xsl:otherwise>
							</xsl:choose>
							</p>
							<!-- <div class="arrow"><a href="insert_url">See all key phrases</a></div> -->
						</div>
						
						<xsl:apply-templates select="/H2G2/SITECONFIG/POPULARRAWMATERIAL" />
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div><!--// col2 -->
		<div class="clear"></div>
	</div>
		
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							MEDIAASSETSEARCHPHRASE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="r_search">
	Use: The 'search for an asset' input field
	-->
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="r_search">
		<div class="assetNavFormBlock">
			<label for="soupSearch">Search for <b><xsl:value-of select="$contenttypetext"/></b> assets:</label>	
			<xsl:apply-templates select="." mode="t_searchbox"/>
			<input type="submit" value="Go" style="width:40px;"/><!-- replace this with pink button -->
		</div>
	</xsl:template>

	
	<!-- override from base skin 
	     url-encoded chars such as '(%27) are not being decoded in PHRASE/TERM,
	     but are being decoded in PHRASE/NAME
	     will check for the existence of % characer in PHRASE/TERM and if present default to PHRASE/NAME
	     FIXME: not a permanent solution, need to find out the difference between NAME and TERM
	-->	
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="t_searchbox">
		<input type="text" name="phrase" value="" xsl:use-attribute-sets="iMEDIAASSETSEARCHPHRASE_t_searchbox">
		<xsl:if test="PHRASES/PHRASE">
			<xsl:attribute name="value">
				<xsl:for-each select="PHRASES/PHRASE">
					<xsl:choose>
						<xsl:when test="contains(TERM, '%')">
							<xsl:value-of select="NAME"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TERM"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="not(position() = last())">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</xsl:if>
		</input>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="r_masp">
	Use: The list of assets on the masp page with navigation
	-->
	<xsl:template match="MEDIAASSETSEARCHPHRASE" mode="r_masp">
		<xsl:if test="PHRASES/PHRASE/NAME">
		<h2>All <xsl:value-of select="$contenttypetext"/> assets with the key phrase 
			'<xsl:for-each select="PHRASES/PHRASE">
			<span class="orange"><xsl:value-of select="NAME"/></span><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>'
		</h2>
		</xsl:if>
		
		
		<div class="assetNavFormBlock">
			<form name="sortByForm" id="sortByForm" method="GET" action="MediaAssetSearchPhrase">
				<input type="hidden" name="contenttype" value="{/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}" />
				<label for="sortBy">Sort by:</label>						
				<select name="assetsortby" id="sortBy">
					<option value="DateUploaded" selected="selected">Most recent</option>
					<option value="Caption">
						<xsl:if test="ASSETSEARCH/@SORTBY='Caption'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
					A-Z by title</option>
					<option value="Rating">
						<xsl:if test="ASSETSEARCH/@SORTBY='Rating'">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
					Highest rated</option>
			    </select>
				
				<input type="submit" value="Go &gt;" style="width:40px;margin:0" />
				
			</form>
		</div>
		
		<div class="paginationBlock">
			<xsl:apply-templates select="ASSETSEARCH" mode="c_previouspage"/>
			<xsl:apply-templates select="ASSETSEARCH" mode="c_mediablocks"/>
			<xsl:apply-templates select="ASSETSEARCH" mode="c_nextpage"/>
		</div>
		
		<xsl:apply-templates select="ASSETSEARCH" mode="c_masp"/>
		
		<div class="paginationBlock">
			<xsl:apply-templates select="ASSETSEARCH" mode="c_previouspage"/>
			<xsl:apply-templates select="ASSETSEARCH" mode="c_mediablocks"/>
			<xsl:apply-templates select="ASSETSEARCH" mode="c_nextpage"/>
		</div>
		
		
	</xsl:template>
	<!-- 
	<xsl:template match="ASSETSEARCH" mode="r_masp">
	Use: The list of assets on the masp page
	-->
	<xsl:template match="ASSETSEARCH" mode="r_masp">
	
	<div class="resultsWrapper">
		<ul class="resultsList float">
			<xsl:apply-templates select="ASSET" mode="r_masp"/>
		</ul>
	</div>
	</xsl:template>
	<!-- 
	<xsl:template match="ASSET" mode="r_masp">
	Use: An individual asset on the masp page
	-->
	<xsl:template match="ASSET" mode="r_masp">
		<li class="floatFB">
			<xsl:if test="position() &gt; 18"><!-- items in the last 'row' don't have border-bottom-->
				<xsl:attribute name="class">floatFB last</xsl:attribute>
			</xsl:if>
			<div class="imageHolder">
				<xsl:apply-templates select="@ASSETID" mode="c_thumb"/>
			</div>
			<div class="content">
				<xsl:apply-templates select="@ASSETID" mode="c_viewmedia"/>
				<xsl:apply-templates select="SUBJECT" mode="checklength"/>
				<xsl:apply-templates select="OWNER/USER" mode="c_assetauthor"/>
				<div class="description"><xsl:apply-templates select="." mode="contenttype_text"/></div>
			</div>
			<div class="clr"></div>
			
		</li>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ASSET" mode="contenttype_text">
	Use: Text for the contenttype of the asset
	-->
	<xsl:template match="ASSET" mode="contenttype_text">
		<xsl:choose>
			<xsl:when test="@CONTENTTYPE=3">
			video
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=2">
			audio
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=1">
			image
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="EXTRAELEMENTXML/DURATION" mode="result_duration"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="EXTRAELEMENTXML/DURATION">
	Use: The DURATION of an asset in a result list
	-->
	<xsl:template match="EXTRAELEMENTXML/DURATION" mode="result_duration">
		<xsl:if test="(@CONTENTTYPE=3 or @CONTENTTYPE=2)">
			<xsl:text> </xsl:text><span>| <xsl:value-of select="./text()"/></span>
		</xsl:if>
	</xsl:template>
	
	<!-- 
	<xsl:template match="@ASSETID" mode="r_thumb">
	Use: Presentation of the thumbnail presentation of the image
	-->
	<xsl:template match="@ASSETID" mode="r_thumb">
		<xsl:choose>
			<xsl:when test="../@CONTENTTYPE=1">
				<xsl:variable name="suffix">
					<xsl:choose>
						<xsl:when test="../MIMETYPE='image/jpeg'">jpg</xsl:when>
						<xsl:when test="../MIMETYPE='image/jpg'">jpg</xsl:when>
						<xsl:when test="../MIMETYPE='image/pjpeg'">jpg</xsl:when>
						<xsl:when test="../MIMETYPE='image/gif'">gif</xsl:when>			
					</xsl:choose>
					</xsl:variable>
				<a href="{$root}MediaAsset?id={.}{$masptags}" ><img src="{$libraryurl}{../FTPPATH}{.}_thumb.{$suffix}" alt="{../SUBJECT}" xsl:use-attribute-sets="imgaASSETID_r_thumb" border="0" /></a>
			</xsl:when>
			<xsl:when test="../@CONTENTTYPE=2">
				<a href="{$root}MediaAsset?id={.}{$masptags}"><img src="{$imagesource}audio_asset_134x134.gif" width="134" height="134" alt="" /></a>
			</xsl:when>
			<xsl:when test="../@CONTENTTYPE=3">
				<a href="{$root}MediaAsset?id={.}{$masptags}"><img src="{$imagesource}video/134/{.}.jpg" alt="{../SUBJECT/text()}" /></a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
	<xsl:template match="@ASSETID" mode="r_viewmedia">
	Use: Presentation of the 'view media' link
	-->
	<xsl:template match="@ASSETID" mode="r_viewmedia">
		<xsl:variable name="suffix">
		<xsl:choose>
			<xsl:when test="../MIMETYPE='image/gif'">gif</xsl:when>
			<xsl:otherwise>
			jpg
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<div class="buttonWrapper"><a href="{$root}MediaAsset?id={.}{$masptags}" class="button"><span><span><span><xsl:copy-of select="$m_viewmedia"/></span></span></span></a></div>
	</xsl:template>
	
	<xsl:variable name="m_viewmedia">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE=2">
				listen to media
			</xsl:when>
			<xsl:otherwise>
				view media
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- 
	<xsl:template match="USER" mode="r_assetauthor">
	Use: Presentation of the link to the author of the asset
	-->
	<xsl:template match="USER" mode="r_assetauthor">
		<div class="author">by<xsl:text> </xsl:text><xsl:apply-imports/></div>
	</xsl:template>
	<!-- 
	<xsl:template match="PHRASES" mode="r_maspsearch">
	Use: Presentation of the list of tags associated with this asset
	-->
	<xsl:template match="PHRASES" mode="r_maspsearch">
		<strong>
			<xsl:text>Tags: </xsl:text>
		</strong>
		<xsl:apply-templates select="PHRASE" mode="c_maspsearch"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="PHRASE" mode="r_maspsearch">
	Use: Presentation of a single tag associated with this asset
	-->
	<xsl:template match="PHRASE" mode="r_maspsearch">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::PHRASE">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- 
	<xsl:template match="SUBJECT" mode="checklength">
	Use: Presentation of a single tag associated with this asset
	-->
	<xsl:template match="SUBJECT" mode="checklength">
		<xsl:variable name="maxlength">50</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length(.) &gt; $maxlength">
				<p title="{.}"><xsl:value-of select="substring(., 1, $maxlength)"/>...</p>
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:apply-imports/></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							HOT-PHRASES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- Count the number of phrases on the page -->
	<xsl:variable name="asset-total-phrases" select="count(/H2G2/HOT-PHRASES/HOT-PHRASE)"/>
	<!-- Set the number of ranges you want -->
	<xsl:variable name="assets-no-of-ranges" select="5"/>
	<!-- Work out how many phrases in each range: -->
	<xsl:variable name="assets-hot-phrases-in-block" select="ceiling($asset-total-phrases div $assets-no-of-ranges)"/>
	<!-- Re-order the HOT-PHRASES so that the highest scoring appears first adding generate-id and position atts -->
	<xsl:variable name="assets-hot-phrases">
		<xsl:for-each select="/H2G2/HOT-PHRASES/HOT-PHRASE">
			<xsl:sort select="RANK" data-type="number" order="descending"/>
			<xsl:copy>
				<xsl:attribute name="position"><xsl:value-of select="position() mod $assets-hot-phrases-in-block"/></xsl:attribute>
				<xsl:attribute name="generate-id"><xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:copy-of select="node()"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<!-- surround each range in the re-ordered node-set with a RANGE tag -->	
	<xsl:variable name="assets-ranked-hot-phrases">
		<xsl:for-each select="msxsl:node-set($assets-hot-phrases)/HOT-PHRASE[@position=1]">
			<RANGE ID="{position()}">
				<xsl:copy-of select="."/>
				<xsl:for-each select="following-sibling::HOT-PHRASE[position() &lt; $assets-hot-phrases-in-block]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</RANGE>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:key name="assets-ranked-hot-phrases" match="HOT-PHRASE" use="RANK"/>
	
	<!-- 
	<xsl:template match="HOT-PHRASES" mode="r_masp">
	Use: Presentation of the tag cloud
	-->
	<xsl:template match="HOT-PHRASES" mode="r_masp">
		<xsl:apply-templates select="HOT-PHRASE" mode="c_masp">
			<xsl:sort select="NAME" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- 
	<xsl:template match="HOT-PHRASES" mode="r_masp">
	Use: Presentation ofan individual item within the tag cloud
	-->
	<xsl:template match="HOT-PHRASE" mode="r_masp">
		<xsl:variable name="popularity" select="$assets-no-of-ranges + 1 - msxsl:node-set($assets-ranked-hot-phrases)/RANGE[HOT-PHRASE[generate-id(current()) = @generate-id]]/@ID"/>
		<a href="{$root}MediaAssetSearchPhrase?contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}&amp;phrase={TERM}" class="rank{$popularity}"><xsl:value-of select="NAME"/></a><xsl:text> </xsl:text>		
	</xsl:template>
	
	<!-- 
	<xsl:template match="HOT-PHRASES/HOT-PHRASE" mode="related">
	Use: Presentation of the related key phrases
	-->
	<xsl:template match="HOT-PHRASES/HOT-PHRASE" mode="related">
		<xsl:if test="position() &lt; 20">
			<a href="{$root}MediaAssetSearchPhrase?contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}&amp;phrase={TERM}"><xsl:value-of select="NAME"/></a><xsl:text> </xsl:text>		
		</xsl:if>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							NAVIGATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="ASSETSEARCH " mode="r_mediablocks">
	Use: Object holding the navigation items
	-->
	<xsl:template match="ASSETSEARCH " mode="r_mediablocks">
		<xsl:apply-templates select="." mode="c_mediablockdisplay"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ASSETSEARCH " mode="on_mediablockdisplay">
	Use: Controls the display of the block (outside the link) which is the current page
	-->
	<xsl:template match="ASSETSEARCH " mode="on_mediablockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_mediaontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_mediaontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<strong>
			<xsl:value-of select="$pagenumber"/>
		</strong>
	</xsl:template>
	<!-- 
	<xsl:template match="ASSETSEARCH " mode="off_mediablockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="ASSETSEARCH " mode="off_mediablockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_mediaofftabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_mediaofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	Use: Attribute sets for the navigation links 
	-->
	<xsl:attribute-set name="mASSETSEARCH_on_mediablockdisplay"/>
	<xsl:attribute-set name="mASSETSEARCH_off_mediablockdisplay"/>
	<!-- 
	<xsl:template match="ASSETSEARCH" mode="text_previouspage">
	Use: invoked when there is no previos page to display
	-->
	<xsl:template match="ASSETSEARCH" mode="text_previouspage">
		<span class="prev_dormant"><b>previous</b>|</span>
	</xsl:template>
	<!-- 
	<xsl:template match="ASSETSEARCH" mode="text_nextpage">
	Use: Invoked when there is no next page to display
	-->
	<xsl:template match="ASSETSEARCH" mode="text_nextpage">
		<span class="next_dormant">|<b>next</b></span>
	</xsl:template>
	<!-- 
	<xsl:template match="ASSETSEARCH" mode="link_previouspage">
	Use: Link to the previous page
	-->
	<xsl:template match="ASSETSEARCH" mode="link_previouspage">
		<span class="prev_active"><b><a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}&amp;assetsortby={@SORTBY}" xsl:use-attribute-sets="mASSETSEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspagemasp"/></a></b>|</span>
	</xsl:template>
	<!-- 
	<xsl:template match="ASSETSEARCH" mode="link_nextpage">
	Use: Link to the next page
	-->
	<xsl:template match="ASSETSEARCH" mode="link_nextpage">
		<span class="next_active">|<b><a href="{$root}MediaAssetSearchPhrase?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}&amp;assetsortby={@SORTBY}" xsl:use-attribute-sets="mASSETSEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpagemasp"/></a></b></span>
	</xsl:template>
	
	
	<!-- override base files - don't want current page to be a link and added assetsortby-->
	<xsl:template match="ASSETSEARCH" mode="displayblockmasp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_mediablockdisplay">
					<xsl:with-param name="url">
						<xsl:call-template name="t_mediaontabcontent">
							<xsl:with-param name="range" select="$PostRange"/>
							<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
						</xsl:call-template>
						<xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_mediablockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}MediaAssetSearchPhrase?skip={$skip}&amp;show={@COUNT}&amp;contenttype={/H2G2/MEDIAASSETSEARCHPHRASE/ASSETSEARCH/@CONTENTTYPE}{$maspsearchphrase}&amp;assetsortby={@SORTBY}" xsl:use-attribute-sets="mASSETSEARCH_off_mediablockdisplay">
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
</xsl:stylesheet>
