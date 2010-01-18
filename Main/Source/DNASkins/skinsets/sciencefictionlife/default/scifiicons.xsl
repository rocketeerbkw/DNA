<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<!-- icons -->

	<!-- numbers -->
	<xsl:variable name="collective.icon.one"><img src="{$imagesource}icons/1_000.gif" width="20" height="20" alt="step 1" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.icon.two"><img src="{$imagesource}icons/2_000.gif" width="20" height="20" alt="step 2" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.icon.three"><img src="{$imagesource}icons/3_000.gif" width="20" height="20" alt="step 3" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.icon.four"><img src="{$imagesource}icons/4_000.gif" width="20" height="20" alt="step 4" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.icon.five"><img src="{$imagesource}icons/5_000.gif" width="20" height="20" alt="step 5" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.icon.six"><img src="{$imagesource}icons/6_000.gif" width="20" height="20" alt="step 6" border="0" />&nbsp;</xsl:variable>

	<xsl:variable name="icon.step.one"><img src="{$imagesource}icons/1_000.gif" width="20" height="20" alt="step 1" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.step.two"><img src="{$imagesource}icons/2_000.gif" width="20" height="20" alt="step 2" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.step.three"><img src="{$imagesource}icons/3_000.gif" width="20" height="20" alt="step 3" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.step.four"><img src="{$imagesource}icons/4_000.gif" width="20" height="20" alt="step 4" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.step.five"><img src="{$imagesource}icons/5_000.gif" width="20" height="20" alt="step 5" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.step.six"><img src="{$imagesource}icons/6_000.gif" width="20" height="20" alt="step 6" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="icon.video"><img src="{$imagesource}icons/icon_videosmall.gif" width="12" height="11" alt="" border="0" /></xsl:variable>
	<xsl:variable name="icon.audio"><img src="{$imagesource}icons/icon_audiosmall.gif" alt="" width="14" height="11" border="0" align="top"/></xsl:variable>
	<xsl:variable name="icon.issue"><img src="{$imagesource}icons/icon_issue.gif" alt="issue" width="16" height="20" border="0" align="top"/></xsl:variable>
<xsl:variable name="icon.collective"><img src="{$imagesource}icons/icon_collective.gif" alt="" width="20" height="20" border="0" align="top"/></xsl:variable>

