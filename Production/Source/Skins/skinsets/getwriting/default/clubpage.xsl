<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-clubpage.xsl"/>
	
    <xsl:template name="CLUB_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="pagename">clubpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated'">
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
	
		<div class="PageContent">
		<xsl:apply-templates select="/H2G2/CLUB/JOURNAL" mode="c_club"/>
		</div>
		
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">GROUP TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.group.tips" />
		</div>
		</xsl:element>
			
		</xsl:element>
		</tr>
		</xsl:element>
	<!-- end of table -->	
		
		</xsl:if>
	
	
		<xsl:apply-templates select="ERROR" mode="c_message"/>
		<xsl:apply-templates select="CLUB" mode="c_display"/>
		<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_club"/>
		
		<xsl:apply-templates select="CLUBACTIONLIST" mode="c_editmembership"/>
		
		<xsl:apply-templates select="CLUB" mode="c_article"/>
		<br />
		<br />
		<xsl:apply-templates select="/H2G2/CLUB/ARTICLE/ARTICLEINFO/MODERATIONSTATUS" mode="c_clubpage">
		<xsl:with-param name="ID" select="CLUB/CLUBINFO/@ID"/>
		</xsl:apply-templates>

	</xsl:template>
	

	<xsl:template match="ERROR" mode="loggedout_message">
			You need to be a member to create a club, please <a href="{$sso_noclubregisterlink}">register</a> or <a href="{$sso_noclubsigninlink}">sign in</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="r_article">
		<!--xsl:apply-templates select="/H2G2/CLUB/ARTICLE/ARTICLEINFO" mode="c_editclubarticlebutton"/-->
		<xsl:apply-templates select="/H2G2/CLUB/ARTICLE/GUIDE/BODY"/>
	</xsl:template>
	
	<!--xsl:template match="ARTICLEINFO" mode="r_editclubarticlebutton">
		<xsl:apply-imports/>
	</xsl:template-->
	
	<xsl:template match="CLUB" mode="r_display">
	<!-- <xsl:apply-templates select="/H2G2/CLIP" mode="c_clubclipped"/> -->
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<div class="PageContent">
	<xsl:apply-templates select="/H2G2/CLUB/ARTICLE" mode="c_club"/>
	<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO" mode="c_joinclub"/>
	<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO" mode="c_becomeowner"/>
	<br/>
	<xsl:apply-templates select="/H2G2/CLUB/JOURNAL" mode="c_club"/>
	<xsl:apply-templates select="/H2G2/CLUB/POPULATION" mode="c_club"/>
	</div>
	
	<div class="PageFooter">
	<img src="{$imagesource}frontpages/t_alsoongetwriting.gif" height="45" width="392" alt="also on get writing" border="0"/>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO1" />
	</td>
	<td>
	<xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO2" />
	</td>
	</tr>
	</table>
	</div>

	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	<div class="NavPromoOuter">
	<div class="NavPromo2">	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="myinfo"><strong>QUICK GROUP INFO</strong></div>
		</xsl:element>
		
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO" mode="c_info"/>
		</xsl:element>
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="/H2G2/CLUB" mode="c_editclub"/>
		<div class="arrow2"><a href="#memberlist">view member list</a></div>
		<xsl:if test="$test_IsEditor or /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
		<div class="arrow2"><a href="#discussion">start group discussion</a></div>
		</xsl:if>
		<xsl:apply-templates select="/H2G2/CLUB/POPULATION" mode="c_editmembershiplink"/>
		</xsl:element>
		</div>
	    </div>

		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">GROUP TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.group.tips" />
		</div>
		</xsl:element>
		
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
	</xsl:template>
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the club
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_clubpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_clubclipped">
	Description: message to be displayed after clipping a club
	 -->
	<xsl:template match="CLIP" mode="r_clubclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<xsl:template match="POPULATION" mode="c_editmembershiplink">
	
	<xsl:choose>
	<xsl:when test="$test_IsEditor or /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
	<div class="arrow2"><xsl:apply-imports/></div>
	</xsl:when>
	<xsl:when test="/H2G2/CLUB/POPULATION/TEAM[@TYPE='MEMBER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
		<div class="arrow2">
		<a href="{$root}G{../CLUBINFO/@ID}?s_view=editmembership">
			<xsl:copy-of select="$m_editmembership"/>
		</a>
		</div>
	</xsl:when>
	</xsl:choose>

	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="r_linktoarticle">
	Use: Presentation of the object holding the 'read this article' link
	 -->
	<xsl:template match="H2G2ID" mode="r_linktoarticle">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBINFO" mode="r_joinclub">
	Use: Presentation of the 'join this club' link
	 -->
	<xsl:template match="CLUBINFO" mode="r_joinclub">

		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUBACTIONLIST/CLUBACTION[@ACTIONTYPE='joinmember' and @RESULT='stored']/ACTIONUSER/USER/USERID">
		You have applied to Join this Group and are awaiting approval
		</xsl:when>
		<xsl:otherwise>
		<span class="arrow1"><xsl:apply-imports/></span>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
		</div>
		
	</xsl:template>
	
	<xsl:template match="CLUBINFO" mode="r_becomeowner">
	
		<div class="boxactionback">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUBACTIONLIST/CLUBACTION[@ACTIONTYPE='joinowner' and @RESULT='stored']/ACTIONUSER/USER/USERID">
		You have applied to be an owner of this Group and are awaiting approval
		</xsl:when>
		<xsl:otherwise>
		<div class="arrow1"><xsl:apply-imports/></div>
		</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
		</div>
		
	</xsl:template>
	
	<xsl:template match="CLUB" mode="r_clip">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="edit_tag">
	Use: Presentation for the link to edit the taxonomy details of a club
	 -->
	<xsl:template match="CLUB" mode="edit_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="add_tag">
	Use: Presentation for the link to add a club to the taxonomy
	 -->
	<xsl:template match="CLUB" mode="add_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="r_editclub">
	Use: Presentation of the link to edit a club
	 -->
	<xsl:template match="CLUB" mode="r_editclub">
	<div class="arrow2"><xsl:apply-imports/></div>
	</xsl:template>
	
	
	<xsl:template match="CLUBACTIONRESULT">
	<xsl:choose>
	<xsl:when test="@ACTIONTYPE='joinmember' and @RESULT='complete'">
	<strong>welcome to our group you have applied for membership</strong>
	</xsl:when>
	<xsl:when test="@ACTIONTYPE='joinowner' and @RESULT='stored'">
	<strong>you have applied for ownership</strong>
	</xsl:when>
	<xsl:when test="@ACTIONTYPE='joinowner' and @RESULT='complete'">
	<strong>you have applied for ownership</strong>
	</xsl:when>
	<xsl:when test="@ACTIONTYPE='joinmember' and @RESULT='stored'">
	<strong>you have applied for membership</strong>
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
	
