<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
    <xsl:import href="pagetype.xsl"/>

	<xsl:variable name="type">
		<!--=============== General Pages ===============================================-->	
    		<type number="1" group="default" user="editor" subtype="default" label="Default" />
    		<type number="2" group="article" user="editor" subtype="editorial" label="Editorial" />
		<type number="10" group="memory" user="member" subtype="user_memory" label="Memory"/>
		<type number="15" group="memory" user="editor" subtype="staff_memory" label="Staff Memory" />
		<type number="3001" group="article" user="member" subtype="profile" label="Member Profile" />
	</xsl:variable>


	<xsl:variable name="current_article_type">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE = 1">
						<xsl:choose>
							<xsl:when test="$test_IsAdminUser">15</xsl:when>
							<xsl:otherwise>10</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
					</xsl:otherwise>
				</xsl:choose>
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
		
	<!-- the article sub type  -->
	<xsl:variable name="article_subtype">
		<xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype" />
	</xsl:variable>
	
</xsl:stylesheet>
