<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

		<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="INPUT | input | SELECT | select | P | p | I | i | B | b | BLOCKQUOTE | blockquote | CAPTION | caption | CODE | code  | PRE | pre | SUB | sub | SUP | sup | BR | br | FONT| I | i">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="FONT | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
	<xsl:apply-templates />
	</xsl:template>

	
	<xsl:template match="TEXTAREA">
		<form>
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</form>
	</xsl:template>
	
	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template>
	
	<xsl:template match="PICTURE" mode="display">
		<div align="center"><xsl:call-template name="renderimage"/></div>
		<xsl:call-template name="insert-caption"/>
	</xsl:template>
	
	<xsl:template match="A">
		<xsl:copy use-attribute-sets="mA">
			<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|@CLASS|text()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- Links -->
	<xsl:template match="LINK">
	<xsl:choose>
		<xsl:when test="@CTA='submitimage'">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="13"/>
			</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a>
		</xsl:when>
		<xsl:when test="@CTA='submitav'">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="11"/>
			</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a>
		</xsl:when>
		<xsl:when test="@TYPE='MORE'">
			<div class="arrow">
			<a>
			<xsl:apply-templates select="@DNAID | @HREF"/>
			<xsl:call-template name="dolinkattributes"/>
			<xsl:value-of select="./text()" />
			</a>
			</div>
		</xsl:when>
		<xsl:when test="@TYPE='BACK'">
			<div class="backArrow">
			<a>
			<xsl:apply-templates select="@DNAID | @HREF"/>
			<xsl:call-template name="dolinkattributes"/>
			<xsl:value-of select="./text()" />
			</a>
			</div>
		</xsl:when>
		<xsl:when test="@TYPE='BUTTON'">
			<a class="button">
			<xsl:apply-templates select="@DNAID | @HREF"/>
			<xsl:call-template name="dolinkattributes"/>
			<span><span><span><xsl:value-of select="./text()" /></span></span></span>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<a>
			<xsl:apply-templates select="@DNAID | @HREF"/>
			<xsl:call-template name="dolinkattributes"/>
			<xsl:value-of select="./text()" />
			</a>
		</xsl:otherwise>
		<!-- 
		<xsl:otherwise>
		<div>
			<a xsl:use-attribute-sets="mLINK" class="arrow">
			<xsl:call-template name="dolinkattributes"/>
			<xsl:apply-templates select="." mode="long_link" />
			</a>
		</div>
		</xsl:otherwise>
		-->
	</xsl:choose>
	</xsl:template>
	
	
	<!-- Alistair - may not actually need this as is in the base files (and don't think it needs to be overridden - test this out! -->
	<xsl:template name="dolinkattributes">
		<xsl:choose>
			<xsl:when test="@POPUP">
				<xsl:variable name="url">
					<xsl:if test="@DNAID">
						<xsl:apply-templates select="@DNAID" mode="applyroot"/>
					</xsl:if>
					<xsl:if test="@HREF">
						<xsl:apply-templates select="@HREF" mode="applyroot"/>
					</xsl:if>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="@STYLE">
						<xsl:attribute name="TARGET"><xsl:choose><xsl:when test="@TARGET"><xsl:value-of select="@TARGET"/></xsl:when><xsl:otherwise><xsl:text>_blank</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:attribute name="HREF"><xsl:value-of select="$url"/></xsl:attribute>
						<xsl:attribute name="onClick">popupwindow('<xsl:value-of select="$url"/>','<xsl:value-of select="@TARGET"/>','<xsl:value-of select="@STYLE"/>');return false;</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="TARGET"><xsl:choose><xsl:when test="@TARGET"><xsl:value-of select="@TARGET"/></xsl:when><xsl:otherwise><xsl:text>_blank</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:attribute name="HREF"><xsl:value-of select="$url"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@DNAID">
					<xsl:apply-templates select="@DNAID"/>
				</xsl:if>
				<xsl:if test="@HREF|@href">
					<xsl:apply-templates select="@HREF"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- IMG -->
	<xsl:template match="IMG | img">
	<xsl:choose>
			<xsl:when test="@DNAID | @HREF">
				<a>
					<xsl:apply-templates select="@DNAID | @HREF"/>
					<img src="{$imagesource}{@NAME}" border="0">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$imagesource}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!-- 
	##############################################################
					NEW
	##############################################################
	-->
	
	<!-- editorial articles -->
	<xsl:template match="ASSETLIBRARYNAV">
		<div class="assetSubNav3Col">
					<ul><!-- selected menu item has no link -->
						
						<!-- item 1 -->
						<xsl:choose>
							<xsl:when test="@SELECTED='1'">
								<li class="item1">OVERVIEW</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="item1"><a href="#">OVERVIEW</a></li>
							</xsl:otherwise>
						</xsl:choose>
						<!-- item 2 -->
						<xsl:choose>
							<xsl:when test="@SELECTED='2'">
								<li class="item2">FAQs</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="item2"><a href="#">FAQs</a></li>
							</xsl:otherwise>
						</xsl:choose>
						<!-- item 3 -->
						<xsl:choose>
							<xsl:when test="@SELECTED='3'">
								<li class="item3">LICENCE FAQs</li>
							</xsl:when>
							<xsl:otherwise>
								<li class="item3"><a href="#">LICENCE FAQs</a></li>
							</xsl:otherwise>
						</xsl:choose>
						
						<div class="clr"></div>
					</ul>
					<div class="hozDots"></div>
				</div>
	</xsl:template>
	
	<xsl:template match="hr|HR|LINE">
		<div class="hozDots"></div>
	</xsl:template>
	
	<xsl:template match="HEADER">
		<h2><xsl:apply-templates/></h2>
	</xsl:template>
	
	<xsl:template match="EMPHASISBOX">
		<div class="emphasisBox"><xsl:apply-templates/></div>
	</xsl:template>
	
	<xsl:template match="EDITORIAL-ITEM">
		<div class="contentBlock"><xsl:apply-templates/></div>
	</xsl:template>
		
	<xsl:template match="INCLUDE">
		<xsl:comment>#include virtual="<xsl:value-of select="@SRC" />"</xsl:comment>
	</xsl:template>
	
	<xsl:template match="UL">
		<xsl:choose>
			<xsl:when test="@class='iconList' or @CLASS='iconList'">
				<ul class="iconList"><xsl:apply-templates/></ul>
			</xsl:when>
			<xsl:otherwise>
				<ul class="starList"><xsl:apply-templates/></ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="COL2">
	<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="IMAGETITLE">
	<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="MEDIAASSETCREATIONBUTTONS">
	<a href="TypedArticle?acreate='new'&amp;type=10&amp;s_type=mediaasset&amp;hasasset=1&amp;manualupload=0&amp;contenttype=1&amp;s_display=1" class="button">
		<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
				<xsl:with-param name="type" select="10"/>
			</xsl:call-template>
		</xsl:attribute>
	<span><span><span>Submit an image</span></span></span></a><br />
	<br />
	or<br />
	<br />
	
	<a class="button">
		<xsl:attribute name="href">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
				TypedArticle?acreate='new'&amp;s_show=audio
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=%26pt=type%26type=11')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
	<span><span><span>Submit some audio</span></span></span></a><br />
	<br />
	or<br />
	<br />
	<a class="button">
		<xsl:attribute name="href">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
				TypedArticle?acreate='new'&amp;s_show=video
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=%26pt=type%26type=12')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
	<span><span><span>Submit some video/animation</span></span></span></a><br />
	<br />
	</xsl:template> 
	
	<xsl:template match="PROGRAMMECHALLENGELISTTITLE">
		<xsl:variable name="challenge_type">
			<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@CONTENTTYPE"/>
		</xsl:variable>
		<xsl:variable name="challenge_type_string">
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$challenge_type]/@label"/>
		</xsl:variable>	
		<xsl:variable name="display_name">
			<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/DISPLAYNAME"/>
		</xsl:variable>
		<xsl:variable name="is_new">
			<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@NEW='Y'"/>
		</xsl:variable>
		<h2>
			<span class="orange"><xsl:value-of select="$display_name"/></span> - <xsl:value-of select="$challenge_type_string"/> challenge
			<xsl:if test="$is_new='true'">
				<span class="orange">new!</span>
			</xsl:if>
		</h2>		
	</xsl:template>
		
	<xsl:template match="PROGRAMMECHALLENGELISTLINK">
		<a class="button">
			<xsl:attribute name="href">
				<xsl:if test="@NUMBER">
					<xsl:value-of select="concat('C', /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@CATEGORY)"/>
				</xsl:if>
		</xsl:attribute>
		<span><span><span><xsl:value-of select="."/></span></span></span></a><br />	
	</xsl:template>
	
	<xsl:template match="PROGRAMMECHALLENGEENTRYLINK">
		<xsl:variable name="challenge_type">
			<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@CONTENTTYPE"/>
		</xsl:variable>
		<xsl:variable name="pccat">
			<xsl:value-of select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@CATEGORY"/>
		</xsl:variable>
		<xsl:variable name="programme_challenge_is_open" select="/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[./@NUMBER=current()/@NUMBER]/@OPEN='Y'"/>		
		<xsl:variable name="num_mediatypes" select="count(msxsl:node-set($type)/type[@number=$challenge_type]/mediatype)"/>
		<xsl:if test="$programme_challenge_is_open">
			<xsl:variable name="href">
				<xsl:choose>
					<!-- jump straight to submission page if only one type -->
					<xsl:when test="$num_mediatypes=1">
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
								<xsl:choose>
									<xsl:when test="msxsl:node-set($type)/type[@number=$challenge_type]/mediatype/@show">
										<xsl:value-of select="concat($root,'TypedArticle?acreate=new&amp;s_show=',msxsl:node-set($type)/type[@number=$challenge_type]/mediatype/@show,'&amp;s_pccat=',$pccat)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($root,'TypedArticle?acreate=new&amp;type=',msxsl:node-set($type)/type[@number=$challenge_type]/mediatype/@number,'&amp;s_pccat=',$pccat)"/>
									</xsl:otherwise>						
								</xsl:choose>
								<!-- TypedArticle?acreate='new'&amp;s_show=audio -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=%26pt=type%26type=',msxsl:node-set($type)/type[@number=$challenge_type]/mediatype/@number,'%26s_pccat=',$pccat)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- otherwise jump to chooser page -->
					<xsl:otherwise>
						<xsl:value-of select="concat($root,'choosechallengetype')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<a class="button" href="href">
				<xsl:attribute name="href">
					<xsl:value-of select="$href"/>
				</xsl:attribute>
			<span><span><span><xsl:value-of select="."/></span></span></span></a><br />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="FRONTPAGERSS">
		<xsl:if test="/H2G2/SITECONFIG/RSSCONFIG/ENABLED='Y'">
			<xsl:call-template name="RSSICON">
				<xsl:with-param name="feedtype">general</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="RSSICON">
		<xsl:param name="feedtype"/>
		<xsl:if test="/H2G2/SITECONFIG/RSSCONFIG/ENABLED='Y'">
			<span class="rssfeed">
				<span class="label">RSS</span> 
				<xsl:choose>
					<xsl:when test="$feedtype='image'">
						<a href="{$root}xml/ArticleSearchPhrase?articlesortby=DateUploaded&amp;contenttype=1&amp;s_xml=rss&amp;s_feedtype={$feedtype}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='audio'">
						<a href="{$root}xml/ArticleSearchPhrase?articlesortby=DateUploaded&amp;contenttype=2&amp;s_xml=rss&amp;s_feedtype={$feedtype}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='video'">
						<a href="{$root}xml/ArticleSearchPhrase?articlesortby=DateUploaded&amp;contenttype=3&amp;s_xml=rss&amp;s_feedtype={$feedtype}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}xml/ArticleSearchPhrase?articlesortby=DateUploaded&amp;s_xml=rss&amp;s_feedtype=general"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="USERRSSICON">
		<xsl:param name="feedtype"/>
		<xsl:param name="userid"/>
		<xsl:param name="firstnames"/>
		<xsl:param name="lastname"/>
		
		<xsl:if test="/H2G2/SITECONFIG/RSSCONFIG/ENABLED='Y'">
			<span class="rssfeed">
				<span class="userName"><xsl:value-of select="$firstnames"/><xsl:text> </xsl:text><xsl:value-of select="$lastname"/></span>
				<span class="label">
					<xsl:text> </xsl:text>|<xsl:text> </xsl:text>
					RSS
				</span>
				<xsl:choose>
					<xsl:when test="$feedtype='image'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=1&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='audio'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=2&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='video'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=3&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;s_xml=rss&amp;s_feedtype=general&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="USERRSSICON_NONAME">
		<xsl:param name="feedtype"/>
		<xsl:param name="userid"/>
		<xsl:param name="firstnames"/>
		<xsl:param name="lastname"/>
		
		<xsl:if test="/H2G2/SITECONFIG/RSSCONFIG/ENABLED='Y'">
			<span class="rssfeed">
				<span class="label">RSS</span>
				<xsl:choose>
					<xsl:when test="$feedtype='image'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=1&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='audio'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=2&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:when test="$feedtype='video'">
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;contenttype=3&amp;s_xml=rss&amp;s_feedtype={$feedtype}&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}xml/UAMA{$userid}?articlesortby=DateUploaded&amp;s_xml=rss&amp;s_feedtype=general&amp;s_name={$firstnames}%20{$lastname}"><img src="http://www.bbc.co.uk/home/images/feed.gif" width="16" height="16" alt="RSS Feed"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</xsl:if>
	</xsl:template>
