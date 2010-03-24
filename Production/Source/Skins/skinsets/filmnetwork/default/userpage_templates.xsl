<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="userpage_message_template.xsl"/>
        <xsl:import href="userpage_comments_template.xsl"/>
        <xsl:import href="userpage_contacts_template.xsl"/>
        <!-- ALISTAIR/TRENT: ideally the following templates would be defined using modes. 
because we are on a time crunch i have defined basic templates and made calls to them using the call-template element. 
the main problem with this design is that call-template doesn't allow you to modify the context node, 
so every testing expression is -->
        <!-- 
     #####################################################################################
	   USER BIOGRAPHY/INTRODUCTION: the top section on a user page 
     ##################################################################################### 
-->
        <xsl:template name="USER_BIOGRAPHY">
                <table border="0" cellpadding="0" cellspacing="0" class="profileTitleFirst" width="371">
                        <tr>
                                <td class="profileTitleImg" valign="top" width="175">
                                        <!-- if filmmaker or industry prof, img for 'biography' -->
                                        <xsl:if test="$isStandardUser=0">
                                                <h2>
                                                        <img alt="biography" height="25" src="{$imagesource}furniture/myprofile/heading_biography.gif" width="124"/>
                                                </h2>
                                        </xsl:if>
                                        <!-- if standard user, img for 'introduction' -->
                                        <xsl:if test="$isStandardUser=1">
                                                <h2>
                                                        <img alt="introduction" height="24" src="{$imagesource}furniture/myprofile/heading_introduction.gif" width="143"/>
                                                </h2>
                                        </xsl:if>
                                </td>
                                <td valign="bottom">
                                        <div class="profileTitleLink">
                                                <!-- if filmmaker or industry prof, edit full biog -->
                                                <xsl:choose>
                                                        <xsl:when test="$isStandardUser=0">
                                                                <xsl:if test="$test_IsEditor or $ownerisviewer = 1">
                                                                        <xsl:variable name="location"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_place]/ANCESTOR[position()=last()]/NAME"/>
                                                                        <xsl:variable name="location_id"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_place]/ANCESTOR[position()=last()]/NODEID"/>
                                                                        <xsl:variable name="specialism1"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=1]/ANCESTOR[position()=last()]/NAME"/>
                                                                        <xsl:variable name="specialism1_id"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=1]/ANCESTOR[position()=last()]/NODEID"/>
                                                                        <xsl:variable name="specialism2"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=2]/ANCESTOR[position()=last()]/NAME"/>
                                                                        <xsl:variable name="specialism2_id"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=2]/ANCESTOR[position()=last()]/NODEID"/>
                                                                        <xsl:variable name="specialism3"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=3]/ANCESTOR[position()=last()]/NAME"/>
                                                                        <xsl:variable name="specialism3_id"
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_specialism][position()=3]/ANCESTOR[position()=last()]/NODEID"/>
                                                                        <a
                                                                                href="{$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_films={$filmPageCount}&amp;s_location={$location}&amp;s_location_id={$location_id}&amp;s_specialism1={$specialism1}&amp;s_specialism1_id={$specialism1_id}&amp;s_specialism2={$specialism2}&amp;s_specialism2_id={$specialism2_id}&amp;s_specialism3={$specialism3}&amp;s_specialism3_id={$specialism3_id}"><strong>
                                                                                        <xsl:choose>
                                                                                                <xsl:when test="$test_introarticle_ifilm"> edit </xsl:when>
                                                                                                <xsl:otherwise> add </xsl:otherwise>
                                                                                        </xsl:choose> my biog</strong>&nbsp;<img alt="" height="7"
                                                                                        src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                                </xsl:if>
                                                        </xsl:when>
                                                        <!-- if standard user, only edit introduction -->
                                                        <xsl:otherwise>
                                                                <xsl:if test="$test_IsEditor or $ownerisviewer = 1">
                                                                        <a href="{$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_standard=1"><strong>
                                                                                        <xsl:choose>
                                                                                                <xsl:when test="$test_introarticle_ifilm"> edit </xsl:when>
                                                                                                <xsl:otherwise> add </xsl:otherwise>
                                                                                        </xsl:choose> introduction</strong>&nbsp;<img alt="" height="7"
                                                                                        src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                                </xsl:if>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                </td>
                        </tr>
                </table>
                <xsl:apply-templates mode="t_userpageintro" select="PAGE-OWNER"/>
        </xsl:template>
        <!-- 	
	 #########
	  new templates for ifilm by Trent Williams 
     #########
