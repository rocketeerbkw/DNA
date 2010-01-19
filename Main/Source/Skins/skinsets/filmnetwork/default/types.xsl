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
<type number="1" group="article" user="editor" subtype="general" style="" label="Article page" />

<type number="10" group="frontpage" user="editor" subtype="discussion" style="" label="discussion" />
<type number="11" group="frontpage" user="editor" subtype="guide" style="" label="filmmakers' guide" />
<type number="12" group="frontpage" user="editor" subtype="filmsubmission" style="" label="film submission" />


<type number="13" group="category" user="editor" subtype="drama" style="" label="drama" />
<type number="14" group="category" user="editor" subtype="comedy" style="" label="comedy" />
<type number="15" group="category" user="editor" subtype="documentary" style="" label="documentary" />
<type number="16" group="category" user="editor" subtype="animation" style="" label="animation" />
<type number="17" group="category" user="editor" subtype="experimental" style="" label="experimental" />
<type number="18" group="category" user="editor" subtype="music" style="" label="music" />

<type number="30" group="film" user="member" subtype="drama" style="" label="drama" />
<type number="31" group="film" user="member" subtype="comedy" style="" label="comedy" />
<type number="32" group="film" user="member" subtype="documentary" style="" label="documentary" />
<type number="33" group="film" user="member" subtype="animation" style="" label="animation" />
<type number="34" group="film" user="member" subtype="experimental" style="" label="experimental" />
<type number="35" group="film" user="member" subtype="music" style="" label="music" />

<type number="50" group="declined" user="member" subtype="drama" style="" label="drama" />
<type number="51" group="declined" user="member" subtype="comedy" style="" label="comedy" />
<type number="52" group="declined" user="member" subtype="documentary" style="" label="documentary" />
<type number="53" group="declined" user="member" subtype="animation" style="" label="animation" />
<type number="54" group="declined" user="member" subtype="experimental" style="" label="experimental" />
<type number="55" group="declined" user="member" subtype="music" style="" label="music" />

<type number="60" group="article" user="editor" subtype="discussion" style="" label="discussion page" />
<type number="61" group="article" user="editor" subtype="knowledgetopic" style="" label="filmmakers' guide" />
<type number="62" group="features" user="editor" subtype="features" style="" label="Magazine frontpage" />
<type number="63" group="features" user="editor" subtype="features" style="" label="Magazine page" />
<type number="64" group="news" user="editor" subtype="news" style="" label="News page" />

<type number="70" group="credit" user="member" subtype="drama" style="" label="drama" />
<type number="71" group="credit" user="member" subtype="comedy" style="" label="comedy" />
<type number="72" group="credit" user="member" subtype="documentary" style="" label="documentary" />
<type number="73" group="credit" user="member" subtype="animation" style="" label="animation" />
<type number="74" group="credit" user="member" subtype="experimental" style="" label="experimental" />
<type number="75" group="credit" user="member" subtype="music" style="" label="music" />

<type number="90" group="notes" user="member" subtype="drama" style="" label="drama" />
<type number="91" group="notes" user="member" subtype="comedy" style="" label="comedy" />
<type number="92" group="notes" user="member" subtype="documentary" style="" label="documentary" />
<type number="93" group="notes" user="member" subtype="animation" style="" label="animation" />
<type number="94" group="notes" user="member" subtype="experimental" style="" label="experimental" />
<type number="95" group="notes" user="member" subtype="music" style="" label="music" />

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