<!-- EDITORIAL TOOLS -->

<xsl:template name="quickedit">

<div class="quickeditbox">
	<table cellspacing="0" classpadding="0">
	<tr>
	<td valign="top">
	<a href="{$root}Moderate">Moderate</a><br />
	<a>
		<xsl:attribute name="href">
			<xsl:choose>
				<xsl:when test="/H2G2/SERVERNAME=$development_server">http://dnadev.national.core.bbc.co.uk/dna/comedysoupdlct</xsl:when>
				<xsl:otherwise>http://www0.bbc.co.uk/dna/comedysoup/dlct</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	Dynamic Lists
	</a>
	</td>
	<td valign="top">
	<a href="{$root}Inspectuser">Edit Users</a><br />
	<a href="{$root}NamedArticles">Named Article</a>
	</td>
	<td valign="top">
	<a href="{$root}Index?submit=new&amp;user=on&amp;submitted=on&amp;let=all">Latest</a><br />
	<a href="{$root}newusers">New Users</a>
	</td>
	<td valign="top">
	<a href="{$root}TypedArticle?acreate=new&amp;type=1">New Article</a><br />
	<a href="{$root}TypedArticle?acreate=new&amp;type=3">New Asset Library Article</a>
	</td>
	<td valign="top" class="last">
	<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Edit Page</a><br />
	<a href="{$root}editfrontpage">Edit Home</a>
	</td>
	</tr>
	</table>

	<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID">
		<div class="inlineform">
			<form name="updatemediaasset" method="post" action="{$root}MediaAsset">
				<input type="hidden" name="id" value="{/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID}"/>
				<input type="hidden" name="_msxml" value="{$updateassetfields}"/>
				<input type="hidden" name="action" value="update"/>
				<input type="hidden" name="s_articleid" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
				<!--
				<input type="hidden" name="skin" value="purexml"/>
				-->
				<input type="submit" value="Edit Media Asset"/>
			</form>
		</div>
	</xsl:if>