<!-- 	<div><b>Action performed:</b> [<xsl:value-of select="@ACTIONTYPE"/>]</div>
	<div><b>Action result:</b> [<xsl:value-of select="@RESULT"/>]</div>
	<div><b>Action ID:</b> [<xsl:value-of select="@ACTIONID"/>]</div>
	<div><b>Club ID:</b> [<xsl:value-of select="@CLUBID"/>]</div>
	<xsl:if test="@ERROR"><div><b>Error:</b> [<xsl:value-of select="@ERROR"/>]</div></xsl:if>
	<xsl:apply-templates select="DATEREQUESTED" mode="test"/>
	<xsl:apply-templates select="DATECOMPLETED" mode="test"/>
	<xsl:apply-templates select="ACTIONUSER" mode="test"/>
	<xsl:apply-templates select="COMPLETEUSER" mode="test"/> -->
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLE" mode="r_club">
	Use: Presentation of the object holding the initiative Article
	 -->
	<xsl:template match="ARTICLE" mode="r_club">
		<div class="heading1">
		<xsl:if test="/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON !='default'">
			<img src="{$graphics}icons/groups/icon_{/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON}.gif" alt="Group icon" border="0" class="imageborder" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO/NAME" />
		</xsl:element>
		</div>
	
		<div class="box">
		<div class="ContentBlock">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<span class="heading1">Owner(s):</span>
		<xsl:apply-templates select="/H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER" mode="c_organiserlist" />
		</xsl:element>
		</div>
		<hr class="line" />
		
		<div class="ContentBlock">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<span class="heading1">Our Group: </span>
	    </xsl:element>
		<xsl:apply-templates select="GUIDE/BODY"/>
		</div>
		<hr class="line" />
				
		<div class="ContentBlock">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<span class="heading1">Critiquing Method:</span> 
		<xsl:apply-templates select="GUIDE/REASON"/>
		</xsl:element>
		</div>
		<hr class="line" />
			
		<div class="ContentBlock">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<span class="heading1">Schedule:</span>
		<xsl:apply-templates select="GUIDE/SCHEDULE"/>
		</xsl:element>
		</div>
		<br/>
				
<!-- 	<div class="ContentBlock">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<span class="heading1">Group Status:</span> 
		<xsl:value-of select="/H2G2/CLUB/CLUBINFO/@STATUS"/> 
		</xsl:element>
		</div> -->
		</div>
		
		<!-- <xsl:apply-templates select="EXTRAINFO" mode="club"/> -->
		<!-- has no '_' prefix on the mode as it is skin specific and all information is contained in this stylesheet -->
	</xsl:template>
	
	<xsl:template match="USER" mode="c_organiserlist">
		<a href="{$root}U{USERID}" class="genericlink"><strong><xsl:value-of select="USERNAME"/></strong></a>
		<xsl:if test="not(position()=last())"><xsl:text>,  </xsl:text></xsl:if>
	</xsl:template>
	
	<!--
	<xsl:template match="EXTRAINFO" mode="club">
	Use: Applies templates to skin - specific Objects for the club
	 -->
	<xsl:template match="EXTRAINFO" mode="club">
		<xsl:apply-templates select="DESCRIPTION" mode="club"/>
		<xsl:apply-templates select="LOCATION" mode="club"/>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="club">
	Use: Presentation of iCan specific object
	 -->
	<xsl:template match="DESCRIPTION" mode="club">
		<xsl:text>Description:</xsl:text>
		<xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="LOCATION" mode="club">
	Use: Presentation of iCan specific object
	 -->
	<xsl:template match="LOCATION" mode="club">
		<xsl:text>Location:</xsl:text>
		<xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							JOURNAL Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:variable name="maxclubjournals" select="5"/>
	Use: Maximum number of Journals to display on a club
	 -->
	<xsl:variable name="maxclubjournals">1</xsl:variable>
	<!--
	<xsl:template match="JOURNAL" mode="r_club">
	Use: Presentation of the object holding the initiative journal
	 -->
	<xsl:template match="JOURNAL" mode="r_club">
	<a name="discussion" id="discussion"></a>
	<div class="titleBars" id="titleGroup1"><xsl:element name="{$text.small}" use-attribute-sets="text.small"><xsl:copy-of select="$m_clubjournaltitle"/></xsl:element></div>
	
	<!-- <xsl:apply-templates select="." mode="t_clubjournalmessage"/> -->
	<xsl:choose>
	<xsl:when test="JOURNALPOSTS/POST">
	<xsl:apply-templates select="JOURNALPOSTS/POST" mode="c_clubjournalentries"/>
	</xsl:when>
	<xsl:otherwise>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<div class="boxback">no journal entry yet</div>
	</xsl:element>
	</xsl:otherwise>
	</xsl:choose>
		
	<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated')">	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="JOURNALPOSTS" mode="c_moreclubjournals"/>
	<xsl:if test="$test_IsEditor or /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
	<xsl:apply-templates select="JOURNALPOSTS" mode="c_addclubjournalentry"/>
	</xsl:if>
	</xsl:element>
	</xsl:if>
	<br/>
	
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreclubjournals">
	Use: Presentation of the 'click here to see more Journal entries' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_moreclubjournals">
		<div class="boxactionback"><span class="arrow1"><xsl:apply-imports/></span></div>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_addclubjournalentry">
	Use: Presentation of the 'add a journal entry' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_addclubjournalentry">
		<div class="boxactionback"><span class="arrow1"><xsl:apply-imports/></span></div>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_clubjournalentries">
	Use: Presentation of a single Journal post
	 -->
	<xsl:template match="POST" mode="r_clubjournalentries">
	<div class="boxback">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<div class="heading1"><xsl:value-of select="SUBJECT"/></div>
	<br/>
	
	<span class="heading1">Posted:</span> 
	<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_dateclubjournalposted"/> 
	by <a href="U{USER/USERID}" class="genericlink"><xsl:value-of select="USER/USERNAME"/></a>
	</xsl:element><br/><br/>
			
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="TEXT" mode="t_clubjournaltext"/>
	</xsl:element><br/>
	</div>
		
	<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated')">
	<div class="boxactionback">
	<table width="380" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<span class="arrow4"><a xsl:use-attribute-sets="maTHREADID_t_clubjournallastreply" href="{$root}F{../@FORUMID}?thread={@THREADID}&amp;latest=1">read more</a></span>
		 and 
		<xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="t_discussclubjournalentry"/> 
		<xsl:text>  </xsl:text>
		(<xsl:apply-templates select="LASTREPLY" mode="c_clubjournalreplies"/>)
		<br/>
		</xsl:element>
	</td>
	<td>
	<xsl:apply-templates select="." mode="c_complainclubjournal"/>
	</td>
	</tr>
	</table>
	</div>
	</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_complainclubjournal">
	Use: Presentation of 'complain about this Journal entry link
	 -->
	<xsl:template match="POST" mode="r_complainclubjournal">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="r_clubjournalreplies">
	Use: Called if there are replies to a journal entry
	 -->
	<xsl:template match="LASTREPLY" mode="r_clubjournalreplies">
		(<xsl:apply-templates select="../@THREADID" mode="t_clubjournalentriesreplies"/>)
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Use: Display of the 'remove journal entry' link 
	 -->
	<xsl:template match="@THREADID" mode="r_removeclubjournalpost">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POPULATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="POPULATION" mode="r_club">
	Use: Presentation of the object holding all the teams
	 -->
	<xsl:template match="POPULATION" mode="r_club">
	<a name="memberlist"></a>
	<div class="titleBars" id="titleGroup2"><xsl:element name="{$text.small}" use-attribute-sets="text.small">OUR GROUP MEMBERS</xsl:element></div>
	
	<div class="box">
	<table width="390" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td class="boxheading">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">MEMBER NAME</xsl:element>
	</td>
	<td class="boxheading">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">ROLE</xsl:element>
	</td>
	</tr>
	<xsl:apply-templates select="TEAM" mode="c_club"/>
	</table>
	</div>
	<xsl:apply-templates select="TEAM" mode="c_more"/>
	</xsl:template>
	
	<xsl:template match="POPULATION" mode="r_editmembershiplink">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
		<xsl:variable name="max_teammembers">
		Use: Sets the maximum number for the team list
	 -->
	<xsl:variable name="max_teammembers">100</xsl:variable>
	<!--
		<xsl:template match="TEAM" mode="owner_club">
		Use: Presentation of the 'owners of the club' object
	 -->
	<xsl:template match="TEAM" mode="owner_club">
