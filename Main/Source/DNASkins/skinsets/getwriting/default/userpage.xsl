<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userpage.xsl"/>

	<!--
	<xsl:variable name="limiteentries" select="10"/>
	Use: sets the number of recent conversations and articles to display
	 -->
	<xsl:variable name="postlimitentries" select="5"/>
	<xsl:variable name="articlelimitentries" select="5"/>
	<xsl:variable name="clublimitentries" select="8"/>
	
	
	<xsl:template name="USERPAGE_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USERPAGE_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">userpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
		
	<xsl:choose>
	<!-- /// LIST ALL MY GROUPS -->
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='listgroup'">
	<table width="600" border="0" cellspacing="0" cellpadding="0">
	<xsl:apply-templates select="/H2G2/USERMYCLUBS/CLUBSSUMMARY/CLUB" mode="r_userpage"/>
	</table>
	</xsl:when>
	
	<!-- /// LIST ALL MY CONTACTS - WATCHED USER -->
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='listcontacts'">
	<div class="PageContent">
	<table  border="0" cellspacing="0" cellpadding="0">
	<xsl:apply-templates select="WATCHED-USER-LIST/USER" mode="c_watcheduser"/>
	</table>
	</div>
	</xsl:when>
	<!-- Groups Membership Bulletin -->
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='myactivity'">
	
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<xsl:apply-templates select="/H2G2/USERCLUBACTIONLIST" mode="c_userpage"/>
				
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		<div class="rightnavboxheadergroup">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		ALL MY GROUPS LIST
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:apply-templates select="/H2G2/USERMYCLUBS/CLUBSSUMMARY/CLUB[SITEID='15']" mode="c_umc"/>
		</div>
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
		
	<!-- /// END ALL MY GROUPS -->	
	</xsl:when>
	<xsl:otherwise>
	<xsl:apply-templates select="/H2G2" mode="c_displayuserpage"/>
	</xsl:otherwise>
	</xsl:choose>


	</xsl:template>

	<xsl:template match="H2G2" mode="r_displayuserpage">
	
	
	<div class="UserContent">
	<!-- MY INTRO -->
	<a name="intro" id="intro"></a>
	<img src="{$graphics}/titles/myspace/t_intro.gif" alt="Intro" width="101" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	    <a href="#portfolio"><xsl:copy-of select="$white.arrow.right" /> portfolio</a> | 
		<a href="#conversations"><xsl:copy-of select="$white.arrow.right" /> conversations</a> | 
		<a href="#messages"><xsl:copy-of select="$white.arrow.right" /> messages &amp; contact</a> | 
		<a href="#group"><xsl:copy-of select="$white.arrow.right" /> group</a> | 
		<a href="#journal"><xsl:copy-of select="$white.arrow.right" /> journal</a>
	</xsl:element>
	</div>
	</div>
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.user.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1.user">
	
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<!-- my intro subject -->
		<div><xsl:value-of select="ARTICLE/SUBJECT"/></div>
		</xsl:element>
				
	<!-- my intro content -->
		<xsl:apply-templates select="PAGE-OWNER" mode="t_userpageintro"/>
		<br/><br/>
		
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:if test="ARTICLE/GUIDE">
		"Unfortunately, the community is now closed, and most people have moved house. Find out more from <a href="{$root}aboutgw">About Get Writing</a>. 
		
				
		<xsl:if test="$ownerisviewer = 1 and /H2G2/ARTICLE/ARTICLEINFO/SITEID='15'">
		If you would like to join another DNA community, you can move your personal space to one of the sites below.
<br/><br/>
<a href="/dna/h2g2">h2g2</a> - The guide to Life, the Universe and Everything. <br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=h2g2&amp;ptrt={$sso_redirectserver}/dna/h2g2/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" vspace="4" height="25" border="0"/></a>
<br/><br/>
		<a href="/dna/collective">collective</a> - exchanging views on new music, film and culture.<br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=collective&amp;ptrt={$sso_redirectserver}/dna/collective/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" height="25" border="0"/></a>
<br/><br/>
		<a href="/dna/ww2">People's War</a> - share your wartime stories or family history <br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=ww2&amp;ptrt={$sso_redirectserver}/dna/ww2/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" height="25" border="0"/></a>
