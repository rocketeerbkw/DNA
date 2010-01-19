<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:variable name="second_unit" select="/H2G2/DATE/@SECONDS" />

<!-- RANDOM EXTERNAL LINKS PROMO -->

<xsl:template name="RANDOMCROSSREFERAL">
<xsl:choose>

	<xsl:when test="$current_article_type=11">
	<!-- Member Review album -->	
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<xsl:when test="$current_article_type=12">
	<!-- Member Review film	 -->
	<xsl:call-template name="RANDOMPROMOFILM" />	
	</xsl:when>
	
	<!-- Member Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=14">
	<strong>radio 4</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof');return false;"><img src="{$promos}promo_bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review tv -->	
	<!-- whats on 	 -->
	<xsl:when test="$current_article_type=16">
	<strong>bbc.co.uk/whatson</strong><br />
	<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}promo_whatsontv.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review comedy	-->
	<!-- bbc comedy  -->	
	<xsl:when test="$current_article_type=17">
	<strong>bbc.co.uk/comedy</strong><br />
	<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}promo_comedy.jpg" alt="bbc.co.uk comedy" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review gig	 -->
	<!-- whats on events/livemusic	 -->
	<xsl:when test="$current_article_type=18">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review art	 -->
	<!-- whats on events/art -->	
	<xsl:when test="$current_article_type=13">
	<strong>bbc.co.uk/arts</strong><br />
	<a href="http://www.bbc.co.uk/events/art"><img src="{$promos}promo_eventsart.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review album	 -->
	<xsl:when test="$current_article_type=26">		
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Selected Member Review film	 -->
	<xsl:when test="$current_article_type=27">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Selected Member Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=29">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof');return false;"><img src="{$promos}promo_bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review tv	 -->
	<!-- whats on 	 -->
	<xsl:when test="$current_article_type=31">
	<strong>bbc.co.uk/whatson</strong><br />
	<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}promo_whatsontv.jpg" alt="bbc" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review comedy	-->
	<!-- bbc comedy -->	
	<xsl:when test="$current_article_type=32">
	<strong>bbc.co.uk/comedy</strong><br />
	<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}promo_comedy.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review gig -->	
	<!-- whats on events music	 -->
	<xsl:when test="$current_article_type=33">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>	
	
	<!-- Editor Review album	 -->
	<xsl:when test="$current_article_type=41">		
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Editor Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=44">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio4_aod.shtml?radio4/bookof');return false;"><img src="{$promos}promo_bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review dvd	 -->
	<xsl:when test="$current_article_type=49">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Editor Review film	 -->
	<xsl:when test="$current_article_type=42">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Editor Review art	 -->
	<!-- whats on  -->
	<xsl:when test="$current_article_type=43">
	<strong>bbc.co.uk/arts</strong><br />
	<a href="http://www.bbc.co.uk/events/art"><img src="{$promos}promo_eventsart.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review tv	 -->
	<!-- whats on  -->	
	<xsl:when test="$current_article_type=46">
	<strong>bbc.co.uk/whatson</strong><br />
	<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}promo_whatsontv.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review comedy	 -->
	<!-- bbc comedy	 -->
	<xsl:when test="$current_article_type=47">
	<strong>bbc.co.uk/comedy</strong><br />
	<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}promo_comedy.jpg" alt="bbc.co.uk comedy" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review gig	 -->
	<!-- whats on events/livemusic	 -->
	<xsl:when test="$current_article_type=48">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Music Feature	 -->
	<xsl:when test="$current_article_type=56">				
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Film Feature	 -->
	<xsl:when test="$current_article_type=57">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Music Interview	 -->
	<xsl:when test="$current_article_type=71">
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Film Interview	 -->
	<!-- back row	 -->
	<xsl:when test="$current_article_type=72">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>	
	
	<!-- Movie News (Column)	 -->
	<!-- news films	 -->
	<xsl:when test="$current_article_type=87">				
	<strong>bbc.co.uk/news</strong><br />
	<a href="http://news.bbc.co.uk/1/hi/entertainment/film/default.stm"><img src="{$promos}promo_newsfilm.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- What's On TV (Column)	 -->
	<!-- whats on  -->	
	<xsl:when test="$current_article_type=89">
	<strong>bbc.co.uk/whatson</strong><br />
	<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}promo_whatsontv.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Music News (Column) news -->	
	<xsl:when test="$current_article_type=86">
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<xsl:otherwise>
	<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:otherwise>

