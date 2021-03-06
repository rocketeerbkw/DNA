<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

		<!-- GUIDEML -->
	<xsl:template match="br | BR | INPUT | input | SELECT | select | P | p | B | b  | SUB | sub | SUP | sup | tr | BR | br | DIV | div | USEFULLINKS | lang | LANG | abbreviation | ABBREVIATION | acronym | ACRONYM | em | EM | strong | STRONG | cite | CITE | q | Q | U | u | SMALL | small | CODE | code">
		<xsl:copy>	<!-- TODO:8 -->	
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	

	<xsl:template match="TABLE | table | TD | td | TH | th | TR | FONT| OL | ol | I | i | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
	<xsl:apply-templates />
	</xsl:template>
	
	<!-- BODY -->
	<xsl:template match="BODY">

	<xsl:choose>
	<xsl:when test="child::SMALL">
	<xsl:apply-templates/>
	</xsl:when>
	<xsl:when test="ancestor::RIGHTNAV">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><xsl:apply-templates/></xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates/></xsl:element>
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>

	<xsl:template match="BOX">

		<xsl:variable name="cell_colour">
			<xsl:value-of select="@TYPE" />
		</xsl:variable>
		
		<div class="{$cell_colour}">
		<xsl:apply-templates/>
		</div>
		
	</xsl:template>

	<xsl:template match="TEXTAREA">
		<form>
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</form>
	</xsl:template>
	

	<xsl:template match="PARABREAK">
		<!-- <div><font size="1"><xsl:text>&nbsp;</xsl:text></font></div> -->
		<BR /><BR />
	</xsl:template>
	
	<xsl:template match="BREAK">
		<BR />
	</xsl:template>
	

	
	<xsl:template match="SMALL">
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><xsl:apply-templates/></xsl:element>
	</xsl:template>
		
	
	<xsl:template match="BULLET">
	 <div class="icon-bullet">
		<xsl:choose>
		<xsl:when test="parent::SMALL|parent::RELATEDREVIEWS|parent::RELATEDCONVERSATIONS|parent::SEEALSO|parent::ALSOONBBC|parent::LIKETHIS">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<xsl:apply-templates/>
			</xsl:element>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates/>
			</xsl:element>
		</xsl:otherwise>
		</xsl:choose>
		</div>			
	</xsl:template>
	
