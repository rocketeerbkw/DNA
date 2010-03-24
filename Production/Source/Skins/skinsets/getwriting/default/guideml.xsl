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
	<xsl:template match="INPUT | input | SELECT | select | P | p | I | i | B | b | BLOCKQUOTE | blockquote | CAPTION | caption | CODE | code | OL | ol | PRE | pre | SUB | sub | SUP | sup |  BR | br | FONT| I | i">
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:copy>
		<xsl:apply-templates select="*[not(self::BR)]|@*[not(self::BR)]|text()[not(self::BR)]"/>
		</xsl:copy>

		</xsl:when>
		<xsl:otherwise>
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
		</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template match="OL | ol  | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
	<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="TABLE | table | TD | td | TH | th | TR | tr ">
			<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="LI|li">
	<li>
	<xsl:apply-templates select="*|@*|text()"/>
	</li>
	</xsl:template>
	
	<xsl:template match="UL|ul">
	<ul>
	<xsl:apply-templates select="*|@*|text()"/>
	</ul>
	</xsl:template>
	
	<xsl:template match="PARABREAK">
		<!-- <div><font size="1"><xsl:text>&nbsp;</xsl:text></font></div> -->
		<BR /><BR />
	</xsl:template>
	
	<xsl:template match="BREAK">
		<BR />
	</xsl:template>
	
	<!-- BANNER -->
    <xsl:template match="BANNER">
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='FRONTPAGE'">frontbanner</xsl:when>
		<xsl:when test="ancestor::EDITORIAL-ITEM">banner2</xsl:when>
		<xsl:otherwise>banner</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="@TYPE"/>
		</xsl:attribute>
	<table border="0" cellspacing="0" cellpadding="0">
		<xsl:attribute name="width">
		<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1"></xsl:when>
		<xsl:when test="ancestor::EDITORIAL-ITEM">380</xsl:when>
		<xsl:otherwise>400</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	<tr>
	<td height="150" valign="top"><xsl:apply-templates select="IMG" /></td>
	<td valign="top">
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='FRONTPAGE'"></xsl:when>
		<xsl:when test="$tabgroups='learn'">LearnPromo</xsl:when>
		<xsl:otherwise>MainPromo2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="BANNERPROMO/*[not(self::BR)]" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="BANNERPROMO" />
		</xsl:otherwise>
		</xsl:choose>
		</div>
	</td>
	</tr>
	</table>
	</div>
	</xsl:template>

	<xsl:template match="NAVPROMO">
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="FRONTFOOTER">
	<div class="homefooter">
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates/>
		</xsl:otherwise>
		</xsl:choose>
	</div>
	</xsl:template>
		
	<xsl:template match="PAGEFOOTER">
	<div class="PageFooter">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" />
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates/>
		</xsl:otherwise>
		</xsl:choose>
	</tr>
	</table>
	</div>
	</xsl:template>
		
	<!-- BODY -->
	<xsl:template match="BODY">
	<xsl:choose>
	<xsl:when test="child::SMALL|descendant::SMALL|ancestor::IMGPROMO1|ancestor::IMGPROMO2|ancestor::IMGPROMO3|ancestor::FRONTFOOTER|ancestor::IMGPROMO4|ancestor::IMGPROMO5|ancestor::IMGPROMO6|ancestor::IMGPROMO7">
	<div><xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates/>
	</xsl:element></div>
	</xsl:when>
	<xsl:when test="@TYPE">
	<div><xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
	<font size="2"><xsl:apply-templates/></font></div>
	</xsl:when>
	<xsl:otherwise>
	<font size="2"><xsl:apply-templates/></font>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="HEADER">
	<xsl:choose>
	<xsl:when test="following-sibling::RIGHTNAVBOX">
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="@TYPE"><xsl:value-of select="@TYPE"/></xsl:when>
		<xsl:otherwise>rightnavboxheader</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:when test="ancestor::NAVPROMO">
		<div class="NavPromoHeader">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:when test="contains(@TYPE,'title')">
		<div class="titleBars" id="{@TYPE}">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:when test="contains(@TYPE,'icon')">
		<div class="IconBars" id="{@TYPE}">
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:when test="$article_type_group='minicourse'">
	<div class="headingspace">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		<div>
			<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
			<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
			<xsl:apply-templates/>
			</xsl:element>
		</div>
		</td>
		<td align="right">
		<img src="{$graphics}icons/icon_{$article_subtype}.gif" alt="{$article_type_label}" />
		</td>
		</tr>
		</table>
		</div>
	</xsl:when>
	<xsl:otherwise>
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
			<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
			<xsl:apply-templates/>
			</xsl:element>
		</div>
	</xsl:otherwise>
	</xsl:choose>
	

	</xsl:template>
	
	<xsl:template match="SUBHEADER">
	<xsl:choose>
	<xsl:when test="ancestor::RIGHTNAVBOX">
	<span class="rightnavboxsubheading"><xsl:apply-templates/></span>
	</xsl:when>
	<xsl:when test="ancestor::NAVPROMO|ancestor::BANNERPROMO">
		<div class="NavPromoSubHeader">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:when test="child::SMALL">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:otherwise>
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates/>
			</xsl:element>
		</div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="SMALL">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="CREDIT">
	<div>
	<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
	<xsl:choose>
		<xsl:when test="parent::BODY|parent::SMALL">
		<xsl:apply-templates />
		</xsl:when>
		<xsl:otherwise>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates />
		</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
	</div>
	</xsl:template>
	
	<xsl:template match="TEXTONLY" mode="textonly_link">
	<div class="textonly"><div class="arrow2"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{.}">read text only version</a></xsl:element></div></div>
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
			<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="LINK">
	<xsl:choose>
		<!-- CTA - Creative -->
		<xsl:when test="@CTA='creative'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="{@TYPE}">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="30"/>
			</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a></div>
			</xsl:element>
		</xsl:when>
		<xsl:when test="@CTA='conversation'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="{@TYPE}">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_addcomment_signin" />
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a></div>
			</xsl:element>
		</xsl:when>
		<xsl:when test="@CTA='signin'">
			<a>
			<xsl:attribute name="href">
			<xsl:choose>
			<xsl:when test="/H2G2/PAGEUI/MYHOME[@VISIBLE=1]">
			<xsl:value-of select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)" />
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$sso_signinlink" />
			</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a>
		</xsl:when>
		<!-- CTA - Challenge -->
		<xsl:when test="@CTA='challenge'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="{@TYPE}">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="42"/>
			</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a></div>
			</xsl:element>
		</xsl:when>
		<!-- CTA - Advice -->
		<xsl:when test="@CTA='advice'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="{@TYPE}">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="41"/>
			</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a></div>
			</xsl:element>
		</xsl:when>
		<!-- CTA - Part -->
		<xsl:when test="contains(@CTA,'part')">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="{@TYPE}">
			<a>
			<xsl:attribute name="href">
			<xsl:call-template name="sso_typedarticle_signin">
			<xsl:with-param name="type" select="51"/>
			</xsl:call-template>
			&amp;s_pagetitle=<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>&amp;s_dnaid=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>&amp;s_part=<xsl:value-of select="@CTA"/>
			</xsl:attribute>
			<xsl:value-of select="./text()" />
			</a></div>
			</xsl:element>
		</xsl:when>
		<xsl:when test="ancestor::RIGHTNAVBOX and @TYPE">
			<div>
			<xsl:attribute name="class"><xsl:value-of select="@TYPE" /></xsl:attribute>
			<xsl:if test="@TYPE='video'"><xsl:copy-of select="$icon.video.grey" /></xsl:if>
			<xsl:apply-imports/>
			</div>
		</xsl:when>