</xsl:choose>
</xsl:template>

<!-- 6 music promo	 -->
<xsl:template name="RANDOMPROMOMUSIC">
<div class="random">
<xsl:choose>
	<xsl:when test="$second_unit &gt; 58">
	<strong>bbc.co.uk/6music</strong><br />
	<a href="http://www.bbc.co.uk/6music/collective"><img src="http://www.bbc.co.uk/6music/images/collective.jpg" alt="bbc 6 music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music experimental feature -->
	<xsl:when test="$second_unit &gt; 55">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/experimental/"><img src="{$promos}promo_musicexperimental.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music rock and alt	 -->
	<xsl:when test="$second_unit &gt; 51">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/rockandalt/"><img src="{$promos}promo_musicrock.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music dance	 -->	
	<xsl:when test="$second_unit &gt; 48">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/dance/"><img src="{$promos}promo_musicdance.jpg	" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- whats on gigs -->
	<xsl:when test="$second_unit &gt; 45">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<xsl:when test="$second_unit &gt; 41">
	<!-- 6 music promo	 -->
	<strong>bbc.co.uk/6music</strong><br />
	<a href="http://www.bbc.co.uk/6music/collective"><img src="http://www.bbc.co.uk/6music/images/collective.jpg " alt="bbc 6 music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music experimental feature -->	
	<xsl:when test="$second_unit &gt; 38">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/experimental/"><img src="{$promos}promo_musicexperimental.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music rock and alt	 -->
	<xsl:when test="$second_unit &gt; 35">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/rockandalt/"><img src="{$promos}promo_musicrock.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music dance	 -->
	<xsl:when test="$second_unit &gt; 31">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/music/dance/"><img src="{$promos}promo_musicdance.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- whats on gigs -->
	<xsl:when test="$second_unit &gt; 28">
	<strong>bbc.co.uk/music</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music promo	 -->
	<xsl:when test="$second_unit &gt; 25">
	<strong>bbc.co.uk/6music</strong><br />
	<a href="http://www.bbc.co.uk/6music/collective"><img src="http://www.bbc.co.uk/6music/images/collective.jpg " alt="bbc 6 music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music experimental feature -->
	<xsl:when test="$second_unit &gt; 21">
	<strong>bbc.co.uk music</strong><br />
	<a href="http://www.bbc.co.uk/music/experimental/"><img src="{$promos}promo_musicexperimental.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music rock and alt	 -->
	<xsl:when test="$second_unit &gt; 18">
	<strong>bbc.co.uk music</strong><br />
	<a href="http://www.bbc.co.uk/music/rockandalt/"><img src="{$promos}promo_musicrock.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music dance	 -->
	<xsl:when test="$second_unit &gt; 15">
	<strong>bbc.co.uk music</strong><br />
	<a href="http://www.bbc.co.uk/music/dance/"><img src="{$promos}promo_musicdance.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- whats on gigs -->
	<xsl:when test="$second_unit &gt; 11">
	<strong>bbc.co.uk</strong><br />
	<a href="http://www.bbc.co.uk/events/livemusic/"><img src="{$promos}promo_eventsmusic.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music promo	 -->
	<xsl:when test="$second_unit &gt; 8">
	<strong>bbc.co.uk/6music</strong><br />
	<a href="http://www.bbc.co.uk/6music/collective"><img src="http://www.bbc.co.uk/6music/images/collective.jpg " alt="bbc 6 music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music experimental feature -->
	<xsl:when test="$second_unit &gt; 5">
	<strong>bbc.co.uk music</strong><br />
	<a href="http://www.bbc.co.uk/music/experimental/"><img src="{$promos}promo_musicexperimental.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc.co.uk music rock and alt	 -->
	<xsl:when test="$second_unit &gt; 1">
	<strong>bbc.co.uk music</strong><br />
	<a href="http://www.bbc.co.uk/music/rockandalt/"><img src="{$promos}promo_musicrock.jpg" alt="bbc.co.uk music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	</xsl:choose>
	</div>
	</xsl:template>
	
	<xsl:template name="RANDOMPROMOFILM">
	<div class="random">
	<xsl:choose>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 58">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}promo_filmssearch.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- back row interviews	 -->
	<xsl:when test="$second_unit &gt; 55">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films promo-->
	<xsl:when test="$second_unit &gt; 51">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/collective"><img src="/films/new_collective_promo.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- dvd reviews -->
	<xsl:when test="$second_unit &gt; 48">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/gateways/release/review/dvd/index.shtml"><img src="{$promos}promo_filmsdvd.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 45">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}promo_filmssearch.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- back row interviews	 -->
	<xsl:when test="$second_unit &gt; 41">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films promo-->
	<xsl:when test="$second_unit &gt; 38">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/collective"><img src="/films/new_collective_promo.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- dvd reviews -->
	<xsl:when test="$second_unit &gt; 35">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/gateways/release/review/dvd/index.shtml"><img src="{$promos}promo_filmsdvd.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 31">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}promo_filmssearch.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- back row interviews	 -->
	<xsl:when test="$second_unit &gt; 28">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films promo-->
	<xsl:when test="$second_unit &gt; 25">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/collective"><img src="/films/new_collective_promo.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- dvd reviews -->
	<xsl:when test="$second_unit &gt; 21">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/gateways/release/review/dvd/index.shtml"><img src="{$promos}promo_filmsdvd.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 18">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}promo_filmssearch.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- back row interviews	 -->
	<xsl:when test="$second_unit &gt; 15">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films promo-->
	<xsl:when test="$second_unit &gt; 11">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/collective"><img src="/films/new_collective_promo.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- dvd reviews -->
	<xsl:when test="$second_unit &gt; 8">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/gateways/release/review/dvd/index.shtml"><img src="{$promos}promo_filmsdvd.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 5">
	<strong>bbc.co.uk/films</strong><br />
	<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}promo_filmssearch.jpg" alt="bbc.co.uk films" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- back row interviews	 -->
	<xsl:when test="$second_unit &gt; 1">
	<strong>radio 4 - back row</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/backrow/backrow_interviews.shtml"><img src="http://www.bbc.co.uk/radio4/arts/backrow/images/promo_backrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>

