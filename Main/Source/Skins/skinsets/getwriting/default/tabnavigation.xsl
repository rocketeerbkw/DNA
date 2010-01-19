<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:variable name="tabgroups">
	
	<xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">nobanner</xsl:when></xsl:choose>
	
	<!-- home -->
	<xsl:choose><xsl:when test="/H2G2/@TYPE='FRONTPAGE'">home</xsl:when></xsl:choose>
	
	<!-- write -->
	<xsl:choose><xsl:when test="$current_article_type=10">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=15">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=16">readreview</xsl:when></xsl:choose><!-- was write -->
	<xsl:choose><xsl:when test="$current_article_type=70">readreview</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=22">readreview</xsl:when></xsl:choose><!-- was write -->
	<xsl:choose><xsl:when test="$article_type_group='creative' and /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$article_type_group='creative' and /H2G2/@TYPE='TYPED-ARTICLE'">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$article_type_group='advice' and /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1">write</xsl:when></xsl:choose>
<xsl:choose><xsl:when test="$article_type_group='advice' and /H2G2/@TYPE='TYPED-ARTICLE'">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$article_type_group='challenge' and /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$article_type_group='challenge' and /H2G2/@TYPE='TYPED-ARTICLE'">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$article_type_group='competition'">readreview</xsl:when></xsl:choose><!-- was write -->
	<xsl:choose><xsl:when test="/H2G2/@TYPE='SUBMITREVIEWFORUM'">write</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/NAME='challengebids'">write</xsl:when></xsl:choose>
	
	
	<!-- groups -->
	<xsl:choose><xsl:when test="/H2G2/@TYPE='USERPAGE' and /H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='myactivity'">group</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=14">group</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='CLUB'">group</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/INDEX/SEARCHTYPES/TYPE=1001 and /H2G2/@TYPE='INDEX'">group</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">group</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='USERMYCLUBS'">group</xsl:when></xsl:choose>
	
	
<!-- learn -->
	<xsl:choose><xsl:when test="$searchtype=53 or $searchtype=56">craft</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$searchtype=54 or $searchtype=55 or $searchtype=50">minicourse</xsl:when></xsl:choose>