</div>

</xsl:template>


<xsl:template name="editorialtools">
	<div class="editbox" style="clear:both;">
		<h1 class="standardHeader">ComedySoup Editor Tools</h1>
		
		<p>
		<h2 class="editheader">Moderation Tools</h2>
		<a href="{$root}Moderate" class="button"><span><span><span>Moderate Homepage</span></span></span></a><br />
		<div class="tool">This is the tool that allows your to pass, fail, hold or refer media assets.</div>
		<a href="{$root}ModerateMediaAssets" class="button"><span><span><span>Moderate Image Library Submissions</span></span></span></a><br />
		<div class="tool">This is the original moderation tool that enable you to pass, fail, hold or refer test such as articles and messages/conversations</div>
		</p>
		
		<p><h2 class="editheader">Article Editing Tools</h2>
		<a href="{$root}editfrontpage" class="button"><span><span><span>Edit the Home Page</span></span></span></a>
		<div class="tool">This opens the edit box at the foot of the homepage which allows you to edit the homepage guideml. Storing the page will save it. Use date active to set a publish date in the future</div>

		<a href="{$root}TypedArticle?acreate=new&amp;type=1" class="button"><span><span><span>Create Editorial Article </span></span></span></a>
		<div class="tool">Use this page creation form to create all editorial pages other than the homepage. See the Guideml glossary for the layout components available on this page</div>

		<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="button"><span><span><span>Edit this page</span></span></span></a>
		<div class="tool">Use this to edit the Article you are looking at now. You can use this to edit users contributions</div>

		<a href="{$root}UserEdit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}#editusers" class="button"><span><span><span>Change the owner of this page</span></span></span></a>
		<div class="tool">Use this form to assign more than two owners to a page or to change the ower of a page. You will need the user number to do this. Find it in the URL in personal space. It starts with a U</div>

		<a href="{$root}NamedArticles" class="button"><span><span><span>Create Named Articles</span></span></span></a>
		<div class="tool">If you have created an editorial page and you want to be able to refer to it using a name rather than the Article or 'A' number then use this page to assign a name. You will need the A number of the article.</div>

		<a href="{$root}editcategory?nodeid={/H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGESPARENTCATEGORY}&amp;action=navigatesubject" class="button"><span><span><span>Edit Programme Challenge Categories</span></span></span></a>
		<div class="tool">You can add and edit Programme Challenge categories here. Create a category for a programme challenge and then add an entry into site config under "Programme Challenges Config"</div>

		<div class="tool">
			<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
				<input type="hidden" name="_msxml" value="{$configfields}"/>
				<input title="edit promos and shared text" type="submit" value="edit site config"/>
			</form>
		</div>
		<div class="tool">Use this form to update shared text and Promo's.</div>
		</p>
		
		<p>
		<h2 class="editheader">User Editing Tools</h2>
		<a href="{$root}inspectuser" class="button"><span><span><span>Edit users</span></span></span></a>
		<div class="tool">If you have the users U number you can use this page to assign the to a group such as Editor, Moderator or Invited. You can also find out their user name and email address</div>
		</p>
		
		<p>
		<h2 class="editheader">Maintenance tools</h2>
		<a href="{$root}UserEdit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" class="button"><span><span><span>Edit with useredit</span></span></span></a>
		<div class="tool">This is the old style DNA edit form. Its useful for getting all the guideml in one big text area box if you need to cut and paste whole page quickly</div>
		<a href="{$root}siteadmin" class="button"><span><span><span>Site Admin</span></span></span></a>
		<div class="tool">Use this tool to set or remove the password from the site</div>
		<a href="?skin=purexml" class="button"><span><span><span>?pure xml</span></span></span></a>
		<div class="tool">This will show you the back end XML that this page uses.</div>
		</p>
		</div>
