<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!-- dynamic lists -->
<xsl:template match="DYNAMIC-LIST">
	<xsl:variable name="listname">
			<xsl:value-of select="@NAME" />
	</xsl:variable>
	<xsl:variable name="listlength">
		<xsl:choose>
			<xsl:when test="@LENGTH &gt; 0">
				<xsl:value-of select="@LENGTH" />
			</xsl:when>
			<xsl:otherwise>
			100
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<xsl:if test="count(/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM) &gt; 1">
	<!-- only display sort box if there is more than 1 item -->
		<div class="headingbox">
			<h3>Sort by</h3> 
			<p class="links">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
						a-z title
					</xsl:when>
					<xsl:otherwise>
						<a href="?s_sort=title">a-z title</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				
				<xsl:if test="@SPORTS='multiple'"><!-- only sortable by sport if multiple sports -->
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'sport'">
						sport
					</xsl:when>
					<xsl:otherwise>
						<a href="?s_sort=sport">sport</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'date'">
						date
					</xsl:when>
					<xsl:otherwise>
						<a href="?s_sort=date">date</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'rating'">
						rating
					</xsl:when>
					<xsl:otherwise>
						<a href="?s_sort=rating">rating</a>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</div>
	</xsl:if>
	
	
	<xsl:choose>
		<xsl:when test="not(/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM)">
			<p class="nofavourites">There is no recent content in this category that has been highly-rated. Click on one of the links on the right to write something on this topic</p>
		</xsl:when>
		<xsl:otherwise>
			<ul class="striped bodylist">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default">
							<xsl:sort select="ARTICLE-ITEM/SUBJECT" data-type="text"/>		
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'sport'">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default">
							<xsl:sort select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/SPORT" data-type="text"/>		
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'date'">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default">
							<xsl:sort select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/DATECREATED" data-type="number" order="descending"/>		
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'rating'">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default">
							<xsl:sort select="POLL-LIST/POLL/STATISTICS/@AVERAGERATING" data-type="text" order="descending"/>		
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default"/>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
		</xsl:otherwise>
	</xsl:choose>
	
	
</xsl:template>


<xsl:template match="ITEM-LIST/ITEM" mode="dynamiclist_default">
	
	<xsl:variable name="oddoreven">
		<xsl:choose>
			<xsl:when test="position() mod 2 != 0">odd</xsl:when>
			<xsl:otherwise>even</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<li><xsl:attribute name="class">
				<xsl:value-of select="$oddoreven"/>
			</xsl:attribute>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/MANAGERSPICK/text()">
				<xsl:with-param name="oddoreven" select="$oddoreven"/>
			</xsl:apply-templates>
			
			<div class="articletitle"><a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a></div>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTHORUSERID"/>
			
			<div class="articledetals">
				<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/SPORT"/> <xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/COMPETITION/text()"/> <xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE"/>
			</div>
			
			
			<!-- rating -->
			<xsl:if test="POLL-LIST/POLL/STATISTICS/@VOTECOUNT &gt; 0">
				<div class="articlerating">
					<img src="{$imagesource}stars/lists/{$oddoreven}/{round(POLL-LIST/POLL/STATISTICS/@AVERAGERATING)}.gif" width="78" height="12" alt="{round(POLL-LIST/POLL/STATISTICS/@AVERAGERATING)} stars" /> average rating from <xsl:value-of select="POLL-LIST/POLL/STATISTICS/@VOTECOUNT"/> members
				</div>
			</xsl:if>
			
			
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/DATECREATED"/>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" />
		</li>
		
</xsl:template>
	

</xsl:stylesheet>
