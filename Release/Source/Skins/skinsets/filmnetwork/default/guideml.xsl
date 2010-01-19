<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template
                match="INPUT | input | SELECT | select | P | p | I | i | B | b | BLOCKQUOTE | blockquote | CAPTION | caption | CODE | code | OL | ol | PRE | pre | SUB | sub | SUP | sup | TABLE | table | TD | td | TH | th | TR | tr | BR | br | FONT| I | i | STRONG | strong">
                <xsl:copy>
                        <xsl:apply-templates select="*|@*|text()"/>
                </xsl:copy>
        </xsl:template>
        <xsl:template
                match="TABLE | table | TD | td | TH | th | TR | FONT| OL | ol  | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="SMILEY"> </xsl:template>
        <xsl:template match="ICON">
                <xsl:choose>
                        <xsl:when test="starts-with(@SRC|@BLOB,&quot;http://&quot;) or starts-with(@SRC|@BLOB,&quot;/&quot;)">
                                <xsl:comment>Off-site picture removed</xsl:comment>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:call-template name="renderimage"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="BANNER">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="HEADER">
                <xsl:choose>
                        <xsl:when test="parent::CRUMBTRAIL">
                                <span class="textxlarge">
                                        <xsl:apply-templates/>
                                </span>
                        </xsl:when>
                        <xsl:when test="parent::BLUE_HEADER_BOX">
                                <div class="biogname">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:when test="ancestor::LEFTCOL or ancestor::COLUMN1">
                                <div class="textxlarge">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:when test="ancestor::EDITORIAL-ITEM">
                                <div class="discussheader">
                                        <b>
                                                <xsl:apply-templates/>
                                        </b>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <strong>
                                        <xsl:apply-templates/>
                                </strong>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="SUBHEADER">
                <xsl:choose>
                        <xsl:when test="parent::CRUMBTRAIL">
                                <span class="textmedium">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </span>
                        </xsl:when>
                        <xsl:when test="parent::BLUE_HEADER_BOX">
                                <div class="whattodotitle">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:when test="ancestor::LEFTCOL">
                                <div class="textmedium">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:when test="parent::FUNDINGDETAILS">
                                <span class="textlightmedium">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </span>
                        </xsl:when>
                        <xsl:when test="parent::COLUMN1">
                                <span class="textmedium">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </span>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="CREDIT">
                <xsl:choose>
                        <xsl:when test="parent::PROMO">
                                <div class="smallsubmenu">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                        <xsl:when test="parent::LEFTCOL">
                                <div class="intocredit">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                        <xsl:when test="parent::ICON">
                                <div class="textsmall">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="CREDITLINKS">
                <div class="intodetails">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <!-- BODY -->
        <xsl:template match="BODY">
                <xsl:choose>
                        <xsl:when test="parent::BLUE_HEADER_BOX">
                                <div class="topboxcopy">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:when test="parent::FUNDINGDETAILS">
                                <span class="textbrightsmall">
                                        <xsl:apply-templates/>
                                </span>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="BODYTEXT">
                <div class="textmedium">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="SMALL">
                <div class="textxsmall">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="LI/SMALL">
                <span class="small">
                        <xsl:apply-templates/>
                </span>
        </xsl:template>
        <xsl:template match="LARGETEXT">
                <div class="textxlarge">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="ICON">
                <table border="0" cellpadding="0" cellspacing="0" width="370">
                        <xsl:if test="count(../ICON) &gt; 1">
                                <tr>
                                        <td colspan="2" height="10"/>
                                </tr>
                        </xsl:if>
                        <tr>
                                <td align="right" valign="middle" width="243">
                                        <div class="textmedium">
                                                <strong>
                                                        <xsl:apply-templates select="LINK[1]"/>
                                                </strong>
                                        </div>
                                        <xsl:apply-templates select="CREDIT"/>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="BODY"/>
                                                <xsl:apply-templates select="BUTTONLINK"/>
                                        </div>
                                        <xsl:apply-templates select="LINK[2]"/>
                                </td>
                                <td align="right" valign="top" width="128">
                                        <xsl:apply-templates select="IMG"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="RIGHTCOLBOX">
                <div class="rightcolbox">
                        <xsl:apply-templates select="IMG"/>
                        <div class="textlightsmall">
                                <xsl:apply-templates select="BODY"/>
                        </div>
                        <div class="textbrightsmall">
                                <xsl:apply-templates select="UL"/>
                                <xsl:apply-templates select="SUBSCRIBEFIELD"/>
                        </div>
                </div>
                <!-- 10px Spacer table -->
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td height="10"/>
                        </tr>
                </table>
                <!-- END 10px Spacer table -->
        </xsl:template>
        <xsl:template match="COLUMN">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td align="right" valign="top">
                                        <xsl:apply-templates select="LEFTCOL"/>
                                </td>
                                <td><!-- 10px spacer column --></td>
                                <td class="introdivider"><!-- 10px spacer column -->&nbsp;</td>
                                <td valign="top">
                                        <xsl:apply-templates select="RIGHTCOL"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="LEFTCOL">
                <xsl:apply-templates select="*|@*|text()"/>
        </xsl:template>
        <xsl:template match="RIGHTCOL">
                <xsl:apply-templates select="*|@*|text()"/>
        </xsl:template>
        <xsl:template match="RIGHTCOLTOP">
                <div class="intorightcolumn">
                        <xsl:apply-templates select="*|@*|text()"/>
                </div>
        </xsl:template>
        <xsl:template match="LI|li">
                <li>
                        <xsl:choose>
                                <xsl:when test="parent::UL[@TYPE = 'FILMMAKING_INDEX']">
                                        <xsl:attribute name="class">index_categories</xsl:attribute>
                                        <span>
                                                <xsl:apply-templates select="text()"/>
                                        </span>
                                        <xsl:apply-templates select="*|@*"/>
                                </xsl:when>
                                <xsl:when test="parent::UL/parent::LI/parent::UL[@TYPE = 'FILMMAKING_INDEX']">
                                        <xsl:attribute name="class">index_items</xsl:attribute>
                                        <xsl:apply-templates select="*|@*|text()"/>
                                </xsl:when>
                                <xsl:when test="parent::UL/parent::RIGHTCOLBOX">
                                        <xsl:attribute name="class">rightcolboxlist</xsl:attribute>
                                        <xsl:apply-templates select="*|@*|text()"/>
                                </xsl:when>
                                <xsl:when test="parent::UL/parent::BLUERIGHTSECTION">
                                        <xsl:attribute name="class">rightcolboxlist</xsl:attribute>
                                        <xsl:apply-templates select="*|@*|text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:apply-templates select="*|@*|text()"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </li>
        </xsl:template>
        <xsl:template match="UL|ul">
                <ul>
                        <xsl:choose>
                                <xsl:when test="parent::FESTIVALAWARDS or ancestor::COLUMN1 or ancestor::LEFTCOL">
                                        <xsl:attribute name="class">centcollist</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="parent::RIGHTCOLBOX or parent::BLUE_RIGHT_BOX or parent::BLUERIGHTSECTION">
                                        <xsl:attribute name="class">rightcolboxlist</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="ancestor::FUNDINGDETAILS">
                                        <xsl:attribute name="class">rightcollistround</xsl:attribute>
                                </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates select="*|@*|text()"/>
                </ul>
        </xsl:template>
        <xsl:template match="OL|ol">
                <ol>
                        <xsl:choose>
                                <xsl:when test="parent::FESTIVALAWARDS or ancestor::COLUMN1 or ancestor::LEFTCOL">
                                        <xsl:attribute name="class">centcollist</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="parent::RIGHTCOLBOX or ancestor::BODYTEXT or parent::BLUERIGHTSECTION">
                                        <xsl:attribute name="class">rightcolboxlist</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="ancestor::FUNDINGDETAILS">
                                        <xsl:attribute name="class">rightcollistround</xsl:attribute>
                                </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates select="*|@*|text()"/>
                </ol>
        </xsl:template>
        <xsl:template match="A">
                <a>
                        <xsl:choose>
                                <xsl:when test="ancestor::BLUERIGHTSECTION">
                                        <xsl:attribute name="class">rightcol</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise> </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
                </a>
        </xsl:template>
        <xsl:template match="LINK">
                <xsl:choose>
                        <xsl:when test="@CTA='article'">
                                <div class="{@TYPE}">
                                        <a>
                                                <xsl:attribute name="href">
                                                        <xsl:call-template name="sso_typedarticle_signin">
                                                                <xsl:with-param name="type" select="1"/>
                                                        </xsl:call-template>
                                                </xsl:attribute>
                                        </a>
                                </div>
                        </xsl:when>
                        <xsl:when test="@DIVCLASS">
                                <div class="{@DIVCLASS}">
                                        <a>
                                                <xsl:attribute name="href">
                                                        <xsl:value-of select="$root"/>
                                                        <xsl:value-of select="@DNAID"/>
                                                </xsl:attribute>
                                                <xsl:apply-templates mode="long_link" select="."/>
                                                <xsl:apply-templates select="IMG"/>
                                        </a>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <a xsl:use-attribute-sets="mLINK">
                                        <xsl:choose>
                                                <xsl:when test="@CLASS">
                                                        <xsl:attribute name="class">
                                                                <xsl:value-of select="@CLASS"/>
                                                        </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:choose>
                                                                <xsl:when test="parent::BODY/parent::BLUERIGHTSECTION">
                                                                        <xsl:attribute name="class">rightcolbold</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:when test="ancestor::BLUERIGHTSECTION">
                                                                        <xsl:attribute name="class">rightcol</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:when test="ancestor::BLUE_RIGHT_BOX">
                                                                        <xsl:attribute name="class">rightcol</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:when test="parent::CREDIT/parent::PROMO">
                                                                        <xsl:attribute name="class">textdark</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:when test="parent::CREDIT">
                                                                        <xsl:attribute name="class">textdark</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:when test="ancestor::FUNDINGDETAILS">
                                                                        <xsl:attribute name="class">rightcol</xsl:attribute>
                                                                </xsl:when>
                                                                <xsl:otherwise> </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:call-template name="dolinkattributes"/>
                                        <xsl:apply-templates mode="long_link" select="./text()"/>
                                        <xsl:apply-templates select="IMG"/>
                                        <xsl:apply-templates select="IMAGE"/>
                                        <!-- added img tag here -->
                                </a>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- LINK ATTRIBUTES -->
        <xsl:attribute-set name="linkatt">
                <xsl:attribute name="class">
                        <xsl:choose>
                                <xsl:when test="@TYPE='logo'">genericlink</xsl:when>
                                <xsl:when test="@TYPE='banner'"/>
                                <xsl:otherwise>genericlink</xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
        </xsl:attribute-set>
        <!-- IMG -->
        <xsl:template match="IMG | img">
                <xsl:choose>
                        <xsl:when test="@DNAID | @HREF">
                                <a>
                                        <xsl:apply-templates select="@DNAID | @HREF"/>
                                        <img border="0" src="{$imagesource}{@NAME}">
                                                <xsl:apply-templates select="*|@*|text()"/>
                                        </img>
                                </a>
                        </xsl:when>
                        <xsl:when test="@CTA='submission'">
                                <a>
                                        <xsl:attribute name="href">
                                                <xsl:call-template name="sso_typedarticle_signin">
                                                        <xsl:with-param name="type" select="30"/>
                                                </xsl:call-template>
                                        </xsl:attribute>
                                        <img border="0" src="{$imagesource}{@NAME}">
                                                <xsl:apply-templates select="*|@*|text()"/>
                                        </img>
                                </a>
                        </xsl:when>
                        <xsl:otherwise>
                                <img border="0" src="{$imagesource}{@NAME}">
                                        <xsl:apply-templates select="*|@*|text()"/>
                                </img>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="RIGHTNAVBOX">
                <div class="rightnavbox">
                        <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
                                <xsl:apply-templates/>
                        </xsl:element>
                </div>
        </xsl:template>
        <xsl:template match="ROW">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
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
                                <xsl:apply-templates/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="EDITORIAL-ITEM">
                <td valign="top">
                        <xsl:choose>
                                <xsl:when test="position() = 1">
                                        <xsl:attribute name="width">371</xsl:attribute>
                                        <xsl:attribute name="align">right</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:attribute name="width">244</xsl:attribute>
                                </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates/>
                </td>
                <xsl:if test="not(position()=last())">
                        <td>&nbsp;</td>
                </xsl:if>
        </xsl:template>
        <xsl:template match="hr|HR|LINE">
                <hr class="line"/>
        </xsl:template>
        <xsl:template match="TITLEDISCUSS">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="TEXTAREA">
                <form>
                        <xsl:copy>
                                <xsl:apply-templates select="*|@*|text()"/>
                        </xsl:copy>
                </form>
        </xsl:template>
        <xsl:template match="INPUT[@SRC]">
                <xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
        </xsl:template>
        <xsl:template match="PICTURE" mode="display">
                <div align="center">
                        <xsl:call-template name="renderimage"/>
                </div>
                <xsl:call-template name="insert-caption"/>
        </xsl:template>
        <xsl:template match="GREYLINESPACER">
                <!-- Grey line spacer -->
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <td height="17">
                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="100%"/>
                                </td>
                        </tr>
                </table>
                <!-- END Grey line spacer -->
        </xsl:template>
        <xsl:template match="GREYLINESPACER_SHORT">
                <!-- Grey line spacer -->
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td height="17">
                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                </td>
                        </tr>
                </table>
                <!-- END Grey line spacer -->
        </xsl:template>
        <xsl:template match="BLACKLINESPACER">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <td height="10"/>
                        </tr>
                        <tr>
                                <td class="darkestbg" height="2"/>
                        </tr>
                        <tr>
                                <td height="20"/>
                        </tr>
                </table>
                <!-- END 2px Black rule -->
        </xsl:template>
        <xsl:template match="SUBSCRIBEFIELD">
                <form action="" id="banner" method="post" name="banner">
                        <!-- trent -->
                        <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                        <td colspan="2" height="5"/>
                                </tr>
                                <tr>
                                        <td>
                                                <xsl:apply-templates select="INPUTSUBSCRIBE[@TYPE='TEXT']"/>
                                        </td>
                                        <td>
                                                <xsl:apply-templates select="INPUTSUBSCRIBE[@TYPE='IMAGE']"/>
                                        </td>
                                </tr>
                        </table>
                </form>
        </xsl:template>
        <xsl:template match="INPUTSUBSCRIBE">
                <xsl:choose>
                        <xsl:when test="@TYPE='TEXT'">
                                <input class="newsletter" name="textfield" size="10" type="text"/>
                        </xsl:when>
                        <xsl:when test="@TYPE='IMAGE'">
                                <input alt="Subscribe to newsletter" border="0" height="13" src="{$imagesource}furniture/{@NAME}" type="image" width="74"/>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="CATEGORYHEAD">
                <!-- table for head of cat pages -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td valign="top" width="371">
                                        <xsl:apply-templates select="CATEGORYLEFTCOLUMN"/>
                                </td>
                                <td width="10">&nbsp;</td>
                                <td valign="top" width="254">
                                        <xsl:apply-templates select="CATEGORYRIGHTCOLUMN"/>
                                </td>
                        </tr>
                        <tr>
                                <td height="10" width="371">
                                        <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                                </td>
                                <td width="10">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td width="254">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="254"/>
                                </td>
                        </tr>
                </table>
                <!-- end table for head of filmgenre.htm -->
        </xsl:template>
        <xsl:template match="CATEGORYRIGHTCOLUMN">
                <xsl:if test="HEADER">
                        <div class="discussheader">
                                <b>
                                        <xsl:apply-templates select="HEADER"/>
                                </b>
                        </div>
                </xsl:if>
                <div class="newdramaheader">
                        <xsl:apply-templates select="IMG[1]"/>
                </div>
                <div class="newdramarollover">
                        <xsl:apply-templates select="IMG[2]"/>
                </div>
                <div class="newdramasmallmenu">
                        <xsl:apply-templates select="CREDIT"/>
                </div>
                <div class="textmediumgrey">
                        <xsl:apply-templates select="BODY"/>
                </div>
        </xsl:template>
        <!-- ###########################################
                   SITECONFIG
	 ###########################################-->
        <xsl:template match="/H2G2/SITECONFIG/MOSTWATCHED">
                <!-- most watched shorts all -->
                <!-- top with angle -->
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" valign="top" width="172">
                                        <div class="mostwatched">
                                                <strong>
                                                        <xsl:apply-templates select="HEADER"/>
                                                </strong>
                                        </div>
                                </td>
                                <td class="anglebg" valign="top" width="72">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <!-- END top with angle -->
                <!-- most watched shorts content -->
                <table border="0" cellpadding="0" cellspacing="1" class="webboxbg" width="244">
                        <xsl:apply-templates select="MWSHORT"/>
                </table>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='MOSTWATCHED']/VALUE">
                <!-- most watched shorts all -->
                <!-- top with angle -->
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" valign="top" width="172">
                                        <div class="mostwatched">
                                                <strong>
                                                        <xsl:apply-templates select="HEADER"/>
                                                </strong>
                                        </div>
                                </td>
                                <td class="anglebg" valign="top" width="72">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <!-- END top with angle -->
                <!-- most watched shorts content -->
                <table border="0" cellpadding="0" cellspacing="1" class="webboxbg" width="244">
                        <xsl:apply-templates select="MWSHORT"/>
                </table>
        </xsl:template>
        <xsl:template match="MWSHORT">
                <tr>
                        <td align="right" valign="top" width="51">
                                <img alt="1" height="30" src="{$imagesource}furniture/filmlength/big{position()}.gif" width="28"/>
                        </td>
                        <td valign="top" width="30">
                                <xsl:apply-templates select="IMG"/>
                        </td>
                        <td valign="top" width="163">
                                <div class="mostwatchedtitle">
                                        <strong>
                                                <xsl:apply-templates select="LINK"/>
                                        </strong>
                                </div>
                                <div class="mostwatchedmenu">
                                        <xsl:apply-templates select="CREDIT"/>
                                </div>
                        </td>
                </tr>
                <tr>
                        <td colspan="3" height="14" valign="top" width="244"/>
                </tr>
        </xsl:template>
        <xsl:template match="/H2G2/SITECONFIG/SUBMITFILM">
                <table border="0" cellpadding="0" cellspacing="0" width="243">
                        <tr>
                                <td class="darkbg" valign="top">
                                        <div class="rightcolsubmit">
                                                <a>
                                                        <xsl:attribute name="href">
                                                                <xsl:call-template name="sso_typedarticle_signin">
                                                                        <xsl:with-param name="type" select="30"/>
                                                                </xsl:call-template>
                                                        </xsl:attribute>
                                                        <xsl:apply-templates select="IMG"/>
                                                </a>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="GUIDE/FILM_PROMO">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="GUIDE/RELATED_FEATURES">
                <!-- Alistair: need to add code for related features -->
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='SUBMITFILM']/VALUE">
                <table border="0" cellpadding="0" cellspacing="0" width="243">
                        <tr>
                                <td class="darkbg" valign="top">
                                        <div class="rightcolsubmit">
                                                <a>
                                                        <xsl:attribute name="href">
                                                                <xsl:call-template name="sso_typedarticle_signin">
                                                                        <xsl:with-param name="type" select="30"/>
                                                                </xsl:call-template>
                                                        </xsl:attribute>
                                                        <xsl:apply-templates select="IMG"/>
                                                </a>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="/H2G2/SITECONFIG/RECENTRELEASES">
                <xsl:choose>
                        <xsl:when test="$article_subtype = 'drama'">
                                <xsl:apply-templates select="DRAMA"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'comedy'">
                                <xsl:apply-templates select="COMEDY"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'experimental'">
                                <xsl:apply-templates select="EXPERIMENTAL"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'animation'">
                                <xsl:apply-templates select="ANIMATION"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'documentary'">
                                <xsl:apply-templates select="DOCUMENTARY"/>
                        </xsl:when>
                        <xsl:otherwise> </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE">
                <xsl:choose>
                        <xsl:when test="$article_subtype = 'drama'">
                                <xsl:apply-templates select="DRAMA"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'comedy'">
                                <xsl:apply-templates select="COMEDY"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'experimental'">
                                <xsl:apply-templates select="EXPERIMENTAL"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'animation'">
                                <xsl:apply-templates select="ANIMATION"/>
                        </xsl:when>
                        <xsl:when test="$article_subtype = 'documentary'">
                                <xsl:apply-templates select="DOCUMENTARY"/>
                        </xsl:when>
                        <xsl:otherwise> </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="RECENTRELEASESCONTENT">
                <div class="rightcolboxspecialbot">
                        <div class="textlightmedium">
                                <strong>
                                        <xsl:apply-templates select="HEADER"/>
                                </strong>
                        </div>
                        <div class="textbrightsmall">
                                <ul class="rightcollistround">
                                        <xsl:for-each select="LINK">
                                                <li>
                                                        <xsl:apply-templates select="."/>
                                                </li>
                                        </xsl:for-each>
                                </ul>
                        </div>
                </div>
        </xsl:template>
        <!-- ###########################################
                   SITECONFIG
	 ###########################################-->
        <xsl:template match="MAINCONTAINER">
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
                                        <xsl:apply-templates select="LEFTCOL"/>
                                </td>
                                <td><!-- 20px spacer column --></td>
                                <td valign="top" width="244">
                                        <xsl:apply-templates select="RIGHTCOL"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="BLUE_HEADER_BOX">
                <xsl:choose>
                        <xsl:when test="ancestor::COLUMNS[@TYPE = 'FILMMAKING_GUIDE_INDEX']">
                                <div class="header">
                                        <div class="left-header-side">
                                                <xsl:apply-templates/>
                                                <img alt="Filmmaking Guide Index" class="header-title" height="99" src="{$imagesource}filmmakersguide/filmmaking_guide_index.gif" width="207"/>
                                        </div>
                                        <div class="right-header-side"/>
                                </div>
                        </xsl:when>
                        <xsl:when test="ancestor::COLUMNS[@TYPE = 'BRITISH_FILM_SEASON']">
                                <div class="header">
                                        <div class="left-header-side">
                                                <xsl:apply-templates/>
                                        </div>
                                        <div class="right-header-side"/>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                        <tr>
                                                <td class="topbg" height="30" valign="top">
                                                        <img alt="" class="tiny" height="8" src="/f/t.gif" width="1"/>
                                                        <xsl:apply-templates/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td height="20" valign="top">
                                                        <img alt="" height="20" src="{$imagesource}furniture/anglefunding.gif" width="371"/>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="CRUMBTRAIL">
                <div class="crumbtop">
                        <xsl:apply-templates/>
                </div>
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td class="darkestbg" height="2"/>
                        </tr>
                        <tr>
                                <td height="10"/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="SPAN">
                <span>
                        <xsl:attribute name="class">
                                <xsl:value-of select="@CLASS"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                </span>
        </xsl:template>
        <xsl:template match="DIV">
                <div>
                        <xsl:attribute name="class">
                                <xsl:value-of select="@CLASS"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="SPACERGIF">
                <img alt="" src="/f/t.gif" width="1">
                        <xsl:attribute name="height">
                                <xsl:value-of select="@HEIGHT"/>
                        </xsl:attribute>
                </img>
        </xsl:template>
        <xsl:template match="PROMOCONTENT">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <xsl:apply-templates/>
                </table>
        </xsl:template>
        <xsl:template match="PROMO">
                <tr>
                        <td valign="top">
                                <xsl:apply-templates select="IMG"/>
                        </td>
                        <td valign="top" width="95%">
                                <div class="titlefilmography">
                                        <strong>
                                                <xsl:apply-templates select="LINK"/>
                                        </strong>
                                </div>
                                <xsl:apply-templates select="CREDIT"/>
                                <div class="padrightpara">
                                        <xsl:apply-templates select="BODY"/>
                                </div>
                        </td>
                </tr>
        </xsl:template>
        <xsl:template match="PROMOCONTENT_RIGHT">
                <table border="0" cellpadding="0" cellspacing="0" class="webboxbg" width="192">
                        <xsl:apply-templates/>
                </table>
        </xsl:template>
        <xsl:template match="PROMO_RIGHT">
                <tr>
                        <td colspan="2" height="10"/>
                </tr>
                <tr>
                        <td valign="top">
                                <xsl:apply-templates select="IMG"/>
                        </td>
                        <td valign="top" width="95%">
                                <div class="mostwatchedtitle">
                                        <strong>
                                                <xsl:apply-templates select="LINK"/>
                                        </strong>
                                </div>
                                <div class="mostwatchedmenu">
                                        <xsl:apply-templates select="CREDIT"/>
                                </div>
                        </td>
                </tr>
                <tr>
                        <td colspan="2" height="4"/>
                </tr>
        </xsl:template>
        <xsl:template match="PULLQUOTE">
                <blockquote class="pullquote">
                        <p>
                                <xsl:apply-templates/>
                                <span class="quoteclose"/>
                        </p>
                </blockquote>
        </xsl:template>
        <xsl:template match="SENDTOFRIEND">
                <div class="sendtoafreind">
                        <a href="/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk{$root}{$referrer}"
                                onclick="popupwindow('/cgi-bin/navigation/mailto.pl?GO=1&amp;REF={$root}{$referrer}','Mailer', 'width=350, height=400, resizable=yes, scrollbars=no');return false;"
                                                ><strong><img alt="email icon" height="11" src="{$imagesource}furniture/emailicon.gif" width="21"/>send to a friend</strong>&nbsp;<img alt=""
                                        height="7" src="{$imagesource}furniture/arrowdark.gif" width="4"/></a>
                </div>
        </xsl:template>
        <xsl:template match="IMAGE_ALIGN">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <td height="6"/>
                        </tr>
                        <tr>
                                <td width="100%">
                                        <xsl:apply-templates/>
                                </td>
                        </tr>
                        <tr>
                                <td height="6"/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="BLUERIGHTBOX">
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" height="34" valign="top" width="172"/>
                                <td class="anglebg" valign="top" width="72">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" valign="top" width="244">
                                        <xsl:apply-templates/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="BLUERIGHTSECTION">
                <div class="rightcolboxfund">
                        <div>
                                <xsl:apply-templates select="IMG"/>
                        </div>
                        <div class="textlightmedium">
                                <strong>
                                        <xsl:apply-templates select="SUBHEADER"/>
                                </strong>
                        </div>
                        <div class="textlightsmall">
                                <xsl:apply-templates select="BODY"/>
                        </div>
                        <xsl:apply-templates select="PROMOCONTENT_RIGHT"/>
                        <div class="textbrightsmall">
                                <xsl:apply-templates select="UL|ul"/>
                        </div>
                        <div class="rightbuttonlink">
                                <strong>
                                        <xsl:for-each select="LINK|A">
                                                <xsl:apply-templates select="."/>
                                                <br/>
                                        </xsl:for-each>
                                </strong>
                        </div>
                        <xsl:apply-templates select="BLUEDASHDIVIDER"/>
                        <xsl:apply-templates select="BUTTONLINK"/>
                </div>
        </xsl:template>
        <xsl:template match="BLUEDASHDIVIDER">
                <div class="dash">
                        <img alt="" height="1" src="{$imagesource}furniture/dashrule.gif" width="192"/>
                </div>
        </xsl:template>
        <xsl:template match="ADDCOMMNT">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td valign="top" width="371">
                                        <img alt="comments" height="52" src="{$imagesource}furniture/drama/comments.gif" width="180"/>
                                </td>
                        </tr>
                </table>
                <xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST">
                        <xsl:apply-templates mode="addthread" select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID"/>
                </xsl:if>
                <xsl:apply-templates mode="article" select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS"/>
                <!-- 10px Spacer table -->
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td height="5"/>
                        </tr>
                </table>
                <!-- END 10px Spacer table -->
                <!--  comments table -->
                <xsl:call-template name="MORE_COMMENTS"/>
                <!-- alert moderator -->
                <xsl:call-template name="ALERT_MODERATORS"/>
        </xsl:template>
        <xsl:template match="DISCUSSIONS">
                <xsl:apply-templates mode="discussions_and_comments" select="/H2G2/ARTICLEFORUM"/>
        </xsl:template>
        <xsl:template match="BUTTONLINK">
                <xsl:choose>
                        <xsl:when test="parent::BODY/parent::CATEGORYRIGHTCOLUMN">
                                <strong>
                                        <xsl:apply-templates/>
                                </strong>&nbsp; <xsl:choose>
                                        <xsl:when test="parent::BLUERIGHTSECTION">
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif" width="4"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" width="4"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:when test="parent::BODY">
                                <strong>
                                        <xsl:apply-templates/>
                                </strong>&nbsp; <xsl:choose>
                                        <xsl:when test="parent::BLUERIGHTSECTION">
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif" width="4"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" width="4"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:when test="parent::ICON"><br/>
                                <strong>
                                        <xsl:apply-templates/>
                                </strong>&nbsp; <xsl:choose>
                                        <xsl:when test="parent::BLUERIGHTSECTION">
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif" width="4"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" width="4"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="textmedium">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>&nbsp; <xsl:choose>
                                                <xsl:when test="parent::BLUERIGHTSECTION">
                                                        <img alt="" height="7" src="{$imagesource}furniture/arrowlight.gif" width="4"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" width="4"/>
                                                </xsl:otherwise>
                                        </xsl:choose></div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- #######################  DISCUSSION ########################### -->
        <xsl:template match="DISCUSSIONROW">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <xsl:apply-templates select="DISCUSSIONITEM"/>
                        </tr>
                        <tr>
                                <td height="10" width="115"/>
                                <td height="10" width="10"/>
                                <td height="10" width="115"/>
                                <td height="10" width="10"/>
                                <td height="10" width="115"/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="DISCUSSIONITEM">
                <td class="borderlight" valign="top" width="115">
                        <div class="imagewrap">
                                <xsl:apply-templates select="IMG"/>
                        </div>
                        <div class="textwrap">
                                <strong>
                                        <xsl:apply-templates select="SUBHEADER"/>
                                </strong>
                                <br/>
                                <xsl:apply-templates select="BODY"/>
                        </div>
                </td>
                <xsl:if test="not(position()=last())">
                        <td width="10"/>
                </xsl:if>
        </xsl:template>
        <xsl:template match="DISCUSSIONHEADER">
                <div class="discussheader">
                        <B>
                                <xsl:apply-templates/>
                        </B>
                </div>
        </xsl:template>
        <xsl:template match="DISCUSSIONBODY">
                <div class="discussintro">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <!-- breaks long links -->
        <xsl:template match="*" mode="long_link">
                <xsl:choose>
                        <xsl:when test="starts-with(.,'http://')">
                                <xsl:value-of select="substring(./text(),1,50)"/>... </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="./text()"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- override the base templates in order to do Go tracking SZ jan 2005 -->
        <xsl:template name="dolinkattributes">
                <xsl:choose>
                        <xsl:when test="@POPUP">
                                <xsl:variable name="url">
                                        <xsl:if test="@H2G2">
                                                <xsl:apply-templates mode="applyroot" select="@H2G2"/>
                                        </xsl:if>
                                        <xsl:if test="@DNAID">
                                                <xsl:apply-templates mode="applyroot" select="@DNAID"/>
                                        </xsl:if>
                                        <xsl:if test="@HREF">
                                                <xsl:choose>
                                                        <xsl:when test="starts-with(@HREF, 'http://') and not(starts-with(@HREF, 'http://news.bbc.co.uk')or starts-with(@HREF, 'http://www.bbc.co.uk'))"
                                                                > http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="@HREF"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:apply-templates mode="applyroot" select="@HREF"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:if>
                                        <xsl:if test="@BIO">
                                                <xsl:apply-templates mode="applyroot" select="@BIO"/>
                                        </xsl:if>
                                </xsl:variable>
                                <xsl:choose>
                                        <xsl:when test="@STYLE">
                                                <xsl:attribute name="href">
                                                        <xsl:value-of select="$url"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="onclick">popupwindow('<xsl:value-of select="$url"/>','<xsl:value-of select="@TARGET"/>','<xsl:value-of select="@STYLE"/>');return false;</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:attribute name="TARGET">
                                                        <xsl:choose>
                                                                <xsl:when test="@TARGET">
                                                                        <xsl:value-of select="@TARGET"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:text>_blank</xsl:text>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:attribute name="href">
                                                        <xsl:value-of select="$url"/>
                                                </xsl:attribute>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:if test="@H2G2|@h2g2">
                                        <xsl:apply-templates select="@H2G2"/>
                                </xsl:if>
                                <xsl:if test="@DNAID">
                                        <xsl:apply-templates select="@DNAID"/>
                                </xsl:if>
                                <xsl:if test="@HREF|@href">
                                        <xsl:choose>
                                                <xsl:when test="starts-with(@HREF, 'http://') and not(starts-with(@HREF, 'http://news.bbc.co.uk')or starts-with(@HREF, 'http://www.bbc.co.uk'))">
                                                        <xsl:attribute name="href">http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="@HREF"/></xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:attribute name="href">
                                                                <xsl:value-of select="@HREF"/>
                                                        </xsl:attribute>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:if>
                                <xsl:if test="@BIO|@bio">
                                        <xsl:attribute name="TARGET">_top</xsl:attribute>
                                        <xsl:attribute name="HREF">
                                                <xsl:value-of select="$root"/>
                                                <xsl:value-of select="@BIO|@bio"/>
                                        </xsl:attribute>
                                </xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="SUBMITSHORTGIF">
                <a href="{$root}filmsubmit" onmouseout="swapImage('submitshort', '{$imagesource}furniture/home/txtsubmitshort1.gif')"
                        onmouseover="swapImage('submitshort', '{$imagesource}furniture/home/txtsubmitshort2.gif')">
                        <img alt="Submit your short" border="0" height="81" name="submitshort" src="{$imagesource}furniture/home/txtsubmitshort1.gif" width="187"/>
                </a>
        </xsl:template>
        <xsl:template match="ARTICLE/GUIDE/BODY/RIGHTCOLUMN">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="ARTICLE/GUIDE/BODY/PROFILEPAGE_RIGHTCOLUMN">
                <xsl:apply-templates/>
        </xsl:template>
        <!-- SITECONFIGS -->
        <xsl:template match="MOSTWATCHED">
                <xsl:apply-templates select="/H2G2/SITECONFIG/MOSTWATCHED"/>
        </xsl:template>
        <xsl:template match="SUBMITFILM">
                <xsl:apply-templates select="/H2G2/SITECONFIG/SUBMITFILM"/>
        </xsl:template>
        <xsl:template match="INDUSTRYPANELFAVOURITES">
                <xsl:apply-templates select="/H2G2/SITECONFIG/INDUSTRYPANELFAVOURITES"/>
        </xsl:template>
        <xsl:template match="NEWSLETTER">
                <xsl:apply-templates select="/H2G2/SITECONFIG/NEWSLETTER"/>
        </xsl:template>
        <xsl:template match="MAGAZINEARCHIVE">
                <xsl:apply-templates select="/H2G2/SITECONFIG/MAGAZINEARCHIVE"/>
        </xsl:template>
        <xsl:template match="THEMES_HEADER">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <td height="6"/>
                        </tr>
                        <tr>
                                <td class="topbg" width="40%">
                                        <div class="textbrightmedium">You are browsing by theme <br/><b>
                                                        <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
                                                </b><br/><br/>
                                                <xsl:apply-templates select="THEMES_DESCRIPTION"/></div>
                                </td>
                                <td class="topbg">|</td>
                                <td class="topbg" width="40%">
                                        <div class="textbrightmedium">browse by another theme<br/><xsl:apply-templates select="THEMES_DROP_DOWN"/></div>
                                </td>
                        </tr>
                        <tr>
                                <td height="26"/>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="DISCUSSIONSPROMO">
                <xsl:apply-templates select="/H2G2/SITECONFIG/DISCUSSIONSPROMO"/>
        </xsl:template>
        <xsl:template match="FILMMAKERSINDEX">
                <xsl:apply-templates select="/H2G2/SITECONFIG/FILMMAKERSINDEX"/>
        </xsl:template>
        <!--