<!-- 		<xsl:variable name="sortedowners">
			<xsl:for-each select="MEMBER">
				<xsl:sort select="DATEJOINED/DATE/@SORT"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable> -->

		<xsl:apply-templates select="MEMBER[USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID]" mode="c_clubowners"/>

		
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="member_club">
	Use: Presentation of the 'members of the club' object
	 -->
	<xsl:template match="TEAM" mode="member_club">

<!-- 		<xsl:variable name="sortedmembers">
			<xsl:for-each select="MEMBER[not(USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)]">
				<xsl:sort select="DATEJOINED/DATE/@SORT"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable> -->

	<xsl:variable name="memberstodisplay" select="100"/>

	<xsl:apply-templates select="MEMBER[not(USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)][position() &lt;= $memberstodisplay]" mode="c_clubmembers"/>

	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_clubowners">
	Use: Presentation of a single club owner
	 -->
	<xsl:template match="MEMBER" mode="r_clubowners">
	<tr>
	<xsl:attribute name="class">
	<xsl:choose>
	<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = USER/USERID">colourbar3</xsl:when>
	<xsl:when test="count(preceding-sibling::MEMBER) mod 2 = 0">colourbar2</xsl:when>
	<xsl:otherwise>colourbar1</xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-imports/><img src="{$graphics}icons/icon_owner.gif"  border="0" align="middle" />
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Owner
	</xsl:element>
	</td>
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembership'">
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="DATEJOINED/DATE" mode="short"/>
	</xsl:element>
	</td>
	</xsl:if>
	</tr>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_clubmembers">
	Use: Presentation of a single clubmember
	 -->
	<xsl:template match="MEMBER" mode="r_clubmembers">
	<tr>
	<xsl:attribute name="class">
	<xsl:choose>
	<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = USER/USERID">colourbar3</xsl:when>
	<xsl:when test="count(preceding-sibling::MEMBER[not(USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)]) mod 2 = 0">colourbar1</xsl:when>
	<xsl:otherwise>colourbar2</xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-imports/>
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Member
	</xsl:element>
	</td>
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembership'">
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="DATEJOINED/DATE" mode="short"/>
	</xsl:element>
	</td>
	</xsl:if>
	</tr>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="r_more">
	Use: Presentation of the 'more team members' link
	 -->
	<xsl:template match="TEAM" mode="r_more">
	<div class="boxactionback">
	<div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-imports/>
	</xsl:element>
	</div>
	</div>
	</xsl:template>
	<!--xsl:apply-templates select="." mode="c_promotetoowner"/>
	<xsl:call-template name="insert-inviteasownerlink"/-->
	<!--
	 <xsl:template match="POPULATION" mode="r_editpermissions">
	Use: Presentation of the 'edit permissions' link
	 -->
	<!--xsl:template match="POPULATION" mode="r_editpermissions">
	 	<xsl:apply-imports/>
	 </xsl:template-->
	<!--
	<xsl:template match="POPULATION" mode="r_managerequests">
	Use: Presentation of the 'manage requests' link
	 -->
	<!--xsl:template match="POPULATION" mode="r_managerequests">
	 	<xsl:apply-imports/>
	 </xsl:template-->
	<!--
	<xsl:template match="USER" mode="r_promotetoowner">
	Use: Presentation of the 'promote to owner' link
	 -->
	<!--xsl:template match="USER" mode="r_promotetoowner">
	 	<xsl:apply-imports/>
	 </xsl:template-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Edit Team Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="c_editmembership">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Chooses which container to call, either a full list of members and recent actions or an inidividual user
	-->
	<xsl:template match="CLUBACTIONLIST" mode="c_editmembership">
	
	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembers'">
		<xsl:apply-templates select="." mode="list_editmembership"/>
		</xsl:when>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembership'">
			<xsl:apply-templates select="." mode="user_editmembership"/>
		</xsl:when>
	</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="list_editmembership">
	Use: Contains a list of outstanding club actions, those completed and a list of all team members
	 -->
	<xsl:template match="CLUBACTIONLIST" mode="list_editmembership">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">CLUBACTIONLIST mode=list_editmembership</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<div class="PageContent">	
		<div class="heading1">
		<xsl:if test="/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON !='default'">
		<img src="{$graphics}icons/groups/icon_{/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON}.gif" alt="Group icon" border="0" class="imageborder" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:text>  </xsl:text>
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO/NAME" />
		</xsl:element>
		</div>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="credit2">Admin page for Owners</div>
		</xsl:element>
		<br/>
		
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}">go to this groups space</a></div>
		</xsl:element>
		</div>
		
		</div>
		
		<div class="PageContent">	
		<img src="{$graphics}titles/groups/t_editmembers.gif" alt="Edit Members" width="182" height="33" border="0" vspace="5"/>

		<a name="editmembers" id="editmembers"></a>
		<div class="titleBarNav" id="titleOwnerAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<span class="titlenavarrow"><a href="#pending">pending approval|</a></span><span class="titlenavarrow"><a href="#completed">recent activity</a></span>
		</xsl:element>
		</div>
		
		<xsl:apply-templates select="/H2G2/CLUB/POPULATION/TEAM" mode="c_editmemberslist"/>
		</div>
		<br/>
		
		<div class="PageContent">
		<img src="{$graphics}titles/groups/t_memberspending.gif" alt="Members Pending Approval" width="235" height="36" border="0" />

		<a name="pending" id="pending"></a>
		<div class="titleBarNav" id="titleOwnerAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<span class="titlenavarrow"><a href="#editmembers">edit members|</a></span>
		<span class="titlenavarrow"><a href="#completed">recent activity</a></span>
		</xsl:element>
		</div>
		
		<xsl:apply-templates select="." mode="c_pending"/>
		</div>
		
		<div class="PageContent">
		<img src="{$graphics}titles/groups/t_recentactivity.gif" alt="Recent Activity" width="182" height="33" border="0" />
		<a name="completed" id="completed"></a>
		<div class="titleBarNav" id="titleOwnerAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<span class="titlenavarrow"><a href="#editmembers">edit members|</a></span>
		<span class="titlenavarrow"><a href="#pending">pending approval</a></span>
		</xsl:element>
		</div>
		<xsl:apply-templates select="." mode="c_completed"/>
		</div>
					
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
	<div class="NavPromoOuter">
	<div class="NavPromo2">	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>MEMBERSHIP BULLETIN</strong><br/>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check on waiting lists</a></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity#descisions">check on membership decisions</a></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity#offers">check for offers</a></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=listgroup">all my groups</a></div>
		</xsl:element>
		</div>
	</div>
		
		<div class="rightnavboxheadergroup">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		ALL MY GROUPS LIST
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:apply-templates select="/H2G2/CLUB/USERMYCLUBS/CLUBSSUMMARY/CLUB[SITEID='15' and position() &lt;=$clublimitentries]" mode="c_umc"/>

     <xsl:if test="/H2G2/CLUB/USERMYCLUBS/CLUBSSUMMARY/CLUB[SITEID='15' and position() &gt;=$clublimitentries]">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=listgroup">view all my groups</a></div></xsl:element>
	</xsl:if>
		</div>
				
    	</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	

	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="r_pending">
	Use: Presentation of the outstanding club actions logical container
	 -->
	<xsl:template match="CLUBACTIONLIST" mode="r_pending">
	<br/>
	
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="3">
			<tr>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				MEMBERS'S NAME
				</xsl:element>
				</td>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				REQUEST
				</xsl:element>
				</td>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				APPLIED
				</xsl:element>
				</td>
				<td valign="top" class="boxheading"></td>
			</tr>
			<xsl:apply-templates select="CLUBACTION" mode="c_pending"/>
		</table>
		</div>
	
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="join_pending">
	Use: An outstanding request to join a club, contains the name of the person making the request, 
	a description of the request, the club to which the request is made, the date made and the option 
	of accepting or rejecting it.
	 -->
	<xsl:template match="CLUBACTION" mode="join_pending">
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::CLUBACTION) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="ACTIONUSER" mode="t_nameofrequestor"/>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_requesttypetext"/>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="DATEREQUESTED" mode="t_request"/>
		</xsl:element>
		</td>
		<td valign="top">	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">			
		<xsl:apply-templates select="." mode="t_accept"/>
		<xsl:text>  </xsl:text>
		<xsl:apply-templates select="." mode="t_reject"/>
		</xsl:element>
		</td>
	</tr>
	</xsl:template>
	
	<!--
	<xsl:template match="CLUBACTION" mode="t_accept">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUBACTIONLIST
	Purpose:	 Displays an 'accept' link to accept a pending request
	-->
	<xsl:template match="CLUBACTION" mode="t_accept">
		<a href="{$root}G{@CLUBID}?action=process&amp;actionid={@ACTIONID}&amp;result=1&amp;s_view=editmembers" xsl:use-attribute-sets="mCLUBACTION_t_accept">
			<xsl:copy-of select="$button.approve"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="t_reject">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST
	Purpose:	Displays a 'reject' link to reject a pending request
	-->
	<xsl:template match="CLUBACTION" mode="t_reject">
		<a href="{$root}G{@CLUBID}?action=process&amp;actionid={@ACTIONID}&amp;result=2&amp;s_view=editmembers" xsl:use-attribute-sets="mCLUBACTION_t_reject">
			<xsl:copy-of select="$button.decline"/>
		</a>
	</xsl:template>
	
	
	
	<!--
	<xsl:template match="CLUBACTION" mode="invite_pending">
	Use: An unanswered invitation to a club
	 -->
	<xsl:template match="CLUBACTION" mode="invite_pending">
	<tr>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="COMPLETEUSER" mode="t_invitinguser"/>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">			
		<xsl:apply-templates select="ACTIONUSER" mode="t_inviteduser"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_invitetext"/>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="CLUBNAME" mode="t_request"/>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="DATEREQUESTED" mode="t_request"/>
		</xsl:element>
		</td>
		<td valign="top"></td>
	</tr>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="r_completed">
	Use: Presentation of the completed club actions logical container
	 -->
	<xsl:template match="CLUBACTIONLIST" mode="r_completed">
