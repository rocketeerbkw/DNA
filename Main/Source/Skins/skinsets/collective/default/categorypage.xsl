<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-categorypage.xsl"/>
        <!-- VARIABLES -->
        <xsl:variable name="categoryid" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
        <xsl:variable name="displayname" select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
        <xsl:variable name="view">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE"/>
        </xsl:variable>
        <xsl:variable name="order">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_order']/VALUE"/>
        </xsl:variable>
        <xsl:variable name="badChars"> '&amp;</xsl:variable>
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
                        <xsl:with-param name="message">CATEGORY_MAINBODY<xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">categorypage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <!-- VARIABLES -->
                <!-- PAGENAME -->
                <div id="page-name">
                        <xsl:if test="count(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR) > 1 or $view = 'archive'">
                                <xsl:for-each select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR">
                                        <xsl:sort order="ascending" select="position()"/>
                                        <a href="{$root}C{NODEID}?s_view=archive">
                                                <xsl:value-of select="NAME"/>
                                        </a>
                                        <xsl:text> / </xsl:text>
                                </xsl:for-each>
                        </xsl:if>
                        <h2>
                                <xsl:value-of select="$displayname"/>
                        </h2>
                </div>
                <xsl:choose>
                        <!-- if we're at the top level of a category ..-->
                        <xsl:when test="count(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR) = 1 and $view != 'archive'">
                                <xsl:call-template name="category-content"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- SEARCHBOX -->
                                <div class="generic-u">
                                        <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                <strong>advanced search</strong>
                                        </xsl:element>
                                        <table border="0" cellpadding="0" cellspacing="0" width="595">
                                                <tr>
                                                        <td>
                                                                <label for="category-search">
                                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                                <strong class="brown">i am looking for:&nbsp;</strong>
                                                                        </xsl:element>
                                                                </label>
                                                        </td>
                                                        <td>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <xsl:call-template name="c_search_dna"/>
                                                                </xsl:element>
                                                        </td>
                                                        <td>&nbsp;</td>
                                                        <td align="right" class="category-b">
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <a href="{$root}faqsgettingaround"><img alt="" border="0" height="14" src="{$imagesource}icons/help.gif" width="12"/>&nbsp;i need help</a>
                                                                </xsl:element>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td>&nbsp;</td>
                                                        <td class="white" colspan="3">
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">e.g. aphex twin, donnie darko, will self, bill viola, elephant, ross noble</xsl:element>
                                                        </td>
                                                </tr>
                                        </table>
                                </div>
                                <xsl:choose>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR">
                                                <xsl:apply-templates mode="r_issue" select="HIERARCHYDETAILS"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:apply-templates mode="r_category" select="HIERARCHYDETAILS"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
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
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <!-- CATEGORY HEADING -->
                                        <h3 id="archive-header">browse archive</h3>
                                        <!-- CATEGORY LIST -->
                                        <xsl:apply-templates mode="r_category" select="MEMBERS"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3"> </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <!-- DESCIPTION GUIDEML INSERT -->
                                        <xsl:apply-templates select="/H2G2/SITECONFIG/ARCHIVEPICK"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- EDITORIAL A-Z -->
                <div class="page-by editor-pages">
                        <h3>pages by editors</h3>
                        <h4>a to z</h4>
                        <xsl:call-template name="alphaindex">
                                <xsl:with-param name="query">submit=new&amp;official=on</xsl:with-param>
                        </xsl:call-template>
                        <span class="clear"/>
                </div>
                <!-- MEMBER REVIEW A-Z -->
                <div class="page-by member-reviews">
                        <h3>member reviews</h3>
                        <h4>a to z</h4>
                        <xsl:call-template name="alphaindex">
                                <xsl:with-param name="query">submit=new&amp;user=on</xsl:with-param>
                        </xsl:call-template>
                        <span class="clear"/>
                </div>
                <!-- MEMBER PAGE A-Z -->
                <div class="page-by member-pages">
                        <h3>member pages</h3>
                        <h4>a to z</h4>
                        <xsl:call-template name="alphaindex">
                                <xsl:with-param name="query">submit=new&amp;user=on&amp;type=1&amp;type=2</xsl:with-param>
                        </xsl:call-template>
                        <span class="clear"/>
                </div>
        </xsl:template>
        <xsl:template match="HIERARCHYDETAILS">
                <xsl:if test="MEMBERS/SUBJECTMEMBER or MEMBERS/ARTICLEMEMBER">
                        <xsl:variable name="parentCategory">
                                <xsl:value-of select="translate($displayname, $badChars, '-')"/>
                                <xsl:text>-category</xsl:text>
                        </xsl:variable>
                        <div id="archive-index">
                                <h3><xsl:value-of select="$displayname"/> archive</h3>
                                <ul>
                                        <xsl:if test="MEMBERS/ARTICLEMEMBER">
                                                <li class="category" id="{$parentCategory}">
                                                        <a href="{$root}C{@NODEID}?s_view=archive">
                                                                <xsl:value-of select="$displayname"/>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                        <xsl:for-each select="MEMBERS/SUBJECTMEMBER">
                                                <xsl:sort order="ascending" select="NAME"/>
                                                <li class="{$parentCategory} category" id="{translate(NAME, $badChars, '-')}-category">
                                                        <a href="{$root}C{NODEID}?s_view=archive">
                                                                <xsl:value-of select="NAME"/>
                                                        </a>
                                                </li>
                                        </xsl:for-each>
                                </ul>
                        </div>
                </xsl:if>
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
                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                        <xsl:apply-templates mode="c_category" select="ANCESTOR"/>
                        <xsl:text>&nbsp;/&nbsp;</xsl:text>
                </xsl:element>
        </xsl:template>
        <!--
	<xsl:template match="ANCESTOR" mode="r_category">
	Use: One item within the crumbtrail
	-->
        <!-- NOTE conditionals added to fix 'games category in more features' wierdness -->
        <xsl:template match="ANCESTOR" mode="r_category">
                <xsl:choose>
                        <xsl:when
                                test="NAME = 'more culture' and (/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'features' or /H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'games' or /H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'reviews')"/>
                        <xsl:otherwise>
                                <a href="{$root}C{NODEID}" xsl:use-attribute-sets="mANCESTOR_r_category">
                                        <xsl:value-of select="NAME"/>
                                </a>
                                <xsl:if test="following-sibling::ANCESTOR">
                                        <xsl:choose>
                                                <xsl:when
                                                        test="following-sibling::ANCESTOR[1]/NAME = 'more culture' and (/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'features' or /H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'games' or /H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'reviews')"/>
                                                <xsl:otherwise>
                                                        <xsl:text>&nbsp;/&nbsp;</xsl:text>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
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
                <ul id="archive-list">
                        <xsl:apply-templates mode="r_category" select="SUBJECTMEMBER"/>
                        <xsl:variable name="class">
                                <xsl:choose>
                                        <xsl:when test="count(SUBJECTMEMBER) mod 2 = 0">odd</xsl:when>
                                        <xsl:otherwise>even</xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <li class="{$class} category" id="back-issues-category">
                                <a href="{$root}backissues">back issues</a>
                        </li>
                        <li class="browse-folder-r">
                                <a href="randomentry">random page</a>
                                <p>bored? try our random page generator</p>
                        </li>
                </ul>
                <br/>
        </xsl:template>
        <!--
	<xsl:template name="alphaindex">
	Author:		Thomas Whitehouse
	Purpose:		Creates the alpha index
	-->
        <xsl:template name="alphaindex">
                <xsl:param name="query"/>
                <!-- switch this to the above methodology for XSLT 2.0 where its possible to use with-param with apply-imports -->
                <xsl:variable name="alphabet">
                        <letter>a</letter>
                        <letter>b</letter>
                        <letter>c</letter>
                        <letter>d</letter>
                        <letter>e</letter>
                        <letter>f</letter>
                        <letter>g</letter>
                        <letter>h</letter>
                        <letter>i</letter>
                        <letter>j</letter>
                        <letter>k</letter>
                        <letter>l</letter>
                        <letter>m</letter>
                        <letter>n</letter>
                        <letter>o</letter>
                        <letter>p</letter>
                        <letter>q</letter>
                        <letter>r</letter>
                        <letter>s</letter>
                        <letter>t</letter>
                        <letter>u</letter>
                        <letter>v</letter>
                        <letter>w</letter>
                        <letter>x</letter>
                        <letter>y</letter>
                        <letter>z</letter>
                </xsl:variable>
                <ol>
                        <xsl:for-each select="msxsl:node-set($alphabet)/letter">
                                <xsl:apply-templates mode="alpha" select=".">
                                        <xsl:with-param name="query" select="$query"/>
                                </xsl:apply-templates>
                        </xsl:for-each>
                </ol>
        </xsl:template>
        <!--
	<xsl:template match="letter" mode="alpha">
	Author:		Thomas Whitehouse
	Purpose:	Creates each of the letter links
	-->
        <xsl:template match="letter" mode="alpha">
                <xsl:param name="query"/>
                <li>
                        <a class="{.}-letter" href="{$root}Index?{$query}&amp;let={.}"/>
                </li>
        </xsl:template>
        <!--
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
	Use: Presentation of a node if it is a subject (contains other nodes)
	 -->
        <xsl:template match="SUBJECTMEMBER" mode="r_category">
                <xsl:variable name="class">
                        <xsl:choose>
                                <xsl:when test="count(preceding-sibling::SUBJECTMEMBER) mod 2 = 0">odd</xsl:when>
                                <xsl:otherwise>even</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <li class="{$class} category" id="{translate(NAME, $badChars, '-')}-category">
                        <a href="{$root}C{NODEID}?s_view=archive">
                                <xsl:value-of select="NAME"/>
                        </a>
                </li>
        </xsl:template>
        <!--
	<xsl:template match="SUBNODES" mode="r_category">
	Use: Presentation of the subnodes logical container
	 -->
        <xsl:template match="SUBNODES" mode="r_category">
                <xsl:apply-templates mode="c_subnodename" select="SUBNODE"/>
        </xsl:template>
        <!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Use: Presenttaion of a subnode, ie the contents of a SUBJECTMEMBER node
	 -->
        <xsl:template match="SUBNODE" mode="r_subnodename">
                <xsl:apply-imports/>
                <xsl:choose>
                        <xsl:when test="count(following-sibling::SUBNODE) &gt; 0">,&nbsp;</xsl:when>
                        <xsl:otherwise>...</xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="zero_category">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="zero_subject"> (<xsl:value-of select="$m_nomembers"/>) </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="one_category">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="one_subject"> (<xsl:value-of select="$m_member"/>) </xsl:template>
        <!--
	<xsl:template match="NODECOUNT" mode="many_category">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
        <xsl:template match="NODECOUNT" mode="many_subject"> (<xsl:apply-imports/>
                <xsl:value-of select="$m_members"/>) </xsl:template>
        <!--
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
	Use: Presentation of an node if it is an article
	 -->
        <xsl:template match="ARTICLEMEMBER" mode="r_category">
                <div>
                        <xsl:apply-imports/>
                </div>
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
                <!--  top level blue folder -->
                <!-- NOTE this section contains a dirty workaround for the 'games category contained in more features category' quirk -->
                <div id="category-list">
                        <h3>
                                <xsl:choose>
                                        <xsl:when test="count(ANCESTRY/ANCESTOR) = 1">
                                                <xsl:attribute name="class">
                                                        <xsl:text>sub-category first-page</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="id">
                                                        <xsl:value-of select="translate($displayname, $badChars, '-')"/>
                                                        <xsl:text>-sub-category</xsl:text>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                        <xsl:when test="MEMBERS/ARTICLEMEMBER">
                                                                <form method="get"> sort <xsl:value-of select="DISPLAYNAME"/> by: <label><input id="title_order" name="s_order" onclick="changeSort(this.value);" type="radio"
                                                                        value="title"/>title a-z</label>
                                                                        <label><input id="date_order" name="s_order" onclick="changeSort(this.value);" type="radio" value="date"/>newest first</label>
                                                                        <input id="sort-submit" type="submit" value="sort"/>
                                                                </form>
                                                                <script type="text/javascript">
                                                                        //<![CDATA[
                                                                            document.getElementById('sort-submit').style.display = 'none';
                                                                            if(location.search == '?s_order=date'){
                                                                                    document.getElementById('date_order').setAttribute('checked', 'checked');
                                                                             }
                                                                             else{
                                                                                     document.getElementById('title_order').setAttribute('checked', 'checked');
                                                                             }
                                                                             function changeSort(sortOrder){
                                                                                     location.search = '?s_order=' + sortOrder; 
                                                                             }
                                                                     //]]>
                                                                </script>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:value-of select="$displayname"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:attribute name="id">
                                                        <xsl:value-of select="ANCESTRY/ANCESTOR[last()]/NAME"/>
                                                        <xsl:text>-sub-category</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="class">
                                                        <xsl:text>sub-category</xsl:text>
                                                </xsl:attribute>
                                                <a href="{$root}C{ANCESTRY/ANCESTOR[last()]/NODEID}?s_view=archive">
                                                        <xsl:value-of select="ANCESTRY/ANCESTOR[last()]/NAME"/>
                                                </a>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </h3>
                        <xsl:if test="count(ANCESTRY/ANCESTOR) &gt; 1">
                                <h4>
                                        <xsl:attribute name="class">
                                                <xsl:value-of select="ANCESTRY/ANCESTOR[last()]/NAME"/>
                                                <xsl:text>-sub-category sub-category</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="id">
                                                <xsl:value-of select="translate($displayname, $badChars, '-')"/>
                                                <xsl:text>-sub-category</xsl:text>
                                        </xsl:attribute>
                                        <form method="get"> sort <xsl:value-of select="DISPLAYNAME"/> by: <label><input id="title_order" name="s_order" onclick="changeSort(this.value);" type="radio"
                                                                value="title"/>title a-z</label>
                                                <label><input id="date_order" name="s_order" onclick="changeSort(this.value);" type="radio" value="date"/>newest first</label>
                                                <input id="sort-submit" type="submit" value="sort"/>
                                        </form>
                                        <script type="text/javascript">
                                            //<![CDATA[
                                                    document.getElementById('sort-submit').style.display = 'none';
                                                    if(location.search == '?s_order=date'){
                                                            document.getElementById('date_order').setAttribute('checked', 'checked');
                                                     }
                                                     else{
                                                             document.getElementById('title_order').setAttribute('checked', 'checked');
                                                     }
                                                     function changeSort(sortOrder){
                                                             location.search = '?s_order=' + sortOrder; 
                                                     }
                                             //]]>
                                        </script>
                                </h4>
                        </xsl:if>
                        <ol>
                                <xsl:if test="count(ANCESTRY/ANCESTOR) &gt; 1">
                                        <xsl:attribute name="class">second-level-members</xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates mode="r_issue" select="MEMBERS">
                                        <xsl:with-param name="order" select="$order"/>
                                </xsl:apply-templates>
                                <!-- MEMBER REVIEW a-z -->
                                <xsl:call-template name="CATEGORIES"/>
                                <span class="clear"/>
                        </ol>
                </div>
        </xsl:template>
        <!--
	<xsl:template name="CATEGORIES">
	Use: template for lists of member reviews A-Z
	 -->
        <xsl:template name="CATEGORIES">
                <xsl:for-each select="msxsl:node-set($type)/type[@category=$categoryid]">
                        <li class="a-z-member">
                                <h4>member <xsl:value-of select="@label"/>'s a-z</h4>
                                <xsl:call-template name="alphaindex">
                                        <xsl:with-param name="query">submit=new&amp;user=on&amp;type=<xsl:value-of select="@number"/><xsl:if test="@selectnumber">&amp;type=<xsl:value-of
                                                                select="@selectnumber"/></xsl:if></xsl:with-param>
                                </xsl:call-template>
                        </li>
                </xsl:for-each>
        </xsl:template>
        <!--
	<xsl:template match="MEMBERS" mode="c_issue">
	Use: Holder for all the members of a node
	 -->
        <xsl:template match="MEMBERS" mode="r_issue">
                <xsl:param name="order"/>
                <xsl:apply-templates mode="r_issue" select="SUBJECTMEMBER[substring(NAME, string-length(NAME) - 2) != 'a-z']">
                        <!-- display A-Z -->
                        <xsl:sort data-type="number" order="ascending" select="@SORTORDER"/>
                </xsl:apply-templates>
                <!-- display A-Z -->
                <xsl:choose>
                        <xsl:when test="$order = 'date'">
                                <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                        <xsl:sort data-type="number" order="descending" select="DATECREATED/DATE/@SORT"/>
                                </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates mode="r_issue" select="ARTICLEMEMBER">
                                        <xsl:sort data-type="number" order="ascending" select="@SORTORDER"/>
                                </xsl:apply-templates>
                        </xsl:otherwise>
                </xsl:choose>
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
                <li>
                        <xsl:attribute name="class">
                                <xsl:value-of select="translate($displayname, $badChars, '-')"/>
                                <xsl:text>-category-member category-member</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="id">
                                <xsl:value-of select="translate(NAME, $badChars, '-')"/>
                                <xsl:text>-category-member</xsl:text>
                        </xsl:attribute>
                        <a href="{$root}C{NODEID}?s_view=archive">
                                <xsl:value-of select="NAME"/>
                        </a>
                </li>
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
        <xsl:template match="MEMBERS" mode="short_articlemembers">
                <b>
                        <xsl:copy-of select="$m_articlememberstitle"/>
                </b>
                <br/>
                <xsl:apply-templates mode="c_issue" select="ARTICLEMEMBER"/>
                <xsl:apply-templates mode="c_morearticles" select="."/>
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
                <xsl:apply-templates mode="c_issue" select="ARTICLEMEMBER"/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Use: Display of a single article container within the above logical container
	 -->
        <xsl:template match="ARTICLEMEMBER" mode="r_issue">
                <li class="article-member">
                        <a href="{$root}A{H2G2ID}">
                                <xsl:value-of select="NAME"/>
                        </a>
                        <p>
                                <xsl:variable name="articleType" select="EXTRAINFO/TYPE/@ID"/>
                                <xsl:choose>
                                        <xsl:when test="$articleType = '1'">editorial</xsl:when>
                                        <xsl:when test="$articleType = '55'">feature</xsl:when>
                                        <xsl:otherwise>
                                                <xsl:choose>
                                                        <xsl:when test="EDITOR/USER/GROUPS/GROUP/NAME = 'EDITOR'">editor's </xsl:when>
                                                        <xsl:otherwise>member's </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:value-of select="$displayname"/>
                                                <xsl:text> review</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </p>
                </li>
        </xsl:template>
        <!-- 
       <xsl:template name="r_search_dna">
       Use: Presentation of the global search box
       -->
        <xsl:template name="r_search_dna">
                <input name="type" type="hidden" value="1"/>
                <!-- or forum or user -->
                <input name="showapproved" type="hidden" value="1"/>
                <!-- status 1 articles -->
                <input name="showsubmitted" type="hidden" value="1"/>
                <!-- articles in a review forum -->
                <input name="shownormal" type="hidden" value="1"/>
                <!-- user articles -->
                <xsl:call-template name="t_searchstring"/>&nbsp; <!-- or other types -->
                <select name="searchtype">
                        <option value="article">pages</option>
                        <option value="forum">conversations</option>
                        <option value="user">members</option>
                </select> &nbsp;<xsl:call-template name="t_submitsearch"/>
        </xsl:template>
        <!--
       <xsl:attribute-set name="it_searchstring"/>
       Use: Presentation attributes for the search input field
        -->
        <xsl:attribute-set name="it_searchstring">
                <xsl:attribute name="maxlength">24</xsl:attribute>
                <xsl:attribute name="size">10</xsl:attribute>
                <xsl:attribute name="class">category-a-b</xsl:attribute>
                <xsl:attribute name="id">category-search</xsl:attribute>
        </xsl:attribute-set>
        <!--
       <xsl:attribute-set name="it_submitsearch"/>
       Use: Presentation attributes for the search submit button
        -->
        <xsl:attribute-set name="it_submitsearch">
                <xsl:attribute name="type">image</xsl:attribute>
                <xsl:attribute name="src">
                        <xsl:value-of select="concat($imagesource,'buttons/banner_search_submit.gif')"/>
                </xsl:attribute>
                <xsl:attribute name="width">19</xsl:attribute>
                <xsl:attribute name="height">19</xsl:attribute>
                <xsl:attribute name="border">0</xsl:attribute>
                <xsl:attribute name="alt">search collective</xsl:attribute>
        </xsl:attribute-set>
        <!--
       <xsl:attribute-set name="fc_search_dna"/>
       Use: Presentation attributes for the search form element
        -->
        <xsl:attribute-set name="fc_search_dna">
                <xsl:attribute name="id">category-search</xsl:attribute>
        </xsl:attribute-set>
        <!-- COLLECTIVE REFRESH -->
        <xsl:template name="category-content">
                <xsl:param name="articleNode" select="/H2G2/HIERARCHYDETAILS/ARTICLE"/>
                <div id="category-content">
                        <script type="text/javascript">
                                //<![CDATA[
                                        // function to swap the tabs
                                        function changeTab(from, to){
                                                document.getElementById(from + '-content-tab').style.display ='none';
                                                document.getElementById(from + '-content').style.display ='none';
                                                document.getElementById(to + '-content-tab').style.display ='block';
                                                document.getElementById(to + '-content').style.display ='block';
                                                return false;
                                        }
                                //]]>
                        </script>
                        <xsl:call-template name="grid-column-1">
                                <xsl:with-param name="articleNode" select="$articleNode" />
                        </xsl:call-template>
                        <xsl:call-template name="grid-column-2"/>
                        <div class="clear"/>
                </div>
        </xsl:template>
        <xsl:template name="grid-column-1">
                <xsl:param name="articleNode" select="/H2G2/HIERARCHYDETAILS/ARTICLE"/>
                <xsl:variable name="content-view">
                        <xsl:choose>
                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_content_view']">
                                        <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_content_view']/VALUE"/>
                                </xsl:when>
                                <xsl:otherwise>editors</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <div class="{$content-view}-view" id="grid-column-1">
                        <xsl:apply-templates select="$articleNode/GUIDE/BODY/PROMO"/>
                        <xsl:call-template name="content">
                                <xsl:with-param name="articleNode" select="$articleNode"/>
                                <xsl:with-param name="content-type" select="'editors'"/>
                        </xsl:call-template>
                        <xsl:call-template name="content">
                                <xsl:with-param name="articleNode" select="$articleNode"/>
                                <xsl:with-param name="content-type" select="'members'"/>
                        </xsl:call-template>
                </div>
        </xsl:template>
        <xsl:template name="grid-column-2">
                <div id="grid-column-2">
                        <xsl:if test="string-length(/H2G2/SITECONFIG/ARCHIVEPICK)">
                                <xsl:apply-templates select="/H2G2/SITECONFIG/ARCHIVEPICK"/>
                        </xsl:if>
                        <xsl:if test="string-length(/H2G2/HIERARCHYDETAILS)">
                                <xsl:apply-templates select="/H2G2/HIERARCHYDETAILS"/>
                        </xsl:if>
                        <xsl:if test="string-length(/H2G2/SITECONFIG/PLAYLIST)">
                                <xsl:apply-templates select="/H2G2/SITECONFIG/PLAYLIST"/>
                        </xsl:if>
                </div>
        </xsl:template>
        <xsl:template name="content">
                <xsl:param name="articleNode" select="/H2G2/HIERARCHYDETAILS/ARTICLE" /> 
                <xsl:param name="content-type"/>
                <xsl:variable name="change-content">
                        <xsl:choose>
                                <xsl:when test="$content-type = 'editors'">members</xsl:when>
                                <xsl:otherwise>editors</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <div id="{$content-type}-content-tab">
                        <ul>
                                <li>
                                        <a href="?s_content_view={$change-content}" onclick="return changeTab('{$content-type}', '{$change-content}')">
                                                <span class="hidden"><xsl:value-of select="$change-content"/> content</span>
                                        </a>
                                </li>
                        </ul>
                </div>
                <div id="{$content-type}-content">
                        <ol>
                                <xsl:choose>
                                        <xsl:when test="$content-type = 'editors'">
                                                <xsl:apply-templates select="$articleNode/GUIDE/BODY/CONTENT[@TYPE = 'EDITORS']"/>
                                        </xsl:when>
                                        <xsl:when test="$content-type = 'members'">
                                                <xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME = concat($displayname, '_members')]/ITEM-LIST/ITEM[position() &lt;= 10]">
                                                        <xsl:sort select="DATE-UPDATED/DATE/@SORT" order="descending" />
                                                        <xsl:apply-templates select="."/>
                                                </xsl:for-each>
                                        </xsl:when>
                                </xsl:choose>
                        </ol>
                </div>
        </xsl:template>
</xsl:stylesheet>
