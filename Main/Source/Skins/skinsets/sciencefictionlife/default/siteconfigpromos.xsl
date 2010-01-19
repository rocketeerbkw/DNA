<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">



<xsl:template name="SITECONFIGPROMOS">
<xsl:choose>

	<!-- music interview or music feature -->
	<xsl:when test="$article_type_name='editor_interview_music' or $article_type_name='editor_feature_music'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO1" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/ALBUMWEEK" />
	</xsl:when>
	
	<!-- film interview or film feature -->	
	<xsl:when test="$article_type_name='editor_interview_film' or $article_type_name='editor_feature_film'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/CINEMAWEEK" />
	</xsl:when>
	
	<!-- interview -->	
	<xsl:when test="$article_type_name='editor_interview_interview'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTURE" />
	</xsl:when>
	
	<!-- feature -->	
	<xsl:when test="$article_type_name='editor_feature_feature'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/PROMO3" />
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTURE" />
	</xsl:when>
	
	<!-- general review -->	
	<xsl:when test="$article_type_name='editor_review_review'">
	<xsl:apply-templates select="/H2G2/SITECONFIG/PROMO3" />
	</xsl:when>
	
	<!-- album review -->	
	<xsl:when test="$article_type_name='editor_review_album'">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
	</xsl:when>
	
	<!-- cinema review or dvd review -->	
	<xsl:when test="$article_type_name='editor_review_film' or $article_type_name='editor_review_dvd'">
	<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
	</xsl:when>
	
	<!-- art review or book review or game review or tv review or comedy review -->	
	<xsl:when test="$article_type_name='editor_review_art' or $article_type_name='editor_review_book' or $article_type_name='editor_review_game' or $article_type_name='editor_review_tv' or $article_type_name='editor_review_comedy'">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
	</xsl:when>
	
	<!-- gig review -->	
	<xsl:when test="$article_type_name='editor_review_gig'">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
	</xsl:when>
	
	<!-- column -->	
	<xsl:when test="$article_type_name='editor_column_column'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
	</xsl:when>
	
	<!-- music column -->	
	<xsl:when test="$article_type_name='editor_column_music'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/ALBUMWEEK" />
	</xsl:when>
	
	<!-- games column or tv column -->	
	<xsl:when test="$article_type_name='editor_column_game' or $article_type_name='editor_column_tv'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTURE" />
	</xsl:when>
	
	<!-- film column -->	
	<xsl:when test="$article_type_name='editor_column_film'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" /></div>
	<xsl:apply-templates select="/H2G2/SITECONFIG/CINEMAWEEK" />
	</xsl:when>
	
	<!-- Editor Article or old article -->	
	<xsl:when test="$article_type_name='_article_review' or $article_type_name='editor_article_page'">
		<xsl:call-template name="RANDOMSITECONFIGPROMOS" />
	</xsl:when>
	
	<!-- member portfolio -->	
	<xsl:when test="$article_type_name='member_article_page'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<xsl:call-template name="RANDOMSITECONFIGPROMOS" />
	</xsl:when>
	
	<!-- ALL member reviews -->
	<xsl:when test="$article_type_group='review' and $article_type_user='member'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/PROMO2" /></div>
	<xsl:call-template name="RANDOMSITECONFIGPROMOS" />
	</xsl:when>
	
	<!-- member features -->	
	<xsl:when test="$article_type_name='member_feature_feature'">
	<div class="siteConfigPromo"><xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" /></div>
	<xsl:call-template name="RANDOMSITECONFIGPROMOS2" />
	</xsl:when>
	
</xsl:choose>
</xsl:template>

<xsl:template name="RANDOMSITECONFIGPROMOS">
	<xsl:choose>
		<xsl:when test="$second_unit &gt; 45">
		<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
		</xsl:when>
		<xsl:when test="$second_unit &gt; 30">
		<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
		</xsl:when>
		<xsl:when test="$second_unit &gt; 15">
		<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
		</xsl:when>
		<xsl:when test="$second_unit &gt; 0">
		<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" />
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="RANDOMSITECONFIGPROMOS2">
	<xsl:choose>
		<xsl:when test="$second_unit &gt; 40">
		<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
		</xsl:when>
		<xsl:when test="$second_unit &gt; 20">
		<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
		</xsl:when>
		<xsl:when test="$second_unit &gt; 0">
		<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>
