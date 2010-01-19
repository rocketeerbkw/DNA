<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="RANDOMCROSSREFERAL">
<xsl:call-template name="RANDOMPROMO" />
</xsl:template>

<xsl:variable name="second_unit" select="/H2G2/DATE/@SECONDS" />
<!-- RANDOM EXTERNAL LINKS PROMO -->

<!-- RANDOM PROMO -->
<xsl:template name="RANDOMPROMO">

	<xsl:choose>
	<!-- <xsl:when test="$second_unit &gt; 58">
	<a href="http://www.bbc.co.uk/news/entertainment"><img src="http://www.bbc.co.uk/collective/filmnetwork" alt="" width="244" height="65" border="0" /></a>	
	</xsl:when>
	<xsl:when test="$second_unit &gt; 55">
	<a href="http://www.bbc.co.uk/news/entertainment"><img src="http://www.bbc.co.uk/collective/filmnetwork" alt="" width="244" height="65" border="0" /></a>
	</xsl:when> -->
	<xsl:when test="$second_unit &gt; 51">
	<a href="http://www.bbc.co.uk/collective/filmnetwork"><img src="http://www.bbc.co.uk/collective/promos/filmnetwork_promo.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 48">
	<a href="http://www.bbc.co.uk/collective/filmnetwork"><img src="http://www.bbc.co.uk/collective/promos/filmnetwork_promo.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 38">
	<a href="http://www.bbc.co.uk/writersroom/writing"><img src="http://www.bbc.co.uk/writersroom/writing/images/writer.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 35">
	<a href="http://www.bbc.co.uk/writersroom/writing"><img src="http://www.bbc.co.uk/writersroom/writing/images/writer.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 31">
	<a href="http://www.bbc.co.uk/films/callingtheshots/index.shtml"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_shootingpeople.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 28">
	<a href="http://www.bbc.co.uk/films/callingtheshots/index.shtml"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_shootingpeople.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 25">
    <a href="http://www.bbc.co.uk/films/directorsdiary/"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_directorsdiary.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 21">
	<a href="http://www.bbc.co.uk/films/directorsdiary/"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_directorsdiary.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 18">
	<a href="http://www.bbc.co.uk/films/gateways/release/review/cinema/index.shtml"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_newcinema.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 15">
	<a href="http://www.bbc.co.uk/films/gateways/release/review/cinema/index.shtml"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_newcinema.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 11">
    <a href="http://www.bbc.co.uk/bbcfour/filmnetwork/"><img src="http://www.bbc.co.uk/bbcfour/filmnetwork/bbcfour_promo.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 8">
	<a href="http://www.bbc.co.uk/films/gateways/release/review/dvd/index.shtml"><img src="http://www.bbc.co.uk/filmnetwork/images/randompromos/films_newdvds.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 5">
	<a href="http://www.bbc.co.uk/films/film_2004/"><img src="http://www.bbc.co.uk/films/film_2004/images/film2004_promo.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	<xsl:when test="$second_unit &gt; 1">
	<a href="http://www.bbc.co.uk/films/film_2004/"><img src="http://www.bbc.co.uk/films/film_2004/images/film2004_promo.jpg" alt="" width="244" height="65" border="0" /></a>
	</xsl:when>
	</xsl:choose>
</xsl:template>
	
</xsl:stylesheet>
