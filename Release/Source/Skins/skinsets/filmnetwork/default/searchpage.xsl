<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-searchpage.xsl"/>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="SEARCH_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message"/>
                        <xsl:with-param name="pagename">searchpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="10">
                                        <!-- crumb menu -->
                                        <div class="crumbtop">
                                                <span class="textxlarge">
                                                        <xsl:choose>
                                                                <xsl:when test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0"> search results </xsl:when>
                                                                <xsl:otherwise> search page </xsl:otherwise>
                                                        </xsl:choose>
                                                </span>
                                        </div>
                                        <!-- END crumb menu -->
                                </td>
                        </tr>
                </table>
                <!-- head section -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="20"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td valign="top" width="371">
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td class="topbg" height="69" valign="top">
                                                                <img alt="" height="10" src="/f/t.gif" width="1"/>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0">
                                                                                <div class="whattodotitle">
                                                                                        <strong>your search results for <br/></strong>
                                                                                </div>
                                                                                <div class="biogname">
                                                                                        <strong>
                                                                                                <xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
                                                                                        </strong>
                                                                                </div>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <div class="whattodotitle">
                                                                                        <strong>search page <br/></strong>
                                                                                </div>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </td>
                                                </tr>
                                        </table>
                                </td>
                                <td class="topbg" valign="top" width="20"/>
                                <td class="topbg" valign="top"> </td>
                        </tr>
                        <tr>
                                <td colspan="3" valign="top" width="635">
                                        <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                                </td>
                        </tr>
                </table>
                <!-- spacer -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="10"/>
                        </tr>
                </table>
                <!-- end spacer -->
                <!-- END head section -->
                <!-- END head section -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="20"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td height="250" valign="top">
                                        <!-- LEFT COL MAIN CONTENT -->
                                        <xsl:choose>
                                                <xsl:when test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0">
                                                        <xsl:apply-templates mode="c_search" select="SEARCH/SEARCHRESULTS"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <div class="textmedium">
                                                                <strong>Enter a search term below <br/></strong>
                                                        </div>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- END LEFT COL MAIN CONTENT -->
                                </td>
                                <td><!-- 20px spacer column --></td>
                                <td valign="top">
                                        <!-- hints and tips -->
                                        <!-- top with angle -->
                                        <!-- hints and tips -->
                                        <!-- top with angle -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                <tr>
                                                        <td align="right" class="webboxbg" height="42" valign="top" width="50">
                                                                <div class="alsoicon">
                                                                        <img alt="" height="24" src="{$imagesource}furniture/myprofile/alsoicon.gif" width="25"/>
                                                                </div>
                                                        </td>
                                                        <td class="webboxbg" valign="top" width="122">
                                                                <div class="hints">
                                                                        <strong>hints and tips</strong>
                                                                </div>
                                                        </td>
                                                        <td class="anglebg" valign="top" width="72">
                                                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END top with angle -->
                                        <!-- hint paragraphs -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                <tr>
                                                        <td class="webboxbg" height="42" valign="top" width="244">
                                                                <xsl:copy-of select="$search_hints"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END hint paragraphs -->
                                        <!-- END hints and tips -->
                                        <xsl:if test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0">
                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                        <tr>
                                                                <td class="webboxbg" colspan="3">
                                                                        <img alt="" height="1" src="/f/t.gif" width="26"/>
                                                                        <img alt="" height="1" src="{$imagesource}furniture/dashrule.gif" width="192"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td align="right" class="webboxbg" height="42" valign="top" width="10"/>
                                                                <td class="webboxbg" valign="top" width="162">
                                                                        <div class="hints">
                                                                                <strong>Search for '<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>' elsewhere :</strong>
                                                                        </div>
                                                                </td>
                                                                <td class="webboxbg" valign="top" width="72">
                                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- END top with angle -->
                                                <!-- hint paragraphs -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                        <tr>
                                                                <td class="webboxbg" height="42" valign="top" width="244">
                                                                        <div class="searchrightcol">
                                                                                <strong><a class="rightcol"
                                                                                                href="http://www.bbc.co.uk/cgi-bin/search/results.pl?q={/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM}&amp;recipe=all"
                                                                                                >bbc.co.uk</a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif" width="4"
                                                                                                /><br/><a class="rightcol"
                                                                                                href="http://www.bbc.co.uk/cgi-bin/search/results.pl?tab=www&amp;q={/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM}&amp;recipe=all&amp;scope=all"
                                                                                                >world wide web</a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif"
                                                                                                width="4"/></strong>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </xsl:if>
                                </td>
                        </tr>
                </table>
                <h2 id="search">search <xsl:if test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0">again</xsl:if></h2>
                <!-- search panel -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td align="right" class="webboxbg" height="96" valign="top" width="98">
                                        <img alt="Search icon" height="75" id="searchIcon" src="{$imagesource}furniture/directory/search.gif" width="75"/>
                                </td>
                                <td class="webboxbg" valign="top" width="465">
                                        <div class="searchline">I am looking for</div>
                                        <div class="searchback">
                                                <xsl:apply-templates mode="c_searchform" select="SEARCH"/>
                                                <!-- <input name="textfield" type="text" size="10" class="searchinput"/> -->
                                        </div>
                                </td>
                                <td class="webboxbg" valign="top" width="72">
                                        <img alt="" height="39" src="{$imagesource}furniture/filmindex/angle.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <!-- END search panel -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="20"/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="SEARCH" mode="r_searchform">
                <input name="type" type="hidden" value="1"/>
                <!-- or forum or user -->
                <input name="showapproved" type="hidden" value="1"/>
                <!-- status 1 articles -->
                <input name="showsubmitted" type="hidden" value="0"/>
                <!-- articles in a review forum -->
                <input name="shownormal" type="hidden" value="1"/>
                <xsl:apply-templates mode="t_searchinput" select="."/>
                &nbsp;&nbsp;<input name="dosearch" src="{$imagesource}furniture/directory/search1.gif" title="search"
                        type="image"/>
        </xsl:template>
        <xsl:attribute-set name="mSEARCH_c_searchform"/>
        <xsl:attribute-set name="mSEARCH_t_searchinput">
                <xsl:attribute name="class">searchinput</xsl:attribute>
                <xsl:attribute name="size">10</xsl:attribute>
                <xsl:attribute name="value">
                        <xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
                </xsl:attribute>
        </xsl:attribute-set>
        <xsl:attribute-set name="mSEARCH_t_searchsubmit">
                <xsl:attribute name="type">submit</xsl:attribute>
        </xsl:attribute-set>
        <xsl:template match="SEARCH" mode="r_searchtype">
                <xsl:copy-of select="$m_searcharticles"/>
                <xsl:apply-templates mode="t_searcharticles" select="."/>
                <br/>
                <xsl:copy-of select="$m_searchusers"/>
                <xsl:apply-templates mode="t_searchusers" select="."/>
                <br/>
                <xsl:copy-of select="$m_searchuserforums"/>
                <xsl:apply-templates mode="t_searchforums" select="."/>
                <br/>
                <br/>
        </xsl:template>
        <xsl:attribute-set name="mSEARCH_t_searcharticles">
                <xsl:attribute name="onclick">document.advsearch.showapproved.disabled=false; document.advsearch.showsubmitted.disabled=false;
                document.advsearch.shownormal.disabled=false;</xsl:attribute>
        </xsl:attribute-set>
        <xsl:attribute-set name="mSEARCH_t_searchusers">
                <xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true;
                document.advsearch.shownormal.disabled=true;</xsl:attribute>
        </xsl:attribute-set>
        <xsl:attribute-set name="mSEARCH_t_searchforums">
                <xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true;
                document.advsearch.shownormal.disabled=true;</xsl:attribute>
        </xsl:attribute-set>
        <xsl:template match="SEARCH" mode="r_resultstype">
                <xsl:copy-of select="$m_allresults"/>
                <xsl:apply-templates mode="t_allarticles" select="."/>
                <br/>
                <xsl:copy-of select="$m_recommendedresults"/>
                <xsl:apply-templates mode="t_submittedarticles" select="."/>
                <br/>
                <xsl:copy-of select="$m_editedresults"/>
                <xsl:apply-templates mode="t_editedarticles" select="."/>
                <br/>
                <br/>
        </xsl:template>
        <xsl:attribute-set name="mSEARCH_t_allarticles">
                <xsl:attribute name="checked">1</xsl:attribute>
        </xsl:attribute-set>
        <xsl:attribute-set name="mSEARCH_t_submittedarticles">
                <xsl:attribute name="checked">1</xsl:attribute>
        </xsl:attribute-set>
        <xsl:attribute-set name="mSEARCH_t_editedarticles">
                <xsl:attribute name="checked">1</xsl:attribute>
        </xsl:attribute-set>
        <xsl:template match="SEARCHRESULTS" mode="noresults_search">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td height="8"/>
                        </tr>
                        <tr>
                                <td height="2" width="371">
                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                </td>
                        </tr>
                        <tr>
                                <td height="8"/>
                        </tr>
                        <tr>
                                <td valign="top" width="371">
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td width="100%">
                                                                <div class="textmedium">
                                                                        <strong>No Results Found</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                        </table>
                                </td>
                        </tr>
                        <tr>
                                <td height="18" width="371">
                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="SEARCHRESULTS" mode="results_search">
                <!-- previous / page x of x / next table -->
                <!-- inly show search from primary results -->
                <xsl:choose>
                        <xsl:when test="count(ARTICLERESULT[PRIMARYSITE=1]) &gt; 0">
                                <!-- search results -->
                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                        <tr>
                                                <td height="2" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="8"/>
                                        </tr>
                                        <tr>
                                                <td valign="top" width="371">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td width="60">
                                                                                <div class="textmedium">
                                                                                        <strong>
                                                                                                <xsl:apply-templates mode="c_previous" select="SKIP"/>
                                                                                        </strong>
                                                                                </div>
                                                                        </td>
                                                                        <td align="center" width="251"></td>
                                                                        <td align="right" width="60">
                                                                                <div class="textmedium">
                                                                                        <strong>
                                                                                                <xsl:apply-templates mode="c_more" select="MORE"/>
                                                                                        </strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="18" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                </table>
                                <!-- END previous / page x of x / next table -->
                                <xsl:apply-templates mode="c_search" select="ARTICLERESULT[PRIMARYSITE=1]"/>
                                <!-- previous / page x of x / next table -->
                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                        <tr>
                                                <td height="8"/>
                                        </tr>
                                        <tr>
                                                <td height="2" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="8"/>
                                        </tr>
                                        <tr>
                                                <td valign="top" width="371">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td width="60">
                                                                                <div class="textmedium">
                                                                                        <strong>
                                                                                                <xsl:apply-templates mode="c_previous" select="SKIP"/>
                                                                                        </strong>
                                                                                </div>
                                                                        </td>
                                                                        <td align="center" width="251"></td>
                                                                        <td align="right" width="60">
                                                                                <div class="textmedium">
                                                                                        <strong>
                                                                                                <xsl:apply-templates mode="c_more" select="MORE"/>
                                                                                        </strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="18" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                </table>
                                <!-- END previous / page x of x / next table -->
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                        <tr>
                                                <td height="8"/>
                                        </tr>
                                        <tr>
                                                <td height="2" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="8"/>
                                        </tr>
                                        <tr>
                                                <td valign="top" width="371">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td width="100%">
                                                                                <div class="textmedium">
                                                                                        <strong>No Results Found</strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="18" width="371">
                                                        <img alt="" class="tiny" height="2" src="{$imagesource}furniture/blackrule.gif" width="371"/>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="SKIP" mode="nolink_previous">
                <xsl:value-of select="$m_noprevresults"/>
        </xsl:template>
        <xsl:template match="SKIP" mode="link_previous">
                <!-- $m_prevresults -->
                <xsl:copy-of select="$previous.arrow"/>&nbsp;<xsl:apply-imports/>
        </xsl:template>
        <xsl:template match="MORE" mode="nolink_more">
                <xsl:value-of select="$m_nomoreresults"/>
        </xsl:template>
        <xsl:template match="MORE" mode="link_more">
                <!-- m_nextresults -->
                <xsl:apply-imports/>&nbsp;<xsl:copy-of select="$next.arrow"/>
        </xsl:template>
        <xsl:template match="ARTICLERESULT" mode="r_search">
                <xsl:variable name="article_medium_gif">
                        <xsl:choose>
                                <xsl:when test="$showfakegifs = 'yes'">A1875585_medium.jpg</xsl:when>
                                <xsl:otherwise>A<xsl:value-of select="H2G2ID"/>_medium.jpg</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <xsl:choose>
                                <xsl:when test="EXTRAINFO/TYPE/@ID = 4001"/>
                                <!-- remove myspace page -->
                                <xsl:when test="STATUS = 3 and EXTRAINFO/TYPE/@ID !=3001"/>
                                <!-- remove non-approved films -->
                                <xsl:otherwise>
                                        <tr>
                                                <td valign="top" width="31">
                                                        <xsl:choose>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID &gt; 29 and EXTRAINFO/TYPE/@ID &lt; 36">
                                                                        <!-- A{H2G2id} -->
                                                                        <img alt="" height="57" src="{$imagesource}{$gif_assets}{$article_medium_gif}" width="115"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 63">
                                                                        <img alt="" height="57" src="{$imagesource}magazine/{$article_medium_gif}" width="115"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 60">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/discussion_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 10">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/discussion_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 61">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/fnguide_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 11">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/fnguide_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:when test="STATUS = 9">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/help_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 3001">
                                                                        <img alt="" height="30" src="{$imagesource}furniture/drama/person_icon.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <img alt="" height="30" src="{$imagesource}furniture/searchpage_icon.gif" width="31"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </td>
                                                <td valign="top" width="340">
                                                        <div class="titlefilmography">
                                                                <strong>
                                                                        <xsl:apply-templates mode="t_subjectlink" select="SUBJECT"/>
                                                                </strong>
                                                        </div>
                                                        <div class="smallsubmenu">
                                                                <xsl:if test="EXTRAINFO/TYPE/@ID &gt; 29 and EXTRAINFO/TYPE/@ID &lt; 36 and EXTRAINFO/DIRECTORSNAME">
                                                                        <xsl:choose>
                                                                                <xsl:when test="EXTRAINFO/DIRECTORSNAME/LINK">
                                                                                        <a class="textdark" href="{$root}{EXTRAINFO/DIRECTORSNAME/LINK/@DNAID}">
                                                                                                <xsl:value-of select="EXTRAINFO/DIRECTORSNAME/LINK/text()"/>
                                                                                        </a>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="EXTRAINFO/DIRECTORSNAME/text()"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose> | </xsl:if>
                                                                <xsl:choose>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 30">
                                                                                <a class="textdark" href="{$root}C{$genreDrama}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 31">
                                                                                <a class="textdark" href="{$root}C{$genreComedy}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 32">
                                                                                <a class="textdark" href="{$root}C{$genreDocumentry}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 33">
                                                                                <a class="textdark" href="{$root}C{$genreAnimation}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 34">
                                                                                <a class="textdark" href="{$root}C{$genreExperimental}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 35">
                                                                                <a class="textdark" href="{$root}C{$genreMusic}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype"/>
                                                                                </a>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 60">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=60 or @selectnumber=60]/@label"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 61">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=61 or @selectnumber=61]/@label"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 10">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=10 or @selectnumber=10]/@label"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 11">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=11 or @selectnumber=11]/@label"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 12">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=12 or @selectnumber=12]/@label"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 3001"> member profile </xsl:when>
                                                                        <xsl:when test="STATUS = 9"> site help </xsl:when>
                                                                        <xsl:otherwise>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                                <!-- region -->
                                                                <xsl:if test="EXTRAINFO/REGION"> | <xsl:choose>
                                                                                <xsl:when test="EXTRAINFO/FILMLENGTH_MINS">
                                                                                        <xsl:call-template name="LINK_REGION">
                                                                                                <xsl:with-param name="region">
                                                                                                    <xsl:value-of select="EXTRAINFO/REGION"/>
                                                                                                </xsl:with-param>
                                                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                                                        </xsl:call-template>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:call-template name="LINK_REGION">
                                                                                                <xsl:with-param name="region">
                                                                                                    <xsl:value-of select="EXTRAINFO/REGION"/>
                                                                                                </xsl:with-param>
                                                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                                                        </xsl:call-template>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:if>
                                                                <xsl:if test="EXTRAINFO/FILMLENGTH_MINS"> | <xsl:choose>
                                                                                <xsl:when test="EXTRAINFO/FILMLENGTH_MINS > 0">
                                                                                        <xsl:call-template name="LINK_MINUTES">
                                                                                                <xsl:with-param name="minutes">
                                                                                                    <xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/>
                                                                                                </xsl:with-param>
                                                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                                                        </xsl:call-template>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <a class="textdark" href="{$root}C{$length2}"><xsl:value-of select="EXTRAINFO/FILMLENGTH_SECS"/> sec</a>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:if>
                                                        </div>
                                                        <!-- show poll dots  templates sits in categorypage.xsl -->
                                                        <xsl:apply-templates mode="show_dots" select="POLL[STATISTICS/@VOTECOUNT &gt; 0][@HIDDEN = 0]"/>
                                                        <!-- show log line -->
                                                        <xsl:if test="(EXTRAINFO/TYPE/@ID &gt; 29 and EXTRAINFO/TYPE/@ID &lt; 36) or EXTRAINFO/TYPE/@ID=63">
                                                                <div class="padrightpara">
                                                                        <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                                </div>
                                                        </xsl:if>
                                                </td>
                                        </tr>
                                        <xsl:if test="following-sibling::ARTICLERESULT[PRIMARYSITE=1]">
                                                <tr>
                                                        <td colspan="2" height="10" width="371"/>
                                                </tr>
                                                <tr>
                                                        <td colspan="2" height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                        </xsl:if>
                                        <tr>
                                                <td colspan="2" height="10" width="371"/>
                                        </tr>
                                </xsl:otherwise>
                        </xsl:choose>
                </table>
        </xsl:template>
        <xsl:template match="USERRESULT" mode="r_search">
                <tr>
                        <xsl:attribute name="class">
                                <xsl:choose>
                                        <xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 0">colourbar1</xsl:when>
                                        <xsl:otherwise>colourbar2</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                        <td>
                                <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
                                        <strong>
                                                <xsl:apply-templates mode="t_userlink" select="USERNAME"/>
                                        </strong>
                                </xsl:element>
                        </td>
                </tr>
        </xsl:template>
        <xsl:template match="FORUMRESULT" mode="r_search">
                <tr>
                        <xsl:attribute name="class">
                                <xsl:choose>
                                        <xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 0">colourbar1</xsl:when>
                                        <xsl:otherwise>colourbar2</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                        <td>
                                <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
                                        <strong>
                                                <xsl:apply-templates mode="t_postlink" select="SUBJECT"/>
                                        </strong>
                                        <br/>
                                </xsl:element>
                        </td>
                </tr>
        </xsl:template>
        <xsl:template name="ABCLINKS"><!-- added by trent -->
                <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=.</xsl:text>
                        </xsl:attribute>
                        <xsl:text>#</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=A</xsl:text>
                        </xsl:attribute>
                        <xsl:text>A</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=B</xsl:text>
                        </xsl:attribute>
                        <xsl:text>B</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=C</xsl:text>
                        </xsl:attribute>
                        <xsl:text>C</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=D</xsl:text>
                        </xsl:attribute>
                        <xsl:text>D</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=E</xsl:text>
                        </xsl:attribute>
                        <xsl:text>E</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=F</xsl:text>
                        </xsl:attribute>
                        <xsl:text>F</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=G</xsl:text>
                        </xsl:attribute>
                        <xsl:text>G</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=H</xsl:text>
                        </xsl:attribute>
                        <xsl:text>H</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=I</xsl:text>
                        </xsl:attribute>
                        <xsl:text>I</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=J</xsl:text>
                        </xsl:attribute>
                        <xsl:text>J</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=K</xsl:text>
                        </xsl:attribute>
                        <xsl:text>K</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=L</xsl:text>
                        </xsl:attribute>
                        <xsl:text>L</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=M</xsl:text>
                        </xsl:attribute>
                        <xsl:text>M</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=N</xsl:text>
                        </xsl:attribute>
                        <xsl:text>N</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=O</xsl:text>
                        </xsl:attribute>
                        <xsl:text>O</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=P</xsl:text>
                        </xsl:attribute>
                        <xsl:text>P</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=Q</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Q</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=R</xsl:text>
                        </xsl:attribute>
                        <xsl:text>R</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=S</xsl:text>
                        </xsl:attribute>
                        <xsl:text>S</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=T</xsl:text>
                        </xsl:attribute>
                        <xsl:text>T</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=U</xsl:text>
                        </xsl:attribute>
                        <xsl:text>U</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=V</xsl:text>
                        </xsl:attribute>
                        <xsl:text>V</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=W</xsl:text>
                        </xsl:attribute>
                        <xsl:text>W</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=X</xsl:text>
                        </xsl:attribute>
                        <xsl:text>X</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=Y</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Y</xsl:text>
                </a>
                <xsl:text> </xsl:text><span class="pipe">|</span>&nbsp; <a>
                        <xsl:attribute name="href">
                                <xsl:value-of select="$root"/>
                                <xsl:text>index?submit=new&amp;official=on&amp;show=25&amp;let=Z</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Z</xsl:text>
                </a>
        </xsl:template>
        <!-- POLL results -->
        <xsl:template match="POLL" mode="r_search">
                <div class="smallsubmenu">
                        <xsl:text>Average rating: </xsl:text>
                        <xsl:value-of select="STATISTICS/@AVERAGERATING"/>
                        <br/>
                        <xsl:text>Number of votes:  </xsl:text>
                        <xsl:value-of select="STATISTICS/@VOTECOUNT"/>
                        <br/>
                </div>
        </xsl:template>
</xsl:stylesheet>