<xsl:choose><xsl:when test="$searchtype=57 or $searchtype=58">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=11">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=17">minicourse</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=50">minicourse</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=18">craft</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=20">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=51">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=53">craft</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=54">minicourse</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=55">minicourse</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=56">craft</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=57">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=58">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=60">learn</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=65">learn</xsl:when></xsl:choose>
	  
	<!-- read and review -->
	<xsl:choose><xsl:when test="$current_article_type=12">readreview</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=52">readreview</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=2001">readreview</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=59">readreview</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=62">readreview</xsl:when></xsl:choose>

	<!-- talk -->
    <xsl:choose><xsl:when test="$current_article_type=13">talk</xsl:when></xsl:choose> 
	<xsl:choose><xsl:when test="$current_article_type=44 and not(/H2G2/ARTICLE/ARTICLEINFO/NAME='challengebids')">talk</xsl:when></xsl:choose> 
	
	<!-- my space -->
	<!-- <xsl:choose><xsl:when test="/H2G2/@TYPE='USERPAGE'">myspace</xsl:when></xsl:choose> -->
	<xsl:choose><xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">myspace</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='MOREPAGES'">myspace</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='USEREDIT'">myspace</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='ADDJOURNAL'">myspace</xsl:when></xsl:choose>
	
	
	<!-- search -->
	<xsl:choose><xsl:when test="/H2G2/@TYPE='CATEGORY'">search</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="/H2G2/@TYPE='SEARCH'">search</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$searchgroup='creative' and /H2G2/@TYPE='INDEX'">search</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$searchgroup='challenge' and /H2G2/@TYPE='INDEX'">search</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$searchgroup='advice' and /H2G2/@TYPE='INDEX'">search</xsl:when></xsl:choose>
	
	<!-- events video -->
	<xsl:choose><xsl:when test="$current_article_type=19">eventsvideo</xsl:when></xsl:choose>
	<xsl:choose><xsl:when test="$current_article_type=61">eventsvideo</xsl:when></xsl:choose>
	
	<!-- help -->
	<xsl:choose><xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">help</xsl:when></xsl:choose>
	
	
	</xsl:variable>
	
	
	<xsl:template name="TABNAVIGATIONBOX">
	<div class="markerBox">
	<!-- tabs -->
	<xsl:call-template name="TABNAVIGATION" />
	
	<xsl:choose>
	<!-- subbeginners -->
	<xsl:when test="$current_article_type=50">
		<xsl:copy-of select="$tabs.page.subbeginners" />
	</xsl:when>
	<xsl:when test="$current_article_type=54">
		<xsl:copy-of select="$tabs.page.subinter" />
	</xsl:when>
	<xsl:when test="$current_article_type=55">
		<xsl:copy-of select="$tabs.page.subadv" />
	</xsl:when>
	<xsl:when test="$current_article_type=57">
		<xsl:copy-of select="$tabs.page.subtool" />
	</xsl:when>
	<!-- home -->
	<xsl:when test="/H2G2/@TYPE='FRONTPAGE' or /H2G2/@TYPE='FRONTPAGE-EDITOR'">
		<xsl:copy-of select="$tabs.front.home" />
	</xsl:when>
	<!-- my space page all my portfolio  -->
	<xsl:when test="/H2G2/@TYPE='MOREPAGES'">
		<xsl:copy-of select="$tabs.page.allmyportfolio" />
	</xsl:when>
	<!-- all my conversations -->
	<xsl:when test="/H2G2/@TYPE='MOREPOSTS'">
		<xsl:copy-of select="$tabs.page.allconversations" />
	</xsl:when>
	<!-- all my messages -->
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
		<xsl:copy-of select="$tabs.page.allmymessages" />
	</xsl:when>
	<!-- my space - edit intro -->
	<xsl:when test="/H2G2/@TYPE='USEREDIT' and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD=1">
		<xsl:copy-of select="$tabs.writeintro" />
	</xsl:when>
	<!-- my space - change screenname -->
	<xsl:when test="/H2G2/@TYPE='USERDETAILS'">
		<xsl:copy-of select="$tabs.changescreename" />
	</xsl:when>
	<!-- my space - my journal -->
	<xsl:when test="/H2G2/@TYPE='JOURNAL' and /H2G2/FORUMSOURCE/@TYPE='journal'">
		<xsl:copy-of select="$tabs.myjournal" />
	</xsl:when>
	<!-- groups- tabs.groupdiscussion -->
	<xsl:when test="/H2G2/@TYPE='JOURNAL' and /H2G2/FORUMSOURCE/@TYPE='clubjournal'">
		<xsl:copy-of select="$tabs.page.conversation" />
	</xsl:when>
	<!-- review circle page -->
	<xsl:when test="$current_article_type=2001">
		<xsl:copy-of select="$tabs.page.reviewcircle" />
	</xsl:when> 
	<!-- review circle intro -->
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='reviewforum'">
		<xsl:copy-of select="$tabs.intro.reviewcircle" />
	</xsl:when> 
	<!-- review circle intro -->
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and /H2G2/POSTTHREADFORM/@INREPLYTO='0' and $ownerisviewer=1 or /H2G2/FORUMSOURCE/@TYPE='clubjournal' and /H2G2/POSTTHREADFORM/@INREPLYTO='0' and $test_IsEditor or /H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated'">
		<xsl:copy-of select="$tabs.groups.discussion" />
	</xsl:when> 
	<!-- learn front page-->
	<xsl:when test="$current_article_type=11">
		<xsl:copy-of select="$tabs.front.learn" />
	</xsl:when>
	<!-- mini course front -->
	<xsl:when test="contains($article_subtype,'minicourse')">
		<xsl:copy-of select="$tabs.front.minicourses" />
	</xsl:when>
	<!-- write excercise -->
	<xsl:when test="$current_article_type=51 and /H2G2/@TYPE='TYPED-ARTICLE'">
		<xsl:copy-of select="$tabs.form.writeexcercise" />
	</xsl:when>
	<!-- the craft front -->
	<xsl:when test="$current_article_type=18">
		<xsl:copy-of select="$tabs.front.thecraft" />
	</xsl:when>
	<!-- the craft page - readonly -->
	<xsl:when test="$current_article_type=56">
		<xsl:copy-of select="$tabs.page.thecraft" />
	</xsl:when>
	<!-- the craft page -flash -->
	<xsl:when test="$current_article_type=53">
		<xsl:copy-of select="$tabs.page.thecraft2" />
	</xsl:when>
	<!-- group front page -->
	<xsl:when test="$current_article_type=14">
		<xsl:copy-of select="$tabs.front.groups" />
	</xsl:when>
	<!-- write front -->
	<xsl:when test="contains($article_type_name, 'frontpage_write')">
	  <xsl:copy-of select="$tabs.front.write" />
	</xsl:when>
	<!-- challenge front -->
	<xsl:when test="contains($article_type_name, 'frontpage_challenge')">
		<xsl:copy-of select="$tabs.front.challenge" />
	</xsl:when>
	<!-- fromedit challenge -->
	<xsl:when test="$test_fromedit and $article_type_group='challenge'">
		<xsl:copy-of select="$tabs.fromedit.challenge" />
	</xsl:when>
	<!-- Create challenge -->
	<xsl:when test="$article_type_group='challenge' and /H2G2/@TYPE='TYPED-ARTICLE'">
		<xsl:copy-of select="$tabs.form.challenge" />
	</xsl:when>
	<!-- challenge page -->
	<xsl:when test="$current_article_type=42">
		<xsl:copy-of select="$tabs.page.challenge" />
	</xsl:when>
	<!-- challenge bid page -->
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/NAME='challengebids'">
		<xsl:copy-of select="$tabs.page.challengebids" />
	</xsl:when>
	<!-- competition front -->
	<xsl:when test="$current_article_type=16">
		<xsl:copy-of select="$tabs.front.competition" />
	</xsl:when>
	<!-- competition front -->
	<xsl:when test="$current_article_type=22">
		<xsl:copy-of select="$tabs.front.winners" />
	</xsl:when>
	<!-- competition page -->
	<xsl:when test="$current_article_type=45 or $current_article_type=46">
		<xsl:copy-of select="$tabs.page.competition" />
	</xsl:when>
	<!-- competition page -->
	<xsl:when test="$current_article_type=47">
		<xsl:copy-of select="$tabs.page.competition2" />
	</xsl:when>
	<!-- this competition -->
	<xsl:when test="$current_article_type=43">
		<xsl:copy-of select="$tabs.page.thiscompetition" />
	</xsl:when>
	<!-- eventsvideo front front -->
	<xsl:when test="$current_article_type=19">
		<xsl:copy-of select="$tabs.front.eventsvideo" />
	</xsl:when>
	<!-- tools and quizzes -->
	<xsl:when test="$current_article_type=20">
		<xsl:copy-of select="$tabs.front.toolsandquizzes" />
	</xsl:when>
	<!-- tools page -->
	<xsl:when test="$current_article_type=57">
		<xsl:copy-of select="$tabs.page.tools" />
	</xsl:when>
 	<!-- help -->
	<xsl:when test="$current_article_type=21">
		<xsl:copy-of select="$tabs.front.help" />
	</xsl:when>
	 <!-- help page-->
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">
		<xsl:copy-of select="$tabs.help.page" />
	</xsl:when>
	<!-- talk front page -->
	<xsl:when test="$article_subtype='talk'">
		<xsl:copy-of select="$tabs.front.talk" />
	</xsl:when>
	<!-- talk page -->
	<xsl:when test="$article_subtype='talkpage'">
		<xsl:copy-of select="$tabs.talk.page" />
	</xsl:when>
	<!-- write creative -->
	<xsl:when test="$article_type_group='creative' and /H2G2/@TYPE='TYPED-ARTICLE'">
		<xsl:copy-of select="$tabs.form.creative" />
	</xsl:when>
	<!-- fromedit creative -->
	<xsl:when test="$test_fromedit and $article_type_group='creative' and not($test_fromeditselected)">
		<xsl:copy-of select="$tabs.fromedit.creative" />
	</xsl:when>
	<!-- creative pages -->
	<xsl:when test="$article_type_group='creative'">
	  <xsl:copy-of select="$tabs.page.creative" />
	</xsl:when>
	<!-- creative pages -->
	<xsl:when test="$current_article_type=51">
	  <xsl:copy-of select="$tabs.page.excercise" />
	</xsl:when>
	<!-- fromedit advice -->
	<xsl:when test="$test_fromedit and $article_type_group='advice'">
		<xsl:if test="$test_IsEditor">
			<xsl:copy-of select="$tabs.fromedit.advice" />
		</xsl:if>
	</xsl:when>
	<!-- write advice -->
	<xsl:when test="$article_type_group='advice' and /H2G2/@TYPE='TYPED-ARTICLE'">
		<xsl:if test="$test_IsEditor">
			<xsl:copy-of select="$tabs.form.advice" />
		</xsl:if>
	</xsl:when>
	<!-- page advice -->
	<xsl:when test="$current_article_type=41">
		<xsl:copy-of select="$tabs.page.advice" />
	</xsl:when>
	<!-- front review circle -->
	<xsl:when test="contains($article_type_name, 'frontpage_reviewcircle')">
		<xsl:copy-of select="$tabs.front.reviewcircle" />
	</xsl:when>
	<!-- submit review forum -->
	<xsl:when test="/H2G2/@TYPE='SUBMITREVIEWFORUM'">
		<xsl:copy-of select="$tabs.form.submitreviewforum" />
	</xsl:when>
	<!-- editors picks -->
	<xsl:when test="$current_article_type=59">
		<xsl:copy-of select="$tabs.page.editorspicks" />
	</xsl:when>
	<!-- anthology picks -->
	<xsl:when test="$current_article_type=62">
		<xsl:copy-of select="$tabs.page.anthology" />
	</xsl:when>
	<!-- group admin -->
	<xsl:when test="/H2G2/@TYPE='CLUB' and /H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembers'">
		<xsl:copy-of select="$tabs.group.admin" />
	</xsl:when>
	<!-- member group admin -->
	<xsl:when test="/H2G2/@TYPE='USERMYCLUBS'">
		<xsl:copy-of select="$tabs.member.group.admin" />
	</xsl:when>
	<!-- group member bulletin -->
	<xsl:when test="/H2G2/@TYPE='USERPAGE' and /H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='myactivity'">
		<xsl:copy-of select="$tabs.member.bulletin" />
	</xsl:when>
	<!-- group fromedit page -->
	<xsl:when test="/H2G2/@TYPE='CLUB' and /H2G2/MULTI-STAGE/@FINISH='YES'">
		<xsl:copy-of select="$tabs.fromedit.groups" />
	</xsl:when>
	<!-- create group -->
	<xsl:when test="/H2G2/@TYPE='CLUB' and /H2G2/MULTI-STAGE">
		<xsl:copy-of select="$tabs.form.group.create" />
	</xsl:when>
	<!-- group page -->
	<xsl:when test="/H2G2/@TYPE='CLUB' and not(/H2G2/MULTI-STAGE)">
		<xsl:copy-of select="$tabs.group.page" />
	</xsl:when>
	<!-- group index -->
	<xsl:when test="/H2G2/@TYPE='INDEX' and $searchtype=1001">
		<xsl:copy-of select="$tabs.index.group" />
	</xsl:when>
	<!-- tools index -->
	<xsl:when test="$searchtype=57">
		<xsl:copy-of select="$tabs.index.alltools" />
	</xsl:when>
	<!-- quiz index -->
	<xsl:when test="$current_article_type=65">
		<xsl:copy-of select="$tabs.index.allquizzes" />
	</xsl:when>
	<!-- craft articles index -->
	<xsl:when test="$searchtype=53 or $searchtype=56">
		<xsl:copy-of select="$tabs.index.thecraft" />
	</xsl:when>
	<!-- mini course articles index -->
	<xsl:when test="$searchtype=54 or $searchtype=55 or $searchtype=50">
		<xsl:copy-of select="$tabs.index.minicourse" />
	</xsl:when>
	<!-- tabs.timetable.minicourses -->
	<xsl:when test="$current_article_type=60">
		<xsl:copy-of select="$tabs.timetable.minicourses" />
	</xsl:when>
	<!-- tabs.calendar.eventsvideo -->
	<xsl:when test="$current_article_type=61">
		<xsl:copy-of select="$tabs.calendar.eventsvideo" />
	</xsl:when>
	<!-- index generic -->
	<xsl:when test="/H2G2/@TYPE='INDEX'">
		<xsl:copy-of select="$tabs.index.generic" />
	</xsl:when>
	<!-- search and browse-->
	<xsl:when test="/H2G2/@TYPE='CATEGORY'">
		<xsl:copy-of select="$tabs.front.search" />
	</xsl:when>
	<!-- add journal page -->
	<xsl:when test="/H2G2/@TYPE='ADDJOURNAL'">
		<xsl:copy-of select="$tabs.form.addjournal" />
	</xsl:when>
	<!-- my space page -->
	<xsl:when test="/H2G2/@TYPE='USERPAGE'">
		<xsl:copy-of select="$tabs.page.myspace" />
	</xsl:when>
	<!-- my space page -->
	<xsl:when test="/H2G2/@TYPE='ADDTHREAD'">
		<xsl:copy-of select="$tabs.page.addcomment" />
	</xsl:when>
	<!-- conversation page -->
	<xsl:when test="/H2G2/@TYPE='MULTIPOSTS' or /H2G2/@TYPE='THREADS'">
		<xsl:copy-of select="$tabs.page.conversation" />
	</xsl:when>
	<!-- useful links -->
	<xsl:when test="$current_article_type=63">
		<xsl:copy-of select="$tabs.page.usefullinks" />
	</xsl:when>
	<!-- newsletter -->
	<xsl:when test="$current_article_type=64">
		<xsl:copy-of select="$tabs.page.newsletter" />
	</xsl:when>
	<xsl:when test="$current_article_type=70">
		<xsl:copy-of select="$tabs.page.specialfeatures" />
	</xsl:when>
	
	<xsl:otherwise>
	<xsl:copy-of select="$tabs.general" />
    </xsl:otherwise>
	</xsl:choose>
	</div>	
	<img src="{$graphics}backgrounds/paper_edge.gif" width="606" height="21" border="0" alt="paper edge" />