####################################################################
	Added by Alistair
#################################################################### -->
        <!-- dynamic lists -->
        <xsl:template match="DYNAMIC-LIST">
                <xsl:variable name="listname">
                        <xsl:value-of select="@NAME"/>
                </xsl:variable>
                <xsl:variable name="listlegnth">
                        <xsl:choose>
                                <xsl:when test="@LENGTH &gt; 0">
                                        <xsl:value-of select="@LENGTH"/>
                                </xsl:when>
                                <xsl:otherwise> 5 </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <table border="0" cellpadding="0" cellspacing="0" class="numberedImageTextTable" id="dynamicList" width="244">
                        <xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlegnth]"/>
                </table>
        </xsl:template>
        <xsl:template match="ITEM-LIST/ITEM">
                <tr>
                        <td class="tdNumber" valign="top">
                                <img alt="{position()}" height="30" src="{$imagesource}furniture/{position()}_default.gif" width="30"/>
                        </td>
                        <td class="tdImage" valign="top">
                                <img alt="" border="0" src="{$imagesource}shorts/A{@ITEMID}_small.jpg"/>
                        </td>
                        <td class="tdText" valign="top">
                                <div class="itemTerm">
                                        <a href="{$root}A{@ITEMID}">
                                                <xsl:value-of select="TITLE"/>
                                        </a>
                                </div>
                                <div class="itemDefinition"><xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/DIRECTORSNAME"/>| <xsl:value-of
                                                select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/FILMLENGTH_MINS"/> mins</div>
                        </td>
                </tr>
        </xsl:template>
        <!-- industry panel favourites -->
        <xsl:template match="/H2G2/SITECONFIG/INDUSTRYPANELFAVOURITES">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='INDUSTRYPANELFAVOURITES']/VALUE">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="INDUSTRYPANELFAVOURITESTITLE">
                <div class="boxTitle">
                        <xsl:if test="parent::BOX[@POSITION='TOP']">
                                <xsl:attribute name="class">boxTitleTop</xsl:attribute>
                        </xsl:if>
                        <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                        <td valign="top" width="41">
                                                <img alt="" height="30" src="{$imagesource}furniture/icon_indust_prof.gif" width="31"/>
                                        </td>
                                        <td valign="top" width="140">
                                                <strong>industry panel's favourites</strong>
                                        </td>
                                </tr>
                        </table>
                </div>
        </xsl:template>
        <xsl:template match="NEWSLETTERTITLE">
                <div id="newsletterTitle">
                        <strong>newsletter</strong>
                </div>
        </xsl:template>
        <!-- newsletter -->
        <xsl:template match="/H2G2/SITECONFIG/NEWSLETTER">
                <!-- This breaks the preview and next button on the preview page musn't diaply it on the preview page-->
                <xsl:if test="not(/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW')">
                        <div class="box default" id="newsletter">
                                <script type="text/javascript">
		//<![CDATA[
		function validate(form){
			var str = form.required_email.value;
			var re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
			if (str == ""){
				alert("Please enter your email address.");
				return false;
			}
			if (!str.match(re)) {
				alert("Please check you have typed your email address correctly.");
				return false;
			} 
			return true;
		}
					//]]>
		</script>
                                <form action="http://www.bbc.co.uk/cgi-bin/cgiemail/filmnetwork/newsletter/newsletter.txt" method="post" name="emailform" onsubmit="return validate(this)">
                                        <input name="success" type="hidden" value="http://www.bbc.co.uk/dna/filmnetwork/newsletterthanks"/>
                                        <input name="heading" type="hidden" value="Newsletter"/>
                                        <input name="option" type="hidden" value="subscribe"/>
                                        <!--<p>
                                                <xsl:apply-templates/>
                                        </p>-->
                                        <p id="enterEmail">Enter your email below:<br/>
                                                <input name="required_email" size="28" type="text" value="your email"/></p>
                                        <input height="16" id="subscribeBtn" name="subscribe" src="{$imagesource}furniture/newsletter_subscribe.gif" type="image" value="subscribe" width="77"/>
                                        <div id="exampleNewsletter">
                                                <div class="arrowlink">
                                                        <a href="/filmnetwork/newsletter/examplenewsletter.html" target="_new">see example newsletter</a>
                                                        <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                                                </div>
                                                <div class="arrowlink">
                                                        <a href="/dna/filmnetwork/newsletter" target="_new">to unsubscribe, go here</a>
                                                        <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                                                </div>
                                                <p>Newsletter is separate from membership.</p>
                                        </div>
                                </form>
                        </div>
                </xsl:if>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='NEWSLETTER']/VALUE">
                <xsl:apply-templates/>
        </xsl:template>
        <!-- magazine archive dropdown -->
        <xsl:template match="/H2G2/SITECONFIG/MAGAZINEARCHIVE">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='MAGAZINEARCHIVE']/VALUE">
                <xsl:apply-templates/>
        </xsl:template>
        <!-- discussions promo -->
        <xsl:template match="/H2G2/SITECONFIG/DISCUSSIONSPROMO">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="MULTI-STAGE/MULTI-ELEMENT[@NAME='DISCUSSIONSPROMO']/VALUE">
                <xsl:apply-templates/>
        </xsl:template>
        <!-- Homepage  -->
        <xsl:template match="FINDAFILM">
                <div class="box default">
                        <img alt="find a film" height="40" src="{$imagesource}furniture/boxtitle_find_a_film.gif" width="244"/>
                        <p>
                                <xsl:value-of select="TEXT"/>
                        </p>
                        <xsl:call-template name="drop_down"/>
                        <div class="arrowlink">
                                <a href="{$root}C{$filmIndexPage}">or browse the catalogue</a>
                                <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                        </div>
                </div>
        </xsl:template>
        <xsl:template match="FINDAPERSON">
                <div class="box default" id="findAPerson">
                        <img alt="find a person" height="40" src="{$imagesource}furniture/boxtitle_find_a_person.gif" width="244"/>
                        <p>
                                <xsl:value-of select="TEXT"/>
                        </p>
                        <div class="arrowlink">
                                <a href="{$root}C{$directoryPage}">go to people directory</a>
                                <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                        </div>
                        <div id="findAPersonInner">
                                <p>To add yourself to our directory, simply <a
                                                href="http://www.bbc.co.uk/cgi-perl/signon/mainscript.pl?service=filmnetwork&amp;c=register&amp;ptrt=http://www.bbc.co.uk/dna/filmnetwork/SSO?s_return=logout"
                                                >create your membership</a></p>
                                <div class="infoLink">
                                        <a href="{$root}sitehelpmembership">why become a member?</a>
                                </div>
                        </div>
                </div>
        </xsl:template>
        <xsl:template match="FILMMAKINGGUIDE">
                <div class="box default">
                        <img alt="filmmaking guide" height="40" src="{$imagesource}furniture/boxtitle_filmmaking_guide.gif" width="244"/>
                        <p>Essential information from writing a script to getting you film seen.</p>
                        <form class="dropdownmenu" onSubmit="self.location=this.link.options[this.link.selectedIndex].value; return false;">
                                <script type="text/javascript">
				document.write('<select name="link"><option>- choose a subject</option><option value="/dna/filmnetwork/filmmakersguidewhy">why make a short film?</option><option value="/dna/filmnetwork/filmmakersguidewriting">writing a script</option><option value="/dna/filmnetwork/filmmakersguidewatching">watching shorts</option><option value="/dna/filmnetwork/dvdshorts">shorts on DVD</option><option value="/dna/filmnetwork/filmmakersguidetraining">training &amp; development</option><option value="/dna/filmnetwork/filmmakersguidereading">recommended reading</option><option value="/dna/filmnetwork/filmmakersguidefunding">funding</option><option value="/dna/filmnetwork/rights">rights</option><option value="/dna/filmnetwork/clearances">clearances</option><option value="/dna/filmnetwork/filmmakersguidewhattoshooton">what to shoot on</option><option value="/dna/filmnetwork/filmmakersguidebudget">budget &amp; schedule</option><option value="/dna/filmnetwork/filmmakersguideequipment">equipment &amp; insurance</option><option value="/dna/filmnetwork/filmmakersguidecastandcrew">cast &amp; crew</option><option value="/dna/filmnetwork/filmmakersguidepost">post-production &amp; editing</option><option value="/dna/filmnetwork/filmmakersguidegettingseen">getting your film seen</option></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27"/>');
			</script>
                                <noscript>
                                        <a class="rightcol" href="/dna/filmnetwork/Filmmakersguide">filmmaking guide</a>
                                </noscript>
                        </form>
                </div>
        </xsl:template>
        <xsl:template match="DROPDOWNLINKS">
                <!-- Not currently working - think it may the options variable that is causing the problem -->
                <xsl:variable name="options">
                        <xsl:for-each select="OPTION">
                                <xsl:value-of disable-output-escaping="yes" select="'&lt;option value='"/>
                                <xsl:value-of select="$root"/>
                                <xsl:value-of select="@DNAID"/>
                                <xsl:value-of disable-output-escaping="yes" select="'&gt;'"/>
                                <xsl:value-of select="."/>
                                <xsl:value-of disable-output-escaping="yes" select="'&lt;/option&gt;'"/>
                        </xsl:for-each>
                </xsl:variable>
                <form class="dropdownmenu" onSubmit="self.location=this.link.options[this.link.selectedIndex].value; return false;">
                        <script type="text/javascript">
			document.write('<select name="link"><xsl:value-of select="$options"/></select><input alt="GO" height="19" src="{$imagesource}furniture/boxbtn_go.gif" type="image" width="27"/>');
		</script>
                        <noscript>
                                <xsl:apply-templates select="LINK"/>
                        </noscript>
                </form>
        </xsl:template>
        <xsl:template match="CONTENTPARTNERS">
                <div id="contentPartners">
                        <img alt="content partners" height="13" src="{$imagesource}furniture/title_content_partners.gif" width="110"/>
                        <br/>
                        <div id="contentPartnersLogo">
                                <a href="/dna/filmnetwork/C55262">
                                        <img alt="dazzle" height="25" src="{$imagesource}furniture/home/logo_dazzle.gif" width="89"/>
                                </a>
                                <a href="/dna/filmnetwork/C54798">
                                        <img alt="onedotzero" height="25" src="{$imagesource}furniture/home/logo_onedotzero.gif" width="108"/>
                                </a>
                                <a href="/dna/filmnetwork/C54810">
                                        <img alt="" height="25" id="lastLogo" src="{$imagesource}furniture/home/logo_ukfilmcouncil.gif" width="125"/>
                                </a>
                        </div>
                        <div class="textmedium"><br/><strong>
                                        <a href="{$root}partners">more Film Network partners</a>
                                </strong>&nbsp; <img alt="" height="7" src="http://www.bbc.co.uk/filmnetwork/images/furniture/arrowdark.gif" width="4"/></div>
                </div>
        </xsl:template>
        <!-- ################ Generic ################ -->
        <xsl:template match="COLUMNS">
                <xsl:choose>
                        <xsl:when test="@TYPE = 'FILMMAKING_GUIDE_INDEX' or @TYPE = 'BRITISH_FILM_SEASON'">
                                <div class="filmmaking-index" id="grid-columns">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                        <xsl:if test="@TOPMARGIN='YES'">
                                                <xsl:attribute name="style">margin-top:10px</xsl:attribute>
                                        </xsl:if>
                                        <tr>
                                                <td>
                                                        <img alt="" height="1" src="/f/t.gif" width="371"/>
                                                </td>
                                                <td>
                                                        <img alt="" height="1" src="/f/t.gif" width="20"/>
                                                </td>
                                                <td>
                                                        <img alt="" height="1" src="/f/t.gif" width="244"/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td class="maincolumn" valign="top">
                                                        <xsl:apply-templates select="COLUMN1"/>
                                                </td>
                                                <td>
                                                        <xsl:if test="COLUMN1/@CONTENT='FEATUREPROMO'">
                                                                <xsl:attribute name="class">colDivider</xsl:attribute>
                                                        </xsl:if>
                                                </td>
                                                <td class="promocolumn" valign="top">
                                                        <xsl:apply-templates select="COLUMN2"/>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- ######## COLUMN1 ######## -->
        <xsl:template match="COLUMN1">
                <xsl:choose>
                        <xsl:when test="parent::COLUMNS/@TYPE = 'FILMMAKING_GUIDE_INDEX' or parent::COLUMNS/@TYPE = 'BRITISH_FILM_SEASON'">
                                <div id="grid-column-1">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                        <xsl:when test="@CONTENT='FEATUREPROMO'">
                                <div class="featurepromo">
                                        <div class="newfeature">
                                                <xsl:apply-templates select="IMG[1]"/>
                                        </div>
                                        <div class="featuretitle">
                                                <xsl:apply-templates select="IMG[2]"/>
                                        </div>
                                        <xsl:apply-templates select="DETAILS"/>
                                        <xsl:apply-templates select="TEXT"/>
                                        <xsl:apply-templates select="BYLINE"/>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="DETAILS">
                <div class="details">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="TEXT">
                <xsl:choose>
                        <!-- if it contains a list, don't wrap in a paragraph element -->
                        <xsl:when test="UL or B/UL">
                                <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="QUESTION">
                                <p class="text question ">
                                        <xsl:apply-templates/>
                                </p>
                        </xsl:when>
                        <xsl:otherwise>
                                <p class="text">
                                        <xsl:apply-templates/>
                                </p>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="ITEM/TEXT">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="ITEM/DETAILS">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="ITEMS">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="BYLINE">
                <div class="byline">
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="COLUMN1//ITEM">
                <table cellpadding="0" cellspacing="0" class="item">
                        <tr>
                                <td class="itemImg" valign="top" width="128">
                                        <xsl:apply-templates select="IMG[position()=1]"/>
                                </td>
                                <td width="243">
                                        <div class="itemTitle">
                                                <xsl:apply-templates select="LINK"/>
                                                <xsl:apply-templates select="IMG[position()=2]"/>
                                        </div>
                                        <div class="itemDetails">
                                                <xsl:apply-templates select="DETAILS"/>
                                        </div>
                                        <div class="itemDescription">
                                                <xsl:apply-templates select="TEXT"/>
                                        </div>
                                        <xsl:apply-templates select="PLAYNOW"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="COLUMN1/P">
                <p class="textmedium">
                        <xsl:apply-templates/>
                </p>
        </xsl:template>
        <xsl:template match="COLUMN1//ITEMS[@ALIGN='RIGHT']//ITEM">
                <table cellpadding="0" cellspacing="0" class="item">
                        <tr>
                                <td align="right" width="243">
                                        <div class="itemTitle">
                                                <xsl:apply-templates select="LINK"/>
                                        </div>
                                        <div class="itemDetails">
                                                <xsl:apply-templates select="DETAILS"/>
                                        </div>
                                        <div class="itemDescription">
                                                <xsl:apply-templates select="TEXT"/>
                                        </div>
                                </td>
                                <td align="right" class="itemImg" valign="top" width="128">
                                        <xsl:apply-templates select="IMG"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="HR[@TYPE='GREY']">
                <div class="hr"/>
        </xsl:template>
        <xsl:template match="HR[@TYPE='BLACK']">
                <div class="hr2"/>
        </xsl:template>
        <!-- 
