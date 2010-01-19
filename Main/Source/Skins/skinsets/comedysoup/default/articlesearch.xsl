<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <xsl:import href="../../../base/base-articlesearch.xsl"/>

  <xsl:template name="ARTICLESEARCH_MAINBODY">
    <!-- 
	NOTE TO ALISTAIR:
	
	change <span class="orange"> to <span class="searchterm">
	check for any other instances of orange or colours as words
	
	-->

    <!-- DEBUG -->
    <xsl:call-template name="TRACE">
      <xsl:with-param name="message">ARTICLESEARCH_MAINBODY</xsl:with-param>
      <xsl:with-param name="pagename">articlesearchphrase.xsl</xsl:with-param>
    </xsl:call-template>
    <!-- DEBUG -->

    <h1>
      <xsl:choose>
        <xsl:when test="/H2G2/ARTICLESEARCH/PHRASES/@COUNT > 0">
          <!-- RESULT PAGES -->
          <xsl:choose>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
              <img src="{$imagesource}h1_imagesresults.gif" alt="images: results" width="185" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">image</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
              <img src="{$imagesource}h1_audioresults.gif" alt="audio: results" width="164" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">audio</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
              <img src="{$imagesource}h1_videoandanimationresults.gif" alt="video &amp; animation: results" width="308" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">video</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=0">
              all results
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">general</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- INDEX PAGES -->
          <xsl:choose>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
              <img src="{$imagesource}h1_images.gif" alt="images (find pictures that people have made)" width="333" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">image</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
              <img src="{$imagesource}h1_audio.gif" alt="audio (find sound that people have made)" width="298" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">audio</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
              <img src="{$imagesource}h1_videoandanimation.gif" alt="video &amp; animation (find clips that people have made)" width="433" height="26" />
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">video</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=0">
              all submissions
              <xsl:call-template name="RSSICON">
                <xsl:with-param name="feedtype">general</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </h1>

    <div  class="default">
      <div class="col1">
        <div class="margins">
          <!-- asset navigation form block - select -->
          <div class="assetNavFormBlock">
            <xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="c_articlesearch"/>
          </div>
          <!--// asset navigation form block - select -->
          <br />

          <xsl:choose>
            <xsl:when test="/H2G2/ARTICLESEARCH/PHRASES/@COUNT = 0">
              <!-- INDEX PAGE -->

              <!-- Current popular key phrases -->
              <h2>
                Current popular key phrases for
                <xsl:choose>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
                    images
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
                    audio assets
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
                    video &amp; animation
                  </xsl:when>
                </xsl:choose>:
              </h2>

              <div class="dynamicKeyPhraseBox">
                <xsl:apply-templates select="/H2G2/ARTICLEHOT-PHRASES" mode="c_articlehotphrases"/>
              </div>

              <!-- Browse current media type-->
              <h2>
                Browse <xsl:choose>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
                    images
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
                    audio
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
                    video &amp; animation
                  </xsl:when>
                </xsl:choose>
              </h2>
            </xsl:when>
            <xsl:otherwise>
              <!-- RESULTS PAGE -->
              <h2>
                <xsl:choose>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
                    images
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
                    audio
                  </xsl:when>
                  <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
                    video &amp; animation
                  </xsl:when>
                </xsl:choose>
                with the key phrase
                '<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
                  <span class="orange">
                    <xsl:value-of select="NAME"/>
                  </span>
                  <xsl:if test="position() != last()">, </xsl:if>
                </xsl:for-each>'
              </h2>
            </xsl:otherwise>
          </xsl:choose>


          <xsl:if test="PHRASES/@COUNT">
            <xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
              <span class="orange">
                <xsl:value-of select="NAME"/>
              </span>
              <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </xsl:if>


          <!-- dropdown - sort by -->
          <div class="assetNavFormBlock">
            <form name="sortByForm" id="sortByForm" method="GET" action="ArticleSearch">
              <input type="hidden" name="contenttype" value="{/H2G2/ARTICLESEARCH/@CONTENTTYPE}" />
              <label for="sortBy">Sort by:</label>
              <select name="articlesortby" id="sortBy">
                <option value="DateUploaded">Most recent</option>
                <option value="Caption">
                  <xsl:if test="ARTICLESEARCH/@SORTBY='Caption'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  A-Z by title
                </option>
                <option value="Rating">
                  <xsl:if test="ARTICLESEARCH/@SORTBY='Rating'">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Most rated
                </option>
              </select>

              <input type="submit" value="Go &gt;" style="width:40px;margin:0" />

            </form>
          </div>

          <!-- pagination block -->
          <xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>

          <!-- list of article -->
          <xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="c_articlesearchresults"/>

          <!-- pagination block -->
          <xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="pagination_links"/>
        </div>
      </div>
      <!--// col1 -->

      <div class="col2">
        <div class="margins">
          <xsl:choose>
            <xsl:when test="/H2G2/ARTICLESEARCH/PHRASES/@COUNT = 0">
              <!-- index page view (no search term) -->
              <!-- Add when we have some content
							<div class="contentBlock">
								<h2>Current top rated <xsl:choose>
									<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=1">
										images
									</xsl:when>
									<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=2">
										audio
									</xsl:when>
									<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=3">
										video
									</xsl:when>
								</xsl:choose>:</h2>
								
								INSERT_DYNAMICLIST
								
								can't do this until the DYNAMIC-LISTS object is available on this page
							</div>
							-->

            </xsl:when>
            <xsl:otherwise>
              <!-- results view -->
              <div class="contentBlock">
                <h2>
                  Key phrases related to
                  '<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
                    <span class="orange">
                      <xsl:value-of select="NAME"/>
                    </span>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>':
                </h2>
                <p>
                  <xsl:choose>
                    <xsl:when test="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE/TERM">
                      <xsl:apply-templates select="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related"/>
                    </xsl:when>
                    <xsl:otherwise>
                      none
                    </xsl:otherwise>
                  </xsl:choose>
                </p>
              </div>
            </xsl:otherwise>
          </xsl:choose>

          <!-- siteconfig - ComedySoup De Jour -->
          <xsl:apply-templates select="/H2G2/SITECONFIG/SOUPDEJOUR" />


          <!-- siteconfig - BBC Three -->
          <xsl:if test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
            <xsl:apply-templates select="/H2G2/SITECONFIG/BBCTHREE" />
          </xsl:if>
        </div>
      </div>
      <!--// col2 -->
      <div class="clr"></div>
    </div>
  </xsl:template>

  <xsl:template match="ARTICLESEARCH" mode="r_search">
    <label for="soupSearch">
      Search <xsl:choose>
        <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
          images
        </xsl:when>
        <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
          audio
        </xsl:when>
        <xsl:when test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
          video &amp; animation
        </xsl:when>
      </xsl:choose>:
    </label>
    <xsl:text> </xsl:text>
    <!--
		<xsl:apply-templates select="." mode="t_articlesearchbox"/>
		-->
    <xsl:apply-templates select="." mode="ARTICLESEARCHBOX"/>
    <input type="submit" value="Go" style="width:30px;margin:0px;padding:0px;"/>
  </xsl:template>
  <xsl:attribute-set name="iARTICLESEARCHPHRASE_t_articlesearchbox">
    <xsl:attribute name="id">soupSearch</xsl:attribute>
  </xsl:attribute-set>

  <!-- override from base skin 
	     url-encoded chars such as '(%27) are not being decoded in PHRASE/TERM,
	     but are being decoded in PHRASE/NAME
	     will check for the existence of % characer in PHRASE/TERM and if present default to PHRASE/NAME
	     FIXME: not a permanent solution, need to find out the difference between NAME and TERM
	-->
  <xsl:template match="ARTICLESEARCH" mode="ARTICLESEARCHBOX">
    <input type="text" name="phrase" value="" xsl:use-attribute-sets="iARTICLESEARCHPHRASE_t_articlesearchbox">
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


  <xsl:template match="ARTICLESEARCH" mode="pagination_links">
    <div class="paginationBlock">
      <xsl:apply-templates select="." mode="c_previouspage"/>
      <xsl:apply-templates select="." mode="c_articleblocks"/>
      <xsl:apply-templates select="." mode="c_nextpage"/>
    </div>
  </xsl:template>

  <xsl:template match="ARTICLESEARCH" mode="r_articlesearchresults">
    <xsl:apply-templates select="ARTICLES" mode="c_articlesearchresults"/>
  </xsl:template>

  <xsl:template match="ARTICLES" mode="r_articlesearchresults">
    <ul class="resultsList">
      <xsl:apply-templates select="ARTICLE" mode="c_articlesearchresults"/>
    </ul>
  </xsl:template>

  <xsl:template match="ARTICLE" mode="r_articlesearchresults">
    <li class="smallFB">
      <div class="imageHolder">
        <xsl:if test="MEDIAASSET/@MEDIAASSETID">
          <a href="{$root}A{@H2G2ID}">
            <xsl:apply-templates select="MEDIAASSET/@MEDIAASSETID" mode="c_articlethumb"/>
          </a>
        </xsl:if>
      </div>
      <div class="content">
        <h2 class="fbHeader">
          <a href="{$root}A{@H2G2ID}">
            <xsl:value-of select="SUBJECT"/>
          </a>
        </h2>
        <xsl:if test="EXTRAINFO/AUTODESCRIPTION">
          <p>
            <xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
          </p>
        </xsl:if>
        <div class="starRating">
          user rating:
          <xsl:choose>
            <xsl:when test="POLL/STATISTICS/@AVERAGERATING > 0" >
              <img src="{$imagesource}stars_{floor(POLL/STATISTICS/@AVERAGERATING)}.gif" alt="{floor(POLL/STATISTICS/@AVERAGERATING)}" width="65" height="12" />
            </xsl:when>
            <xsl:otherwise>
              not yet rated
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div class="author">
          by <a href="{$root}U{EDITOR/USER/USERID}">
            <xsl:value-of select="EDITOR/USER/FIRSTNAMES"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="EDITOR/USER/LASTNAME"/>
          </a>
        </div>
        <div class="description">
          <xsl:choose>
            <xsl:when test="MEDIAASSET/CONTENTTYPE=1">
              images
            </xsl:when>
            <xsl:when test="MEDIAASSET/CONTENTTYPE=2">
              audio
            </xsl:when>
            <xsl:when test="MEDIAASSET/CONTENTTYPE=3">
              video
            </xsl:when>
          </xsl:choose>
          <xsl:if test="EXTRAINFO/PCCAT &gt; 0">
            <span class="challenge">CHALLENGE</span>
          </xsl:if>
          <span></span>
        </div>
      </div>
      <div class="clr"></div>
    </li>
  </xsl:template>

  <xsl:template match="MEDIAASSET/@MEDIAASSETID" mode="r_articlethumb">
    <xsl:choose>
      <xsl:when test="../CONTENTTYPE=1">
        <xsl:apply-imports/>
      </xsl:when>
      <xsl:when test="../CONTENTTYPE=2">
        <img src="{$imagesource}audio_asset_134x134.gif" width="134" height="134" alt="" />
      </xsl:when>
      <xsl:when test="../CONTENTTYPE=3">
        <img src="{$imagesource}video/134/{.}.jpg" width="134" height="134" alt="" />
      </xsl:when>
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
  <xsl:variable name="total-phrases" select="count(/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE)"/>
  <!-- Set the number of ranges you want -->
  <xsl:variable name="no-of-ranges" select="5"/>
  <!-- Work out how many phrases in each range: -->
  <xsl:variable name="hot-phrases-in-block" select="ceiling($total-phrases div $no-of-ranges)"/>
  <!-- Re-order the HOT-PHRASES so that the highest scoring appears first adding generate-id and position atts -->
  <xsl:variable name="hot-phrases">
    <xsl:for-each select="/H2G2/ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE">
      <xsl:sort select="RANK" data-type="number" order="descending"/>
      <xsl:copy>
        <xsl:attribute name="position">
          <xsl:value-of select="position() mod $hot-phrases-in-block"/>
        </xsl:attribute>
        <xsl:attribute name="generate-id">
          <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
        <xsl:copy-of select="node()"/>
      </xsl:copy>
    </xsl:for-each>
  </xsl:variable>
  <!-- surround each range in the re-ordered node-set with a RANGE tag -->
  <xsl:variable name="ranked-hot-phrases">
    <xsl:for-each select="msxsl:node-set($hot-phrases)/ARTICLEHOT-PHRASE[@position=1]">
      <RANGE ID="{position()}">
        <xsl:copy-of select="."/>
        <xsl:for-each select="following-sibling::ARTICLEHOT-PHRASE[position() &lt; $hot-phrases-in-block]">
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </RANGE>
    </xsl:for-each>
  </xsl:variable>

  <xsl:key name="ranked-hot-phrases" match="ARTICLEHOT-PHRASE" use="RANK"/>

  <xsl:template match="ARTICLEHOT-PHRASES" mode="r_articlehotphrases">
    <xsl:apply-templates select="ARTICLEHOT-PHRASE" mode="c_articlehotphrases">
      <xsl:sort select="NAME" order="ascending"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ARTICLEHOT-PHRASE" mode="r_articlehotphrases">
    <xsl:variable name="popularity" select="$no-of-ranges + 1 - msxsl:node-set($ranked-hot-phrases)/RANGE[ARTICLEHOT-PHRASE[generate-id(current()) = @generate-id]]/@ID"/>

    <a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}" class="rank{$popularity}">
      <xsl:value-of select="NAME"/>
    </a>
    <xsl:text> </xsl:text>
  </xsl:template>


  <!-- 
	<xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
	Use: Presentation of the related key phrases
	-->
  <xsl:template match="ARTICLEHOT-PHRASES/ARTICLEHOT-PHRASE" mode="related">
    <xsl:if test="position() &lt; 20">
      <a href="{$root}ArticleSearchPhrase?&amp;phrase={TERM}&amp;contenttype={../@ASSETCONTENTTYPE}">
        <xsl:value-of select="NAME"/>
      </a>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							NAVIGATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
  <xsl:template match="ARTICLESEARCH" mode="r_articleblocks">

    <xsl:apply-templates select="." mode="c_articleblockdisplay"/>

  </xsl:template>

  <xsl:template match="ARTICLESEARCH" mode="on_articleblockdisplay">
    <xsl:param name="url"/>
    <xsl:copy-of select="$url"/>
  </xsl:template>
  <!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
  <xsl:template name="t_articleontabcontent">
    <xsl:param name="range"/>
    <xsl:param name="pagenumber"/>
    <strong>
      <xsl:value-of select="$pagenumber"/>
    </strong>
  </xsl:template>
  <!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
  <xsl:template match="ARTICLESEARCH" mode="off_articleblockdisplay">
    <xsl:param name="url"/>
    <xsl:copy-of select="$url"/>
  </xsl:template>
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
	Use: Attribute sets for the links themselves
	-->
  <xsl:attribute-set name="mARTICLESEARCH_on_articleblockdisplay"/>
  <xsl:attribute-set name="mARTICLESEARCH_off_articleblockdisplay"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_nextpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_previouspage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_firstpage"/>
  <xsl:attribute-set name="mARTICLESEARCH_link_lastpage"/>

  <xsl:template match="ARTICLESEARCH" mode="text_previouspage">
    <span class="prev_dormant">
      <b>previous</b>|
    </span>
  </xsl:template>
  <xsl:template match="ARTICLESEARCH" mode="text_nextpage">
    <span class="next_dormant">
      |<b>next</b>
    </span>
  </xsl:template>

  <!-- Not being used:
	
	<xsl:template match="ARTICLESEARCH" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_firstpage">
		<xsl:text>No first </xsl:text>
	</xsl:template>
	<xsl:template match="ARTICLESEARCH" mode="text_lastpage">
		<xsl:text>No last </xsl:text>
	</xsl:template>
	-->

  <!-- override base files as need to have contenttype= in the querystring  -->
  <xsl:template match="ARTICLESEARCH" mode="link_nextpage">
    <span class="next_active">
      |<b>
        <a href="{$root}ArticleSearch?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_nextpage">
          <xsl:copy-of select="$m_nextpageartsp"/>
        </a>
      </b>
    </span>
  </xsl:template>

  <!-- override base files as need to have contenttype= in the querystring -->
  <xsl:template match="ARTICLESEARCH" mode="link_previouspage">
    <span class="prev_active">
      <b>
        <a href="{$root}ArticleSearch?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_link_previouspage">
          <xsl:copy-of select="$m_previouspageartsp"/>
        </a>
      </b>|
    </span>
  </xsl:template>


  <!-- override base files as needed to add contenttype and ArticleSortby to link -->
  <xsl:template match="ARTICLESEARCH" mode="displayblockartsp">
    <xsl:param name="skip"/>
    <xsl:param name="onlink"/>
    <xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
    <xsl:choose>
      <xsl:when test="@SKIPTO = $skip">
        <xsl:apply-templates select="." mode="on_articleblockdisplay">
          <xsl:with-param name="url">
            <xsl:call-template name="t_articleontabcontent">
              <xsl:with-param name="range" select="$PostRange"/>
              <xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="off_articleblockdisplay">
          <xsl:with-param name="url">
            <xsl:value-of select="$onlink"/>
            <a href="{$root}ArticleSearchPhrase?skip={$skip}&amp;show={@COUNT}{$artspsearchphrase}&amp;contenttype={@CONTENTTYPE}&amp;ArticleSortby={@SORTBY}" xsl:use-attribute-sets="mARTICLESEARCH_off_articleblockdisplay">
              <xsl:call-template name="t_articleofftabcontent">
                <xsl:with-param name="range" select="$PostRange"/>
                <xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
              </xsl:call-template>
            </a>
            <xsl:text> </xsl:text>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