</xsl:template>


	<xsl:template name="TABNAVIGATION">

	<xsl:choose>
	<!--///////////////// WRITE -->
	<xsl:when test="$tabgroups='write'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=10"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor"><!-- $test_IsEditor -->
	<a href="{$root}write" id="markerNavLinksOff"><xsl:if test="$current_article_type=10"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Write</a>
	</xsl:when>
	<xsl:otherwise>
	<strong>Write</strong>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$article_type_group='creative' and /H2G2/@TYPE='TYPED-ARTICLE'  or /H2G2/@TYPE='SUBMITREVIEWFORUM' or $article_type_group='creative' and /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<a id="markerNavLinksOff">
	<xsl:if test="$article_type_group='creative' and /H2G2/@TYPE='TYPED-ARTICLE' or /H2G2/@TYPE='SUBMITREVIEWFORUM' or $article_type_group='creative' and /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>
	<xsl:attribute name="href">
	<xsl:call-template name="sso_typedarticle_signin">
	<xsl:with-param name="type" select="36"/>
	</xsl:call-template>
	</xsl:attribute>
	Publish Your Work</a>
	</xsl:when>
	<xsl:otherwise>
	<strong>Publish Your Work</strong>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</td>


	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$article_type_group='advice' and /H2G2/@TYPE='TYPED-ARTICLE'"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<a id="markerNavLinksOff">
	<xsl:if test="$article_type_group='advice' and /H2G2/@TYPE='TYPED-ARTICLE'"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>
	<xsl:attribute name="href">
	<xsl:call-template name="sso_typedarticle_signin">
	<xsl:with-param name="type" select="41"/>
	</xsl:call-template>
	</xsl:attribute>Share Your Advice</a>
	</xsl:when>
	<xsl:otherwise>
	<strong>Share Your Advice</strong>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</td>


	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=15"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<a href="{$root}challenge" id="markerNavLinksOff"><xsl:if test="$current_article_type=15"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Challenges</a>
	</xsl:when>
	<xsl:otherwise>
	<strong>Challenges</strong>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</td>

	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=16"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<a href="{$root}competitions" id="markerNavLinksOff"><xsl:if test="$current_article_type=16"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Competitions</a>
	</xsl:when>
	<xsl:otherwise>
	<strong>Competitions</strong>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</td>
	<td>
	<xsl:if test="$current_article_type=16"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>

	<!--///////////// GROUPS -->
	<xsl:when test="$tabgroups='group'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap"  class="markerNavOff">
	<xsl:if test="$current_article_type=14"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}groups" id="markerNavLinksOff"><xsl:if test="$current_article_type=14"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Groups</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="/H2G2/INDEX/SEARCHTYPES/TYPE=1001"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?let=A&amp;user=on&amp;type=1001" id="markerNavLinksOff"><xsl:if test="/H2G2/INDEX/SEARCHTYPES/TYPE=1001"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Group A-Z Index</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="/H2G2/@TYPE='CLUB'"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="G?action=new" id="markerNavLinksOff"><xsl:if test="/H2G2/@TYPE='CLUB'"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Start a New Group</a>
	</xsl:element>
	</td>
	<td>
	<xsl:if test="/H2G2/@TYPE='CLUB'"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>

	<!-- ///////MINI COURSE -->
	<xsl:when test="$tabgroups='minicourse'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=17"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}minicourse" id="markerNavLinksOff"><xsl:if test="$current_article_type=17"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Mini-Courses</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$searchtype=50 or $current_article_type = 50"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="markerNavLinksOff"><xsl:if test="$searchtype=50 or $current_article_type = 50"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Beginners</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$searchtype=54 or $current_article_type = 54"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="markerNavLinksOff"><xsl:if test="$searchtype=54 or $current_article_type = 54"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Intermediate</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$searchtype=55 or $current_article_type = 55"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="markerNavLinksOff"><xsl:if test="$searchtype=55 or $current_article_type = 55"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Advanced</a>
	</xsl:element>
	</td>
	<td>
	<xsl:if test="$current_article_type=20 or $searchtype=57 or $searchtype=58"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>

		<!--/////////// CRAFT -->
	<xsl:when test="$tabgroups='craft'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=18"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}thecraft" id="markerNavLinksOff"><xsl:if test="$current_article_type=18"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>The Craft</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$searchtype=53 or $current_article_type=53"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}Index?submit=new&amp;user=on&amp;type=53&amp;let=all" id="markerNavLinksOff"><xsl:if test="$searchtype=53 or $current_article_type=53"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Craft Index</a>
	</xsl:element>
	</td>
	<td>
	<xsl:if test="$current_article_type=20 or $searchtype=53 or $searchtype=58"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>

	
	<!--/////////// LEARN -->
	<!-- <xsl:when test="$tabgroups='learn'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=11"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}learn" id="markerNavLinksOff"><xsl:if test="$current_article_type=11"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Learn</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=17 or $searchtype=54 or $searchtype=55 or $searchtype=50 or $current_article_type=51"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}minicourse" id="markerNavLinksOff"><xsl:if test="$current_article_type=17 or $searchtype=54 or $searchtype=55 or $searchtype=50 or $current_article_type=51"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Mini-Courses</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=18 or $current_article_type=56 or $current_article_type=53 or $searchtype=53 or $searchtype=56"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}thecraft" id="markerNavLinksOff"><xsl:if test="$current_article_type=18 or $current_article_type=56 or $current_article_type=53 or $searchtype=53 or $searchtype=56"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>The Craft</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=20 or $searchtype=57 or $searchtype=58"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}toolsandquizzes" id="markerNavLinksOff"><xsl:if test="$current_article_type=20 or $searchtype=57 or $searchtype=58"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Tools &amp; Quizzes</a>
	</xsl:element>
	</td>
	<td>
	<xsl:if test="$current_article_type=20 or $searchtype=57 or $searchtype=58"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when> -->
	<xsl:when test="$tabgroups='learn'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=20 or $searchtype=58"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}toolsandquizzes" id="markerNavLinksOff"><xsl:if test="$current_article_type=20 or $searchtype=58"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Tools &amp; Quizzes</a>
	</xsl:element>
	</td>

	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$searchtype=57 or $current_article_type=57"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}Index?submit=new&amp;user=on&amp;type=57&amp;let=all" id="markerNavLinksOff"><xsl:if test="$searchtype=57 or $current_article_type=57"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Tool Index</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=65"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}quizindex" id="markerNavLinksOff"><xsl:if test="$current_article_type=65"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Quiz Index</a>
	</xsl:element>
	</td>
	<!-- <td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=18 or $current_article_type=56 or $current_article_type=53 or $searchtype=53 or $searchtype=56"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}thecraft" id="markerNavLinksOff"><xsl:if test="$current_article_type=18 or $current_article_type=56 or $current_article_type=53 or $searchtype=53 or $searchtype=56"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>The Craft</a>
	</xsl:element>
	</td> -->
	
	<td>
	<xsl:if test="$current_article_type=20 or $searchtype=57 or $searchtype=58"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>


	<!--/////////// READ AND REVIEW -->
	<xsl:when test="$tabgroups='readreview'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=12"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}readandreview" id="markerNavLinksOff"><xsl:if test="$current_article_type=12"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Read</a>
	</xsl:element>
	</td>
	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=62"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}anthology" id="markerNavLinksOff"><xsl:if test="$current_article_type=62"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Anthology</a>
	</xsl:element>
	</td>

