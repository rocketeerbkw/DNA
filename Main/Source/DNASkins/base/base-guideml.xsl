<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="blobbackground">white</xsl:variable>
	<xsl:template match="SMILEY">
		<xsl:choose>
			<xsl:when test="@H2G2|@h2g2|@BIO|@bio|@HREF|@href">
				<xsl:variable name="url">
					<xsl:value-of select="@H2G2|@h2g2|@BIO|@bio|@HREF|@href"/>
				</xsl:variable>
				<a href="{$root}{$url}">
					<!-- only put in target="_top" when link goes outside current page -->
					<xsl:if test="substring($url, 0, 1) != '#'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{translate(@TYPE,$uppercase,$lowercase)}.gif"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{translate(@TYPE,$uppercase,$lowercase)}.gif"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--xsl:template match="PICTURE">
		<xsl:choose>
			<xsl:when test='starts-with(@SRC|@BLOB,"http://") or starts-with(@SRC|@BLOB,"/")'>
				<xsl:comment>Off-site picture removed</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="display"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template-->
	<xsl:template name="insert-caption">
		<xsl:apply-templates/>
	</xsl:template>
	<!--xsl:template match="PICTURE" mode="display"/-->
	<xsl:template match="@*|*" mode="applyroot">
		<xsl:choose>
			<xsl:when test="../@SITE">
				<xsl:text>/dna/</xsl:text>
				<xsl:value-of select="../@SITE"/>/<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="starts-with(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/classic/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/brunel/')">
				<xsl:value-of select="concat(substring-after(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/classic/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/brunel/'))"/>
			</xsl:when>
			<xsl:when test="starts-with(.,'http://www.h2g2.com/')">
				<xsl:value-of select="concat('/dna/h2g2/',substring-after(.,'http://www.h2g2.com/'))"/>
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
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="GUIDE">

		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="HEADER">
		<font size="4">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="SUBHEADER">
		<font size="3">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="INPUT | input | SELECT | select | P | p | I | i | B | b | BLOCKQUOTE | blockquote | CAPTION | caption | CODE | code | UL | ul | OL | ol | LI | li | PRE | pre | SUB | sub | SUP | sup | TABLE | table | TD | td | TH | th | TR | tr | BR | br">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
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
	<xsl:template match="IMG">
    <xsl:if test="not(contains(@SRC,':')) and not(starts-with(@SRC,'//'))">
      <xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PICTURE" mode="display">
		<table border="0" cellpadding="0" cellspacing="0">
			<xsl:if test="@EMBED">
				<xsl:attribute name="align"><xsl:value-of select="@EMBED"/></xsl:attribute>
			</xsl:if>
			<tr>
				<td rowspan="4" width="5"/>
				<td height="5"/>
				<td rowspan="4" width="5"/>
			</tr>
			<tr>
				<td>
					<xsl:call-template name="renderimage"/>
				</td>
			</tr>
			<tr>
				<td align="center" valign="top">
					<font xsl:use-attribute-sets="mainfont" size="1">
						<xsl:call-template name="insert-caption"/>
					</font>
				</td>
			</tr>
			<tr>
				<td height="5"/>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="A">
		<xsl:copy use-attribute-sets="mA">
			<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="LINK">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="SMILEY">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="*|@*|text()|comment()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()|comment()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:choose>
			<xsl:when test="contains(translate(.,$uppercase,$lowercase),'document.cookie')"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="*|@*|text()|comment()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--                                                      GUIDEML Stuff                                                    -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<!--  )()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()()()()()()())()( -->
	<xsl:template match="LINK">
		<xsl:if test="@H2G2|@h2g2|@DNAID">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:call-template name="bio-link"/>
			</a>
		</xsl:if>
		<xsl:if test="@HREF|@href">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:apply-templates/>
			</a>
		</xsl:if>
		<xsl:if test="@BIO|@bio">
			<a xsl:use-attribute-sets="mLINK">
				<xsl:call-template name="dolinkattributes"/>
				<xsl:call-template name="bio-link"/>
			</a>
		</xsl:if>
	</xsl:template>
	<xsl:template match="@HREF|@H2G2|@DNAID">
		<!--