<!-- 	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template> -->
	
	<!-- IMG -->
	<xsl:template match="IMG | img">
	<xsl:choose>
				<xsl:when test="@TYPE='noborder'">
				<img src="{$graphics}{@NAME}" border="0">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
			</xsl:when>
			<xsl:when test="@DNAID | @HREF">
				<a>
					<xsl:apply-templates select="@DNAID | @HREF"/>
					<img src="{$graphics}{@NAME}" border="0" class="guideml-a">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
				</a>
			</xsl:when>
			<xsl:when test="parent::HEADER|parent::ISSUENUMBER|ancestor::MULTI-ELEMENT[@NAME='ISSUENUMBER']/VALUE">
				<img src="{$imagesource}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</xsl:when>
			<xsl:when test="parent::SNIPPET">
				<img src="{$imagesource}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</xsl:when>
			<xsl:when test="parent::BODY">
				<img src="{$graphics}{@NAME}" border="0" class="guideml-a">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$graphics}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<!-- PICTURE -->
	 <xsl:template match="PICTURE" mode="display">
		<div align="center"><xsl:call-template name="renderimage"/></div>
		<xsl:call-template name="insert-caption"/>
	 </xsl:template> 
	 
	<!-- BANNER -->
    <xsl:template match="BANNER">
	<xsl:apply-templates select="IMG" />
	<xsl:choose>
	
	<xsl:when test="parent::FRONTPAGE">
	<div class="hp-text">
	<xsl:element name="{$text.frontheading}" use-attribute-sets="text.frontheading">
	<xsl:apply-templates select="TEXT" />
	<xsl:apply-templates select="LINK[@TYPE='banner']" />
	</xsl:element>
	</div>
	</xsl:when>
	
	<xsl:otherwise>
	<div class="frontimage">
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<xsl:apply-templates select="TEXT" />
	<xsl:apply-templates select="LINK[@TYPE='banner']" />
	</xsl:element>
	</div>
	
	<xsl:if test="BODY">
	<div class="frontimagebox"><xsl:apply-templates select="BODY" /></div>
	</xsl:if>
	</xsl:otherwise>
	</xsl:choose>

	</xsl:template> 
	<!-- A -->
	<xsl:template match="A">
		<xsl:copy use-attribute-sets="mA">
			<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- SUBJECT -->
	<xsl:template match="SUBJECT">
	<div class="frontpagesubject"><xsl:apply-templates/></div>
	</xsl:template>

	<!-- LINK -->
	<xsl:template match="LINK">
		<xsl:choose>
		<!-- gallery link -->
		<xsl:when test="@POPUP='gallery'">
		    <xsl:element name="{$text.base}" use-attribute-sets="text.base"><span class="guideml-b">
			<a xsl:use-attribute-sets="mLINK">
			<xsl:attribute name="HREF">http://www.bbc.co.uk/collective/gallery/2/static.shtml?collection=<xsl:value-of select="@COLLECTION" /></xsl:attribute>
			<xsl:attribute name="onClick">open_gallery('http://www.bbc.co.uk/collective/gallery/2/index.shtml?collection=<xsl:value-of select="@COLLECTION" />&amp;mode=dynamic',this.target,<xsl:value-of select="@WIDTH" />,<xsl:value-of select="@HEIGHT" />);return false;</xsl:attribute>
			<xsl:attribute name="target">collectivegallery</xsl:attribute>	
			<xsl:apply-templates/>
			</a></span>
			</xsl:element>
		</xsl:when>
		<xsl:when test="@POPUP='gallery' and @TYPE='icon'">
		    <xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<a xsl:use-attribute-sets="mLINK">
			<xsl:attribute name="HREF">http://www.bbc.co.uk/collective/gallery/2/static.shtml?collection=<xsl:value-of select="@COLLECTION" /></xsl:attribute>
			<xsl:attribute name="onClick">open_gallery('http://www.bbc.co.uk/collective/gallery/2/index.shtml?collection=<xsl:value-of select="@COLLECTION" />&amp;mode=dynamic',this.target,<xsl:value-of select="@WIDTH" />,<xsl:value-of select="@HEIGHT" />);return false;</xsl:attribute>
			<xsl:attribute name="target">collectivegallery</xsl:attribute>	
			<xsl:apply-templates/>
			</a>
			</xsl:element>
		</xsl:when>
		<xsl:when test="@CTA='article' and parent::SMALL">
		
					<!-- <xsl:copy-of select="$arrow.right" /><a href="{$root}{$create_member_review}" xsl:use-attribute-sets="nc_createnewarticle">
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="2"/>
					</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="./text()" />
					</a> -->
			
		</xsl:when>
		<xsl:when test="@CTA='article'">
		<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<xsl:copy-of select="$arrow.right" /><a href="{$root}{$create_member_review}" xsl:use-attribute-sets="nc_createnewarticle">
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="2"/>
					</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="./text()" />
					</a>
			</xsl:element> -->
		</xsl:when>
		<xsl:when test="@CTA='review' and parent::SMALL">
		
				<!-- 	<xsl:copy-of select="$arrow.right" /><a href="{$root}{$create_member_review}" xsl:use-attribute-sets="nc_createnewarticle">
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="10"/>
					</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="./text()" />
					</a> -->
			
		</xsl:when>
		<xsl:when test="@CTA='review'">
		<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<xsl:copy-of select="$arrow.right" /><a href="{$root}{$create_member_review}" xsl:use-attribute-sets="nc_createnewarticle">
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="10"/>
					</xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="./text()" />
					</a>
			</xsl:element> -->
		</xsl:when>
		<xsl:when test="@TYPE='logo'">
		<div class="icon-bullet">
		<xsl:choose>
		<xsl:when test="ancestor::RIGHTNAV|parent::RELATEDREVIEWS|parent::RELATEDCONVERSATIONS|parent::SEEALSO|parent::ALSOONBBC|ancestor::RECOMMENDED|parent::LIKETHIS">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:value-of select="./text()" />
			</a>
			</xsl:element>
			 <xsl:if test="TYPE"><span class="article-type"><xsl:text>&nbsp;</xsl:text><xsl:value-of select="TYPE" /></span></xsl:if>
		</xsl:when>
		<xsl:when test="parent::SMALL">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:value-of select="./text()" />
			</a>
			
			 <xsl:if test="TYPE"><span class="article-type"><xsl:text>&nbsp;</xsl:text><xsl:value-of select="TYPE" /></span></xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:value-of select="./text()" />
			</a>
			</xsl:element>
		 <xsl:if test="TYPE"><span class="article-type"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:text>&nbsp;</xsl:text><xsl:value-of select="TYPE" /></xsl:element></span></xsl:if>
		</xsl:otherwise>
		</xsl:choose>
		</div>			

		</xsl:when>
		
		<!-- ICON -->
		<xsl:when test="@TYPE='icon'">
		
			<xsl:choose>
			<xsl:when test="contains(IMG/@NAME,'white')">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"><span class="guideml-c"><xsl:apply-imports/></span></xsl:element>
			</xsl:when>
			<xsl:when test="parent::RELATEDREVIEWS|parent::RELATEDCONVERSATIONS|parent::SEEALSO|RIGHTNAV">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><span class="guideml-b"><xsl:apply-imports/></span></xsl:element>
			</xsl:when>
			<xsl:otherwise>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"><span class="guideml-b"><xsl:apply-imports/></span></xsl:element>
			</xsl:otherwise>
			</xsl:choose>
		
			
		</xsl:when>
		
		<!-- BANNER -->
		<xsl:when test="@TYPE='banner'">
		<xsl:apply-imports/>
		</xsl:when>
		<!-- ARROW -->
		<xsl:when test="@TYPE='arrow'">
		<xsl:choose>
		<xsl:when test="parent::SMALL|parent::INFOBOX">
			<xsl:copy-of select="$arrow.right" /><xsl:apply-imports/>
		</xsl:when>
		<xsl:when test="ancestor::RIGHTNAV">
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><xsl:copy-of select="$arrow.right" /><xsl:apply-imports/></xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$arrow.right" /><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-imports/></xsl:element>
		</xsl:otherwise>
		</xsl:choose>			
		</xsl:when>
		<!-- AUDIO-->
		<xsl:when test="@TYPE='audio'">
		<xsl:choose>
		<xsl:when test="parent::SMALL">
			<xsl:copy-of select="$icon.audio" /> <xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$icon.audio" /> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-imports/></xsl:element>
		</xsl:otherwise>
		</xsl:choose>			
		</xsl:when>
		<!-- VIDEO -->
		<xsl:when test="@TYPE='video'">
		<xsl:choose>
		<xsl:when test="parent::SMALL">
			<xsl:copy-of select="$icon.video" /> <xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$icon.video" /> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-imports/></xsl:element>
		</xsl:otherwise>
		</xsl:choose>			
		</xsl:when>
		<!-- archive/issue -->
		<xsl:when test="@TYPE='issue'">
		<xsl:choose>
		<xsl:when test="parent::SMALL">
			<xsl:copy-of select="$icon.issue" /> <xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$icon.issue" /> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-imports/></xsl:element>
		</xsl:otherwise>
		</xsl:choose>			
		</xsl:when>
		<!-- NORMAL -->
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="parent::SMALL|parent::RELATEDREVIEWS|parent::RELATEDCONVERSATIONS|parent::SEEALSO|parent::ALSOONBBC|ancestor::FURNITURE|parent::USEFULLINKS">
				
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:apply-templates select="." mode="long_link" />
			</a>
			<xsl:text>  </xsl:text>
			<span class="article-type"><xsl:value-of select="TYPE" /></span>
			</xsl:when>
			<xsl:when test="ancestor::RIGHTNAV">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">		
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:apply-templates select="." mode="long_link" />
			</a></xsl:element>
			
	   <xsl:if test="following-sibling::TYPE">
			<xsl:text>  </xsl:text>
			<span class="article-type"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><xsl:value-of select="TYPE" /></xsl:element></span></xsl:if> 
			</xsl:when>
			<xsl:otherwise>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">		
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:apply-templates select="." mode="long_link" />
			</a></xsl:element>
			
	   <xsl:if test="following-sibling::TYPE">
			<xsl:text>  </xsl:text>
			<span class="article-type"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:value-of select="TYPE" /></xsl:element></span></xsl:if> 

			</xsl:otherwise>
			</xsl:choose>
			

		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<!-- LINK ATTRIBUTES -->
	<xsl:attribute-set name="linkatt">
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="../TOP-FIVE-ARTICLE">article-title</xsl:when>
		<xsl:when test="../TOP-FIVE-FORUM">article-title</xsl:when>
		<xsl:when test="@TYPE='logo'">article-title</xsl:when>
		<xsl:when test="@TYPE='banner'"></xsl:when>
													<!-- v3 cat CLASS DEFINITION OF ARTICLE LINK -->
		<xsl:otherwise>title</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set> 

	
	<xsl:template match="TYPE | DESCRIPTION">
	<xsl:choose>
	<xsl:when test="parent::RELATEDREVIEWS|parent::RELATEDCONVERSATIONS|parent::SEEALSO|parent::ALSOONBBC">
		<span class="article-type"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><xsl:apply-templates/></xsl:element></span>
	</xsl:when>
	<xsl:otherwise>
		<span class="article-type"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates/></xsl:element></span>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template> 
	
	<xsl:template match="LINKICON">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="LINK[@TYPE='icon']" />
	<xsl:apply-templates select="TYPE" />
	<div><xsl:apply-templates select="BODY" /></div>
	<br clear="all" />
	</xsl:element>
	</xsl:template>
	
	<xsl:template match="LINE | hr | HR">
		<xsl:choose>
		<xsl:when test="@TYPE='space'">
		<div class="page-space"/>
		</xsl:when>
		<xsl:otherwise>
		<hr class="page-break"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	
	<xsl:template match="WIN">
	<xsl:variable name="cell_colour">
		<xsl:value-of select="@TYPE" />
	</xsl:variable>
	<div class="{$cell_colour}"><xsl:apply-templates select="/H2G2/SITECONFIG/WIN/*" /></div>
	</xsl:template>
	
	<xsl:template match="ISSUENUMBER">
		<xsl:apply-templates select="/H2G2/SITECONFIG/ISSUENUMBER/*" />
	</xsl:template>
	
	
	<xsl:template match="LASTWEEKWIN">
		<xsl:apply-templates select="/H2G2/SITECONFIG/LASTWEEKWIN/*" />
	</xsl:template>
	
	<xsl:template match="CREATEPAGE">
	<xsl:variable name="cell_colour">
		<xsl:choose>
		<xsl:when test="@TYPE='orangebox'">orangeboxcol</xsl:when>
		<xsl:otherwise><xsl:value-of select="@TYPE" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<div id="{$cell_colour}"><xsl:apply-templates select="/H2G2/SITECONFIG/CREATEPAGE/*" /></div>
		
	</xsl:template>
	
	
	<xsl:template match="WRITEREVIEW">
		<xsl:variable name="cell_colour">
		<xsl:choose>
		<xsl:when test="@TYPE='orangebox'">orangeboxcol</xsl:when>
		<xsl:otherwise><xsl:value-of select="@TYPE" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<div id="{$cell_colour}"><xsl:apply-templates select="/H2G2/SITECONFIG/WRITEREVIEW/*" /></div>
	
	</xsl:template>
	
	<xsl:template match="MUSICFEATURE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MUSICFEATURE/*" />
	</xsl:template>
	
	<xsl:template match="FILMFEATURE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/FILMFEATURE/*" />
	</xsl:template>
	
	<xsl:template match="MORECULTUREFEATURE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREFEATURE/*" />
	</xsl:template>
	
	<xsl:template match="TALKFEATURE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/TALKFEATURE/*" />
	</xsl:template>
	
	<xsl:template match="ALBUMWEEK">
	<xsl:apply-templates select="/H2G2/SITECONFIG/ALBUMWEEK/*" />
	</xsl:template>
	
	<xsl:template match="CINEMAWEEK">
	<xsl:apply-templates select="/H2G2/SITECONFIG/CINEMAWEEK/*" />
	</xsl:template>
	
	<xsl:template match="MORECULTURE">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTURE/*" />
	</xsl:template>
	
	<xsl:template match="MOREALBUM">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MOREALBUM/*" />
	</xsl:template>		
	
	<xsl:template match="MORECINEMA">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECINEMA/*" />
	</xsl:template>					
					
	<xsl:template match="MORECULTUREREVIEWS">
	<xsl:apply-templates select="/H2G2/SITECONFIG/MORECULTUREREVIEWS/*" />
	</xsl:template>		
	
<xsl:template match="SMILEY">
		<xsl:choose>
			<xsl:when test="contains($smileylist, concat(translate(@TYPE,$uppercase,$lowercase), ','))">
				<xsl:choose>
					<xsl:when test="@H2G2|@h2g2|@BIO|@bio|@HREF|@href">
						<xsl:variable name="url">
							<xsl:value-of select="@H2G2|@h2g2|@BIO|@bio|@HREF|@href"/>
						</xsl:variable>
						<a href="{$root}{$url}">
							<xsl:if test="substring($url, 0, 1) != '#'">
								<xsl:attribute name="target">_top</xsl:attribute>
							</xsl:if>
							<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{translate(@TYPE,$uppercase,$lowercase)}.gif"/>
						</a>&space;
					</xsl:when>
					<xsl:otherwise>
						<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{@TYPE}.gif"/>&space;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				&lt;<xsl:value-of select="@TYPE"/>&gt;
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ICON">
		<xsl:choose>
			<xsl:when test='starts-with(@SRC|@BLOB,"http://") or starts-with(@SRC|@BLOB,"/")'>
				<!-- <xsl:comment>Off-site picture removed</xsl:comment> -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="renderimage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="HEADER">
		<xsl:choose>
		<xsl:when test="parent::WRITEREVIEW | parent::CREATEPAGE">
		<div class="generic-nopadding">
		<xsl:copy-of select="$myspace.portfolio.orange" />&nbsp;<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong><xsl:apply-templates/></strong></xsl:element></div>
		</xsl:when>
		<xsl:when test="@TYPE='boxheader'"><!-- 
		<div class="greenorangetitle"><xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong><xsl:apply-templates/></strong></xsl:element></div> -->
		</xsl:when>
		<xsl:otherwise>
		 <div>
		 <xsl:attribute name="class"><xsl:value-of select="@TYPE" /></xsl:attribute>
		 <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong><xsl:apply-templates/></strong></xsl:element></div>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="SUBHEADER">
		<xsl:choose>
		<xsl:when test="ancestor::WIN|parent::SMALL|ancestor::RECOMMENDED">
			<span class="article-type">
<strong><xsl:apply-templates/></strong>
</span><br />
		</xsl:when>
		<xsl:when test="ancestor::RIGHTNAV">
			<span class="article-type">
<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><strong><xsl:apply-templates/></strong></xsl:element>
</span><br />
		</xsl:when>
		<xsl:otherwise>
			<span class="article-type"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong><xsl:apply-templates/></strong></xsl:element></span><br />
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!-- PULLQUOTE -->
	<xsl:template match="PULLQUOTE">
	<xsl:choose>
	<xsl:when test="@EMBED">
	<xsl:element name="TABLE">

	<xsl:attribute name="ALIGN"><xsl:value-of select="@EMBED"/></xsl:attribute>
	<TR VALIGN="top"><td width="175" align="left">
	<div class="pullquote">
	<xsl:choose>
	<xsl:when test="@ALIGN">
	<xsl:attribute name="ALIGN"><xsl:value-of select="@ALIGN"/></xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	<xsl:attribute name="ALIGN">CENTER</xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	
	<xsl:apply-templates/>
	</div>
	
	</td></TR>
	</xsl:element>
	</xsl:when>
	<xsl:otherwise>
	<div class="pullquote">
	<xsl:choose>
	<xsl:when test="@ALIGN">
	<xsl:attribute name="ALIGN"><xsl:value-of select="@ALIGN"/></xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	<xsl:attribute name="ALIGN">CENTER</xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates/>
	</div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- breaks long links -->
	<xsl:template match="*" mode="long_link">
	
	<xsl:choose>
	<xsl:when test="starts-with(.,'http://')">
	<xsl:value-of select="substring(./text(),1,50)" />...
	</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="./text()" />
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>
	
	
	
	<xsl:attribute-set name="pullquote" use-attribute-sets="mainfont">
	<xsl:attribute name="color"></xsl:attribute>
	<xsl:attribute name="face">arial</xsl:attribute>
	<xsl:attribute name="SIZE">2</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="pullquotetable">
	<xsl:attribute name="CELLPADDING">6</xsl:attribute>
	<xsl:attribute name="CELLSPACING">6</xsl:attribute>
	<xsl:attribute name="WIDTH">200</xsl:attribute>
	<xsl:attribute name="BGCOLOR">#ffcc66</xsl:attribute>
	</xsl:attribute-set>

	<!-- override the base templates in order to do Go tracking SZ jan 2005 -->
	<xsl:template name="dolinkattributes">
		<xsl:choose>
				<xsl:when test="@POPUP">
				<xsl:variable name="url">
					<xsl:if test="@H2G2">
						<xsl:apply-templates select="@H2G2" mode="applyroot"/>
					</xsl:if>
					<xsl:if test="@DNAID">
						<xsl:apply-templates select="@DNAID" mode="applyroot"/>
					</xsl:if>
					<xsl:if test="@HREF">
					<!-- external go  tracking -->
					<xsl:choose>
					<xsl:when test="starts-with(@HREF, 'http://') and not(starts-with(@HREF, 'http://news.bbc.co.uk')or starts-with(@HREF, 'http://www.bbc.co.uk'))">
					http://www.bbc.co.uk/go/dna/collective/ext/ide1/-/<xsl:value-of select="@HREF"/> 
					</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="@HREF" mode="applyroot"/></xsl:otherwise>
					</xsl:choose>			
					</xsl:if>
					<xsl:if test="@BIO">
						<xsl:apply-templates select="@BIO" mode="applyroot"/>
					</xsl:if>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="@STYLE">
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
				<xsl:if test="@H2G2|@h2g2">
					<xsl:apply-templates select="@H2G2"/>
					<!--<xsl:attribute name="TARGET">_top</xsl:attribute>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="@H2G2|@h2g2"/></xsl:attribute>-->
				</xsl:if>
				<xsl:if test="@DNAID">
					<xsl:apply-templates select="@DNAID"/>
				</xsl:if>
				<xsl:if test="@HREF|@href">
				<!-- external go  tracking -->
					<xsl:choose>
					<xsl:when test="starts-with(@HREF, 'http://') and not(starts-with(@HREF, 'http://news.bbc.co.uk')or starts-with(@HREF, 'http://www.bbc.co.uk'))">
					<xsl:attribute name="HREF">http://www.bbc.co.uk/go/dna/collective/ext/ide1/-/<xsl:value-of select="@HREF"/></xsl:attribute> 
					</xsl:when>
					<xsl:otherwise>
					<xsl:apply-templates select="@HREF"/>
					</xsl:otherwise>
					</xsl:choose>
					
				</xsl:if>
				<xsl:if test="@BIO|@bio">
					<xsl:attribute name="TARGET">_top</xsl:attribute>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="@BIO|@bio"/></xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="COLUMN">
	<div>
	<xsl:attribute name="class"><xsl:value-of select="@TYPE"/></xsl:attribute>
	<table border="0" cellspacing="0" cellpadding="0">
	<xsl:if test="ancestor::RIGHTNAV"><xsl:attribute name="width">170</xsl:attribute></xsl:if>
	<tr>
	<td valign="top"><xsl:apply-templates select="LEFTCOL"/></td>
	<td><img src="/f/t.gif" width="8" height="1" border="0"/></td>
	<td valign="top"><xsl:apply-templates select="RIGHTCOL"/></td>
	</tr>
	</table>
	</div>
	</xsl:template>
	
	<xsl:template match="COMMENT">
	<img src="{$imagesource}furniture/commenttop.gif" alt="" border="0"/><br/>
	<div class="comment">
	<table width="180" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td valign="top"><img src="{$imagesource}furniture/openquote.gif" width="35" height="24"  border="0"/></td>
	<td><xsl:apply-templates /></td>
	<td valign="bottom"><img src="{$imagesource}furniture/closequote.gif" alt="" width="27" height="24" border="0" align="right"/></td>
	</tr>
	</table>
	</div>
	<img src="{$imagesource}furniture/commentbottom.gif" alt="" border="0"/>
	</xsl:template>
	
	

</xsl:stylesheet>