<!-- 	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=59"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}editorspicks" id="markerNavLinksOff"><xsl:if test="$current_article_type=59"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Editor's Picks</a>
	</xsl:element>
	</td> -->

	

	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=22 or $current_article_type=16 or $current_article_type=45 or $current_article_type=46 or $current_article_type=47"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}competitions" id="markerNavLinksOff"><xsl:if test="$current_article_type=22 or $current_article_type=16 or $current_article_type=45 or $current_article_type=46 or $current_article_type=47"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Past Competition Winners</a>
	</xsl:element>
	</td>

	<td nowrap="nowrap" class="markerNavOff">
	<xsl:if test="$current_article_type=70"><xsl:attribute name="class">markerNavOn</xsl:attribute></xsl:if>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}specialfeatures" id="markerNavLinksOff"><xsl:if test="$current_article_type=70"><xsl:attribute name="id">markerNavLinksOn</xsl:attribute></xsl:if>Special Features</a>
	</xsl:element>
	</td>

	<td>
	<xsl:if test="$current_article_type=59"><xsl:attribute name="class">markerNavOff</xsl:attribute></xsl:if>
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>
	<!--///////////// SEARCH -->
	<xsl:when test="$tabgroups='search' and not(/H2G2/@TYPE='CATEGORY')">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOn">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="markerNavLinksOn">Search &amp; Browse</a>
	</xsl:element>
	</td>
	<td class="markerNavOff">
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>
	<!--///////////// EVENTS AND VIDEO-->
	<xsl:when test="$tabgroups='eventsvideo' and $current_article_type!=19">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOn">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="markerNavLinksOn">Watch &amp; Listen</a>
	</xsl:element>
	</td>
	<td class="markerNavOff">
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>
	<!--///////////// MY SPACE -->
	<xsl:when test="$tabgroups='myspace' and not(/H2G2/FORUMSOURCE/@TYPE='journal')">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOn">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="markerNavLinksOn">My Space</a>
	</xsl:element>
	</td>
	<td class="markerNavOff">
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>
	<!--///////////// SITE HELP -->
	<xsl:when test="$tabgroups='help'">
	<div class="markerNav">
	<div class="markerBack">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td nowrap="nowrap" class="markerNavOn">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="markerNavLinksOn">Site Help</a>
	</xsl:element>
	</td>
	<td class="markerNavOff">
	&nbsp;
	</td>
	</tr>
	</table>
	</div>
	</div>
	</xsl:when>
	<xsl:otherwise><!-- no tab navigation --></xsl:otherwise>
	</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>
