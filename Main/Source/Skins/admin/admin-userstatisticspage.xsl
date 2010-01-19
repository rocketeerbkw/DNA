<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield"/>

	<xsl:template name="USERSTATISTICS_SUBJECT">
		<font xsl:use-attribute-sets="forumsource">
			<B>
				<xsl:value-of select="$m_thisuserstatistics"/>
				<A>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U
<xsl:value-of select="USERSTATISTICS/@USERID"/></xsl:attribute>
					<xsl:attribute name="TARGET">_top</xsl:attribute>
					<font xsl:use-attribute-sets="forumsourcelink">
						<xsl:value-of select="USERSTATISTICS/@USERNAME"/>
					</font>
				</A>
			</B>
		</font>
	</xsl:template>
<xsl:template name="USERSTATISTICS_MAINBODY">
<!--	
	<xsl:for-each select="USERSTATISTICS">
		<xsl:call-template name="navbuttons">
			<xsl:with-param name="URL">US</xsl:with-param>
			<xsl:with-param name="ID" select="@USERID"/>
			<xsl:with-param name="Previous" select="$alt_previouspage"/>
			<xsl:with-param name="Next" select="$alt_nextpage"/>
			<xsl:with-param name="shownewest" select="$alt_firstpage"/>
			<xsl:with-param name="showoldestconv" select="$alt_lastpage"/>
			<xsl:with-param name="ExtraParameters">&amp;mode=<xsl:value-of select="@DISPLAYMODE"/></xsl:with-param>
			<xsl:with-param name="showconvs" select="$alt_showposts"/>
		</xsl:call-template>
	</xsl:for-each>
-->
	<br/>						
	<xsl:call-template name="forumpostblocks">
		<xsl:with-param name="forum" select="USERSTATISTICS/@USERID"/>
		<xsl:with-param name="skip" select="0"/>
		<xsl:with-param name="show" select="USERSTATISTICS/@COUNT"/>
		<xsl:with-param name="total" select="USERSTATISTICS/@TOTAL"/>
		<xsl:with-param name="this" select="USERSTATISTICS/@SKIPTO"/>
		<xsl:with-param name="url">US</xsl:with-param>
		<xsl:with-param name="ExtraParameters">&amp;mode=<xsl:value-of select="USERSTATISTICS/@DISPLAYMODE"/></xsl:with-param>
		<xsl:with-param name="splitevery">800</xsl:with-param>
		<xsl:with-param name="objectname" select="$m_postings"/>
		<xsl:with-param name="blocklimit" select="20"/>
	</xsl:call-template><br/>

