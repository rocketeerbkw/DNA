<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:variable name="filmmakersnotes">
                <![CDATA[<MULTI-INPUT>
                        <REQUIRED NAME='TYPE'></REQUIRED>
                        <REQUIRED NAME='BODY'></REQUIRED>
                        <REQUIRED NAME='TITLE'></REQUIRED>
                        <ELEMENT NAME='ARTICLEFORUMSTYLE'></ELEMENT>
                        <ELEMENT NAME='HID'></ELEMENT>
                        <ELEMENT NAME='DIRECTORSNAME' EI='add'></ELEMENT>
                        <ELEMENT NAME='FILMLENGTH_MINS'></ELEMENT>
                        <ELEMENT NAME='YEARPRODUCTION'></ELEMENT>
                        <ELEMENT NAME='REGION' EI='add'></ELEMENT>
                        <ELEMENT NAME='DESCRIPTION'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT1'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT2'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT3'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT4'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT5'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT6'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT7'></ELEMENT>
                        <ELEMENT NAME='NOTE_TEXT8'></ELEMENT>
                </MULTI-INPUT>]]>
        </xsl:variable>
        <xsl:template name="FILM_NOTES">
                <xsl:variable name="article_header_gif">
                        <xsl:choose>
                                <xsl:when test="$showfakegifs = 'yes'">A4144196_large.jpg</xsl:when>
                                <xsl:otherwise>A<xsl:value-of select="ARTICLEINFO/H2G2ID"/>_large.jpg</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <style type="text/css">
	.dramaintroimagebg {background:url(<xsl:value-of select="$imagesource"/><xsl:value-of select="$gif_assets"/><xsl:value-of select="$article_header_gif"/>) top left no-repeat;}
                </style>
                <!-- Header information (film title, director, date, etc) for approved film or credit -->
                <xsl:call-template name="FILM_NOTES_HEAD"/>
                <!-- BEGIN MAIN BODY -->
                <table border="0" cellpadding="0" cellspacing="0" style="border-top:1px solid #A3A3A3;margin-top:10px;" width="635">
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
                                <td height="300" id="notesText" valign="top">
                                        <div id="notesHeading">
                                                <table cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td width="204">
                                                                        <h2>
                                                                                <img alt="filmmaker's notes" height="24" src="{$imagesource}furniture/heading_filmmakers_notes.gif" width="204"/>
                                                                        </h2>
                                                                </td>
                                                                <td align="right" valign="baseline">
                                                                        <!-- BEGIN edit filmmakers notes: only viewed by owner and editors -->
                                                                        <xsl:if test="$test_IsEditor or $ownerisviewer = 1 ">
                                                                                <div class="textmedium">
                                                                                        <!-- link to edit note-->
                                                                                        <strong>
                                                                                                <a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit filmmaker's notes</a>
                                                                                        </strong>
                                                                                        <img alt="" border="0" height="7" src="{$imagesource}furniture/linkgraphic.gif" width="10"/>
                                                                                </div>
                                                                        </xsl:if>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                        <!-- BEGIN primary content segment for filmmaker's notes page -->
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT1) > 0">
                                                <h3>What is your name? What was your role on this short?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT1"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT2) > 0">
                                                <h3>What was the inspiration for your short and what ideas were you exploring?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT2"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT3) > 0">
                                                <h3>Where did you find your cast and crew?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT3"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT4) > 0">
                                                <h3>What was the biggest challenge in making your short?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT4"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT5) > 0">
                                                <h3>If you could go back, what would you do differently?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT5"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT6) > 0">
                                                <h3>What opportunities has this short opened up for you?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT6"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT7) > 0">
                                                <h3>What advice would you give to other filmmakers?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT7"/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/NOTE_TEXT8) > 0">
                                                <h3>Any further comments or information about your short?</h3>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/NOTE_TEXT8"/>
                                                </div>
                                        </xsl:if>
                                        <!-- END primary content segment for filmmaker's notes page -->
                                        <!-- DISCUSSIONS 
		Div and green only for testings -->
                                        <div style="margin-top:10px;">
                                                <xsl:apply-templates mode="discussions_and_comments" select="/H2G2/ARTICLEFORUM"/>
                                        </div>
                                </td>
                                <td><!-- 20px spacer column --></td>
                                <td valign="top">
                                        <div class="box default" style="margin-top:10px;">
                                                <div class="boxTitleTop">
                                                        <strong>what are filmmakers notes?</strong>
                                                </div>
                                                <p>This page allows filmmakers to include more information about their film and add commentary.</p>
                                        </div>
                                </td>
                        </tr>
                </table>
                <xsl:apply-templates mode="c_articlefootnote" select=".//FOOTNOTE"/>
        </xsl:template>
        <!-- 
     #####################################################################################
	   defines the header (img, title, info) for an approved film 
     ##################################################################################### 