Examples
<PLAYNOW MEDIA="features/trailer" WM="yes" RM="yes" BB="yes" NB="yes" ratio="16x9" />
<PLAYNOW MEDIA="shorts/A1234567" WM="no" RM="yes" BB="no" NB="yes" ratio="4x3" />
default values if attribute not included: WM="yes" RM="yes" BB="yes" NB="yes" ratio="16x9"
-->
        <xsl:template match="PLAYNOW">
                <xsl:variable name="narrowband_windowsmedia">
                        <xsl:choose>
                                <xsl:when test="(@NB = 'no' or @NB = 'NO') and (@WM = 'no' or @WM = 'NO')">0</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="narrowband_realmedia">
                        <xsl:choose>
                                <xsl:when test="(@NB = 'no' or @NB = 'NO') and (@RM = 'no' or @RM = 'NO')">0</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="broadband_windowsmedia">
                        <xsl:choose>
                                <xsl:when test="(@BB = 'no' or @BB = 'NO') and (@WM = 'no' or @WM = 'NO')">0</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="broadband_realmedia">
                        <xsl:choose>
                                <xsl:when test="(@BB = 'no' or @BB = 'NO') and (@RM = 'no' or @RM = 'NO')">0</xsl:when>
                                <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="ratio">
                        <xsl:choose>
                                <xsl:when test="@RATIO = '4x3'">4x3</xsl:when>
                                <xsl:otherwise>16x9</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <a
                        href="http://www.bbc.co.uk/mediaselector/check/filmnetwork/media/{@MEDIA}?size={$ratio}&amp;bgc=C0C0C0&amp;nbwm={$narrowband_windowsmedia}&amp;bbwm={$broadband_windowsmedia}&amp;nbram={$narrowband_realmedia}&amp;bbram={$broadband_realmedia}"
                        onclick="window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=384,height=283')"
                        onmouseout="swapImage('dramawatch', 'http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow.gif')"
                        onmouseover="swapImage('dramawatch', 'http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow_ro2.gif')" target="avaccesswin">
                        <img alt="PLAY NOW" height="31" name="dramawatch" src="http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow.gif" width="121"/>
                </a>
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td width="39"/>
                                <td>
                                        <div class="textxsmall">Requires <strong>
                                                        <a href="http://www.bbc.co.uk/webwise/categories/plug/winmedia/winmedia.shtml?intro"
                                                                onClick="popwin(this.href, this.target, 420, 400, 'scroll', 'resize'); return false;" target="webwise">windows media player</a>
                                                </strong>&nbsp;or<br/><strong>
                                                        <a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro"
                                                                onClick="popwin(this.href, this.target, 420, 400, 'scroll', 'resize'); return false;" target="webwise">real player</a>
                                                </strong>.</div>
                                </td>
                        </tr>
                </table>
                <!-- BEGIN content advise -->
                <xsl:if test="string-length(@WARNING) > 0">
                        <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                <tr>
                                        <td width="39"/>
                                        <td>
                                                <img alt="" height="14" src="{$imagesource}furniture/drama/contentadvice.gif" width="106"/>
                                                <br/>
                                                <img alt="" class="tiny" height="5" src="/f/t.gif" width="1"/>
                                                <div class="textxsmall">
                                                        <xsl:value-of select="@WARNING"/>
                                                </div>
                                        </td>
                                </tr>
                        </table>
                </xsl:if>
                <!-- END content advise -->
        </xsl:template>
        <!-- move BROWSEBYTHEME to categories or create variables -->
        <xsl:template match="BROWSEBYTHEME">
                <div class="box catalogue" style="margin-top:20px">
                        <div class="boxTitle">
                                <strong>browse over 200 short films by theme</strong>
                        </div>
                        <table cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td width="50%">
                                                <ul>
                                                        <li>
                                                                <a href="{$root}C55267">A Twist In The Tale</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55269">Addictive Behaviour</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55270">Animal Magnetism</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55271">Behind Closed Doors</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55272">Child's Play</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55273">Crimes &amp; Misdemeanours</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55274">Crossing Borders</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55276">Cut 'n' Splice</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55277">Deja View</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55278">End Of The Road</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55279">Eye For An Eye</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55280">Head To Head</a>
                                                        </li>
                                                </ul>
                                        </td>
                                        <td width="50%">
                                                <ul>
                                                        <li>
                                                                <a href="{$root}C55281">Laugh Out Loud</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55284">Out Of This World</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55285">Outsiders</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55286">Reflections</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55287">Strange Happenings</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55288">Talking Heads</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55289">Techno Babble</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55290">Teenage Kicks</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55291">Thrill &amp; Chill</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55292">Urban Tales</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55282">Love/Hate</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C55283">Nine-To-Five</a>
                                                        </li>
                                                </ul>
                                        </td>
                                </tr>
                        </table>
                        <div class="hr2"/>
                        <div class="arrowlink"><a href="{$root}C{$filmIndexPage}">or view entire film catalogue</a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif"
                                        width="4"/></div>
                </div>
        </xsl:template>
        <!-- ######## COLUMN2 ######## -->
        <xsl:template match="COLUMN2">
                <xsl:choose>
                        <xsl:when test="@CONTENT='FILMPROMO'">
                                <div class="filmgenre">
                                        <xsl:apply-templates select="IMG[1]"/>
                                </div>
                                <div class="filmtitle">
                                        <xsl:apply-templates select="IMG[2]"/>
                                </div>
                                <xsl:apply-templates select="DETAILS"/>
                                <xsl:apply-templates select="TEXT"/>
                        </xsl:when>
                        <xsl:when test="@CONTENT='SELECTIONPROMO'">
                                <div class="selectiontitle">
                                        <xsl:apply-templates select="IMG[1]"/>
                                </div>
                                <xsl:apply-templates select="TEXT"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="BOX">
                <div>
                        <xsl:if test="@MARGIN-TOP">
                                <xsl:attribute name="style">margin-top:<xsl:value-of select="@MARGIN-TOP"/>px</xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                                <xsl:when test="@TYPE='DEFAULT'">
                                        <xsl:attribute name="class">box default</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@TYPE='CATALOGUE'">
                                        <xsl:attribute name="class">box catalogue</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@TYPE='INDUSTRYPANEL'">
                                        <xsl:attribute name="class">box industry</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="@TYPE='COMMUNITY'">
                                        <xsl:attribute name="class">box community</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:attribute name="class">box default</xsl:attribute>
                                </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates/>
                </div>
        </xsl:template>
        <xsl:template match="BOX/TWOLISTS">
                <table cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td width="50%">
                                        <xsl:apply-templates select="child::*[position()=1]"/>
                                </td>
                                <td width="50%">
                                        <xsl:apply-templates select="child::*[position()=2]"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="BOX/TITLE">
                <div class="boxTitle">
                        <xsl:if test="parent::BOX[@POSITION='TOP']">
                                <xsl:attribute name="class">boxTitleTop</xsl:attribute>
                        </xsl:if>
                        <strong>
                                <xsl:apply-templates/>
                        </strong>
                </div>
        </xsl:template>
        <xsl:template match="COLUMN1/BOX//TITLE">
                <div class="boxTitle">
                        <strong>
                                <xsl:apply-templates/>
                        </strong>
                </div>
        </xsl:template>
        <xsl:template match="COLUMN2/BOX//TITLE">
                <xsl:choose>
                        <xsl:when test="../preceding-sibling::BOX">
                                <div class="boxTitle">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- must be the first box in the column so use the boxTitleTop class to give the angled top -->
                                <div class="boxTitleTop">
                                        <strong>
                                                <xsl:apply-templates/>
                                        </strong>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="BOX//TEXT">
                <p>
                        <xsl:apply-templates/>
                </p>
        </xsl:template>
        <xsl:template match="BOX/LINK">
                <div class="itemlink">
                        <a>
                                <xsl:call-template name="dolinkattributes"/>
                                <xsl:apply-templates select="./text()"/>
                        </a>
                </div>
        </xsl:template>
        <xsl:template match="BOX//LINK[@TYPE='INFO']">
                <div class="infoLink">
                        <a>
                                <xsl:call-template name="dolinkattributes"/>
                                <xsl:apply-templates select="./text()"/>
                        </a>
                </div>
        </xsl:template>
        <xsl:template match="LINK[@TYPE='ARROW']">
                <xsl:choose>
                        <xsl:when test="parent::TEXT">
                                <strong>
                                        <a>
                                                <xsl:call-template name="dolinkattributes"/>
                                                <xsl:apply-templates select="./text()"/>
                                        </a>
                                </strong>
                                <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" style="margin-left:5px" width="4"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="arrowlink">
                                        <xsl:if test="parent::ITEMS">
                                                <xsl:attribute name="align">right</xsl:attribute>
                                        </xsl:if>
                                        <a>
                                                <xsl:call-template name="dolinkattributes"/>
                                                <xsl:apply-templates select="./text()"/>
                                        </a>
                                        <xsl:choose>
                                                <xsl:when test="parent::BOX[@TYPE='COMMUNITY']">
                                                        <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" style="margin-left:5px" width="4"/>
                                                </xsl:when>
                                                <xsl:when test="parent::BOX[@TYPE='INDUSTRYPANEL']">
                                                        <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                                                </xsl:when>
                                                <xsl:when test="parent::BOX[@TYPE='CATALOGUE']">
                                                        <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" style="margin-left:5px" width="4"/>
                                                </xsl:when>
                                                <xsl:when test="parent::BOX[@TYPE='DEFAULT']">
                                                        <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                                                </xsl:when>
                                                <xsl:when test="parent::BOX">
                                                        <img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif" width="9"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <img alt="" height="7" src="{$imagesource}furniture/arrowdark.gif" style="margin-left:5px" width="4"/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="BOX/NUMBEREDITEMS">
                <table border="0" cellpadding="0" cellspacing="0" class="numberedImageTextTable">
                        <xsl:apply-templates select="ITEM"/>
                </table>
        </xsl:template>
        <xsl:template match="BOX/NUMBEREDITEMS/ITEM">
                <xsl:variable name="style">
                        <xsl:choose>
                                <xsl:when test="ancestor::BOX[@TYPE='CATALOGUE']">catalogue</xsl:when>
                                <xsl:when test="ancestor::BOX[@TYPE='INDUSTRYPANEL']">industry</xsl:when>
                                <xsl:when test="ancestor::BOX[@TYPE='COMMUNITY']">community</xsl:when>
                                <xsl:when test="ancestor::BOX[@TYPE='DEFAULT']">catalogue</xsl:when>
                                <xsl:otherwise>default</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <tr>
                        <td class="tdNumber" valign="top">
                                <img alt="1" border="0" height="30" src="{$imagesource}furniture/{position()}_{$style}.gif" width="30"/>
                        </td>
                        <td class="tdImage" valign="top">
                                <xsl:apply-templates select="IMG"/>
                        </td>
                        <td class="tdText" valign="top">
                                <div class="itemTerm">
                                        <xsl:apply-templates select="LINK"/>
                                </div>
                                <div class="itemDefinition">
                                        <xsl:apply-templates select="DETAILS"/>
                                </div>
                        </td>
                </tr>
        </xsl:template>
        <xsl:template match="BOX/ITEMS">
                <table border="0" cellpadding="0" cellspacing="0" class="imageTextTable">
                        <xsl:apply-templates select="ITEM"/>
                </table>
        </xsl:template>
        <xsl:template match="BOX/ITEMS/ITEM">
                <tr>
                        <td class="tdImage" valign="top">
                                <xsl:apply-templates select="IMG"/>
                        </td>
                        <td class="tdText" valign="top">
                                <div class="itemTerm">
                                        <xsl:apply-templates select="LINK"/>
                                </div>
                                <div class="itemDefinition">
                                        <xsl:apply-templates select="DETAILS"/>
                                </div>
                        </td>
                </tr>
        </xsl:template>
        <xsl:template match="BOX/HR">
                <div class="hr"/>
        </xsl:template>
        <!--
