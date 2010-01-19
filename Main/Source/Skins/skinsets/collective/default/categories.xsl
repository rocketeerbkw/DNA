<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes"
        xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:variable name="server_type">
                <xsl:choose>
                        <xsl:when test="$server = 'OPS-DNA1'">dev</xsl:when>
                        <xsl:otherwise>live</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="categories">
                <category name="music">
                        <server cnum="1074" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="1074" name="live"/>
                </category>
                <category name="film">
                        <server cnum="1073" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="1073" name="live"/>
                </category>
                <category name="art">
                        <server cnum="54929" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="54668" name="live"/>
                </category>
                <category name="books">
                        <server cnum="54930" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="54667" name="live"/>
                </category>
                <category name="games">
                        <server cnum="974" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="974" name="live"/>
                </category>
                <category name="usefulPages">
                        <server cnum="54932" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="983" name="live"/>
                </category>
                <category name="watchListen">
                        <server cnum="54933" name="dev"/>
                        <server cnum="" name="stage"/>
                        <server cnum="958" name="live"/>
                </category>
        </xsl:variable>
        <!-- SETTING VARIABLES -->
        <!-- cats -->
        <xsl:variable name="thisCat" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
        <xsl:variable name="musicCat" select="msxsl:node-set($categories)/category[@name='music']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="filmCat" select="msxsl:node-set($categories)/category[@name='film']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="artCat" select="msxsl:node-set($categories)/category[@name='art']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="booksCat" select="msxsl:node-set($categories)/category[@name='books']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="gamesCat" select="msxsl:node-set($categories)/category[@name='games']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="usefulPagesCat" select="msxsl:node-set($categories)/category[@name='usefulpages']/server[@name=$server_type]/@cnum"/>
        <xsl:variable name="watchListenCat" select="msxsl:node-set($categories)/category[@name='watchlisten']/server[@name=$server_type]/@cnum"/>
</xsl:stylesheet>