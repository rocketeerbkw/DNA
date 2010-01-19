<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<xsl:variable name="collective.icon.one"><img src="{$graphics}icons/1_000.gif" width="20" height="20" alt="step 1" border="0" />&nbsp;</xsl:variable>

<xsl:variable name="next.arrow"><img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt="" /></xsl:variable>
<xsl:variable name="previous.arrow"><img src="{$imagesource}furniture/arrowdarkprev.gif" width="4" height="7" alt="" /></xsl:variable>

<!-- arrows -->
	<xsl:variable name="arrow.right"><img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt="" /></xsl:variable>
	<!-- <xsl:variable name="arrow.left"><img src="{$graphics}icons/arrow_left.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.up"><img src="{$graphics}icons/arrow_up.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.down"><img src="{$graphics}icons/arrow_down.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.right.white"><img src="{$graphics}icons/white/arrow_right.gif" width="9" height="7" alt="" border="0" /></xsl:variable>-->

	<xsl:variable name="arrow.first"><img src="{$imagesource}furniture/arrowdarkprev.gif" width="4" height="7" alt="" /><img src="{$imagesource}furniture/arrowdarkprev.gif" width="4" height="7" alt="" /></xsl:variable> 
	<xsl:variable name="arrow.previous"><img src="{$imagesource}furniture/arrowdarkprev.gif" width="4" height="7" alt="" /></xsl:variable>
	<xsl:variable name="arrow.next"><img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt="" /></xsl:variable>
	<xsl:variable name="arrow.latest"><img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt="" /><img src="{$imagesource}furniture/arrowdark.gif" width="4" height="7" alt="" /></xsl:variable>

<xsl:variable name="white.arrow.right"><img src="{$graphics}icons/arrow_next_white.gif" width="7" height="9" alt="" border="0" /></xsl:variable>


<!-- userpage -->
	<xsl:variable name="content.by"><div class="generic-img"><img src="{$graphics}/icons/content_by_{$article_authortype}.gif" width="8" height="10" border="0" alt="{$article_authortype}" />&nbsp;content by: <xsl:value-of select="$article_authortype" /></div></xsl:variable>

<!-- conversations -->
<xsl:variable name="m_useronlineflagmp"><img src="{$graphics}icons/icon_useronline.gif" width="23" height="23" alt="user online" border="0" /></xsl:variable>

<xsl:variable name="icon.video.grey"><img src="{$graphics}icons/icon_videogrey.gif" width="30" height="29" alt="" border="0" /></xsl:variable>

<xsl:variable name="icon.video.pink"><img src="{$graphics}icons/icon_videopink.gif" width="30" height="29" alt="" border="0" /></xsl:variable>

<xsl:variable name="icon.browse"><img src="{$graphics}icons/icon_browse.gif" width="31" height="34" alt="browse" border="0" /></xsl:variable>

<xsl:variable name="icon.browse.white"><img src="{$graphics}icons/icon_browse_white.gif" width="31" height="30" alt="browse" border="0" /></xsl:variable>

<xsl:variable name="icon.browse.brown"><img src="{$graphics}icons/icon_browse_brown.gif" width="31" height="30" alt="browse" border="0" /></xsl:variable>

<xsl:variable name="icon.print"><img src="{$graphics}icons/icon_browse_brown.gif" width="31" height="30" alt="browse" border="0" /></xsl:variable>

	
</xsl:stylesheet>
