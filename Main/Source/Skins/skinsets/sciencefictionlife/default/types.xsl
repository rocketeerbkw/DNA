<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


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


	<xsl:variable name="type">
	
		<!-- categories: book, comic, film, radio, tv, other -->
		<!-- themes: catastrophe, dystopia, evolution, origins, religion, sex -->



		<type number="1" group="article" user="editor" subtype="general" style="" label="Article page" />
		<type number="3" group="article" user="editor" subtype="page" style="layout_a" label="page"/>

		<type number="4001" group="category" user="editor" subtype="" style="" label="category page" />

		<type number="4" group="article" user="editor" subtype="feature" style="" label="feature" />
		<type number="5" group="article" user="editor" subtype="interview" style="" label="interview" />
		
		<type number="12" group="article" user="editor" subtype="dump" style="" label="article dump" />

		<type number="13" group="category" user="editor" subtype="book" style="" label="Book" />
		<type number="14" group="category" user="editor" subtype="comic" style="" label="Comic" />
		<type number="15" group="category" user="editor" subtype="film" style="" label="Film" />
		<type number="16" group="category" user="editor" subtype="radio" style="" label="Radio" />
		<type number="17" group="category" user="editor" subtype="tv" style="" label="TV" />
		<type number="18" group="category" user="editor" subtype="other" style="" label="Other" />
		<type number="19" group="category" user="editor" subtype="person" style="" label="Person" />
		<!-- <type number="20" group="category" user="editor" subtype="catastrophe" style="" label="Catastrophe" />
		<type number="21" group="category" user="editor" subtype="dystopia" style="" label="Dystopia" />
		<type number="22" group="category" user="editor" subtype="evolution" style="" label="Evolution" />
		<type number="23" group="category" user="editor" subtype="origins" style="" label="Origins and Development" />
		<type number="24" group="category" user="editor" subtype="religion" style="" label="Religion" />
		<type number="25" group="category" user="editor" subtype="sex" style="" label="Sex" /> -->
		<type number="26" group="category" user="editor" subtype="theme" style="" label="Themes" />

		<type number="30" group="article" user="member" subtype="book" style="" label="Book" />
		<type number="31" group="article" user="member" subtype="comic" style="" label="Comic" />
		<type number="32" group="article" user="member" subtype="film" style="" label="Film" />
		<type number="33" group="article" user="member" subtype="radio" style="" label="Radio" />
		<type number="34" group="article" user="member" subtype="tv" style="" label="TV" />
		<type number="35" group="article" user="member" subtype="other" style="" label="Other" />
		<type number="36" group="article" user="editor" subtype="person" style="" label="Person" />
		<type number="37" group="article" user="editor" subtype="theme" style="" label="Theme" />

	
	</xsl:variable>
	
	<!-- the article sub type film, book etc -->
	<xsl:variable name="article_subtype">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype" />
	</xsl:variable>
	
	<!-- the article group review, feature etc -->
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
			<xsl:when test="$article_type_user='member' and $article_type_group='feature'">member</xsl:when>
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