-->
        <!--
	<xsl:template match="PAGE-OWNER" mode="t_userpageintro">
	Author:		Tom Whitehouse
	Context:    /H2G2/PAGE-OWNER
	Purpose:	Creates the correct text for introductioon to the userpage
	Update By:	Trent Williams
	Update:		need to now print more fields then just body and check at least one has content in to know wether user has filled something in.
	-->
        <xsl:template match="PAGE-OWNER" mode="t_userpageintro">
                <xsl:choose>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:call-template name="m_userpagehidden"/>
                                </xsl:element>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:call-template name="m_userpagereferred"/>
                                </xsl:element>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:call-template name="m_userpagependingpremoderation"/>
                                </xsl:element>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <xsl:call-template name="m_legacyuserpageawaitingmoderation"/>
                                </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:choose>
                                        <xsl:when test="$test_introarticle_ifilm">
                                                <xsl:apply-templates mode="userpage_bio" select="/H2G2/ARTICLE/GUIDE"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:choose>
                                                        <xsl:when test="$ownerisviewer = 1">
                                                                <xsl:choose>
                                                                        <xsl:when test="$isStandardUser=1">
                                                                                <xsl:call-template name="m_psintrostandarduserowner"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:call-template name="m_psintroowner"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:call-template name="m_psintroviewer"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="/H2G2/ARTICLE/GUIDE/BODY" mode="userpage_bio">
	Author:		Trent Williams
	Context:    /H2G2/PAGE-OWNER
	Purpose:	Display userpagebio area
	
-->
        <xsl:template match="/H2G2/ARTICLE/GUIDE" mode="userpage_bio">
                <!-- variables used below ($isIndustryPro and $isFilmmaker) are defined in HTMLOutput.xsl for now -->
                <div class="titlepara">
                        <strong>biog</strong>
                        <br/>
                        <xsl:apply-templates select="BODY"/>
                </div>
                <xsl:if test="TBC[text()] and $isFilmmaker=1">
                        <div class="titlepara">
                                <strong>ambitions</strong>
                                <br/>
                                <xsl:apply-templates select="TBC"/>
                        </div>
                </xsl:if>
                <xsl:if test="ORGINFO[text()] and $isIndustryProf=1">
                        <div class="titlepara">
                                <strong>organisation info</strong>
                                <br/>
                                <xsl:apply-templates select="ORGINFO"/>
                        </div>
                </xsl:if>
                <xsl:if test="PROJECTINDEVELOPMENT[text()] and $isFilmmaker=1">
                        <div class="titlepara">
                                <strong>project in development</strong>
                                <br/>
                                <xsl:apply-templates select="PROJECTINDEVELOPMENT"/>
                        </div>
                </xsl:if>
                <xsl:if test="FAVFILMS[text()] and ($isFilmmaker=1 or $isIndustryProf=1)">
                        <div class="titlepara">
                                <strong>influences, inspirations and favourite films</strong>
                                <br/>
                                <xsl:apply-templates select="FAVFILMS"/>
                        </div>
                </xsl:if>
                <xsl:if test="MYLINKS1[text()] and ($isFilmmaker=1 or $isIndustryProf=1)">
                        <div class="titlepara">
                                <strong>my links</strong>
                                <ul class="centcollist">
                                        <xsl:if test="MYLINKS1[text()]">
                                                <li>
                                                        <strong>
                                                                <a target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="starts-with(MYLINKS1, 'http')">
                                                                                                <xsl:value-of select="MYLINKS1"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:text>http://</xsl:text>
                                                                                                <xsl:value-of select="MYLINKS1"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <!-- <xsl:value-of select="MYLINKS1" /> -->
                                                                        <xsl:choose>
                                                                                <xsl:when test="MYLINKS1_TEXT[text()]">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS1_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS1_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS1"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS1"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </strong>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="MYLINKS2[text()]">
                                                <li>
                                                        <strong>
                                                                <a target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="starts-with(MYLINKS2, 'http')">
                                                                                                <xsl:value-of select="MYLINKS2"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:text>http://</xsl:text>
                                                                                                <xsl:value-of select="MYLINKS2"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="MYLINKS2_TEXT[text()]">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS2_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS2_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS2"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS2"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </strong>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="MYLINKS3[text()]">
                                                <li>
                                                        <strong>
                                                                <a target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when test="starts-with(MYLINKS3, 'http')">
                                                                                                <xsl:value-of select="MYLINKS3"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:text>http://</xsl:text>
                                                                                                <xsl:value-of select="MYLINKS3"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="MYLINKS3[text()]">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS3_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS3_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="MYLINKS3"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="MYLINKS3"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </strong>
                                                </li>
                                        </xsl:if>
                                </ul>
                        </div>
                </xsl:if>
                <xsl:if test="$ownerisviewer != 1">
                        <!-- alert editors -->
                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td height="10"/>
                                </tr>
                                <tr>
                                        <td valign="top">
                                                <div class="alerteditorbody"><strong>
                                                                <a
                                                                        href="javascript:popupwindow('/dna/filmnetwork/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')"
                                                                        xsl:use-attribute-sets="maHIDDEN_r_complainmp">
                                                                        <img alt="Click this button if you see something on this page that breaks the house rules." height="16"
                                                                                src="{$imagesource}furniture/keyalert.gif" width="17"/>
                                                                </a>
                                                        </strong> Click this button if you see something on this page that breaks the house rules.</div>
                                        </td>
                                </tr>
                                <tr>
                                        <td height="10"/>
                                </tr>
                        </table>
                        <!-- END alert editors -->
                </xsl:if>
        </xsl:template>
        <!-- 
     #####################################################################################
	   RIGHT SIDE SECTION: 'Also on this page'
     ##################################################################################### 