<xsl:choose>
<xsl:when test="starts-with(.,'http://') and not(starts-with(., 'http://www.bbc.co.uk')) and not(starts-with(., 'http://www.h2g2.com'))">
<xsl:attribute name="TARGET">_blank</xsl:attribute>
</xsl:when>
<xsl:otherwise>
-->
		<xsl:attribute name="TARGET">_top</xsl:attribute>
		<!--
</xsl:otherwise>
</xsl:choose>
-->
		<xsl:attribute name="HREF"><xsl:apply-templates select="." mode="applyroot"/><!--
<xsl:choose>
<xsl:when test="starts-with(.,'/') and string-length(.) &gt; 1">
<xsl:value-of select="$root"/><xsl:value-of select="substring(.,2)"/>
</xsl:when>
<xsl:when test="starts-with(.,'http://')">
<xsl:value-of select="."/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$root"/><xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
--></xsl:attribute>
	</xsl:template>
	<xsl:template match="LINK" mode="justattributes">
		<xsl:call-template name="dolinkattributes"/>
	</xsl:template>
	<xsl:template match="SMILEY">
		<xsl:choose>
			<xsl:when test="@H2G2|@h2g2|@BIO|@bio|@HREF|@href">
				<xsl:variable name="url">
					<xsl:value-of select="@H2G2|@h2g2|@BIO|@bio|@HREF|@href"/>
				</xsl:variable>
				<a href="{$root}{$url}">
					<!-- only put in target="_top" when link goes outside current page -->
					<xsl:if test="substring($url, 0, 1) != '#'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{translate(@TYPE,$uppercase,$lowercase)}.gif"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<img border="0" alt="{@TYPE}" title="{@TYPE}" src="{$smileysource}f_{translate(@TYPE,$uppercase,$lowercase)}.gif"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--

	<xsl:template name="bio-link">

	Generic:	Yes
	Purpose:	Given a LINK tag as context, if the tag is empty, this
				will search the rest of the document for the referenced
				info, and display that.
				This works for both BIO and H2G2 types.

-->
	<xsl:template name="bio-link">
		<xsl:choose>
			<xsl:when test="@BIO">
				<xsl:choose>
					<xsl:when test="./*">
						<xsl:apply-templates/>
					</xsl:when>
					<xsl:when test="string-length(.) = 0">
						<xsl:variable name="userid">
							<xsl:value-of select="substring-after(@BIO,'U')"/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="//REFERENCES/USERS/USERLINK[USERID=$userid]/USERNAME">
								<xsl:value-of select="//REFERENCES/USERS/USERLINK[USERID=$userid]/USERNAME"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_researcher"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$userid"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@H2G2|@DNAID">
				<xsl:choose>
					<xsl:when test="./*">
						<xsl:apply-templates/>
					</xsl:when>
					<xsl:when test="string-length(.) = 0">
						<xsl:variable name="h2g2id">
							<xsl:choose>
								<xsl:when test="@H2G2">
									<xsl:value-of select="substring-after(@H2G2,'A')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-after(@DNAID,'A')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="//REFERENCES/ENTRIES/ENTRYLINK[H2G2ID=$h2g2id]/SUBJECT">
								<xsl:value-of select="//REFERENCES/ENTRIES/ENTRYLINK[H2G2ID=$h2g2id]/SUBJECT"/>
							</xsl:when>
							<xsl:otherwise>A<xsl:value-of select="$h2g2id"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="PICTURE">
		<xsl:choose>
			<xsl:when test='starts-with(@SRC|@BLOB,"http://") or starts-with(@SRC|@BLOB,"/")'>
				<xsl:comment>Off-site picture removed</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="display"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--xsl:template match="PICTURE" mode="display"/-->
	<xsl:template name="renderimage">
		<xsl:choose>
			<xsl:when test="name(..)=string('LINK')">
				<a>
					<xsl:for-each select="..">
						<xsl:call-template name="dolinkattributes"/>
					</xsl:for-each>
					<xsl:call-template name="outputimg"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="outputimg"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--

	<xsl:template name="outputimg">

	Generic:	Yes
	Context:	<PICTURE>
	Purpose:	Outputs an IMG tag corresponding to the PICTURE tag

