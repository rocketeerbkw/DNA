<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-userpage.xsl"/>
        <!--
	<xsl:variable name="limiteentries" select="10"/>
	Use: sets the number of recent conversations and articles to display
	 -->
        <xsl:variable name="postlimitentries" select="10"/>
        <xsl:variable name="articlelimitentries" select="10"/>
        <xsl:variable name="clublimitentries" select="10"/>
        <!-- Page Level template -->
        <xsl:template name="USERPAGE_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">USERPAGE_MAINBODY test variable = <xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">userpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:apply-templates mode="c_displayuserpage" select="/H2G2"/>
        </xsl:template>
        <xsl:template match="H2G2" mode="r_displayuserpage">
                <xsl:apply-templates mode="c_userpageclipped" select="CLIP"/>
                <!-- my space title -->
                <div class="generic-u">
                        <table border="0" cellpadding="0" cellspacing="0" width="595">
                                <tr>
                                        <td width="470">
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong>my space</strong>
                                                </xsl:element>
                                        </td>
                                        <td align="right">
                                                <xsl:copy-of select="$content.by"/>
                                        </td>
                                </tr>
                        </table>
                </div>
                <!-- my space user name -->
                <xsl:apply-templates mode="c_usertitle" select="/H2G2/PAGE-OWNER"/>
                <!-- my intro -->
                <a id="intro" name="intro"/>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <!-- * my intro column 1 -->
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <div class="myspace-a">
                                                <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                        <tr>
                                                                <td>
                                                                        <xsl:copy-of select="$myspace.intro"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                                <strong>
                                                                                        <xsl:value-of select="$m_intro"/>
                                                                                </strong>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                <a href="#conversations">conversations</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#messages">messages</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#portfolio">portfolio</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#weblog">weblog</a>
                                                                        </xsl:element>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                        <div class="myspace-b">
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <!-- my intro subject -->
                                                        <strong>
                                                                <xsl:value-of select="ARTICLE/SUBJECT"/>
                                                        </strong>
                                                        <xsl:if test="ARTICLE/SUBJECT">
                                                                <br/>
                                                        </xsl:if>
                                                        <!-- my intro content -->
                                                        <xsl:apply-templates mode="t_userpageintro" select="PAGE-OWNER"/>
                                                </xsl:element>
                                        </div>
                                        <div class="myspace-b">
                                                <!-- SEND TO A FRIEND -->
                                                <table border="0" cellpadding="2" cellspacing="0" width="390">
                                                        <xsl:if test="/H2G2/JOURNAL/JOURNALPOSTS[descendant::POST!='']">
                                                                <tr>
                                                                        <td colspan="2">
                                                                                <div class="icon-send-to-friend">
                                                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                                                <img align="middle" border="0" height="21" src="{$imagesource}icons/white/my_weblog.gif" width="20"/>
                                                                                                <xsl:text>  </xsl:text>
                                                                                                <a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
                                                                                                    <xsl:attribute name="HREF">
                                                                                                    <xsl:value-of select="$root"/>MJ<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"
                                                                                                    />?Journal=<xsl:value-of select="/H2G2/JOURNAL/JOURNALPOSTS/@FORUMID"
                                                                                                    /></xsl:attribute>read my weblog</a>
                                                                                        </xsl:element>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                        </xsl:if>
                                                        <tr>
                                                                <td>
                                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                                <xsl:copy-of select="$coll_sendtoafriend"/>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">
                                                                        <!-- COMPLAIN - dont show on editorial -->
                                                                        <xsl:if test="not($article_authortype='editor')">
                                                                                <a
                                                                                        href="javascript:popupwindow('/dna/collective/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')"
                                                                                        xsl:use-attribute-sets="maHIDDEN_r_complainmp">
                                                                                        <xsl:copy-of select="$alt_complain"/>
                                                                                </a>
                                                                        </xsl:if>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <xsl:if test="not(/H2G2/ARTICLE/ARTICLEINFO/SITEID = 9)">
                                                        <div>
                                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                        <strong>
                                                                                <xsl:copy-of select="$m_memberofothersite"/>
                                                                        </strong>
                                                                </xsl:element>
                                                        </div>
                                                        <br/>
                                                </xsl:if>
                                        </div>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                        <!-- (not in design) <xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/> -->
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <!-- * my intro column 2 -->
                                <!-- my intro right panel -->
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s-b</xsl:attribute>
                                        <!-- my intro tips heading -->
                                        <div class="myspace-r">
                                                <xsl:copy-of select="$myspace.tips"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">intro</strong>
                                                </xsl:element>
                                        </div>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- my conversation -->
                <a id="conversation" name="conversations"/>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <!-- * my conversations column 1 -->
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <div class="myspace-a">
                                                <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                        <tr>
                                                                <td>
                                                                        <xsl:copy-of select="$myspace.conversations"/>&nbsp; <xsl:element name="{$text.subheading}"
                                                                                use-attribute-sets="text.subheading">
                                                                                <strong>
                                                                                        <xsl:value-of select="$m_mostrecentconv"/>
                                                                                </strong>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                <a href="#intro">intro</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#messages">messages</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#portfolio">portfolio</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#weblog">weblog</a>
                                                                        </xsl:element>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                       
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="c_userpage" select="RECENT-POSTS"/>
                                        </xsl:element>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <!-- * my conversations column 2 -->
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s</xsl:attribute>
                                        <!-- my conversations tips heading -->
                                        <div class="myspace-r">
                                                <xsl:copy-of select="$myspace.tips"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">conversations</strong>
                                                </xsl:element>
                                        </div>

                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- my messages -->
                <a name="messages"/>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <!-- * my messages column 1 -->
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <div class="myspace-a">
                                                <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                        <tr>
                                                                <td>
                                                                        <xsl:copy-of select="$myspace.messages"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                                <strong>
                                                                                        <xsl:value-of select="$m_recentarticlethreads"/>
                                                                                </strong>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                <a href="#intro">intro</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#conversations">conversations</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#portfolio">portfolio</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#weblog">weblog</a>
                                                                        </xsl:element>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="c_userpage" select="ARTICLEFORUM"/>
                                        </xsl:element>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <!-- * my messages column 2 -->
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s</xsl:attribute>
                                        <!-- my conversations tips heading -->
                                        <div class="myspace-r">
                                                <xsl:copy-of select="$myspace.tips"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">messages</strong>
                                                </xsl:element>
                                        </div>
                                        <xsl:copy-of select="$tips_userpage_mymessages"/>
                                        <br/>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- my editorial -->
                <xsl:if test="$test_UserHasCollectiveEditorial">
                        <a name="editorial"/>
                        <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                        <!-- * my editorial column 1 -->
                                        <xsl:element name="td" use-attribute-sets="column.1">
                                                <div class="myspace-a">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                                <tr>
                                                                        <td>
                                                                                <xsl:copy-of select="$myspace.editorial"/>&nbsp; <xsl:element name="{$text.subheading}"
                                                                                        use-attribute-sets="text.subheading">
                                                                                        <strong>
                                                                                                <xsl:value-of select="$m_recentapprovals"/>
                                                                                        </strong>
                                                                                </xsl:element>
                                                                        </td>
                                                                        <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                        <a href="#intro">intro</a>
                                                                                        <xsl:text> &#8226; </xsl:text>
                                                                                        <a href="#conversations">conversations</a>
                                                                                        <xsl:text> &#8226; </xsl:text>
                                                                                        <a href="#portfolio">portfolio</a>
                                                                                        <xsl:text> &#8226; </xsl:text>
                                                                                        <a href="#weblog">weblog</a>
                                                                                </xsl:element>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                </div>
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <xsl:apply-templates mode="c_userpage" select="RECENT-APPROVALS"/>
                                                </xsl:element>
                                                <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                        </xsl:element>
                                        <xsl:element name="td" use-attribute-sets="column.3">
                                                <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                        </xsl:element>
                                        <!-- * my editorial column 2 -->
                                        <xsl:element name="td" use-attribute-sets="column.2">
                                                <xsl:attribute name="id">myspace-s</xsl:attribute>
                                                <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                        </xsl:element>
                                </tr>
                        </table>
                </xsl:if>
                <!-- my portfolio -->
                <a name="portfolio"/>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <!-- * my portfolio column 1 -->
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <div class="myspace-a">
                                                <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                        <tr>
                                                                <td>
                                                                        <xsl:copy-of select="$myspace.portfolio"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                                <strong>
                                                                                        <xsl:value-of select="$m_recententries"/>
                                                                                </strong>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                <a href="#intro">intro</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#conversations">conversations</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#messages">messages</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#weblog">weblog</a>
                                                                        </xsl:element>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="c_userpage" select="RECENT-ENTRIES"/>
                                        </xsl:element>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <!-- * my portfolio column 2 -->
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s</xsl:attribute>
                                        <!-- my portfolio tips heading -->
                                        <div class="myspace-r">
                                                <xsl:copy-of select="$myspace.tips"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">portfolio</strong>
                                                </xsl:element>
                                        </div>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- my weblog -->
                <a id="weblog" name="weblog"/>
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <!-- * my weblog column 1 -->
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <div class="myspace-a">
                                                <table border="0" cellpadding="0" cellspacing="0" class="myspace-a">
                                                        <tr>
                                                                <td>
                                                                        <xsl:copy-of select="$myspace.weblog"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                                <strong>
                                                                                        <xsl:value-of select="$m_weblog"/>
                                                                                </strong>
                                                                        </xsl:element>
                                                                </td>
                                                                <td align="right">&nbsp; <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                <a href="#intro">intro</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#conversations">conversations</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#messages">messages</a>
                                                                                <xsl:text> &#8226; </xsl:text>
                                                                                <a href="#portfolio">portfolio</a>
                                                                        </xsl:element>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="c_userpage" select="JOURNAL"/>
                                        </xsl:element>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <!-- * my weblog column 2 -->
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s-a</xsl:attribute>
                                        <!-- my weblog tips heading -->
                                        <div class="myspace-r">
                                                <xsl:copy-of select="$myspace.tips"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">weblog</strong>
                                                </xsl:element>
                                        </div>
                                        <xsl:copy-of select="$tips_userpage_myweblog"/>
                                        <br/>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
                <!-- <xsl:apply-templates select="WATCHED-USER-LIST" mode="c_userpage"/> -->
                <xsl:call-template name="insert-articleerror"/>
        </xsl:template>
        <!-- my messages -->
        <!--
	<xsl:template match="ARTICLE" mode="r_taguser">
	Use: Presentation of the link to tag a user to the taxonomy
	 -->
        <xsl:template match="ARTICLE" mode="r_taguser">
                <xsl:apply-imports/>
                <br/>
                <br/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						ARTICLEFORUM Object for the userpage 
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="ARTICLEFORUM" mode="r_userpage">
                <!-- all my messages list -->
                <xsl:apply-templates mode="c_userpage" select="FORUMTHREADS"/>
                <!-- all my messages links -->
                <xsl:if test="FORUMTHREADS/@TOTALTHREADS >= 1">
                        <div class="myspace-h">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:copy-of select="$arrow.right"/>
                                        <xsl:apply-templates mode="r_viewallthreadsup" select="."/>
                                </xsl:element>
                        </div>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	 leave me a message
	-->
        <xsl:template match="@FORUMID" mode="c_leaveamessage">

        </xsl:template>
        <!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Description: Presentation of the 'Click to see more conversations' link
	 -->
        <xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	Description: Presentation of the 'Be the first person to talk about this article' link 

	 -->
        <xsl:template match="FORUMTHREADS" mode="empty_userpage">
                <xsl:choose>
                        <xsl:when test="$ownerisviewer = 1">
                                <div class="myspace-b">
                                        <xsl:value-of select="$m_nomessagesowner"/>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="myspace-b">
                                        <xsl:value-of select="$m_nomessages"/>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
        <xsl:template match="FORUMTHREADS" mode="full_userpage">
                <xsl:for-each select="THREAD[position()&lt;6]">
                        <div>
                                <xsl:attribute name="class">
                                        <xsl:choose>
                                                <xsl:when test="position() mod 2 = 0">myspace-e-1</xsl:when>
                                                <!-- alternate colours, MC -->
                                                <xsl:otherwise>myspace-e-2</xsl:otherwise>
                                        </xsl:choose>
                                </xsl:attribute>
                                <table border="0" cellpadding="0" cellspacing="0" width="395">
                                        <tr>
                                                <td class="myspace-e-3" rowspan="2" width="25">&nbsp;</td>
                                                <td class="brown">
                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                <strong>
                                                                        <xsl:apply-templates mode="c_userpage" select="."/>
                                                                </strong>
                                                        </xsl:element>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td class="orange">
                                                        <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"> message from <a href="{$root}U{FIRSTPOST/USER/USERID}">
                                                                        <xsl:apply-templates select="FIRSTPOST/USER/USERNAME"/>
                                                                </a> | <xsl:apply-templates mode="collective_long" select="FIRSTPOST/DATE"/>
                                                        </xsl:element>
                                                </td>
                                        </tr>
                                </table>
                        </div>
                </xsl:for-each>
        </xsl:template>
        <!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
        <xsl:template match="THREAD" mode="r_userpage">
                <xsl:apply-templates mode="t_threadtitlelinkup" select="@THREADID"/>
                <!-- last posting <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/> -->
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object for the userpage
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="REFERENCES" mode="r_userpagerefs">
                <b>References</b>
                <br/>
                <xsl:apply-templates mode="c_userpagerefs" select="ENTRIES"/>
                <xsl:apply-templates mode="c_userpagerefs" select="USERS"/>
                <xsl:apply-templates mode="c_userpagerefsbbc" select="EXTERNAL"/>
                <xsl:apply-templates mode="c_userpagerefsnotbbc" select="EXTERNAL"/>
        </xsl:template>
        <!-- 
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
        <xsl:template match="ENTRIES" mode="r_userpagerefs">
                <xsl:value-of select="$m_refentries"/>
                <br/>
                <xsl:apply-templates mode="c_userpagerefs" select="ENTRYLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
	Use: presentation of each individual entry link
	-->
        <xsl:template match="ENTRYLINK" mode="r_userpagerefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
        <xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
                <xsl:value-of select="$m_refresearchers"/>
                <br/>
                <xsl:apply-templates mode="c_userpagerefs" select="USERLINK"/>
                <br/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="USERLINK" mode="r_userpagerefs">
	Use: presentation of each individual link to a user in the references section
	-->
        <xsl:template match="USERLINK" mode="r_userpagerefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
	Use: presentation of of the 'List of external BBC sites' logical container
	-->
        <xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
                <xsl:value-of select="$m_otherbbcsites"/>
                <br/>
                <xsl:apply-templates mode="c_userpagerefsbbc" select="EXTERNALLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
	Use: presentation of of the 'List of external non-BBC sites' logical container
	-->
        <xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
                <xsl:value-of select="$m_refsites"/>
                <br/>
                <xsl:apply-templates mode="c_userpagerefsnotbbc" select="EXTERNALLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
        <xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
        <xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- my weblog -->
        <!--
	<xsl:template match="JOURNAL" mode="r_userpage">
	Description: Presentation of the object holding the userpage journal
	 -->
        <xsl:template match="JOURNAL" mode="r_userpage">
                <div class="myspace-b">
                        <xsl:apply-templates mode="t_journalmessage" select="."/>
                </div>
                <!-- only show first post -->
                <xsl:apply-templates mode="c_userpagejournalentries" select="JOURNALPOSTS/POST[1]"/>
                <xsl:apply-templates mode="c_moreuserpagejournals" select="JOURNALPOSTS"/>
        </xsl:template>
        <!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Description: Presentation of the 'click here to see more entries' link if appropriate
	 -->
        <xsl:template match="JOURNALPOSTS" mode="c_moreuserpagejournals">
                <div class="myspace-h">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$arrow.right"/>
                                <xsl:apply-templates mode="r_moreuserpagejournals" select="."/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the JOURNAL 'more entries' button 
	-->
        <xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
                <xsl:param name="img" select="$m_clickmorejournal"/>
                <a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
                        <xsl:attribute name="HREF"><xsl:value-of select="$root"/>MJ<xsl:value-of select="../../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="@FORUMID"/></xsl:attribute>
                        <xsl:copy-of select="$img"/>
                </a>
        </xsl:template>
        <!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Description: Presentation of the 'add a journal entry' link if appropriate
	 -->
        <xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">

        </xsl:template>
        <!--
	<xsl:template match="POST" mode="r_userpagejournalentries">
	Description: Presentation of a single Journal post
	 -->
        <xsl:template match="POST" mode="r_userpagejournalentries">
                <div class="myspace-e-4">
                        <table border="0" cellpadding="0" cellspacing="0" width="395">
                                <tr>
                                        <td>
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base"> &nbsp;<strong>latest weblog</strong>
                                                </xsl:element>
                                        </td>
                                        <td align="right" class="orange">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"> published <xsl:apply-templates mode="t_datejournalposted"
                                                                select="DATEPOSTED/DATE"/> | <xsl:apply-templates mode="c_lastjournalrepliesup" select="LASTREPLY"/>
                                                </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </div>
                <!-- blog title -->
                <div class="myspace-j">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
                                        <xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>
                                        <xsl:value-of select="SUBJECT"/>
                                </a>
                        </xsl:element>
                </div>
                <div class="myspace-b">
                        <xsl:apply-templates mode="t_journaltext" select="TEXT"/>
                </div>
                <!-- blog buttons -->
                <div class="myspace-h">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$arrow.right"/>
                                <!-- view comment --><a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of
                                                        select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>view</a>
                        </xsl:element>
                </div>
                <!-- TODO:23 - should this be here or not <div class="myspace-h">
			<font size="2">
			<xsl:copy-of select="$arrow.right" />
			remove blog entry <xsl:apply-templates select="@THREADID" mode="c_removejournalpostup"/>
			</font>
		</div>	-->
        </xsl:template>
        <!--
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
	Description: Object is used if there are replies to a journal entry
	 -->
        <xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
                <xsl:apply-templates mode="t_journalentriesreplies" select="../@THREADID"/>
                <!-- latest reply <xsl:value-of select="$m_latestreply"/><xsl:apply-templates select="../@THREADID" mode="t_journallastreply"/> -->
        </xsl:template>
        <xsl:template name="noJournalReplies">
                <xsl:value-of select="$m_noreplies"/>
        </xsl:template>
        <!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Description: Display of the 'remove journal entry' link if appropriate
	 -->
        <xsl:template match="@THREADID" mode="r_removejournalpost">
                <xsl:apply-imports/>
        </xsl:template>
        <!-- my conversation -->
        <!--
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest conversations the user
	has contributed to
	 -->
        <xsl:template match="RECENT-POSTS" mode="r_userpage">
                <!-- default text if no entries have been made -->
                <xsl:apply-templates mode="c_postlistempty" select="."/>
                <!-- the list of recent entries -->
                <xsl:apply-templates mode="c_postlist" select="POST-LIST"/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
        <xsl:template match="POST-LIST" mode="owner_postlist">
                <!-- <xsl:copy-of select="$m_forumownerfull"/> intro text -->
                <xsl:apply-templates mode="c_userpage" select="POST[position() &lt;=$postlimitentries][SITEID=9]"/>
                <xsl:if test="count(./POST)&gt;=1">
                        <!-- all my coversations link -->
                        <div class="myspace-h">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:copy-of select="$arrow.right"/>
                                        <xsl:apply-templates mode="c_morepostslink" select="USER/USERID"/>
                                </xsl:element>
                        </div>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
        <xsl:template match="POST-LIST" mode="viewer_postlist">
                <!-- <xsl:copy-of select="$m_forumviewerfull"/> -->
                <xsl:apply-templates mode="c_userpage" select="POST[position() &lt;=$postlimitentries][SITEID=9]"/>
                <!-- all my conversations link -->
                <xsl:if test="count(./POST)&gt;=1">
                        <div class="myspace-h">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:copy-of select="$arrow.right"/>
                                        <xsl:apply-templates mode="c_morepostslink" select="USER/USERID"/>
                                </xsl:element>
                        </div>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="USERID" mode="r_morepostslink">
	Description: Presentation of a link to 'see all posts'
	 -->
        <xsl:template match="USERID" mode="r_morepostslink">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
        <xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
                <div class="myspace-b">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$m_forumownerempty"/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
        <xsl:template match="RECENT-POSTS" mode="viewer_postlistempty">
                <div class="myspace-b">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$m_forumviewerempty"/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="POST-LIST/POST" mode="r_userpage">
	Description: Presentation of a single post in a list
	 -->
        <xsl:template match="POST-LIST/POST" mode="r_userpage">
                <!-- <xsl:value-of select="$m_fromsite"/> -->
                <!-- <xsl:apply-templates select="SITEID" mode="t_userpage"/>: -->
                <div>
                        <xsl:attribute name="class">
                                <xsl:choose>
                                        <xsl:when test="count(preceding-sibling::POST) mod 2 = 0">myspace-e-1</xsl:when>
                                        <!-- alternate colours, MC -->
                                        <xsl:otherwise>myspace-e-2</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                        <table border="0" cellpadding="0" cellspacing="0" width="395">
                                <tr>
                                        <td class="myspace-e-3" rowspan="2" width="25">&nbsp;</td>
                                        <td class="brown">
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <strong>
                                                                <xsl:apply-templates mode="t_userpagepostsubject" select="THREAD/@THREADID"/>
                                                        </strong>
                                                </xsl:element>
                                        </td>
                                        <td align="right">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:apply-templates mode="c_postunsubscribeuserpage" select="."/>
                                                </xsl:element>
                                        </td>
                                </tr>
                                <tr>
                                        <td class="orange" colspan="2">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:apply-templates mode="c_userpagepostdate" select="."/>
                                                        <xsl:if test="THREAD/LASTUSERPOST"> | </xsl:if>
                                                        <xsl:apply-templates mode="c_userpagepostlastreply" select="."/> | <xsl:value-of select="@COUNTPOSTS"/> comments </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="POST" mode="r_userpagepostdate">
	Description: Presentation of when the user posted date
	 -->
        <xsl:template match="POST" mode="r_userpagepostdate">
                <xsl:value-of select="$m_postedcolon"/>
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="POST" mode="r_userpagepostlastreply">
	Description: Presentation of the 'reply to a user posting' date
	 -->
        <xsl:template match="POST" mode="r_userpagepostlastreply">
                <xsl:apply-templates mode="t_lastreplytext" select="."/>
                <xsl:apply-templates mode="t_userpagepostlastreply" select="."/>
        </xsl:template>
        <!--
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
        <xsl:template match="POST" mode="r_postunsubscribeuserpage">
                <a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}"
                        xsl:use-attribute-sets="npostunsubscribe1">
                        <xsl:copy-of select="$m_removeme"/>
                </a>
        </xsl:template>
        <!-- my portfolio -->
        <xsl:template match="RECENT-ENTRIES" mode="r_userpage">
                <!-- <xsl:apply-templates select="." mode="c_userpagelistempty"/> -->
                <xsl:apply-templates mode="c_userpagelist" select="ARTICLE-LIST"/>
        </xsl:template>
        <xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
                <!-- list of reviews -->
                <div class="myspace-j">
                        <strong><xsl:value-of select="$m_memberormy"/> published reviews</strong>
                </div>
                <xsl:apply-templates mode="c_userpagelist_a" select="ARTICLE[position() &lt;=$articlelimitentries][not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9]"/>
                <!-- if no reviews -->
                <xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9][not(EXTRAINFO/TYPE/@ID='3001')]!=''])">
                        <div class="myspace-b">
                                <xsl:copy-of select="$m_ownerreviewempty"/>
                        </div>
                </xsl:if>
                <!-- list of pages -->
                <div class="myspace-j">
                        <strong><xsl:value-of select="$m_memberormy"/> other pages</strong>
                </div>
                <xsl:apply-templates mode="c_userpagelist_b" select="ARTICLE[position() &lt;=$articlelimitentries][EXTRAINFO/TYPE/@ID='2'][SITEID=9]"/>
                <!-- all reviews link -->
                <!-- if no pages -->
                <xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[EXTRAINFO/TYPE/@ID='2'][SITEID=9]!=''])">
                        <div class="myspace-b">
                                <xsl:copy-of select="$m_ownerpageempty"/>
                        </div>
                </xsl:if>
                <xsl:apply-templates mode="c_morearticles" select="."/>
                <!--xsl:call-template name="insert-moreartslink"/-->
                <!-- <xsl:call-template name="c_createnewarticle"/> -->
        </xsl:template>
        <!-- TODO:23 doesn't this duplicate the above template ? -->
        <!--
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer doesn`t owns
	 -->
        <xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
                <!-- list of reviews -->
                <div class="myspace-j">
                        <strong><xsl:value-of select="$m_memberormy"/> published reviews</strong>
                </div>
                <xsl:apply-templates mode="c_userpagelist" select="ARTICLE[position() &lt;=$articlelimitentries][not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9]"/>
                <!-- if no reviews -->
                <xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9][not(EXTRAINFO/TYPE/@ID='3001')]!=''])">
                        <div class="myspace-b">
                                <xsl:copy-of select="$m_reviewempty"/>
                        </div>
                </xsl:if>
                <!-- list of pages -->
                <div class="myspace-j">
                        <strong><xsl:value-of select="$m_memberormy"/> other pages</strong>
                </div>
                <xsl:apply-templates mode="c_userpagelist" select="ARTICLE[position() &lt;=$articlelimitentries][EXTRAINFO/TYPE/@ID='2'][SITEID=9]"/>
                <!-- if no pages -->
                <xsl:if test="not(/H2G2/RECENT-ENTRIES/ARTICLE-LIST[descendant::ARTICLE[EXTRAINFO/TYPE/@ID='2'][SITEID=9]!=''])">
                        <div class="myspace-b">
                                <xsl:copy-of select="$m_pageempty"/>
                        </div>
                </xsl:if>
                <!-- all reviews link -->
                <xsl:apply-templates mode="c_morearticles" select="."/>
                <!--xsl:call-template name="insert-moreartslink"/-->
                <!-- <xsl:apply-templates select="." mode="c_morearticles"/> -->
        </xsl:template>
        <!--
	<xsl:template name="r_createnewarticle">
	Description: Presentation of the 'create a new article' link
	 -->
        <xsl:template name="r_createnewarticle">
                <xsl:param name="content" select="$m_clicknewentry"/>
                <xsl:copy-of select="$content"/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
	Description: Presentation of the 'click to see more articles' link
	 -->
        <xsl:template match="ARTICLE-LIST" mode="r_morearticles">
                <div class="myspace-h">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$arrow.right"/>
                                <xsl:apply-imports/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer owns
	 -->
        <xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
                <div class="myspace-b">
                        <xsl:copy-of select="$m_artownerempty"/>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer doesn`t own
	 -->
        <xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
                <!-- 	<div class="myspace-b"><xsl:copy-of select="$m_artviewerempty"/></div> -->
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	Description: Presentation of a single article item within a list
	 -->
        <!--
	<xsl:template match="ARTICLE" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the ARTICLE container
	-->
        <xsl:template match="ARTICLE" mode="c_userpagelist">
                <xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">
                        <div>
                                <xsl:attribute name="class">
                                        <xsl:choose>
                                                <xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0">myspace-e-1</xsl:when>
                                                <!-- alternate colours, MC -->
                                                <xsl:otherwise>myspace-e-2</xsl:otherwise>
                                        </xsl:choose>
                                </xsl:attribute>
                                <xsl:apply-templates mode="r_userpagelist" select="."/>
                        </div>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the ARTICLE container
	-->
        <xsl:template match="ARTICLE" mode="c_userpagelist_a">
                <xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">
                        <div>
                                <xsl:attribute name="class">
                                        <xsl:choose>
                                                <xsl:when test="count(preceding-sibling::ARTICLE[not(EXTRAINFO/TYPE/@ID='2') and STATUS=3][SITEID=9]) mod 2 = 0">myspace-e-1</xsl:when>
                                                <!-- alternate colours, MC -->
                                                <xsl:otherwise>myspace-e-2</xsl:otherwise>
                                        </xsl:choose>
                                </xsl:attribute>
                                <xsl:apply-templates mode="r_userpagelist" select="."/>
                        </div>
                </xsl:if>
        </xsl:template>
        <xsl:template match="ARTICLE" mode="c_userpagelist_b">
                <xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">
                        <div>
                                <xsl:attribute name="class">
                                        <xsl:choose>
                                                <xsl:when test="count(preceding-sibling::ARTICLE[EXTRAINFO/TYPE/@ID='2'][SITEID=9]) mod 2 = 0">myspace-e-1</xsl:when>
                                                <!-- alternate colours, MC -->
                                                <xsl:otherwise>myspace-e-2</xsl:otherwise>
                                        </xsl:choose>
                                </xsl:attribute>
                                <xsl:apply-templates mode="r_userpagelist" select="."/>
                        </div>
                </xsl:if>
        </xsl:template>
        <xsl:template match="ARTICLE" mode="r_userpagelist">
                <table border="0" cellpadding="0" cellspacing="0" width="395">
                        <tr>
                                <td class="myspace-e-3" rowspan="2" width="25">&nbsp;</td>
                                <td class="brown">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <strong>
                                                        <xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"/>
                                                </strong>
                                        </xsl:element>
                                </td>
                                <td align="right" class="orange">
                                        <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                <strong>
                                                        <xsl:call-template name="article_subtype">
                                                                <xsl:with-param name="pagetype">nouser</xsl:with-param>
                                                        </xsl:call-template>
                                                </strong>
                                        </xsl:element>
                                </td>
                        </tr>
                        <tr>
                                <td class="orange">
                                        <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                <xsl:apply-templates mode="collective_long" select="DATE-CREATED/DATE"/>
                                        </xsl:element>
                                </td>
                                <td align="right">
                                        <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                <xsl:apply-templates mode="c_editarticle" select="H2G2-ID"/>
                                        </xsl:element>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- <xsl:template match="TYPE" mode="t_test">
		<xsl:value-of select="@ID" />
	</xsl:template> -->
        <!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Description: Presentation of the 'uncancel this article' link
	 -->
        <xsl:template match="H2G2-ID" mode="r_uncancelarticle"> (<xsl:apply-imports/>) </xsl:template>
        <!--
	<xsl:template match="H2G2-ID" mode="c_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Edit this article' link container
	-->
        <xsl:template match="H2G2-ID" mode="c_editarticle">

        </xsl:template>
        <!--
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	Description: Presentation of the 'edit this article' link
	 -->
        <xsl:template match="H2G2-ID" mode="r_editarticle">
                <!-- edit article -->
                <!-- uses m_edit for image -->
                <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={.}" xsl:use-attribute-sets="mH2G2-ID_r_editarticle">
                        <xsl:copy-of select="$m_editme"/>
                </a>
        </xsl:template>
        <!-- my editorial -->
        <!--
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
	Description: Presentation of the Edited Articles Object
	 -->
        <xsl:template match="RECENT-APPROVALS" mode="r_userpage">
                <font size="2">
                        <xsl:apply-templates mode="c_approvalslistempty" select="."/>
                </font>
                <xsl:apply-templates mode="c_approvalslist" select="ARTICLE-LIST"/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
        <xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
                <xsl:apply-templates mode="c_userpagelist" select="ARTICLE[position() &lt;=$articlelimitentries]"/>
                <xsl:apply-templates mode="c_moreeditedarticles" select="."/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
        <xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
                <!--<xsl:copy-of select="$m_editviewerfull"/>-->
                <xsl:apply-templates mode="c_userpagelist" select="ARTICLE[position() &lt;=$articlelimitentries]"/>
                <xsl:apply-templates mode="c_moreeditedarticles" select="."/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Description: Presentation of the 'See more edited articles' link
	 -->
        <xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
                <div class="myspace-h">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$arrow.right"/>
                                <xsl:apply-imports/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is the owner
	 -->
        <xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty">
                <xsl:copy-of select="$m_editownerempty"/>
        </xsl:template>
        <!--
	<xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is not the owner
	 -->
        <xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty">
                <xsl:copy-of select="$m_editviewerempty"/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

							PAGE-OWNER Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!--
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
	Description: Presentation of the Page Owner object
	 -->
        <xsl:template match="PAGE-OWNER" mode="r_userpage">
                <b>
                        <xsl:value-of select="$m_userdata"/>
                </b>
                <br/>
                <xsl:value-of select="$m_researcher"/>
                <xsl:value-of select="USER/USERID"/>
                <br/>
                <xsl:value-of select="$m_namecolon"/>
                <xsl:value-of select="USER/USERNAME"/>
                <br/>
                <xsl:apply-templates mode="c_inspectuser" select="USER/USERID"/>
                <xsl:apply-templates mode="c_editmasthead" select="."/>
                <xsl:apply-templates mode="c_addtofriends" select="USER/USERID"/>
                <xsl:apply-templates mode="c_userpage" select="USER/GROUPS"/>
        </xsl:template>
        <xsl:template match="PAGE-OWNER" mode="c_usertitle">
                <div class="myspace-o">
                        <table border="0" cellpadding="0" cellspacing="0" class="myspace-a-a" width="600">
                                <tr>
                                        <td>
                                                <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
                                                        <strong>
                                                                <xsl:value-of select="USER/USERNAME"/>
                                                        </strong>
                                                </xsl:element>
                                        </td>
                                        <td align="right" class="myspace-a-a">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"> member since: <strong>
                                                                        <xsl:apply-templates mode="collective_long" select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"/>
                                                                </strong>
                                                        </xsl:if>
                                                </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="USERID" mode="r_inspectuser">
	Description: Presentation of the 'Inspect this user' link
	 -->
        <xsl:template match="USERID" mode="r_inspectuser">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
	Description: Presentation of the 'Edit my Introduction' link
	 -->
        <xsl:template match="PAGE-OWNER" mode="r_editmasthead">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Description: Presentation of the 'Add to my friends' link
	 -->
        <xsl:template match="USERID" mode="r_addtofriends">
                <xsl:apply-imports/>
                <br/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="GROUPS" mode="r_userpage">
	Description: Presentation of the GROUPS object
	 -->
        <xsl:template match="GROUPS" mode="r_userpage">
                <xsl:value-of select="$m_memberof"/>
                <br/>
                <xsl:apply-templates/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="USER/GROUPS/*">
	Description: Presentation of the group name
	 -->
        <xsl:template match="USER/GROUPS/*">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Watched User Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
	Description: Presentation of the WATCHED-USER-LIST object
	 -->
        <xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
                <b>
                        <xsl:value-of select="$m_friends"/>
                </b>
                <br/>
                <xsl:apply-templates mode="t_introduction" select="."/>
                <br/>
                <xsl:apply-templates mode="c_watcheduser" select="USER"/>
                <xsl:apply-templates mode="c_friendsjournals" select="."/>
                <xsl:apply-templates mode="c_deletemany" select="."/>
                <br/>
                <hr/>
        </xsl:template>
        <!--
	<xsl:template match="USER" mode="r_watcheduser">
	Description: Presentation of the WATCHED-USER-LIST/USER object
	 -->
        <xsl:template match="USER" mode="r_watcheduser">test <xsl:apply-templates mode="t_watchedusername" select="."/>
                <br/>
                <xsl:apply-templates mode="t_watcheduserpage" select="."/>
                <br/>
                <xsl:apply-templates mode="t_watcheduserjournal" select="."/>
                <br/>
                <xsl:apply-templates mode="c_watcheduserdelete" select="."/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Description: Presentation of the 'Delete' link
	 -->
        <xsl:template match="USER" mode="r_watcheduserdelete">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
	Description: Presentation of the 'Views friends journals' link
	 -->
        <xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
	Description: Presentation of the 'Delete many friends' link
	 -->
        <xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								LINKS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="LINKS" mode="r_userpage">
                <xsl:apply-templates mode="t_folderslink" select="."/>
                <br/>
                <hr/>
        </xsl:template>
        <!-- POPUPCONVERSATIONS LINK -->
        <xsl:variable name="popupconvheight">340</xsl:variable>
        <xsl:variable name="popupconvwidth">277</xsl:variable>
        <xsl:template name="popupconversationslink">
                <xsl:param name="content" select="."/>
                <xsl:variable name="userid">
                        <xsl:choose>
                                <xsl:when test="@USERID">
                                        <xsl:value-of select="@USERID"/>
                                </xsl:when>
                                <xsl:when test="$registered=1">
                                        <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:if test="$userid > 0">
                        <xsl:variable name="upto">
                                <xsl:choose>
                                        <xsl:when test="@UPTO">
                                                <xsl:value-of select="@UPTO"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$curdate"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="target">
                                <xsl:choose>
                                        <xsl:when test="@TARGET">
                                                <xsl:value-of select="@TARGET"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text>conversation</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="width">
                                <xsl:choose>
                                        <xsl:when test="$popupconvwidth">
                                                <xsl:value-of select="$popupconvwidth"/>
                                        </xsl:when>
                                        <xsl:when test="@WIDTH">
                                                <xsl:value-of select="@WIDTH"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text>170</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="height">
                                <xsl:choose>
                                        <xsl:when test="$popupconvheight">
                                                <xsl:value-of select="$popupconvheight"/>
                                        </xsl:when>
                                        <xsl:when test="@HEIGHT">
                                                <xsl:value-of select="@HEIGHT"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text>400</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="poptarget">
                                <xsl:choose>
                                        <xsl:when test="@POPTARGET">
                                                <xsl:value-of select="@POPTARGET"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text>popupconv</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <a href="{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1"
                                onClick="popupwindow('{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1','{$poptarget}','width={$width},height={$height},resizable=yes,scrollbars=yes');return false;"
                                target="{$poptarget}">
                                <xsl:copy-of select="$content"/>
                        </a>
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template name="USERPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
        <xsl:template name="USERPAGE_HEADER">
                <xsl:apply-templates mode="header" select=".">
                        <xsl:with-param name="title">
                                <xsl:choose>
                                        <xsl:when test="ARTICLE/SUBJECT">
                                                <xsl:value-of select="$m_pagetitlestart"/>
                                                <!-- <xsl:value-of select="ARTICLE/SUBJECT"/> -->
                                                <xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>
                                                <!--  - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/> -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:choose>
                                                        <xsl:when test="$ownerisviewer = 1">
                                                                <xsl:value-of select="$m_pagetitlestart"/>
                                                                <xsl:value-of select="$m_pstitleowner"/>
                                                                <xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>.</xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:value-of select="$m_pagetitlestart"/>
                                                                <xsl:value-of select="$m_pstitleviewer"/>
                                                                <!-- <xsl:value-of select="PAGE-OWNER/USER/USERID"/>-->.</xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:with-param>
                </xsl:apply-templates>
        </xsl:template>
</xsl:stylesheet>