-->
        <xsl:template name="USER_ALSO_ON_PAGE">
                <!-- BEGIN also on this page -->
                <table border="0" cellpadding="0" cellspacing="0" width="244">
                        <tr>
                                <td align="right" class="webboxbg" height="141" valign="top" width="50">
                                        <div class="alsoicon">
                                                <img alt="" height="24" src="{$imagesource}furniture/myprofile/alsoicon.gif" width="25"/>
                                        </div>
                                </td>
                                <td class="webboxbg" valign="top" width="122">
                                        <div class="alsoonpage">
                                                <strong>also on this page</strong>
                                        </div>
                                        <div class="alsolist">
                                                <xsl:if test="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID=$site_number]) > 0"><a class="rightcol" href="#filmography">
                                                                <strong>filmography</strong>
                                                        </a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowwhite.gif" width="4"/><br/>
                                                </xsl:if>
                                                <xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID=$site_number and EXTRAINFO/TYPE[@ID != '3001']]) > 0"><a class="rightcol"
                                                                href="#submissions">
                                                                <strong>submissions</strong>
                                                        </a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowwhite.gif" width="4"/><br/>
                                                </xsl:if>
                                                <xsl:if test="$isStandardUser=0 and count(/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID=$site_number]) > 0 ">
                                                        <a class="rightcol" href="#comments">
                                                                <strong>comments</strong>
                                                        </a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowwhite.gif" width="4"/><br/>
                                                </xsl:if>
                                                <a class="rightcol" href="#messages">
                                                        <strong>messages</strong>
                                                </a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowwhite.gif" width="4"/></div>
                                </td>
                                <td class="webboxbg" valign="top" width="72">
                                        <img alt="" height="39" src="{$imagesource}furniture/myprofile/anglegrey.gif" width="72"/>
                                </td>
                        </tr>
                </table>
                <!-- END also on this page -->
        </xsl:template>
        <!-- 
     #####################################################################################
									FILMOGRAPHY
     ##################################################################################### 
-->
        <xsl:template name="USER_FILMOGRAPHY">
                <a name="filmography"/>
                <!-- BEGIN second section header -->
                <table border="0" cellpadding="0" cellspacing="0" class="profileTitle" width="371">
                        <tr>
                                <td valign="top" width="175">
                                        <h2>
                                                <img alt="films" height="24" src="{$imagesource}furniture/myprofile/heading_films.gif" width="82"/>
                                        </h2>
                                </td>
                                <td valign="bottom">
                                        <div class="profileTitleLink">
                                                <xsl:if test="$test_IsEditor or ($ownerisviewer = 1)">
                                                        <a href="{$root}TypedArticle?acreate=new&amp;type=30"><strong>submit another short</strong>&nbsp;<img alt="" height="7"
                                                                        src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                        </tr>
                        <tr>
                                <td valign="top">
                                        <div class="textmedium">
                                                <strong>
                                                        <xsl:choose>
                                                                <xsl:when test="$ownerisviewer = 1">
                                                                        <xsl:choose>
                                                                                <!-- for editors that are viewing their own user page -->
                                                                                <xsl:when test="$test_IsEditor"> Below is a list of films or article pages featured on Film Network that you have worked
                                                                                        on. </xsl:when>
                                                                                <!-- for all other users viewing their own page -->
                                                                                <xsl:otherwise> Below is a list of films featured on Film Network that you have worked on. </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:when>
                                                                <!-- for all viewers that are not the owner of that user page -->
                                                                <xsl:otherwise> Below is a list of films featured on Film Network that <xsl:choose>
                                                                                <xsl:when test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
                                                                                        <xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"/>&nbsp; <xsl:value-of
                                                                                                select="/H2G2/PAGE-OWNER/USER/LASTNAME"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose> has worked on. </xsl:otherwise>
                                                        </xsl:choose>
                                                </strong>
                                        </div>
                                        <!-- 12px Spacer table -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="12"/>
                                                </tr>
                                        </table>
                                        <!-- END 12px Spacer table -->
                                        <!-- filmography content table -->
                                        <xsl:choose>
                                                <xsl:when test="$test_IsEditor">
                                                        <!-- if an editor display all film network recent approval-->
                                                        <xsl:for-each
                                                                select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID!= 63][EXTRAINFO/TYPE/@ID!= 64][position() &lt;=$articlelimitentries]">
                                                                <xsl:choose>
                                                                        <xsl:when test="position(  ) mod 2 = 0">
                                                                                <div class="even">
                                                                                        <xsl:call-template name="USER_FILMOGRAPHY_ENTRY"/>
                                                                                </div>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <div class="odd">
                                                                                        <xsl:call-template name="USER_FILMOGRAPHY_ENTRY"/>
                                                                                </div>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <!-- otherwise (if not editor) only display all film network recent approval that are films (i.e EXTRAINFO/TYPE@ID begins with a 3)-->
                                                        <xsl:for-each
                                                                select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=3]][position() &lt;=$articlelimitentries]">
                                                                <xsl:choose>
                                                                        <xsl:when test="position(  ) mod 2 = 0">
                                                                                <div class="even">
                                                                                        <xsl:call-template name="USER_FILMOGRAPHY_ENTRY"/>
                                                                                </div>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <div class="odd">
                                                                                        <xsl:call-template name="USER_FILMOGRAPHY_ENTRY"/>
                                                                                </div>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:for-each>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- BEGIN 12px Spacer table -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="12"/>
                                                </tr>
                                        </table>
                                        <!-- END 12px Spacer table -->
                                        <xsl:if test="$filmPageCount > $articlelimitentries">
                                                <!-- more films table -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td valign="top" width="371">
                                                                        <div class="morecommments">
                                                                                <strong>
                                                                                        <a href="{$root}MA{/H2G2/RECENT-APPROVALS/USER/USERID}?type=1"
                                                                                                xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles"> more films </a>
                                                                                </strong>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- END more films table -->
                                        </xsl:if>
                                        <div class="profileMoreAbout">
                                                <a href="{$root}SiteHelpProfile#films">more about films&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
                                                        /></a>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     #####################################################################################
					DEFINES INFO FOR EACH FILM THAT WILL BE LISTED IN THE FILMOLOGY
     ##################################################################################### 