<br/><br/>
		</xsl:if>
				
		<p>There are still useful articles, tools and listings on the site. We hope you'll continue to use this resource for your writing</p>
		</xsl:if>
		</xsl:element>  
			
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<xsl:if test="ARTICLE/GUIDE">	
	<div class="NavPromoOuter">
	<div class="NavPromo2">	
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="myinfo"><strong>MY INFO</strong></div>
		<strong>member since:</strong><br/>
		<li><xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE" mode="short1"/></li><br/>
		<strong>ID no:</strong>
		<li><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></li>
		
		<div class="arrow2"><a href="{$root}useredit{ARTICLE/ARTICLEINFO/H2G2ID}">edit intro</a></div>
		<div class="arrow2"><a href="{$root}UserDetails">change screen name</a></div>
		
		<xsl:if test="/H2G2/JOURNAL/JOURNALPOSTS/@CANWRITE = 1 and $test_MayAddToJournal">
			<div class="arrow2">
		<a href="{$root}PostJournal">
			write journal entry
		</a>
		</div>
		</xsl:if>

		<xsl:if test="/H2G2/USERMYCLUBS[descendant::CLUB!='']/CLUBSSUMMARY">
		<div class="arrow2"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check group activity</a></div>
		</xsl:if>
		</xsl:element>
		
	</xsl:when>
	<xsl:when test="$ownerisviewer = 1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		If you no longer wish your introduction to be displayed, click the link below.
		<div class="arrow2"><a href="{$root}useredit{ARTICLE/ARTICLEINFO/H2G2ID}">remove intro</a></div>
		</xsl:element>
	</xsl:when>
	<xsl:otherwise>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="memberinfo">ABOUT THIS MEMBER</div>
		<strong>member since:</strong><br/>
		<li><xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE" mode="short1"/></li><br/>
		<strong>ID no:</strong>
		<li><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></li>
		
		</xsl:element>
	
		<!-- <xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="c_leaveamessage"/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow2"> <a href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}" class="grey">add user to my contacts</a>
		</div>
		</xsl:element> -->
		
	</xsl:otherwise>
	</xsl:choose>
	</div>
	</div>
	</xsl:if>
	
	<xsl:if test="$test_IsEditor">
	<div class="editboxheader2">For editors only</div>
	<div class="editbox2">
	<div class="arrow2"><a href="{$root}useredit{ARTICLE/ARTICLEINFO/H2G2ID}">edit intro</a></div>
	<div class="arrow2"><a href="{$root}inspectuser">inspectuser</a></div>
	</div>
	</xsl:if>
	
	
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	
	</div>

	
	
	<div class="UserContent">
	<!-- MY PORTFOLIO -->
	<a name="portfolio"></a>
	<img src="{$graphics}/titles/myspace/t_portfolio.gif" alt="Portfolio" width="129" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<a href="#intro"><xsl:copy-of select="$white.arrow.right" /> intro</a> | 
		<a href="#conversations"><xsl:copy-of select="$white.arrow.right" /> conversations</a> | 
		<a href="#messages"><xsl:copy-of select="$white.arrow.right" /> messages &amp; contact</a> | 
		<a href="#group"><xsl:copy-of select="$white.arrow.right" /> group</a> | 
		<a href="#journal"><xsl:copy-of select="$white.arrow.right" /> journal</a>
		</xsl:element>
	</div>
	</div>
	
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.user.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1.user">
	
	<xsl:apply-templates select="RECENT-ENTRIES" mode="c_userpage"/>
	<!-- <xsl:apply-templates select="RECENT-APPROVALS" mode="c_userpage"/> -->
		
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">

	<!-- removed for site pulldown -->
	<xsl:if test="$test_IsEditor">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderedit">MANAGEMENT TOOLS</div>
		<div class="rightnavbox">
			
		<xsl:if test="ARTICLE[position() &gt; $articlelimitentries]">
		<div class="arrow2">
		<a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=4" xsl:use-attribute-sets="mARTICLE-LIST_r_morearticles">
			<xsl:value-of select="$m_clickmoreentries"/>
		</a></div>
		</xsl:if>
				
		<div class="arrow2"><a href="{$root}aboutwrite#10">how to delete work</a></div>
			
		<div class="arrow2">
		<a>
		<xsl:attribute name="href">
		<xsl:call-template name="sso_typedarticle_signin">
		<xsl:with-param name="type" select="36"/>
		</xsl:call-template>
		</xsl:attribute>publish my work
		</a></div>
		
		<div class="arrow2">
		<a>
		<xsl:attribute name="href">
		<xsl:call-template name="sso_typedarticle_signin">
		<xsl:with-param name="type" select="41"/>
		</xsl:call-template>
		</xsl:attribute>share your advice
		</a></div>
		
		<div class="arrow2">
		<a>
		<xsl:attribute name="href">
		<xsl:call-template name="sso_typedarticle_signin">
		<xsl:with-param name="type" select="42"/>
		</xsl:call-template>
		</xsl:attribute>start a new challenge
		</a></div>
		
<!-- 		<div class="arrow2">
		<a href="{$root}mypinboard">open my 'Pinboard'</a>
		</div>		
		 -->
		</div>
		</xsl:element>
	</xsl:if><!-- end removed for site pulldown -->
	</xsl:element>
	</tr>
	</xsl:element>
<!-- end of table -->	
	</div>	
	
	<div class="UserContent">
<!-- MY CONVERSATION -->
	<a name="conversations" id="conversation"></a>
	<img src="{$graphics}/titles/myspace/t_conversations.gif" alt="Conversations" width="180" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<a href="#intro"><xsl:copy-of select="$white.arrow.right" /> intro</a> | 
	    <a href="#portfolio"><xsl:copy-of select="$white.arrow.right" /> portfolio</a> | 
		<a href="#messages"><xsl:copy-of select="$white.arrow.right" /> messages &amp; contact</a> | 
		<a href="#group"><xsl:copy-of select="$white.arrow.right" /> group</a> | 
		<a href="#journal"><xsl:copy-of select="$white.arrow.right" /> journal</a>
		</xsl:element>
	</div>
	</div>

