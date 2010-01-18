<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-categorypage.xsl"/>
        <!-- this var determines how results are displayed -->
        <xsl:variable name="diplaytype">
                <xsl:choose>
                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $filmIndexPage">film</xsl:when>
                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage">member</xsl:when>
                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage">magazine</xsl:when>
                        <xsl:otherwise>member</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:template name="CATEGORY_HEADER">
                <xsl:apply-templates mode="header" select=".">
                        <xsl:with-param name="title">
                                <xsl:value-of select="$m_pagetitlestart"/>
                                <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
                        </xsl:with-param>
                </xsl:apply-templates>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="CATEGORY_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">CATEGORY_MAINBODY</xsl:with-param>
                        <xsl:with-param name="pagename">categorypage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                        <div class="debug">
                                <strong>HIERARCHYDETAILS</strong><br/> DISPLAYNAME = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/><br/> @NODEID = <xsl:value-of
                                        select="/H2G2/HIERARCHYDETAILS/@NODEID"/><br/> ANCESTOR[2] = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME"/><br/> ANCESTOR[3] =
                                        <xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NAME"/><br/> variable for testing ANCESTOR[3] = $<xsl:choose>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byLengthPage">byLengthPage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byGenrePage">byGenrePage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byRegionPage">byRegionPage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $membersPlacePage">membersPlacePage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $membersSpecialismPage">membersSpecialismPage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID =       $membersIndustryPanel">membersIndustryPanel</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage">byThemePage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byDistributorPage">byDistributorPage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $organizationPage">organizationPage</xsl:when>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byFestivalPage">byFestivalPage</xsl:when>
                                </xsl:choose><br/> $diplaytype = <xsl:value-of select="$diplaytype"/><br/>
                        </div>
                </xsl:if>
                <xsl:choose>
                        <xsl:when test="not(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2])">
                                <!-- top level index -->
                                <!-- list all sub categories for films catalogue or people directory -->
                                <xsl:apply-templates mode="c_category" select="HIERARCHYDETAILS"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- 2nd level index -->
                                <!-- show all films in certain category -->
                                <xsl:apply-templates mode="c_issue" select="HIERARCHYDETAILS"/>
                        </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                        <div class="debug">
                                <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/><br/>
                                <br/> /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER <table border="1" cellpadding="0" cellspacing="0" style="font-size:100%;">
                                        <tr>
                                                <th>no.</th>
                                                <th>name</th>
                                                <th>nodeid</th>
                                        </tr>
                                        <xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER">
                                                <tr>
                                                        <td valign="top">
                                                                <xsl:value-of select="position()"/>
                                                        </td>
                                                        <td>
                                                                <a href="{$root}C{NODEID}">
                                                                        <xsl:value-of select="NAME"/>
                                                                </a>
                                                                <ol>
                                                                        <xsl:for-each select="SUBNODES/SUBNODE">
                                                                                <li><a href="{$root}C{@ID}">
                                                                                                <xsl:value-of select="."/>
                                                                                        </a> - <xsl:value-of select="@ID"/></li>
                                                                        </xsl:for-each>
                                                                </ol>
                                                        </td>
                                                        <td valign="top">
                                                                <xsl:value-of select="NODEID"/>
                                                        </td>
                                                </tr>
                                        </xsl:for-each>
                                </table>
                                <br/> /H2G2/HIERARCHYDETAILS/CLOSEMEMBERS/ARTICLEMEMBER <table border="1" cellpadding="0" cellspacing="0" style="font-size:100%;">
                                        <tr>
                                                <th>no.</th>
                                                <th>NAME</th>
                                                <th>H2G2ID</th>
                                        </tr>
                                        <xsl:for-each select="/H2G2/HIERARCHYDETAILS/CLOSEMEMBERS/ARTICLEMEMBER">
                                                <tr>
                                                        <td>
                                                                <xsl:value-of select="position()"/>
                                                        </td>
                                                        <td>
                                                                <a href="{$root}A{H2G2ID}">
                                                                        <xsl:value-of select="NAME"/>
                                                                </a>
                                                        </td>
                                                        <td>
                                                                <xsl:value-of select="H2G2ID"/>
                                                        </td>
                                                </tr>
                                        </xsl:for-each>
                                </table>
                        </div>
                </xsl:if>
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
                <h1 class="directory">
                        <xsl:value-of select="DISPLAYNAME"/>
                </h1>
                <xsl:if test="$filmIndexPage = @NODEID">
                        <!-- main panel : a-z -->
                        <table border="0" cellpadding="0" cellspacing="0" class="directoryItem" width="635">
                                <tr>
                                        <td valign="top">
                                                <img alt="A-Z icon" height="75" src="{$imagesource}furniture/directory/atoz.gif" width="75"/>
                                        </td>
                                        <td valign="top" width="635">
                                                <h2>
                                                        <img alt="by title" height="29" src="{$imagesource}furniture/directory/bytitle.gif" width="81"/>
                                                </h2>
                                                <div class="atoz">
                                                        <xsl:call-template name="ABCLINKS"/>
                                                </div>
                                        </td>
                                </tr>
                        </table>
                </xsl:if>
                <xsl:apply-templates mode="c_category" select="MEMBERS"/>
                <!-- darren: added industry professional image link -->
                <!--<xsl:if test="$directoryPage = /H2G2/HIERARCHYDETAILS/@NODEID">
			<table border="0" cellpadding="0" cellspacing="0" class="directoryItem"
				width="635">
				<tr>
					<td valign="top">
						<div class="mainpanelicon">
							<img alt="" height="75"
								src="{$imagesource}furniture/directory/panelicon-copy.gif"
								width="75" />
						</div>
					</td>
					<td valign="top" width="635">
						<h2>
							<a href="http://www.bbc.co.uk/dna/filmnetwork/industrypanel">
								<img alt="industry panel" height="29"
									src="{$imagesource}furniture/directory/filmnetwork/industrypanel.gif"
									width="261" />
							</a>
						</h2>
					</td>
				</tr>
			</table>
		</xsl:if>-->
                <!-- search panel -->
                <h2 id="search">or search</h2>
                <form action="{$root}Search" id="filmindexsearch" method="get" name="filmindexsearch" xsl:use-attribute-sets="fc_search_dna">
                        <table border="0" cellpadding="0" cellspacing="0" width="635">
                                <tr>
                                        <td align="right" class="webboxbg" height="96" valign="top" width="98">
                                                <img alt="Search icon" height="75" id="searchIcon" src="{$imagesource}furniture/directory/search.gif" width="75"/>
                                        </td>
                                        <td class="webboxbg" valign="top" width="465">
                                                <div class="searchline">I am looking for</div>
                                                <div class="searchback"><xsl:call-template name="r_search_dna2"
                                                                /><!-- <input name="textfield" type="text" size="10" class="searchinput"/> -->&nbsp;&nbsp;<input alt="search" name="dosearch"
                                                                src="{$imagesource}furniture/directory/search1.gif" type="image"/></div>
                                        </td>
                                        <td class="webboxbg" valign="top" width="72">
                                                <img alt="" height="39" src="{$imagesource}furniture/filmindex/angle.gif" width="72"/>
                                        </td>
                                </tr>
                        </table>
                </form>
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
                <xsl:apply-templates mode="c_category" select="ANCESTOR"/>
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
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byLengthPage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byThemePage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byGenrePage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byDistributorPage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byRegionPage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $byBritishFilmSeason]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $membersPlacePage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $membersSpecialismPage]"/>
                <xsl:apply-templates mode="c_category" select="SUBJECTMEMBER[NODEID = $membersIndustryPanel]"/>
                <xsl:apply-templates mode="c_category" select="ARTICLEMEMBER"/>
                <xsl:apply-templates mode="c_category" select="NODEALIASMEMBER"/>
                <xsl:apply-templates mode="c_category" select="CLUBMEMBER"/>
        </xsl:template>
        <!--
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
	Use: Presentation of a node if it is a subject (contains other nodes)
	 -->
        <xsl:template match="SUBJECTMEMBER" mode="r_category">
                <!-- @@CV@@ maybe choose here. when = people. otherwise (film) 
			for film:
				careful because distributor, organisation, festival are top level cats, but
			treated as sub level cats for the index page (each with their own third level cats) -->
                <xsl:choose>
                        <xsl:when test="NODEID = $byDistributorPage">
                                <table border="0" cellpadding="0" cellspacing="0" class="directoryItem" id="bySelection" width="635">
                                        <tr>
                                                <td valign="top">
                                                        <img alt="duration icon" height="75" src="{$imagesource}furniture/directory/organicon.gif" width="75"/>
                                                </td>
                                                <td valign="top" width="635">
                                                        <h2>
                                                                <img alt="by selection" height="29" src="{$imagesource}furniture/directory/byselection.gif" width="145"/>
                                                        </h2>
                                                        <!-- display categories as 3 column table -->
                                                        <h3>distributor</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byDistributorPage]/SUBNODES"/>
                                                        <h3>organisation</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byOrganisationPage]/SUBNODES"/>
                                                        <h3>festival and competition</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byFestivalPage]/SUBNODES"/>
                                                        <h3>film school/university</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $bySchoolsPage]/SUBNODES"/>
                                                        <h3>production company</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byCompanyPage]/SUBNODES"/>
                                                        <h3>record label</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byLabelPage]/SUBNODES"/>
                                                        <h3>access options</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID = $byAccessPage]/SUBNODES"/>
                                                        <h3>screen agency</h3>
                                                        <xsl:apply-templates mode="c_category" select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER[NODEID =         $byScreenAgency]/SUBNODES"/>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:when>
                        <xsl:when test="$byFestivalPage = NODEID"/>
                        <xsl:when test="$byOrganisationPage = NODEID"/>
                        <xsl:otherwise>
                                <!-- main panel : organisations -->
                                <table border="0" cellpadding="0" cellspacing="0" class="directoryItem" width="635">
                                        <tr>
                                                <td valign="top">
                                                        <!-- BEGIN Large Icons -->
                                                        <!-- for debugging purpose -->
                                                        <xsl:comment>NODEID: <xsl:value-of select="NODEID"/></xsl:comment>
                                                        <!-- /end for debugging purpose -->
                                                        <div class="mainpanelicon">
                                                                <xsl:choose>
                                                                        <xsl:when test="$filmIndexPage = /H2G2/HIERARCHYDETAILS/@NODEID">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="$byGenrePage = NODEID">
                                                                                                <img alt="genre icon" height="75" src="{$imagesource}furniture/directory/genre2.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byRegionPage = NODEID">
                                                                                                <img alt="region icon" height="75" src="{$imagesource}furniture/directory/region.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byLengthPage = NODEID">
                                                                                                <img alt="duration icon" height="75" src="{$imagesource}furniture/directory/duration.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byThemePage = NODEID">
                                                                                                <img alt="theme icon" height="75" src="{$imagesource}furniture/directory/theme.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byBritishFilmSeason = NODEID">
                                                                                                <img alt="british icon" height="77" src="{$imagesource}furniture/directory/british.gif" width="77"/>
                                                                                        </xsl:when>
                                                                                        <!-- for debugging purpose -->
                                                                                        <xsl:otherwise>
                                                                                                <xsl:comment>otherwise (NODEID: <xsl:value-of select="NODEID"/>)</xsl:comment>
                                                                                        </xsl:otherwise>
                                                                                        <!-- /end for debugging purpose -->
                                                                                </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="$directoryPage = /H2G2/HIERARCHYDETAILS/@NODEID">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="$membersPlacePage = NODEID">
                                                                                                <img alt="" height="75" src="{$imagesource}furniture/directory/region.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$membersSpecialismPage = NODEID">
                                                                                                <img alt="" height="75" src="{$imagesource}furniture/directory/membersicon.gif" width="75"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$membersIndustryPanel = NODEID">
                                                                                                <img alt="industry panel" height="75" src="{$imagesource}furniture/directory/panelicon-copy.gif"
                                                                                                    width="75"/>
                                                                                        </xsl:when>
                                                                                </xsl:choose>
                                                                        </xsl:when>
                                                                </xsl:choose>
                                                        </div>
                                                </td>
                                                <td valign="top" width="635">
                                                        <!-- Section Header -->
                                                        <!-- for debugging purpose -->
                                                        <xsl:comment>NODEID: <xsl:value-of select="NODEID"/></xsl:comment>
                                                        <!-- /end for debugging purpose -->
                                                        <h2>
                                                                <xsl:choose>
                                                                        <xsl:when test="$filmIndexPage = /H2G2/HIERARCHYDETAILS/@NODEID">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="$byGenrePage = NODEID">
                                                                                                <img alt="by genre" height="29" name="genre" src="{$imagesource}furniture/directory/bygenre1.gif"
                                                                                                    width="136"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byRegionPage = NODEID">
                                                                                                <img alt="by place" height="29" name="region" src="{$imagesource}furniture/directory/byregion1.gif"
                                                                                                    width="136"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byLengthPage = NODEID">
                                                                                                <img alt="by duration" height="29" name="duration"
                                                                                                    src="{$imagesource}furniture/directory/byduration1.gif" width="136"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byThemePage = NODEID">
                                                                                                <img alt="by theme" height="29" name="genre" src="{$imagesource}furniture/directory/bytheme.gif"
                                                                                                    width="115"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$byBritishFilmSeason = NODEID">
                                                                                                <img alt="by summer of British film" height="27" name="british"
                                                                                                    src="{$imagesource}furniture/directory/bysummerbritishfilm.gif" width="307"/>
                                                                                        </xsl:when>
                                                                                        <!-- for debugging purpose -->
                                                                                        <xsl:otherwise>
                                                                                                <xsl:comment>otherwise (NODEID: <xsl:value-of select="NODEID"/>)</xsl:comment>
                                                                                        </xsl:otherwise>
                                                                                        <!-- /end for debugging purpose -->
                                                                                </xsl:choose>
                                                                        </xsl:when>
                                                                        <xsl:when test="$directoryPage = /H2G2/HIERARCHYDETAILS/@NODEID">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="$membersPlacePage = NODEID">
                                                                                                <img alt="member by place" height="29" src="{$imagesource}furniture/directory/people_by_place.gif"
                                                                                                    width="194"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$membersSpecialismPage = NODEID">
                                                                                                <img alt="people by specialism" height="29"
                                                                                                    src="{$imagesource}furniture/directory/people_by_specialism.gif" width="261"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$membersIndustryPanel = NODEID">
                                                                                                <img alt="industry panel" height="29"
                                                                                                    src="{$imagesource}furniture/directory/filmnetwork/industrypanel.gif" width="261"/>
                                                                                        </xsl:when>
                                                                                </xsl:choose>
                                                                        </xsl:when>
                                                                </xsl:choose>
                                                        </h2>
                                                    <xsl:choose>
                                                        <xsl:when test="$membersIndustryPanel = NODEID">
                                                            <!-- hard coded links to the industry panel page -->
                                                            <table cellspacing="1" cellpadding="1" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td width="187">
                                                                            <a href="/dna/filmnetwork/industrypanel#members">Film Organisation Panellists</a>
                                                                        </td>
                                                                        <td width="187">
                                                                            <a href="/dna/filmnetwork/industrypanel#festivals">Film Festival Panellists</a>
                                                                        </td>
                                                                        <td width="187">
                                                                            <a href="/dna/filmnetwork/industrypanel#agents">Literary &amp; Talent Agents</a>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="187">
                                                                            <a href="/dna/filmnetwork/industrypanel#Productioncompanies">Production Company Panellists</a>
                                                                        </td>
                                                                        <td width="187">
                                                                            <a href="/dna/filmnetwork/industrypanel#regionalpanel">Screen Agency Panellists</a>
                                                                        </td>
                                                                        <td width="187"></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <!-- display categories as 3 column table -->
                                                            <xsl:apply-templates mode="c_category" select="SUBNODES"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="NAME" mode="t_nodename">
	Author:		Trent
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      subject name no link, was using terminal template before
	-->
        <xsl:template match="NAME" mode="r_nodename">
                <h3>
                        <xsl:value-of select="."/>
                </h3>
                <!-- </a> -->
        </xsl:template>
        <!--
	<xsl:template match="SUBNODES" mode="r_category">
	Use: Presentation of the subnodes logical container
	 -->
        <xsl:template match="SUBNODES" mode="r_category">
                <!-- Need to work out an elegant way of doing this -->
                <xsl:variable name="numberOfSubnodes" select="count(child::SUBNODE)"/>
                <xsl:value-of disable-output-escaping="yes" select="'&lt;table border=0 cellspacing=1 cellpadding=0&gt;'"/>
                <xsl:for-each select="SUBNODE">
                        <xsl:sort/>
                        <xsl:if test="position() mod 3 = 1">
                                <xsl:choose>
                                        <xsl:when test="position() = $numberOfSubnodes">
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;tr&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:apply-templates mode="r_category" select="."/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/tr&gt;'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;tr&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:apply-templates mode="r_category" select="."/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:if>
                        <xsl:if test="position() mod 3 = 2">
                                <xsl:choose>
                                        <xsl:when test="position() = $numberOfSubnodes">
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:apply-templates mode="r_category" select="."/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/tr&gt;'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                                <xsl:apply-templates mode="r_category" select="."/>
                                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:if>
                        <xsl:if test="position() mod 3 = 0">
                                <xsl:value-of disable-output-escaping="yes" select="'&lt;td width=187&gt;'"/>
                                <xsl:apply-templates mode="r_category" select="."/>
                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/tr&gt;'"/>
                        </xsl:if>
                </xsl:for-each>
                <xsl:value-of disable-output-escaping="yes" select="'&lt;/table&gt;'"/>
        </xsl:template>
        <!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Use: Presenttaion of a subnode, ie the contents of a SUBJECTMEMBER node
	 -->
        <xsl:template match="SUBNODE" mode="r_category">
                <a href="{$root}C{@ID}">
                        <xsl:value-of select="."/>
                </a>
        </xsl:template>
        <!-- ALISTAIR: you are going to need to change the current design ( item | item | item ) to use a table layout. This will take some creative use of paramaters and using recursion. you will encounter some issues with keeping up with the context node. -->
        <xsl:template name="menu_items">
                <a href="{$root}C{@ID}" xsl:use-attribute-sets="mSUBNODE_r_subnodename">
                        <xsl:value-of select="."/>
                </a>
                <xsl:if test="following-sibling::*[1][local-name()= 'SUBNODE'] ">
                        <xsl:text>&nbsp;&nbsp;|&nbsp;&nbsp;</xsl:text>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="zero_category">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="zero_subject"> [<xsl:value-of select="$m_nomembers"/>] </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="one_category">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="one_subject"> [1<xsl:value-of select="$m_member"/>] </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="many_category">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="many_subject"> [<xsl:apply-imports/>
                <xsl:value-of select="$m_members"/>] </xsl:template>
        <!--
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
	Use: Presentation of an node if it is an article
	 -->
        <xsl:template match="ARTICLEMEMBER" mode="r_category">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="NODEALIASMEMBER" mode="r_category">
	Use: Presentation of a node if it is a nodealias
	 -->
        <xsl:template match="NODEALIASMEMBER" mode="r_category">
                <xsl:apply-templates mode="t_nodealiasname" select="NAME"/>
                <xsl:apply-templates mode="c_nodealias" select="NODECOUNT"/>
                <xsl:if test="SUBNODES/SUBNODE">
                        <br/>
                </xsl:if>
                <xsl:apply-templates mode="c_category" select="SUBNODES"/>
                <br/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="NODEALIASMEMBER" mode="zero_category">
	Use: Used if a NODEALIASMEMBER has 0 nodes contained in it
	 -->
        <xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="zero_nodealias"> [<xsl:value-of select="$m_nomembers"/>] </xsl:template>
        <!--
	<xsl:template match="NODEALIASMEMBER" mode="one_category">
	Use: Used if a NODEALIASMEMBER has 1 node contained in it
	 -->
        <xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="one_nodealias"> [1<xsl:value-of select="$m_member"/>] </xsl:template>
        <!--
	<xsl:template match="NODEALIASMEMBER" mode="many_category">
	Use: Used if a NODEALIASMEMBER has more than 1 nodes contained in it
	 -->
        <xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="many_nodealias"> [<xsl:apply-imports/>
                <xsl:value-of select="$m_members"/>] </xsl:template>
        <!--
	<xsl:template match="CLUBMEMBER" mode="r_category">
	Use: Presentation of a node if it is a club
	 -->
        <xsl:template match="CLUBMEMBER" mode="r_category">
                <xsl:apply-templates mode="t_clubname" select="NAME"/>
                <xsl:apply-templates mode="c_clubdescription" select="EXTRAINFO/DESCRIPTION"/>
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
                <!-- Breadcrumb -->
                <div class="crumbtop">
                        <span class="textmedium">
                                <xsl:choose>
                                        <xsl:when test="$diplaytype = 'magazine'">
                                                <a href="{$root}magazine">
                                                        <strong>
                                                                <xsl:value-of select="ANCESTRY/ANCESTOR[2]/NAME"/>
                                                        </strong>
                                                </a>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <a href="C{ANCESTRY/ANCESTOR[2]/NODEID}">
                                                        <strong>
                                                                <xsl:value-of select="ANCESTRY/ANCESTOR[2]/NAME"/>
                                                        </strong>
                                                </a>
                                        </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text> </xsl:text>|</span>
                        <xsl:text> </xsl:text>
                        <span class="textxlarge">
                                <xsl:value-of select="DISPLAYNAME"/>
                        </span>
                </div>
                <!-- location box
			displayed on film pages when they are 'by genre' or 'by theme' or 'magazine'
		-->
                <xsl:if test="ANCESTRY/ANCESTOR[3]/NODEID = $byGenrePage or ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage or ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage">
                        <table border="0" cellpadding="0" cellspacing="0" width="635">
                                <tr>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="371"/>
                                        </td>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="20"/>
                                        </td>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="244"/>
                                        </td>
                                </tr>
                                <tr>
                                        <td class="topbg" height="97" valign="top">
                                                <div class="youAreBrowsing">
                                                        <strong>You are browsing <xsl:choose>
                                                                        <xsl:when test="ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage"> the magazine archive </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:value-of select="ANCESTRY/ANCESTOR[3]/NAME"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </strong>
                                                </div>
                                                <div class="browseTitle">
                                                        <strong>
                                                                <xsl:value-of select="DISPLAYNAME"/>
                                                        </strong>
                                                </div>
                                                <div class="topboxDescription">
                                                        <xsl:value-of select="DESCRIPTION"/>
                                                </div>
                                        </td>
                                        <td class="verticaldivider" valign="top">
                                                <img height="30" src="{$imagesource}furniture/myprofile/verticalcap.gif" width="20"/>
                                        </td>
                                        <td class="topbg" valign="top">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                                <td class="browseInfoText" valign="top">
                                                                        <xsl:choose>
                                                                                <xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage">
                                                                                        <strong>browse by another theme</strong>
                                                                                        <xsl:call-template name="drop_down">
                                                                                                <xsl:with-param name="category" select="'theme'"/>
                                                                                        </xsl:call-template>
                                                                                </xsl:when>
                                                                                <xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byGenrePage">
                                                                                        <strong>browse by another genre</strong>
                                                                                        <xsl:call-template name="drop_down">
                                                                                                <xsl:with-param name="category" select="'genre'"/>
                                                                                        </xsl:call-template>
                                                                                </xsl:when>
                                                                                <xsl:when test="ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage">
                                                                                        <strong>browse other magazine archives</strong>
                                                                                        <xsl:call-template name="drop_down">
                                                                                                <xsl:with-param name="category" select="'magazine'"/>
                                                                                        </xsl:call-template>
                                                                                </xsl:when>
                                                                        </xsl:choose>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </td>
                                </tr>
                        </table>
                        <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                        <br/>
                </xsl:if>
                <!-- location box
			display on member index pages
		-->
                <xsl:if test="$diplaytype = 'member'">
                        <table border="0" cellpadding="0" cellspacing="0" width="635">
                                <tr>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="371"/>
                                        </td>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="20"/>
                                        </td>
                                        <td>
                                                <img alt="" class="tiny" height="1" src="f/t.gif" width="244"/>
                                        </td>
                                </tr>
                                <tr>
                                        <td class="topbg" height="97" valign="top">
                                                <div class="youAreBrowsing">
                                                        <strong>You are browsing <xsl:value-of select="ANCESTRY/ANCESTOR[3]/NAME"/></strong>
                                                </div>
                                                <div class="listedUnder">These are the members listed under</div>
                                                <div class="browseTitle">
                                                        <strong>
                                                                <xsl:value-of select="DISPLAYNAME"/>
                                                        </strong>
                                                </div>
                                        </td>
                                        <td class="verticaldivider" valign="top">
                                                <img height="30" src="{$imagesource}furniture/myprofile/verticalcap.gif" width="20"/>
                                        </td>
                                        <td class="topbg" valign="top">
                                                <table border="0" cellpadding="0" cellspacing="0" width="165">
                                                        <tr>
                                                                <td class="infoIcon" valign="top">
                                                                        <img alt="i" height="16" src="{$imagesource}furniture/icon_info.gif" width="16"/>
                                                                </td>
                                                                <td class="browseInfoText" valign="top">
                                                                        <strong>
                                                                                <a href="{$root}SiteHelpProfile#place">how do I add myself to this page?</a>
                                                                        </strong>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </td>
                                </tr>
                        </table>
                        <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                        <br/>
                </xsl:if>
                <!-- insert guideML that appears at the top of the page - except genre pages as have guideML from phase 1
		Can remove this conditional once the guideML is removed from the genre pages -->
                <xsl:if test="ANCESTRY/ANCESTOR[3]/NODEID !=$byGenrePage">
                        <xsl:apply-templates select="ARTICLE/GUIDE/BODY/CATEGORYHEAD"/>
                </xsl:if>
                <!-- select page specific top content area -->
                <xsl:choose>
                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byLengthPage">
                                <!-- time dial rollover table -->
                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                        <tr>
                                                <!-- change mouseover gif to stay on when it's cat is selected -->
                                                <xsl:variable name="length2_img">
                                                        <xsl:choose>
                                                                <xsl:when test="$thisCatPage = $length2">2</xsl:when>
                                                                <xsl:otherwise>1</xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <td align="right" valign="top" width="121">
                                                        <div class="dialpad">
                                                                <a onmouseout="swapImage('dial1', '{$imagesource}furniture/filmlength/dialundertwo{$length2_img}.gif')"
                                                                        onmouseover="swapImage('dial1', '{$imagesource}furniture/filmlength/dialundertwo2.gif')">
                                                                        <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of select="$length2"/></xsl:attribute>
                                                                        <img alt="0 - 2 min dial" height="145" id="dial1" name="dial1"
                                                                                src="{$imagesource}furniture/filmlength/dialundertwo{$length2_img}.gif" width="120"/>
                                                                </a>
                                                        </div>
                                                </td>
                                                <xsl:variable name="length2_5_img">
                                                        <xsl:choose>
                                                                <xsl:when test="$thisCatPage = $length2_5">2</xsl:when>
                                                                <xsl:otherwise>1</xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <td valign="top" width="51">
                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="51"/>
                                                </td>
                                                <td valign="top" width="120">
                                                        <a onmouseout="swapImage('dial2', '{$imagesource}furniture/filmlength/dialtwofive{$length2_5_img}.gif')"
                                                                onmouseover="swapImage('dial2', '{$imagesource}furniture/filmlength/dialtwofive2.gif')">
                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of select="$length2_5"/></xsl:attribute>
                                                                <img alt="2-5 min dial" height="145" id="dial2" name="dial2" src="{$imagesource}furniture/filmlength/dialtwofive{$length2_5_img}.gif"
                                                                        width="120"/>
                                                        </a>
                                                </td>
                                                <xsl:variable name="length5_10_img">
                                                        <xsl:choose>
                                                                <xsl:when test="$thisCatPage = $length5_10">2</xsl:when>
                                                                <xsl:otherwise>1</xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <td valign="top" width="52">
                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="52"/>
                                                </td>
                                                <td valign="top" width="120">
                                                        <a onmouseout="swapImage('dial3', '{$imagesource}furniture/filmlength/dialfiveten{$length5_10_img}.gif')"
                                                                onmouseover="swapImage('dial3', '{$imagesource}furniture/filmlength/dialfiveten2.gif')">
                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of select="$length5_10"/></xsl:attribute>
                                                                <img alt="5-10 min dial" height="145" id="dial3" name="dial3" src="{$imagesource}furniture/filmlength/dialfiveten{$length5_10_img}.gif"
                                                                        width="120"/>
                                                        </a>
                                                </td>
                                                <xsl:variable name="length10_20_img">
                                                        <xsl:choose>
                                                                <xsl:when test="$thisCatPage = $length10_20">2</xsl:when>
                                                                <xsl:otherwise>1</xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <td valign="top" width="51">
                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="51"/>
                                                </td>
                                                <td valign="top" width="120">
                                                        <a onmouseout="swapImage('dial4', '{$imagesource}furniture/filmlength/dialoverten{$length10_20_img}.gif')"
                                                                onmouseover="swapImage('dial4', '{$imagesource}furniture/filmlength/dialoverten2.gif')">
                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of select="$length10_20"/></xsl:attribute>
                                                                <img alt="10 - 20 min dial" height="145" id="dial4" name="dial4"
                                                                        src="{$imagesource}furniture/filmlength/dialoverten{$length10_20_img}.gif" width="120"/>
                                                        </a>
                                                </td>
                                        </tr>
                                </table>
                                <!-- END time dial rollover table -->
                                <div class="timeheader">
                                        <xsl:choose>
                                                <xsl:when test="$thisCatPage = $length2">
                                                        <img alt="duration: under 2 minutes" height="16" src="{$imagesource}furniture/filmlength/durunder2min.gif" width="166"/>
                                                </xsl:when>
                                                <xsl:when test="$thisCatPage = $length2_5">
                                                        <img alt="duration: 2 - 5 minutes" height="16" src="{$imagesource}furniture/filmlength/dur2to5.gif" width="137"/>
                                                </xsl:when>
                                                <xsl:when test="$thisCatPage = $length5_10">
                                                        <img alt="duration: 5 - 10 minutes" height="16" src="{$imagesource}furniture/filmlength/dur5to10.gif" width="146"/>
                                                </xsl:when>
                                                <xsl:when test="$thisCatPage = $length10_20">
                                                        <img alt="duration: 10 - 20 minutes" height="16" src="{$imagesource}furniture/filmlength/dur10to20.gif" width="152"/>
                                                </xsl:when>
                                        </xsl:choose>
                                </div>
                        </xsl:when>
                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $byRegionPage">
                                <!-- maps -->
                                <xsl:call-template name="getRegionImagemaps"/>
                        </xsl:when>
                </xsl:choose>
                <!-- END select page specific top content area -->
                <!-- begin 2 col section -->
                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;" width="635">
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
                                <!-- end Spacer row -->
                                <td valign="top">
                                        <xsl:choose>
                                                <xsl:when test="count(MEMBERS/ARTICLEMEMBER) &gt; 0">
                                                        <!-- sort by-->
                                                        <xsl:choose>
                                                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $filmIndexPage">
                                                                        <!-- sort links for a film index -->
                                                                        <div class="sortBy">
                                                                                <div class="sortTitle">sort by</div>
                                                                                <div class="sortLinks">
                                                                                        <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'name'"> name </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=name">name</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> | <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'rating'"> rating </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=rating">rating</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> | <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'duration'"> duration </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=duration">duration</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> | <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'genre'"> genre </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=genre">genre</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> | <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'date'"> published date </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=date">published date</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> | <xsl:choose>
                                                                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'place'"> place </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <a href="{$root}C{$thisCatPage}?s_sort=place">place</a>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                </div>
                                                                        </div>
                                                                </xsl:when>
                                                                <!-- 'sort by' options for people directory page -->
                                                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage"> </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:apply-templates mode="c_articlemembers" select="MEMBERS"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td class="darkestbg" height="2"/>
                                                                </tr>
                                                        </table>
                                                        <div class="textmedium"><br/>There are currently no&nbsp; <xsl:choose>
                                                                        <xsl:when test="ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage">members in</xsl:when>
                                                                        <xsl:otherwise>films listed under</xsl:otherwise>
                                                                </xsl:choose> &nbsp;<strong>
                                                                        <xsl:value-of select="DISPLAYNAME"/>
                                                                </strong><br/><br/></div>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                                                <div class="debug">
                                                        <table border="1" cellpadding="0" cellspacing="0" style="font-size:100%;">
                                                                <tr>
                                                                        <th>position()</th>
                                                                        <th>NAME</th>
                                                                        <th>type</th>
                                                                        <th>status</th>
                                                                        <th>date</th>
                                                                </tr>
                                                                <xsl:for-each select="MEMBERS/ARTICLEMEMBER">
                                                                        <tr>
                                                                                <td>
                                                                                        <xsl:value-of select="position()"/>
                                                                                </td>
                                                                                <td>
                                                                                        <a href="{$root}A{H2G2ID}">
                                                                                                <xsl:value-of select="NAME"/>
                                                                                        </a>
                                                                                </td>
                                                                                <td>
                                                                                        <xsl:value-of select="EXTRAINFO/TYPE/@ID"/>
                                                                                </td>
                                                                                <td>
                                                                                        <xsl:value-of select="STATUS/@TYPE"/>
                                                                                </td>
                                                                                <td><xsl:value-of select="DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of select="DATECREATED/DATE/@MONTHNAME"
                                                                                                />&nbsp;<xsl:value-of select="DATECREATED/DATE/@YEAR"/><xsl:text> </xsl:text><xsl:value-of
                                                                                                select="DATECREATED/DATE/@HOURS"/>:<xsl:value-of select="DATECREATED/DATE/@MINUTES"/>:<xsl:value-of
                                                                                                select="DATEPOSTED/DATE/@SECONDS"/></td>
                                                                        </tr>
                                                                </xsl:for-each>
                                                        </table>
                                                </div>
                                        </xsl:if>
                                        <!-- END film duration content table -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                        </table>
                                        <!-- nexp prev buttons -->
                                        <xsl:if test="count(/H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER) &gt; 0">
                                                <div class="gofilmindex">
                                                        <xsl:if test="$cat_skipto &gt; $category_max_length - 1">
                                                                <xsl:variable name="prevskip">
                                                                        <xsl:value-of select="$cat_skipto - $category_max_length"/>
                                                                </xsl:variable>
                                                                <strong><img alt="" height="7" src="{$imagesource}furniture/arrowdarkprev.gif" width="4"/>&nbsp;<a
                                                                                href="{$root}C{$thisCatPage}?s_skipto={$prevskip}">see previous <xsl:value-of select="DISPLAYNAME"/> films</a></strong>
                                                        </xsl:if>
                                                        <xsl:if test="count(/H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER) &gt; $category_max_length + $cat_skipto">&nbsp;&nbsp;&nbsp;
                                                                        <xsl:variable name="nextskip">
                                                                        <xsl:value-of select="$cat_skipto + $category_max_length"/>
                                                                </xsl:variable>
                                                                <strong><a href="{$root}C{$thisCatPage}?s_skipto={$nextskip}">see next <xsl:value-of select="DISPLAYNAME"/> films</a>&nbsp;<img
                                                                                alt="" height="7" src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4"/></strong>
                                                        </xsl:if>
                                                </div>
                                        </xsl:if>
                                        <!-- END 2px Black rule -->
                                        <div class="gofilmindex"><a>
                                                        <xsl:attribute name="href">
                                                                <xsl:value-of select="$root"/>
                                                                <xsl:choose>
                                                                        <xsl:when test="ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage"> magazine </xsl:when>
                                                                        <xsl:otherwise>C<xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:attribute>
                                                        <strong>
                                                                <xsl:choose>
                                                                        <xsl:when test="$diplaytype = 'film'"> view entire </xsl:when>
                                                                        <xsl:when test="$diplaytype = 'member'"> go to </xsl:when>
                                                                </xsl:choose>
                                                                <xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME"/>
                                                        </strong>
                                                </a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4"/>
                                        </div>
                                </td>
                                <td><!-- 20px spacer column --></td>
                                <!-- right col begins here -->
                                <td valign="top">
                                        <xsl:choose>
                                                <!-- FILM CATALOGUES -->
                                                <xsl:when test="$diplaytype = 'film'">
                                                        <xsl:apply-templates select="ARTICLE/GUIDE/BODY/CATEGORYPROMOCOLUMN"/>
                                                </xsl:when>
                                                <!-- MAGAZINE ARCHIVE -->
                                                <xsl:when test="$diplaytype = 'magazine'">
                                                        <div style="padding-bottom:10px;">
                                                                <a href="{$root}magazine">
                                                                        <img alt="go to magazine" height="109" src="{$imagesource}furniture/boxlink_go_to_magazine.gif" width="244"/>
                                                                </a>
                                                        </div>
                                                        <xsl:apply-templates select="/H2G2/SITECONFIG/DISCUSSIONSPROMO"/>
                                                </xsl:when>
                                                <xsl:when test="$diplaytype = 'member'">
                                                        <!-- PEOPLE DIRECTORIES -->
                                                        <!-- key -->
                                                        <xsl:call-template name="INDUSTRY_PANEL_KEY"/>
                                                        <xsl:choose>
                                                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $membersPlacePage">
                                                                        <div class="browsePeopleBox">
                                                                                <div class="browsePeopleBoxTitle">browse people by another place</div>
                                                                                <xsl:variable name="region" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
                                                                                <xsl:choose>
                                                                                        <xsl:when test="$region = $memberNorthEast">
                                                                                                <img alt="You are looking at: North East" border="0" height="194" id="northeastmap" name="northeastmap"
                                                                                                    src="{$imagesource}furniture/membersplace/2northeastmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberNorthWest">
                                                                                                <img alt="You are looking at: North West" border="0" height="194" id="northwestmap" name="northwestmap"
                                                                                                    src="{$imagesource}furniture/membersplace/3northwestmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberWales">
                                                                                                <img alt="You are looking at: Wales" border="0" height="194" id="walesmap" name="walesmap"
                                                                                                    src="{$imagesource}furniture/membersplace/6walesmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberNthireland">
                                                                                                <img alt="You are looking at: Northern Ireland" border="0" height="194" id="nirelandmap"
                                                                                                    name="nirelandmap" src="{$imagesource}furniture/membersplace/4northernirelandmap.gif"
                                                                                                    width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberScotland">
                                                                                                <img alt="You are looking at: Scotland" border="0" height="194" id="scotmap" name="scotmap"
                                                                                                    src="{$imagesource}furniture/membersplace/1scotlandmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberEastMidlands">
                                                                                                <img alt="You are looking at: East Midlands" border="0" height="194" id="eastmidlandsmap"
                                                                                                    name="eastmidlandsmap" src="{$imagesource}furniture/membersplace/8eastmidlandsmap.gif"
                                                                                                    width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberEastOfEngland">
                                                                                                <img alt="You are looking at: East of England" border="0" height="194" id="eastenglandmap"
                                                                                                    name="eastenglandmap" src="{$imagesource}furniture/membersplace/9eastenglandmap.gif" width="244"
                                                                                                />
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberLondon">
                                                                                                <img alt="You are looking at: London" border="0" height="194" id="londonmap" name="londonmap"
                                                                                                    src="{$imagesource}furniture/membersplace/12londonmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberSouthEast">
                                                                                                <img alt="You are looking at: South East" border="0" height="194" id="southeastmap" name="southeastmap"
                                                                                                    src="{$imagesource}furniture/membersplace/11southeastmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberSouthWest">
                                                                                                <img alt="You are looking at: South West" border="0" height="194" id="southwestmap" name="southwestmap"
                                                                                                    src="{$imagesource}furniture/membersplace/10southwestmap.gif" width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberWestMidlands">
                                                                                                <img alt="You are looking at: West Midlands" border="0" height="194" id="westmidlandsmap"
                                                                                                    name="westmidlandsmap" src="{$imagesource}furniture/membersplace/7westmidlandsmap.gif"
                                                                                                    width="244"/>
                                                                                        </xsl:when>
                                                                                        <xsl:when test="$region = $memberYorkshirehumber">
                                                                                                <img alt="You are looking at: Yorks &amp; Humber" border="0" height="194" id="yorkshumbermap"
                                                                                                    name="yorkshumbermap" src="{$imagesource}furniture/membersplace/5yorkshumbermap.gif" width="244"
                                                                                                />
                                                                                        </xsl:when>
                                                                                </xsl:choose>
                                                                                <br/>
                                                                                <table border="0" cellpadding="0" cellspacing="0" class="mapContainer" width="234">
                                                                                        <tr>
                                                                                                <td valign="top" width="117">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="117">
                                                                                                    <tr>
                                                                                                    <td valign="top" width="1%">
                                                                                                    <div class="number">
                                                                                                    <img alt="1" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num1.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberScotland"> Scotland </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberScotland}">Scotland</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="2" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num2.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberNorthEast"> North East </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberNorthEast}">North East</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="3" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num3.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberNorthWest"> North West </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberNorthWest}">North West</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="4" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num4.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberNthireland"> Northern Ireland </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberNthireland}">Northern
                                                                                                    Ireland</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="5" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num5.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberYorkshirehumber"> Yorks
                                                                                                    &amp; Humber </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberYorkshirehumber}">Yorks
                                                                                                    &amp; Humber</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="6" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num6.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberWales"> Wales </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberWales}">Wales</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                                <td valign="top" width="2"/>
                                                                                                <td valign="top" width="117">
                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="117">
                                                                                                    <tr>
                                                                                                    <td valign="top" width="1">
                                                                                                    <div class="number">
                                                                                                    <img alt="7" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num7.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberWestMidlands"> West Midlands </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberWestMidlands}">West
                                                                                                    Midlands</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="8" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num8.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberEastMidlands"> East Midlands </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberEastMidlands}">East
                                                                                                    Midlands</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="9" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num9.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberEastOfEngland"> East of England </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberEastOfEngland}">East of
                                                                                                    England</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="10" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num10.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberSouthWest"> South West </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberSouthWest}">South West</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="11" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num11.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberSouthEast"> South East </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberSouthEast}">South East</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                    <td valign="top">
                                                                                                    <div class="number">
                                                                                                    <img alt="12" height="15"
                                                                                                    src="{$imagesource}furniture/filmregion/num12.gif"
                                                                                                    width="16"/>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                    <td class="maplist" valign="top">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when test="$region = $memberLondon"> London </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <a href="{$root}C{$memberLondon}">London</a>
                                                                                                    </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                    </td>
                                                                                                    </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                        </tr>
                                                                                </table>
                                                                        </div>
                                                                </xsl:when>
                                                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NODEID = $membersSpecialismPage">
                                                                        <!-- other specialism -->
                                                                        <div class="browsePeopleBox">
                                                                                <div class="browsePeopleBoxTitle">browse people by another specialism</div>
                                                                                <ul>
                                                                                        <!--  this makes a list of all the specialisms -->
                                                                                        <xsl:for-each select="msxsl:node-set($categories)/category[substring(@name, 1, 10)             = 'specialism']">
                                                                                                <li>
                                                                                                    <a href="{root}C{server[@name = $server]/@cnum}">
                                                                                                    <xsl:value-of select="@label"/>
                                                                                                    </a>
                                                                                                </li>
                                                                                        </xsl:for-each>
                                                                                </ul>
                                                                        </div>
                                                                </xsl:when>
                                                        </xsl:choose>
                                                </xsl:when>
                                        </xsl:choose>
                                </td>
                        </tr>
                </table>
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
                <xsl:apply-templates mode="c_issue" select="ANCESTOR"/>
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
                <xsl:copy-of select="$m_numberofclubstext"/> [<xsl:apply-imports/>] </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
	Use: container for displaying the number of articles there are in a node
	 -->
        <xsl:template match="MEMBERS" mode="r_numberofarticles">
                <xsl:copy-of select="$m_numberofarticlestext"/> [<xsl:apply-imports/>] </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="r_subjectmembers">
	Use: Logical container for all subject members
	 -->
        <xsl:template match="MEMBERS" mode="r_subjectmembers">
                <xsl:copy-of select="$m_subjectmemberstitle"/>
                <xsl:apply-templates mode="c_issue" select="SUBJECTMEMBER"/>
        </xsl:template>
        <!--
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
	Use: display of a single subject member within the above logical container
	 -->
        <xsl:template match="SUBJECTMEMBER" mode="r_issue">
                <xsl:apply-imports/>
                <!-- <a href="{$root}C{NODEID}" xsl:use-attribute-sets="mSUBJECTMEMBER_r_issue">
			<xsl:value-of select="NAME"/>
		</a> -->
                <xsl:if test="following-sibling::SUBJECTMEMBER">
                        <xsl:text>, </xsl:text>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="r_nodealiasmembers">
	Use: Logical container for all subject members
	 -->
        <xsl:template match="MEMBERS" mode="r_nodealiasmembers">
                <xsl:apply-templates mode="c_issue" select="NODEALIASMEMBER"/>
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
                <xsl:apply-templates mode="c_issue" select="CLUBMEMBER"/>
                <xsl:apply-templates mode="c_moreclubs" select="."/>
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
                <xsl:apply-templates mode="c_issue" select="CLUBMEMBER"/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="CLUBMEMBER" mode="r_issue">
	Use: Display of a single club member within the above logical container
	 -->
        <xsl:template match="CLUBMEMBER" mode="r_issue">
                <xsl:apply-templates mode="t_clubname" select="."/>
                <br/>
                <xsl:apply-templates mode="t_clubdescription" select="."/>
                <br/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="short_articlemembers">
	Use: Logical container for shortened list of article members
	 -->
        <xsl:variable name="articlemaxlength">3</xsl:variable>
        <!-- pagination length set below   set to 1000 as it was reauested to be removed, figure 1000 ahould do it -->
        <xsl:variable name="category_max_length">1000</xsl:variable>
        <xsl:variable name="cat_skipto">
                <xsl:choose>
                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_skipto']/VALUE &gt; 0">
                                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME= 's_skipto']/VALUE"/>
                        </xsl:when>
                        <xsl:otherwise> 0 </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:template match="MEMBERS" mode="short_articlemembers">
                <!-- film duration content table -->
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <!-- spacer for OPENING row of image/menu stack -->
                        <tr>
                                <td colspan="2" height="10" width="371"/>
                        </tr>
                        <!-- get right sort order for cat section we're in -->
                        <xsl:choose>
                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $filmIndexPage">
                                        <xsl:choose>
                                                <!-- work out what to sort by -->
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'rating'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort rating -->
                                                                <xsl:sort data-type="number" order="descending" select="POLL/STATISTICS/@AVERAGERATING"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'duration'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort duration -->
                                                                <xsl:sort data-type="number" select="EXTRAINFO/FILMLENGTH_MINS"/>
                                                                <xsl:sort data-type="number" select="EXTRAINFO/FILMLENGTH_SECS"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'name'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort title -->
                                                                <xsl:sort data-type="text" select="NAME"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'genre'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort genre -->
                                                                <xsl:sort data-type="number" select="EXTRAINFO/TYPE/@ID"/>
                                                                <xsl:sort data-type="text" select="NAME"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'date'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort date -->
                                                                <xsl:sort data-type="number" order="descending" select="DATECREATED/DATE/@SORT"/>
                                                                <xsl:sort data-type="text" select="NAME"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'place'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort place -->
                                                                <xsl:sort data-type="text" select="EXTRAINFO/REGION"/>
                                                                <xsl:sort data-type="text" select="NAME"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                                <!-- sort title -->
                                                                <xsl:sort data-type="text" select="NAME"/>
                                                        </xsl:apply-templates>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:when>
                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $magazinePage">
                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                                <xsl:sort data-type="number" order="descending" select="DATECREATED/DATE/@SORT"/>
                                        </xsl:apply-templates>
                                </xsl:when>
                                <!--Sort for the people's directory page page -->
                                <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage">
                                        <xsl:choose>
                                                <!-- work out what to sort by -->
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'name'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                                                <!-- sort name -->
                                                                <xsl:sort data-type="text" select="EDITOR/USER/FIRSTNAMES"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <!-- unsure how to implement the specialism search, as there can be three specialisms-->
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'specialism'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                                                <xsl:sort data-type="text" select="EXTRAINFO/SPECIALISM1"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'place'">
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                                                <xsl:sort data-type="number" select="DATECREATED/DATE/@SORT"/>
                                                                <xsl:sort data-type="text" select="EXTRAINFO/LOCATION"/>
                                                        </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <!-- by default, sort by name -->
                                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                                                <xsl:sort data-type="text" select="EDITOR/USER/FIRSTNAMES"/>
                                                        </xsl:apply-templates>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER[STATUS/@TYPE = '1']">
                                                <xsl:sort data-type="text" select="NAME"/>
                                        </xsl:apply-templates>
                                </xsl:otherwise>
                        </xsl:choose>
                </table>
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
                <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER"/>
        </xsl:template>
        <xsl:template name="newStatus">
                <xsl:param name="thisPosition"/>
                <xsl:if test="$thisPosition &lt; 5"> &nbsp;<span class="alert">NEW</span>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Use: Display of a single article container within the above logical container
	 -->
        <xsl:template match="ARTICLEMEMBER" mode="r_issue">
                <xsl:if test="position() &gt; $cat_skipto and position() &lt; ($category_max_length + $cat_skipto + 1)">
                        <xsl:choose>
                                <xsl:when test="string-length(NAME) = 0 and $diplaytype = 'member'">
                                        <!-- on film network members don't show if profile not filled in -->
                                </xsl:when>
                                <xsl:when test="$diplaytype = 'member'">
                                        <!-- PEOPLE INDEX -->
                                        <tr>
                                                <td valign="top" width="31">
                                                        <xsl:choose>
                                                                <xsl:when test="EDITOR/USER/GROUPS/ADVISER">
                                                                        <img alt="industry panel member" height="30" src="{$imagesource}furniture/icon_indust_prof.gif" width="31"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <img alt="Film Network member" height="30" src="{$imagesource}furniture/icon_fn_member.gif" width="31"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </td>
                                                <td class="categoryItem" valign="top" width="340">
                                                        <div class="titlefilmography">
                                                                <strong>
                                                                        <a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_issue">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(NAME) = 0"> No title </xsl:when>
                                                                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage">
                                                                                                <xsl:value-of select="EDITOR/USER/FIRSTNAMES"/>&nbsp;<xsl:value-of select="EDITOR/USER/LASTNAME"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="NAME"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </a>
                                                                </strong>
                                                        </div>
                                                        <div class="smallsubmenu">
                                                                <xsl:if test="EXTRAINFO/SPECIALISM1 != ''">
                                                                        <a href="{$root}C{EXTRAINFO/SPECIALISM1_ID}">
                                                                                <xsl:value-of select="EXTRAINFO/SPECIALISM1"/>
                                                                        </a>
                                                                        <xsl:if
                                                                                test="(EXTRAINFO/SPECIALISM2 != '') or (EXTRAINFO/SPECIALISM3           != '') or (EXTRAINFO/LOCATION != '') or           (EXTRAINFO/NUMBEROFAPPROVEDFILMS  &gt; 0)"
                                                                                > | </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="EXTRAINFO/SPECIALISM2 != ''">
                                                                        <a href="{$root}C{EXTRAINFO/SPECIALISM2_ID}">
                                                                                <xsl:value-of select="EXTRAINFO/SPECIALISM2"/>
                                                                        </a>
                                                                        <xsl:if
                                                                                test="(EXTRAINFO/SPECIALISM3           != '') or (EXTRAINFO/LOCATION != '') or           (EXTRAINFO/NUMBEROFAPPROVEDFILMS  &gt; 0)"
                                                                                > | </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="EXTRAINFO/SPECIALISM3 != ''">
                                                                        <a href="{$root}C{EXTRAINFO/SPECIALISM3_ID}">
                                                                                <xsl:value-of select="EXTRAINFO/SPECIALISM3"/>
                                                                        </a>
                                                                        <xsl:if test="(EXTRAINFO/LOCATION != '') or           (EXTRAINFO/NUMBEROFAPPROVEDFILMS &gt; 0)"> | </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="EXTRAINFO/LOCATION != ''">
                                                                        <a href="{$root}C{EXTRAINFO/LOCATION_ID}">
                                                                                <xsl:value-of select="EXTRAINFO/LOCATION"/>
                                                                        </a>
                                                                        <xsl:if test="EXTRAINFO/NUMBEROFAPPROVEDFILMS &gt; 0"> | </xsl:if>
                                                                </xsl:if>
                                                                <xsl:if test="EXTRAINFO/NUMBEROFAPPROVEDFILMS &gt; 0">
                                                                        <xsl:choose>
                                                                                <xsl:when test="EXTRAINFO/NUMBEROFAPPROVEDFILMS &lt; 2">
                                                                                        <xsl:value-of select="EXTRAINFO/NUMBEROFAPPROVEDFILMS"/> film on Film Network </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="EXTRAINFO/NUMBEROFAPPROVEDFILMS"/> films on Film Network </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:if>
                                                        </div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td colspan="2" height="10" width="371"/>
                                        </tr>
                                        <xsl:if test="position() &lt; count(../ARTICLEMEMBER) and position() &lt; ($category_max_length + $cat_skipto)">
                                                <tr>
                                                        <td colspan="2" height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td colspan="2" height="10" width="371"/>
                                                </tr>
                                        </xsl:if>
                                </xsl:when>
                                <xsl:when test="$diplaytype = 'film'">
                                        <!-- FILM INDEX -->
                                        <tr>
                                                <td valign="top" width="116">
                                                        <xsl:variable name="article_medium_gif">
                                                                <xsl:choose>
                                                                        <xsl:when test="$showfakegifs = 'yes'">A3326834_medium.jpg</xsl:when>
                                                                        <xsl:otherwise>A<xsl:value-of select="H2G2ID"/>_medium.jpg</xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:variable>
                                                        <img alt="" height="57" src="{$imagesource}{$gif_assets}{$article_medium_gif}" width="116"/>
                                                </td>
                                                <td class="categoryItem" valign="top">
                                                        <div class="titlefilmography">
                                                                <strong>
                                                                        <a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_issue">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(NAME) = 0"> No title </xsl:when>
                                                                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID = $directoryPage">
                                                                                                <xsl:value-of select="EDITOR/USER/FIRSTNAMES"/>&nbsp;<xsl:value-of select="EDITOR/USER/LASTNAME"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="NAME"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </a>
                                                                </strong>
                                                        </div>
                                                        <div class="smallsubmenu">
                                                                <xsl:apply-templates select="EXTRAINFO/DIRECTORSNAME"/>
                                                                <xsl:if test="EXTRAINFO/DIRECTORSNAME"> | </xsl:if>
                                                                <xsl:choose>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 30">
                                                                                <a href="{$root}C{$genreDrama}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 31">
                                                                                <a href="{$root}C{$genreComedy}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 32">
                                                                                <a href="{$root}C{$genreDocumentry}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 33">
                                                                                <a href="{$root}C{$genreAnimation}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 34">
                                                                                <a href="{$root}C{$genreExperimental}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 35">
                                                                                <a href="{$root}C{$genreMusic}">
                                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype"/>
                                                                                </a> | </xsl:when>
                                                                </xsl:choose>
                                                                <xsl:call-template name="LINK_REGION">
                                                                        <xsl:with-param name="region">
                                                                                <xsl:value-of select="EXTRAINFO/REGION"/>
                                                                        </xsl:with-param>
                                                                </xsl:call-template>
                                                                <xsl:choose>
                                                                        <xsl:when test="EXTRAINFO/FILMLENGTH_MINS > 0"> | <xsl:call-template name="LINK_MINUTES">
                                                                                        <xsl:with-param name="minutes">
                                                                                                <xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/>
                                                                                        </xsl:with-param>
                                                                                        <xsl:with-param name="class">textdark</xsl:with-param>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <a class="textdark" href="{$root}C{$length2}">
                                                                                        <xsl:value-of select="EXTRAINFO/FILMLENGTH_SECS"/> sec </a>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </div>
                                                        <div class="publishedDate">published <xsl:value-of select="DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                                        select="substring(DATECREATED/DATE/@MONTHNAME, 1, 3)"/>&nbsp;<xsl:value-of select="substring(DATECREATED/DATE/@YEAR, 3, 4)"
                                                                /></div>
                                                        <xsl:apply-templates mode="show_dots" select="POLL[STATISTICS/@VOTECOUNT &gt; 0][@HIDDEN = 0]"/>
                                                        <div class="padrightpara">
                                                                <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                        </div>
                                                </td>
                                        </tr>
                                        <xsl:if test="position() &lt; count(../ARTICLEMEMBER) and position() &lt; ($category_max_length + $cat_skipto)">
                                                <tr>
                                                        <td colspan="2" height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td colspan="2" height="10" width="371"/>
                                                </tr>
                                        </xsl:if>
                                </xsl:when>
                                <xsl:when test="$diplaytype = 'magazine'">
                                        <!-- MAGAZINE INDEX -->
                                        <tr>
                                                <td valign="top" width="116">
                                                        <xsl:variable name="article_medium_gif">
                                                                <xsl:choose>
                                                                        <xsl:when test="$showfakegifs = 'yes'">A3326834_medium.jpg</xsl:when>
                                                                        <xsl:otherwise>A<xsl:value-of select="H2G2ID"/>_medium.jpg</xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:variable>
                                                        <img alt="" height="57" src="{$imagesource}magazine/{$article_medium_gif}" width="116"/>
                                                </td>
                                                <td class="categoryItem" valign="top">
                                                        <div class="titlefilmography">
                                                                <strong>
                                                                        <a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_issue">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(NAME) = 0"> No title </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="NAME"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </a>
                                                                </strong>
                                                        </div>
                                                        <div class="publishedDate">published <xsl:value-of select="DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                                        select="substring(DATECREATED/DATE/@MONTHNAME, 1, 3)"/>&nbsp;<xsl:value-of select="substring(DATECREATED/DATE/@YEAR, 3, 4)"
                                                                /></div>
                                                        <xsl:apply-templates mode="show_dots" select="POLL[STATISTICS/@VOTECOUNT &gt; 0][@HIDDEN = 0]"/>
                                                        <div class="padrightpara">
                                                                <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                        </div>
                                                </td>
                                        </tr>
                                        <xsl:if test="position() &lt; count(../ARTICLEMEMBER) and position() &lt; ($category_max_length + $cat_skipto)">
                                                <tr>
                                                        <td colspan="2" height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td colspan="2" height="10" width="371"/>
                                                </tr>
                                        </xsl:if>
                                </xsl:when>
                        </xsl:choose>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="c_articlemembers">
	Author:		Tom Whitehouse
	Context:    /H2G2/HIERARCHYDETAILS
	Purpose:    Creates the container for a list of all the articles within the current node
	Updateby:  Trent
	Purpose:   Change to look for status not type
	-->
        <!-- @@CV@@ -->
        <xsl:template match="MEMBERS" mode="c_articlemembers">
                <xsl:if test="ARTICLEMEMBER[STATUS/@TYPE = '1'] or ARTICLEMEMBER[not(EXTRAINFO)] or ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '3001'] or ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '63']">
                        <xsl:choose>
                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
                                        <xsl:apply-templates mode="full_articlemembers" select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <a name="articles"/>
                                        <xsl:apply-templates mode="short_articlemembers" select="."/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLEMEMBER" mode="c_issue">
	Author:		Tom Whitehouse
	Context:        /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a single article
	Updateby:  Trent
	Purpose:   Change to look for status not type
	-->
        <xsl:template match="ARTICLEMEMBER" mode="c_issue">
                <xsl:choose>
                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
                                <xsl:if test="EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)">
                                        <xsl:apply-templates mode="r_issue" select="."/>
                                </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:if test="(STATUS/@TYPE = '1' or not(EXTRAINFO)) and count(preceding-sibling::ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)]) &lt; $articlemaxlength">
                                        <!-- all layout should sit within here and below template so status 3 don't show anything etc -->
                                        <xsl:apply-templates mode="r_issue" select="."/>
                                </xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template name="getRegionImagemaps">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <xsl:choose>
                                <xsl:when test="$thisCatPage = $northeast">
                                        <!-- map 2 north east image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: North East" border="0" height="194" id="northeastmap" name="northeastmap"
                                                                src="{$imagesource}furniture/filmregion/2northeastmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>North East</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="north east" height="18" src="{$imagesource}furniture/filmregion/2northeastseg.gif" width="30"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                        <!-- END map 2 north east image map / links table -->
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $northwest">
                                        <!-- map 3 north west image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: North West" border="0" height="194" id="northwestmap" name="northwestmap"
                                                                src="{$imagesource}furniture/filmregion/3northwestmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>North West</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="north west" height="35" src="{$imagesource}furniture/filmregion/3northwestseg.gif" width="26"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                        <!-- END map 3 north west image map / links table -->
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $wales">
                                        <!-- map 6 wales image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: Wales" border="0" height="194" id="walesmap" name="walesmap"
                                                                src="{$imagesource}furniture/filmregion/6walesmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>Wales</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="wales" height="50" src="{$imagesource}furniture/filmregion/6walesseg.gif" width="56"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                        <!-- END map 6 wales image map / links table -->
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $nthireland">
                                        <!-- map 4 northern ireland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: Northern Ireland" border="0" height="194" id="nirelandmap" name="nirelandmap"
                                                                src="{$imagesource}furniture/filmregion/4northernirelandmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>Northern Ireland</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="northern ireland" height="21" src="{$imagesource}furniture/filmregion/4northernirelandseg.gif" width="55"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $scotland">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: Scotland" border="0" height="194" id="scotmap" name="scotmap"
                                                                src="{$imagesource}furniture/filmregion/1scotlandmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>Scotland</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="scotland" height="40" src="{$imagesource}furniture/filmregion/1scotlandseg.gif" width="58"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $eastmidlands">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: East Midlands" border="0" height="194" id="eastmidlandsmap" name="eastmidlandsmap"
                                                                src="{$imagesource}furniture/filmregion/8eastmidlandsmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>East Midlands</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="east midlands" height="33" src="{$imagesource}furniture/filmregion/8eastmidlandsseg.gif" width="43"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $eastofengland">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: East of England" border="0" height="194" id="eastenglandmap" name="eastenglandmap"
                                                                src="{$imagesource}furniture/filmregion/9eastenglandmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>East of England</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="east england" height="37" src="{$imagesource}furniture/filmregion/9eastenglandseg.gif" width="48"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $london">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: London" border="0" height="194" id="londonmap" name="londonmap"
                                                                src="{$imagesource}furniture/filmregion/12londonmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>London</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="london" height="21" src="{$imagesource}furniture/filmregion/12londonseg.gif" width="21"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $southeast">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: South East" border="0" height="194" id="southeastmap" name="southeastmap"
                                                                src="{$imagesource}furniture/filmregion/11southeastmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>South East</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="south east" height="53" src="{$imagesource}furniture/filmregion/11southeastseg.gif" width="95"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $southwest">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: South West" border="0" height="194" id="southwestmap" name="southwestmap"
                                                                src="{$imagesource}furniture/filmregion/10southwestmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>South West</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="south west" height="67" src="{$imagesource}furniture/filmregion/10southwestseg.gif" width="97"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $westmidlands">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: West Midlands" border="0" height="194" id="westmidlandsmap" name="westmidlandsmap"
                                                                src="{$imagesource}furniture/filmregion/7westmidlandsmap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>West Midlands</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="west midlands" height="39" src="{$imagesource}furniture/filmregion/7westmidlandsseg.gif" width="41"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                                <xsl:when test="$thisCatPage = $yorkshirehumber">
                                        <!-- map 1 scotland image map / links table -->
                                        <tr>
                                                <td class="webboxbg" valign="top" width="244">
                                                        <img alt="You are looking at: Yorks &amp; Humber" border="0" height="194" id="yorkshumbermap" name="yorkshumbermap"
                                                                src="{$imagesource}furniture/filmregion/5yorkshumbermap.gif" usemap="#map1" width="244"/>
                                                </td>
                                                <td align="right" class="mapbg" valign="top" width="127">
                                                        <div class="mapintro">you are looking at:</div>
                                                        <div class="textbrightmedium">
                                                                <strong>Yorks &amp; Humber</strong>
                                                        </div>
                                                        <div class="mapsegment">
                                                                <img alt="yorks and humber" height="21" src="{$imagesource}furniture/filmregion/5yorkshumberseg.gif" width="44"/>
                                                        </div>
                                                </td>
                                                <td class="mapvertdivider" valign="top" width="20"/>
                                                <td class="webboxbg" colspan="3" valign="top" width="107">
                                                        <xsl:call-template name="regionMapList"/>
                                                </td>
                                        </tr>
                                </xsl:when>
                        </xsl:choose>
                        <tr>
                                <td height="10" valign="top">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                                <td valign="top">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="127"/>
                                </td>
                                <td valign="top" width="20"/>
                                <td valign="top">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="117"/>
                                </td>
                                <td valign="top">
                                        <img alt="" class="tiny" height="8" src="/f/t.gif" width="10"/>
                                </td>
                                <td valign="top">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="117"/>
                                </td>
                        </tr>
                        <!-- END spacer row -->
                </table>
                <map id="map1" name="map1">
                        <xsl:if test="$thisCatPage != $scotland">
                                <area alt="SCOTLAND" coords="117,23,173,32" href="{$root}C{$scotland}" shape="rect" title="SCOTLAND"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $nthireland">
                                <area alt="NORTHERN IRELAND" coords="23,51,85,62" href="{$root}C{$nthireland}" shape="rect" title="NORTHERN IRELAND"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $northeast">
                                <area alt="NORTH EAST" coords="164,37,187,46" href="{$root}C{$northeast}" shape="rect" title="NORTH EAST"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $northwest">
                                <area alt="NORTH WEST" coords="114,56,141,64" href="{$root}C{$northwest}" shape="rect" title="NORTH WEST"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $yorkshirehumber">
                                <area alt="YORKS / HUMBER" coords="164,56,239,67" href="{$root}C{$yorkshirehumber}" shape="rect" title="YORKS / HUMBER"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $wales">
                                <area alt="WALES" coords="89,81,132,90" href="{$root}C{$wales}" shape="rect" title="WALES"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $eastmidlands">
                                <area alt="EAST MIDLANDS" coords="176,74,237,86" href="{$root}C{$eastmidlands}" shape="rect" title="EAST MIDLANDS"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $westmidlands">
                                <area alt="WEST MIDLANDS" coords="118,96,183,107" href="{$root}C{$westmidlands}" shape="rect" title="WEST MIDLANDS"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $eastofengland">
                                <area alt="EAST OF ENGLAND" coords="188,97,243,109" href="{$root}C{$eastofengland}" shape="rect" title="EAST OF ENGLAND"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $london">
                                <area alt="LONDON" coords="199,118,243,129" href="{$root}C{$london}" shape="rect" title="LONDON"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $southwest">
                                <area alt="SOUTH WEST" coords="97,132,120,142" href="{$root}C{$southwest}" shape="rect" title="SOUTH WEST"/>
                        </xsl:if>
                        <xsl:if test="$thisCatPage != $southeast">
                                <area alt="SOUTH EAST" coords="184,135,207,145" href="{$root}C{$southeast}" shape="rect" title="SOUTH EAST"/>
                        </xsl:if>
                </map>
                <!-- END map 1 scotland image map / links table -->
        </xsl:template>
        <xsl:template name="regionMapList">
                <table border="0" cellpadding="0" cellspacing="0" width="117">
                        <tr>
                                <td>
                                        <div class="maplistwrap">
                                                <table border="0" cellpadding="0" cellspacing="0" width="117">
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="1" height="15" src="{$imagesource}furniture/filmregion/num1.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $scotland">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>Scotland</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$scotland}">
                                                                                                <strong>Scotland</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="2" height="15" src="{$imagesource}furniture/filmregion/num2.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $northeast">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>North East</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$northeast}">
                                                                                                <strong>North East</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="3" height="15" src="{$imagesource}furniture/filmregion/num3.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $northwest">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>North West</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$northwest}">
                                                                                                <strong>North West</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="4" height="15" src="{$imagesource}furniture/filmregion/num4.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $nthireland">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>Northern Ireland</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$nthireland}">
                                                                                                <strong>Northern Ireland</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="5" height="15" src="{$imagesource}furniture/filmregion/num5.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $yorkshirehumber">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>Yorks &amp; Humber</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$yorkshirehumber}">
                                                                                                <strong>Yorks &amp; Humber</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="6" height="15" src="{$imagesource}furniture/filmregion/num6.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $wales">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>Wales</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$wales}">
                                                                                                <strong>Wales</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                </table>
                                        </div>
                                </td>
                                <td class="webboxbg" valign="top" width="10">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td class="webboxbg" valign="top" width="107">
                                        <div class="maplistwrap">
                                                <table border="0" cellpadding="0" cellspacing="0" class="webboxbg" width="117">
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="7" height="15" src="{$imagesource}furniture/filmregion/num7.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $westmidlands">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>West Midlands</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$westmidlands}">
                                                                                                <strong>West Midlands</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="8" height="15" src="{$imagesource}furniture/filmregion/num8.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $eastmidlands">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>East Midlands</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$eastmidlands}">
                                                                                                <strong>East Midlands</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="9" height="15" src="{$imagesource}furniture/filmregion/num9.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $eastofengland">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>East of England</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$eastofengland}">
                                                                                                <strong>East of England</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="10" height="15" src="{$imagesource}furniture/filmregion/num10.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $southwest">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>South West</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$southwest}">
                                                                                                <strong>South West</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="11" height="15" src="{$imagesource}furniture/filmregion/num11.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $southeast">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>South East</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$southeast}">
                                                                                                <strong>South East</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="16">
                                                                        <div class="number">
                                                                                <img alt="12" height="15" src="{$imagesource}furniture/filmregion/num12.gif" width="16"/>
                                                                        </div>
                                                                </td>
                                                                <xsl:choose>
                                                                        <xsl:when test="$thisCatPage = $london">
                                                                                <td class="maplistselected" valign="top" width="101">
                                                                                        <strong>London</strong>
                                                                                </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <td class="maplist" valign="top" width="101">
                                                                                        <a class="rightcol" href="{$root}C{$london}">
                                                                                                <strong>London</strong>
                                                                                        </a>
                                                                                </td>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </tr>
                                                </table>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- POLL results -->
        <xsl:template match="POLL" mode="show_dots">
                <xsl:variable name="poll_average_score2">
                        <xsl:value-of select="STATISTICS/@AVERAGERATING"/>
                </xsl:variable>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <td>
                                        <div class="articleratingdots">
                                                <xsl:choose>
                                                        <xsl:when test="$poll_average_score2 &gt; 0.2">
                                                                <xsl:choose>
                                                                        <xsl:when test="$poll_average_score2 &gt; 0.6">
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_on_w_sm.gif" width="8"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_onhalf_w_sm.gif" width="8"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_off_w_sm.gif" width="8"/>
                                                        </xsl:otherwise>
                                                </xsl:choose> &nbsp; <xsl:choose>
                                                        <xsl:when test="$poll_average_score2 &gt; 1.2">
                                                                <xsl:choose>
                                                                        <xsl:when test="$poll_average_score2 &gt; 1.6">
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_on_w_sm.gif" width="8"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_onhalf_w_sm.gif" width="8"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_off_w_sm.gif" width="8"/>
                                                        </xsl:otherwise>
                                                </xsl:choose> &nbsp; <xsl:choose>
                                                        <xsl:when test="$poll_average_score2 &gt; 2.2">
                                                                <xsl:choose>
                                                                        <xsl:when test="$poll_average_score2 &gt; 2.6">
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_on_w_sm.gif" width="8"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_onhalf_w_sm.gif" width="8"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_off_w_sm.gif" width="8"/>
                                                        </xsl:otherwise>
                                                </xsl:choose> &nbsp; <xsl:choose>
                                                        <xsl:when test="$poll_average_score2 &gt; 3.2">
                                                                <xsl:choose>
                                                                        <xsl:when test="$poll_average_score2 &gt; 3.6">
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_on_w_sm.gif" width="8"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_onhalf_w_sm.gif" width="8"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_off_w_sm.gif" width="8"/>
                                                        </xsl:otherwise>
                                                </xsl:choose> &nbsp; <xsl:choose>
                                                        <xsl:when test="$poll_average_score2 &gt; 4.2">
                                                                <xsl:choose>
                                                                        <xsl:when test="$poll_average_score2 &gt; 4.6">
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_on_w_sm.gif" width="8"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_onhalf_w_sm.gif" width="8"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="" border="0" height="9" src="{$imagesource}furniture/drama/btn_off_w_sm.gif" width="8"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                </td>
                                <td>
                                        <div class="articleratingdots2"> &nbsp;average rating from <xsl:value-of select="STATISTICS/@VOTECOUNT"/> member<xsl:if
                                                        test="STATISTICS/@VOTECOUNT &gt; 1">s</xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- Author:  Trent Williams
	 Purpose: link to region category in crumbs for categories, notes or any other
	 HowTo:   Pass the string name you get in the EXTRAINFO node, we match on that to make link
	 -->
        <xsl:template name="LINK_REGION">
                <xsl:param name="region"/>
                <xsl:param name="class"/>
                <xsl:choose>
                        <xsl:when test="$region='North East'">
                                <a href="{$root}C{$northeast}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>North East</a>
                        </xsl:when>
                        <xsl:when test="$region='North West'">
                                <a href="{$root}C{$northwest}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>North West</a>
                        </xsl:when>
                        <xsl:when test="$region='Wales'">
                                <a href="{$root}C{$wales}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>Wales</a>
                        </xsl:when>
                        <xsl:when test="$region='Northern Ireland'">
                                <a href="{$root}C{$nthireland}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>Northern Ireland</a>
                        </xsl:when>
                        <xsl:when test="$region='Scotland'">
                                <a href="{$root}C{$scotland}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>Scotland</a>
                        </xsl:when>
                        <xsl:when test="$region='East Midlands'">
                                <a href="{$root}C{$eastmidlands}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>East Midlands</a>
                        </xsl:when>
                        <xsl:when test="$region='East Of England'">
                                <a href="{$root}C{$eastofengland}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>East Of England</a>
                        </xsl:when>
                        <xsl:when test="$region='London'">
                                <a href="{$root}C{$london}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>London</a>
                        </xsl:when>
                        <xsl:when test="$region='South East'">
                                <a href="{$root}C{$southeast}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>South East</a>
                        </xsl:when>
                        <xsl:when test="$region='South West'">
                                <a href="{$root}C{$southwest}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>South West</a>
                        </xsl:when>
                        <xsl:when test="$region='West Midlands'">
                                <a href="{$root}C{$westmidlands}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>West Midlands</a>
                        </xsl:when>
                        <xsl:when test="$region='Yorkshire &amp; Humber'">
                                <a href="{$root}C{$yorkshirehumber}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if>Yorkshire &amp; Humber</a>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <!-- Author:  Trent Williams
	 Purpose: link to duration category in crumbs for categories, notes or any other
	 HowTo:   Pass the string name you get in the EXTRAINFO node, we check that to make link
	 -->
        <xsl:template name="LINK_MINUTES">
                <xsl:param name="minutes"/>
                <xsl:param name="class"/>
                <xsl:choose>
                        <xsl:when test="$minutes &lt; 2">
                                <a href="{$root}C{$length2}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if><xsl:value-of select="$minutes"/> min</a>
                        </xsl:when>
                        <xsl:when test="$minutes &lt; 5">
                                <a href="{$root}C{$length2_5}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if><xsl:value-of select="$minutes"/> min</a>
                        </xsl:when>
                        <xsl:when test="$minutes &lt; 10">
                                <a href="{$root}C{$length5_10}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if><xsl:value-of select="$minutes"/> min</a>
                        </xsl:when>
                        <xsl:when test="$minutes &gt; 9">
                                <a href="{$root}C{$length10_20}"><xsl:if test="string-length($class) &gt; 0">
                                                <xsl:attribute name="class">
                                                        <xsl:value-of select="$class"/>
                                                </xsl:attribute>
                                        </xsl:if><xsl:value-of select="$minutes"/> min</a>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <!-- Author:  Alistair Duggin
	 Purpose: HTML for industry panel key
	 -->
        <xsl:template name="INDUSTRY_PANEL_KEY">
                <div class="box community">
                        <div class="boxTitleTop">
                                <strong>Key</strong>
                        </div>
                        <div class="imgAndText"><img alt="" height="30" src="{$imagesource}furniture/icon_fn_member.gif" width="31"/>Film Network member</div>
                        <div class="imgAndText"><img alt="" height="30" src="{$imagesource}furniture/icon_indust_prof.gif" width="31"/>industry panel member</div>
                        <div class="hr"/>
                        <div class="infoLink">
                                <a href="{root}industrypanel">what is the industry panel?</a>
                        </div>
                </div>
        </xsl:template>
</xsl:stylesheet>
