<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="br | BR">
		<xsl:text> </xsl:text>
		<br/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="P | p | B | b  | SUB | sub | SUP | sup | DIV | div | USEFULLINKS | lang | LANG | abbreviation | ABBREVIATION | acronym | ACRONYM | em | EM | strong | STRONG | cite | CITE | q | Q | I | i | SMALL | small | CODE | code | H3 | h3 | NAMEDANCHOR | namedanchor">
		<xsl:copy>	
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<!--
	<xsl:template match="BR[preceding-sibling::BR[1]]"><xsl:comment>BR</xsl:comment></xsl:template>
	-->
	
	<!--
	<xsl:template match="node()[preceding-sibling::BR[1]][not(self::BR)][not(self::QUOTE)][not(ancestor::CITE)][not(self::VIDEO)][not(self::AUDIO)][not(self::LINK)][not(self::A)][not(self::TABLE)][not(self::TH)][not(self::TD)][not(self::P)][not(self::TABLETITLE)][not(self::TABLESUBTITLE)]">
	-->
	<!--
	<xsl:template match="text()[preceding-sibling::BR[1]]">
	-->
	<!--
		<p><xsl:value-of select="."/></p>
	</xsl:template>
	-->

	<xsl:template match="HEADER | SUBHEADER | FORM | form | INPUT | input | SELECT | select | TABLE | table | TD | td | TH | th | TR | FONT| font | OL | ol | UL | ul | LI | li  | U | u | MARQUEE| marquee |CENTER | center | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="TEXTAREA">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template>
	<xsl:template match="IMG">
		<xsl:if test="not(starts-with(@SRC,'http://'))">
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<xsl:template match="OBJECT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="EMBED">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="SCRIPT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@COLOR">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@WIDTH">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@HEIGHT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@ALIGN">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="PICTURE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="TABLE | TR | TH | TD">
		<!-- do nothing -->
	</xsl:template>
	
	
	<xsl:template match="A">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<xsl:copy use-attribute-sets="mA">
					<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|@CLASS|text()"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="LINK">
		<xsl:apply-templates/>
	</xsl:template>
	-->
	
	<xsl:template match="LINK">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<a>
					<xsl:apply-templates select="@DNAID | @HREF"/>
					<xsl:call-template name="dolinkattributes"/>
					<xsl:value-of select="./text()" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="LINK | A | a" mode="truncate">
		<!--[FIXME: is this needed?]
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
		-->
				<a>
				<xsl:apply-templates select="@DNAID | @HREF"/>
				<xsl:call-template name="dolinkattributes"/>
				<xsl:call-template name="TRUNCATE_TEXT">
					<xsl:with-param name="text" select="./text()" />
					<xsl:with-param name="new_length" select="$links_max_length"/>
				</xsl:call-template>
				</a>
		<!--[FIXME: is this needed?]				
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		-->
	</xsl:template>
	
	<xsl:template match="NAMEDANCHOR">
		<a name="{@NAME}"/>
	</xsl:template>
	
	<xsl:template match="SMILEY">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="H3">
		<h3><xsl:apply-templates/></h3>
	</xsl:template>
	
	<xsl:template match="UL">
		<ul class="normal"><xsl:apply-templates/></ul>
	</xsl:template>

	<xsl:template match="OL">
		<ol class="normal"><xsl:apply-templates/></ol>
	</xsl:template>
	
	<xsl:template match="LI">
		<li><xsl:apply-templates/></li>
	</xsl:template>
	
	<!--[FIXME: remove]	
	<xsl:template match="COL2">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="TABLETITLE">
		<div class="tableTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="TABLESUBTITLE">
		<div class="tableSubTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="TABLE">
		<table border="0" class="userTable" cellspacing="0">
			<xsl:apply-templates select="*|@*|text()"/>
		</table>
	</xsl:template>
	
	<xsl:template match="TR | TH | TD">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="TR/TH[1]">
		<th class="first"><xsl:apply-templates/></th>
	</xsl:template>
	
	<xsl:template match="TR/TD[1]">
		<td class="first"><xsl:apply-templates select="*|@*|text()"/></td>
	</xsl:template>
	
	<xsl:template match="QUOTE">
		<xsl:variable name="raw_class">
			<xsl:choose>
				<xsl:when test="@align">
					quote<xsl:text> </xsl:text><xsl:value-of select="@align"/>quote
				</xsl:when>
				<xsl:when test="@ALIGN">
					quote<xsl:text> </xsl:text><xsl:value-of select="@ALIGN"/>quote
				</xsl:when>
				<xsl:otherwise>
					quote
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="translate($raw_class, '&#xA;&#9;&#10;', '')"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="QUOTE/P">
		<span class="q1"></span><xsl:value-of select="."/><span class="q2"></span>
	</xsl:template>
	
	<xsl:template match="CITE">
		<cite><xsl:apply-templates/></cite>
	</xsl:template>

	<xsl:template match="VIDEO">
		<div class="avlink">
		<a onClick="javascript:launchAVConsoleStory('{@STORYID}'); return false;" href="http://news.bbc.co.uk/sport1/hi/video_and_audio/help_guide/4304501.stm">
			<img src="http://newsimg.bbc.co.uk/sol/shared/img/v3/videosport.gif" align="left" width="60" height="13" alt="" border="0" vspace="1"/><b><xsl:value-of select="CAPTION"/></b>
		</a>
		</div>
	</xsl:template>
	-->
	
	<xsl:template match="SUBSCRIBE_NEWSLETTERFORM">
		<xsl:param name="hostOverride">no</xsl:param>
		
		<xsl:if test="$test_AuthorIsHost = 1 or $hostOverride = 'yes'">
			<!-- if editing or previewing, do not render form, as this intefereres witht the actual edit form -->
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<div id="subscribeForm">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}newslettersubthanks" />
							<input type="hidden" name="heading" value="Newsletter" />
							<input type="hidden" name="option" value="subscribe" />
							<legend><xsl:apply-templates select="HEADER"/></legend>
							<label for="subscribe_email"><xsl:apply-templates select="INTRO"/></label>
							<br/>
							<input id="subscribe_email" class="txt" type="text" name="email"/><xsl:text> </xsl:text>
							<input class="submit" type="submit" name="Submit" value="Subscribe"/>
						</fieldset>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<form name="form1" method="post" id="subscribeForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" onsubmit="return checkEmail('subscribe_email')">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}newslettersubthanks" />
							<input type="hidden" name="heading" value="Newsletter" />
							<input type="hidden" name="option" value="subscribe" />
							<legend><xsl:apply-templates select="HEADER"/></legend>
							<label for="subscribe_email"><xsl:apply-templates select="INTRO"/></label>
							<br/>
							<input id="subscribe_email" class="txt" type="text" name="email"/><xsl:text> </xsl:text>
							<input class="submit" type="submit" name="Submit" value="Subscribe"/>
						</fieldset>
					</form>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="UNSUBSCRIBE_NEWSLETTERFORM">
		<xsl:param name="hostOverride">no</xsl:param>
		
		<xsl:if test="$test_AuthorIsHost = 1 or $hostOverride = 'yes'">
			<!-- if editing or previewing, do not render form, as this intefereres witht the actual edit form -->
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<div id="UnsubscribeForm">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}newsletterunsubthanks" />
							<input type="hidden" name="heading" value="Newsletter" />
							<input type="hidden" name="option" value="unsubscribe" />
							<legend><xsl:apply-templates select="HEADER"/></legend>
							<label for="unsubscribe_email"><xsl:apply-templates select="INTRO"/></label>
							<br/>
							<input id="unsubscribe_email" class="txt" type="text" name="email"/><xsl:text> </xsl:text>
							<input class="submit" type="submit" name="Submit" value="Unsubscribe"/>
						</fieldset>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<form name="form1" method="post" id="UnsubscribeForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" onsubmit="return checkEmail('unsubscribe_email')">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}newsletterunsubthanks" />
							<input type="hidden" name="heading" value="Newsletter" />
							<input type="hidden" name="option" value="unsubscribe" />
							<legend><xsl:apply-templates select="HEADER"/></legend>
							<label for="unsubscribe_email"><xsl:apply-templates select="INTRO"/></label>
							<br/>
							<input id="unsubscribe_email" class="txt" type="text" name="email"/><xsl:text> </xsl:text>
							<input class="submit" type="submit" name="Submit" value="Unsubscribe"/>
						</fieldset>
					</form>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="CONTACTFORM">
		<xsl:if test="$test_AuthorIsHost = 1">
			<!-- if editing or previewing, do not render form, as this intefereres witht the actual edit form -->
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<div id="contactDetailsForm">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}contactthanks" />
							<input type="hidden" name="heading" value="Contact us" />
							<div class="formRow">
								<label for="name">Your name:</label>
								<input id="name" class="txt" type="text" name="name"/>
								<div class="clr"></div>
							</div>
							<div class="formRow">
								<label for="email">Your email address:</label>
								<input id="email" class="txt" type="text" name="email"/>
								<div class="clr"></div>
							</div>
							<div class="formRow">
								<label for="feedback">Your feedback:</label>
								<textarea id="feedback" class="txtArea" rows="5" cols="50" name="feedback"></textarea>
								<div class="clr"></div>
							</div>
							<div class="submitRow">
								<input type="submit" value="Submit" class="submit" name="submit"/>
								<div class="clr"></div>
							</div>
						</fieldset>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<form name="form1" method="post" id="contactDetailsForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/contact.txt">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}contactthanks" />
							<input type="hidden" name="heading" value="Contact us" />
							<div class="formRow">
								<label for="name">Your name:</label>
								<input id="name" class="txt" type="text" name="name"/>
								<div class="clr"></div>
							</div>
							<div class="formRow">
								<label for="email">Your email address:</label>
								<input id="email" class="txt" type="text" name="email"/>
								<div class="clr"></div>
							</div>
							<div class="formRow">
								<label for="feedback">Your feedback:</label>
								<textarea id="feedback" class="txtArea" rows="5" cols="50" name="feedback"></textarea>
								<div class="clr"></div>
							</div>
							<div class="submitRow">
								<input type="submit" value="Submit" class="submit" name="submit"/>
								<div class="clr"></div>
							</div>
						</fieldset>
					</form>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="USERPAGELINK">
		<xsl:if test="/H2G2/VIEWING-USER">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="$root"/>
					<xsl:text>U</xsl:text>
					<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|*" mode="applyroot">
		<xsl:choose>
			<xsl:when test="../@SITE">
				<xsl:text>/dna/</xsl:text>
				<xsl:value-of select="../@SITE"/>/<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="starts-with(.,'http://') or starts-with(.,'#') or starts-with(.,'mailto:') or (starts-with(.,'/') and contains(substring-after(.,'/'),'/'))">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="starts-with(.,'/') and string-length(.) &gt; 1">
				<xsl:value-of select="$root"/>
				<xsl:value-of select="substring(.,2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$root"/>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