<xsl:choose>
	<xsl:when test="USERSTATISTICS[@DISPLAYMODE = 'ungrouped']">
		<TABLE>
		<TH ALIGN="left"><xsl:value-of select="$m_whichsite"/></TH>
		<TH ALIGN="left"><xsl:value-of select="$m_forumsubject"/></TH>
		<TH ALIGN="left"><xsl:value-of select="$m_conversationfirstsubject"/></TH>
		<TH ALIGN="left"><xsl:value-of select="$m_postsubject"/></TH>
		<TH ALIGN="left">Post Text</TH>
		<TH ALIGN="left"><xsl:value-of select="$m_posteddate"/></TH>
		<TH ALIGN="left">Complain</TH>
		<xsl:for-each select="USERSTATISTICS/FORUM/THREAD/POST">
		<TR>
			<TD>
				<FONT SIZE="2">
					<B>
						<xsl:value-of select="../../SITENAME"/>
					</B>
				</FONT>
			</TD>
			<TD>
				<xsl:choose>
					<xsl:when test="not(../../URL='')">
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{../../URL}">
									<xsl:apply-templates mode="nosubject" select="../../SUBJECT"/>
								</a>
							</B>
						</FONT>
					</xsl:when>
					<xsl:otherwise>
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{$root}F{../../@FORUMID}">
									<xsl:apply-templates mode="nosubject" select="../../SUBJECT"/>
								</a>
							</B>
						</FONT>
					</xsl:otherwise>
				</xsl:choose>
			</TD>
			<TD>
				<xsl:choose>
					<xsl:when test="not(../../URL='')">
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{../../URL}">
									<xsl:apply-templates mode="nosubject" select="../../SUBJECT"/>
								</a>
							</B>
						</FONT>
					</xsl:when>
					<xsl:otherwise>
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{$root}F{../../@FORUMID}?thread={../@THREADID}">
									<xsl:apply-templates mode="nosubject" select="../SUBJECT"/>
								</a>
							</B>
						</FONT>
					</xsl:otherwise>
				</xsl:choose>
			</TD>
			<TD>
				<xsl:choose>
					<xsl:when test="not(../../URL='')">
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{../../URL}#{POSTINDEX}">
									<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
								</a>
							</B>
						</FONT>
						<BR/>
					</xsl:when>
					<xsl:otherwise>
						<FONT SIZE="2">
							<B>
								<a target="_blank" href="{$root}F{../../@FORUMID}?thread={../@THREADID}&amp;post={@POSTID}#p{@POSTID}">
									<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
								</a>
							</B>
						</FONT>
						<BR/>
					</xsl:otherwise>
				</xsl:choose>
			</TD>
			<TD>
				<FONT SIZE="1">
					<xsl:apply-templates select="BODY" mode="library_Richtext" />
				</FONT><BR/>
			</TD>
			<TD>
				<FONT SIZE="1"><xsl:apply-templates select="DATEPOSTED"/></FONT>
			</TD>
			<TD>
				<FONT SIZE="2">
					<B>
						<a target="_blank" href="{$root}/comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1">
							Complain about this post
						</a>
					</B>
				</FONT>
				<BR/>
			</TD>
		</TR>
		</xsl:for-each>
		</TABLE>
	</xsl:when>
	<xsl:otherwise>
		<xsl:for-each select="USERSTATISTICS/FORUM">
		<FONT SIZE="2"><B><a href="{$root}F{@FORUMID}">
		<xsl:apply-templates mode="nosubject" select="SUBJECT"/></a></B></FONT><BR/>
		<xsl:for-each select="THREAD">
		<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
		<FONT SIZE="2"><B><a href="{$root}F{../@FORUMID}?thread={@THREADID}">
		<xsl:apply-templates mode="nosubject" select="SUBJECT"/></a></B></FONT><BR/>
		<xsl:for-each select="POST">
		<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
		<FONT SIZE="2"><B><a href="{$root}F{../../@FORUMID}?thread={../@THREADID}&amp;post={@POSTID}#p{@POSTID}">
		<xsl:apply-templates mode="nosubject" select="SUBJECT"/></a></B></FONT><BR/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
		<FONT SIZE="1">
			<xsl:value-of select="BODY"/>
		</FONT>
		<BR/>
		<FONT SIZE="1"><xsl:value-of select="$m_posted"/><xsl:apply-templates select="DATEPOSTED"/></FONT><BR/>
			<FONT SIZE="2">
				<B>
					<a href="{$root}/comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1">
						Complain about this post
					</a>
				</B>
			</FONT>
			<BR/>
		</xsl:for-each>
		</xsl:for-each>
		</xsl:for-each>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


	<xsl:template match="TEXT | BODY | RICHPOST" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<xsl:apply-templates select="* | text()" mode="library_Richtext">
			<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template match="UL | ul" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<ul>
			<xsl:apply-templates select="LI | li" mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="text()" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<xsl:choose>
			<xsl:when test="$escapeapostrophe">
				<xsl:call-template name="library_string_escapeapostrophe">
					<xsl:with-param name="str">
						<xsl:value-of select="."/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="strong | STRONG | b | B" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<strong>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</strong>
	</xsl:template>
	<xsl:template match="Q | q" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<q>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</q>
	</xsl:template>
	<xsl:template match="PRE | pre" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<pre>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</pre>
	</xsl:template>
	<xsl:template match="P | p" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<p>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</p>
	</xsl:template>
	<xsl:template match="LI | li" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<li>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</li>
	</xsl:template>
	<xsl:template match="I | i | EM | em" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<em>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</em>
	</xsl:template>
	<xsl:template match="BR | br" mode="library_Richtext">
		<br />
	</xsl:template>
	<xsl:template match="BLOCKQUOTE | blockquote" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<blockquote>
			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</blockquote>
	</xsl:template>
	<xsl:template match="B | b" mode="library_Richtext">
		<b>
			<xsl:apply-templates mode="library_Richtext"/>
		</b>
	</xsl:template>
	<xsl:template match="A | a" mode="library_Richtext">
		<xsl:param name="escapeapostrophe"/>
		<a>
			<xsl:attribute name="href">
				<xsl:if test="@HREF | @href">
					<xsl:call-template name="library_string_searchandreplace">
						<xsl:with-param name="str" select="@HREF | @href" />
						<xsl:with-param name="search" select="'javascript:'" />
						<xsl:with-param name="replace" select="''" />
					</xsl:call-template>
				</xsl:if>

			</xsl:attribute>

			<xsl:apply-templates mode="library_Richtext">
				<xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
			</xsl:apply-templates>
		</a>
	</xsl:template>
	
	<xsl:template name="library_string_escapeapostrophe">
		<xsl:param name="str"/>

		<xsl:call-template name="library_string_searchandreplace">
			<xsl:with-param name="str">
				<xsl:value-of select="$str"/>
			</xsl:with-param>
			<xsl:with-param name="search">
				<xsl:text>'</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="replace">
				<xsl:text>\'</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="library_string_searchandreplace">

		<xsl:param name="str" />
		<xsl:param name="search" />
		<xsl:param name="replace" />

		<xsl:choose>
			<xsl:when test="contains($str, $search)">

				<xsl:value-of select="substring-before($str, $search)"/>

				<xsl:value-of select="$replace"/>

				<xsl:call-template name="library_string_searchandreplace">
					<xsl:with-param name="str" select="substring-after($str, $search)" />
					<xsl:with-param name="search" select="$search"/>
					<xsl:with-param name="replace" select="$replace"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>