<!-- 		<xsl:when test="starts-with(@HREF, 'http://') and not(starts-with(@HREF, 'http://news.bbc.co.uk')or starts-with(@HREF, 'http://www.bbc.co.uk')) and ancestor::BODY">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<span class="external">
			<xsl:apply-imports/></span>
			</xsl:element>
		</xsl:when> -->
		<!-- type for arrows  -->
		<xsl:when test="@TYPE">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div><xsl:attribute name="class"><xsl:value-of select="@TYPE" /></xsl:attribute>
			<xsl:apply-imports/></div>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<a xsl:use-attribute-sets="mLINK">
			<xsl:call-template name="dolinkattributes"/>
			<xsl:apply-templates select="." mode="long_link" />
			</a>
		</xsl:otherwise>
	</xsl:choose>

	</xsl:template>
	
	<!-- LINK ATTRIBUTES -->
	<xsl:attribute-set name="linkatt">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="@TYPE='logo'">genericlink</xsl:when>
		<xsl:when test="@TYPE='banner'"></xsl:when>
		<xsl:otherwise>genericlink</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set> 
	
	<!-- IMG -->
	<xsl:template match="IMG | img">
	<xsl:choose>
			<xsl:when test="@DNAID | @HREF">
				<a>
					
					<xsl:call-template name="dolinkattributes"/>
				
					<img src="{$imagesource}{@NAME}" border="0">
					<xsl:attribute name="class">
					<xsl:choose>
					<xsl:when test="ancestor::IMGPROMO1|ancestor::IMGPROMO2|ancestor::IMGPROMO3|ancestor::IMGPROMO4|ancestor::IMGPROMO5|ancestor::IMGPROMO6|ancestor::IMGPROMO7|ancestor::RIGHTNAVBOX"></xsl:when>
					<xsl:when test="parent::ICON|@ALIGN">imageborder</xsl:when>
					<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</xsl:attribute>
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
				</a>
			</xsl:when>
			<xsl:when test="@CTA='advice'">
				<a>
				<xsl:attribute name="href">
				<xsl:call-template name="sso_typedarticle_signin">
				<xsl:with-param name="type" select="41"/>
				</xsl:call-template>
				</xsl:attribute>
					<img src="{$imagesource}{@NAME}" border="0">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
				</a>
			</xsl:when>
			<xsl:when test="@CTA='challenge'">
				<a>
				<xsl:attribute name="href">
				<xsl:call-template name="sso_typedarticle_signin">
				<xsl:with-param name="type" select="42"/>
				</xsl:call-template>
				</xsl:attribute>
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
	
	
 	<xsl:template match="RIGHTNAVBOX">
	<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates />
		</xsl:element>
	</div>
	</xsl:template> 
	
	<xsl:template match="ICON">
	<!-- i am sorry this is a table not two floated div's.... i just dont have time to mess with css -->
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<table border="0" cellspacing="0" cellpadding="0">
		<xsl:attribute name="width">
		<xsl:choose>
			<xsl:when test="ancestor::FRONTFOOTER">396</xsl:when>
			<xsl:when test="count(ancestor::ROW/EDITORIAL-ITEM)=1">390</xsl:when>
			<xsl:when test="ancestor::IMGPROMO1|ancestor::IMGPROMO2|ancestor::IMGPROMO3|ancestor::IMGPROMO4|ancestor::IMGPROMO5|ancestor::IMGPROMO6|ancestor::IMGPROMO7|ancestor::RIGHTNAVBOX">195</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<tr>
		<td valign="top"><div class="icon"><xsl:apply-templates select="IMG" /></div></td>
		<td width="85%" valign="top"><div class="icontext"><xsl:apply-templates select="*[not(self::IMG)]" /></div></td>
		</tr>
		</table></div>
	</xsl:template>
	
	 
	<xsl:template match="IMGPROMO">
		<div class="globalPromoBg">
		<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<xsl:template match="IMGPROMO1">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO1/*|@*|text()" /></div>
	</xsl:template>
	
	<xsl:template match="IMGPROMO2">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2/*|@*|text()" /></div>
		</xsl:template>
	
	<xsl:template match="IMGPROMO3">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3/*|@*|text()" /></div>
	</xsl:template>
	
	<xsl:template match="IMGPROMO4">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO4/*|@*|text()" /></div>
	</xsl:template>
	
	<xsl:template match="IMGPROMO5">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO5/*|@*|text()" /></div>
		</xsl:template>
	
	<xsl:template match="IMGPROMO6">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO6/*|@*|text()" /></div>
	</xsl:template>
	
	<xsl:template match="IMGPROMO7">
		<div>
		<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO7/*|@*|text()" />
		</div>
	</xsl:template>
	
	<xsl:template match="TEXTPROMO1">
		<td><xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO1/*|@*|text()" /></td>
	</xsl:template>
	
	<xsl:template match="TEXTPROMO2">
		<td><xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO2/*|@*|text()" /></td>
	</xsl:template>
	
	<xsl:template match="TEXTPROMO3">
		<td><xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO3/*|@*|text()" /></td>
	</xsl:template>
	
	<xsl:template match="TEXTPROMO4">
		<td><xsl:apply-templates select="/H2G2/SITECONFIG/TEXTPROMO4/*|@*|text()" /></td>
	</xsl:template>
	
	<xsl:template match="TIMETABLE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/TIMETABLE/*|@*|text()" />
	</xsl:template>
	
	<xsl:template match="CALENDAR">
	<xsl:apply-templates select="/H2G2/SITECONFIG/CALENDAR/*|@*|text()" />
	</xsl:template>
	
	
	
	<xsl:template match="ROW">
	<xsl:variable name="columncount"><xsl:value-of select="count(../EDITORIAL-ITEM)" /></xsl:variable>
	<div>
	<xsl:attribute name="class">
	<xsl:choose>
		<xsl:when test="@TYPE"><xsl:value-of select="@TYPE"/></xsl:when>
	</xsl:choose>
	</xsl:attribute>
	<table border="0" cellspacing="0" cellpadding="0">
	<xsl:attribute name="width">
	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1"></xsl:when>
		<xsl:when test="$columncount=3">100%</xsl:when>
		<xsl:when test="$columncount=2">100%</xsl:when>
		<xsl:otherwise>410</xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>
	<tr>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
	</tr>
	</table>
	</div>
	</xsl:template>
		
	
	<xsl:template match="EDITORIAL-ITEM">
	<xsl:variable name="columncount"><xsl:value-of select="count(../EDITORIAL-ITEM)" /></xsl:variable>
	
		<td valign="top">
		<xsl:attribute name="width">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1"></xsl:when>
			<xsl:when test="$columncount=3">207</xsl:when>
			<xsl:when test="$columncount=2 and parent::ROW/@TYPE='promoRow'">50%</xsl:when>
			<xsl:when test="$columncount=2">201</xsl:when>
			<xsl:otherwise>410</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
			<xsl:when test="@TYPE"><xsl:value-of select="@TYPE"/></xsl:when>
			<xsl:when test="descendant::BANNERPROMO">promobanner</xsl:when>
			<xsl:when test="$columncount=3">promoMain3</xsl:when>
			<xsl:when test="$columncount=2">promoMain1</xsl:when>
			<xsl:otherwise>promoMain</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
		</div>
		</td>
		<xsl:if test="../@TYPE='promoRow' and position()=last()"><td width="10" class="promocol"><img src="/t/f.gif" alt="" width="10" height="1" border="0" /></td></xsl:if>
	</xsl:template>
	
	<xsl:template match="hr|HR|LINE">
		<hr class="line"/>
	</xsl:template>
	
	<xsl:template match="PART1|PART2|PART3|PART4">
	<xsl:apply-templates select="SUBHEADER[contains(@TYPE,'part')]" />
	<div class="box1">
			<xsl:apply-templates select="*[not(self::SUBHEADER[contains(@TYPE,'part')])]"/>
	</div>
	</xsl:template>
	
	<xsl:template match="COLUMN">
	<div>
	<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td><xsl:apply-templates select="LEFTCOL"/></td>
	<td>&nbsp;</td>
	<td align="right"><xsl:apply-templates select="RIGHTCOL"/></td>
	</tr>
	</table>
	</div>
	</xsl:template>

	<!-- BESPOKE -->
	
	<xsl:template match="FLASH">
	<script language="javascript" src="{$jscriptsource}javascript_flash_detect.js"></script>
	<script language="VBscript" src="{$jscriptsource}flash_detect.js"></script> 

	<table width="620" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="center"><br/>
	<!-- Flash embed -->
	<!-- DO NOT EDIT THE LINE BELOW -->
	<!-- Flash Detect SSITool (Multi-clip pt2 of 2) v2.2  do not copy, see http://intracat/ssi/ for usage -->
	<xsl:variable name="flash_url">
	<xsl:choose>
	<xsl:when test="$current_article_type=53">
	<xsl:value-of select="concat(FLASH-URL,/H2G2/VIEWING-USER/USER/USERID,'&amp;s_show=',/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE)"/>
	</xsl:when>
	<xsl:otherwise><xsl:apply-templates select="FLASH-URL"/></xsl:otherwise>
	</xsl:choose>
	
	
	
	</xsl:variable>
	
	<xsl:variable name="flash_height">
	<xsl:choose>
	<xsl:when test="FLASH-HEIGHT"><xsl:apply-templates select="FLASH-HEIGHT"/></xsl:when>
	<xsl:otherwise>410</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="flash_width">
	<xsl:choose>
	<xsl:when test="FLASH-WIDTH"><xsl:apply-templates select="FLASH-WIDTH"/></xsl:when>
	<xsl:otherwise>620</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<script language="Javascript">
	flashUrl = '<xsl:value-of select="$flash_url"/>'
	flashHeight = '<xsl:value-of select="$flash_height"/>'
	flashWidth = '<xsl:value-of select="$flash_width"/>'
	
	
	
	//flashUrl = flashUrl + '&amp;total=' + moduleNum;
	//document.write(flashUrl);
	<![CDATA[
	<!--
	if ((flashDetect == true) || (flashDetect == 1)) {
	//alert(flashUrl);
	document.write ('<object id="ssitools_flash_movie" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="' + flashWidth + '" height="' + flashHeight + '"  ALIGN=""><param name="movie" value="' + flashUrl + '"/><param name="quality" value="high"/><param name="bgcolor" value="#DBD3C6"/><embed src="' + flashUrl + '" quality=\high" bgcolor="#751E5D" width="' + flashWidth + '" height="' + flashHeight + '" type="application/x-shockwave-flash"  pluginspage="http://www.macromedia.com/go/getflashplayer" swLiveconnect="true"></embed></object>');
	}
	else {
	document.write('<font class="white"><b>You must install flash for this page to work</b></font>');
	}
	-->
	]]>
	</script>
	<noscript>
	<font class="white">
	<b>You must install flash for this page to work</b>
	</font>
	</noscript>
	
	<!-- END Flash Detect SSITool -->
	<!-- End Flash embed -->
	</td></tr></table>
	</xsl:template>
	
<xsl:template match="SUBSCRIBE-NEWSLETTER">
<div align="center"><!-- http://dev3.kw.bbc.co.uk -->
<form method="post" action="http://www.bbc.co.uk/cgi-bin/cgiemail/getwriting/newsletter/newsletter.txt" name="bbcform" >
<input type="hidden" name="success" value="http://www.bbc.co.uk/dna/getwriting/newsletter-thanks" />
<input type="text" size="20" name="required_email" value="your email" />
<input type="hidden" name="subject" value="Newsletter" />

<br />

                    
<input type="radio" name="whichlist" value="getwriting" checked="checked"/>
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">html (recommended) </xsl:element>
                    
<input type="radio" name="whichlist" value="getwritingtext" />
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">text <br />
Hotmail users: Our newsletters may end up in your junk mail folder.</xsl:element><br />

<input type="image" src="{$graphics}buttons/button_subscribe.gif" alt="SUBSCRIBE" border="0" VALUE="subscribe" vspace="12" />
                  
</form></div>
</xsl:template>

<xsl:template match="UNSUBSCRIBE-NEWSLETTER">
<div align="center"><form method="post" action="http://www.bbc.co.uk/cgi-bin/cgiemail/getwriting/newsletter/unsubscribe.txt" name="bbcform2" onSubmit="if (!document.images) return true;  ">
<!-- this.required_email.optional = true; return verify2(this);-->
<input type="hidden" name="success" value="http://www.bbc.co.uk/dna/getwriting/newsletter-cancelled" />
<input type="text" size="20" name="required_email2" value="your email" />
<input type="hidden" name="subject2" value="Newsletter Cancellation" />
                    <br />
                    <br />

<input type="image" src="{$graphics}buttons/button_unsubscribe.gif" alt="UNSUBSCRIBE" border="0" VALUE="unsubscribe" vspace="8" />
                  
</form></div>
</xsl:template>
	
	<xsl:template match="FLASH-URL">
	<xsl:value-of select="."/>
	</xsl:template>
	

	<xsl:template match="SMILEY">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
