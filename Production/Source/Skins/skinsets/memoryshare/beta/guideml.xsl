<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">
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

	<xsl:variable name="brTag">
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	</xsl:variable>

	<xsl:template match="br | BR">
		<xsl:element name="br"></xsl:element>
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
				<!--xsl:copy use-attribute-sets="mA">
					<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|@CLASS|text()"/>
				</xsl:copy-->
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

	<xsl:template match="P">
		<p>
			<xsl:if test="@ID|@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@ID|@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@CLASS|@class">
				<xsl:attribute name="class">
					<xsl:value-of select="@CLASS|@class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="DIV">
		<div>
			<xsl:if test="@ID|@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@ID|@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@CLASS|@class">
				<xsl:attribute name="class">
					<xsl:value-of select="@CLASS|@class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="ACRONYM">
		<acronym>
			<xsl:if test="@ID|@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@ID|@id"/>
				</xsl:attribute>
			</xsl:if>	
			<xsl:if test="@TITLE|@title">
				<xsl:attribute name="title">
					<xsl:value-of select="@TITLE|@title"/>
				</xsl:attribute>				
			</xsl:if>
			<xsl:value-of select="text()"/>
		</acronym>
	</xsl:template>

	<xsl:template match="I">
		<em><xsl:apply-templates/></em>
	</xsl:template>

	<xsl:template match="B|b|STRONG|strong">
		<strong><xsl:apply-templates/></strong>
	</xsl:template>

	<xsl:template match="H2|h2">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<xsl:template match="H3|h3">
		<h3><xsl:apply-templates/></h3>
	</xsl:template>
	
	<xsl:template match="UL">
		<ul>
			<xsl:if test="@CLASS|@class">
				<xsl:attribute name="class">
					<xsl:value-of select="@CLASS|@class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="OL">
		<ol>
			<xsl:if test="@CLASS|@class">
				<xsl:attribute name="class">
					<xsl:value-of select="@CLASS|@class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</ol>
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
		<xsl:call-template name="SUBSCRIBE_NEWSLETTERFORM">
			<xsl:with-param name="userDefaults">no</xsl:with-param>
			<xsl:with-param name="param_subscribe_form_header">
				<xsl:value-of select="HEADER" />
			</xsl:with-param>
			<xsl:with-param name="param_subscribe_form_intro">
				<xsl:apply-templates select="INTRO/*" />
			</xsl:with-param>
			<xsl:with-param name="hostOverride">yes</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	
	
	<xsl:template name="SUBSCRIBE_NEWSLETTERFORM">
		<xsl:param name="useDefaults">yes</xsl:param>
		<xsl:param name="param_subscribe_form_header" />
		<xsl:param name="param_subscribe_form_intro" select="/.." />
		<xsl:param name="hostOverride">no</xsl:param>

		<xsl:if test="$test_AuthorIsHost = 1 or $hostOverride = 'yes'">
			<!-- if editing or previewing, do not render form, as this intefereres witht the actual edit form -->
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<xsl:text disable-output-escaping="yes">&lt;div id="subscribeForm"&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&lt;form method="post" id="subscribeForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" onsubmit="return checkEmail('subscribe_email')"&gt;</xsl:text>					
				</xsl:otherwise>
			</xsl:choose>
			<fieldset>
				<input type="hidden" name="success" value="{$host}{$root}newslettersubthanks" />
				<input type="hidden" name="heading" value="Newsletter" />
				<input type="hidden" name="option" value="subscribe" />
				<xsl:choose>
					<xsl:when test="$useDefaults='yes'">
						<h3>Subscribe to the Memoryshare newsletter</h3>
						<p>Sign up for the Memoryshare newsletter and we'll keep you up to date with all the most important developments on the service and on the calls for memories from BBC programmes. It's not a regular newsletter so we promise to only send one out when we've actually have something worth saying. It may include information about other BBC services, links or events we think might be of interest to you.</p>
						<p><strong>The BBC won't contact you for marketing purposes, or promote new services to you unless you specifically agree to be contacted for these purposes.</strong></p>
						<p>To subscribe to the Memoryshare newsletter, please type in your <label for="subscribe_email">email address</label> below and click the subscribe button.</p>
					</xsl:when>
					<xsl:otherwise>
						<h3><xsl:value-of select="$param_subscribe_form_header" /></h3>
						<xsl:apply-templates select="msxsl:node-set($param_subscribe_form_intro)/*" />
					</xsl:otherwise>
				</xsl:choose>
				<p class="pref-form-inputs"><input id="subscribe_email" class="txt" type="text" name="email"/></p>
				<p class="pref-form-inputs"><input type="image" src="/memoryshare/assets/images/subscribe-button.png" alt="Subscribe" name="subscribe" id="subscribe" /></p>
			</fieldset>
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&lt;/form&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="UNSUBSCRIBE_NEWSLETTERFORM">
		<xsl:call-template name="UNSUBSCRIBE_NEWSLETTERFORM">
			<xsl:with-param name="param_unsubscribe_form_header">
				<xsl:value-of select="HEADER" />
			</xsl:with-param>
			<xsl:with-param name="param_unsubscribe_form_intro">
				<xsl:apply-templates select="INTRO/*" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="UNSUBSCRIBE_NEWSLETTERFORM">
		<xsl:param name="useDefaults">yes</xsl:param>
		<xsl:param name="param_unsubscribe_form_header" />
		<xsl:param name="param_unsubscribe_form_intro" select="/.." />
		<xsl:param name="hostOverride">no</xsl:param>
		
		<xsl:if test="$test_AuthorIsHost = 1 or $hostOverride = 'yes'">
			<!-- if editing or previewing, do not render form, as this intefereres witht the actual edit form -->
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<xsl:text disable-output-escaping="yes">&lt;div id="UnsubscribeForm"&gt;</xsl:text>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&lt;form method="post" id="UnsubscribeForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/newsletter.txt" onsubmit="return checkEmail('unsubscribe_email')"&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<fieldset>
				<input type="hidden" name="success" value="{$host}{$root}newsletterunsubthanks" />
				<input type="hidden" name="heading" value="Newsletter" />
				<input type="hidden" name="option" value="unsubscribe" />
				<xsl:choose>
					<xsl:when test="$useDefaults='yes'">
						<h3>Unsubscribe to the Memoryshare newsletter</h3>
						<p>To unsubscribe from the Memoryshare newsletter, please type in your <label for="unsubscribe_email">email address</label> and click the unsubscribe button.</p>
					</xsl:when>
					<xsl:otherwise>
						<h3><xsl:value-of select="$param_unsubscribe_form_header" /></h3>
						<xsl:apply-templates select="msxsl:node-set($param_unsubscribe_form_intro)/*" />
					</xsl:otherwise>
				</xsl:choose>
				<p id="unsubscribe-padding" class="pref-form-inputs"><input id="unsubscribe_email" class="txt" type="text" name="email"/></p>
				<p class="pref-form-inputs"><input type="image" src="/memoryshare/assets/images/unsubscribe-button.png" name="unsubscribe" id="unsubscribe" alt="Unsubscribe" /></p>
			</fieldset>
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&lt;/form&gt;</xsl:text>
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
							<p class="pref-form-inputs">
								<label for="name">Your name:</label>
								<input id="name" class="txt" type="text" name="name"/>
							</p>
							<p class="pref-form-inputs">
								<label for="email">Your email address:</label>
								<input id="email" class="txt" type="text" name="email"/>
							</p>
							<p class="pref-form-inputs">
								<label for="feedback">Your feedback:</label>
								<xsl:text disable-output-escaping="yes">
								&lt;textarea id="feedback" class="txtArea" rows="5" cols="50" name="feedback"&gt;&lt;/textarea&gt;
								</xsl:text>
							</p>
							<p class="pref-form-inputs">
								<input type="submit" value="Submit" class="submit" name="submit"/>
							</p>
						</fieldset>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<form method="post" id="contactDetailsForm" action="http://www.bbc.co.uk/cgi-bin/cgiemail/memoryshare/contact.txt">
						<fieldset>
							<input type="hidden" name="success" value="{$host}{$root}contactthanks" />
							<input type="hidden" name="heading" value="Contact us" />
							<p class="pref-form-inputs">
								<label for="name">Your name:</label>
								<input id="name" class="txt" type="text" name="name"/>
							</p>
							<p class="pref-form-inputs">
								<label for="email">Your email address:</label>
								<input id="email" class="txt" type="text" name="email"/>
							</p>
							<p class="pref-form-inputs">
								<label for="feedback">Your feedback:</label>
								<xsl:text disable-output-escaping="yes">
								&lt;textarea id="feedback" class="txtArea" rows="5" cols="50" name="feedback"&gt;&lt;/textarea&gt;
								</xsl:text>
							</p>
							<p class="pref-form-inputs">
								<input type="submit" value="Submit" class="submit" name="submit"/>
							</p>
						</fieldset>
					</form>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="RSSLINK">
		<a>
			<xsl:attribute name="href">
				<xsl:if test="@TYPE='decade'">
				<xsl:choose>
					<xsl:when test="@SUBTYPE='1960s'">
						<xsl:text disable-output-escaping="yes">http://feeds.bbc.co.uk/dna/memoryshare/xml/ArticleSearch?contenttype=-1&amp;phrase=_memory&amp;datesearchtype=2&amp;startdate=01%2F01%2F1960&amp;enddate=31%2F12%2F1969&amp;phrase=_memory&amp;s_xml=rss&amp;sortby=dateuploaded&amp;s_client=memoryshare&amp;show=20</xsl:text>												
					</xsl:when>
					<xsl:when test="@SUBTYPE='1970s'">
						<xsl:text disable-output-escaping="yes">http://feeds.bbc.co.uk/dna/memoryshare/xml/ArticleSearch?contenttype=-1&amp;phrase=_memory&amp;datesearchtype=2&amp;startdate=01%2F01%2F1970&amp;enddate=31%2F12%2F1979&amp;phrase=_memory&amp;s_xml=rss&amp;sortby=dateuploaded&amp;s_client=memoryshare&amp;show=20</xsl:text>
					</xsl:when>
					<xsl:when test="@SUBTYPE='1980s'">
						<xsl:text disable-output-escaping="yes">http://feeds.bbc.co.uk/dna/memoryshare/xml/ArticleSearch?contenttype=-1&amp;phrase=_memory&amp;datesearchtype=2&amp;startdate=01%2F01%2F1980&amp;enddate=31%2F12%2F1989&amp;phrase=_memory&amp;s_xml=rss&amp;sortby=dateuploaded&amp;s_client=memoryshare&amp;show=20</xsl:text>
					</xsl:when>
					<xsl:when test="@SUBTYPE='1990s'">
						<xsl:text disable-output-escaping="yes">http://feeds.bbc.co.uk/dna/memoryshare/xml/ArticleSearch?contenttype=-1&amp;phrase=_memory&amp;datesearchtype=2&amp;startdate=01%2F01%2F1990&amp;enddate=31%2F12%2F1999&amp;phrase=_memory&amp;s_xml=rss&amp;sortby=dateuploaded&amp;s_client=memoryshare&amp;show=20</xsl:text>
					</xsl:when>
					<xsl:when test="@SUBTYPE='2000s'">
						<xsl:text disable-output-escaping="yes">http://feeds.bbc.co.uk/dna/memoryshare/xml/ArticleSearch?contenttype=-1&amp;phrase=_memory&amp;datesearchtype=2&amp;startdate=01%2F01%2F2000&amp;enddate=31%2F12%2F2009&amp;phrase=_memory&amp;s_xml=rss&amp;sortby=dateuploaded&amp;s_client=memoryshare&amp;show=20</xsl:text>
					</xsl:when>
				</xsl:choose>
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="@TEXT" />
		</a>
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

	<xsl:template match="@HREF|@H2G2|@DNAID">
		<xsl:attribute name="href">
			<xsl:apply-templates select="." mode="applyroot"/>
		</xsl:attribute>
	</xsl:template>

	</xsl:stylesheet>