-->
        <xsl:template name="USER_FILMOGRAPHY_ENTRY">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td class="filmsImg" valign="top" width="51">
                                        <xsl:variable name="article_small_gif">
                                                <xsl:choose>
                                                        <xsl:when test="$showfakegifs = 'yes'">A3923219_small.jpg</xsl:when>
                                                        <xsl:otherwise>A<xsl:value-of select="H2G2-ID"/>_small.jpg</xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:variable>
                                        <img alt="" height="30" src="{$imagesource}{$gif_assets}{$article_small_gif}" width="31"/>
                                </td>
                                <td class="filmsTxt" valign="top" width="320">
                                        <div class="itemTitle">
                                                <strong>
                                                        <xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"/>
                                                </strong>
                                        </div>
                                        <div class="itemText">
                                                <!-- BEGIN CRUMBTRAIL -->
                                                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,1,1)=3]">
                                                        <!-- director's name-->
                                                        <xsl:if test="EXTRAINFO/DIRECTORSNAME != ''">
                                                                <xsl:apply-templates select="EXTRAINFO/DIRECTORSNAME"/> | </xsl:if>
                                                        <!-- region -->
                                                        <xsl:if test="EXTRAINFO/REGION != ''">
                                                                <xsl:choose>
                                                                        <xsl:when test="EXTRAINFO/REGION = 'non-UK' and EXTRAINFO/REGION-OTHER != ''">
                                                                                <xsl:value-of select="EXTRAINFO/REGION-OTHER"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:call-template name="LINK_REGION">
                                                                                        <xsl:with-param name="region">
                                                                                                <xsl:value-of select="EXTRAINFO/REGION"/>
                                                                                        </xsl:with-param>
                                                                                        <xsl:with-param name="class">textdark</xsl:with-param>
                                                                                </xsl:call-template>
                                                                        </xsl:otherwise>
                                                                </xsl:choose> | </xsl:if>
                                                        <!-- language -->
                                                        <xsl:if test="EXTRAINFO/LANGUAGE != ''">
                                                                <xsl:choose>
                                                                        <xsl:when test="EXTRAINFO/LANGUAGE = 'other' and EXTRAINFO/LANGUAGE-OTHER != ''">
                                                                                <xsl:value-of select="EXTRAINFO/LANGUAGE-OTHER"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:value-of select="EXTRAINFO/LANGUAGE"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose> | </xsl:if>
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
                                                        <!-- genre -->
                                                        <!-- the following links point to the category main page, not the full
						 category listing page. to change to the full cat listing page,
						 modify the href value: {$root}C{$genreAnimation} -->
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
                                                        </xsl:choose>
                                                        <br/>
                                                </xsl:if>
                                                <xsl:if test="$test_IsEditor and (EXTRAINFO/TYPE/@ID[substring(.,1,1)=6] or EXTRAINFO/TYPE/@ID[substring(.,1,1)=1])"> article type: <xsl:value-of
                                                                select="EXTRAINFO/TYPE/@ID"/>
                                                        <br/>
                                                </xsl:if>
                                                <!-- published by date --> published <xsl:value-of select="DATE-CREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                        select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"/>&nbsp;<xsl:value-of select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)"/><!-- </a> -->
                                                <br/>
                                                <!-- film description -->
                                                <xsl:if test="EXTRAINFO/DESCRIPTION">
                                                        <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                        <br/>
                                                </xsl:if>
                                                <!-- view notes link -->
                                                <xsl:if test="EXTRAINFO/NOTESID[text()]">
                                                        <xsl:variable name="notesID">
                                                                <xsl:value-of select="EXTRAINFO/NOTESID"/>
                                                        </xsl:variable>
                                                        <strong>
                                                                <a href="{$root}{$notesID}">view filmmakers notes&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif"
                                                                                width="4"/></a>
                                                        </strong>
                                                        <br/>
                                                </xsl:if>
                                                <!-- feedback link -->
                                                <xsl:if test="$ownerisviewer = 1">
                                                        <br/> has having your film on filmnetwork been of benefit to you - <a>
                                                                <xsl:attribute name="href">mailto:filmnetwork@bbc.co.uk?subject=Filmaker's Feedback - Film Title: <xsl:value-of select="SUBJECT"/>, Film
                                                                        ID: <xsl:value-of select="H2G2-ID"/>, User ID: <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/></xsl:attribute>
                                                                <strong>email us your feedback &gt;</strong>
                                                        </a>
                                                        <br/>
                                                </xsl:if>
                                                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                                                        <div class="debug"> Article ID: A<xsl:value-of select="H2G2-ID"/>
                                                                <BR/> Article type: <xsl:value-of select="EXTRAINFO/TYPE/@ID"/>
                                                                <BR/> Site ID: <xsl:value-of select="SITEID"/>
                                                                <BR/> Status: <xsl:value-of select="STATUS"/>
                                                                <BR/>
                                                        </div>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     #####################################################################################
									CREDITS
     ##################################################################################### 
