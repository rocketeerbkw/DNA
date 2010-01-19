<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes"
        xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:variable name="current_article_type">
                <xsl:choose>
                        <xsl:when
                                test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
                                <xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="type">
                <type group="article" label="review" number="1" style="layout_a" subtype="review" user=""/>
                <type group="article" label="portfolio page" number="2" style="layout_c" subtype="page" user="member"/>
                <type group="article" label="page" number="3" style="layout_a" subtype="page" user="editor"/>
                <type group="article" label="review" number="20" style="layout_a" subtype="picture" user="editor"/>
                <!--=============== Front Pages =====================-->
                <type group="category" label="category page" number="4001" style="" subtype="" user="editor"/>
                <type group="frontpage" label="watch and listen" number="4" style="layout_a" subtype="watchandlisten"
                        user="editor"/>
                <type group="frontpage" label="reviews" number="5" style="layout_a" subtype="reviews" user="editor"/>
                <type group="frontpage" label="recommended" number="6" style="layout_a" subtype="recommended"
                        user="editor"/>
                <type group="frontpage" label="features" number="7" style="layout_a" subtype="features" user="editor"/>
                <type group="frontpage" label="community" number="8" style="layout_a" subtype="community" user="editor"/>
                <type group="frontpage" label="find" number="9" style="layout_a" subtype="find" user="editor"/>
                <!--===============Article Types =====================-->
                <!-- member reviews -->
                <type group="review" label="general review" number="10" selectnumber="25" style="layout_c"
                        subtype="review" user="member"/>
                <type category="1074" group="review" label="album review" number="11" selectnumber="26" style="layout_c"
                        subtype="album" user="member"/>
                <type category="1073" group="review" label="cinema review" number="12" selectnumber="27"
                        style="layout_c" subtype="film" user="member"/>
                <type category="54668" group="review" label="art review" number="13" selectnumber="28" style="layout_c"
                        subtype="art" user="member"/>
                <type category="54667" group="review" label="book review" number="14" selectnumber="29" style="layout_c"
                        subtype="book" user="member"/>
                <type category="974" group="review" label="game review" number="15" selectnumber="30" style="layout_c"
                        subtype="game" user="member"/>
                <type category="1075" group="review" label="tv review" number="16" selectnumber="31" style="layout_c"
                        subtype="tv" user="member"/>
                <type category="1075" group="review" label="comedy review" number="17" selectnumber="32"
                        style="layout_c" subtype="comedy" user="member"/>
                <type category="1074" group="review" label="gig review" number="18" selectnumber="33" style="layout_c"
                        subtype="gig" user="member"/>
                <type category="1073" group="review" label="dvd review" number="19" selectnumber="34" style="layout_c"
                        subtype="dvd" user="member"/>
                <!-- member features -->
                <!-- editor reviews -->
                <type group="review" label="review" number="40" style="layout_a" subtype="review" user="editor"/>
                <type group="review" label="album review" number="41" style="layout_b" subtype="album" user="editor"/>
                <type group="review" label="film review" number="42" style="layout_a" subtype="film" user="editor"/>
                <type group="review" label="art review" number="43" style="layout_a" subtype="art" user="editor"/>
                <type group="review" label="book review" number="44" style="layout_b" subtype="book" user="editor"/>
                <type group="review" label="game review" number="45" style="layout_a" subtype="game" user="editor"/>
                <type group="review" label="tv review" number="46" style="layout_a" subtype="tv" user="editor"/>
                <type group="review" label="comedy review" number="47" style="layout_a" subtype="comedy" user="editor"/>
                <type group="review" label="gig review" number="48" style="layout_b" subtype="gig" user="editor"/>
                <type group="review" label="dvd review" number="49" style="layout_b" subtype="dvd" user="editor"/>
                <!-- editor features -->
                <!-- below more culture -->
                <type group="feature" label="feature" number="55" style="layout_a" subtype="feature" user="editor"/>
                <type group="feature" label="music feature" number="56" style="layout_a" subtype="music" user="editor"/>
                <type group="feature" label="film feature" number="57" style="layout_a" subtype="film" user="editor"/>
                <!-- editor interview -->
                <type group="interview" label="interview" number="70" style="layout_a" subtype="interview" user="editor"/>
                <type group="interview" label="music interview" number="71" style="layout_a" subtype="music"
                        user="editor"/>
                <type group="interview" label="film interview" number="72" style="layout_a" subtype="film" user="editor"/>
                <!-- editorcolumn -->
                <type group="column" label="column" number="85" style="layout_a" subtype="column" user="editor"/>
                <type group="column" label="music column" number="86" style="layout_a" subtype="music" user="editor"/>
                <type group="column" label="film column" number="87" style="layout_a" subtype="film" user="editor"/>
                <type group="column" label="game column" number="88" style="layout_a" subtype="game" user="editor"/>
                <type group="column" label="tv column" number="89" style="layout_a" subtype="tv" user="editor"/>
                <!-- archive and backissues -->
                <type group="archive" label="back issues" number="100" style="" subtype="backissues" user="editor"/>
                <type group="archive" label="all back issues" number="101" style="" subtype="allbackissues"
                        user="editor"/>
                <!-- member feature -->
                <type group="feature" label="member feature" number="120" style="layout_a" subtype="feature"
                        user="member"/>
        </xsl:variable>
        <!-- the article sub type film, book etc -->
        <xsl:variable name="article_subtype">
                <xsl:value-of
                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype"
                />
        </xsl:variable>
        <!-- the article group review, feature etc -->
        <xsl:variable name="article_type_group">
                <xsl:value-of
                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@group"
                />
        </xsl:variable>
        <!-- the article label - can give a title an alternative text -->
        <xsl:variable name="article_type_label">
                <xsl:value-of
                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@label"
                />
        </xsl:variable>
        <!-- authortype -->
        <xsl:variable name="article_type_user">
                <xsl:value-of
                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@user"
                />
        </xsl:variable>
        <!-- concat of user, group and subtype - useful for conditioning -->
        <xsl:variable name="article_type_name">
                <xsl:value-of select="concat($article_type_user, '_', $article_type_group,'_', $article_subtype)"/>
        </xsl:variable>
        <!-- subtype and group concatenated -->
        <xsl:variable name="article_subtype_group">
                <xsl:value-of select="$article_subtype"/>
                <xsl:text>  </xsl:text>
                <xsl:value-of select="$article_type_group"/>
        </xsl:variable>
        <!-- layout -->
        <xsl:variable name="layout_type">
                <xsl:value-of
                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@style"
                />
        </xsl:variable>
        <!-- selected -->
        <xsl:variable name="selected_member_type">
                <xsl:choose>
                        <xsl:when test="$selected_status='on'">
                                <xsl:value-of
                                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@number"
                                />
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of
                                        select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@selectnumber"
                                />
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
        <xsl:variable name="num" select="EXTRAINFO/TYPE/@ID"/>
        <xsl:variable name="article_subtype_userpage">
                <xsl:value-of select="msxsl:node-set($type)/type[@number=$num]/@subtype"/>
        </xsl:variable>
</xsl:stylesheet>
