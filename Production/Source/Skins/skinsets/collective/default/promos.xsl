<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:variable name="second_unit" select="/H2G2/DATE/@SECONDS" />

<!-- RANDOM EXTERNAL LINKS PROMO -->

<xsl:template name="RANDOMCROSSREFERAL">
<xsl:choose>

<!-- ARTICLES -->
	<!-- Editor's Articles -->
	<xsl:when test="($current_article_type = 3) or ($current_article_type = 20)">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
<!-- FRONT PAGES -->
	<!-- watch and listen/reviews/recommended/features/community/find -->
	<xsl:when test="($current_article_type= 4) or ($current_article_type= 5) or ($current_article_type= 6) or ($current_article_type= 7) or ($current_article_type= 8) or ($current_article_type= 9)">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
<!-- MEMBER REVIEWS -->
	<!-- Member Review general -->	
	<xsl:when test="$current_article_type=10">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- Member Review album -->	
	<xsl:when test="$current_article_type=11">
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Member Review film	 -->
	<xsl:when test="$current_article_type=12">
	<xsl:call-template name="RANDOMPROMOFILM" />	
	</xsl:when>
	
	<!-- Member Review art	 -->
	<!-- whats on events/art -->	
	<xsl:when test="$current_article_type=13">
		<strong>bbc.co.uk/arts</strong><br />
		<a href="http://www.bbc.co.uk/arts"><img src="{$promos}arts.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=14">
	<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon');return false;"><img src="{$promos}bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review games	 -->
	<!-- bbc news - technology	 -->
	<xsl:when test="$current_article_type=15">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review tv -->	
	<!-- whats on 	 -->
	<xsl:when test="$current_article_type=16">
	<strong>bbc.co.uk/whatson</strong><br />
		<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}whatson.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review comedy	-->
	<!-- bbc comedy  -->	
	<xsl:when test="$current_article_type=17">
	<strong>bbc.co.uk/comedy</strong><br />
		<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}comedy.jpg" alt="bbc.co.uk comedy" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review gig	 -->
	<!-- whats on events/livemusic	 -->
	<xsl:when test="$current_article_type=18">
	<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/goingout/"><img src="{$promos}music_goingout.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Memeber Review dvd -->	
	<xsl:when test="$current_article_type=19">
		<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	
	<!-- Selected Member Review general -->	
	<xsl:when test="$current_article_type=25">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- Selected Member Review album	 -->
	<xsl:when test="$current_article_type=26">		
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Selected Member Review film	 -->
	<xsl:when test="$current_article_type=27">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Selected Member Review art	 -->
	<!-- whats on events/art -->	
	<xsl:when test="$current_article_type=28">
		<strong>bbc.co.uk/arts</strong><br />
		<a href="http://www.bbc.co.uk/arts"><img src="{$promos}arts.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=29">
	<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon');return false;"><img src="{$promos}bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Member Review games	 -->
	<!-- bbc news - technology	 -->
	<xsl:when test="$current_article_type=30">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review tv	 -->
	<!-- whats on 	 -->
	<xsl:when test="$current_article_type=31">
	<strong>bbc.co.uk/whatson</strong><br />
		<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}whatson.jpg" alt="bbc" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review comedy	-->
	<!-- bbc comedy -->	
	<xsl:when test="$current_article_type=32">
	<strong>bbc.co.uk/comedy</strong><br />
		<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}comedy.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Member Review gig -->	
	<!-- whats on events music	 -->
	<xsl:when test="$current_article_type=33">
	<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/goingout/"><img src="{$promos}music_goingout.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Selected Memeber Review dvd -->	
	<xsl:when test="$current_article_type=34">
		<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