###########################################################################################
						DELETE WHEN NEW GUIDEML IS FULLY IMPLEMENTED
###########################################################################################
 -->
        <!-- COLUMNS is a duplicate of COLS - delete COLS when COLUMNS is fully implemented -->
        <xsl:template match="COLS">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td>
                                        <img alt="" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" height="1" src="/f/t.gif" width="20"/>
                                </td>
                                <td>
                                        <img alt="" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="maincolumn" valign="top">
                                        <xsl:apply-templates select="MAINCOLUMN"/>
                                </td>
                                <td/>
                                <td class="promocolumn" valign="top">
                                        <xsl:apply-templates select="PROMOCOLUMN"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- COLUMN1 is a duplicate of MAINCOLUMN - delete MAINCOLUMN when COLUMN1 is fully implemented -->
        <xsl:template match="MAINCOLUMN">
                <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="MAINCOLUMN//ITEM">
                <table border="0" cellpadding="0" cellspacing="0" class="item">
                        <tr>
                                <td class="itemImg" valign="top" width="128">
                                        <xsl:apply-templates select="IMG"/>
                                </td>
                                <td width="243">
                                        <div class="itemTitle">
                                                <xsl:apply-templates select="LINK"/>
                                        </div>
                                        <div class="itemDetails">
                                                <xsl:apply-templates select="DETAILS"/>
                                        </div>
                                        <div class="itemDescription">
                                                <xsl:apply-templates select="TEXT"/>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="MAINCOLUMN//ITEMS[@ALIGN='RIGHT']//ITEM">
                <table cellpadding="0" cellspacing="0" class="item">
                        <tr>
                                <td align="right" width="243">
                                        <div class="itemTitle">
                                                <xsl:apply-templates select="LINK"/>
                                        </div>
                                        <div class="itemDetails">
                                                <xsl:apply-templates select="DETAILS"/>
                                        </div>
                                        <div class="itemDescription">
                                                <xsl:apply-templates select="TEXT"/>
                                        </div>
                                </td>
                                <td align="right" class="itemImg" valign="top" width="128">
                                        <xsl:apply-templates select="IMG"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="MAINCOLUMN//HR[@TYPE='GREY']">
                <div class="hr"/>
        </xsl:template>
        <xsl:template match="MAINCOLUMN//HR[@TYPE='BLACK']">
                <div class="hr2"/>
        </xsl:template>
        <!-- COLUMN2 is a duplicate of PROMOCOLUMN - delete PROMOCOLUMN when COLUMN2 is fully implemented -->
        <xsl:template match="PROMOCOLUMN">
                <xsl:apply-templates/>
        </xsl:template>
        <!-- NOT NEEDED AS USE GUIDEML TO CREATE BOX, TWOLISTS and LINKS etc -->
        <xsl:template match="BROWSEMAGAZINEARCHIVE">
                <div class="box catalogue" style="margin-top:20px">
                        <div class="boxTitle">
                                <strong>browse magazine archive</strong>
                        </div>
                        <table cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td width="50%">
                                                <ul>
                                                        <li>
                                                                <a href="{$root}C54793">interviews</a>
                                                        </li>
                                                        <li>
                                                                <a href="{$root}C54794">master classes</a>
                                                        </li>
                                                </ul>
                                        </td>
                                        <td width="50%">
                                                <ul>
                                                        <li>
                                                                <a href="{$root}C54795">special programme</a>
                                                        </li>
                                                        <li>news</li>
                                                </ul>
                                        </td>
                                        <td/>
                                </tr>
                        </table>
                </div>
        </xsl:template>
        <xsl:template match="RSSLINK">
                <a>
                        <xsl:attribute name="href">http://www.bbc.co.uk/dna/filmnetwork/xml/?s_xml=rss&amp;s_feed=dynamiclist_<xsl:value-of select="@NAME"/>&amp;s_feedamount=5</xsl:attribute>
                        <img alt="RSS Feed" height="16" id="rssIconInline" src="{$imagesource}rss/rssfeedicon.gif" width="16"/>
                        <xsl:apply-templates/>
                </a>
        </xsl:template>
        <!-- Darren's new NEW EVEN-NEWER guideML -->
        <!-- Filmmaking guide pages -->
        <xsl:template match="IMAGE">
                <xsl:choose>
                        <xsl:when test="parent::BLUE_HEADER_BOX and (ancestor::COLUMNS[@TYPE = 'FILMMAKING_GUIDE_INDEX'] or ancestor::COLUMNS[@TYPE = 'BRITISH_FILM_SEASON'])">
                                <img alt="{@ALT}" class="header-image" height="{@HEIGHT}" src="{concat($imagesource, @SRC)}" width="{@WIDTH}">
                                        <xsl:attribute name="class">
                                                <xsl:choose>
                                                        <xsl:when test="position() = 1"> header-image </xsl:when>
                                                        <xsl:when test="position() = 2"> header-title </xsl:when>
                                                </xsl:choose>
                                        </xsl:attribute>
                                </img>
                        </xsl:when>
                        <xsl:when test="ancestor::COLUMNS[@TYPE = 'BRITISH_FILM_SEASON']">
                                <img alt="{@ALT}" class="british-film-images" height="{@HEIGHT}" src="{concat($imagesource, @SRC)}" width="{@WIDTH}"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <img alt="{@ALT}" height="{@HEIGHT}" src="{concat($imagesource, @SRC)}" width="{@WIDTH}"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="INTRO[@TYPE = 'INDEX']">
                <p class="intro">
                        <xsl:apply-templates/>
                </p>
        </xsl:template>
        <xsl:template match="LINKS">
                <xsl:choose>
                        <xsl:when test="ancestor::COLUMNS[@TYPE = 'FILMMAKING_GUIDE_INDEX']">
                                <div class="filmmaking_index_links">
                                        <xsl:apply-templates/>
                                </div>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="LINK_SET">
                <xsl:choose>
                        <xsl:when test="ancestor::COLUMNS[@TYPE = 'FILMMAKING_GUIDE_INDEX']">
                                <div>
                                        <xsl:attribute name="class">
                                                <xsl:text>filmmaking-link-set </xsl:text>
                                                <xsl:value-of select="concat('nth-child-', position())"/>
                                                <xsl:if test="position() = last()">
                                                        <xsl:text> last-child</xsl:text>
                                                </xsl:if>
                                        </xsl:attribute>
                                        <xsl:apply-templates select="*[name() != 'LINK']"/>
                                        <div class="links">
                                                <ul class="link-set-left">
                                                        <xsl:apply-templates select="LINK[position() mod 2 = 1]"/>
                                                </ul>
                                                <ul class="link-set-right">
                                                        <xsl:apply-templates select="LINK[position() mod 2 = 0]"/>
                                                </ul>
                                                <div class="clear-both-link-set"/>
                                        </div>
                                </div>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="PICTURE_IMAGE">
                <img alt="{@ALT}" class="link-set-image" height="{@HEIGHT}" src="{concat($imagesource, @SRC)}" width="{@WIDTH}"/>
        </xsl:template>
        <xsl:template match="TITLE_IMAGE">
                <img alt="{@ALT}" class="link-set-title" height="{@HEIGHT}" src="{concat($imagesource, @SRC)}" width="{@WIDTH}"/>
        </xsl:template>
        <xsl:template match="LINK[ancestor::COLUMNS/@TYPE = 'FILMMAKING_GUIDE_INDEX']">
                <li>
                        <a href="{concat($root,  @DNAID)}">
                                <xsl:value-of select="@NAME"/>
                        </a>
                </li>
        </xsl:template>
        <xsl:template match="LINK[ancestor::COLUMNS/@TYPE = 'BRITISH_FILM_SEASON']">
                <div class="british-film-links">
                        <a href="{concat($root,  @DNAID)}">
                                <xsl:attribute name="href">
                                        <xsl:choose>
                                                <xsl:when test="@DNAID">
                                                        <xsl:value-of select="concat($root,  @DNAID)"/>
                                                </xsl:when>
                                                <xsl:when test="@HREF">
                                                        <xsl:value-of select="@HREF"/>
                                                </xsl:when>
                                        </xsl:choose>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                        </a>
                </div>
                <xsl:if test="position() = last()">
                        <div class="clear"/>
                </xsl:if>
        </xsl:template>
        <xsl:template match="BLUE_RIGHT_BOX">
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" height="34" valign="top" width="172"/>
                                <td class="anglebg" valign="top" width="72">
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td class="webboxbg" valign="top" width="244">
                                        <div class="rightcolboxfund">
                                                <div>
                                                        <xsl:apply-templates select="IMG"/>
                                                </div>
                                                <xsl:apply-templates select="FILMMAKERSINDEX"/>
                                                <div class="textlightsmall">
                                                        <xsl:apply-templates select="BODY"/>
                                                </div>
                                                <xsl:apply-templates select="PROMOCONTENT_RIGHT"/>
                                                <div class="textbrightsmall">
                                                        <xsl:apply-templates select="UL|ul"/>
                                                </div>
                                                <div class="rightbuttonlink">
                                                        <strong>
                                                                <xsl:for-each select="LINK|A">
                                                                        <xsl:apply-templates select="."/>
                                                                        <br/>
                                                                </xsl:for-each>
                                                        </strong>
                                                </div>
                                                <xsl:apply-templates select="BLUEDASHDIVIDER"/>
                                                <xsl:apply-templates select="BUTTONLINK"/>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template match="UL[ancestor::BLUE_RIGHT_BOX and not(parent::LI)]">
                <div id="filmmaking_index">
                        <ul class="rightcolboxlist">
                                <xsl:apply-templates/>
                        </ul>
                </div>
        </xsl:template>
        <xsl:template match="UL[ancestor::BLUE_RIGHT_BOX and parent::LI]">
                <ul>
                        <xsl:apply-templates/>
                </ul>
        </xsl:template>
        <xsl:template match="UL[parent::LEFTHANDNAV]">
                <div id="leftnav">
                        <div class="leftnavwhitedashes">
                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="1"/>
                        </div>
                        <xsl:for-each select="LI">
                                <xsl:apply-templates select="."/>
                                <xsl:if test="position() mod 2 = 0 and position() != last()">
                                        <div class="leftnavgreydashes">
                                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="1"/>
                                        </div>
                                </xsl:if>
                        </xsl:for-each>
                        <div class="leftnavwhitedashes">
                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="1"/>
                        </div>
                </div>
        </xsl:template>
        <xsl:template match="LI[ancestor::LEFTHANDNAV]">
                <xsl:choose>
                        <xsl:when test="@NAME = 'profile'">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/@TYPE='USERPAGE'">
                                                <xsl:choose>
                                                        <xsl:when
                                                                test="$ownerisviewer != 1 or /H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'placeandspecialisms' or /H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step2' or /H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step4'">
                                                                <div class="leftnavitem">
                                                                        <xsl:apply-templates mode="c_userpage" select="/H2G2"/>
                                                                </div>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <div class="leftnavselected">my profile</div>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="PAGEUI/MYHOME[@VISIBLE=1]">
                                                <div class="leftnavitem">
                                                        <xsl:apply-templates mode="c_userpage" select="/H2G2"/>
                                                </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <div class="leftnavitem">
                                                        <a href="{$sso_signinlink}">my profile</a>
                                                </div>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:choose>
                                        <xsl:when test="/H2G2/HIERARCHYDETAILS/ARTICLE/SUBJECT = @NAME or /H2G2/ARTICLE/SUBJECT = @NAME or /H2G2/ARTICLE/ARTICLEINFO/NAME = @NAME">
                                                <div class="leftnavselected">
                                                        <xsl:value-of select="LINK"/>
                                                </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <div class="leftnavitem">
                                                        <a target="_top">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when test="@NAME = 'film catalogue'">
                                                                                        <xsl:value-of select="concat($root, 'C', $filmIndexPage)"/>
                                                                                 </xsl:when>
                                                                                 <xsl:when test="@NAME = 'people directory'">
                                                                                         <xsl:value-of select="concat($root, 'C', $directoryPage)"/>
                                                                                 </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="concat($root, LINK/@HREF)"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:if test="@NAME = 'sitehelprss'">
                                                                        <img height="16" id="rssicon" src="/ui/ide/1/images/icons/feed.gif" width="16"/>
                                                                </xsl:if>
                                                                <xsl:value-of select="LINK"/>
                                                        </a>
                                                </div>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="/H2G2/SITECONFIG/FILMMAKERSINDEX">
                <div class="textlightmedium">
                        <strong>
                                <xsl:value-of select="SUBHEADER"/>
                        </strong>
                </div>
                <div class="textlightsmall"/>
                <div class="textbrightsmall">
                        <div id="filmmaking_index">
                                <xsl:apply-templates select="UL | LI"/>
                        </div>
                </div>
        </xsl:template>
        <xsl:template match="BR">
                <br/>
        </xsl:template>
</xsl:stylesheet>