<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				MEMBER'S NAME
				</xsl:element>
				</td>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				ACTION
				</xsl:element>
				</td>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				ACTION BY
				</xsl:element>
				</td>
				<td valign="top" class="boxheading">
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				DATE
				</xsl:element>
				</td>
			</tr>
			<xsl:apply-templates select="CLUBACTION" mode="r_completed"/>
		</table>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_completed">
	Use: A completed club action. Contains the named of the person who made the request, the type of
	request made, the outcome, who decided the outcome and the date.
	 -->
	<xsl:template match="CLUBACTION" mode="r_completed">
		<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::CLUBACTION) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="ACTIONUSER" mode="t_nameofrequested"/>
			</xsl:element>
			</td>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="@ACTIONTYPE" mode="t_requestmade"/><br/>
			
<!-- 			<xsl:choose>
			<xsl:when test="@RESULT='complete'">
			approved
			</xsl:when>
			<xsl:otherwise>
			pending
			</xsl:otherwise>
			</xsl:choose> -->

			</xsl:element>
			</td>
<!-- 		<td valign="top">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates select="DATEREQUESTED" mode="t_clubaction"/>
			</xsl:element>
			</td> -->
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="COMPLETEUSER" mode="c_authoriser"/>
			</xsl:element>
			</td>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<!-- <xsl:apply-templates select="DATEREQUESTED"  mode="short1"/><br/> -->
			<xsl:apply-templates select="DATECOMPLETED"  mode="short"/>
			</xsl:element>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="COMPLETEUSER" mode="r_authoriser">
	Use: Presentation of the person who decided on the outcome of a completed action
	 -->
	<xsl:template match="COMPLETEUSER" mode="r_authoriser">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="r_editmemberslist">
	Use: Logical container for the list of all team members
	 -->
	<xsl:template match="TEAM" mode="r_editmemberslist">
	<br/>
	<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="2">
			<tr>
			<td valign="top" class="boxheading">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
			MEMBER'S NAME
			</xsl:element>
			</td>
			<td width="110" valign="top" class="boxheading">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		     MEMBER SINCE
			</xsl:element>
			</td>
			<td valign="top" class="boxheading">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
			CHANGE STATUS
			</xsl:element>
			</td>
			</tr>
			<!-- have to do this so owners appear first -->
			<xsl:apply-templates select="MEMBER[USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID]" mode="c_memberdetails"/>
<xsl:apply-templates select="MEMBER[not(USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)]" mode="c_memberdetails"/>
		</table>
		</div>
		
		<br/>
		