<xsl:variable name="icon.hints.black"><img src="{$imagesource}icons/hints_tips_000.gif" width="20" height="20" alt="light bulb" border="0" />&nbsp;</xsl:variable>
	<xsl:variable name="collective.orange"><img src="{$imagesource}icons/orange/collective.gif" width="11" height="16" alt="" border="0" /></xsl:variable>
	
	<xsl:variable name="arrow.right"><img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" /></xsl:variable>
	<xsl:variable name="arrow.left"><img src="{$imageRoot}images/previous.gif" border="0"  width="4" height="7" alt="arrow icon" /></xsl:variable>
	<xsl:variable name="arrow.up"><img src="{$imagesource}icons/arrow_up.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.down"><img src="{$imagesource}icons/arrow_down.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.right.white"><img src="{$imagesource}icons/white/arrow_right.gif" width="9" height="7" alt="" border="0" /></xsl:variable>

	<xsl:variable name="arrow.first"><img src="{$imagesource}icons/arrow_first.gif" width="8" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.previous"><img src="{$imagesource}icons/arrow_previous.gif" width="4" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.next"><img src="{$imagesource}icons/arrow_next.gif" width="4" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="arrow.latest"><img src="{$imagesource}icons/arrow_latest.gif" width="8" height="7" alt="" border="0" /></xsl:variable>

	<xsl:variable name="weblog.green"><img src="{$imagesource}icons/arrow_right.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="intro.green"><img src="{$imagesource}icons/arrow_left.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="conversation.green"><img src="{$imagesource}icons/arrow_up.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="message.green"><img src="{$imagesource}icons/arrow_down.gif" width="9" height="7" alt="" border="0" /></xsl:variable>
	<xsl:variable name="portfolio.green"><img src="{$imagesource}icons/arrow_down.gif" width="9" height="7" alt="" border="0" /></xsl:variable>

	<xsl:variable name="download.realplayer"><div class="realplayer"><xsl:element name="{$text.small}" use-attribute-sets="text.small"><img src="{$imagesource}icons/realplayer.gif" width="16" height="16" alt="real player" />&nbsp;to access audio and video on collective you need <a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro" target="webwise" onClick="popwin(this.href, this.target, 620, 500, 'scroll', 'resize'); return false;">real player</a>.</xsl:element></div></xsl:variable>
	
	<xsl:variable name="page.editor"><img src="{$imagesource}icons/page_editor.gif" width="15" height="18" alt="" border="0" /></xsl:variable>
	<xsl:variable name="page.member"><img src="{$imagesource}icons/page_member.gif" width="15" height="18" alt="" border="0" /></xsl:variable>

	<xsl:variable name="myspace.intro"><img src="{$imagesource}icons/my_intro.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.tips"><img src="{$imagesource}icons/tips_intro.gif" height="21" width="20" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.tips.black"><img src="{$imagesource}icons/black/tips.gif" height="21" width="20" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.tools"><img src="{$imagesource}icons/my_tools.gif" height="21" width="20" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.tools.black"><img src="{$imagesource}icons/black/tools.gif" height="20" width="19" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.messages"><img src="{$imagesource}icons/my_messages.gif" height="21" width="20" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.messages.orange"><img src="{$imagesource}icons/orange/my_messages.gif" height="21" width="20" border="0" alt="" /></xsl:variable>
	<xsl:variable name="myspace.conversations"><img src="{$imagesource}icons/my_convo.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.conversations.white"><img src="{$imagesource}icons/white/my_convo.gif" alt="" width="19" height="20" border="0" /></xsl:variable>
	<xsl:variable name="myspace.popup"><img src="{$imagesource}icons/popup_orange.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.portfolio"><img src="{$imagesource}icons/my_portfolio.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.portfolio.orange"><img src="{$imagesource}icons/orange/my_portfolio.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.portfolio.white"><img src="{$imagesource}icons/white/my_portfolio.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.weblog"><img src="{$imagesource}icons/my_weblog.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.weblog.white"><img src="{$imagesource}icons/white/my_weblog.gif" alt="" width="20" height="21" border="0" /></xsl:variable>
	<xsl:variable name="myspace.editorial"><xsl:copy-of select="$myspace.portfolio" /></xsl:variable>

	<xsl:variable name="member.has_intro.orange"><img src="{$imagesource}icons/orange/has_intro.gif" alt="" width="11" height="12" border="0" /></xsl:variable>
	<xsl:variable name="member.left_message.orange"><img src="{$imagesource}icons/orange/has_left_message.gif" alt="" width="11" height="12" border="0" /></xsl:variable>
	<xsl:variable name="member.has_intro.white"><img src="{$imagesource}icons/white/has_intro.gif" alt="member has written an introduction" width="11" height="12" border="0" /></xsl:variable>
	<xsl:variable name="member.left_message.white"><img src="{$imagesource}icons/white/has_left_message.gif" alt="member has been left a message" width="11" height="12" border="0" /></xsl:variable>

	<xsl:variable name="complain.brown"><img src="{$imagesource}icons/brown/complain.gif" height="16" width="17" border="0" alt="alert the moderators" /></xsl:variable>
	<xsl:variable name="complain.orange"><img src="{$imagesource}icons/orange/complain.gif" height="16" width="18" border="0" alt="" /></xsl:variable>

	<xsl:variable name="useful.links"><img src="{$imagesource}icons/useful_links.gif" height="20" width="20" border="0" alt="" /></xsl:variable>

<!-- @cv@3 -->
	<xsl:variable name="content.by"><div class="generic-img"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><img src="{$imagesource}/icons/content_by_{$article_authortype}.gif" width="8" height="10" border="0" alt="{$article_authortype}" />&nbsp;content by: <xsl:value-of select="$article_authortype" /></xsl:element></div></xsl:variable>

	<xsl:template name="icon.number">
		<xsl:param name="icon.number.image" />
		<xsl:param name="icon.number.alt" />
		<xsl:param name="icon.number.label" />
		<div class="icon"><img src="{$imagesource}icons/{$icon.number.image}.gif" alt="{$icon.number.alt}" width="20" height="20" border="0" /></div>
	</xsl:template>
	
	<xsl:variable name="m_useronlineflagmp"><img src="{$imagesource}icons/white/icon_eyes.gif" alt="" width="27" height="13" border="0" /></xsl:variable>

</xsl:stylesheet>