</xsl:choose>
</div>
</xsl:template>

<xsl:template name="RANDOMPROMOGENERAL">
<div class="random">
<xsl:choose>

	<!-- breezeblock radio-->
	<xsl:when test="$second_unit &gt; 58">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/breezeblock" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/breezeblock');return false;"><img src="{$promos}promo_breezeblock.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- blue room radio -->
	<xsl:when test="$second_unit &gt; 55">
	<strong>bbc radio player</strong><br />

	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/r1blueroom_sun" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/r1blueroom_sun');return false;"><img src="{$promos}promo_blueroom.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- gilles peterson radio -->
	<xsl:when test="$second_unit &gt; 51">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/gilles" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/gilles');return false;"><img src="{$promos}promo_gilles.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6mix radio -->
	<xsl:when test="$second_unit &gt; 48">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?6music/6mix" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?6music/6mix');return false;"><img src="{$promos}promo_6mix.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- late junction radio -->
	<xsl:when test="$second_unit &gt; 45">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/latejunction_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/latejunction_mon');return false;"><img src="{$promos}promo_latejunction.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- mixing it radio -->
	<xsl:when test="$second_unit &gt; 41">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/mixingit" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/mixingit');return false;"><img src="{$promos}promo_mixingit.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- one world radio-->
	<xsl:when test="$second_unit &gt; 38">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/oneworld" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/oneworld');return false;"><img src="{$promos}promo_oneworld.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- news entertainment -->
	<xsl:when test="$second_unit &gt; 35">
	<strong>bbc.co.uk/news</strong><br />
	<a href="http://news.bbc.co.uk/1/hi/entertainment/default.stm"><img src="{$promos}promo_newsents.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- dvd collection -->
	<xsl:when test="$second_unit &gt; 31">
	<strong>bbc.co.uk/bbcfour</strong><br />
	<a href="http://www.bbc.co.uk/bbcfour/collective/"><img src="http://www.bbc.co.uk/bbcfour/collective/promo_bbcfour.jpg" alt="bbc four" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- front row -->
	<xsl:when test="$second_unit &gt; 28">
	<strong>bbc.co.uk/radio4</strong><br />
	<a href="http://www.bbc.co.uk/radio4/arts/frontrow/index.shtml"><img src="{$promos}promo_frontrow.jpg" alt="radio 4" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	 <!-- breezeblock radio-->
	<xsl:when test="$second_unit &gt; 25">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/breezeblock" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/breezeblock');return false;"><img src="{$promos}promo_breezeblock.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a> 	
	</xsl:when>
	
	<!-- blue room radio -->
	<xsl:when test="$second_unit &gt; 21">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/r1blueroom_sun" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?radio1/r1blueroom_sun');return false;"><img src="{$promos}promo_blueroom.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- gilles peterson radio -->
	<xsl:when test="$second_unit &gt; 18">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/gilles" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/gilles');return false;"><img src="{$promos}promo_gilles.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- 6mix radio -->
	<xsl:when test="$second_unit &gt; 15">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/dance.shtml?6music/6mix" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/dance.shtml?6music/6mix');return false;"><img src="{$promos}promo_6mix.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- late junction radio	 -->
	<xsl:when test="$second_unit &gt; 11">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/latejunction_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/latejunction_mon');return false;"><img src="{$promos}promo_latejunction.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- mixing it radio -->
	<xsl:when test="$second_unit &gt; 8">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/mixingit" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/radio3_aod.shtml?radio3/mixingit');return false;"><img src="{$promos}promo_mixingit.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- one world radio-->
	<xsl:when test="$second_unit &gt; 6">
	<strong>bbc radio player</strong><br />
	<a href="http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/oneworld" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/urban.shtml?radio1/oneworld');return false;"><img src="{$promos}promo_oneworld.jpg" alt="bbc radio player" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- news entertainment -->
	<xsl:when test="$second_unit &gt; 4">
	<strong>bbc.co.uk/news</strong><br />
	<a href="http://news.bbc.co.uk/1/hi/entertainment/default.stm"><img src="{$promos}promo_newsents.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- the culture show -->
	<xsl:when test="$second_unit &gt; 1">
	<strong>bbc.co.uk/cultureshow</strong><br />
	<a href="http://www.bbc.co.uk/arts/cultureshow/"><img src="{$promos}promo_thecultureshow.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
</xsl:choose>
</div>
</xsl:template>

<!-- RANDOM PROMO -->
<xsl:template name="RANDOMPROMO">

<xsl:choose>
<xsl:when test="$second_unit &gt; 58">
<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 55">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 51">
<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 48">
<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 45">
<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 41">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 38">
<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 35">
<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 31">
<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 28">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 25">
<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 21">
<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 18">
<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 15">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 11">
<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 8">
<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 5">
<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE" />
</xsl:when>
<xsl:when test="$second_unit &gt; 1">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>