-->
	<xsl:template name="outputimg">
		<img border="0">
			<xsl:copy-of select="@WIDTH|@HEIGHT|@ALT"/>
			<xsl:attribute name="src"><xsl:choose><xsl:when test="@BLOB"><xsl:value-of select="@BLOB"/><xsl:value-of select="$blobbackground"/></xsl:when><xsl:when test="@CNAME"><xsl:value-of select="$skingraphics"/><xsl:value-of select="@CNAME"/></xsl:when><xsl:when test="@NAME"><xsl:value-of select="$graphics"/><xsl:value-of select="@NAME"/></xsl:when><xsl:otherwise><xsl:value-of select="@SRC"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</img>
	</xsl:template>
	<!--
<xsl:template name="renderfootnotetext">
Purpose:	Display the footnote text
Call:		<xsl:call-template name="renderfootnotetext"/>.
-->
	<xsl:template name="renderfootnotetext">
		<xsl:for-each select="*|text()">
			<xsl:choose>
				<xsl:when test="self::text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="name()!=string('FOOTNOTE')">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="renderfootnotetext"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
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
						<xsl:apply-templates select="@HREF" mode="applyroot"/>
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
					<xsl:apply-templates select="@HREF"/>
				</xsl:if>
				<xsl:if test="@BIO|@bio">
					<xsl:attribute name="TARGET">_top</xsl:attribute>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="@BIO|@bio"/></xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*|*" mode="applyroot">
		<xsl:choose>
			<xsl:when test="../@SITE">
				<xsl:text>/dna/</xsl:text>
				<xsl:value-of select="../@SITE"/>/<xsl:value-of select="."/>
			</xsl:when>
			<xsl:when test="starts-with(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/classic/') or starts-with(.,'http://www.bbc.co.uk/dna/h2g2/brunel/')">
				<xsl:value-of select="concat(substring-after(.,'http://www.bbc.co.uk/dna/h2g2/alabaster/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/classic/'),substring-after(.,'http://www.bbc.co.uk/dna/h2g2/brunel/'))"/>
			</xsl:when>
			<xsl:when test="starts-with(.,'http://www.h2g2.com/')">
				<xsl:value-of select="concat('/dna/h2g2/',substring-after(.,'http://www.h2g2.com/'))"/>
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
	<!--
<xsl:template match="FOOTNOTE">
Purpose:	Display a footnote within the body of the text
Call:		<xsl:apply-templates select="FOOTNOTE"/>.
-->
	<xsl:template match="FOOTNOTE">
		<a xsl:use-attribute-sets="mFOOTNOTE">
			<xsl:attribute name="title"><xsl:call-template name="renderfootnotetext"/></xsl:attribute>
			<xsl:attribute name="name">back<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:attribute name="href">#footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:apply-templates select="@INDEX" mode="Footnote"/>
		</a>
	</xsl:template>
	<!--
<xsl:template match="FOOTNOTE">
Purpose:	Display a footnote within the body of the text
Call:		<xsl:apply-templates select="FOOTNOTE"/>.
-->
	<xsl:template match="FOOTNOTE">
		<a xsl:use-attribute-sets="mFOOTNOTE">
			<xsl:attribute name="title"><xsl:call-template name="renderfootnotetext"/></xsl:attribute>
			<xsl:attribute name="name">back<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:attribute name="href">#footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:apply-templates select="@INDEX" mode="Footnote"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SECTION">
		<a name="section{count(preceding::SECTION)+1}"><xsl:value-of select="count(preceding::SECTION)+1"/>: <xsl:apply-templates/></a> <a href="#top">&gt;&gt;</a><br/>
		<xsl:value-of select="."/><br/>
	</xsl:template>
-->
	<!-- block some ways of getting offsite images -->
	<xsl:template match="@STYLE[contains(.,'//')]"/>
	<xsl:template match="TABLE//@BACKGROUND"/>
	<xsl:template match="ENTITY"><xsl:text disable-output-escaping="yes">&amp;</xsl:text><xsl:value-of select="@TYPE|@type"/>;</xsl:template>

  <xsl:template match="SCRIPT|OBJECT|EMBED|BGSOUND|APPLET|IFRAME|META|STYLE|IMAGE">
    <!--<xsl:choose>
