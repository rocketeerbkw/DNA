<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY copy "&#169;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="node()" mode="body">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="br | BR | P | p | B | b  | SUB | sub | SUP | sup | DIV | div | USEFULLINKS | lang | LANG | abbreviation | ABBREVIATION | acronym | ACRONYM | em | EM | strong | STRONG | cite | CITE | q | Q | I | i | SMALL | small | CODE | code">
		<xsl:copy>	
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<!--
	<xsl:template match="BR[preceding-sibling::BR[1]]"><xsl:comment>BR</xsl:comment></xsl:template>
	-->
	
	<!--
	<xsl:template match="node()[preceding-sibling::BR[1]][not(self::BR)][not(self::QUOTE)][not(ancestor::CITE)][not(self::VIDEO)][not(self::AUDIO)][not(self::LINK)][not(self::A)][not(self::TABLE)][not(self::TH)][not(self::TD)][not(self::P)][not(self::TABLETITLE)][not(self::TABLESUBTITLE)]">
	-->
	<!--
	<xsl:template match="text()[preceding-sibling::BR[1]]">
	-->
	<!--
		<p><xsl:value-of select="."/></p>
	</xsl:template>
	-->

	<xsl:template match="HEADER | SUBHEADER | FORM | form | INPUT | input | SELECT | select | TABLE | table | TD | td | TH | th | TR | FONT| font | OL | ol | UL | ul | LI | li  | U | u | MARQUEE| marquee |CENTER | center | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="TEXTAREA">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template>
	<xsl:template match="IMG">
		<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
			<xsl:if test="not(starts-with(@SRC,'http://'))">
				<xsl:copy>
					<xsl:apply-templates select="*|@*|text()"/>
				</xsl:copy>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="OBJECT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="EMBED">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="SCRIPT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@COLOR">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@WIDTH">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@HEIGHT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@ALIGN">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="PICTURE">
		<!-- do nothing -->
	</xsl:template>
	
	
	<xsl:template match="A">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<xsl:copy use-attribute-sets="mA">
					<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|@CLASS|text()"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="LINK">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!--
	<xsl:template match="LINK">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<a>
				<xsl:apply-templates select="@DNAID | @HREF"/>
				<xsl:call-template name="dolinkattributes"/>
				<xsl:value-of select="./text()" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->
	
	<xsl:template match="LINK">
		<a>
		<xsl:apply-templates select="@DNAID | @HREF"/>
		<xsl:call-template name="dolinkattributes"/>
        <xsl:value-of select="./text()" />
		</a>
	</xsl:template>
	
	<xsl:template match="LINK | A | a" mode="truncate">
		<a>
		<xsl:apply-templates select="@DNAID | @HREF"/>
		<xsl:call-template name="dolinkattributes"/>
		<xsl:call-template name="TRUNCATE_TEXT">
			<xsl:with-param name="text" select="./text()" />
			<xsl:with-param name="new_length" select="$links_max_length"/>
		</xsl:call-template>
		</a>
	</xsl:template>

	<!--
	<xsl:template match="SMILEY">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>
	</xsl:template>
	-->
	<!-- override from base -->
	<!--
	<xsl:template match="SMILEY">
		<img border="0" alt="{@TYPE}" title="{@TYPE}">
			<xsl:choose>
				<xsl:when test="@TYPE='fish' and number(../../USER/USERID) = 23">
					<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>s_fish.gif</xsl:attribute>
					<xsl:attribute name="alt">Shim's Blue Fish</xsl:attribute>
					<xsl:attribute name="title">Shim's Blue Fish</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="src"><xsl:value-of select="$smileysource606"/>f_<xsl:value-of select="@TYPE"/>.gif</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</img>
		<xsl:text> </xsl:text>
	</xsl:template>
	-->
	
	<xsl:template match="UL">
		<ul class="text"><xsl:apply-templates/></ul>
	</xsl:template>
	
	<xsl:template match="LI">
		<li><xsl:apply-templates/></li>
	</xsl:template>
	
	
	<xsl:template match="COL2">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="TABLETITLE">
		<div class="tableTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="TABLESUBTITLE">
		<div class="tableSubTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="TABLE">
		<table border="0" class="userTable" cellspacing="0">
			<xsl:apply-templates select="*|@*|text()"/>
		</table>
	</xsl:template>
	
	<xsl:template match="TR | TH | TD">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="TR/TH[1]">
		<th class="first"><xsl:apply-templates/></th>
	</xsl:template>
	
	<xsl:template match="TR/TD[1]">
		<td class="first"><xsl:apply-templates select="*|@*|text()"/></td>
	</xsl:template>
	
	<xsl:template match="QUOTE">
        <xsl:choose>
            <xsl:when test="not(./ancestor::TEXT)">
                <xsl:variable name="raw_class">
                    <xsl:choose>
                        <xsl:when test="@align">
                            <xsl:value-of select="@align"/>
                            <xsl:text>quote</xsl:text>
                        </xsl:when>
                        <xsl:when test="@ALIGN">
                            <xsl:value-of select="@ALIGN"/>
                            <xsl:text>quote</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>quote</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <div>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$raw_class"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
	        </xsl:when>
            <xsl:otherwise>
                <p><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<xsl:template match="QUOTE/P">
		<span class="q1"></span><xsl:value-of select="."/><span class="q2"></span>
	</xsl:template>
	
	<xsl:template match="CITE">
		<cite><xsl:apply-templates/></cite>
	</xsl:template>

	<xsl:template match="VIDEO">
		<div class="avlink">
		<a onClick="javascript:launchAVConsoleStory('{@STORYID}'); return false;" href="http://news.bbc.co.uk/sport1/hi/video_and_audio/help_guide/4304501.stm">
			<img src="http://newsimg.bbc.co.uk/sol/shared/img/v3/videosport.gif" align="left" width="60" height="13" alt="" border="0" vspace="1"/><b><xsl:value-of select="CAPTION"/></b>
		</a>
		</div>
	</xsl:template>
	
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
                <!--[FIXME: remove]
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sort']/VALUE = 'title'">
						a-z title
					</xsl:when>
					<xsl:otherwise>
						<a href="?s_sort=title">a-z title</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> | </xsl:text>
				-->

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
					<img src="{$imagesource}stars/lists/neutral/{round(POLL-LIST/POLL/STATISTICS/@AVERAGERATING)}.gif" width="78" height="12" alt="{round(POLL-LIST/POLL/STATISTICS/@AVERAGERATING)} stars" /> average rating from <xsl:value-of select="POLL-LIST/POLL/STATISTICS/@VOTECOUNT"/> members
				</div>
			</xsl:if>
			
			
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/DATECREATED"/>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" />
		</li>
		
</xsl:template>
	
<xsl:template match="INCLUDE">
		<xsl:comment>#include virtual="<xsl:value-of select="@SRC" />"</xsl:comment>
</xsl:template>

</xsl:stylesheet>