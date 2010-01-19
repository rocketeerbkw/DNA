<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<!-- CURRENT ARTICLE TYPE -->
	<xsl:variable name="current_article_type">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

<!-- TYPE -->
	<xsl:variable name="type">
	
	<type number="1" group="creative" user="member" subtype="review" style="article" label="Work" selectnumber="89"/>
	<type number="2" group="articleeditor" user="editor" subtype="article" style="articleeditor" label="Article" />
	
	<type number="10" group="frontpage" user="editor" subtype="write" style="front3column" label="Write Front page" />
	<type number="11" group="frontpage" user="editor" subtype="learn" style="front2column" label="Learn Front page" />
	<type number="12" group="frontpage" user="editor" subtype="reviewcircle" style="front3column" label="Review Circle front page" />
	<type number="13" group="frontpage" user="editor" subtype="talk" style="front3column" label="Talk front page" />
	<type number="14" group="frontpage" user="editor" subtype="group" style="front2column" label="Group front page" />
	<type number="15" group="frontpage" user="editor" subtype="challenge" style="front2column" label="Challenge front page" />
	<type number="16" group="frontpage" user="editor" subtype="competitions" style="front2column" label="Competitions front page" />
	<type number="17" group="frontpage" user="editor" subtype="minicourse" style="front2column" label="Mini Course front page" />
	<type number="18" group="frontpage" user="editor" subtype="craft" style="front2column" label="The Craft front page" />
	 <type number="19" group="frontpage" user="editor" subtype="eventsvideo" style="front2column" label="Events &amp; Video Front page" />
	<type number="20" group="frontpage" user="editor" subtype="toolsandquizzes" style="front2column" label="Tools &amp; quizzes" />
	 <type number="21" group="frontpage" user="editor" subtype="help" style="front3column" label="Help front page" /> 
	<type number="22" group="frontpage" user="editor" subtype="competition" style="front2column" label="Competition Winners front page" /> 
	
	<type number="30" group="creative" user="member" subtype="poetry" style="article" label="Poetry" selectnumber="80" reviewforumid="19" />
	<type number="31" group="creative" user="member" subtype="shortfiction" style="article" label="Short fiction" selectnumber="81" reviewforumid="17" />
	<type number="32" group="creative" user="member" subtype="extendedwork" style="article" label="Extended Work" selectnumber="82" reviewforumid="25" />
	<type number="33" group="creative" user="member" subtype="non-fiction" style="article" label="Non-Fiction" selectnumber="83" reviewforumid="24" />
	<type number="34" group="creative" user="member" subtype="dramascripts" style="article" label="Drama Scripts" selectnumber="84" reviewforumid="20" />
	<type number="35" group="creative" user="member" subtype="forchildren" style="article" label="For Children" selectnumber="85" reviewforumid="26" />
	<type number="36" group="creative" user="member" subtype="scififantasy" style="article" label="Sci-Fi/Fantasy" selectnumber="86" reviewforumid="18" />
	<type number="37" group="creative" user="member" subtype="crimethriller" style="article" label="Crime &amp; Thriller" selectnumber="87" reviewforumid="28" />
	<type number="38" group="creative" user="member" subtype="comedyscripts" style="article" label="Comedy Scripts" selectnumber="88" reviewforumid="29" />


	<!-- 
	<type number="38" group="" user="" subtype="" style="" label="" />
	<type number="39" group="" user="" subtype="" style="" label="" />
	<type number="40" group="" user="" subtype="" style="" label="" /> -->
	

	<type number="41" group="advice" user="member" subtype="advice" style="article" label="advice article pages" />
	<type number="42" group="challenge" user="member" subtype="challenge" style="article" label="challenge article pages" />
	<type number="43" group="competition" user="editor" subtype="competition" style="articleeditor" label="competition" />
	<type number="44" group="talkpage" user="editor" subtype="talk" style="articleeditor" label="talk page" />
	<type number="45" group="competition" user="editor" subtype="competitionwinners" style="articleeditor" label="competition winners" />
	<type number="46" group="competition" user="editor" subtype="competitionrules" style="articleeditor" label="competition rules" />
	<type number="47" group="competition" user="editor" subtype="competitionarticle" style="articleeditor" label="competition winner" />
	<type number="48" group="" user="" subtype="" style="" label="" />
	<type number="49" group="" user="" subtype="" style="" label="" />
	
	<type number="50" group="minicourse" user="editor" subtype="beginnersminicourse" style="articleeditor" label="Beginners Minicourses" />
	<type number="51" group="excercise" user="member" subtype="excercise" style="article" label="Mini Course excercise" selectnumber="89" />
	<type number="52" group="seminar" user="editor" subtype="seminar" style="article" label="Seminar" />
	<type number="53" group="craft" user="editor" subtype="craftflash" style="articleeditor" label="Craft articles" />
	<type number="54" group="minicourse" user="editor" subtype="intermediateminicourse" style="articleeditor" label="Intermediate Mini Course" />
	<type number="55" group="minicourse" user="editor" subtype="advancedminicourse" style="articleeditor" label="Advanced Mini Course" />
	<type number="56" group="articleeditor" user="editor" subtype="crafttext" style="articleeditor" label="Craft articles" />
	<type number="57" group="articleeditor" user="editor" subtype="tools" style="articleeditor" label="Tools" />
	<type number="58" group="articleeditor" user="editor" subtype="quizzes" style="articleeditor" label="Quizzes" />
	<type number="59" group="articleeditor" user="editor" subtype="editorspicks" style="articleeditor" label="Editor's Picks" />
		<type number="60" group="timetable" user="editor" subtype="timetable" style="articleeditor" label="Time table" />

	<type number="61" group="eventsandvideo" user="editor" subtype="calendar" style="articleeditor" label="Calendar" />

	<type number="62" group="articleeditor" user="editor" subtype="anthology" style="articleeditor" label="Anthology" />

	<type number="63" group="articleeditor" user="editor" subtype="usefullinks" style="articleeditor" label="Useful Links" />
	<type number="64" group="articleeditor" user="editor" subtype="newsletter" style="articleeditor" label="Newsletter" />
	<type number="65" group="articleeditor" user="editor" subtype="quizindex" style="articleeditor" label="Quiz index" />
	<type number="66" group="" user="" subtype="" style="" label="" />
	<type number="67" group="" user="" subtype="" style="" label="" />
	<type number="68" group="" user="" subtype="" style="" label="" />
	<type number="69" group="" user="" subtype="" style="" label="" />
	<type number="70" group="frontpage" user="editor" subtype="specialfeatures" style="front2column" label="Special Features front page" />
	<type number="71" group="minicourse" user="editor" subtype="beginnersminicourse" style="articleeditor" label="Beginners Minicourses" />
	
	</xsl:variable>
	
	<!-- the article sub poem, shortstory etc -->
	<xsl:variable name="article_subtype">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype" />
	</xsl:variable>
	
	<!-- the article group creative, advice, minicourse, excercise -->
	<xsl:variable name="article_type_group">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@group" />
	</xsl:variable>
	
 <!-- the article label - can give a title an alternative text -->
	<xsl:variable name="article_type_label">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@label" />
	</xsl:variable>
	
	<!-- authortype -->
	<xsl:variable name="article_type_user">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@user" />
	</xsl:variable>
	
	<!--reviewforum -->
	<xsl:variable name="article_reviewforum">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@reviewforumid" />
	</xsl:variable>
	
	<!-- concat of user, group and subtype - useful for conditioning -->
	<xsl:variable name="article_type_name">
	<xsl:value-of select="concat($article_type_user, '_', $article_type_group,'_', $article_subtype)" />
	</xsl:variable>
	
	<!-- subtype and group concatenated -->
	<xsl:variable name="article_subtype_group">
	<xsl:value-of select="$article_subtype" /><xsl:text>  </xsl:text><xsl:value-of select="$article_type_group" />
	</xsl:variable>
	
	<!-- layout -->
	<xsl:variable name="layout_type">
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@style" />
	</xsl:variable>
	
	<!-- selected -->
	<xsl:variable name="selected_member_type">
	
		<xsl:choose>
		<xsl:when test="$selected_status='on'">
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@number" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@selectnumber" />
		</xsl:otherwise>
		</xsl:choose>
				
	</xsl:variable>
	
	<!-- set to selected when the current article type equals a selected number value-->
	<xsl:variable name="selected_status">
	<xsl:choose>
		<xsl:when test="msxsl:node-set($type)/type[@selectnumber=$current_article_type]">on</xsl:when>
		</xsl:choose>
	</xsl:variable>
		
	<!-- editor or user -->
	<xsl:variable name="article_authortype">
		<xsl:choose>
<!-- 			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">you</xsl:when> -->
			<xsl:when test="$ownerisviewer=1">you</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1">editor</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3">member</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">editor</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="num" select="EXTRAINFO/TYPE/@ID" />
	<xsl:variable name="article_subtype_userpage">
	 <xsl:value-of select="msxsl:node-set($type)/type[@number=$num]/@subtype" />
	</xsl:variable>


</xsl:stylesheet>