-->
        <xsl:template name="USER_CREDITS">
                <!-- CREDITS  not submissions -->
                <!-- $creditPageCount defined in HTMLOutput -->
                <!-- second section header -->
                <a name="credits"/>
                <!-- BEGIN second section header -->
                <table border="0" cellpadding="0" cellspacing="0" class="profileTitle" width="371">
                        <tr>
                                <td valign="top" width="175">
                                        <h2>
                                                <img alt="credits" height="24" src="{$imagesource}furniture/myprofile/heading_credits.gif" width="98"/>
                                        </h2>
                                </td>
                                <td valign="bottom">
                                        <div class="profileTitleLink">
                                                <xsl:if test="$test_IsEditor or ($ownerisviewer = 1)">
                                                        <a href="{$root}TypedArticle?acreate=new&amp;type=70"><strong>add credit</strong>&nbsp;<img alt="" height="7"
                                                                        src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
                <!-- END second section header -->
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                        </tr>
                        <tr>
                                <td valign="top">
                                        <xsl:if test="$creditPageCount &gt; 0">
                                                <div class="textmedium">
                                                        <strong>
                                                                <xsl:choose>
                                                                        <xsl:when test="$ownerisviewer = 1"> These are your credits. Click 'add credit' to add another. </xsl:when>
                                                                        <xsl:otherwise> Below is a list of <xsl:choose>
                                                                                        <xsl:when test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
                                                                                                <xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"/>&nbsp; <xsl:value-of
                                                                                                    select="/H2G2/PAGE-OWNER/USER/LASTNAME"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>'s credits. </xsl:otherwise>
                                                                </xsl:choose>
                                                        </strong>
                                                </div>
                                                <!-- 12px Spacer table -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td height="12"/>
                                                        </tr>
                                                </table>
                                                <!-- END 12px Spacer table -->
                                                <xsl:for-each select="$isCreditPage[position() &lt;=$articlelimitentries]">
                                                        <xsl:choose>
                                                                <xsl:when test="position(  ) mod 2 = 0">
                                                                        <div class="even">
                                                                                <xsl:call-template name="USER_CREDITS_ENTRY"/>
                                                                        </div>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <div class="odd">
                                                                                <xsl:call-template name="USER_CREDITS_ENTRY"/>
                                                                        </div>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:for-each>
                                        </xsl:if>
                                        <xsl:if test="$isFilmmaker=1 and $ownerisviewer = 1 and $creditPageCount = 0">
                                                <!-- ALISTAIR: move me to filmnetwork text file -->
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">Links to credit pages you add will appear here. You may add a credit page for each film you have made or worked on. Please do NOT add a credit for a film that has already been selected for a showcase on film network. Please note: Unsuccessful submissions can be turned into a credit page later.</xsl:element>
                                        </xsl:if>
                                        <!-- END submissions content table -->
                                </td>
                        </tr>
                </table>
                <xsl:if test="$creditPageCount > $articlelimitentries">
                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td height="12"/>
                                </tr>
                        </table>
                        <!-- more films table -->
                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td valign="top" width="371">
                                                <div class="morecommments">
                                                        <strong>
                                                                <a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=2&amp;s_iscredit=yes"
                                                                        xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles"> more credits </a>
                                                        </strong>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/>
                                                </div>
                                        </td>
                                </tr>
                        </table>
                        <!-- END more films table -->
                </xsl:if>
                <div class="profileMoreAbout">
                        <a href="{$root}SiteHelpProfile#credits">more about credits&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                </div>
        </xsl:template>
        <!-- #####################################################################################
			USER_CREDITS_ENTRY
			PROVIES INFO FOR EACH CREDIT TO BE INCLUDED IN THE LISTING
	 #####################################################################################