<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.user.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1.user">

	<xsl:apply-templates select="RECENT-POSTS" mode="c_userpage"/>
		
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<xsl:if test="$ownerisviewer = 1">
	<!-- removed for site pulldown -->
	<xsl:if test="$test_IsEditor">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderedit">MANAGEMENT TOOLS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$user.conversation.tips" /><br/>
		</div>
	</xsl:element>
	</xsl:if><!-- end site pulldown if -->
	</xsl:if> 
	
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	
</div>





	<!-- ######### now no show if no groups ######### -->
	<xsl:if test="FORUMTHREADS/@TOTALTHREADS >= 1">
	<div class="UserContent">
	<!-- MY MESSAGES -->	
	<a name="messages"></a>
	<img src="{$graphics}/titles/myspace/t_messages.gif" alt="Messages &amp; Contacts" width="220" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<a href="#intro"><xsl:copy-of select="$white.arrow.right" /> intro</a> | 
	    <a href="#portfolio"><xsl:copy-of select="$white.arrow.right" /> portfolio</a> | 
		<a href="#conversations"><xsl:copy-of select="$white.arrow.right" /> conversations</a> | 
		<a href="#group"><xsl:copy-of select="$white.arrow.right" /> group</a> | 
		<a href="#journal"><xsl:copy-of select="$white.arrow.right" /> journal</a>
		</xsl:element>
	</div>
	</div>
	
	<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.user.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1.user">
		
		<xsl:apply-templates select="ARTICLEFORUM" mode="c_userpage"/>
				
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:apply-templates select="WATCHED-USER-LIST" mode="c_userpage"/>		
		
		</xsl:element>
		</tr>
		</xsl:element>
	<!-- end of table -->	
	</div>
	</xsl:if><!-- end now no show if no groups ######### -->
	


	<!-- ######### now no show if no groups ######### -->
	<xsl:if test="CLUBSSUMMARY/CLUB and CLUBSSUMMARY/CLUB[SITEID='15']">
	<div class="UserContent">
	<!-- my groups-->
	<a name="group" id="group"></a>
	<img src="{$graphics}/titles/myspace/t_groups.gif" alt="Groups" width="102" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<a href="#intro"><xsl:copy-of select="$white.arrow.right" /> intro</a> | 
	    <a href="#portfolio"><xsl:copy-of select="$white.arrow.right" /> portfolio</a> | 
		<a href="#conversations"><xsl:copy-of select="$white.arrow.right" /> conversations</a> | 
		<a href="#messages"><xsl:copy-of select="$white.arrow.right" /> messages &amp; contact</a> | 
		<a href="#journal"><xsl:copy-of select="$white.arrow.right" /> journal</a>
		</xsl:element>
	</div>
	</div>
	
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.user.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1.user">
			<xsl:apply-templates select="USERMYCLUBS" mode="c_userpage"/>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3">
	<xsl:element name="img" use-attribute-sets="column.spacer.3" />
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	
	<xsl:if test="/H2G2/USERCLUBACTIONLIST/CLUBACTION/@RESULT='stored' and /H2G2/USERCLUBACTIONLIST/CLUBACTION/@ACTIONTYPE='invitemember'">
	
	<table width="195" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<img src="{$graphics}newoffertop.gif" width="195" height="18" border="0"/>
	<div class="rightnavboxheadernewoffer">NEW MEMBERSHIP OFFER</div>
	<div class="rightnavboxnewoffer">
	
	<xsl:apply-templates select="/H2G2/USERCLUBACTIONLIST[CLUBACTION/@RESULT='stored']" mode="newoffers"/>
	
	</div>
	<img src="{$graphics}newoffer_bottom.gif" width="195" height="51" border="0"/>
	</xsl:element>
	</td>
	</tr>
	</table>
	
	</xsl:if>
	
	
	<xsl:element name="img" use-attribute-sets="column.spacer.3" />
	</xsl:element>
	</tr>
	</xsl:element>
<!-- end of table -->	
	</div>
	
	</xsl:if><!-- end now no show if no groups -->





	<!-- ######### now no show if no journal ######### -->
	<!-- <xsl:if test="JOURNALPOSTS/POST"> -->
	<xsl:if test="JOURNALPOSTS/POST">
	<div class="UserContent">
	<!-- my journal -->
	<a name="journal" id="journal"></a>
	<img src="{$graphics}/titles/myspace/t_journal.gif" alt="Journal" width="112" height="40" border="0"/><br/>

	<div class="titleBarNavBg">
	<div class="titleBarNav">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<a href="#intro"><xsl:copy-of select="$white.arrow.right" /> intro</a> | 
	    <a href="#portfolio"><xsl:copy-of select="$white.arrow.right" /> portfolio</a> | 
		<a href="#conversations"><xsl:copy-of select="$white.arrow.right" /> conversations</a> | 
		<a href="#messages"><xsl:copy-of select="$white.arrow.right" /> messages &amp; contact</a> | 
		<a href="#group"><xsl:copy-of select="$white.arrow.right" /> group</a>
		</xsl:element>
	</div>
	</div>
	