<!-- 		
INVITE A USER - may use this later SZ
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<form action="Club{/H2G2/CLUB/CLUBINFO/@ID}" METHOD="GET">
			Invite a member: <input type="checkbox" name="action" value="invitemember"/>
			Userid: <input type="text" name="userid"/>
			<input type="submit" name="doit" value="change"/>
			</form>
		</xsl:element> -->
		

	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="r_memberdetails">
	Use: Presentation of information relating to a single member within a team list
	 -->
	<xsl:template match="MEMBER" mode="r_memberdetails">
		<tr>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::MEMBER) mod 2 = 0">colourbar2</xsl:when>
			<xsl:otherwise>colourbar1</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="USER" mode="t_membershipname"/><br/>
			<div class="credit"><xsl:apply-templates select="USER" mode="t_ownerormember"/></div>
			</xsl:element>
			</td>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="DATEJOINED/DATE" mode="short1" />
			</xsl:element>
			</td>
			<td valign="top">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_changetypeform"/>
			</xsl:element>
			</td>
		</tr>
		<!-- <xsl:value-of select="ROLE"/> -->
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_editmember">
	Use: Creates the edit link next to edit the membership details of an individual team member
	 -->
	<xsl:template match="USER" mode="r_editmember">
		(<xsl:apply-imports/>)
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Edit a member is a team object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="user_editmembership">
	Use: Contains the members name, a form to adjust his status / type, his / her existing type / role and the 
	option to return to the club without doing anything.
	 -->
	<xsl:template match="CLUBACTIONLIST" mode="user_editmembership">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">CLUBACTIONLIST mode=user_editmembership</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		<xsl:variable name="status">
		<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
		an owner
		</xsl:when>
		<xsl:otherwise>
		a member
		</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
				
		
		
		<div class="PageContent">
		<div class="heading1">
		<xsl:if test="/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON !='default'">
		<img src="{$graphics}icons/groups/icon_{/H2G2/CLUB/ARTICLE/GUIDE/GROUPICON}.gif" alt="Group icon" border="0" class="imageborder" /><xsl:text>  </xsl:text>
		</xsl:if>
		<xsl:text>  </xsl:text>
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO/NAME" />
		</xsl:element>
		</div>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="credit2">Admin page for Members</div>
		</xsl:element>
		<br/>
		
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}">go to this groups space</a></div>
		</xsl:element>
		</div>
		</div>
		
		<div class="PageContent">
		<img src="{$graphics}titles/groups/t_leavegroup.gif" alt="Leave Group" width="182" height="33" border="0" vspace="5"/>
		<div class="titleBarNav" id="titleMemberAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#">&nbsp;membership info&nbsp;&nbsp;|</a><a href="#">&nbsp;recent activity</a>
		</xsl:element>
		</div>
		<br/>
		<div class="box2">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:value-of select="$m_statustitle"/>: I am <xsl:value-of select="$status" /> of this group.</strong></xsl:element><br/><br/>
		
		<form action="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}" xsl:use-attribute-set="fMEMBERSHIPSTATUS_c_changestatus">

			<table>
			<tr>
				<td>
				<input type="hidden" name="userid" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
				<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:choose>
				<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<input type="radio" name="action" value="ownerresignsmember" /> become a member<br/>
				<input type="radio" name="action" value="ownerresignscompletely" />leave club<br/>
				</xsl:when>
				<xsl:otherwise>
				<input type="radio" name="action" value="joinowner" />request to become owner<br/>
				<input type="radio" name="action" value="memberresigns" />leave club<br/>
				</xsl:otherwise>
				</xsl:choose>
				</xsl:element>
				</td>
				<td>
				<input type="image" xsl:use-attribute-sets="iMEMBERSHIPSTATUS_t_changestatussubmit"/>
				</td>
			</tr>
			</table>
		</form>
		
		</div>
		</div>
		
		<div class="PageContent">	
		<img src="{$graphics}titles/groups/t_memberlist.gif" alt="Membership List" width="182" height="33" border="0" vspace="5" />
		<div class="titleBarNav" id="titleMemberAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#">&nbsp;recent activity</a>
		</xsl:element>
		</div>
		<br/>
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">MEMBER NAME</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">ROLE</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">MEMBER SINCE</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="/H2G2/CLUB/POPULATION/TEAM" mode="c_club"/>
		</table>
		</div>
		
		</div>
		
		<div class="PageContent">	
		<img src="{$graphics}titles/groups/t_recentactivity.gif" alt="Recent Activity" width="182" height="33" border="0" vspace="5" />
		<div class="titleBarNav" id="titleMemberAdmin">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#">&nbsp;membership info&nbsp;&nbsp;|</a><a href="#">&nbsp;recent activity</a>
		</xsl:element>
		</div>
		<br/>
		<xsl:apply-templates select="." mode="c_completed"/>
		</div>
				
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		<div class="NavPromoOuter">
		<div class="NavPromo2">	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="myinfo"><strong>MEMBERSHIP BULLETIN</strong></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check on waiting lists</a></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity#descisions">check on membership decisions</a></div>
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity#offers">check for offers</a></div>
		<!-- <div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">all my groups</a></div> -->
		</xsl:element>
		</div>
		</div>
		
		<div class="rightnavboxheadergroup">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		ALL MY GROUPS LIST
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:apply-templates select="/H2G2/CLUB/USERMYCLUBS/CLUBSSUMMARY/CLUB[SITEID='15' and position() &lt;=$clublimitentries]" mode="c_umc"/>
	<xsl:if test="/H2G2/CLUB/USERMYCLUBS/CLUBSSUMMARY/CLUB[SITEID='15' and position() &gt;=$clublimitentries]">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=listgroup">view all my groups</a></div></xsl:element>
	</xsl:if>
		</div>
	
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->		
	</xsl:template> 
	
	<xsl:attribute-set name="iMEMBERSHIPSTATUS_t_changestatussubmit" use-attribute-sets="form.change"/>
	
	<!--
	<xsl:template match="TEAM" mode="r_changetypeform">
	Use: Contains the form for changing a user's type and a submit button
	 -->
	<xsl:template match="TEAM" mode="c_memberinfo">
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:value-of select="MEMBER/USER/USERNAME" />
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:value-of select="MEMBER/ROLE" />
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="MEMBER/DATEJOINED/DATE" mode="short" />
	</xsl:element>
	</td>
	</tr>
	</xsl:template>
	
	<!--
	<xsl:template match="MEMBER" mode="r_changetypeform">
	Use: Contains the form for changing a user's type and a submit button
	 -->
	<xsl:template match="MEMBER" mode="r_changetypeform">
		<xsl:apply-templates select="." mode="t_selectactionform"/>
		<xsl:apply-templates select="." mode="t_selectactionsubmit"/>
	</xsl:template>
	
	<!--
	<xsl:template match="MEMBER" mode="t_selectactionform">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Chooses which form is appropriate for the member being acted upon 
	-->
	<xsl:template match="MEMBER" mode="t_selectactionform">
	<input type="hidden" name="s_view" value="editmembers"/>
		<xsl:choose>
			<xsl:when test="USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID and USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
				<input type="hidden" name="userid" value="{USER/USERID}"/>
				<input type="radio" name="action" value="demoteownertomember" /><xsl:copy-of select="$m_demoteownertomember"/><br/>
				
			</xsl:when>
			<xsl:when test="USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<input type="hidden" name="userid" value="{USER/USERID}"/>
				
				<input type="radio" name="action" value="demoteownertomember" /><xsl:copy-of select="$m_demoteownertomember"/><br/>
				<input type="radio" name="action" value="removeowner" /><xsl:copy-of select="$m_removeowner"/><br/>
			</xsl:when>
			<xsl:when test="USER/USERID != /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<input type="hidden" name="userid" value="{USER/USERID}"/>
				<input type="radio" name="action" value="inviteowner" /><xsl:copy-of select="$m_promoteowner"/><br/>
				<input type="radio" name="action" value="removemember" /><xsl:copy-of select="$m_removemember"/><br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="MEMBER" mode="r_currenttype">
	Use: Displays the user's current type (owner or member)
	 -->
	<xsl:template match="MEMBER" mode="r_currenttype">
		<b>
			<xsl:copy-of select="$m_membertypetitle"/>
		</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="r_currentrole">
	Use: Displays the user's current role
	 -->
	<xsl:template match="MEMBER" mode="r_currentrole">
		<b>
			<xsl:copy-of select="$m_memberroletitle"/>
		</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--xsl:template match="CLUBACTIONLIST" mode="r_recentrequestslist">
		<xsl:apply-templates select="CLUBACTION" mode="c_recentrequest"/>
	</xsl:template>
	<xsl:template match="CLUBACTION" mode="r_recentrequest">
		<xsl:apply-imports/>
	</xsl:template-->
	<!--
	<xsl:attribute-set name="sMEMBER_t_selectactionform"/>
	Use: Presentation attributes for the <select> HTML element when changing a person's type
	 -->
	<xsl:attribute-set name="sMEMBER_t_selectactionform"/>
	<!--
	<xsl:attribute-set name="oMEMBER_t_selectactionform"/>
	Use: Presentation attributes for the <option> HTML elements when changing a person's type
	 -->
	<xsl:attribute-set name="oMEMBER_t_selectactionform"/>
	<!--
	<xsl:attribute-set name="fMEMBER_c_changetypeform"/>
	Use: Presentation attributes for the <form> HTML element when chaning a person's type
	 -->
	<xsl:attribute-set name="fMEMBER_c_changetypeform"/>
	<!--
	<xsl:attribute-set name="fMEMBER_c_changetypeform"/>
	Use: Presentation attributes for the submit HTML element when chaning a person's type
	 -->
	<xsl:attribute-set name="iMEMBER_t_selectactionsubmit" use-attribute-sets="form.change.small"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CLUBFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CLUBFORUM" mode="r_club">
		<xsl:apply-templates select="FORUMTHREADS" mode="c_club"/>
		<!-- regular FORUMTHREAD -->
		<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_club"/>

	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_clubmembers">
	Use: Presentation of the list of posts.
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_club">
		<h2>
			<xsl:copy-of select="$m_clubcommentstitle"/>
		</h2>
		<xsl:apply-templates select="." mode="t_clubcommentsintro"/>
		<br/>
		<xsl:apply-templates select="POST" mode="c_clubcomment"/>
		<xsl:apply-templates select="." mode="t_addclubcomment"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_clubcomment">
	Use: Presentation of a single comment
	 -->
	<xsl:template match="POST" mode="r_clubcomment">
		<b>
			<xsl:value-of select="SUBJECT"/>
		</b>
		<br/>
		<xsl:value-of select="TEXT"/>
		<br/>
		<xsl:copy-of select="$m_clubcommentby"/>
		<xsl:apply-templates select="USER" mode="t_clubcommentauthor"/> &nbsp;(<xsl:apply-templates select="DATEPOSTED"/>)
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Use: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_club">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Use: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_club">
		<xsl:apply-templates select="THREAD" mode="c_club"/>
	</xsl:template>
	<!--
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_club">
		<xsl:copy-of select="$m_clublastposting"/>:<xsl:apply-templates select="@THREADID" mode="t_clubthreaddatepostedlink"/>
		<br/>
		<xsl:apply-templates select="@THREADID" mode="t_clubthreadtitlelink"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_club">
	Use: Presentation of an individual post. 
	 -->
	<!--xsl:template match="POST" mode="r_club">
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
					
				
						<xsl:apply-templates select="@PREVINDEX" mode="c_clubpost"/>
						
					
						<xsl:apply-templates select="@NEXTINDEX" mode="c_clubpost"/>
			
						<xsl:copy-of select="$m_fsubject"/>
				
						<xsl:value-of select="$m_posted"/>
						<xsl:apply-templates select="USER/USERNAME" mode="c_clubpost"/>
						<xsl:apply-templates select="USER" mode="c_onlineflag"/>
						<xsl:call-template name="insert-postdate"/>
						<xsl:apply-templates select="@INREPLYTO" mode="c_clubpost"/>
					
				</td>
				<td>
					
						<xsl:call-template name="insert-postnumber"/>
						<xsl:apply-templates select="." mode="c_gadgetclubpost"/>
				
					
				</td>
			</tr>
			<tr>
				<td colspan="2">
					
						<xsl:call-template name="insert-postbody"/>
					
				</td>
			</tr>
			<tr>
				<td colspan="2">
					
						<xsl:call-template name="insert-replytopost"/>
						<xsl:apply-templates select="@FIRSTCHILD" mode="c_clubpost"/>
						<xsl:call-template name="insert-postmoderation"/>
						<xsl:apply-templates select="@HIDDEN" mode="c_clubpostcomplain"/>
						<xsl:apply-templates select="@POSTID" mode="c_editclubpost"/>
					
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="@NEXTINDEX" mode="r_clubpost">
		<xsl:apply-imports/>
	</xsl:template-->
	<!--
	<xsl:template match="USERNAME" mode="r_clubpost">
	Use: Presentation if the user name is to be displayed
	 -->
	<!--xsl:template match="USERNAME" mode="r_clubpost">
		<xsl:value-of select="$m_by"/>
		<xsl:apply-imports/>
	
	</xsl:template-->
	<!--
	<xsl:template match="@INREPLYTO" mode="r_clubpost">
	Use: Presentation of the 'this is a reply tothis post' link
	 -->
	<!--xsl:template match="@INREPLYTO" mode="r_clubpost">
		<xsl:value-of select="$m_inreplyto"/>
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="USER" mode="r_onlineflag">
	Use: Presntation of the flag to show if a user is online or not.
	-->
	<!--xsl:template match="USER" mode="r_onlineflag">
		<xsl:copy-of select="$m_useronlineflag"/>
	</xsl:template-->
	<!--
	<xsl:template match="POST" mode="r_gadgetclubpost">
	Use: Presentation if the user name is to be displayed
	 -->
	<!--xsl:template match="POST" mode="r_gadgetclubpost">
		<xsl:apply-imports/>
	</xsl:template-->
	<!--
	<xsl:template match="@FIRSTCHILD" mode="r_clubpost">
	Use: Presentation if the 'first reply to this'
	 -->
	<!--xsl:template match="@FIRSTCHILD" mode="r_clubpost">
		<xsl:value-of select="$m_readthe"/>
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="@POSTID" mode="r_clubpostmod">
	use: Moderation link. Will appear only if editor or moderator.
	-->
	<!--xsl:template match="@POSTID" mode="r_clubpostmod">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="@HIDDEN" mode="r_clubpostcomplain">
	use: alert our moderation team link
	-->
	<!--xsl:template match="@HIDDEN" mode="r_clubpostcomplain">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="@POSTID" mode="r_editclubpost">
	use: editors or moderators can edit a post
	-->
	<!--xsl:template match="@POSTID" mode="r_editclubpost">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="CLUB" mode="open_joinclub">
	use: Presentation of 'Join club' link for open clubs
	-->
	<!--xsl:template match="CLUB" mode="open_joinclub">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="CLUB" mode="closed_joinclub">
	use: Presentation of 'Request to Join club' link for closed clubs
	-->
	<!--xsl:template match="CLUB" mode="closed_joinclub">
		<xsl:apply-imports/>
	</xsl:template-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								MULTI-STAGE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
 	<xsl:variable name="clubfields">
 	Use: Required for extra skin input fields 
 	-->
	<xsl:variable name="clubfields">
	        <![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
						<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></</REQUIRED>
						<ELEMENT NAME='GROUPICON'></ELEMENT>
						<ELEMENT NAME='REASON'></ELEMENT>
						<ELEMENT NAME='SCHEDULE'></ELEMENT>
						<ELEMENT NAME='DESCRIPTION'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="r_club">
 	Use: Presentation of the 'create a club' page
 	-->
	<xsl:template match="MULTI-STAGE" mode="r_club">
	<xsl:apply-templates select="." mode="c_form"/>
		
	</xsl:template>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="loggedout_form">
 	Use: MULTI-STAGE page when the user is not logged in
 	-->
	<xsl:template match="MULTI-STAGE" mode="loggedout_form">
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		Before you create or edit a club, you must <a href="{$sso_noclubregisterlink}">register</a> or <a href="{$sso_noclubsigninlink}">sign in</a>
		</xsl:if>
	</xsl:template>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="r_form">
 	Use: Presentation of the 'create a club' form when the viewer is registered
 	-->
	<xsl:template match="MULTI-STAGE" mode="loggedin_form">
	 
	 <xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->



		<input type="hidden" name="_msxml" value="{$clubfields}"/>
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="_msfinish" value="yes"/>
	

		
		<xsl:apply-templates select="@FINISH" mode="c_message"/>
		
		<!-- ERROR -->
		<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
<!-- <input type="hidden" name="skin" value="purexml"/> -->
		
		<!-- PREVIEW -->
		<xsl:apply-templates select="." mode="c_previewclub"/>
						
		
			<input type="hidden" name="_msstage" value="{@STAGE}"/>
			<!-- start of table -->
			<xsl:element name="table" use-attribute-sets="html.table.container">
			<tr>
			<xsl:element name="td" use-attribute-sets="column.1">
			<div class="PromoMain">
			
			<a name="edit" id="edit"></a>
			<div class="titleBars" id="titleGroup">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="@TYPE='CLUB-EDIT' or @TYPE='CLUB-EDIT-PREVIEW' or @TYPE='CLUB-PREVIEW'">EDIT GROUP</xsl:when>
			<xsl:otherwise>START A NEW GROUP</xsl:otherwise>
			</xsl:choose>
			
			
			</xsl:element>
			</div>
			
			<div class="box6">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
			<span class="requiredtext">* =required field</span>
			</xsl:element>
			</div>
			
					
			<div class="box2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">GROUP IDENTITY <xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="c_error"/></div>
			e.g. Big Blue Non-Fiction Group, etc
			<xsl:apply-templates select="." mode="t_inputtitle"/>
			</xsl:element>	
			</div>
			


			<!-- <input type="hidden" name="skin" value="purexml"/> -->

			
			<!-- <xsl:value-of select="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE" /> -->
			
			<div class="boxsection">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">CHOOSE A GROUP ICON(OPTIONAL) </div>
			<table border="0" cellspacing="0" cellpadding="1">
			<tr>
			<td>
			<img src="{$graphics}icons/groups/icon_group1.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group1'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group1</xsl:attribute>
			</input>
			</td>
			<td>		
			<img src="{$graphics}icons/groups/icon_group2.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group2'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group2</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group3.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group3'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group3</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group4.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group4'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group4</xsl:attribute>
			</input>
			</td>
			<td>		
			<img src="{$graphics}icons/groups/icon_group5.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group5'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group5</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group6.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group6'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group6</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group7.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group7'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group7</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group8.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group8'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group8</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group9.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group9'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group9</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group10.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group10'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group10</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group11.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group11'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group11</xsl:attribute>
			</input>
			</td>
			</tr>
			<tr>
			<td>
			<img src="{$graphics}icons/groups/icon_group12.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group12'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group12</xsl:attribute>
			</input>
			</td>
			<td>		
			<img src="{$graphics}icons/groups/icon_group13.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group13'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group13</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group14.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group14'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group14</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group15.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group15'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group15</xsl:attribute>
			</input>
			</td>
			<td>		
			<img src="{$graphics}icons/groups/icon_group16.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group16'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group16</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group17.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group17'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group17</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group18.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group18'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group18</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group19.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group19'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group19</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group20.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group20'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group20</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group21.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group21'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group21</xsl:attribute>
			</input>
			</td>
			<td>
			<img src="{$graphics}icons/groups/icon_group22.gif" alt="" width="28" height="28" class="imageborder" border="0"/><br/>
			<input type="radio" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='group22'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">group22</xsl:attribute>
			</input>
			</td>
			</tr>
			</table>
			</xsl:element>
			</div>
			
			<input type="hidden" name="GROUPICON">
			<xsl:if test="MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='' or MULTI-ELEMENT[@NAME='GROUPICON']/VALUE-EDITABLE ='default'">
			<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="value">default</xsl:attribute>
			</input>
			
			<div class="boxsection">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">GROUP INTRODUCTION <xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_error"/></div>
			e.g. What do we review? What's our ethos?	
			<xsl:apply-templates select="." mode="t_inputbody"/>
			</xsl:element>
			</div>
			
			<div class="boxsection">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">REVIEWING METHOD</div>
			e.g. General feedback, grid-based scoring, etc.
			<textarea name="REASON" cols="45" rows="5">
			<xsl:value-of select="MULTI-ELEMENT[@NAME='REASON']/VALUE-EDITABLE"/>
			</textarea>
			</xsl:element>
			</div>
			
			<div class="boxsection">
			<table width="350" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="headinggeneric">SCHEDULE </div>
			e.g. How often do we review stuff?
			<textarea name="SCHEDULE" cols="35" rows="5">
			<xsl:value-of select="MULTI-ELEMENT[@NAME='SCHEDULE']/VALUE-EDITABLE"/>
			</textarea>
			</xsl:element>
			</td>
			<td><a href="{$root}aboutgroups#group9"><img src="{$graphics}icons/icon_help.gif" alt="Preview" width="57" height="36" border="0"/></a></td>
			</tr>
			</table>
			</div>
			
<!-- 			<div>TEST DESCRIPTION<br/>
			<textarea name="DESCRIPTION" cols="45" rows="5">
			<xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
			</textarea>
			</div> -->
			<a name="save" id="save"></a>
			<div class="boxsection">
			<xsl:apply-templates select="." mode="c_previewclubbutton"/>
			<xsl:apply-templates select="." mode="c_submitclub"/>
			</div>
					
		
			</div>
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="column.2">
	
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
					
			<div class="rightnavbox">
				<a href="{$root}headtotoe?s_print=1&amp;s_type=pop" target="printpopup" onClick="popwin(this.href, this.target, 575, 600, 'scroll', 'resize'); return false;"><xsl:copy-of select="$button.seeexample" /></a>
			
			<xsl:copy-of select="$form.group.tips" />
			</div>
			</xsl:element>
			
			
			
			</xsl:element>
			</tr>
			</xsl:element>
			<!-- end of table -->	


	
		
	<!-- end removed for site pulldown --></xsl:if>
	</xsl:template>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="r_previewclub">
 	Use: Presentation of previewing the input fields
 	-->
	<xsl:template match="MULTI-STAGE" mode="r_previewclub">
		<div class="PageContent">
		<xsl:apply-templates select="/H2G2/CLUB/ARTICLE" mode="c_club"/>
		</div>
	</xsl:template>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="create_submitclub">
 	Use: Submit button for creating an article
 	-->
	<xsl:template match="MULTI-STAGE" mode="create_submitclub">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
 	<xsl:template match="MULTI-STAGE" mode="edit_submitclub">
 	Use: Submit button for editing an article
 	-->
	<xsl:template match="MULTI-STAGE" mode="edit_submitclub">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
 	<xsl:template match="@FINISH" mode="r_message">
 	Use: Message displayed after a club has been created
 	-->
	<xsl:template match="@FINISH" mode="r_message">
		<xsl:apply-imports/>
	</xsl:template>
		<!--
 	<xsl:template match="MULTI-STAGE" mode="r_previewclub">
 	Use: Submit button for previewing a club
 	-->
	<xsl:template match="MULTI-STAGE" mode="r_previewclubbutton">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_previewclubbutton" use-attribute-sets="form.preview" />
	
	<xsl:attribute-set name="iMULTI-STAGE_create_submitclub" use-attribute-sets="form.save"/>


	<xsl:attribute-set name="iMULTI-STAGE_edit_submitclub" use-attribute-sets="form.save"/>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								MULTI-STAGE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="SEARCHRESULTS" mode="results_club">
		<br/>
		<hr width="60%"/>
		<br/>
		<xsl:copy-of select="$m_catagoriseintroduction"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_catagoriseform"/>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="noresults_club">
		<br/>
		<hr width="60%"/>
		<br/>
		<xsl:copy-of select="$m_nocatagories"/>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="r_catagoriseform">
		<xsl:apply-templates select="HIERARCHYRESULT" mode="c_result"/>
		<xsl:apply-templates select="." mode="t_catagorisesubmit"/>
	</xsl:template>
	<xsl:template match="HIERARCHYRESULT" mode="r_result">
		<xsl:copy-of select="DISPLAYNAME"/>
		<xsl:text> : </xsl:text>
		<xsl:apply-templates select="." mode="t_checkbox"/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									VOTE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="VOTE" mode="vote_club">
	Use: The vote object
	 -->
	<xsl:template match="VOTE" mode="vote_club">
		<h2>
			<xsl:copy-of select="$m_votetitle"/>
		</h2>
		<xsl:apply-templates select="RESPONSE1" mode="c_club"/>
		<xsl:apply-templates select="RESPONSE2" mode="c_club"/>
		<xsl:apply-templates select="." mode="c_selectvote"/>
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE1" mode="r_club">
	Use: Presentation of the results of 'Response 1'
	 -->
	<xsl:template match="RESPONSE1" mode="r_club">
		<xsl:copy-of select="$m_supporting"/>
		<xsl:copy-of select="$m_visiblevote"/>
		<xsl:value-of select="VISIBLE"/>, <xsl:copy-of select="$m_hiddenvote"/>
		<xsl:value-of select="HIDDEN"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE2" mode="r_club">
	Use: Presentaion of the results of 'Response 2'
	 -->
	<xsl:template match="RESPONSE2" mode="r_club">
		<xsl:copy-of select="$m_opposing"/>
		<xsl:copy-of select="$m_visiblevote"/>
		<xsl:value-of select="VISIBLE"/>, <xsl:copy-of select="$m_hiddenvote"/>
		<xsl:value-of select="HIDDEN"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="VOTE" mode="r_selectvote">
	Use: Presentation of the radio buttons used to add a vote
	 -->
	<xsl:template match="VOTE" mode="r_selectvote">
		<xsl:copy-of select="$m_votetext"/>
		<br/>
		<xsl:apply-templates select="RESPONSE1" mode="t_select"/>
		<br/>
		<xsl:apply-templates select="RESPONSE2" mode="t_select"/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									RELATEDMEMBERS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="RELATEDMEMBERS" mode="r_club">
		<xsl:apply-templates select="RELATEDCLUBS" mode="c_club"/>
		<xsl:apply-templates select="RELATEDARTICLES" mode="c_club"/>
	</xsl:template>
	<xsl:template match="RELATEDCLUBS" mode="r_club">
		
			<strong>Related Clubs</strong>
		
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_club"/>
		<br/>
	</xsl:template>
	<xsl:template match="RELATEDARTICLES" mode="r_club">
		
			<strong>Related Articles</strong>
		
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_club"/>
		<br/>
	</xsl:template>
	<xsl:template match="CLUBMEMBER" mode="r_club">
		<xsl:apply-templates select="NAME" mode="t_subjectlink"/>
		<br/>
	</xsl:template>
	<xsl:template match="ARTICLEMEMBER" mode="r_club">
		<xsl:apply-templates select="NAME" mode="t_subjectlink"/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									CLUBINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CLUBINFO" mode="r_info">
		<strong>Started:</strong>&nbsp;<xsl:apply-templates select="/H2G2/CLUB/CLUBINFO/DATECREATED/DATE"/><br/>
		<strong>Members:</strong>&nbsp;<xsl:value-of select="count(/H2G2/CLUB/POPULATION/TEAM[@TYPE='MEMBER']/MEMBER)" />
		
		

		<!-- Last Updated: <xsl:apply-templates select="/H2G2/CLUB/CLUBINFO/LASTUPDATED/DATE"/> -->
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CRUMBTRAILS" mode="r_club">
		<strong>Crumbtrails</strong>
		<br/>
		This club is attached to:
		<br/>
		<xsl:apply-templates select="CRUMBTRAIL" mode="c_club"/>
	</xsl:template>
	<xsl:template match="CRUMBTRAIL" mode="r_club">
		<xsl:apply-templates select="ANCESTOR" mode="c_club"/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="ANCESTOR" mode="r_club">
		<xsl:apply-templates select="NAME" mode="t_club"/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> > </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="iMULTI-STAGE_t_inputtitle">
		<xsl:attribute name="size">40</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tMULTI-STAGE_t_inputbody">
		<xsl:attribute name="rows">20</xsl:attribute>
		<xsl:attribute name="cols">40</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:stylesheet>