<!-- EDITOR REVIEWS -->
	<!-- Editor Review general	 -->
	<xsl:when test="$current_article_type=40">		
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- Editor Review album	 -->
	<xsl:when test="$current_article_type=41">		
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Editor Review film	 -->
	<xsl:when test="$current_article_type=42">
		<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Editor Review art	 -->
	<!-- whats on  -->
	<xsl:when test="$current_article_type=43">
	<strong>bbc.co.uk/arts</strong><br />
		<a href="http://www.bbc.co.uk/art"><img src="{$promos}arts.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review book	 -->
	<!-- radio 4 book of the week	 -->
	<xsl:when test="$current_article_type=44">
		<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio4/aod.shtml?radio4/bookof_mon');return false;"><img src="{$promos}bookoftheweek.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review games	 -->
	<!-- bbc news - technology	 -->
	<xsl:when test="$current_article_type=45">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review tv	 -->
	<!-- whats on  -->	
	<xsl:when test="$current_article_type=46">
	<strong>bbc.co.uk/whatson</strong><br />
		<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}whatson.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review comedy	 -->
	<!-- bbc comedy	 -->
	<xsl:when test="$current_article_type=47">
	<strong>bbc.co.uk/comedy</strong><br />
		<a href="http://www.bbc.co.uk/comedy"><img src="{$promos}comedy.jpg" alt="bbc.co.uk comedy" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review gig	 -->
	<!-- whats on events/livemusic	 -->
	<xsl:when test="$current_article_type=48">
	<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/goingout"><img src="{$promos}music_goingout.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Editor Review dvd	 -->
	<xsl:when test="$current_article_type=49">
		<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
<!-- FEATURES/INTERVIEWS -->
	<!-- Feature	 -->
	<xsl:when test="$current_article_type=55">				
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- Music Feature	 -->
	<xsl:when test="$current_article_type=56">				
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Film Feature	 -->
	<xsl:when test="$current_article_type=57">
	<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Interview	 -->
	<xsl:when test="$current_article_type=70">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- Music Interview	 -->
	<xsl:when test="$current_article_type=71">
	<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Film Interview	 -->
	<!-- front row	 -->
	<xsl:when test="$current_article_type=72">
		<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio4/arts/frontrow/"><img src="{$promos}frontrow.jpg" alt="radio 4 - back row" width="189" height="74" border="0" /></a>
	</xsl:when>	
	
<!-- COLUMNS -->
	<!-- (Column) news -->	
	<xsl:when test="$current_article_type=85">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- Music News (Column) news -->	
	<xsl:when test="$current_article_type=86">
		<xsl:call-template name="RANDOMPROMOMUSIC" />
	</xsl:when>
	
	<!-- Movie News (Column)	 -->
	<!-- news films	 -->
	<xsl:when test="$current_article_type=87">
		<xsl:call-template name="RANDOMPROMOFILM" />
	</xsl:when>
	
	<!-- Games News (Column) news -->	
	<xsl:when test="$current_article_type=88">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="bbc.co.uk/news" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- What's On TV (Column)	 -->
	<!-- whats on  -->	
	<xsl:when test="$current_article_type=89">
	<strong>bbc.co.uk/whatson</strong><br />
		<a href="http://www.bbc.co.uk/whatson"><img src="{$promos}whatson.jpg" alt="bbc.co.uk" width="189" height="74" border="0" /></a>
	</xsl:when>
	
<!-- ARCHIVES -->
	<!-- Back Issues -->
	<xsl:when test="$current_article_type=100">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<!-- All Back Issues -->
	<xsl:when test="$current_article_type=101">
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:when>
	
	<xsl:otherwise>
		<xsl:call-template name="RANDOMPROMOGENERAL" />
	</xsl:otherwise>

</xsl:choose>
</xsl:template>