<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.user.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1.user">
			<xsl:apply-templates select="JOURNAL" mode="c_userpage"/>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3">
	<xsl:element name="img" use-attribute-sets="column.spacer.3" />
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	<xsl:element name="img" use-attribute-sets="column.spacer.2" />
	</xsl:element>
	</tr>
	</xsl:element>
<!-- end of table -->	
	</div>
	</xsl:if><!-- end now no show if no journal -->




	</xsl:template>


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
		<xsl:apply-templates select="FORUMTHREADS" mode="c_userpage"/>
		
		<!-- all my messages links -->
		<xsl:if test="FORUMTHREADS/@TOTALTHREADS >= 1">
		<div class="boxactionback1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="r_viewallthreadsup"/>
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
	<div>
	<div>		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<!-- leave a message -->
			<div class="arrow2">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_message_signin"/>
			</xsl:attribute>
			leave me a message
			</a>
			</div>
		</xsl:element>
	</div></div>
	</xsl:template>
	
	
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Description: Presentation of the 'Click to see more conversations' link
	 $m_clickmoreuserpageconv -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
		<div class="arrow1"><xsl:apply-imports/></div>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	Description: Presentation of the 'Be the first person to talk about this article' link 

	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	<xsl:choose>
	<xsl:when test="$ownerisviewer = 1">
	<div class="box2">
	<xsl:copy-of select="$m_nomessagesowner" />
	</div>
	</xsl:when>
	<xsl:otherwise>
	<div class="box2">
	<xsl:copy-of select="$m_nomessages" />
	</div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	<div class="box">
		<xsl:for-each select="THREAD[position() &lt;=$articlelimitentries]">
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="position() mod 2 = 0">colourbar1</xsl:when>
			<xsl:otherwise>colourbar2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0">
			<tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<strong><xsl:apply-templates select="." mode="c_userpage"/></strong>
			</xsl:element>
			</td>
			</tr><tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			first post: <xsl:apply-templates select="FIRSTPOST/DATE" mode="short"/> | 
			latest reply: <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/>
			</xsl:element>
			</td></tr></table></div></xsl:for-each></div>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates 'Date posted' link
	-->
	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
		<a xsl:use-attribute-sets="maTHREADID_t_threaddatepostedlinkup">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="../LASTPOST/@POSTID"/>#p<xsl:value-of select="../LASTPOST/@POSTID"/></xsl:attribute>
			<xsl:apply-templates select="../DATEPOSTED" mode="short"/>
		</a>
	</xsl:template>

	
	<!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_userpage">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelinkup"/>		
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
		<xsl:apply-templates select="ENTRIES" mode="c_userpagerefs"/>
		<xsl:apply-templates select="USERS" mode="c_userpagerefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_userpagerefsbbc"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_userpagerefsnotbbc"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
		<xsl:value-of select="$m_refentries"/>
		<br/>
		<xsl:apply-templates select="ENTRYLINK" mode="c_userpagerefs"/>
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
		<xsl:apply-templates select="USERLINK" mode="c_userpagerefs"/>
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
		<xsl:apply-templates select="EXTERNALLINK" mode="c_userpagerefsbbc"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
	Use: presentation of of the 'List of external non-BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
		<xsl:value-of select="$m_refsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_userpagerefsnotbbc"/>
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