</xsl:template>

	
<!-- dynamic lists -->
<xsl:template match="DYNAMIC-LIST">
	<xsl:variable name="listname">
			<xsl:value-of select="@NAME" />
	</xsl:variable>
	<xsl:variable name="listlength">
		<xsl:choose>
			<xsl:when test="@LENGTH &gt; 0">
				<xsl:value-of select="@LENGTH" />
			</xsl:when>
			<xsl:otherwise>
			5
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
			<ul class="iconList">
				<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_frontpage"/>
			</ul>
		</xsl:when>
		<xsl:when test="/H2G2/@TYPE='ARTICLESEARCHPHRASE'">
			<ol class="pink">
				<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_articlesearchphrase"/>
			</ol>
		</xsl:when>
		<xsl:otherwise>
			<ul class="top5List">
				<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="dynamiclist_default"/>
			</ul>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- homepage item -->
<xsl:template match="ITEM-LIST/ITEM" mode="dynamiclist_frontpage">
	<li>
		<xsl:choose>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=10">
				<xsl:attribute name="class">imagesIcon</xsl:attribute>
			</xsl:when>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=11">
				<xsl:attribute name="class">audioIcon</xsl:attribute>
			</xsl:when>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=12">
				<xsl:attribute name="class">videoIcon</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">starIcon</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	<h3><a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a></h3>
	<p><xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" /></p>
	</li>	
