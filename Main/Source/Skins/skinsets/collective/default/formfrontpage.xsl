<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EDITOR_FRONTPAGE">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITOR_FRONTPAGE</xsl:with-param>
	<xsl:with-param name="pagename">formfrontpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		<!-- FORM HEADER -->
		<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your <xsl:value-of select="$article_type_group" /></strong>
				</xsl:element>
			</div>
		</xsl:if>
		
		<!-- FORM BOX -->
		<div class="form-wrapper">
		<a name="edit" id="edit"></a>
	    <input type="hidden" name="_msfinish" value="yes"/>
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									FRONT PAGE FORM
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<input type="hidden" name="_msxml" value="{$frontpagearticlefields}"/>

	<table>
	<tr>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Title:</b></xsl:element><br />
	<xsl:apply-templates select="." mode="t_articletitle"/>
	</td>
	<td>	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Front page type</b></xsl:element><br />
	<xsl:apply-templates select="." mode="r_articletype"> 
	<xsl:with-param name="group" select="$article_type_group" />
	<xsl:with-param name="user" select="$article_type_user" />
	</xsl:apply-templates> 
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Body:</b></xsl:element><br />
	<xsl:apply-templates select="." mode="t_articlebody"/>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Description:</b></xsl:element><br />
	<textarea name="DESCRIPTION" ID="DESCRIPTION" cols="65" rows="5">
	
	<xsl:choose>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='features'">Indepth features on the best new arts and culture, including interviews, exclusive sessions, audio and video.</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='recommended'">BBC Collective recommendations for music, books, art, films, dvds</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='reviews'">Top journalists and Collective members chew over the best new music, film, art, books and culture.</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='watchandlisten'">View film trailers and clips, videos, animations and art galleries and listen to underground music , playlists, FULL album tracks and exclusive sessions</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='talk'">Find out what our members have been up to. Pictures, music tracks, reviews and discussion.</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='community'">The Collective community hub: write reviews, submit photos, start conversations and more</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
	</xsl:otherwise>
	</xsl:choose>
	</textarea><br /><br />
	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Keywords:</b></xsl:element><br />
	<textarea name="KEYWORDS" ID="KEYWORDS" cols="65" rows="5">
	<xsl:choose>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='features'">music sessions, band interviews, director interviews, music interviews, film interviews, record label profiles</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='recommended'">recommended music, new music, recommended albums, recommended films, recommended cinema, recommended dvds, recommended art, recommended books</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='reviews'">music reviews, film reviews, art reviews, comic reviews, book reviews, rap, hip hop, electronica, dance music, reggae, hip-hop, mc, garage, rock, alternative rock, indy rock, indie, acoustic, folktronica, jazz, nu-jazz, afrobeat, techno, house, electroclash, punk, post punk, new wave, funk, art reviews, exhibition reviews, paperback reviews, single reviews, album reviews, albums, live reviews, write reviews, member reviews, gig reviews, cinema reviews, dvd reviews, arthouse films, art house, CD reviews, cds, playlists. community reviews</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='watchandlisten'">listen to music, watch trailers, film trailers, cinema clips, film clips, music videos, trailers, clips, playlists, streaming music, music cds, broadband music, broadband films, image galleries, art galleries</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='talk'">community members, online community, cultural forum, discussion forum, discuss culture, talk</xsl:when>
	<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' and $article_subtype='community'">community, members, member, get involved, member photos, member projects, member portfolio, member art, talk,member tracks</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
	</xsl:otherwise>
	</xsl:choose>
	</textarea>
	</td>
	</tr>
	</table>

	<!--EDIT BUTTONS --> 
	
	<!-- STATUS -->
	<div>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/>
	</div>
	
	<!-- HIDE ARTICLE -->
	<div><xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_hidearticle"/></div>
	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
		
	<!-- DELETE ARTICLE commented out as per request Matt W 13/04/2004 -->
	   <!-- <xsl:apply-templates select="." mode="c_deletearticle"/> -->
	</div>

		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>


		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>

		</tr>
	</table>
	</xsl:template>
	
</xsl:stylesheet>