<xsl:template name="RANDOMPROMOMUSIC">
<div class="random">
<xsl:choose>
	
	<!-- 6 music mix -->
	<xsl:when test="$second_unit &gt; 58">
		<strong>bbc radio player</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_6mix" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_6mix'); return false;"><img src="{$promos}promo_6mix.jpg" alt="6 music mix" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music brain surgery-->
	<xsl:when test="$second_unit &gt; 56">
		<strong>bbc radio player</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_marc_wed" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_marc_wed');return false;"><img src="{$promos}brainsurgery.jpg" alt="6 music brain surgery" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music tom robinson -->
	<xsl:when test="$second_unit &gt; 54">
		<strong>bbc radio player</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_tom_mon" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/6music/aod.shtml?6music/6m_tom_mon');"><img src="{$promos}tomrobinson.jpg" alt="6 music tom robinson" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music listeners mix -->	
	<xsl:when test="$second_unit &gt; 51">
		<strong>6 music</strong><br />
		<a href="http://www.bbc.co.uk/6music/shows/listener_6mix/listener6mix.shtml"><img src="{$promos}listenersmix.jpg" alt="6 music listeners mix" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 6 music club fandango -->
	<xsl:when test="$second_unit &gt; 48">
		<strong>6 music</strong><br />
		<a href="http://www.bbc.co.uk/6music/events/fandango/"><img src="{$promos}clubfandango.jpg" alt="6 music club fandango" width="189" height="74" border="0" /></a>
	</xsl:when>

	<!-- music -->
	<xsl:when test="$second_unit &gt; 45">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/"><img src="{$promos}music.jpg" alt="bbc.co.uk/music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- music - going out -->	
	<xsl:when test="$second_unit &gt; 42">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/goingout/"><img src="{$promos}music_goingout.jpg" alt="music going out" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- music - experiemental -->
	<xsl:when test="$second_unit &gt; 39">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/experimental/"><img src="{$promos}music_exp.jpg" alt="music experimental" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- music - rock and indie-->
	<xsl:when test="$second_unit &gt; 36">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/rockindie/"><img src="{$promos}music_rock.jpg" alt="music rock and indie" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- music - dance -->
	<xsl:when test="$second_unit &gt; 33">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/dance/"><img src="{$promos}music_dance.jpg" alt="music dance" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- music - urban -->
	<xsl:when test="$second_unit &gt; 30">
		<strong>bbc.co.uk/music</strong><br />
		<a href="http://www.bbc.co.uk/music/urban/"><img src="{$promos}music_urban.jpg" alt="music urban" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- radio 1 -->
	<xsl:when test="$second_unit &gt; 27">
		<strong>radio 1</strong><br />
		<a href="http://www.bbc.co.uk/radio1/"><img src="{$promos}radio1.jpg" alt="radio 1" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- radio 1 - music interviews -->
	<xsl:when test="$second_unit &gt; 24">
		<strong>radio 1</strong><br />
		<a href="http://www.bbc.co.uk/radio1/musicinterviews/"><img src="{$promos}radio1_musicint.jpg" alt="radio 1" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- radio 1 - giles peterson -->
	<xsl:when test="$second_unit &gt; 21">
		<strong>bbc radio player</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/peterson" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/peterson'); return false;"><img src="{$promos}gillespeterson.jpg" alt="gilles peterson" width="189" height="74" border="0" /></a>
	</xsl:when>

	<!-- radio 1 - annie nghtingale -->
	<xsl:when test="$second_unit &gt; 18">
		<strong>radio 1</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/nightingale" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/nightingale'); return false;"><img src="{$promos}annienightingale.jpg" alt="radio 1 annie nghtingale" width="189" height="74" border="0" /></a>
	</xsl:when>

	<!-- radio1 - mary anne hobbs -->
	<xsl:when test="$second_unit &gt; 15">
		<strong>radio 1</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/hobbs" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/hobbs'); return false;"><img src="{$promos}maryannehobbs.jpg" alt="radio1 mary anne hobbs" width="189" height="74" border="0" /></a>
	</xsl:when>

	<!-- radio 1 - jo whiley -->
	<xsl:when test="$second_unit &gt; 12">
		<strong>radio 1</strong><br />
		<a href="http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/newmusic_wed" target="aod" onClick="aodpopup('http://www.bbc.co.uk/radio/aod/networks/radio1/aod.shtml?radio1/newmusic_wed'); return false;"><img src="{$promos}jowhiley.jpg" alt="radio 1 jo whiley" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- one music -->
	<xsl:when test="$second_unit &gt; 9">
		<strong>one music</strong><br />
		<a href="http://www.bbc.co.uk/radio1/onemusic/"><img src="{$promos}onemusic.jpg" alt="one music" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 1xtra -->
	<xsl:when test="$second_unit &gt; 6">
		<strong>1xtra</strong><br />
		<a href="http://www.bbc.co.uk/1xtra/"><img src="{$promos}1xtra.jpg" alt="1xtra" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- 1xtra podcast -->
	<xsl:when test="$second_unit &gt; 3">
		<strong>1xtra</strong><br />
		<a href="http://www.bbc.co.uk/1xtra/podcast/"><img src="{$promos}1xtra_podcast.jpg" alt="1xtra podcast" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- radio -->
	<xsl:when test="$second_unit &gt; 0">
		<strong>bbc.co.uk/radio</strong><br />
		<a href="http://www.bbc.co.uk/radio/"><img src="{$promos}radio.jpg" alt="radio" width="189" height="74" border="0" /></a>
	</xsl:when>
	
</xsl:choose>
</div>
</xsl:template>
	