<xsl:when test="contains(translate(.,$uppercase,$lowercase),'cookie')">
<xsl:call-template name="m_scriptremoved"/>
</xsl:when>
<xsl:otherwise>
<xsl:copy><xsl:apply-templates select="*|@*|text()|comment()"/></xsl:copy>
</xsl:otherwise>
</xsl:choose>-->

     <!--just get rid of all of them--> 
    <xsl:comment>
      <xsl:call-template name="m_scriptremoved"/>
    </xsl:comment>
  </xsl:template>
  <xsl:template match="@ONCLICK|@ONMOUSEOVER|@ONMOUSEDOWN|@ONMOUSEOUT|@ONCONTEXTMENU|@ONDBLCLICK|@ONBLUR|@ONFOCUS|@ONSCROLL|@ONMOUSEUP|@ONMOUSEENTER|@ONMOUSELEAVE|@ONMOUSEMOVE|@ONSELECTSTART">
  </xsl:template>


  <xsl:template match="TEST-XSLT-TESTS">
    <h2>Testing the Test_ variables</h2>
    <h3>test_MayRemoveFromResearchers</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_MayRemoveFromResearchers">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_MayRemoveFromResearchers">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_ShowEditLink</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_ShowEditLink">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_ShowEditLink">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_ShowEntrySubbedLink</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_ShowEntrySubbedLink">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_ShowEntrySubbedLink">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_HasResearchers</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_HasResearchers">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_HasResearchers">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_IsEditor</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_IsEditor">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_IsEditor">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_IsModerator</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_IsModerator">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_IsModerator">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_IsAssetModerator</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_IsAssetModerator">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_IsAssetModerator">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_CanEditMasthead</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_CanEditMasthead">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_CanEditMasthead">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_RefHasEntries</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_RefHasEntries">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_RefHasEntries">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_RefHasUsers</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_RefHasUsers">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_RefHasUsers">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_RefHasBBCSites</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_RefHasBBCSites">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_RefHasBBCSites">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_RefHasNONBBCSites</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_RefHasNONBBCSites">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_RefHasNONBBCSites">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_EditorOrModerator</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_EditorOrModerator">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_EditorOrModerator">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_IsArticleMasthead</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_IsArticleMasthead">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_IsArticleMasthead">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_ShowResearchers</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_ShowResearchers">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_ShowResearchers">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_PreviewError</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_PreviewError">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_PreviewError">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_HasPreviewBody</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_HasPreviewBody">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_HasPreviewBody">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_AllowNewConversationBtn</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_AllowNewConversationBtn">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_AllowNewConversationBtn">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_MayAddToJournal</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_MayAddToJournal">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_MayAddToJournal">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_MayRemoveJournalPost</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_MayRemoveJournalPost">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_MayRemoveJournalPost">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_MayShowCancelledEntries</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_MayShowCancelledEntries">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_MayShowCancelledEntries">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_NewerArticlesExist</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_NewerArticlesExist">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_NewerArticlesExist">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_OlderArticlesExist</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_OlderArticlesExist">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_OlderArticlesExist">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_AddHomePage</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_AddHomePage">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_AddHomePage">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_AddGuideEntry</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_AddGuideEntry">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_AddGuideEntry">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_EditHomePage</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_EditHomePage">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_EditHomePage">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_EditguideEntry</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_EditguideEntry">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_EditguideEntry">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_introarticle</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_introarticle">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_introarticle">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_articletypeonly</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_articletypeonly">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_articletypeonly">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>
    <h3>test_registererror</h3>
    <ul>
      <li>
        if: [<xsl:if test="test_registererror">true</xsl:if>]
      </li>
      <li>
        <xsl:text>choose: [</xsl:text>
        <xsl:choose>
          <xsl:when test="test_registererror">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </li>
    </ul>

  </xsl:template>



</xsl:stylesheet>
