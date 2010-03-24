<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
    <xsl:import href="pagetype.xsl"/>

	<xsl:variable name="type">
	<!--=============== General Pages ===============================================-->	
    	<type number="1" group="favourite" user="editor" subtype="dynamiclist" label="Favourites" />
		<type number="2" group="general" user="editor" subtype="info" label="" />
		<type number="4" group="general" user="editor" subtype="popup" label="" />
		
		<type number="10" group="article" user="member" subtype="user_article" label="Article"/>
		<type number="11" group="report" user="member" subtype="match_report" label="Match article" />
		<type number="12" group="report" user="member" subtype="event_report" label="Event article" />
		<type number="13" group="profile" user="member" subtype="player_profile" label="Player profile" />
		<type number="14" group="profile" user="member" subtype="team_profile" label="Team profile" />
		<type number="15" group="article" user="editor" subtype="staff_article" label="Article" />
	</xsl:variable>


	<xsl:variable name="current_article_type">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_editorial']/VALUE or (/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE != '1' and /H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE != '')">
						<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$default_article_type"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="test_current_article_type">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_editorial']/VALUE or (/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE != '1' and /H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE != '')">
						<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>null</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="default_article_type">
		<xsl:choose>
			<xsl:when test="$test_IsEditor">15</xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- the article group -->
	<xsl:variable name="article_type_group">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@group" />
	</xsl:variable>
	
	<!-- authortype -->
	<xsl:variable name="article_type_sport">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@sport" />
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

    <!-- identity template -->
    <xsl:template match="@*|node()" mode="identity">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()" mode="identity"/>
      </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