-->
        <xsl:template name="USER_CREDITS_ENTRY">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td class="creditsImg" valign="top" width="51">
                                        <img alt="" height="40" src="{$imagesource}furniture/myprofile/icon_file1.gif" width="33"/>
                                </td>
                                <td class="creditsTxt" valign="top" width="320">
                                        <div class="itemTitle">
                                                <strong>
                                                        <xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"/>
                                                </strong>
                                        </div>
                                        <div class="itemText">
                                                <!-- director's name-->
                                                <xsl:if test="EXTRAINFO/DIRECTORSNAME">
                                                        <xsl:apply-templates select="EXTRAINFO/DIRECTORSNAME"/> | </xsl:if>
                                                <!-- region -->
                                                <xsl:if test="EXTRAINFO/REGION != ''">
                                                        <xsl:choose>
                                                                <xsl:when test="EXTRAINFO/REGION = 'non-UK' and EXTRAINFO/REGION-OTHER != ''">
                                                                        <xsl:value-of select="EXTRAINFO/REGION-OTHER"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:call-template name="LINK_REGION">
                                                                                <xsl:with-param name="region">
                                                                                        <xsl:value-of select="EXTRAINFO/REGION"/>
                                                                                </xsl:with-param>
                                                                                <xsl:with-param name="class">textdark</xsl:with-param>
                                                                        </xsl:call-template>
                                                                </xsl:otherwise>
                                                        </xsl:choose> | </xsl:if>
                                                <!-- language -->
                                                <xsl:if test="EXTRAINFO/LANGUAGE != ''">
                                                        <xsl:choose>
                                                                <xsl:when test="EXTRAINFO/LANGUAGE = 'other' and EXTRAINFO/LANGUAGE-OTHER != ''">
                                                                        <xsl:value-of select="EXTRAINFO/LANGUAGE-OTHER"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="EXTRAINFO/LANGUAGE"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose> | </xsl:if>
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
                                                <!-- genre -->
                                                <!-- the following links point to the category main page, not the full
					 category listing page. to change to the full cat listing page,
					 modify the href value: {$root}C{$genreAnimation} -->
                                                <xsl:choose>
                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 70">
                                                                <a class="textdark" href="{$root}C{$genreDrama}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype"/>
                                                                </a>
                                                        </xsl:when>
                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 71">
                                                                <a class="textdark" href="{$root}C{$genreComedy}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype"/>
                                                                </a>
                                                        </xsl:when>
                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 72">
                                                                <a class="textdark" href="{$root}C{$genreDocumentry}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype"/>
                                                                </a>
                                                        </xsl:when>
                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 73">
                                                                <a class="textdark" href="{$root}C{$genreAnimation}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype"/>
                                                                </a>
                                                        </xsl:when>
                                                        <xsl:when test="EXTRAINFO/TYPE/@ID = 74">
                                                                <a class="textdark" href="{$root}C{$genreExperimental}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype"/>
                                                                </a>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <a class="textdark" href="{$root}C{$genreMusic}">
                                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype"/>
                                                                </a>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- published by date -->
                                                <!--
				<br />
				published 
				<xsl:value-of select="DATE-CREATED/DATE/@DAY" />&nbsp;<xsl:value-of select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)" />&nbsp;<xsl:value-of select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)" />  -->
                                                <!-- film description -->
                                                <br/>
                                                <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                <!-- participation -->
                                                <br/> role: <xsl:apply-templates select="EXTRAINFO/YOUR_ROLE"/>
                                                <br/>
                                                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                                                        <div class="debug"> Article ID: A<xsl:value-of select="H2G2-ID"/>
                                                                <BR/> Article type: <xsl:value-of select="EXTRAINFO/TYPE/@ID"/>
                                                                <BR/> Site ID: <xsl:value-of select="SITEID"/>
                                                                <BR/> Status: <xsl:value-of select="STATUS"/>
                                                                <BR/>
                                                        </div>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     #####################################################################################
	   submission section of a user page
     ##################################################################################### 