-->
        <xsl:template name="FILM_NOTES_HEAD">
                <!-- BEGIN background image for an approved film page -->
                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;" width="635">
                        <tr>
                                <td class="dramaintroimagebg" height="195" valign="top" width="635"/>
                        </tr>
                </table>
                <!-- END background image -->
                <!-- Intro -->
                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:19px;" width="635">
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
                                <!-- Film Title -->
                                <xsl:variable name="filmTitle">A<xsl:value-of select="ARTICLEINFO/H2G2ID"/>_title</xsl:variable>
                                <td align="right" valign="top">
                                        <img border="0" name="newmovietitle" src="{$imagesource}{$gif_assets}{$filmTitle}.gif">
                                                <xsl:attribute name="alt">
                                                        <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
                                                </xsl:attribute>
                                        </img>
                                        <br/>
                                        <!-- Director's Name: The link to the director's page is built using guideML -->
                                        <span class="textxxlarge">
                                                <strong>
                                                        <xsl:apply-templates select="GUIDE/DIRECTORSNAME"/>
                                                </strong>
                                        </span>
                                        <!-- BEGIN poll average votes -->
                                        <!-- check option list means it has been voted for at least 5 time and isn't a hidden poll -->
                                        <xsl:if test="$votes_cast &gt; 0">
                                                <xsl:apply-templates mode="average_vote" select="/H2G2/POLL-LIST/POLL/OPTION-LIST[../@HIDDEN=0]"/>
                                        </xsl:if>
                                        <!-- END poll average votes -->
                                        <div class="intocredit">
                                                <div class="intodetails">
                                                        <!-- BEGIN crumbtrail -->
                                                        <xsl:choose>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 90">
                                                                        <a class="textdark" href="{$root}C{$genreDrama}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=90 or @selectnumber=90]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 91">
                                                                        <a class="textdark" href="{$root}C{$genreComedy}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=91 or @selectnumber=91]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 92">
                                                                        <a class="textdark" href="{$root}C{$genreDocumentry}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=92 or @selectnumber=92]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 93">
                                                                        <a class="textdark" href="{$root}C{$genreAnimation}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=93 or @selectnumber=93]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 94">
                                                                        <a class="textdark" href="{$root}C{$genreExperimental}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=94 or @selectnumber=94]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                                <xsl:when test="EXTRAINFO/TYPE/@ID = 95">
                                                                        <a class="textdark" href="{$root}C{$genreMusic}">
                                                                                <xsl:value-of select="msxsl:node-set($type)/type[@number=95 or @selectnumber=95]/@subtype"/>
                                                                        </a>
                                                                </xsl:when>
                                                        </xsl:choose> | <!-- Date Stamp: Year only -->
                                                        <xsl:apply-templates select="GUIDE/YEARPRODUCTION"/> | 
                                                        <xsl:call-template name="LINK_REGION">
                                                                <xsl:with-param name="region">
                                                                        <xsl:value-of select="GUIDE/REGION"/>
                                                                </xsl:with-param>
                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                        </xsl:call-template> | <!-- Minute Stamp -->
                                                        <xsl:choose>
                                                                <xsl:when test="EXTRAINFO/FILMLENGTH_MINS > 0">
                                                                        <xsl:call-template name="LINK_MINUTES">
                                                                                <xsl:with-param name="minutes">
                                                                                        <xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/>
                                                                                </xsl:with-param>
                                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                                        </xsl:call-template> | </xsl:when>
                                                                <xsl:otherwise>
                                                                        <a class="textdark" href="{$root}C{$length2}"><xsl:value-of select="EXTRAINFO/FILMLENGTH_SECS"/> sec</a> | </xsl:otherwise>
                                                        </xsl:choose>
                                                        <!-- END crumbtrail -->
                                                </div>
                                                <!-- ALISTAIR: Note from annotation about this section: the date stamp is pulled from the date created node and this will need to be updated when the date published mechanism is working -->
                                                <!-- Film description and published date stamp --> Published <xsl:value-of select="ARTICLEINFO/DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                        select="substring(ARTICLEINFO/DATECREATED/DATE/@MONTHNAME, 1,3)"/>&nbsp;<xsl:value-of
                                                        select="substring(ARTICLEINFO/DATECREATED/DATE/@YEAR, 3,4)"/><br/>
                                                <xsl:apply-templates select="GUIDE/DESCRIPTION"/>
                                        </div>
                                        <!-- END edit filmmakers notes-->
                                </td>
                                <td><!-- 10px spacer column --></td>
                                <td class="introdivider"><!-- 10px spacer column -->&nbsp;</td>
                                <td valign="top">
                                        <a href="{$root}A{GUIDE/HID}">
                                                <img alt="go to film" height="69" src="{$imagesource}furniture/go_to_films.gif" width="135"/>
                                        </a>
                                </td>
                        </tr>
                </table>
                <!-- END Intro -->
        </xsl:template>
</xsl:stylesheet>