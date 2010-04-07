<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" version="1.0" exclude-result-prefixes="msxsl local s dt">
  <xsl:import href="site.xsl"/>
  <xsl:import href="lists.xsl"/>
  <xsl:import href="toolbar.xsl"/>
  <xsl:import href="sso.xsl"/>
  <xsl:import href="attributesets.xsl"/>
  <xsl:include href="basetext.xsl"/>
  <xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="no"/>

  <xsl:variable name="sitename">h2g2</xsl:variable>
  <xsl:variable name="scopename">h2g2</xsl:variable>

  <!--<xsl:variable name="showtreegadget">1</xsl:variable>-->
  <xsl:variable name="showtreegadget">
    <xsl:choose>
      <xsl:when test="number(/H2G2/VIEWING-USER/USER/USER-MODE) = 1">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="curdate" select="concat(/H2G2/DATE/@YEAR,/H2G2/DATE/@MONTH,/H2G2/DATE/@DAY,/H2G2/DATE/@HOURS,/H2G2/DATE/@MINUTES,/H2G2/DATE/@SECONDS)"/>
  <xsl:variable name="curday" select="/H2G2/DATE/@DAYNAME"/>

  <xsl:variable name="robotsetting">
    <xsl:choose>
      <xsl:when test="number(/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='AllowRobots']/VALUE) = number(1)">index,follow</xsl:when>
      <xsl:otherwise>noindex,nofollow</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="limitentries">
    <xsl:choose>
      <xsl:when test="/H2G2[@TYPE='USERPAGE']">10</xsl:when>
      <xsl:otherwise>10000</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="realmediadir">http://www.bbc.co.uk/h2g2/ram/</xsl:variable>

  <xsl:variable name="ownerisviewer">
    <xsl:choose>
      <xsl:when test="string(/H2G2/@TYPE) = 'USERPAGE' and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
      <xsl:when test="string(/H2G2/@TYPE) = 'MOREPOSTS' and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/POSTS/@USERID)">1</xsl:when>
      <xsl:when test="string(/H2G2/@TYPE) = 'ARTICLE' and number(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE) = 3 and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">1</xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="superuser">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/STATUS = 2">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="premoderated">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/MODERATIONSTATUS[@NAME='PREMODERATED']">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="restricted">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/MODERATIONSTATUS[@NAME='RESTRICTED']">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="registered">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="fpregistered">
    <xsl:choose>
      <xsl:when test="/H2G2/FRONTPAGE-EDIT-FORM/REGISTERED">
        <xsl:value-of select="/H2G2/FRONTPAGE-EDIT-FORM/REGISTERED"/>
      </xsl:when>
      <xsl:when test="/H2G2/VIEWING-USER/USER">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="viewerid">
    <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
  </xsl:variable>

  <!-- Get the PAGEUI variables in a more useable form -->
  <xsl:variable name="pageui_sitehome">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/SITEHOME/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/SITEHOME/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/SITEHOME/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_search">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/SEARCH/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/SEARCH/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/SEARCH/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_dontpanic">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/DONTPANIC/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/DONTPANIC/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/DONTPANIC/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_myhome">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/MYHOME/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/MYHOME/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/MYHOME/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_register">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/REGISTER/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/REGISTER/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/REGISTER/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_mydetails">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/MYDETAILS/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/MYDETAILS/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/MYDETAILS/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_logout">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/LOGOUT/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/LOGOUT/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/LOGOUT/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_editpage">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/EDITPAGE/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/EDITPAGE/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/EDITPAGE/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pageui_discuss">
    <xsl:choose>
      <xsl:when test="substring(/H2G2/PAGEUI/DISCUSS/@LINKHINT,1,1) = '/'">
        <xsl:value-of select="substring(/H2G2/PAGEUI/DISCUSS/@LINKHINT,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/H2G2/PAGEUI/DISCUSS/@LINKHINT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="root">/dna/h2g2/</xsl:variable>
  <xsl:variable name="rootbase">/dna/</xsl:variable>
  <xsl:variable name="imagesource">/h2g2/skins/Alabaster/images/</xsl:variable>
  <xsl:variable name="imagesource2">/h2g2/skins/Alabaster/images/</xsl:variable>
  <xsl:variable name="skingraphics">/h2g2/skins/Alabaster/images/</xsl:variable>
  <xsl:variable name="graphics">/h2g2/skins/Alabaster/images/</xsl:variable>
  <xsl:variable name="h2g2graphics">
    <xsl:value-of select="$foreignserver"/>/h2g2/blobs/
  </xsl:variable>
  <xsl:variable name="smileysource">
    <xsl:value-of select="$imagesource"/>
  </xsl:variable>
  <xsl:variable name="mymessage">
    <xsl:if test="$ownerisviewer=1">
      <xsl:text>My </xsl:text>
    </xsl:if>
  </xsl:variable>


  <xsl:variable name="skinname">Simple</xsl:variable>

  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <!-- number of category members beyond which the display will split into two columns -->
  <xsl:variable name="catcolcount">16</xsl:variable>

  <xsl:variable name="mainfontcolour">#000000</xsl:variable>
  <xsl:variable name="boxfontcolour">#000000</xsl:variable>
  <!-- light blue -->
  <xsl:variable name="journalfontsize">2</xsl:variable>

  <xsl:variable name="subbadges">
    <GROUPBADGE NAME="SUBS">
      <a href="{$root}SubEditors">
        <xsl:value-of select="$m_subgroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="ACES">
      <a href="{$root}Aces">
        <xsl:value-of select="$m_acesgroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="FIELDRESEARCHERS">
      <a href="{$root}University">
        <xsl:value-of select="$m_researchersgroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="SECTIONHEADS">
      <a href="{$root}SectionHeads">
        <xsl:value-of select="$m_sectionheadgroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="GURUS">
      <a href="{$root}Gurus">
        <xsl:value-of select="$m_GurusGroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="SCOUTS">
      <a href="{$root}Scouts">
        <xsl:value-of select="$m_ScoutsGroup"/>
      </a>
    </GROUPBADGE>
    <GROUPBADGE NAME="COMMUNITYARTISTS">
      <a href="{$root}CommunityArtists">Community Artists</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="POSTREPORTERS">
      <a href="{$root}ThePost">Post Reporters</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="TRANSLATOR">
      <a href="{$root}Translators">Translators</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="PHOTOGRAPHER">
      <a href="{$root}Photographers">Photographers</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="UNDERGUIDE">
      <a href="{$root}underguide">Underguide</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="SCAVENGER">
      <a href="{$root}Scavengers">Scavengers</a>
    </GROUPBADGE>
    <GROUPBADGE NAME="FORMERSTAFF">Former Staff</GROUPBADGE>
    <GROUPBADGE NAME="BBCTESTER">BBC Tester</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE1">25 Edited Entries</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE2">50 Edited Entries</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE3">75 Edited Entries</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE4">100 Edited Entries</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE5">150 Edited Entries</GROUPBADGE>
    <GROUPBADGE NAME="PROLIFICSCRIBE6">200 Edited Entries</GROUPBADGE>


  </xsl:variable>


  <!-- name and researcher ID as displayed on the homepage boxout-->
  <xsl:variable name="homepagedetailscolour">blue</xsl:variable>
  <xsl:variable name="headercolour">#000000</xsl:variable>
  <!-- page background colour -->
  <xsl:variable name="bgcolour">#FFFFFF</xsl:variable>
  <!-- colour of the button bar tablecell -->
  <xsl:variable name="buttonbarbgcolour">#BBBBBB</xsl:variable>
  <!-- colours of links -->
  <xsl:variable name="alinkcolour">#FF00FF</xsl:variable>
  <xsl:variable name="linkcolour">#0000BB</xsl:variable>
  <xsl:variable name="vlinkcolour">#880088</xsl:variable>
  <!-- colour of title in top fives box -->
  <xsl:variable name="topfivetitle">black</xsl:variable>
  <!-- colour of header text in forum -->
  <xsl:variable name="forumheader">green</xsl:variable>
  <!-- colour of header for referenced researchers -->
  <xsl:variable name="refresearchers">blue</xsl:variable>
  <!-- colour of header for referenced entries -->
  <xsl:variable name="refentries">blue</xsl:variable>
  <!-- colour of header for referenced sites -->
  <xsl:variable name="refsites">blue</xsl:variable>
  <xsl:variable name="topbar">black</xsl:variable>
  <!-- colour of the [3 members] bit on categorisation pages -->
  <xsl:variable name="memberscolour">black</xsl:variable>
  <!-- colour of an empty category -->
  <xsl:variable name="emptycatcolour">#006666</xsl:variable>
  <!-- colour of an full category -->
  <xsl:variable name="fullcatcolour">red</xsl:variable>
  <!-- colour of an article in a category -->
  <xsl:variable name="catarticlecolour"/>

  <xsl:variable name="blobbackground">white</xsl:variable>

  <xsl:variable name="picturebordercolour">#000000</xsl:variable>
  <xsl:variable name="pictureborderwidth">1</xsl:variable>

  <!-- Categorisation styles -->

  <xsl:variable name="catdecoration">none</xsl:variable>
  <xsl:variable name="catcolour"/>
  <xsl:variable name="artdecoration">none</xsl:variable>
  <xsl:variable name="artcolour"/>
  <xsl:variable name="hovcatdecoration">underline ! important</xsl:variable>
  <xsl:variable name="hovcatcolour"/>
  <xsl:variable name="hovartdecoration">underline ! important</xsl:variable>
  <xsl:variable name="hovartcolour"/>
  <xsl:variable name="catfontheadersize">5</xsl:variable>
  <xsl:variable name="catfontheadercolour">blue</xsl:variable>


  <!-- categorisation boxout colours -->
  <xsl:variable name="catboxwidth">165</xsl:variable>
  <!-- background colour -->
  <xsl:variable name="catboxbg">#ffffff</xsl:variable>
  <!-- title colour -->
  <xsl:variable name="catboxtitle">green</xsl:variable>
  <!-- main link colour -->
  <xsl:variable name="catboxmain">white</xsl:variable>
  <!-- sub link colour -->
  <xsl:variable name="catboxsublink">red</xsl:variable>
  <!-- other link colour -->
  <xsl:variable name="catboxotherlink">purple</xsl:variable>
  <xsl:variable name="catboxlinecolour">black</xsl:variable>


  <xsl:variable name="horizdividers">black</xsl:variable>
  <xsl:variable name="verticalbarcolour">#99CCCC</xsl:variable>

  <!-- colour of the errors displayed when editing articles-->
  <xsl:variable name="xmlerror">#FF0000</xsl:variable>

  <xsl:variable name="boxoutcolour">#CCFFFF</xsl:variable>
  <xsl:variable name="boxholderfontcolour">#33FFFF</xsl:variable>
  <xsl:variable name="boxholderleftcolour">#000099</xsl:variable>
  <xsl:variable name="boxholderrightcolour">#006699</xsl:variable>
  <xsl:variable name="headertopedgecolour">#CCCCCC</xsl:variable>
  <xsl:variable name="headerbgcolour">#006699</xsl:variable>
  <xsl:variable name="pullquotecolour">#BB4444</xsl:variable>
  <xsl:variable name="welcomecolour">#ff6666</xsl:variable>
  <xsl:variable name="CopyrightNoticeColour">#000000</xsl:variable>
  <xsl:variable name="WarningMessageColour">red</xsl:variable>

  <!-- font details -->
  <xsl:variable name="fontsize">2</xsl:variable>
  <xsl:variable name="fontface">Arial, Helvetica, sans-serif</xsl:variable>
  <xsl:variable name="buttonfont">Verdana, Verdana, Arial, Helvetica, sans-serif</xsl:variable>
  <xsl:variable name="ftfontsize">2</xsl:variable>
  <xsl:variable name="regmessagesize">1</xsl:variable>
  <xsl:variable name="forumtitlesize">2</xsl:variable>
  <xsl:variable name="forumsubsize">1</xsl:variable>

  <!-- colours for links in forum threads page -->

  <xsl:variable name="ftfontcolour">#000000</xsl:variable>
  <xsl:variable name="ftbgcolour">#99CCCC</xsl:variable>
  <xsl:variable name="ftbgcolour2">#77BBBB</xsl:variable>
  <xsl:variable name="ftbgcoloursel">#000033</xsl:variable>
  <xsl:variable name="ftalinkcolour">#333333</xsl:variable>
  <xsl:variable name="ftlinkcolour">#000000</xsl:variable>
  <xsl:variable name="ftvlinkcolour">#883333</xsl:variable>
  <xsl:variable name="ftcurrentcolour">#FF0000</xsl:variable>
  <xsl:variable name="forumsourcelink">green</xsl:variable>

  <xsl:variable name="fttitle">#009999</xsl:variable>
  <!-- If the following are set to false they are excluded from that skin's user details page -->
  <xsl:variable name="expertmode" select="true()"/>
  <xsl:variable name="framesmode" select="true()"/>
  <xsl:variable name="changeableskins" select="true()"/>
  <xsl:variable name="DefaultRFID" select="/H2G2/SUBMIT-REVIEW-FORUM/REVIEWFORUMS/FORUMNAME/@ID"/>
  <xsl:variable name="skinlist">
    <SKINDEFINITION>
      <NAME>Alabaster</NAME>
      <DESCRIPTION>Alabaster</DESCRIPTION>
    </SKINDEFINITION>
    <SKINDEFINITION>
      <NAME>Classic</NAME>
      <DESCRIPTION>Classic GOO</DESCRIPTION>
    </SKINDEFINITION>
    <SKINDEFINITION>
      <NAME>brunel</NAME>
      <DESCRIPTION>Brunel</DESCRIPTION>
    </SKINDEFINITION>
  </xsl:variable>

  <!--

	<xsl:attribute-set name="mainfont">

	Purpose:	attributes for the main font in this stylesheet

-->

  <xsl:attribute-set name="mainfont">
    <xsl:attribute name="class">mainfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="mainbodytag">
    <xsl:attribute name="bgcolor">
      <xsl:value-of select="$bgcolour"/>
    </xsl:attribute>
    <xsl:attribute name="text">
      <xsl:value-of select="$boxfontcolour"/>
    </xsl:attribute>
    <xsl:attribute name="MARGINHEIGHT">4</xsl:attribute>
    <xsl:attribute name="MARGINWIDTH">4</xsl:attribute>
    <xsl:attribute name="TOPMARGIN">4</xsl:attribute>
    <xsl:attribute name="LEFTMARGIN">4</xsl:attribute>
    <xsl:attribute name="link">
      <xsl:value-of select="$linkcolour"/>
    </xsl:attribute>
    <xsl:attribute name="vlink">
      <xsl:value-of select="$vlinkcolour"/>
    </xsl:attribute>
    <xsl:attribute name="alink">
      <xsl:value-of select="$alinkcolour"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="frontpagefont" use-attribute-sets="mainfont">

	Purpose:	body font for the frontpage

-->

  <xsl:attribute-set name="linkatt">
  </xsl:attribute-set>

  <xsl:attribute-set name="frontpagefont">
    <xsl:attribute name="class">frontpagefont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="buttons">
    <xsl:attribute name="class">buttons</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumtitlefont">
    <xsl:attribute name="class">forumtitlefont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsubfont">
    <xsl:attribute name="class">forumsubfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="boxfont">
    <xsl:attribute name="class">boxfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsource">
    <xsl:attribute name="class">forumsource</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsubject">
    <xsl:attribute name="class">forumsubject</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsubjectlabel">
    <xsl:attribute name="class">forumsubjectlabel</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumposted">
    <xsl:attribute name="class">forumposted</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumpostedlabel">
    <xsl:attribute name="class">forumpostedlabel</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsmall">
    <xsl:attribute name="class">forumsmall</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumsourcelink">
    <xsl:attribute name="class">forumsourcelink</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="journaltitle">
    <xsl:attribute name="class">journaltitle</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="journalbody" use-attribute-sets="mainfont">
    <xsl:attribute name="size">
      <xsl:value-of select="$journalfontsize"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="asftUSER-DETAILS-FORM_PrefMode">
  </xsl:attribute-set>

  <xsl:attribute-set name="asftUSER-DETAILS-FORM_PrefForumStyle">
  </xsl:attribute-set>

  <xsl:attribute-set name="mENTRYLINK_UI">
  </xsl:attribute-set>

  <xsl:attribute-set name="mUSERLINK_UI">
  </xsl:attribute-set>

  <xsl:attribute-set name="mEXTERNALLINK_BBCSitesUI">
  </xsl:attribute-set>

  <xsl:attribute-set name="mEXTERNALLINK_NONBBCSitesUI">
  </xsl:attribute-set>

  <xsl:attribute-set name="nPeopleTalking">
  </xsl:attribute-set>

  <xsl:attribute-set name="mPOSTTHREADFORM_Subj">
  </xsl:attribute-set>


  <!--

	<xsl:attribute-set name="pageauthorsfont" use-attribute-sets="mainfont">

	Purpose:	font for displaying authors of the page

-->

  <xsl:attribute-set name="pageauthorsfont">
    <xsl:attribute name="class">pageauthorsfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="registermessage">
    <xsl:attribute name="class">registermessage</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="headerfont" use-attribute-sets="mainfont">

	Purpose:	Font style for headers

-->

  <xsl:attribute-set name="headerfont">
    <xsl:attribute name="class">headerfont</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="subheaderfont" use-attribute-sets="mainfont">

	Purpose:	subheader font style

-->

  <xsl:attribute-set name="subheaderfont">
    <xsl:attribute name="class">subheaderfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="gadgetfont">
    <xsl:attribute name="class">gadgetfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cellstyle">
    <xsl:attribute name="align">center</xsl:attribute>
    <xsl:attribute name="valign">center</xsl:attribute>
    <xsl:attribute name="width">10</xsl:attribute>
    <xsl:attribute name="height">8</xsl:attribute>
    <xsl:attribute name="bgcolor">cyan</xsl:attribute>
  </xsl:attribute-set>
  <!--

	<xsl:attribute-set name="xmlerrorfont" use-attribute-sets="mainfont">

	Purpose:	Font attrs for displaying an xml error

-->

  <xsl:attribute-set name="xmlerrorfont">
    <xsl:attribute name="class">xmlerrorfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subjectfont">
    <xsl:attribute name="class">subjectfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topfivetitle">
    <xsl:attribute name="class">topfivetitle</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topfivefont">
    <xsl:attribute name="class">topfivefont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topfiveitem">
    <xsl:attribute name="class">topfiveitem</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="navbuttons">
    <xsl:attribute name="class">navbuttons</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="lifelinks">
    <xsl:attribute name="class">lifelinks</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="pullquote" use-attribute-sets="mainfont">

	Purpose:	Font used in pullquotes

-->

  <xsl:attribute-set name="pullquote">
    <xsl:attribute name="class">pullquote</xsl:attribute>
  </xsl:attribute-set>

  <!--
	Attributes for the font used for the copyright notice at the bottom
	of every page.
-->

  <xsl:attribute-set name="CopyrightNoticeFont" use-attribute-sets="mainfont">
    <xsl:attribute name="color">
      <xsl:value-of select="$CopyrightNoticeColour"/>
    </xsl:attribute>
    <xsl:attribute name="size">1</xsl:attribute>
  </xsl:attribute-set>

  <!--
	Attribute set used in warning messages - currently used only by internal tools
-->

  <xsl:attribute-set name="WarningMessageFont">
    <xsl:attribute name="class">warningmessagefont</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="pullquotetable">

	Purpose:	attributes of table used by pullquotes

-->

  <xsl:attribute-set name="pullquotetable">
    <xsl:attribute name="CELLPADDING">6</xsl:attribute>
    <xsl:attribute name="CELLSPACING">6</xsl:attribute>
    <xsl:attribute name="WIDTH">200</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="picturetable">

	Purpose:	attributes of table used by PICTURE tag

-->

  <xsl:attribute-set name="picturetable">
    <xsl:attribute name="border">0</xsl:attribute>
    <xsl:attribute name="cellspacing">0</xsl:attribute>
    <xsl:attribute name="cellpadding">0</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfont" use-attribute-sets="mainfont">

	Purpose:	font used in categorisation page

-->

  <xsl:attribute-set name="catfont">
    <xsl:attribute name="class">catfont</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfontfullsubject" use-attribute-sets="catfont">

	Purpose:	font used when subject has members

-->

  <xsl:attribute-set name="catfontfullsubject">
    <xsl:attribute name="class">catfontfullsubject</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfontemptysubject" use-attribute-sets="catfont">

	Purpose:	font used when subject is empty

-->

  <xsl:attribute-set name="catfontemptysubject">
    <xsl:attribute name="class">catfontemptysubject</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfontarticle" use-attribute-sets="catfont">

	Purpose:	font used for an article in the categorisation display

-->

  <xsl:attribute-set name="catfontarticle">
    <xsl:attribute name="class">catfontarticle</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfontmember" use-attribute-sets="catfont">

	Purpose:	font used to display the number of members of the category

-->

  <xsl:attribute-set name="catfontmember">
    <xsl:attribute name="class">catfontmember</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="catfontheader" use-attribute-sets="catfont">

	Purpose:	Header font on categorisation page

-->

  <xsl:attribute-set name="catfontheader">
    <xsl:attribute name="class">catfontheader</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="captionfont" use-attribute-sets="mainfont">

	Purpose:	Font used in a picture caption

-->

  <xsl:attribute-set name="captionfont">
    <xsl:attribute name="class">captionfont</xsl:attribute>
  </xsl:attribute-set>

  <!--

	<xsl:attribute-set name="introfont" use-attribute-sets="mainfont">

	Purpose:	Font used in the Intro section

-->

  <xsl:attribute-set name="introfont">
    <xsl:attribute name="class">introfont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxtitle">
    <xsl:attribute name="class">catboxtitle</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxsmalllink">
    <xsl:attribute name="class">catboxsmalllink</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxmain">
    <xsl:attribute name="class">catboxmain</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxsubtext">
    <xsl:attribute name="class">catboxsubtext</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxsublink">
    <xsl:attribute name="class">catboxsublink</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="catboxotherlink">
    <xsl:attribute name="class">catboxotherlink</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumblockson">
    <xsl:attribute name="class">forumblockson</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="forumblocksoff">
    <xsl:attribute name="class">forumblocksoff</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="welcomeback">
    <xsl:attribute name="class">welcomeback</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="onlinefont">
    <xsl:attribute name="class">onlinefont</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="reviewforumlistheader">
    <xsl:attribute name="class">reviewforumlistheader</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="reviewforumlistentry">
    <xsl:attribute name="class">reviewforumlistentry</xsl:attribute>
  </xsl:attribute-set>
  <!--

	<xsl:attribute-set name="body">

	Purpose:	Attributes in main body tag

-->

  <xsl:attribute-set name="body">
    <xsl:attribute name="bgcolor">
      <xsl:value-of select="$bgcolour"/>
    </xsl:attribute>
    <xsl:attribute name="text">
      <xsl:value-of select="$boxfontcolour"/>
    </xsl:attribute>
    <xsl:attribute name="MARGINHEIGHT">4</xsl:attribute>
    <xsl:attribute name="MARGINWIDTH">4</xsl:attribute>
    <xsl:attribute name="TOPMARGIN">4</xsl:attribute>
    <xsl:attribute name="LEFTMARGIN">4</xsl:attribute>
    <xsl:attribute name="link">
      <xsl:value-of select="$linkcolour"/>
    </xsl:attribute>
    <xsl:attribute name="vlink">
      <xsl:value-of select="$vlinkcolour"/>
    </xsl:attribute>
    <xsl:attribute name="alink">
      <xsl:value-of select="$alinkcolour"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
<xsl:attribute-set name="ArticleEditLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Edit Entry link
-->
  <xsl:attribute-set name="ArticleEditLinkAttr" use-attribute-sets="linkatt"/>


  <!--
<xsl:attribute-set name="CategoriseLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Categorise link on Articleinfo
-->
  <xsl:attribute-set name="CategoriseLinkAttr"/>


  <!--
<xsl:attribute-set name="RetToEditorsLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Return to Editors link
-->
  <xsl:attribute-set name="RetToEditorsLinkAttr"/>


  <!--
	template: *
	Matches any unmatched tags and copies them straight through
	Generic:	Yes
-->

  <xsl:template match="*|@*|text()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:choose>
      <xsl:when test="contains(translate(.,$uppercase,$lowercase),'document.cookie')">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="*|@*|text()|comment()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	Here's our basic template, containing various value-of tags to insert
	the info from the xml data. The code handling the different tags is below
	in the xsl:template tags.
	Generic:	Yes
-->

  <xsl:template match="/">
    <xsl:apply-templates select="H2G2"/>
  </xsl:template>

  <!--
	template: <H2G2>
	This is the primary match for all H2G2 elements, unless one of the specific
	matches on the TYPE attribute catch it first. This is the main template
	for general pages, and has a lot of conditional stuff which might be
	better off in a more specialised stylesheet.

	Non-Generic - must be overridden unless you're happy with simple layout

-->

  <xsl:template match="H2G2">
    <xsl:call-template name="primary-template"/>
  </xsl:template>

  <xsl:template name="primary-template">
    <html>
      <xsl:call-template name="insert-header"/>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="4" MARGINWIDTH="4" TOPMARGIN="4" LEFTMARGIN="4" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3" bgcolor="{$buttonbarbgcolour}" align="left" valign="top">
              <xsl:call-template name="buttons"/>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top" width="100%" colspan="3">
              <xsl:call-template name="insert-strapline"/>
            </td>
          </tr>
          <tr>
            <td valign="top">
              <xsl:call-template name="insert-leftcol"/>
            </td>
            <td align="left" valign="top" width="75%">
              <xsl:comment>
                <xsl:value-of select="SERVERNAME"/>
              </xsl:comment>
              <xsl:call-template name="insert-subject"/>
              <xsl:call-template name="insert-mainbody"/>
            </td>

            <td width="25%" align="left" valign="top">
              <xsl:call-template name="insert-sidebar"/>

            </td>
          </tr>
        </table>
        <!-- place the complaints text and link -->
        <p align="center">
          <xsl:call-template name="m_pagebottomcomplaint"/>
        </p>
        <!-- do the copyright notice -->
        <xsl:call-template name="CopyrightNotice"/>
      </body>
    </html>
  </xsl:template>


  <!--
	template: Status Page
	This template matches the output of the status page and ensures that the output
	is kept as simple as possible, i.e. no graphics or javascript
	Generic
-->

  <xsl:template match="H2G2[@TYPE='STATUSPAGE']">
    <html>
      <head>
        <title>Ripley Status Report</title>
      </head>
      <body>
        <h1>
          Status: <xsl:value-of select="/H2G2/STATUS-REPORT/STATUS"/>
        </h1>
        <b>
          <xsl:value-of select="/H2G2/STATUS-REPORT/MESSAGE"/>
          <br/>
          Computer name: <xsl:value-of select="/H2G2/SERVERNAME"/>

          <xsl:if test="PARAMS/PARAM/NAME='s_disp' and PARAMS/PARAM/VALUE='version'">
            <br/>
            Version: <xsl:value-of select="/H2G2/STATUS-REPORT/RIPLEYSERVERINFO/FILEVERSION"/><xsl:value-of select="/H2G2/STATUS-REPORT/FILEVERSION"/>
          </xsl:if>
        </b>
      </body>
    </html>
  </xsl:template>

  <!--

	<xsl:template match='H2G2[@TYPE="REDIRECT"]'>

	Generic:	Yes
	Purpose:	uses META-refresh to redirect. Usually not needed.

-->

  <xsl:template match="H2G2[@TYPE='REDIRECT']">
    <html>
      <head>
        <meta>
          <xsl:attribute name="content">
            0;url=<xsl:value-of select="REDIRECT-TO"/>
          </xsl:attribute>
          <xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
        </meta>
      </head>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        Please wait, while your call is transferred...
      </body>
    </html>
  </xsl:template>

  <!--
	<xsl:template match="REFEREE-LIST">
	Author:		Igor Loboda
	Generic:	Yes
	Purpose:	fills the options list for ReferTo html select control
-->
  <xsl:template match="REFEREE-LIST">
    <xsl:param name="SiteID"/>
    <option value="0" selected="selected">Refer to:</option>
    <option value="0">Anyone</option>
    <xsl:for-each select="REFEREE[SITEID = $SiteID]/USER">
      <option value="{USERID}">
        <xsl:value-of select="USERNAME"/>
      </option>
    </xsl:for-each>
  </xsl:template>

  <!--

	<xsl:template match='H2G2[@TYPE="REDIRECT-TARGET"]'>

	Generic:	Yes
	Purpose:	Use this to redirect to specified target frame.

-->

  <xsl:template match="H2G2[@TYPE='REDIRECT-TARGET']">
    <HTML>
      <HEAD>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
      </HEAD>
      <BODY ONLOAD="Anchor.click()" BGCOLOR="{$bgcolour}" TEXT="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" LINK="{$linkcolour}" VLINK="{$vlinkcolour}" ALINK="{$alinkcolour}">
        <A ID="Anchor">
          <xsl:attribute name="TARGET">
            <xsl:value-of select="//REDIRECT-TO-TARGET"/>
          </xsl:attribute>
          <xsl:attribute name="HREF">
            <xsl:value-of select="//REDIRECT-TO"/>
          </xsl:attribute>
          <xsl:value-of select="$m_clickifnotredirected"/>
        </A>
      </BODY>
    </HTML>
  </xsl:template>

  <!--
Categorisation page. Here's the XML tree we expect:

- <HIERARCHYDETAILS NODEID="47">
	  <DISPLAYNAME>South America</DISPLAYNAME> 
	- <CATEGORY>
		  <CATID>24</CATID> 
		  <CATEGORY-NAME>South America</CATEGORY-NAME> 
		  <DESCRIPTION>This is where you can find entries about South America.</DESCRIPTION> 
	  </CATEGORY>
	- <ANCESTRY>
		- <ANCESTOR>
			  <NODEID>73</NODEID> 
			  <NAME>The Universe</NAME> 
		  </ANCESTOR>
		- <ANCESTOR>
			  <NODEID>42</NODEID> 
			  <NAME>The Earth</NAME> 
		  </ANCESTOR>
	  </ANCESTRY>
	- <MEMBERS>
		- <SUBJECTMEMBER SORTORDER="0">
			  <NODEID>346</NODEID> 
			  <CATEGORYID>300</CATEGORYID> 
			  <NODECOUNT>0</NODECOUNT> 
			  <ARTICLECOUNT>0</ARTICLECOUNT> 
			  <NAME>Argentina</NAME> 
		  </SUBJECTMEMBER>
		- <ARTICLEMEMBER SORTORDER="1">
			  <H2G2ID>155954</H2G2ID> 
			  <NAME>Guinea Pigs</NAME> 
			  <SECTION /> 
			  <SECTIONDESCRIPTION /> 
		  </ARTICLEMEMBER>
		  ...
	  </MEMBERS>
  </HIERARCHYDETAILS>

-->


  <!--

	<xsl:template match="HIERARCHYDETAILS">

	Generic:	Yes (with attribute variables)
	Purpose:	Matches the HIERARCHYDETAILS tag and displays the hierarchy.


<xsl:template match="HIERARCHYDETAILS" mode="CATEGORY">
<font xsl:use-attribute-sets="catfontheader"><B><xsl:value-of select="DISPLAYNAME"/></B></font><br/>
<font xsl:use-attribute-sets="catfont">
<xsl:apply-templates select="DESCRIPTION"/>
<hr/>
<xsl:apply-templates select="ANCESTRY"/>
<hr/>
<xsl:apply-templates select="MEMBERS">
<xsl:with-param name="columnlen"><xsl:choose><xsl:when test="count(MEMBERS/*) &lt; $catcolcount"><xsl:value-of select="$catcolcount"/></xsl:when><xsl:otherwise><xsl:value-of select="floor(count(MEMBERS/*) div 2)"/></xsl:otherwise></xsl:choose></xsl:with-param>
<xsl:with-param name="numitems"><xsl:value-of select="count(MEMBERS/*)"/></xsl:with-param>
</xsl:apply-templates>
</font>
</xsl:template>

-->

  <xsl:template match="EDITCATEGORY">
    <span xsl:use-attribute-sets="catfontheader">
      <B>
        <xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/>
      </B>
    </span>
    <A>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>editcategory?action=renamesubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>
      </xsl:attribute>
      <br/>
      <xsl:call-template name="m_EditCatRenameSubjectButton"/>
    </A>
    <br/>


    <span xsl:use-attribute-sets="catfont">
      <xsl:apply-templates select="HIERARCHYDETAILS/DESCRIPTION">
        <xsl:with-param name="iscategory">0</xsl:with-param>
      </xsl:apply-templates>


      <hr/>


      <xsl:variable name="action">
        <xsl:choose>
          <xsl:when test="ACTIVENODE/@TYPE">
            &amp;action=navigate<xsl:value-of select="ACTIVENODE/@TYPE"/>
          </xsl:when>
          <xsl:otherwise>
            &amp;action=navigatesubject
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>


      <xsl:apply-templates select="HIERARCHYDETAILS/ANCESTRY">
        <xsl:with-param name="iscategory">0</xsl:with-param>
        <xsl:with-param name="activenode">
          <xsl:if test="ACTIVENODE/@ACTIVEID">
            &amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>
          </xsl:if>
          <xsl:if test="ACTIVENODE/@DELNODE">
            &amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="action" select="$action"/>
      </xsl:apply-templates>
      <hr/>


      <A>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>editcategory?action=addsubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>
        </xsl:attribute>
        <xsl:call-template name="m_EditCatAddSubjectButton"/>
      </A>
      <br/>
      <xsl:choose>
        <xsl:when test="ACTIVENODE/@TYPE='article'">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>editcategory?action=storearticle&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/>
            </xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the article here');</xsl:attribute>Store the article "<xsl:value-of select="ACTIVENODE"/>" here
          </A>
        </xsl:when>
        <xsl:when test="ACTIVENODE/@TYPE='alias'">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>editcategory?action=storealias&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/>
            </xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the link here');</xsl:attribute>Move the link "<xsl:value-of select="ACTIVENODE"/>" here
          </A>
        </xsl:when>
        <xsl:when test="ACTIVENODE/@TYPE='subject'">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>editcategory?action=storesubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>
            </xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the subject here');</xsl:attribute>Store the subject "<xsl:value-of select="ACTIVENODE"/>" here
          </A>
          <br/>
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>editcategory?action=doaddalias&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>
            </xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the link here');</xsl:attribute>Store the link "<xsl:value-of select="ACTIVENODE"/>" here
          </A>
        </xsl:when>
      </xsl:choose>
      <!-- add your own messages here if you don't want the default ones-->

      <xsl:if test="ERROR">
        <br/>
        <xsl:choose>
          <xsl:when test="ERROR/@TYPE='9'">
            <span xsl:use-attribute-sets="xmlerrorfont">
              That subject already exists
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span xsl:use-attribute-sets="xmlerrorfont">
              <xsl:value-of select="ERROR"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:apply-templates select="EDITINPUT">
        <xsl:with-param name="nodeid">
          <xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>
        </xsl:with-param>
        <xsl:with-param name="displayname">
          <xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/>
        </xsl:with-param>
      </xsl:apply-templates>
      <hr/>

      <xsl:if test="HIERARCHYDETAILS/@ISROOT=0">
        Add an article to this subject
        <FORM METHOD="GET" ACTION="EditCategory">
          Article ID: <INPUT TYPE="TEXT" NAME="h2g2id"/>
          <INPUT TYPE="HIDDEN" NAME="nodeid" VALUE="{HIERARCHYDETAILS/@NODEID}"/>
          <INPUT TYPE="HIDDEN" NAME="action" VALUE="doaddarticle"/>
          <INPUT TYPE="SUBMIT" NAME="button" VALUE="Store Article"/>
        </FORM>
      </xsl:if>
      <hr/>

      <xsl:apply-templates select="HIERARCHYDETAILS/MEMBERS">
        <xsl:with-param name="columnlen">
          <xsl:choose>
            <xsl:when test="count(HIERARCHYDETAILS/MEMBERS/*) &lt; $catcolcount">
              <xsl:value-of select="$catcolcount"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="floor(count(HIERARCHYDETAILS/MEMBERS/*) div 2)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="numitems">
          <xsl:value-of select="count(HIERARCHYDETAILS/MEMBERS/*)"/>
        </xsl:with-param>
        <xsl:with-param name="iscategory">0</xsl:with-param>
        <xsl:with-param name="activenode">
          <xsl:if test="ACTIVENODE/@ACTIVEID">
            &amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>
          </xsl:if>
          <xsl:if test="ACTIVENODE/@DELNODE">
            &amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="action" select="$action"/>
      </xsl:apply-templates>

    </span>

  </xsl:template>

  <xsl:template match="EDITINPUT">
    <xsl:param name="nodeid"/>
    <xsl:param name="displayname"/>

    <xsl:choose>
      <xsl:when test="@TYPE='renamesubject'">
        <FORM method="GET" action="{$root}editcategory">
          Rename this subject<BR/>
          New Name: <INPUT name="subject" type="TEXT">
            <xsl:attribute name="value">
              <xsl:value-of select="$displayname"/>
            </xsl:attribute>
          </INPUT>
          <INPUT type="SUBMIT" value="Rename"/><BR/>
          <INPUT name="action" type="HIDDEN" value="dorenamesubject"/>
          <INPUT name="nodeid" type="HIDDEN">
            <xsl:attribute name="value">
              <xsl:value-of select="$nodeid"/>
            </xsl:attribute>
          </INPUT>
        </FORM>
      </xsl:when>

      <xsl:when test="@TYPE='addsubject'">
        <FORM method="GET" action="{$root}editcategory">
          <B>Enter the new subject name</B><BR/>
          New Subject: <INPUT name="subject" type="TEXT"/>
          <INPUT type="SUBMIT" value="Add"/><BR/>
          <INPUT name="action" type="HIDDEN" value="doaddsubject"/>
          <INPUT name="nodeid" type="HIDDEN">
            <xsl:attribute name="value">
              <xsl:value-of select="$nodeid"/>
            </xsl:attribute>
          </INPUT>
        </FORM>
      </xsl:when>

      <xsl:when test="@TYPE='changedescription'">
        <FORM method="POST" action="{$root}editcategory">
          <B>Change the subject's description</B><BR/>
          Description: <BR/>
          <TEXTAREA cols="50" name="description" wrap="VIRTUAL" rows="3">
            <xsl:apply-templates/>
          </TEXTAREA>
          <INPUT name="action" type="HIDDEN" value="dochangedesc"/>
          <INPUT name="nodeid" type="HIDDEN">
            <xsl:attribute name="value">
              <xsl:value-of select="$nodeid"/>
            </xsl:attribute>
          </INPUT>
          <BR/><INPUT type="SUBMIT" value="Update"/>
        </FORM>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!--

	<xsl:template match="DESCRIPTION" mode="EDITCATEGORY">

	Generic:	Yes
	Purpose:	Displays the subject description and a link to rename the description



<xsl:template match="HIERARCHYDETAILS/DESCRIPTION">
<xsl:param name="iscategory">1</xsl:param>
<xsl:apply-templates/>
<xsl:if test="$iscategory=0">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=renamedesc&amp;nodeid=<xsl:value-of select="../@NODEID"/></xsl:attribute><BR/><xsl:call-template name="m_EditCatRenameDesc"/></A>
</xsl:if>
</xsl:template>
-->

  <!--

	<xsl:template match="ANCESTRY">

	Generic:	Yes
	Purpose:	Displays the ancestry path (Life > Culture > Yoghurt)


<xsl:template match="ANCESTRY">
<xsl:param name="iscategory">1</xsl:param>
<xsl:param name="activenode"/>
<xsl:param name="action">&amp;action=navigatesubject</xsl:param>

 
<xsl:for-each select="ANCESTOR">
<xsl:choose>
	<xsl:when test="$iscategory=1">
	<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>C<xsl:value-of select="NODEID"/></xsl:attribute><xsl:value-of select="NAME"/></A> / 
	</xsl:when>
	<xsl:otherwise>
	<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/></xsl:attribute><xsl:value-of select="NAME"/></A> / 
	</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:value-of select="../DISPLAYNAME"/>
</xsl:template>
-->

  <!--

	<xsl:template match="MEMBERS">

	Generic:	Yes (given variable setting)
	Purpose:	Displays the members of the category in two columns



<xsl:template match="MEMBERS">
<xsl:param name="iscategory">1</xsl:param>
<xsl:param name="activenode"/>
<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
<xsl:param name="columnlen">120</xsl:param>
<xsl:param name="numitems">120</xsl:param>
<P></P>
<TABLE width="100%">
	<TR valign="top">
		<TD width="50%">
			<font xsl:use-attribute-sets="catfont">
			<UL>
			<xsl:apply-templates select="SUBJECTMEMBER[number(@SORTORDER) &lt; $columnlen]|ARTICLEMEMBER[number(@SORTORDER) &lt; $columnlen]|NODEALIASMEMBER[number(@SORTORDER) &lt; $columnlen]">
				<xsl:sort select="@SORTORDER" data-type="number" order="ascending"/>
				<xsl:with-param name="iscategory" select="$iscategory"/>
				<xsl:with-param name="activenode" select="$activenode"/>
				<xsl:with-param name="action" select="$action"/>
			</xsl:apply-templates>
			</UL>
			</font>
		</TD>
		<TD width="50%">
			<font xsl:use-attribute-sets="catfont">
			
			<UL>
				<xsl:apply-templates select="SUBJECTMEMBER[number(@SORTORDER) &gt; ($columnlen)-1]|ARTICLEMEMBER[number(@SORTORDER) &gt; ($columnlen)-1]|NODEALIASMEMBER[number(@SORTORDER) &gt; $columnlen]">
					<xsl:sort select="@SORTORDER" data-type="number" order="ascending"/>
					<xsl:with-param name="iscategory" select="$iscategory"/>
					<xsl:with-param name="activenode" select="$activenode"/>
					<xsl:with-param name="action" select="$action"/>
				</xsl:apply-templates>
			</UL>
			</font>
		</TD>
	</TR>
</TABLE>
</xsl:template>
-->

  <!--

	<xsl:template match="SUBJECTMEMBER">

	Generic:	Yes
	Purpose:	Displays a subject category on the browse page



<xsl:template match="MEMBERS/SUBJECTMEMBER">
<xsl:param name="iscategory">1</xsl:param>
<xsl:param name="activenode"/>
<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
<LI>
<DIV class="category">

<xsl:variable name="linkto">
<xsl:choose>
<xsl:when test="$iscategory=1">C<xsl:value-of select="NODEID"/></xsl:when>
<xsl:otherwise>
editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>


<xsl:choose>
<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><FONT xsl:use-attribute-sets="catfontemptysubject"><xsl:value-of select="NAME"/></FONT></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [<xsl:value-of select="$m_nomembers"/>]</NOBR></FONT>
</xsl:when>
<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><B><FONT xsl:use-attribute-sets="catfontfullsubject"><xsl:value-of select="NAME"/></FONT></B></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [1<xsl:value-of select="$m_member"/>]</NOBR></FONT>
</xsl:when>
<xsl:otherwise>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><B><FONT xsl:use-attribute-sets="catfontfullsubject"><xsl:value-of select="NAME"/></FONT></B></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/><xsl:value-of select="$m_members"/>]</NOBR></FONT>
</xsl:otherwise>

</xsl:choose>


<xsl:if test="$iscategory=0">
<br/>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatesubject&amp;activenode=<xsl:value-of select="NODEID"/></xsl:attribute><xsl:call-template name="m_movesubject"/></A><xsl:call-template name="m_EditCatDots"/>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delsubject&amp;activenode=<xsl:value-of select="NODEID"/></xsl:attribute>
<xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute>Delete Subject</A>
</xsl:if>

</DIV>
</LI>
</xsl:template>
-->

  <!--

	<xsl:template match="ARTICLEMEMBER">

	Generic:	Yes
	Purpose:	Displays an article in a category when browsing the guide




<xsl:template match="MEMBERS/ARTICLEMEMBER">
<xsl:param name="iscategory">1</xsl:param>
<xsl:param name="activenode"/>
<LI>
<DIV class="categoryarticle">
<xsl:choose>
<xsl:when test="string-length(SECTION) &gt; 0">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>?section=<xsl:value-of select="SECTION"/></xsl:attribute><FONT xsl:use-attribute-sets="catfontarticle"><xsl:value-of select="NAME"/> (<xsl:value-of select="SECTIONDESCRIPTION"/>)</FONT></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><FONT xsl:use-attribute-sets="catfontarticle"><xsl:value-of select="NAME"/></FONT></A>
</xsl:otherwise>
</xsl:choose>

<xsl:if test="$iscategory=0">
<br/>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatearticle&amp;activenode=<xsl:value-of select="H2G2ID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/></xsl:attribute>Move Article</A>........
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delarticle&amp;activenode=<xsl:value-of select="H2G2ID"/></xsl:attribute>
<xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute>Delete Article</A>
</xsl:if>

</DIV>
</LI></xsl:template>
-->

  <!--
		<xsl:template match="NODEALIASMEMBER">

	Generic:	Yes
	Purpose:	Displays an symbolica link to a subject when borwsing the guide



<xsl:template match="MEMBERS/NODEALIASMEMBER">
<xsl:param name="iscategory">1</xsl:param>
<xsl:param name="activenode"/>
<xsl:param name="action">&amp;action=navigatesubject</xsl:param>

<xsl:variable name="linkto">
<xsl:choose>
<xsl:when test="$iscategory=1">C<xsl:value-of select="LINKNODEID"/></xsl:when>
<xsl:otherwise>
editcategory?nodeid=<xsl:value-of select="LINKNODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<LI>
<DIV class="subjectalias">
<xsl:choose>
<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><FONT xsl:use-attribute-sets="catfontemptysubject"><I><xsl:value-of select="NAME"/></I></FONT></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [<xsl:value-of select="$m_nomembers"/>]</NOBR></FONT>
</xsl:when>
<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><B><FONT xsl:use-attribute-sets="catfontfullsubject"><I><xsl:value-of select="NAME"/></I></FONT></B></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [1<xsl:value-of select="$m_member"/>]</NOBR></FONT>
</xsl:when>
<xsl:otherwise>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><B><FONT xsl:use-attribute-sets="catfontfullsubject"><I><xsl:value-of select="NAME"/></I></FONT></B></A> <FONT xsl:use-attribute-sets="catfontmember"><NOBR> [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/><xsl:value-of select="$m_members"/>]</NOBR></FONT>
</xsl:otherwise>
</xsl:choose>

<xsl:if test="$iscategory=0">
<br/>
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatealias&amp;activenode=<xsl:value-of select="LINKNODEID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/></xsl:attribute>Move Subject Link</A>........
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delalias&amp;activenode=<xsl:value-of select="LINKNODEID"/></xsl:attribute>
<xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete');</xsl:attribute>Delete Subject Link</A>
</xsl:if>

</DIV>
</LI>
</xsl:template>

-->


  <!--
	Template to match and display a list of users
	Mainly used by the NewUsers page, but could also be used elsewhere
-->

  <xsl:template match="USER-LIST">
    <xsl:choose>
      <xsl:when test="@TYPE='NEW-USERS'">
        <table border="0" cellspacing="2" cellpadding="0">
          <xsl:for-each select="USER">
            <tr>
              <td align="right">
                <xsl:if test="number(MASTHEAD) != 0">
                  <xsl:value-of select="$m_userhasmastheadflag"/>
                </xsl:if>
                <xsl:if test="number(FORUM-POSTED-TO) != 0">
                  <xsl:value-of select="$m_usersintropostedtoflag"/>
                </xsl:if>
              </td>
              <td>
                <a>
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="USERNAME"/>
                </a>
              </td>
              <td>&nbsp;</td>
              <td>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="DATE-JOINED/DATE"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:when>
      <xsl:when test="@TYPE='SUB-EDITORS'">
        <table border="0" cellspacing="2" cellpadding="0">
          <xsl:for-each select="USER">
            <tr>
              <td>
                <a>
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="USERNAME"/>
                </a>
              </td>
              <td>&nbsp;</td>
              <td>
                <xsl:value-of select="ALLOCATIONS"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <!-- default is simply to apply templates to each item in list
				 and put a linebreak afterwards -->
        <xsl:for-each select="USER">
          <xsl:apply-templates select="."/>
          <br/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="NEWUSERS-LISTING">
    <!-- flag for if we are only showing researchers who have written their intros -->
    <xsl:variable name="filter">
      <xsl:choose>
        <xsl:when test="@FILTER-USERS=1">
          <xsl:choose>
            <xsl:when test="@FILTER-TYPE='haveintroduction'">Filter=haveintroduction</xsl:when>
            <xsl:otherwise>Filter=noposting</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>Filter=off</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- if at least one new user returned then display the list -->
      <xsl:when test="USER-LIST/USER">
        <xsl:call-template name="m_NewUsersListingHeading"/>
        <xsl:apply-templates select="USER-LIST"/>
        <br/>
        <xsl:variable name="thissiteflag">
          <xsl:if test="@SITEID">&amp;thissite=1</xsl:if>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="USER-LIST/@SKIP &gt; 0 or USER-LIST/@SKIPTO &gt; 0">
            <a href="{$root}NewUsers?unittype={@UNITTYPE}&amp;timeunits={@TIMEUNITS}&amp;skip={number((USER-LIST/@SKIP|USER-LIST/@SKIPTO)[1]) - number(USER-LIST/@SHOW)}{$thissiteflag}&amp;{$filter}">
              <xsl:value-of select="$m_OlderRegistrations"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_NoOlderRegistrations"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$m_RegistrationsSeparater"/>
        <xsl:choose>
          <xsl:when test="USER-LIST/@MORE=1">
            <a href="{$root}NewUsers?unittype={@UNITTYPE}&amp;timeunits={@TIMEUNITS}&amp;skip={number((USER-LIST/@SKIP|USER-LIST/@SKIPTO)[1]) + number(USER-LIST/@SHOW)}{$thissiteflag}&amp;{$filter}">
              <xsl:value-of select="$m_NewerRegistrations"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_NoNewerRegistrations"/>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
        <br/>
        <table border="0" cellspacing="2" cellpadding="0">
          <tr>
            <td align="right">
              <xsl:value-of select="$m_userhasmastheadflag"/>
            </td>
            <td align="left">
              <xsl:value-of select="$m_userhasmastheadfootnote"/>
            </td>
          </tr>
          <tr>
            <td align="right">
              <xsl:value-of select="$m_userhasmastheadflag"/>
              <xsl:value-of select="$m_usersintropostedtoflag"/>
            </td>
            <td align="left">
              <xsl:value-of select="$m_usersintropostedtofootnote"/>
            </td>
          </tr>
        </table>
      </xsl:when>
      <!-- otherwise display a message saying no users have registered in that
time -->
      <xsl:otherwise>
        <xsl:call-template name="m_NewUsersListingEmpty"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="NEWUSERS-LISTINGggg">
    <!-- flag for if we are only showing researchers who have written their intros -->
    <xsl:variable name="OnlyIntrosFlag">
      <xsl:choose>
        <xsl:when test="@ONLY-INTROS=1">on</xsl:when>
        <xsl:otherwise>off</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- if at least one new user returned then display the list -->
      <xsl:when test="USER-LIST/USER">
        <xsl:call-template name="m_NewUsersListingHeading"/>
        <xsl:apply-templates select="USER-LIST"/>
        <br/>
        <xsl:choose>
          <xsl:when test="USER-LIST/@SKIP &gt; 0 or USER-LIST/@SKIPTO &gt; 0">
            <a>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>NewUsers?unittype=<xsl:value-of select="@UNITTYPE"/>&amp;timeunits=<xsl:value-of select="@TIMEUNITS"/>&amp;skip=<xsl:value-of select="number((USER-LIST/@SKIP|USER-LIST/@SKIPTO)[1]) - number(USER-LIST/@SHOW)"/>&amp;OnlyIntros=<xsl:value-of select="$OnlyIntrosFlag"/>
              </xsl:attribute>
              <xsl:value-of select="$m_NewerRegistrations"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_NoNewerRegistrations"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$m_RegistrationsSeparater"/>
        <xsl:choose>
          <xsl:when test="USER-LIST/@MORE=1">
            <a>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>NewUsers?unittype=<xsl:value-of select="@UNITTYPE"/>&amp;timeunits=<xsl:value-of select="@TIMEUNITS"/>&amp;skip=<xsl:value-of select="number((USER-LIST/@SKIP|USER-LIST/@SKIPTO)[1]) + number(USER-LIST/@SHOW)"/>&amp;OnlyIntros=<xsl:value-of select="$OnlyIntrosFlag"/>
              </xsl:attribute>
              <xsl:value-of select="$m_OlderRegistrations"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_NoOlderRegistrations"/>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
        <br/>
        <table border="0" cellspacing="2" cellpadding="0">
          <tr>
            <td align="right">
              <xsl:value-of select="$m_userhasmastheadflag"/>
            </td>
            <td align="left">
              <xsl:value-of select="$m_userhasmastheadfootnote"/>
            </td>
          </tr>
          <tr>
            <td align="right">
              <xsl:value-of select="$m_userhasmastheadflag"/>
              <xsl:value-of select="$m_usersintropostedtoflag"/>
            </td>
            <td align="left">
              <xsl:value-of select="$m_usersintropostedtofootnote"/>
            </td>
          </tr>
        </table>
      </xsl:when>
      <!-- otherwise display a message saying no users have registered in that time -->
      <xsl:otherwise>
        <xsl:call-template name="m_NewUsersListingEmpty"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	Template to match the entry recommendation form
	Used by the scout's entry recommendation page
-->

  <xsl:template match="RECOMMEND-ENTRY-FORM">
    <xsl:choose>
      <xsl:when test="ERROR">
        <xsl:choose>
          <xsl:when test="ERROR/@TYPE='OWN-ENTRY'">
            <xsl:value-of select="$m_RecommendEntryOwnEntryError"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='INVALID-H2G2ID'">
            <xsl:value-of select="$m_RecommendEntryInvalidIDError"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='WRONG-STATUS'">
            <xsl:value-of select="$m_RecommendEntryWrongStatusError"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='INVALID-RECOMMENDATION'">
            <xsl:value-of select="$m_RecommendEntryInvalidIDError"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='ALREADY-RECOMMENDED'">
            <xsl:apply-templates select="ERROR"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='NOT-IN-REVIEW'">
            <xsl:value-of select="$m_RecommendEntryNotInReviewForum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_RecommendEntryUnspecifiedError"/>
            <br/>
            <br/>
            <xsl:apply-templates select="ERROR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="SUBMITTED">
          <xsl:call-template name="m_RecommendEntrySubmitSuccessMessage"/>
        </xsl:if>
        <form name="RecommendEntryForm" method="post" action="{$root}RecommendEntry">
          <xsl:call-template name="skinfield"/>
          <input type="hidden" name="mode">
            <xsl:attribute name="value">
              <xsl:value-of select="/H2G2/@MODE"/>
            </xsl:attribute>
          </input>
          <xsl:if test="number(H2G2ID) != 0">
            <a target="_blank">
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
              </xsl:attribute>A<xsl:value-of select="H2G2ID"/>
            </a>
            <xsl:text> : </xsl:text>
            <b>
              <xsl:value-of select="SUBJECT"/>
            </b>
            <xsl:text> by </xsl:text>
            <xsl:apply-templates select="EDITOR/USER"/>
            <br/>
            <br/>
          </xsl:if>
          <xsl:if test="FUNCTIONS/RECOMMEND-ENTRY">
            Comments:<br/>
            <textarea name="Comments" wrap="virtual" cols="40" rows="10">
              <xsl:value-of select="COMMENTS"/>
            </textarea>
            <br/>
            <input type="submit" name="Submit" value="Recommend"/>
            <br/><br/><br/>
          </xsl:if>
          <input type="hidden" name="h2g2ID">
            <xsl:attribute name="value">
              <xsl:choose>
                <xsl:when test="number(H2G2ID) = 0"/>
                <xsl:otherwise>
                  <xsl:value-of select="H2G2ID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </input>
          <xsl:if test="FUNCTIONS/FETCH-ENTRY">
            <!--					<font xsl:use-attribute-sets="mainfont">
						<xsl:value-of select="$m_RecommendEntryFetchEntryText"/><br/>
						<xsl:value-of select="$m_RecommendEntryEntryIDBoxText"/>
						<input type="text" name="h2g2ID">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="number(H2G2ID) = 0"></xsl:when>
									<xsl:otherwise><xsl:value-of select="H2G2ID"/></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input><xsl:text> </xsl:text>
						<input type="submit" name="Fetch" value="Fetch Entry"/>
					</font>
-->
          </xsl:if>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="EDITREVIEWFORM">
    <xsl:choose>
      <xsl:when test="ERROR/@TYPE='NOEDIT'">
        <xsl:value-of select="ERROR"/>
      </xsl:when>
      <xsl:when test="ERROR/@TYPE='BADPARAM'">
        <xsl:value-of select="ERROR"/>
      </xsl:when>
      <xsl:when test="ERROR/@TYPE='UPDATE'">
        <xsl:value-of select="ERROR"/>
      </xsl:when>
      <xsl:when test="ERROR/@TYPE='VIEW'">
        <xsl:value-of select="ERROR"/>
      </xsl:when>
      <xsl:when test="ERROR">
        <xsl:value-of select="ERROR"/>
      </xsl:when>
      <xsl:when test="SUCCESS/@TYPE='UPDATE'">
        Updated Successfully! <br/>
        (Changes may not appear instantly!)<p/>
      </xsl:when>
      <xsl:when test="SUCCESS/@TYPE='ADDNEW'">
        Added Successfully! <br/>
        Go back to the review using the link below or update details here <p/>
      </xsl:when>
    </xsl:choose>

    <br/>
    <table cellpadding="10">
      <tr>
        <td>
          <form name="EditReviewForm" method="post" action="{$root}EditReview">

            <input type="hidden" name="mode">
              <xsl:attribute name="value">
                <xsl:value-of select="/H2G2/@MODE"/>
              </xsl:attribute>
            </input>
            <input type="hidden" name="id" value="{REVIEWFORUM/@ID}"/>
            <table>
              <tr>
                <td>Forum Name:</td>
                <td>
                  <input type="text" name="name" value="{REVIEWFORUM/FORUMNAME}"/>
                </td>
              </tr>
              <tr>
                <td>URL Name:</td>
                <td>
                  <input type="text" name="url" value="{REVIEWFORUM/URLFRIENDLYNAME}"/>
                </td>
              </tr>
              <tr>
                <td>Recommendable: </td>
                <td>
                  <input type="radio" name="recommend" value="1">
                    <xsl:if test="REVIEWFORUM/RECOMMENDABLE=1">
                      <xsl:attribute name="checked"/>
                    </xsl:if>
                  </input> Yes
                  <input type="radio" name="recommend" value="0">
                    <xsl:if test="not(REVIEWFORUM/RECOMMENDABLE=1)">
                      <xsl:attribute name="checked"/>
                    </xsl:if>
                  </input> No
                </td>
              </tr>
              <tr>
                <td>Incubate Time: </td>
                <td>
                  <input type="text" name="incubate" size="3" value="{REVIEWFORUM/INCUBATETIME}"/>
                </td>
              </tr>
              <tr>
                <td>Article ID:</td>
                <td>
                  <input type="text" name="h2g2id" value="{REVIEWFORUM/H2G2ID}"/>
                </td>
              </tr>
            </table>
            <xsl:choose>
              <xsl:when test="BLANKFORM">
                <input type="hidden" name="action" value="doaddnew"/>
                <input type="submit" value="Add"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" name="action" value="update"/>
                <input type="submit" value="Update"/>
              </xsl:otherwise>
            </xsl:choose>

          </form>
          <br/>
          <xsl:if test="REVIEWFORUM and REVIEWFORUM/@ID &gt; 0">
            <A>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>RF<xsl:value-of select="REVIEWFORUM/@ID"/>
              </xsl:attribute>Go Back to the Review Forum '<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>'
            </A>
          </xsl:if>

        </td>
      </tr>
    </table>
  </xsl:template>
  <!--
	Template to match the subbed entry submission form
	Used by the sub's entry submission page
-->

  <xsl:template match="SUBBED-ENTRY-FORM">
    <xsl:choose>
      <xsl:when test="ERROR">
        <xsl:choose>
          <xsl:when test="ERROR/@TYPE='INVALID-H2G2ID'">
            <xsl:value-of select="$m_SubbedEntryInvalidIDError"/>
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='WRONG-STATUS'">
            <xsl:value-of select="$m_SubbedEntryWrongStatusError"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_SubbedEntryUnspecifiedError"/>
            <br/>
            <br/>
            <xsl:apply-templates select="ERROR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="SUBMITTED">
          <xsl:value-of select="$m_SubbedEntrySubmitSuccessMessage"/>
        </xsl:if>
        <form name="SubbedEntryForm" method="POST" action="{$root}SubmitSubbedEntry">
          <input type="hidden" name="mode">
            <xsl:attribute name="value">
              <xsl:value-of select="/H2G2/@MODE"/>
            </xsl:attribute>
          </input>
          <xsl:if test="number(H2G2ID) != 0">
            <a target="_blank">
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
              </xsl:attribute>A<xsl:value-of select="H2G2ID"/>
            </a>
            <xsl:text> : </xsl:text>
            <b>
              <xsl:value-of select="SUBJECT"/>
            </b>
            <xsl:text> by </xsl:text>
            <xsl:apply-templates select="EDITOR/USER"/>
            <br/>
            <br/>
          </xsl:if>
          <xsl:if test="FUNCTIONS/SUBMIT-ENTRY">
            Comments:<br/>
            <textarea name="Comments" wrap="virtual" cols="40" rows="10">
              <xsl:value-of select="COMMENTS"/>
            </textarea>
            <br/>
            <input type="submit" name="Submit" value="Submit"/> <xsl:call-template name="skinfield"/>
            <br/><br/><br/>
          </xsl:if>
          <input type="hidden" name="h2g2ID">
            <xsl:attribute name="value">
              <xsl:choose>
                <xsl:when test="number(H2G2ID) = 0"/>
                <xsl:otherwise>
                  <xsl:value-of select="H2G2ID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </input>
          <xsl:if test="FUNCTIONS/FETCH-ENTRY">
            <!--					<font xsl:use-attribute-sets="mainfont">
						<xsl:value-of select="$m_SubbedEntryFetchEntryText"/><br/>
						<xsl:value-of select="$m_SubbedEntryEntryIDBoxText"/>
						<input type="text" name="h2g2ID">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="number(H2G2ID) = 0"></xsl:when>
									<xsl:otherwise><xsl:value-of select="H2G2ID"/></xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input><xsl:text> </xsl:text>
						<input type="submit" name="Fetch" value="Fetch Entry"/>
					</font>
-->
          </xsl:if>
        </form>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='MORETHREADSFRAME']">
    <HTML>
      <TITLE>h2g2</TITLE>
      <body xsl:use-attribute-sets="body">
        <div align="center">
          <b>
            <xsl:value-of select="$m_otherconv"/>
          </b>
        </div>
        <xsl:apply-templates select="FORUMTHREADS"/>
        <xsl:choose>
          <xsl:when test="FORUMTHREADS/@JOURNALOWNER">
            <xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
              <CENTER>
                <A>
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                  </xsl:attribute>
                  <xsl:attribute name="TARGET">_top</xsl:attribute>
                  <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
                </A>
              </CENTER>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <CENTER>
              <A>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                </xsl:attribute>
                <xsl:attribute name="TARGET">_top</xsl:attribute>
                <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
              </A>
            </CENTER>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </HTML>
  </xsl:template>

  <!--
	template: <H2G2 TYPE="CONTENTFRAME">
	General purpose blue background frame which can contain either
	<FORUMTHREADS> and FORUMTHREADHEADERS, <FORUMSOURCE> which displays
	the title, or <FORUMTHREADPOSTS> which display the actual posts.
	This should be made into several templates for clarity.
-->

  <xsl:template match="H2G2[@TYPE='CONTENTFRAME']">
    <HTML>
      <TITLE>h2g2</TITLE>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <xsl:choose>
          <xsl:when test="FORUMTHREADS">
            <xsl:apply-templates mode="many" select="FORUMTHREADHEADERS"/>

            <xsl:if test="FORUMTHREADHEADERS[@SKIPTO &gt; 0]">
              <A>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/>
                </xsl:attribute>
                <xsl:attribute name="TARGET">twosides</xsl:attribute>
                Click to see older posts
              </A>
              <br/>
            </xsl:if>

            <xsl:if test="FORUMTHREADHEADERS/@MORE">
              <A>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/>
                </xsl:attribute>
                <xsl:attribute name="TARGET">twosides</xsl:attribute>
                Click to see newer posts
              </A>
              <br/>
            </xsl:if>

            <hr/>
            Conversations in this forum:<br/>
            <xsl:apply-templates select="FORUMTHREADS"/>
            <br/>
            <CENTER>
              <A>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                </xsl:attribute>
                <xsl:attribute name="TARGET">_top</xsl:attribute>
                <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
              </A>
            </CENTER>
          </xsl:when>
          <xsl:when test="FORUMSOURCE">
            <xsl:apply-templates/>
          </xsl:when>
        </xsl:choose>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='FRAMESOURCE']">
    <HTML>
      <TITLE>h2g2</TITLE>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <xsl:apply-templates select="FORUMSOURCE"/>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='FRAMETHREADS']">
    <HTML>
      <HEAD>
        <TITLE>h2g2</TITLE>
        <STYLE type="text/css">
          <xsl:comment>
            DIV.browse A {  text-decoration: none;}
            DIV.browse A:hover   { text-decoration: underline ! important; color: <xsl:value-of select="$mainfontcolour"/>}
          </xsl:comment>
        </STYLE>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
      </HEAD>
      <body bgcolor="{$bgcolour}" text="{$mainfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <xsl:apply-templates select="SUBSCRIBE-RESULT"/>
        <xsl:choose>
          <xsl:when test="FORUMTHREADS">

            <TABLE WIDTH="100%" valign="CENTER">
              <TR>
                <TD align="CENTER" valign="baseline">

                  <div align="center">
                    <b>
                      <xsl:value-of select="$m_currentconv"/>
                    </b>
                  </div>
                  <xsl:call-template name="messagenavbuttons"/>
                  <!--xsl:with-param name="skipto"><xsl:value-of select="FORUMTHREADHEADERS/@SKIPTO"/></xsl:with-param>
<xsl:with-param name="count"><xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/></xsl:with-param>
<xsl:with-param name="forumid"><xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/></xsl:with-param>
<xsl:with-param name="threadid"><xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/></xsl:with-param>
<xsl:with-param name="more"><xsl:value-of select="FORUMTHREADHEADERS/@MORE"/></xsl:with-param>
</xsl:call-template-->
                </TD>
              </TR>
            </TABLE>
            <CENTER>
              <xsl:call-template name="forumpostblocks">
                <xsl:with-param name="thread" select="FORUMTHREADHEADERS/@THREADID"/>
                <xsl:with-param name="forum" select="FORUMTHREADHEADERS/@FORUMID"/>
                <xsl:with-param name="skip" select="0"/>
                <xsl:with-param name="show" select="FORUMTHREADHEADERS/@COUNT"/>
                <xsl:with-param name="total" select="FORUMTHREADHEADERS/@TOTALPOSTCOUNT"/>
                <xsl:with-param name="this" select="FORUMTHREADHEADERS/@SKIPTO"/>
                <xsl:with-param name="blocklimit" select="20"/>
              </xsl:call-template>
            </CENTER>
            <DIV class="browse">
              <table cellspacing="0" cellpadding="0" border="0">
                <xsl:apply-templates mode="many" select="FORUMTHREADHEADERS"/>
              </table>
            </DIV>
            <!--
<xsl:if test="FORUMTHREADHEADERS[@SKIPTO > 0]">
<A>
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">twosides</xsl:attribute>
Click to see older posts
</A><br />
</xsl:if>

<xsl:if test="FORUMTHREADHEADERS/@MORE">
<A>
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">twosides</xsl:attribute>
Click to see newer posts
</A><br />
</xsl:if>
-->
            <xsl:choose>
              <xsl:when test="FORUMTHREADS/@JOURNALOWNER">
                <xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
                  <CENTER>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                      </xsl:attribute>
                      <xsl:attribute name="TARGET">_top</xsl:attribute>
                      <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
                    </A>
                  </CENTER>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <CENTER>
                  <A>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                    </xsl:attribute>
                    <xsl:attribute name="TARGET">_top</xsl:attribute>
                    <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
                  </A>
                </CENTER>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <xsl:call-template name="subscribethread"/>
            <hr/>
            <div align="center">
              <b>
                <xsl:value-of select="$m_otherconv"/>
              </b>
            </div>
            <xsl:apply-templates select="FORUMTHREADS"/>
            <br/>
            <xsl:choose>
              <xsl:when test="FORUMTHREADS/@JOURNALOWNER">
                <xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
                  <CENTER>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                      </xsl:attribute>
                      <xsl:attribute name="TARGET">_top</xsl:attribute>
                      <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
                    </A>
                  </CENTER>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <CENTER>
                  <A>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/>
                    </xsl:attribute>
                    <xsl:attribute name="TARGET">_top</xsl:attribute>
                    <img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}"/>
                  </A>
                </CENTER>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
        <CENTER>
          <xsl:call-template name="subscribeforum"/>
        </CENTER>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template name="messagenavbuttons">
    <!--xsl:param name="skipto">0</xsl:param>
<xsl:param name="count">0</xsl:param>
<xsl:param name="forumid">0</xsl:param>
<xsl:param name="threadid">0</xsl:param>
<xsl:param name="more">0</xsl:param>
						<font size="1">
						<xsl:choose>
						<xsl:when test="$skipto &gt; 0">
							<A>
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="$forumid" />?thread=<xsl:value-of select="$threadid" />&amp;skip=<xsl:value-of select='number($skipto) - number($count)' />&amp;show=<xsl:value-of select="$count" /></xsl:attribute>
								posts <xsl:value-of select="number($skipto) - number($count) + 1"/>-<xsl:value-of select="number($skipto)"/>
							</A>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="forum_button_reverse"/>
						</xsl:otherwise>
						</xsl:choose>
							<xsl:text> | </xsl:text>
						<xsl:choose>
						<xsl:when test="$more &gt; 0">
							<A>
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="$forumid" />?thread=<xsl:value-of select="$threadid" />&amp;skip=<xsl:value-of select='number($skipto) + number($count)' />&amp;show=<xsl:value-of select="$count" /></xsl:attribute>
								posts <xsl:value-of select="number($skipto) + number($count) + 1"/>-<xsl:value-of select="number($skipto) + number($count) + number($count)"/>
								</A>
						</xsl:when>
						<xsl:otherwise>
						<xsl:call-template name="forum_button_play"/>
						</xsl:choose>
						</font>
							<br/-->
    <xsl:variable name="prevrange">
      <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="showprevrange">
        <xsl:with-param name="showtext"/>
        <!-- overrides - 'show postings ' which is not required in base -->
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="nextrange">
      <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="shownextrange">
        <xsl:with-param name="showtext"/>
      </xsl:apply-templates>
    </xsl:variable>
    <span xsl:use-attribute-sets="navbuttons">
      <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="navbuttons">
        <xsl:with-param name="URL" select="'F'"/>
        <xsl:with-param name="skiptoprevious" select="concat('posts ', $prevrange)"/>
        <xsl:with-param name="skiptopreviousfaded" select="concat('&lt;', $m_showolder)"/>
        <xsl:with-param name="skiptonext" select="concat('posts ', $nextrange)"/>
        <xsl:with-param name="skiptonextfaded" select="concat($m_shownewer, '&gt;')"/>
        <xsl:with-param name="navbuttonsspacer">
          <xsl:text> | </xsl:text>
        </xsl:with-param>
        <xsl:with-param name="showendpoints" select="false()"/>
        <xsl:with-param name="attributes">
          <attribute name="target" value="_top"/>
        </xsl:with-param>
      </xsl:apply-templates>
    </span>
    <br/>
  </xsl:template>


  <xsl:template name="subscribethread">
    <xsl:if test="$registered=1">
      <xsl:choose>
        <xsl:when test="SUBSCRIBE-STATE[@THREAD='1']">
          <a target="_top" href="{$root}FSB{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={FORUMTHREADHEADERS/@SKIPTO}&amp;show={FORUMTHREADHEADERS/@COUNT}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADHEADERS/@FORUMID}%3Fthread={FORUMTHREADHEADERS/@THREADID}%26amp;skip={FORUMTHREADHEADERS/@SKIPTO}%26amp;show={FORUMTHREADHEADERS/@COUNT}">
            <xsl:value-of select="$m_clickunsubscribe"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a target="_top" href="{$root}FSB{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={FORUMTHREADHEADERS/@SKIPTO}&amp;show={FORUMTHREADHEADERS/@COUNT}&amp;cmd=subscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADHEADERS/@FORUMID}%3Fthread={FORUMTHREADHEADERS/@THREADID}%26amp;skip={FORUMTHREADHEADERS/@SKIPTO}%26amp;show={FORUMTHREADHEADERS/@COUNT}">
            <xsl:value-of select="$m_clicksubscribe"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="subscribethreadposts">
    <xsl:if test="$registered=1">
      <xsl:choose>
        <xsl:when test="SUBSCRIBE-STATE[@THREAD='1']">
          <a target="_top" href="{$root}FSB{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={FORUMTHREADPOSTS/@SKIPTO}&amp;show={FORUMTHREADPOSTS/@COUNT}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADPOSTS/@FORUMID}%3Fthread={FORUMTHREADPOSTS/@THREADID}%26amp;skip={FORUMTHREADPOSTS/@SKIPTO}%26amp;show={FORUMTHREADPOSTS/@COUNT}">
            <xsl:value-of select="$m_clickunsubscribe"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a target="_top" href="{$root}FSB{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={FORUMTHREADPOSTS/@SKIPTO}&amp;show={FORUMTHREADPOSTS/@COUNT}&amp;cmd=subscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADPOSTS/@FORUMID}%3Fthread={FORUMTHREADPOSTS/@THREADID}%26amp;skip={FORUMTHREADPOSTS/@SKIPTO}%26amp;show={FORUMTHREADPOSTS/@COUNT}">
            <xsl:value-of select="$m_clicksubscribe"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template name="subscribeforum">

	Generic:	Yes
	Purpose:	Displays a link for subscribing to a forum

-->

  <xsl:template name="subscribeforum">
    <xsl:if test="$registered=1">
      <br/>
      <xsl:choose>
        <xsl:when test="SUBSCRIBE-STATE[@FORUM='1']">
          <a target="_top" href="{$root}FSB{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={FORUMTHREADHEADERS/@SKIPTO}&amp;show={FORUMTHREADHEADERS/@COUNT}&amp;cmd=unsubscribeforum&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADHEADERS/@FORUMID}%3Fthread={FORUMTHREADHEADERS/@THREADID}%26amp;skip={FORUMTHREADHEADERS/@SKIPTO}%26amp;show={FORUMTHREADHEADERS/@COUNT}">
            <xsl:value-of select="$m_clickunsubforum"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a target="_top" href="{$root}FSB{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={FORUMTHREADHEADERS/@SKIPTO}&amp;show={FORUMTHREADHEADERS/@COUNT}&amp;cmd=subscribeforum&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADHEADERS/@FORUMID}%3Fthread={FORUMTHREADHEADERS/@THREADID}%26amp;skip={FORUMTHREADHEADERS/@SKIPTO}%26amp;show={FORUMTHREADHEADERS/@COUNT}">
            <xsl:value-of select="$m_clicksubforum"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="subscribearticleforum">
    <xsl:param name="ForumID" select="@FORUMID"/>
    <xsl:param name="URL">A</xsl:param>
    <xsl:param name="ID" select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
    <xsl:param name="Desc" select="$alt_subreturntoarticle"/>
    <xsl:param name="Notify" select="$m_clicknotifynewconv"/>
    <xsl:param name="DeNotify">
      <xsl:value-of select="$m_clickstopnotifynewconv"/>
    </xsl:param>
    <xsl:if test="$registered=1">
      <a target="_top">
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>FSB<xsl:value-of select="$ForumID"/>?cmd=subscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$Desc"/>&amp;return=<xsl:value-of select="$URL"/><xsl:value-of select="$ID"/>
        </xsl:attribute>
        <xsl:value-of select="$Notify"/>
      </a>
      <br/>
      <a target="_top">
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>FSB<xsl:value-of select="$ForumID"/>?cmd=unsubscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$Desc"/>&amp;return=<xsl:value-of select="$URL"/><xsl:value-of select="$ID"/>
        </xsl:attribute>
        <xsl:value-of select="$DeNotify"/>
      </a>
      <br/>
    </xsl:if>
  </xsl:template>

  <!--
<xsl:template name="subscribearticleforum">
<xsl:if test="$registered=1">
<a target="_top" href="{$root}FSB{@FORUMID}?cmd=subscribeforum&amp;page=normal&amp;desc={$alt_subreturntoarticle}&amp;return=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="$m_clicknotifynewconv"/></a><br/>
</xsl:if>
</xsl:template>
-->



  <!--
	Template to overide modularised version of RECOMMEND-ENTRY page so that
	the popup window verson can display a simple page without all the
	navigation and banner ads stuff.
-->

  <xsl:template match="H2G2[@TYPE='RECOMMEND-ENTRY' and @MODE='POPUP']">
    <xsl:call-template name="RECOMMEND-ENTRY-POPUP"/>
  </xsl:template>

  <!--<xsl:template match='H2G2[@TYPE="SUBMIT-SUBBED-ENTRY" and @MODE="POPUP"]'>-->
  <xsl:template match="H2G2[@TYPE='SUBMIT-SUBBED-ENTRY']">
    <!--	<xsl:call-template name="SUBMIT-SUBBED-ENTRY-POPUP"/>-->
    <xsl:call-template name="SUBMIT-SUBBED-ENTRY"/>
  </xsl:template>

  <!--
	Template to do the actual popup recommend entry page
	- this can be called from derived stylesheets to avoid duplicate code
-->

  <xsl:template name="RECOMMEND-ENTRY-POPUP">
    <html>
      <head>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>
          <xsl:value-of select="$m_RecommendEntryPageTitle"/>
        </title>
      </head>
      <body xsl:use-attribute-sets="body">
        <xsl:apply-templates select="/H2G2/RECOMMEND-ENTRY-FORM"/>
      </body>
    </html>
  </xsl:template>

  <!--
	Template to do the actual popup submit subbed entry page
	- this can be called from derived stylesheets to avoid duplicate code
-->

  <!--<xsl:template name="SUBMIT-SUBBED-ENTRY-POPUP">-->
  <xsl:template name="SUBMIT-SUBBED-ENTRY">
    <html>
      <head>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>
          <xsl:value-of select="$m_SubbedEntryPageTitle"/>
        </title>
      </head>
      <body xsl:use-attribute-sets="body">
        <xsl:apply-templates select="/H2G2/SUBBED-ENTRY-FORM"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='ONLINE']">
    <xsl:apply-templates select="ONLINEUSERS"/>
  </xsl:template>

  <xsl:template match="ONLINEUSERS">
    <HTML>
      <HEAD>
        <TITLE>
          <xsl:value-of select="$m_onlinetitle"/>
        </TITLE>
        <META http-equiv="REFRESH" content="120;url=online?orderby={@ORDER-BY}"/>
        <xsl:call-template name="insert-headelements"/>
      </HEAD>
      <body>
        <table border="0" cellspacing="0" cellpadding="0">
          <form name="WhosOnlineForm" method="get" action="{$root}Online" title="{$alt_onlineform}">
            <tr>
              <td>
                <span xsl:use-attribute-sets="onlinefont">
                  <xsl:value-of select="$m_onlineorderby"/>
                </span>
              </td>
              <td>
                <input type="radio" name="orderby" value="id" onclick="document.WhosOnlineForm.submit()" title="{$alt_onlineorderbyid}">
                  <xsl:if test="@ORDER-BY='id'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
              </td>
              <td>
                <span xsl:use-attribute-sets="onlinefont">
                  <xsl:value-of select="$m_onlineidradiolabel"/>
                </span>
              </td>
              <td>
                <input type="radio" name="orderby" value="name" onclick="document.WhosOnlineForm.submit()" title="{$alt_onlineorderbyname}">
                  <xsl:if test="@ORDER-BY='name'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
              </td>
              <td>
                <span xsl:use-attribute-sets="onlinefont">
                  <xsl:value-of select="$m_onlinenameradiolabel"/>
                </span>
              </td>
            </tr>
          </form>
        </table>
        <span xsl:use-attribute-sets="onlinefont">
          <xsl:choose>
            <xsl:when test="count(ONLINEUSER)=1">
              <xsl:value-of select="count(ONLINEUSER)"/>
              <xsl:value-of select="$m_useronline"/>
              <br/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="count(ONLINEUSER)"/>
              <xsl:value-of select="$m_usersonline"/>
              <br/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="@ORDER-BY='id'">
              <xsl:apply-templates select="ONLINEUSER">
                <xsl:sort select="USER/USERID" data-type="number" order="ascending"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="@ORDER-BY='name'">
              <xsl:apply-templates select="ONLINEUSER">
                <xsl:sort select="USER/USERNAME" data-type="text" order="ascending"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="ONLINEUSER"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </body>
    </HTML>
  </xsl:template>

  <!--

	<xsl:template match="ONLINEUSER">

	Generic:	Yes
	Purpose:	Displays a user's details in the who's online page

-->

  <xsl:template match="ONLINEUSER">
    <A TARGET="_blank">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/>
      </xsl:attribute>
      <xsl:apply-templates select="USER/USERNAME"/>
    </A>
    <xsl:if test="number(DAYSSINCEJOINED) &lt; 7">
      (<xsl:value-of select="$m_newthisweek"/>)
    </xsl:if>
    <br/>
  </xsl:template>




  <!--

	<xsl:template match="INFO">

	Generic:	Yes
	Purpose:	Displays the info page details

-->

  <xsl:template match="INFO">
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_totalregusers"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <xsl:value-of select="TOTALREGUSERS"/>
      <xsl:value-of select="$m_usershaveregistered"/>
      <br/>
      <br/>
    </blockquote>
    <!-- queue length now redundant
<xsl:call-template name="HEADER">
<xsl:with-param name="text"><xsl:value-of select="$m_queuelength"/></xsl:with-param>
</xsl:call-template>
<blockquote>
<xsl:value-of select="$m_therearecurrently"/><xsl:value-of select="SUBMITTEDQUEUE"/><xsl:value-of select="$m_recinqueue"/><br />
<br/>
</blockquote>
-->
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_editedentries"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <xsl:value-of select="$m_therearecurrently"/>
      <xsl:value-of select="APPROVEDENTRIES"/>
      <xsl:value-of select="$m_editedinguide"/>
      <br/>
      <br/>
    </blockquote>

    <!--
<xsl:call-template name="HEADER">
<xsl:with-param name="text"><xsl:value-of select="$m_toptenprolific"/></xsl:with-param>
</xsl:call-template>
<blockquote>
<xsl:apply-templates select="PROLIFICPOSTERS"/>
<br/>
</blockquote>

<xsl:call-template name="HEADER">
<xsl:with-param name="text"><xsl:value-of select="$m_toptenerudite"/></xsl:with-param>
</xsl:call-template>
<blockquote>
<xsl:apply-templates select="ERUDITEPOSTERS"/>
<br/>
</blockquote>
-->

    <!-- do not wish to encourage long posts for the sake of it
<xsl:call-template name="HEADER">
<xsl:with-param name="text"><xsl:value-of select="$m_toptenlongest"/></xsl:with-param>
</xsl:call-template>
<blockquote>
<xsl:apply-templates select="LONGESTPOSTS"/>
<br/>
</blockquote>
-->
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_toptwentyupdated"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <xsl:apply-templates select="RECENTCONVERSATIONS"/>
      <br/>
    </blockquote>

    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_toptenupdatedarticles"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <xsl:apply-templates select="FRESHESTARTICLES"/>
      <br/>
    </blockquote>

  </xsl:template>

  <!--

	<xsl:template match="PROLIFICPOSTERS|ERUDITEPOSTERS|LONGESTPOSTS|RECENTCONVERSATIONS|FRESHESTARTICLES">

	Generic:	Yes
	Purpose:	Drills down into the sub-elements

-->

  <xsl:template match="PROLIFICPOSTERS|ERUDITEPOSTERS|LONGESTPOSTS|RECENTCONVERSATIONS|FRESHESTARTICLES">
    <xsl:apply-templates select="PROLIFICPOSTER|ERUDITEPOSTER|LONGPOST|RECENTCONVERSATION|RECENTARTICLE"/>
  </xsl:template>

  <!--

	<xsl:template match="PROLIFICPOSTER|ERUDITEPOSTER">

	Generic:	Yes
	Purpose:	Shows a poster's details on the INFO page

-->

  <xsl:template match="PROLIFICPOSTER|ERUDITEPOSTER">
    <A>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/>
      </xsl:attribute>
      <xsl:value-of select="USER/USERNAME"/>
    </A> (<xsl:value-of select="COUNT"/><xsl:choose>
      <xsl:when test="number(COUNT) = 1">
        <xsl:value-of select="$m_postaverage"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_postsaverage"/>
      </xsl:otherwise>
    </xsl:choose><xsl:value-of select="AVERAGESIZE"/>)<br/>
  </xsl:template>

  <!--

	<xsl:template match="LONGPOST">

	Generic:	Yes
	Purpose:	Links to a long post on the info page

-->

  <xsl:template match="LONGPOST">
    <A>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>F<xsl:value-of select="FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;post=<xsl:value-of select="POSTID"/>#p<xsl:value-of select="POSTID"/>
      </xsl:attribute>
      <xsl:value-of select="POSTSUBJECT"/>
    </A> by <xsl:value-of select="USERNAME"/> (<xsl:value-of select="TOTALLENGTH"/><xsl:value-of select="$m_letters"/>)<br/>
  </xsl:template>

  <!--

	<xsl:template match="RECENT">

	Generic:	Yes
	Purpose:	Displays links to recent conversations

-->

  <xsl:template match="RECENTCONVERSATION">
    <A HREF="{$root}F{FORUMID}?thread={THREADID}&amp;latest=1">
      <xsl:value-of select="FIRSTSUBJECT"/>
    </A> (<xsl:apply-templates select="DATEPOSTED"/>)<br/>
  </xsl:template>

  <xsl:template match="RECENTARTICLE">
    <xsl:text>A</xsl:text><xsl:value-of select="H2G2ID"/>
    &nbsp;
    <A HREF="{$root}A{H2G2ID}">
      <xsl:value-of select="SUBJECT"/>
    </A>
    &nbsp;
    <xsl:choose>
      <xsl:when test="STATUS[.='1']">
        <xsl:value-of select="$m_edited"/>
      </xsl:when>
      <xsl:when test="STATUS[.='3']">
        <xsl:value-of select="$m_unedited"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
    &nbsp;
    (<xsl:apply-templates select="DATEUPDATED"/>)<br/>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='MESSAGEFRAME']">
    <html>
      <head>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <TITLE>h2g2</TITLE>
      </head>
      <body bgcolor="{$bgcolour}" text="{$mainfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="3" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <form>

          <!--<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]|FORUMTHREADPOSTS/@MORE">
<CENTER>
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/rewind.gif" border="0" alt="Skip to start of conversation"/>
</A>
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/reverse.gif" border="0" alt="back to older posts"/>
</A>
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/play.gif" border="0" alt="forward to newer posts"/>
</A>
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;latest=1" TARGET="twosides">
<IMG src="{$imagesource2}buttons/fforward.gif" border="0" alt="skip to newest posts"/>
</A>
</xsl:if>
</CENTER>
</xsl:if>
-->

          <xsl:apply-templates select="FORUMTHREADPOSTS">
            <xsl:with-param name="ptype" select="'frame'"/>
          </xsl:apply-templates>
          <hr/>
          <!--
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]|FORUMTHREADPOSTS/@MORE">
<CENTER>
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/rewind.gif" border="0" alt="Skip to start of conversation"/>
</A>
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/reverse.gif" border="0" alt="back to older posts"/>
</A>
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/play.gif" border="0" alt="forward to newer posts"/>
</A>
<A href="{$root}FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;latest=1" TARGET="twosides">
<IMG src="{$imagesource2}buttons/fforward.gif" border="0" alt="skip to newest posts"/>
</A>
</xsl:if>
</CENTER>
</xsl:if>
-->

          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
          <br/>
        </form>
      </body>
    </html>
  </xsl:template>

  <!--
	template: <H2G2 TYPE="FORUMFRAME">
	This template calls the FORUMFRAME template to create the frameset
-->

  <xsl:template match="H2G2[@TYPE='FORUMFRAME']">
    <HTML>
      <HEAD>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <TITLE>
          <xsl:value-of select="$m_forumtitle"/>
        </TITLE>
      </HEAD>
      <xsl:apply-templates select="FORUMFRAME"/>
    </HTML>
  </xsl:template>

  <!--
	template: <FORUMFRAME>
	Creates the frameset from the FORUMFRAME information.
	A frameset works by defining the sizes and relative positions of each frame
	on the page. Each frameset is divided either horizontally or vertically, 
	depending on whether it has a ROWS or COLS attribute. This means that
	you often need framesets within framesets - a frameset can contain either
	FRAME elements or more FRAMESET elements.

	Ripley provides the following URLs which can be used to deliver frame-based
	forums (each of which take id, thread, skip, show and post params):
		FFU - The top frame of the page, used simply to display UI
		FFL - The 'left' hand buttons frame. Another stylesheet might not
				need this frame. Does a similar thing to FFU.
		FFS - source of the forum - displays the 'This forum is associated with'
				header
		FFT - the list of headers and threads
		FFM - the actual messages
-->

  <!--

	<xsl:template match="FORUMFRAME">

	Generic:	No - must be overridden
	Purpose:	outputs a frameset based on the parameters passed

-->

  <xsl:template match="FORUMFRAME">
    <FRAMESET ROWS="80,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
      <FRAME NAME="toprow" MARGINHEIGHT="0" MARGINWIDTH="0" LEFTMARGIN="0" TOPMARGIN="0" SCROLLING="no">
        <xsl:attribute name="SRC">
          /FFU<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;post=<xsl:value-of select="@POST"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>
        </xsl:attribute>
      </FRAME>
      <FRAMESET ROWS="25,100%">
        <FRAME>
          <xsl:attribute name="SRC">
            /FFS<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;post=<xsl:value-of select="@POST"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>
          </xsl:attribute>
          <xsl:attribute name="SCROLLING">no</xsl:attribute>
        </FRAME>
        <FRAME>
          <xsl:attribute name="SRC">
            /FLR<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<xsl:if test="@POST &gt; 0">
              post=<xsl:value-of select="@POST"/>&amp;
            </xsl:if>skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>
          </xsl:attribute>
          <xsl:attribute name="NAME">twosides</xsl:attribute>
          <xsl:attribute name="ID">twosides</xsl:attribute>
        </FRAME>
        <!--			<FRAMESET COLS="35%,65%">
				<FRAME><xsl:attribute name="SRC">/FFT<xsl:value-of select="@FORUM" />&amp;thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="NAME">threads</xsl:attribute>
	<xsl:attribute name="ID">threads</xsl:attribute>
	</FRAME>
				<FRAME><xsl:attribute name="SRC">/FFM<xsl:value-of select="@FORUM" />&amp;thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" />#p<xsl:value-of select="@POST" /></xsl:attribute>
	<xsl:attribute name="NAME">messages</xsl:attribute>
	<xsl:attribute name="ID">frmmess</xsl:attribute>
	</FRAME>
			</FRAMESET>
-->
      </FRAMESET>
    </FRAMESET>
  </xsl:template>

  <!--

	<xsl:template match="FORUMFRAME[@SUBSET='TWOSIDES']">

	Generic:	No - must be overridden
	Purpose:	Displays the 'twosides' frameset

-->

  <xsl:template match="FORUMFRAME[@SUBSET='TWOSIDES']">
    <FRAMESET COLS="35%,65%">
      <FRAME>
        <xsl:attribute name="SRC">
          /FFT<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<xsl:if test="@POST &gt; 0">
            post=<xsl:value-of select="@POST"/>&amp;
          </xsl:if>skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>
        </xsl:attribute>
        <xsl:attribute name="NAME">threads</xsl:attribute>
        <xsl:attribute name="ID">threads</xsl:attribute>
      </FRAME>
      <FRAME>
        <xsl:attribute name="SRC">
          /FFM<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<!--<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>-->skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>#p<xsl:value-of select="@POST"/>
        </xsl:attribute>
        <xsl:attribute name="NAME">messages</xsl:attribute>
        <xsl:attribute name="ID">frmmess</xsl:attribute>
      </FRAME>
    </FRAMESET>
  </xsl:template>


  <xsl:template match="H2G2[@TYPE='SIDEFRAME']">
    <html>
      <xsl:apply-templates mode="header" select=".">
        <xsl:with-param name="title">h2g2 buttons</xsl:with-param>
      </xsl:apply-templates>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">

        <xsl:apply-templates mode="map" select="."/>
        <table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <xsl:call-template name="buttons"/>
          </tr>
        </table>
        <P>&nbsp;</P>
      </body>
    </html>
  </xsl:template>

  <!--
	template: <H2G2> mode=header
	param: title

	We're using modes to encapsulate commonly used bits of the UI. This
	template outputs the <HEAD> section which contains a bunch of javascript
	and stuff. This is used in several places, so it's put here to avoid
	duplication.
-->

  <xsl:template match="H2G2" mode="header">
    <xsl:param name="title">h2g2</xsl:param>
    <head>
      <title>
        <xsl:value-of select="$title"/>
      </title>
      <xsl:call-template name="insert-headelements"/>
      <script language="JavaScript">
        <xsl:comment>
          hide this script from non-javascript-enabled browsers

          function popupwindow(link, target, parameters)
          {
          popupWin = window.open(link,target,parameters);
          }

          // stop hiding
        </xsl:comment>
      </script>
      <style type="text/css">
        <xsl:comment>
          DIV.browse A { color: <xsl:value-of select="$mainfontcolour"/>}
        </xsl:comment>
      </style>
      <xsl:if test="//WHO-IS-ONLINE">
        <SCRIPT language="javascript">
          <xsl:comment>
            function popusers(link) {
            popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
            }
            //
          </xsl:comment>
        </SCRIPT>
      </xsl:if>

      <xsl:if test="//POPUP|//LINK[@POPUP]">
        <SCRIPT language="javascript">
          <xsl:comment>
            function popupwindow(link, target, parameters)
            {
            popupWin = window.open(link,target,parameters);
            }
            //
          </xsl:comment>
        </SCRIPT>
      </xsl:if>


    </head>
  </xsl:template>

  <!--
	template: <H2G2> mode = map

	This template outputs the <MAP> elements for the UI. This might be specific
	to the goo UI - I don't know if other UIs need the map stuff.
-->

  <xsl:template match="H2G2" mode="map">
    <map name="top_panic">
      <area>
        <xsl:attribute name="shape">rect</xsl:attribute>
        <xsl:attribute name="coords">52,6,108,36</xsl:attribute>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>
          <xsl:value-of select="$pageui_dontpanic"/>
        </xsl:attribute>
        <xsl:attribute name="onMouseOver">di('Ngui_02_03','Igui_02_03o');dmim('DON\'T PANIC!'); return document.returnValue;</xsl:attribute>
        <xsl:attribute name="onMouseOut">di('Ngui_02_03','Igui_02_03'); dmim(''); return document.returnValue;</xsl:attribute>
        <xsl:attribute name="onClick">di('Ngui_02_03','Igui_02_03h');return true;</xsl:attribute>
        <xsl:attribute name="target">_top</xsl:attribute>
      </area>
    </map>
    <map name="top_copy">
      <area>
        <xsl:attribute name="shape">rect</xsl:attribute>
        <xsl:attribute name="coords">14,41,51,53</xsl:attribute>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>aboutus
        </xsl:attribute>
        <xsl:attribute name="onMouseOver">
          dmim('<xsl:value-of select="$m_copyright"/>'); return document.returnValue;
        </xsl:attribute>
        <xsl:attribute name="onMouseOut">dmim(''); return document.returnValue;</xsl:attribute>
        <xsl:attribute name="target">_top</xsl:attribute>
      </area>
      <area>
        <xsl:attribute name="shape">rect</xsl:attribute>
        <xsl:attribute name="coords">19,9,48,42</xsl:attribute>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>aboutus
        </xsl:attribute>
        <xsl:attribute name="onMouseOver">
          dmim('<xsl:value-of select="$m_copyright"/>'); return document.returnValue;
        </xsl:attribute>
        <xsl:attribute name="onMouseOut">dmim(''); return document.returnValue;</xsl:attribute>
        <xsl:attribute name="target">_top</xsl:attribute>
      </area>
    </map>
  </xsl:template>

  <!--

	<xsl:template name="buttons">

	Generic:	No - either overridden or never called
	Purpose:	Displays a button bar for the simple skin

-->

  <xsl:template name="buttons">
    <!-- sub renderMainButtons -->
    <STYLE type="text/css">
      <xsl:comment>
        SPAN.buttons A {  text-decoration: none; color: #FFFFFF}
        SPAN.buttons A:hover   { text-decoration: underline ! important; color: yellow}
      </xsl:comment>
    </STYLE>
    <TABLE width="100%" CELLPADDING="0" CELLSPACING="0">
      <form method="GET" action="{$root}Search" target="_top">
        <TR>
          <TD>
            <span xsl:use-attribute-sets="buttons">
              <SPAN STYLE="text-decoration:none;font-size:11px;color:#ffffff">
                <input type="hidden" name="searchtype" value="goosearch"/>
                <input type="text" name="searchstring" value=""/>
                <input type="submit" name="dosearch" value="{$alt_searchbutton}"/>
                <span xsl:use-attribute-sets="lifelinks">
                  <xsl:text> </xsl:text><xsl:call-template name="m_lifelink"/>
                  | <xsl:call-template name="m_universelink"/>
                  | <xsl:call-template name="m_everythinglink"/>
                  | <xsl:call-template name="m_searchlink"/>
                </span>
              </SPAN>
            </span>
          </TD>
        </TR>
        <TR>
          <TD bgcolor="{$topbar}" height="1"/>
        </TR>
        <TR>
          <TD bgcolor="{$topbar}" CELLPADDING="0" CELLSPACING="0">
            <span xsl:use-attribute-sets="buttons">
              <SPAN class="buttons">
                <a href="{$root}{$pageui_sitehome}" target="_top">
                  <xsl:value-of select="$m_frontpagebut"/>
                </a> |
                <xsl:choose>
                  <xsl:when test="PAGEUI/MYHOME[@VISIBLE = 1]">
                    <!-- choose between either my home or register -->
                    <a>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>
                        <xsl:value-of select="$pageui_myhome"/>
                      </xsl:attribute>
                      <xsl:attribute name="target">_top</xsl:attribute>
                      <xsl:value-of select="$alt_myspace"/>
                    </a> |
                  </xsl:when>
                  <xsl:otherwise>
                    <a>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>
                        <xsl:value-of select="$pageui_register"/>
                      </xsl:attribute>
                      <xsl:attribute name="target">_top</xsl:attribute>
                      <xsl:value-of select="$alt_register"/>
                    </a> |
                  </xsl:otherwise>
                </xsl:choose>
                <!--
<xsl:choose>
<xsl:when test='PAGEUI/DISCUSS[@VISIBLE = "1"]'>
<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="PAGEUI/DISCUSS/@LINKHINT" /></xsl:attribute>
<xsl:attribute name="target">_top</xsl:attribute>
<xsl:value-of select="$m_discuss"/></xsl:element> | 
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$m_discuss"/> | 
</xsl:otherwise>
</xsl:choose>
-->
                <!--<xsl:if test="PAGEUI/EDITPAGE[@VISIBLE = 1]|PAGEUI/MYDETAILS[@VISIBLE = 1]">-->
                <!--
<xsl:choose>
<xsl:when test='PAGEUI/EDITPAGE[@VISIBLE = "1"]'>
<a>
<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="PAGEUI/EDITPAGE/@LINKHINT" /></xsl:attribute>
<xsl:attribute name="target">_top</xsl:attribute>
<xsl:value-of select="$m_editpagetbut"/></a> | 
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$m_editpagetbut"/> | 
</xsl:otherwise>
</xsl:choose>
-->
                <xsl:choose>
                  <xsl:when test="PAGEUI/MYDETAILS[@VISIBLE = '1']">

                    <A target="_top">
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>
                        <xsl:value-of select="$pageui_mydetails"/>
                      </xsl:attribute>
                      <xsl:value-of select="$alt_preferences"/>
                    </A> |
                  </xsl:when>
                  <xsl:otherwise>
                  </xsl:otherwise>
                </xsl:choose>
                <!--</xsl:if>-->
                <xsl:if test="PAGEUI/LOGOUT[@VISIBLE = '1']">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/>
                      <xsl:value-of select="$pageui_logout"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_top</xsl:attribute>
                    <xsl:value-of select="$alt_logout"/>
                  </xsl:element> |
                </xsl:if>
                <A href="{$root}Shop" target="_top">
                  <xsl:value-of select="$alt_shop"/>
                </A> |
                <A href="{$root}DontPanic" target="_top">
                  <xsl:value-of select="$alt_help"/>
                </A> |
                <A href="{$root}Askh2g2" target="_top">
                  <xsl:value-of select="$alt_askh2g2"/>
                </A> |
                <A href="{$root}UserEdit" target="_top">
                  <xsl:value-of select="$alt_tellh2g2"/>
                </A> |
                <A href="{$root}Feedback" target="_top">Feedback</A> |
                <A href="{$root}UserDetails" target="_top">
                  <xsl:value-of select="$alt_preferences"/>
                </A> |
                <A href="{$root}AboutUs" target="_top">
                  <xsl:value-of select="$alt_aboutus"/>
                </A>
              </SPAN>
            </span>
          </TD>
        </TR>
      </form>
    </TABLE>
  </xsl:template>


  <xsl:template match="H2G2[@TYPE='TOPFRAME']">
    <html>
      <xsl:apply-templates mode="header" select="."/>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <!--<META http-equiv="REFRESH" content="90"/>-->
        <xsl:call-template name="buttons"/>
      </body>
    </html>
  </xsl:template>


  <!--
BODY
Just pass through anything below it, subject to other templates
-->

  <!--

	<xsl:template mode="frontpage" match="BODY">

	Generic:	No
	Purpose:	Different handling of BODY tag on frontpage

-->

  <xsl:template match="BODY" mode="frontpage">
    <!--<table><tr><td width="36"></td><td>-->
    <!--<blockquote><font size="2">-->
    <span xsl:use-attribute-sets="frontpagefont">
      <xsl:apply-templates/>
    </span>
    <!--</font></blockquote>-->
    <!--</td><td width="36"></td></tr></table>-->
  </xsl:template>

  <!--
P
Pass it through as normal
-->

  <xsl:template match="P|p">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>

  <!--
	various HTML tags that are passed through unchanged:

	<B>
	<BLOCKQUOTE>
	<BODY>
	<BR/>
	<CAPTION>
	<CODE>
	<FOOTNOTE>
	<GUIDE>
	<HEADER>
	<I>
	<LI>
	<LINK>
	<OL>
	<P>
	<PRE>
	<REFERENCES>
	<SUB>
	<SUBHEADER>
	<SUP>
	<TABLE>
	<TD>
	<TH>
	<TR>
	<UL>
	
	<AREA>
	<FORM>
	<INPUT>
	<MAP>
	<PICTURE>
	<SELECT>
-->

  <xsl:template match="BLOCKQUOTE|blockquote|CAPTION|caption|CODE|code|OL|ol|PRE|pre|SUB|sub|SUP|sup|TABLE|table|TD|td|TH|th|TR|tr">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="INPUT|input|SELECT|select">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="TEXTAREA">
    <form>
      <xsl:copy>
        <xsl:apply-templates select="*|@*|text()"/>
      </xsl:copy>
    </form>
  </xsl:template>

  <xsl:template match="INPUT[@SRC]">
    SRC attributes not allowed in GuideML
  </xsl:template>

  <!--
<xsl:template match="FORM">
<xsl:if test="not(starts-with(@ACTION,'http://'))">
<xsl:copy><xsl:apply-templates select="*|@*|text()"/></xsl:copy>
</xsl:if>
</xsl:template>
-->

  <xsl:template match="IMG">
    <xsl:if test="not(contains(@SRC,':')) and not(starts-with(@SRC,'//'))">
      <xsl:copy>
        <xsl:apply-templates select="*|@*|text()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="PULLQUOTE">

	Generic:	Yes
	Purpose:	Pullquote handling

-->

  <xsl:template match="PULLQUOTE">
    <xsl:choose>
      <xsl:when test="@EMBED">
        <xsl:element name="TABLE" use-attribute-sets="pullquotetable">
          <xsl:attribute name="ALIGN">
            <xsl:value-of select="@EMBED"/>
          </xsl:attribute>
          <TR VALIGN="middle">
            <TD ALIGN="left">
              <xsl:element name="P">
                <xsl:choose>
                  <xsl:when test="@ALIGN">
                    <xsl:attribute name="ALIGN">
                      <xsl:value-of select="@ALIGN"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="ALIGN">CENTER</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <span xsl:use-attribute-sets="pullquote">
                  <B>
                    <xsl:apply-templates/>
                  </B>
                </span>
              </xsl:element>
            </TD>
          </TR>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="P">
          <xsl:choose>
            <xsl:when test="@ALIGN">
              <xsl:attribute name="ALIGN">
                <xsl:value-of select="@ALIGN"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="ALIGN">CENTER</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <span xsl:use-attribute-sets="pullquote">
            <B>
              <xsl:apply-templates/>
            </B>
          </span>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="PICTURE">

	Generic:	Yes
	Purpose:	Display a picture

-->

  <xsl:template match="PICTURE">
    <xsl:choose>
      <xsl:when test="starts-with(@SRC|@BLOB,'http://') or starts-with(@SRC|@BLOB,'/')">
        <xsl:comment>Off-site picture removed</xsl:comment>
      </xsl:when>
      <xsl:otherwise>

        <xsl:call-template name="picturenoshadow"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="picturenoshadow">
    <table xsl:use-attribute-sets="picturetable">
      <xsl:attribute name="align">
        <xsl:value-of select="@EMBED"/>
      </xsl:attribute>
      <tr>
        <td rowspan="4" width="5"/>
        <td height="5"/>
        <td rowspan="4" width="5"/>
      </tr>
      <tr>
        <td>
          <xsl:call-template name="renderimage"/>
        </td>

      </tr>
      <tr>
        <td align="center" valign="top">
          <span xsl:use-attribute-sets="captionfont">
            <xsl:apply-templates/>
          </span>
        </td>
      </tr>
      <tr>
        <td height="5"/>
      </tr>
    </table>
  </xsl:template>


  <xsl:template match="PICTURE[@BORDER=1]">
    <xsl:choose>
      <xsl:when test="starts-with(@SRC|@BLOB,'http://') or starts-with(@SRC|@BLOB,'/')">
        <xsl:comment>Off-site picture removed</xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <table xsl:use-attribute-sets="picturetable">
          <xsl:attribute name="align">
            <xsl:value-of select="@EMBED"/>
          </xsl:attribute>
          <tr>
            <td rowspan="6" width="5"/>
            <td colspan="3" height="5"/>
            <td rowspan="6" width="5"/>
          </tr>
          <tr>
            <td rowspan="3" align="left" valign="top" width="{$pictureborderwidth}" bgcolor="{$picturebordercolour}">
              <img border="0" src="{$imagesource}blank.gif" width="{$pictureborderwidth}"/>
            </td>
            <td align="left" valign="top" height="{$pictureborderwidth}" bgcolor="{$picturebordercolour}">
              <img border="0" src="{$imagesource}blank.gif" height="{$pictureborderwidth}"/>
            </td>
            <td rowspan="3" align="left" valign="top" width="{$pictureborderwidth}" bgcolor="{$picturebordercolour}">
              <img border="0" src="{$imagesource}blank.gif" width="{$pictureborderwidth}"/>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="renderimage"/>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top" height="{$pictureborderwidth}" bgcolor="{$picturebordercolour}">
              <img border="0" src="{$imagesource}blank.gif" height="{$pictureborderwidth}"/>
            </td>
          </tr>
          <tr>
            <td/>
            <td align="center" valign="top">
              <span xsl:use-attribute-sets="captionfont">
                <xsl:apply-templates/>
              </span>
            </td>
          </tr>
          <tr>
            <td colspan="3" height="5"/>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="PICTURE[@SRC]">
    <xsl:comment>Off-site picture removed</xsl:comment>
  </xsl:template>

  <xsl:template name="renderimage">
    <xsl:choose>
      <xsl:when test="name(..)=string('LINK')">
        <A>
          <xsl:for-each select="..">
            <xsl:call-template name="dolinkattributes"/>
          </xsl:for-each>
          <!--<xsl:choose>
<xsl:when test="../@H2G2"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="../@H2G2"/></xsl:attribute>
</xsl:when>
<xsl:when test="../@BIO"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="../@BIO"/></xsl:attribute>
</xsl:when>
<xsl:when test="../@HREF"><xsl:apply-templates select="../@HREF"/>
</xsl:when>
</xsl:choose>	
	-->
          <xsl:call-template name="outputimg"/>
        </A>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="outputimg"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template name="outputimg">

	Generic:	Yes
	Context:	<PICTURE>
	Purpose:	Outputs an IMG tag corresponding to the PICTURE tag

-->

  <xsl:template name="outputimg">
    <IMG BORDER="0">
      <xsl:copy-of select="@WIDTH|@HEIGHT|@ALT"/>
      <xsl:attribute name="SRC">
        <xsl:choose>
          <xsl:when test="@BLOB">
            <xsl:value-of select="@BLOB"/>
            <xsl:value-of select="$blobbackground"/>
          </xsl:when>
          <xsl:when test="@CNAME">
            <xsl:value-of select="$skingraphics"/>
            <xsl:value-of select="@CNAME"/>
          </xsl:when>
          <xsl:when test="@NAME">
            <xsl:value-of select="$graphics"/>
            <xsl:value-of select="@NAME"/>
          </xsl:when>
          <xsl:when test="@H2G2IMG">
            <xsl:value-of select="concat($h2g2graphics,@H2G2IMG)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@SRC"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </IMG>
  </xsl:template>

  <!--

	<xsl:template match="LINK/PICTURE">

	Generic:	Yes
	Purpose:	Display a picture which is contained in a link

-->

  <!--
<xsl:template match="LINK/PICTURE">
<xsl:if test="@SRC">
<table xsl:use-attribute-sets="picturetable">
<xsl:attribute name="align"><xsl:value-of select="@EMBED"/></xsl:attribute>
<tr> 

<td><A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>
<xsl:choose>
<xsl:when test="../@H2G2">/<xsl:value-of select="../@H2G2"/>
</xsl:when>
<xsl:when test="../@BIO">/<xsl:value-of select="../@BIO"/>
</xsl:when>
<xsl:when test="../@HREF"><xsl:value-of select="../@HREF"/>
</xsl:when>
</xsl:choose></xsl:attribute><IMG BORDER="0"><xsl:copy-of select="@ALT"/><xsl:attribute name="SRC"><xsl:value-of select="@SRC"/></xsl:attribute>
</IMG></A></td>

</tr>
<tr>
<td align="center" valign="top"><font xsl:use-attribute-sets="captionfont"><xsl:apply-templates /></font></td>
</tr>
</table>
</xsl:if>
<xsl:if test="@BLOB">
<table xsl:use-attribute-sets="picturetable">
<xsl:attribute name="align"><xsl:value-of select="@EMBED"/></xsl:attribute>
  <tr> 
	
    <td><A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>
<xsl:choose>
<xsl:when test="../@H2G2">/<xsl:value-of select="../@H2G2"/>
</xsl:when>
<xsl:when test="../@BIO">/<xsl:value-of select="../@BIO"/>
</xsl:when>
<xsl:when test="../@HREF"><xsl:value-of select="../@HREF"/>
</xsl:when>
</xsl:choose></xsl:attribute><IMG BORDER="0"><xsl:copy-of select="@ALT"/><xsl:attribute name="SRC">/<xsl:value-of select="@BLOB"/><xsl:value-of select="$blobbackground"/></xsl:attribute>
</IMG></A></td>
	
  </tr>
  <tr>
<td align="center" valign="top"><font xsl:use-attribute-sets="captionfont"><xsl:apply-templates /></font></td>
  </tr>
</table>
</xsl:if>
</xsl:template>
-->
  <!--

	<xsl:template match="SMILEY">

	Generic:	Yes
	Purpose:	Display a smiley face based on the TYPE attribute

-->

  <xsl:template match="SMILEY">
    <xsl:choose>
      <xsl:when test="@H2G2|@h2g2|@BIO|@bio|@HREF|@href">
        <xsl:variable name="url">
          <xsl:value-of select="@H2G2|@h2g2|@BIO|@bio|@HREF|@href"/>
        </xsl:variable>
        <a href="{$root}{$url}">
          <!-- only put in target="_top" when link goes outside current page -->
          <xsl:if test="substring($url, 0, 1) != '#'">
            <xsl:attribute name="target">_top</xsl:attribute>
          </xsl:if>
          <img border="0" alt="{@TYPE}" title="{@TYPE}">
            <xsl:choose>
              <xsl:when test="@TYPE='fish' and number(../../USER/USERID) = 23">
                <xsl:attribute name="src">
                  <xsl:value-of select="$smileysource"/>s_fish.gif
                </xsl:attribute>
                <xsl:attribute name="alt">Shim's Blue Fish</xsl:attribute>
                <xsl:attribute name="title">Shim's Blue Fish</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="src">
                  <xsl:value-of select="$smileysource"/>f_<xsl:value-of select="translate(@TYPE,$uppercase,$lowercase)"/>.gif
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </img>
        </a>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <img border="0" alt="{@TYPE}" title="{@TYPE}">
          <xsl:choose>
            <xsl:when test="@TYPE='fish' and number(../../USER/USERID) = 23">
              <xsl:attribute name="src">
                <xsl:value-of select="$smileysource"/>s_fish.gif
              </xsl:attribute>
              <xsl:attribute name="alt">Shim's Blue Fish</xsl:attribute>
              <xsl:attribute name="title">Shim's Blue Fish</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="src">
                <xsl:value-of select="$smileysource"/>f_<xsl:value-of select="@TYPE"/>.gif
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </img>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="INTRO">

	Generic:	Yes
	Purpose:	Displays the INTRO section

-->

  <xsl:template match="INTRO">
    <xsl:if test="string-length(.) &gt; 0">
      <span xsl:use-attribute-sets="introfont">
        <xsl:apply-templates/>
      </span>
      <br/>
      <br/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="UL">

	Generic:	Yes
	Purpose:	-

-->

  <xsl:template match="UL">
    <UL>
      <xsl:apply-templates/>
    </UL>
  </xsl:template>

  <!--

	<xsl:template match="LI">

	Generic:	Yes
	Purpose:	-

-->

  <xsl:template match="LI">
    <LI>
      <xsl:apply-templates/>
    </LI>
  </xsl:template>

  <!--

	<xsl:template match="LINK">

	Generic:	Yes
	Purpose:	Hyperlink

-->

  <xsl:template match="LINK">
    <xsl:if test="@H2G2|@h2g2|@DNAID">
      <a xsl:use-attribute-sets="mLINK">
        <xsl:call-template name="dolinkattributes"/>
        <xsl:call-template name="bio-link"/>
      </a>
    </xsl:if>
    <xsl:if test="@HREF|@href">
      <a xsl:use-attribute-sets="mLINK">
        <xsl:call-template name="dolinkattributes"/>
        <xsl:apply-templates/>
      </a>
    </xsl:if>
    <xsl:if test="@BIO|@bio">
      <a xsl:use-attribute-sets="mLINK">
        <xsl:call-template name="dolinkattributes"/>
        <xsl:call-template name="bio-link"/>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@HREF|@H2G2|@DNAID">
    <!--
<xsl:choose>
<xsl:when test="starts-with(.,'http://') and not(starts-with(., 'http://www.bbc.co.uk')) and not(starts-with(., 'http://www.h2g2.com'))">
<xsl:attribute name="TARGET">_blank</xsl:attribute>
</xsl:when>
<xsl:otherwise>
-->
    <xsl:attribute name="TARGET">_top</xsl:attribute>
    <!--
</xsl:otherwise>
</xsl:choose>
-->
    <xsl:attribute name="HREF">
      <xsl:apply-templates select="." mode="applyroot"/>
      <!--
<xsl:choose>
<xsl:when test="starts-with(.,'/') and string-length(.) &gt; 1">
<xsl:value-of select="$root"/><xsl:value-of select="substring(.,2)"/>
</xsl:when>
<xsl:when test="starts-with(.,'http://')">
<xsl:value-of select="."/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$root"/><xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
-->
    </xsl:attribute>
  </xsl:template>

  <!--

	<xsl:template name="bio-link">

	Generic:	Yes
	Purpose:	Given a LINK tag as context, if the tag is empty, this
				will search the rest of the document for the referenced
				info, and display that.
				This works for both BIO and H2G2 types.

-->

  <xsl:template name="bio-link">
    <xsl:choose>
      <xsl:when test="@BIO">
        <xsl:choose>
          <xsl:when test="./*">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:when test="string-length(.) = 0">
            <xsl:variable name="userid">
              <xsl:value-of select="substring-after(@BIO,'U')"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="//REFERENCES/USERS/USERLINK[USERID=$userid]/USERNAME">
                <xsl:value-of select="//REFERENCES/USERS/USERLINK[USERID=$userid]/USERNAME"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$m_researcher"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$userid"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@H2G2|@DNAID">
        <xsl:choose>
          <xsl:when test="./*">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:when test="string-length(.) = 0">
            <xsl:variable name="h2g2id">
              <xsl:choose>
                <xsl:when test="@H2G2">
                  <xsl:value-of select="substring-after(@H2G2,'A')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring-after(@DNAID,'A')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="//REFERENCES/ENTRIES/ENTRYLINK[H2G2ID=$h2g2id]/SUBJECT">
                <xsl:value-of select="//REFERENCES/ENTRIES/ENTRYLINK[H2G2ID=$h2g2id]/SUBJECT"/>
              </xsl:when>
              <xsl:otherwise>
                A<xsl:value-of select="$h2g2id"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template name="dolinkattributes">

	Generic: Yes
	Purpose:	Called in context of a LINK tag and will generate the correct link
				attributes for that link

-->

  <xsl:template name="dolinkattributes">
    <xsl:choose>
      <xsl:when test="@POPUP">
        <xsl:variable name="url">
          <xsl:if test="@H2G2">
            <xsl:apply-templates select="@H2G2" mode="applyroot"/>
          </xsl:if>
          <xsl:if test="@DNAID">
            <xsl:apply-templates select="@DNAID" mode="applyroot"/>
          </xsl:if>
          <xsl:if test="@HREF">
            <xsl:apply-templates select="@HREF" mode="applyroot"/>
          </xsl:if>
          <xsl:if test="@BIO">
            <xsl:apply-templates select="@BIO" mode="applyroot"/>
          </xsl:if>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="@STYLE">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$url"/>
            </xsl:attribute>
            <xsl:attribute name="onClick">
              popupwindow('<xsl:value-of select="$url"/>','<xsl:value-of select="@TARGET"/>','<xsl:value-of select="@STYLE"/>');return false;
            </xsl:attribute>
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
            <xsl:attribute name="HREF">
              <xsl:value-of select="$url"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@H2G2|@h2g2">
          <xsl:apply-templates select="@H2G2"/>
          <!--<xsl:attribute name="TARGET">_top</xsl:attribute>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="@H2G2|@h2g2"/></xsl:attribute>-->
        </xsl:if>
        <xsl:if test="@DNAID">
          <xsl:apply-templates select="@DNAID"/>
        </xsl:if>
        <xsl:if test="@HREF|@href">
          <xsl:apply-templates select="@HREF"/>
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

  <xsl:template match="@*|*" mode="applyroot">
    <xsl:choose>
      <xsl:when test="../@SITE">
        <xsl:text>/dna/</xsl:text><xsl:value-of select="../@SITE"/>/<xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="starts-with(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/classic/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/brunel/')">
        <xsl:value-of select="concat(substring-after(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/classic/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/brunel/'))"/>
      </xsl:when>
      <xsl:when test="starts-with(.,'http://www.h2g2.com/')">
        <xsl:value-of select="concat('/dna/h2g2/',substring-after(.,'http://www.h2g2.com/'))"/>
      </xsl:when>
      <xsl:when test="starts-with(.,'http://') or starts-with(.,'#') or starts-with(.,'mailto:') or (starts-with(.,'/') and contains(substring-after(.,'/'),'/'))">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="starts-with(.,'/') and string-length(.) &gt; 1">
        <xsl:value-of select="$root"/>
        <xsl:value-of select="substring(.,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$root"/>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="INVALIDARTICLE">

	Generic:	Yes
	Purpose:	Displays alternatives when an invalid article is found

-->

  <xsl:template match="INVALIDARTICLE">
    <xsl:call-template name="m_entryexists"/>
    <xsl:apply-templates select="SUGGESTEDALTERNATIVES[LINK]"/>
  </xsl:template>

  <!--

	<xsl:template match="SUGGESTEDALTERNATIVES">

	Generic:	Yes
	Purpose:	Displays suggested alternative articles

-->

  <xsl:template match="SUGGESTEDALTERNATIVES">
    <xsl:call-template name="m_possiblealternatives"/>
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>

  <!--

	<xsl:template match="SUGGESTEDALTERNATIVES/LINK">

	Generic:	Yes
	Purpose:	displays the links to alternative articles

-->

  <xsl:template match="SUGGESTEDALTERNATIVES/LINK">
    <A xsl:use-attribute-sets="mSUGLINK">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>A<xsl:value-of select="@H2G2"/>
      </xsl:attribute>A<xsl:value-of select="@H2G2"/>
    </A>: <xsl:apply-templates/><br/>
  </xsl:template>

  <!--

	<xsl:template match="NOENTRYYET">

	Generic:	Yes
	Purpose:	Entry doesn't exist yet

-->

  <xsl:template match="NOENTRYYET">
    <P>
      <xsl:value-of select="$m_noentryyet"/>
    </P>
  </xsl:template>

  <!--

	<xsl:template match="PARSE-ERROR">

	Generic:	Yes
	Purpose:	Display an XML parsing error

-->

  <xsl:template match="PARSE-ERROR">
    <br/><br/>XML Parsing error found: <xsl:value-of select="DESCRIPTION"/><br/>
    <PRE>
      <xsl:value-of select="LINE"/>
    </PRE><br/>
    Line <xsl:value-of select="LINENO"/>, line position <xsl:value-of select="LINEPOS"/><br/>

  </xsl:template>

  <!--

	<xsl:template match="USER">

	Generic:	Yes
	Purpose:	Handle the user tag

-->

  <xsl:template match="USER">
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
      </xsl:attribute>
      <xsl:value-of select="USERNAME"/>
    </xsl:element>
  </xsl:template>

  <!--

	<xsl:template match="USER" mode="ArticleInfo">
	Purpose:	Display the User ID in the Article info section

-->

  <xsl:template match="USER" mode="ArticleInfo">
    <a xsl:use-attribute-sets="pageauthorsfont" href="{$root}U{USERID}">
      <xsl:value-of select="USERNAME"/>
    </a>
  </xsl:template>
  <!--

	<xsl:template match="HEADER">

	Generic:	No
	Purpose:	handle the header tag

-->

  <xsl:template match="HEADER">
    <div xsl:use-attribute-sets="headerfont">
      <xsl:apply-templates/>
    </div>
  </xsl:template>



  <!--

	<xsl:template match="SUBHEADER">

	Generic:	No
	Purpose:	Handles SUBHEADER tag

-->

  <xsl:template match="SUBHEADER">
    <div xsl:use-attribute-sets="subheaderfont">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!--

	<xsl:template match="B|b">

	Generic:	Yes
	Purpose:	Handles bold

-->

  <xsl:template match="B|b">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>

  <!--

	<xsl:template match="I|i">

	Generic:	Yes
	Purpose:	Italic

-->

  <xsl:template match="I|i">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <!--

	<xsl:template match="XMLERROR">

	Generic:	Yes
	Purpose:	Displays the XML error value

-->

  <xsl:template match="XMLERROR">
    <span xsl:use-attribute-sets="xmlerrorfont">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <!--

	<xsl:template match="SUBJECT">

	Generic:	No
	Purpose:	handles the SUBJECT tag in documents

-->

  <xsl:template match="SUBJECT">
    <br clear="all"/>
    <div xsl:use-attribute-sets="subjectfont">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>


  <!--

	<xsl:template match="SECTION">

	Generic:	Yes
	Purpose:	Handle the SECTION tag

-->

  <xsl:template match="SECTION">
    <B>
      <xsl:value-of select="@DESCRIPTION"/>
    </B>
    <BR/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- dodgy old code
<xsl:template match="THREADLIST">
<UL>
<xsl:for-each select="FORUMLINK">
<LI><xsl:value-of select="DATE"/> 
<xsl:choose>
<xsl:when test="ENTRYID[. != /H2G2/FORUMPOST/POSTID]">
<STRONG>
<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="ENTRYID"/></xsl:attribute>
<xsl:value-of select="SUBJECT"/></xsl:element>
</STRONG>
</xsl:when>
<xsl:otherwise>
<STRONG>
<xsl:value-of select="SUBJECT"/>
</STRONG>
</xsl:otherwise>
</xsl:choose> - <xsl:value-of select="POSTEDBY/USER/USERNAME"/> 
</LI>
</xsl:for-each>
</UL>
</xsl:template>

<xsl:template match="PREVIOUSPOST">
&lt;<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="."/></xsl:attribute>
Prev</xsl:element> 
</xsl:template>

<xsl:template match="NEXTPOST">
<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="."/></xsl:attribute>
Next</xsl:element> &gt;
</xsl:template>
-->

  <!--
<xsl:template match="THREADS">
<xsl:for-each select="THREAD">
<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="FIRSTPOSTID"/></xsl:attribute>
<b><xsl:value-of select="SUBJECT"/></b></xsl:element> - <xsl:value-of select="USER/USERNAME"/> [ <B><xsl:value-of select="COUNT"/>
<xsl:if test=".[NEWTODAY=1]">
<EM><FONT COLOR="#800000">new!</FONT></EM>
</xsl:if>
</B> ]<xsl:value-of select="DATE"/><BR/><BR/>
</xsl:for-each>
</xsl:template>
-->

  <!--
<xsl:template match="POSTBODY">
<P>
<xsl:apply-templates />
</P>
</xsl:template>
-->

  <!--
<xsl:template match="FORUMPOST">
	<TABLE WIDTH="100%">
	<TR><TD width="100%"><HR/></TD>
	<TD nowrap="1">
	<xsl:choose>
	<xsl:when test="PREVIOUSPOST">
	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="PREVIOUSPOST"/></xsl:attribute><IMG src="{$imagesource}f_backward.gif" border="0" alt="Previous message"/></xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<IMG src="{$imagesource}f_backgrey.gif" border="0" alt="There is no previous message"/>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
	<xsl:when test="NEXTPOST">
	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="NEXTPOST"/></xsl:attribute><IMG src="{$imagesource}f_forward.gif" border="0" alt="Next message"/></xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<IMG src="{$imagesource}f_forwardgrey.gif" border="0" alt="There is no next message"/>
	</xsl:otherwise>
	</xsl:choose>
	 </TD>
	</TR>
	</TABLE>
	<FONT COLOR="#00FFFF">Posted <xsl:value-of select="DATE"/> by </FONT>
	<A>
	<xsl:attribute name="TARGET">_top</xsl:attribute>
	<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="POSTEDBY/USER/USERID"/></xsl:attribute><xsl:choose><xsl:when test='POSTEDBY/USER[USERID > 9999]'><xsl:value-of select="POSTEDBY/USER/USERNAME"/></xsl:when><xsl:otherwise><B><I><xsl:value-of select="POSTEDBY/USER/USERNAME"/></I></B></xsl:otherwise></xsl:choose></A>
	<BR/>
	<FONT COLOR="#00FFFF">Subject:</FONT> <B><xsl:value-of select="SUBJECT"/></B>
	<BR/>
<xsl:apply-templates select="//POSTBODY" />
	<TABLE WIDTH="100%">
	<TR><TD width="100%"><HR/></TD>
	<TD nowrap="1">
	<xsl:choose>
	<xsl:when test="PREVIOUSPOST">
	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="PREVIOUSPOST"/></xsl:attribute><IMG src="{$imagesource}f_backward.gif" border="0" alt="Previous message"/></xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<IMG src="{$imagesource}f_backgrey.gif" border="0" alt="There is no previous message"/>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
	<xsl:when test="NEXTPOST">
	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>forumh2g2.asp?postid=<xsl:value-of select="NEXTPOST"/></xsl:attribute><IMG src="{$imagesource}f_forward.gif" border="0" alt="Next message"/></xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<IMG src="{$imagesource}f_forwardgrey.gif" border="0" alt="There is no next message"/>
	</xsl:otherwise>
	</xsl:choose>
	 </TD>
	</TR>
	</TABLE>
</xsl:template>
-->

  <!--

	<xsl:template match="BR">

	Generic:	Yes
	Purpose:	BR tag

-->

  <xsl:template match="BR">
    <xsl:copy/>
  </xsl:template>

  <!--

	<xsl:template match="FRONTPAGE">

	Generic:	No
	Purpose:	Handles the Frontpage element (possibly never used?)

-->

  <xsl:template match="FRONTPAGE">
    <xsl:apply-templates select="MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM">
      <xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--

	<xsl:template match="EDITORIAL-ITEM">

	Generic:	No
	Purpose:	Handles EDITORIAL-ITEM tags and whether the user is registered or not.

-->

  <xsl:template match="EDITORIAL-ITEM">
    <xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $fpregistered=1) or (@TYPE='UNREGISTERED' and $fpregistered=0)">
      <xsl:apply-templates select="SUBJECT"/>
      <xsl:apply-templates mode="frontpage" select="BODY"/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="TOP-FIVES">

	Generic:	No
	Purpose:	Display the top fives

-->

  <xsl:template match="TOP-FIVES">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="TOP-FIVE">

	Generic:	No
	Purpose:	Displays a particular top five

-->

  <xsl:template match="TOP-FIVE">
    <xsl:variable name="topfivenumtoshow">
      <xsl:choose>
        <xsl:when test="@NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser'">5</xsl:when>
        <xsl:otherwise>100</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div xsl:use-attribute-sets="topfivetitle">
      <xsl:value-of select="TITLE"/>
    </div>
    <div class="topfivelist">
      <xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;= $topfivenumtoshow]|TOP-FIVE-FORUM[position() &lt;= $topfivenumtoshow]"/>
    </div>
  </xsl:template>

  <!--

	<xsl:template match="TOP-FIVE-ARTICLE">

	Generic:	No
	Purpose:	Displays one of the top five items

-->

  <xsl:template match="TOP-FIVE-ARTICLE">
    <li xsl:use-attribute-sets="topfiveitem">
      <a href="{$root}A{H2G2ID}">
        <xsl:value-of select="SUBJECT"/>
      </a>
    </li>
  </xsl:template>

  <!--

	<xsl:template match="TOP-FIVE-FORUM">

	Generic:	No
	Purpose:	Displays one of the top five items

-->

  <xsl:template match="TOP-FIVE-FORUM">
    <li xsl:use-attribute-sets="topfiveitem">
      <a href="{$root}F{FORUMID}">
        <xsl:value-of select="SUBJECT"/>
      </a>
    </li>
  </xsl:template>

  <!--

	<xsl:template match="FORUMTHREADS">

	Generic:	No
	Purpose:	Displays a list of threads with skip links

-->

  <xsl:template match="FORUMTHREADS">
    <xsl:param name="url" select="'F'"/>
    <xsl:param name="target">_top</xsl:param>
    <!-- javascript for thread moving popup -->
    <script language="javascript">
      <xsl:comment>
        function moveThreadPopup(threadID)
        {
        // build a js string to popup a window to move the given thread to the currently selected destination
        var selectObject = 'document.forms.MoveThreadForm' + threadID + '.Select' + threadID;
        var forumID = eval(selectObject + '.options[' + selectObject + '.selectedIndex].value');
        var command = 'Move';

        // don't try to perform the move if we have no sensible destination
        if (forumID == 0)
        {
        command = 'Fetch';
        }
        return eval('window.open(\'<xsl:value-of select="$root"/>MoveThread?cmd=' + command + '?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\', \'MoveThread\', \'scrollbars=1,resizable=1,width=300,height=230\')');
        }
        //
      </xsl:comment>
    </script>
    <div align="CENTER">
      <xsl:choose>
        <xsl:when test="@SKIPTO != 0">
          <a href="{$root}FFO{@FORUMID}?skip=0&amp;show={@COUNT}">

            [ <xsl:value-of select="$m_newest"/> ]
          </a>
          <xsl:variable name="alt">
            [ <xsl:value-of select="number(@SKIPTO) - number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO)"/> ]
          </xsl:variable>
          <a href="{$root}FFO{@FORUMID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}">
            <xsl:value-of select="$alt"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          [ <xsl:value-of select="$m_newest"/> ]
          [ <xsl:value-of select="$m_newer"/> ]
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="@MORE">
          <xsl:variable name="alt">
            [ <xsl:value-of select="number(@SKIPTO) + number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO) + number(@COUNT) + number(@COUNT)"/> ]
          </xsl:variable>
          <a href="{$root}FFO{@FORUMID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}">
            <xsl:value-of select="$alt"/>
          </a>
          <a href="{$root}FFO{@FORUMID}?skip={floor((number(@TOTALTHREADS)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}">
            [ <xsl:value-of select="$m_oldest"/> ]
          </a>
        </xsl:when>
        <xsl:otherwise>
          [ <xsl:value-of select="$m_older"/> ]
          [ <xsl:value-of select="$m_oldest"/> ]
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <xsl:call-template name="forumpostblocks">
        <xsl:with-param name="forum" select="@FORUMID"/>
        <xsl:with-param name="skip" select="0"/>
        <xsl:with-param name="show" select="@COUNT"/>
        <xsl:with-param name="total" select="@TOTALTHREADS"/>
        <xsl:with-param name="this" select="@SKIPTO"/>
        <xsl:with-param name="url" select="'FFO'"/>
        <xsl:with-param name="objectname" select="'Conversations'"/>
        <xsl:with-param name="target"/>
        <xsl:with-param name="blocklimit" select="20"/>
      </xsl:call-template>
    </div>

    <TABLE width="100%" cellpadding="2" cellspacing="0" border="0">
      <xsl:for-each select="THREAD">
        <xsl:choose>
          <xsl:when test="number(../../FORUMTHREADHEADERS/@THREADID) = number(THREADID)">
            <TR>
              <TD bgColor="{$ftbgcoloursel}" colspan="2">
                <xsl:element name="A">
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;skip=0&amp;show=20
                  </xsl:attribute>
                  <xsl:attribute name="TARGET">
                    <xsl:value-of select="$target"/>
                  </xsl:attribute>
                  <B>
                    <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
                  </B>
                </xsl:element>

              </TD>
            </TR>
            <TR>
              <TD bgColor="{$ftbgcoloursel}" width="69%" colspan="2">
                <span class="lastposting">
                  <xsl:value-of select="$m_lastposting"/>
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;latest=1
                    </xsl:attribute>
                    <xsl:attribute name="TARGET">
                      <xsl:value-of select="$target"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="DATEPOSTED"/>
                  </xsl:element>
                </span>
              </TD>
            </TR>
          </xsl:when>
          <xsl:otherwise>
            <TR>
              <TD colspan="2">
                <xsl:element name="A">
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;skip=0&amp;show=20
                  </xsl:attribute>
                  <xsl:attribute name="TARGET">
                    <xsl:value-of select="$target"/>
                  </xsl:attribute>
                  <B>
                    <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
                  </B>
                </xsl:element>
              </TD>
            </TR>
            <TR>
              <TD width="69%">
                <span class="lastposting">
                  <xsl:value-of select="$m_lastposting"/>
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;latest=1
                    </xsl:attribute>
                    <xsl:attribute name="TARGET">
                      <xsl:value-of select="$target"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="DATEPOSTED"/>
                  </xsl:element>
                </span>
              </TD>
            </TR>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </TABLE>

  </xsl:template>

  <!--IL

	<xsl:template match="navbuttons">

	Generic:	Yes
	Purpose:	Navigation buttons

-->

  <xsl:template name="navbuttons">
    <xsl:param name="URL"/>
    <xsl:param name="ID"/>
    <xsl:param name="ExtraParameters"/>
    <xsl:param name="shownewest">
      <xsl:value-of select="$m_newest"/>
    </xsl:param>
    <xsl:param name="showoldestconv">
      <xsl:value-of select="$m_oldest"/>
    </xsl:param>
    <xsl:param name="Previous" select="$m_newer"/>
    <xsl:param name="Next" select="$m_older"/>
    <xsl:param name="Skip" select="@SKIPTO"/>
    <xsl:param name="Show" select="@COUNT"/>
    <xsl:param name="Total" select="@TOTAL"/>
    <br/>
    <xsl:choose>
      <xsl:when test="$Skip != 0">
        <xsl:variable name="alt">
          [ <xsl:value-of select="number($Skip) - number($Show) + 1"/>-<xsl:value-of select="number($Skip)"/> ]
        </xsl:variable>
        <a href="{$root}{$URL}{$ID}?skip=0&amp;show={$Show}{$ExtraParameters}">
          [ <xsl:value-of select="$shownewest"/> ]
        </a>
        <a href="{$root}{$URL}{$ID}?skip={number($Skip) - number($Show)}&amp;show={$Show}{$ExtraParameters}">
          <xsl:value-of select="$alt"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        [ <xsl:value-of select="$shownewest"/> ]
        [ <xsl:value-of select="$Previous"/> ]
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="@MORE">
        <xsl:variable name="alt">
          [ <xsl:value-of select="number($Skip) + number($Show) + 1"/>-<xsl:value-of select="number($Skip) + number($Show) + number($Show)"/> ]
        </xsl:variable>
        <a href="{$root}{$URL}{$ID}?skip={number($Skip) + number($Show)}&amp;show={$Show}{$ExtraParameters}">
          <xsl:value-of select="$alt"/>
        </a>
        <a href="{$root}{$URL}{$ID}?skip={floor((number($Total)-1) div number($Show)) * number($Show)}&amp;show={$Show}{$ExtraParameters}">
          [ <xsl:value-of select="$showoldestconv"/> ]
        </a>
      </xsl:when>
      <xsl:otherwise>
        [ <xsl:value-of select="$Next"/> ]
        [ <xsl:value-of select="$showoldestconv"/> ]
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="threadnavbuttons">
    <!-- this is deprecated - please use match="@SKIPTO" mode="navbuttons" - TW -->
    <xsl:param name="URL">FFO</xsl:param>
    <xsl:param name="ID">
      <xsl:value-of select="@FORUMID"/>
    </xsl:param>
    <xsl:param name="ExtraParameters"/>
    <xsl:if test="(number(@SKIPTO) != 0) or (@MORE)">
      <br/>
      <xsl:choose>
        <xsl:when test="@SKIPTO != 0">
          <!--
		<a href="{$root}{$URL}{$ID}?skip=0&amp;show={@COUNT}{$ExtraParameters}">
			
				[ <xsl:value-of select="$m_newest"/> ]
		</a>
-->
          <xsl:variable name="alt">
            [ <xsl:value-of select="number(@SKIPTO) - number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO)"/> ]
          </xsl:variable>
          <a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
            <xsl:value-of select="$alt"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <!--
		[ <xsl:value-of select="$m_newest"/> ]
-->
          [ <xsl:value-of select="$m_newer"/> ]
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="@MORE">
          <xsl:variable name="alt">
            [ <xsl:value-of select="number(@SKIPTO) + number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO) + number(@COUNT) + number(@COUNT)"/> ]
          </xsl:variable>
          <a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
            <xsl:value-of select="$alt"/>
          </a>
          <!--
		<a href="{$root}{$URL}{$ID}?skip={floor((number(@TOTALTHREADS)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
				[ <xsl:value-of select="$m_oldest"/> ]
		</a>
-->
        </xsl:when>
        <xsl:otherwise>
          [ <xsl:value-of select="$m_older"/> ]
          <!--
		[ <xsl:value-of select="$m_oldest"/> ]
-->
        </xsl:otherwise>
      </xsl:choose>
      <br/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template mode="nosubject" match="SUBJECT">

	Generic:	Yes
	Purpose:	Displays a SUBJECT tag or shows 'No subject' if it doesn't exist

-->

  <xsl:template match="SUBJECT" mode="nosubject">
    <xsl:choose>
      <xsl:when test=".=''">
        <xsl:value-of select="$m_nosubject"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="DATEPOSTED">

	Generic:	Yes
	Purpose:	-

-->

  <xsl:template match="DATEPOSTED">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="DATEUPDATED">

	Generic:	Yes
	Purpose:	-

-->

  <xsl:template match="DATEUPDATED">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="DATE">

	Generic:	Yes
	Purpose:	Displays a date

-->

  <xsl:template match="DATE">
    <xsl:choose>
      <xsl:when test="@RELATIVE">
        <xsl:value-of select="@RELATIVE"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="absolute"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	Display the date and forces absolute rather than relative date format
-->

  <xsl:template match="DATE" mode="absolute">
    <xsl:value-of select="@DAYNAME"/>&nbsp;
    <xsl:value-of select="@DAY"/>&nbsp;
    <xsl:value-of select="@MONTHNAME"/>&nbsp;
    <xsl:value-of select="@YEAR"/>,&nbsp;
    <xsl:value-of select="@HOURS"/>:<xsl:value-of select="@MINUTES"/> GMT
  </xsl:template>

  <!--
	Displays the absolute date in a shortened format
-->

  <xsl:template match="DATE" mode="short">
    <nobr>
      <xsl:value-of select="@DAY"/>
      <xsl:value-of select="$m_ShortDateDelimiter"/>
      <xsl:value-of select="@MONTH"/>
      <xsl:value-of select="$m_ShortDateDelimiter"/>
      <xsl:value-of select="@YEAR"/>
    </nobr>
  </xsl:template>

  <!--
	<xsl:template name="DATE" mode="short1">
	Author:		Igor Loboda
	Generic:	Yes
	Inputs:		-
	Purpose:	Displays date in the following format:28 March 2002
-->
  <xsl:template match="DATE" mode="short1">
    <xsl:value-of select="@DAY"/>
    &nbsp;
    <xsl:value-of select="@MONTHNAME"/>
    &nbsp;
    <xsl:value-of select="@YEAR"/>
  </xsl:template>

  <!--

	<xsl:template match="FORUMPAGE">

	Generic:	No (and incomplete)
	Purpose:	Single page forum handling

-->

  <xsl:template match="FORUMPAGE">
    <xsl:apply-templates select="FORUMSOURCE"/>
    <br/>
    <xsl:choose>
      <xsl:when test="FORUMTHREADS">
        Here are some more conversations, starting at number <xsl:value-of select="number(FORUMTHREADS/@SKIPTO)+1"/>.<br/><br/>
        <xsl:apply-templates select="FORUMTHREADS">
          <xsl:with-param name="url" select="'FP'"/>
          <xsl:with-param name="target" select="''"/>
        </xsl:apply-templates>
        <br/>
        <xsl:if test="FORUMTHREADS/@MORE">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID"/>?skip=<xsl:value-of select="number(FORUMTHREADS/@SKIPTO) + number(FORUMTHREADS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>Click here for older conversations
          </A>
          <br/>
        </xsl:if>
        <xsl:if test="number(FORUMTHREADS/@SKIPTO) &gt; 0">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID"/>?skip=<xsl:value-of select="number(FORUMTHREADS/@SKIPTO) - number(FORUMTHREADS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>Click here for newer conversations
          </A>
        </xsl:if>
      </xsl:when>


      <xsl:when test="FORUMTHREADPOSTS">
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          Click here to return to the list of conversations
        </A>
        <br/>
        <xsl:if test="FORUMTHREADPOSTS[@SKIPTO &gt; 0]">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see older posts
          </A>
          <br/>
        </xsl:if>

        <xsl:if test="FORUMTHREADPOSTS/@MORE">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see newer posts
          </A>
          <br/>
        </xsl:if>

        <xsl:apply-templates select="FORUMTHREADPOSTS">
          <xsl:with-param name="ptype" select="'page'"/>
        </xsl:apply-templates>
        <br/>
        <xsl:if test="FORUMTHREADPOSTS[@SKIPTO &gt; 0]">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see older posts
          </A>
          <br/>
        </xsl:if>

        <xsl:if test="FORUMTHREADPOSTS/@MORE">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see newer posts
          </A>
          <br/>
        </xsl:if>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
        <br/>
      </xsl:when>
      <xsl:when test="FORUMTHREADHEADERS">
        <xsl:apply-templates select="FORUMTHREADHEADERS"/>
        <br/>

        <xsl:if test="FORUMTHREADHEADERS[@SKIPTO &gt; 0]">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see older posts
          </A>
          <br/>
        </xsl:if>

        <xsl:if test="FORUMTHREADHEADERS/@MORE">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">_top</xsl:attribute>
            Click to see newer posts
          </A>
          <br/>
        </xsl:if>

      </xsl:when>


      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- I think this is redundant... -->

  <xsl:variable name="lastsubject"/>

  <!--

	<xsl:template match="FORUMTHREADHEADERS">

	Purpose:	Overridden below?

-->

  <xsl:template match="FORUMTHREADHEADERS">
    <xsl:value-of select="$m_currentconv"/>:<br/>
    <xsl:variable name="lastsubject"/>
    <xsl:for-each select="POST">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <!--

	<xsl:template match="FORUMTHREADHEADERS">

	Generic:	Yes
	Purpose:	Drill into the thread headers, setting an appropriate mode

-->

  <xsl:template match="FORUMTHREADHEADERS">
    <xsl:apply-templates mode="single" select="POST"/>
  </xsl:template>

  <!--

	<xsl:template match="FORUMTHREADPOSTS">

	Generic:	Yes
	Parameters:	ptype - 'frame' if the posts should display frame links, otherwise 
						should display single-page links
	Purpose:	Displays the list of posts

-->

  <xsl:template match="FORUMTHREADPOSTS">
    <xsl:param name="ptype" select="'frame'"/>
    <xsl:apply-templates select="POST">
      <xsl:with-param name="ptype">
        <xsl:value-of select="$ptype"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!--
<xsl:template match="FORUMTHREADPOSTS" mode="makelink">
blardy blardy blardy
</xsl:template>
-->

  <!--

	<xsl:template mode="many" match="FORUMTHREADHEADERS/POST">

	Generic:	No - in fact Alabaster has FORUMTHREADHEADERS template as well
	Purpose:	-

-->

  <xsl:template match="FORUMTHREADHEADERS/POST" mode="many">
    <TR align="left">
      <!--<TD nowrap="1" valign="top">&nbsp;</TD>-->
      <TD colspan="2" nowrap="1" valign="top">
        <span class="fthreadheaders">
          <A target="messages" href="{$root}FFM{../@FORUMID}?thread={../@THREADID}&amp;skip={../@SKIPTO}&amp;show={../@COUNT}#p{@POSTID}">
            <xsl:value-of select="position() + number(../@SKIPTO)"/>
          </A>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
        </span>
      </TD>
      <TD nowrap="1">
        <DIV class="browse">
          <xsl:element name="A">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>FFM<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>#p<xsl:value-of select="@POSTID"/>
            </xsl:attribute>
            <xsl:attribute name="TARGET">messages</xsl:attribute>
            <!--
<xsl:choose>
<xsl:when test="position()=1 and number(../@SKIPTO)=0">
<IMG SRC="{$imagesource}threadtop.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:when test="position() != 20 or number(../@MORE)=1">
<IMG SRC="{$imagesource}thread2.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:otherwise>
<IMG SRC="{$imagesource}thread.gif" width="13" height="13" border="0"/>
</xsl:otherwise>
</xsl:choose>
-->
            <!--<IMG SRC="{$imagesource}threadicon.gif" border="0"/>-->
            <xsl:if test="SUBJECT[@SAME!='1']">
              <B>
                <xsl:value-of select="SUBJECT"/>
              </B>
              <BR/>
              <!--
<xsl:choose>
<xsl:when test="position() != 20 or number(../@MORE)=1">
<IMG SRC="{$imagesource}threadline.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:otherwise>
<IMG SRC="{$imagesource}threadblank.gif" width="13" height="13" border="0"/></xsl:otherwise>
</xsl:choose>-->
              <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
            </xsl:if>
            <xsl:if test="not(@HIDDEN &gt; 0)">
              <xsl:apply-templates select="USER/USERNAME"/>
            </xsl:if>
            (<xsl:apply-templates select="DATEPOSTED"/>)
          </xsl:element>
        </DIV>
      </TD>
    </TR>


    <!--
<NOBR>
<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root"/>FFM<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@POSTID" /></xsl:attribute>
<xsl:attribute name="TARGET">messages</xsl:attribute>
<IMG border="0" src="{$imagesource}threadicon.gif"/>
<xsl:choose>
<xsl:when test="SUBJECT[@SAME='1']">
...
</xsl:when>
<xsl:otherwise>
<b><xsl:value-of select="SUBJECT" /></b>
</xsl:otherwise>
</xsl:choose>
(<xsl:apply-templates select="USER/USERNAME" />, <xsl:apply-templates select="DATEPOSTED" />)
</xsl:element>
</NOBR><br />
-->
  </xsl:template>

  <!--

	<xsl:template mode="single" match="FORUMTHREADHEADERS/POST">

	Generic:	No
	Purpose:	Single page posts

-->

  <xsl:template match="FORUMTHREADHEADERS/POST" mode="single">
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>FSP<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;post=<xsl:value-of select="@POSTID"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="SUBJECT[@SAME='1']">
          ...
        </xsl:when>
        <xsl:otherwise>
          <b>
            <xsl:value-of select="SUBJECT"/>
          </b>
        </xsl:otherwise>
      </xsl:choose>
      (<xsl:value-of select="USER/USERNAME"/>, <xsl:apply-templates select="DATEPOSTED"/>)
    </xsl:element>
    <br/>
  </xsl:template>




  <xsl:template name="showtreegadget">
    <xsl:param name="ptype" select="'frame'"/>
    <TABLE cellpadding="0" cellspacing="0" BORDER="0">
      <TR>
        <TD xsl:use-attribute-sets="cellstyle">
          <span xsl:use-attribute-sets="gadgetfont">&nbsp;</span>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <xsl:choose>
            <xsl:when test="@INREPLYTO">
              <xsl:attribute name="bgcolor">yellow</xsl:attribute>
              <xsl:choose>
                <xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
                  <A>
                    <xsl:attribute name="HREF">
                      #p<xsl:value-of select="@INREPLYTO"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_replyingtothis"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">^</span>
                  </A>
                </xsl:when>
                <xsl:otherwise>
                  <A>
                    <xsl:if test="$ptype='frame'">
                      <xsl:attribute name="target">twosides</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:choose>
                        <xsl:when test="$ptype='frame'">FLR</xsl:when>
                        <xsl:otherwise>F</xsl:otherwise>
                      </xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@INREPLYTO"/>#p<xsl:value-of select="@INREPLYTO"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_replyingtothis"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">^</span>
                  </A>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <span xsl:use-attribute-sets="gadgetfont">
                <xsl:text>^</xsl:text>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <span xsl:use-attribute-sets="gadgetfont">&nbsp;</span>
        </TD>
      </TR>
      <TR>
        <TD xsl:use-attribute-sets="cellstyle">
          <xsl:choose>
            <xsl:when test="@PREVSIBLING">
              <xsl:attribute name="bgcolor">yellow</xsl:attribute>
              <xsl:choose>
                <xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
                  <A>
                    <xsl:attribute name="HREF">
                      #p<xsl:value-of select="@PREVSIBLING"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_prevreply"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">&lt;</span>
                  </A>
                </xsl:when>
                <xsl:otherwise>
                  <A>
                    <xsl:if test="$ptype='frame'">
                      <xsl:attribute name="target">_top</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:choose>
                        <xsl:when test="$ptype='frame'">F</xsl:when>
                        <xsl:otherwise>F</xsl:otherwise>
                      </xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@PREVSIBLING"/>#p<xsl:value-of select="@PREVSIBLING"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_prevreply"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">&lt;</span>
                  </A>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <span xsl:use-attribute-sets="gadgetfont">
                <xsl:text>&lt;</xsl:text>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <span xsl:use-attribute-sets="gadgetfont">o</span>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <xsl:choose>
            <xsl:when test="@NEXTSIBLING">
              <xsl:attribute name="bgcolor">yellow</xsl:attribute>
              <xsl:choose>
                <xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
                  <A>
                    <xsl:attribute name="HREF">
                      #p<xsl:value-of select="@NEXTSIBLING"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_nextreply"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">&gt;</span>
                  </A>
                </xsl:when>
                <xsl:otherwise>
                  <A>
                    <xsl:if test="$ptype='frame'">
                      <xsl:attribute name="target">twosides</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:choose>
                        <xsl:when test="$ptype='frame'">FLR</xsl:when>
                        <xsl:otherwise>F</xsl:otherwise>
                      </xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@NEXTSIBLING"/>#p<xsl:value-of select="@NEXTSIBLING"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$alt_nextreply"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">&gt;</span>
                  </A>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <span xsl:use-attribute-sets="gadgetfont">
                <xsl:text>&gt;</xsl:text>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </TD>
      </TR>
      <TR>
        <TD xsl:use-attribute-sets="cellstyle">
          <span xsl:use-attribute-sets="gadgetfont">&nbsp;</span>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <xsl:choose>
            <xsl:when test="@FIRSTCHILD">
              <xsl:attribute name="bgcolor">yellow</xsl:attribute>
              <xsl:choose>
                <xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
                  <A>
                    <xsl:attribute name="HREF">
                      #p<xsl:value-of select="@FIRSTCHILD"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$m_firstreplytothis"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">V</span>
                  </A>
                </xsl:when>
                <xsl:otherwise>
                  <A>
                    <xsl:if test="$ptype='frame'">
                      <xsl:attribute name="target">twosides</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$root"/><xsl:choose>
                        <xsl:when test="$ptype='frame'">FLR</xsl:when>
                        <xsl:otherwise>F</xsl:otherwise>
                      </xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@FIRSTCHILD"/>#p<xsl:value-of select="@FIRSTCHILD"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$m_firstreplytothis"/>
                    </xsl:attribute>
                    <span xsl:use-attribute-sets="gadgetfont">V</span>
                  </A>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <span xsl:use-attribute-sets="gadgetfont">
                <xsl:text>V</xsl:text>
              </span>
            </xsl:otherwise>
          </xsl:choose>
        </TD>
        <TD xsl:use-attribute-sets="cellstyle">
          <span xsl:use-attribute-sets="gadgetfont">&nbsp;</span>
        </TD>
      </TR>
    </TABLE>
  </xsl:template>

  <xsl:template name="showpostbody">
    <xsl:choose>
      <xsl:when test="@HIDDEN = 1">
        <xsl:call-template name="m_postremoved"/>
      </xsl:when>
      <xsl:when test="@HIDDEN = 2">
        <xsl:call-template name="m_postawaitingmoderation"/>
      </xsl:when>
      <xsl:when test="@HIDDEN = 3">
        <xsl:call-template name="m_postawaitingpremoderation"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="TEXT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="postsubject">
    <xsl:choose>
      <xsl:when test="@HIDDEN = 1">
        <xsl:value-of select="$m_postsubjectremoved"/>
      </xsl:when>
      <xsl:when test="@HIDDEN = 2">
        <xsl:value-of select="$m_awaitingmoderationsubject"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="SUBJECT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="POST/TEXT">

	Generic:	Yes
	Purpose:	Display the text of a post

-->

  <xsl:template match="POST/TEXT">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="BOX">

	Generic:	Yes
	Purpose:	Handle the BOX tag

-->

  <xsl:template match="BOX">
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="TITLE"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <span xsl:use-attribute-sets="boxfont">
        <xsl:apply-templates select="TEXT"/>
      </span>
    </blockquote>
  </xsl:template>

  <!--

	<xsl:template match="BOX/TEXT">

	Generic:	Yes
	Purpose:	Displays the text of the box tag

-->

  <xsl:template match="BOX/TEXT">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <!--

	<xsl:template match = "FORUMSOURCE/ARTICLE">

	Generic:	Yes
	Purpose:	Displays the source of the forum

-->

  <xsl:template match="FORUMSOURCE/ARTICLE">
    <span xsl:use-attribute-sets="forumsource">
      <B>
        <xsl:value-of select="$m_thisconvforentry"/>
        <a xsl:use-attribute-sets="mFORUMSOURCEARTICLE">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          <span xsl:use-attribute-sets="forumsourcelink">
            <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
          </span>
        </a>
      </B>
    </span>
  </xsl:template>

  <!--

	<xsl:template match = "FORUMSOURCE/JOURNAL">

	Generic:	Yes
	Purpose:	Displays the source of the forum

-->

  <xsl:template match="FORUMSOURCE/JOURNAL">
    <span xsl:use-attribute-sets="forumsource">
      <B>
        <xsl:value-of select="$m_thisjournal"/>
        <a xsl:use-attribute-sets="mFORUMSOURCEJOURNAL">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          <span xsl:use-attribute-sets="forumsourcelink">
            <xsl:value-of select="USER/USERNAME"/>
          </span>
        </a>
      </B>
    </span>
  </xsl:template>

  <!--

	<xsl:template match = "FORUMSOURCE/USERPAGE">

	Generic:	Yes
	Purpose:	<xsl:template match = "FORUMSOURCE/USERPAGE">

-->

  <xsl:template match="FORUMSOURCE/USERPAGE">
    <span xsl:use-attribute-sets="forumsource">
      <B>
        <xsl:value-of select="$m_thismessagecentre"/>
        <a xsl:use-attribute-sets="mFORUMSOURCEUSERPAGE">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          <span xsl:use-attribute-sets="forumsourcelink">
            <xsl:value-of select="USER/USERNAME"/>
          </span>
        </a>
      </B>
    </span>
  </xsl:template>

  <!--

	<xsl:template match = "FORUMSOURCE/USERPAGE">

	Generic:	Yes
	Purpose:	<xsl:template match = "FORUMSOURCE/USERPAGE">

-->

  <xsl:template match="FORUMSOURCE/REVIEWFORUM">
    <span xsl:use-attribute-sets="forumsource">
      <B>
        <xsl:value-of select="$m_thisconvforentry"/>
        <a xsl:use-attribute-sets="mFORUMSOURCEREVIEWFORUM">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>RF<xsl:value-of select="@ID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          <span xsl:use-attribute-sets="forumsourcelink">
            <xsl:value-of select="REVIEWFORUMNAME"/>
          </span>
        </a>
      </B>
    </span>
  </xsl:template>

  <!--

	<xsl:template match="RECENT-ENTRIES">

	Generic:	No
	Purpose:	Display the list of recent entries

-->

  <xsl:template match="RECENT-ENTRIES">
    <xsl:choose>
      <xsl:when test="$ownerisviewer = 1">
        <xsl:choose>
          <xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
            <!-- owner, full-->
            <xsl:call-template name="m_artownerfull"/>
            <xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
            <br/>
            <A>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2
              </xsl:attribute>
              <xsl:value-of select="$m_clickmoreentries"/>
            </A>
            <br/>
            <br/>
            <a href="{$root}useredit">
              <xsl:value-of select="$m_clicknewentry"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <!-- owner empty-->
            <xsl:call-template name="m_artownerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
            <!-- visitor full-->
            <xsl:call-template name="m_artviewerfull"/>
            <xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
            <br/>
            <A>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2
              </xsl:attribute>
              <xsl:value-of select="$m_clickmoreentries"/>
            </A>
            <br/>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <!-- visitor empty-->
            <xsl:call-template name="m_artviewerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="RECENT-APPROVALS">

	Generic:	No
	Purpose:	Recent edited guide entries

-->

  <xsl:template match="RECENT-APPROVALS">
    <xsl:choose>
      <xsl:when test="$ownerisviewer = 1">
        <xsl:choose>
          <xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
            <xsl:call-template name="m_editownerfull"/>
            <xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
            <br/>
            <A>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1
              </xsl:attribute>
              <xsl:value-of select="$m_clickmoreedited"/>
            </A>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="m_editownerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
            <xsl:call-template name="m_editviewerfull"/>
            <xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
            <br/>
            <A>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1
              </xsl:attribute>
              <xsl:value-of select="$m_clickmoreedited"/>
            </A>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="m_editviewerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="ARTICLE-LIST/ARTICLE">

	Generic:	Yes
	Purpose:	Displays articles from a list of articles with status and edit links

-->

  <xsl:template match="ARTICLE-LIST/ARTICLE">
    <xsl:apply-templates select="SITEID" mode="showfrom"/>:
    <A>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/>
      </xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
    </A>
    &nbsp;<xsl:value-of select="SUBJECT"/> (<xsl:apply-templates select="DATE-CREATED/DATE"/>)
    <xsl:choose>
      <xsl:when test="STATUS = 7">
        <xsl:value-of select="$m_cancelled"/>
        <xsl:if test="($ownerisviewer = 1)">
          (<A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>?cmd=undelete
            </xsl:attribute>
            <xsl:value-of select="$m_uncancel"/>
          </A>)
        </xsl:if>
      </xsl:when>
      <xsl:when test="STATUS &gt; 3 and STATUS != 7">
        <!--
			<xsl:if test="($ownerisviewer = 1)">
				<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>&amp;cmd=unconsider</xsl:attribute>(unsubmit)</A>
			</xsl:if>
-->
        <!-- show entry as 'pending' when it is waiting to go official -->
        <xsl:choose>
          <xsl:when test="STATUS = 13 or STATUS = 6">
            <xsl:value-of select="$m_pending"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_recommended"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!--
		<xsl:when test=".[STATUS = 1]"> pending</xsl:when>
-->
    </xsl:choose>
    <!--	<xsl:if test="($ownerisviewer = 1) and .[STATUS = 3 or STATUS = 4]">-->
    <xsl:if test="($ownerisviewer = 1) and (STATUS = 3 or STATUS = 4) and (EDITOR/USER/USERID = $viewerid)">
      &nbsp;<A>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>
        </xsl:attribute>
        <xsl:value-of select="$m_edit"/>
      </A>
    </xsl:if>
    <BR/>
  </xsl:template>

  <!--
	Displays username, but truncates names longer than 20 chars
-->

  <xsl:template match="USERNAME" mode="truncated">
    <xsl:variable name="UserName">
      <xsl:choose>
        <xsl:when test="string-length(.) &gt; 20">
          <xsl:value-of select="substring(., 1, 17)"/>...
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="../USERID &lt; 10000">
        <b>
          <i>
            <xsl:value-of select="$UserName"/>
          </i>
        </b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$UserName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="POSTTHREADUNREG">

	Generic:	Yes
	Purpose:	Message for unregistered posting to forums

-->

  <xsl:template match="POSTTHREADUNREG">
    <xsl:choose>
      <xsl:when test="@RESTRICTED = 1">
        <xsl:call-template name="m_cantpostrestricted"/>
      </xsl:when>
      <xsl:when test="@REGISTERED = 1">
        <xsl:call-template name="m_cantpostnoterms"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="m_cantpostnotregistered"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
  </xsl:template>

  <!--

	<xsl:template match="CATEGORISATION">

	Generic:	No
	Purpose:	Displays the categorisation box for the frontpage

-->

  <xsl:template match="CATEGORISATION">
    <table width="100%" border="0" cellspacing="0" cellpadding="8" bgcolor="{$catboxbg}">
      <tr>
        <td>
          <div class="browse">
            <!--
					<font size="2" face="{$fontface}" color="{$catboxtitle}"><b>Ask h2g2</b></font> 
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr bgcolor="{$boxfontcolour}"> 
							<td><img src="{$imagesource}blank.gif" width="{number($catboxwidth)-16}" height="1"/></td>
						</tr>
					</table>
-->
            <table width="100%" border="0" cellspacing="0" cellpadding="8">
              <tr>
                <td>
                  <div align="left" class="browse">
                    <xsl:apply-templates/>
                  </div>
                  <!--
								<div align="left"><font face="{$fontface}" size="1">[ 
									<A href="{$root}/DontPanic-Explore"><font color="{$catboxotherlink}">How do I browse 
									the Guide?</font></a> ]<br/>
									[ <A href="{$root}/search"><font color="{$catboxotherlink}">Power Search</font></a> 
									]</font>
								</div>
								<div align="left"><font size="1" face="{$fontface}">[ 
									<A href="{$root}/Askh2g2"> <font color="{$catboxotherlink}">Ask the h2g2 
									community</font></a> ]</font>
								</div>
-->
                </td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <img src="{$imagesource}blank.gif" width="{number($catboxwidth)-16}" height="1"/>
                </td>
              </tr>
            </table>
          </div>
          <!--
				<font size="2" face="{$fontface}" color="{$catboxtitle}"><b>Tell h2g2</b></font>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr bgcolor="{$boxfontcolour}"> 
						<td><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="8">
					<tr> 
						<td> 
							<div align="left"> 
								<p><font size="1" face="{$fontface}"><A href="{$root}/useredit"><b>Click 
								here</b></a> to add your own entry to the Guide</font></p>
							</div>
						</td>
					</tr>
				</table>
-->
        </td>
      </tr>
    </table>
    <br/>
  </xsl:template>

  <!--

	<xsl:template match="CATEGORISATION[CATBLOCK]">

	Generic:	No
	Purpose:	New categorisation handler - takes *all* its info from the
				categorisation section using the CATBLOCK, CATLINKITEM and 
				CATLINK tags.

-->

  <xsl:template match="CATEGORISATION[CATBLOCK]">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="CATBLOCK">

	Generic:	No
	Purpose:	Displays a section in the categorisation box.

-->

  <xsl:template match="CATBLOCK">
    <div class="catblock">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="CATBLOCK/TITLE">
    <div xsl:use-attribute-sets="catboxtitle">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <!--

	<xsl:template match="CATLINKITEM">

	Generic:	Yes
	Purpose:	A link which appears as an item on its own in the
				categorisation box

-->

  <xsl:template match="CATLINKITEM">
    [ <A href="{$root}{@HREF}">
      <span xsl:use-attribute-sets="catboxotherlink">
        <xsl:value-of select="."/>
      </span>
    </A> ]<br/>
  </xsl:template>

  <!--

	<xsl:template match="CATLINK">

	Generic:	Yes
	Purpose:	LINK tag for use in text in the categorisation box

-->

  <xsl:template match="CATLINK">
    <A href="{$root}{@HREF}">
      <span xsl:use-attribute-sets="catboxotherlink">
        <xsl:value-of select="."/>
      </span>
    </A>
  </xsl:template>

  <!--

	<xsl:template match="ONLYREGISTERED">

	Generic:	Yes
	Purpose:	Only output the contents of the tag if the user is registered

-->

  <xsl:template match="ONLYREGISTERED">
    <xsl:if test="$registered=1">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="ONLYUNREGISTERED">

	Generic:	Yes
	Purpose:	Only output contents if user is unregistered

-->

  <xsl:template match="ONLYUNREGISTERED">
    <xsl:if test="$registered=0">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="ONLYOWNER">

	Generic:	Yes
	Purpose:	Personal space only: Display contents if the viewer is also
				the page owner

-->

  <xsl:template match="ONLYOWNER">
    <xsl:if test="$ownerisviewer=1">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="NEVEROWNER">

	Generic:	Yes
	Purpose:	Personal space: Only show contents if the viewer is NOT
				the owner of the page.

-->

  <xsl:template match="NEVEROWNER">
    <xsl:if test="$ownerisviewer=0">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>

  <!--

	<xsl:template match="CATEGORY">

	Generic:	Yes
	Purpose:	Display the main category header and all the subcats

-->

  <xsl:template match="CATEGORY">
    <b>
      <a>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>C<xsl:value-of select="CATID"/>
        </xsl:attribute>
        <span xsl:use-attribute-sets="catboxmain">
          <u>
            <xsl:value-of select="NAME"/>
          </u>
        </span>
      </a>
    </b>
    <span xsl:use-attribute-sets="catboxsubtext">
      - <xsl:apply-templates select="SUBCATEGORY"/>
      ...
    </span>
    <br/>
    <br/>
  </xsl:template>

  <!--

	<xsl:template match="SUBCATEGORY">

	Generic:	Yes
	Purpose:	Display the sub category link

-->

  <xsl:template match="SUBCATEGORY">
    <xsl:if test="position()&gt;1">, </xsl:if>
    <a>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>C<xsl:value-of select="CATID"/>
      </xsl:attribute>
      <span xsl:use-attribute-sets="catboxsublink">
        <xsl:value-of select="NAME"/>
      </span>
    </a>
  </xsl:template>


  <!--

	<xsl:template match="PASSTHROUGH">

	Generic:	Yes
	Purpose:	Passes CDATA sections through

-->

  <xsl:template match="PASSTHROUGH">
    <xsl:variable name="contents">
      <xsl:value-of select="translate(.,$uppercase,$lowercase)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="(contains($contents,'&lt;script') and contains($contents,'cookie')) or (contains($contents,'document.cookie'))">
        <xsl:call-template name="m_illegaltext"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of disable-output-escaping="yes" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--

	<xsl:template match="PAGEUI/BANNER">

	Generic:	No
	Purpose:	Displays the banner ad

-->

  <xsl:template match="PAGEUI/BANNERism">
    <!--<img src="{$imagesource}banners/ripley.gif" width="468" height="60" vspace="0" hspace="0" border="0"/>-->
    <A TARGET="_h2g2banner">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>http://ad.uk.doubleclick.net/jump/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?
      </xsl:attribute>
      <IMG name="Ngui_01_03" height="60" width="468" border="0" vspace="0" hspace="0">
        <xsl:attribute name="SRC">
          http://ad.uk.doubleclick.net/ad/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?
        </xsl:attribute>
      </IMG>
    </A>
  </xsl:template>

  <xsl:template match="PAGEUI/BANNER">
    <xsl:choose>
      <xsl:when test="$ripleybanner = 1">
        <a target="_top" href="{$bannerurl}">
          <img src="{$bannersrc}" width="468" height="60" vspace="7" hspace="0" border="0"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <A TARGET="_h2g2banner">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>http://ad.uk.doubleclick.net/jump/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?
          </xsl:attribute>
          <IMG name="Ngui_01_03" height="60" width="468" border="0" vspace="7" hspace="0">
            <xsl:attribute name="SRC">
              http://ad.uk.doubleclick.net/ad/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?
            </xsl:attribute>
          </IMG>
        </A>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--

	<xsl:template match="WHO-IS-ONLINE">

	Generic:	Yes
	Purpose:	Does the pop-up users code

-->

  <xsl:template match="WHO-IS-ONLINE">
    <a href="javascript:popusers('{$root}online');">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!--

	<xsl:template match="POPUP">

	Generic:	Yes
	Purpose:	Pops up a window - identical to LINK POPUP="1" - never used AFAIK

-->

  <xsl:template match="POPUP">
    <a>
      <xsl:attribute name="HREF">
        javascript:popupwindow('<xsl:value-of select="@HREF"/>','<xsl:value-of select="@TARGET"/>','<xsl:value-of select="@STYLE"/>');
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!--

	<xsl:template match="A">

	Generic:	Yes
	Purpose:	Handler for A tags

-->

  <xsl:template match="A">
    <xsl:copy use-attribute-sets="mA">
      <xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
    </xsl:copy>
  </xsl:template>


  <!--

Attempt at User Edit Page by Kim
Created: 21/03/2000

-->

  <xsl:template name="articlepremoderationmessage">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/MODERATIONSTATUS[@NAME='PREMODERATED']">
        <xsl:call-template name="m_articleuserpremodblurb"/>
      </xsl:when>
      <xsl:when test="PREMODERATION=1">
        <xsl:call-template name="m_articlepremodblurb"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--

	<xsl:template match="USER-DETAILS-UNREG">

	Generic:	No
	Purpose:	User Details page when unregistered, new password req

-->

  <xsl:template match="USER-DETAILS-UNREG">
    <!--xsl:apply-templates select="MESSAGE"/-->
    <xsl:call-template name="m_unregprefsmessage"/>
    <!--TABLE vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
		<FORM METHOD="POST" action="{$root}UserDetails">
			<TR><INPUT NAME="unregcmd" TYPE="hidden" VALUE="submit" /></TR>
			<TR>
				<TD align="RIGHT"><xsl:value-of select="$m_loginname"/></TD>
				<TD>
					<INPUT NAME="loginname" TYPE="text" />
				</TD>
			</TR>
			<TR>
				<TD align="RIGHT"><xsl:value-of select="$m_oruserid"/></TD>
				<TD>
					<INPUT NAME="userid" TYPE="text" VALUE="{/H2G2/VIEWING-USER/USER/USERID}"/>
				</TD>
			</TR>
			<TR>
				<TD align="RIGHT"><xsl:value-of select="$m_emailaddress"/></TD>
				<TD>
					<INPUT NAME="email" TYPE="text" VALUE="{/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS}" />
				</TD>
			</TR>
			<TR>
				<TD align="RIGHT"></TD>
				<TD>
					<INPUT TYPE="submit" VALUE="Request New Password" />
				</TD>
			</TR>

		</FORM>
	</TABLE-->
    <br/>
  </xsl:template>

  <xsl:template match="USER-DETAILS-FORM/MESSAGE|USER-DETAILS-UNREG/MESSAGE">
    <xsl:choose>
      <xsl:when test="@TYPE='badpassword'">
        <xsl:call-template name="m_udbaddpassword"/>
      </xsl:when>
      <xsl:when test="@TYPE='invalidpassword'">
        <xsl:call-template name="m_udinvalidpassword"/>
      </xsl:when>
      <xsl:when test="@TYPE='unmatchedpasswords'">
        <xsl:call-template name="m_udunmatchedpasswords"/>
      </xsl:when>
      <xsl:when test="@TYPE='badpasswordforemail'">
        <xsl:call-template name="m_udbaddpasswordforemail"/>
      </xsl:when>
      <xsl:when test="@TYPE='newpasswordsent'">
        <xsl:call-template name="m_udnewpasswordsent"/>
      </xsl:when>
      <xsl:when test="@TYPE='newpasswordfailed'">
        <xsl:call-template name="m_udnewpasswordfailed"/>
      </xsl:when>
      <xsl:when test="@TYPE='detailsupdated'">
        <xsl:call-template name="m_uddetailsupdated"/>
      </xsl:when>
      <xsl:when test="@TYPE='skinset'">
        <xsl:call-template name="m_udskinset"/>
      </xsl:when>
      <xsl:when test="@TYPE='restricteduser'">
        <xsl:call-template name="m_udrestricteduser"/>
      </xsl:when>
      <xsl:when test="@TYPE='invalidemail'">
        <xsl:call-template name="m_udinvalidemail"/>
      </xsl:when>
      <xsl:when test="@TYPE='usernamepremoderated'">
        <xsl:call-template name="m_udusernamepremoderated"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="skindropdown">
    <xsl:param name="localskinname">
      <xsl:value-of select="$skinname"/>
    </xsl:param>
    <xsl:apply-templates select="msxsl:node-set($skinlist)/*">
      <!--<xsl:apply-templates select="$skinlist">-->
      <xsl:with-param name="localskinname">
        <xsl:value-of select="$localskinname"/>
      </xsl:with-param>
    </xsl:apply-templates>
    <!--
	<xsl:choose>
		<xsl:when test="$localskinname='Classic'">
			<OPTION VALUE="Classic" SELECTED="1">Classic GOO</OPTION>
			<OPTION VALUE="Simple">Simple</OPTION>
			<OPTION VALUE="Alabaster">Alabaster</OPTION>
		</xsl:when>
		<xsl:when test="$localskinname='Simple'">
			<OPTION VALUE="Classic">Classic GOO</OPTION>
			<OPTION VALUE="Simple" SELECTED="1">Simple</OPTION>
			<OPTION VALUE="Alabaster">Alabaster</OPTION>
		</xsl:when>
		<xsl:otherwise>
			<OPTION VALUE="Classic">Classic GOO</OPTION>
			<OPTION VALUE="Simple">Simple</OPTION>
			<OPTION VALUE="Alabaster" SELECTED="1">Alabaster</OPTION>
		</xsl:otherwise>
	</xsl:choose>
-->
  </xsl:template>

  <xsl:template match="SKINDEFINITION">
    <xsl:param name="localskinname">
      <xsl:value-of select="$skinname"/>
    </xsl:param>
    <OPTION VALUE="{NAME}">
      <xsl:if test="$localskinname = string(NAME)">
        <xsl:attribute name="SELECTED">1</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="DESCRIPTION"/>
    </OPTION>
  </xsl:template>


  <!--
	Special case for when visiting the UserPage with a secret key to confirm your
	registration.
-->


  <!--

	<xsl:template match="POST-LIST|ARTICLE-LIST">

	Generic:	Yes
	Purpose:	display the articles or posts in the list

-->

  <xsl:template match="POST-LIST|ARTICLE-LIST">
    <xsl:apply-templates select="POST[@PRIVATE=0]|ARTICLE"/>
  </xsl:template>

  <!--

	<xsl:template match="ENTITY"><xsl:text disable-output-escaping="yes">&amp;</xsl:text><xsl:value-of select="@TYPE|@type"/>;</xsl:template>

	Generic:	Yes
	Purpose:	Pass through an entity.

-->

  <xsl:template match="ENTITY">
    <xsl:text disable-output-escaping="yes">&amp;</xsl:text><xsl:value-of select="@TYPE|@type"/>;
  </xsl:template>

  <!--

	<xsl:template match="USERNAME" mode="simple">

	Generic:	Unknown
	Purpose:	Unknown

-->

  <xsl:template match="USERNAME" mode="simple">
    <xsl:apply-templates/>
  </xsl:template>

  <!--

	<xsl:template match="BOXHOLDER">

	Generic:	No - only in Classic
	Purpose:	Display two columns

-->

  <xsl:template match="BOXHOLDER">
    <xsl:for-each select="BOX">
      <xsl:if test="position() mod 2 = 1">
        <xsl:variable name="pos">
          <xsl:value-of select="position()"/>
        </xsl:variable>
        <br clear="all"/>
        <table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
          <tr>
            <td bgcolor="{$boxholderleftcolour}">
              <b>
                <span class="boxholdertitle">
                  <xsl:value-of select="TITLE"/>
                </span>
              </b>
            </td>
            <td bgcolor="{$boxholderrightcolour}">
              <b>
                <span class="boxholdertitle">
                  <xsl:value-of select="../BOX[$pos+1]/TITLE"/>
                </span>
              </b>
            </td>
          </tr>
          <tr>
            <td valign="top" align="left" width="50%">
              <p>
                <br/>
                <xsl:apply-templates select="TEXT"/>
              </p>
            </td>
            <td valign="top" align="left" width="50%">
              <p>
                <br/>
                <xsl:apply-templates select="../BOX[$pos+1]/TEXT"/>
              </p>
            </td>
          </tr>
        </table>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--

	<xsl:template name="forumpostblocks">

	Generic:	No
	Purpose:	Show one item per block

-->

  <xsl:template name="forumpostblocks">
    <xsl:param name="attributes"/>
    <xsl:param name="thread"/>
    <xsl:param name="forum"/>
    <xsl:param name="total"/>
    <xsl:param name="show">20</xsl:param>
    <xsl:param name="skip">0</xsl:param>
    <xsl:param name="this">0</xsl:param>
    <xsl:param name="url">F</xsl:param>
    <xsl:param name="blocklimit">0</xsl:param>
    <xsl:param name="splitevery">0</xsl:param>
    <xsl:param name="objectname">
      <xsl:value-of select="$m_postings"/>
    </xsl:param>
    <xsl:param name="target">_top</xsl:param>
    <xsl:param name="ExtraParameters"/>
    <xsl:variable name="limit">
      <xsl:value-of select="number($blocklimit) * $show"/>
    </xsl:variable>
    <xsl:variable name="postblockon">
      <xsl:value-of select="$imagesource2"/>buttons/forumselected.gif
    </xsl:variable>
    <xsl:variable name="postblockoff">
      <xsl:value-of select="$imagesource2"/>buttons/forumunselected.gif
    </xsl:variable>
    <xsl:variable name="lower">
      <xsl:choose>
        <xsl:when test="$limit = 0">0</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="(floor($this div $limit))*$limit"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="upper">
      <xsl:choose>
        <xsl:when test="$limit = 0">
          <xsl:value-of select="$total + $show"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$lower + $limit"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="(number($skip) &gt; 0) or ((number($skip)) &lt; number($total))">
      <!--
<xsl:if test="$skip = 0">
<font size="1"><br/></font>
</xsl:if>
-->
      <xsl:variable name="PostRange">
        <xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="($skip = 0) and ($skip + $show) &lt; $lower">
          <a>
            <xsl:if test="$target!=''">
              <xsl:attribute name="target">
                <xsl:value-of select="$target"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose>
                <xsl:when test="$thread!=''">
                  ?thread=<xsl:value-of select="$thread"/>&amp;
                </xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
              </xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/>
            </xsl:attribute>
            <xsl:attribute name="TITLE">
              <xsl:value-of select="$alt_show"/>First <xsl:value-of select="$objectname"/>
            </xsl:attribute>
            <xsl:call-template name="fpb_start"/>
          </a>
        </xsl:when>
        <xsl:when test="($skip + $show) = $lower">
          <a>
            <xsl:if test="$target!=''">
              <xsl:attribute name="target">
                <xsl:value-of select="$target"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose>
                <xsl:when test="$thread!=''">
                  ?thread=<xsl:value-of select="$thread"/>&amp;
                </xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
              </xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/>
            </xsl:attribute>
            <xsl:attribute name="TITLE">
              <xsl:value-of select="$alt_show"/>More <xsl:value-of select="$objectname"/>
            </xsl:attribute>
            <xsl:call-template name="fpb_prevset"/>
          </a>
        </xsl:when>
        <xsl:when test="$skip = $upper">
          <a>
            <xsl:if test="$target!=''">
              <xsl:attribute name="target">
                <xsl:value-of select="$target"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose>
                <xsl:when test="$thread!=''">
                  ?thread=<xsl:value-of select="$thread"/>&amp;
                </xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
              </xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/>
            </xsl:attribute>
            <xsl:attribute name="TITLE">
              <xsl:value-of select="$alt_show"/>More <xsl:value-of select="$objectname"/>
            </xsl:attribute>
            <xsl:call-template name="fpb_nextset"/>
          </a>
        </xsl:when>
        <xsl:when test="($skip &gt; $upper) and ((number($skip) + number($show)) &gt;= number($total))">
          <a>
            <xsl:if test="$target!=''">
              <xsl:attribute name="target">
                <xsl:value-of select="$target"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose>
                <xsl:when test="$thread!=''">
                  ?thread=<xsl:value-of select="$thread"/>&amp;
                </xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
              </xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/>
            </xsl:attribute>
            <xsl:attribute name="TITLE">
              <xsl:value-of select="$alt_show"/>Last <xsl:value-of select="$objectname"/>
            </xsl:attribute>
            <xsl:call-template name="fpb_end"/>
          </a>
        </xsl:when>
        <xsl:when test="$skip &gt;= $lower and $skip &lt; $upper">
          <xsl:if test="($skip mod $splitevery) = 0 and ($splitevery &gt; 0) and ($skip != 0)">
            <br/>
          </xsl:if>
          <a xsl:use-attribute-sets="nforumpostblocks">
            <xsl:call-template name="ApplyAttributes">
              <xsl:with-param name="attributes" select="$attributes"/>
            </xsl:call-template>
            <xsl:if test="$target!=''">
              <xsl:attribute name="target">
                <xsl:value-of select="$target"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose>
                <xsl:when test="$thread!=''">
                  ?thread=<xsl:value-of select="$thread"/>&amp;
                </xsl:when>
                <xsl:otherwise>?</xsl:otherwise>
              </xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="number($this) = number($skip)">
                <xsl:attribute name="TITLE">
                  <xsl:value-of select="$alt_nowshowing"/>
                  <xsl:value-of select="$objectname"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$PostRange"/>
                </xsl:attribute>
                <xsl:call-template name="fpb_thisblock">
                  <xsl:with-param name="blocknumber" select="number($skip div $show + 1)"/>
                  <xsl:with-param name="PostRange" select="$PostRange"/>
                  <xsl:with-param name="objectname" select="$objectname"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="TITLE">
                  <xsl:value-of select="$alt_show"/>
                  <xsl:value-of select="$objectname"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$PostRange"/>
                </xsl:attribute>
                <xsl:call-template name="fpb_otherblock">
                  <xsl:with-param name="blocknumber" select="number($skip div $show + 1)"/>
                  <xsl:with-param name="PostRange" select="$PostRange"/>
                  <xsl:with-param name="objectname" select="$objectname"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </a>
          <img src="{$imagesource}blank.gif" width="2" height="1"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>

        <xsl:when test="(number($skip) + number($show)) &lt; number($total)">
          <xsl:call-template name="forumpostblocks">
            <xsl:with-param name="thread" select="$thread"/>
            <xsl:with-param name="forum" select="$forum"/>
            <xsl:with-param name="total" select="$total"/>
            <xsl:with-param name="show" select="$show"/>
            <xsl:with-param name="this" select="$this"/>
            <xsl:with-param name="skip" select="number($skip) + number($show)"/>
            <xsl:with-param name="url" select="$url"/>
            <xsl:with-param name="objectname" select="$objectname"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="splitevery" select="$splitevery"/>
            <xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
            <xsl:with-param name="blocklimit" select="$blocklimit"/>
          </xsl:call-template>
        </xsl:when>
        <!--
	<xsl:otherwise>
	<br/>
	<font size="1"><br/></font>
	</xsl:otherwise>
-->
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="fpb_start">
    <span xsl:use-attribute-sets="forumblocksoff">[start]</span>
  </xsl:template>

  <xsl:template name="fpb_prevset">
    <span xsl:use-attribute-sets="forumblocksoff">&lt;&lt;</span>
  </xsl:template>

  <xsl:template name="fpb_nextset">
    <span xsl:use-attribute-sets="forumblocksoff">&gt;&gt;</span>
  </xsl:template>

  <xsl:template name="fpb_end">
    <span xsl:use-attribute-sets="forumblocksoff">[end]</span>
  </xsl:template>

  <xsl:template name="fpb_thisblock">
    <xsl:param name="blocknumber"/>
    <xsl:param name="objectname"/>
    <xsl:param name="PostRange"/>
    <span xsl:use-attribute-sets="forumblockson">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$blocknumber"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

  <xsl:template name="fpb_otherblock">
    <xsl:param name="blocknumber"/>
    <xsl:param name="objectname"/>
    <xsl:param name="PostRange"/>
    <span xsl:use-attribute-sets="forumblocksoff">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$blocknumber"/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>



  <xsl:template name="insert-header">
    <xsl:choose>
      <xsl:when test="@TYPE='ARTICLE'">
        <xsl:call-template name="ARTICLE_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='INDEX'">
        <xsl:call-template name="INDEX_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE'">
        <xsl:call-template name="FRONTPAGE_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERPAGE'">
        <xsl:call-template name="USERPAGE_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDTHREAD'">
        <xsl:call-template name="ADDTHREAD_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='CATEGORY'">
        <xsl:call-template name="CATEGORY_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITCATEGORY'">
        <xsl:call-template name="EDITCATEGORY_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBMITREVIEWFORUM'">
        <xsl:call-template name="SUBMITREVIEWFORUM_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='REVIEWFORUM'">
        <xsl:call-template name="REVIEWFORUM_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='SEARCH'">
        <xsl:call-template name="SEARCH_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDJOURNAL'">
        <xsl:call-template name="ADDJOURNAL_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER'">
        <xsl:call-template name="REGISTER_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWREGISTER'">
        <xsl:call-template name="NEWREGISTER_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='INFO'">
        <xsl:call-template name="INFO_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='LOGOUT'">
        <xsl:call-template name="LOGOUT_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='JOURNAL'">
        <xsl:call-template name="JOURNAL_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWEMAIL'">
        <xsl:call-template name="NEWEMAIL_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPAGES'">
        <xsl:call-template name="MOREPAGES_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='ERROR'">
        <xsl:call-template name="ERROR_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPOSTS'">
        <xsl:call-template name="MOREPOSTS_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='USEREDIT'">
        <xsl:call-template name="USEREDIT_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERDETAILS'">
        <xsl:call-template name="USERDETAILS_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER-CONFIRMATION'">
        <xsl:call-template name="REGISTER-CONFIRMATION_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWUSERS'">
        <xsl:call-template name="NEWUSERS_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='SHAREANDENJOY'">
        <xsl:call-template name="SHAREANDENJOY_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='DIAGNOSE'">
        <xsl:call-template name="DIAGNOSE_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='RECOMMEND-ENTRY'">
        <xsl:call-template name="RECOMMEND-ENTRY_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUB-ALLOCATION_HEADER'">
        <xsl:call-template name="SUB-ALLOCATION_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='SCOUT-RECOMMENDATIONS_HEADER'">
        <xsl:call-template name="SCOUT-RECOMMENDATIONS_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='INSPECT-USER_HEADER'">
        <xsl:call-template name="INSPECT-USER_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='GROUP-MANAGEMENT'">
        <xsl:call-template name="GROUP-MANAGEMENT_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='MULTIPOSTS'">
        <xsl:call-template name="MULTIPOSTS_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='KEYARTICLE-EDITOR'">
        <xsl:call-template name="KEYARTICLE-EDITOR_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITREVIEW'">
        <xsl:call-template name="EDITREVIEW_HEADER"/>
      </xsl:when>
      <xsl:when test="@TYPE='MONTH'">
        <xsl:call-template name="MONTHSUMMARY_HEADER"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_HEADER"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="insert-strapline">
    <xsl:choose>
      <xsl:when test="false()"/>
      <!--	<xsl:when test=".[@TYPE='FRONTPAGE']">
	<xsl:call-template name="FRONTPAGE_STRAPLINE"/>
	</xsl:when>
-->
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_STRAPLINE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="insert-leftcol">
    <xsl:choose>
      <xsl:when test="@TYPE='FRONTPAGE'">
        <xsl:call-template name="FRONTPAGE_LEFTCOL"/>
      </xsl:when>
      <xsl:when test="@TYPE='SEARCH'">
        <xsl:call-template name="SEARCH_LEFTCOL"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERPAGE'">
        <xsl:call-template name="USERPAGE_LEFTCOL"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE-EDITOR'">
        <xsl:call-template name="FRONTPAGE_LEFTCOL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_LEFTCOL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="insert-subject">
    <xsl:choose>
      <xsl:when test="@TYPE='ARTICLE'">
        <xsl:call-template name="ARTICLE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SIMPLEPAGE'">
        <xsl:call-template name="SIMPLEPAGE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE'">
        <xsl:call-template name="FRONTPAGE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='INDEX'">
        <xsl:call-template name="INDEX_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDTHREAD'">
        <xsl:call-template name="ADDTHREAD_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='CATEGORY'">
        <xsl:call-template name="CATEGORY_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITCATEGORY'">
        <xsl:call-template name="EDITCATEGORY_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBMITREVIEWFORUM'">
        <xsl:call-template name="SUBMITREVIEWFORUM_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='REVIEWFORUM'">
        <xsl:call-template name="REVIEWFORUM_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SEARCH'">
        <xsl:call-template name="SEARCH_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERPAGE'">
        <xsl:call-template name="USERPAGE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDJOURNAL'">
        <xsl:call-template name="ADDJOURNAL_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER'">
        <xsl:call-template name="REGISTER_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWREGISTER'">
        <xsl:call-template name="NEWREGISTER_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='INFO'">
        <xsl:call-template name="INFO_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='LOGOUT'">
        <xsl:call-template name="LOGOUT_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='JOURNAL'">
        <xsl:call-template name="JOURNAL_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWEMAIL'">
        <xsl:call-template name="NEWEMAIL_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPAGES'">
        <xsl:call-template name="MOREPAGES_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='ERROR'">
        <xsl:call-template name="ERROR_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPOSTS'">
        <xsl:call-template name="MOREPOSTS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='USEREDIT'">
        <xsl:call-template name="USEREDIT_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERDETAILS'">
        <xsl:call-template name="USERDETAILS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER-CONFIRMATION'">
        <xsl:call-template name="REGISTER-CONFIRMATION_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBSCRIBE'">
        <xsl:call-template name="SUBSCRIBE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWUSERS'">
        <xsl:call-template name="NEWUSERS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SHAREANDENJOY'">
        <xsl:call-template name="SHAREANDENJOY_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='DIAGNOSE'">
        <xsl:call-template name="DIAGNOSE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='MULTIPOSTS'">
        <xsl:call-template name="MULTIPOSTS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='THREADS'">
        <xsl:call-template name="THREADS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='RECOMMEND-ENTRY'">
        <xsl:call-template name="RECOMMEND-ENTRY_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITREVIEW'">
        <xsl:call-template name="EDITREVIEW_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUB-ALLOCATION'">
        <xsl:call-template name="SUB-ALLOCATION_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SCOUT-RECOMMENDATIONS'">
        <xsl:call-template name="SCOUT-RECOMMENDATIONS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='INSPECT-USER'">
        <xsl:call-template name="INSPECT-USER_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='GROUP-MANAGEMENT'">
        <xsl:call-template name="GROUP-MANAGEMENT_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBBED-ARTICLE-STATUS'">
        <xsl:call-template name="SUBBED-ARTICLE-STATUS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SITECHANGE'">
        <xsl:call-template name="SITECHANGE_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='COMING-UP'">
        <xsl:call-template name="COMING-UP_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='KEYARTICLE-EDITOR'">
        <xsl:call-template name="KEYARTICLE-EDITOR_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='SITEADMIN-EDITOR'">
        <xsl:call-template name="SITEADMIN-EDITOR_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='NOTFOUND'">
        <xsl:call-template name="NOTFOUND_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERSTATISTICS'">
        <xsl:call-template name="USERSTATISTICS_SUBJECT"/>
      </xsl:when>
      <xsl:when test="@TYPE='WATCHED-USERS'">
        <xsl:call-template name="WATCHED-USERS_SUBJECT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_SUBJECT"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="insert-mainbody">
    <xsl:choose>
      <xsl:when test="@TYPE='ARTICLE'">
        <xsl:call-template name="ARTICLE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SIMPLEPAGE'">
        <xsl:call-template name="SIMPLEPAGE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE'">
        <xsl:call-template name="FRONTPAGE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='INDEX'">
        <xsl:call-template name="INDEX_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERPAGE'">
        <xsl:call-template name="USERPAGE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDTHREAD'">
        <xsl:call-template name="ADDTHREAD_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='CATEGORY'">
        <xsl:call-template name="CATEGORY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SEARCH'">
        <xsl:call-template name="SEARCH_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='ADDJOURNAL'">
        <xsl:call-template name="ADDJOURNAL_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER'">
        <xsl:call-template name="REGISTER_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWREGISTER'">
        <xsl:call-template name="NEWREGISTER_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='INFO'">
        <xsl:call-template name="INFO_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='LOGOUT'">
        <xsl:call-template name="LOGOUT_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='JOURNAL'">
        <xsl:call-template name="JOURNAL_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWEMAIL'">
        <xsl:call-template name="NEWEMAIL_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPAGES'">
        <xsl:call-template name="MOREPAGES_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='ERROR'">
        <xsl:call-template name="ERROR_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MOREPOSTS'">
        <xsl:call-template name="MOREPOSTS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='USEREDIT'">
        <xsl:call-template name="USEREDIT_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERDETAILS'">
        <xsl:call-template name="USERDETAILS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='REGISTER-CONFIRMATION'">
        <xsl:call-template name="REGISTER-CONFIRMATION_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBSCRIBE'">
        <xsl:call-template name="SUBSCRIBE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='NEWUSERS'">
        <xsl:call-template name="NEWUSERS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SHAREANDENJOY'">
        <xsl:call-template name="SHAREANDENJOY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='DIAGNOSE'">
        <xsl:call-template name="DIAGNOSE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='THREADS'">
        <xsl:call-template name="THREADS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MULTIPOSTS'">
        <xsl:call-template name="MULTIPOSTS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='ARTCHECK'">
        <xsl:call-template name="ARTCHECK_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='RECOMMEND-ENTRY'">
        <xsl:call-template name="RECOMMEND-ENTRY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITREVIEW'">
        <xsl:call-template name="EDITREVIEW_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUB-ALLOCATION'">
        <xsl:call-template name="SUB-ALLOCATION_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SCOUT-RECOMMENDATIONS'">
        <xsl:call-template name="SCOUT-RECOMMENDATIONS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='INSPECT-USER'">
        <xsl:call-template name="INSPECT-USER_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='GROUP-MANAGEMENT'">
        <xsl:call-template name="GROUP-MANAGEMENT_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MONTH'">
        <xsl:call-template name="MONTHSUMMARY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBBED-ARTICLE-STATUS'">
        <xsl:call-template name="SUBBED-ARTICLE-STATUS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SITECHANGE'">
        <xsl:call-template name="SITECHANGE_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='EDITCATEGORY'">
        <xsl:call-template name="EDITCATEGORY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUBMITREVIEWFORUM'">
        <xsl:call-template name="SUBMITREVIEWFORUM_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='REVIEWFORUM'">
        <xsl:call-template name="REVIEWFORUM_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='COMING-UP'">
        <xsl:call-template name="COMING-UP_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE-EDITOR'">
        <xsl:call-template name="FRONTPAGE_MAINBODY"/>
        <xsl:call-template name="FRONTPAGE_EDITOR"/>
      </xsl:when>
      <xsl:when test="@TYPE='KEYARTICLE-EDITOR'">
        <xsl:call-template name="KEYARTICLE-EDITOR_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='TOPFIVE-EDITOR'">
        <xsl:call-template name="TOPFIVE-EDITOR_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='SITEADMIN-EDITOR'">
        <xsl:call-template name="SITEADMIN-EDITOR_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='NOTFOUND'">
        <xsl:call-template name="NOTFOUND_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERSTATISTICS'">
        <xsl:call-template name="USERSTATISTICS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='WATCHED-USERS'">
        <xsl:call-template name="WATCHED-USERS_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MODERATOR-MANAGEMENT'">
        <xsl:call-template name="MODERATOR-MANAGEMENT_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE='MANAGE-FAST-MOD'">
        <!--<xsl:call-template name="MANAGE-FAST-MOD_MAINBODY"/>-->
      </xsl:when>
      <xsl:when test="@TYPE='MODERATION-HISTORY'">
        <xsl:call-template name="MODERATIONHISTORY_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_MAINBODY"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_MAINBODY"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_MAINBODY"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="XMLPARSEERROR"/>
  </xsl:template>

  <xsl:template name="MODERATIONHISTORY_HEADER"/>
  <xsl:template name="MODERATIONHISTORY_SUBJECT"/>
  <xsl:template name="MODERATIONHISTORY_MAINBODY"/>
  <xsl:template name="MODERATIONHISTORY_CSS"/>
  <xsl:template name="MODERATIONHISTORY_JAVASCRIPT"/>

  <xsl:template name="insert-bottomsidebar">
    <xsl:choose>
      <xsl:when test="@TYPE='MULTIPOSTS'">
        <xsl:call-template name="MULTIPOSTS_BOTTOMSIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_BOTTOMSIDEBAR"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="insert-sidebar">
    <xsl:choose>
      <xsl:when test="@TYPE='ARTICLE'">
        <xsl:call-template name="ARTICLE_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE'">
        <xsl:call-template name="FRONTPAGE_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='INDEX'">
        <xsl:call-template name="INDEX_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='USERPAGE'">
        <xsl:call-template name="USERPAGE_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='CATEGORY'">
        <xsl:call-template name="CATEGORY_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='SEARCH'">
        <xsl:call-template name="SEARCH_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='MULTIPOSTS'">
        <xsl:call-template name="MULTIPOSTS_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='SUB-ALLOCATION'">
        <xsl:call-template name="SUB-ALLOCATION_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='SCOUT-RECOMMENDATIONS'">
        <xsl:call-template name="SCOUT-RECOMMENDATIONS_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='INSPECT-USER'">
        <xsl:call-template name="INSPECT-USER_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='GROUP-MANAGEMENT'">
        <xsl:call-template name="GROUP-MANAGEMENT_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='REVIEWFORUM'">
        <xsl:call-template name="REVIEWFORUM_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE='FRONTPAGE-EDITOR'">
        <xsl:call-template name="FRONTPAGE_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:when test="@TYPE=''">
        <xsl:call-template name="_SIDEBAR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_SIDEBAR"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="DEFAULT_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_h2g2"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="DEFAULT_SUBJECT">
  </xsl:template>

  <xsl:template name="DEFAULT_SIDEBAR">
  </xsl:template>

  <xsl:template name="DEFAULT_MAINBODY">
  </xsl:template>

  <xsl:template name="DEFAULT_STRAPLINE">
  </xsl:template>

  <xsl:template name="DEFAULT_LEFTCOL">
  </xsl:template>

  <!-- ******************************** -->

  <xsl:template name="ARTCHECK_MAINBODY">
    <xsl:for-each select="FAILED">
      Failed article:
      <A target="_blank" href="{$root}A{@ID}">
        A<xsl:value-of select="@ID"/>
      </A>
      (<A target="_blank" HREF="http://bbc.h2g2.com/A{@ID}">old code</A>)
      <br/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="FRONTPAGE_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_frontpagetitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="FRONTPAGE_LEFTCOL">
    <xsl:attribute name="width">200</xsl:attribute>
    <xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION"/>
    <xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN='2']">
      <xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="FRONTPAGE_SUBJECT">
  </xsl:template>

  <xsl:template name="FRONTPAGE_SIDEBAR">
    <xsl:apply-templates select="/H2G2/TOP-FIVES"/>
  </xsl:template>

  <xsl:template name="FRONTPAGE_MAINBODY">
    <xsl:if test="$fpregistered=1">
      <div xsl:use-attribute-sets="welcomeback">
        <xsl:call-template name="m_welcomebackuser"/>
      </div>
    </xsl:if>
    <xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN!='2']">
      <xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template name="FRONTPAGE_STRAPLINE">
    <div align="center">
      <b>
        h2g2 - The Earth Edition of The Hitchhiker's Guide to the Galaxy
      </b>
    </div>
  </xsl:template>

  <!-- ******************************** -->

  <xsl:template name="ARTICLE_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:choose>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
            <xsl:value-of select="$m_articlehiddentitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
            <xsl:value-of select="$m_articlereferredtitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
            <xsl:value-of select="$m_articleawaitingpremoderationtitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
            <xsl:value-of select="$m_legacyarticleawaitingmoderationtitle"/>
          </xsl:when>
          <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
            <xsl:value-of select="$m_articledeletedtitle"/>
          </xsl:when>
          <xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
            <xsl:copy-of select="$m_nosuchguideentry"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="ARTICLE/SUBJECT"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="ARTICLE/ARTICLEINFO/H2G2ID">
          - A<xsl:value-of select="ARTICLE/ARTICLEINFO/H2G2ID"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="ARTICLE_SUBJECT">

    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
            <xsl:value-of select="$m_articlehiddentitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
            <xsl:value-of select="$m_articlereferredtitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
            <xsl:value-of select="$m_articleawaitingpremoderationtitle"/>
          </xsl:when>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
            <xsl:value-of select="$m_legacyarticleawaitingmoderationtitle"/>
          </xsl:when>
          <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
            <xsl:value-of select="$m_articledeletedsubject"/>
          </xsl:when>
          <xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
            <xsl:copy-of select="$m_nosuchguideentry"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="ARTICLE/SUBJECT"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ARTICLE_SIDEBAR">
    <xsl:if test="$registered=0">
      <xsl:call-template name="displayunregisteredslug"/>
    </xsl:if>
    <xsl:apply-templates select="ARTICLE/ARTICLEINFO"/>
  </xsl:template>

  <xsl:template name="ARTICLE_MAINBODY">
    <xsl:if test="/H2G2/ARTICLE-MODERATION-FORM/@REFERRALS=1">
      <br/>
      <a href="#moderatesection">
        <xsl:value-of select="$m_jumptomoderate"/>
      </a>
      <br/>
    </xsl:if>

    <BR/>
    <xsl:choose>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
        <xsl:call-template name="m_articlehiddentext"/>
        <br/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
        <xsl:call-template name="m_articlereferredtext"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
        <xsl:call-template name="m_articleawaitingpremoderationtext"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
        <xsl:call-template name="m_legacyarticleawaitingmoderationtext"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
        <xsl:call-template name="m_articledeletedbody"/>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="/H2G2/ARTICLE/GUIDE/INTRO">
          <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTRO"/>
        </xsl:if>
        <DIV>
          <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
        </DIV>
        <xsl:if test=".//FOOTNOTE">
          <blockquote>
            <div class="footnote">
              <hr/>
              <xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
            </div>
          </blockquote>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS"/>
    <!-- put the moderation form in if present -->
    <xsl:if test="/H2G2/ARTICLE-MODERATION-FORM">
      <div class="ModerationTools">
        <br/>
        <table bgColor="lightblue" cellspacing="2" cellpadding="2" border="0">
          <tr>
            <td>
              <xsl:apply-templates select="/H2G2/ARTICLE-MODERATION-FORM"/>
            </td>
          </tr>
        </table>
      </div>
    </xsl:if>
    <xsl:apply-templates select="FORUMPAGE"/>
    <br clear="all"/>
  </xsl:template>

  <xsl:template name="INDEX_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_indextitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="INDEX_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_indextitle"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="INDEX_SIDEBAR">
    <form method="get" action="{$root}Index" name="">
      <input type="hidden" name="let">
        <xsl:attribute name="value">
          <xsl:value-of select="INDEX/@LETTER"/>
        </xsl:attribute>
      </input>
      <table border="0" cellspacing="0" cellpadding="1">
        <tr>
          <td valign="top">&nbsp;</td>
          <td valign="top">
            <span class="indexnavtitle">
              <xsl:value-of select="$m_show"/>
            </span>
          </td>
        </tr>
        <tr>
          <td valign="top">
            <input type="checkbox" name="official">
              <xsl:if test="INDEX/@APPROVED">
                <xsl:attribute name="checked">1</xsl:attribute>
              </xsl:if>
            </input>
          </td>
          <td>
            <b>
              <xsl:value-of select="$m_editedentries"/>
            </b>
          </td>
        </tr>
        <tr>
          <td valign="top">
            <input type="checkbox" name="submitted">
              <xsl:if test="INDEX/@SUBMITTED">
                <xsl:attribute name="checked">1</xsl:attribute>
              </xsl:if>
            </input>
          </td>
          <td>
            <xsl:value-of select="$m_awaitingappr"/>
          </td>
        </tr>
        <tr>
          <td valign="top">
            <input type="checkbox" name="user">
              <xsl:if test="INDEX/@UNAPPROVED">
                <xsl:attribute name="checked">1</xsl:attribute>
              </xsl:if>
            </input>
          </td>
          <td>
            <i>
              <xsl:value-of select="$m_guideentries"/>
            </i>
          </td>
        </tr>
        <tr>
          <td valign="top">&nbsp;</td>
          <td>
            <input type="submit" value="{$m_refresh}" name="submit"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>


  <xsl:template name="THREADS_SUBJECT">
    <xsl:apply-templates select="FORUMSOURCE"/>
  </xsl:template>

  <xsl:template name="USERSTATISTICS_SUBJECT">
    <span xsl:use-attribute-sets="forumsource">
      <B>
        <xsl:value-of select="$m_thisuserstatistics"/>
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>U
            <xsl:value-of select="USERSTATISTICS/@USERID"/>
          </xsl:attribute>
          <xsl:attribute name="TARGET">_top</xsl:attribute>
          <span xsl:use-attribute-sets="forumsourcelink">
            <xsl:value-of select="USERSTATISTICS/@USERNAME"/>
          </span>
        </A>
      </B>
    </span>
  </xsl:template>

  <xsl:template name="MULTIPOSTS_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>A Forum Conversation
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="MULTIPOSTS_SUBJECT">
    <xsl:apply-templates select="FORUMSOURCE"/>
    <xsl:apply-templates select="FORUMTHREADS" mode="PrevAndNext"/>
  </xsl:template>

  <xsl:template name="MULTIPOSTS_MAINBODY">
    <div align="right">
      <xsl:choose>
        <xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 1">
          <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')  or ($superuser = 1)">
            <a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=closethread">
              <img src="http://www.bbc.co.uk/dnaimages/boards/images/button_close.gif" alt="Close this thread" width="137" height="23" border="0" vspace="5" hspace="5"/>
            </a>
          </xsl:if>
        </xsl:when>
        <xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 0">
          <img src="http://www.bbc.co.uk/dnaimages/boards/images/button_closed.gif" alt="This thread has been closed" width="183" height="23" border="0" vspace="5" hspace="5"/>
          <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')  or ($superuser = 1)">
            <a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=reopenthread">
              <img src="http://www.bbc.co.uk/dnaimages/boards/images/button_open.gif" alt="Open this thread" width="139" height="23" border="0" vspace="5" hspace="0"/>
            </a>
            <br clear="all"/>
            <p>
              <font face="verdana, helvetica, sans-serif" size="2">
                <b>(If you are an editor you will still see the reply buttons)</b>
              </font>
            </p>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </div>
    <br/>
    <xsl:call-template name="showthreadintro"/>
    <xsl:apply-templates select="FORUMTHREADPOSTS">
      <xsl:with-param name="ptype" select="'single'"/>
    </xsl:apply-templates>
    <hr/>
    <xsl:call-template name="subscribethreadposts"/>
    <br/>
  </xsl:template>

  <xsl:template name="showthreadintro">
    <xsl:if test="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/THREADINTRO">
      <xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/THREADINTRO"/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="MULTIPOSTS_SIDEBAR">
    <br/>
    <CENTER>
      <xsl:call-template name="sidebarforumnav"/>
      <br/>
      <br/>
      <xsl:call-template name="m_forumpostingsdisclaimer"/>
    </CENTER>
  </xsl:template>

  <xsl:template name="MULTIPOSTS_BOTTOMSIDEBAR">
    <br/>
    <CENTER>
      <xsl:call-template name="sidebarforumnav"/>
    </CENTER>
  </xsl:template>

  <xsl:template name="sidebarforumnav">
    <xsl:call-template name="messagenavbuttons"/>

    <!--xsl:with-param name="skipto"><xsl:value-of select="FORUMTHREADPOSTS/@SKIPTO"/></xsl:with-param>
<xsl:with-param name="count"><xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/></xsl:with-param>
<xsl:with-param name="forumid"><xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/></xsl:with-param>
<xsl:with-param name="threadid"><xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/></xsl:with-param>
<xsl:with-param name="more"><xsl:value-of select="FORUMTHREADPOSTS/@MORE"/></xsl:with-param>
</xsl:call-template-->


    <xsl:call-template name="forumpostblocks">
      <xsl:with-param name="forum" select="FORUMTHREADPOSTS/@FORUMID"/>
      <xsl:with-param name="thread" select="FORUMTHREADPOSTS/@THREADID"/>
      <xsl:with-param name="skip" select="0"/>
      <xsl:with-param name="show" select="FORUMTHREADPOSTS/@COUNT"/>
      <xsl:with-param name="total" select="FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/>
      <xsl:with-param name="this" select="FORUMTHREADPOSTS/@SKIPTO"/>
      <xsl:with-param name="url" select="'F'"/>
      <xsl:with-param name="objectname" select="'Postings'"/>
      <xsl:with-param name="target"/>
      <xsl:with-param name="splitevery">100</xsl:with-param>
      <xsl:with-param name="blocklimit" select="20"/>
    </xsl:call-template>
    <br/>
    <xsl:choose>
      <xsl:when test="/H2G2/FORUMSOURCE[@TYPE='reviewforum']">
        <a href="{$root}RF{/H2G2/FORUMSOURCE/REVIEWFORUM/@ID}?entry=0">
          <xsl:value-of select="$m_articlelisttext"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <A href="{$root}F{FORUMTHREADPOSTS/@FORUMID}?showthread={FORUMTHREADPOSTS/@THREADID}">
          <xsl:value-of select="$m_returntothreadspage"/>
        </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="USERSTATISTICS_MAINBODY">
    <xsl:for-each select="USERSTATISTICS">
      <xsl:call-template name="navbuttons">
        <xsl:with-param name="URL">US</xsl:with-param>
        <xsl:with-param name="ID" select="@USERID"/>
        <xsl:with-param name="Previous" select="$alt_previouspage"/>
        <xsl:with-param name="Next" select="$alt_nextpage"/>
        <xsl:with-param name="shownewest" select="$alt_firstpage"/>
        <xsl:with-param name="showoldestconv" select="$alt_lastpage"/>
        <xsl:with-param name="ExtraParameters">
          &amp;mode=<xsl:value-of select="@DISPLAYMODE"/>
        </xsl:with-param>
        <xsl:with-param name="showconvs" select="$alt_showposts"/>
      </xsl:call-template>
    </xsl:for-each>

    <br/>
    <xsl:call-template name="forumpostblocks">
      <xsl:with-param name="forum" select="USERSTATISTICS/@USERID"/>
      <xsl:with-param name="skip" select="0"/>
      <xsl:with-param name="show" select="USERSTATISTICS/@COUNT"/>
      <xsl:with-param name="total" select="USERSTATISTICS/@TOTAL"/>
      <xsl:with-param name="this" select="USERSTATISTICS/@SKIPTO"/>
      <xsl:with-param name="url">US</xsl:with-param>
      <xsl:with-param name="ExtraParameters">
        &amp;mode=<xsl:value-of select="USERSTATISTICS/@DISPLAYMODE"/>
      </xsl:with-param>
      <xsl:with-param name="splitevery">800</xsl:with-param>
      <xsl:with-param name="objectname" select="$m_postings"/>
      <xsl:with-param name="blocklimit" select="20"/>
    </xsl:call-template>
    <br/>

    <xsl:choose>
      <xsl:when test="USERSTATISTICS[@DISPLAYMODE = 'ungrouped']">
        <TABLE>
          <TH ALIGN="left">
            <xsl:value-of select="$m_forumsubject"/>
          </TH>
          <TH ALIGN="left">
            <xsl:value-of select="$m_conversationfirstsubject"/>
          </TH>
          <TH ALIGN="left">
            <xsl:value-of select="$m_postsubject"/>
          </TH>
          <TH ALIGN="left">
            <xsl:value-of select="$m_posteddate"/>
          </TH>
          <xsl:for-each select="USERSTATISTICS/FORUM/THREAD/POST">
            <TR>
              <TD>
                <B>
                  <a href="{$root}F{../../@FORUMID}">
                    <xsl:apply-templates mode="nosubject" select="../../SUBJECT"/>
                  </a>
                </B>
              </TD>
              <TD>
                <B>
                  <a href="{$root}F{../../@FORUMID}?thread={../@THREADID}">
                    <xsl:apply-templates mode="nosubject" select="../SUBJECT"/>
                  </a>
                </B>
              </TD>
              <TD>
                <B>
                  <a href="{$root}F{../../@FORUMID}?thread={../@THREADID}&amp;post={@POSTID}#p{@POSTID}">
                    <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
                  </a>
                </B>
                <BR/>
              </TD>
              <TD>
                <span class="statdateposted">
                  <xsl:apply-templates select="DATEPOSTED"/>
                </span>
              </TD>
            </TR>
          </xsl:for-each>
        </TABLE>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="USERSTATISTICS/FORUM">
          <B>
            <a href="{$root}F{@FORUMID}">
              <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
            </a>
          </B>
          <BR/>
          <xsl:for-each select="THREAD">
            <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
            <B>
              <a href="{$root}F{../@FORUMID}?thread={@THREADID}">
                <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
              </a>
            </B>
            <BR/>
            <xsl:for-each select="POST">
              <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
              <B>
                <a href="{$root}F{../../@FORUMID}?thread={../@THREADID}&amp;post={@POSTID}#p{@POSTID}">
                  <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
                </a>
              </B>
              <BR/>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
              <span class="statdateposted">
                <xsl:value-of select="$m_posted"/>
                <xsl:apply-templates select="DATEPOSTED"/>
              </span>
              <BR/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="USERPAGE_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:choose>
          <xsl:when test="ARTICLE/SUBJECT">
            <xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="ARTICLE/SUBJECT"/> - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$ownerisviewer = 1">
                <xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_pstitleowner"/><xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>.
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_pstitleviewer"/><xsl:value-of select="PAGE-OWNER/USER/USERID"/>.
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="USERPAGE_LEFTCOL">
  </xsl:template>

  <xsl:template name="USERPAGE_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
            <xsl:value-of select="$m_userpagemoderatesubject"/>
          </xsl:when>
          <xsl:when test="ARTICLE/SUBJECT and $test_introarticle">
            <xsl:value-of select="ARTICLE/SUBJECT"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$ownerisviewer = 1">
                <xsl:value-of select="$m_pstitleowner"/><xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>.
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$m_pstitleviewer"/><xsl:value-of select="PAGE-OWNER/USER/USERID"/>.
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="USERPAGE_MAINBODY">
    <xsl:variable name="mymessage">
      <xsl:if test="$ownerisviewer=1">
        <xsl:value-of select="$m_mymessage"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:variable>
    <!-- do any error reports before anything else
		 currently just says if there is an error, but could give more info
	-->
    <xsl:if test="/H2G2/ARTICLE/ERROR">
      <p>
        <xsl:choose>
          <xsl:when test="$ownerisviewer = 1">
            <xsl:call-template name="m_pserrorowner"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="m_pserrorviewer"/>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </xsl:if>

    <xsl:if test="/H2G2/ARTICLE/GUIDE">
      <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTRO"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
        <xsl:call-template name="m_userpagehidden"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
        <xsl:call-template name="m_userpagereferred"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
        <xsl:call-template name="m_userpagependingpremoderation"/>
      </xsl:when>
      <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
        <xsl:call-template name="m_legacyuserpageawaitingmoderation"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$test_introarticle">
            <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$ownerisviewer = 1">
                <xsl:call-template name="m_psintroowner"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="m_psintroviewer"/>
              </xsl:otherwise>
            </xsl:choose>
            <!--
			<P>This is the Personal Home Page for <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>.
			Unfortunately <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
			hasn't managed to find the time to write his or her own
			Home Page Introduction, but hopefully they soon will.</P>
			<P>By the way, if you've registered but haven't yet written an
			Entry to display as <I>your</I> Home Page Introduction, then this
			is what your Home Page looks like to visitors. You change
			this by going to your Home Page, clicking on the Edit Page
			button, and putting whatever you want as your Home Page Introduction.</P>
-->
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test=".//FOOTNOTE">
          <blockquote>
            <div class="footnote">
              <hr/>
              <xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
              <xsl:text> </xsl:text>
            </div>
          </blockquote>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS"/>
    <br clear="all"/>
    <b>
      <span class="spacesectiontitle">
        <xsl:value-of select="$mymessage"/>
        <xsl:value-of select="$m_journalentries"/>
      </span>
    </b>
    <p>
      <br/>
      <!--Welcome to your Journal. <A href="{$root}/dontpanic-journal">Click here for more information about your journal and what you can do with it</A><br/><br/>-->
      <xsl:apply-templates select="JOURNAL"/>
    </p>
    <hr/>
    <b>
      <span class="spacesectiontitle">
        <xsl:value-of select="$mymessage"/>
        <xsl:value-of select="$m_mostrecentconv"/>
      </span>
    </b>
    <p>
      <br/>
      <xsl:apply-templates select="RECENT-POSTS"/>
    </p>
    <br clear="all"/>
    <hr/>
    <b>
      <span class="spacesectiontitle">
        <xsl:value-of select="$mymessage"/>
        <xsl:value-of select="$m_recententries"/>
      </span>
    </b>
    <p>
      <br/>
      <xsl:apply-templates select="RECENT-ENTRIES"/>
      <br/>
      <br/>
    </p>
    <hr/>
    <b>
      <span class="spacesectiontitle">
        <xsl:value-of select="$mymessage"/>
        <xsl:value-of select="$m_mostrecentedited"/>
      </span>
    </b>
    <p>
      <br/>
      <xsl:apply-templates select="RECENT-APPROVALS"/>
      <br/>
      <br/>
    </p>
    <div class="friendstitle">Friends List</div>
    <div class="friendslist">
      <xsl:apply-templates select="WATCHED-USER-LIST"/>
      <xsl:apply-templates select="WATCHING-USER-LIST"/>
    </div>
  </xsl:template>


  <xsl:template name="USERPAGE_SIDEBAR">
    <xsl:apply-templates select="/H2G2/PAGE-OWNER"/>
    <br/>
    <br/>
    <br/>
    <xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES"/>
  </xsl:template>


  <xsl:template name="ADDTHREAD_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_posttoaforum"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="ADDTHREAD_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="POSTTHREADUNREG">
            <xsl:value-of select="$m_greetingshiker"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_posttoaforum"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ADDTHREAD_MAINBODY">

    <xsl:choose>

      <xsl:when test="ERROR">

        <xsl:choose>
          <xsl:when test="ERROR/@TYPE='REVIEWFORUM'">
            Sorry but you have attempted to add a post to the <xsl:value-of select="ERROR/REVIEWFORUM/REVIEWFORUMNAME"/> Forum. This is not allowed.
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='BADREVIEWFORUM'">
            You have attempted to post to a review forum this is not allowed.
          </xsl:when>
          <xsl:when test="ERROR/@TYPE='DBERROR'">
            There was a database error
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <br/>
        <xsl:call-template name="showaddthreadintro"/>
        <xsl:apply-templates select="POSTTHREADFORM"/>
        <xsl:apply-templates select="POSTTHREADUNREG"/>
        <xsl:apply-templates select="POSTPREMODERATED"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="showaddthreadintro">
    <xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO"/>
  </xsl:template>


  <xsl:template name="CATEGORY_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_browsetheguide"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>




  <xsl:template name="CATEGORY_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_browsetheguide"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="CATEGORY_SIDEBAR">
    <xsl:call-template name="m_clickhelpbrowse"/>
  </xsl:template>

  <xsl:template name="EDITCATEGORY_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_editcategorisationsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="EDITCATEGORY_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_editcategorisationheader"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="EDITCATEGORY_MAINBODY">
    <br/>
    <xsl:apply-templates select="EDITCATEGORY"/>
  </xsl:template>

  <xsl:template name="CATEGORY_MAINBODY">
    <style type="text/css">

      <xsl:comment>
        ul {  list-style-type: square; text-decoration: none}
        DIV.category A { text-decoration: <xsl:value-of select="$catdecoration"/>; color: <xsl:value-of select="$catcolour"/>}
        DIV.categoryarticle A { text-decoration: <xsl:value-of select="$artdecoration"/>; colour: <xsl:value-of select="$artcolour"/>}
        DIV.category A:hover { text-decoration: <xsl:value-of select="$hovcatdecoration"/>; color: <xsl:value-of select="$hovcatcolour"/>}
        DIV.categoryarticle A:hover { text-decoration: <xsl:value-of select="$hovartdecoration"/>; colour: <xsl:value-of select="$hovartcolour"/>}
      </xsl:comment>
    </style>
    <xsl:choose>
      <xsl:when test="HIERARCHYDETAILS">
        <xsl:apply-templates select="HIERARCHYDETAILS" mode="CATEGORY"/>
      </xsl:when>
      <xsl:otherwise>
        <UL>

          <!--
<xsl:choose>
<xsl:when test="$usenodeset = 1">
<xsl:apply-templates select="msxsl:node-set($categoryroot)/ROOTCAT"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$categoryroot"/>
</xsl:otherwise>
</xsl:choose>
-->
          <xsl:call-template name="applytofragment">
            <xsl:with-param name="fragment" select="$categoryroot"/>
          </xsl:call-template>
        </UL>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="ROOTCAT">
    <LI>
      <P>
        <B>
          <A href="{$root}C{CATID}">
            <xsl:value-of select="NAME"/>
          </A>
        </B>
        <xsl:apply-templates select="DETAILS"/>
      </P>
    </LI>
  </xsl:template>

  <xsl:template match="ROOTCAT/DETAILS">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="SHOWCAT">
    <A href="{$root}C{@ID}">
      <xsl:apply-templates/>
    </A>
  </xsl:template>



  <xsl:template name="ADDJOURNAL_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_addjournal"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="ADDJOURNAL_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_addjournal"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="ADDJOURNAL_MAINBODY">
    <xsl:apply-templates select="POSTJOURNALUNREG"/>
    <xsl:apply-templates select="POSTJOURNALFORM"/>
  </xsl:template>

  <xsl:template match="POSTJOURNALUNREG">
    <xsl:choose>
      <xsl:when test="@RESTRICTED = 1">
        <xsl:call-template name="m_cantpostrestricted"/>
      </xsl:when>
      <xsl:when test="@REGISTERED = 1">
        You haven't agreed to the standard terms and conditions for this site.
      </xsl:when>
      <xsl:otherwise>
        We're sorry, but you can't have a journal without being registered.
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
  </xsl:template>


  <xsl:template name="REGISTER_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_registrationtitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="REGISTER_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_registrationtitle"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="REGISTER_MAINBODY">
    <!--
	possibilities:
		REGISTER STATUS='NEWEMAIL' - they haven't registered before
		REGISTER STATUS='ALREADY' - they're already logged in as that email address
		REGISTER STATUS='LOGGEDIN' - Successfully logged them in
		REGISTER STATUS='BADPASSWORD' - password didn't match
		REGISTER STATUS='ASKPASSWORD' - ask for a password
		REGISTER STATUS='OLDEMAIL' - already registered - resend email address
		REGISTER STATUS='BADEMAIL' - email was malformed - give error message
		REGISTER STATUS='NODETAILS' - Display the whole register page
		REGISTER STATUS='CONFIRMTERMS' - Display terms and get user to confirm them
		REGISTER STATUS='UNMATCHEDPASSWORD' - passwords entered don't match
		REGISTER STATUS='BLANKPASSWORD' - password was blank
		REGISTER STATUS='REJECTEDTERMS' - user did not accept the terms
		REGISTER STATUS='CONFIRMCANCEL' - Ask user are they sure they want to cancel the account
		REGISTER STATUS='CANCELLED' - The account was cancelled
		REGISTER STATUS='NOTCANCELLED' - The account was not cancelled in the end
		REGISTER STATUS='CANCELERROR' - some problem occurred during cancellation
	-->

    <!--
	This script is used to prevent people submitting the form without agreeing to
	the terms and conditions.
-->
    <SCRIPT>
      <xsl:comment>
        accept= 0;
        function toggleaccept()
        {
        if (accept == 0)
        {
        accept = 1;
        }
        else
        {
        accept = 0;
        }
        return true;
        }
        function haveaccepted()
        {
        if (accept == 1)
        {
        return (true);
        }
        else
        {
        alert("You cannot log in until you have accepted the terms and conditions. Please tick the 'I Accept' box.");
        return (false);
        }
        }
        //
      </xsl:comment>
    </SCRIPT>
    <br/>
    <!-- First display a suitable message -->
    <xsl:choose>
      <xsl:when test="REGISTER[@STATUS='NEWEMAIL']">
        <xsl:call-template name="m_regnewemail"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='LOGGEDIN']">
        <xsl:choose>
          <xsl:when test="REGISTER[ACTIVE=1]">
            <meta http-equiv="REFRESH">
              <xsl:attribute name="content">
                0;url=<xsl:value-of select="$root"/>U<xsl:value-of select="REGISTER/USERID"/>
              </xsl:attribute>
            </meta>
            <xsl:call-template name="m_regwaittransfer"/>
          </xsl:when>
          <xsl:otherwise>
            <meta http-equiv="REFRESH">
              <xsl:attribute name="content">
                0;url=<xsl:value-of select="$root"/>Welcome
              </xsl:attribute>
            </meta>
            <xsl:call-template name="m_regwaitwelcomepage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='OLDEMAIL']">
        <xsl:call-template name="m_regoldemail"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='ALREADY']">
        <xsl:call-template name="m_regalready"/>
        <BR/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='BADPASSWORD']">
        <xsl:call-template name="m_regbadpassword"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='UNMATCHEDPASSWORD']">
        <P>
          <xsl:value-of select="$m_unmatchedpasswords"/>
        </P>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='BLANKPASSWORD']">
        <P>
          <xsl:value-of select="$m_blankpassword"/>
        </P>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='TERMSERROR']">
        <xsl:call-template name="m_termserror"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='ACCOUNTSUSPENDED']">
        <P>
          <xsl:choose>
            <xsl:when test="REGISTER/DATERELEASED">
              <xsl:call-template name="m_accountsuspendedsince"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="m_accountsuspended"/>
            </xsl:otherwise>
          </xsl:choose>
        </P>
      </xsl:when>
    </xsl:choose>
    <!-- Now display the appropriate form -->
    <xsl:choose>
      <!--<xsl:when test="REGISTER[@STATUS='BADPASSWORD' | STATUS='ASKPASSWORD']">-->
      <xsl:when test="REGISTER[@STATUS='BADPASSWORD']|REGISTER[@STATUS='ASKPASSWORD']">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_enterpassword"/>
          </xsl:with-param>
        </xsl:call-template>
        <blockquote>
          <xsl:call-template name="m_passwordintro"/>
          <FORM METHOD="POST" action="{$root}Register" ONSUBMIT="return haveaccepted()">
            <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="withpassword"/>

            <div class="termsbox">
              <TEXTAREA READONLY="1" rows="10" cols="60" WRAP="VIRTUAL" NAME="terms">
                <xsl:call-template name="m_terms"/>
              </TEXTAREA>
            </div><br/>
            <INPUT TYPE="CHECKBOX" NAME="accept" VALUE="1" ONCLICK="return toggleaccept()"/>I Accept these conditions<br/>


            <xsl:value-of select="$m_emailaddr"/><INPUT TYPE="TEXT" NAME="email">
              <xsl:attribute name="value">
                <xsl:value-of select="REGISTER/EMAILADDRESS"/>
              </xsl:attribute>
            </INPUT><BR/>
            <xsl:value-of select="$m_password"/><INPUT TYPE="PASSWORD" NAME="password"/><BR/>
            <INPUT TYPE="CHECKBOX" NAME="remember" value="1"/><xsl:value-of select="$m_alwaysremember"/><BR/>
            <INPUT TYPE="SUBMIT" NAME="Register" VALUE="{$alt_login}"/>
          </FORM>
        </blockquote>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='NODETAILS'] | REGISTER[@STATUS='BADEMAIL']">
        <xsl:if test="REGISTER[@STATUS='BADEMAIL']">
          <BLOCKQUOTE>
            <xsl:call-template name="m_dodgyemail"/>
          </BLOCKQUOTE>
        </xsl:if>
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_newusers"/>
          </xsl:with-param>
        </xsl:call-template>
        <blockquote>
          <xsl:call-template name="m_registrationblurb"/>
          <FORM METHOD="POST" action="{$root}register">
            <xsl:value-of select="$m_emailaddr"/>
            <INPUT TYPE="TEXT" NAME="email" value=""/>
            <br/>
            <INPUT TYPE="SUBMIT" NAME="Register" VALUE="{$alt_register}"/>
          </FORM>
        </blockquote>
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_existingusers"/>
          </xsl:with-param>
        </xsl:call-template>
        <blockquote>
          <xsl:call-template name="m_loginblurb"/>
          <FORM METHOD="POST" action="{$root}register" ONSUBMIT="return haveaccepted()">
            <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="withpassword"/>

            <div class="termsbox">
              <TEXTAREA READONLY="1" rows="10" cols="60" WRAP="VIRTUAL" NAME="terms">
                <xsl:call-template name="m_terms"/>
              </TEXTAREA>
            </div><br/>
            <INPUT TYPE="CHECKBOX" NAME="accept" VALUE="1" ONCLICK="return toggleaccept()"/>I Accept these conditions<br/>

            <xsl:value-of select="$m_emailaddr"/><INPUT TYPE="TEXT" NAME="email" value=""/><BR/>
            <xsl:value-of select="$m_password"/><INPUT TYPE="PASSWORD" NAME="password"/><BR/>
            <INPUT TYPE="CHECKBOX" NAME="remember" value="1"/><xsl:value-of select="$m_alwaysremember"/><BR/>
            <br/>
            <INPUT TYPE="SUBMIT" NAME="Register" VALUE="{$alt_login}" ONCLICK=""/>
          </FORM>
        </blockquote>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='CONFIRMTERMS'] | REGISTER[@STATUS='BLANKPASSWORD'] | REGISTER[@STATUS='UNMATCHEDPASSWORD']">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_confregistration"/>
          </xsl:with-param>
        </xsl:call-template>
        <FORM METHOD="POST" action="{$root}Register">
          <xsl:if test="REGISTER[ACTIVE=1]">
            <xsl:attribute name="ONSUBMIT">return haveaccepted()</xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="REGISTER[ACTIVE=1]">
              <xsl:call-template name="m_termsforregistered"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="m_acceptblurb"/>
            </xsl:otherwise>
          </xsl:choose>
          <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="accept"/>
          <INPUT TYPE="HIDDEN" NAME="key" VALUE="{REGISTER/SECRETKEY}"/>
          <INPUT TYPE="HIDDEN" NAME="email">
            <xsl:attribute name="value">
              <xsl:value-of select="REGISTER/EMAILADDRESS"/>
            </xsl:attribute>
          </INPUT>
          <INPUT TYPE="HIDDEN" NAME="userid" VALUE="{REGISTER/USERID}"/>
          <table>
            <tr>
              <td>
                <xsl:value-of select="$m_password"/>
              </td>
              <td>
                <INPUT TYPE="PASSWORD" NAME="password"/>
              </td>
            </tr>
            <tr>
              <td>
                <xsl:value-of select="$m_confirmpassword"/>
              </td>
              <td>
                <INPUT TYPE="PASSWORD" NAME="password1"/>
              </td>
            </tr>
          </table>
          <xsl:choose>
            <xsl:when test="REGISTER[ACTIVE=0]">
              <div class="termsbox">
                <TEXTAREA READONLY="1" rows="10" cols="60" WRAP="VIRTUAL" NAME="terms">
                  <xsl:call-template name="m_terms"/>
                </TEXTAREA>
              </div>
              <br/>
              <INPUT TYPE="SUBMIT" NAME="accept" VALUE="{$m_iaccept}"/>
              <INPUT TYPE="SUBMIT" NAME="notaccept" VALUE="{$m_idonotaccept}"/>
            </xsl:when>
            <xsl:otherwise>
              <div class="termsbox">
                <TEXTAREA READONLY="1" rows="10" cols="60" WRAP="VIRTUAL" NAME="terms">
                  <xsl:call-template name="m_terms"/>
                </TEXTAREA>
              </div><br/>
              <INPUT TYPE="CHECKBOX" NAME="accept" VALUE="1" ONCLICK="return toggleaccept()"/>I Accept these conditions<br/>

              <INPUT TYPE="SUBMIT" NAME="accept" VALUE="{$alt_changepasswordlogin}"/>
            </xsl:otherwise>
          </xsl:choose>
        </FORM>

      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='REJECTEDTERMS']">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_sorrytermsrejectedtitle"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="m_sorryrejectedterms"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='CONFIRMCANCEL']">
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_warningcancellingaccount"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="m_abouttocancelaccount"/>
        <FORM METHOD="POST" action="{$root}Register">
          <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="docancel"/>
          <INPUT TYPE="HIDDEN" NAME="key" VALUE="{REGISTER/SECRETKEY}"/>
          <INPUT TYPE="HIDDEN" NAME="userid" VALUE="{REGISTER/USERID}"/>
          <INPUT TYPE="SUBMIT" NAME="confirm" VALUE="{$m_yescancelaccount}"/>
          <INPUT TYPE="SUBMIT" NAME="noconfirm" VALUE="{$m_noleaveaccountactive}"/>
          <br/>
        </FORM>

      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='CANCELLED']">
        <xsl:call-template name="m_accountcancelled"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='NOTCANCELLED']">
        <xsl:call-template name="m_notcancelled"/>
      </xsl:when>
      <xsl:when test="REGISTER[@STATUS='CANCELERROR']">
        <P>
          <xsl:value-of select="$m_problemcancelling"/>
          <xsl:value-of select="REGISTER/CANCELREASON"/>
        </P>
      </xsl:when>
    </xsl:choose>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
  </xsl:template>

  <xsl:template name="NEWREGISTER_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_registrationtitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="NEWREGISTER_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_registrationsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="NEWREGISTER_MAINBODY">
    <!--
	We're expecting a <NEWREGISTER> item with a STATUS param and a COMMAND param.
	Some statuses have different effects depending on what the COMMAND was.

	Possible stati:
		ASSOCIATED
			BBC ID has been successfully associated with an h2g2 account
		NOLOGINNAME
			The user failed to type a loginname
		NOPASSWORD
			The user failed to type a password
		UNMATCHEDPASSWORDS
			Two passwords given didn't match
		LOGINFAILED
			The loginname or password was wrong
		LOGINUSED
			The account couldn't be created because the loginname is already used
		NOTERMS
			They didn't agree to the terms
		H2G2BADLOGIN
			The h2g2 email addres or password didn't match a valid user
		H2G2ALREADYHASLOGIN
			The h2g2 account already has a valid login
		BBCLOGINUSEDALREADY
			The login the user wants to associate with an h2g2 ID is already used
		H2G2UNKOWNERROR
			No idea what caused this
		HASHFAILED
			The hash didn't match the data it was protecting
		
	Possible COMMANDS
		returning - a returning h2g2 researcher wants to create/use a BBC id
					with their existing account
		normal - no attempt should be made to associate with an existing ID
		fasttrack - just show the loginname/password fields
-->
    <xsl:choose>
      <!-- do the cases where no form needs to be displayed -->
      <xsl:when test="NEWREGISTER[@STATUS='ASSOCIATED']|NEWREGISTER[@STATUS='LOGGEDIN']">
        <xsl:choose>
          <xsl:when test="NEWREGISTER/REGISTER-PASSTHROUGH">
            <xsl:choose>
              <xsl:when test="NEWREGISTER/FIRSTTIME=0">
                <xsl:call-template name="m_passthroughwelcomeback"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="m_passthroughnewuser"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="NEWREGISTER/REGISTER-PASSTHROUGH" mode="completed"/>
          </xsl:when>
          <xsl:when test="NEWREGISTER[FIRSTTIME=0]">
            <meta http-equiv="REFRESH">
              <xsl:attribute name="content">
                0;url=<xsl:value-of select="$root"/>U<xsl:value-of select="NEWREGISTER/USERID"/>
              </xsl:attribute>
            </meta>
            <xsl:call-template name="m_regwaittransfer"/>
          </xsl:when>
          <xsl:otherwise>
            <meta http-equiv="REFRESH">
              <xsl:attribute name="content">
                0;url=<xsl:value-of select="$root"/>Welcome
              </xsl:attribute>
            </meta>
            <xsl:call-template name="m_regwaitwelcomepage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- add more redirect stuff here -->

      <xsl:when test="$test_registererror">
        <xsl:copy-of select="$m_registernouser"/>
      </xsl:when>
      <!-- Now deal with outputting the form and reporting any errors -->
      <xsl:otherwise>
        <!--	for ease, we'll break the page up into sections.
				The Top part will be for general errors.
				Then there's a separate section for errors which *might*
				only happen when associating with an existing ID
				We'll use two separate templates for these, to make redesigning
				the forms easier.
		 -->

        <!-- now just output the correct form -->
        <!--xsl:apply-templates select="NEWREGISTER"/-->
        <xsl:choose>
          <xsl:when test="NEWREGISTER[@COMMAND='normal']">
            <xsl:copy-of select="$m_dnaregistertext"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$m_dnasignintext"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- generic newregister template to fall back to -->
  <xsl:template match="NEWREGISTER">
    <xsl:call-template name="register-mainerror"/>
    <xsl:call-template name="register-associateerror"/>
  </xsl:template>

  <!-- form generation for a returning user -->
  <xsl:template match="NEWREGISTER[@COMMAND='returning']">
    <xsl:call-template name="m_returninguserblurb"/>
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <FORM METHOD="POST" ACTION="{$bbcregscript}">
      <INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
      <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="returning"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <INPUT TYPE="TEXT" NAME="loginname" VALUE="{LOGINNAME}"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <INPUT TYPE="password" NAME="password"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_confirmbbcpassword"/>
          </TD>
          <TD>
            <INPUT TYPE="password" NAME="password2"/>
          </TD>
        </TR>
        <TR>
          <TD COLSPAN="2">
            <HR/>
            <div class="registerassociateerror">
              <xsl:call-template name="register-associateerror"/>
            </div>
            <br/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_emailaddr"/>
          </TD>
          <TD>
            <INPUT TYPE="TEXT" NAME="email" VALUE="{EMAIL}"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_h2g2password"/>
          </TD>
          <TD>
            <INPUT TYPE="PASSWORD" NAME="h2g2password"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="CHECKBOX" NAME="remember" VALUE="1"/>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <TR>
          <TD COLSPAN="2">
            <xsl:call-template name="m_terms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="CHECKBOX" NAME="terms" VALUE="1"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="m_agreetoterms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="SUBMIT" NAME="submit" VALUE="{$m_newreactivatebutton}"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>
  </xsl:template>

  <!-- form generation for fasttrack login -->
  <xsl:template match="NEWREGISTER[@COMMAND='agreeterms']">
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <xsl:call-template name="m_bbcloginblurb"/>
    <br/>
    <FORM METHOD="POST" ACTION="{$bbcregscript}">
      <INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
      <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="fasttrack"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <INPUT TYPE="TEXT" NAME="loginname" VALUE="{LOGINNAME}"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <INPUT TYPE="password" NAME="password"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="CHECKBOX" NAME="remember" VALUE="1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <TR>
          <TD COLSPAN="2">
            <div class="termsbox">
              <xsl:call-template name="m_terms"/>
            </div>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="CHECKBOX" NAME="terms" VALUE="1"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="m_agreetoterms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT TYPE="SUBMIT" NAME="submit" VALUE="{$m_newloginbutton}"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>

  </xsl:template>

  <xsl:template match="REGISTER-PASSTHROUGH[@ACTION='postforum']" mode="completed">
    <xsl:choose>
      <xsl:when test="PARAM[@NAME='post']=0">
        <A href="{$root}AddThread?forum={PARAM[@NAME='forum']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
          <xsl:value-of select="$m_ptclicktostartnewconv"/>
        </A>
      </xsl:when>
      <xsl:otherwise>
        <A href="{$root}AddThread?inreplyto={PARAM[@NAME='post']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
          <xsl:value-of select="$m_ptclicktowritereply"/>
        </A>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="REGISTER-PASSTHROUGH[@ACTION='editpage']" mode="completed">
    <xsl:call-template name="m_ptwriteguideentry"/>
  </xsl:template>


  <xsl:template name="regpassthroughhref">
    <xsl:param name="url">Login</xsl:param>
    <xsl:choose>
      <xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH">
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>
          <xsl:value-of select="$url"/>
          <xsl:for-each select="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH">
            <xsl:text>?pa=</xsl:text>
            <xsl:value-of select="@ACTION"/>
            <xsl:for-each select="PARAM">
              <xsl:text>&amp;pt=</xsl:text>
              <xsl:value-of select="@NAME"/>
              <xsl:text>&amp;</xsl:text>
              <xsl:value-of select="@NAME"/>=<xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>
          <xsl:value-of select="$url"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="register-associateerror">
    <xsl:choose>
      <xsl:when test="@STATUS='H2G2BADLOGIN'">
        <xsl:value-of select="$m_badlogin"/>
        <br/>
      </xsl:when>
      <xsl:when test="@STATUS='H2G2ALREADYHASLOGIN'">
        <xsl:value-of select="$m_alreadyhaslogin"/>
        <br/>
      </xsl:when>
      <xsl:when test="@STATUS='BBCLOGINUSEDALREADY'">
        <xsl:value-of select="$m_bbcloginalreadyused"/>
        <br/>
      </xsl:when>
      <xsl:when test="@STATUS='H2G2UNKOWNERROR'">
        <xsl:value-of select="$m_followingproblem"/>
        <xsl:value-of select="MESSAGE"/>
        <br/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="INFO_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_interestingfacts"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="INFO_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_h2g2stats"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="INFO_MAINBODY">
    <xsl:apply-templates select="INFO"/>
  </xsl:template>



  <xsl:template name="LOGOUT_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_logoutheader"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="LOGOUT_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_logoutsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template name="LOGOUT_MAINBODY">
    <blockquote>
      <xsl:call-template name="m_logoutblurb"/>
    </blockquote>
  </xsl:template>



  <xsl:template name="JOURNAL_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_h2g2journaltitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="JOURNAL_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_journalforresearcher"/>
        <xsl:value-of select="JOURNAL/@USERID"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template name="JOURNAL_MAINBODY">
    <div class="journalbody">
      <xsl:apply-templates select="JOURNAL/JOURNALPOSTS"/>
    </div>
    <div class="journallinks">
      <xsl:if test="JOURNAL/JOURNALPOSTS[@SKIPTO &gt; 0]">
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>MJ<xsl:value-of select="JOURNAL/@USERID"/>?journal=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNAL/JOURNALPOSTS/@SKIPTO) - number(JOURNAL/JOURNALPOSTS/@COUNT)"/>
          </xsl:attribute>
          <xsl:copy-of select="$m_newerentries"/>
        </A>
        &nbsp;
      </xsl:if>
      <xsl:if test="JOURNAL/JOURNALPOSTS[@MORE=1]">
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>MJ<xsl:value-of select="JOURNAL/@USERID"/>?journal=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNAL/JOURNALPOSTS/@SKIPTO) + number(JOURNAL/JOURNALPOSTS/@COUNT)"/>
          </xsl:attribute>
          <xsl:copy-of select="$m_olderentries"/>
        </A>
      </xsl:if>
      <br/>
      <A>
        <xsl:attribute name="HREF">
          <xsl:value-of select="$root"/>U<xsl:value-of select="JOURNAL/@USERID"/>
        </xsl:attribute>
        <xsl:value-of select="$m_backtoresearcher"/>
      </A>
    </div>
  </xsl:template>



  <xsl:template name="NEWEMAIL_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_newemailtitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="NEWEMAIL_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="NEWEMAILSTORED">
            <xsl:value-of select="$m_newemailstored"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_failedtostoreemail"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="JOURNAL/@USERID"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



  <xsl:template name="NEWEMAIL_MAINBODY">
    <br/>
    <blockquote>
      <xsl:choose>
        <xsl:when test="NEWEMAILSTORED">
          <xsl:value-of select="$m_yournewemailstored"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$m_unabletostoreemailbecause"/><xsl:value-of select="NEWEMAILFAILED"/>.
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
      <br/>
    </blockquote>
  </xsl:template>


  <xsl:template name="MOREPAGES_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_morepagestitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="MOREPAGES_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="ARTICLES[@WHICHSET=1]">
            <xsl:value-of select="$m_editedentries"/>
          </xsl:when>
          <xsl:when test="ARTICLES[@WHICHSET=2]">
            <xsl:value-of select="$m_guideentries"/>
          </xsl:when>
          <xsl:when test="ARTICLES[@WHICHSET=3]">
            <xsl:value-of select="$m_cancelledentries"/>
          </xsl:when>
        </xsl:choose>
        <xsl:value-of select="$m_by"/>
        <xsl:value-of select="ARTICLES/USER/USERNAME"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ERROR_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_errortitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="ERROR_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_errorsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>




  <xsl:template name="ERROR_MAINBODY">
    <!-- handle specific errors differently if need be -->
    <xsl:choose>
      <xsl:when test="ERROR/@TYPE = 'UNREGISTERED-USEREDIT'">
        <xsl:call-template name="m_unregistereduserediterror"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- default style for all other error messages -->
        <blockquote>
          <B>
            <xsl:value-of select="$m_followingerror"/>
          </B>
          <xsl:value-of select="ERROR"/>
          <br/>
          <br/>
          <br/>
        </blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="MOREPOSTS_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_morepoststitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="MOREPOSTS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_postingsby"/>
        <xsl:apply-templates select="POSTS" mode="ResearcherName"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="USEREDIT_HEADER">
    <xsl:choose>
      <xsl:when test="INREVIEW">
        <xsl:apply-templates mode="header" select=".">
          <xsl:with-param name="title">
            <xsl:value-of select="$m_articleisinreviewtext"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="header" select=".">
          <xsl:with-param name="title">
            <xsl:value-of select="$m_editpagetitle"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="USEREDIT_SUBJECT">
    <xsl:choose>
      <xsl:when test="INREVIEW">
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_articleisinreviewtext"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <A NAME="top"/>
        <xsl:if test="ARTICLE-PREVIEW/ARTICLE/SUBJECT">
          <xsl:call-template name="SUBJECTHEADER">
            <xsl:with-param name="text">
              <xsl:value-of select="ARTICLE-PREVIEW/ARTICLE/SUBJECT"/>
            </xsl:with-param>
          </xsl:call-template>
          <BR/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="USEREDIT_MAINBODY">
    <br/>

    <xsl:choose>
      <xsl:when test="INREVIEW">
        <xsl:call-template name="m_inreviewtextandlink"/>
      </xsl:when>
      <xsl:otherwise>

        <SCRIPT LANGUAGE="JavaScript">
          <xsl:comment>
            submit=0;
            function runSubmit ()
            {
            submit+=1;
            if(submit&gt;2) {alert("<xsl:value-of select="$m_donotpress"/>"); return (false);}
            if(submit&gt;1) {alert("<xsl:value-of select="$m_atriclesubmitted"/>"); return (false);}
            return(true);
            }
            //
          </xsl:comment>
        </SCRIPT>
        <xsl:apply-templates select="ARTICLE-PREVIEW/ARTICLE/GUIDE/BODY"/>
        <xsl:if test=".//FOOTNOTE">
          <blockquote>
            <div class="footnote">
              <hr/>
              <xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
            </div>
          </blockquote>
        </xsl:if>
        <xsl:if test="ARTICLE-EDIT-FORM">
          <br/>
          <xsl:call-template name="SUBJECTHEADER">
            <xsl:with-param name="text">
              <xsl:choose>
                <xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0">
                  <xsl:value-of select="$m_AddHomePageHeading"/>
                </xsl:when>
                <xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0">
                  <xsl:value-of select="$m_AddGuideEntryHeading"/>
                </xsl:when>
                <xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0">
                  <xsl:value-of select="$m_EditHomePageHeading"/>
                </xsl:when>
                <xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0">
                  <xsl:value-of select="$m_EditGuideEntryHeading"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$m_EditGuideEntryHeading"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
          <!--							<xsl:apply-templates select="ARTICLE/ARTICLE-EDIT-FORM"/>-->
          <xsl:apply-templates select="ARTICLE-EDIT-FORM"/>
          <HR/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="USERDETAILS_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_preferencestitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template name="USERDETAILS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_preferencessubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="USERDETAILS_MAINBODY">
    <xsl:choose>
      <xsl:when test="USER-DETAILS-UNREG">
        <xsl:apply-templates select="USER-DETAILS-UNREG"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$restricted = 0">
            <xsl:apply-templates select="USER-DETAILS-FORM"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="m_restricteduserpreferencesmessage"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="REGISTER-CONFIRMATION_HEADER">
    <META http-equiv="REFRESH">
      <xsl:attribute name="CONTENT">
        10;url=U<xsl:value-of select="REGISTERING-USER/USER/USERID"/>
      </xsl:attribute>
    </META>
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_regconfirm"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template name="REGISTER-CONFIRMATION_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_reginprogress"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="REGISTER-CONFIRMATION_MAINBODY">
    <br/>
    <xsl:call-template name="m_regconfirmation"/>

  </xsl:template>

  <!-- Templates for the various parts of the NewUsers page -->

  <xsl:template name="NEWUSERS_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_NewUsersPageTitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="NEWUSERS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_NewUsersPageHeader"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="NEWUSERS_MAINBODY">
    <blockquote>
      <br/>
      <p>
        <xsl:value-of select="$m_NewUsersPageExplanatory"/>
      </p>
      <form method="get" action="{$root}NewUsers">
        <select name="TimeUnits" title="Number of Time Units">
          <option value="1">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='1'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>1
          </option>
          <option value="2">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='2'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>2
          </option>
          <option value="3">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='3'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>3
          </option>
          <option value="4">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='4'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>4
          </option>
          <option value="5">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='5'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>5
          </option>
          <option value="6">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='6'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>6
          </option>
          <option value="7">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='7'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>7
          </option>
          <option value="8">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='8'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>8
          </option>
          <option value="9">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='9'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>9
          </option>
          <option value="10">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='10'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>10
          </option>
          <option value="11">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='11'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>11
          </option>
          <option value="12">
            <xsl:if test="NEWUSERS-LISTING/@TIMEUNITS='12'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>12
          </option>
        </select>
        <xsl:text> </xsl:text>
        <select name="UnitType" title="Type of Time Unit">
          <option value="month">
            <xsl:if test="NEWUSERS-LISTING/@UNITTYPE='month'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Months
          </option>
          <option value="week">
            <xsl:if test="NEWUSERS-LISTING/@UNITTYPE='week'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Weeks
          </option>
          <option value="day">
            <xsl:if test="NEWUSERS-LISTING/@UNITTYPE='day'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Days
          </option>
          <option value="hour">
            <xsl:if test="NEWUSERS-LISTING/@UNITTYPE='hour'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Hours
          </option>
        </select>
        <xsl:text> </xsl:text>
        <input type="submit" value="{$m_NewUsersPageSubmitButtonText}"/>
        <br/>
        <br/>
        <xsl:element name="input">
          <xsl:attribute name="type">radio</xsl:attribute>
          <xsl:attribute name="name">Filter</xsl:attribute>
          <xsl:attribute name="value">off</xsl:attribute>
          <xsl:if test="not(NEWUSERS-LISTING/@FILTER-USERS=1)">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$m_UsersAll"/>
        </xsl:element>
        <br/>
        <xsl:element name="input">
          <xsl:attribute name="type">radio</xsl:attribute>
          <xsl:attribute name="name">Filter</xsl:attribute>
          <xsl:attribute name="value">haveintroduction</xsl:attribute>
          <xsl:if test="NEWUSERS-LISTING/@FILTER-TYPE='haveintroduction'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$m_UsersWithIntroductions"/>
        </xsl:element>
        <br/>
        <xsl:element name="input">
          <xsl:attribute name="type">radio</xsl:attribute>
          <xsl:attribute name="name">Filter</xsl:attribute>
          <xsl:attribute name="value">noposting</xsl:attribute>
          <xsl:if test="NEWUSERS-LISTING/@FILTER-TYPE='noposting'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$m_UsersWithIntroductionsNoPostings"/>
        </xsl:element>
        <br/>
        <!--<input type="checkbox" name="thissite" value="1">
					<xsl:if test="NEWUSERS-LISTING/@SITEID">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input><xsl:value-of select="$m_onlyshowusersfromthissite"/><br/>-->
      </form>
      <xsl:apply-templates select="NEWUSERS-LISTING"/>
    </blockquote>
  </xsl:template>

  <!-- end of NewUsers page templates -->

  <xsl:template name="SHAREANDENJOY_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_shareandenjoytitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="SHAREANDENJOY_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_shareandenjoytitle"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SHAREANDENJOY_MAINBODY">
    <br/>
    <!-- First put up any error messages -->
    <xsl:choose>
      <xsl:when test="SHAREANDENJOY[@STATUS='BADEMAIL']">
        <xsl:call-template name="m_sharebademail"/>
      </xsl:when>
      <xsl:when test="SHAREANDENJOY[@STATUS='NOMESSAGE']">
        <xsl:call-template name="m_sharenomessage"/>
      </xsl:when>
      <xsl:when test="SHAREANDENJOY[@STATUS='ALREADYJOINED']">
        <xsl:call-template name="m_sharealreadyjoined"/>
      </xsl:when>
      <xsl:when test="SHAREANDENJOY[@STATUS='ALREADYASKED']">
        <xsl:call-template name="m_sharealreadyasked"/>
      </xsl:when>
      <xsl:when test="SHAREANDENJOY[@STATUS='UNREGISTERED']">
        <xsl:call-template name="m_shareunregistered"/>
      </xsl:when>
      <xsl:when test="SHAREANDENJOY[@STATUS='SUCCESS']">
        <xsl:call-template name="m_sharesuccess"/>
      </xsl:when>
    </xsl:choose>

    <!-- Now put up the form if appropriate -->
    <xsl:if test="SHAREANDENJOY[@STATUS='INITIAL']">
      <xsl:call-template name="m_shareandenjoyintro"/>
    </xsl:if>
    <xsl:if test="SHAREANDENJOY[contains('INITIAL.NOMESSAGE.BADEMAIL.ALREADYJOINED.ALREADYASKED',@STATUS)]">
      <FORM METHOD="POST" action="{$root}ShareAndEnjoy">
        <xsl:value-of select="$m_emailaddress"/>
        <INPUT TYPE="TEXT" NAME="email" VALUE="{SHAREANDENJOY/EMAILADDRESS}"/>
        <br/>
        <xsl:value-of select="$m_welcomemessage"/>
        <br/>
        <TEXTAREA ROWS="10" COLS="50" NAME="welcome">
          <xsl:value-of select="SHAREANDENJOY/MESSAGE"/>
        </TEXTAREA>
        <br/>
        <INPUT TYPE="SUBMIT" NAME="invite" VALUE="{$alt_inviteuser}"/>
        <!--<br/><INPUT TYPE="TEXT" NAME="skin" VALUE=""/>-->
      </FORM>
    </xsl:if>
  </xsl:template>


  <xsl:template name="DIAGNOSE_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">h2g2 Diagnostics</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="DIAGNOSE_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="ARTICLE/SUBJECT"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="DIAGNOSE_MAINBODY">
    <DIV>
      <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
    </DIV>
  </xsl:template>

  <!--
	RECOMMEND-ENTRY page templates
-->

  <xsl:template name="RECOMMEND-ENTRY_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_RecommendEntryPageTitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="RECOMMEND-ENTRY_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_RecommendEntryPageHeader"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="RECOMMEND-ENTRY_MAINBODY">
    <br/>
    <xsl:apply-templates select="/H2G2/RECOMMEND-ENTRY-FORM"/>
    <br/>
  </xsl:template>



  <xsl:template name="EDITREVIEW_HEADER">
    <xsl:choose>
      <xsl:when test="EDITREVIEWFORM/BLANKFORM">
        <xsl:apply-templates mode="header" select=".">
          <xsl:with-param name="title">
            <xsl:value-of select="$m_addnewreviewforum_title"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="header" select=".">
          <xsl:with-param name="title">
            <xsl:value-of select="$m_editreviewtitle"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>


  </xsl:template>

  <xsl:template name="EDITREVIEW_SUBJECT">
    <xsl:choose>
      <xsl:when test="EDITREVIEWFORM/BLANKFORM">
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_addnewreviewforum_title"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_editreviewtitle"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="EDITREVIEW_MAINBODY">
    <br/>
    <xsl:apply-templates select="/H2G2/EDITREVIEWFORM"/>
    <br/>
  </xsl:template>


  <!-- buttons and stuff for forum code -->

  <xsl:template name="forum_button_rewind">
    &lt;&lt;<xsl:value-of select="$m_showoldest"/>
  </xsl:template>

  <xsl:template name="forum_button_reverse">
    &lt;<xsl:value-of select="$m_showolder"/>
  </xsl:template>

  <xsl:template name="forum_button_play">
    <xsl:value-of select="$m_shownewer"/>&gt;
  </xsl:template>

  <xsl:template name="forum_button_fforward">
    <xsl:value-of select="$m_shownewest"/>&gt;&gt;
  </xsl:template>




  <xsl:template match="SUBSCRIBE-RESULT">
    <xsl:choose>
      <xsl:when test="@TOTHREAD">
        <xsl:value-of select="$m_subscribedtothread"/>
        <br/>
      </xsl:when>
      <xsl:when test="@TOFORUM">
        <xsl:value-of select="$m_subscribedtoforum"/>
        <br/>
      </xsl:when>
      <xsl:when test="@FROMFORUM">
        <xsl:value-of select="$m_unsubbedfromforum"/>
        <br/>
      </xsl:when>
      <xsl:when test="@FROMTHREAD">
        <xsl:choose>
          <xsl:when test="@FAILED">
            <xsl:value-of select="."/>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@JOURNAL">
                <xsl:value-of select="$m_journalremoved"/>
                <br/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$m_unsubscribedfromthread"/>
                <br/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 
	Include this template in *all* stylesheets which wish to have
	a simplified popup window
-->
  <!--
<xsl:template match='H2G2[@TYPE="SUBSCRIBE"]'>
<xsl:call-template name="popsubscribe"/>
</xsl:template>
-->

  <xsl:template name="popsubscribe">
    <html>
      <head>
        <title>
          <xsl:value-of select="$m_subscriberesult"/>
        </title>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
      </head>
      <body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
        <SCRIPT LANGUAGE="JavaScript">
          <xsl:comment>
            function closewin()
            {
            return window.close();
            }
          </xsl:comment>
        </SCRIPT>
        <xsl:apply-templates select="SUBSCRIBE-RESULT"/>
        <a href="{$root}javascript:closewin()">
          <xsl:value-of select="$m_close"/>
        </a>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="SUBSCRIBE_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="SUBSCRIBE-RESULT/@TOTHREAD">
            <xsl:value-of select="$m_subthreadcomplete"/>
          </xsl:when>
          <xsl:when test="SUBSCRIBE-RESULT/@TOFORUM">
            <xsl:value-of select="$m_subforumcomplete"/>
          </xsl:when>
          <xsl:when test="SUBSCRIBE-RESULT/@JOURNAL">
            <xsl:value-of select="$m_journalremovecomplete"/>
          </xsl:when>
          <xsl:when test="SUBSCRIBE-RESULT/@FROMTHREAD">
            <xsl:value-of select="$m_unsubthreadcomplete"/>
          </xsl:when>
          <xsl:when test="SUBSCRIBE-RESULT/@FROMFORUM">
            <xsl:value-of select="$m_unsubforumcomplete"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_subrequestfailed"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SUBSCRIBE_MAINBODY">
    <xsl:apply-templates select="SUBSCRIBE-RESULT"/>
    <xsl:apply-templates select="RETURN-TO"/>
  </xsl:template>


  <xsl:template match="RETURN-TO">
    <a href="{$root}{URL}" xsl:use-attribute-sets="mRETURN-TO">
      <xsl:value-of select="DESCRIPTION"/>
    </a>
    <br/>
  </xsl:template>

  <!-- delete these soon -->
  <xsl:template name="_HEADER">
  </xsl:template>
  <xsl:template name="_SUBJECT">
  </xsl:template>
  <xsl:template name="_MAINBODY">
  </xsl:template>
  <xsl:template name="_SIDEBAR">
  </xsl:template>
  <xsl:template name="_BOTTOMSIDEBAR">
  </xsl:template>

  <xsl:template name="CopyrightNotice">
    <!-- start of copyright notice -->
    <div class="copyrightnotice">
      <br/>
      <b>
        <xsl:call-template name="m_copyright2"/>
      </b>
      <br/>
      <br/>
      <!--<a href="/dna/hub/"><img src="{$imagesource}by_dna.gif" width="100" height="26" alt="Powered by DNA" border="0"/></a>-->
      <a href="/dna/hub/">Powered by DNA, the BBC's community website engine</a>
      <br/>
      <br/>
    </div>
    <!-- end of copyright notice -->
  </xsl:template>

  <xsl:template match="SHOWJOURNALPOST[@LATEST]">
    <xsl:apply-templates select="/H2G2/JOURNAL/JOURNALPOSTS/POST[position() = 1]"/>
    <br/>
  </xsl:template>

  <xsl:template match="TD">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="displayunregisteredslug">
    <xsl:call-template name="unregisteredslug"/>
  </xsl:template>

  <xsl:template name="unregisteredslug">
    <p>
      <!--<form method="POST" action="{$root}Register">-->
      <div xsl:use-attribute-sets="registermessage">
        <xsl:call-template name="m_registerslug"/>
        <!--	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
			<font xsl:use-attribute-sets="registermessage"><xsl:value-of select="$m_emailaddress"/></font> 
		</td>
		<td>
		</td>
		<td>
			<input type="TEXT" name="email" value="" size="15"/> 
		</td>
		</tr>
	</table>
	<center>
		<input type="SUBMIT" name="Register" value="Register" /> 
	</center>
-->
      </div>
      <!--</form>-->
    </p>
  </xsl:template>

  <xsl:template match="SKINSELECT">
    <xsl:choose>
      <xsl:when test="WHENSKIN[@NAME=$skinname]">
        <xsl:apply-templates select="WHENSKIN[@NAME=$skinname]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="SKINOTHERWISE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="WHENSKIN">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="SKINOTHERWISE">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="FORM">
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <xsl:template match="GUIDE">
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <xsl:template match="SCRIPT|OBJECT|EMBED|BGSOUND|APPLET|IFRAME|META|STYLE|IMAGE">
    <!--<xsl:choose>
<xsl:when test="contains(translate(.,$uppercase,$lowercase),'cookie')">
<xsl:call-template name="m_scriptremoved"/>
</xsl:when>
<xsl:otherwise>
<xsl:copy><xsl:apply-templates select="*|@*|text()|comment()"/></xsl:copy>
</xsl:otherwise>
</xsl:choose>
-->
    <!-- just get rid of all of them -->
    <xsl:comment>
      <xsl:call-template name="m_scriptremoved"/>
    </xsl:comment>
  </xsl:template>

  <xsl:template match="SOUNDBITE">
    <table align="right" bgcolor="#ffffcc" border="0" cellpadding="3" cellspacing="0" width="150" vspace="2" hspace="2">
      <tbody>
        <tr>
          <td>

            <div STYLE="COLOR: #990000; FONT-FAMILY: Verdana, Arial, Helvetica, Sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold">
              "<xsl:apply-templates select="QUOTE"/>"
            </div>
          </td>
        </tr>

        <tr>
          <td bgcolor="#cccc99">
            <div STYLE="COLOR: #333300; FONT-FAMILY: Verdana, Arial, Helvetica, Sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold; PADDING-LEFT: 8px">
              <xsl:apply-templates select="SPEAKER"/>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="BOXOUT">
    <table align="right" bgcolor="#ffffcc" border="0" cellpadding="3" cellspacing="0" width="150" vspace="2" hspace="2">
      <tbody>
        <tr>
          <td bgcolor="#cccc99">
            <div STYLE="COLOR: #333300; FONT-FAMILY: Verdana, Arial, Helvetica, Sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold; PADDING-LEFT: 8px">
              <b>
                <xsl:value-of select="TITLE"/>
              </b>
            </div>
          </td>
        </tr>

        <tr>
          <td>
            <div STYLE="COLOR: #990000; FONT-FAMILY: Verdana, Arial, Helvetica, Sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold">
              <xsl:for-each select="ITEM">
                <div STYLE="BACKGROUND: url(/furniture/aro_red_sm2.gif) #ffffcc no-repeat 2px 1px; PADDING-LEFT: 8px">
                  <xsl:value-of select="."/>
                </div>
              </xsl:for-each>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="XMLPARSEERROR">
    An XML Parsing error occurred.<br/>
    <xsl:value-of select="REASON"/><br/>
    at line <xsl:value-of select="LINENUMBER"/>, character <xsl:value-of select="CHARACTER"/><br/>
    <br/>
    <xsl:choose>
      <xsl:when test="SOURCE">
        <font size="3">
          <SAMP>
            <xsl:value-of select="substring(SOURCE,1,number(CHARACTER)-1)"/>
            <b>
              <font color="red">[here]</font>
            </b>
            <xsl:value-of select="substring(SOURCE,number(CHARACTER))"/>
          </SAMP>
        </font>
      </xsl:when>
      <xsl:otherwise>
        We are unable to display the line containing the error.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='FORUM-MODERATION']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: Forum Postings</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
        <script language="JavaScript">
          <![CDATA[
<!-- hide this script from non-javascript-enabled browsers
function IsEmpty(str)
{
	for (var i = 0; i < str.length; i++)
	{
		var ch = str.charCodeAt(i);
		if (ch > 32)
		{
			return false;
		}
	}

	return true;
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

function setAllDecisions(value)
{
	if (value >= 0)
	{
		var i = 0;

		for (i = 0; i < document.ForumModerationForm.elements.length; i++)
		{
			if (document.ForumModerationForm.elements[i].name == 'Decision')
			{
				document.ForumModerationForm.elements[i].value = value;
			}
		}
	}
	return true;
}

function setAllReferTos(value,index)
{

	if (value >= 0)
	{
		var i =0;

		for (i=0; i < document.ForumModerationForm.elements.length; i++)
		{
			//finds the referto select node
			if (document.ForumModerationForm.elements[i].name == 'ReferTo')
			{	
				document.ForumModerationForm.elements[i].value = value;
				document.ForumModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(2);
		document.ForumModerationForm.DecideAll.value = 2;
	}
	return true;
}


function setAllFailedBecause(value,index)
{

	if (index >= 0)
	{
		var i = 0;

		for (i = 0; i < document.ForumModerationForm.elements.length; i++)
		{
			if (document.ForumModerationForm.elements[i].name == 'EmailType')
			{
				document.ForumModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(4);
		document.ForumModerationForm.DecideAll.value = 4;	 
	}

	return true;
}

function checkForumModerationForm()
{
	var totalPosts = 0;
	var i = 0;

	// first find the total number of posts being processed on this page
	for (i = 0; i < document.ForumModerationForm.elements.length; i++)
	{
		if (document.ForumModerationForm.elements[i].name == 'Decision')
		{
			totalPosts++;
		}
	}
	// then go through them all and check that all failed posts have 
	// been given a reason and all referred posts are given a note
	for (i = 1; i <= totalPosts; i++)
	{
		var emailElement = 'ForumModerationForm.EmailType' + i;
		var decisionElement = 'ForumModerationForm.Decision' + i;
		var email = eval(emailElement + '.options[' + emailElement + '.selectedIndex].value');
		var decision = eval(decisionElement + '.options[' + decisionElement + '.selectedIndex].value');

		if (decision == 4 || decision == 6)
		{
			if (email == 'None')
			{
				alert('You must specify a failure reason for all failed postings!');
				return false;
			}
			else
			if (email == 'URLInsert') 
			{
				//if failed with the URL reason - custom email field should be filled
				var customEmail = eval('ForumModerationForm.CustomEmailText' + i + '.value');
				if (IsEmpty(customEmail))
				{
					alert('Custom Email box should be filled if URL is selected as failure reason');
					eval('ForumModerationForm.CustomEmailText' + i + '.focus()')
					return false;
				}
			}
		}
		else
		if (decision == 2) //refer to
		{ 
			var notes = eval('ForumModerationForm.NotesArea' + i + '.value');
			if (IsEmpty(notes))
			{
				alert('Notes box should be filled if the post is referred');
				eval('ForumModerationForm.NotesArea' + i + '.focus()')
				return false;
			}
		}
	}
	return true;
}
// stop hiding -->
				]]>
        </script>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <h2 align="center">
            Forum Moderation :
            <xsl:if test="POST-MODERATION-FORM/@REFERRALS = '1'">Referred </xsl:if>
            <xsl:choose>
              <xsl:when test="POST-MODERATION-FORM/@TYPE='LEGACY'">Legacy Posts</xsl:when>
              <xsl:when test="POST-MODERATION-FORM/@TYPE='NEW'">New Posts</xsl:when>
              <xsl:when test="POST-MODERATION-FORM/@TYPE='COMPLAINTS'">Complaints Posts</xsl:when>
              <xsl:otherwise>Unkown type</xsl:otherwise>
            </xsl:choose>
          </h2>
          <table width="100%">
            <tr>
              <td align="left" valign="top">
                Logged in as <b>
                  <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
                </b>
              </td>
              <td align="right" valign="top">
                <a href="{$root}Moderate">Moderation Home Page</a>
              </td>
            </tr>
          </table>
          <br/>
          <!-- do an error messages -->
          <xsl:if test="POST-MODERATION-FORM/ERROR">
            <span class="moderationformerror">
              <xsl:for-each select="POST-MODERATION-FORM/ERROR">
                <b>
                  <xsl:value-of select="."/>
                </b>
                <br/>
              </xsl:for-each>
            </span>
          </xsl:if>
          <!-- do any other messages -->
          <xsl:if test="POST-MODERATION-FORM/MESSAGE">
            <xsl:choose>
              <xsl:when test="POST-MODERATION-FORM/MESSAGE/@TYPE = 'NONE-LOCKED'">
                <b>
                  You currently have no forum postings of this type allocated to you for moderation. Select a type and click 'Process' to be
                  allocated the next batch of postings of that type waiting to be moderated.
                </b>
                <br/>
              </xsl:when>
              <xsl:when test="POST-MODERATION-FORM/MESSAGE/@TYPE = 'EMPTY-QUEUE'">
                <b>Currently there are no forum postings of the specified type awaiting moderation.</b>
                <br/>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <xsl:value-of select="POST-MODERATION-FORM/MESSAGE"/>
                </b>
                <br/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <form action="{$root}ModerateForums" method="post" name="ForumModerationForm" onSubmit="return checkForumModerationForm()">
            <xsl:if test="POST-MODERATION-FORM/POST">
              <table border="1" cellPadding="2" cellSpacing="0" width="100%">
                <!-- do the column headings -->
                <tbody>
                  <tr align="left" vAlign="top">
                    <td>
                      <b>Post</b>
                    </td>
                    <td>
                      <b>Subject</b>
                    </td>
                    <td width="100%">
                      <b>Text</b>
                    </td>
                    <td>
                      <b>Decision</b>
                    </td>
                  </tr>
                </tbody>
                <!-- and then fill the table -->
                <tbody align="left" vAlign="top">
                  <xsl:for-each select="POST-MODERATION-FORM/POST">
                    <tr>
                      <td align="left" vAlign="top">
                        <a target="ForumViewer">
                          <xsl:attribute name="HREF">
                            <xsl:value-of select="$root"/>F<xsl:value-of select="FORUM-ID"/>?thread=<xsl:value-of select="THREAD-ID"/>&amp;post=<xsl:value-of select="POST-ID"/>#p<xsl:value-of select="POST-ID"/>
                          </xsl:attribute>
                          <xsl:value-of select="POST-ID"/>
                        </a>
                        <br/>
                        <br/>
                        <xsl:apply-templates select="SITEID" mode="showfrom_mod_offsite"/>
                        <input type="hidden" name="PostID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="POST-ID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="ThreadID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="THREAD-ID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="ForumID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="FORUM-ID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="ModID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="MODERATION-ID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="SiteID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="SITEID"/>
                          </xsl:attribute>
                        </input>
                      </td>
                      <td align="left" vAlign="top">
                        <xsl:value-of select="SUBJECT"/>
                      </td>
                      <td align="left" vAlign="top" width="100%">
                        <xsl:apply-templates select="TEXT"/>
                      </td>
                      <td align="left" vAlign="top">
                        <table width="100%" cellpadding="0" cellspacing="0">
                          <tr>
                            <td>
                              <xsl:if test="/H2G2/POST-MODERATION-FORM/@REFERRALS = 1">
                                Referred by
                                <xsl:choose>
                                  <xsl:when test="number(REFERRED-BY/USER/USERID) &gt; 0">
                                    <xsl:apply-templates select="REFERRED-BY/USER"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <span class="moderationformerror">Auto Referral</span>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:if>
                            </td>
                            <td align="right">
                              <a target="_blank" href="{$root}ModerationHistory?PostID={POST-ID}">Show History</a>
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
                                <input type="hidden" name="ComplainantID" value="{COMPLAINANT-ID}"/>
                                <input type="hidden" name="CorrespondenceEmail" value="{CORRESPONDENCE-EMAIL}"/>
                                Complaint from
                                <xsl:choose>
                                  <xsl:when test="string-length(CORRESPONDENCE-EMAIL) &gt; 0">
                                    <a href="mailto:{CORRESPONDENCE-EMAIL}">
                                      <xsl:value-of select="CORRESPONDENCE-EMAIL"/>
                                    </a>
                                  </xsl:when>
                                  <xsl:when test="number(COMPLAINANT-ID) &gt; 0">
                                    Researcher <a href="{$root}U{COMPLAINANT-ID}">
                                      U<xsl:value-of select="COMPLAINANT-ID"/>
                                    </a>
                                  </xsl:when>
                                  <xsl:otherwise>Anonymous Complainant</xsl:otherwise>
                                </xsl:choose>
                                <br/>
                                <textarea cols="30" name="ComplaintText" rows="5" wrap="virtual">
                                  <xsl:value-of select="COMPLAINT-TEXT"/>
                                </textarea>
                                <br/>
                              </xsl:if>
                            </td>
                          </tr>
                        </table>
                        Notes<br/>
                        <textarea ID="NotesArea{position()}" cols="30" name="Notes" rows="5" wrap="virtual">
                          <xsl:value-of select="NOTES"/>
                        </textarea>
                        <br/>
                        <input type="button" name="EditPostButton" value="Edit Post" onClick="popupwindow('{$root}EditPost?PostID={POST-ID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450')"/>
                        &nbsp;
                        <select name="Decision" id="Decision{position()}">
                          <!--													<option value="0">No Decision</option>-->
                          <xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
                            <option value="3" selected="selected">
                              <xsl:value-of select="$m_modrejectpostingcomplaint"/>
                            </option>
                            <option value="4">
                              <xsl:value-of select="$m_modacceptpostingcomplaint"/>
                            </option>
                            <option value="6">
                              <xsl:value-of select="$m_modacceptandeditposting"/>
                            </option>
                          </xsl:if>
                          <xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE!='COMPLAINTS'">
                            <option value="3" selected="selected">Pass</option>
                            <option value="4">Fail</option>
                          </xsl:if>
                          <option value="2">Refer</option>
                          <xsl:if test="/H2G2/POST-MODERATION-FORM/@REFERRALS = 1">
                            <option value="5">Unrefer</option>
                          </xsl:if>
                        </select>
                        <br/>
                        <select name="ReferTo" id="ReferTo{position()}" onChange="javascript:if (selectedIndex != 0) ForumModerationForm.Decision{position()}.value = 2">
                          <xsl:apply-templates select="/H2G2/REFEREE-LIST">
                            <xsl:with-param name="SiteID" select="SITEID"/>
                          </xsl:apply-templates>
                        </select>
                        &nbsp;
                        <select name="EmailType" id="EmailType{position()}" onChange="javascript:if (ForumModerationForm.EmailType{position()}.selectedIndex != 0 &amp;&amp; ForumModerationForm.Decision{position()}.value != 4 &amp;&amp; ForumModerationForm.Decision{position()}.value !=6 ) ForumModerationForm.Decision{position()}.value = 4" title="Select a reason if you are failing this content">
                          <!--
													<option value="None" selected="selected">Failed because:</option>
													<option value="OffensiveInsert">Offensive</option>
													<option value="LibelInsert">Libellous</option>
													<option value="URLInsert">URL</option>
													<option value="PersonalInsert">Personal</option>
													<option value="AdvertInsert">Advertising</option>
													<option value="CopyrightInsert">Copyright</option>
													<option value="PoliticalInsert">Party Political</option>
													<option value="IllegalInsert">Illegal</option>
													<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
														<option value="Custom">Custom (enter below)</option>
													</xsl:if>
-->
                          <xsl:call-template name="m_ModerationFailureMenuItems"/>
                        </select>
                        <br/>
                        <xsl:choose>
                          <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
                            Text for Custom Email
                          </xsl:when>
                          <xsl:when test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR') and not(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')">
                            <xsl:value-of select="$m_ModEnterURLandReason"/>
                            <br/>
                          </xsl:when>
                          <xsl:otherwise>
                            If this posting failed due to URLs, please list them here.
                            Please note that this information will be sent to the researcher
                            who wrote the posting, so please only type the URLs.
                            <br/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <textarea cols="30" rows="5" name="CustomEmailText" id="CustomEmailText{position()}" wrap="virtual"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </xsl:if>
            <br/>
            <input type="hidden" name="Referrals">
              <xsl:attribute name="value">
                <xsl:value-of select="POST-MODERATION-FORM/@REFERRALS"/>
              </xsl:attribute>
            </input>
            <input type="hidden" name="Show">
              <xsl:attribute name="value">
                <xsl:value-of select="POST-MODERATION-FORM/@TYPE"/>
              </xsl:attribute>
            </input>
            <!-- form buttons -->
            <table width="100%">
              <tr>
                <td valign="top" align="left">
                  <input type="submit" name="Next" value="Process" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch"/>
                  <xsl:text> </xsl:text>
                  <input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home"/>
                </td>
                <td valign="top" align="left">
                  <xsl:if test="POST-MODERATION-FORM/POST">
                    Set all decisions to:
                    <select name="DecideAll" onChange="setAllDecisions(this.options[this.selectedIndex].value)">
                      <!--											<option value="0">No Decision</option>-->
                      <option value="-1" selected="selected">Choose one:</option>
                      <xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
                        <option value="3" selected="selected">
                          <xsl:value-of select="$m_modrejectpostingcomplaint"/>
                        </option>
                        <option value="4">
                          <xsl:value-of select="$m_modacceptpostingcomplaint"/>
                        </option>
                        <option value="6">
                          <xsl:value-of select="$m_modacceptandeditposting"/>
                        </option>
                      </xsl:if>
                      <xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE!='COMPLAINTS'">
                        <option value="3">Pass</option>
                        <option value="4">Fail</option>
                      </xsl:if>
                      <option value="2">Refer</option>
                    </select>
                  </xsl:if>
                </td>

                <!-- Referto all -->

                <td valign="top" align="left">
                  <xsl:if test="POST-MODERATION-FORM/POST">
                    Refer to:
                    <select name="DecideAllReferTo" onChange="setAllReferTos(this.options.value,this.selectedIndex);">
                      <xsl:apply-templates select="/H2G2/REFEREE-LIST">
                        <xsl:with-param name="SiteID" select="SITEID"/>
                      </xsl:apply-templates>
                    </select>
                  </xsl:if>
                </td>

                <td valign="top" align="left">
                  <xsl:if test="POST-MODERATION-FORM/POST">
                    Failed Because:
                    <select name="DecideAllFailedBecause" onChange="setAllFailedBecause(this.options.value,this.selectedIndex);">
                      <xsl:call-template name="m_ModerationFailureMenuItems"/>
                    </select>
                  </xsl:if>
                </td>


              </tr>
            </table>
            <br/>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--
	Nickname moderation page
-->

  <xsl:template match="H2G2[@TYPE='MODERATE-NICKNAMES']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: Nicknames</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <h2 align="center">Nickname Moderation</h2>
          <table width="100%">
            <tr>
              <td align="left" valign="top">
                Logged in as <b>
                  <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
                </b>
              </td>
              <td align="right" valign="top">
                <a href="{$root}Moderate">Moderation Home Page</a>
              </td>
            </tr>
          </table>
          <br/>
          <xsl:if test="NICKNAME-MODERATION-FORM/MESSAGE">
            <xsl:choose>
              <xsl:when test="NICKNAME-MODERATION-FORM/MESSAGE/@TYPE = 'NONE-LOCKED'">
                <b>
                  You currently have no nicknames allocated to you for moderation. Click 'Process' to be
                  allocated the next batch of postings waiting to be moderated.
                </b>
                <br/>
              </xsl:when>
              <xsl:when test="NICKNAME-MODERATION-FORM/MESSAGE/@TYPE = 'EMPTY-QUEUE'">
                <b>Currently there are no nicknames awaiting moderation.</b>
                <br/>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <xsl:value-of select="NICKNAME-MODERATION-FORM/MESSAGE"/>
                </b>
                <br/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <form action="{$root}ModerateNicknames" method="post" name="NicknameModerationForm">
            <xsl:if test="NICKNAME-MODERATION-FORM/NICKNAME">
              <table border="1" cellPadding="2" cellSpacing="0">
                <!-- do the column headings -->
                <tbody>
                  <tr align="left" vAlign="top">
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">User ID</font>
                      </b>
                    </td>
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">Nickname</font>
                      </b>
                    </td>
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">First name</font>
                      </b>
                    </td>
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">Last name</font>
                      </b>
                    </td>
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">Site</font>
                      </b>
                    </td>
                    <td>
                      <b>
                        <font face="Arial" size="2" color="black">Pass?</font>
                      </b>
                    </td>
                  </tr>
                </tbody>
                <!-- and then fill the table -->
                <tbody align="left" vAlign="top">
                  <xsl:for-each select="NICKNAME-MODERATION-FORM/NICKNAME">
                    <tr>
                      <td align="left" vAlign="top">
                        <xsl:apply-templates select="USER/USERID"/>
                        <input type="hidden" name="UserID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="USER/USERID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="ModID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="MODERATION-ID"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="UserName">
                          <xsl:attribute name="value">
                            <xsl:value-of select="USER/USERNAME"/>
                          </xsl:attribute>
                        </input>
                        <input type="hidden" name="SiteID">
                          <xsl:attribute name="value">
                            <xsl:value-of select="SITEID"/>
                          </xsl:attribute>
                        </input>
                      </td>
                      <td align="left" vAlign="top">
                        <font face="Arial" size="2" color="black">
                          <xsl:choose>
                            <xsl:when test="string-length(USER/USERNAME) &gt; 0">
                              <xsl:apply-templates select="USER"/>
                            </xsl:when>
                            <xsl:otherwise>None set</xsl:otherwise>
                          </xsl:choose>
                        </font>
                      </td>
                      <td>
                        <font face="Arial" size="2" color="black">
                          <xsl:value-of select="USER/FIRSTNAMES"/>
                          <xsl:text>&nbsp;</xsl:text>
                        </font>
                      </td>
                      <td>
                        <font face="Arial" size="2" color="black">
                          <xsl:value-of select="USER/LASTNAME"/>
                          <xsl:text>&nbsp;</xsl:text>
                        </font>
                      </td>
                      <td>
                        <font face="Arial" size="2" color="black">
                          <xsl:value-of select="SITENAME"/>
                        </font>
                      </td>
                      <td align="left" vAlign="top">
                        <font face="Arial" size="2" color="black">
                          <select name="Pass">
                            <OPTION value="1" selected="selected">Pass</OPTION>
                            <OPTION value="0">Fail</OPTION>
                          </select>
                        </font>
                      </td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </xsl:if>
            <!-- form buttons -->
            <table width="100%">
              <tr>
                <td valign="top" align="left">
                  <input type="submit" name="Next" value="Process" title="Process these nicknames and then fetch the next batch" alt="Process these nicknames and then fetch the next batch"/>
                  <xsl:text> </xsl:text>
                  <input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process these nicknames and then go to Moderation Home" alt="Process these nicknames and then go to Moderation Home"/>
                </td>
              </tr>
            </table>
            <br/>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--
	Template for the article moderation form
-->

  <xsl:template match="ARTICLE-MODERATION-FORM">
    <script language="JavaScript">
      <![CDATA[
<!-- hide this script from non-javascript-enabled browsers
function IsEmpty(str)
{
	for (var i = 0; i < str.length; i++)
	{
		var ch = str.charCodeAt(i);
		if (ch > 32)
		{
			return false;
		}
	}

	return true;
}

function checkArticleModerationForm()
{
	if ((ArticleModerationForm.Decision.value == 4 
			|| ArticleModerationForm.Decision.value == 6))
	{
		if (ArticleModerationForm.EmailType.selectedIndex == 0)
		{
			alert('You must select a reason when failing content');
			return false;
		}
		else
		if (ArticleModerationForm.EmailType.value == 'URLInsert')
		{
			//if failed with the URL reason - custom email field should be filled
			if (IsEmpty(ArticleModerationForm.CustomEmailText.value))
			{
				alert('Custom Email box should be filled if URL is selected as failure reason');
				ArticleModerationForm.CustomEmailText.focus();
				return false;
			}
		}
	}
	else if (ArticleModerationForm.EmailType.options[ArticleModerationForm.EmailType.selectedIndex].value == 'Custom' &&
			 ArticleModerationForm.CustomEmailText.value == '')
	{
		alert('You must specify the content for a custom email.');
		return false;
	}
	else
	if (ArticleModerationForm.Decision.value == 2) //refer to
	{ 
		if (IsEmpty(ArticleModerationForm.notes.value))
		{
			alert('Notes box should be filled if the article is referred');
			ArticleModerationForm.notes.focus();
			return false;
		}
	}

	return true;
}
// stop hiding -->
		]]>
    </script>
    <a name="moderatesection"/>
    <h3>Moderate this Entry</h3>
    <xsl:if test="/H2G2/ARTICLE/ERROR[@TYPE='XML-PARSE-ERROR']">
      <b>XML Parsing Error in article</b><br/>
      Please fail this entry and continue moderating.
    </xsl:if>
    <!-- first show any error messages -->
    <xsl:if test="ERROR">
      <span class="moderationformerror">
        <xsl:for-each select="ERROR">
          <b>
            <xsl:value-of select="."/>
          </b>
        </xsl:for-each>
        <br/>
      </span>
    </xsl:if>
    <!-- show any other messages -->
    <xsl:if test="MESSAGE">
      <xsl:choose>
        <xsl:when test="MESSAGE/@TYPE = 'NONE-LOCKED'">
          <b>
            You currently have no entries of this type allocated to you for moderation. Select a type and click 'Process' to be
            allocated the next entry of that type waiting to be moderated.
          </b>
          <br/>
        </xsl:when>
        <xsl:when test="MESSAGE/@TYPE = 'EMPTY-QUEUE'">
          <b>Currently there are no entries of the specified type awaiting moderation.</b>
          <br/>
        </xsl:when>
        <xsl:when test="MESSAGE/@TYPE = 'NO-ARTICLE'">
          <b>
            You have no entry allocated to you for moderation currently. Click on 'Process' below
            to be allocated the next entry requiring moderation.
          </b>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <b>
            <xsl:value-of select="MESSAGE"/>
          </b>
          <br/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- if the article has extra information in it then display it -->
    <xsl:if test="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
      <br/>
      <table bgColor="lightblue">
        <tr>
          <td>
            <b>Other information</b>
          </td>
        </tr>
        <xsl:for-each select="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="substring(.,1,7) = 'http://'">
                  <a href="{.}">
                    <xsl:value-of select="."/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>

            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
    <form action="{$root}ModerateArticle" method="POST" name="ArticleModerationForm" onSubmit="return checkArticleModerationForm()">
      <input type="hidden" name="h2g2ID">
        <xsl:attribute name="value">
          <xsl:value-of select="ARTICLE/H2G2-ID"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="ModID">
        <xsl:attribute name="value">
          <xsl:value-of select="ARTICLE/MODERATION-ID"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="SiteID" value="{../ARTICLE/ARTICLEINFO/SITEID}"/>
      <table width="100%">
        <tr>
          <td>
            <xsl:apply-templates select="../ARTICLE/ARTICLEINFO/SITEID" mode="showfrom_mod_offsite"/>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:if test="@REFERRALS = 1">
              Referred by
              <xsl:choose>
                <xsl:when test="number(ARTICLE/REFERRED-BY/USER/USERID) &gt; 0">
                  <xsl:apply-templates select="ARTICLE/REFERRED-BY/USER"/>
                </xsl:when>
                <xsl:otherwise>
                  <span class="moderationformerror">Auto Referral</span>
                </xsl:otherwise>
              </xsl:choose>
              <br/>
            </xsl:if>
          </td>
          <td align="right">
            <a target="_blank" href="{$root}ModerationHistory?h2g2ID={ARTICLE/H2G2-ID}">Show History</a>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:if test="@TYPE='COMPLAINTS'">
              <input type="hidden" name="ComplainantID" value="{ARTICLE/COMPLAINANT-ID}"/>
              <input type="hidden" name="CorrespondenceEmail" value="{ARTICLE/CORRESPONDENCE-EMAIL}"/>
              Complaint from
              <xsl:choose>
                <xsl:when test="string-length(ARTICLE/CORRESPONDENCE-EMAIL) &gt; 0">
                  <a href="mailto:{ARTICLE/CORRESPONDENCE-EMAIL}">
                    <xsl:value-of select="ARTICLE/CORRESPONDENCE-EMAIL"/>
                  </a>
                </xsl:when>
                <xsl:when test="number(ARTICLE/COMPLAINANT-ID) &gt; 0">
                  Researcher <a href="{$root}U{ARTICLE/COMPLAINANT-ID}">
                    U<xsl:value-of select="ARTICLE/COMPLAINANT-ID"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>Anonymous Complainant</xsl:otherwise>
              </xsl:choose>
              <br/>
              <textarea name="ComplaintText" cols="60" rows="10" wrap="virtual">
                <xsl:value-of select="ARTICLE/COMPLAINT-TEXT"/>
              </textarea>
              <br/>
            </xsl:if>
          </td>
        </tr>
      </table>
      Notes<br/>
      <textarea cols="60" name="notes" rows="10" wrap="virtual">
        <xsl:value-of select="ARTICLE/NOTES"/>
      </textarea>
      <br/>
      <input type="hidden" name="Referrals">
        <xsl:attribute name="value">
          <xsl:value-of select="@REFERRALS"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="Show">
        <xsl:attribute name="value">
          <xsl:value-of select="@TYPE"/>
        </xsl:attribute>
      </input>
      <select name="Decision">
        <!--				<option value="0">No Decision</option>-->
        <xsl:if test="@TYPE='COMPLAINTS'">
          <option value="3" selected="selected">
            <xsl:value-of select="$m_modrejectarticlecomplaint"/>
          </option>
          <option value="4">
            <xsl:value-of select="$m_modacceptarticlecomplaint"/>
          </option>
          <option value="6">
            <xsl:value-of select="$m_modacceptandeditarticle"/>
          </option>
        </xsl:if>
        <xsl:if test="@TYPE!='COMPLAINTS'">
          <option value="3" selected="selected">Pass</option>
          <option value="4">Fail</option>
        </xsl:if>
        <option value="2">Refer</option>
        <xsl:if test="@REFERRALS = 1">
          <option value="5">Unrefer</option>
        </xsl:if>
      </select>
      <xsl:text> </xsl:text>
      <select name="ReferTo" onChange="javascript:if (selectedIndex != 0) Decision.value = 2">
        <xsl:apply-templates select="/H2G2/REFEREE-LIST">
          <xsl:with-param name="SiteID" select="/H2G2/ARTICLE/ARTICLEINFO/SITEID"/>
        </xsl:apply-templates>
      </select>
      <xsl:text> </xsl:text>
      <select name="EmailType" onChange="javascript:if (selectedIndex != 0 &amp;&amp; ArticleModerationForm.Decision.value != 4 &amp;&amp; ArticleModerationForm.Decision.value != 6) ArticleModerationForm.Decision.value = 4" title="Select a reason if you are failing this content">
        <!--
				<option value="None" selected="selected">Failed because:</option>
				<option value="OffensiveInsert">Offensive</option>
				<option value="LibelInsert">Libellous</option>
				<option value="URLInsert">URL</option>
				<option value="PersonalInsert">Personal</option>
				<option value="AdvertInsert">Advertising</option>
				<option value="CopyrightInsert">Copyright</option>
				<option value="PoliticalInsert">Party Political</option>
				<option value="IllegalInsert">Illegal</option>
				<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
					<option value="Custom">Custom (enter below)</option>
				</xsl:if>
-->
        <xsl:call-template name="m_ModerationFailureMenuItems"/>
      </select>
      <br/><br/>
      <input type="submit" name="Next" value="Process" title="Process this Entry and then fetch the next one"/>
      <xsl:text> </xsl:text>
      <input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process and go to Moderation Home"/>
      <br/>
      <br/>
      <a href="{$root}Moderate">Moderation Home Page</a>
      <br/>
      <xsl:choose>
        <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
          <br/>
          Text for Custom Email
          <br/>
        </xsl:when>
        <xsl:when test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR') and not(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')">
          <xsl:value-of select="$m_ModEnterURLandReason"/>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <br/>
          If this entry failed due to broken URLs, please list them here, along with
          the reason why the URL failed, so the user can correct the article.
          <br/>
        </xsl:otherwise>
      </xsl:choose>
      <textarea cols="60" name="CustomEmailText" rows="10" wrap="virtual"/>
      <br/>
    </form>
  </xsl:template>

  <!--
	The top level containing frame for general moderation page - contains a frame
	that displays the page complained about, and a frame that displays the moderation form
-->

  <xsl:template match="H2G2[@TYPE='MODERATION-TOP-FRAME']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: General Complaints</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
      </head>
      <frameset rows="*,160" border="0" framespacing="1" frameborder="1">
        <frame src="{MODERATION-FRAME/@URL}" name="ModerationDisplayFrame" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" scrolling="auto"/>
        <xsl:choose>
          <xsl:when test="string-length(MODERATION-FRAME/NEXT) &gt; 0">
            <frame src="ModerationFormFrame?Next={MODERATION-FRAME/NEXT}&amp;Referrals={MODERATION-FRAME/@REFERRALS}" name="ModerationFormFrame" marginheight="0" marginwidth="1" leftmargin="0" topmargin="0" scrolling="auto"/>
          </xsl:when>
          <xsl:otherwise>
            <frame src="ModerationFormFrame?Referrals={MODERATION-FRAME/@REFERRALS}" name="ModerationFormFrame" marginheight="0" marginwidth="1" leftmargin="0" topmargin="0" scrolling="auto"/>
          </xsl:otherwise>
        </xsl:choose>
      </frameset>
    </html>
  </xsl:template>

  <!--
	template to match the frame that displays the moderation form in the bottom
	frame of a generalm moderation page
-->

  <xsl:template match="H2G2[@TYPE='MODERATION-FORM-FRAME']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: Forum Postings</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
        <script language="JavaScript">
          <![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

function loadURLInDisplayFrame()
{
	var navName = navigator.appName;

	// can't get dumb-ass Netscape to work with this yet - Kim
	if (navName == 'Microsoft Internet Explorer')
	{
		// check the URL is not blank
		if (GeneralModerationForm.URL.value != '')
		{
			window.open(GeneralModerationForm.URL.value, 'ModerationDisplayFrame', 'status=1,resizable=1,scrollbars=1');
		}
	}
	else if (false)
	{
		if (window.document.forms[0].URL.value != '')
		{
			window.top.frames[0].location.replace(window.document.forms[0].URL.value);
		}
	}
	else
	{
		alert('Your browser is unable to load the page into the top frame. Please click on the link below to open it in a seperate window');
	}
	return true;
}

// stop hiding -->
				]]>
        </script>
      </head>
      <body bgColor="lightblue" onLoad="loadURLInDisplayFrame()">
        <div class="ModerationTools">
          <!--				<h2 align="center">General Moderation</h2>-->
          <xsl:apply-templates select="/H2G2/GENERAL-MODERATION-FORM"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--
	Template for the general moderation form
-->

  <xsl:template match="GENERAL-MODERATION-FORM">
    <script language="JavaScript">
      <![CDATA[
			<!-- hide this script from non-javascript-enabled browsers
			function IsEmpty(str)
			{
				for (var i = 0; i < str.length; i++)
				{
					var ch = str.charCodeAt(i);
					if (ch > 32)
					{
						return false;
					}
				}

				return true;
			}

			function CheckGeneralModerationForm()
			{
				if (GeneralModerationForm.Decision.value == 2) //refer to
				{ 
					if (IsEmpty(GeneralModerationForm.notes.value))
					{
						alert('Notes box should be filled if the complaint is referred');
						GeneralModerationForm.notes.focus();
						return false;
					}
				}

				return true;
			}
			// stop hiding -->
		]]>
    </script>
    <xsl:if test="MESSAGE">
      <xsl:choose>
        <xsl:when test="MESSAGE/@TYPE = 'NONE-LOCKED'">
          <b>
            You currently have no complaints of this type allocated to you for moderation. Select a type and click 'Process' to be
            allocated the next complaint of that type waiting to be moderated.
          </b>
          <br/>
        </xsl:when>
        <xsl:when test="MESSAGE/@TYPE = 'EMPTY-QUEUE'">
          <b>Currently there are no complaints of the specified type awaiting moderation.</b>
          <br/>
        </xsl:when>
        <xsl:when test="MESSAGE/@TYPE = 'NO-ARTICLE'">
          <b>
            You have no complaint allocated to you for moderation currently. Click on 'Process' below
            to be allocated the next complaint requiring moderation.
          </b>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <b>
            <xsl:value-of select="MESSAGE"/>
          </b>
          <br/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <form action="{$root}ModerateGeneral" method="post" name="GeneralModerationForm" onSubmit="return CheckGeneralModerationForm()">
      <input type="hidden" name="URL">
        <xsl:attribute name="value">
          <xsl:value-of select="URL"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="ModID">
        <xsl:attribute name="value">
          <xsl:value-of select="MODERATION-ID"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="Referrals">
        <xsl:attribute name="value">
          <xsl:value-of select="@REFERRALS"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="ComplainantID" value="{COMPLAINANT-ID}"/>
      <input type="hidden" name="CorrespondenceEmail" value="{CORRESPONDENCE-EMAIL}"/>
      <table width="100%" border="0">
        <tr>
          <td valign="top" align="left" colspan="2" nowrap="nowrap">
            Complaint from
            <xsl:choose>
              <xsl:when test="string-length(CORRESPONDENCE-EMAIL) &gt; 0">
                <a href="mailto:{CORRESPONDENCE-EMAIL}">
                  <xsl:value-of select="CORRESPONDENCE-EMAIL"/>
                </a>
              </xsl:when>
              <xsl:when test="number(COMPLAINANT-ID) &gt; 0">
                Researcher <a href="{$root}U{COMPLAINANT-ID}">
                  U<xsl:value-of select="COMPLAINANT-ID"/>
                </a>
              </xsl:when>
              <xsl:otherwise>Anonymous Complainant</xsl:otherwise>
            </xsl:choose>
            about page <a target="_blank" href="{URL}">
              <xsl:value-of select="substring(URL, 1, 50)"/>
            </a>
          </td>
          <td valign="top" align="left" rowspan="2" nowrap="nowrap">
            <a href="{$root}Moderate" target="_top">Moderation Home Page</a>
          </td>
        </tr>
        <tr>
          <td colspan="4" align="left">
            <xsl:apply-templates select="SITEID" mode="showfrom_mod_offsite_line"/>
          </td>
        </tr>
        <tr>
          <td valign="top" align="left">Complaint:</td>
          <td valign="top" align="left">Notes:</td>
          <td valign="top" rowspan="2" align="left">
            <table>
              <tr>
                <td valign="top" align="left">
                  <select name="Decision">
                    <!--				<option value="0">No Decision</option>-->
                    <option value="3" selected="selected">
                      <xsl:value-of select="$m_modrejectgeneralcomplaint"/>
                    </option>
                    <option value="4">
                      <xsl:value-of select="$m_modacceptgeneralcomplaint"/>
                    </option>
                    <option value="2">Refer</option>
                  </select>
                  <br/>
                  <select name="ReferTo" onChange="javascript:if (selectedIndex != 0) Decision.selectedIndex = 2">
                    <xsl:apply-templates select="/H2G2/REFEREE-LIST">
                      <xsl:with-param name="SiteID" select="SITEID"/>
                    </xsl:apply-templates>
                  </select>
                </td>
              </tr>
              <tr>
                <td valign="top" align="left">
                  <input type="submit" name="Next" value="Process" title="Process this Entry and then fetch the next one"/>
                </td>
              </tr>
              <tr>
                <td valign="top" align="left">
                  <input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process this Entry and go to Moderation Home"/>
                </td>
              </tr>
            </table>
          </td>
          <td valign="top" align="left"/>
        </tr>
        <tr>
          <td valign="top" align="left">
            <textarea name="ComplaintText" cols="45" rows="5" wrap="virtual">
              <xsl:value-of select="COMPLAINT-TEXT"/>
            </textarea>
          </td>
          <td valign="top" align="left">
            <textarea id="notes" cols="30" name="notes" rows="5" wrap="virtual">
              <xsl:value-of select="NOTES"/>
            </textarea>
          </td>
          <td/>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--
	The home page for the moderation tools
-->

  <xsl:template match="H2G2[@TYPE='MODERATE-HOME']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 : Moderation</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
        <script language="JavaScript">
          <xsl:comment>
            hide this script from non-javascript-enabled browsers

            function confirmUnlockOnOtherUser()
            {
            <xsl:if test="$ownerisviewer != 1">
              return confirm('Warning! Unlocking other users moderation items whilst they are working on them can cause confusion. Are you sure you wish to proceed?')
            </xsl:if>
            return true;
            }

            // unhide
          </xsl:comment>
        </script>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <h2 align="center">
            Moderation Home Page for <br/><xsl:apply-templates select="/H2G2/PAGE-OWNER/USER"/>
          </h2>
          <form method="post" action="{$root}Moderate">
            <table border="0" cellPadding="0" cellSpacing="0" width="100%">
              <tr>
                <td align="left">
                  Logged in as
                  <b>
                    <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
                  </b>
                </td>
                <td align="right">
                  <a href="{$root}ModerateStats">Moderation Stats Page</a>
                  <br/>
                  <a href="{$root}ModerationBilling">Moderation Billing Page</a>
                  <br/>
                </td>
              </tr>
            </table>
            <br/>
            <input type="hidden" name="UserID" value="{/H2G2/MODERATOR-HOME/@USER-ID}"/>
            <table border="1" cellPadding="0" cellSpacing="0" width="100%">
              <!-- do the column headings -->
              <tr align="center" vAlign="top">
                <td colspan="6">
                  <b>Moderation</b>
                </td>
              </tr>
              <tr align="center" vAlign="top">
                <td colspan="2">
                  <b>Forums</b>
                </td>
                <td colspan="2">
                  <b>Entries</b>
                </td>
              </tr>
              <tr align="left" vAlign="top">
                <!--
							<td width="16.6%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<xsl:if test="$ownerisviewer = 0">
									<tr>
										<td align="center" valign="top">
											Legacy
										</td>
									</tr>
									</xsl:if>
									<xsl:if test="$ownerisviewer = 1">
										<tr>
											<td align="center" valign="top">
												<a href="{$root}ModerateForums?Next=Process&amp;show=legacy&amp;Referrals=0">Legacy</a>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
							-->
                <td width="16.6%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$ownerisviewer = 0">
                      <tr>
                        <td align="center" valign="top">
                          New
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="$ownerisviewer = 1">
                      <tr>
                        <td align="center" valign="top">
                          <a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=0">New</a>
                        </td>
                      </tr>
                    </xsl:if>
                  </table>
                </td>
                <td width="16.6%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$ownerisviewer = 0">
                      <tr>
                        <td align="center" valign="top">
                          Complaints
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="$ownerisviewer = 1">
                      <tr>
                        <td align="center" valign="top">
                          <a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=0">Complaints</a>
                        </td>
                      </tr>
                    </xsl:if>
                  </table>
                </td>
                <!--
							<td width="16.6%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<xsl:if test="$ownerisviewer = 0">
									<tr>
										<td align="center" valign="top">
											Legacy
										</td>
									</tr>
									</xsl:if>
									<xsl:if test="$ownerisviewer = 1">
										<tr>
											<td align="center" valign="top">
												<a href="{$root}ModerateArticle?Next=Process&amp;show=legacy&amp;Referrals=0">Legacy</a>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
							-->
                <td width="16.6%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$ownerisviewer = 0">
                      <tr>
                        <td align="center" valign="top">
                          New
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="$ownerisviewer = 1">
                      <tr>
                        <td align="center" valign="top">
                          <a href="{$root}ModerateArticle?Next=Process&amp;show=new&amp;Referrals=0">New</a>
                        </td>
                      </tr>
                    </xsl:if>
                  </table>
                </td>
                <td width="16.6%">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$ownerisviewer = 0">
                      <tr>
                        <td align="center" valign="top">
                          Complaints
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="$ownerisviewer = 1">
                      <tr>
                        <td align="center" valign="top">
                          <a href="{$root}ModerateArticle?Next=Process&amp;show=complaints&amp;Referrals=0">Complaints</a>
                        </td>
                      </tr>
                    </xsl:if>
                  </table>
                </td>
              </tr>
              <tr align="left" vAlign="top">
                <!--
							<td>
								<xsl:if test="number(MODERATOR-HOME/MODERATION/FORUMS/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
								Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/LEGACY/LOCKED"/>
							</td>
							-->
                <td>
                  <xsl:if test="number(MODERATOR-HOME/MODERATION/FORUMS/NEW/LOCKED) &gt; 0">
                    <xsl:attribute name="bgColor">red</xsl:attribute>
                  </xsl:if>
                  Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/NEW/LOCKED"/>
                </td>
                <td>
                  <xsl:if test="number(MODERATOR-HOME/MODERATION/FORUMS/COMPLAINTS/LOCKED) &gt; 0">
                    <xsl:attribute name="bgColor">red</xsl:attribute>
                  </xsl:if>
                  Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/COMPLAINTS/LOCKED"/>
                </td>
                <!--
							<td>
								<xsl:if test="number(MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
								Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/LOCKED"/>
							</td>
							-->
                <td>
                  <xsl:if test="number(MODERATOR-HOME/MODERATION/ARTICLES/NEW/LOCKED) &gt; 0">
                    <xsl:attribute name="bgColor">red</xsl:attribute>
                  </xsl:if>
                  Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/NEW/LOCKED"/>
                </td>
                <td>
                  <xsl:if test="number(MODERATOR-HOME/MODERATION/ARTICLES/COMPLAINTS/LOCKED) &gt; 0">
                    <xsl:attribute name="bgColor">red</xsl:attribute>
                  </xsl:if>
                  Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/COMPLAINTS/LOCKED"/>
                </td>
              </tr>
              <tr align="left" vAlign="top">
                <!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/LEGACY/QUEUED"/></td> -->
                <td>
                  Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/NEW/QUEUED"/>
                </td>
                <td>
                  Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/COMPLAINTS/QUEUED"/>
                </td>
                <!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/QUEUED"/></td> -->
                <td>
                  Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/NEW/QUEUED"/>
                </td>
                <td>
                  Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/COMPLAINTS/QUEUED"/>
                </td>
              </tr>
              <tr align="center" vAlign="top">
                <td colspan="2" rowspan="2">
                  <input type="submit" name="UnlockForums" value="Unlock Forums" onClick="return confirmUnlockOnOtherUser()"/>
                </td>
                <td colspan="2" rowspan="2">
                  <input type="submit" name="UnlockArticles" value="Unlock Entries" onClick="return confirmUnlockOnOtherUser()"/>
                </td>
              </tr>
            </table>
            <br/>
            <!-- stuff for superusers and referees-->
            <xsl:if test="MODERATOR-HOME/@ISREFEREE = 1 or $superuser = 1">
              <!-- nickname moderation -->
              <xsl:if test="(number(MODERATOR-HOME/MODERATION/NICKNAMES/NEW/LOCKED) &gt; 0 or number(MODERATOR-HOME/MODERATION/NICKNAMES/NEW/QUEUED) &gt; 0)">
                <div align="center">
                  <table border="1" cellPadding="0" cellSpacing="0">
                    <!-- only one column heading -->
                    <tr align="center" vAlign="top">
                      <td colspan="1">
                        <xsl:if test="$ownerisviewer = 0">
                          <span class="moderationheader">
                            <b>Nicknames</b>
                          </span>
                        </xsl:if>
                        <xsl:if test="$ownerisviewer = 1">
                          <span class="moderationheader">
                            <b>
                              <a href="{$root}ModerateNicknames?Next=Process">Nicknames</a>
                            </b>
                          </span>
                        </xsl:if>
                      </td>
                    </tr>
                    <tr align="left" vAlign="top">
                      <td>
                        <xsl:if test="number(MODERATOR-HOME/MODERATION/NICKNAMES/NEW/LOCKED) &gt; 0">
                          <xsl:attribute name="bgColor">red</xsl:attribute>
                        </xsl:if>
                        Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/NICKNAMES/NEW/LOCKED"/>
                      </td>
                    </tr>
                    <tr align="left" vAlign="top">
                      <td>
                        Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/NICKNAMES/NEW/QUEUED"/>
                      </td>
                    </tr>
                    <tr align="center" vAlign="top">
                      <td colspan="1" rowspan="1">
                        <input type="submit" name="UnlockNicknames" value="Unlock Nicknames" onClick="return confirmUnlockOnOtherUser()"/>
                      </td>
                    </tr>
                  </table>
                </div>
              </xsl:if>
              <br/>
              <table border="1" cellPadding="0" cellSpacing="0" width="100%">
                <tr align="center" vAlign="top">
                  <td colspan="6">
                    <b>
                      <span class="moderationheader">Referrals</span>
                    </b>
                  </td>
                </tr>
                <tr align="center" vAlign="top">
                  <td colspan="2">
                    <b>Forums</b>
                  </td>
                  <td colspan="2">
                    <b>Entries</b>
                  </td>
                </tr>
                <tr align="left" vAlign="top">
                  <!--
								<td width="16.6%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$ownerisviewer = 0">
										<tr>
											<td align="center" valign="top">
												Legacy
											</td>
										</tr>
										</xsl:if>
										<xsl:if test="$ownerisviewer = 1">
											<tr>
												<td align="center" valign="top">
													<a href="{$root}ModerateForums?Next=Process&amp;show=legacy&amp;Referrals=1">Legacy</a>
												</td>
											</tr>
										</xsl:if>
									</table>
								</td>
								-->
                  <td width="16.6%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$ownerisviewer = 0">
                        <tr>
                          <td align="center" valign="top">
                            New
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <tr>
                          <td align="center" valign="top">
                            <a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=1">New</a>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </td>
                  <td width="16.6%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$ownerisviewer = 0">
                        <tr>
                          <td align="center" valign="top">
                            Complaints
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <tr>
                          <td align="center" valign="top">
                            <a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=1">Complaints</a>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </td>
                  <!--
								<td width="16.6%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$ownerisviewer = 0">
										<tr>
											<td align="center" valign="top">
												Legacy
											</td>
										</tr>
										</xsl:if>
										<xsl:if test="$ownerisviewer = 1">
											<tr>
												<td align="center" valign="top">
													<a href="{$root}ModerateArticle?Next=Process&amp;show=legacy&amp;Referrals=1">Legacy</a>
												</td>
											</tr>
										</xsl:if>
									</table>
								</td>
								-->
                  <td width="16.6%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$ownerisviewer = 0">
                        <tr>
                          <td align="center" valign="top">
                            New
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <tr>
                          <td align="center" valign="top">
                            <a href="{$root}ModerateArticle?Next=Process&amp;show=new&amp;Referrals=1">New</a>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </td>
                  <td width="16.6%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$ownerisviewer = 0">
                        <tr>
                          <td align="center" valign="top">
                            Complaints
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <tr>
                          <td align="center" valign="top">
                            <a href="{$root}ModerateArticle?Next=Process&amp;show=complaints&amp;Referrals=1">Complaints</a>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </td>
                </tr>
                <tr align="left" vAlign="top">
                  <!--
								<td>
									<xsl:if test="number(MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
									Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/LOCKED"/>
								</td>
								-->
                  <td>
                    <xsl:if test="number(MODERATOR-HOME/REFERRALS/FORUMS/NEW/LOCKED) &gt; 0">
                      <xsl:attribute name="bgColor">red</xsl:attribute>
                    </xsl:if>
                    Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/NEW/LOCKED"/>
                  </td>
                  <td>
                    <xsl:if test="number(MODERATOR-HOME/REFERRALS/FORUMS/COMPLAINTS/LOCKED) &gt; 0">
                      <xsl:attribute name="bgColor">red</xsl:attribute>
                    </xsl:if>
                    Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/COMPLAINTS/LOCKED"/>
                  </td>
                  <!--
								<td>
									<xsl:if test="number(MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
									Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/LOCKED"/>
								</td>
								-->
                  <td>
                    <xsl:if test="number(MODERATOR-HOME/REFERRALS/ARTICLES/NEW/LOCKED) &gt; 0">
                      <xsl:attribute name="bgColor">red</xsl:attribute>
                    </xsl:if>
                    Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/NEW/LOCKED"/>
                  </td>
                  <td>
                    <xsl:if test="number(MODERATOR-HOME/REFERRALS/ARTICLES/COMPLAINTS/LOCKED) &gt; 0">
                      <xsl:attribute name="bgColor">red</xsl:attribute>
                    </xsl:if>
                    Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/COMPLAINTS/LOCKED"/>
                  </td>
                </tr>
                <tr align="left" vAlign="top">
                  <!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/QUEUED"/></td> -->
                  <td>
                    Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/NEW/QUEUED"/>
                  </td>
                  <td>
                    Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/COMPLAINTS/QUEUED"/>
                  </td>
                  <!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/QUEUED"/></td> -->
                  <td>
                    Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/NEW/QUEUED"/>
                  </td>
                  <td>
                    Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/COMPLAINTS/QUEUED"/>
                  </td>
                </tr>
                <tr align="center" vAlign="top">
                  <td colspan="2" rowspan="2">
                    <input type="submit" name="UnlockForumReferrals" value="Unlock Forum Referrals" onClick="return confirmUnlockOnOtherUser()"/>
                  </td>
                  <td colspan="2" rowspan="2">
                    <input type="submit" name="UnlockArticleReferrals" value="Unlock Entry Referrals" onClick="return confirmUnlockOnOtherUser()"/>
                  </td>
                </tr>
              </table>
              <br/>
              <div align="center">
                <table border="1" cellPadding="0" cellSpacing="0" width="50%">
                  <tr align="center" vAlign="top">
                    <td colspan="2">
                      <b>
                        <span class="moderationheader">General Complaints</span>
                      </b>
                    </td>
                  </tr>
                  <tr align="center" vAlign="top">
                    <td width="50%">
                      <xsl:if test="$ownerisviewer = 0">
                        New
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <a href="{$root}ModerationTopFrame?Next=Process&amp;Referrals=0">New</a>
                      </xsl:if>
                    </td>
                    <td width="50%">
                      <xsl:if test="$ownerisviewer = 0">
                        Referrals
                      </xsl:if>
                      <xsl:if test="$ownerisviewer = 1">
                        <a href="{$root}ModerationTopFrame?Next=Process&amp;Referrals=1">Referrals</a>
                      </xsl:if>
                    </td>
                  </tr>
                  <tr align="left" vAlign="top">
                    <td>
                      <xsl:if test="number(MODERATOR-HOME/MODERATION/GENERAL/COMPLAINTS/LOCKED) &gt; 0">
                        <xsl:attribute name="bgColor">red</xsl:attribute>
                      </xsl:if>
                      Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/GENERAL/COMPLAINTS/LOCKED"/>
                    </td>
                    <td>
                      <xsl:if test="number(MODERATOR-HOME/REFERRALS/GENERAL/COMPLAINTS/LOCKED) &gt; 0">
                        <xsl:attribute name="bgColor">red</xsl:attribute>
                      </xsl:if>
                      Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/GENERAL/COMPLAINTS/LOCKED"/>
                    </td>
                  </tr>
                  <tr align="left" vAlign="top">
                    <td>
                      Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/GENERAL/COMPLAINTS/QUEUED"/>
                    </td>
                    <td>
                      Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/GENERAL/COMPLAINTS/QUEUED"/>
                    </td>
                  </tr>
                  <tr align="center" vAlign="top">
                    <td>
                      <input type="submit" name="UnlockGeneral" value="Unlock General" onClick="return confirmUnlockOnOtherUser()"/>
                    </td>
                    <td>
                      <input type="submit" name="UnlockGeneralReferrals" value="Unlock General Referrals" onClick="return confirmUnlockOnOtherUser()"/>
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:if>
            <br/>
            <div align="center">
              <input type="submit" name="UnlockAll" value="Unlock Everything" onClick="return confirmUnlockOnOtherUser()"/>
            </div>

            <!-- Display the list of sites and a number of queued 
						moderation items/complaints for each -->
            <br/>
            <table border="1" cellPadding="0" cellSpacing="0" width="100%">
              <tr>
                <td width="25%" align="center">
                  <b>
                    <xsl:value-of select="$m_modsitename"/>
                  </b>
                </td>
                <td width="25%" align="center">
                  <b>
                    <xsl:value-of select="$m_modnumberqueued"/>
                  </b>
                </td>
                <td width="25%" align="center">
                  <b>
                    <xsl:value-of select="$m_modnumbercomplaints"/>
                  </b>
                </td>
                <td width="25%" align="center">
                  <b>
                    <xsl:value-of select="$m_modcurrentlyvisible"/>
                  </b>
                </td>
              </tr>
              <xsl:for-each select="MODERATOR-HOME/QUEUED-PER-SITE/SITE">
                <tr>
                  <td>
                    <xsl:if test="number(ISMODERATOR) = 0">
                      <a href="{$rootbase}{URL}/Login">
                        <xsl:value-of select="NAME"/>
                      </a>
                    </xsl:if>
                    <xsl:if test="number(ISMODERATOR) = 1">
                      <xsl:value-of select="NAME"/>
                    </xsl:if>
                  </td>
                  <xsl:if test="ISMODERATOR = 1">
                    <xsl:if test="ISREFEREE = 1">
                      <td>
                        <xsl:value-of select="NOT-COMPLAINTS"/>(<xsl:value-of select="NOT-COMPLAINTS-REF"/>)
                      </td>
                      <td>
                        <xsl:value-of select="COMPLAINTS"/>(<xsl:value-of select="COMPLAINTS-REF"/>)
                      </td>
                    </xsl:if>
                    <xsl:if test="not(ISREFEREE = 1)">
                      <td>
                        <xsl:value-of select="number(NOT-COMPLAINTS)"/>
                      </td>
                      <td>
                        <xsl:value-of select="number(COMPLAINTS)"/>
                      </td>
                    </xsl:if>
                  </xsl:if>
                  <xsl:if test="not(ISMODERATOR = 1)">
                    <td>
                      <xsl:value-of select="NOT-COMPLAINTS"/>(<xsl:value-of select="NOT-COMPLAINTS-REF"/>)
                    </td>
                    <td>
                      <xsl:value-of select="COMPLAINTS"/>(<xsl:value-of select="COMPLAINTS-REF"/>)
                    </td>
                  </xsl:if>
                  <td>
                    <xsl:if test="number(ISMODERATOR) = 1">
                      <xsl:value-of select="$m_modcurrentlyvisibleyes"/>
                    </xsl:if>
                    <xsl:if test="number(ISMODERATOR) = 0">
                      <xsl:value-of select="$m_modcurrentlyvisibleno"/>
                    </xsl:if>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
            <xsl:value-of select="$m_ModPerSiteTableNote"/>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>

  <!--
	The locked status page for the moderation tools
-->

  <xsl:template match="H2G2[@TYPE='MODERATE-STATS']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 : Moderation Stats</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <h2 align="center">Moderation Stats Page</h2>
          <form method="post" action="{$root}ModerateStats">
            <table border="0" cellPadding="0" cellSpacing="0" width="100%">
              <tr valign="top">
                <td align="left">
                  Logged in as <b>
                    <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
                  </b>
                </td>
                <td align="right">
                  <a href="{$root}Moderate">Moderation Home Page</a>
                </td>
              </tr>
            </table>
            <br/>
            <!-- give info if user is active and what they have locked to them -->
            <xsl:for-each select="MODERATION-STATS">
              <div align="center">
                <table border="1" cellPadding="4" cellSpacing="0">
                  <tr align="center" vAlign="top">
                    <td colspan="7">
                      <b>
                        <span class="moderationheader">Total Locked/Referred Items per User</span>
                      </b>
                    </td>
                  </tr>
                  <tr align="center" vAlign="top">
                    <td>
                      <b>User</b>
                    </td>
                    <td>
                      <b>Status</b>
                    </td>
                    <td>
                      <b>Entries</b>
                    </td>
                    <td>
                      <b>Postings</b>
                    </td>
                    <td>
                      <b>Nicknames</b>
                    </td>
                    <td>
                      <b>General</b>
                    </td>
                    <td>
                      <b>Unlock</b>
                    </td>
                  </tr>
                  <xsl:for-each select="USER">
                    <tr align="center" vAlign="top">
                      <td align="left">
                        <xsl:choose>
                          <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
                            <a href="{$root}Moderate?UserID={USERID}">
                              <xsl:value-of select="USERNAME"/>
                            </a>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="USERNAME"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="SESSION/MINUTES-IDLE = 0">Active</xsl:when>
                          <xsl:when test="SESSION/ONLINE = 1">
                            Idle <xsl:value-of select="SESSION/MINUTES-IDLE"/> mins
                          </xsl:when>
                          <xsl:when test="SESSION/ONLINE = 0">Offline</xsl:when>
                          <xsl:otherwise>
                            <span class="moderationformerror">Unknown</span>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:value-of select="TOTAL-ENTRIES"/>
                      </td>
                      <td>
                        <xsl:value-of select="TOTAL-POSTS"/>
                      </td>
                      <td>
                        <xsl:value-of select="TOTAL-NICKNAMES"/>
                      </td>
                      <td>
                        <xsl:value-of select="TOTAL-GENERAL"/>
                      </td>
                      <td>
                        <a href="{$root}ModerateStats?UserID={USERID}&amp;Unlock=1">Unlock All</a>
                      </td>
                    </tr>
                  </xsl:for-each>
                </table>
                <br/>
                <br/>
              </div>
            </xsl:for-each>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='MODERATION-HISTORY']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 : Moderation History</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
      </head>
      <body b4gColor="lightblue">
        <div class="ModerationTools">
          <h2 align="center">Moderation History</h2>
          <!-- show any error messages -->
          <xsl:for-each select="ERROR">
            <xsl:choose>
              <xsl:when test="@TYPE = 'INVALID-H2G2ID'">
                <b>
                  <span class="moderationformerror">The Entry ID supplied was not a valid one.</span>
                </b>
                <br/>
              </xsl:when>
              <xsl:otherwise>
                <b>
                  <span class="moderationformerror">
                    <xsl:value-of select="."/>
                  </span>
                </b>
                <br/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          <form method="post" action="{$root}ModerationHistory">
            <table border="0" cellPadding="0" cellSpacing="0" width="100%">
              <tr>
                <td align="left">
                  Logged in as <b>
                    <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
                  </b>
                </td>
                <td align="right">
                  <a href="{$root}Moderate">Moderation Home Page</a>
                  <br/>
                  <br/>
                  <a href="{$root}ModerateStats">Moderation Stats Page</a>
                </td>
              </tr>
            </table>
            <br/>
            <xsl:choose>
              <xsl:when test="not(MODERATION-HISTORY)">
                Enter an Entry ID or Post ID and click 'Fetch History'.<br/>
              </xsl:when>
              <xsl:when test="not(MODERATION-HISTORY/MODERATION)">
                <b>There is no moderation history for the item specified.</b>
                <br/>
              </xsl:when>
              <xsl:when test="not(number(MODERATION-HISTORY/@H2G2ID) &gt; 0 or number(MODERATION-HISTORY/@POSTID) &gt; 0)">
                No valid Entry ID or Post ID was provided.<br/>
              </xsl:when>
            </xsl:choose>
            <br/>
            <!-- process any article moderation history available -->
            <!-- show nothing if we don't even have data on the item -->
            <xsl:if test="MODERATION-HISTORY/SUBJECT">
              <xsl:for-each select="MODERATION-HISTORY[@TYPE='ARTICLE' and number(@H2G2ID) &gt; 0 or @TYPE='POST' and number(@POSTID) &gt; 0]">
                <div align="center">
                  <table border="1" cellPadding="4" cellSpacing="0">
                    <tr align="center" vAlign="top">
                      <td colspan="13">
                        <span class="moderationheader">
                          <xsl:choose>
                            <xsl:when test="@TYPE='ARTICLE'">
                              Moderation History for Entry A<xsl:value-of select="@H2G2ID"/>
                            </xsl:when>
                            <xsl:when test="@TYPE='POST'">
                              Moderation History for Post P<xsl:value-of select="@POSTID"/>
                            </xsl:when>
                            <xsl:otherwise>Moderation History</xsl:otherwise>
                          </xsl:choose>
                        </span>
                      </td>
                    </tr>
                    <tr align="center" vAlign="top">
                      <td colspan="13">
                        <b>Subject</b>:
                        <xsl:choose>
                          <xsl:when test="@TYPE='POST'">
                            <a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;post={@POSTID}#p{@POSTID}">
                              <xsl:value-of select="SUBJECT"/>
                            </a>
                          </xsl:when>
                          <xsl:otherwise>
                            <a href="{$root}A{@H2G2ID}">
                              <xsl:value-of select="SUBJECT"/>
                            </a>
                          </xsl:otherwise>
                        </xsl:choose>
                        <br/>
                        <b>
                          <xsl:choose>
                            <xsl:when test="@TYPE='ARTICLE'">Editor</xsl:when>
                            <xsl:otherwise>Author</xsl:otherwise>
                          </xsl:choose>
                        </b>: <xsl:apply-templates select="EDITOR/USER"/>
                      </td>
                    </tr>
                    <xsl:if test="MODERATION">
                      <tr align="center" vAlign="top">
                        <td>
                          <b>ModID</b>
                        </td>
                        <td>
                          <b>Status</b>
                        </td>
                        <td>
                          <b>Source</b>
                        </td>
                        <td>
                          <b>Locked By</b>
                        </td>
                        <td>
                          <b>Referred By</b>
                        </td>
                        <td>
                          <b>Date Queued</b>
                        </td>
                        <td>
                          <b>Date Locked</b>
                        </td>
                        <td>
                          <b>Date Referred</b>
                        </td>
                        <td>
                          <b>Date Completed</b>
                        </td>
                        <td>
                          <b>
                            Notes<br/><img src="{$imagesource}blank.gif" width="200" height="1"/>
                          </b>
                        </td>
                        <td>
                          <b>Complainant</b>
                        </td>
                        <td>
                          <b>Correspondence Email</b>
                        </td>
                        <td>
                          <b>
                            <nobr>Complaint Text</nobr>
                            <br/>
                            <img src="{$imagesource}blank.gif" width="200" height="1"/>
                          </b>
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:for-each select="MODERATION">
                      <tr align="center" vAlign="top">
                        <td>
                          <xsl:value-of select="MODERATION-ID"/>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="MODERATION-STATUS = 0">In Queue</xsl:when>
                            <xsl:when test="MODERATION-STATUS = 1">Locked</xsl:when>
                            <xsl:when test="MODERATION-STATUS = 2">Referred</xsl:when>
                            <xsl:when test="MODERATION-STATUS = 3">Passed</xsl:when>
                            <xsl:when test="MODERATION-STATUS = 4">Failed</xsl:when>
                            <xsl:otherwise>
                              Invalid Status: <xsl:value-of select="MODERATION-STATUS"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="COMPLAINT = 1">Complaint</xsl:when>
                            <xsl:when test="LEGACY = 1">Legacy</xsl:when>
                            <xsl:otherwise>New</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="LOCKED-BY/USER">
                              <xsl:apply-templates select="LOCKED-BY/USER"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="REFERRED-BY/USER">
                              <xsl:apply-templates select="REFERRED-BY/USER"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="DATE-QUEUED/DATE">
                              <xsl:apply-templates select="DATE-QUEUED/DATE" mode="short"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="DATE-LOCKED/DATE">
                              <xsl:apply-templates select="DATE-LOCKED/DATE" mode="short"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="DATE-REFERRED/DATE">
                              <xsl:apply-templates select="DATE-REFERRED/DATE" mode="short"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="DATE-COMPLETED/DATE">
                              <xsl:apply-templates select="DATE-COMPLETED/DATE" mode="short"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <xsl:choose>
                          <xsl:when test="string-length(NOTES) &gt; 0">
                            <td align="left">
                              <xsl:value-of select="NOTES"/>
                            </td>
                          </xsl:when>
                          <xsl:otherwise>
                            <td align="center">-</td>
                          </xsl:otherwise>
                        </xsl:choose>
                        <td>
                          <xsl:choose>
                            <xsl:when test="COMPLAINANT/USER/USERID = 0">Unregistered User</xsl:when>
                            <xsl:when test="COMPLAINANT/USER">
                              <xsl:apply-templates select="COMPLAINANT/USER"/>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="COMPLAINANT/USER/CORRESPONDENCE-EMAIL">
                              <a href="mailto:{COMPLAINANT/USER/CORRESPONDENCE-EMAIL}">
                                <xsl:value-of select="COMPLAINANT/USER/CORRESPONDENCE-EMAIL"/>
                              </a>
                            </xsl:when>
                            <xsl:otherwise>-</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <xsl:choose>
                          <xsl:when test="string-length(COMPLAINT-TEXT) &gt; 0">
                            <td align="left">
                              <xsl:value-of select="COMPLAINT-TEXT"/>
                            </td>
                          </xsl:when>
                          <xsl:otherwise>
                            <td align="center">-</td>
                          </xsl:otherwise>
                        </xsl:choose>
                      </tr>
                    </xsl:for-each>
                  </table>
                  <br/>
                  <br/>
                </div>
              </xsl:for-each>
            </xsl:if>
            <table>
              <tr align="left" valign="center">
                <td>Entry Number:</td>
                <td>
                  <input type="text" name="h2g2ID">
                    <xsl:if test="number(MODERATION-HISTORY/@H2G2ID) &gt; 0">
                      <xsl:attribute name="value">
                        <xsl:value-of select="MODERATION-HISTORY/@H2G2ID"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr align="left" valign="center">
                <td>Post Number:</td>
                <td>
                  <input type="text" name="PostID">
                    <xsl:if test="number(MODERATION-HISTORY/@POSTID) &gt; 0">
                      <xsl:attribute name="value">
                        <xsl:value-of select="MODERATION-HISTORY/@POSTID"/>
                      </xsl:attribute>
                    </xsl:if>
                  </input>
                </td>
              </tr>
              <tr align="left" valign="center">
                <td>Reference :</td>
                <td>
                  <input type="text" name="Reference"/>
                </td>
              </tr>
              <tr align="left" valign="center">
                <td>
                  <xsl:text> </xsl:text>
                </td>
                <td>
                  <input type="submit" name="Fetch" value="Fetch History"/>
                </td>
              </tr>
            </table>
          </form>
        </div>
        <br/>
        <br/>
        <br/>
      </body>
    </html>
  </xsl:template>

  <!--
	Post Editing page
-->

  <xsl:template match="H2G2[@TYPE='EDIT-POST']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: Edit Post</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
        <script language="JavaScript">
          <xsl:comment>
            <!--
			this variable will receive the instance of TextObject describing
			current document selection
			-->
            var g_Range;

            <!--
			function EasyTextSelected()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	This function is called when user selected a string
						from the EasyText select control and replaces the
						text from TextRange specified in g_Range with the text
						from the select control
			-->
            function EasyTextSelected()
            {
            var insertText = document.TextForm.EasyText.item(
            document.TextForm.EasyText.selectedIndex).text
            document.TextForm.EasyText.value = 0;
            if (g_Range == null) //PostText did not have focus yet
            {
            document.TextForm.PostText.value += insertText;
            return;
            }

            g_Range.text = insertText;
            document.selection.empty();
            }

            <!--
			function MonitorSelectionByMouse()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	When mouse button is clicked the instance of TextRange 
						should be filled with correct selection information by
						means of moveToPoint function
			-->
            function MonitorSelectionByMouse()
            {
            g_Range = document.selection.createRange();
            g_Range.moveToPoint(window.event.x, window.event.y);
            }

            <!--
			function MonitorSelectionByKeybord()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	Just get the TextRange for the current document selecion.
			-->
            function MonitorSelectionByKeybord()
            {
            g_Range = document.selection.createRange();
            }

            //
          </xsl:comment>
        </script>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <xsl:for-each select="POST-EDIT-FORM/MESSAGE">
            <b>
              <xsl:value-of select="."/>
            </b>
            <BR/>
            <BR/>
          </xsl:for-each>
          <b>
            Edit Post '<xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>' by <xsl:apply-templates select="POST-EDIT-FORM/AUTHOR"/>
          </b>
          <form name="TextForm" method="post" action="{$root}EditPost">
            <input type="hidden" name="PostID" value="{POST-EDIT-FORM/POST-ID}"/>
            Subject:
            <input type="text" name="Subject" size="30">
              <xsl:attribute name="value">
                <xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>
              </xsl:attribute>
            </input>
            <br/>
            Text:<br/>
            <textarea onkeyup="MonitorSelectionByKeybord()" onmousedown="MonitorSelectionByMouse()" onselect="MonitorSelectionByKeybord()" id="PostText" name="Text" cols="40" rows="15" wrap="virtual">
              <xsl:value-of select="POST-EDIT-FORM/TEXT"/>
            </textarea>
            <br/>
            <xsl:text>Easy Text:</xsl:text>
            <select id="EasyText" onchange="EasyTextSelected()">
              <option value="0" selected="1">Select text to insert:</option>
              <option value="1">[Unsuitable link removed by Moderator]</option>
              <option value="2">[Broken link removed by Moderator]</option>
              <option value="2">[Personal details removed by Moderator]</option>
            </select>
            <br/>
            <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR') or $superuser = 1">
              <xsl:text> Hide Post:</xsl:text>
              <input type="checkbox" name="HidePost" value="1">
                <xsl:if test="POST-EDIT-FORM/HIDDEN &gt; 0">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="POST-EDIT-FORM/HIDDEN &gt; 0">
                <span class="posthidden">(Post is currently hidden)</span>
              </xsl:when>
              <xsl:otherwise>
                <span class="posthidden">(Post is currently visible)</span>
              </xsl:otherwise>
            </xsl:choose>
            <br/><br/>
            <input type="submit" name="Update" value="Update"/>
            <xsl:text> </xsl:text>
            <input type="submit" name="Cancel" value="Close" onClick="javascript:if (window.name == 'EditPostPopup') window.close()"/>
          </form>
        </div>
      </body>
    </html>
  </xsl:template>


  <!--
	The user complaint popup page
-->

  <xsl:template match="H2G2[@TYPE='USER-COMPLAINT']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>
          <xsl:value-of select="$m_usercomplaintpopuptitle"/>
        </title>
        <script language="JavaScript">
          <xsl:comment>
            hide this script from non-javascript-enabled browsers

            function CheckEmailFormat(email)
            {
            if (email.length &lt; 5)
            {
            return false;
            }

            var atIndex = email.indexOf('@');
            if (atIndex &lt; 1)
            {
            return false;
            }

            var lastDotIndex = email.lastIndexOf('.');
            if (lastDotIndex &lt; atIndex + 2)
            {
            return false;
            }

            return true;
            }

            function checkUserComplaintForm()
            {
            var text = document.UserComplaintForm.ComplaintText.value;

            // if user leaves text unchanged or blank then ask them for some details
            if (text == '' || text == '<xsl:value-of select="$m_defaultcomplainttext"/>')
            {
            alert('<xsl:value-of select="$m_usercomplaintnodetailsalert"/>');
            return false;
            }

            //email should be specified and be of correct format aa@bb.cc
            if (!CheckEmailFormat(document.UserComplaintForm.EmailAddress.value))
            {
            alert("<xsl:value-of select="$m_invalidemailformat"/>");
            document.UserComplaintForm.EmailAddress.focus();
            return false;
            }

            return true;
            }

            // stop hiding
          </xsl:comment>
        </script>
      </head>
      <body bgColor="white">
        <!-- first insert any message requested as appropriate -->
        <xsl:choose>
          <xsl:when test="USER-COMPLAINT-FORM/ERROR">
            <p>
              <xsl:value-of select="USER-COMPLAINT-FORM/ERROR"/>
            </p>
          </xsl:when>
          <xsl:when test="USER-COMPLAINT-FORM/MESSAGE/@TYPE='SUBMIT-SUCCESSFUL'">
            <b>
              <xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/>
            </b><br/><br/>
            Your complaint reference number is <b>
              <xsl:value-of select="USER-COMPLAINT-FORM/MODERATION-REFERENCE"/>
            </b><br/><br/>
          </xsl:when>
          <xsl:when test="USER-COMPLAINT-FORM/MESSAGE">
            <xsl:value-of select="MESSAGE"/>
          </xsl:when>
        </xsl:choose>
        <!-- after successful submission just have a 'close' button -->
        <xsl:choose>
          <xsl:when test="USER-COMPLAINT-FORM/MESSAGE/@TYPE='SUBMIT-SUCCESSFUL' or USER-COMPLAINT-FORM/ERROR">
            <form>
              <input type="button" name="Close" value="Close" onClick="javascript:window.close()"/>
            </form>
          </xsl:when>
          <!-- insert a complaint form if one is required -->
          <xsl:when test="USER-COMPLAINT-FORM">
            <!-- place the general proviso about seriousness of complaints -->
            <xsl:call-template name="m_complaintpopupseriousnessproviso"/>
            <!-- then insert any messages requested within the form XML -->
            <xsl:choose>
              <xsl:when test="USER-COMPLAINT-FORM/MESSAGE/@TYPE='ALREADY-HIDDEN'">
                <xsl:value-of select="$m_contentalreadyhiddenmessage"/>
              </xsl:when>
              <xsl:when test="USER-COMPLAINT-FORM/MESSAGE/@TYPE='DELETED'">
                <xsl:value-of select="$m_contentcancelledmessage"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- otherwise insert some appropriate preamble -->
                <xsl:choose>
                  <xsl:when test="USER-COMPLAINT-FORM/@TYPE='ARTICLE'">
                    <xsl:call-template name="m_articlecomplaintdescription"/>
                  </xsl:when>
                  <xsl:when test="USER-COMPLAINT-FORM/@TYPE='POST'">
                    <xsl:call-template name="m_postingcomplaintdescription"/>
                  </xsl:when>
                  <xsl:when test="USER-COMPLAINT-FORM/@TYPE='GENERAL'">
                    <xsl:call-template name="m_generalcomplaintdescription"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="m_generalcomplaintdescription"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <br/>
            <form method="post" action="{$root}UserComplaint" name="UserComplaintForm" id="UserComplaintForm" onSubmit="return checkUserComplaintForm()">
              <input type="hidden" name="Type">
                <xsl:attribute name="value">
                  <xsl:value-of select="USER-COMPLAINT-FORM/@TYPE"/>
                </xsl:attribute>
              </input>
              <xsl:if test="USER-COMPLAINT-FORM/POST-ID">
                <input type="hidden" name="PostID">
                  <xsl:attribute name="value">
                    <xsl:value-of select="USER-COMPLAINT-FORM/POST-ID"/>
                  </xsl:attribute>
                </input>
              </xsl:if>
              <xsl:if test="USER-COMPLAINT-FORM/H2G2-ID">
                <input type="hidden" name="h2g2ID">
                  <xsl:attribute name="value">
                    <xsl:value-of select="USER-COMPLAINT-FORM/H2G2-ID"/>
                  </xsl:attribute>
                </input>
              </xsl:if>
              <xsl:if test="USER-COMPLAINT-FORM/URL">
                <input type="hidden" name="URL">
                  <xsl:attribute name="value">
                    <xsl:value-of select="USER-COMPLAINT-FORM/URL"/>
                  </xsl:attribute>
                </input>
              </xsl:if>
              <textarea name="ComplaintText" id="ComplaintText" cols="70" rows="15" wrap="virtual">
                <xsl:value-of select="$m_defaultcomplainttext"/>
              </textarea>
              <br/>
              <xsl:call-template name="m_complaintpopupemailaddresslabel"/>
              <input type="text" name="EmailAddress" size="20">
                <xsl:attribute name="value">
                  <xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/>
                </xsl:attribute>
              </input>
              <xsl:text> </xsl:text>
              <input type="submit" name="Submit">
                <xsl:attribute name="value">
                  <xsl:value-of select="$m_complaintsformsubmitbuttonlabel"/>
                </xsl:attribute>
              </input>
              <xsl:text> </xsl:text>
              <input type="button" name="Cancel" onClick="window.close()">
                <xsl:attribute name="value">
                  <xsl:value-of select="$m_complaintsformcancelbuttonlabel"/>
                </xsl:attribute>
              </input>
            </form>
          </xsl:when>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>

  <!-- template for dealing with Monthsummary page
	 uses - PROCESS-MONTHSUMMARY
	 MONTHSUMMARY-OUTPUT-SUBJECTS -->
  <xsl:template name="MONTHSUMMARY_MAINBODY">
    <xsl:apply-templates select="MONTHSUMMARY"/>
  </xsl:template>

  <xsl:template name="MONTHSUMMARY_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$alt_MonthSummarySub"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="MONTHSUMMARY">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$alt_MonthSummarySub"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="m_monthsummaryblurb"/>
    <xsl:call-template name="PROCESS-MONTHSUMMARY">
      <xsl:with-param name="guidelist" select="GUIDEENTRY"/>
    </xsl:call-template>
  </xsl:template>

  <!-- goes through all the guide entries recursively -->

  <xsl:template name="PROCESS-MONTHSUMMARY">
    <xsl:param name="guidelist"/>
    <xsl:choose>
      <!-- when there are guide entries in the list -->
      <xsl:when test="$guidelist">
        <xsl:variable name="currententry" select="$guidelist[1]"/>

        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="concat($currententry/DATE/@DAYNAME,' ',$currententry/DATE/@DAY,' ',$currententry/DATE/@MONTHNAME,' ',$currententry/DATE/@YEAR)"/>
          </xsl:with-param>
        </xsl:call-template>
        <!-- find the set of guide entries that match the current date and output there subjects -->
        <xsl:call-template name="MONTHSUMMARY-OUTPUT-SUBJECTS">
          <xsl:with-param name="guidelist" select="$guidelist[DATE/@DAY = $currententry/DATE/@DAY and DATE/@MONTH = $currententry/DATE/@MONTH and DATE/@YEAR = $currententry/DATE/@YEAR]"/>
        </xsl:call-template>


        <!-- find the set of guide entries that don't match the current date and recurse this template -->
        <xsl:call-template name="PROCESS-MONTHSUMMARY">
          <xsl:with-param name="guidelist" select="$guidelist[not(DATE/@DAY = $currententry/DATE/@DAY and DATE/@MONTH = $currententry/DATE/@MONTH and DATE/@YEAR = $currententry/DATE/@YEAR)]"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="MONTHSUMMARY-OUTPUT-SUBJECTS">
    <xsl:param name="guidelist"/>
    <UL>
      <xsl:for-each select="$guidelist">
        <LI>
          <A href="{$root}A{@H2G2ID}">
            <xsl:value-of select="./SUBJECT"/>
          </A>
        </LI>
      </xsl:for-each>
    </UL>
  </xsl:template>

  <!-- end of month summary templates -->

  <xsl:template name="applytofragment">
    <xsl:param name="fragment"/>
    <xsl:choose>
      <xsl:when test="$usenodeset = 1">
        <xsl:apply-templates select="msxsl:node-set($fragment)/*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$fragment"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="VOLUNTEER-LIST">
    <xsl:choose>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='SUBS'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/SUBS"/>
          <xsl:with-param name="groupname">sub</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='ACES'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/ACES"/>
          <xsl:with-param name="groupname">ace</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='GURUS'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/GURUS"/>
          <xsl:with-param name="groupname">guru</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='SECTION-HEADS'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/SECTION-HEADS"/>
          <xsl:with-param name="groupname">sechead</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='SCOUTS'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/SCOUTS"/>
          <xsl:with-param name="groupname">scout</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="translate(@GROUP, $lowercase, $uppercase)='FIELD-RESEARCHERS'">
        <xsl:call-template name="show-volunteers">
          <xsl:with-param name="group" select="msxsl:node-set($volunteerlists)/VOLUNTEERS/FIELD-RESEARCHERS"/>
          <xsl:with-param name="groupname">fieldres</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="USER-GADGET">
    <xsl:call-template name="show-volunteers">
      <xsl:with-param name="group" select="."/>
      <xsl:with-param name="groupname">
        <xsl:value-of select="@NAME"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="show-volunteers">
    <xsl:param name="group"/>
    <xsl:param name="groupname"/>
    <SCRIPT LANGUAGE="javaScript">
      <xsl:comment>
        var <xsl:value-of select="$groupname"/>newwin="0";
        function go<xsl:value-of select="$groupname"/>(<xsl:value-of select="$groupname"/>newwin){
        <xsl:value-of select="$groupname"/>number=document.<xsl:value-of select="$groupname"/>list.<xsl:value-of select="$groupname"/>.options[document.<xsl:value-of select="$groupname"/>list.<xsl:value-of select="$groupname"/>.selectedIndex].value;
        if(<xsl:value-of select="$groupname"/>number!='0'){
        if(<xsl:value-of select="$groupname"/>newwin=="1")
        window.open('<xsl:value-of select="$root"/>U' + <xsl:value-of select="$groupname"/>number)
        else window.location.href='<xsl:value-of select="$root"/>U' + <xsl:value-of select="$groupname"/>number;
        }
        }
        //
      </xsl:comment>
    </SCRIPT>
    <FORM NAME="{$groupname}list">
      <TABLE CELLSPACING="2" CELLPADDING="3">
        <xsl:if test="TITLE">
          <TR>
            <TD ALIGN="center">
              <xsl:value-of select="TITLE"/>
            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TD ALIGN="center">
            <SELECT NAME="{$groupname}">
              <xsl:attribute name="SIZE">
                <xsl:value-of select="@LENGTH"/>
              </xsl:attribute>
              <OPTION value="0">
                <xsl:choose>
                  <xsl:when test="FIRSTITEM">
                    <xsl:value-of select="FIRSTITEM"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$m_dropdownpleasechooseone"/>
                  </xsl:otherwise>
                </xsl:choose>
              </OPTION>
              <OPTION value="0">-----------------</OPTION>
              <xsl:for-each select="msxsl:node-set($group)/LISTITEM">
                <OPTION value="{number(USER/USERID)}">
                  <xsl:value-of select="substring(USER/USERNAME,1,20)"/>
                  <xsl:if test="string-length(USER/USERNAME) &gt; 20">...</xsl:if>
                </OPTION>
              </xsl:for-each>
            </SELECT>&nbsp;
            <xsl:choose>
              <xsl:when test="@TYPE='command'">
                &nbsp;In:
              </xsl:when>
              <xsl:when test="@TYPE='new'">
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{$groupname}(1)"/>
              </xsl:when>
              <xsl:when test="@TYPE='this'">
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{$groupname}(0)"/>
              </xsl:when>
              <xsl:otherwise>
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{$groupname}({$groupname}newwin)"/>
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <xsl:choose>
          <xsl:when test="@TYPE='command'">
            <TR>
              <TD ALIGN="left">
                <INPUT TYPE="button" VALUE="{$m_thiswindow}" ONCLICK="go{$groupname}(0)"/>
                &nbsp;<INPUT TYPE="button" VALUE="{$m_newwindow}" ONCLICK="go{$groupname}(1)"/>
              </TD>
            </TR>
          </xsl:when>
          <xsl:otherwise>
            <TR>
              <TD>
                <SMALL>
                  <INPUT NAME="win" TYPE="radio" VALUE="0" CHECKED="1" ONCLICK="{$groupname}newwin='0';"/>
                  <xsl:value-of select="$m_gadgetusethiswindow"/>
                  <INPUT NAME="win" TYPE="radio" VALUE="1" ONCLICK="{$groupname}newwin='1';"/>
                  <xsl:value-of select="$m_gadgetusenewwindow"/>
                </SMALL>
              </TD>
            </TR>
          </xsl:otherwise>
        </xsl:choose>
      </TABLE>
    </FORM>
  </xsl:template>

  <!--
	Internal Tools templates from here on
-->

  <xsl:template name="INTERNAL-TOOLS-NAVIGATION">
    <br/>
    <br/>
    <table border="0" width="100%" cellpadding="2" cellspacing="4">
      <tr>
        <td>&nbsp;</td>
        <td>
          <nobr>
            <b>Tools Available:</b>
          </nobr>
        </td>
      </tr>
      <xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
        <tr colspan="2">
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <b>Editor Tools</b>
            </nobr>
          </td>
        </tr>
        <xsl:if test="/H2G2/@TYPE!='INSPECT-USER'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}InspectUser" target="_top">Inspect User</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="/H2G2/@TYPE!='GROUP-MANAGEMENT'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}ManageGroups" target="_top">Group Management</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}editor.cgi" target="_top">Entry Editor</a>
            </nobr>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}edithome.cgi" target="_top">Editor Homepage</a>
            </nobr>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}editqueue.cgi" target="_top">Waiting to Go Live</a>
            </nobr>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}editfrontpageraw.cgi" target="_top">Edit Front Page</a>
            </nobr>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}catpage.cgi" target="_top">Categorisation</a>
            </nobr>
          </td>
        </tr>
        <tr colspan="2">
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <b>Peer Review</b>
            </nobr>
          </td>
        </tr>
        <xsl:if test="/H2G2/@TYPE!='SCOUT-RECOMMENDATIONS'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}ScoutRecommendations" target="_top">Scout Recommendations</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="/H2G2/@TYPE!='SUB-ALLOCATION'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}AllocateSubs" target="_top">Allocate Subs</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <tr colspan="2">
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <b>Moderation</b>
            </nobr>
          </td>
        </tr>
        <xsl:if test="/H2G2/@TYPE!='MODERATE-HOME'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}Moderate" target="_top">Moderation Home Page</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="/H2G2/@TYPE!='MODERATE-STATS'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <a href="{$root}ModerateStats" target="_top">Moderation Stats Page</a>
              </nobr>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}ModerationHistory" target="_top">Moderation History</a>
            </nobr>
          </td>
        </tr>
        <tr colspan="2">
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <b>Miscellaneous</b>
            </nobr>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <a href="{$root}MoveThread" target="_top">Move Thread</a>
            </nobr>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td>&nbsp;</td>
        <td>
          <nobr>
            <a href="{$root}RandomEntry" target="_top">Random Entry</a>
          </nobr>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>
          <nobr>
            <a href="{$root}RandomNormalEntry" target="_top">Random Normal Entry</a>
          </nobr>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>
          <nobr>
            <a href="{$root}RandomRecommendedEntry" target="_top">Random Recommended Entry</a>
          </nobr>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>
          <nobr>
            <a href="{$root}RandomEditedEntry" target="_top">Random Edited Entry</a>
          </nobr>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--
	Sub editor allocation page template
-->

  <xsl:template name="SUB-ALLOCATION_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>Sub Editor Allocation
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="SUB-ALLOCATION_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">Allocate Recommended Entries to Sub Editors</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SUB-ALLOCATION_SIDEBAR">
    <xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
  </xsl:template>

  <xsl:template name="SUB-ALLOCATION_MAINBODY">
    <br/>
    <!-- put the rest inside a table to give it some space around the borders -->
    <table width="100%" cellpadding="2" cellspacing="2" border="0">
      <tr valign="top">
        <td>
          <!-- now for the main part of the page -->
          <!-- the whole thing is one big form -->
          <xsl:apply-templates select="SUB-ALLOCATION-FORM"/>
        </td>
      </tr>
    </table>
    <br clear="all"/>
  </xsl:template>

  <!--
	Template for the SUB-ALLOCATION-FORM used to allocated
	recommended entries to sub editors
-->

  <xsl:template match="SUB-ALLOCATION-FORM">
    <!-- put in the javascript specific to this form -->
    <script language="javascript">
      <xsl:comment>
        submit = 0;
        function checkSubmit()
        {
        submit += 1;
        if (submit &gt; 2) { alert("<xsl:value-of select="$m_donotpress"/>"); return (false); }
        if (submit &gt; 1) { alert("<xsl:value-of select="$m_SubAllocationBeingProcessedPopup"/>"); return (false); }
        return (true);
        }

        function confirmAllocate(currentAllocations)
        {
        if (currentAllocations == 0 || confirm('This Sub still has some unreturned allocations, are you sure you wish to allocate more Entries to them?')) return (true);
        else return (false);
        }

        function allocate(subID)
        {
        if (checkSubmit())
        {
        document.forms.SubAllocationForm.Command.value = 'Allocate';
        document.forms.SubAllocationForm.SubID.value = subID;
        return (true);
        }
        else return (false);
        }

        function autoAllocate(subID, amount)
        {
        if (checkSubmit())
        {
        document.forms.SubAllocationForm.Command.value = 'AutoAllocate';
        document.forms.SubAllocationForm.SubID.value = subID;
        document.forms.SubAllocationForm.Amount.value = amount;
        return (true);
        }
        else return (false);
        }

        function deallocate()
        {
        if (checkSubmit())
        {
        document.forms.SubAllocationForm.Command.value = 'Deallocate';
        return (true);
        }
        else return (false);
        }

        function sendNotificationEmails()
        {
        if (checkSubmit())
        {
        document.forms.SubAllocationForm.Command.value = 'NotifySubs';
        return (true);
        }
        else return (false);
        }
        //
      </xsl:comment>
    </script>
    <!-- first display any report messages and errors -->
    <!-- check for errors first and show them in the warning colour -->
    <span xsl:use-attribute-sets="WarningMessageFont">
      <xsl:for-each select="ERROR">
        <xsl:choose>
          <xsl:when test="@TYPE='NO-ENTRIES-SELECTED'">
            There were no entries selected to allocate
          </xsl:when>
          <xsl:when test="@TYPE='INVALID-SUBEDITOR-ID'">
            The Sub-Editor ID was invalid.
          </xsl:when>
          <xsl:when test="@TYPE='ZERO-AUTO-ALLOCATE'">
            Auto-Allocate was set to zero
          </xsl:when>
          <xsl:when test="@TYPE='EMAIL-FAILURE'">
            Auto-Allocate was set to zero
          </xsl:when>
          <xsl:otherwise>
            An unknown error occurred.
          </xsl:otherwise>
        </xsl:choose>
        <br/>
      </xsl:for-each>
    </span>
    <!-- show number successfully allocated -->
    <xsl:if test="SUCCESSFUL-ALLOCATIONS">
      Successfully allocated: <xsl:value-of select="SUCCESSFUL-ALLOCATIONS/@TOTAL"/><br/>
    </xsl:if>
    <!-- show failed allocations in warning colour (probably red) if there are any -->
    <xsl:if test="FAILED-ALLOCATIONS">
      <xsl:choose>
        <xsl:when test="number(FAILED-ALLOCATIONS/@TOTAL) &gt; 0">
          <span xsl:use-attribute-sets="WarningMessageFont">
            Failed to allocate: <xsl:value-of select="FAILED-ALLOCATIONS/@TOTAL"/><br/>
            <xsl:for-each select="FAILED-ALLOCATIONS/ALLOCATION">
              Entry: <a target="_blank">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>
                  <xsl:value-of select="H2G2-ID"/>
                </xsl:attribute>
                <xsl:value-of select="SUBJECT"/>
              </a>, was allocated to <xsl:apply-templates select="USER"/> on <xsl:apply-templates select="DATE-ALLOCATED/DATE" mode="short"/><br/>
            </xsl:for-each>
          </span>
        </xsl:when>
        <xsl:otherwise>
          Failed to allocate: <xsl:value-of select="FAILED-ALLOCATIONS/@TOTAL"/><br/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- show number successfully deallocated -->
    <xsl:if test="SUCCESSFUL-DEALLOCATIONS">
      Successfully deallocated: <xsl:value-of select="SUCCESSFUL-DEALLOCATIONS/@TOTAL"/><br/>
    </xsl:if>
    <!-- show failed deallocations in warning colour (probably red) if there are any -->
    <xsl:if test="FAILED-DEALLOCATIONS">
      <xsl:choose>
        <xsl:when test="number(FAILED-DEALLOCATIONS/@TOTAL) &gt; 0">
          <span xsl:use-attribute-sets="WarningMessageFont">
            Failed to deallocate: <xsl:value-of select="FAILED-DEALLOCATIONS/@TOTAL"/><br/>
            <xsl:for-each select="FAILED-DEALLOCATIONS/DEALLOCATION">
              Entry: <a target="_blank">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>
                  <xsl:value-of select="H2G2-ID"/>
                </xsl:attribute>
                <xsl:value-of select="SUBJECT"/>
              </a>, was returned by <xsl:apply-templates select="USER"/> on <xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/><br/>
            </xsl:for-each>
          </span>
        </xsl:when>
        <xsl:otherwise>
          Failed to deallocate: <xsl:value-of select="FAILED-DEALLOCATIONS/@TOTAL"/><br/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="NOTIFICATIONS-SENT">
      Total notification emails sent to Subs: <xsl:value-of select="NOTIFICATIONS-SENT/@TOTAL"/><br/>
    </xsl:if>
    <!-- create the form HTML -->
    <form name="SubAllocationForm" method="post" action="{$root}AllocateSubs">
      <xsl:call-template name="skinfield"/>
      <input type="hidden" name="Command" value="Allocate"/>
      <input type="hidden" name="SubID" value="0"/>
      <input type="hidden" name="Amount" value="0"/>
      <table width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr valign="top">
          <!-- left hand sidebar with subs listing -->
          <td width="100">
            <table border="0" cellspacing="2" cellpadding="0">
              <!-- put the heading in it's own row -->
              <tr>
                <td colspan="7" align="center">
                  <span class="subheaderfont">
                    <b>Sub Editors</b>
                  </span>
                </td>
              </tr>
              <!-- put the send notifications button under the title -->
              <tr>
                <td colspan="7" align="center">
                  <xsl:if test="number(UNNOTIFIED-SUBS) &gt; 0">
                    <xsl:attribute name="bgcolor">red</xsl:attribute>
                  </xsl:if>
                  <input type="submit" value="Send Notifications" onClick="sendNotificationEmails()"/>
                </td>
              </tr>
              <!-- now place the colum headings -->
              <tr valign="top">
                <td>
                  <b>Sub</b>
                </td>
                <td>&nbsp;</td>
                <td>
                  <b>Current</b>
                </td>
                <td>&nbsp;</td>
                <td align="center">
                  <b>Notified</b>
                </td>
                <td>&nbsp;</td>
                <td align="center">
                  <b>Allocate</b>
                </td>
              </tr>
              <!-- do the actual table contents -->
              <xsl:for-each select="SUB-EDITORS/USER-LIST/USER">
                <tr valign="top">
                  <td>
                    <a href="{$root}InspectUser?UserID={USERID}">
                      <xsl:apply-templates select="USERNAME" mode="truncated"/>
                    </a>
                  </td>
                  <td>&nbsp;</td>
                  <td align="center">
                    <xsl:value-of select="ALLOCATIONS"/>
                  </td>
                  <td>&nbsp;</td>
                  <td align="center">
                    <xsl:apply-templates select="DATE-LAST-NOTIFIED/DATE" mode="short"/>
                  </td>
                  <td>&nbsp;</td>
                  <td align="left" width="200">
                    <input type="submit" value="Allocate" alt="{$alt_AllocateEntriesToThisSub}">
                      <xsl:attribute name="id">
                        AllocateButton<xsl:value-of select="USERID"/>
                      </xsl:attribute>
                      <xsl:attribute name="onClick">
                        if (confirmAllocate(<xsl:value-of select="ALLOCATIONS"/>)) allocate(<xsl:value-of select="USERID"/>); else (false)
                      </xsl:attribute>
                    </input>
                    &nbsp;
                    <input type="submit" alt="{$alt_AllocateEntriesToThisSub}">
                      <xsl:attribute name="id">
                        AutoAllocateButton<xsl:value-of select="USERID"/>
                      </xsl:attribute>
                      <xsl:attribute name="onClick">
                        if (confirmAllocate(<xsl:value-of select="ALLOCATIONS"/>)) autoAllocate(<xsl:value-of select="USERID"/>, <xsl:value-of select="SUB-QUOTA"/>); else (false)
                      </xsl:attribute>
                      <xsl:attribute name="value">
                        Auto <xsl:value-of select="SUB-QUOTA"/>
                      </xsl:attribute>
                    </input>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </td>
          <!-- central section with recommended articles
						 => two sections, top for unallocated, bottom for allocated recommendations
					-->
          <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <table border="0" cellspacing="2" cellpadding="0">
                    <!-- put the heading in it's own row -->
                    <tr>
                      <td colspan="7" align="center">
                        <span class="subheaderfont">
                          <b>Recommendations Awaiting Allocation</b>
                        </span>
                      </td>
                    </tr>
                    <!-- and put a nice gap after it -->
                    <tr>
                      <td colspan="7">&nbsp;</td>
                    </tr>
                    <!-- now place the colum headings -->
                    <tr valign="top">
                      <td>
                        <b>ID</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Subject</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Author</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Selected</b>
                      </td>
                    </tr>
                    <!-- do the actual table contents -->
                    <xsl:for-each select="UNALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/ARTICLE">
                      <tr valign="top">
                        <td>
                          <a target="_blank" href="{$root}A{H2G2-ID}">
                            A<xsl:value-of select="H2G2-ID"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <a target="_blank" href="{$root}A{H2G2-ID}">
                            <xsl:value-of select="SUBJECT"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <a target="_blank" href="{$root}U{AUTHOR/USER/USERID}">
                            <xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <input type="checkbox" name="EntryID">
                            <xsl:attribute name="value">
                              <xsl:value-of select="ENTRY-ID"/>
                            </xsl:attribute>
                          </input>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </table>
                </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>
                  <table border="0" cellspacing="2" cellpadding="0">
                    <!-- put the heading in it's own row -->
                    <tr>
                      <td colspan="11" align="center">
                        <span class="subheaderfont">
                          <b>Allocations Waiting to be Returned</b>
                        </span>
                      </td>
                    </tr>
                    <!-- and put a nice gap after it -->
                    <tr>
                      <td colspan="11">&nbsp;</td>
                    </tr>
                    <!-- now place the colum headings -->
                    <tr valign="top">
                      <td>
                        <b>ID</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Subject</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Author</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Sub</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Notified</b>
                      </td>
                      <td>&nbsp;</td>
                      <td>
                        <b>Deallocate</b>
                      </td>
                    </tr>
                    <!-- do the actual table contents -->
                    <xsl:for-each select="ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/ARTICLE">
                      <tr valign="top">
                        <td>
                          <a target="_blank" href="{$root}SubbedArticleStatus{H2G2-ID}">
                            A<xsl:value-of select="H2G2-ID"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <a target="_blank" href="{$root}A{H2G2-ID}">
                            <xsl:value-of select="SUBJECT"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <a target="_blank" href="{$root}U{AUTHOR/USER/USERID}">
                            <xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <a target="_blank" href="{$root}InspectUser?UserID={SUBEDITOR/USER/USERID}">
                            <xsl:apply-templates select="SUBEDITOR/USER/USERNAME" mode="truncated"/>
                          </a>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="NOTIFIED/text() = 1">Yes</xsl:when>
                            <xsl:otherwise>No</xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>&nbsp;</td>
                        <td>
                          <input type="checkbox" name="DeallocateID">
                            <xsl:attribute name="value">
                              <xsl:value-of select="ENTRY-ID"/>
                            </xsl:attribute>
                          </input>
                        </td>
                      </tr>
                    </xsl:for-each>
                    <tr>
                      <td colspan="9">

                        <xsl:if test="number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) &gt; 0">
                          <A href="{$root}AllocateSubs?show={ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT}&amp;skip={number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) - number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT)}">Older allocations</A> |
                        </xsl:if>
                        <xsl:if test="number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@MORE) = 1">
                          <A href="{$root}AllocateSubs?show={ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT}&amp;skip={number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@SKIPTO) + number(ALLOCATED-RECOMMENDATIONS/ARTICLE-LIST/@COUNT)}">More recent entries</A>
                        </xsl:if>
                      </td>
                      <td colspan="2" align="right">
                        <input type="submit" value="Deallocate" onClick="deallocate()"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <!--
	Scout recommendations page template
-->

  <xsl:template name="SCOUT-RECOMMENDATIONS_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>Scout Recommendations
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="SCOUT-RECOMMENDATIONS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">Scout Recommendations</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SCOUT-RECOMMENDATIONS_SIDEBAR">
    <xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
  </xsl:template>

  <xsl:template name="SCOUT-RECOMMENDATIONS_MAINBODY">
    <br/>
    <!-- put the rest inside a table to give it some space around the borders -->
    <table width="100%" cellpadding="2" cellspacing="2" border="0">
      <tr valign="top">
        <td>
          <!-- now for the main part of the page -->
          <!-- the whole thing is one big form -->
          <xsl:apply-templates select="UNDECIDED-RECOMMENDATIONS"/>
        </td>
      </tr>
    </table>
    <br clear="all"/>
  </xsl:template>

  <!--
	Template to match the undecied recommendations list in e.g. the scout recommendations
	page, and turn it into a suitable form
-->

  <xsl:template match="UNDECIDED-RECOMMENDATIONS">
    <!-- create the form HTML -->
    <form name="ScoutRecommendationsForm" method="get" action="{$root}ScoutRecommendations">
      <table width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr valign="top">
          <td>
            <b>ID</b>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Subject</b>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Author</b>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Recommended</b>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Scout</b>
          </td>
          <xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
            <td>&nbsp;</td>
            <td>
              <b>Decision</b>
            </td>
          </xsl:if>
        </tr>
        <xsl:for-each select="ARTICLE-LIST/ARTICLE">
          <tr valign="top">
            <td>
              A<xsl:value-of select="H2G2-ID"/>
            </td>
            <td>&nbsp;</td>
            <td>
              <a target="_blank" href="{$root}A{H2G2-ID}">
                <xsl:value-of select="SUBJECT"/>
              </a>
            </td>
            <td>&nbsp;</td>
            <td>
              <a target="_blank" href="{$root}U{EDITOR/USER/USERID}">
                <xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/>
              </a>
            </td>
            <td>&nbsp;</td>
            <td>
              <xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
            </td>
            <td>&nbsp;</td>
            <td>
              <a target="_blank" href="{$root}U{SCOUT/USER/USERID}">
                <xsl:apply-templates select="SCOUT/USER/USERNAME" mode="truncated"/>
              </a>
            </td>
            <xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
              <td>&nbsp;</td>
              <td>
                <input type="button" value="Accept">
                  <xsl:attribute name="onClick">
                    javascript:window.open('<xsl:value-of select="$root"/>ProcessRecommendation?RecommendationID=' + <xsl:value-of select="RECOMMENDATION-ID"/> + '&amp;Reject=0' + '&amp;mode=POPUP', 'ProcessRecommendation', 'resizable=1,scrollbars=1,width=750,height=550')
                  </xsl:attribute>
                </input>
                &nbsp;
                <input type="button" value="Reject">
                  <xsl:attribute name="onClick">
                    javascript:window.open('<xsl:value-of select="$root"/>ProcessRecommendation?RecommendationID=' + <xsl:value-of select="RECOMMENDATION-ID"/> + '&amp;Accept=0' + '&amp;mode=POPUP', 'ProcessRecommendation', 'resizable=1,scrollbars=1,width=375,height=550')
                  </xsl:attribute>
                </input>
              </td>
            </xsl:if>
          </tr>
        </xsl:for-each>
      </table>
    </form>
  </xsl:template>

  <!--
	Template to do the PROCESS-RECOMMENDATION page in a simple format
	when viewed in a popup window.
-->

  <!--<xsl:template match='H2G2[@TYPE="PROCESS-RECOMMENDATION" and @MODE="POPUP"]'>-->
  <xsl:template match="H2G2[@TYPE='PROCESS-RECOMMENDATION']">
    <html>
      <head>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>Process Recommendation</title>
        <script language="JavaScript">
          <xsl:comment>
            submit=0;
            function submitAndRefreshParent(form)
            {
            submit += 1;
            if (submit &gt; 1) { alert("Request is being processed, please be patient"); return false; }
            else
            {
            // submit the form, then wait a second and refresh the parent window, if any
            form.submit();
            if (window.opener != null)
            {
            window.setTimeout('window.opener.location.reload()', 1000);
            }
            }
            }
            //
          </xsl:comment>
        </script>
      </head>
      <body xsl:use-attribute-sets="body">
        <xsl:apply-templates select="PROCESS-RECOMMENDATION-FORM"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="PROCESS-RECOMMENDATION-FORM">
    <form name="ProcessRecommendationForm" method="post" action="{$root}ProcessRecommendation" onSubmit="submitAndRefreshParent(this)">
      <!--<input type="text" name="skin"/><br/>-->
      <input type="hidden" name="mode">
        <xsl:attribute name="value">
          <xsl:value-of select="/H2G2/@MODE"/>
        </xsl:attribute>
      </input>
      <!-- don't show the form if we have no details -->
      <xsl:if test="SUBMISSION/@SUCCESS=1">
        The recommendation has been accepted.
      </xsl:if>

      <xsl:if test="number(RECOMMENDATION-ID) &gt; 0">
        <input type="hidden" name="RecommendationID">
          <xsl:attribute name="value">
            <xsl:value-of select="number(RECOMMENDATION-ID)"/>
          </xsl:attribute>
        </input>
        <input type="hidden" name="h2g2ID">
          <xsl:attribute name="value">
            <xsl:value-of select="number(H2G2-ID)"/>
          </xsl:attribute>
        </input>
        <xsl:if test="number(H2G2-ID) != 0">
          <a target="_blank">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/>
            </xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
          </a>
          <xsl:text> : </xsl:text>
          <b>
            <xsl:value-of select="SUBJECT"/>
          </b>
          <xsl:text> by </xsl:text>
          <a href="mailto:{EDITOR/USER/EMAIL-ADDRESS}">
            <xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/>
          </a>
          <br/>
          <br/>
          <xsl:text>Recommended by </xsl:text>
          <xsl:apply-templates select="SCOUT/USER"/>
          <xsl:text> on </xsl:text>
          <xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
        </xsl:if>
        <br/><br/>
        Comments:<br/>
        <textarea name="Comments" wrap="virtual" cols="40" rows="5">
          <xsl:value-of select="COMMENTS"/>
        </textarea>
        <br/>
        <table>
          <tr>
            <td>
              <br/><b>Email to Scout</b><br/><br/>
              Email:
              <input type="text" name="ScoutEmail">
                <xsl:attribute name="value">
                  <xsl:value-of select="SCOUT/USER/EMAIL-ADDRESS"/>
                </xsl:attribute>
              </input><br/>
              Subject:
              <input type="text" name="ScoutEmailSubject" size="30">
                <xsl:attribute name="value">
                  <xsl:value-of select="SCOUT-EMAIL/SUBJECT"/>
                </xsl:attribute>
              </input>
              <br/>
              Text:<br/>
              <textarea name="ScoutEmailText" wrap="virtual" cols="40" rows="10">
                <xsl:value-of select="SCOUT-EMAIL/TEXT"/>
              </textarea>
            </td>
            <td>
              <xsl:if test="FUNCTIONS/ACCEPT">
                <br/>
                <br/><b>Email to Author</b><br/><br/>
                Email:
                <input type="text" name="AuthorEmail">
                  <xsl:attribute name="value">
                    <xsl:value-of select="EDITOR/USER/EMAIL-ADDRESS"/>
                  </xsl:attribute>
                </input><br/>
                Subject:
                <input type="text" name="AuthorEmailSubject" size="30">
                  <xsl:attribute name="value">
                    <xsl:value-of select="AUTHOR-EMAIL/SUBJECT"/>
                  </xsl:attribute>
                </input>
                <br/>
                Text:<br/>
                <textarea name="AuthorEmailText" wrap="virtual" cols="40" rows="10">
                  <xsl:value-of select="AUTHOR-EMAIL/TEXT"/>
                </textarea>
              </xsl:if>
              <br/>
              <br/>
            </td>
          </tr>
        </table>
      </xsl:if>
      <xsl:if test="FUNCTIONS/ACCEPT">
        <input type="submit" name="cmd" value="Accept"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="FUNCTIONS/REJECT">
        <input type="submit" name="cmd" value="Reject"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="FUNCTIONS/CANCEL">
        <input type="submit" value="Cancel" onClick="window.close()"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="FUNCTIONS/FETCH">
        <!--
				<br/><br/>
				Fetch by ID: 
				<input type="text" name="FetchID"/>
				<input type="submit" name="cmd" value="Fetch"/>
-->
      </xsl:if>
    </form>
  </xsl:template>

  <!--
	Template to do the MOVE-THREAD page in a simple format
	when viewed in a popup window.
-->

  <!--<xsl:template match='H2G2[@TYPE="MOVE-THREAD" and @MODE="POPUP"]'>-->
  <xsl:template match="H2G2[@TYPE='MOVE-THREAD']">
    <html>
      <head>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 : Move Thread</title>
        <!-- javascript for thread moving popup -->
        <script language="javascript">
          <xsl:comment>
            submit = 0;
            function checkSubmit()
            {
            submit += 1;
            if (submit &gt; 1) { alert("Request is being processed, please be patient."); return (false); }
            return (true);
            }

            function fetchDetails(threadID)
            {
            // build a js string to popup a window to move the given thread to the currently selected destination
            var selectObject = eval('document.forms.MoveThreadForm' + threadID + '.Select' + threadID);
            var forumID = selectObject.options[selectObject.selectedIndex].value;

            //msgbox("hello");
            var fieldObject = eval('document.forms.MoveThreadForm' + threadID + '.DestinationID');
            fieldObject.value = 'F' + forumID;
            // show screen for 'busy processing'
            // only do a fetch within the popup - not an automatic move
            //return eval('window.location.href=\'<xsl:value-of select="$root"/>MoveThread?cmd=Fetch?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\'');
            }
            //
          </xsl:comment>
        </script>
      </head>
      <body xsl:use-attribute-sets="body">
        <xsl:apply-templates select="MOVE-THREAD-FORM"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="MOVE-THREAD-FORM">
    <form method="get" action="{$root}MoveThread" onSubmit="checkSubmit()">
      <xsl:attribute name="name">
        MoveThreadForm<xsl:value-of select="THREAD-ID"/>
      </xsl:attribute>
      <input type="hidden" name="mode">
        <xsl:attribute name="value">
          <xsl:value-of select="/H2G2/@MODE"/>
        </xsl:attribute>
      </input>
      <input type="hidden" name="AutoPostID">
        <xsl:attribute name="value">
          <xsl:value-of select="AUTO-POST-ID"/>
        </xsl:attribute>
      </input>
      <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_frommod']/VALUE=1">
        <input type="hidden" name="s_frommod" value="1"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="SUCCESS='1'">
          <b>Thread moved successfully!</b>
          <br/>
          <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME = 's_frommod']/VALUE=1)">
            <script language="javascript">
              <xsl:comment>
                // force a reload on the opening window, if any
                if (window.opener != null)
                {
                window.opener.location.reload();
                }
                //
              </xsl:comment>
            </script>
          </xsl:if>
        </xsl:when>
        <xsl:when test="SUCCESS='0'">
          <b>
            <span xsl:use-attribute-sets="WarningMessageFont">Move failed!</span>
          </b>
        </xsl:when>
      </xsl:choose>
      <br/>
      <!-- display any error messages -->
      <xsl:for-each select="ERROR">
        <xsl:choose>
          <xsl:when test="@TYPE='INVALID-DESTINATION'">
            Destination was not a valid Forum, Article or User ID.<br/><br/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <!-- display the form -->
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr valign="center">
          <td align="right">Move:</td>
          <td align="left">
            <input type="text" name="ThreadID" size="8">
              <xsl:attribute name="value">
                <xsl:value-of select="number(THREAD-ID)"/>
              </xsl:attribute>
            </input>
          </td>
          <td>&nbsp;</td>
          <td width="100%">
            <xsl:if test="string-length(THREAD-SUBJECT) &gt; 0">
              <nobr>
                '<xsl:value-of select="THREAD-SUBJECT"/>'
              </nobr>
            </xsl:if>
          </td>
        </tr>
        <tr valign="center">
          <td align="right">To:</td>
          <td align="left">
            <input type="text" name="DestinationID" size="8">
              <xsl:attribute name="value">
                F<xsl:value-of select="number(NEW-FORUM-ID)"/>
              </xsl:attribute>
            </input>
          </td>
          <td>&nbsp;</td>
          <td width="100%">
            <xsl:if test="string-length(NEW-FORUM-TITLE) &gt; 0">
              '<xsl:value-of select="NEW-FORUM-TITLE"/>'
            </xsl:if>
          </td>
        </tr>
        <!-- do the drop down menu -->
        <tr valign="center">
          <td/>
          <td align="left" colspan="3">
            <select>
              <xsl:attribute name="name">
                Select<xsl:value-of select="THREAD-ID"/>
              </xsl:attribute>
              <xsl:attribute name="onChange">
                fetchDetails(<xsl:value-of select="THREAD-ID"/>)
              </xsl:attribute>
              <option value="0" selected="selected">Choose destination:</option>
              <option value="1">
                <xsl:if test="number(NEW-FORUM-ID) = 1">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Junk
              </option>
              <option value="48874">
                <xsl:if test="number(NEW-FORUM-ID) = 48874">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Peer Review
              </option>
              <option value="59234">
                <xsl:if test="number(NEW-FORUM-ID) = 59234">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Peer Review Sin Bin
              </option>
              <option value="57153">
                <xsl:if test="number(NEW-FORUM-ID) = 57153">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Writing Workshop
              </option>
              <option value="615">
                <xsl:if test="number(NEW-FORUM-ID) = 615">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Feedback Forum
              </option>
              <option value="47997">
                <xsl:if test="number(NEW-FORUM-ID) = 47997">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Editorial Feedback
              </option>
              <option value="47996">
                <xsl:if test="number(NEW-FORUM-ID) = 47996">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Technical Feedback
              </option>
              <option value="47998">
                <xsl:if test="number(NEW-FORUM-ID) = 47998">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Design Feedback
              </option>
              <option value="56584">
                <xsl:if test="number(NEW-FORUM-ID) = 56584">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Business Feedback
              </option>
              <option value="47999">
                <xsl:if test="number(NEW-FORUM-ID) = 47999">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Feature Suggestions
              </option>
              <option value="48000">
                <xsl:if test="number(NEW-FORUM-ID) = 48000">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Bug Reports
              </option>
              <option value="24276">
                <xsl:if test="number(NEW-FORUM-ID) = 24276">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>GuideML Clinic
              </option>
              <option value="55683">
                <xsl:if test="number(NEW-FORUM-ID) = 55683">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Community Soapbox
              </option>
              <option value="19585">
                <xsl:if test="number(NEW-FORUM-ID) = 19585">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>Ask h2g2
              </option>
              <option value="30859">
                <xsl:if test="number(NEW-FORUM-ID) = 30859">
                  <xsl:attribute name="SELECTED">SELECTED</xsl:attribute>
                </xsl:if>How Do I...?
              </option>
              <option value="0">Other</option>
            </select>
            <xsl:if test="FUNCTIONS/FETCH">
              <input type="submit" name="cmd" value="Fetch"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <br/>
          </td>
        </tr>
        <!-- do the textfield for custom message -->
        <tr valign="center">
          <td valign="top" align="right">Post:</td>
          <td align="left" colspan="3">
            <textarea name="PostContent" wrap="virtual" cols="25" rows="3">
              <xsl:value-of select="POST-CONTENT"/>
            </textarea>
          </td>
        </tr>
        <!-- insert the buttons requested -->
        <tr valign="center">
          <td/>
          <td align="left" colspan="3">
            <xsl:if test="FUNCTIONS/MOVE">
              <input type="submit" name="cmd" value="Move"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <!--
						<xsl:if test="FUNCTIONS/UNDO">
							<input type="submit" name="cmd" value="Undo"/>
							<xsl:text> </xsl:text>
						</xsl:if>
-->
            <xsl:if test="FUNCTIONS/CANCEL">
              <input type="submit" value="Close" onClick="window.close()"/>
            </xsl:if>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

  <xsl:template name="INSPECT-USER_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>Inspect User
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="INSPECT-USER_SUBJECT">
    <!--
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">Inspect User</xsl:with-param>
	</xsl:call-template>
-->
  </xsl:template>

  <xsl:template name="INSPECT-USER_SIDEBAR">
    <xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
  </xsl:template>

  <xsl:template name="INSPECT-USER_MAINBODY">
    <br/>
    <!-- put the rest inside a table to give it some space around the borders -->
    <table width="100%" cellpadding="2" cellspacing="2" border="0">
      <tr valign="top">
        <td>
          <!-- now for the main part of the page -->
          <!-- the whole thing is one big form -->
          <xsl:apply-templates select="INSPECT-USER-FORM"/>
        </td>
      </tr>
    </table>
    <br clear="all"/>
  </xsl:template>

  <xsl:template match="INSPECT-USER-FORM">
    <!-- variable to make calculation of drop down menus easier -->
    <xsl:variable name="Integers">
      <VALUES>
        <I>0</I>
        <I>1</I>
        <I>2</I>
        <I>3</I>
        <I>4</I>
        <I>5</I>
        <I>6</I>
        <I>7</I>
        <I>8</I>
        <I>9</I>
        <I>10</I>
        <I>11</I>
        <I>12</I>
        <I>13</I>
        <I>14</I>
        <I>15</I>
        <I>16</I>
        <I>17</I>
        <I>18</I>
        <I>19</I>
        <I>20</I>
        <I>21</I>
        <I>22</I>
        <I>23</I>
        <I>24</I>
        <I>25</I>
        <I>26</I>
        <I>27</I>
        <I>28</I>
        <I>29</I>
        <I>30</I>
      </VALUES>
    </xsl:variable>
    <!-- display any error message first -->
    <span xsl:use-attribute-sets="WarningMessageFont">
      <xsl:for-each select="ERROR">
        <xsl:value-of select="."/>
        <br/>
      </xsl:for-each>
    </span>
    <!-- the actual inspect user form -->
    <form name="InspectUserForm" method="post" action="{$root}InspectUser">
      <input type="hidden" name="UserID" value="{USER/USERID}"/>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr valign="top" align="center">
          <td colspan="5">
            <b>User ID: </b>
            <input type="text" name="FetchUserID" value="{USER/USERID}" size="8"/>
            &nbsp;
            <input type="submit" name="FetchUser" value="Fetch User"/>
          </td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr align="center">
          <td colspan="5">
            <span class="inspecttitle">
              Inspecting U<xsl:value-of select="USER/USERID"/> : <xsl:apply-templates select="USER"/>
            </span>
          </td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td colspan="2">
            <b>Active: </b>
            <xsl:value-of select="USER/ACTIVE"/>
            <xsl:if test="USER/ACTIVE = 'No'">
              &nbsp;
              (since <xsl:apply-templates select="USER/DATE-RELEASED/DATE"/>)
            </xsl:if>
          </td>
          <td colspan="3">
            <b>Date Joined: </b>
            <xsl:apply-templates select="USER/DATE-JOINED/DATE" mode="absolute"/>
          </td>
        </tr>
        <tr valign="top">
          <td colspan="5">
            <!-- don't show deactivate button on users own account -->
            <xsl:choose>
              <xsl:when test="USER/ACTIVE = 'Yes' and /H2G2/VIEWING-USER/USER/USERID != USER/USERID">
                <input type="submit" name="DeactivateAccount" value="Deactivate">
                  <xsl:if test="USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
                    <xsl:attribute name="onClick">return confirm('Are you sure you wish to deactivate this Editors account?')</xsl:attribute>
                  </xsl:if>
                </input>
              </xsl:when>
              <xsl:when test="USER/ACTIVE = 'No'">
                <input type="submit" name="ReactivateAccount" value="Reactivate"/>
              </xsl:when>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td>
            <b>UserName:</b>
            <br/>
            <input type="text" name="UserName" value="{USER/USERNAME}"/>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Email:</b>
            <br/>
            <input type="text" name="EmailAddress" value="{USER/EMAIL-ADDRESS}"/>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>LoginName:</b>
            <br/>
            <input type="text" name="LoginName" value="{USER/LOGIN-NAME}" disabled="disabled"/>
          </td>
        </tr>
        <tr valign="top">
          <td>
            <b>First Names:</b>
            <br/>
            <input type="text" name="FirstNames" value="{USER/FIRST-NAMES}"/>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Last Name:</b>
            <br/>
            <input type="text" name="LastName" value="{USER/LAST-NAME}"/>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>BBC User ID:</b>
            <br/>
            <input type="text" name="BBCUID" value="{USER/BBCUID}" disabled="disabled"/>
          </td>
        </tr>
        <tr valign="top">
          <td>
            <b>Status:</b>
            <br/>
            <xsl:choose>
              <xsl:when test="$superuser = 1">
                <select name="Status">
                  <option value="1">
                    <xsl:if test="USER/STATUS=1">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>User
                  </option>
                  <option value="2">
                    <xsl:if test="USER/STATUS=2">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>Editor
                  </option>
                </select>
              </xsl:when>
              <xsl:otherwise>
                <input type="HIDDEN" name="Status" value="{USER/STATUS}"/>
                <xsl:choose>
                  <xsl:when test="USER/STATUS=1">User</xsl:when>
                  <xsl:when test="USER/STATUS=2">Super-User</xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>&nbsp;</td>
          <td>
            <b>Password:</b>
            <br/>
            <input type="text" name="Password" value="{USER/PASSWORD}"/>
          </td>
          <td>&nbsp;</td>
          <td>
            <xsl:if test="$superuser = 1">
              <input name="ClearBBCDetails" value="Clear BBC Details" type="submit" onClick="return confirm('This will clear the BBC details for this user, requiring them to reactivate their account. Are you sure you want to do this?')"/>
            </xsl:if>
            <br/>
            <xsl:choose>
              <xsl:when test="$superuser = 1">
                <span class="">Clearing the BBC details allows them to be used with a different h2g2 account, but it also prevents the use of this account until it is reactivated with different BBC details.</span>
              </xsl:when>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="5">
            <input type="submit" name="UpdateDetails" value="Update Details"/>
          </td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="5">&nbsp;</td>
        </tr>
      </table>
      <!-- bizarre work around to allow comparison of node name to a variable => is there a better way? -->
      <xsl:variable name="UsersGroups">
        <xsl:for-each select="/H2G2/INSPECT-USER-FORM/USER/GROUPS/*">
          <xsl:text> </xsl:text>
          <xsl:value-of select="name()"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:variable>
      <table cellpadding="0" cellspacing="0" border="0">
        <tr valign="top">
          <td colspan="5">
            <b>Group Membership:</b>
          </td>
        </tr>
        <tr valign="top" align="left">
          <td>
            <B>Current</B>
            <br/>
            <!-- display current groups in a deactivated list for reference -->
            <!--
							<select name="GroupsDisplay" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}" disabled="disabled">
								<xsl:for-each select="GROUPS-LIST/GROUP">
									<option value="{@ID}"><xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="@NAME"/></option>
								</xsl:for-each>
							</select>
							-->
            <xsl:for-each select="GROUPS-LIST/GROUP">
              <xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))">
                <xsl:value-of select="@NAME"/>
                <br/>
              </xsl:if>
            </xsl:for-each>
          </td>
          <td>&nbsp;</td>
          <td>
            <B>New</B>
            <br/>
            <!-- then have a list the user can change -->
            <!--
							<select name="GroupsMenu" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}">
								<xsl:for-each select="GROUPS-LIST/GROUP">
									<option value="{@ID}"><xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="@NAME"/></option>
								</xsl:for-each>
							</select>
							-->
            <xsl:for-each select="GROUPS-LIST/GROUP">
              <INPUT id="Chk{@NAME}" name="GroupsMenu" value="{@ID}" TYPE="CHECKBOX">
                <xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))">
                  <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                </xsl:if>
              </INPUT>
              <xsl:value-of select="@NAME"/>
              <br/>
            </xsl:for-each>
          </td>
          <td>&nbsp;</td>
          <td>
            <xsl:if test="$superuser=1">
              <b>Create new group:</b>
              <br/>
              <input type="text" name="NewGroupName" value=""/>
              <br/>
              <input type="submit" name="CreateUserGroup" value="Create Group"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <script language="JavaScript">
          <xsl:comment>
            function CheckGroups()
            {
            if (document.InspectUserForm.ChkReferee == null ||
            document.InspectUserForm.ChkModerator == null)
            {
            return true;
            }

            if (document.InspectUserForm.ChkModerator.checked == false
            &amp;&amp; document.InspectUserForm.ChkReferee.checked == true)
            {
            alert("<xsl:value-of select="$m_RefereeShouldBeModerator"/>");
            return false;
            }
            return true;
            }
            //
          </xsl:comment>
        </script>
        <tr>
          <td colspan="2">
            <input type="submit" onclick="return CheckGroups();" name="UpdateGroups" value="Update Groups"/>
          </td>
        </tr>
      </table>
      <br/>
      <input type="reset" value="Reset Form"/>
      <!-- display group-related data as appropriate -->
      <xsl:if test="USER/GROUPS[SCOUTS or EDITOR]">
        <br/>
        <br/>
        <h3>Scout Info</h3>
        Quota:
        <xsl:variable name="ScoutQuota" select="number(SCOUT-INFO/QUOTA)"/>
        <select name="ScoutQuota">
          <xsl:for-each select="msxsl:node-set($Integers)/VALUES/I">
            <option value="{number(.)}">
              <xsl:if test="number(.) = number($ScoutQuota)">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="number(.)"/>
            </option>
          </xsl:for-each>
        </select>
        <xsl:text> </xsl:text>
        Interval:
        <select name="ScoutInterval">
          <option value="day">
            <xsl:if test="SCOUT-INFO/INTERVAL = 'day'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Day
          </option>
          <option value="week">
            <xsl:if test="SCOUT-INFO/INTERVAL = 'week'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Week
          </option>
          <option value="month">
            <xsl:if test="SCOUT-INFO/INTERVAL = 'month'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Month
          </option>
        </select>
        <br/>
        Total Recommendations: <xsl:value-of select="SCOUT-INFO/TOTAL-RECOMMENDATIONS"/><br/>
        Recommendations Last Interval: <xsl:value-of select="SCOUT-INFO/RECOMMENDATIONS-LAST-INTERVAL"/><br/>
        <br/>
        <input type="submit" name="UpdateScoutInfo" value="Update Scout Info"/>
        <br/>
        <br/>
        <b>Recent Recommendations</b> in the last:
        <select name="RecommendationsPeriod">
          <option value="hour">
            <xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'hour'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Hour
          </option>
          <option value="day">
            <xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'day'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Day
          </option>
          <option value="week">
            <xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'week'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Week
          </option>
          <option value="month">
            <xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'month'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Month
          </option>
          <option value="year">
            <xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'year'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Year
          </option>
        </select>
        &nbsp;
        <input type="submit" name="Refresh" value="Refresh"/>
        <br/>
        <br/>
        <table>
          <tr valign="top">
            <td>
              <b>ID</b>
            </td>
            <td>
              <b>Subject</b>
            </td>
            <td>
              <b>Editor</b>
            </td>
            <td>
              <b>Recommended</b>
            </td>
            <td>
              <b>Accepted?</b>
            </td>
            <td>
              <b>Sub Editor</b>
            </td>
            <td>
              <b>Returned?</b>
            </td>
          </tr>
          <xsl:for-each select="SCOUT-INFO/ARTICLE-LIST[@TYPE = 'SCOUT-RECOMMENDATIONS']/ARTICLE">
            <tr valign="top">
              <td>
                A<xsl:value-of select="H2G2-ID"/>
              </td>
              <td>
                <a href="{$root}A{H2G2-ID}">
                  <xsl:value-of select="SUBJECT"/>
                </a>
              </td>
              <td>
                <a href="{$root}U{EDITOR/USER/USERID}">
                  <xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/>
                </a>
              </td>
              <td>
                <xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="RECOMMENDATION-STATUS = 3">
                    <xsl:apply-templates select="RECOMMENDATION-DECISION-DATE/DATE" mode="short"/>
                  </xsl:when>
                  <xsl:when test="RECOMMENDATION-STATUS = 2">Rejected</xsl:when>
                  <xsl:otherwise>Pending</xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="SUBBING-STATUS = 1">Unallocated</xsl:when>
                  <xsl:when test="SUBBING-STATUS = 2 or SUBBING-STATUS = 3">
                    <a href="{$root}InspectUser?UserID={SUBEDITOR/USER/USERID}">
                      <xsl:apply-templates select="SUBEDITOR/USER/USERNAME" mode="truncated"/>
                    </a>
                  </xsl:when>
                  <xsl:when test="SUBBING-STATUS = 3"/>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="SUBBING-STATUS = 3">
                    <xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/>
                  </xsl:when>
                  <xsl:when test="SUBBING-STATUS = 2">Waiting</xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>
      <xsl:if test="USER/GROUPS[SUBS or EDITOR]">
        <br/>
        <br/>
        <h3>Sub Editor Info</h3>
        Quota:
        <xsl:variable name="SubQuota" select="number(SUB-INFO/QUOTA)"/>
        <select name="SubQuota">
          <xsl:for-each select="msxsl:node-set($Integers)/VALUES/I">
            <option value="{number(.)}">
              <xsl:if test="number(.) = number($SubQuota)">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="number(.)"/>
            </option>
          </xsl:for-each>
        </select>
        <br/>
        Current Allocations: <xsl:value-of select="SUB-INFO/CURRENT-ALLOCATIONS"/><br/>
        Total Subbed: <xsl:value-of select="SUB-INFO/TOTAL-SUBBED"/><br/>
        <br/>
        <input type="submit" name="UpdateSubInfo" value="Update Sub Info"/>
        <br/>
        <br/>
        <b>Recent Allocations</b> in the last:
        <select name="SubAllocationsPeriod">
          <option value="hour">
            <xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'hour'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Hour
          </option>
          <option value="day">
            <xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'day'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Day
          </option>
          <option value="week">
            <xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'week'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Week
          </option>
          <option value="month">
            <xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'month'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Month
          </option>
          <option value="year">
            <xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'year'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>Year
          </option>
        </select>
        &nbsp;
        <input type="submit" name="Refresh" value="Refresh"/>
        <br/>
        <br/>
        <table>
          <tr valign="top">
            <td>
              <b>ID</b>
            </td>
            <td>
              <b>Subject</b>
            </td>
            <td>
              <b>Editor</b>
            </td>
            <td>
              <b>Recommended</b>
            </td>
            <td>
              <b>Scout</b>
            </td>
            <td>
              <b>Accepted</b>
            </td>
            <td>
              <b>Allocated</b>
            </td>
            <td>
              <b>Returned?</b>
            </td>
          </tr>
          <xsl:for-each select="SUB-INFO/ARTICLE-LIST[@TYPE = 'SUB-ALLOCATIONS']/ARTICLE">
            <tr valign="top">
              <td>
                A<xsl:value-of select="H2G2-ID"/>
              </td>
              <td>
                <a href="{$root}A{H2G2-ID}">
                  <xsl:value-of select="SUBJECT"/>
                </a>
              </td>
              <td>
                <a href="{$root}U{EDITOR/USER/USERID}">
                  <xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/>
                </a>
              </td>
              <td>
                <xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
              </td>
              <td>
                <a href="{$root}U{SCOUT/USER/USERID}">
                  <xsl:apply-templates select="SCOUT/USER/USERNAME" mode="truncated"/>
                </a>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="RECOMMENDATION-STATUS = 3">
                    <xsl:apply-templates select="RECOMMENDATION-DECISION-DATE/DATE" mode="short"/>
                  </xsl:when>
                  <xsl:when test="RECOMMENDATION-STATUS = 2">Rejected</xsl:when>
                  <xsl:otherwise>Pending</xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="SUBBING-STATUS = 3 or SUBBING-STATUS=2">
                    <xsl:apply-templates select="DATE-ALLOCATED/DATE" mode="short"/>
                  </xsl:when>
                  <xsl:when test="SUBBING-STATUS = 1">Unallocated</xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="SUBBING-STATUS = 3">
                    <xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/>
                  </xsl:when>
                  <xsl:when test="SUBBING-STATUS = 2">Waiting</xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:if>


      <br/>
    </form>
    <xsl:if test="JOURNAL-INFO">
      <br/>
      <h3>
        <xsl:value-of select="m_MoveJournalToSite"/>
      </h3>
      <xsl:apply-templates select="JOURNAL-INFO/SITEID" mode="MoveToSite">
        <xsl:with-param name="objectID" select="/H2G2/INSPECT-USER-FORM/USER/JOURNAL"/>
      </xsl:apply-templates>
    </xsl:if>
    <br/>
    <br/>
    <br/>
  </xsl:template>

  <xsl:template name="GROUP-MANAGEMENT_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>Manage Groups
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="GROUP-MANAGEMENT_SUBJECT">
    <div align="center">
      <xsl:call-template name="SUBJECTHEADER">
        <xsl:with-param name="text">Users Group Management</xsl:with-param>
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template name="GROUP-MANAGEMENT_SIDEBAR">
    <xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
  </xsl:template>

  <xsl:template name="GROUP-MANAGEMENT_MAINBODY">
    <br/>
    <!-- put the rest inside a table to give it some space around the borders -->
    <table width="100%" cellpadding="2" cellspacing="2" border="0">
      <tr valign="top">
        <td>
          <!-- now for the main part of the page -->
          <!-- the whole thing is one big form -->
          <xsl:apply-templates select="GROUP-MANAGEMENT-FORM"/>
        </td>
      </tr>
    </table>
    <br clear="all"/>
  </xsl:template>

  <xsl:template match="GROUP-MANAGEMENT-FORM">
    <!-- display any error message first -->
    <span xsl:use-attribute-sets="WarningMessageFont">
      <xsl:for-each select="ERROR">
        <xsl:value-of select="."/>
        <br/>
      </xsl:for-each>
    </span>
    <!-- the actual group management form -->
    <form name="ManageGroupsForm" method="post" action="{$root}ManageGroups">
      <!-- bizarre work around to allow comparison of node name to a variable => is there a better way? -->
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr valign="top" align="center">
          <td>
            <b>Show Membership of:</b>
          </td>
        </tr>
        <tr valign="top" align="center">
          <td>
            <select name="GroupName" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}">
              <xsl:for-each select="GROUPS-LIST/GROUP">
                <option value="{@ID}">
                  <xsl:if test="@ID = /H2G2/GROUP-MANAGEMENT-FORM/GROUP/@NAME">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="@NAME"/>
                </option>
              </xsl:for-each>
            </select>
            <br/>
            <input type="submit" name="Refresh" value="Refresh"/>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      <table cellpadding="0" cellspacing="4" border="0" width="100%">
        <xsl:for-each select="GROUP">
          <tr valign="top" align="center">
            <td colspan="4">
              <b>
                <xsl:value-of select="@NAME"/>
              </b>
            </td>
          </tr>
          <tr valign="top">
            <td>
              <b>ID</b>
            </td>
            <td>
              <b>UserName</b>
            </td>
            <td>
              <b>Email</b>
            </td>
            <td>
              <b>
                <nobr>Date Joined</nobr>
              </b>
            </td>
          </tr>
          <xsl:for-each select="USER-LIST/USER">
            <tr valign="top">
              <td>
                <a href="{$root}U{USERID}">
                  U<xsl:value-of select="USERID"/>
                </a>
              </td>
              <td>
                <a href="{$root}InspectUser?UserID={USERID}">
                  <xsl:apply-templates select="USERNAME" mode="truncated"/>
                </a>
              </td>
              <td>
                <a href="mailto:{EMAIL}">
                  <xsl:value-of select="EMAIL"/>
                </a>
              </td>
              <td>
                <xsl:apply-templates select="DATE-JOINED" mode="short"/>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
        </xsl:for-each>
      </table>
      <br/>
      <br/>
      <br/>
      <br/>
    </form>
  </xsl:template>

  <xsl:template name="SUBBED-ARTICLE-STATUS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">Subbed Article Status</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SUBBED-ARTICLE-STATUS_MAINBODY">
    <xsl:if test="ERROR">
      No details were found for the article ID <xsl:value-of select="ERROR/@H2G2ID"/><br/>
    </xsl:if>
    <xsl:apply-templates select="SUBBED-ARTICLES"/>
  </xsl:template>

  <xsl:template match="SUBBED-ARTICLES">
    <TABLE>
      <xsl:for-each select="ARTICLEDETAILS">
        <TR>
          <TD>ID:</TD>
          <TD>
            <A href="{$root}A{H2G2ID}" TARGET="_blank">
              A<xsl:value-of select="H2G2ID"/>
            </A>
          </TD>
        </TR>
        <TR>
          <TD>Subject: </TD>
          <TD>
            <xsl:value-of select="SUBJECT"/>
          </TD>
        </TR>
        <TR>
          <TD>Based on:</TD>
          <TD>
            <A href="{$root}A{ORIGINALH2G2ID}" TARGET="_blank">
              A<xsl:value-of select="ORIGINALH2G2ID"/>
            </A>
          </TD>
        </TR>
        <TR>
          <TD>Accepted by:</TD>
          <TD>
            <A href="{$root}InspectUser?UserID={ACCEPTOR/USERID}" TARGET="_blank">
              <xsl:value-of select="ACCEPTOR/USERNAME"/>
            </A>
          </TD>
        </TR>
        <TR>
          <TD>Allocated by:</TD>
          <TD>
            <A href="{$root}InspectUser?UserID={ALLOCATOR/USERID}" TARGET="_blank">
              <xsl:value-of select="ALLOCATOR/USERNAME"/>
            </A>
          </TD>
        </TR>
        <TR>
          <TR>
            <TD>SubEditor:</TD>
            <TD>
              <A href="{$root}InspectUser?UserID={SUBEDITOR/USERID}" TARGET="_blank">
                <xsl:value-of select="SUBEDITOR/USERNAME"/>
              </A>
            </TD>
          </TR>
          <TD>Date allocated</TD>
          <TD>
            <xsl:choose>
              <xsl:when test="DATEALLOCATED">
                <xsl:apply-templates select="DATEALLOCATED/DATE"/>
              </xsl:when>
              <xsl:otherwise>
                Not yet allocated
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <TR>
          <TD>Date returned</TD>
          <TD>
            <xsl:choose>
              <xsl:when test="DATERETURNED">
                <xsl:apply-templates select="DATERETURNED/DATE"/>
              </xsl:when>
              <xsl:otherwise>
                Not yet returned
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <TR>
          <TD>Notification sent:</TD>
          <TD>
            <xsl:choose>
              <xsl:when test="NOTIFICATION=1">
                Yes
              </xsl:when>
              <xsl:otherwise>
                No
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <TR>
          <TD>Status:</TD>
          <TD>
            <xsl:choose>
              <xsl:when test="STATUS=1">
                Accepted
              </xsl:when>
              <xsl:when test="STATUS=2">
                Allocated
              </xsl:when>
              <xsl:when test="STATUS=3">
                Returned
              </xsl:when>
              <xsl:otherwise>
                Unknown status (<xsl:value-of select="STATUS"/>)
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <TR>
          <TD>
            Comments:
          </TD>
          <TD>
            <xsl:value-of select="COMMENTS"/>
          </TD>
        </TR>
      </xsl:for-each>
    </TABLE>
  </xsl:template>

  <xsl:template match="EXTERNALLINK" mode="justlink">
    <a xsl:use-attribute-sets="mEXTERNALLINK_justlink">
      <xsl:variable name="uindex">
        <xsl:value-of select="@UINDEX"/>
      </xsl:variable>
      <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=$uindex]" mode="justattributes"/>
      <xsl:value-of select="TITLE"/>
    </a>
  </xsl:template>

  <xsl:template match="LINK" mode="justattributes">
    <xsl:call-template name="dolinkattributes"/>
  </xsl:template>

  <xsl:template name="skinfield">
    <!--<input type="text" name="skin"/>-->
  </xsl:template>

  <xsl:template match="GUESTBOOK">
    <xsl:variable name="rows">
      <xsl:choose>
        <xsl:when test="@ROWS">
          <xsl:value-of select="@ROWS"/>
        </xsl:when>
        <xsl:otherwise>6</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="cols">
      <xsl:choose>
        <xsl:when test="@COLS">
          <xsl:value-of select="@COLS"/>
        </xsl:when>
        <xsl:otherwise>70</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="button">
      <xsl:choose>
        <xsl:when test="@BUTTON">
          <xsl:value-of select="@BUTTON"/>
        </xsl:when>
        <xsl:otherwise>Submit</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <FORM METHOD="POST" action="{$root}AddThread">
      <xsl:choose>
        <xsl:when test="@INREPLYTO">
          <INPUT type="HIDDEN" name="inreplyto" value="{@INREPLYTO}"/>
        </xsl:when>
        <xsl:when test="@FORUM">
          <INPUT type="HIDDEN" name="forum" value="{@FORUM}"/>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="not(@FORUM) and not(@INREPLYTO)">
          <B>Warning! You haven't specified a forum or a post to reply to</B>
        </xsl:when>
        <xsl:otherwise>
          <INPUT NAME="subject" VALUE="{@SUBJECT}"/>
          <br/>
          <TEXTAREA WRAP="VIRTUAL" ROWS="{$rows}" COLS="{$cols}" NAME="body">
            <xsl:value-of select="."/>
          </TEXTAREA>
          <br/>
          <INPUT TYPE="SUBMIT" value="{$button}"/>
        </xsl:otherwise>
      </xsl:choose>
    </FORM>
  </xsl:template>

  <xsl:template match="GUESTBOOK[@FORUM=/H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID]">
  </xsl:template>

  <!--
<ITEM-LIST NAME="myfriends">
	<FIRSTITEM>Please pick my friends</FIRSTITEM>
	<ITEM H2G2="A12345">An article I like</ITEM>
</ITEM-LIST>

-->

  <xsl:template match="ITEM-LIST">
    <SCRIPT LANGUAGE="javaScript">
      <xsl:comment>
        var <xsl:value-of select="@NAME"/>newwin="0";
        function go<xsl:value-of select="@NAME"/>(<xsl:value-of select="@NAME"/>newwin){
        <xsl:value-of select="@NAME"/>number=document.<xsl:value-of select="@NAME"/>list.<xsl:value-of select="@NAME"/>.options[document.<xsl:value-of select="@NAME"/>list.<xsl:value-of select="@NAME"/>.selectedIndex].value;
        if(<xsl:value-of select="@NAME"/>number!='0'){
        if(<xsl:value-of select="@NAME"/>newwin=="1")
        window.open(<xsl:value-of select="@NAME"/>number)
        else window.location.href=<xsl:value-of select="@NAME"/>number;
        }
        }
        //
      </xsl:comment>
    </SCRIPT>
    <FORM NAME="{@NAME}list">
      <TABLE CELLSPACING="2" CELLPADDING="3">
        <xsl:if test="TITLE">
          <TR>
            <TD ALIGN="center">
              <xsl:value-of select="TITLE"/>
            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TD ALIGN="center">
            <SELECT NAME="{@NAME}">
              <xsl:attribute name="SIZE">
                <xsl:value-of select="@LENGTH"/>
              </xsl:attribute>
              <OPTION value="0">
                <xsl:choose>
                  <xsl:when test="FIRSTITEM">
                    <xsl:value-of select="FIRSTITEM"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$m_dropdownpleasechooseone"/>
                  </xsl:otherwise>
                </xsl:choose>
              </OPTION>
              <OPTION value="0">-----------------</OPTION>
              <xsl:for-each select="ITEM">
                <OPTION value="{@H2G2|@BIO|@HREF}">
                  <xsl:value-of select="."/>
                </OPTION>
              </xsl:for-each>
            </SELECT>&nbsp;
            <xsl:choose>
              <xsl:when test="@TYPE='command'">
                &nbsp;In:
              </xsl:when>
              <xsl:when test="@TYPE='new'">
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{@NAME}(1)"/>
              </xsl:when>
              <xsl:when test="@TYPE='this'">
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{@NAME}(0)"/>
              </xsl:when>
              <xsl:otherwise>
                <INPUT TYPE="button" VALUE="{$m_govolunteer}" ONCLICK="go{@NAME}({@NAME}newwin)"/>
              </xsl:otherwise>
            </xsl:choose>
          </TD>
        </TR>
        <xsl:choose>
          <xsl:when test="@TYPE='command'">
            <TR>
              <TD ALIGN="left">
                <INPUT TYPE="button" VALUE="{$m_thiswindow}" ONCLICK="go{@NAME}(0)"/>
                &nbsp;<INPUT TYPE="button" VALUE="{$m_newwindow}" ONCLICK="go{@NAME}(1)"/>
              </TD>
            </TR>
          </xsl:when>
          <xsl:otherwise>
            <TR>
              <TD>
                <SMALL>
                  <INPUT NAME="win" TYPE="radio" VALUE="0" CHECKED="1" ONCLICK="{@NAME}newwin='0';"/>
                  <xsl:value-of select="$m_gadgetusethiswindow"/>
                  <INPUT NAME="win" TYPE="radio" VALUE="1" ONCLICK="{@NAME}newwin='1';"/>
                  <xsl:value-of select="$m_gadgetusenewwindow"/>
                </SMALL>
              </TD>
            </TR>
          </xsl:otherwise>
        </xsl:choose>
      </TABLE>
    </FORM>
  </xsl:template>

  <xsl:template name="SITECHANGE_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">You are now leaving us for pastures new</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SITECHANGE_MAINBODY">
    <xsl:call-template name="m_sitechangemessage"/>
  </xsl:template>

  <xsl:template name="COMING-UP_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_whatscomingupheader"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="COMING-UP_MAINBODY">
    <xsl:apply-templates select="RECOMMENDATIONS"/>
  </xsl:template>

  <xsl:template match="RECOMMENDATIONS">
    <xsl:call-template name="m_comingupintro"/>
    <xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 1 and GUIDESTATUS = 4]">
      <xsl:call-template name="HEADER">
        <xsl:with-param name="text">
          <xsl:value-of select="$m_cominguprecheader"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="m_cominguprecintro"/>
      <TABLE BORDER="0" CELLPADDING="2">
        <TR>
          <TD>
            <xsl:value-of select="$m_comingupid"/>
          </TD>
          <TD>
            <xsl:value-of select="$m_comingupsubject"/>
          </TD>
        </TR>
        <xsl:apply-templates select="RECOMMENDATION[ACCEPTEDSTATUS = 1 and GUIDESTATUS = 4]"/>
      </TABLE>
    </xsl:if>
    <xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 2 and GUIDESTATUS = 4]">
      <xsl:call-template name="HEADER">
        <xsl:with-param name="text">
          <xsl:value-of select="$m_comingupwitheditorheader"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="m_comingupwitheditorintro"/>
      <TABLE BORDER="0" CELLPADDING="2">
        <TR>
          <TD>
            <xsl:value-of select="$m_comingupid"/>
          </TD>
          <TD>
            <xsl:value-of select="$m_comingupsubject"/>
          </TD>
        </TR>
        <xsl:apply-templates select="RECOMMENDATION[ACCEPTEDSTATUS = 2 and GUIDESTATUS = 4]"/>
      </TABLE>
    </xsl:if>
    <xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 3 and (GUIDESTATUS = 6 or GUIDESTATUS = 13)]">
      <xsl:call-template name="HEADER">
        <xsl:with-param name="text">
          <xsl:value-of select="$m_comingupreturnheader"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="m_comingupreturnintro"/>
      <TABLE BORDER="0" CELLPADDING="2">
        <TR>
          <TD>
            <xsl:value-of select="$m_comingupid"/>
          </TD>
          <TD>
            <xsl:value-of select="$m_comingupsubject"/>
          </TD>
        </TR>
        <xsl:apply-templates select="RECOMMENDATION[ACCEPTEDSTATUS = 3 and (GUIDESTATUS = 6 or GUIDESTATUS = 13)]"/>
      </TABLE>
    </xsl:if>
  </xsl:template>

  <xsl:template match="RECOMMENDATION[ACCEPTEDSTATUS = 1]">
    <TR>
      <TD>
        A<xsl:value-of select="ORIGINAL/H2G2ID"/>
      </TD>
      <TD>
        <A href="{$root}A{ORIGINAL/H2G2ID}">
          <xsl:value-of select="SUBJECT"/>
        </A>
      </TD>
    </TR>
  </xsl:template>

  <xsl:template match="RECOMMENDATION[ACCEPTEDSTATUS = 2]">
    <TR>
      <TD>
        A<xsl:value-of select="ORIGINAL/H2G2ID"/>
      </TD>
      <TD>
        <A href="{$root}A{ORIGINAL/H2G2ID}">
          <xsl:value-of select="SUBJECT"/>
        </A>
      </TD>
    </TR>

  </xsl:template>

  <xsl:template match="RECOMMENDATION[ACCEPTEDSTATUS = 3]">
    <TR>
      <TD>
        A<xsl:value-of select="EDITED/H2G2ID"/>
      </TD>
      <TD>
        <A href="{$root}A{EDITED/H2G2ID}">
          <xsl:value-of select="SUBJECT"/>
        </A>
      </TD>
    </TR>

  </xsl:template>


  <xsl:template name="SUBMITREVIEWFORUM_HEADER">

    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_submitreviewforumheader"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="SUBMITREVIEWFORUM_SUBJECT">
    <xsl:choose>
      <xsl:when test="SUBMIT-REVIEW-FORUM/ERROR">
        <xsl:call-template name="ERROR_SUBJECT"/>
      </xsl:when>
      <xsl:when test="SUBMIT-REVIEW-FORUM/MOVEDTHREAD">
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_removefromreviewforumsubject"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="SUBMIT-REVIEW-FORUM/NEW-THREAD">
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_entrysubmittoreviewforumsubject"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_submitreviewforumsubject"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>

  <xsl:template name="SUBMITREVIEWFORUM_MAINBODY">
    <xsl:apply-templates select="SUBMIT-REVIEW-FORUM"/>
  </xsl:template>

  <xsl:template match="SUBMIT-REVIEW-FORUM">

    <xsl:choose>
      <xsl:when test="REVIEWFORUMS">
        <xsl:apply-templates select="REVIEWFORUMS"/>
      </xsl:when>
      <xsl:when test="NEW-THREAD">
        <xsl:apply-templates select="NEW-THREAD"/>
      </xsl:when>
      <xsl:when test="ERROR">
        <xsl:apply-templates select="ERROR"/>
      </xsl:when>
      <xsl:when test="MOVEDTHREAD">
        <xsl:apply-templates select="MOVEDTHREAD"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="SUBMIT-REVIEW-FORUM/MOVEDTHREAD">
    <xsl:call-template name="m_removefromreviewsuccesslink"/>
  </xsl:template>

  <xsl:template match="SUBMIT-REVIEW-FORUM/ERROR">
    <xsl:choose>
      <xsl:when test="@TYPE='CHANGE-THIS'">
      </xsl:when>
      <xsl:when test="@TYPE='BADH2G2ID'">
        <xsl:call-template name="DEFAULT_ERROR">
          <xsl:with-param name="Message">
            <xsl:value-of select="MESSAGE"/>
          </xsl:with-param>
          <xsl:with-param name="LinkBody">Frontpage</xsl:with-param>
          <xsl:with-param name="LinkHref">Frontpage</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@TYPE='BADRFID'">
        <xsl:call-template name="DEFAULT_ERROR">
          <xsl:with-param name="Message">
            <xsl:value-of select="MESSAGE"/>
          </xsl:with-param>
          <xsl:with-param name="LinkBody">Frontpage</xsl:with-param>
          <xsl:with-param name="LinkHref">Frontpage</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DEFAULT_ERROR"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="SUBMIT-REVIEW-FORUM/NEW-THREAD">
    <xsl:call-template name="m_entrysubmittedtoreviewforum"/>
  </xsl:template>

  <xsl:template match="SUBMIT-REVIEW-FORUM/REVIEWFORUMS">
    <p/>
    <p/>
    <xsl:apply-templates select="ERROR"/>
    <p/>
    <xsl:call-template name="m_submitarticlefirst_text"/>
    <form method="POST" action="{$root}SubmitReviewForum">
      <INPUT TYPE="HIDDEN" NAME="action" VALUE="submitarticle"/>
      <INPUT TYPE="HIDDEN" NAME="h2g2id" VALUE="{../ARTICLE/@H2G2ID}"/>
      <select name="reviewforumid">
        <option value="{$DefaultRFID}">
          <xsl:value-of select="$m_dropdownpleasechooseone"/>
        </option>
        <option value="{$DefaultRFID}">-----------------</option>
        <xsl:for-each select="FORUMNAME[.!='Collaborative Writing Workshop']">
          <xsl:sort select="."/>
          <option value="{@ID}">
            <xsl:if test="@SELECTED">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
          </option>
        </xsl:for-each>
      </select>
      <p/>
      <TEXTAREA NAME="response" COLS="40" ROWS="8">
        <xsl:value-of select="COMMENTS"/>
      </TEXTAREA>
      <p/>
      <input type="submit" value="{$m_submittoreviewforumbutton}" title="{$alt_submittoreviewforumbutton}"/>
    </form>

    <p/>

    <xsl:call-template name="m_submitarticlelast_text"/>
  </xsl:template>

  <xsl:template match="REVIEWFORUMS/ERROR">
    <span xsl:use-attribute-sets="xmlerrorfont">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <!--

	<xsl:template match="DEFAULT_ERROR">
	Author:		Dharmesh Raithatha
	Generic:	Yes
	Purpose:	Display an error message with a link

-->

  <xsl:template name="DEFAULT_ERROR">
    <xsl:param name="Message">
      <xsl:value-of select="MESSAGE"/>
    </xsl:param>
    <xsl:param name="LinkBody">
      <xsl:value-of select="LINK"/>
    </xsl:param>
    <xsl:param name="LinkHref">
      <xsl:value-of select="LINK/@HREF"/>
    </xsl:param>

    <!-- default style for all other error messages -->
    <blockquote>
      <span xsl:use-attribute-sets="xmlerrorfont">
        <B>
          <xsl:value-of select="$m_followingerror"/>
        </B>
        <xsl:value-of select="$Message"/>
      </span>
      <br/>
      <br/>
      <span class="subheaderfont">
        <B>Return To: </B>
        <A href="{$root}{$LinkHref}">
          <xsl:value-of select="$LinkBody"/>
        </A>
      </span>
      <br/>
    </blockquote>
  </xsl:template>

  <xsl:template match="SITEID" mode="showfrom">
    <xsl:variable name="thissiteid">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:value-of select="$m_fromsite"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/SHORTNAME"/>
  </xsl:template>

  <!--
	<xsl:template name="ONEYES">
	Author:		Igor Loboda
	Generic:	Yes
	Purpose:	transforms current value into YES or NO. 1 - Yes, otherwize - 0
-->
  <xsl:template name="ONEYES">
    <xsl:if test=".!='1'">
      <xsl:value-of select="$m_oneyes_no"/>
    </xsl:if>
    <xsl:if test=".='1'">
      <xsl:value-of select="$m_oneyes_yes"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="PREMODERATION">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	displays site premoderation flag
-->
  <xsl:template match="PREMODERATION">
    <xsl:value-of select="$m_premoderation"/>
    <xsl:text> </xsl:text>
    <xsl:call-template name="ONEYES"/>
  </xsl:template>

  <!--
	<xsl:template match="OFFSITELINKS">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	displays off-site links availability
-->
  <xsl:template match="OFFSITELINKS">
    <xsl:value-of select="$m_offsiteallowed"/>
    <xsl:text> </xsl:text>
    <xsl:call-template name="ONEYES"/>
  </xsl:template>

  <!--
	<xsl:template match="SITEID" mode="showfrom_mod_offsite">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	Displays site information:site name, premoderation status, 
				are off-site links allowed. The information is displayed 
				each piece on separate line.
-->
  <xsl:template match="SITEID" mode="showfrom_mod_offsite">
    <xsl:variable name="thissiteid">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:apply-templates select="." mode="showfrom"/>
    <br/>
    <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/PREMODERATION"/>
    <br/>
    <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/OFFSITELINKS"/>
  </xsl:template>

  <!--
	<xsl:template match="SITEID" mode="showfrom_mod_offsite">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	Displays site information:site name, premoderation status, 
				are off-site links allowed. The information is displayed all
				in one line.
-->
  <xsl:template match="SITEID" mode="showfrom_mod_offsite_line">
    <xsl:variable name="thissiteid">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:apply-templates select="." mode="showfrom"/>
    <xsl:text> -- </xsl:text>
    <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/PREMODERATION"/>
    <xsl:text> -- </xsl:text>
    <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/OFFSITELINKS"/>
  </xsl:template>

  <xsl:template match="SITEFILTER">
    <xsl:if test="SITE/@NAME=$sitename">
      <xsl:apply-templates select="CONTENTS"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="SITEFILTER[@EXCLUDE='1']">
    <xsl:if test="not(SITE/@NAME=$sitename)">
      <xsl:apply-templates select="CONTENTS"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="H2G2[@TYPE='ARTICLE' and PARAMS/PARAM[NAME='s_ssi']/VALUE='yes']">
    <xsl:apply-templates select="//COMMUNICATE-PROMO[(not(@FROM) or $curdate &gt; substring(concat(translate(@FROM,'-/,',''),'00000000000000'),1,14)) and (not(@TO) or $curdate &lt; substring(concat(translate(@TO,'-/,',''),'00000000000000'),1,14))]"/>
  </xsl:template>

  <xsl:template match="COMMUNICATE">
    <LINK href="communicate_files/bbci.css" type="text/css" rel="StyleSheet"/>
    <table border="0">
      <tr>
        <td vAlign="top" bgColor="#f9f7bc">
          <font size="1">current:</font><br/>
          [<xsl:value-of select="$curdate"/>]<br/>
          <xsl:apply-templates select="COMMUNICATE-PROMO[$curdate &gt; substring(concat(translate(@FROM,'-/,',''),'00000000000000'),1,14) and $curdate &lt; substring(concat(translate(@TO,'-/,',''),'00000000000000'),1,14)]"/>
          [editing]<br/>
          <xsl:for-each select="COMMUNICATE-PROMO">
            <xsl:variable name="fromnum" select="substring(concat(translate(@FROM,'-/,',''),'00000000000000'),1,14)"/>
            <xsl:variable name="tonum" select="substring(concat(translate(@TO,'-/,',''),'00000000000000'),1,14)"/>
            {<xsl:value-of select="concat($fromnum,':',$tonum)"/>}<br/>
            {<xsl:value-of select="$curdate &gt; $fromnum and $curdate &lt; $tonum"/>}
            {<xsl:value-of select="$curdate &gt; $fromnum"/>}
            {<xsl:value-of select="$curdate &lt; $tonum"/>}
            <font size="1">
              From <xsl:value-of select="@FROM"/><br/>to <xsl:value-of select="@TO"/>
            </font><br/>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="COMMUNICATE-PROMO">

    <table width="250" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td rowspan="2">
          <img src="communicate_files/tiny.gif" width="5" height="87" alt=""/>
        </td>
        <td colspan="2" valign="top">
          <img src="communicate_files/tiny.gif" width="245" height="3" alt=""/>
          <br/>
          <font size="2">
            <b>
              <a href="/dna/h2g2/">h2g2</a>
            </b>
            <br/>
          </font>
          <font size="1">
            The guide to <b>
              <a href="/dna/h2g2/C72">life</a>
            </b>, the <b>
              <a href="/dna/h2g2/C73">universe</a>
            </b> and <b>
              <a href="/dna/h2g2/C74">everything</a>
            </b> written by you.<br/>
          </font>
          <img src="communicate_files/tiny.gif" width="1" height="6" alt=""/>
          <br/>
        </td>
      </tr>
      <tr>
        <td valign="top">
          <img src="communicate_files/tiny.gif" width="55" height="1" alt=""/>
          <br/>
          <!-- image reference -->
          <a href="/dna/h2g2/">
            <img src="{@IMG}" width="48" height="44" alt="h2g2" hspace="0" vspace="0" border="0"/>
          </a>
          <br/>
        </td>
        <td valign="top">
          <img src="communicate_files/tiny.gif" width="190" height="1" alt=""/>
          <br/>
          <font size="2">
            <b>
              Today's new entries:
            </b>
            <img src="communicate_files/tiny.gif" width="1" height="6" alt=""/>
            <br/>

            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="ENTRY"/>
            </table>
            <font size="1">
              <img src="communicate_files/tiny.gif" width="1" height="6" alt=""/>
              <br/>
              <img src="communicate_files/bullet.gif" width="3" height="3" hspace="0" vspace="4" border="0" alt="" align="top"/>
              <img src="communicate_files/tiny.gif" width="5" height="1" alt="" border="0" align="top"/>
              <a href="/dna/h2g2/C0">Full list of entries</a>
              <br clear="all"/>
            </font>
          </font>
          <img src="communicate_files/tiny.gif" width="1" height="6" alt=""/>
          <br/>
        </td>
      </tr>
      <tr>
        <td bgcolor="#ffffff" colspan="3">
          <img src="communicate_files/tiny.gif" width="1" height="5" alt=""/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="COMMUNICATE-PROMO/ENTRY">
    <xsl:comment> start h2g2 link row </xsl:comment>
    <tr>
      <td valign="top" width="7">
        <img src="communicate_files/bullet.gif" width="3" height="3" alt="" hspace="0" vspace="6" border="0"/>
      </td>
      <td>
        <font size="1">
          <a HREF="/dna/h2g2/{@H2G2}">
            <xsl:apply-templates/>
          </a>
        </font>
      </td>
    </tr>
    <xsl:comment> End start h2g2 link row </xsl:comment>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLEINFO/SUBMITTABLE">
	Author:		Dharmesh Raithatha
	Generic:	Yes
	Purpose:	Generates the content for the Submittable type in Articleinfo 


-->

  <xsl:template match="ARTICLEINFO/SUBMITTABLE">
    <xsl:param name="delimiter">
      <BR/>
      <BR/>
    </xsl:param>

    <!-- If the article is hidden then don't display any of this -->
    <xsl:if test="not(../HIDDEN) and /H2G2/VIEWING-USER/USER">
      <xsl:copy-of select="$delimiter"/>
      <xsl:choose>

        <xsl:when test="@TYPE='YES'">
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>SubmitReviewForum?action=submitrequest&amp;h2g2id=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
            </xsl:attribute>
            <xsl:call-template name="m_submitforreviewbutton"/>
          </a>
        </xsl:when>

        <xsl:when test="@TYPE='NO'">
          <xsl:choose>
            <!-- Only show the button for editors-->
            <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
              <a>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>SubmitReviewForum?action=submitrequest&amp;h2g2id=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
                </xsl:attribute>
                <xsl:call-template name="m_submitforreviewbutton"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="m_notforreviewbutton"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="@TYPE='IN'">
          <xsl:call-template name="m_currentlyinreviewforum"/>
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>F<xsl:value-of select="FORUM/@ID"/>?thread=<xsl:value-of select="THREAD/@ID"/>
            </xsl:attribute>
            <xsl:call-template name="m_submittedtoreviewforumbutton"/>
          </a>
        </xsl:when>

      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ARTICLEINFO/RECOMMENDENTRY">
    <xsl:if test="not(../HIDDEN)">
      <xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='SCOUTS' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
        <xsl:call-template name="DISPLAY-RECOMMENDENTRY"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="DISPLAY-RECOMMENDENTRY">
    <a>
      <xsl:attribute name="HREF">
        javascript:popupwindow('<xsl:value-of select="$root"/>RecommendEntry?h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>&amp;mode=POPUP','RecommendEntry','resizable=1,scrollbars=1,width=375,height=300');
      </xsl:attribute>
      <xsl:call-template name="m_recommendentrybutton"/>
    </a>
  </xsl:template>

  <xsl:template name="REVIEWFORUM_SIDEBAR">
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          Review Forum Data<br/>
        </td>
      </tr>
      <tr>
        <td bgcolor="{$horizdividers}">
          <img src="{$imagesource}blank.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          Name: <xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
        </td>
      </tr>
      <tr>
        <td>
          URL: <xsl:value-of select="REVIEWFORUM/URLFRIENDLYNAME"/>
        </td>
      </tr>
      <xsl:choose>
        <xsl:when test="REVIEWFORUM/RECOMMENDABLE=1">
          <tr>
            <td>Recommendable:Yes</td>
          </tr>
          <tr>
            <td>
              Incubate period: <xsl:value-of select="REVIEWFORUM/INCUBATETIME"/> days
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <tr>
            <td>Recommendable:No</td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
        <tr>
          <td>
            <xsl:value-of select="$m_reviewforumdata_h2g2id"/>
            <A>
              <xsl:attribute name="HREF">
                A<xsl:value-of select="REVIEWFORUM/H2G2ID"/>
              </xsl:attribute>A<xsl:value-of select="REVIEWFORUM/H2G2ID"/>
            </A>
          </td>
        </tr>
        <tr>
          <td>
            <a>
              <xsl:attribute name="HREF">
                <xsl:value-of select="$root"/>EditReview?id=<xsl:value-of select="REVIEWFORUM/@ID"/>
              </xsl:attribute>
              <xsl:value-of select="$m_reviewforumdata_edit"/>
            </a>
          </td>
        </tr>
      </xsl:if>
    </table>
    <br/>
    <br/>
    <br/>
  </xsl:template>

  <xsl:template name="REVIEWFORUM_MAINBODY">
    <xsl:choose>
      <xsl:when test="REVIEWFORUM/REVIEWFORUMTHREADS">
        <DIV>
          <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
        </DIV>
        <xsl:if test=".//FOOTNOTE">
          <div class="footnote">
            <hr/>
            <xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
          </div>
        </xsl:if>
        <xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS"/>
      </xsl:when>
      <xsl:when test="REVIEWFORUM/ERROR">
        <xsl:call-template name="DEFAULT_ERROR">
          <xsl:with-param name="Message" select="REVIEWFORUM/ERROR/MESSAGE"/>
          <xsl:with-param name="LinkBody" select="REVIEWFORUM/ERROR/LINK"/>
          <xsl:with-param name="LinkHref" select="REVIEWFORUM/ERROR/LINK/@HREF"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="REVIEWFORUM_SUBJECT">
    <xsl:choose>
      <xsl:when test="REVIEWFORUM/ERROR">
        <xsl:call-template name="ERROR_SUBJECT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="SUBJECTHEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>

  <xsl:template name="REVIEWFORUM_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!--

	<xsl:template match="REVIEWFORUM/REVIEWFORUMTHREADS">

	Generic:	No
	Purpose:	Display the threads associated with a forum

-->

  <xsl:template match="REVIEWFORUM/REVIEWFORUMTHREADS">

    <xsl:variable name="var_orderby">
      <xsl:choose>
        <xsl:when test="@ORDERBY=1">dateentered</xsl:when>
        <xsl:when test="@ORDERBY=2">lastposted</xsl:when>
        <xsl:when test="@ORDERBY=3">authorid</xsl:when>
        <xsl:when test="@ORDERBY=4">authorname</xsl:when>
        <xsl:when test="@ORDERBY=5">entry</xsl:when>
        <xsl:when test="@ORDERBY=6">subject</xsl:when>
        <xsl:otherwise>dateentered</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="op_dir">
      <xsl:choose>
        <xsl:when test="@DIR=1">0</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="/H2G2/NOGUIDE">
      <xsl:call-template name="threadnavbuttons">
        <xsl:with-param name="URL">RF</xsl:with-param>
        <xsl:with-param name="ID" select="../@ID"/>
        <xsl:with-param name="ExtraParameters">
          ?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/>
        </xsl:with-param>
        <xsl:with-param name="showconvs">
          <xsl:value-of select="$alt_rf_showconvs"/>
        </xsl:with-param>
        <xsl:with-param name="shownewest">
          <xsl:value-of select="$alt_rf_shownewest"/>
        </xsl:with-param>
        <xsl:with-param name="alreadynewestconv">
          <xsl:value-of select="$alt_rf_alreadynewestconv"/>
        </xsl:with-param>
        <xsl:with-param name="nonewconvs">
          <xsl:value-of select="$alt_rf_nonewconvs"/>
        </xsl:with-param>
        <xsl:with-param name="showoldestconv">
          <xsl:value-of select="$alt_rf_showoldestconv"/>
        </xsl:with-param>
        <xsl:with-param name="noolderconv">
          <xsl:value-of select="$alt_rf_noolderconv"/>
        </xsl:with-param>
        <xsl:with-param name="showingoldest">
          <xsl:value-of select="$alt_rf_showingoldest"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="forumpostblocks">
        <xsl:with-param name="forum"/>
        <xsl:with-param name="skip" select="0"/>
        <xsl:with-param name="show" select="@COUNT"/>
        <xsl:with-param name="total" select="@TOTALTHREADS"/>
        <xsl:with-param name="this" select="@SKIPTO"/>
        <xsl:with-param name="url">
          RF<xsl:value-of select="../@ID"/>?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/>
        </xsl:with-param>
        <xsl:with-param name="objectname" select="'Entries'"/>
        <xsl:with-param name="target"/>
      </xsl:call-template>
    </xsl:if>

    <a>
      <xsl:attribute name="id">
        <xsl:value-of select="$m_reviewforum_entrytarget"/>
      </xsl:attribute>
    </a>
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_rft_articlesinreviewheader"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:choose>

      <xsl:when test="THREAD">
        <br clear="all"/>

        <table width="100%">
          <tr>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=5">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selecth2g2id"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_h2g2id"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=6">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selectsubject"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_subject"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=1">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selectdateentered"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_dateentered"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=2">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selectlastposted"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_lastposted"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=4">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selectauthor"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_author"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
            <th align="left">
              <span xsl:use-attribute-sets="reviewforumlistheader">
                <xsl:choose>
                  <xsl:when test="@ORDERBY=3">
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_selectauthorid"/>
                    </A>
                  </xsl:when>
                  <xsl:otherwise>
                    <A>
                      <xsl:attribute name="HREF">
                        <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/>
                      </xsl:attribute>
                      <xsl:call-template name="m_rft_authorid"/>
                    </A>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </th>
          </tr>

          <xsl:choose>
            <xsl:when test="THREAD">
              <xsl:for-each select="THREAD">
                <tr>

                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
                        </xsl:attribute>
                        A<xsl:value-of select="H2G2ID"/>
                      </A>
                    </span>
                  </td>

                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
                        </xsl:attribute>
                        <xsl:call-template name="TRUNCATE">
                          <xsl:with-param name="longtext">
                            <xsl:apply-templates mode="nosubject" select="SUBJECT"/>
                          </xsl:with-param>
                          <xsl:with-param name="maxlength">58</xsl:with-param>
                        </xsl:call-template>
                      </A>
                    </span>
                  </td>

                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>
                        </xsl:attribute>
                        <xsl:value-of select="DATEENTERED/DATE/@RELATIVE"/>
                      </A>
                    </span>
                  </td>

                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          <xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;latest=1
                        </xsl:attribute>
                        <xsl:apply-templates select="DATEPOSTED"/>
                      </A>
                    </span>
                  </td>

                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          <xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/>
                      </A>
                    </span>
                  </td>
                  <td>
                    <span xsl:use-attribute-sets="reviewforumlistentry">
                      <A>
                        <xsl:attribute name="HREF">
                          <xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/>
                        </xsl:attribute>
                        U<xsl:value-of select="AUTHOR/USER/USERID"/>
                      </A>
                    </span>
                  </td>
                  <xsl:choose>
                    <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
                      <td>
                        <span xsl:use-attribute-sets="reviewforumlistentry">
                          <A>
                            <xsl:attribute name="HREF">
                              <xsl:value-of select="$root"/>SubmitReviewForum?action=removethread&amp;rfid=<xsl:value-of select="../../@ID"/>&amp;h2g2id=<xsl:value-of select="H2G2ID"/>
                            </xsl:attribute>
                            <xsl:attribute name="onclick">return window.confirm('Remove entry from Review Forum?');</xsl:attribute>
                            <xsl:call-template name="m_removefromreviewforum"/>
                          </A>
                        </span>
                      </td>
                    </xsl:when>
                  </xsl:choose>
                </tr>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
        </table>
        <br/>
        <xsl:if test="not(/H2G2/NOGUIDE)">
          <xsl:if test="@MORE=1">
            <br/>
            <center>
              <A>
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?entry=0&amp;skip=0&amp;show=25&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/>
                </xsl:attribute>
                <xsl:value-of select="$m_clickmorereviewentries"/>
              </A>
              <br/>
            </center>
          </xsl:if>
        </xsl:if>

      </xsl:when>

      <xsl:otherwise>
        <p/>
        <b>
          <xsl:value-of select="$m_rftnoarticlesinreviewforum"/>
        </b>
        <p/>
      </xsl:otherwise>
    </xsl:choose>
    <center>
      <xsl:call-template name="subscribearticleforum">
        <xsl:with-param name="ForumID" select="@FORUMID"/>
        <xsl:with-param name="ID" select="../@ID"/>
        <xsl:with-param name="URL">RF</xsl:with-param>
        <xsl:with-param name="Desc" select="$alt_returntoreviewforum"/>
        <xsl:with-param name="Notify" select="$m_notifynewentriesinreviewforum"/>
        <xsl:with-param name="DeNotify">
          <xsl:value-of select="$m_stopnotifynewentriesreviewforum"/>
        </xsl:with-param>
      </xsl:call-template>
    </center>
  </xsl:template>

  <xsl:template name="KEYARTICLE-EDITOR_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">Named Articles</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="KEYARTICLE-EDITOR_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>Named Articles
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="KEYARTICLE-EDITOR_MAINBODY">
    <xsl:apply-templates select="KEYARTICLEFORM"/>
    <br/>
    <xsl:apply-templates select="KEYARTICLELIST"/>
  </xsl:template>

  <xsl:template match="KEYARTICLELIST">
    <form method="post" action="{$root}NamedArticles">
      These are the current named articles for your site:<br/>
      <xsl:apply-templates select="ARTICLE"/>
      <input type="submit" name="remove" value="Remove checked articles"/>
    </form>
  </xsl:template>

  <xsl:template match="KEYARTICLELIST/ARTICLE">
    <input type="checkbox" name="removename" value="{NAME}"/><a href="{$root}{NAME}">
      <xsl:value-of select="NAME"/>
    </a> (<a href="{$root}UserEdit{H2G2ID}">edit</a>)<br/>
  </xsl:template>

  <xsl:template match="KEYARTICLEFORM">
    <xsl:apply-templates select="ERROR"/>
    <xsl:apply-templates select="SUCCESS"/>
    Add a new named article.
    <form method="POST" action="{$root}NamedArticles">
      Article Name <input type="text" name="name" value="{NAME}"/><br/>
      h2g2 ID <input type="text" name="h2g2id" value="{H2G2ID}"/> Allow articles from another site <input type="checkbox" name="allowothersites" value="1"/><br/>
      Date active <input type="text" name="date" value="{DATE}"/> <span class="smallfont">(leave blank to start immediately)</span><br/>
      <input type="submit" name="setarticle" value="Set Article"/>
    </form><br/>
    Note: Article names can only contain letters, numbers and the '-' sign.
  </xsl:template>

  <xsl:template match="KEYARTICLEFORM/ERROR">
    <span class="warningmessagefont">
      <b>
        Error: <xsl:value-of select="."/>
      </b>
    </span>
    <br/>
  </xsl:template>

  <xsl:template match="KEYARTICLEFORM/SUCCESS">
    The key article has been successfully created.<br/>
  </xsl:template>

  <xsl:template name="TOPFIVE-EDITOR_MAINBODY">
    <xsl:apply-templates select="TOP-FIVE-LISTS"/>
    <form method="POST" action="{$root}TopFiveEditor">
      List name: <INPUT TYPE="text" name="editgroup" value="{TOP-FIVE-EDIT/@NAME}"/>
      <input type="submit" name="fetch" value="Fetch list"/><br/>
      Description: <input type="text" name="description" value="{TOP-FIVE-EDIT/DESCRIPTION}"/><br/>
      <input type="radio" name="type" value="article">
        <xsl:if test="TOP-FIVE-EDIT[@TYPE='ARTICLE']">
          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
        </xsl:if>
      </input> Articles
      <input type="radio" name="type" value="forum">
        <xsl:if test="TOP-FIVE-EDIT[@TYPE='FORUM']">
          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
        </xsl:if>
      </input> Forums
      <br/>
      The second field is the thread ID - leave blank to link to a whole forum or linking to articles<br/>
      <xsl:apply-templates select="TOP-FIVE-EDIT/FORUM|TOP-FIVE-EDIT/H2G2"/>
      <input type="text" name="id" value=""/>
      (<input type="text" name="threadid" value=""/>)<br/>
      <input type="text" name="id" value=""/>
      (<input type="text" name="threadid" value=""/>)<br/>
      <input type="text" name="id" value=""/>
      (<input type="text" name="threadid" value=""/>)<br/>
      <input type="text" name="id" value=""/>
      (<input type="text" name="threadid" value=""/>)<br/>
      <input type="text" name="id" value=""/>
      (<input type="text" name="threadid" value=""/>)<br/>
      (To add more than five new entries, add the first five and press the Update Group button to add the next five)<br/>
      <!--
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">1</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">2</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">3</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">4</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">5</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">6</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">7</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">8</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">9</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">10</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">11</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">12</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">13</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">14</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">15</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">16</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">17</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">18</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">19</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="topfivefields">
<xsl:with-param name="index">20</xsl:with-param>
</xsl:call-template>
-->
      <!--
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 1]|TOP-FIVE-EDIT/H2G2ID[position() = 1]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 1]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 2]|TOP-FIVE-EDIT/H2G2ID[position() = 2]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 2]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 3]|TOP-FIVE-EDIT/H2G2ID[position() = 3]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 3]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 4]|TOP-FIVE-EDIT/H2G2ID[position() = 4]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 4]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 5]|TOP-FIVE-EDIT/H2G2ID[position() = 5]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 5]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 6]|TOP-FIVE-EDIT/H2G2ID[position() = 6]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 6]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 7]|TOP-FIVE-EDIT/H2G2ID[position() = 7]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 7]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 8]|TOP-FIVE-EDIT/H2G2ID[position() = 8]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 8]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 9]|TOP-FIVE-EDIT/H2G2ID[position() = 9]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 9]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 10]|TOP-FIVE-EDIT/H2G2ID[position() = 10]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 10]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 11]|TOP-FIVE-EDIT/H2G2ID[position() = 11]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 11]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 12]|TOP-FIVE-EDIT/H2G2ID[position() = 12]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 12]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = 13]|TOP-FIVE-EDIT/H2G2ID[position() = 13]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 13]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 14]|TOP-FIVE-EDIT/H2G2ID[position() = 14]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 14]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 15]|TOP-FIVE-EDIT/H2G2ID[position() = 15]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 15]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 16]|TOP-FIVE-EDIT/H2G2ID[position() = 16]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 16]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 17]|TOP-FIVE-EDIT/H2G2ID[position() = 17]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 17]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 18]|TOP-FIVE-EDIT/H2G2ID[position() = 18]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 18]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 19]|TOP-FIVE-EDIT/H2G2ID[position() = 19]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 19]/@THREAD}"/>)<br/>
<input type="text" name="id" value="{TOP-FIVE-EDIT/FORUMID[position() = 20]|TOP-FIVE-EDIT/H2G2ID[position() = 20]}"/>
(<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUMID[position() = 20]/@THREAD}"/>)<br/>
-->
      <input type="submit" name="update" value="Update group"/>
    </form>
    <xsl:apply-templates select="TOP-FIVES"/>
  </xsl:template>

  <xsl:template match="TOP-FIVE-EDIT/FORUM">
    <input type="text" name="id" value="{@FORUMID}"/>
    (<input type="text" name="threadid" value="{@THREAD}"/>) <xsl:value-of select="."/><br/>
  </xsl:template>

  <xsl:template match="TOP-FIVE-EDIT/H2G2">
    <input type="text" name="id" value="{@H2G2ID}"/>
    (<input type="text" name="threadid" value=""/>) <xsl:value-of select="."/><br/>
  </xsl:template>

  <xsl:template name="topfivefields">
    <xsl:param name="index"/>
    <input type="text" name="id" value="{TOP-FIVE-EDIT/FORUM[position() = $index]/@FORUMID|TOP-FIVE-EDIT/H2G2[position() = $index]/@H2G2ID}"/>
    (<input type="text" name="threadid" value="{TOP-FIVE-EDIT/FORUM[position() = $index]/@THREAD}"/>) <xsl:value-of select="TOP-FIVE-EDIT/FORUM[position() = $index]|TOP-FIVE-EDIT/H2G2[position() = $index]"/><br/>
  </xsl:template>

  <xsl:template match="TOP-FIVE-LISTS">
    Here are your current lists (not all of these will be editable)<br/>
    <xsl:for-each select="LIST">
      <a href="{$root}TopFiveEditor?editgroup={GROUPNAME}&amp;type={TYPE}&amp;fetch=1">
        <xsl:value-of select="GROUPNAME"/>
      </a>
      <br/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="SITEADMIN-EDITOR_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        DNA Site Admin for <xsl:value-of select="SITEADMIN/URLNAME"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="SITEADMIN-EDITOR_MAINBODY">
    <xsl:if test="$superuser = 1">
      <xsl:for-each select="SITE-LIST/SITE">
        <xsl:sort select="@ID" order="ascending" data-type="number"/>
        [ <a href="/dna/{NAME}/SiteAdmin">
          <xsl:value-of select="SHORTNAME"/>
        </a> ]
      </xsl:for-each>
      <br/>
    </xsl:if>
    <xsl:apply-templates select="SITEADMIN"/>
  </xsl:template>

  <xsl:template match="SITEADMIN">
    <b>
      <xsl:value-of select="ERROR"/>
    </b>
    <xsl:apply-templates select="CREATERESULT"/>
    <xsl:apply-templates select="UPLOADRESULT"/>
    <form method="post" action="SiteAdmin">
      <table>
        <tr>
          <td align="right">URL: </td>
          <td>
            <xsl:value-of select="URLNAME"/>
          </td>
        </tr>
        <tr>
          <td align="right">Short name:</td>
          <td>
            <input type="text" name="shortname" value="{SHORTNAME}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Description:</td>
          <td>
            <input type="text" name="description" value="{DESCRIPTION}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Default skin:</td>
          <td>
            <input type="text" name="defaultskin" value="{DEFAULTSKIN}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Moderators email:</td>
          <td>
            <input type="text" name="ModeratorsEmail" value="{MODERATORSEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Editors email:</td>
          <td>
            <input type="text" name="EditorsEmail" value="{EDITORSEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Feedback email:</td>
          <td>
            <input type="text" name="FeedbackEmail" value="{FEEDBACKEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Auto Message User ID</td>
          <td>
            <input type="text" name="AutoMessageUserID" value="{AUTOMESSAGEUSERID}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Premoderation:</td>
          <td>
            <input type="radio" name="premoderation" value="1">
              <xsl:apply-templates select="PREMODERATION" mode="checkedattribute"/>
            </input> Yes
            <input type="radio" name="premoderation" value="0">
              <xsl:apply-templates select="PREMODERATION" mode="notcheckedattribute"/>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Prevent cross-linking:</td>
          <td>
            <input type="radio" name="crosslink" value="1">
              <xsl:apply-templates select="NOCROSSLINKING" mode="checkedattribute"/>
            </input> Yes
            <input type="radio" name="crosslink" value="0">
              <xsl:apply-templates select="NOCROSSLINKING" mode="notcheckedattribute"/>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Custom terms:</td>
          <td>
            <input type="radio" name="customterms" value="1">
              <xsl:apply-templates select="CUSTOMTERMS" mode="checkedattribute"/>
            </input> Yes
            <input type="radio" name="customterms" value="0">
              <xsl:apply-templates select="CUSTOMTERMS" mode="notcheckedattribute"/>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Require Password:</td>
          <td>
            <input type="radio" name="passworded" value="1">
              <xsl:apply-templates select="PASSWORDED" mode="checkedattribute"/>
            </input> Yes
            <input type="radio" name="passworded" value="0">
              <xsl:apply-templates select="PASSWORDED" mode="notcheckedattribute"/>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Unmoderated:</td>
          <td>
            <input type="radio" name="unmoderated" value="1">
              <xsl:apply-templates select="UNMODERATED" mode="checkedattribute"/>
            </input> Yes
            <input type="radio" name="unmoderated" value="0">
              <xsl:apply-templates select="UNMODERATED" mode="notcheckedattribute"/>
            </input> No
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <input type="submit" name="update" value="Change settings"/>
          </td>
        </tr>
      </table>
    </form>
    <hr/>
    Edit skin details:<br/>
    <table>
      <xsl:for-each select="SKINS/SKIN">
        <tr>
          <td>
            <form method="get" action="SiteAdmin">
              <xsl:value-of select="NAME"/>: <input type="text" name="skindescription" value="{DESCRIPTION}"/><input type="hidden" name="skinname" value="{NAME}"/><br/>
              Use frames: <input type="radio" name="useframes" value="1">
                <xsl:apply-templates select="USEFRAMES" mode="checkedattribute"/>
              </input> Yes
              <input type="radio" name="useframes" value="0">
                <xsl:apply-templates select="USEFRAMES" mode="notcheckedattribute"/>
              </input> No<br/>
              <input type="submit" name="renameskin" value="Change details"/>
            </form>
          </td>
        </tr>
      </xsl:for-each>
    </table>
    <hr/>
    <b>Upload skins</b>
    <form enctype="multipart/form-data" action="SiteAdmin" method="post">
      File to upload: <input align="center" type="file" name="file" size="60" maxlength="255"/><br/>
      Skin Name: <input type="text" name="skinname"/>
      <xsl:if test="$superuser = 1">
        <input type="checkbox" name="create" value="1" selected="selected"/> Create New Skin<br/>
        Description: <input type="text" name="description"/>
        Use frames: <input type="radio" name="useframes" value="1"/> Yes <input type="radio" name="useframes" value="0" checked="checked"/> No<br/>
      </xsl:if>
      <br/>
      Leafname: <input type="text" name="leafname" value="HTMLOutput.xsl"/><br/>
      <!--Skin: <input type="text" name="skin"/><br/>-->
      <INPUT type="submit" name="uploadskin" value="upload it"/>
    </form>

    <xsl:if test="$superuser = 1">
      <hr/>
      <B>Create new site</B>
      <form enctype="multipart/form-data" method="post" action="SiteAdmin">
        <table>
          <tr>
            <td>URL Name: </td>
            <td>
              <input type="text" name="urlname"/>
            </td>
          </tr>
          <tr>
            <td>Short Name: </td>
            <td>
              <input type="text" name="shortname"/>
            </td>
          </tr>
          <tr>
            <td>Description: </td>
            <td>
              <input type="text" name="description"/>
            </td>
          </tr>
          <tr>
            <td>Default Skin: </td>
            <td>
              <input type="text" name="defaultskin"/>
            </td>
          </tr>
          <tr>
            <td>Skin description: </td>
            <td>
              <input type="text" name="skindescription"/>
            </td>
          </tr>
          <tr>
            <td>File to upload: </td>
            <td>
              <input align="center" type="file" name="file" size="60" maxlength="255"/>
            </td>
          </tr>
          <tr>
            <td>Leafname: </td>
            <td>
              <input type="text" name="leafname" value="HTMLOutput.xsl"/>
            </td>
          </tr>
          <tr>
            <td>Use frames: </td>
            <td>
              <input type="radio" name="useframes" value="1"/> Yes <input type="radio" name="useframes" value="0" checked="checked"/> No
            </td>
          </tr>
          <tr>
            <td>Moderators email:</td>
            <td>
              <input type="text" name="ModeratorsEmail"/>
            </td>
          </tr>
          <tr>
            <td>Editors email:</td>
            <td>
              <input type="text" name="EditorsEmail"/>
            </td>
          </tr>
          <tr>
            <td>Feedback email:</td>
            <td>
              <input type="text" name="FeedbackEmail"/>
            </td>
          </tr>
          <tr>
            <td>Auto Message User ID</td>
            <td>
              <input type="text" name="AutoMessageUserID" value="294"/>
            </td>
          </tr>
          <tr>
            <td>Premoderation: </td>
            <td>
              <input type="radio" name="premoderation" value="1"/> Yes
              <input type="radio" name="premoderation" value="0" checked="checked"/> No
            </td>
          </tr>
          <tr>
            <td>Prevent cross-linking: </td>
            <td>
              <input type="radio" name="crosslink" value="1"/> Yes
              <input type="radio" name="crosslink" value="0" checked="checked"/> No
            </td>
          </tr>
          <tr>
            <td>Custom terms: </td>
            <td>
              <input type="radio" name="customterms" value="1"/> Yes
              <input type="radio" name="customterms" value="0" checked="checked"/> No
            </td>
          </tr>
          <tr>
            <td>Require Password: </td>
            <td>
              <input type="radio" name="passworded" value="1" checked="checked"/> Yes
              <input type="radio" name="passworded" value="0"/> No
            </td>
          </tr>
          <tr>
            <td>Unmoderated: </td>
            <td>
              <input type="radio" name="unmoderated" value="1"/> Yes
              <input type="radio" name="unmoderated" value="0" checked="checked"/> No
            </td>
          </tr>
          <tr>
            <td/>
            <td>
              <input type="submit" name="newsite" value="Create Site"/>
            </td>
          </tr>
        </table>
      </form>
    </xsl:if>

  </xsl:template>

  <xsl:template match="*|@*" mode="checkedattribute">
    <xsl:if test=".=1">
      <xsl:attribute name="checked">checked</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*|@*" mode="notcheckedattribute">
    <xsl:if test=".=0">
      <xsl:attribute name="checked">checked</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="UPLOADRESULT">
    <xsl:choose>
      <xsl:when test="SAVED">
        Your stylesheet change has been uploaded successfully<br/>
      </xsl:when>
      <xsl:when test="UPLOADERROR">
        There was a problem uploading your stylesheet<br/>
      </xsl:when>
      <xsl:when test="NOSUCHSKIN">
        The skin name you chose does not exist in this site.<br/>
      </xsl:when>
      <xsl:when test="NOTALLOWED">
        You are not allowed to upload core elements<br/>
      </xsl:when>
      <xsl:when test="COPYERROR">
        Unable to copy the stylesheet. Try again or clear the templates.<br/>
      </xsl:when>
      <xsl:when test="PARSE-ERROR[@TYPE='runtime']">
        Your stylesheet contains runtime errors. Make sure you haven't mistyped a variable name or template name.<br/>
      </xsl:when>
      <xsl:when test="PARSE-ERROR[@TYPE='parse']">
        Your stylesheet is badly formed. An error was found on line <xsl:value-of select="PARSE-ERROR/LINE"/> at character <xsl:value-of select="PARSE-ERROR/CHARACTER"/><br/>
        Error: <xsl:value-of select="PARSE-ERROR/REASON"/>
        <PRE>
          <xsl:value-of select="PARSE-ERROR/SRCTEXT"/>
        </PRE><br/>
      </xsl:when>
      <xsl:otherwise>
        An unknown error occurred while uploading your stylesheet.<br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="CREATERESULT">
    <xsl:choose>
      <xsl:when test="@RESULT='SUCCESS'">
        Site created. <a href="/dna/{@URLNAME}/SiteAdmin">Click here to administer.</a><br/>
      </xsl:when>
      <xsl:otherwise>
        Failed to create new site - URL already exists<br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="FRONTPAGE-EDIT-FORM">
    <form method="post" action="EditFrontpage">
      <textarea cols="70" rows="20" wrap="virtual" name="bodytext">
        <xsl:value-of select="BODY"/>
      </textarea>
      <br/>
      Skin: <input type="text" name="skin" value="{SKIN}"/>
      Date Active: <input type="text" name="date" value="{DATE}"/>
      <input type="checkbox" name="registered" value="1">
        <xsl:if test="REGISTERED=1">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input> Registered
      <input type="submit" name="preview" value="Preview"/>
      <input type="submit" name="storepage" value="Store page"/>
    </form>
  </xsl:template>

  <xsl:template match="REALMEDIA">

    <xsl:choose>
      <xsl:when test="false">
        <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="192">
          <TR>
            <TD WIDTH="192" VALIGN="TOP" ALIGN="CENTER" COLSPAN="2">
              This
              clip should play automatically after a few minutes.
            </TD>
          </TR>
          <TR>
            <TD WIDTH="192" VALIGN="TOP" ALIGN="CENTER" COLSPAN="2">&nbsp;</TD>
          </TR>
          <TR>
            <TD WIDTH="192" VALIGN="TOP" ALIGN="CENTER" BGCOLOR="#000000" COLSPAN="2">
              <object id="REALVIDEO" classid="CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA" align="baseline" width="192" height="144" border="0">
                <!-- RAM FILE -->
                <param name="SRC" value="{$realmediadir}{@SRC}"/>
                <!-- END RAM FILE -->
                <param name="CONTROLS" value="imagewindow"/>
                <param name="CONSOLE" value="console"/>
                <param name="AUTOSTART" value="TRUE"/>
                <param name="NOLABELS" value="FALSE"/>
                <!-- EMBEDDED RAM FILE -->
                <embed src="{$realmediadir}{@SRC}" align="BASELINE" border="0" width="192" height="144" controls="imagewindow" console="console" name="REALVIDEO" autostart="TRUE" type="audio/x-pn-realaudio-plugin" nojava="TRUE">
                </embed>
                <!-- END EMBEDDED RAM FILE -->
              </object>
              <BR CLEAR="ALL"/>
            </TD>
          </TR>
          <TR>
            <TD ALIGN="MIDDLE" COLSPAN="2">
              <!-- EMBEDDED PLAYER CONTROLS -->
              <OBJECT ID="REALVIDEO" CLASSID="CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA" ALIGN="baseline" WIDTH="192" HEIGHT="36" BORDER="0">
                <PARAM NAME="SRC" VALUE="{$realmediadir}{@SRC}"/>
                <PARAM NAME="CONTROLS" VALUE="ControlPanel"/>
                <PARAM NAME="CONSOLE" VALUE="console"/>
                <EMBED SRC="{$realmediadir}{@SRC}" WIDTH="192" HEIGHT="36" NOJAVA="TRUE" CONTROLS="CONTROLPANEL" CONSOLE="console" TYPE="audio/x-pn-realaudio-plugin">
                </EMBED>
              </OBJECT>
              <BR CLEAR="ALL"/>
              <!-- END EMBEDDED PLAYER CONTROLS -->
            </TD>
          </TR>
          <TR>
            <TD HEIGHT="5" colspan="2" ALIGN="CENTER">&nbsp;</TD>
          </TR>
          <TR>
            <TD HEIGHT="25" WIDTH="96" ALIGN="CENTER">
              <A HREF="{$realmediadir}{@SRC}">
                <FONT SIZE="-2">
                  Non-embedded
                  player
                </FONT>
              </A>
            </TD>
            <TD HEIGHT="25" WIDTH="96" ALIGN="CENTER">
              <A href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro">
                <FONT SIZE="-2">
                  Download
                  RealPlayer
                </FONT>
              </A>
            </TD>
          </TR>
        </TABLE>
      </xsl:when>
      <xsl:otherwise>
        <P>
          This clip should play automatically after a few seconds. If not <a href="{$realmediadir}{@SRC}">
            click
            here
          </a>.
        </P>
        <OBJECT ID="video" CLASSID="CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA" ALIGN="baseline" WIDTH="192" HEIGHT="144" BORDER="0">
          <!-- RAM FILE -->
          <PARAM NAME="SRC" VALUE="{$realmediadir}{@SRC}"/>
          <!-- END RAM FILE -->
          <PARAM NAME="CONTROLS" VALUE="IMAGEWINDOW"/>
          <PARAM NAME="CONSOLE" VALUE="CONSOLE"/>
          <PARAM NAME="AUTOSTART" VALUE="TRUE"/>
          <PARAM NAME="NOLABELS" VALUE="0"/>
          <!-- EMBEDDED RAM FILE -->
          <EMBED SRC="{$realmediadir}{@SRC}" ALIGN="BASELINE" BORDER="0" WIDTH="192" HEIGHT="144" CONTROLS="IMAGEWINDOW" CONSOLE="CONSOLE" NAME="REALVIDEO" AUTOSTART="TRUE" TYPE="audio/x-pn-realaudio-plugin" NOJAVA="TRUE">
          </EMBED>
        </OBJECT>
        <BR CLEAR="ALL"/>
        <!-- END EMBEDDED RAM FILE -->
        <!-- EMBEDDED PLAYER CONTROLS -->
        <OBJECT ID="REALVIDEO" CLASSID="CLSID:CFCDAA03-8BE4-11CF-B84B-0020AFBBCCFA" ALIGN="baseline" WIDTH="192" HEIGHT="36" BORDER="0">
          <PARAM NAME="SRC" VALUE="{$realmediadir}{@SRC}"/>
          <PARAM NAME="CONTROLS" VALUE="CONTROLPANEL"/>
          <PARAM NAME="CONSOLE" VALUE="CONSOLE"/>
          <EMBED SRC="{$realmediadir}{@SRC}" WIDTH="190" HEIGHT="36" NOJAVA="TRUE" CONTROLS="CONTROLPANEL" CONSOLE="CONSOLE" TYPE="audio/x-pn-realaudio-plugin">
          </EMBED>
        </OBJECT>
        <!-- END EMBEDDED PLAYER CONTROLS -->
        <P>
          If you are having problems playing the clip you may need to download RealPlayer.
          For help with this, check the <a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro">
            Webwise
            guide to RealMedia.
          </a>
        </P>
        <BR CLEAR="ALL"/>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="FRONTPAGE-PREVIEW-PARSEERROR">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="FRONTPAGE_EDITOR">
    <xsl:apply-templates select="FRONTPAGE-PREVIEW-PARSEERROR"/>
    <xsl:apply-templates select="FRONTPAGE-EDIT-FORM"/>
  </xsl:template>

  <xsl:template match="POSTPREMODERATED">
    <xsl:call-template name="m_posthasbeenpremoderated"/>
  </xsl:template>

  <xsl:template match="POSTQUEUED">
    Thank you for posting. Your Posting has been put in a queue and will appear on the site shortly. If you
    just started a new Conversation, it will only appear on your Personal Space
    after it has been posted. In particularly busy times, it can take a few minutes for posts to appear.<BR/>
    <xsl:choose>
      <xsl:when test="@NEWCONVERSATION=1">
        <A href="{$root}F{@FORUM}">
          Click here to
          return to the Conversation list
        </A>
      </xsl:when>
      <xsl:otherwise>
        <A href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}#p{@POST}">
          Click here to
          return to the Conversation
        </A>
      </xsl:otherwise>
    </xsl:choose>
    <BR/><BR/>
  </xsl:template>
  <xsl:template name="SIMPLEPAGE_SUBJECT">
    <xsl:choose>
      <xsl:when test="/H2G2/ARTICLE/GUIDE">
        <xsl:call-template name="ARTICLE_SUBJECT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="ARTICLE/USERACTION" mode="subject"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="SIMPLEPAGE_MAINBODY">
    <xsl:choose>
      <xsl:when test="/H2G2/ARTICLE/GUIDE">
        <xsl:call-template name="ARTICLE_MAINBODY"/>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <xsl:apply-templates select="ARTICLE/USERACTION"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="USERACTION">

    <xsl:choose>
      <xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=1">
        <xsl:call-template name="m_nameremovedfromresearchers"/>
      </xsl:when>
      <xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=0">
        <xsl:call-template name="m_namenotremovedfromresearchers"/>
      </xsl:when>
      <xsl:when test="@TYPE='DELETEGUIDEENTRY' and @REASON='nopermission' and @RESULT=0">
        <xsl:value-of select="$m_nopermissiontodeleteentry"/>
      </xsl:when>
      <xsl:when test="@TYPE='DELETEGUIDEENTRY' and @REASON='dberror' and @RESULT=0">
        <xsl:value-of select="$m_dberrordeleteentry"/>
      </xsl:when>
      <xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=1">
        <xsl:call-template name="m_guideentrydeleted"/>
      </xsl:when>
      <xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=1">
        <xsl:call-template name="m_guideentryrestored"/>
      </xsl:when>

      <xsl:when test="@TYPE='EDITENTRY' and @REASON='nopermission' and @RESULT=0">
        <xsl:call-template name="m_nopermissiontoedit"/>
      </xsl:when>
      <xsl:when test="@TYPE='UNRECOGNISEDCOMMAND' and @RESULT=1">
        <xsl:call-template name="m_unrecognisedcommand"/>
      </xsl:when>
      <xsl:when test="@TYPE='UNSPECIFIEDERROR' and @RESULT=1">
        <xsl:call-template name="m_unspecifiederror"/>
      </xsl:when>
      <xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=0 and @REASON='dberror'">
        <xsl:value-of select="$m_dberrorguideundelete"/>
      </xsl:when>

      <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='homepage'">
        <xsl:value-of select="$m_homepageerrorstatuschange"/>
      </xsl:when>

      <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='notentry'">
        <xsl:value-of select="$m_notentryerrorstatuschange"/>
      </xsl:when>

      <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='general'">
        <xsl:value-of select="$m_generalerrorstatuschange"/>
      </xsl:when>

      <xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='noarticle'">
        <xsl:value-of select="$m_noarticleerrorresearcherchange"/>
      </xsl:when>

      <xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='general'">
        <xsl:value-of select="$m_generalerrorresearcherchange"/>
      </xsl:when>

      <xsl:when test="@TYPE='ARTICLEINREVIEW' and @RESULT=0 and @REASON='initialise'">
        <xsl:value-of select="$m_initialiseerrorarticleinreview"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="USERACTION" mode="subject">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:choose>
          <xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=1">
            <xsl:value-of select="$m_removenamesubjsuccess"/>
          </xsl:when>

          <xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=0">
            <xsl:value-of select="$m_removenamesubjfailure"/>
          </xsl:when>
          <xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=0">
            <xsl:value-of select="$m_entrynotdeletedsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=1">
            <xsl:value-of select="$m_guideentrydeletedsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=1">
            <xsl:value-of select="$m_guideentryrestoredsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='EDITENTRY' and @REASON='nopermission' and @RESULT=0">
            <xsl:value-of select="$m_editpermissiondenied"/>
          </xsl:when>
          <xsl:when test="@TYPE='UNRECOGNISEDCOMMAND' and @RESULT=1">
            <xsl:value-of select="$m_unrecognisedcommandsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='UNSPECIFIEDERROR' and @RESULT=1">
            <xsl:value-of select="$m_unspecifiederrorsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=0 and @REASON='dberror'">
            <xsl:value-of select="$m_dberrorsubj"/>
          </xsl:when>
          <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='homepage'">
            <xsl:value-of select="$m_homepageerrorstatuschangesubj"/>
          </xsl:when>

          <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='notentry'">
            <xsl:value-of select="$m_notentryerrorstatuschangesubj"/>
          </xsl:when>

          <xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='general'">
            <xsl:value-of select="$m_generalerrorstatuschangesubj"/>
          </xsl:when>

          <xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='noarticle'">
            <xsl:value-of select="$m_noarticleerrorresearcherchangesubj"/>
          </xsl:when>

          <xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='general'">
            <xsl:value-of select="$m_generalerrorresearcherchangesubj"/>
          </xsl:when>

          <xsl:when test="@TYPE='ARTICLEINREVIEW' and @RESULT=0 and @REASON='initialise'">
            <xsl:value-of select="$m_initialiseerrorarticleinreviewsubj"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../SUBJECT"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="TRUNCATE">
    <xsl:param name="longtext"/>
    <xsl:param name="maxlength">20</xsl:param>
    <xsl:variable name="shortlength" select="$maxlength - 3"/>
    <xsl:choose>
      <xsl:when test="string-length($longtext) &gt; $maxlength">
        <xsl:value-of select="substring($longtext, 1, $shortlength)"/>...
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$longtext"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- 
Description: Base
-->

  <xsl:template name="CRUMBTRAIL_BASE">
    <xsl:param name="crumbtrail_divider">
      <br/>
    </xsl:param>
    <xsl:for-each select="ANCESTOR">
      <a>
        <xsl:attribute name="href">
          C<xsl:value-of select="NODEID"/>
        </xsl:attribute>
        <xsl:call-template name="TRUNCATE">
          <xsl:with-param name="longtext">
            <xsl:value-of select="NAME"/>
          </xsl:with-param>
        </xsl:call-template>
      </a>
      <xsl:copy-of select="$crumbtrail_divider"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="CRUMBTRAILS">
    <xsl:apply-templates select="CRUMBTRAIL/ANCESTOR[TREELEVEL = 0 and not(number(preceding::ANCESTOR/NODEID) = NODEID)]"/>
    <xsl:for-each select="CRUMBTRAIL">
      <ul>
        <xsl:for-each select="ANCESTOR">
          <li>
            <a href="{$root}C{NODEID}">
              <xsl:value-of select="NAME"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="CRUMBTRAIL/ANCESTOR">
    <xsl:param name="depth">0</xsl:param>
    <xsl:value-of select="TREELEVEL"/>(<xsl:value-of select="$depth"/>):<xsl:value-of select="NAME"/><br/>
    <xsl:variable name="thislevel">
      <xsl:value-of select="TREELEVEL"/>
    </xsl:variable>
    <xsl:variable name="thisnode">
      <xsl:value-of select="NODEID"/>
    </xsl:variable>
    Scanning set:<br/>
    <xsl:copy-of select="../../CRUMBTRAIL/ANCESTOR[preceding-sibling::ANCESTOR/NODEID = $thisnode and TREELEVEL = ($thislevel + 1) and not(preceding::ANCESTOR[NODEID=self::NODEID])]"/>
    <xsl:for-each select="../../CRUMBTRAIL/ANCESTOR[preceding-sibling::ANCESTOR/NODEID = $thisnode and TREELEVEL = ($thislevel + 1) and not(preceding::ANCESTOR/NODEID[.=NODEID])]">
      -<xsl:value-of select="concat(NODEID,' ',NAME,'(',TREELEVEL,')')"/><br/>
    </xsl:for-each>
    <hr/>
    <xsl:for-each select="../../CRUMBTRAIL/ANCESTOR[preceding-sibling::ANCESTOR/NODEID = $thisnode and not(number(preceding::ANCESTOR/NODEID) = NODEID)]">
      -<xsl:value-of select="concat(NODEID,' ',NAME,'(',TREELEVEL,')')"/><br/>
    </xsl:for-each>
    <hr/>
    <xsl:apply-templates select="../../CRUMBTRAIL/ANCESTOR[preceding-sibling::ANCESTOR/NODEID = $thisnode and TREELEVEL = ($thislevel + 1) and not(number(preceding::ANCESTOR/NODEID) = NODEID)]">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depth + 1"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='MOREPOSTS' and PARAMS/PARAM[NAME='s_type']/VALUE='pop']">
    <xsl:call-template name="popupconversations2"/>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='MOREPOSTS' and PARAMS/PARAM[NAME='s_type']/VALUE='ticker']">
    <HTML>
      <HEAD>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <style type="text/css">
          a:link,a:visited {text-decoration: none}
          a:hover {text-decoration: underline; color: #0000FF}
        </style>
        <TITLE>Newest TiVo Topics</TITLE>

        <script language="javascript1.2">
          <xsl:comment>
            //
            var ticker;
            var tParent;
            var offline;
            var tMove = 1;
            var tOn = 1;
            var tImage;
            var tSpeed = 1;
            var tPaused = 0;

            var reloadTime = 300;
            var timer;

            var onImg = new Image();
            onImg.src = "http://www.tivocommunity.com/tivo-vb/images/on.gif"
            var offImg = new Image();
            offImg.src = "http://www.tivocommunity.com/tivo-vb/images/off.gif"
            var pauseImg = new Image();
            pauseImg.src = "http://www.tivocommunity.com/tivo-vb/images/tpause.gif";
            var playImg = new Image();
            playImg.src = "http://www.tivocommunity.com/tivo-vb/images/tplay.gif";

            function getCookie(name){
            var cname = name + "=";
            var dc = document.cookie;
            if (dc.length &gt; 0) {
            begin = dc.indexOf(cname);
            if (begin != -1) {
            begin += cname.length;
            end = dc.indexOf(";", begin);
            if (end == -1) end = dc.length;
            return unescape(dc.substring(begin, end));
            }
            }
            return null;
            }

            function setCookie(name, value, expires, path, domain, secure) {
            document.cookie = name + "=" + escape(value) +
            ((expires == null) ? "" : "; expires=" + expires.toGMTString()) +
            ((path == null) ? "" : "; path=" + path) +
            ((domain == null) ? "" : "; domain=" + domain) +
            ((secure == null) ? "" : "; secure");
            }

            function linkClick(){
            setCookie('reloads', '1', null, null, null, null);
            tickerOut();
            }

            function fastScrollOn(sdir){
            if (sdir == "up")
            tSpeed = 10;
            else if (sdir == "down")
            tSpeed = -10;
            }

            function fastScrollOff(){
            tSpeed = 1;
            }

            function pausePlay(){
            if (tOn){
            if (tPaused){
            tMove = 1;
            tPaused = 0;
            tPauseImg.src = pauseImg.src;
            if (document.all)
            tPauseImg.alt = "Click To Pause Ticker";
            else if (document.getElementById)
            tImage.setAttribute("alt", "Click To Pause Ticker");
            }
            else{
            tMove = 0;
            tPaused = 1;
            tPauseImg.src = playImg.src;
            if (document.all)
            tPauseImg.alt = "Click To Play Ticker";
            else if (document.getElementById)
            tImage.setAttribute("alt", "Click To Play Ticker");
            }
            }
            }


            function init() {
            if (document.layers){
            tImage = document.bglayer.document.images["timage"];
            tPauseImg = document.bglayer.document.images["tpauseimg"];
            ticker = document.tickerholder.document.threadticker;
            ticker.onmouseover=tickerOver;
            ticker.onmouseout=tickerOut;

            tParent = document.tickerholder;
            tParent.onmouseover=tickerOver;
            tParent.onmouseout=tickerOut;

            offline = document.tickerholder.document.offline;
            setInterval("moveTickerNS()", 100);
            }
            else if (document.all){
            tImage = document.all["timage"];
            tImage.alt = "Click To Stop Ticker";
            tPauseImg = document.all["tpauseimg"];
            tPauseImg.alt = "Click To Pause Ticker";
            ticker = document.all["threadticker"]
            ticker.onmouseover=tickerOver;
            ticker.onmouseout=tickerOut;

            tParent = document.all["tickerholder"];
            tParent.onmouseover=tickerOver;
            tParent.onmouseout=tickerOut;

            offline = document.all["offline"];
            setInterval("moveTickerIE()", 100);
            }
            else if (document.getElementById){
            tImage = document.getElementById("timage");
            tImage.setAttribute("alt", "Click To Stop Ticker");
            tPauseImg = document.getElementById("tpauseimg");
            tPauseImg.setAttribute("alt", "Click To Pause Ticker");
            ticker = document.getElementById("threadticker");
            ticker.onmouseover=tickerOver;
            ticker.onmouseout=tickerOut;

            tParent = document.getElementById("tickerholder");
            tParent.onmouseover=tickerOver;
            tParent.onmouseout=tickerOut;

            offline = document.getElementById("offline");
            setInterval("moveTickerDOM()", 100);
            }
            if (getCookie('reloads')){
            var rNum = parseInt(getCookie('reloads'));
            if (rNum &lt;= 5){
            timer = setInterval("countDown()", 1000);
            rNum += 1;
            setCookie('reloads', rNum, null, null, null, null);
            }
            else {
            toggelState();
            reloadTime = 0;
            }
            }
            else{
            timer = setInterval("countDown()", 1000);
            setCookie('reloads', '1', null, null, null, null);
            }
            }

            function countDown(){
            if (reloadTime &gt;= 1)
            reloadTime -= 1;
            else if (tMove)
            location.reload();
            else
            clearInterval(timer);
            }

            function moveTickerNS(){
            if (tMove){
            if ((ticker.top &gt; -(ticker.clip.height)) &amp;&amp; (ticker.top &amp;= 68))
            ticker.top -= tSpeed;
            else
            ticker.top = ticker.parentLayer.clip.height;

            }
            }

            function moveTickerIE(){
            if (tMove){
            if ((ticker.offsetTop &gt; -(ticker.offsetHeight)) &amp;&amp; (ticker.offsetTop &amp;= 68))
            ticker.style.top = (ticker.offsetTop-tSpeed);
            else
            ticker.style.top = ticker.parentElement.offsetHeight;

            }
            }

            function moveTickerDOM(){
            if (tMove){
            if ((ticker.offsetTop &gt; -(ticker.offsetHeight)) &amp;&amp; (ticker.offsetTop &amp;= 68))
            ticker.style.top = parseInt(ticker.style.top)-tSpeed+"px";
            else
            ticker.style.top = ticker.parentNode.offsetHeight+"px";

            }
            }

            function tickerOver(){
            tMove = 0;
            }

            function tickerOut(){
            if (!tPaused){
            tMove = 1;
            if (reloadTime == 0 &amp;&amp; tOn == 1)
            location.reload();
            }
            }

            function toggelState(){
            if (tOn){
            tOn = 0;
            tMove = 0;
            tImage.src = offImg.src;
            tPaused = 1;
            tPauseImg.src = pauseImg.src;
            if (document.all){
            tImage.alt = "Click To Start Ticker";
            tPauseImg.alt = "Click To Pause Ticker";
            }
            else if (document.getElementById){
            tImage.setAttribute("alt", "Click To Start Ticker");
            tPauseImg.setAttribute("alt", "Click To Pause Ticker");
            }

            if (document.all || document.getElementById){
            ticker.style.visibility = "hidden";
            offline.style.visibility = "visible";
            }
            else if (document.layers){
            ticker.visibility = "hide";
            offline.visibility = "show";
            }
            }
            else{
            setCookie('reloads', '0', null, null, null, null);
            if (reloadTime == 0)
            location.reload();
            tOn = 1;
            tMove = 1;
            tImage.src = onImg.src;
            tPaused = 0;
            tPauseImg.src = pauseImg.src;
            if (document.all)
            tImage.alt = "Click To Stop Ticker";
            else if (document.getElementById)
            tImage.setAttribute("alt", "Click To Stop Ticker");
            if (document.all || document.getElementById){
            ticker.style.top = "68px";
            ticker.style.visibility = "visible";
            offline.style.visibility = "hidden";
            }
            else if (document.layers){
            ticker.top = 68;
            ticker.visibility = "show";
            offline.visibility = "hide";
            }
            }
            if (document.all)
            window.focus();
            }
            //
          </xsl:comment>
        </script>
        <script language="javascript">
          function thread(ttitle, tpostuserid, tpostusername, tforumid, treplycount, tthreadid, tlastposter, tstartdate, tstarttime, tlastdate, tlasttime, tforumname){
          this.title=ttitle;
          this.postuserid=tpostuserid;
          this.postusername=tpostusername;
          this.forumid=tforumid;
          this.startpostdate=tstartdate;
          this.startposttime=tstarttime;
          this.lastpostdate=tlastdate;
          this.lastposttime=tlasttime;
          this.replycount=treplycount;
          this.threadid=tthreadid;
          this.forumname=tforumname;
          this.lastposter=tlastposter;
          }

          var threads=new Array(25);
          threads[1] = new thread("The increasing mystery of the missing directivo","10860","minorthr","3","5","61766","tornado","Today","08:59 PM","Today","09:49 PM","TiVo Coffee House - TiVo Chat");
          threads[2] = new thread("DSR6000 hanging and CC service agreement","7449","Quantu5","7","9","61669","Kemas","Today","01:44 PM","Today","09:49 PM","DIRECTV Receiver with TiVo");
          threads[3] = new thread("Next Generation PVR","16124","cwingert","8","3","61769","MighTiVo","Today","09:21 PM","Today","09:48 PM","TiVo Underground");
          threads[4] = new thread("What About India and Pakistan?","12194","Karyk","5","57","61114","Guyy","05-31-2002","08:27 PM","Today","09:47 PM","Happy Hour - General Chit-Chat");
          threads[5] = new thread("TiVo's light died","258","cwoody222","4","2","61626","cwoody222","Today","03:09 AM","Today","09:47 PM","TiVo Help Center");
          threads[6] = new thread("Best Buy Shinanigans","703","Speeden71","3","20","61631","Scutter","Today","04:34 AM","Today","09:47 PM","TiVo Coffee House - TiVo Chat");
          threads[7] = new thread("Need down payment/equity/pmi/car payoff advice","6003","johnmoorejohn","5","38","61295","jsmeeker","06-02-2002","04:06 AM","Today","09:47 PM","Happy Hour - General Chit-Chat");
          threads[8] = new thread("Women in the Workforce: Part cause for the increase in housing cost?","778","Squeak","5","4","61772","Darin","Today","09:30 PM","Today","09:45 PM","Happy Hour - General Chit-Chat");
          threads[9] = new thread("I want my clock back!! VOTE!","601","John494900","3","51","57144","kvandivo","05-04-2002","07:06 AM","Today","09:45 PM","TiVo Coffee House - TiVo Chat");
          threads[10] = new thread("So who here doesn't like Enterprise (spoilers)","21615","TDSLB","5","61","60937","bigray327","05-30-2002","09:14 PM","Today","09:45 PM","Happy Hour - General Chit-Chat");
          threads[11] = new thread("Video Game Channel "G4"","17172","Toeside","7","25","55845","Kemas","04-25-2002","07:31 PM","Today","09:45 PM","DIRECTV Receiver with TiVo");
          threads[12] = new thread("Give me a push","7746","jwestoby","14","24","45772","johnh","02-15-2002","09:44 AM","Today","09:44 PM","TiVo UK");
          threads[13] = new thread("Cordless Phone Recommendations?","11662","Satchel","5","8","61750","Dusty68","Today","07:40 PM","Today","09:43 PM","Happy Hour - General Chit-Chat");
          threads[14] = new thread("Can I Output To PC?","24469","chrisplettuce","14","2","61771","cyril","Today","09:27 PM","Today","09:43 PM","TiVo UK");
          threads[15] = new thread("Enhanced Content/TiVo Central Promotions - Going Forward","22926","TiVoPony","14","194","60934","GarySargent","05-30-2002","09:13 PM","Today","09:43 PM","TiVo UK");
          threads[16] = new thread("Can't Get TIVO Service Back","24456","peek","4","2","61748","phone1","Today","07:35 PM","Today","09:43 PM","TiVo Help Center");
          threads[17] = new thread(""The Wire"... worth keeping SP?","4896","jradosh","31","1","61773","ClutchBrake","Today","09:34 PM","Today","09:42 PM","Now Playing - TV Show Talk");
          threads[18] = new thread("Anybody catch Crank Yankers?","11631","harvscar","31","5","61680","KRS","Today","02:32 PM","Today","09:42 PM","Now Playing - TV Show Talk");
          threads[19] = new thread("Lifetime subs and Upgrades","24156","andys","14","8","61491","cyril","Yesterday","03:39 PM","Today","09:40 PM","TiVo UK");
          threads[20] = new thread("Hughes Warranty, month 5 begins","20174","floyd","7","0","61774","floyd","Today","09:40 PM","Today","09:40 PM","DIRECTV Receiver with TiVo");
          threads[21] = new thread("Tivo, Best Buy, telemarketers, the FTC, and $500 in your pocket.","24294","Belmont","3","175","61389","Uther","06-02-2002","10:21 PM","Today","09:38 PM","TiVo Coffee House - TiVo Chat");
          threads[22] = new thread("Will you watch Six Feet Under next year?","5799","ClutchBrake","31","19","61441","KRS","Yesterday","04:31 AM","Today","09:37 PM","Now Playing - TV Show Talk");
          threads[23] = new thread("Tivo in violation of service agreement","24373","gekea","7","10","61590","Kemas","Yesterday","09:53 PM","Today","09:37 PM","DIRECTV Receiver with TiVo");
          threads[24] = new thread("WitchBlade 2 Movie on WB?","529","andyf","31","6","60890","DanT","05-30-2002","04:42 PM","Today","09:37 PM","Now Playing - TV Show Talk");
          threads[25] = new thread("Best Program on TV","918","MikeCG","31","54","61432","DanT","Yesterday","03:28 AM","Today","09:35 PM","Now Playing - TV Show Talk");

        </script>
      </HEAD>
      <body BGCOLOR="#FFFFFF" TEXT="#000066" LINK="#000099" VLINK="#000066" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="init()">
        <div style="position:absolute; top:3px; left:3px; z-index:0;" id="bglayer">
          <table border="0" cellpadding="0" cellspacing="0" width="428" height="94">
            <tr>
              <td valign="top" rowspan="2" bgcolor="#ffffff">
                <a href="#" onClick="toggelState()">
                  <img src="http://www.tivocommunity.com/tivo-vb/images/on.gif" width="25" height="31" border="0" alt="Click To Start/Stop Ticker" id="timage" name="timage"/>
                </a>
                <br/>
                <img src="http://www.tivocommunity.com/tivo-vb/images/space.gif" width="1" height="4" border="0"/>
                <br/>
                <a href="#" onMouseDown="fastScrollOn('down')" onMouseUp="fastScrollOff()">
                  <img src="http://www.tivocommunity.com/tivo-vb/images/tup.gif" width="25" height="20" border="0" id="tupimg" name="tupimg" alt="Hold to scroll down"/>
                </a>
                <br/>
                <a href="#" onClick="pausePlay()">
                  <img src="http://www.tivocommunity.com/tivo-vb/images/tpause.gif" width="25" height="20" border="0" id="tpauseimg" name="tpauseimg" alt="Click To Pause/Play Ticker"/>
                </a>
                <br/>
                <a href="#" onMouseDown="fastScrollOn('up')" onMouseUp="fastScrollOff()">
                  <img src="http://www.tivocommunity.com/tivo-vb/images/tdown.gif" width="25" height="20" border="0" id="tdownimg" name="tdownimg" alt="Hold to scroll up"/>
                </a>
              </td>
              <td valign="middle" bgcolor="#ff9900" width="403" height="23">
                &nbsp;<font size="1" face="Verdana, Arial, sans-serif, Helvetica, Times" color="#000000">
                  <b>
                    Latest
                    topics on <a href="http://www.tivocommunity.com/tivo-vb" target="_NEWWINDOW">TiVo Community Forum</a>
                  </b>
                </font>
              </td>
              <td bgcolor="#ff9900">
                <img src="http://www.tivocommunity.com/tivo-vb/images/space.gif" width="1" height="23" border="0"/>
              </td>
            </tr>
            <tr>
              <td bgcolor="#ff9900" width="403" height="68" colspan="2">
                <table border="0" cellpadding="0" cellspacing="2" width="403" height="68">
                  <tr>
                    <td bgcolor="#ffffff">
                      <img src="http://www.tivocommunity.com/tivo-vb/images/space.gif" width="399" height="68"/>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </div>

        <div id="tickerholder" style="position:absolute; left:30px; top:28px; height:68px; width:399px; clip:rect(0px,399px,68px,0px); background:white; z-index:100;">
          <script language="javascript1.2">
            <!--
if (document.layers){
  tickerholder.document.write("<style type=\"text/css\">");
  tickerholder.document.write("a\:link\, a\:visited \{text\-decoration\: none\}");
  tickerholder.document.write("</style>");
}
//-->
          </script>

          <div id="threadticker" style="position:absolute; top:68px; z-index:300;">
            <script language="javascript1.2">
              <!--
document.write("<table border=\"0\" cellpadding=\"5\" cellspacing=\"0\" width=\"399\" bgcolor=\"#ffffff\">");
var tbgcolor = "";
for (i=1; i<=25; i++){
  if ((i % 2) == 0){
    tbgcolor = "ffffff";
  } else {
    tbgcolor = "ffffcc";
  }
  document.write("<tr><td bgcolor=\"#" + tbgcolor + "\"><font size=1 face=\"Verdana, Arial, sans-serif, Helvetica, Times\"><a href=\"http://www.tivocommunity.com/tivo-vb/showthread.php?s=&amp;threadid=" + threads[i].threadid + "\" target=_NEWWINDOW onClick=\"linkClick()\"><b>" + threads[i].title + "</b><br><i>(" + threads[i].forumname + ")</i></a></font></td><td bgcolor=\"#" + tbgcolor + "\"><font size=1 face=\"Verdana, Arial, sans-serif, Helvetica, Times\">" + threads[i].lastposter + "</font></td><td bgcolor=\"#" + tbgcolor + "\"><font size=1 face=\"Verdana, Arial, sans-serif, Helvetica, Times\">" + threads[i].replycount + "</font></td></tr>");
}
document.write("</table>");
//-->
            </script>
          </div>
          <div id="offline" style="position:absolute; visibility:hidden; height:68px; width:399px; background:white; z-index:200;">
            <table border="0" cellpadding="0" cellspacing="0" width="399" height="68">
              <tr>
                <td valign="middle" align="center">
                  <font size="1" face="Verdana, Arial, sans-serif, Helvetica, Times">
                    <b>Ticker off.</b> Click image to reactivate.
                  </font>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </body>
    </HTML>
  </xsl:template>



  <xsl:template match="@ONCLICK|@ONMOUSEOVER|@ONMOUSEDOWN|@ONMOUSEOUT|@ONCONTEXTMENU|@ONDBLCLICK|@ONBLUR|@ONFOCUS|@ONSCROLL|@ONMOUSEUP|@ONMOUSEENTER|@ONMOUSELEAVE|@ONMOUSEMOVE|@ONSELECTSTART">
  </xsl:template>

  <xsl:template name="navbar">
    <div class="navbar">
      <xsl:choose>
        <xsl:when test="PAGEUI/REGISTER[@VISIBLE=1]">
          <a target="_top">
            <xsl:attribute name="href">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$pageui_register"/>
            </xsl:attribute>
            <xsl:value-of select="$alt_register"/>
          </a>
          <br/>
          <a target="_top" href="{$root}">
            <xsl:value-of select="$alt_frontpage"/>
          </a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          <a target="_top" href="{$root}">
            <xsl:value-of select="$alt_frontpage"/>
          </a>
          <br/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="PAGEUI/MYHOME[@VISIBLE=1]">
        <a target="_top">
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>
            <xsl:value-of select="$pageui_myhome"/>
          </xsl:attribute>
          <xsl:value-of select="$alt_myspace"/>
        </a>
        <br/>
        <a target="_h2g2conv" onClick="popupwindow('{$root}MP{VIEWING-USER/USER/USERID}?s_type=pop','Conversations','scrollbars=1,resizable=1,width=140,height=400');return false;" href="{$root}MP{VIEWING-USER/USER/USERID}">
          My Conversations
        </a>
        <br/>
      </xsl:if>
      <a target="_top" href="{$root}Read">
        <xsl:value-of select="$alt_read"/>
      </a>
      <br/>
      <a target="_top" href="{$root}Talk">
        <xsl:value-of select="$alt_talk"/>
      </a>
      <br/>
      <a target="_top" href="{$root}Contribute">
        <xsl:value-of select="$alt_contribute"/>
      </a>
      <br/>
      <xsl:if test="PAGEUI/DONTPANIC[@VISIBLE=1]">
        <a target="_top">
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>
            <xsl:value-of select="$pageui_dontpanic"/>
          </xsl:attribute>
          <xsl:value-of select="$alt_help"/>
        </a>
        <br/>
      </xsl:if>
      <a target="_top" href="{$root}Feedback">
        <xsl:value-of select="$alt_feedbackforum"/>
      </a>
      <br/>
      <a href="javascript:popusers('{$root}online');">
        <xsl:value-of select="$alt_whosonline"/>
      </a>
      <br/>
      <xsl:if test="PAGEUI/MYDETAILS[@VISIBLE=1]">
        <a target="_top">
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>
            <xsl:value-of select="$pageui_mydetails"/>
          </xsl:attribute>
          <xsl:value-of select="$alt_preferences"/>
        </a>
        <br/>
      </xsl:if>
      <xsl:if test="PAGEUI/LOGOUT[@VISIBLE=1]">
        <a target="_top">
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>
            <xsl:value-of select="$pageui_logout"/>
          </xsl:attribute>
          <xsl:value-of select="$alt_logout"/>
        </a>
        <br/>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="NOTFOUND_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_notfoundsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="NOTFOUND_MAINBODY">
    <xsl:call-template name="m_notfoundbody"/>
  </xsl:template>

  <xsl:template match="POPUPCONVERSATIONS">
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
    <xsl:if test="$userid &gt; 0">

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
      <a xsl:use-attribute-sets="mPOPUPCONVERSATIONS" onClick="popupwindow('{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={@UPTO}&amp;s_target={$target}','{$poptarget}','width={$width},height={$height},resizable=yes,scrollbars=yes')" href="{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={@UPTO}&amp;s_target={$target}" target="{$poptarget}">
        <xsl:value-of select="."/>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="H2G2[@TYPE='THREADS' and PARAMS/PARAM[NAME='s_type']/VALUE='ssi']">
    <DIV>
      <xsl:call-template name="THREADS_MAINBODY"/>
    </DIV>
  </xsl:template>


  <xsl:template match="H2G2[@TYPE='MODERATION-BILLING']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 Moderation: Billing</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
        <script language="JavaScript">
          <![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

// stop hiding -->
				]]>
        </script>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <!--				<h2 align="center">General Moderation</h2>-->
          <H2>DNA Moderation Billing</H2>
          <span class="modbillinglinks">
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-1</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-2</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-3</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-4</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-5</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-6</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-7</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-8</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-9</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-10</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-11</xsl:with-param>
            </xsl:call-template>
            |
            <xsl:call-template name="createmodbillmonthlink">
              <xsl:with-param name="offset">-12</xsl:with-param>
            </xsl:call-template>
          </span>
          <br/>
          <a href="{$root}Moderate">Moderation home page</a>
          <form method="get" action="{$root}ModerationBilling">

            From: <input type="text" name="startdate"/>
            To: <input type="text" name="enddate"/>
            <input type="checkbox" name="recalc" value="1"/> Force recalculation
            <input type="submit" name="process" value="Get Stats For Date"/>
          </form>
          <xsl:apply-templates select="/H2G2/MODERATION-BILLING"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:variable name="modthreadcolour">#000000</xsl:variable>
  <xsl:variable name="modarticlecolour">#FF0000</xsl:variable>
  <xsl:variable name="modgeneralcolour">#0000FF</xsl:variable>

  <xsl:template match="MODERATION-BILLING">
    Between <xsl:apply-templates select="START-DATE/DATE"/> and <xsl:apply-templates select="END-DATE/DATE"/><br/>

    <table border="1">
      <tr>
        <td rowspan="3">Site</td>
        <td colspan="5" align="center">
          <span class="modbillingthread">Threads</span>
        </td>
      </tr>
      <tr>
        <td colspan="5" align="center">
          <span class="modbillingarticle">Articles</span>
        </td>
      </tr>
      <tr>
        <td colspan="5" align="center">
          <span class="modbillinggeneral">General</span>
        </td>
      </tr>
      <tr>
        <td/>
        <td>
          <span class="modbilling">Total</span>
        </td>
        <td>
          <span class="modbilling">Passed</span>
        </td>
        <td>
          <span class="modbilling">Failed</span>
        </td>
        <td>
          <span class="modbilling">Referred</span>
        </td>
        <td>
          <span class="modbilling">Complaints</span>
        </td>
      </tr>
      <xsl:apply-templates select="BILL"/>
    </table>
    <b>Notes</b><br/>
    <span class="smallfont">
      The percentage figures for passed, failed etc. are the percentage of the total items for that site.
      The percentage figure for totals is the percentage of the total moderation items across all sites.
    </span>
  </xsl:template>


  <xsl:template match="BILL">
    <xsl:variable name="threadtotal">
      <xsl:value-of select="sum(../BILL/THREADTOTAL)"/>
    </xsl:variable>
    <xsl:variable name="articletotal">
      <xsl:value-of select="sum(../BILL/ARTICLETOTAL)"/>
    </xsl:variable>
    <xsl:variable name="generaltotal">
      <xsl:value-of select="sum(../BILL/GENERALTOTAL)"/>
    </xsl:variable>
    <tr>
      <td rowspan="3">
        <xsl:apply-templates select="SITEID" mode="showfrom"/>
      </td>

      <td>
        <span class="modbillingthread">
          <xsl:value-of select="THREADTOTAL"/>
          <xsl:choose>
            <xsl:when test="$threadtotal &gt; 0">
              (<xsl:value-of select="format-number(round((THREADTOTAL div $threadtotal)*100),'0.00')"/>%)
            </xsl:when>
            <xsl:otherwise>
              (0%)
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </td>
      <td>
        <span class="modbillingthread">
          <xsl:apply-templates select="THREADPASSED"/>
        </span>
      </td>
      <td>
        <span class="modbillingthread">
          <xsl:apply-templates select="THREADFAILED"/>
        </span>
      </td>
      <td>
        <span class="modbillingthread">
          <xsl:apply-templates select="THREADREFERRED"/>
        </span>
      </td>
      <td>
        <span class="modbillingthread">
          <xsl:apply-templates select="THREADCOMPLAINT"/>
        </span>
      </td>
    </tr>
    <tr>
      <td>
        <span class="modbillingarticle">
          <xsl:value-of select="ARTICLETOTAL"/>
          <xsl:choose>
            <xsl:when test="$articletotal &gt; 0">
              (<xsl:value-of select="format-number(round((ARTICLETOTAL div $articletotal)*100),'0.00')"/>%)
            </xsl:when>
            <xsl:otherwise>
              (0%)
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </td>
      <td>
        <span class="modbillingarticle">
          <xsl:apply-templates select="ARTICLEPASSED"/>
        </span>
      </td>
      <td>
        <span class="modbillingarticle">
          <xsl:apply-templates select="ARTICLEFAILED"/>
        </span>
      </td>
      <td>
        <span class="modbillingarticle">
          <xsl:apply-templates select="ARTICLEREFERRED"/>
        </span>
      </td>
      <td>
        <span class="modbillingarticle">
          <xsl:apply-templates select="ARTICLECOMPLAINT"/>
        </span>
      </td>
    </tr>
    <tr>
      <td>
        <span class="modbillinggeneral">
          <xsl:value-of select="GENERALTOTAL"/>
          <xsl:choose>
            <xsl:when test="$generaltotal &gt; 0">
              (<xsl:value-of select="round((GENERALTOTAL div $generaltotal)*100)"/>%)
            </xsl:when>
            <xsl:otherwise>
              (0%)
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </td>
      <td>
        <span class="modbillinggeneral">
          <xsl:apply-templates select="GENERALPASSED"/>
        </span>
      </td>
      <td>
        <span class="modbillinggeneral">
          <xsl:apply-templates select="GENERALFAILED"/>
        </span>
      </td>
      <td>
        <span class="modbillinggeneral">
          <xsl:apply-templates select="GENERALREFERRED"/>
        </span>
      </td>
    </tr>

  </xsl:template>


  <xsl:template match="THREADPASSED|THREADFAILED|THREADREFERRED|THREADCOMPLAINT">
    <xsl:choose>
      <xsl:when test="number(preceding-sibling::THREADTOTAL) &gt; 0">
        <xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::THREADTOTAL)),'0.00')"/>%)
      </xsl:when>
      <xsl:otherwise>0 (0%)</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ARTICLEPASSED|ARTICLEFAILED|ARTICLEREFERRED|ARTICLECOMPLAINT">
    <xsl:choose>
      <xsl:when test="number(preceding-sibling::ARTICLETOTAL) &gt; 0">
        <xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::ARTICLETOTAL)),'0.00')"/>%)
      </xsl:when>
      <xsl:otherwise>0 (0%)</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="GENERALPASSED|GENERALFAILED|GENERALREFERRED">
    <xsl:choose>
      <xsl:when test="number(preceding-sibling::GENERALTOTAL) &gt; 0">
        <xsl:value-of select="."/> (<xsl:value-of select="format-number(100*(number(.) div number(preceding-sibling::GENERALTOTAL)),'0.00')"/>%)
      </xsl:when>
      <xsl:otherwise>0 (0%)</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="createmodbillmonthlink">
    <xsl:param name="offset">-1</xsl:param>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>
        <xsl:text>ModerationBilling?startdate=</xsl:text>
        <xsl:call-template name="generatedate">
          <xsl:with-param name="offset">
            <xsl:value-of select="number($offset)"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>&amp;enddate=</xsl:text>
        <xsl:call-template name="generatedate">
          <xsl:with-param name="offset">
            <xsl:value-of select="number($offset)+1"/>
          </xsl:with-param>
        </xsl:call-template>
        <!--		<xsl:choose>
			<xsl:when test="/H2G2/DATE/@MONTH = 1">
				<xsl:value-of select="concat(number(/H2G2/DATE/@YEAR)-1,'-12-01')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(/H2G2/DATE/@YEAR,'-',number(/H2G2/DATE/@MONTH)-1,'-01')"/>
			</xsl:otherwise>
		</xsl:choose>
-->
      </xsl:attribute>
      <xsl:call-template name="generatemonth">
        <xsl:with-param name="offset">
          <xsl:value-of select="$offset"/>
        </xsl:with-param>
      </xsl:call-template>
    </a>
  </xsl:template>

  <xsl:template name="generatedate">
    <xsl:param name="offset">-1</xsl:param>
    <xsl:choose>
      <xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
        <xsl:value-of select="concat(number(/H2G2/DATE/@YEAR)-1,'-',number(/H2G2/DATE/@MONTH)+12+number($offset),'-01')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(/H2G2/DATE/@YEAR,'-',number(/H2G2/DATE/@MONTH)+number($offset),'-01')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="generatemonth">
    <xsl:param name="offset">-1</xsl:param>
    <xsl:variable name="monthcount">
      <xsl:choose>
        <xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
          <xsl:value-of select="number(/H2G2/DATE/@MONTH)+12+number($offset)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(/H2G2/DATE/@MONTH)+number($offset)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$monthcount = 1">January </xsl:when>
      <xsl:when test="$monthcount = 2">February </xsl:when>
      <xsl:when test="$monthcount = 3">March </xsl:when>
      <xsl:when test="$monthcount = 4">April </xsl:when>
      <xsl:when test="$monthcount = 5">May </xsl:when>
      <xsl:when test="$monthcount = 6">June </xsl:when>
      <xsl:when test="$monthcount = 7">July </xsl:when>
      <xsl:when test="$monthcount = 8">August </xsl:when>
      <xsl:when test="$monthcount = 9">September </xsl:when>
      <xsl:when test="$monthcount = 10">October </xsl:when>
      <xsl:when test="$monthcount = 11">November </xsl:when>
      <xsl:when test="$monthcount = 12">December </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="(number(/H2G2/DATE/@MONTH)+number($offset)) &lt; 1">
        <xsl:value-of select="number(/H2G2/DATE/@YEAR)-1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(/H2G2/DATE/@YEAR)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--

	<xsl:template name="SUBJECTHEADER">
	Purpose:	Default way of presenting a SUBJECTHEADER

-->
  <xsl:template name="SUBJECTHEADER">
    <xsl:param name="text">?????</xsl:param>
    <div xsl:use-attribute-sets="headerfont">
      <xsl:value-of select="$text"/>
    </div>
  </xsl:template>
  <!--

	<xsl:template name="HEADER">
	Purpose:	Default way of presenting a HEADER element

-->
  <xsl:template name="HEADER">
    <xsl:param name="text">?????</xsl:param>
    <div xsl:use-attribute-sets="headerfont">
      <xsl:value-of select="$text"/>
    </div>
  </xsl:template>


  <!--
	The locked status page for the moderation tools
-->

  <xsl:template match="H2G2[@TYPE='MODERATOR-LIST']">
    <html>
      <head>
        <!-- prevent browsers caching the page -->
        <meta http-equiv="Cache-Control" content="no cache"/>
        <meta http-equiv="Pragma" content="no cache"/>
        <meta http-equiv="Expires" content="0"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
        <title>h2g2 : Moderator List</title>
        <style type="text/css">
          <xsl:comment>
            DIV.ModerationTools A { color: blue}
            DIV.ModerationTools A.active { color: red}
            DIV.ModerationTools A.visited { color: darkblue}
            DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
          </xsl:comment>
        </style>
      </head>
      <body bgColor="lightblue">
        <div class="ModerationTools">
          <xsl:variable name="currentsite">
            <xsl:value-of select="//SITE-LIST/SITE/SHORTNAME[//CURRENTSITEID=../@ID]"/>
          </xsl:variable>
          <h2 align="Left">
            Moderator Lists Page for
            <a>
              <xsl:attribute name="href">
                /dna/<xsl:value-of select="$currentsite"/>/
              </xsl:attribute>
              <xsl:value-of select="$currentsite"/>
            </a>
          </h2>

          <table>
            <tr>
              <td>
                <b>Moderator</b>
              </td>
              <td>
                <b>Homepage</b>
              </td>
              <td>
                <b>Sites</b>
              </td>
            </tr>
            <tr height="5"/>
            <xsl:for-each select="./MODERATORLIST/MODERATOR">
              <tr>
                <td>
                  <xsl:value-of select="USER/USERNAME"/>
                </td>
                <td>
                  <a>
                    <xsl:attribute name="href">
                      U<xsl:value-of select="USER/USERID"/>
                    </xsl:attribute>
                    U<xsl:value-of select="USER/USERID"/>
                  </a>
                </td>
                <xsl:for-each select="SITEID">
                  <xsl:variable name="site">
                    <xsl:value-of select="//SITE-LIST/SITE/SHORTNAME[current()=../@ID]"/>
                  </xsl:variable>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        /dna/<xsl:value-of select="$site"/>/
                      </xsl:attribute>
                      <xsl:value-of select="$site"/>
                    </a>
                  </td>
                </xsl:for-each>
              </tr>
            </xsl:for-each>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ***************************************************************************************************** -->
  <!-- ***************************************************************************************************** -->
  <!--         New Generic Base Don't!!! Add your templates below here unless it is generic -->
  <!-- ***************************************************************************************************** -->
  <!-- ***************************************************************************************************** -->





  <!--
	<xsl:template match="@SKIPTO" mode="navbuttons">
	Author:		Tom Whitehouse
	Inputs:		ID: By default Id is the Forum ID, will need to be overridden if used outside of the FORUMTHREADSPOSTS context
				URL: The letter that precedes ID, ef to make up F123456
				ExtraParameters:
				skiptobeginning - skiptoendfaded: Required 8 different Images/ text to display 
				navbuttonsspacer: delimiter used between the navbuttons
	Purpose:	Displays 4 navbuttons - Skip to beginning, skip to previous, skip to next and skip to end. Used in, for example, 
	                    conversation lists, MULTIPOSTS pages.
	Call:             Use the calls <xsl:apply-templates select="@SKIPTO" mode="showprevrange"/>
                          and <xsl:apply-templates select="@SKIPTO" mode="shownextrange"/> to hold alt values for 'show postings XX'.
	                    To use this template with rollovers, use the attribute sets as_skiptobeginning etc, 
-->
  <xsl:template match="@SKIPTO" mode="navbuttons">
    <xsl:param name="ID" select="../@FORUMID"/>
    <xsl:param name="URL">F</xsl:param>
    <xsl:param name="ExtraParameters"/>
    <!--xsl:param name="showconvs">
			<xsl:value-of select="$alt_showconvs"/>
		</xsl:param>
		<xsl:param name="shownewest">
			<xsl:value-of select="$alt_shownewest"/>
		</xsl:param>
		<xsl:param name="alreadynewestconv">
			<xsl:value-of select="$alt_alreadynewestconv"/>
		</xsl:param>
		<xsl:param name="nonewconvs">
			<xsl:value-of select="$alt_nonewconvs"/>
		</xsl:param>
		<xsl:param name="showoldestconv">
			<xsl:value-of select="$alt_showoldestconv"/>
		</xsl:param>
		<xsl:param name="noolderconv">
			<xsl:value-of select="$m_noolderconv"/>
		</xsl:param>
		<xsl:param name="showingoldest">
			<xsl:value-of select="$alt_showingoldest"/>
		</xsl:param-->
    <!-- Start of 8 prev/next parameters -->
    <xsl:param name="skiptobeginning">
      <xsl:value-of select="$alt_shownewest"/>
    </xsl:param>
    <xsl:param name="skiptoprevious">
      <xsl:apply-templates select="." mode="showprevrange"/>
    </xsl:param>
    <xsl:param name="skiptobeginningfaded">
      <xsl:value-of select="$alt_alreadynewestconv"/>
    </xsl:param>
    <xsl:param name="skiptopreviousfaded">
      <xsl:value-of select="$alt_nonewconvs"/>
    </xsl:param>
    <xsl:param name="skiptonext">
      <xsl:apply-templates select="." mode="shownextrange"/>
    </xsl:param>
    <xsl:param name="skiptoend">
      <xsl:value-of select="$alt_showoldestconv"/>
    </xsl:param>
    <xsl:param name="skiptonextfaded">
      <xsl:value-of select="$m_noolderconv"/>
    </xsl:param>
    <xsl:param name="skiptoendfaded">
      <xsl:value-of select="$alt_showingoldest"/>
    </xsl:param>
    <xsl:param name="navbuttonsspacer"/>
    <xsl:param name="showendpoints" select="true()"/>
    <xsl:param name="attributes"/>
    <xsl:variable name="choosethread">
      <xsl:choose>
        <xsl:when test="../@THREADID">
          ?thread=<xsl:value-of select="../@THREADID"/>&amp;
        </xsl:when>
        <xsl:otherwise>?</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="findlatest">
      <xsl:choose>
        <xsl:when test="../@THREADID">latest=1</xsl:when>
        <!-- Is this a shortcut for multipost pages? -->
        <xsl:otherwise>
          skip=<xsl:value-of select="floor((number(../@TOTALTHREADS)-1) div number(../@COUNT)) * number(../@COUNT)"/>&amp;show= <xsl:value-of select="../@COUNT"/>
          <xsl:value-of select="$ExtraParameters"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test=". != 0">
        <xsl:if test="$showendpoints">
          <a href="{$root}{$URL}{$ID}{$choosethread}skip=0&amp;show={../@COUNT}{$ExtraParameters}" xsl:use-attribute-sets="as_skiptobeginning">
            <xsl:call-template name="ApplyAttributes">
              <xsl:with-param name="attributes" select="$attributes"/>
            </xsl:call-template>
            <xsl:copy-of select="$skiptobeginning"/>
          </a>
        </xsl:if>
        <a href="{$root}{$URL}{$ID}{$choosethread}skip={number(.) - number(../@COUNT)}&amp;show={../@COUNT}{$ExtraParameters}" xsl:use-attribute-sets="as_skiptoprevious">
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:copy-of select="$skiptoprevious"/>
        </a>
        <xsl:call-template name="ApplyAttributes">
          <xsl:with-param name="attributes" select="$attributes"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$showendpoints">
          <xsl:copy-of select="$skiptobeginningfaded"/>
        </xsl:if>
        <xsl:copy-of select="$skiptopreviousfaded"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="$navbuttonsspacer"/>
    <xsl:choose>
      <xsl:when test="../@MORE = 1">
        <a href="{$root}{$URL}{$ID}{$choosethread}skip={number(../@SKIPTO) + number(../@COUNT)}&amp;show={../@COUNT}{$ExtraParameters}" xsl:use-attribute-sets="as_skiptonext">
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:copy-of select="$skiptonext"/>
        </a>
        <xsl:if test="$showendpoints">
          <a href="{$root}{$URL}{$ID}{$choosethread}{$findlatest}" xsl:use-attribute-sets="as_skiptoend">
            <xsl:call-template name="ApplyAttributes">
              <xsl:with-param name="attributes" select="$attributes"/>
            </xsl:call-template>
            <xsl:copy-of select="$skiptoend"/>
          </a>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$skiptonextfaded"/>
        <xsl:if test="$showendpoints">
          <xsl:copy-of select="$skiptoendfaded"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
	<xsl:template match="@SKIPTO" mode="showprevrange | shownextrange">
	Author:		Tom Whitehouse
	Purpose:	Calculates the string to display the link to the following range of conversations
	                    eg. Show Posting 501-520
	-->
  <xsl:template match="@SKIPTO" mode="showprevrange">
    <xsl:param name="showtext" select="$alt_showpostings"/>
    <xsl:value-of select="$showtext"/>
    <xsl:value-of select="concat(string(number(../@SKIPTO) - number(../@COUNT) + 1), $alt_to, string(number(../@SKIPTO)))"/>
    <!--xsl:value-of select="number(../@SKIPTO) - number(../@COUNT) + 1"/>-<xsl:value-of select="number(../@SKIPTO)"/-->
  </xsl:template>
  <xsl:template match="@SKIPTO" mode="shownextrange">
    <xsl:param name="showtext" select="$alt_showpostings"/>
    <xsl:value-of select="$showtext"/>
    <xsl:value-of select="concat(string(number(../@SKIPTO) + number(../@COUNT) + 1), $alt_to, string(number(../@SKIPTO) + number(../@COUNT) + number(../@COUNT)))"/>
  </xsl:template>

  <!-- ********************************************************************************************************************************************** -->
  <!-- ********************             Generic Search Page templates              *********************** -->
  <!--                                                      28/02/2002                                                              -->
  <!-- ***************************************************************************************************** -->
  <!-- ******************************************************************************************** -->

  <!-- ******************************************************************************************** -->
  <!-- ******************************************************************************************** -->
  <!-- ***************  Secure attributes, these cannot be overridden:  ****************** -->
  <!-- ******************************************************************************************** -->
  <!-- ******************************************************************************************** -->
  <!-- These attribute sets are always be utilised in HTMLOutput in their currewnt form -->


  <!--
	SearchFormAtts specifies the attributes that MUST appear on a search <form> element 
 -->
  <xsl:attribute-set name="SearchFormAtts">
    <xsl:attribute name="METHOD">GET</xsl:attribute>
    <xsl:attribute name="action">
      <xsl:value-of select="$root"/>Search
    </xsl:attribute>
  </xsl:attribute-set>
  <!--
The following specifies the attributes that MUST appear on an <input> element for an Article/Friends/Forums search
-->
  <xsl:attribute-set name="SearchTypeArticles">
    <xsl:attribute name="NAME">searchtype</xsl:attribute>
    <xsl:attribute name="value">article</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="SearchTypeForums">
    <xsl:attribute name="NAME">searchtype</xsl:attribute>
    <xsl:attribute name="value">forum</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="SearchTypeFriends">
    <xsl:attribute name="NAME">searchtype</xsl:attribute>
    <xsl:attribute name="value">USER</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="fPOSTTHREADFORM">
    <xsl:attribute name="METHOD">POST</xsl:attribute>
    <xsl:attribute name="ACTION">
      <xsl:value-of select="$root"/>AddThread
    </xsl:attribute>
    <xsl:attribute name="name">theForm</xsl:attribute>
  </xsl:attribute-set>

  <!-- ******************************************************************************************** -->
  <!-- ******************************************************************************************** -->
  <!--                        Overwritable attribute sets and Variables                                  -->
  <!-- ******************************************************************************************** -->
  <!-- ******************************************************************************************** -->
  <!-- These attribute sets are always copied or overridden in HTMLOutput -->
  <!-- The following all specify which font size, face and style to use for each result fragment, by default they are the same as mainfont. -->
  <!-- statusstyle: The status column values -->
  <xsl:attribute-set name="statusstyle">
    <xsl:attribute name="class">statusstyle</xsl:attribute>
  </xsl:attribute-set>
  <!-- subjectstyle: The Article Subject column values -->
  <xsl:attribute-set name="subjectstyle">
    <xsl:attribute name="class">subjectstyle</xsl:attribute>
  </xsl:attribute-set>
  <!-- scorestyle: the score column values -->
  <xsl:attribute-set name="scorestyle">
    <xsl:attribute name="class">scorestyle</xsl:attribute>
  </xsl:attribute-set>
  <!-- h2g2idstyle: The DNAID column values -->
  <xsl:attribute-set name="h2g2idstyle">
    <xsl:attribute name="class">h2g2idstyle</xsl:attribute>
  </xsl:attribute-set>
  <!-- shortnamestyle: the shortname (eg 360, Sense of Place - Northern Ireland) column values -->
  <xsl:attribute-set name="shortnamestyle">
    <xsl:attribute name="class">shortnamestyle</xsl:attribute>
  </xsl:attribute-set>
  <!-- useridstyle: The Username column values -->
  <xsl:attribute-set name="useridstyle">
    <xsl:attribute name="class">useridstyle</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="searchtitlefont" use-attribute-sets="mainfont"/>
  <!-- resultscolumntitle: The title for each column, eg status, score etc -->
  <xsl:attribute-set name="resultscolumntitle" use-attribute-sets="mainfont"/>
  <!-- textsearchatts is for extra presentation info, eg size, style for the search form <input> element -->
  <xsl:attribute-set name="textsearchatts"/>
  <!-- ******************************************************************************************** -->
  <!--                                           <a> tag attribute sets                                               -->
  <!-- ******************************************************************************************** -->
  <!-- UserResultLinkAttr: The USERNAME link when searching for users -->
  <!--xsl:attribute-set name="UserResultLinkAttr" use-attribute-sets="linkatt"/-->
  <!-- ForumResultLinkAttr: SUBJECT when searching conversations -->
  <!--xsl:attribute-set name="ForumResultLinkAttr" use-attribute-sets="linkatt"/-->
  <!-- SearchMoreLinkAttr: the 'next results' link, they dont follow naming convention due to problems no mode was put on the template -->
  <xsl:attribute-set name="SearchMoreLinkAttr" use-attribute-sets="linkatt"/>
  <!-- SearchSkipLinkAttr: the 'previous results' link -->
  <xsl:attribute-set name="SearchSkipLinkAttr" use-attribute-sets="linkatt"/>
  <!-- AlphaLinkAttr: The alphaindex letters -->
  <!--xsl:attribute-set name="AlphaLinkAttr" use-attribute-sets="linkatt"/-->

  <!-- ******************************************************************************************** -->
  <!--
	$skipdivider specifies how the 'previous' and 'next results' is presented
	 -->
  <xsl:variable name="skipdivider"> | </xsl:variable>
  <!-- ********************************************************************************************************* -->
  <!-- ********************************************************************************************************* -->
  <!-- 
	 Secure templates, these cannot be overridden, they contain core DNA programmatic
	  information as well as references to attribute sets and variables defined in 
	  HTMLOutput or text files  
 -->
  <!-- *********************************************************************************************************** -->
  <!-- ********************************************************************************************************* -->
  <!--
	<xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL" mode="hidden">
	Author:		Tom Whitehouse
	Context:	Always a child of /H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES
	Purpose:  Used if no distinction between the edited, recommended and normal guide is required
-->
  <xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL" mode="hidden">
    <input type="hidden" value="1" name="{translate(name(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}"/>

  </xsl:template>
  <!--
	<xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL">
	Author:		Tom Whitehouse
	Context:	Always a child of /H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES
	Purpose:  Creates an input checkbox used in deciding where to search on H2G2
-->
  <xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL" name="WhatToSearch">
    <xsl:param name="searchType" select="name()"/>
    <INPUT TYPE="checkbox" VALUE="1" name="{translate($searchType, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}">
      <xsl:if test=".=1">
        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
      </xsl:if>
    </INPUT>
  </xsl:template>

  <xsl:template match="SEARCHARTICLES">
    <xsl:choose>
      <xsl:when test="./*">
        <xsl:apply-templates select="SHOWAPPROVED"/>
        <xsl:value-of select="$m_editedentries"/>
        <br/>
        <xsl:apply-templates select="SHOWSUBMITTED"/>
        <xsl:value-of select="$m_recommendedentries"/>
        <br/>
        <xsl:apply-templates select="SHOWNORMAL"/>
        <xsl:value-of select="$m_guideentries"/>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="WhatToSearch">
          <xsl:with-param name="searchType" select="'showapproved'"/>
        </xsl:call-template>
        <xsl:value-of select="$m_editedentries"/>
        <br/>
        <xsl:call-template name="WhatToSearch">
          <xsl:with-param name="searchType" select="'showsubmitted'"/>
        </xsl:call-template>
        <xsl:value-of select="$m_recommendedentries"/>
        <br/>
        <xsl:call-template name="WhatToSearch">
          <xsl:with-param name="searchType" select="'shownormal'"/>
        </xsl:call-template>
        <xsl:value-of select="$m_guideentries"/>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--
	<xsl:template name="SearchFormSubmitText">
	Author:		Tom Whitehouse
	Context: H2G2 (always)
	Purpose: Generic Submit button with a textual value
-->
  <xsl:template name="SearchFormSubmitText">
    <xsl:param name="text" select="$m_searchtheguide"/>
    <INPUT TYPE="SUBMIT" NAME="dosearch" VALUE="{$text}"/>
  </xsl:template>
  <!--
	<xsl:template name="SearchFormSubmitImage">
	Author:		Tom Whitehouse
	Context: H2G2 (always)
	Purpose: Generic Submit button rendered as an image
-->
  <xsl:template name="SearchFormSubmitImage">
    <xsl:param name="imagesrc"/>
    <xsl:param name="attributes"/>
    <INPUT TYPE="image" NAME="dosearch" src="{$imagesrc}" value="{$m_searchtheguide}" border="0" xsl:use-attribute-sets="nSearchFormSubmitImage">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
    </INPUT>
  </xsl:template>
  <!--
	<xsl:template name="SearchFormMain / searchforfriends / searchforforums">
	Author:		Tom Whitehouse
	Context: H2G2 (always)
	Purpose: Generic Textual <input> elements used to search the site/ users/ forums
-->
  <xsl:template name="SearchFormMain">
    <INPUT TYPE="TEXT" NAME="searchstring" xsl:use-attribute-sets="textsearchatts">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="SEARCH/SEARCHRESULTS/SEARCHTERM"/>
      </xsl:attribute>
    </INPUT>
  </xsl:template>
  <xsl:template name="searchforfriends">
    <xsl:value-of select="$m_searchfor"/>
    <INPUT TYPE="TEXT" NAME="searchstring"/>
  </xsl:template>
  <xsl:template name="searchforforums">
    <xsl:value-of select="$m_searchfor"/>
    <INPUT TYPE="TEXT" NAME="searchstring"/>
  </xsl:template>
  <!--
	<xsl:template match="MORE / SKIP">
	Author:		Tom Whitehouse
	Context: Always a child of /H2G2/SEARCH/SEARCHRESULTS. 
	Obligatory: Yes
	Purpose: Renders a link to previous/ next pages of a search result
-->
  <xsl:template match="MORE[parent::SEARCHRESULTS]">
    <xsl:choose>
      <xsl:when test=". = 1">
        <a xsl:use-attribute-sets="SearchMoreLinkAttr">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(../SKIP) + number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if>
          </xsl:attribute>
          <xsl:value-of select="$m_nextresults"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_nomoreresults"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="SKIP[parent::SEARCHRESULTS]">
    <xsl:choose>
      <xsl:when test="(. &gt; 0)">
        <a xsl:use-attribute-sets="SearchSkipLinkAttr">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(.) - number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if>
          </xsl:attribute>
          <xsl:value-of select="$m_prevresults"/>
        </a>
        <xsl:copy-of select="$skipdivider"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_noprevresults"/>
        <xsl:copy-of select="$skipdivider"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="SUBJECT"/>
	Author:		Tom Whitehouse
	Context: Always a child of ARTICLERESULT
	Purpose: Displays the SUBJECT of an article result, can optionally be displayed as a link 
-->
  <xsl:template match="SUBJECT" mode="articleresult">
    <xsl:param name="link" select="'no'"/>

    <xsl:choose>
      <xsl:when test="$link='yes'">
        <a xsl:use-attribute-sets="mSUBJECT_articleresult" href="{$root}A{../H2G2ID}">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <!--
	<xsl:template match="STATUS"/>
	Author:		Tom Whitehouse
	Context: Always a child of ARTICLERESULT
	Purpose: Appropriate when Site is split up into edited, recommended or normal sections - displays where the article result is in this process
-->
  <xsl:template match="STATUS">

    <xsl:choose>
      <xsl:when test=".=1">
        <xsl:value-of select="$m_EditedEntryStatusName"/>
      </xsl:when>
      <xsl:when test=".=9">
        <xsl:value-of select="$m_HelpPageStatusName"/>
      </xsl:when>
      <xsl:when test=".=4 or .=6 or .=11 or .=12 or .=13">
        <xsl:value-of select="$m_RecommendedEntryStatusName"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_NormalEntryStatusName"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <!--
	<xsl:template match="SCORE"/>
	Author:		Tom Whitehouse
	Context: Always a child of ARTICLERESULT
	Purpose:Display of the score a search result returns, ie how appropriate it is to the search criteria
-->
  <xsl:template match="SCORE">
    <xsl:value-of select="."/>%
  </xsl:template>
  <!--
	<xsl:template match="SHORTNAME"/>
	Author:		Tom Whitehouse
	Context: Always a child of ARTICLERESULT
	Purpose: 
-->
  <xsl:template match="SHORTNAME" mode="result">

    <xsl:value-of select="."/>

  </xsl:template>
  <!--
	<xsl:template match="USERNAME"/>
	Author:		Tom Whitehouse
	Context: Always a child of USERRESULT
	Purpose:Display a user as a link to his space
-->
  <xsl:template match="USERNAME" mode="UserResult">
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mUSERNAME_UserResult" href="{$root}U{../USERID}">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:apply-templates select="."/>
    </a>

  </xsl:template>
  <!--
	<xsl:template match="SUBJECT"/>
	Author:		Tom Whitehouse
	Context: Always a child of USERRESULT
	Purpose: Display the Forum subject as a link
-->
  <xsl:template match="SUBJECT" mode="forumresult">

    <a href="{$root}F{../FORUMID}?thread={../THREADID}&amp;post={../POSTID}#p{../POSTID}" xsl:use-attribute-sets="mSUBJECT_forumresult">
      <xsl:value-of select="."/>
    </a>


  </xsl:template>


  <!--

	<xsl:template name="alphaindex">
	Author:		Tom Whitehouse
	Context:      Usually H2G2[@TYPE='SEARCH'], but can be called from anywhere with paramaters
	Purpose:	displays the alphabetical index with links. Can display text or images. Call extra alpha processing to, for example, add line breaks at particular points, add image spacers etc.
	Inputs:		 searchall - if this is specified as 'yes' the template won`t do conditional searching (ie ommitting approved, submitted and unapproved articles), it will just search everything.
 				class - Allows the class in attribute set to be overridden if eg different classes are used for index and search pages
				imagedisplay - specifies whether the template is uses images or text (values are yes or no)
				imagewidth, imageheight - the width/ height of the images
				firstimage - the string (or name of the image) rendered that searches all articles not beginning with a letter
				alphaimagesrc - the image directory for alpha images (if different from $imagesource)
				imagetype - the image type appended to the image name - eg .gif

				letter, display and uri are parameters whose values should not be altered
				
		-->

  <xsl:template name="alphaindex">
    <xsl:param name="letter">.</xsl:param>
    <xsl:param name="display">*</xsl:param>
    <xsl:param name="alphaimagesrc" select="$imagesource"/>
    <xsl:param name="imagedisplay" select="'no'"/>
    <xsl:param name="imagetype">.gif</xsl:param>
    <xsl:param name="imagewidth">12</xsl:param>
    <xsl:param name="imageheight">17</xsl:param>
    <xsl:param name="firstimage">-</xsl:param>
    <xsl:param name="attributes"/>
    <xsl:param name="searchall" select="'no'"/>
    <xsl:param name="lowercase" select="'no'"/>
    <xsl:param name="uri">
      <xsl:value-of select="$root"/>Index?submit=new<xsl:if test="INDEX/@APPROVED or ($searchall = 'yes')">&amp;official=on</xsl:if>
      <xsl:if test="INDEX/@SUBMITTED or ($searchall = 'yes')">&amp;submitted=on</xsl:if>
      <xsl:if test="INDEX/@UNAPPROVED or ($searchall = 'yes')">&amp;user=on</xsl:if>&amp;let=
    </xsl:param>
    <a xsl:use-attribute-sets="nalphaindex">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:attribute name="HREF">
        <xsl:copy-of select="$uri"/>
        <xsl:value-of select="$letter"/>
      </xsl:attribute>
      <b>
        <xsl:choose>
          <xsl:when test="$imagedisplay='yes'">
            <img alt="{$display}" border="0" width="{$imagewidth}" height="{$imageheight}">
              <xsl:attribute name="src">
                <xsl:choose>
                  <xsl:when test="$display='*'">
                    <xsl:value-of select="concat($alphaimagesrc, $firstimage, $imagetype)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($alphaimagesrc, translate($display, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), $imagetype)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </img>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$lowercase='yes'">
                <xsl:value-of select="translate($display, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="$display"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </b>
    </a>
    <xsl:call-template name="extraalphaprocessing">
      <xsl:with-param name="letter" select="$letter"/>
    </xsl:call-template>
    <xsl:if test="not($letter = 'Z')">
      <xsl:call-template name="alphaindex">
        <xsl:with-param name="letter">
          <xsl:value-of select="translate($letter,'.ABCDEFGHIJKLMNOPQRSTUVWXYZ','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:with-param>
        <xsl:with-param name="display">
          <xsl:value-of select="translate($display,'*ABCDEFGHIJKLMNOPQRSTUVWXYZ','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:with-param>
        <xsl:with-param name="imagedisplay">
          <xsl:if test="$imagedisplay='yes'">
            <xsl:value-of select="$imagedisplay"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="alphaimagesrc">
          <xsl:if test="$imagedisplay='yes'">
            <xsl:value-of select="$alphaimagesrc"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="lowercase" select="$lowercase"/>
        <xsl:with-param name="uri" select="$uri"/>
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!--
			<xsl:template name="extraalphaprocessing">
			Author:		Tom Whitehouse
			Purpose:	Used to specify additional processing between each letter in alphaindex
-->

  <xsl:template name="extraalphaprocessing">
    <xsl:param name="letter"/>
    <xsl:if test="$letter = 'M'">
      <BR/>
    </xsl:if>
    &nbsp;
  </xsl:template>


  <!--
	<xsl:template match="SITEID" mode="SiteList">
	Author:		Igor Loboda
	Generic:	Yes
	Inputs:		-
	Purpose:	presents site list as a <SELECT> element.
	-->
  <xsl:template match="SITEID" mode="SiteList">
    <xsl:variable name="currentSiteID" select="."/>
    <SELECT NAME="SitesList">
      <xsl:for-each select="/H2G2/SITE-LIST/SITE">
        <OPTION VALUE="{@ID}">
          <xsl:if test="@ID = $currentSiteID">
            <xsl:attribute name="SELECTED"/>
          </xsl:if>
          <xsl:value-of select="SHORTNAME"/>
        </OPTION>
      </xsl:for-each>
    </SELECT>
  </xsl:template>

  <!--
	<xsl:template name="ArticleInfoDate">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displays date in the following format: Date: 28 March 2002
	-->
  <xsl:template name="ArticleInfoDate">
    <xsl:value-of select="$m_datecolon"/>
    <xsl:apply-templates select="DATECREATED/DATE" mode="short1"/>
  </xsl:template>

  <!--
	<xsl:template name="ArticleInfoDateB">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displays date in the following format: Date: 28 March 2002. 
				Date is marked with bold tag.
	-->
  <xsl:template name="ArticleInfoDateB">
    <xsl:value-of select="$m_datecolon"/>
    <B>
      <xsl:apply-templates select="DATECREATED/DATE" mode="short1"/>
    </B>
  </xsl:template>

  <!--
	<xsl:template match="STATUS/@TYPE">
	Author:		Igor Loboda
	Purpose:	Displays article type in form of:(Recommended)
	-->
  <xsl:template match="STATUS/@TYPE">
    <xsl:choose>
      <xsl:when test=".=1">
        <xsl:value-of select="$m_edited"/>
      </xsl:when>
      <xsl:when test=".=9">
        <xsl:value-of select="$m_helppage"/>
      </xsl:when>
      <xsl:when test=".=4">
        <xsl:value-of select="$m_entrydatarecommendedstatus"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template name="EDITPAGE/@VISIBLE">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Edit Entry button
	-->
  <xsl:template match="EDITPAGE/@VISIBLE" mode="EditEntry">
    <xsl:param name="img" select="$m_editentrylinktext"/>
    <a xsl:use-attribute-sets="maVISIBLE_EditEntry">
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>
        <xsl:value-of select="$pageui_editpage"/>
      </xsl:attribute>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template name="RecommendEntry">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Recommend Entry button
	-->
  <xsl:template name="RecommendEntry">
    <xsl:param name="delimiter">
      <BR/>
      <BR/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="RECOMMENDENTRY">
        <xsl:copy-of select="$delimiter"/>
        <xsl:apply-templates select="RECOMMENDENTRY"/>
      </xsl:when>
      <xsl:when test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR') and STATUS/@TYPE=3">
        <xsl:copy-of select="$delimiter"/>
        <xsl:call-template name="DISPLAY-RECOMMENDENTRY"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template name="ENTRY-SUBBED/@VISIBLE">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Return to Editors button
	-->
  <xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="RetToEditors">
    <xsl:param name="img" select="$m_ReturnToEditorsLinkText"/>
    <a xsl:use-attribute-sets="RetToEditorsLinkAttr">
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>
        <xsl:value-of select="/H2G2/PAGEUI/ENTRY-SUBBED/@LINKHINT"/>
      </xsl:attribute>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!-- ********************************************************************************************************************************************** -->
  <!-- ********************             Generic Category Page templates              *********************** -->
  <!--                                                      11/04/2002                                                              -->
  <!-- ***************************************************************************************************** -->
  <!-- ******************************************************************************************** -->

  <xsl:attribute-set name="CatDisplayNameAttr" use-attribute-sets="catfontheader"/>
  <xsl:attribute-set name="CatDescriptionAttr" use-attribute-sets="catfont"/>
  <xsl:attribute-set name="CatAncestorAttr" use-attribute-sets="catfont"/>
  <xsl:attribute-set name="CatSubjectMemberAttr" use-attribute-sets="catfont"/>

  <!--
	<xsl:template name="HIERARCHYDETAILS" mode="CATEGORY"
	Author:	Dharmesh Raithatha
	Inputs:	
	Purpose: Displays the information in the category page in the alabaster and classic styles 
	-->

  <xsl:template match="HIERARCHYDETAILS" mode="CATEGORY">
    <span xsl:use-attribute-sets="CatDisplayNameAttr">
      <xsl:apply-templates select="DISPLAYNAME"/>
    </span>
    <br/>
    <span xsl:use-attribute-sets="CatDescriptionAttr">
      <xsl:apply-templates select="DESCRIPTION"/>
    </span>
    <hr/>
    <span xsl:use-attribute-sets="CatAncestorAttr">
      <xsl:apply-templates select="ANCESTRY"/>
    </span>
    <hr/>
    <p/>
    <xsl:apply-templates select="MEMBERS">
      <xsl:with-param name="columnlen">
        <xsl:choose>
          <xsl:when test="count(MEMBERS/*) &lt; $catcolcount">
            <xsl:value-of select="$catcolcount"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="floor(count(MEMBERS/*) div 2)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="numitems">
        <xsl:value-of select="count(MEMBERS/*)"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!--
	<Name:	xsl:template name="HIERARCHYDETAILS/DISPLAYNAME"
	Author:	Dharmesh Raithatha
	Inputs:	
	Purpose: Displays the name of the Current category
	-->

  <xsl:template match="HIERARCHYDETAILS/DISPLAYNAME">
    <xsl:value-of select="."/>
  </xsl:template>


  <!--
	<Name:		xsl:template match="HIERARCHYDETAILS/DESCRIPTION"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
	Purpose:	Displays the description and also an edit description link underneath if iscategory = 0 
	-->

  <xsl:template match="HIERARCHYDETAILS/DESCRIPTION">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:apply-templates/>
    <!-- this lets the editors edit the description -->
    <xsl:if test="$iscategory=0">
      <xsl:apply-templates select="../@NODEID" mode="editdescription"/>
    </xsl:if>
  </xsl:template>

  <!--
	<Name:		xsl:template match="@NODEID | NODEID" mode="editdescription"
	Author:		Dharmesh Raithatha
	Inputs:		
	Purpose:	Puts an editdescription link of the given nodeid context 
	-->

  <xsl:template match="@NODEID | NODEID" mode="editdescription">
    <a>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>editcategory?action=renamedesc&amp;nodeid=<xsl:value-of select="../@NODEID"/>
      </xsl:attribute>
      <br/>
      <xsl:call-template name="m_EditCatRenameDesc"/>
    </a>
  </xsl:template>

  <!--
	Name:		<xsl:template match="HIERARCHYDETAILS/ANCESTRY"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
				activenode - if the page is carrying a node around then this is it
				action - the current action that is being performed - defaults as navigate subject
				linker - the connector between the ancestors (x > x > x)
	Purpose:	Displays the description and also an edit description link underneath if iscategory = 0 
	-->

  <xsl:template match="HIERARCHYDETAILS/ANCESTRY">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:param name="activenode"/>
    <xsl:param name="action">&amp;action=navigatesubject</xsl:param>
    <xsl:param name="linker"> / </xsl:param>
    <xsl:for-each select="ANCESTOR">
      <xsl:choose>
        <xsl:when test="$iscategory=1">
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>C<xsl:value-of select="NODEID"/>
            </xsl:attribute>
            <xsl:value-of select="NAME"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/>
            </xsl:attribute>
            <xsl:value-of select="NAME"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of select="$linker"/>
    </xsl:for-each>
    <xsl:value-of select="../DISPLAYNAME"/>
  </xsl:template>


  <!--
	Name:		<xsl:template match="HIERARCHYDETAILS/MEMBERS"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
				activenode - if the page is carrying a node around then this is it
				action - the current action that is being performed - defaults as navigate subject
				columnlen - the length of the column 
				numitems - the number of items that you want to display
	Purpose:	Displays the description and also an edit description link underneath if iscategory = 0 
	-->

  <xsl:template match="MEMBERS">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:param name="activenode"/>
    <xsl:param name="action">&amp;action=navigatesubject</xsl:param>
    <xsl:param name="columnlen">120</xsl:param>
    <xsl:param name="numitems">120</xsl:param>
    <xsl:variable name="sortedmembers">
      <MEMBERS>
        <xsl:for-each select="SUBJECTMEMBER|ARTICLEMEMBER|NODEALIASMEMBER">
          <xsl:sort select="STRIPPEDNAME" data-type="text" order="ascending"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </MEMBERS>
    </xsl:variable>
    <table width="100%">
      <tr valign="top">
        <td width="50%">
          <ul>
            <xsl:for-each select="msxsl:node-set($sortedmembers)/MEMBERS/*[position() &lt; ($columnlen + 1)]">

              <li>
                <span xsl:use-attribute-sets="CatSubjectMemberAttr">
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="iscategory" select="$iscategory"/>
                    <xsl:with-param name="activenode" select="$activenode"/>
                    <xsl:with-param name="action" select="$action"/>
                  </xsl:apply-templates>
                </span>
              </li>
            </xsl:for-each>
          </ul>
        </td>
        <td width="50%">
          <ul>
            <xsl:for-each select="msxsl:node-set($sortedmembers)/MEMBERS/*[position() &gt; ($columnlen)]">

              <li>
                <span xsl:use-attribute-sets="CatSubjectMemberAttr">
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="iscategory" select="$iscategory"/>
                    <xsl:with-param name="activenode" select="$activenode"/>
                    <xsl:with-param name="action" select="$action"/>
                  </xsl:apply-templates>
                </span>
              </li>
            </xsl:for-each>
          </ul>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--
	Name:		<xsl:template match="MEMBERS/SUBJECTMEMBER"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
				activenode - if the page is carrying a node around then this is it
				action - the current action that is being performed - defaults as navigate subject
	context:	HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:	Displays subjectmember within the category page 
	-->

  <xsl:template match="MEMBERS/SUBJECTMEMBER">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:param name="activenode"/>
    <xsl:param name="action">&amp;action=navigatesubject</xsl:param>
    <div class="category">
      <xsl:variable name="linkto">
        <xsl:choose>
          <xsl:when test="$iscategory=1">
            C<xsl:value-of select="NODEID"/>
          </xsl:when>
          <xsl:otherwise>
            editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
          <a xsl:use-attribute-sets="catfontemptysubject">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontemptysubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [<xsl:value-of select="$m_nomembers"/>]
            </nobr>
          </span>
        </xsl:when>
        <xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
          <a xsl:use-attribute-sets="catfontfullsubject">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontfullsubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [1<xsl:value-of select="$m_member"/>]
            </nobr>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <a xsl:use-attribute-sets="catfontfullsubject">
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontfullsubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/><xsl:value-of select="$m_members"/>]
            </nobr>
          </span>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$iscategory=0">
        <br/>
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatesubject&amp;activenode=<xsl:value-of select="NODEID"/>
          </xsl:attribute>
          <xsl:call-template name="m_movesubject"/>
        </A>
        <xsl:call-template name="m_EditCatDots"/>
        <A>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delsubject&amp;activenode=<xsl:value-of select="NODEID"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute>Delete Subject
        </A>
      </xsl:if>
    </div>
  </xsl:template>

  <!--
	Name:		<xsl:template match="MEMBERS/ARTICLEMEMBER"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
				activenode - if the page is carrying a node around then this is it
	context:	HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER
	Purpose:	Displays articlemember within the category page 
	-->

  <xsl:template match="MEMBERS/ARTICLEMEMBER">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:param name="activenode"/>
    <div class="categoryarticle">
      <xsl:choose>
        <xsl:when test="string-length(SECTION) &gt; 0">
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>?section=<xsl:value-of select="SECTION"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontarticle">
              <xsl:value-of select="NAME"/> (<xsl:value-of select="SECTIONDESCRIPTION"/>)
            </span>
          </A>
        </xsl:when>
        <xsl:otherwise>
          <A>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontarticle">
              <xsl:value-of select="NAME"/>
            </span>
          </A>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$iscategory=0">
        <br/>
        <a>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatearticle&amp;activenode=<xsl:value-of select="H2G2ID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/>
          </xsl:attribute>Move Article
        </a>........
        <a>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delarticle&amp;activenode=<xsl:value-of select="H2G2ID"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute>Delete Article
        </a>
      </xsl:if>
    </div>
  </xsl:template>


  <!--
	Name:		<xsl:template match="MEMBERS/NODEALIASMEMBER"
	Author:		Dharmesh Raithatha
	Inputs:		iscategory - 0 if you want edit links, 1 otherwise
				activenode - if the page is carrying a node around then this is it
	context:	HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER
	Purpose:	Displays articlemember within the category page 
	-->

  <xsl:template match="MEMBERS/NODEALIASMEMBER">
    <xsl:param name="iscategory">1</xsl:param>
    <xsl:param name="activenode"/>
    <xsl:param name="action">&amp;action=navigatesubject</xsl:param>

    <xsl:variable name="linkto">
      <xsl:choose>
        <xsl:when test="$iscategory=1">
          C<xsl:value-of select="LINKNODEID"/>
        </xsl:when>
        <xsl:otherwise>
          editcategory?nodeid=<xsl:value-of select="LINKNODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="subjectalias">
      <xsl:choose>
        <xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontemptysubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [<xsl:value-of select="$m_nomembers"/>]
            </nobr>
          </span>
        </xsl:when>
        <xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontfullsubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [1<xsl:value-of select="$m_member"/>]
            </nobr>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="HREF">
              <xsl:value-of select="$root"/>
              <xsl:value-of select="$linkto"/>
            </xsl:attribute>
            <span xsl:use-attribute-sets="catfontfullsubject">
              <xsl:value-of select="NAME"/>
            </span>
          </a>
          <span xsl:use-attribute-sets="catfontmember">
            <nobr>
              [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/><xsl:value-of select="$m_members"/>]
            </nobr>
          </span>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$iscategory=0">
        <br/>
        <a>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatealias&amp;activenode=<xsl:value-of select="LINKNODEID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/>
          </xsl:attribute>Move Subject Link
        </a>........
        <a>
          <xsl:attribute name="HREF">
            <xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delalias&amp;activenode=<xsl:value-of select="LINKNODEID"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete');</xsl:attribute>Delete Subject Link
        </a>
      </xsl:if>
    </div>
  </xsl:template>

  <!--
	<xsl:template match="H2G2ID" mode="CategoriseLink">
	Author:		Igor Loboda
	Inputs:		img - img/text for <A/>
	Purpose:	Categorise button
	-->
  <xsl:template match="H2G2ID" mode="CategoriseLink">
    <xsl:param name="img" select="$m_Categorise"/>
    <a xsl:use-attribute-sets="CategoriseLinkAttr">
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>EditCategory?activenode=<xsl:value-of select="."/>&amp;nodeid=0&amp;action=navigatearticle
      </xsl:attribute>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>


  <!--
	<xsl:template match="RESEARCHERS">
	Author:		Igor Loboda
	Inputs:		delimiter - delimiter between Researcher 172781 and Edited by:
	Context:    ARTICLEINFO
				Uses test variable test_HasResearchers.
	Purpose:	Displays list of article researchers in form of
				Researcher 172781
				Researcher 172782
	-->
  <xsl:template match="RESEARCHERS">
    <xsl:param name="delimiter">
      <BR/>
    </xsl:param>
    <xsl:for-each select="USER">
      <xsl:if test="USERID!=../../EDITOR/USER/USERID">
        <xsl:apply-templates select="." mode="ArticleInfo"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template match="ENTRYLINK" mode="JustLink">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displayes <ENTRYLINK> information in form of <A> element
	-->
  <xsl:template match="ENTRYLINK" mode="JustLink">
    <xsl:element name="A" use-attribute-sets="mENTRYLINK_JustLink">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
      </xsl:attribute>
      <xsl:value-of select="SUBJECT"/>
    </xsl:element>
  </xsl:template>

  <!--
	<xsl:template match="USERLINK" mode="JustLink">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displayes <USERLINK> information in form of <A> element
	-->
  <xsl:template match="USERLINK" mode="JustLink">
    <xsl:element name="A" use-attribute-sets="linkatt">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
      </xsl:attribute>
      <xsl:value-of select="USERNAME"/>
    </xsl:element>
  </xsl:template>

  <!--
	<xsl:template name="HDivider">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displayes divider as table
	-->
  <xsl:template name="HDivider">
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td bgcolor="{$horizdividers}">
          <img src="{$imagesource}blank.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--
	<xsl:template match="DATE" mode="MorePosts">
	Author:		Igor Loboda
	Inputs:		userid - user id
				skipparams - skip=N&
				target - target frame for A element
				linkText - tex for the link
	Context:    any where @FORUMID is present
	Purpose:	Generates A with HREF as 
				MP6?skip=0&show=25&s_type=pop&s_upto=&s_target=conversation
	Call:		
				<xsl:apply-templates select="DATE" mode="MorePosts">
					<xsl:with-param name="userid" select="$userid"/>
					<xsl:with-param name="skipparams" select="$skipparams"/>
					<xsl:with-param name="target" select="$target"/>
					<xsl:with-param name="linkText" select="$m_MarkAllRead"/>
				</xsl:apply-templates>
	-->
  <xsl:template match="DATE" mode="MorePosts">
    <xsl:param name="userid"/>
    <xsl:param name="skipparams"/>
    <xsl:param name="target"/>
    <xsl:param name="linkText"/>
    <xsl:param name="threadparams"/>
    <xsl:param name="thread"/>
    <xsl:param name="allsame"/>
    <xsl:param name="postlist"/>
    <xsl:param name="adjust"/>
    <xsl:variable name="datestring">
      <xsl:choose>
        <xsl:when test="string-length($adjust)=0">
          <xsl:value-of select="concat(@YEAR,@MONTH,@DAY,@HOURS,@MINUTES,@SECONDS)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(number(concat(@YEAR,@MONTH,@DAY,@HOURS,@MINUTES,@SECONDS)) + number($adjust))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a xsl:use-attribute-sets="mDATE_MorePosts">
      <xsl:attribute name="href">
        <xsl:value-of select="$root"/>MP<xsl:value-of select="$userid"/>?<xsl:value-of select="$skipparams"/>s_type=pop&amp;s_target=<xsl:value-of select="$target"/>
        <xsl:if test="$threadparams">
          <xsl:apply-templates select="msxsl:node-set($threadparams)" mode="ThreadRead">
            <xsl:with-param name="setdate" select="$allsame"/>
            <xsl:with-param name="date" select="$datestring"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$postlist">
          <xsl:apply-templates select="msxsl:node-set($postlist)" mode="ThreadRead">
            <xsl:with-param name="date" select="$datestring"/>
          </xsl:apply-templates>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$thread">
            <xsl:text>&amp;s_t=</xsl:text><xsl:value-of select="$thread"/>|<xsl:value-of select="$datestring"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&amp;s_upto=</xsl:text>
            <xsl:value-of select="$datestring"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$linkText"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="@THREADID" mode="JustLink">
	Author:		Igor Loboda
	Inputs:		-
	Context:    any where @FORUMID is present
	Purpose:	Generates HREF as F432?thread=175875
	Call:		<xsl:apply-templates select="@THREADID" mode="JustLink"/>
	-->
  <xsl:template match="@THREADID" mode="JustLink">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <!--
	<xsl:template match="@THREADID" mode="linktothread">
	Author:		Tom Whitehouse
	Inputs:		-
	Context:    any where @FORUMID is present as an attribute of the parent element
	Purpose:	Generates HREF as F432?thread=175875
	Call:		<xsl:apply-templates select="@THREADID" mode="linktothread"/>
-->
  <xsl:template match="@THREADID" mode="linktothread">
    <xsl:param name="embodiment" select="$m_clickherediscuss"/>
    <xsl:param name="attributes"/>
    <a href="{$root}F{../../@FORUMID}?thread={.}" xsl:use-attribute-sets="maTHREADID_linktothread">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@THREADID" mode="linktolatest">
	Author:		Tom Whitehouse
	Inputs:		-
	Context:    any where @FORUMID is present as an attribute of the parent element
	Purpose:	Generates HREF as F432?thread=175875&latest=1
	Call:		<xsl:apply-templates select="@THREADID" mode="linktolatest"/>
-->
  <xsl:template match="@THREADID" mode="linktolatest">
    <xsl:param name="embodiment">
      <xsl:apply-templates select="../LASTREPLY/DATE"/>
    </xsl:param>
    <xsl:param name="attributes"/>
    <a href="{$root}F{../../@FORUMID}?thread={.}&amp;latest=1" xsl:use-attribute-sets="maTHREADID_linktolatest">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@THREADID" mode="LinkOnSubject">
	Author:		Igor Loboda
	Inputs:		attributes - additional attributes for the link
	Purpose:	Generates link with text taken from SUBJECT and HREF as F432?thread=175875
				If SUBJECT is empty - generates link with "No subject" text
	Call:		<xsl:apply-templates select="@THREADID" mode="LinkOnSubject"/>
	-->
  <xsl:template match="@THREADID" mode="LinkOnSubject">
    <xsl:param name="attributes"/>
    <A xsl:use-attribute-sets="maTHREADID_LinkOnSubject">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>

      <xsl:apply-templates select="." mode="JustLink"/>
      <xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template match="@THREADID" mode="THREADS_MAINBODY">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Generates link with text taken from SUBJECT and HREF as F432?thread=175875
				If SUBJECT is empty - generates link with "No subject" text
	Call:		<xsl:apply-templates select="@THREADID" mode="THREADS_MAINBODY"/>
	-->
  <xsl:template match="@THREADID" mode="THREADS_MAINBODY">
    <A xsl:use-attribute-sets="maTHREADID_THREADS_MAINBODY">
      <xsl:apply-templates select="." mode="JustLink"/>
      <xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template name="ApplyAttributes">
	Author:		Tom Whitehouse/Igor Loboda
	Inputs:		attributes - pairs of name value in form of
							<attribute name="name" value="value"/>
	Context:    -
	Purpose:	Generates <xsl:attributes> element from given parameter
	Call:		<xsl:call-template name="ApplyAttributes"><xsl:with-param name="attributes" select="$attributes"/></xsl:call-template>
	-->
  <xsl:template name="ApplyAttributes">
    <xsl:param name="attributes"/>
    <xsl:for-each select="msxsl:node-set($attributes)/attribute">
      <xsl:attribute name="{@name}">
        <xsl:value-of select="@value"/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template match="@THREADID" mode="LinkOnDatePosted">
	Author:		Igor Loboda
	Inputs:		-
	Context:    any where @FORUMID and DATEPOSTED are present
	Purpose:	Generates link with text representation of DATEPOSTED and 
				HREF as F432?thread=175875&latest=1
	Call:		<xsl:apply-templates select="@THREADID" mode="LinkOnDatePosted"/>
	-->
  <xsl:template match="@THREADID" mode="LinkOnDatePosted">
    <A xsl:use-attribute-sets="maTHREADID_LinkOnDatePosted">
      <xsl:apply-templates select="../@FORUMID" mode="HREF_FTLatest"/>
      <xsl:apply-templates select="../DATEPOSTED"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template match="@FORUMID" mode="THREADS_MAINBODY_Date">
	Author:		Igor Loboda
	Inputs:		-
	Context:    any where @FORUMID and DATEPOSTED are present
	Purpose:	Generates link with text representation of DATEPOSTED and 
				HREF as F432?thread=175875&latest=1
	Call:		<xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY_Date"/>
	-->
  <xsl:template match="@FORUMID" mode="THREADS_MAINBODY_Date">
    <A xsl:use-attribute-sets="maTHREADID_THREADS_MAINBODY_Date">
      <xsl:apply-templates select="." mode="HREF_FTLatest"/>
      <xsl:apply-templates select="../DATEPOSTED"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template match="@THREADID" mode="LinkOnSubjectAB">
	Author:		Igor Loboda/ Tom Whitehouse
	Inputs:		attributes - extra attributes can be added to the a tag by including parameters
				of the form: <attribute name="class" value="darkfont"/>
	Context:    any where @FORUMID and SUBJECT are present
	Purpose:	Generates link with text taken from SUBJECT and HREF as F432?thread=175875
				If SUBJECT is empty - generates link with "<No subject>" text
	Call:		<xsl:apply-templates select="@THREADID" mode="LinkOnSubjectAB"/>
	-->

  <xsl:template match="@THREADID" mode="LinkOnSubjectAB">
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="maTHREADID_LinkOnSubjectAB">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="JustLink"/>
      <xsl:apply-templates select="../SUBJECT" mode="NoSubjectAngleBr"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="DATE" mode="LatestPost">
	Author:		Igor Loboda/ Tom Whitehouse
	Inputs:		attributes - extra attributes can be added to the a tag by including parameters
				of the form: <attribute name="class" value="darkfont"/>
	Context:    any where ../@FORUMID and ../@THREADID are present
	Purpose:	Generates link with text representation of DATE and 
				HREF as F432?thread=175875&latest=1
	Call:		<xsl:apply-templates select="DATE" mode="LatestPost"/>
	-->
  <xsl:template match="DATE" mode="LatestPost">
    <xsl:param name="attributes"/>
    <A xsl:use-attribute-sets="mDATE_LatestPost">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>
        <xsl:variable name="thread" select="../../@THREADID"/>
        <xsl:choose>
          <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_t' and (substring-before(VALUE, '|') = string($thread))]">
            <xsl:text>&amp;date=</xsl:text>
            <xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE, '|') = string($thread)]/VALUE,'|')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&amp;latest=1</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="."/>
    </A>
  </xsl:template>

  <!--
	<xsl:template match="@FORUMID" mode="MoreConv">
	Author:		Igor Loboda
	Inputs:		-
	Context:    -
	Purpose:	Generates "Click here to see more Conversations" link with 
				HREF as F432
	Call:		<xsl:apply-templates select="@FORUMID" mode="MoreConv"/>
	-->
  <xsl:template match="@FORUMID" mode="MoreConv">
    <xsl:param name="content" select="$m_clickmoreconv"/>
    <A xsl:use-attribute-sets="maFORUMID_MoreConv">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>F<xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:copy-of select="$content"/>
    </A>
  </xsl:template>


  <!--
	<xsl:template match="@FORUMID" mode="AddThread">
	Author:		Igor Loboda/ Tom Whitehouse
	Inputs:		img - the embodiment of the link
				attributes - Overwrites the attribute set attributes if required
	Context:    /H2G2/ARTICLE/ARTICLEINFO/H2G2ID should be present in xml
	Purpose:	Generates "Discuss this Entry" link with 
				HREF as AddThread?forum=432&article=4041
	Call:		<xsl:apply-templates select="@FORUMID" mode="AddThread"/>
	-->
  <xsl:template match="@FORUMID" mode="AddThread">
    <xsl:param name="attributes"/>
    <xsl:param name="img">
      <xsl:value-of select="$alt_discussthis"/>
    </xsl:param>
    <A xsl:use-attribute-sets="maForumID_AddThread" href="{$root}AddThread?forum={.}&amp;article={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$img"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template match="H2G2ID" mode="RemoveSelf">
	Author:		Igor Loboda
	Inputs:		-
	Context:    -
	Purpose:	Generates "Remove My Name" link with 
				HREF as UserEdit724042?cmd=RemoveSelf
	Call:		<xsl:apply-templates select="H2G2ID" mode="RemoveSelf"/>
	-->
  <xsl:template match="H2G2ID" mode="RemoveSelf">
    <xsl:param name="img" select="$m_RemoveMeFromResearchersList"/>
    <a xsl:use-attribute-sets="mH2G2ID_RemoveSelf" onclick="return confirm('{$m_ConfirmRemoveSelf}')">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="."/>?cmd=RemoveSelf
      </xsl:attribute>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="@FORUMID" mode="FirstToTalk">
	Author:		Igor Loboda
	Inputs:		-
	Context:    -
	Purpose:	Generates "Click here to be the first person to discuss this entry" 
				link with HREF as AddThread?forum=432
	Call:		<xsl:apply-templates select="@FORUMID" mode="FirstToTalk"/>
	-->
  <xsl:template match="@FORUMID" mode="FirstToTalk">
    <a href="{$root}Addthread?forum={.}" xsl:use-attribute-sets="maFORUMID_FirstToTalk">

      <xsl:value-of select="$m_firsttotalk"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="SUBJECT" mode="NoSubjectAngleBr">
	Author:		Igor Loboda
	Inputs:		-
	Context:    -
	Purpose:	Displays a SUBJECT tag or shows '<No subject>'.
	Call:		<xsl:apply-templates select="SUBJECT" mode="NoSubjectAngleBr">
	-->
  <xsl:template match="SUBJECT" mode="NoSubjectAngleBr">
    <xsl:choose>
      <xsl:when test=".=''">
        &lt;<xsl:value-of select="$m_nosubject"/>&gt;
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="USERID" mode="MorePosts">
	Author:		Igor Loboda
	Inputs:		img - specify image/text to appear as link
	Purpose:	Creates link with text "Click here to see more Conversations"
				and HREF like "MP6"
	Call:		<xsl:apply-templates select="USERID" mode="MorePosts">
	-->
  <xsl:template match="USERID" mode="MorePosts">
    <xsl:param name="img">
      <xsl:value-of select="$m_clickmoreconv"/>
    </xsl:param>
    <a xsl:use-attribute-sets="mUSERID_MorePosts">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>MP<xsl:value-of select="."/>
      </xsl:attribute>

      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="USERID" mode="MorePostsOtherSite">
	Author:		Tom Whitehouse
	Inputs:		content - specify image/text to appear as link
	Purpose:	Creates link with text "Click here to see more Conversations from other sites"
				Only to be used on sites that specifically want this functionality
	Call:		<xsl:apply-templates select="USERID" mode="MorePostsOtherSite">
	-->
  <xsl:template match="USERID" mode="MorePostsOtherSite">
    <xsl:param name="content" select="$m_morepostsothersites"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mUSERID_MorePostsOtherSite" href="{$root}MP{.}?s_omitsiteid=8">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="USERID" mode="MorePostsThisSite">
	Author:		Tom Whitehouse
	Inputs:		content - specify image/text to appear as link
	Purpose:	Creates link with text "Click here to see more Conversations from this site"
				Only to be used on sites that specifically want this functionality
	Call:		<xsl:apply-templates select="USERID" mode="MorePostsOtherSite">
	-->
  <xsl:template match="USERID" mode="MorePostsThisSite">
    <xsl:param name="content" select="$m_morepoststhissite"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mUSERID_MorePostsThisSite" href="{$root}MP{.}?s_includesiteid=8">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="DATE" mode="LastUserPost">
	Author:		Igor Loboda/ Tom Whitehouse
	Inputs:		attributes - extra attributes can be added to the a tag by including parameters
				of the form: <attribute name="class" value="darkfont"/>
	Context		should have ../../@THREADID, ../@POSTID, ../../@FORUMID
	Purpose:	Creates link with text "3 Weeks Ago"
				and HREF like "F19585?thread=168678&post=1865469#p1865469"
	Call:		<xsl:apply-templates select="DATE" mode="LastUserPost"/>
	-->
  <xsl:template match="DATE" mode="LastUserPost">
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mDATE_LastUserPost">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>F<xsl:value-of select="../../../@FORUMID"/>?thread=<xsl:value-of select="../../../@THREADID"/>&amp;post=<xsl:value-of select="../../@POSTID"/>#p<xsl:value-of select="../../@POSTID"/>
      </xsl:attribute>
      <xsl:apply-templates select="."/>
    </a>
  </xsl:template>


  <!--
	<xsl:template match="USERID" mode="Inspect">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates link with text "Inspect this User"
				and HREF like "InspectUser?UserID=6"
	Call:		<xsl:apply-templates select="USERID" mode="Inspect"/>
	-->
  <xsl:template match="USERID" mode="Inspect">
    <xsl:param name="img" select="$m_InspectUser"/>
    <a xsl:use-attribute-sets="mUSERID_Inspect" href="{$root}InspectUser?UserID={.}">
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="POST-LIST" mode="MorePosts">
	Author:		Igor Loboda
	Inputs:		userid - user id
				target - target frame for A element
				linkText - tex for the link
				prev - 1 to generat Previous link otherwise Next one is generated
	Context:    any where @SKIPTO and @COUNT are present
				checks for /H2G2/PARAMS/PARAM[NAME='s_upto']/VALUE
	Purpose:	Generates A with HREF as 
				MP6?skip=0&show=25&s_type=pop&s_upto=&s_target=conversation
	Call:		
				<xsl:apply-templates select="POSTS/POST-LIST" mode="MorePosts">
					<xsl:with-param name="userid" select="$userid"/>
					<xsl:with-param name="target" select="$target"/>
					<xsl:with-param name="linkText">&lt;&lt;<xsl:value-of select="$m_newerpostings"/></xsl:with-param>
					<xsl:with-param name="prev">1</xsl:with-param>
				</xsl:apply-templates>
	-->
  <xsl:template match="POST-LIST" mode="MorePosts">
    <xsl:param name="userid"/>
    <xsl:param name="target"/>
    <xsl:param name="linkText"/>
    <xsl:param name="prev"/>

    <A xsl:use-attribute-sets="mPOST-LIST_MorePosts">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>MP<xsl:value-of select="$userid"/>?show=<xsl:value-of select="@COUNT"/>&amp;skip=<xsl:choose>
          <xsl:when test="$prev = 1">
            <xsl:value-of select="number(@SKIPTO) - number(@COUNT)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="number(@SKIPTO) + number(@COUNT)"/>
          </xsl:otherwise>
        </xsl:choose>&amp;s_type=pop&amp;s_upto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_upto']/VALUE"/>&amp;s_target=<xsl:value-of select="$target"/>
      </xsl:attribute>
      <xsl:copy-of select="$linkText"/>
    </A>
  </xsl:template>

  <!--
	<xsl:template name="UserEditMasthead">
	Author:		Igor Loboda
	Inputs:		-
	Context		looks for introduction article id in /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	Creates link with text "Edit this Page"
				and HREF like "UserEdit6" or "UserEdit?masthead=1" if there is no 
				introducton.
	Call:		<xsl:call-template name="UserEditMasthead">
	-->
  <xsl:template name="UserEditMasthead">
    <xsl:param name="img" select="$alt_editthispage"/>
    <a xsl:use-attribute-sets="nUserEditMasthead">
      <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID">
        <xsl:attribute name="href">
          <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="not(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID)">
        <xsl:attribute name="href">
          <xsl:value-of select="$root"/>UserEdit?masthead=1
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template name="LinkToUserDetails">
	Author:		Tom Whitehouse
	Purpose:	Creates a link to the Userdetails page
	-->
  <xsl:template name="LinkToUserDetails">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment" select="$m_preferencessubject"/>
    <a xsl:use-attribute-sets="nLinkToUserDetails" href="{$root}UserDetails">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="GROUPS">
	Inputs:		-
	Context		-
	Purpose:	applies templates to child elements
	Call:		<xsl:apply-templates select="GROUPS">
	-->
  <xsl:template match="GROUPS">
    <xsl:apply-templates select="EDITOR"/>
    <xsl:apply-templates select="*[not(starts-with(name(), 'PROLIFICSCRIBE'))][not(name() = 'EDITOR')]"/>
    <xsl:apply-templates select="*[starts-with(name(), 'PROLIFICSCRIBE')][position() = last()]"/>
  </xsl:template>

  <!--
	<xsl:template match="USER/GROUPS/*">
	Inputs:		-
	Context		-
	Purpose:	displays badges
	-->
  <xsl:template match="USER/GROUPS/*">
    <xsl:variable name="groupname">
      <xsl:value-of select="name()"/>
    </xsl:variable>
    <xsl:apply-templates select="msxsl:node-set($subbadges)/GROUPBADGE[@NAME = $groupname]"/>
  </xsl:template>

  <!--
	<xsl:template match="GROUPBADGE">
	Inputs:		-
	Context		-
	Purpose:	displays badge
	-->
  <xsl:template match="GROUPBADGE">
    <center>
      <xsl:apply-templates/>
      <br/>
    </center>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK">
	Author:		Igor Loboda
	Inputs:		-
	Context		looks for /H2G2/ARTICLE/GUIDE//LINK 
	Purpose:	Creates entry link with HREF "A4041" which is not filtered out by SITEFILTER
	Call:		<xsl:apply-templates select="ENTRYLINK">
	-->
  <xsl:template match="REFERENCES/ENTRIES/ENTRYLINK">
    <xsl:variable name="id" select="@H2G2"/>
    <xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@DNAID=$id])">
      <xsl:apply-templates select="." mode="UI"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template name="ExLinksNONBBCSites">
	Author:		Igor Loboda
	Inputs:		-
	Context		looks for /H2G2/ARTICLE/GUIDE//LINK and EXTERNALLINK
				see <xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="BBCSitesUI">
	Purpose:	Creates entry link for NON-BBC resource
	Call:		<xsl:call-template name="ExLinksNONBBCSites">
	-->
  <xsl:template name="ExLinksNONBBCSites">
    <xsl:for-each select="EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]">
      <xsl:variable name="id" select="@UINDEX"/>
      <xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=$id])">
        <xsl:apply-templates select="." mode="NONBBCSitesUI"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template name="ExLinksBBCSites">
	Author:		Igor Loboda
	Inputs:		-
	Context		looks for /H2G2/ARTICLE/GUIDE//LINK and EXTERNALLINK
				see <xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="BBCSitesUI">
	Purpose:	Creates entry link for BBC resource
	Call:		<xsl:call-template name="ExLinksBBCSites">
	-->
  <xsl:template name="ExLinksBBCSites">
    <xsl:for-each select="EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]">
      <xsl:variable name="id" select="@UINDEX"/>
      <xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=$id])">
        <xsl:apply-templates select="." mode="BBCSitesUI"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/USERS/USERLINK">
	Author:		Igor Loboda
	Inputs:		-
	Context		looks for /H2G2/ARTICLE/GUIDE//LINK 
	Purpose:	Creates entry link with HREF "U6" which is not filtered out by SITEFILTER
	Call:		<xsl:apply-templates select="USERLINK">
	-->
  <xsl:template match="REFERENCES/USERS/USERLINK">
    <xsl:variable name="id" select="@H2G2"/>
    <xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@BIO=$id])">
      <xsl:apply-templates select="." mode="UI"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="/H2G2/HELP" mode="WritingGE">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates entry "Click here for help on how to write your Entry" link
	Call:		<xsl:apply-templates select="/H2G2/HELP"  mode="WritingGE">
	-->
  <xsl:template match="/H2G2/HELP" mode="WritingGE">
    <a xsl:use-attribute-sets="mHELP_WritingGE">
      <xsl:attribute name="HREF">
        <xsl:choose>
          <xsl:when test="/H2G2/HELP[@TOPIC='GuideML']">
            <xsl:value-of select="$m_WritingGuideMLHelpLink"/>
          </xsl:when>
          <xsl:when test="/H2G2/HELP[@TOPIC='PlainText']">
            <xsl:value-of select="$m_WritingPlainTextHelpLink"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$alt_clickherehelpentry"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template name="SelectSkin">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates drop down with the list of skins
	Call:		<xsl:call-template name="SelectSkin">
	-->
  <xsl:template name="SelectSkin">
    <SELECT NAME="skin">
      <xsl:call-template name="skindropdown"/>
    </SELECT>
  </xsl:template>

  <!--
	<xsl:template match="SUBMITTABLE">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates Not-For-Review check box
	Call:		<xsl:apply-templates select="SUBMITTABLE">
	-->
  <xsl:template match="SUBMITTABLE">
    <INPUT TYPE="CHECKBOX" NAME="NotForReview" VALUE="1">
      <xsl:if test="number(.) = 0">
        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
      </xsl:if>
    </INPUT>
    <INPUT TYPE="HIDDEN" NAME="CanSubmit" VALUE="1"/>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="HiddenInputs">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates set of hidden inputs:h2g2id, masthead, format, cmd
	Call:		<xsl:apply-templates select="." mode="HiddenInputs">
	-->
  <xsl:template match="ARTICLE-EDIT-FORM" mode="HiddenInputs">
    <INPUT TYPE="hidden" NAME="id">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="H2G2ID"/>
      </xsl:attribute>
    </INPUT>
    <INPUT TYPE="hidden" NAME="masthead">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="MASTHEAD"/>
      </xsl:attribute>
    </INPUT>
    <INPUT TYPE="hidden" NAME="format">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="FORMAT"/>
      </xsl:attribute>
    </INPUT>
    <INPUT TYPE="hidden" NAME="cmd" VALUE="submit"/>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="Subject">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Creates an input field with article subject
	Call:		<xsl:apply-templates select="." mode="Subject">
	-->
  <xsl:template match="ARTICLE-EDIT-FORM" mode="Subject">
    <INPUT NAME="subject" xsl:use-attribute-sets="iArticleSubject">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="SUBJECT"/>
      </xsl:attribute>
    </INPUT>
  </xsl:template>

  <!--
	<xsl:template match="FUNCTIONS/ADDENTRY">
	Author:		Igor Loboda
	Inputs:		-
	Context		tests /H2G2/ARTICLE-EDIT-FORM/MASTHEAD value
	Purpose:	Creates Add-Introduction or Add-Entry button
	Call:		<xsl:apply-templates select="FUNCTIONS/ADDENTRY">
	-->
  <xsl:template match="FUNCTIONS/ADDENTRY">
    <INPUT NAME="addentry" xsl:use-attribute-sets="iAddEntry">
      <xsl:choose>
        <xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD[.='1']">
          <xsl:attribute name="VALUE">
            <xsl:value-of select="$m_addintroduction"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="VALUE">
            <xsl:value-of select="$m_addguideentry"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </INPUT>
  </xsl:template>

  <!--
	<xsl:template match="FUNCTIONS/UPDATE">
	Author:		Igor Loboda
	Inputs:		-
	Context		tests /H2G2/ARTICLE-EDIT-FORM/MASTHEAD value
	Purpose:	Creates Update-Introduction or Update-Entry button
	Call:		<xsl:apply-templates select="FUNCTIONS/UPDATE">
	-->
  <xsl:template match="FUNCTIONS/UPDATE">
    <INPUT NAME="update" xsl:use-attribute-sets="iUpdateEntry">
      <xsl:choose>
        <xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD[.='1']">
          <xsl:attribute name="VALUE">
            <xsl:value-of select="$m_updateintroduction"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="VALUE">
            <xsl:value-of select="$m_updateentry"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </INPUT>
  </xsl:template>

  <!--
	<xsl:template match="FORMAT" mode="GuideMLOrOther">
	Author:		Igor Loboda
	Inputs:		-
	Context		tests /H2G2/ARTICLE-EDIT-FORM/MASTHEAD value
	Purpose:	Creates set of two radiobuttons for Plain-Text and GuideML formats
	Call:		<xsl:apply-templates select="FORMAT" mode="GuideMLOrOther">
	-->
  <xsl:template match="FORMAT" mode="GuideMLOrOther">
    <xsl:choose>
      <xsl:when test=".='1'">
        <INPUT TYPE="radio" NAME="newformat" VALUE="2"/>
        <xsl:value-of select="$m_plaintext"/>
        <INPUT TYPE="radio" NAME="newformat" VALUE="1" CHECKED="yes"/>
        <xsl:value-of select="$m_guideml"/>
      </xsl:when>
      <xsl:when test=".='2'">
        <INPUT TYPE="radio" NAME="newformat" VALUE="2" CHECKED="yes"/>
        <xsl:value-of select="$m_plaintext"/>
        <INPUT TYPE="radio" NAME="newformat" VALUE="1"/>
        <xsl:value-of select="$m_guideml"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="MustSaveFirst">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Writes:"None of your changes will take effect until you press the 
					Update Introduction button."
	Call:		<xsl:apply-templates select="." mode="MustSaveFirst">
	-->
  <xsl:template match="ARTICLE-EDIT-FORM" mode="MustSaveFirst">
    <xsl:value-of select="$m_noneofthese"/>
    <xsl:apply-templates select="." mode="ButtonName"/>
    <xsl:value-of select="$m_button"/>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="ButtonName">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Writes button name (e.i. Update-Introduction or Update-Entry)
	Call:		<xsl:apply-templates select="." mode="ButtonName">
	-->
  <xsl:template match="ARTICLE-EDIT-FORM" mode="ButtonName">
    <xsl:choose>
      <xsl:when test="MASTHEAD[.='1']">
        <xsl:choose>
          <xsl:when test="FUNCTIONS/ADDENTRY">
            <xsl:value-of select="$m_addintroduction"/>
          </xsl:when>
          <xsl:when test="FUNCTIONS/UPDATE">
            <xsl:value-of select="$m_updateintroduction"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_updateintroduction"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="FUNCTIONS/ADDENTRY">
            <xsl:value-of select="$m_addguideentry"/>
          </xsl:when>
          <xsl:when test="FUNCTIONS/UPDATE">
            <xsl:value-of select="$m_updateentry"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_updateentry"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="USER-LIST" mode="Researchers">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Makes list of researchers with limitation on the length of the name
				and limitation the number of items in the list. Names are presented in the
				form of 
					IL 192271 (U192271)
					Researcher 192270 (U192270)
	Call:		<xsl:apply-templates select="USER-LIST" mode="Researchers">
	-->
  <xsl:template match="USER-LIST" mode="Researchers">
    <xsl:param name="delimiter">
      <BR/>
    </xsl:param>

    <xsl:variable name="MaxResearchersShown">10</xsl:variable>
    <xsl:variable name="MaxUsernameChars">20</xsl:variable>

    <xsl:for-each select="USER">
      <xsl:sort select="USERNAME" data-type="text" order="ascending"/>
      <xsl:choose>
        <xsl:when test="string-length(USERNAME) &gt; $MaxUsernameChars">
          <xsl:value-of select="substring(USERNAME, 1, $MaxUsernameChars - 3)"/>...
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="USERNAME"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> (U</xsl:text><xsl:value-of select="USERID"/>)
      <xsl:copy-of select="$delimiter"/>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template match="USER-LIST" mode="EditResearchers">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Makes list of researchers ides in the
				form of 192271,192270,
	Call:		<xsl:apply-templates select="USER-LIST" mode="EditResearchers">
	-->
  <xsl:template match="USER-LIST" mode="EditResearchers">
    <xsl:param name="delimiter">
      <xsl:text>,</xsl:text>
    </xsl:param>
    <xsl:for-each select="USER">
      <xsl:sort select="USERNAME" data-type="text" order="ascending"/>
      <xsl:value-of select="USERID"/>
      <xsl:copy-of select="$delimiter"/>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template match="FUNCTIONS/ADDENTRY" mode="Form">
	Author:		Igor Loboda
	Inputs:		-
	Context		tests /H2G2/ARTICLE-EDIT-FORM/MASTHEAD value
	Purpose:	Creates set of hidden inputs to store and submit information 
				required for Delete-Article operation and also makes 
				Delete-Article button
	Call:		<xsl:apply-templates select="FUNCTIONS/ADDENTRY" mode="Form">
	-->
  <xsl:template match="FUNCTIONS/DELETE" mode="Form">
    <FORM METHOD="post" action="{$root}Edit" ONSUBMIT="return confirm('{$m_ConfirmDeleteEntry}')">
      <INPUT TYPE="hidden" NAME="id">
        <xsl:attribute name="VALUE">
          <xsl:value-of select="/H2G2/ARTICLE-EDIT-FORM/H2G2ID"/>
        </xsl:attribute>
      </INPUT>
      <INPUT TYPE="hidden" NAME="masthead">
        <xsl:attribute name="VALUE">
          <xsl:value-of select="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD"/>
        </xsl:attribute>
      </INPUT>
      <INPUT TYPE="hidden" NAME="cmd" VALUE="delete"/>
      <INPUT NAME="button" xsl:use-attribute-sets="iDeleteArticle"/>
    </FORM>
  </xsl:template>

  <!--
	<xsl:template match="FUNCTIONS/HIDE">
	Author:		Igor Loboda
	Inputs:		-
	Context		-
	Purpose:	Makes Hide-Entry check box
	Call:		<xsl:apply-templates select="FUNCTIONS/HIDE">
	-->
  <xsl:template match="FUNCTIONS/HIDE">
    <input type="checkbox" name="Hide" value="1">
      <xsl:if test="number(HIDDEN) = 1">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
    </input>
  </xsl:template>
  <!--
	<xsl:template name="articlecancelled">
	Author:		Tom Whitehouse
	Context:	Called from any element who has a STATUS child
	Purpose:	Returns a string (true or false) that indicates whether the article has been cancelled or not 
-->
  <xsl:template name="articlecancelled">
    <xsl:value-of select="STATUS=7"/>
  </xsl:template>
  <!--
	<xsl:template name="articlepending">
	Author:		Tom Whitehouse
	Context:	Called from any element who has a STATUS child
	Purpose:	Returns a string (true or false) that indicates whether the article is pending or not 
-->
  <xsl:template name="articlepending">
    <xsl:value-of select="STATUS = 13 or STATUS = 6"/>
  </xsl:template>
  <!--
	<xsl:template name="articlenotcancelled">
	Author:		Tom Whitehouse
	Context:	Called from any element who has a STATUS child
	Purpose:	Returns a string (true or false) that indicates whether the article has not been cancelled  
-->
  <xsl:template name="articlenotcancelled">
    <xsl:value-of select="STATUS &gt; 3 and STATUS != 7"/>
  </xsl:template>
  <!--
	<xsl:template name="articleeditable">
	Author:		Tom Whitehouse
	Context:	Called from any element who has a STATUS child
	Purpose:	Returns a string (true or false) that indicates whether the article is editable by the viewing user  
-->

  <xsl:template name="articleeditable">
    <xsl:value-of select="($ownerisviewer = 1) and (STATUS = 3 or STATUS = 4) and (EDITOR/USER/USERID = $viewerid)"/>
  </xsl:template>
  <!--
	<xsl:template match="USERID" mode="clickformore">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	Context is USERID
	Purpose:	Presents a link to view more entries by the user 
-->
  <xsl:template match="USERID" mode="clickformore">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment" select="$m_clickmoreentries"/>
    <a href="{$root}MA{.}?type=2" xsl:use-attribute-sets="mUSERID_clickformore">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="USERID" mode="MoreArticlesThisSite">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	Context is USERID
	Purpose:	Presents a link to view more entries from the present site 
				Only to be used on sites that specifically want this functionality
-->
  <xsl:template match="USERID" mode="MoreArticlesThisSite">
    <xsl:param name="attributes"/>
    <xsl:param name="content" select="$m_morearticlesthissite"/>
    <a href="{$root}MA{.}?type=2&amp;s_includesiteid=8" xsl:use-attribute-sets="mUSERID_MoreArticlesThisSite">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$content"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="USERID" mode="MoreArticlesOtherSite">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	Context is USERID
	Purpose:	Presents a link to view more entries from other sites 
				Only to be used on sites that specifically want this functionality
-->
  <xsl:template match="USERID" mode="MoreArticlesOtherSite">
    <xsl:param name="attributes"/>
    <xsl:param name="content" select="$m_morearticlesothersites"/>
    <a href="{$root}MA{.}?type=2&amp;s_omitsiteid=8" xsl:use-attribute-sets="mUSERID_MoreArticlesOtherSite">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$content"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template name="createnewentry">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	No Context, can be called from anywhere
	Purpose:	Presents a link to useredit
-->
  <xsl:template name="createnewentry">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment" select="$m_clicknewentry"/>
    <a href="{$root}useredit" xsl:use-attribute-sets="ncreatenewentry">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="H2G2-ID" mode="recententries">
	Author:		Tom Whitehouse
	Inputs:		attributes - overwrites the attribute set attributes if required
	Purpose:	Presents a link to the context article, ie A 634233  
-->
  <xsl:template match="H2G2-ID" mode="recententries">
    <xsl:param name="embodiment" select="concat('A', .)"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mH2G2-ID_recententries" href="{$root}A{.}">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:value-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="H2G2-ID" mode="UserEdit">
	Author:		Tom Whitehouse
	Inputs:		attributes - overwrites the attribute set attributes if required
				embodiment - The embodiment of the link
	Purpose:	Presents a link to edit the context article
-->
  <xsl:template match="H2G2-ID" mode="UserEdit">
    <xsl:param name="embodiment" select="$m_edit"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mH2G2-ID_UserEdit" href="{$root}UserEdit{.}">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="H2G2-ID" mode="UserEditUndelete">
	Author:		Tom Whitehouse
	Inputs:		attributes - overwrites the attribute set attributes if required
				embodiment - The embodiment of the link
	Purpose:	Presents a link to uncancel the context article
-->
  <xsl:template match="H2G2-ID" mode="UserEditUndelete">
    <xsl:param name="embodiment" select="$m_uncancel"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mH2G2-ID_UserEditUndelete" href="{$root}UserEdit{.}?cmd=undelete">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="JOURNALPOSTS" mode="clickformorejournals">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	Context is USERID
	Purpose:	Presents a link to view more Journal entries from the user 
-->
  <xsl:template match="JOURNALPOSTS" mode="clickformorejournals">
    <xsl:param name="embodiment" select="$m_clickmorejournal"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="mJOURNALPOSTS_clickformorejournals">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>MJ<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="@FORUMID"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;skip=<xsl:value-of select="number(@SKIPTO) + number(@COUNT)"/>
      </xsl:attribute>
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template name="createnewjournalentry">
	Author:		Tom Whitehouse
	Inputs:		attributes (overwrites the attribute set attributes if required) and embodiment
	Context:	No Context, can be called from anywhere
	Purpose:	Presents a link to PostJournal
-->
  <xsl:template name="createnewjournalentry">
    <xsl:param name="embodiment" select="$m_clickaddjournal"/>
    <xsl:param name="attributes"/>
    <a xsl:use-attribute-sets="ncreatenewjournalentry" href="{$root}PostJournal">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="@POSTID" mode="CreateAnchor">
	Author:		Tom Whitehouse
	Purpose:	Creates the link anchor to make it possible to link between different threads in a conversation
	Call:		<xsl:apply-templates select="@POSTID" mode="CreateAnchor"/>
-->
  <xsl:template match="@POSTID" mode="CreateAnchor">
    <a name="p{.}"/>
  </xsl:template>
  <!--
	<xsl:template match="@HIDDEN" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the user complaint link
	Purpose:	Creates a link to the UserComplaint popup page
-->
  <xsl:template match="@HIDDEN" mode="multiposts">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment">
      <img width="14" height="15" src="{$imagesource}buttons/complain.gif" border="0" alt="{$alt_complain}"/>
    </xsl:param>
    <a href="/dna/h2g2/{translate(/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/NAME,$uppercase,$lowercase)}comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('/dna/h2g2/{translate(/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/NAME,$uppercase,$lowercase)}comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=660,height=500')" xsl:use-attribute-sets="maHIDDEN_multiposts">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@POSTID" mode="editpost">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the user complaint link
	Purpose:	Creates a link to the Edit Post page
-->
  <xsl:template match="@POSTID" mode="editpost">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment" select="$m_editpost"/>
    <a href="{$root}EditPost?PostID={.}" target="_top" onClick="popupwindow('{$root}EditPost?PostID={.}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;" xsl:use-attribute-sets="maPOSTID_editpost">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@POSTID" mode="moderation">
	Author:		Tom Whitehouse
	Context		Called from POST
	Purpose:	Creates a link to the Moderation History page page
-->
  <xsl:template match="@POSTID" mode="moderation">
    <a target="_top" href="{$root}ModerationHistory?PostID={.}" xsl:use-attribute-sets="maPOSTID_moderation">
      <xsl:value-of select="$m_moderationhistory"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@POSTID" mode="ReplyToPost">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the Reply link
	Purpose:	Creates the 'Reply to this entry' link
-->
  <xsl:template match="@POSTID" mode="ReplyToPost">
    <xsl:param name="attributes"/>
    <xsl:param name="embodiment" select="$m_replytothispost"/>
    <a href="{$root}AddThread?inreplyto={.}" target="_top" xsl:use-attribute-sets="maPOSTID_ReplyToPost">
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@FIRSTCHILD" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the link
	Purpose:	Creates the 'Read the first reply to this entry' link
-->
  <xsl:template match="@FIRSTCHILD" mode="multiposts">
    <xsl:param name="embodiment" select="$m_firstreplytothis"/>
    <xsl:param name="ptype"/>
    <xsl:param name="attributes"/>
    <xsl:choose>
      <xsl:when test="../../POST[@POSTID = current()]">
        <a href="#p{.}" xsl:use-attribute-sets="maFIRSTCHILD_multiposts1">
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:copy-of select="$embodiment"/>
        </a>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$root}F{../../@FORUMID}?thread={../../@THREADID}&amp;post={../@FIRSTCHILD}#p{../@FIRSTCHILD}" xsl:use-attribute-sets="maFIRSTCHILD_multiposts2">
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:if test="$ptype='frame'">
            <xsl:attribute name="target">_top</xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
	<xsl:template match="@INREPLYTO" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the link
				ptype - if ptype is set to frame, it will adjust the href values to point to the appropriate frame
	Purpose:	Creates the 'This is a reply to' link
-->
  <xsl:template match="@INREPLYTO" mode="multiposts">
    <xsl:param name="embodiment" select="$m_thispost"/>
    <xsl:param name="attributes"/>
    <xsl:param name="ptype"/>
    <xsl:choose>
      <xsl:when test="../../POST[@POSTID = .]">
        <a xsl:use-attribute-sets="maINREPLYTO_multiposts1">
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/><xsl:choose>
              <xsl:when test="$ptype='frame'">FFM</xsl:when>
              <xsl:otherwise>F</xsl:otherwise>
            </xsl:choose><xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;skip=<xsl:value-of select="../../@SKIPTO"/>&amp;show=<xsl:value-of select="../../@COUNT"/>#p<xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a xsl:use-attribute-sets="maINREPLYTO_multiposts2" href="{$root}F{../../@FORUMID}?thread={../../@THREADID}&amp;post={.}#p{.}">
          <xsl:if test="$ptype='frame'">
            <xsl:attribute name="target">_top</xsl:attribute>
          </xsl:if>
          <xsl:call-template name="ApplyAttributes">
            <xsl:with-param name="attributes" select="$attributes"/>
          </xsl:call-template>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
	<xsl:template match="USERNAME" mode="multiposts">
	Author:		Tom Whitehouse
	Purpose:	Creates a link to the author of a post on the MULTIPOSTS page
-->
  <xsl:template match="USERNAME" mode="multiposts">
    <a target="_top" href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_multiposts">
      <xsl:apply-templates select="."/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="@FORUMID" mode="returntothreads">
	Author: Tom Whitehouse
	Purpose: Provides a link to a threads page from a multiposts page

-->
  <xsl:template match="@FORUMID" mode="returntothreads">
    <xsl:param name="embodiment" select="$m_returntothreadspage"/>
    <a href="{$root}F{.}?showthread={../@THREADID}" xsl:use-attribute-sets="maFORUMID_returntothreads">
      <xsl:copy-of select="$embodiment"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="POST" mode="postnumber">
	Author:		Tom Whitehouse
	Purpose:	Creates the 'Post 3' text
-->
  <xsl:template match="POST" mode="postnumber">
    <xsl:value-of select="$m_postnumber"/>
    <xsl:value-of select="count(preceding-sibling::POST) + 1 + number(../@SKIPTO)"/>
  </xsl:template>
  <!--
	<xsl:template match="@NEXTINDEX" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		embodiment - the text/ image used to embody the link
				ptype - if ptype is set to frame, it will adjust the href values to point to the appropriate frame
	Purpose:	Creates the 'view next posting' link
-->
  <xsl:template match="@NEXTINDEX" mode="multiposts">
    <xsl:param name="ptype"/>
    <xsl:param name="embodiment" select="$m_next"/>
    <xsl:choose>
      <xsl:when test="../../POST/@POSTID = .">
        <a href="#p{.}" xsl:use-attribute-sets="maNEXTINDEX_multiposts1">
          <xsl:call-template name="nextindexattributes"/>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a xsl:use-attribute-sets="maNEXTINDEX_multiposts2">
          <xsl:call-template name="nextindexattributes"/>
          <xsl:if test="$ptype='frame'">
            <xsl:attribute name="target">_top</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;post=<xsl:value-of select="../@NEXTINDEX"/>#p<xsl:value-of select="../@NEXTINDEX"/>
          </xsl:attribute>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
	<xsl:template match="@NEXTINDEX" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		embodiment - the text/ image used to embody the link
				ptype - if ptype is set to frame, it will adjust the href values to point to the appropriate frame
	Purpose:	Creates the 'view previous posting' link
-->
  <xsl:template match="@PREVINDEX" mode="multiposts">
    <xsl:param name="ptype"/>
    <xsl:param name="embodiment" select="$m_prev"/>
    <xsl:choose>
      <xsl:when test="../../POST/@POSTID = .">
        <a href="#p{.}" xsl:use-attribute-sets="maPREVINDEX_multiposts1">
          <xsl:call-template name="previndexattributes"/>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a xsl:use-attribute-sets="maPREVINDEX_multiposts2">
          <xsl:call-template name="previndexattributes"/>
          <xsl:if test="$ptype='frame'">
            <xsl:attribute name="target">_top</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="href">
            <xsl:value-of select="$root"/><xsl:choose>
              <xsl:when test="$ptype='frame'">F</xsl:when>
              <xsl:otherwise>F</xsl:otherwise>
            </xsl:choose><xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;post=<xsl:value-of select="../@PREVINDEX"/>#p<xsl:value-of select="../@PREVINDEX"/>
          </xsl:attribute>
          <xsl:copy-of select="$embodiment"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="POST" mode="imageName">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		text - Creates the identifier text for each anchor - eg 'ArrowUp'
	Purpose:	Counts the number of preceding sibling POSTS (can`t use position() as its being called from its child)
-->
  <xsl:template match="POST" mode="imageName">
    <xsl:param name="text" select="'ArrowUp'"/>
    <xsl:value-of select="concat($text, (count(preceding-sibling::POST) + 1))"/>
  </xsl:template>
  <xsl:template name="nextindexattributes"/>
  <xsl:template name="previndexattributes"/>

  <!--
<xsl:template match="POSTTHREADFORM" mode="HiddenInputs">
Author:		Igor Loboda
Context:    -
Purpose:	Creates hidden fields with ThreadID, ForumID, InReplyTo
Call:		<xsl:apply-templates select="." mode="HiddenInputs">
-->
  <xsl:template match="POSTTHREADFORM" mode="HiddenInputs">
    <INPUT TYPE="HIDDEN" NAME="threadid">
      <xsl:attribute name="value">
        <xsl:value-of select="@THREADID"/>
      </xsl:attribute>
    </INPUT>
    <INPUT TYPE="HIDDEN" NAME="forum">
      <xsl:attribute name="value">
        <xsl:value-of select="@FORUMID"/>
      </xsl:attribute>
    </INPUT>
    <INPUT TYPE="HIDDEN" NAME="inreplyto">
      <xsl:attribute name="value">
        <xsl:value-of select="@INREPLYTO"/>
      </xsl:attribute>
    </INPUT>
  </xsl:template>

  <!--
	<xsl:template match="PREVIEWBODY">
	Generic:	Yes
	Purpose:	Display the body of the preview
-->
  <xsl:template match="PREVIEWBODY">
    <xsl:apply-templates/>
  </xsl:template>

  <!--
<xsl:template match="PREVIEWERROR">
Author:		Igor Loboda
Context:    -
Purpose:	Displays preview error information
Call:		<xsl:apply-templates select="PREVIEWERROR">
-->
  <xsl:template match="PREVIEWERROR">
    <xsl:choose>
      <xsl:when test="@TYPE = 'TOOLONG'">
        <xsl:value-of select="$m_postingtoolong"/>
      </xsl:when>
      <xsl:when test="@TYPE = 'TOOMANYSMILEYS'">
        <xsl:value-of select="$m_PostTooManySmileys"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="POSTTHREADFORM" mode="ReturnTo">
Author:		Igor Loboda
Context:    -
Purpose:	Displays link with text
			"Click here to return to the Conversation without saying anything"
			or "Click here to return to the Article without saying anything"
Call:		<xsl:apply-templates select="POSTTHREADFORM" mode="ReturnTo">
-->
  <xsl:template match="POSTTHREADFORM" mode="ReturnTo">
    <xsl:choose>
      <xsl:when test="RETURNTO">
        <xsl:apply-templates select="RETURNTO"/>
      </xsl:when>
      <xsl:when test="@INREPLYTO &gt; 0">
        <xsl:apply-templates select="@FORUMID" mode="ReturnToConv"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@FORUMID" mode="ReturnToConv1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="ReturnToConv1">
Author:		Igor Loboda
Context:    -
Purpose:	Displays link with text 
			"Click here to return to the Conversation without saying anything"
			and HREF F1234
Call:		<xsl:apply-templates select="@FORUMID" mode="ReturnToConv1">
-->
  <xsl:template match="@FORUMID" mode="ReturnToConv1">
    <A xsl:use-attribute-sets="maFORUMID_ReturnToConv1">
      <xsl:apply-templates select="." mode="HREF_F"/>
      <xsl:value-of select="$m_returntoconv"/>
    </A>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="ReturnToConv">
Author:		Igor Loboda
Context:    -
Purpose:	Displays link with text 
			"Click here to return to the Conversation without saying anything"
			and HREF F1234?threadid=1123&post=35#35
Call:		<xsl:apply-templates select="@FORUMID" mode="ReturnToConv">
-->
  <xsl:template match="@FORUMID" mode="ReturnToConv">
    <A xsl:use-attribute-sets="maFORUMID_ReturnToConv">
      <xsl:apply-templates select="." mode="HREF_FTP"/>
      <xsl:value-of select="$m_returntoconv"/>
    </A>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_F">
Author:		Igor Loboda
Context:    -
Purpose:	Creates HREF attribute F1234
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_F">
-->
  <xsl:template match="@FORUMID" mode="HREF_F">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_FTP">
Author:		Igor Loboda
Context:    -
Purpose:	Creates HREF attribute F1234?threadid=1123&post=35#35
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_FTP">
-->
  <xsl:template match="@FORUMID" mode="HREF_FTP">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="../@INREPLYTO"/>#p<xsl:value-of select="../@INREPLYTO"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="USERID" mode="UserName">
Author:		Igor Loboda
Context:    -
Purpose:	Creates link with user name as text and U12341 as HREF
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_FTP">
-->
  <xsl:template match="USERID" mode="UserName">
    <xsl:param name="useFont">1</xsl:param>
    <xsl:element name="A" use-attribute-sets="mUSERID_UserName">
      <xsl:apply-templates select="." mode="HREF_U"/>
      <xsl:if test="$useFont = 1">
        <span xsl:use-attribute-sets="mUSERID_UserName_Name">
          <xsl:apply-templates select="../USERNAME"/>
        </span>
      </xsl:if>
      <xsl:if test="$useFont != 1">
        <xsl:apply-templates select="../USERNAME"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <!--
<xsl:template match="BODY">

Generic:	???
Purpose:	Handles the BODY tag
			Possibly needs overriding
-->
  <xsl:template match="BODY">
    <xsl:apply-templates/>
  </xsl:template>

  <!--
<xsl:template match="USERID" mode="HREF_U">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like U1234
Call:		<xsl:apply-templates select="USERID" mode="HREF_U">
-->
  <xsl:template match="USERID | @USERID" mode="HREF_U">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>U<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="POSTTHREADFORM" mode="Subject">
Author:		Igor Loboda
Context:    -
Purpose:	Generates input field with post subject in it
Call:		<xsl:apply-templates select="POSTTHREADFORM" mode="Subject">
-->
  <xsl:template match="POSTTHREADFORM" mode="Subject">
    <INPUT xsl:use-attribute-sets="iPOSTTHREADFORM_Subject">
      <xsl:attribute name="VALUE">
        <xsl:value-of select="SUBJECT"/>
      </xsl:attribute>
    </INPUT>
  </xsl:template>

  <!--
<xsl:template name="postpremoderationmessage">
Author:		Igor Loboda
Context:    -
Purpose:	Generates either "Your are premoderated" or "Site is premoderated"
			message
Call:		<xsl:call-template name="postpremoderationmessage">
-->
  <xsl:template name="postpremoderationmessage">
    <xsl:choose>
      <xsl:when test="PREMODERATION[@USER=1]">
        <xsl:call-template name="PostYouArePremoderated"/>
      </xsl:when>
      <xsl:when test="PREMODERATION=1">
        <xsl:call-template name="PostSiteIsPremod"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="RETURNTO/H2G2ID">
	Generic:	Yes
	Purpose:	Displays a 'return' link on the forum posting page
-->
  <xsl:template match="RETURNTO/H2G2ID">
    <A xsl:use-attribute-sets="mRETURNTOH2G2ID">
      <xsl:apply-templates select="." mode="HREF_A"/>
      <xsl:value-of select="$m_returntoentry"/>
    </A>
  </xsl:template>

  <!--
<xsl:template match="H2G2ID" mode="HREF_A">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like A234534
Call:		<xsl:apply-templates select="H2G2ID" mode="HREF_A">
-->
  <xsl:template match="H2G2ID" mode="HREF_A">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>A<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <!--
<xsl:template match="TOP-FIVE-ARTICLE" mode="generic">
Author:		Tom Whitehouse

Purpose:	Generates TOP FIVE link

-->
  <xsl:template match="TOP-FIVE-ARTICLE" mode="generic">
    <a xsl:use-attribute-sets="mTOP-FIVE-ARTICLE_generic" href="{$root}A{H2G2ID}">
      <xsl:value-of select="SUBJECT"/>
    </a>
  </xsl:template>
  <xsl:template match="TOP-FIVE-FORUM" mode="generic">
    <a xsl:use-attribute-sets="mTOP-FIVE-FORUM_generic" href="{$root}F{FORUMID}">
      <xsl:value-of select="SUBJECT"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="REGISTER-PASSTHROUGH">
Context:    -
Purpose:	-
Call:		<xsl:apply-templates select="REGISTER-PASSTHROUGH">
-->
  <xsl:template match="REGISTER-PASSTHROUGH">
    <INPUT TYPE="HIDDEN" NAME="pa" VALUE="{@ACTION}"/>
    <xsl:for-each select="PARAM">
      <INPUT TYPE="HIDDEN" NAME="pt" VALUE="{@NAME}"/>
      <INPUT TYPE="HIDDEN" NAME="{@NAME}" VALUE="{.}"/>
    </xsl:for-each>
  </xsl:template>

  <!--
<xsl:template name="register-mainerror">
Context:    must have @STATUS
Purpose:	displays registration/login error message
Param:		delimiter - will be placed after the message
Call:		<xsl:call-template name="register-mainerror">
-->
  <xsl:template name="register-mainerror">
    <xsl:param name="delimiter">
      <br/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="@STATUS='NOLOGINNAME'">
        <xsl:value-of select="$m_invalidloginname"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='NOPASSWORD'">
        <xsl:value-of select="$m_invalidpassword"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='UNMATCHEDPASSWORDS'">
        <xsl:value-of select="$m_unmatchedpasswords"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='LOGINFAILED'">
        <xsl:value-of select="$m_loginfailed"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='LOGINUSED'">
        <xsl:value-of select="$m_loginused"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='NOTERMS'">
        <xsl:value-of select="$m_mustagreetoterms"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='HASHFAILED'">
        <xsl:value-of select="$m_problemwithreg"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='NOCONNECTION'">
        <xsl:copy-of select="$m_noconnectionerror"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='INVALIDPASSWORD'">
        <xsl:value-of select="$m_invalidbbcpassword"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='INVALIDUSERNAME'">
        <xsl:value-of select="$m_invalidbbcusername"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='INVALIDEMAIL'">
        <xsl:value-of select="$m_invalidEmail"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
      <xsl:when test="@STATUS='UIDUSED'">
        <xsl:value-of select="$m_uidused"/>
        <xsl:copy-of select="$delimiter"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER" mode="HiddenInputsNormal">
Author:		Igor Loboda
Context:    -
Purpose:	Generates hidden fields for register page
Call:		<xsl:apply-templates select="USENEWREGISTERRID" mode="HiddenInputsNormal">
-->
  <xsl:template match="NEWREGISTER" mode="HiddenInputsNormal">
    <INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="normal"/>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER" mode="HiddenInputsFasttrack">
Author:		Igor Loboda
Context:    -
Purpose:	Generates hidden fields for login page
Call:		<xsl:apply-templates select="USENEWREGISTERRID" mode="HiddenInputsFasttrack">
-->
  <xsl:template match="NEWREGISTER" mode="HiddenInputsFasttrack">
    <INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
    <INPUT TYPE="HIDDEN" NAME="cmd" VALUE="fasttrack"/>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM" mode="Subject">
Author:		Igor Loboda
Context:    -
Purpose:	Generates input field with post subject in it
Call:		<xsl:apply-templates select="." mode="Subject">
-->
  <xsl:template match="POSTJOURNALFORM" mode="Subject">
    <input name="subject" type="text" xsl:use-attribute-sets="asiPOSTJOURNALFORM_Subject">
      <xsl:attribute name="value">
        <xsl:value-of select="SUBJECT"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM" mode="Body">
Author:		Igor Loboda
Context:    -
Purpose:	Generates textarea for post text input
Call:		<xsl:apply-templates select="." mode="Body">
-->
  <xsl:template match="POSTJOURNALFORM" mode="Body">
    <textarea xsl:use-attribute-sets="astaPOSTJOURNALFORM_Body" name="body">
      <xsl:value-of select="BODY"/>
    </textarea>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="HiddenInputs">
Author:		Igor Loboda
Context:    -
Purpose:	Generates a number of hidden inputs 
Call:		<xsl:apply-templates select="." mode="HiddenInputs">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="HiddenInputs">
    <input name="cmd" type="hidden" value="submit"/>

    <xsl:if test="not($changeableskins)">
      <input type="hidden" name="PrefSkin" value="{$skinname}"/>
    </xsl:if>

    <xsl:if test="not($expertmode)">
      <input type="hidden" name="PrefUserMode" value="{PREFERENCES/USER-MODE}"/>
    </xsl:if>


    <xsl:if test="not($framesmode)">
      <input type="hidden" name="PrefForumStyle" value="{PREFERENCES/FORUM-STYLE}"/>
    </xsl:if>

    <input name="OldEmail" type="hidden">
      <xsl:attribute name="value">
        <xsl:value-of select="EMAIL-ADDRESS"/>
      </xsl:attribute>
    </input>
    <input name="NewEmail" type="hidden">
      <xsl:attribute name="value">
        <xsl:value-of select="EMAIL-ADDRESS"/>
      </xsl:attribute>
    </input>
    <input name="Password" type="hidden" value=""/>
    <input name="NewPassword" type="hidden" value=""/>
    <input name="PasswordConfirm" type="hidden" value=""/>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="UserNameInput">
Author:		Igor Loboda
Context:    -
Purpose:	Generates User Name input field
Call:		<xsl:apply-templates select="." mode="UserNameInput">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="UserNameInput">
    <input xsl:use-attribute-sets="asiUSER-DETAILS-FORM_UserNameInput" name="Username">
      <xsl:attribute name="value">
        <xsl:value-of select="USERNAME"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="Email">
Author:		Igor Loboda
Context:    -
Purpose:	Generates Email input field
Call:		<xsl:apply-templates select="." mode="Email">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="Email">
    <input xsl:use-attribute-sets="asiUSER-DETAILS-FORM_Email" name="NewEmail">
      <xsl:attribute name="value">
        <xsl:value-of select="EMAIL-ADDRESS"/>
      </xsl:attribute>
    </input>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="UserName">
Author:		Igor Loboda
Context:    -
Purpose:	Generates either user name input field or just plain text containing
			user name dependin on premoderated flag	
Call:		<xsl:apply-templates select="." mode="UserName">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="UserName">
    <xsl:choose>
      <xsl:when test="$premoderated = 1">
        <xsl:value-of select="USERNAME"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="UserNameInput"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="SkinList">
Author:		Igor Loboda
Context:    -
Purpose:	Generates drop down list of skins
Call:		<xsl:apply-templates select="." mode="SkinList">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="SkinList">
    <select name="PrefSkin">
      <span class="skindropdown">
        <xsl:call-template name="skindropdown">
          <xsl:with-param name="localskinname">
            <xsl:value-of select="PREFERENCES/SKIN"/>
          </xsl:with-param>
        </xsl:call-template>
      </span>
    </select>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="PrefMode">
Author:		Igor Loboda
Context:    -
Purpose:	Generates drop down list of modes (normal/expert)
Call:		<xsl:apply-templates select="." mode="PrefMode">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="PrefMode">
    <select name="PrefUserMode">
      <span xsl:use-attribute-sets="asftUSER-DETAILS-FORM_PrefMode">
        <xsl:choose>
          <xsl:when test="number(PREFERENCES/USER-MODE)=1">
            <option value="0">
              <xsl:value-of select="$m_normal"/>
            </option>
            <option value="1" selected="1">
              <xsl:value-of select="$m_expert"/>
            </option>
          </xsl:when>
          <xsl:otherwise>
            <option value="0" selected="1">
              <xsl:value-of select="$m_normal"/>
            </option>
            <option value="1">
              <xsl:value-of select="$m_expert"/>
            </option>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </select>
  </xsl:template>

  <!--
<xsl:template match="USER-DETAILS-FORM" mode="PrefForumStyle">
Author:		Igor Loboda
Context:    -
Purpose:	Generates drop down list of prefered styles (single pages/frames)
Call:		<xsl:apply-templates select="." mode="PrefForumStyle">
-->
  <xsl:template match="USER-DETAILS-FORM" mode="PrefForumStyle">
    <select name="PrefForumStyle">
      <span xsl:use-attribute-sets="asftUSER-DETAILS-FORM_PrefForumStyle">
        <xsl:choose>
          <xsl:when test="number(PREFERENCES/FORUM-STYLE)=0">
            <option value="0" selected="selected">
              <xsl:value-of select="$m_forumstylesingle"/>
            </option>
            <option value="1">
              <xsl:value-of select="$m_forumstyleframes"/>
            </option>
          </xsl:when>
          <xsl:otherwise>
            <option value="0">
              <xsl:value-of select="$m_forumstylesingle"/>
            </option>
            <option value="1" selected="selected">
              <xsl:value-of select="$m_forumstyleframes"/>
            </option>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </select>
  </xsl:template>

  <!--
<xsl:template match="USERID" mode="USER-DETAILS-FORM">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Click here to go back to your Personal Space." with U6 HREF 
Call:		<xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="USER-DETAILS-FORM"/>
-->
  <xsl:template match="USERID" mode="USER-DETAILS-FORM">
    <A xsl:use-attribute-sets="mUSERID_USER-DETAILS-FORM">
      <xsl:apply-templates select="." mode="HREF_U"/>
      <xsl:value-of select="$m_backtouserpage"/>
    </A>
  </xsl:template>

  <!--
<xsl:template name="showforumintro">
-->
  <xsl:template name="showforumintro">
    <xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO"/>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="movethreadgadget">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "MoveThread"
Call:		<xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>
-->
  <xsl:template match="@THREADID" mode="movethreadgadget">
    <xsl:if test="$test_IsEditor">
      <a xsl:use-attribute-sets="maTHREADID_movethreadgadget" onClick="popupwindow('{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP','MoveThreadWindow','scrollbars=1,resizable=1,width=300,height=230');return false;" href="{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP">
        <xsl:value-of select="$m_MoveThread"/>
      </a>
    </xsl:if>
  </xsl:template>

  <!--
<xsl:template match="FORUMTHREADS" mode="SubscribeUnsub">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Click here to be notified of new Conversations about this Guide Entry" or
			"Click here to stop being notified of new..."
Call:		<xsl:apply-templates select="FORUMTHREADS" mode="SubscribeUnsub"/>
-->
  <xsl:template match="FORUMTHREADS" mode="SubscribeUnsub">
    <xsl:choose>
      <xsl:when test="../SUBSCRIBE-STATE[@FORUM='1']">
        <xsl:apply-templates select="." mode="Unsubscribe"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="Subscribe"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="FORUMTHREADS" mode="Unsubscribe">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Click here to stop being notified of new..."
Call:		<xsl:apply-templates select="FORUMTHREADS" mode="Unsubscribe"/>
-->
  <xsl:template match="FORUMTHREADS" mode="Unsubscribe">
    <a xsl:use-attribute-sets="mFORUMTHREADS_Unsubscribe">
      <xsl:apply-templates select="@FORUMID" mode="HREF_Unsubscribe"/>
      <xsl:copy-of select="$m_clickunsubforum"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="FORUMTHREADS" mode="Subscribe">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Click here to be notified of new Conversations about this Guide Entry" 
Call:		<xsl:apply-templates select="FORUMTHREADS" mode="Subscribe"/>
-->
  <xsl:template match="FORUMTHREADS" mode="Subscribe">
    <a xsl:use-attribute-sets="mFORUMTHREADS_Subscribe">
      <xsl:apply-templates select="@FORUMID" mode="HREF_Subscribe"/>
      <xsl:copy-of select="$m_clicksubforum"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_Unsubscribe">
Author:		Igor Loboda
Context:    should have @THREADID, @SKIPTO, @COUNT
Purpose:	Generates URL for unsubscribe_from_conversation link"
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_Unsubscribe"/>
-->
  <xsl:template match="@FORUMID" mode="HREF_Unsubscribe">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>FSB<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;cmd=unsubscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$alt_subreturntoconv"/>&amp;return=F<xsl:value-of select="."/>%3Fthread=<xsl:value-of select="../@THREADID"/>%26amp;skip=<xsl:value-of select="../@SKIPTO"/>%26amp;show=<xsl:value-of select="../@COUNT"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_Subscribe">
Author:		Igor Loboda
Context:    should have @THREADID, @SKIPTO, @COUNT
Purpose:	Generates URL for subscribe_for_conversation link"
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_Subscribe"/>
-->
  <xsl:template match="@FORUMID" mode="HREF_Subscribe">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>FSB<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;cmd=subscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$alt_subreturntoconv"/>&amp;return=F<xsl:value-of select="."/>%3Fthread=<xsl:value-of select="../@THREADID"/>%26amp;skip=<xsl:value-of select="../@SKIPTO"/>%26amp;show=<xsl:value-of select="../@COUNT"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="THREADS_MAINBODY">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with thread subject and HREF like this "F87231?thread=176256"
Call:		<xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY"/>
-->
  <xsl:template match="@FORUMID" mode="THREADS_MAINBODY">
    <xsl:param name="img">
      <xsl:value-of select="$alt_newconversation"/>
    </xsl:param>
    <A xsl:use-attribute-sets="maFORUMID_THREADS_MAINBODY">
      <xsl:apply-templates select="." mode="HREF_ADDTHREAD"/>
      <xsl:copy-of select="$img"/>
    </A>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_ADDTHREAD">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like this "F87231?thread=176256"
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_Subscribe"/>
-->
  <xsl:template match="@FORUMID" mode="HREF_ADDTHREAD">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@FORUMID" mode="HREF_FTLatest">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like this "F87231?thread=176250&latest=1"
Call:		<xsl:apply-templates select="@FORUMID" mode="HREF_FTLatest"/>
-->
  <xsl:template match="@FORUMID" mode="HREF_FTLatest">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;latest=1
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="HREF_FTLatest">
Author:		Igor Loboda
Context:    must have have ../@FORUMID
Purpose:	Generates HREF like this "F87231?thread=176250&latest=1"
Call:		<xsl:apply-templates select="@THREADID" mode="HREF_FTLatest"/>
-->
  <xsl:template match="@THREADID" mode="HREF_FTLatest">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="."/>&amp;latest=1
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="HREF_FT">
Author:		Igor Loboda
Context:    must have have ../@FORUMID
Purpose:	Generates HREF like this "F87231?thread=176250"
Call:		<xsl:apply-templates select="@THREADID" mode="HREF_FT"/>.
-->
  <xsl:template match="@THREADID" mode="HREF_FT">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="FOOTNOTE">
Purpose:	Display a footnote within the body of the text
Call:		<xsl:apply-templates select="FOOTNOTE"/>.
-->
  <xsl:template match="FOOTNOTE">
    <a xsl:use-attribute-sets="mFOOTNOTE">
      <xsl:attribute name="title">
        <xsl:call-template name="renderfootnotetext"/>
      </xsl:attribute>
      <xsl:attribute name="name">
        back<xsl:value-of select="@INDEX"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        #footnote<xsl:value-of select="@INDEX"/>
      </xsl:attribute>
      <xsl:apply-templates select="@INDEX" mode="Footnote"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="FOOTNOTE" mode="display" >
Inputs:		endcode - tags that will be placed after the link
Purpose:	Display the footnote text underneath the article
Call:		<xsl:apply-templates select="FOOTNOTE" mode="display"/>.
-->
  <xsl:template match="FOOTNOTE" mode="display">
    <xsl:param name="endcode">
      <br/>
    </xsl:param>
    <a>
      <xsl:attribute name="name">
        footnote<xsl:value-of select="@INDEX"/>
      </xsl:attribute>
      <a xsl:use-attribute-sets="mFOOTNOTE_display">
        <xsl:attribute name="href">
          #back<xsl:value-of select="@INDEX"/>
        </xsl:attribute>
        <xsl:apply-templates select="@INDEX" mode="Footnote"/>
      </a>
      <xsl:apply-templates select="." mode="BottomText"/>
    </a>
    <xsl:copy-of select="$endcode"/>
  </xsl:template>

  <!--
<xsl:template name="renderfootnotetext">
Purpose:	Display the footnote text
Call:		<xsl:call-template name="renderfootnotetext"/>.
-->
  <xsl:template name="renderfootnotetext">
    <xsl:for-each select="*|text()">
      <xsl:choose>
        <xsl:when test="self::text()">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="name()!=string('FOOTNOTE')">
          <xsl:choose>
            <xsl:when test="self::text()">
              <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="renderfootnotetext"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <!--
<xsl:template match="JOURNALPOSTS" mode="MoreJournal">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like this MJ192271?Journal=87222&show=5&skip=5
Call:		<xsl:apply-templates select="JOURNALPOSTS" mode="MoreJournal"/>
-->
  <xsl:template match="JOURNALPOSTS" mode="MoreJournal">
    <xsl:param name="img" select="$m_clickmorejournal"/>
    <a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
      <xsl:apply-templates select="." mode="HREF_MJ"/>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="JOURNALPOSTS" mode="HREF_MJ">
Author:		Igor Loboda
Context:    must have ../PAGE-OWNER/USER/USERID
Purpose:	Generates HREF like this MJ192271?Journal=87222&show=5&skip=5
Call:		<xsl:apply-templates select="JOURNALPOSTS" mode="HREF_MJ"/>
-->
  <xsl:template match="JOURNALPOSTS" mode="HREF_MJ">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MJ<xsl:value-of select="../../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="@FORUMID"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;skip=<xsl:value-of select="number(@SKIPTO) + number(@COUNT)"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template name="ClickAddJournal">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with HREF like this PostJournal
Call:		<xsl:call-template name="ClickAddJournal"/>
-->
  <xsl:template name="ClickAddJournal">
    <xsl:param name="img" select="$m_clickaddjournal"/>
    <a xsl:use-attribute-sets="nClickAddJournal">
      <xsl:call-template name="HREF_PostJournal"/>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template name="HREF_PostJournal">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like this PostJournal
Call:		<xsl:call-template name="HREF_PostJournal"/>
-->
  <xsl:template name="HREF_PostJournal">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>PostJournal
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template name="JournalEmptyMsg">
Author:		Igor Loboda
Context:    -
Purpose:	puts either m_journalownerempty or m_journalviewerempty to the output depending on
			whether user is the journal owner or not
Call:		<xsl:call-template name="JournalEmptyMsg"/>
-->
  <xsl:template name="JournalEmptyMsg">
    <xsl:choose>
      <xsl:when test="$ownerisviewer = 1">
        <xsl:call-template name="m_journalownerempty"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="m_journalviewerempty"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template name="JournalFullMsg">
Author:		Igor Loboda
Context:    -
Purpose:	puts either m_journalownerfull or m_journalviewerfull to the output depending on
			whether user is the journal owner or not
Call:		<xsl:call-template name="JournalFullMsg"/>
-->
  <xsl:template name="JournalFullMsg">
    <xsl:choose>
      <xsl:when test="$ownerisviewer = 1">
        <xsl:call-template name="m_journalownerfull"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="m_journalviewerfull"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="JOURNALPOSTS">
	Generic:	Yes
	Purpose:	Display a journal post
-->
  <xsl:template match="JOURNALPOSTS">
    <xsl:apply-templates select="POST"/>
  </xsl:template>

  <!--
<xsl:template match="@POSTID" mode="DiscussJournalEntry">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with HREF like this AddThread?InReplyTo=1899780
Call:		<xsl:apply-templates select="@POSTID" mode="DiscussJournalEntry"/>
-->
  <xsl:template match="@POSTID" mode="DiscussJournalEntry">
    <xsl:param name="attributes"/>
    <xsl:param name="img" select="$m_clickherediscuss"/>
    <a xsl:use-attribute-sets="maPOSTID_DiscussJournalEntry">
      <xsl:apply-templates select="." mode="HREF_AddthreadInReply"/>
      <xsl:call-template name="ApplyAttributes">
        <xsl:with-param name="attributes" select="$attributes"/>
      </xsl:call-template>
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@POSTID" mode="HREF_AddthreadInReply">
Author:		Igor Loboda
Context:    -
Purpose:	Generates HREF like this AddThread?InReplyTo=1899780
Call:		<xsl:apply-templates select="@POSTID" mode="HREF_AddthreadInReply"/>
-->
  <xsl:template match="@POSTID" mode="HREF_AddthreadInReply">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>AddThread?InReplyTo=<xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="JournalEntryReplies">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link like "2 replies" with HREF like this AddThread?InReplyTo=1899780
Call:		<xsl:apply-templates select="@THREADID" mode="JournalEntryReplies"/>
-->
  <xsl:template match="@THREADID" mode="JournalEntryReplies">
    <a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
      <xsl:apply-templates select="." mode="HREF_FT"/>
      <xsl:choose>
        <xsl:when test="../LASTREPLY[@COUNT &gt; 2]">
          <xsl:value-of select="number(../LASTREPLY/@COUNT)-1"/>
          <xsl:value-of select="$m_replies"/>
        </xsl:when>
        <xsl:otherwise>
          1<xsl:value-of select="$m_reply"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="JournalLastReply">
Author:		Igor Loboda
Context:    must have LASTREPLY child
Purpose:	Generates link like "Yesterday" with HREF like this F87222?thread=176266&latest=1
Call:		<xsl:apply-templates select="@THREADID" mode="JournalLastReply"/>
-->
  <xsl:template match="@THREADID" mode="JournalLastReply">
    <a xsl:use-attribute-sets="maTHREADID_JournalLastReply">
      <xsl:apply-templates select="." mode="HREF_FTLatest"/>
      <xsl:apply-templates select="../LASTREPLY/DATE"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@THREADID" mode="JournalLastReply">
Author:		Igor Loboda
Context:    must have ../@FORUMID
Purpose:	Generates link like "Click here to remove this Journal Entry from your Space" 
			with HREF like this 
			FSB87222?thread=176266&cmd=unsubscribejournal&page=normal&desc=Return+to+your+Personal+Space&return=U192271
Call:		<xsl:apply-templates select="@THREADID" mode="JournalLastReply"/>
-->
  <xsl:template match="@THREADID" mode="JournalRemovePost">
    <xsl:param name="img" select="$m_removejournal"/>
    <a xsl:use-attribute-sets="maTHREADID_JournalRemovePost" href="{$root}FSB{../../@FORUMID}?thread={.}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}">
      <xsl:copy-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="POSTS" mode="BackToUserSpace">
Author:		Igor Loboda
Context:    see <xsl:apply-templates select="." mode="ResearcherName"/>
Purpose:	Generates text like "Back to Jim Lynn's Personal Space"
Call:		<xsl:apply-templates select="POSTS" mode="BackToUserSpace"/>
-->
  <xsl:template match="POSTS" mode="BackToUserSpace">
    <xsl:copy-of select="$m_PostsBackTo"/>
    <xsl:apply-templates select="." mode="ResearcherName"/>
    <xsl:copy-of select="$m_PostsPSpace"/>
  </xsl:template>

  <!--
<xsl:template match="POSTS" mode="ResearcherName">
Author:		Igor Loboda
Context:    -
Purpose:	Generates text like "Jim Lynn" or "Reseacher 6"
Call:		<xsl:apply-templates select="POSTS" mode="ResearcherName"/>
-->
  <xsl:template match="POSTS" mode="ResearcherName">
    <xsl:choose>
      <xsl:when test="POST-LIST">
        <xsl:value-of select="POST-LIST/USER/USERNAME"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_researcher"/>
        <xsl:value-of select="@USERID"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="POSTS" mode="ToPSpaceFromMP">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with text "Back to Jim Lynn's Personal Space" and
			HREF "U6"
Call:		<xsl:apply-templates select="POSTS" mode="ToPSpaceFromMP"/>
-->
  <xsl:template match="POSTS" mode="ToPSpaceFromMP">
    <a xsl:use-attribute-sets="maPOSTS_ToPSpaceFromMP">
      <xsl:apply-templates select="@USERID" mode="HREF_U"/>
      <xsl:apply-templates select="." mode="BackToUserSpace"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="NewerPostings">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with text "<< Newer Postings" and HREF "MP6?show=25&skip=0"
Call:		<xsl:apply-templates select="@USERID" mode="NewerPostings"/>
-->
  <xsl:template match="@USERID" mode="NewerPostings">
    <xsl:param name="img">
      &lt;&lt;<xsl:value-of select="$m_newerpostings"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_NewerPostings">
      <xsl:apply-templates select="." mode="HREF_NewerPostings"/>
      <xsl:value-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="OlderPostings">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link with text "Older Postings >>" and HREF "MP6?show=25&skip=50"
Call:		<xsl:apply-templates select="@USERID" mode="OlderPostings"/>
-->
  <xsl:template match="@USERID" mode="OlderPostings">
    <xsl:param name="img">
      <xsl:value-of select="$m_olderpostings"/> &gt;&gt;
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_OlderPostings">
      <xsl:apply-templates select="." mode="HREF_OlderPostings"/>
      <xsl:value-of select="$img"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="HREF_NewerPostings">
Author:		Igor Loboda
Context:    must have POST-LIST/@COUNT and POST-LIST/@SKIPTO
Purpose:	Generates HREF "MP6?show=25&skip=0"
Call:		<xsl:apply-templates select="@USERID" mode="HREF_NewerPostings"/>
-->
  <xsl:template match="@USERID" mode="HREF_NewerPostings">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>MP<xsl:value-of select="."/>?show=<xsl:value-of select="../POST-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(../POST-LIST/@SKIPTO) - number(../POST-LIST/@COUNT)"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="HREF_OlderPostings">
Author:		Igor Loboda
Context:    must have POST-LIST/@COUNT and POST-LIST/@SKIPTO
Purpose:	Generates HREF "MP6?show=25&skip=50"
Call:		<xsl:apply-templates select="@USERID" mode="HREF_OlderPostings"/>
-->
  <xsl:template match="@USERID" mode="HREF_OlderPostings">
    <xsl:attribute name="href">
      <xsl:value-of select="$root"/>MP<xsl:value-of select="."/>?show=<xsl:value-of select="../POST-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(../POST-LIST/@SKIPTO) + number(../POST-LIST/@COUNT)"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="ShowEditedEntries">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Show Edited Articles" with HREF "MA6?show=25&type=1"
Call:		<xsl:apply-templates select="@USERID" mode="ShowEditedEntries"/>
-->
  <xsl:template match="@USERID" mode="ShowEditedEntries">
    <xsl:param name="content">
      <xsl:copy-of select="$m_showeditedentries"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_ShowEditedEntries">
      <xsl:apply-templates select="." mode="HREF_ShowEditedEntries"/>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="HREF_ShowEditedEntries">
Author:		Igor Loboda
Context:    must have ARTICLE-LIST/@COUNT
Purpose:	Generates HREF "MA6?show=25&type=1"
Call:		<xsl:apply-templates select="@USERID" mode="HREF_ShowEditedEntries"/>
-->
  <xsl:template match="@USERID" mode="HREF_ShowEditedEntries">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MA<xsl:value-of select="."/>?show=<xsl:value-of select="../ARTICLE-LIST/@COUNT"/>&amp;type=1
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="ShowGuideEntries">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Show Articles" with HREF "MA6?show=25&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="ShowGuideEntries"/>
-->
  <xsl:template match="@USERID" mode="ShowGuideEntries">
    <xsl:param name="content">
      <xsl:copy-of select="$m_showguideentries"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_ShowGuideEntries">
      <xsl:apply-templates select="." mode="HREF_ShowGuideEntries"/>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="ShowGuideEntries">
Author:		Igor Loboda
Context:    must have ARTICLE-LIST/@COUNT
Purpose:	Generates HREF "MA6?show=25&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="ShowGuideEntries"/>
-->
  <xsl:template match="@USERID" mode="HREF_ShowGuideEntries">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MA<xsl:value-of select="."/>?show=<xsl:value-of select="../ARTICLE-LIST/@COUNT"/>&amp;type=2
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="ShowCancelledEntries">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Show Cancelled Articles" with HREF "MA192271?show=25&type=3"
Call:		<xsl:apply-templates select="@USERID" mode="ShowCancelledEntries"/>
-->
  <xsl:template match="@USERID" mode="ShowCancelledEntries">
    <xsl:param name="content">
      <xsl:copy-of select="$m_showcancelledentries"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_ShowCancelledEntries">
      <xsl:apply-templates select="." mode="HREF_ShowCancelledEntries"/>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="HREF_ShowCancelledEntries">
Author:		Igor Loboda
Context:    must have ARTICLE-LIST/@COUNT
Purpose:	HREF "MA192271?show=25&type=3"
Call:		<xsl:apply-templates select="@USERID" mode="HREF_ShowCancelledEntries"/>
-->
  <xsl:template match="@USERID" mode="HREF_ShowCancelledEntries">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MA<xsl:value-of select="."/>?show=<xsl:value-of select="../ARTICLE-LIST/@COUNT"/>&amp;type=3
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="USERNAME" mode="FromMAToPSText">
    <xsl:copy-of select="$m_MABackTo"/>
    <xsl:value-of select="."/>
    <xsl:copy-of select="$m_MAPSpace"/>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="FromMAToPS">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Back to IgorLoboda 192271's Personal Space" with HREF "U192271"
Call:		<xsl:apply-templates select="@USERID" mode="FromMAToPS"/>
-->
  <xsl:template match="@USERID" mode="FromMAToPS">
    <a xsl:use-attribute-sets="maUSERID_FromMAToPS">
      <xsl:apply-templates select="." mode="HREF_U"/>
      <xsl:apply-templates select="/H2G2/PAGE-OWNER/USER/USERNAME" mode="FromMAToPSText"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="OlderEntries">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Older Articles >>" with HREF like "MA6?show=25&skip=50&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="OlderEntries"/>
-->
  <xsl:template match="@USERID" mode="OlderEntries">
    <xsl:param name="content">
      <xsl:copy-of select="$m_olderentries"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_OlderEntries">
      <xsl:apply-templates select="." mode="HREF_OlderEntries"/>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="OlderEntries">
Author:		Igor Loboda
Context:    must have ARTICLE-LIST/@COUNT, ARTICLE-LIST/@SKIPTO and @WHICHSET
Purpose:	Generates HREF like "MA6?show=25&skip=50&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="OlderEntries"/>
-->
  <xsl:template match="@USERID" mode="HREF_OlderEntries">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MA<xsl:value-of select="."/>?show=<xsl:value-of select="../ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(../ARTICLE-LIST/@SKIPTO) + number(../ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="../@WHICHSET"/>
    </xsl:attribute>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="NewerEntries">
Author:		Igor Loboda
Context:    -
Purpose:	Generates link "Newer Articles >>" with HREF like "MA6?show=25&skip=0&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="NewerEntries"/>
-->
  <xsl:template match="@USERID" mode="NewerEntries">
    <xsl:param name="content">
      <xsl:copy-of select="$m_newerentries"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_NewerEntries">
      <xsl:apply-templates select="." mode="HREF_NewerEntries"/>
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
<xsl:template match="@USERID" mode="NewerEntries">
Author:		Igor Loboda
Context:    must have ARTICLE-LIST/@COUNT, ARTICLE-LIST/@SKIPTO and @WHICHSET
Purpose:	Generates HREF like "MA6?show=25&skip=0&type=2"
Call:		<xsl:apply-templates select="@USERID" mode="NewerEntries"/>
-->
  <xsl:template match="@USERID" mode="HREF_NewerEntries">
    <xsl:attribute name="HREF">
      <xsl:value-of select="$root"/>MA<xsl:value-of select="."/>?show=<xsl:value-of select="../ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(../ARTICLE-LIST/@SKIPTO) - number(../ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="../@WHICHSET"/>
    </xsl:attribute>
  </xsl:template>

  <!-- ******************************************************************************************** -->
  <!-- End of Secure templates-->
  <!-- SECURESEC This is to be able to search for the end of this section-->
  <!-- ******************************************************************************************** -->


  <!-- ******************************************************************************************** -->
  <!-- Overwritable Template names, these decide the placement for secure template names and matches  -->
  <!-- The templates provided here are default and can be overridden by specific skins-->
  <!-- ******************************************************************************************** -->
  <xsl:template name="SEARCH_LEFTCOL"/>
  <xsl:template name="SEARCH_SIDEBAR">
    <xsl:call-template name="showcategory"/>
  </xsl:template>
  <xsl:template name="SEARCH_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_pagetitlestart"/>
        <xsl:value-of select="$m_searchtitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template name="SEARCH_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_searchsubject"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!--
	<xsl:template name="SEARCH_MAINBODY">
	Author:		Tom Whitehouse
	Inputs:		-
	Context		H2G2
	Purpose:	Contains the UI for the search page
-->

  <xsl:template name="SEARCH_MAINBODY">
    <!-- Skin Template (containing presentation elements) -->
    <xsl:apply-templates select="SEARCH/SEARCHRESULTS"/>
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$alt_searchtheguide"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <FORM xsl:use-attribute-sets="SearchFormAtts">
        <xsl:value-of select="$m_enterwordsorphrases"/>
        <xsl:call-template name="SearchFormMain"/>
        <br/>
        <xsl:value-of select="$m_searchin"/>
        <br/>
        <xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHARTICLES"/>



        <input type="hidden" xsl:use-attribute-sets="SearchTypeArticles"/>
        <xsl:call-template name="SearchFormSubmitText">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_searchtheguide"/>
          </xsl:with-param>
        </xsl:call-template>
      </FORM>
      <CENTER>
        <xsl:value-of select="$m_oruseindex"/>
        <BR/>
        <xsl:call-template name="alphaindex"/>
      </CENTER>
    </blockquote>
    <br/>
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_searchforums"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <FORM xsl:use-attribute-sets="SearchFormAtts">
        <xsl:call-template name="searchforforums"/>
        <input type="hidden" xsl:use-attribute-sets="SearchTypeForums"/>
        <br/>
        <xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHFORUMS" mode="searchforumids"/>
        <xsl:call-template name="SearchFormSubmitText">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_searchforums"/>
          </xsl:with-param>
        </xsl:call-template>
      </FORM>
    </blockquote>
    <br/>
    <xsl:call-template name="HEADER">
      <xsl:with-param name="text">
        <xsl:value-of select="$m_searchforafriend"/>
      </xsl:with-param>
    </xsl:call-template>
    <blockquote>
      <FORM xsl:use-attribute-sets="SearchFormAtts">
        <xsl:call-template name="searchforfriends"/>
        <input type="hidden" xsl:use-attribute-sets="SearchTypeFriends"/>
        <br/>
        <xsl:call-template name="SearchFormSubmitText">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_searchforafriend"/>
          </xsl:with-param>
        </xsl:call-template>
      </FORM>
    </blockquote>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
    <br/>
  </xsl:template>
  <!--
	<xsl:template match="SEARCHRESULTS">
	Author:		Tom Whitehouse
	Inputs:		-
	Context		Applied from H2G2
	Purpose:	Creates the Search Results on a Search Page, 
	-->
  <xsl:template match="SEARCHRESULTS">
    <xsl:choose>
      <xsl:when test="ARTICLERESULT|FORUMRESULT|USERRESULT">
        <xsl:choose>
          <xsl:when test="ARTICLERESULT">
            <xsl:call-template name="HEADER">
              <xsl:with-param name="text">
                <xsl:value-of select="$m_resultsfound"/>
              </xsl:with-param>
            </xsl:call-template>
            <!-- xsl:apply-templates select="ARTICLERESULT" -->
            <table>
              <xsl:comment> Search Results Start</xsl:comment>
              <xsl:if test="ARTICLERESULT[PRIMARYSITE=1]">
                <!-- If at least one of them exists, treated as presentation -->
                <tr>
                  <td colspan="4">
                    <xsl:call-template name="m_searchresultsthissite"/>
                  </td>
                </tr>
                <tr valign="top">
                  <td>

                    <b>
                      <xsl:value-of select="$m_SearchResultsIDColumnName"/>
                    </b>

                  </td>
                  <td>

                    <b>
                      <xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
                    </b>

                  </td>
                  <td>

                    <b>
                      <xsl:value-of select="$m_SearchResultsStatusColumnName"/>
                    </b>

                  </td>
                  <td>

                    <b>
                      <xsl:value-of select="$m_SearchResultsScoreColumnName"/>
                    </b>

                  </td>
                </tr>
                <xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE=1]"/>
              </xsl:if>
              <xsl:if test="ARTICLERESULT[PRIMARYSITE!=1]">
                <tr>
                  <td colspan="5">
                    <xsl:call-template name="m_searchresultsothersites"/>
                  </td>
                </tr>
                <tr valign="top">
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsIDColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsStatusColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsScoreColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>Site</b>
                  </td>
                </tr>
                <xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE!=1]"/>
              </xsl:if>
              <xsl:comment> Search Results End </xsl:comment>
            </table>
          </xsl:when>
          <!-- forum and user searches don't need a table for formatting -->
          <xsl:when test="FORUMRESULT">
            <xsl:call-template name="HEADER">
              <xsl:with-param name="text">
                <xsl:value-of select="$m_resultsfound"/>
              </xsl:with-param>
            </xsl:call-template>
            <table>
              <xsl:if test="FORUMRESULT[PRIMARYSITE=1]">
                <tr>
                  <td colspan="2">
                    <xsl:call-template name="m_searchresultsthissite"/>
                  </td>
                </tr>
                <tr valign="top">
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsScoreColumnName"/>
                    </b>
                  </td>
                </tr>
                <xsl:apply-templates select="FORUMRESULT[PRIMARYSITE=1]"/>
              </xsl:if>
              <xsl:if test="FORUMRESULT[PRIMARYSITE!=1]">
                <tr>
                  <td colspan="5">
                    <xsl:call-template name="m_searchresultsothersites"/>
                  </td>
                </tr>
                <tr valign="top">
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_SearchResultsScoreColumnName"/>
                    </b>
                  </td>
                  <td>
                    <b>
                      <xsl:value-of select="$m_whichsite"/>
                    </b>
                  </td>
                </tr>
                <xsl:apply-templates select="FORUMRESULT[PRIMARYSITE!=1]"/>
              </xsl:if>
            </table>
          </xsl:when>
          <xsl:when test="USERRESULT">
            <xsl:call-template name="HEADER">
              <xsl:with-param name="text">
                <xsl:value-of select="$m_resultsfound"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="USERRESULT"/>
          </xsl:when>
        </xsl:choose>
        <!-- put in the links for next and previous results -->
        <xsl:apply-templates select="SKIP"/>
        <xsl:apply-templates select="MORE"/>
        <br/>
      </xsl:when>
      <xsl:when test="string-length(SEARCHTERM)=0"/>
      <xsl:otherwise>
        <xsl:call-template name="HEADER">
          <xsl:with-param name="text">
            <xsl:value-of select="$m_noresults"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="m_searchfailed"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="ARTICLERESULT">
    <tr valign="top">
      <td>
        <span xsl:use-attribute-sets="h2g2idstyle">
          <xsl:apply-templates select="H2G2ID" mode="link"/>
        </span>
      </td>
      <td>
        <span xsl:use-attribute-sets="subjectstyle">
          <xsl:apply-templates select="SUBJECT" mode="articleresult"/>
        </span>
      </td>
      <td>
        <span xsl:use-attribute-sets="statusstyle">
          <xsl:apply-templates select="STATUS"/>
        </span>
      </td>
      <td>
        <span xsl:use-attribute-sets="scorestyle">
          <xsl:apply-templates select="SCORE"/>
        </span>
      </td>
      <xsl:if test="PRIMARYSITE!=1">
        <td>
          <span xsl:use-attribute-sets="shortnamestyle">
            <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/SHORTNAME" mode="result"/>
          </span>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
  <xsl:template match="FORUMRESULT">
    <tr valign="top">
      <td>
        <span xsl:use-attribute-sets="subjectstyle">
          <xsl:apply-templates select="SUBJECT" mode="forumresult"/>
        </span>
      </td>
      <td>

        <xsl:apply-templates select="SCORE"/>

      </td>
      <xsl:if test="PRIMARYSITE!=1">
        <td>
          <span xsl:use-attribute-sets="shortnamestyle">
            <xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/SHORTNAME" mode="result"/>
          </span>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
  <!--
	<xsl:template match="USERRESULT">
	Context: 
	Obligatory: No
	Purpose: Displays a user link as part of search results

-->
  <xsl:template match="USERRESULT">
    <span xsl:use-attribute-sets="useridstyle">
      <xsl:apply-templates select="USERNAME" mode="UserResult"/>
    </span>
    <br/>
  </xsl:template>

  <!--
	<xsl:template match="H2G2ID" mode="notLinkTextBold">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displays date in the entry id in the following format: Entry ID: A544411, 
				where A544411 is not link but just a text and Entry ID is bold
	-->
  <xsl:template match="H2G2ID" mode="notLinkTextBold">
    <B>
      <xsl:value-of select="$m_idcolon"/>
    </B>
    A<xsl:value-of select="."/>
  </xsl:template>



  <!--
	<xsl:template match="H2G2ID" mode="notlinkIDBold">
	Author:		Igor Loboda
	Inputs:		-
	Purpose:	Displays date in the entry id in the following format: Entry ID: A544411, 
				where A544411 is not link but just a text and A544411 is bold 
	-->
  <xsl:template match="H2G2ID" mode="notlinkIDBold">
    <xsl:value-of select="$m_idcolon"/>
    <B>
      A<xsl:value-of select="."/>
    </B>
  </xsl:template>
  <!--
	<xsl:template match="H2G2ID"/>
	Context: Always a child of ARTICLERESULT
	Purpose: Creates a link to a DNA article, the a link can include any site specific attribute, as can the parent font tag
-->
  <xsl:template match="H2G2ID[parent::ARTICLERESULT]">
    A<xsl:value-of select="."/>
  </xsl:template>
  <!--
	<xsl:template match="H2G2ID" mode="link">
	Author:		Tom Whitehouse
	Inputs:		-
	Purpose:	Displays H2G2ID as a link 
	-->
  <xsl:template match="H2G2ID" mode="link">
    <xsl:param name="content" select="concat('A', .)"/>
    <a href="{$root}A{.}" xsl:use-attribute-sets="mH2G2ID_link">
      <xsl:copy-of select="$content"/>
    </a>
  </xsl:template>

  <!--
	<xsl:template match="PAGEAUTHOR">
	Author:		Igor Loboda
	Inputs:		delimiter - delimiter between Researcher 172781 and Edited by:
				researchersDelimiter - delimiter between Written and Researched by: and
					Researcher 172781
				authorDelimiter - delimiter between Edited by: and Researcher 172783
				listItemDelimiter - delimiter between items in researchers list
	Context:    ARTICLEINFO
				Uses test variable test_HasResearchers.
	Purpose:	Displays part of article information in form of
				Written and Researched by:
				Researcher 172781

				Edited by:
				Researcher 172783
	-->
  <xsl:template match="PAGEAUTHOR">
    <xsl:param name="delimiter">
      <B>
        <BR/>
      </B>
    </xsl:param>
    <xsl:param name="researchersDelimiter">
      <BR/>
    </xsl:param>
    <xsl:param name="authorDelimiter">
      <BR/>
    </xsl:param>
    <xsl:param name="listItemDelimiter">
      <BR/>
    </xsl:param>

    <xsl:if test="$test_HasResearchers">
      <span xsl:use-attribute-sets="pageauthorsfont">
        <xsl:call-template name="PageAuthorResearchers">
          <xsl:with-param name="delimiter" select="$researchersDelimiter"/>
          <xsl:with-param name="listItemDelimiter" select="$listItemDelimiter"/>
        </xsl:call-template>
        <xsl:copy-of select="$delimiter"/>
      </span>
    </xsl:if>

    <xsl:call-template name="PageAuthorEditor">
      <xsl:with-param name="delimiter" select="$authorDelimiter"/>
    </xsl:call-template>
  </xsl:template>

  <!--
	<xsl:template name="PageAuthorResearchers">
	Author:		Igor Loboda
	Inputs:		delimiter - delimiter between Written and Researched by: 
							and Researcher 172781
				listItemDelimiter - delimiter between items in the researchers list
	Context:    PAGEAUTHOR
				Uses test variable test_HasResearchers.
	Purpose:	Displays researchers list for an article in form of
				Written and Researched by:
				Researcher 172781
	-->
  <xsl:template name="PageAuthorResearchers">
    <xsl:param name="delimiter">
      <BR/>
    </xsl:param>
    <xsl:param name="listItemDelimiter">
      <BR/>
    </xsl:param>

    <xsl:if test="$test_HasResearchers">
      <span xsl:use-attribute-sets="pageauthorsfont">
        <xsl:value-of select="$m_researchers"/>
        <xsl:copy-of select="$delimiter"/>
        <b>
          <xsl:apply-templates select="RESEARCHERS">
            <xsl:with-param name="delimiter" select="$listItemDelimiter"/>
          </xsl:apply-templates>
        </b>
      </span>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template name="PageAuthorEditor">
	Author:		Igor Loboda
	Inputs:		delimiter - delimiter between Edited by: and Researcher 172783
	Context:    PAGEAUTHOR
	Purpose:	Displays Editor name in form of
				Edited by:
				Researcher 172783
	-->
  <xsl:template name="PageAuthorEditor">
    <xsl:param name="delimiter">
      <BR/>
    </xsl:param>
    <span xsl:use-attribute-sets="pageauthorsfont">
      <xsl:apply-templates select="EDITOR">
        <xsl:with-param name="delimiter" select="$delimiter"/>
      </xsl:apply-templates>
    </span>
  </xsl:template>

  <!--
	<xsl:template match="SITEID" mode="MoveToSite">
	Author:		Igor Loboda
	Inputs:		objectID - this id will be submitted to the server when Move button is 
							pressed. Usually this ID identifies entity to move. Like
							to move Article this will be H2G2ID.
	Purpose:	provides move-to-site functinality
	-->
  <xsl:template match="SITEID" mode="MoveToSite">
    <xsl:param name="objectID"/>
    <FORM NAME="MoveToSiteForm" METHOD="get">
      <xsl:value-of select="$m_BelongsToSite"/>
      <xsl:apply-templates select="." mode="SiteList"/>
      <INPUT TYPE="hidden" NAME="cmd" VALUE="MoveToSite"/>
      <xsl:text> </xsl:text>
      <INPUT TYPE="hidden" NAME="moveObjectID">
        <xsl:attribute name="VALUE">
          <xsl:value-of select="$objectID"/>
        </xsl:attribute>
      </INPUT>
      <INPUT NAME="button" xsl:use-attribute-sets="iMoveToSite"/>
    </FORM>
  </xsl:template>

  <!--
	<xsl:template match="ARTICLEINFO">

	Generic:	No
	Purpose:	Displays the ArticleInfo section in the sidebar
-->
  <xsl:template match="ARTICLEINFO">
    <xsl:call-template name="HDivider"/>

    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <xsl:value-of select="$m_entrydata"/>
          <br/>
        </td>
      </tr>
      <tr valign="top">
        <td align="left">
          <span xsl:use-attribute-sets="pageauthorsfont">
            <xsl:apply-templates select="H2G2ID" mode="notlinkIDBold"/>
            <b>
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="STATUS/@TYPE"/>
            </b>
          </span>
        </td>
      </tr>
      <tr>
        <td align="left" valign="top">
          <xsl:apply-templates select="PAGEAUTHOR"/>
          <br/>
        </td>
      </tr>
      <tr>
        <td align="left" valign="top">
          <span xsl:use-attribute-sets="pageauthorsfont">
            <xsl:call-template name="ArticleInfoDate"/>
          </span>
        </td>
      </tr>

      <xsl:if test="$test_ShowEditLink">
        <tr>
          <td>
            <nobr>
              <xsl:apply-templates select="/H2G2/PAGEUI/EDITPAGE/@VISIBLE" mode="EditEntry"/>
            </nobr>
          </td>
        </tr>
      </xsl:if>

      <tr>
        <td>
          <!-- put the recommend entry button in the side bar if specified in the page UI -->
          <xsl:call-template name="RecommendEntry">
            <xsl:with-param name="delimiter"/>
          </xsl:call-template>
        </td>
      </tr>

      <xsl:if test="$test_ShowEntrySubbedLink">
        <tr>
          <td>
            <nobr>
              <xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="RetToEditors"/>
            </nobr>
            <br/>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="$test_IsEditor">
        <tr>
          <td align="left" valign="top">
            <xsl:apply-templates select="H2G2ID" mode="CategoriseLink"/>
          </td>
        </tr>
      </xsl:if>

      <tr>
        <td align="left" valign="top">
          <!-- Inser link to remove current user from	the list of researcers -->
          <xsl:if test="$test_MayRemoveFromResearchers">
            <xsl:apply-templates select="H2G2ID" mode="RemoveSelf"/>
          </xsl:if>

          <xsl:apply-templates select="SUBMITTABLE">
            <xsl:with-param name="delimiter"/>
          </xsl:apply-templates>
        </td>
      </tr>
    </table>
    <xsl:apply-templates select="REFERENCES"/>
    <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CREDITS[../../ARTICLEINFO/STATUS/@TYPE=1]"/>
    <br/>
    <xsl:call-template name="m_entrysidebarcomplaint"/>
  </xsl:template>
  <xsl:template match="CREDITS[/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1]">
    <br/>
    <br/>

    <xsl:call-template name="HDivider"/>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="refentries">
            <xsl:value-of select="@TITLE"/>
          </span>
        </td>
      </tr>
      <xsl:for-each select="LINK">
        <tr>
          <td>
            <span xsl:use-attribute-sets="mENTRYLINK_UI">
              <xsl:apply-templates select="."/>
            </span>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <!--
		<xsl:template match="REFERENCES/ENTRIES">

		Generic:	No
		Purpose:	Displays the Entries in the references
	-->
  <xsl:template match="REFERENCES/ENTRIES">
    <BR/>
    <BR/>
    <xsl:call-template name="HDivider"/>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="refentries">
            <xsl:value-of select="$m_refentries"/>
          </span>
        </td>
      </tr>
      <xsl:apply-templates select="ENTRYLINK"/>
    </table>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="UI">
	Author:		Igor Loboda
	Inputs:		-
	Context		see <xsl:template match="REFERENCES/ENTRIES/ENTRYLINK">
	Purpose:	Creates entry link with HREF "A4041". The right place to
				overwrite if differen UI is required.
	Call:		<xsl:apply-templates select="ENTRYLINK" mode="UI">
	-->
  <xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="UI">
    <tr>
      <td>
        <span xsl:use-attribute-sets="mENTRYLINK_UI">
          <xsl:apply-templates select="." mode="JustLink"/>
        </span>
      </td>
    </tr>
  </xsl:template>

  <!--
		<xsl:template match="REFERENCES/USERS">

		Generic:	No
		Purpose:	Displays the refernced users
	-->
  <xsl:template match="REFERENCES/USERS">
    <BR/>
    <BR/>
    <xsl:call-template name="HDivider"/>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="refresearchers">
            <xsl:value-of select="$m_refresearchers"/>
          </span>
        </td>
      </tr>
      <xsl:apply-templates select="USERLINK"/>
    </table>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/USERS/USERLINK" mode="UI">
	Author:		Igor Loboda
	Inputs:		-
	Context		see <xsl:template match="REFERENCES/USERS/USERLINK">
	Purpose:	Creates entry link with HREF "U4041". The right place to
				overwrite if differen UI is required.
	Call:		<xsl:apply-templates select="USERLINK" mode="UI">
	-->
  <xsl:template match="REFERENCES/USERS/USERLINK" mode="UI">
    <tr>
      <td>
        <span xsl:use-attribute-sets="mUSERLINK_UI">
          <xsl:apply-templates select="." mode="JustLink"/>
        </span>
      </td>
    </tr>
  </xsl:template>

  <!--
		<xsl:template match="REFERENCES/EXTERNAL">

		Generic:	No
		Purpose:	Displays the external references
	-->
  <xsl:template match="REFERENCES/EXTERNAL" mode="BBCSites">
    <BR/>
    <BR/>
    <xsl:call-template name="HDivider"/>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="refsites">
            <xsl:value-of select="$m_otherbbcsites"/>
          </span>
        </td>
      </tr>
      <xsl:call-template name="ExLinksBBCSites"/>
    </table>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="BBCSitesUI">
	Author:		Igor Loboda
	Inputs:		-
	Context		see <xsl:template match="EXTERNALLINK mode="justlink">
	Purpose:	Creates entry link for BBC resources. The right place to
				overwrite if differen UI is required.
	Call:		<xsl:apply-templates select="EXTERNALLINK" mode="BBCSitesUI">
	-->
  <xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="BBCSitesUI">
    <tr>
      <td>
        <span xsl:use-attribute-sets="mEXTERNALLINK_BBCSitesUI">
          <xsl:apply-templates select="." mode="justlink"/>
        </span>
      </td>
    </tr>
  </xsl:template>

  <!--
		<xsl:template match="REFERENCES/EXTERNAL">

		Generic:	No
		Purpose:	Displays the external references
	-->
  <xsl:template match="REFERENCES/EXTERNAL" mode="NONBBCSites">
    <BR/>
    <BR/>
    <xsl:call-template name="HDivider"/>
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="refsites">
            <xsl:value-of select="$m_refsites"/>
          </span>
        </td>
      </tr>
      <xsl:call-template name="ExLinksNONBBCSites"/>
    </table>
    <br/>
    <span class="disclaimer">
      <xsl:value-of select="$m_referencedsitesdisclaimer"/>
    </span>
    <br/>
  </xsl:template>

  <!--
	<xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="NONBBCSitesUI">
	Author:		Igor Loboda
	Inputs:		-
	Context		see <xsl:template match="EXTERNALLINK mode="justlink">
	Purpose:	Creates entry link for NON-BBC resource. The right place to
				overwrite if differen UI is required.
	Call:		<xsl:apply-templates select="EXTERNALLINK" mode="NONBBCSitesUI">
	-->
  <xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="NONBBCSitesUI">
    <tr>
      <td>
        <span xsl:use-attribute-sets="mEXTERNALLINK_NONBBCSitesUI">
          <xsl:apply-templates select="." mode="justlink"/>
        </span>
      </td>
    </tr>
  </xsl:template>


  <!--
		<xsl:template match="REFERENCES">

		Generic:	Yes
		Purpose:	Displays article references
	-->
  <xsl:template match="REFERENCES">
    <xsl:if test="$test_RefHasEntries">
      <xsl:apply-templates select="ENTRIES"/>
    </xsl:if>

    <xsl:if test="$test_RefHasUsers">
      <xsl:apply-templates select="USERS"/>
    </xsl:if>

    <xsl:if test="$test_RefHasBBCSites">
      <xsl:apply-templates select="EXTERNAL" mode="BBCSites"/>
    </xsl:if>

    <xsl:if test="$test_RefHasNONBBCSites">
      <xsl:apply-templates select="EXTERNAL" mode="NONBBCSites"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="EDITOR">
	Author:		Igor Loboda
	Inputs:		delimiter - delimiter between Edited by: and Researcher 172783
	Context:    PAGEAUTHOR
	Purpose:	Displays Editor name in form of
				Edited by:
				Researcher 172783
	-->
  <xsl:template match="EDITOR">
    <xsl:param name="delimiter">
      <BR/>
    </xsl:param>

    <xsl:value-of select="$m_editor"/>
    <xsl:copy-of select="$delimiter"/>
    <xsl:apply-templates select="USER" mode="ArticleInfo"/>
  </xsl:template>

  <!--
		<xsl:template match="ARTICLEFORUM/FORUMTHREADS">

		Generic:	No
		Purpose:	Display the threads associated with a forum
	-->
  <xsl:template match="ARTICLEFORUM/FORUMTHREADS">
    <br clear="all"/>
    <div class="articleforum">
      <b>
        <NOBR>
          <xsl:apply-templates select="@FORUMID" mode="AddThread"/>
        </NOBR>
      </b>
      <p>
        <xsl:choose>
          <xsl:when test="THREAD">
            <xsl:value-of select="$m_peopletalking"/>
            <br/>
            <xsl:for-each select="THREAD">
              <xsl:apply-templates select="@THREADID" mode="LinkOnSubject"/>
              (<xsl:value-of select="$m_lastposting"/>
              <xsl:apply-templates select="@THREADID" mode="LinkOnDatePosted"/>)
              <br/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$registered=1">
                <xsl:apply-templates select="@FORUMID" mode="FirstToTalk"/>
                <br/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="m_registertodiscuss"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@MORE=1">
          <xsl:apply-templates select="@FORUMID" mode="MoreConv"/>
          <br/>
        </xsl:if>
        <xsl:call-template name="subscribearticleforum"/>
      </p>
      <br/>
    </div>
  </xsl:template>

  <!--
	<xsl:template name="PeopleTalking">
	Author:		Igor Loboda
	Inputs:		-
	Context:    ARTICLEFORUM/FORUMTHREADS or any other which could have THREAD element
	Purpose:	Displays "People have been talking about this entry. 
				Here are the most recent Conversations:" or "Click here to be the first 
				person to discuss this entry" if THREAD element is missing
	-->
  <xsl:template name="PeopleTalking">
    <xsl:choose>
      <xsl:when test="THREAD">
        <td>
          <span xsl:use-attribute-sets="nPeopleTalking">
            <xsl:value-of select="$m_peopletalking"/>
          </span>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td>
          <span xsl:use-attribute-sets="nPeopleTalking">
            <xsl:value-of select="$m_firsttotalk"/>
          </span>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="POST-LIST/POST">
	Author:		Igor Loboda
	Inputs:		-
	Context:    -
	Purpose:	Displays a Post list
	Call:		<xsl:apply-templates select="POST-LIST/POST">
	-->
  <xsl:template match="POST-LIST/POST">
    <xsl:apply-templates select="SITEID" mode="showfrom"/>
    <br/>
    <xsl:apply-templates select="THREAD/@THREADID" mode="LinkOnSubjectAB"/>
    <br/>
    <NOBR>
      (<xsl:apply-templates select="." mode="LastUserPost"/>)
    </NOBR>
    <br/>
    <NOBR>
      (<xsl:apply-templates select="." mode="LastReply"/>)
    </NOBR>
    <br/>
    <xsl:call-template name="postunsubscribe"/>
    <br/>
    <br/>
  </xsl:template>

  <!--
	<xsl:template match="RECENT-POSTS">

	Generic:	Possibly - some difference in messages displayed
	Purpose:	Display the list of recent posts on a user page
	-->
  <xsl:template match="RECENT-POSTS">
    <xsl:choose>
      <xsl:when test="$ownerisviewer = 1">
        <xsl:choose>
          <xsl:when test="POST-LIST">
            <!-- owner, full-->
            <xsl:call-template name="m_forumownerfull"/>
            <xsl:apply-templates select="POST-LIST/POST[@PRIVATE=0][position() &lt;=$limitentries]"/>
            <xsl:apply-templates select="POST-LIST/USER/USERID" mode="MorePosts"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- owner empty-->
            <xsl:call-template name="m_forumownerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="POST-LIST">
            <!-- visitor, full-->
            <xsl:call-template name="m_forumviewerfull"/>
            <xsl:apply-templates select="POST-LIST/POST[@PRIVATE=0][position() &lt;=$limitentries]"/>
            <xsl:apply-templates select="POST-LIST/USER/USERID" mode="MorePosts"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- visitor empty-->
            <xsl:call-template name="m_forumviewerempty"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="POST" mode="LastUserPost">
	Author:		Igor Loboda
	Context:    -
	Purpose:	Displays "(Posted: 3 Weeks Ago)" where "3 Weeks Ago" is
				a link-see <xsl:template match="DATE" mode="LastUserPost">
	Call:		<xsl:apply-templates select="POST" mode="LastUserPost">
	-->
  <xsl:template match="POST" mode="LastUserPost">
    <xsl:param name="attributes"/>
    <xsl:choose>
      <xsl:when test="THREAD/LASTUSERPOST">
        <xsl:value-of select="$m_postedcolon"/>
        <xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="LastUserPost">
          <xsl:with-param name="attributes" select="$attributes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_noposting"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
	<xsl:template match="POST" mode="LastReply">
	Author:		Igor Loboda
	Context:    -
	Purpose:	Displays "(Last reply: Last Week)" where "Last Week" is
				a link-see <xsl:template match="DATE" mode="LatestPost">
	Call:		<xsl:apply-templates select="POST" mode="LastReply">
	-->
  <xsl:template match="POST" mode="LastReply">
    <xsl:param name="attributes"/>
    <xsl:choose>
      <xsl:when test="HAS-REPLY &gt; 0">
        <xsl:choose>
          <xsl:when test="THREAD/LASTUSERPOST">
            <xsl:value-of select="$m_lastreply"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$m_newestpost"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="LatestPost">
          <xsl:with-param name="attributes" select="$attributes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_noreplies"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="POST" mode="NewPosts">
    <xsl:param name="attributes"/>
    <xsl:if test="@LASTPOSTCOUNTREAD">
      <A href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;show=20&amp;skip={floor(((number(@LASTPOSTCOUNTREAD)) div 20))*20}#pi{number(@LASTPOSTCOUNTREAD)+1}">
        <xsl:call-template name="ApplyAttributes">
          <xsl:with-param name="attributes" select="$attributes"/>
        </xsl:call-template>
        <xsl:choose>
          <xsl:when test="number(@LASTPOSTCOUNTREAD) = number(@COUNTPOSTS)">no new posts</xsl:when>
          <xsl:when test="(number(@COUNTPOSTS) - number(@LASTPOSTCOUNTREAD)) = 1">1 new post</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="(number(@COUNTPOSTS) - number(@LASTPOSTCOUNTREAD))"/> new posts
          </xsl:otherwise>
        </xsl:choose>
      </A>,
    </xsl:if>
  </xsl:template>


  <!--
	<xsl:template name="postunsubscribe">
	Author:		Tom Whitehouse
	Inputs:		attributes - extra attributes can be added to the a tag by including parameters
				of the form: <attribute name="class" value="darkfont"/>
	Context		should have THREAD/@FORUMID and THREAD/@THREADID
	Purpose:	Creates link to unsubscribe from a post
	Call:		<xsl:call-template name="postunsubscribe"/>
	-->
  <xsl:template name="postunsubscribe">
    <xsl:param name="embodiment" select="$m_unsubscribe"/>
    <xsl:param name="attributes"/>
    <xsl:if test="$ownerisviewer = 1">
      <xsl:choose>
        <xsl:when test="/H2G2[@TYPE='USERPAGE']">
          <a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}" xsl:use-attribute-sets="npostunsubscribe1">
            <xsl:call-template name="ApplyAttributes">
              <xsl:with-param name="attributes" select="$attributes"/>
            </xsl:call-template>
            <xsl:copy-of select="$embodiment"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a target="_top" href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntopostlist}&amp;return=MP{$viewerid}%3Fskip={../@SKIPTO}%26amp;show={../@COUNT}" xsl:use-attribute-sets="npostunsubscribe2">
            <xsl:call-template name="ApplyAttributes">
              <xsl:with-param name="attributes" select="$attributes"/>
            </xsl:call-template>
            <xsl:copy-of select="$embodiment"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template match="PAGE-OWNER">
	Generic:	No
	Purpose:	Display the details of the owner of a user page
	-->
  <xsl:template match="PAGE-OWNER">
    <table border="0" width="100%" cellpadding="3" cellspacing="0">
      <tr>
        <td>
          <span class="userdatatitle">
            <xsl:value-of select="$m_userdata"/>
            <br/>
            <br/>
          </span>
        </td>
      </tr>
      <tr valign="top">
        <td align="left">
          <span class="userdatalabel">
            <xsl:value-of select="$m_researcher"/>
          </span>
          <span class="userdatanumber">
            <xsl:value-of select="USER/USERID"/>
          </span>
        </td>
      </tr>
      <tr>
        <td align="left" valign="top">
          <span class="userdatalabel">
            <xsl:value-of select="$m_namecolon"/>
          </span>
          <span class="userdetailsname">
            <xsl:value-of select="USER/USERNAME"/>
          </span>
          <br/>
          <xsl:if test="$test_IsEditor">
            <span class="smallfont">
              <xsl:apply-templates select="USER/USERID" mode="Inspect"/>
              <br/>
              <a href="{$root}ModerationHistory?h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Moderation History</a>
              <br/>
            </span>
          </xsl:if>
          <xsl:if test="$test_CanEditMasthead">
            <br/>
            <xsl:call-template name="UserEditMasthead"/>
            <br/>
            <br/>
          </xsl:if>

          <xsl:if test="$ownerisviewer=0 and $registered=1">
            <a href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">Add to Friends</a>
            <br/>
          </xsl:if>
          <xsl:if test="USER/GROUPS/*">
            <span xsl:use-attribute-sets="pageauthorsfont">
              <xsl:value-of select="$m_memberof"/>
              <br/>
              <xsl:apply-templates select="USER/GROUPS"/>
            </span>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td align="left">
          <xsl:call-template name="m_entrysidebarcomplaint"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!--
	<xsl:template name="popupconversations">
	Purpose:	Display the conversation list in the popup window
	Call:		<xsl:call-template name="popupconversations"/>
	-->
  <xsl:template name="popupconversations">
    <xsl:variable name="target" select="/H2G2/PARAMS/PARAM[NAME='s_target']/VALUE"/>
    <xsl:variable name="skipparams">
      skip=<xsl:value-of select="POSTS/POST-LIST/@SKIPTO"/>&amp;show=<xsl:value-of select="POSTS/POST-LIST/@COUNT"/>&amp;
    </xsl:variable>
    <xsl:variable name="userid">
      <xsl:value-of select="POSTS/@USERID"/>
    </xsl:variable>
    <html>
      <head>
        <title>
          <xsl:value-of select="$m_myconversationstitle"/>
        </title>
        <meta content="120;url=MP{$userid}?{$skipparams}s_type=pop&amp;s_upto={PARAMS/PARAM[NAME='s_upto']/VALUE}&amp;s_target={$target}" http-equiv="REFRESH"/>
        <META NAME="robots" CONTENT="{$robotsetting}"/>
      </head>
      <body class="conversationbody">
        <div class="conversationpopup">
          <xsl:apply-templates select="DATE" mode="MorePosts">
            <xsl:with-param name="userid" select="$userid"/>
            <xsl:with-param name="skipparams" select="$skipparams"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="linkText" select="$m_MarkAllRead"/>
          </xsl:apply-templates>
          <br/>
          <table>
            <xsl:for-each select="POSTS/POST-LIST/POST[@PRIVATE=0]">
              <tr>
                <td valign="top">
                  <xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="MorePosts">
                    <xsl:with-param name="userid" select="$userid"/>
                    <xsl:with-param name="skipparams" select="$skipparams"/>
                    <xsl:with-param name="target" select="$target"/>
                    <xsl:with-param name="linkText" select="$m_MarkTillThis"/>
                  </xsl:apply-templates>
                </td>
                <td>
                  <xsl:if test="(number(/H2G2/PARAMS/PARAM[NAME='s_upto']/VALUE) &lt; number(concat(THREAD/REPLYDATE/DATE/@YEAR,THREAD/REPLYDATE/DATE/@MONTH,THREAD/REPLYDATE/DATE/@DAY,THREAD/REPLYDATE/DATE/@HOURS,THREAD/REPLYDATE/DATE/@MINUTES,THREAD/REPLYDATE/DATE/@SECONDS))) ">
                    <xsl:attribute name="bgcolor">
                      <xsl:value-of select="$catboxbg"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="SITEID" mode="showfrom"/>
                  <br/>
                  <xsl:apply-templates select="THREAD/@THREADID" mode="LinkOnSubject">
                    <xsl:with-param name="attributes">
                      <attribute name="target" value="{$target}"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <br/>
                  <xsl:apply-templates select="." mode="LastUserPost">
                    <xsl:with-param name="attributes">
                      <attribute name="target" value="{$target}"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <BR/>
                  <NOBR>
                    <xsl:apply-templates select="." mode="LastReply">
                      <xsl:with-param name="attributes">
                        <attribute name="target" value="{$target}"/>
                      </xsl:with-param>
                    </xsl:apply-templates>
                  </NOBR>
                </td>
              </tr>
            </xsl:for-each>
          </table>
          <xsl:if test="POSTS/POST-LIST[@SKIPTO &gt; 0]">
            <xsl:apply-templates select="POSTS/POST-LIST" mode="MorePosts">
              <xsl:with-param name="userid" select="$userid"/>
              <xsl:with-param name="target" select="$target"/>
              <xsl:with-param name="linkText">
                &lt;&lt;<xsl:value-of select="$m_newerpostings"/>
              </xsl:with-param>
              <xsl:with-param name="prev">1</xsl:with-param>
            </xsl:apply-templates>
            &nbsp;
          </xsl:if>
          <xsl:if test="POSTS/POST-LIST[@MORE=1]">
            <xsl:apply-templates select="POSTS/POST-LIST" mode="MorePosts">
              <xsl:with-param name="userid" select="$userid"/>
              <xsl:with-param name="target" select="$target"/>
              <xsl:with-param name="linkText">
                <xsl:value-of select="$m_olderpostings"/> &gt;&gt;
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:if>
          <br/>
        </div>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="POST" mode="shownew">
    <xsl:variable name="thread">
      <xsl:value-of select="THREAD/@THREADID"/>
    </xsl:variable>
    <xsl:variable name="threadread">
      <xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') = string($thread)]/VALUE,'|')"/>
    </xsl:variable>
    <xsl:if test="($threadread = '' or number(concat(THREAD/REPLYDATE/DATE/@YEAR,THREAD/REPLYDATE/DATE/@MONTH,THREAD/REPLYDATE/DATE/@DAY,THREAD/REPLYDATE/DATE/@HOURS,THREAD/REPLYDATE/DATE/@MINUTES,THREAD/REPLYDATE/DATE/@SECONDS)) &gt; $threadread) and (HAS-REPLY = 1)">1</xsl:if>
  </xsl:template>

  <xsl:template name="popupconversations2">
    <xsl:variable name="target" select="/H2G2/PARAMS/PARAM[NAME='s_target']/VALUE"/>
    <xsl:variable name="skipparams">
      skip=<xsl:value-of select="POSTS/POST-LIST/@SKIPTO"/>&amp;show=<xsl:value-of select="POSTS/POST-LIST/@COUNT"/>&amp;
    </xsl:variable>
    <xsl:variable name="userid">
      <xsl:value-of select="POSTS/@USERID"/>
    </xsl:variable>
    <xsl:variable name="newpost">
      <xsl:apply-templates select="POSTS/POST-LIST/POST[@PRIVATE=0]" mode="shownew"/>
    </xsl:variable>
    <xsl:variable name="lastpostbyusersort">
      <xsl:for-each select="/H2G2/POSTS/POST-LIST/POST[@PRIVATE=0]/THREAD/LASTUSERPOST/DATEPOSTED/DATE">
        <xsl:sort select="concat(@YEAR, @MONTH, @DAY, @HOURS, @MINUTES, @SECONDS)" order="descending"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="lastpostbyuser">
      <xsl:apply-templates select="msxsl:node-set($lastpostbyusersort)/DATE[1]"/>
    </xsl:variable>
    <html>
      <head>
        <title>
          <xsl:if test="/H2G2/POSTS/POST-LIST/POST[@PRIVATE=0][@LASTPOSTCOUNTREAD &lt; @COUNTPOSTS]">*</xsl:if>
          <xsl:value-of select="$m_myconversationstitle"/>
        </title>
        <meta http-equiv="REFRESH">
          <xsl:attribute name="content">
            120;url=MP<xsl:value-of select="$userid"/>?<xsl:value-of select="$skipparams"/>s_type=pop<xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME='s_t']" mode="ThreadRead"/>&amp;s_target=<xsl:value-of select="$target"/>
          </xsl:attribute>
        </meta>
        <xsl:call-template name="insert-headelements"/>
      </head>
      <body class="conversationbody">
        <div class="conversationpopup">
          <xsl:value-of select="$m_myconvsname"/>
          <xsl:apply-templates select="/H2G2/POSTS/POST-LIST/USER/USERNAME" mode="UserResult">
            <xsl:with-param name="attributes">
              <attribute name="target" value="{$target}"/>
            </xsl:with-param>
          </xsl:apply-templates>
          <br/>
          <xsl:choose>
            <xsl:when test="msxsl:node-set($lastpostbyusersort)/DATE">
              <xsl:value-of select="$m_myconvslastposted"/>
              <xsl:value-of select="$lastpostbyuser"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$m_norecentpostings"/>
            </xsl:otherwise>
          </xsl:choose>
          <br/>
          <xsl:apply-templates select="DATE" mode="MorePosts">
            <xsl:with-param name="userid" select="$userid"/>
            <xsl:with-param name="skipparams" select="$skipparams"/>
            <xsl:with-param name="target" select="$target"/>
            <xsl:with-param name="linkText" select="$m_MarkAllRead"/>
            <xsl:with-param name="allsame" select="true()"/>
            <xsl:with-param name="postlist" select="POSTS/POST-LIST/POST[@PRIVATE=0]"/>
          </xsl:apply-templates>
          <br/>
          <table>
            <xsl:for-each select="POSTS/POST-LIST/POST[@PRIVATE=0]">
              <xsl:variable name="thread">
                <xsl:value-of select="THREAD/@THREADID"/>
              </xsl:variable>
              <xsl:variable name="threadread">
                <xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') = string($thread)]/VALUE,'|')"/>
              </xsl:variable>
              <tr>
                <td valign="top">
                  <xsl:choose>
                    <xsl:when test="($threadread = '' or number(concat(THREAD/REPLYDATE/DATE/@YEAR,THREAD/REPLYDATE/DATE/@MONTH,THREAD/REPLYDATE/DATE/@DAY,THREAD/REPLYDATE/DATE/@HOURS,THREAD/REPLYDATE/DATE/@MINUTES,THREAD/REPLYDATE/DATE/@SECONDS)) &gt; $threadread) and (HAS-REPLY = 1)">
                      <xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="MorePosts">
                        <xsl:with-param name="userid" select="$userid"/>
                        <xsl:with-param name="skipparams" select="$skipparams"/>
                        <xsl:with-param name="target" select="$target"/>
                        <xsl:with-param name="linkText" select="$m_MarkTillThis"/>
                        <xsl:with-param name="thread" select="THREAD/@THREADID"/>
                        <!-- ***this is not filtering properly *** -->
                        <xsl:with-param name="threadparams" select="/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') != string($thread)]"/>
                      </xsl:apply-templates>
                      <br/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="MorePosts">
                        <xsl:with-param name="userid" select="$userid"/>
                        <xsl:with-param name="skipparams" select="$skipparams"/>
                        <xsl:with-param name="target" select="$target"/>
                        <xsl:with-param name="linkText" select="'&lt;&lt;'"/>
                        <xsl:with-param name="thread" select="THREAD/@THREADID"/>
                        <xsl:with-param name="adjust" select="-1"/>
                        <xsl:with-param name="threadparams" select="/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') != string($thread)]"/>
                      </xsl:apply-templates>
                      <br/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="MorePosts">
                    <xsl:with-param name="userid" select="$userid"/>
                    <xsl:with-param name="skipparams" select="$skipparams"/>
                    <xsl:with-param name="target" select="$target"/>
                    <xsl:with-param name="linkText" select="'^^'"/>
                    <xsl:with-param name="allsame" select="true()"/>
                    <xsl:with-param name="postlist" select="../POST"/>
                  </xsl:apply-templates>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="not(@LASTPOSTCOUNTREAD) or number(@LASTPOSTCOUNTREAD) &lt; number(@COUNTPOSTS)">
                      <xsl:attribute name="class">conversationunread</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">conversationread</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:apply-templates select="SITEID" mode="showfrom"/>
                  <br/>
                  <xsl:apply-templates select="THREAD/@THREADID" mode="LinkOnSubject">
                    <xsl:with-param name="attributes">
                      <attribute name="target" value="{$target}"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <br/>
                  <xsl:apply-templates select="." mode="LastUserPost">
                    <xsl:with-param name="attributes">
                      <attribute name="target" value="{$target}"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <BR/>
                  <NOBR>
                    <xsl:apply-templates select="." mode="NewPosts">
                      <xsl:with-param name="attributes">
                        <attribute name="target" value="{$target}"/>
                      </xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="LastReply">
                      <xsl:with-param name="attributes">
                        <attribute name="target" value="{$target}"/>
                      </xsl:with-param>
                    </xsl:apply-templates>
                  </NOBR>
                </td>
              </tr>
            </xsl:for-each>
          </table>
          <xsl:if test="POSTS/POST-LIST[@SKIPTO &gt; 0]">
            <xsl:apply-templates select="POSTS/POST-LIST" mode="MorePosts">
              <xsl:with-param name="userid" select="$userid"/>
              <xsl:with-param name="target" select="$target"/>
              <xsl:with-param name="linkText">
                &lt;&lt;<xsl:value-of select="$m_newerpostings"/>
              </xsl:with-param>
              <xsl:with-param name="prev">1</xsl:with-param>
            </xsl:apply-templates>
            &nbsp;
          </xsl:if>
          <xsl:if test="POSTS/POST-LIST[@MORE=1]">
            <xsl:apply-templates select="POSTS/POST-LIST" mode="MorePosts">
              <xsl:with-param name="userid" select="$userid"/>
              <xsl:with-param name="target" select="$target"/>
              <xsl:with-param name="linkText">
                <xsl:value-of select="$m_olderpostings"/> &gt;&gt;
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:if>
          <br/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="PARAM" mode="debug">
    -- <xsl:value-of select="NAME"/>--<xsl:value-of select="VALUE"/><br/>
  </xsl:template>

  <xsl:template match="PARAM" mode="ThreadRead">
    <xsl:param name="setdate"/>
    <xsl:param name="date"/>
    <xsl:text>&amp;s_t=</xsl:text>
    <xsl:choose>
      <xsl:when test="$setdate">
        <xsl:value-of select="$date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="VALUE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="POST" mode="ThreadRead">
    <xsl:param name="date"/>
    <xsl:text>&amp;s_t=</xsl:text>
    <xsl:value-of select="THREAD/@THREADID"/>|<xsl:value-of select="$date"/>
  </xsl:template>


  <!--
		<xsl:template match="ARTICLE-EDIT-FORM">

		Generic:	No
		Purpose:	Form used inb the edit page code
	-->
  <xsl:template match="ARTICLE-EDIT-FORM">
    <FORM METHOD="POST" action="{$root}Edit" ONSUBMIT="return runSubmit()" TITLE="Article Editing Form">
      <xsl:apply-templates select="." mode="HiddenInputs"/>
      <xsl:call-template name="articlepremoderationmessage"/>
      <table width="100%" cellpadding="0" cellspacing="2" border="0">
        <tr>
          <td>
            <xsl:if test="@PROFANITYTRIGGERED = 1">
              <p style=" font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This entry has been blocked as it contains a word which other users may find offensive. Please edit your entry and post it again.</p>
            </xsl:if>
            <!-- article subject -->
            <span class="articleeditsubject">
              <xsl:value-of select="$m_fsubject"/>
              <xsl:apply-templates select="." mode="Subject"/>
            </span>
          </td>
          <td>&nbsp;</td>

          <td>
            <span class="smallfont">
              <xsl:copy-of select="$m_UserEditWarning"/>
            </span>
          </td>
        </tr>
      </table>
      <xsl:value-of select="$m_content"/><BR/>
      <TEXTAREA NAME="body" COLS="70" ROWS="20" WRAP="virtual" TITLE="{$alt_contentofguideentry}">
        <xsl:value-of select="CONTENT"/>
      </TEXTAREA>
      <BR/>
      <!-- preview in skin -->
      <xsl:value-of select="$m_previewinskin"/>
      <xsl:call-template name="SelectSkin"/>
      &nbsp;
      <INPUT TYPE="submit" NAME="preview" TITLE="{$alt_previewhowlook}">
        <xsl:attribute name="VALUE">
          <xsl:value-of select="$m_preview"/>
        </xsl:attribute>
      </INPUT>
      &nbsp;
      <!-- add entry -->
      <xsl:apply-templates select="FUNCTIONS/ADDENTRY"/>
      <!-- update entry -->
      <xsl:apply-templates select="FUNCTIONS/UPDATE"/>
      <xsl:if test="$test_IsEditor or ($superuser=1)">
        <xsl:apply-templates select="STATUS|EDITORID" mode="ArticleEdit"/>
      </xsl:if>
      <!-- hide entry -->
      <xsl:if test="FUNCTIONS/HIDE">
        &nbsp;
        <xsl:value-of select="$m_HideEntry"/>
        <xsl:apply-templates select="FUNCTIONS/HIDE"/>
      </xsl:if>
      <!-- not for review check box -->
      <xsl:if test="FUNCTIONS/CHANGE-SUBMITTABLE">
        <BR/>
        <BR/>
        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="2" BORDER="0">
          <TR>
            <TD WIDTH="200">
              <xsl:apply-templates select="/H2G2/ARTICLE-EDIT-FORM/SUBMITTABLE"/>
              <xsl:value-of select="$m_notforreviewtext"/>
            </TD>
            <TD>
              <xsl:call-template name="m_notforreview_explanation"/>
            </TD>
          </TR>
        </TABLE>
      </xsl:if>
      <BR/><BR/>
      <!-- format: guideml or plaintext -->
      <xsl:apply-templates select="FORMAT" mode="GuideMLOrOther"/>
      <INPUT TYPE="submit" NAME="reformat">
        <xsl:attribute name="VALUE">
          <xsl:value-of select="$m_changestyle"/>
        </xsl:attribute>
      </INPUT>
      <BR/><BR/>
      <!-- help on writing the article -->
      <xsl:apply-templates select="/H2G2/HELP" mode="WritingGE"/>
      <P>
        <xsl:apply-templates select="." mode="MustSaveFirst"/>
      </P>

      <!-- researchers -->
      <!-- only show the researcher list for non-masthead entries -->
      <xsl:if test="$test_ShowResearchers">
        <!-- show the list of researchers, and allow editing -->
        <p>
          <span class="subheaderfont">
            <xsl:value-of select="$m_edittheresearcherlisttext"/>
          </span>
        </p>
        <P>
          <xsl:value-of select="$m_ResList"/>
          <br/>
          <xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="Researchers"/>
        </P>
        <xsl:value-of select="$m_ResListEdit"/>
        <BR/>
        <textarea name="ResearcherList" cols="60" rows="3">
          <xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="EditResearchers"/>
        </textarea>
        <br/>
        <input type="submit" name="SetResearchers" value="{$m_SetResearchers}"/>
      </xsl:if>
    </FORM>

    <!-- move to site -->
    <xsl:if test="FUNCTIONS/MOVE-TO-SITE">
      <h3>
        <xsl:value-of select="$m_MoveToSite"/>
      </h3>
      <xsl:apply-templates select="SITEID" mode="MoveToSite">
        <xsl:with-param name="objectID" select="H2G2ID"/>
      </xsl:apply-templates>
    </xsl:if>


    <!-- delete -->
    <xsl:if test="FUNCTIONS/DELETE">
      <P>
        <span class="subheaderfont">
          <xsl:value-of select="$m_deletethisentry"/>
        </span>
      </P>
      <P>
        <xsl:value-of select="$m_deletebypressing"/>
      </P>
      <xsl:apply-templates select="FUNCTIONS/DELETE" mode="Form"/>
    </xsl:if>

    <!-- insert the disclaimer about the house rules -->
    <P>
      <xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
    </P>
    <!-- replacement text explaining new system -->
    <xsl:if test="MASTHEAD[. != '1']">
      <P>
        <span class="subheaderfont">
          <xsl:value-of select="$m_recommendtitle"/>
        </span>
      </P>
      <xsl:call-template name="m_recommendtext"/>
    </xsl:if>
  </xsl:template>


  <!--
<xsl:template name="PostYouArePremoderated">
Author:		Igor Loboda
Context:    -
Purpose:	Generates "Your are premoderated" message
Call:		<xsl:call-template name="PostYouArePremoderated">
-->
  <xsl:template name="PostYouArePremoderated">
    <p>
      <b>
        <xsl:value-of select="$m_PleaseNoteCS"/>
      </b>
      <xsl:value-of select="$m_PostYourePremod"/>
    </p>
  </xsl:template>

  <!--
<xsl:template name="PostSiteIsPremod">
Author:		Igor Loboda
Context:    -
Purpose:	Generates "Site is premoderated" message
Call:		<xsl:call-template name="PostSiteIsPremod">
-->
  <xsl:template name="PostSiteIsPremod">
    <p>
      <xsl:value-of select="$m_PostSitePremod"/>
    </p>
  </xsl:template>

  <!--
<xsl:template match="POSTTHREADFORM" mode="Preview">
Author:		Igor Loboda
Context:    -
Purpose:	Generates preview part of the POSTTHREADFORM
Call:		<xsl:apply-templates select="POSTTHREADFORM" mode="Preview">
-->
  <xsl:template match="POSTTHREADFORM" mode="Preview">
    <xsl:if test="$test_PreviewError">
      <B>
        <xsl:apply-templates select="PREVIEWERROR"/>
      </B>
      <BR/>
    </xsl:if>
    <xsl:if test="$test_HasPreviewBody">
      <B>
        <xsl:value-of select="$m_whatpostlooklike"/>
      </B>
      <BR/>
      <TABLE WIDTH="100%">
        <TR>
          <TD width="100%">
            <HR/>
          </TD>
          <TD nowrap="1"/>
        </TR>
      </TABLE>
      <span xsl:use-attribute-sets="forumpostedlabel">
        <xsl:value-of select="$m_postedsoon"/>
      </span>
      <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="UserName"/>
      <BR/>
      <span xsl:use-attribute-sets="forumsubjectlabel">
        <xsl:value-of select="$m_fsubject"/>
      </span>
      <B>
        <span xsl:use-attribute-sets="forumsubject">
          <xsl:value-of select="SUBJECT"/>
        </span>
      </B>
      <BR/>
      <xsl:apply-templates select="PREVIEWBODY"/>
      <BR/>
    </xsl:if>
  </xsl:template>

  <!--
<xsl:template match="POSTTHREADFORM" mode="Post">
Author:		Igor Loboda
Context:    -
Purpose:	Generates post part of the POSTTHREADFORM
Call:		<xsl:apply-templates select="POSTTHREADFORM" mode="Post">
-->
  <xsl:template match="POSTTHREADFORM" mode="Post">
    <xsl:value-of select="$m_nicknameis"/>
    <B>
      <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
    </B>.
    <BR/>
    <xsl:call-template name="postpremoderationmessage"/>
    <FORM xsl:use-attribute-sets="fPOSTTHREADFORM">
      <xsl:apply-templates select="." mode="HiddenInputs"/>
      <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="2" BORDER="0">
        <TR>
          <TD>
            <span xsl:use-attribute-sets="mPOSTTHREADFORM_Subj">
              <xsl:if test="/H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED = 1">
                <p style="font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">
                  This message has been blocked as it contains a word which other users may find offensive. Please edit your message and post it again.<br/>&nbsp;<br/>
                </p>
              </xsl:if>
              <xsl:value-of select="$m_fsubject"/>
              <xsl:apply-templates select="." mode="Subject"/>
            </span>
          </TD>
          <TD>&nbsp;</TD>
          <TD>
            <span class="smallfont">
              <xsl:copy-of select="$m_UserEditWarning"/>
            </span>
          </TD>
        </TR>
      </TABLE>
      <xsl:value-of select="$m_textcolon"/>
      <BR/>
      <TEXTAREA NAME="body" COLS="70" ROWS="15" WRAP="VIRTUAL">
        <xsl:value-of select="BODY"/>
      </TEXTAREA>
      <BR/>
      <INPUT TYPE="SUBMIT" NAME="preview" VALUE="{$alt_previewmess}"/>
      <INPUT TYPE="SUBMIT" NAME="post" VALUE="{$alt_postmess}"/>
    </FORM>
    <BR/>
    <xsl:apply-templates select="." mode="ReturnTo"/>
    <BR/>
    <BR/>
    <P>
      <xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
    </P>
    <xsl:if test="INREPLYTO">
      <span class="replyingto">
        <xsl:value-of select="$m_messageisfrom"/>
        <xsl:value-of select="INREPLYTO/USERNAME"/>
      </span>
      <br/>
      <xsl:apply-templates select="INREPLYTO/BODY"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="POSTTHREADFORM">
	Generic:	No
	Purpose:	Displays the thread post form (with preview)
-->
  <xsl:template match="POSTTHREADFORM">
    <xsl:apply-templates select="." mode="Preview"/>
    <xsl:apply-templates select="." mode="Post"/>
  </xsl:template>

  <!--
<xsl:template match="USERNAME">
Context:    checks for EDITOR
Generic:	Yes
Purpose:	Displays a username (in bold/italic if necessary)
-->
  <xsl:template match="USERNAME">
    <xsl:choose>
      <xsl:when test="../EDITOR = 1">
        <B>
          <I>
            <xsl:apply-templates/>
          </I>
        </B>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER[@COMMAND='normal']">
Context:    -
Purpose:	Registration form
-->
  <xsl:template match="NEWREGISTER[@COMMAND='normal']">
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <xsl:call-template name="m_bbcregblurb"/>
    <br/>

    <FORM xsl:use-attribute-sets="fNEWREGISTER">
      <xsl:apply-templates select="." mode="HiddenInputsNormal"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_InputLoginName"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_confirmbbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password2"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_emailaddr"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Email"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Remember"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <TR>
          <TD COLSPAN="2">
            <xsl:call-template name="m_terms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Terms"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="m_agreetoterms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Register"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER[@COMMAND='fasttrack']">
Context:    -
Purpose:	Login form
-->
  <xsl:template match="NEWREGISTER[@COMMAND='fasttrack']">
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <xsl:call-template name="m_bbcloginblurb"/>
    <br/>
    <FORM xsl:use-attribute-sets="fNEWREGISTER">
      <xsl:apply-templates select="." mode="HiddenInputsFasttrack"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_InputLoginName"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Remember"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <xsl:if test="@STATUS='NOTERMS'">
          <TR>
            <TD COLSPAN="2">
              <xsl:call-template name="m_terms"/>
            </TD>
          </TR>
          <TR>
            <TD/>
            <TD>
              <input xsl:use-attribute-sets="iNEWREGISTER_Terms"/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="m_agreetoterms"/>
            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Login"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM">
Purpose:	Forum for posting to a journal
-->
  <xsl:template match="POSTJOURNALFORM">
    <xsl:choose>
      <xsl:when test="WARNING">
        <b>
          <xsl:value-of select="$m_warningcolon"/>
        </b>
        <xsl:value-of select="WARNING"/>
      </xsl:when>
      <xsl:when test="PREVIEWBODY">
        <b>
          <xsl:value-of select="$m_journallooklike"/>
        </b>
        <hr/>
        <br/>
        <span xsl:use-attribute-sets="journaltitle">
          <b>
            <xsl:value-of select="SUBJECT"/>
          </b>
          (<xsl:value-of select="$m_soon"/>)
          <br/>
          <xsl:apply-templates select="PREVIEWBODY"/>
        </span>
        <br/>
        <hr/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$m_journalintroUI"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="postpremoderationmessage"/>
    <xsl:apply-templates select="." mode="Form"/>
    <br/>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM" mode="Form">
Author:		Igor Loboda
Context:    -
Purpose:	Generates post part of the POSTJOURNALFORM
Call:		<xsl:apply-templates select="." mode="Form">
-->
  <xsl:template match="POSTJOURNALFORM" mode="Form">
    <form xsl:use-attribute-sets="asfPOSTJOURNALFORM">
      <xsl:value-of select="$m_fsubject"/>
      <xsl:apply-templates select="." mode="Subject"/>
      <br/>
      <xsl:apply-templates select="." mode="Body"/>
      <br/>
      <input xsl:use-attribute-sets="asiPOSTJOURNALFORM_PreviewBtn"/>
      <input xsl:use-attribute-sets="asiPOSTJOURNALFORM_StoreBtn"/>
    </form>
  </xsl:template>

  <!--
	<xsl:template match="USER-DETAILS-FORM">
	Generic:	No
	Purpose:	Form for editing user details
-->
  <xsl:template match="USER-DETAILS-FORM">
    <xsl:apply-templates select="MESSAGE"/>
    <xsl:if test="MESSAGE[@TYPE='']">
      <xsl:call-template name="m_spacingaboveudetails"/>
    </xsl:if>
    <TABLE vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
      <FORM xsl:use-attribute-sets="asfUSER-DETAILS-FORM">
        <TR>
          <xsl:apply-templates select="." mode="HiddenInputs"/>
        </TR>

        <xsl:if test="$changeableskins">
          <TR>
            <TD align="RIGHT">
              <xsl:value-of select="$m_skin"/>
            </TD>
            <TD>
              <xsl:apply-templates select="." mode="SkinList"/>
            </TD>
            <TD/>
          </TR>
        </xsl:if>

        <xsl:if test="$expertmode">
          <TR>
            <TD align="RIGHT">
              <xsl:value-of select="$m_usermode"/>
            </TD>
            <TD>
              <xsl:apply-templates select="." mode="PrefMode"/>
            </TD>
            <TD/>
          </TR>
        </xsl:if>

        <xsl:if test="$framesmode">
          <TR>
            <TD align="RIGHT">
              <xsl:value-of select="$m_forumstyle"/>
            </TD>
            <TD>
              <xsl:apply-templates select="." mode="PrefForumStyle"/>
            </TD>
            <TD/>
          </TR>
        </xsl:if>

        <TR>
          <TD align="RIGHT">
            Stylesheet:
          </TD>
          <TD>
            <INPUT type="hidden" name="p_name" value="plaincss"/>
            <INPUT name="plaincss" type="text" value="{/H2G2/VIEWING-USER/USER/SITEPREFERENCES/PLAINCSS/@VALUE}"/>
            <INPUT type="hidden" name="p_name" value="blob"/>

            <INPUT name="blob" type="radio" value="white">
              <xsl:if test="/H2G2/VIEWING-USER/USER/SITEPREFERENCES/BLOB[@VALUE='white']">
                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              </xsl:if>
            </INPUT> White
            <INPUT name="blob" type="radio" value="blue">
              <xsl:if test="/H2G2/VIEWING-USER/USER/SITEPREFERENCES/BLOB[@VALUE='blue']">
                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              </xsl:if>
            </INPUT> Blue

          </TD>
          <TD/>
        </TR>

        <!--TR>
				<TD align="RIGHT">
						<xsl:value-of select="$m_emailaddr"/>
				</TD>
				<TD>
						<xsl:apply-templates select="." mode="Email"/>
				</TD>
				<TD/>
			</TR-->
        <xsl:apply-templates select="SITEPREFERENCES" mode="UserDetailsForm"/>
        <!--TR>
			<TD/>
			<TD COLSPAN="2" VALIGN="top">
					<br/>
					<xsl:copy-of select="$m_changepasswordmessage"/>
					<br/>
					<br/>
			</TD>
			</TR>
			<TR>
				<TD align="RIGHT">
						<xsl:value-of select="$m_oldpassword"/>
				</TD>
				<TD>
						<INPUT xsl:use-attribute-sets="asiUSER-DETAILS-FORM_Password"/>
				</TD>
				<TD rowspan="3" valign="top"/>
			</TR>
			<TR>
				<TD align="RIGHT">
						<xsl:value-of select="$m_newpassword"/>
				</TD>
				<TD>
						<INPUT xsl:use-attribute-sets="asiUSER-DETAILS-FORM_NewPassword"/>
				</TD>
			</TR>
			<TR>
				<TD align="RIGHT">
						<xsl:value-of select="$m_confirmpassword"/>
				</TD>
				<TD>
						<INPUT xsl:use-attribute-sets="asiUSER-DETAILS-FORM_NewPasswordConf"/>
				</TD>
			</TR-->
        <TR>
          <TD>
            <BR/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <INPUT xsl:use-attribute-sets="asiUSER-DETAILS-FORM_Submit"/>
          </TD>
        </TR>
      </FORM>
    </TABLE>
    <BR/>
    <xsl:copy-of select="$m_changepasswordexternal"/>
    <BR/>
    <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="USER-DETAILS-FORM"/>.
  </xsl:template>

  <!--
	<xsl:template match="FORUMTHREADS" mode="forumpostblocks">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	Call to forumpostblocks
	Call:		<xsl:apply-templates select="FORUMTHREADS" mode="forumpostblocks"/>
-->
  <xsl:template match="FORUMTHREADS" mode="forumpostblocks">
    <xsl:call-template name="forumpostblocks">
      <xsl:with-param name="forum" select="@FORUMID"/>
      <xsl:with-param name="skip" select="0"/>
      <xsl:with-param name="show" select="@COUNT"/>
      <xsl:with-param name="total" select="@TOTALTHREADS"/>
      <xsl:with-param name="this" select="@SKIPTO"/>
    </xsl:call-template>
  </xsl:template>

  <!--
<xsl:template name="THREADS_MAINBODY">
Author:		Igor Loboda
Context:    -
Purpose:	Generates conversation list
Call:		<xsl:call-template name="THREADS_MAINBODY"/>
-->
  <xsl:template name="THREADS_MAINBODY">
    <br/>
    <xsl:call-template name="showforumintro"/>
    <xsl:for-each select="FORUMTHREADS">
      <xsl:call-template name="threadnavbuttons">
        <xsl:with-param name="URL">F</xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <br/>
    <xsl:apply-templates select="FORUMTHREADS" mode="forumpostblocks"/>
    <br/>
    <br/>
    <xsl:for-each select="FORUMTHREADS/THREAD">
      <span class="threadtitle">
        <xsl:apply-templates select="@THREADID" mode="THREADS_MAINBODY"/>
      </span>
      <br/>
      <span class="threadlastposting">
        <xsl:value-of select="$m_LastPost"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY_Date"/>
      </span>
      <br/>
      <span class="threadlastposting">
        <xsl:if test="$test_IsEditor">
          <xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>
          <br/>
          <br/>
        </xsl:if>
      </span>
    </xsl:for-each>
    <!-- if it is a review forum don't display in all skins-->
    <xsl:if test="not(/H2G2/FORUMSOURCE[@TYPE='reviewforum'])">
      <xsl:if test="$test_AllowNewConversationBtn">
        <xsl:apply-templates select="FORUMTHREADS/@FORUMID" mode="THREADS_MAINBODY_UI"/>
      </xsl:if>
    </xsl:if>
    <br/>
    <xsl:if test="$registered=1">
      <xsl:apply-templates select="FORUMTHREADS" mode="SubscribeUnsub"/>
    </xsl:if>
    <br/>
    <br/>
  </xsl:template>
  <!-- 
<xsl:template name="movethreadgadget"/> exists for uploading purposes - will be removed - TW
 -->
  <xsl:template name="movethreadgadget"/>
  <xsl:template name="removejournalpost"/>

  <!--
<xsl:template match="@FORUMID" mode="THREADS_MAINBODY_UI">
Author:		Igor Loboda
Context:    -
Purpose:	Calls <xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY"/>. 
			Provides a place to override UI.
Call:		<xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY_UI"/>
-->
  <xsl:template match="@FORUMID" mode="THREADS_MAINBODY_UI">
    <center>
      <xsl:apply-templates select="." mode="THREADS_MAINBODY"/>
    </center>
  </xsl:template>

  <!--
<xsl:template match="@INDEX" mode="Footnote">
Author:		Igor Loboda
Context:    -
Purpose:	Displayes superscript index. Provides a place to override UI.
Call:		<xsl:apply-templates select="@INDEX" mode="Footnote"/>
-->
  <xsl:template match="@INDEX" mode="Footnote">
    <span class="footnoteindex">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <!--
<xsl:template match="FOOTNOTE" mode="BottomText">
Author:		Igor Loboda
Context:    -
Purpose:	Displayes footnote text in the footnote table. Provides a place to override UI.
Call:		<xsl:apply-templates select="." mode="BottomText"/>
-->
  <xsl:template match="FOOTNOTE" mode="BottomText">
    <span class="footnotetext">
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER[@COMMAND='normal']">
Context:    -
Purpose:	Registration form
-->
  <xsl:template match="NEWREGISTER[@COMMAND='normal']">
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <xsl:call-template name="m_bbcregblurb"/>
    <br/>

    <FORM xsl:use-attribute-sets="fNEWREGISTER">
      <xsl:apply-templates select="." mode="HiddenInputsNormal"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_InputLoginName"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_confirmbbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password2"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_emailaddr"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Email"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Remember"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <TR>
          <TD COLSPAN="2">
            <xsl:call-template name="m_terms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Terms"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="m_agreetoterms"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Register"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>
  </xsl:template>

  <!--
<xsl:template match="NEWREGISTER[@COMMAND='fasttrack']">
Context:    -
Purpose:	Login form
-->
  <xsl:template match="NEWREGISTER[@COMMAND='fasttrack']">
    <div class="registererror">
      <xsl:call-template name="register-mainerror"/>
    </div>
    <br/>
    <xsl:call-template name="m_bbcloginblurb"/>
    <br/>
    <FORM xsl:use-attribute-sets="fNEWREGISTER">
      <xsl:apply-templates select="." mode="HiddenInputsFasttrack"/>
      <xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
      <TABLE BORDER="0">
        <TR>
          <TD>
            <xsl:value-of select="$m_loginname"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_InputLoginName"/>
          </TD>
        </TR>
        <TR>
          <TD>
            <xsl:value-of select="$m_bbcpassword"/>
          </TD>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Password"/>
          </TD>
        </TR>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Remember"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$m_alwaysremember"/>
          </TD>
        </TR>
        <xsl:if test="@STATUS='NOTERMS'">
          <TR>
            <TD COLSPAN="2">
              <span class="smallfont">
                <xsl:call-template name="m_terms"/>
              </span>
            </TD>
          </TR>
          <TR>
            <TD/>
            <TD>
              <input xsl:use-attribute-sets="iNEWREGISTER_Terms"/>
              <xsl:text> </xsl:text>
              <xsl:call-template name="m_agreetoterms"/>
            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TD/>
          <TD>
            <input xsl:use-attribute-sets="iNEWREGISTER_Login"/>
          </TD>
        </TR>
      </TABLE>
    </FORM>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM">
Purpose:	Forum for posting to a journal
-->
  <xsl:template match="POSTJOURNALFORM">
    <xsl:choose>
      <xsl:when test="WARNING">
        <b>
          <xsl:value-of select="$m_warningcolon"/>
        </b>
        <xsl:value-of select="WARNING"/>
      </xsl:when>
      <xsl:when test="PREVIEWBODY">
        <b>
          <xsl:value-of select="$m_journallooklike"/>
        </b>
        <hr/>
        <br/>
        <span xsl:use-attribute-sets="journaltitle">
          <b>
            <xsl:value-of select="SUBJECT"/>
          </b>
          (<xsl:value-of select="$m_soon"/>)
          <br/>
          <xsl:apply-templates select="PREVIEWBODY"/>
        </span>
        <br/>
        <hr/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$m_journalintroUI"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="postpremoderationmessage"/>
    <xsl:apply-templates select="." mode="Form"/>
    <br/>
  </xsl:template>

  <!--
<xsl:template match="POSTJOURNALFORM" mode="Form">
Author:		Igor Loboda
Context:    -
Purpose:	Generates post part of the POSTJOURNALFORM
Call:		<xsl:apply-templates select="." mode="Form">
-->
  <xsl:template match="POSTJOURNALFORM" mode="Form">
    <form xsl:use-attribute-sets="asfPOSTJOURNALFORM">
      <xsl:value-of select="$m_fsubject"/>
      <xsl:apply-templates select="." mode="Subject"/>
      <br/>
      <xsl:apply-templates select="." mode="Body"/>
      <br/>
      <input xsl:use-attribute-sets="asiPOSTJOURNALFORM_PreviewBtn"/>
      <input xsl:use-attribute-sets="asiPOSTJOURNALFORM_StoreBtn"/>
    </form>
  </xsl:template>


  <!--
<xsl:template match="JOURNAL">
Generic:	No
Purpose:	Displays the journal entries
-->
  <xsl:template match="H2G2/JOURNAL">
    <xsl:choose>
      <xsl:when test="JOURNALPOSTS/POST">
        <!-- owner, full -->
        <xsl:call-template name="JournalFullMsg"/>
        <xsl:apply-templates select="JOURNALPOSTS"/>
        <br/>
        <xsl:if test="JOURNALPOSTS[@MORE=1]">
          <xsl:apply-templates select="JOURNALPOSTS" mode="MoreJournal"/>
          <br/>
        </xsl:if>
        <br/>
        <xsl:if test="$test_MayAddToJournal">
          <xsl:call-template name="ClickAddJournal"/>
          <br/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- owner empty -->
        <xsl:call-template name="JournalEmptyMsg"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
<xsl:template match="JOURNALPOSTS/POST">
Generic:	No
Purpose:	Displays a single journal post
-->
  <xsl:template match="JOURNALPOSTS/POST">
    <xsl:if test="not(@HIDDEN &gt; 0)">
      <B>
        <xsl:value-of select="SUBJECT"/>
      </B>
      (<xsl:apply-templates select="DATEPOSTED/DATE"/>)
      <br/>
      <xsl:apply-templates select="TEXT"/>
      <br/>
      <xsl:apply-templates select="@POSTID" mode="DiscussJournalEntry"/>
      <br/>
      <xsl:choose>
        <xsl:when test="number(LASTREPLY/@COUNT) &gt; 1">
          (<xsl:apply-templates select="@THREADID" mode="JournalEntryReplies"/>,
          <xsl:value-of select="$m_latestreply"/>
          <xsl:apply-templates select="@THREADID" mode="JournalLastReply"/>)
        </xsl:when>
        <xsl:otherwise>
          (<xsl:value-of select="$m_noreplies"/>)
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <xsl:if test="$test_MayRemoveJournalPost">
        <xsl:apply-templates select="@THREADID" mode="JournalRemovePost"/>
        <br/>
      </xsl:if>
      <br/>
    </xsl:if>
  </xsl:template>

  <!--
<xsl:template name="MOREPOSTS_MAINBODY">
Author:		,Igor Loboda
Context:    -
Purpose:	Displays posts list
Call:		<xsl:call-template name="MOREPOSTS_MAINBODY"/>
-->
  <xsl:template name="MOREPOSTS_MAINBODY">
    <br/>
    <script language="javascript">
      <xsl:comment>
        function popupwindow(link, target, parameters)
        {
        popupWin = window.open(link,target,parameters);
        }
        //
      </xsl:comment>
    </script>
    <blockquote>
      <table width="100%">
        <tr>
          <td valign="top">
            <xsl:apply-templates select="POSTS/POST-LIST/POST[@PRIVATE=0][(position() mod 2) = 1]"/>
          </td>
          <td valign="top">
            <xsl:apply-templates select="POSTS/POST-LIST/POST[@PRIVATE=0][(position() mod 2) = 0]"/>
          </td>
        </tr>
      </table>
      <br/>
      <xsl:if test="POSTS/POST-LIST[@SKIPTO &gt; 0]">
        <xsl:apply-templates select="POSTS/@USERID" mode="NewerPostings"/>&nbsp;
      </xsl:if>
      <xsl:if test="POSTS/POST-LIST[@MORE=1]">
        <xsl:apply-templates select="POSTS/@USERID" mode="OlderPostings"/>
      </xsl:if>
      <xsl:if test="not(POSTS/POST-LIST)">
        <xsl:copy-of select="m_NoConversations"/>
        <br/>
      </xsl:if>
      <br/>
      <xsl:apply-templates select="POSTS" mode="ToPSpaceFromMP"/>
    </blockquote>
  </xsl:template>

  <!-- ********************************************************************************************************************************************** -->
  <!-- ********************             Generic Index Page templates              *********************** -->
  <!--                                                      12/06/2002                                                              -->
  <!-- ***************************************************************************************************** -->
  <!-- ******************************************************************************************** -->


  <!--
<xsl:template match="INDEX_MAINBODY">
Author:		Dharmesh Raithatha
Inputs:		-
Context:    -
Purpose:	Displays the mainbody of th index page
Call:		<xsl:call-template name="INDEX_MAINBODY">
-->

  <xsl:template name="INDEX_MAINBODY">
    <br/>
    <CENTER>
      <xsl:call-template name="alphaindex"/>
    </CENTER>
    <br/>
    <BLOCKQUOTE>
      <xsl:apply-templates select="INDEX"/>
    </BLOCKQUOTE>
  </xsl:template>

  <!--
<xsl:template match="INDEX">
Author:		Dharmesh Raithatha
Inputs:		-
Context:    -
Purpose:	Displays the Index of Guide Entries
Call:		<xsl:apply-templates select="INDEX">
-->

  <xsl:template match="INDEX">
    <xsl:apply-templates select="INDEXENTRY"/>
    <br/>
    <xsl:apply-templates select="@SKIP" mode="index"/>

    <br/>
    <br/>
    <br/>
  </xsl:template>


  <!--
<xsl:template match="@SKIP" mode="index">
Author:		Dharmesh Raithatha
Inputs:		lessthan - the << at the beginning
			greaterthan - the > at the end
			bar - the | used as a divider
			previous - text pulled in from $m_previous
			next - the text pulled in from $m_next
			entries - the text pulled in from $m_entries
			nopreventries - the text pulled in from $m_nopreventries
			nomoreentries - the text pulled in from $m_nomoreentries
Context:    -
Purpose:	Displays the previous and next guidentries in index
			Defaults to "<< Previous 50 guide entries | next 50 guide entries >>"
Call:		<xsl:apply-templates select="@SKIP" mode="index">
-->

  <xsl:template match="@SKIP" mode="index">
    <xsl:param name="lessthan">&lt;&lt;</xsl:param>
    <xsl:param name="greaterthan">&gt;&gt;</xsl:param>
    <xsl:param name="bar"> | </xsl:param>
    <xsl:param name="previous">
      <xsl:value-of select="$m_previous"/>
    </xsl:param>
    <xsl:param name="next">
      <xsl:value-of select="$m_nextspace"/>
    </xsl:param>
    <xsl:param name="entries">
      <xsl:value-of select="$m_entries"/>
    </xsl:param>
    <xsl:param name="nopreventries">
      <xsl:value-of select="$m_nopreventries"/>
    </xsl:param>
    <xsl:param name="nomoreentries">
      <xsl:value-of select="$m_nomoreentries"/>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="number(.) &gt; 0">
        <xsl:apply-templates select="." mode="previndexlink">
          <xsl:with-param name="linkcontent">
            <xsl:copy-of select="$lessthan"/>&nbsp;<xsl:copy-of select="$previous"/><xsl:value-of select="../@COUNT"/>&nbsp;<xsl:copy-of select="$entries"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$lessthan"/>
        <xsl:copy-of select="$nopreventries"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="$bar"/>
    <xsl:choose>
      <xsl:when test="../@MORE=1">
        <xsl:apply-templates select="." mode="nextindexlink">
          <xsl:with-param name="linkcontent">
            <xsl:copy-of select="$next"/>
            <xsl:value-of select="../@COUNT"/>
            &nbsp;
            <xsl:copy-of select="$entries"/>
            &nbsp;
            <xsl:copy-of select="$greaterthan"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$nomoreentries"/>&nbsp;<xsl:copy-of select="$greaterthan"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--
	<xsl:template match="INDEXENTRY">
	Author:		Dharmesh Raithatha
	Inputs:		-
	Context:    -
	Purpose:	Displays an index entry
	Call:		<xsl:apply-templates select="INDEXENTRY">
-->

  <xsl:template match="INDEXENTRY">
    <xsl:apply-templates select="H2G2ID" mode="indexentry"/>
    &nbsp;<span class="indexnormal">
      <xsl:value-of select="SUBJECT"/>
    </span><br/>
  </xsl:template>

  <!--
	<xsl:template match="INDEXENTRY[STATUS='APPROVED']">
	Author:		Dharmesh Raithatha
	Inputs:		-
	Context:    -
	Purpose:	Displays an index entry link in the Form A12345 subject in bold
	Call:		<xsl:apply-templates select="INDEXENTRY">
-->

  <xsl:template match="INDEXENTRY[STATUS='APPROVED']">
    <xsl:apply-templates select="H2G2ID" mode="indexentry"/>
    &nbsp;<span class="indexapproved">
      <xsl:value-of select="SUBJECT"/>
    </span><br/>
  </xsl:template>

  <!--
	<xsl:template match="INDEXENTRY[STATUS='SUBMITTED']">
	Author:		Dharmesh Raithatha
	Inputs:		-
	Context:    -
	Purpose:	Displays an index entry link in the Form A12345 subject
	Call:		<xsl:apply-templates select="INDEXENTRY">
-->


  <xsl:template match="INDEXENTRY[STATUS='SUBMITTED']">
    <xsl:apply-templates select="H2G2ID" mode="indexentry"/>
    &nbsp;<span class="indexsubmitted">
      <xsl:value-of select="SUBJECT"/>
    </span><br/>
  </xsl:template>

  <!--
	<xsl:template match="INDEXENTRY[STATUS='UNAPPROVED']">
	Author:		Dharmesh Raithatha
	Inputs:		-
	Context:    -
	Purpose:	Displays an index entry link in the Form A12345 subject n italics
	Call:		<xsl:apply-templates select="INDEXENTRY">
-->

  <xsl:template match="INDEXENTRY[STATUS='UNAPPROVED']">
    <xsl:apply-templates select="H2G2ID" mode="indexentry"/>
    &nbsp;<span class="indexnormal">
      <xsl:value-of select="SUBJECT"/>
    </span><br/>
  </xsl:template>
  <!--	************************* Non Overwritable templates for Index pages ***************** -->
  <!--
<xsl:template match="@SKIP" mode="previndexlink">
Author:		Dharmesh Raithatha
Inputs:		linkcontent - the text or image for the link
Context:    -
Purpose:	Displays the link to the previous entries in the index (text defaults to Previous)
Call:		<xsl:apply-templates select="@SKIP" mode="previndexlink">
-->

  <xsl:template match="@SKIP" mode="previndexlink">
    <xsl:param name="linkcontent">Previous</xsl:param>
    <A xsl:use-attribute-sets="maSKIP_previndexlink">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>Index?let=<xsl:value-of select="../@LETTER"/><xsl:apply-templates select="../@APPROVED"/><xsl:apply-templates select="../@UNAPPROVED"/><xsl:apply-templates select="../@SUBMITTED"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;skip=<xsl:value-of select="number(.) - number(../@COUNT)"/>
      </xsl:attribute>
      <xsl:copy-of select="$linkcontent"/>
    </A>
  </xsl:template>


  <xsl:template match="ARTICLE-EDIT-FORM/STATUS" mode="ArticleEdit">
    <br/>Status: <input type="text" name="status" value="{.}" maxlength="5"/>
  </xsl:template>

  <xsl:template match="ARTICLE-EDIT-FORM/EDITORID" mode="ArticleEdit">
    <br/>Editor: <input type="text" name="editor" value="{.}" maxlength="15"/>
  </xsl:template>


  <!--
<xsl:template match="@SKIP" mode="nextindexlink">
Author:		Dharmesh Raithatha
Inputs:		linkcontent - the text or image for the link
Context:    -
Purpose:	Displays the link to the next entries in the index (text defaults to Next)
Call:		<xsl:apply-templates select="@SKIP" mode="nextindexlink">
-->

  <xsl:template match="@SKIP" mode="nextindexlink">
    <xsl:param name="linkcontent">Next</xsl:param>
    <A xsl:use-attribute-sets="maSKIP_nextindexlink">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>Index?let=<xsl:value-of select="../@LETTER"/><xsl:apply-templates select="../@APPROVED"/><xsl:apply-templates select="../@UNAPPROVED"/><xsl:apply-templates select="../@SUBMITTED"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;skip=<xsl:value-of select="number(.) + number(../@COUNT)"/>
      </xsl:attribute>
      <xsl:copy-of select="$linkcontent"/>
    </A>
  </xsl:template>

  <!--

	<xsl:template match="INDEX/@APPROVED">&amp;official=on</xsl:template>

	Generic:	Yes
	Purpose:	Will put the right URL parameter into a query string depending on the atribute set

-->

  <xsl:template match="INDEX/@APPROVED">&amp;official=on</xsl:template>

  <!--

	<xsl:template match="INDEX/@UNAPPROVED">&amp;user=on</xsl:template>

	Generic:	Yes
	Purpose:	Will put the right URL parameter into a query string depending on the atribute set

-->

  <xsl:template match="INDEX/@UNAPPROVED">&amp;user=on</xsl:template>

  <!--

	<xsl:template match="INDEX/@SUBMITTED">&amp;submitted=on</xsl:template>

	Generic:	Yes
	Purpose:	Will put the right URL parameter into a query string depending on the atribute set

-->

  <xsl:template match="INDEX/@SUBMITTED">&amp;submitted=on</xsl:template>


  <!--
	<xsl:template match="H2G2ID" mode="indexentry">
	Author:		Dharmesh Raithatha
	Inputs:		subject - the body of the link to A12345 (defaults to A12345)
	Context:    -
	Purpose:	Displays an index entry link in the Form A12345
	Call:		<xsl:apply-templates select="H2G2ID" mode="indexentry">
-->


  <xsl:template match="H2G2ID" mode="indexentry">
    <xsl:param name="subject">
      A<xsl:value-of select="."/>
    </xsl:param>
    <A xsl:use-attribute-sets="mH2G2ID_indexentry">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>A<xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:copy-of select="$subject"/>
    </A>
  </xsl:template>

  <!--
<xsl:template name="MOREPAGES_MAINBODY">
Author:		Igor Loboda
Context:    H2G2
Purpose:	Displays articles list
Call:		<xsl:call-template name="MOREPAGES_MAINBODY"/>
-->
  <xsl:template name="MOREPAGES_MAINBODY">
    <br/>
    <blockquote>
      <xsl:apply-templates select="ARTICLES/@USERID" mode="ShowEditedEntries"/>
      <xsl:text> | </xsl:text>
      <xsl:apply-templates select="ARTICLES/@USERID" mode="ShowGuideEntries"/>
      <xsl:if test="$test_MayShowCancelledEntries">
        <xsl:text> | </xsl:text>
        <xsl:apply-templates select="ARTICLES/@USERID" mode="ShowCancelledEntries"/>
      </xsl:if>
      <br/>
      <br/>
      <xsl:apply-templates select="ARTICLES/ARTICLE-LIST"/>
      <br/>
      <xsl:if test="$test_NewerArticlesExist">
        <xsl:apply-templates select="ARTICLES/@USERID" mode="NewerEntries"/>&nbsp;
      </xsl:if>
      <xsl:if test="$test_OlderArticlesExist">
        <xsl:apply-templates select="ARTICLES/@USERID" mode="OlderEntries"/>
      </xsl:if>
      <br/>
      <xsl:apply-templates select="ARTICLES/@USERID" mode="FromMAToPS"/>
    </blockquote>
  </xsl:template>

  <xsl:template match="DVD">
    <UL>
      <xsl:for-each select="DISC">
        <li>
          <b>
            Disc <xsl:value-of select="@NUMBER"/>
          </b>
        </li>
        <ul>
          <xsl:for-each select="TITLE">
            <li>
              <xsl:value-of select="NAME"/>
              <xsl:if test="STORYNAME">
                - <i>
                  <xsl:value-of select="STORYNAME"/>
                </i>
              </xsl:if>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:for-each>
    </UL>
  </xsl:template>

  <!--
<xsl:template match="FORUMTHREADPOSTS/POST">
Author:		Tom Whitehouse
Purpose:	Displays a thread post
-->

  <xsl:template match="FORUMTHREADPOSTS/POST">
    <xsl:param name="ptype" select="'frame'"/>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
      <TBODY>
        <TR>
          <TD width="100%" COLSPAN="2">
            <HR size="2"/>
          </TD>
          <TD nowrap="1">
            <span xsl:use-attribute-sets="forumsubfont">
              <a name="pi{count(preceding-sibling::POST) + 1 + number(../@SKIPTO)}">
                <xsl:apply-templates select="@POSTID" mode="CreateAnchor"/>
                <xsl:choose>
                  <xsl:when test="@PREVINDEX">
                    <xsl:apply-templates select="@PREVINDEX" mode="multiposts"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$m_prev"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text> | </xsl:text>
                <xsl:choose>
                  <xsl:when test="@NEXTINDEX">
                    <xsl:apply-templates select="@NEXTINDEX" mode="multiposts"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$m_next"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </span>
          </TD>
        </TR>
        <TR>
          <TD ALIGN="left">
            <span xsl:use-attribute-sets="forumsubjectlabel">
              <xsl:value-of select="$m_fsubject"/>
            </span>
            <span xsl:use-attribute-sets="forumsubject">
              <xsl:call-template name="postsubject"/>
            </span>
            <br/>
            <FONT xsl:use-attribute-sets="forumpostedlabel">
              <xsl:value-of select="$m_posted"/>
              <xsl:apply-templates select="DATEPOSTED/DATE"/>
            </FONT>
            <xsl:if test="not(@HIDDEN &gt; 0)">
              <span xsl:use-attribute-sets="forumpostedlabel">
                <xsl:value-of select="$m_by"/>
              </span>
              <span xsl:use-attribute-sets="forumposted">
                <xsl:apply-templates select="USER/USERNAME" mode="multiposts"/>
              </span>
              <xsl:if test="USER[USERID=/H2G2/ONLINEUSERS/USER/USERID]">
                <span class="onlinemarker">*</span>
              </xsl:if>
            </xsl:if>
            <xsl:if test="@INREPLYTO">
              <br/>
              <span xsl:use-attribute-sets="forumsmall">
                <xsl:value-of select="$m_inreplyto"/>
                <xsl:apply-templates select="@INREPLYTO" mode="multiposts"/>
              </span>
            </xsl:if>
            <xsl:if test="@INREPLYTO|@PREVSIBLING|@NEXTSIBLING">
              <br/>
            </xsl:if>
          </TD>
          <TD align="right" valign="top">
          </TD>
          <TD nowrap="1" ALIGN="center" valign="top">
            <span class="postnumber">
              <xsl:apply-templates select="." mode="postnumber"/>
              <br/>
            </span>
            <xsl:if test="$showtreegadget=1">
              <xsl:call-template name="showtreegadget">
                <xsl:with-param name="ptype" select="$ptype"/>
              </xsl:call-template>
            </xsl:if>
          </TD>
        </TR>
      </TBODY>
    </table>
    <br/>
    <span class="postbody">
      <xsl:call-template name="showpostbody"/>
    </span>
    <br/>
    <br/>
    <table width="100%">
      <tr>
        <td align="left">
          <span xsl:use-attribute-sets="forumtitlefont">
            <xsl:apply-templates select="@POSTID" mode="ReplyToPost"/>
            <br/>
            <xsl:if test="@FIRSTCHILD">
              <span class="readreply">
                <br/>
                <xsl:value-of select="$m_readthe"/>
                <xsl:apply-templates select="@FIRSTCHILD" mode="multiposts"/>
              </span>
            </xsl:if>
          </span>
        </td>
        <td align="right">
          <xsl:if test="$test_EditorOrModerator">
            <span class="smallfont">
              <xsl:apply-templates select="@POSTID" mode="moderation"/>
            </span>
          </xsl:if>
          <xsl:if test="@HIDDEN=0">
            <xsl:apply-templates select="@HIDDEN" mode="multiposts"/>
          </xsl:if>
          <xsl:if test="$test_EditorOrModerator">
            <span class="smallfont">
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="@POSTID" mode="editpost"/>
            </span>
          </xsl:if>
        </td>
      </tr>
    </table>
  </xsl:template>


  <xsl:variable name="test_DeleteLotsOfFriends" select="/H2G2/PARAMS/PARAM[NAME='s_bd']"/>

  <xsl:template name="WATCHED-USERS_MAINBODY">
    <br/>
    <xsl:apply-templates select="WATCH-USER-RESULT"/>
    <xsl:apply-templates select="WATCHED-USER-LIST"/>
    <xsl:apply-templates select="WATCHING-USER-LIST"/>
    <xsl:apply-templates select="WATCHED-USER-POSTS"/>
  </xsl:template>

  <xsl:template match="WATCH-USER-RESULT">
    <xsl:choose>
      <xsl:when test="@TYPE='delete'">
        <p>
          <xsl:copy-of select="$m_deletedfollowingfriends"/>
        </p>
        <xsl:apply-templates select="USER" mode="deletewatched"/>
      </xsl:when>
      <xsl:when test="@TYPE='remove'">
        <p>
          <xsl:copy-of select="$m_someusersdeleted"/>
        </p>
      </xsl:when>
      <xsl:when test="@TYPE='add'">
        <p>
          <xsl:copy-of select="$m_namesaddedtofriends"/>
        </p>
        <xsl:apply-templates select="USER" mode="addwatched"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="WATCHED-USER-LIST">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td valign="top" align="left" width="50%">
          <xsl:choose>
            <xsl:when test="$ownerisviewer=1">
              <xsl:choose>
                <xsl:when test="USER">
                  <xsl:copy-of select="$m_namesonyourfriendslist"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="$m_youremptyfriendslist"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="USER">
                  <xsl:copy-of select="$m_friendslistofuser"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
                  <xsl:copy-of select="$m_hasntaddedfriends"/>
                  <br/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td valign="top" align="right" width="50%">
          <xsl:if test="/H2G2/PAGE-OWNER/USER/USERID=/H2G2/VIEWING-USER/USER/USERID">
            <a href="watch{/H2G2/PAGE-OWNER/USER/USERID}?full=1" xsl:use-attribute-sets="mWATCHED-USER-LIST_FullList">
              <xsl:copy-of select="$m_journalentriesbyfriends"/>
            </a>
          </xsl:if>
        </td>
      </tr>
    </table>
    <form method="GET" action="{$root}Watch{@USERID}">
      <xsl:apply-templates select="USER" mode="watched"/>
      <xsl:if test="$test_DeleteLotsOfFriends">
        <input type="submit" name="delete" value="Delete Marked Names"/>
        <input type="hidden" name="s_bd" value="yes"/>
      </xsl:if>
    </form>
    <xsl:if test="not($test_DeleteLotsOfFriends) and USER">
      <xsl:apply-templates select="@USERID" mode="WatchUserBigDelete"/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="WATCHING-USER-LIST">
    <xsl:if test="not(/H2G2/ARTICLE) or /H2G2/ARTICLE/GUIDE/OPTIONS[@WATCHING-USERS=1]">
      <xsl:choose>
        <xsl:when test="$ownerisviewer=1">
          <xsl:choose>
            <xsl:when test="USER">
              <xsl:call-template name="m_peoplewatchingyou"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="m_youhavenousers"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="USER">
            <xsl:call-template name="m_userswatchingusers"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="USER" mode="watching"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@USERID" mode="WatchUserBigDelete">
    <xsl:param name="linkcontent">
      <xsl:copy-of select="$m_deletemultiplefriends"/>
    </xsl:param>
    <a xsl:use-attribute-sets="maUSERID_WatchUserBigDelete" href="{$root}Watch{.}?s_bd=yes">
      <xsl:copy-of select="$linkcontent"/>
    </a>
  </xsl:template>

  <xsl:template match="USERID" mode="WatchUserPS">
    <xsl:param name="linkcontent">
      <xsl:copy-of select="$m_personalspace"/>
    </xsl:param>
    <a xsl:use-attribute-sets="mUSERID_WatchUserPS" href="{$root}U{.}">
      <xsl:copy-of select="$linkcontent"/>
    </a>
  </xsl:template>

  <xsl:template match="USER" mode="WatchUserJournal">
    <xsl:param name="linkcontent">
      <xsl:copy-of select="$m_journalpostings"/>
    </xsl:param>
    <a xsl:use-attribute-sets="mUSER_WatchUserJournal" href="MJ{USERID}?Journal={JOURNAL}">
      <xsl:copy-of select="$linkcontent"/>
    </a>
  </xsl:template>

  <xsl:template match="USER" mode="WatchUserPosted">
    <xsl:param name="linkcontent">
      <xsl:apply-templates select="USERNAME"/>
    </xsl:param>
    <a xsl:use-attribute-sets="mUSER_WatchUserPosted" href="{$root}U{USERID}">
      <xsl:copy-of select="$linkcontent"/>
    </a>
  </xsl:template>

  <xsl:template match="USERID" mode="WatchUserDelete">
    <xsl:param name="linkcontent">
      <xsl:copy-of select="$m_delete"/>
    </xsl:param>
    <a xsl:use-attribute-sets="mUSERID_WatchUserDelete" href="{$root}Watch{/H2G2/WATCHED-USER-LIST/@USERID}?delete=yes&amp;duser={.}">
      <xsl:copy-of select="$linkcontent"/>
    </a>
  </xsl:template>

  <xsl:template match="USER" mode="watched">
    <xsl:choose>
      <xsl:when test="string-length(USERNAME) = 0">
        <xsl:value-of select="concat($m_user,' ')"/>
        <xsl:value-of select="USERID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="USERNAME"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <span class="watchlinks">
      <xsl:apply-templates select="USERID" mode="WatchUserPS"/> | <xsl:apply-templates select="." mode="WatchUserJournal"/>
      <xsl:if test="$ownerisviewer">
        <xsl:choose>
          <xsl:when test="$test_DeleteLotsOfFriends">
            | <input type="CHECKBOX" name="duser" value="{USERID}"/><xsl:copy-of select="$m_deletethisfriend"/>
          </xsl:when>
          <xsl:otherwise>
            | <xsl:apply-templates select="USERID" mode="WatchUserDelete"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <br/><br/>
    </span>
  </xsl:template>

  <xsl:template match="USER" mode="watching">
    <xsl:choose>
      <xsl:when test="string-length(USERNAME) = 0">
        <xsl:value-of select="concat($m_user,' ')"/>
        <xsl:value-of select="USERID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="USERNAME"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <span class="watchlinks">
      <xsl:apply-templates select="USERID" mode="WatchUserPS"/> | <xsl:apply-templates select="." mode="WatchUserJournal"/>
      <br/>
    </span>
  </xsl:template>

  <xsl:template match="USER" mode="deletewatched">
    <xsl:choose>
      <xsl:when test="string-length(USERNAME) = 0">
        <xsl:value-of select="concat($m_user,' ')"/>
        <xsl:value-of select="USERID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="USERNAME"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <span class="watchlinks">
      <xsl:apply-templates select="USERID" mode="WatchUserPS"/> | <xsl:apply-templates select="." mode="WatchUserJournal"/>
    </span>
    <br/>
  </xsl:template>

  <xsl:template match="USER" mode="addwatched">
    <xsl:choose>
      <xsl:when test="string-length(USERNAME) = 0">
        <xsl:value-of select="concat($m_user,' ')"/>
        <xsl:value-of select="USERID"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="USERNAME"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
  </xsl:template>

  <xsl:template name="WATCHED-USERS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        <xsl:if test="$ownerisviewer=1">
          <xsl:copy-of select="$m_my"/>
        </xsl:if>
        <xsl:copy-of select="$m_friends"/>
        <xsl:if test="$ownerisviewer=0">
          <xsl:copy-of select="$m_of"/>
          <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="WATCHED-USER-POSTS">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td align="left" valign="top" width="50%">
          <xsl:call-template name="navbuttons">
            <xsl:with-param name="URL">watch</xsl:with-param>
            <xsl:with-param name="ID" select="@USERID"/>
            <xsl:with-param name="Previous" select="$alt_previouspage"/>
            <xsl:with-param name="Next" select="$alt_nextpage"/>
            <xsl:with-param name="shownewest" select="$alt_firstpage"/>
            <xsl:with-param name="showoldestconv" select="$alt_lastpage"/>
            <xsl:with-param name="ExtraParameters">&amp;full=1</xsl:with-param>
            <xsl:with-param name="showconvs" select="'Show Entries '"/>
          </xsl:call-template>
          <xsl:copy-of select="$m_friendsblockdivider"/>
          <xsl:call-template name="forumpostblocks">
            <xsl:with-param name="forum" select="@USERID"/>
            <xsl:with-param name="skip" select="0"/>
            <xsl:with-param name="show" select="@COUNT"/>
            <xsl:with-param name="total" select="@TOTAL"/>
            <xsl:with-param name="this" select="@SKIPTO"/>
            <xsl:with-param name="url">Watch</xsl:with-param>
            <xsl:with-param name="ExtraParameters">&amp;full=1</xsl:with-param>
            <xsl:with-param name="splitevery">800</xsl:with-param>
            <xsl:with-param name="objectname" select="'Entries '"/>
          </xsl:call-template>
          <br/>
        </td>
        <td align="right" valign="top" width="50%">
          <a xsl:use-attribute-sets="mWATCH-USER-POSTS_Back" href="{$root}Watch{@USERID}">
            <xsl:copy-of select="$m_friendslist"/>
          </a>
          <br/>
        </td>
      </tr>
    </table>
    <xsl:apply-templates select="WATCHED-USER-POST"/>
    <xsl:if test="not(WATCHED-USER-POST)">
      <xsl:copy-of select="$m_noentriestodisplay"/>
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="WATCHED-USER-POST">
    <xsl:copy-of select="$m_postedby"/>
    <xsl:apply-templates select="USER" mode="WatchUserPosted"/>
    <xsl:copy-of select="$m_on"/>
    <xsl:apply-templates select="DATEPOSTED/DATE" mode="absolute"/>
    <br/>
    <xsl:copy-of select="$m_fsubject"/>
    <xsl:apply-templates select="SUBJECT" mode="watchedpost"/>
    <br/>
    <xsl:apply-templates select="BODY"/>
    <br/>
    <br/>
    <xsl:choose>
      <xsl:when test="number(POSTCOUNT) &gt; 2">
        <a xsl:use-attribute-sets="mWATCH-USER-POSTS_Replies" href="F{@FORUMID}?thread={@THREADID}">
          <xsl:value-of select="number(POSTCOUNT)-1"/>
          <xsl:copy-of select="$m_replies"/>
        </a>
        <xsl:text> </xsl:text>
        <xsl:copy-of select="$m_latestreply"/>
        <a xsl:use-attribute-sets="mWATCH-USER-POSTS_LastReply" href="F{@FORUMID}?thread={@THREADID}&amp;latest=1">
          <xsl:apply-templates select="LASTPOSTED/DATE"/>
        </a>
        <br/>
      </xsl:when>
      <xsl:when test="number(POSTCOUNT) = 2">
        <xsl:copy-of select="$m_onereplyposted"/>
        <a xsl:use-attribute-sets="mWATCH-USER-POSTS_LastReply" href="F{@FORUMID}?thread={@THREADID}">
          <xsl:apply-templates select="LASTPOSTED/DATE"/>
        </a>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$m_noreplies"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@POSTID" mode="ReplyToPost"/>

    <hr/>
  </xsl:template>

  <xsl:template match="SUBJECT" mode="watchedpost">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="FORUMTHREADS" mode="PrevAndNext">
    <span class="prevnextforumnav">
      <xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/preceding-sibling::THREAD[1]" mode="PreviousThread"/>
      <xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/following-sibling::THREAD[1]" mode="NextThread"/>
    </span>
  </xsl:template>

  <xsl:template match="THREAD" mode="PreviousThread">
    <br/>
    <b>
      <a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mTHREAD_PreviousThread">
        &lt;&lt; <xsl:value-of select="SUBJECT"/>
      </a>
    </b>
  </xsl:template>

  <xsl:template match="THREAD" mode="NextThread">
    <br/>
    <b>
      <a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mTHREAD_NextThread">
        <xsl:value-of select="SUBJECT"/> &gt;&gt;
      </a>
    </b>
  </xsl:template>

  <xsl:template match="SITEPREFERENCES" mode="UserDetailsForm">
    <xsl:apply-templates select="node()" mode="UserDetailsForm"/>
  </xsl:template>

  <xsl:template match="node()" mode="UserDetailsForm">
    <xsl:if test="name() != 'PLAINCSS' and name() != 'BLOB'">
      <input type="hidden" name="p_name" value="{name()}"/>
      <input type="hidden" name="{name()}" value="{@VALUE}"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="MYSPACE-LINK">
    <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">
      <xsl:apply-templates select="@TARGET|@TITLE"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="MYSPACE-LINK/@TARGET">
    <xsl:attribute name="target">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="MYSPACE-LINK/@TITLE">
    <xsl:attribute name="title">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="USER" mode="showonline">
    <xsl:param name="symbol">
      <span class="onlinemarker">*</span>
    </xsl:param>
    <xsl:if test="./USERID=/H2G2/ONLINEUSERS/ONLINEUSER/USER/USERID or ./USERID=/H2G2/VIEWING-USER/USER/USERID">
      <xsl:copy-of select="$symbol"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="FORUMSOURCE">
    <xsl:apply-templates select="ARTICLE"/>
  </xsl:template>

  <xsl:template match="FORUMSOURCE[@TYPE='userpage']">
    <xsl:apply-templates select="USERPAGE"/>
  </xsl:template>

  <xsl:template match="FORUMSOURCE[@TYPE='reviewforum']">
    <xsl:apply-templates select="REVIEWFORUM"/>
  </xsl:template>

  <xsl:template match="FORUMSOURCE[@TYPE='journal']">
    <xsl:apply-templates select="JOURNAL"/>
  </xsl:template>

  <xsl:template name="insert-headelements">
    <META NAME="robots" CONTENT="{$robotsetting}"/>
  </xsl:template>
  <!--
<xsl:template match="VIEWER">
Author:		Tom Whitehouse
Purpose:	Displays the Viewers name or 'Unknown Visitor'
-->
  <xsl:template match="VIEWER">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME">
        <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$m_unknownvisitor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="POST/TEXT/LINK/text()|PREVIEWBODY/LINK/text()">
    <xsl:choose>
      <xsl:when test="string-length(.) &gt; 70">
        <xsl:value-of select="concat(substring(.,1,35),'...',substring(.,string-length(.) - 34,35))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="SEARCH/FUNCTIONALITY/SEARCHFORUMS" mode="searchforumids">
    <xsl:apply-templates select="FORUM|THREAD" mode="searchforumids"/>
  </xsl:template>

  <xsl:template match="FORUM" mode="searchforumids">
    <input type="hidden" name="forum" value="{.}"/>
  </xsl:template>

  <xsl:template match="THREAD" mode="searchforumids">
    <input type="hidden" name="thread" value="{.}"/>
  </xsl:template>

  <xsl:template match="@STYLE[contains(.,'//')]"/>
  <xsl:template match="TABLE/@BACKGROUND"/>

  <xsl:template match="RICHPOST">
  </xsl:template>

  <xsl:variable name="v_moderatorviewtype">
    <xsl:value-of select="/H2G2/MODERATOR-VIEW/@VIEWTYPE"/>
  </xsl:variable>
  <xsl:variable name="v_moderatorviewid">
    <xsl:value-of select="/H2G2/MODERATOR-VIEW/@VIEWID"/>
  </xsl:variable>
  <xsl:variable name="v_moderatorsiteid">
    <xsl:if test="$v_moderatorviewtype='site'">
      <xsl:value-of select="/H2G2/MODERATOR-VIEW/@VIEWID"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="v_moderatorclassid">
    <xsl:choose>
      <xsl:when test="$v_moderatorviewtype='class'">
        <xsl:value-of select="$v_moderatorviewid"/>
      </xsl:when>
      <xsl:when test="$v_moderatorviewtype='site'">
        <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$v_moderatorviewid]/CLASSID"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="v_moderatoruserid">
    <xsl:if test="$v_moderatorviewtype='user'">
      <xsl:value-of select="/H2G2/MODERATOR-VIEW/@VIEWID"/>
    </xsl:if>
  </xsl:variable>

  <xsl:template name="MODERATOR-MANAGEMENT_MAINBODY">

    <H1>Moderator Management</H1>
    <xsl:variable name="currentviewtype">
      <xsl:value-of select="$v_moderatorviewtype"/>
    </xsl:variable>
    <xsl:variable name="currentviewid">
      <xsl:value-of select="$v_moderatorviewid"/>
    </xsl:variable>
    <xsl:variable name="currentclassid">
      <xsl:choose>
        <xsl:when test="$currentviewtype='class'">
          <xsl:value-of select="$currentviewid"/>
        </xsl:when>
        <xsl:when test="$currentviewtype='site'">
          <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$currentviewid]/CLASSID"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$v_moderatorviewtype = 'class'">
        <H2>
          Viewing class: <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID=$v_moderatorclassid]/NAME"/>
        </H2>
      </xsl:when>
      <xsl:when test="$v_moderatorviewtype = 'site'">
        <H2>
          Viewing site: <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$v_moderatorsiteid]/SHORTNAME"/>
        </H2>
      </xsl:when>
    </xsl:choose>
    <a href="{$root}moderatormanagement">Show All</a>
    <br/>
    <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
      <a href="{$root}moderatormanagement?view=class&amp;viewid={@CLASSID}">
        <xsl:if test="@CLASSID=$currentclassid">
          <xsl:attribute name="style">font-weight:bold</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="NAME"/>
      </a> |
    </xsl:for-each>
    <br/>
    <xsl:for-each select="/H2G2/SITE-LIST/SITE">
      <xsl:if test="$currentclassid = '0' or $currentclassid = CLASSID">
        <a href="{$root}moderatormanagement?view=site&amp;viewid={@ID}">
          <xsl:if test="$currentviewtype='site' and @ID=$currentviewid">
            <xsl:attribute name="style">font-weight:bold</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="NAME"/>
        </a> |
      </xsl:if>
    </xsl:for-each>
    <br/>
    <xsl:apply-templates select="/H2G2/MODERATOR-LIST"/>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="MODERATOR-LIST">
    <xsl:apply-templates select="/H2G2/LASTACTION/REMOVEDUSERS"/>
    <form method="GET" action="moderatormanagement">
      <input type="hidden" name="view" value="all"/>
      <input type="hidden" name="viewid" value="0"/>
      <SELECT name="accessobject">
        <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
          <OPTION value="class{@CLASSID}">
            Class: <xsl:value-of select="NAME"/>
          </OPTION>
        </xsl:for-each>
        <xsl:for-each select="/H2G2/SITE-LIST/SITE">
          <OPTION value="site{@ID}">
            Site: <xsl:value-of select="SHORTNAME"/>
          </OPTION>
        </xsl:for-each>
      </SELECT>
      <input type="submit" name="giveaccess" value="Grant Access" OnClick="javascript:return(confirm('Are you sure?'))"/>

      <br/>
      <input type="submit" name="removeallaccess" value="Delete from System" OnClick="javascript:return(confirm('Are you sure?'))"/>

      <br/>
      <input type="submit" name="finduser" value="Add New Moderator"/>

      <table>
        <xsl:apply-templates select="MODERATOR">
        </xsl:apply-templates>
        <!--
<tr>
<td><INPUT TYPE="CHECKBOX" NAME="userid" VALUE="{USER/USERID}"/></td><td><xsl:value-of select="USER/USERNAME"/></td><td>
 (<xsl:value-of select="count(SITES/SITE)"/> sites)</td><td>
<xsl:for-each select="CLASSES/CLASSID">Class <xsl:value-of select="."/>,</xsl:for-each>
</td><td>
<xsl:for-each select="SITES/SITE">Site <xsl:value-of select="@SITEID"/>,</xsl:for-each>
 </td>
</tr>
</xsl:for-each>
-->
      </table>
      <input type="submit" name="giveaccess" value="Grant Access" OnClick="javascript:return(confirm('Are you sure?'))"/>
    </form>
  </xsl:template>

  <xsl:template match="MODERATOR-LIST[/H2G2/MODERATOR-VIEW/@VIEWTYPE='class']">
    <form method="GET" action="{$root}moderatormanagement">
      <input type="hidden" name="view" value="{$v_moderatorviewtype}"/>
      <input type="hidden" name="viewid" value="{$v_moderatorviewid}"/>
      <input type="hidden" name="accessobject" value="class{$v_moderatorclassid}"/>
      <table>
        <xsl:apply-templates select="MODERATOR[CLASSES/CLASSID=$v_moderatorclassid]">
          <xsl:with-param name="showsitecount">0</xsl:with-param>
          <xsl:with-param name="showclasses">0</xsl:with-param>
          <xsl:with-param name="showdirectsites">0</xsl:with-param>

        </xsl:apply-templates>
        <!--
<xsl:for-each select="MODERATOR[CLASSES/CLASSID=$thisclassid]">
<tr>
<td><INPUT TYPE="CHECKBOX" NAME="userid" VALUE="{USER/USERID}"/></td><td><a href="{$root}moderatormanagement?view=user&amp;viewid={USER/USERID}">U<xsl:value-of select="USER/USERID"/></a></td><td><xsl:value-of select="USER/USERNAME"/></td><td>
 (<xsl:value-of select="count(SITES/SITE)"/> sites)</td><td>
<xsl:for-each select="CLASSES/CLASSID">
<xsl:variable name="curclass"><xsl:value-of select="."/></xsl:variable>
<xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID=$curclass]/NAME"/>
<xsl:if test="position()=last()"><br/></xsl:if></xsl:for-each>
</td><td>
<xsl:for-each select="SITES/SITE">Site <xsl:value-of select="@SITEID"/>,</xsl:for-each>
 </td>
</tr>
</xsl:for-each>
-->
      </table>
      <input type="submit" name="removeclassaccess" value="Remove Access to Class" OnClick="javascript:return(confirm('Are you sure?'))"/>
    </form>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="MODERATOR-LIST[/H2G2/MODERATOR-VIEW/@VIEWTYPE='site']">
    <form method="GET" action="{$root}moderatormanagement">

      <!-- show the current class the site belongs to -->

      Site: <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$v_moderatorsiteid]/SHORTNAME"/><br/>
      Member of class <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID=$v_moderatorclassid]/NAME"/><br/>
      Change to class:
      <select name="classid">
        <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
          <option value="{@CLASSID}">
            <xsl:if test="@CLASSID=$v_moderatorclassid">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="NAME"/>
          </option>
        </xsl:for-each>
      </select> <input type="submit" name="changesiteclass" value="Change class of site"/><br/>
      <input type="hidden" name="view" value="site"/>
      <input type="hidden" name="viewid" value="{$v_moderatorsiteid}"/>

      <input type="hidden" name="accessobject" value="site{$v_moderatorsiteid}"/>
      <table>
        <xsl:apply-templates select="MODERATOR[SITES/SITE/@SITEID=$v_moderatorsiteid]">
          <xsl:with-param name="showaccessthrough">
            <xsl:value-of select="$v_moderatorsiteid"/>
          </xsl:with-param>
          <xsl:with-param name="showsitecount">0</xsl:with-param>
          <xsl:with-param name="showclasses">0</xsl:with-param>
          <xsl:with-param name="showdirectsites">0</xsl:with-param>
        </xsl:apply-templates>
        <!--
<xsl:for-each select="MODERATOR[SITES/SITE/@SITEID=$thisid]">
<tr>
<td><INPUT TYPE="CHECKBOX" NAME="userid" VALUE="{USER/USERID}">
<xsl:if test="SITES/SITE[@SITEID=$thisid]/@CLASSID">
<xsl:attribute name="DISABLED">DISABLED</xsl:attribute>
</xsl:if>
</INPUT></td>
<td>U<xsl:value-of select="USER/USERID"/></td>
<td><xsl:value-of select="USER/USERNAME"/></td><td>
 (<xsl:value-of select="count(SITES/SITE)"/> sites)</td>
<td>
<xsl:choose>
<xsl:when test="SITES/SITE[@SITEID=$thisid]/@CLASSID">
<a href="{$root}moderatormanagement?view=class&amp;viewid={SITES/SITE[@SITEID=$thisid]/@CLASSID}">Class <xsl:value-of select="SITES/SITE[@SITEID=$thisid]/@CLASSID"/></a>
</xsl:when>
<xsl:otherwise>Direct Access</xsl:otherwise>
</xsl:choose>
</td>
</tr>
</xsl:for-each>
-->
      </table>
      <input type="submit" name="removesiteaccess" value="Remove Access to Site">
        <xsl:call-template name="confirmjavascript">
          <xsl:with-param name="message">
            Remove the selected moderators' access privileges for site <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$v_moderatorsiteid]/SHORTNAME"/>
          </xsl:with-param>
        </xsl:call-template>
      </input>
    </form>
  </xsl:template>

  <!--

	Parameters:	showsitecount = 1/0 - show/don't show the count of sites
				showaccessthrough = siteID - Show if the access is direct or through a class
				showdirectsites = 1/0 - show sites the user has direct access to
				showclasses = 1/0 - show classes the user belongs to
		

-->

  <xsl:template match="MODERATOR">
    <xsl:param name="showsitecount">1</xsl:param>
    <!-- Set this parameter to the site in question, to show which class the access is through -->
    <xsl:param name="showaccessthrough">0</xsl:param>
    <xsl:param name="showdirectsites">1</xsl:param>
    <xsl:param name="showclasses">1</xsl:param>
    <xsl:if test="position()=1">
      <tr>
        <td colspan="3">User details</td>
        <xsl:if test="$showclasses=1">
          <td>
            Class Access
          </td>
        </xsl:if>
        <xsl:if test="$showaccessthrough &gt; 0">
          <td>
            Access Granted Through
          </td>
        </xsl:if>
        <xsl:if test="$showdirectsites=1">
          <td>
            Direct Site Access
          </td>
        </xsl:if>
        <xsl:if test="$showsitecount=1">
          <td>No. of Sites</td>
        </xsl:if>
      </tr>
    </xsl:if>
    <tr valign="top">
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="BGCOLOR">#CCCCCC</xsl:attribute>
      </xsl:if>
      <td>
        <INPUT TYPE="CHECKBOX" NAME="userid" VALUE="{USER/USERID}"/>
      </td>
      <td>
        <a href="{$root}moderatormanagement?view=user&amp;viewid={USER/USERID}">
          U<xsl:value-of select="USER/USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USER/USERNAME"/>
      </td>
      <xsl:if test="$showclasses=1">
        <td>
          <xsl:for-each select="CLASSES/CLASSID">
            <xsl:variable name="curclass">
              <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID=$curclass]/NAME"/>
            <xsl:if test="position()!=last()">
              <br/>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:if>
      <xsl:if test="$showaccessthrough &gt; 0">
        <td>
          <xsl:choose>
            <xsl:when test="SITES/SITE[@SITEID=$showaccessthrough]/@CLASSID">
              <xsl:variable name="classforaccess">
                <xsl:value-of select="SITES/SITE[@SITEID=$showaccessthrough]/@CLASSID"/>
              </xsl:variable>
              <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID=$classforaccess]/NAME"/>
            </xsl:when>
            <xsl:when test="SITES/SITE[@SITEID=$showaccessthrough][not(@CLASSID)]">Direct Access</xsl:when>
          </xsl:choose>
        </td>
      </xsl:if>
      <xsl:if test="$showdirectsites=1">
        <td>
          <xsl:for-each select="SITES/SITE[not(@CLASSID)]">
            <xsl:variable name="thissiteid">
              <xsl:value-of select="@SITEID"/>
            </xsl:variable>
            <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$thissiteid]/SHORTNAME"/>
            <xsl:if test="position()!=last()">
              <br/>
            </xsl:if>
          </xsl:for-each>
        </td>
      </xsl:if>
      <xsl:if test="$showsitecount=1">
        <td>
          <xsl:value-of select="count(SITES/SITE)"/>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>


  <!-- 
**************** 
 -->
  <xsl:template match="MODERATOR-LIST[/H2G2/MODERATOR-VIEW/@VIEWTYPE='user']">
    <form method="GET" action="{$root}moderatormanagement">
      <input type="submit" name="updateuser" value="Update User Settings"/><br/>
      <input type="hidden" name="view" value="{$v_moderatorviewtype}"/>
      <input type="hidden" name="viewid" value="{$v_moderatorviewid}"/>
      <input type="hidden" name="userid" value="{$v_moderatorviewid}"/>
      <xsl:apply-templates select="MODERATOR[USER/USERID=$v_moderatoruserid]" mode="updateuserdetails"/>
      -------------------
    </form>

  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="MODERATOR-LIST/MODERATOR" mode="updateuserdetails">
    <xsl:variable name="thisid">
      <xsl:value-of select="USER/USERID"/>
    </xsl:variable>
    <H2>
      <xsl:value-of select="USER/USERNAME"/>'s Moderator details
    </H2>
    <table>
      <tr>
        <td>Name: </td>
        <td bgcolor="#CCCCCC">
          <xsl:value-of select="USER/USERNAME"/>
        </td>
        <td>Email: </td>
        <td bgcolor="#CCCCCC">
          <xsl:value-of select="USER/EMAIL"/>
        </td>
      </tr>
      <tr>
        <td>User ID: </td>
        <td bgcolor="#CCCCCC">
          <xsl:value-of select="USER/USERID"/>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td>Class level access</td>
        <td>Direct access</td>
      </tr>
      <tr>
        <td>
          <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
            <input type="checkbox" name="toclass" value="{@CLASSID}">
              <xsl:variable name="thisclassid">
                <xsl:value-of select="@CLASSID"/>
              </xsl:variable>
              <xsl:if test="/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID=$thisid]/CLASSES[CLASSID=$thisclassid]">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <xsl:value-of select="NAME"/>
            <br/>
          </xsl:for-each>
        </td>
        <td>
          <xsl:for-each select="/H2G2/SITE-LIST/SITE">
            <input type="checkbox" name="tosite" value="{@ID}">
              <xsl:variable name="thissiteid">
                <xsl:value-of select="@ID"/>
              </xsl:variable>
              <xsl:if test="/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID=$thisid]/SITES/SITE[@SITEID=$thissiteid]">
                <xsl:choose>
                  <xsl:when test="not(/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID=$thisid]/SITES/SITE[@SITEID=$thissiteid]/@CLASSID)">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID=$thisid]/SITES/SITE[@SITEID=$thissiteid]/@CLASSID">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>
            </input>
            <xsl:value-of select="SHORTNAME"/>
            <br/>
          </xsl:for-each>

        </td>
      </tr>
    </table>
  </xsl:template>


  <!-- 
**************** 
 -->

  <xsl:template match="MODERATOR-LIST[/H2G2/MODERATOR-VIEW/@VIEWTYPE='addmoderator']">
    <form method="GET" action="{$root}moderatormanagement">
      <input type="hidden" name="view" value="addmoderator"/>
      <input type="hidden" name="viewid" value="0"/>
      <xsl:apply-templates select="/H2G2/LASTACTION/ADDMODERATOR" mode="showform"/>
    </form>

  </xsl:template>

  <xsl:template match="MODERATOR-LIST[/H2G2/MODERATOR-VIEW/@VIEWTYPE='createnewclass']">
    <form method="GET" action="{$root}moderatormanagement">
      <input type="hidden" name="view" value="createnewclass"/>
      <input type="hidden" name="viewid" value="0"/>
      Name of class: <input type="text" name="classname"/><br/>
      Description: <input type="text" name="classdescription"/><br/>
      Based On Class: <select name="basedonclass">
        <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
          <option value="{@CLASSID}">
            <xsl:value-of select="NAME"/>
          </option>
        </xsl:for-each>
      </select> <br/>
      <input type="submit" name="createnewclass" value="Create New Class"/>
    </form>

  </xsl:template>
  <!-- 
**************** 
 -->

  <xsl:template match="ADDMODERATOR" mode="showform">
    email address: <input type="text" name="email" value="{EMAIL}"/><br/>
    <xsl:if test="ERROR/@TYPE=1">
      <B>No users were found matching that email address</B>
      <br/>
    </xsl:if>
    <xsl:if test="ERROR/@TYPE=2">
      <B>You must select at least one class</B>
      <br/>
    </xsl:if>
    <xsl:if test="ERROR/@TYPE=3">
      <B>You must select one of the listed users</B>
      <br/>
    </xsl:if>
    <input type="submit" name="finduser" value="Find user"/><br/>
    <xsl:choose>
      <xsl:when test="count(FOUNDUSERS/USER) = 1">
        Please select this user to confirm it's the one you want to add or type a new email address<br/>
      </xsl:when>
      <xsl:otherwise>
        Select the user you want to add, or type a different email address<br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="FOUNDUSERS/USER">
      <input type="radio" name="userid" value="{USERID}"/>
      <a href="{$root}U{USERID}">
        U<xsl:value-of select="USERID"/>
      </a>
      <xsl:text> </xsl:text>
      <xsl:value-of select="concat(USERNAME,' (',EMAIL,', ',LOGIN,')')"/>
      <xsl:variable name="thisuserid">
        <xsl:value-of select="USERID"/>
      </xsl:variable>
      <xsl:if test="/H2G2/MODERATOR-LIST/MODERATOR/USER[USERID=$thisuserid]">
        <b> Warning! This user already exists as a moderator</b>
      </xsl:if>
      <br/>
    </xsl:for-each>
    Add the selected user to the following classes and groups<br/>
    <table>
      <tr valign="top">
        <td>
          <xsl:apply-templates select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS" mode="addmoderatorcheckboxes"/>
        </td>
        <td>
          <xsl:apply-templates select="/H2G2/SITE-LIST/SITE" mode="addmoderatorcheckboxes"/>
        </td>
      </tr>
    </table>
    <!--
<xsl:apply-templates select="/H2G2/SITE-LIST/SITE" mode="addmoderatorcheckboxes"/>
-->
    <xsl:if test="FOUNDUSERS/USER">
      <input type="submit" name="addmoderator" value="Add Selected User"/>
    </xsl:if>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="MODERATION-CLASS" mode="addmoderatorcheckboxes">
    <input type="checkbox" name="toclass" value="{@CLASSID}">
      <xsl:variable name="tmp_classid">
        <xsl:value-of select="@CLASSID"/>
      </xsl:variable>
      <xsl:if test="/H2G2/LASTACTION/ADDMODERATOR/ADDTO/ADDTOCLASSES[CLASS=$tmp_classid]">
        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
      </xsl:if>
    </input>
    <xsl:value-of select="NAME"/>
    <br/>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="SITE-LIST/SITE" mode="addmoderatorcheckboxes">
    <input type="checkbox" name="tosite" value="{@ID}">
      <xsl:variable name="tmp_siteid">
        <xsl:value-of select="@ID"/>
      </xsl:variable>
      <xsl:if test="/H2G2/LASTACTION/ADDMODERATOR/ADDTO/ADDTOSITES[SITE=$tmp_siteid]">
        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
      </xsl:if>
    </input>
    <xsl:value-of select="SHORTNAME"/>
    <br/>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="REMOVEDUSERS">
    <xsl:choose>
      <xsl:when test="count(USER) = 1">
        Moderator <xsl:value-of select="concat(USER/USERNAME,' (',USER/USERID,')')"/> has been removed<br/>
      </xsl:when>
      <xsl:otherwise>
        The following moderators have been removed:<br/>
        <xsl:for-each select="USER">
          <xsl:value-of select="concat(USERNAME,' (',USERID,')')"/>
          <br/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="confirmjavascript">
    <xsl:param name="message">Are you sure?</xsl:param>
    <xsl:attribute name="OnClick">
      javascript:return(confirm('<xsl:value-of select="$message"/>'))
    </xsl:attribute>
  </xsl:template>

  <!-- 
**************** 
 -->

  <xsl:template match="H2G2[@TYPE='STATUSPAGE' and PARAMS/PARAM[NAME='s_disp']/VALUE='stats']">

    <html>
      <head>
        <title>DNA statistics</title>
      </head>
      <body>
        <h1>
          Statistics for <xsl:value-of select="/H2G2/SERVERNAME"/>
        </h1>

        <table>
          <tr>
            <td>Time</td>
            <td>Raw Requests</td>
            <td>Server Too Busy</td>
            <td>Cache hits</td>
            <td>Cache Misses</td>
            <td>Non SSO requests</td>
            <td>HTML cache hits</td>
            <td>HTML cache misses</td>
            <td>RSS cache hits</td>
            <td>RSS cache misses</td>
            <td>SSI cache hits</td>
            <td>SSI cache misses</td>
            <td>Average Request Time</td>
            <td>Total Requests</td>
          </tr>
          <xsl:for-each select="/H2G2/STATUS-REPORT/STATISTICS/STATISTICSDATA">
            <tr>
              <td>
                <xsl:value-of select="@INTERVALSTARTTIME"/>
              </td>
              <td>
                <xsl:value-of select="RAWREQUESTS"/>
              </td>
              <td>
                <xsl:value-of select="SERVERBUSYCOUNT"/>
              </td>
              <td>
                <xsl:value-of select="CACHEHITS"/>
              </td>
              <td>
                <xsl:value-of select="CACHEMISSES"/>
              </td>
              <td>
                <xsl:value-of select="NONSSOREQUESTS"/>
              </td>
              <td>
                <xsl:value-of select="HTMLCACHEHITS"/>
              </td>
              <td>
                <xsl:value-of select="HTMLCACHEMISSES"/>
              </td>
              <td>
                <xsl:value-of select="RSSCACHEHITS"/>
              </td>
              <td>
                <xsl:value-of select="RSSCACHEMISSES"/>
              </td>
              <td>
                <xsl:value-of select="SSICACHEHITS"/>
              </td>
              <td>
                <xsl:value-of select="SSICACHEMISSES"/>
              </td>
              <td>
                <xsl:value-of select="AVERAGEREQUESTTIME"/>
              </td>
              <td>
                <xsl:value-of select="REQUESTS"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>


      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
