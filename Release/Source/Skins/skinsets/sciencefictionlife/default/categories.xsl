<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">



<!-- v3 cat VALUES FOR DEV -->


<!--===============Category numbers=====================-->


<xsl:variable name="thisCatPage"><xsl:value-of select="/H2G2/HIERARCHYDETAILS/@NODEID" /></xsl:variable>

<!-- level 1 cats -->
<xsl:variable name="scifiIndexPage">55290</xsl:variable>


<!-- level 2 cats -->
<xsl:variable name="byMediaPage">55725</xsl:variable>
<xsl:variable name="byThemePage">55291</xsl:variable>
<xsl:variable name="byDatePage">55726</xsl:variable>
 

<!-- level 3 cats -->
<xsl:variable name="mediaBook">55737</xsl:variable>
<xsl:variable name="mediaComic">55738</xsl:variable>
<xsl:variable name="mediaFilm">55739</xsl:variable>
<xsl:variable name="mediaRadio">55740</xsl:variable>
<xsl:variable name="mediaTV">55741</xsl:variable>
<xsl:variable name="mediaOther">55742</xsl:variable>

<xsl:variable name="themeCatastrophe">55299</xsl:variable>
<xsl:variable name="themeDystopia">55300</xsl:variable>
<xsl:variable name="themeEvolution">55301</xsl:variable>
<xsl:variable name="themeOrigins">55302</xsl:variable>
<xsl:variable name="themeReligion">55303</xsl:variable>
<xsl:variable name="themeSex">55304</xsl:variable>

<xsl:variable name="dateTo1930">55728</xsl:variable>
<xsl:variable name="date1930s">55729</xsl:variable>
<xsl:variable name="date1940s">55730</xsl:variable>
<xsl:variable name="date1950s">55731</xsl:variable>
<xsl:variable name="date1960s">55732</xsl:variable>
<xsl:variable name="date1970s">55733</xsl:variable>
<xsl:variable name="date1980s">55734</xsl:variable>
<xsl:variable name="date1990s">55735</xsl:variable>
<xsl:variable name="date2000s">55736</xsl:variable>

	
<!-- deleted DROP_DOWN template -->

</xsl:stylesheet>