<xsl:template name="RANDOMPROMOFILM">
<div class="random">
<xsl:choose>
	
	<!-- films cinema search -->
	<xsl:when test="$second_unit &gt; 50">
		<strong>bbc.co.uk/films</strong><br />
		<a href="http://www.bbc.co.uk/films/listings/"><img src="{$promos}film_cinemasearch.jpg" alt="films cinema search" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- front row -->
	<xsl:when test="$second_unit &gt; 40">
		<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio4/arts/frontrow/"><img src="{$promos}frontrow.jpg" alt="front row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- film -->
	<xsl:when test="$second_unit &gt; 30">
		<strong>bbc.co.uk/film</strong><br />
		<a href="http://www.bbc.co.uk/film/"><img src="{$promos}film.jpg" alt="film" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- mark kermode on five live -->
	<xsl:when test="$second_unit &gt; 20">
		<strong>five live</strong><br />
		<a href="http://www.bbc.co.uk/fivelive/entertainment/kermode.shtml"><img src="{$promos}fivelive_markkermode.gif" alt="five live" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- film network -->
	<xsl:when test="$second_unit &gt; 10">
		<strong>film network</strong><br />
		<a href="http://www.bbc.co.uk/filmnetwork/"><img src="{$promos}filmnetwork.jpg" alt="film network" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- radio 4 - film programme -->
	<xsl:when test="$second_unit &gt; 0">
		<strong>radio 4</strong><br />
		<a href="http://www.bbc.co.uk/radio4/arts/filmprogramme/"><img src="{$promos}filmprogramme.jpg" alt="radio 4" width="189" height="74" border="0" /></a>
	</xsl:when>

</xsl:choose>
</div>
</xsl:template>

<xsl:template name="RANDOMPROMOGENERAL">
<div class="random">
<xsl:choose>

	<!-- news entertainment -->
	<xsl:when test="$second_unit &gt; 54">
		<strong>bbc news</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/entertainment/default.stm"><img src="{$promos}news_ents.jpg" alt="news entertainment" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- bbc four -->
	<xsl:when test="$second_unit &gt; 48">
		<strong>bbc four</strong><br />
		<a href="http://www.bbc.co.uk/bbcfour/"><img src="{$promos}bbcfour.jpg" alt="bbc four" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- front row -->
	<xsl:when test="$second_unit &gt; 42">
		<strong>front row</strong><br />
		<a href="http://www.bbc.co.uk/radio4/arts/frontrow/"><img src="{$promos}frontrow.jpg" alt="front row" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- the culture show -->
	<xsl:when test="$second_unit &gt; 36">
		<strong>the culture show</strong><br />
		<a href="http://www.bbc.co.uk/cultureshow/"><img src="{$promos}promo_thecultureshow.jpg" alt="the culture show" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- blast -->
	<xsl:when test="$second_unit &gt; 30">
		<strong>bbc.co.uk/blast</strong><br />
		<a href="http://www.bbc.co.uk/blast/"><img src="{$promos}blast.jpg" alt="blast" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- arts -->
	<xsl:when test="$second_unit &gt; 24">
		<strong>bbc.co.uk/arts</strong><br />
		<a href="http://www.bbc.co.uk/arts/"><img src="{$promos}arts.jpg" alt="arts" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- comedy -->
	<xsl:when test="$second_unit &gt; 18">
		<strong>bbc.co.uk</strong><br />
		<a href="http://www.bbc.co.uk/comedy/"><img src="{$promos}comedy.jpg" alt="comedy" width="189" height="74" border="0" /></a>
	</xsl:when>
	
	<!-- comedy soup -->
	<xsl:when test="$second_unit &gt; 12">
		<strong>bbc.co.uk</strong><br />
		<a href="http://www.bbc.co.uk/comedysoup/"><img src="{$promos}comedysoup.jpg" alt="comedy soup" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- bbc two -->
	<xsl:when test="$second_unit &gt; 6">
		<strong>bbc two</strong><br />
		<a href="http://www.bbc.co.uk/bbctwo/"><img src="{$promos}bbctwo.jpg" alt="bbc two" width="189" height="74" border="0" /></a>	
	</xsl:when>
	
	<!-- news technology -->
	<xsl:when test="$second_unit &gt; 0">
		<strong>bbc news - technology</strong><br />
		<a href="http://news.bbc.co.uk/1/hi/technology/default.stm"><img src="{$promos}news_technology.jpg" alt="news technology" width="189" height="74" border="0" /></a>	
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
<xsl:when test="$second_unit &gt; 0">
<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE" />
</xsl:when>
</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>