-->
        <xsl:template name="USER_SUBMISSIONS">
                <a name="submissions"/>
                <!-- BEGIN second section header -->
                <table border="0" cellpadding="0" cellspacing="0" class="profileTitle" width="371">
                        <tr>
                                <td valign="top" width="175">
                                        <h2>
                                                <img alt="submissions" height="24" src="{$imagesource}furniture/myprofile/heading_submissions.gif" width="153"/>
                                        </h2>
                                </td>
                                <td valign="bottom">
                                        <div class="profileTitleLink">
                                                <xsl:if test="$test_IsEditor or ($ownerisviewer = 1)">
                                                        <a href="{$root}TypedArticle?acreate=new&amp;type=30"><strong>submit another short</strong>&nbsp;<img alt="" height="7"
                                                                        src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
                <div class="textmedium">
                        <strong>Below is a list of your submissions to Film Network. These submissions are only visible to you and not other members.</strong>
                </div>
                <!-- submissions content table -->
                <!-- checks to see if there are any articles with a status=1 (in xml: /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/STATUS) and if there are lists each one  -->
                <ul class="submmissions">
                        <xsl:for-each select="($isSubmissionPage | $isDeclinedPage)[position() &lt;=$articlelimitentries]">
                                <xsl:choose>
                                        <xsl:when test="position(  ) mod 2 = 0">
                                                <li class="even">
                                                        <xsl:call-template name="USER_SUBMISSIONS_ENTRY"/>
                                                </li>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <li class="odd">
                                                        <xsl:call-template name="USER_SUBMISSIONS_ENTRY"/>
                                                </li>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:for-each>
                </ul>
                <xsl:if test="($submissionPageCount + $declinedPageCount) > $articlelimitentries">
                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td height="12"/>
                                </tr>
                        </table>
                        <!-- more films table -->
                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                <tr>
                                        <td valign="top" width="371">
                                                <div class="morecommments">
                                                        <strong>
                                                                <a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=2&amp;s_issubmission=yes"
                                                                        xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles">more film submissions&nbsp;<img alt="" height="7"
                                                                                src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                                                        </strong>
                                                </div>
                                        </td>
                                </tr>
                        </table>
                </xsl:if>
                <div class="profileMoreAbout">
                        <a href="{$root}SiteHelpSubmitting">more about submissions&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/></a>
                </div>
        </xsl:template>
        <!-- #####################################################################################
			USER_SUBMISSIONS_ENTRY
			PROVIDES INFO FOR EACH SUBMISSION TO BE INCLUDED IN THE LISTING
	 #####################################################################################
-->
        <xsl:template name="USER_SUBMISSIONS_ENTRY">
                <div class="submissionTitle">
                        <img align="absmiddle" alt="" height="5" src="{$imagesource}furniture/myprofile/bullett.gif" width="5"/>
                        <strong>&nbsp;<xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"/></strong>
                </div>
                <div class="submissionDetails">
                        <span class="itemText">
                                <xsl:value-of select="DATE-CREATED/DATE/@DAY"/>&nbsp;<xsl:value-of select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"/>&nbsp;<xsl:value-of
                                        select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)"/><!-- </a> --> | </span>
                        <xsl:choose>
                                <xsl:when test="EXTRAINFO/FILM_STATUS_MSG[text()]">
                                        <span class="submissionStatus">
                                                <xsl:value-of select="EXTRAINFO/FILM_STATUS_MSG"/>
                                        </span>
                                </xsl:when>
                                <xsl:when test="EXTRAINFO/TYPE/@ID[substring(.,1,1)=5]">
                                        <span class="submissionStatus">declined</span>
                                </xsl:when>
                                <xsl:otherwise>
                                        <span class="submissionStatus">new submission</span>
                                </xsl:otherwise>
                        </xsl:choose>
                </div>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,1,1)=5]">
                        <xsl:variable name="creditTypeNumber" select="EXTRAINFO/TYPE/@ID + 20"/>
                        <div class="submissionActions"><a href="{root}TypedArticle?aedit=new&amp;type={$creditTypeNumber}&amp;h2g2id={H2G2-ID}">convert into credit</a> | <a
                                        href="{root}TypedArticle?adelete=delete&amp;h2g2id={H2G2-ID}">remove</a></div>
                </xsl:if>
        </xsl:template>
        <!-- 
     #####################################################################################
										FEATURES
     ##################################################################################### 