<!-- my journal -->
	<!--
	<xsl:template match="JOURNAL" mode="r_userpage">
	Description: Presentation of the object holding the userpage journal
	 -->
	<xsl:template match="JOURNAL" mode="r_userpage">
		<xsl:if test="not(JOURNALPOSTS/POST)">
		<div class="box2"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="." mode="t_journalmessage"/></xsl:element></div> 
		</xsl:if>
		<!-- only show first post -->
		<xsl:apply-templates select="JOURNALPOSTS/POST[1]" mode="c_userpagejournalentries"/>
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_moreuserpagejournals"/>		
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<xsl:apply-templates select="/H2G2/JOURNAL/JOURNALPOSTS" mode="c_adduserpagejournalentry"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Description: Presentation of the 'click here to see more entries' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="c_moreuserpagejournals">
		<xsl:apply-templates select="." mode="r_moreuserpagejournals"/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the JOURNAL 'more entries' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	<xsl:param name="img" select="$m_clickmorejournal"/>
	<xsl:if test="count(POST)&gt;1">
	<div class="boxactionback">
		<div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MJ<xsl:value-of select="../../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="@FORUMID"/></xsl:attribute>
			<xsl:copy-of select="$img"/>
		</a>
		</xsl:element>
		</div>
		</div>
	</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Description: Presentation of the 'add a journal entry' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	<!-- m_clickaddjournal -->
	<div class="boxactionback">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow1"><xsl:apply-imports/></div>
	</xsl:element>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagejournalentries">
	Description: Presentation of a single Journal post
	 -->
	<xsl:template match="POST" mode="r_userpagejournalentries">
		<div class="boxheading">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:value-of select="SUBJECT"/>
		</xsl:element>
		
		<!-- <a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>
		<xsl:value-of select="SUBJECT"/>
		</a> -->
		</div>	

		<div class="box2">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		published <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/> | <xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/><br/>
		</xsl:element>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="TEXT" mode="t_journaltext"/>
		</xsl:element>
		
		</div>
		
			
		<table width="400" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxactionback">
		
		<div class="arrow1"><xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
		</xsl:element><!-- end removed for site pulldown --></xsl:if>
		</div>
		
		</td>
		<td align="right" class="boxactionback"><a href="UserComplaint?PostID={@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp"><xsl:copy-of select="$alt_complain"/></a></td>
		</tr>
		</table>

		<!-- EDIT AND MODERATION HISTORY -->
		<xsl:if test="$test_IsEditor">
		<div class="moderationbox">
		<div align="right"><img src="{$graphics}icons/icon_editorsedit.gif" alt="" width="23" height="21" border="0" align="left"/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
		</xsl:element>
		</div>
		</div>
		</xsl:if>			

		<!-- 			
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>view all my entries</a>
		</xsl:element>
		-->
		
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
	Description: Object is used if there are replies to a journal entry
	 -->
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
		<xsl:apply-templates select="../@THREADID" mode="t_journalentriesreplies"/>
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

	<!--
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
	Description: Presentation of the object holding the 100 latest conversations the user
	has contributed to
	 -->
	<xsl:template match="RECENT-POSTS" mode="r_userpage">
		<!-- default text if no entries have been made -->
		<xsl:apply-templates select="." mode="c_postlistempty"/>
		<!-- the list of recent entries -->
		<xsl:apply-templates select="POST-LIST" mode="c_postlist"/>
		
	</xsl:template>


	<!--
	<xsl:template match="POST-LIST" mode="owner_postlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_postlist">
	<div class="box">
		<!-- <xsl:copy-of select="$m_forumownerfull"/> intro text -->
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries][SITEID=15]" mode="c_userpage"/>
		<xsl:if test="count(./POST)&gt;=1">
		<!-- all my coversations link -->
		<div class="boxactionback1">
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
		</div>		
		</xsl:if>
	</div>
		<!-- [THREAD/FORUMTITLE!='POETRY'] -->
	</xsl:template>

	<!--
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_postlist">
	<div class="box">
		<xsl:apply-templates select="POST[position() &lt;=$postlimitentries][SITEID=15]" mode="c_userpage"/>
		<!-- all my conversations link -->
		<xsl:if test="count(./POST)&gt;=1">
		<div class="boxactionback">
		<xsl:apply-templates select="USER/USERID" mode="c_morepostslink"/>
		</div>		
		</xsl:if>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_morepostslink">
	Description: Presentation of a link to 'see all posts'
	 -->
	<xsl:template match="USERID" mode="r_morepostslink">
		<div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
		</xsl:element>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="RECENT-POSTS" mode="owner_postlistempty">
		<div class="box2">
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
		<div class="box2">
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


		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::POST) mod 2 = 0">colourbar1</xsl:when>
			<xsl:otherwise>colourbar2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="300">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<strong>
			<xsl:apply-templates select="THREAD/@THREADID" mode="t_userpagepostsubject"/>
			</strong><br/>
			</xsl:element>
			</td>
			<td  align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="." mode="c_postunsubscribeuserpage"/>
			</xsl:element>
			</td>
			</tr>
			<tr>
			<td colspan="2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_postedcolon"/><xsl:text>  </xsl:text><xsl:apply-templates select="." mode="c_userpagepostdate"/> | <xsl:apply-templates select="." mode="c_userpagepostlastreply"/>
			</xsl:element>
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
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagepostlastreply">
	Description: Presentation of the 'reply to a user posting' date
	 -->
	<xsl:template match="POST" mode="r_userpagepostlastreply">
		<xsl:apply-templates select="." mode="t_lastreplytext"/><xsl:text>  </xsl:text>
		<xsl:apply-templates select="." mode="t_userpagepostlastreply"/>
	</xsl:template>
	
	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the 'last reply' date link
	-->
	<xsl:template match="POST" mode="t_userpagepostlastreply">
		<xsl:if test="HAS-REPLY > 0">
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="LatestPost"/>
		</xsl:if>
	</xsl:template>
	
	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the 'last reply' date link
	-->
	<xsl:template match="DATE" mode="LatestPost">
		<xsl:param name="attributes"/>
		<a xsl:use-attribute-sets="mDATE_LatestPost">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/><xsl:variable name="thread" select="../../@THREADID"/><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_t' and (substring-before(VALUE, '|') = string($thread))]"><xsl:text>&amp;date=</xsl:text><xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE, '|') = string($thread)]/VALUE,'|')"/></xsl:when><xsl:otherwise><xsl:text>&amp;latest=1#last</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	<a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}" xsl:use-attribute-sets="npostunsubscribe1"><xsl:copy-of select="$m_removeme"/></a>
	</xsl:template>

	<!-- my portfolio -->
	<xsl:template match="RECENT-ENTRIES" mode="r_userpage">
		<xsl:apply-templates select="." mode="c_userpagelistempty"/>
		<div class="box">
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_userpagelist"/>
		</div>
	</xsl:template>

	<xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
	<!-- approvalslistempty FOR EMPTY ARTICLES -->
	
	<!-- <xsl:value-of select="$m_memberormy"/> -->
		<!-- CREATIVE WRITING -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>CREATIVE WRITING WORKS</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID &gt;= 30 and EXTRAINFO/TYPE/@ID &lt;= 40 or EXTRAINFO/TYPE/@ID='1' or EXTRAINFO/TYPE/@ID &gt;= 80 and EXTRAINFO/TYPE/@ID &lt;= 90][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		
	
	    <!-- ADVICE -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>YOUR ADVICE</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='41'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		
		
		 <!-- CHALLENGE -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>CHALLENGES</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='42'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		
		
		<!-- MINICOURSES -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>MINI-COURSES</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='51'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
	
		
		<!-- all reviews link -->
		<div class="boxactionback1">
		<xsl:apply-templates select="." mode="c_morearticles"/>
		</div>

	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	Description: Presentation of a full list of articles that the viewer doesn`t owns
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
	
		<!-- CREATIVE WRITING -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>CREATIVE WRITING WORKS</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID &gt;= 30 and EXTRAINFO/TYPE/@ID &lt;= 40 or EXTRAINFO/TYPE/@ID='1' or EXTRAINFO/TYPE/@ID &gt;= 80 and EXTRAINFO/TYPE/@ID &lt;= 90][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
	
	    <!-- ADVICE -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>YOUR ADVICE</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='41'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>

		
		 <!-- CHALLENGE -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>CHALLENGES</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='42'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		
		<!-- MINICOURSES -->
		<div class="boxheading"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>MINI-COURSES</strong></xsl:element></div>
		<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID='51'][position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>

		<!-- all reviews link -->
		<div class="boxactionback1">
		<xsl:apply-templates select="." mode="c_morearticles"/>
		</div>
		
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
		<div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
		</xsl:element>
		</div>		
	</xsl:template>

	<!--
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer owns
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
		<div class="box2"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$m_artownerempty"/></xsl:element></div>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
	Description: Presentation of an empty list of articles that the viewer doesn`t own
	 -->
	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
		<div class="box2"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$m_artviewerempty"/></xsl:element></div>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	Description: Presentation of a single article item within a list
	 -->
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	<a name="{H2G2-ID}" id="{H2G2-ID}"></a>
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0">colourbar2</xsl:when>
			<xsl:otherwise>colourbar1</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table width="390" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="300">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<strong><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/></strong>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:variable name="imgcolour">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0">editorspick1</xsl:when>
			<xsl:otherwise>editorspick2</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			
			<xsl:call-template name="article_selected">
			<xsl:with-param name="status" select="EXTRAINFO/TYPE/@ID" />
			<xsl:with-param name="img" select="$imgcolour" />
			</xsl:call-template>
			</td>
			</tr>
			<tr>
			<td>
			<xsl:if test="EXTRAINFO/TYPE/@ID = 51">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<a href="A{EXTRAINFO/DESCRIPTION/ARTICLEID}#{EXTRAINFO/DESCRIPTION/PART}"><xsl:value-of select="EXTRAINFO/DESCRIPTION/COURSENAME" /></a>
			</xsl:element><br/> 
			</xsl:if>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="DATE-CREATED/DATE" mode="short1"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>

	</xsl:template>
	<!-- <xsl:template match="TYPE" mode="t_test">
		<xsl:value-of select="@ID" />
	</xsl:template> -->
	<!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Description: Presentation of the 'uncancel this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
		(<xsl:apply-imports/>)
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="c_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Edit this article' link container
	-->
	<xsl:template match="H2G2-ID" mode="c_editarticle">
		<xsl:if test="($ownerisviewer = 1) and (../STATUS = 1 or ../STATUS = 3 or ../STATUS = 4) and (../EDITOR/USER/USERID = $viewerid)">
			<xsl:apply-templates select="." mode="r_editarticle"/>
		</xsl:if>
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

	<!--
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
	Description: Presentation of the Edited Articles Object
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
		<xsl:apply-templates select="." mode="c_approvalslistempty"/>
		<xsl:apply-templates select="ARTICLE-LIST" mode="c_approvalslist"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
		<!--<xsl:copy-of select="$m_editviewerfull"/>-->
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_userpagelist"/>
		<xsl:apply-templates select="." mode="c_moreeditedarticles"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Description: Presentation of the 'See more edited articles' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
			<div>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:copy-of select="$arrow.right" />
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
			<b><xsl:value-of select="$m_userdata"/></b>
			<br/>
			<xsl:value-of select="$m_researcher"/>
			<xsl:value-of select="USER/USERID"/>
			<br/>
			<xsl:value-of select="$m_namecolon"/>
			<xsl:value-of select="USER/USERNAME"/>
			<br/>
			<xsl:apply-templates select="USER/USERID" mode="c_inspectuser"/>
			<xsl:apply-templates select="." mode="c_editmasthead"/>
			<xsl:apply-templates select="USER/USERID" mode="c_addtofriends"/>
			<xsl:apply-templates select="USER/GROUPS" mode="c_userpage"/>		
	</xsl:template>
	


	<xsl:template match="PAGE-OWNER" mode="c_usertitle">
	
	<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
	<span class="headinguser">
	<a href="{$root}U{USER/USERID}"><xsl:value-of select="USER/USERNAME" /></a>
	</span>
	</xsl:element>
	
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
	
	<div class="rightnavboxheaderedit">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		MANAGE CONTACTS
		</xsl:element>
	</div>
	
	<div class="rightnavbox">
	<!-- has the default text -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="." mode="t_introduction"/>
	</xsl:element>
	<table width="192" border="0" cellspacing="0" cellpadding="0">
		<xsl:apply-templates select="USER[position()&lt;6]" mode="c_watcheduser"/>
	</table>
  	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow1"><a href="{$root}U{/H2G2/PAGE-OWNER/USER/USERID}?s_view=listcontacts">see all my contacts</a></div>
	</xsl:element>
	</div>

	<!-- <xsl:apply-templates select="." mode="c_friendsjournals"/> -->
	<!-- <xsl:apply-templates select="." mode="c_deletemany"/> -->

	</xsl:template>
	
	<!--
	<xsl:template match="USER" mode="r_watcheduser">
	Description: Presentation of the WATCHED-USER-LIST/USER object
	 -->
	<xsl:template match="USER" mode="r_watcheduser">
	<tr>
	<td height="30">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="U{USERID}" class="genericlink"><xsl:value-of select="USERNAME"/></a> 
	</xsl:element>
	</td>
	<td valign="middle">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="c_watcheduserdelete"/>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td colspan="2"><div class="line"></div></td>
	</tr>
	<!-- 
	<xsl:apply-templates select="." mode="t_watcheduserpage"/>
	<xsl:apply-templates select="." mode="t_watcheduserjournal"/>
	 -->
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Description: Presentation of the 'Delete' link
	 -->
	<xsl:template match="USER" mode="r_watcheduserdelete">
		<xsl:apply-imports/>
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
		<xsl:apply-templates select="." mode="t_folderslink"/>
		<br/>
		<hr/>
	</xsl:template>
	

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							USERCLUBACTIONLIST Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_userpage">
		<div class="PageContent">
		<img src="{$graphics}/titles/groups/t_waitinglists.gif" alt="Waiting Lists" width="205" height="39" border="0"/>
		
		<xsl:apply-templates select="." mode="c_yourrequests"/>
		</div>
		
		<div class="PageContent">
		<img src="{$graphics}/titles/groups/t_membershipdecisions.gif" alt="Membership Descisions" width="215" height="39" border="0"/>
		<a name="descisions" id="descisions"></a>
		<xsl:apply-templates select="." mode="c_previousactions"/>
		</div>
		
		<div class="PageContent">
		<img src="{$graphics}/titles/groups/t_membershipoffers.gif" alt="Membership Descisions" width="215" height="39" border="0"/>
		<a name="offers" id="offers"></a>
		<xsl:apply-templates select="." mode="c_invitations"/>
		</div>
		
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_yourrequests">
	Use: Presentation of any club requests the user has made 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_yourrequests">
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="2">
		<tr>
		<td class="boxheading"><xsl:element name="{$text.small}" use-attribute-sets="text.small">
	    REQUEST
		</xsl:element></td>
		<td class="boxheading"><xsl:element name="{$text.small}" use-attribute-sets="text.small">
		DATE REQUESTED
		</xsl:element></td>
		</tr>
		<xsl:apply-templates select="CLUBACTION" mode="c_yourrequests"/>
		</table>
		</div>
		
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_invitations">
	Use: Presentation of any club invitations the user has recieved 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_invitations">
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		OFFER
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		ACTION
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="CLUBACTION" mode="c_invitations"/>
		</table>
		</div>
	</xsl:template>
		<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_invitations">
	Use: Presentation of any club invitations the user has recieved 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="newoffers">
		hey <a href="{$root}G{CLUBACTION/@CLUBID}"><xsl:value-of select="CLUBACTION/COMPLETEUSER/USER/USERNAME" /></a> from the <a href="U{CLUBACTION/COMPLETEUSER/USER/USERID}"><xsl:value-of select="CLUBACTION/CLUBNAME" /></a> group offers you ownership. Go and check.
	</xsl:template>

	<!--
	<xsl:template match="CLUBACTION" mode="r_invitations">
	Use: Presentation of each individual club invitations the user has received 
	 -->
	<xsl:template match="CLUBACTION" mode="r_invitations">
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::CLUBACTION) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		
		<xsl:choose>
		<xsl:when test="@ACTIONTYPE='invitemember'">
		invitation<br/>
		as a member from the
		
		</xsl:when>
		<xsl:otherwise>
		promotion offer<br/>
		as an owner from the
		</xsl:otherwise>
		</xsl:choose>
	
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/> group
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		do you want to accept this offer?<br/>
		<xsl:apply-templates select="@ACTIONID" mode="t_acceptlink"/><xsl:text>  </xsl:text>
		<xsl:apply-templates select="@ACTIONID" mode="t_rejectlink"/>
		</xsl:element>
		</td>
	</tr>
		<!-- <xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
		<xsl:apply-templates select="DATEREQUESTED" mode="t_date"/> -->
		
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_yourrequests">
	Use: Presentation of each individual club request the user has made 
	 -->
	<xsl:template match="CLUBACTION" mode="r_yourrequests">
	<tr>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_actiondescription"/>
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="DATEREQUESTED" mode="t_date"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="r_previousactions">
	Use: Presentation of any previous club request actions the user the made 
	 -->
	<xsl:template match="USERCLUBACTIONLIST" mode="r_previousactions">

		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		REQUESTED
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		RESULTS
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="CLUBACTION" mode="c_previousactions"/>
		</table>
		</div>
		
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="r_previousactions">
	Use: Presentation of each previous club actions the user has made 
	 -->
 
	<xsl:template match="CLUBACTION" mode="r_previousactions">
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::CLUBACTION) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@ACTIONTYPE" mode="t_actiondescription"/>
		<xsl:apply-templates select="CLUBNAME" mode="t_clublink"/>
		</xsl:element>
		</td>
		<!-- <td><xsl:apply-templates select="DATEREQUESTED" mode="t_date"/></td> -->
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="." mode="c_resulttext"/>
		</xsl:element>
		</td>
	</tr>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="auto_resulttext">
	Use: Presentation of the automatic response result text 
	 -->
	<xsl:template match="CLUBACTION" mode="auto_resulttext">
		processed automatically
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="accept_resulttext">
	Use: Presentation of the accepted by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="accept_resulttext">
		approved by
		<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="by_resulttext">
	Use: Presentation of the made by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="by_resulttext">
		approved by
	<xsl:apply-templates select="COMPLETEUSER/USER/USERNAME" mode="t_userlink"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="selfdecline_resulttext">
	Use: Presentation of the you declined result text 
	 -->
	<xsl:template match="CLUBACTION" mode="selfdecline_resulttext">
		You declined
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="decline_resulttext">
	Use: Presentation of the declined by result text 
	 -->
	<xsl:template match="CLUBACTION" mode="decline_resulttext">
		rejected<br/>
		do you want to <a href="{$root}U{../USERID}">contact</a> this group owner
		</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								USERMYCLUBS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="USERMYCLUBS" mode="r_userpage">
	
		<xsl:choose>
		<xsl:when test="CLUBSSUMMARY/CLUB and CLUBSSUMMARY/CLUB[SITEID='15']">
		<xsl:apply-templates select="CLUBSSUMMARY" mode="c_userpage"/>	
		</xsl:when>
		<xsl:otherwise>
		<div class="box2">
		<xsl:copy-of select="$m_clubempty" />
		</div>
		</xsl:otherwise>
		</xsl:choose>
	
		
	</xsl:template>
	
	<xsl:template match="CLUBSSUMMARY" mode="r_userpage">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td colspan="2" class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		GROUP<br/>NAME
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		LATEST<br/>DISCUSSION
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="CLUB[SITEID='15'][@ID!='680']" mode="c_userpage"/>
		<tr>
		<td colspan="3">
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1"><a href="{$root}U{/H2G2/PAGE-OWNER/USER/USERID}?s_view=listgroup">view all my groups</a></div>
		</xsl:element>
		</div>
		
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:if test="$ownerisviewer = 1">
		<div class="arrow1"><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">view my membership bulletin</a></div>
		</xsl:if>
		</xsl:element>
		</div>
		</td>
		</tr>
		</table>

	</xsl:template>
	
	<xsl:template match="CLUB" mode="r_userpage">
		<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::CLUB) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td width="230">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="NAME" mode="t_clublink"/>
		</xsl:element>
		</td>
		<td width="70" align="right">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		
		<xsl:choose>
		<xsl:when test="$test_IsEditor or MEMBERSHIPSTATUS='Owner' or /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
		<a href="{$root}G{@ID}?s_view=editmembers"><xsl:copy-of select="$button.admin" /></a>
		</xsl:when>
		<xsl:otherwise>
		<a href="{$root}G{@ID}?s_view=editmembership"><xsl:copy-of select="$button.admin" /></a>
		</xsl:otherwise>
		</xsl:choose>
		
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="DATECREATED/DATE" mode="short" />
		</xsl:element>
		</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="CLUB" mode="c_umc">
	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">		
	<li>
	<a href="{$root}G{@ID}" class="genericlink"><xsl:value-of select="NAME"/></a><br/> 
	<xsl:choose>
	<xsl:when test="$test_IsEditor or MEMBERSHIPSTATUS='Owner' or /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
	<a href="{$root}G{@ID}?s_view=editmembers"><xsl:copy-of select="$button.admin" /></a>
	</xsl:when>
	<xsl:otherwise>
	<a href="{$root}G{@ID}?s_view=editmembership"><xsl:copy-of select="$button.admin" /></a>
	</xsl:otherwise>
	</xsl:choose>
	</li>
	</xsl:element>
	

	<!-- : <xsl:value-of select="MEMBERSHIPSTATUS"/> -->
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
						<!-- <xsl:value-of select="ARTICLE/SUBJECT"/> --> <xsl:value-of select="PAGE-OWNER/USER/USERNAME"/><!--  - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/> -->
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