</xsl:template>

<!-- articlesearch page item -->
<xsl:template match="ITEM-LIST/ITEM" mode="dynamiclist_articlesearchphrase">
	<li><a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a> (<xsl:value-of select="POLL-LIST/POLL/STATISTICS/@VOTECOUNT"/> votes)</li>	
</xsl:template>

<!-- default item -->
<xsl:template match="ITEM-LIST/ITEM" mode="dynamiclist_default">
	<xsl:variable name="last"><xsl:if test="position()=last()"> last</xsl:if></xsl:variable><!-- add class last to last item in the list -->
	<li>
		<xsl:choose>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=10">
				<xsl:attribute name="class">imagesIcon<xsl:value-of select="$last"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=11">
				<xsl:attribute name="class">audioIcon<xsl:value-of select="$last"/></xsl:attribute>
			</xsl:when>
			<xsl:when test="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/TYPE/@ID=12">
				<xsl:attribute name="class">videoIcon<xsl:value-of select="$last"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">starIcon<xsl:value-of select="$last"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<div class="content">
			<h2 class="fbHeader"><a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a><xsl:text> </xsl:text><!-- <span class="small">(<xsl:value-of select="POLL-LIST/POLL/STATISTICS/@VOTECOUNT"/> votes)</span> --></h2>
			<p><xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" /></p>
			<div class="author">by <a href="U{ARTICLE-ITEM/AUTHOR/USER/USERID}"><xsl:value-of select="ARTICLE-ITEM/AUTHOR/USER/USERNAME"/></a></div>
		</div>
	</li>	
</xsl:template>
</xsl:stylesheet>