-->
        <xsl:template name="USER_FEATURES">
                <a name="features"/>
                <!-- magazine heading -->
                <table border="0" cellpadding="0" cellspacing="0" class="profileTitle" width="371">
                        <tr>
                                <td valign="top" width="175">
                                        <h2>
                                                <img alt="magazine features" height="24" src="{$imagesource}furniture/heading_magazine.gif" width="205"/>
                                        </h2>
                                </td>
                                <!-- 
			<td valign="bottom">
				<div class="profileTitleLink">
					<xsl:if test="$test_IsEditor">
						<a href="{$root}TypedArticle?acreate=new&amp;type=63"><strong>submit your feature</strong>&nbsp;<img src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" /></a>
					</xsl:if>
				</div>
			</td>
			-->
                        </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                        </tr>
                        <tr>
                                <td valign="top">
                                        <div class="textmedium">
                                                <strong>
                                                        <xsl:choose>
                                                                <xsl:when test="$ownerisviewer = 1"> Below is a list of featured articles on Film Network that you have worked on. </xsl:when>
                                                                <xsl:otherwise> Below is a list of featured articles on Film Network that <xsl:choose>
                                                                                <xsl:when test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
                                                                                        <xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"/>&nbsp; <xsl:value-of
                                                                                                select="/H2G2/PAGE-OWNER/USER/LASTNAME"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose> has worked on. </xsl:otherwise>
                                                        </xsl:choose>
                                                </strong>
                                        </div>
                                        <!-- 12px Spacer table -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="12"/>
                                                </tr>
                                        </table>
                                        <!-- END 12px Spacer table -->
                                        <!-- features content table -->
                                        <!-- checks to see if is a Features page  -->
                                        <!-- variable defined in HTMLOutpu.xsl -->
                                        <xsl:for-each select="$isFeaturesPage">
                                                <xsl:choose>
                                                        <xsl:when test="position(  ) mod 2 = 0">
                                                                <div class="even">
                                                                        <xsl:call-template name="USER_FEATURES_ENTRY"/>
                                                                </div>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <div class="odd">
                                                                        <xsl:call-template name="USER_FEATURES_ENTRY"/>
                                                                </div>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:for-each>
                                        <!-- END features content table -->
                                </td>
                        </tr>
                </table>
                <xsl:if test="$featuresPageCount > $articlelimitentries">
                        <div class="morecommments" style="margin-top:12px">
                                <strong>
                                        <a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=1&amp;s_isfeature=yes" xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles"> more magazine
                                                features </a>
                                </strong>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/>
                        </div>
                </xsl:if>
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td height="12"/>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     #####################################################################################
			DEFINES INFO FOR EACH FEATURE THAT WILL BE LISTED IN THE MAGAZINE SECTION
     ##################################################################################### 
-->
        <xsl:template name="USER_FEATURES_ENTRY">
                <table border="0" cellpadding="0" cellspacing="0" width="371">
                        <tr>
                                <td class="filmsImg" valign="top" width="51">
                                        <xsl:variable name="article_small_gif">
                                                <xsl:choose>
                                                        <xsl:when test="$showfakegifs = 'yes'">A3923219_small.jpg</xsl:when>
                                                        <xsl:otherwise>A<xsl:value-of select="H2G2-ID"/>_small.jpg</xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:variable>
                                        <img alt="" height="30" src="{$imagesource}magazine/{$article_small_gif}" width="31"/>
                                </td>
                                <td class="filmsTxt" valign="top" width="320">
                                        <div class="itemTitle">
                                                <strong>
                                                        <xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"/>
                                                </strong>
                                        </div>
                                        <div class="itemText">
                                                <!-- magazine category -->
                                                <xsl:if test="EXTRAINFO/CATEGORYNAME/text()">
                                                        <a class="textdark" href="{$root}C{EXTRAINFO/CATEGORYNUMBER/text()}">
                                                                <xsl:copy-of select="EXTRAINFO/CATEGORYNAME/text()"/>
                                                        </a> | </xsl:if>
                                                <!-- published by date -->
                                                <xsl:value-of select="DATE-CREATED/DATE/@DAY"/>&nbsp;<xsl:value-of select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"/>&nbsp;<xsl:value-of
                                                        select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)"/><br/>
                                                <!-- description -->
                                                <xsl:value-of select="EXTRAINFO/DESCRIPTION"/>
                                                <!-- DEBUGGING -->
                                                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                                                        <div class="debug"> Article ID: A<xsl:value-of select="H2G2-ID"/>
                                                                <BR/> Article type: <xsl:value-of select="EXTRAINFO/TYPE/@ID"/>
                                                                <BR/> Site ID: <xsl:value-of select="SITEID"/>
                                                                <BR/> Status: <xsl:value-of select="STATUS"/>
                                                                <BR/>
                                                        </div>
                                                </xsl:if>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
</xsl:stylesheet>
