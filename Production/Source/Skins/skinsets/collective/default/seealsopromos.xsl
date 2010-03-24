<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<!-- RANDOM PROMO -->
<xsl:template name="SEEALSOPROMO">
<xsl:choose>

	<!-- music interview -->
	<xsl:when test="$current_article_type=71">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>music archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- film interview -->
	<xsl:when test="$current_article_type=72">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>film archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- interview -->
	<xsl:when test="$current_article_type=70">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- music feature -->
	<xsl:when test="$current_article_type=56">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>music archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- film feature -->
	<xsl:when test="$current_article_type=57">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>film archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- feature -->
	<xsl:when test="$current_article_type=55">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- feature -->
	<xsl:when test="$current_article_type=120">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/GUIDE/EDITORDNAID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- general review -->
	<xsl:when test="$current_article_type=40">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- album review -->
	<xsl:when test="$current_article_type=41">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>music archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- cinema review -->
	<xsl:when test="$current_article_type=42">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>film archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- art review -->
	<xsl:when test="$current_article_type=43">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>art archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C54668"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- book review -->
	<xsl:when test="$current_article_type=44">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>books archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C54667"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- games review -->
	<xsl:when test="$current_article_type=45">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>games archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C974"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- tv review -->
	<xsl:when test="$current_article_type=46">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>more culture archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1075"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- comedy review -->
	<xsl:when test="$current_article_type=47">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>comedy archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C970"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- gig review -->
	<xsl:when test="$current_article_type=48">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>music archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- dvd review -->
	<xsl:when test="$current_article_type=49">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>film archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- general column -->
	<xsl:when test="$current_article_type=85">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- music column -->
	<xsl:when test="$current_article_type=86">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>music archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- games column -->
	<xsl:when test="$current_article_type=88">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>games archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C974"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- film column -->
	<xsl:when test="$current_article_type=87">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>film archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- tv column -->
	<xsl:when test="$current_article_type=89">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>more culture archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1075"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />access 1000s of articles</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	
	
	<!-- general member review -->
	<xsl:when test="$current_article_type=10">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- album -->
	<xsl:when test="$current_article_type=11">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the music back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- cinema -->
	<xsl:when test="$current_article_type=12">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the film back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- art -->
	<xsl:when test="$current_article_type=13">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C54668"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the art back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- books -->
	<xsl:when test="$current_article_type=14">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C54667"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the books back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- games -->
	<xsl:when test="$current_article_type=15">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C974"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the games back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- tv -->
	<xsl:when test="$current_article_type=16">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1075"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the more culture back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- comedy -->
	<xsl:when test="$current_article_type=17">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C970"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the comedy back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- gig -->
	<xsl:when test="$current_article_type=18">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1074"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the music back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- DVD -->
	<xsl:when test="$current_article_type=19">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/C1073"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the film back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>
	
	<!-- member portfolios -->
	<xsl:when test="$current_article_type=2">
	<div class="generic-v">
		<div class="like-this">
			<font size="2"><strong>archive</strong></font>
		</div>
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />more reviews by this member</a></span></span><br /><br />
		<span class="textsmall"><span class="guideml-b"><a class="font-base"  href="/dna/collective/browse"><img src="http://www.bbc.co.uk/collective/dnaimages/icons/archive.gif" border="0"  width="64" height="36" align="left" alt="" />browse the back catalogue</a></span></span><br /><br />
	</div>
	</xsl:when>

</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>


