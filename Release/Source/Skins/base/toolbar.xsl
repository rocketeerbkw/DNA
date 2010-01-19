<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">


<xsl:variable name="toolbar_searchcolour">#666666</xsl:variable>
<xsl:variable name="toolbar_width" select="''"/>

<xsl:template name="bbcitoolbar"><!-- h2g2 toolbar 1.0 -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr>
<td colspan="2" style="background:#666666 url(http://www.bbc.co.uk/images/bg.gif);" ><a name="top"><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="600" height="2" alt="" /></a></td>
<td style="background:#666666 url(http://www.bbc.co.uk/images/bg.gif);"><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="1" height="2" alt="" /></td>
</tr>
<form target="_top" action="http://www.bbc.co.uk/cgi-bin/search/results.pl">
<tr><td style="background:#999999 url(http://www.bbc.co.uk/images/bg.gif) repeat-y;" width="76"><a target="_top" href="http://www.bbc.co.uk/go/toolbar/-/"><img src="http://www.bbc.co.uk/images/logo.gif" width="62" height="20" alt="BBCi" border="0" hspace="7" vspace="2" /></a></td>
<td style="background:#999999;" align="right"><table cellpadding="0" cellspacing="0" border="0" style="float:right;">
<tr>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/categories/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">CATEGORIES</a></b></font></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/tv/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">TV</a></b></font></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/radio/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">RADIO</a></b></font></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/communicate/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">COMMUNICATE</a></b></font></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/whereilive/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">WHERE<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>I<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>LIVE</a></b></font></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;" width="6"><br /></td>
<td><font size="1"><b><a target="_top" href="/go/toolbar/-/a-z/" style="color:#ffffff;text-decoration:none;font-family:tahoma,arial,helvetica,sans-serif;">INDEX</a></b></font></td>

<td style="background:{$toolbar_searchcolour} url(http://www.bbc.co.uk/images/sl3.gif) no-repeat;" width="8"><br /></td>
<td style="background:{$toolbar_searchcolour} url(http://www.bbc.co.uk/images/st.gif) repeat-x;"><font size="1" style="color:#ffffff;font-family:tahoma,arial,helvetica,sans-serif;"><label for="bbcpagesearchbox"><b>SEARCH</b></label><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="3" height="1" alt="" /></font></td>
<td style="background:{$toolbar_searchcolour} url(http://www.bbc.co.uk/images/st.gif) repeat-x 0 0;"><input type="text"  name="q" id="bbcpagesearchbox" size="8" style="margin:3px 0 0;font-family:arial,helvetica,sans-serif;width:100px;" /></td>
<td style="background:{$toolbar_searchcolour} url(http://www.bbc.co.uk/images/st.gif) repeat-x;"><input type="image" src="http://www.bbc.co.uk/images/go2.gif" alt="Go" width="26" height="21" border="0" /></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/sra.gif) no-repeat;" width="1"><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="1" height="30" alt="" /></td>
</tr>
</table></td>
<td style="background:#999999 url(http://www.bbc.co.uk/images/srb.gif) no-repeat;"><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="1" height="1" alt="" /><input type="hidden" name="uri" value="/{$scopename}/" /></td>
</tr>
</form>
<tr>
<xsl:choose>
<xsl:when test="$toolbar_width=''">
<td colspan="3" style="background-color:#000000;"><img src="http://www.bbc.co.uk/furniture/tiny.gif" width="1" height="1" alt="" /></td>
</xsl:when>
<xsl:otherwise>
<td class="bbcpageBlack" colspan="2">
<table cellpadding="0" cellspacing="0" border="0">
<tr>    
<td width="125"><img src="/furniture/tiny.gif" width="125" height="1" alt="" /></td>
<td width="10"><img src="/furniture/tiny.gif" width="10" height="1" alt="" /></td>
<td width="{number($toolbar_width)-165}"><img src="/furniture/tiny.gif" width="{number($toolbar_width)-165}" height="1" alt="" /></td>
</tr>
</table>
</td>
<td class="bbcpageBlack" width="100%"><img src="/furniture/tiny.gif" width="1" height="1" alt="" /></td>
</xsl:otherwise>
</xsl:choose>
</tr>
</table>
<!-- end h2g2toolbar 1.0 -->
</xsl:template>

</xsl:stylesheet>
