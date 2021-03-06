<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<xsl:variable name="type">
	<!--=============== General Pages ===============================================-->	
    	<type number="1" group="main" user="editor" subtype="editorial" label="editorial" />
		<type number="2" group="main" user="member" subtype="personal" label="personal" />
		
		<type number="3" group="assetlibrary" user="editor" subtype="editorial" label="editorial" />
		
		
	
	<!--=============== User Based Article Types ====================================-->
		<type number="10" group="mediasset" user="member" subtype="image" label="Image" />
		<type number="11" group="mediasset" user="member" subtype="audio" label="Audio"  />
		<type number="12" group="mediasset" user="member" subtype="video" label="Video &amp; Animation" />	
	
	<!--=============== Editor Based Article Types ====================================-->
		<type number="30" group="index" user="editor" subtype="latest" label="The Latest" />
		<type number="31" group="index" user="editor" subtype="submitarticle" label="Submit Content Index" />
		<type number="32" group="index" user="editor" subtype="submitasset" label="Submit Asset Index" />
		<type number="33" group="index" user="editor" subtype="programmechallenge" label="Programme Challenges Index" />	
		
	<!--=============== Programme Challenge Types ====================================-->
		<type number="4001" group="programmechallenge" user="member" subtype="article" label="Programme Challenge Category Article"/>

		<type number="100" group="programmechallenge" user="member" subtype="image" label="image">
			<mediatype number="10" label="image"/>
		</type>
		<type number="101" group="programmechallenge" user="member" subtype="audio" label="audio">
			<mediatype number="11" show="audio" label="audio"/>
		</type>
		<type number="102" group="programmechallenge" user="member" subtype="video" label="video &amp; animation">
			<mediatype number="12" show="video" label="video &amp; animation"/>
		</type>		
		<type number="103" group="programmechallenge" user="member" subtype="image-audio" label="image or audio">
			<mediatype number="10" label="image"/>
			<mediatype number="11" show="audio" label="audio"/>
		</type>		
		<type number="104" group="programmechallenge" user="member" subtype="image-video" label="image or video &amp; animation">
			<mediatype number="10" label="image"/>
			<mediatype number="12" show="video" label="video &amp; animation"/>
		</type>
		<type number="105" group="programmechallenge" user="member" subtype="audio-video" label="audio or video &amp; animation">
			<mediatype number="11" show="audio" label="audio"/>
			<mediatype number="12" show="video" label="video &amp; animation"/>
		</type>
		<type number="106" group="programmechallenge" user="member" subtype="image-audio-video" label="image or audio or video &amp; animation">
			<mediatype number="10" label="image"/>
			<mediatype number="11" show="audio" label="audio"/>
			<mediatype number="12" show="video" label="video &amp; animation"/>
		</type>
	</xsl:variable>


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

	
	<!-- the article group -->
	<xsl:variable name="article_type_group">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@group" />
	</xsl:variable>
	
	<!-- authortype -->
	<xsl:variable name="article_type_user">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@user" />
	</xsl:variable>
		
	<!-- the article sub type: image, audio, video etc -->
	<xsl:variable name="article_subtype">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype" />
	</xsl:variable>
	
 	<!-- the article label - can give a title an alternative text -->
	<xsl:variable name="article_type_label">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@label" />
	</xsl:variable>
	
	
	<!--
	##################################################################
		WHICH OF THE FOLLOWING WILL BE NEEDED
	##################################################################
	 -->
	
	
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
