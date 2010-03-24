<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
				exclude-result-prefixes="msxsl dt local s">
	
<xsl:attribute-set name="textsearchatts">
	<xsl:attribute name="size">28</xsl:attribute>
	<xsl:attribute name="style">width:230;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="astyle1">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="h2g2idlink" use-attribute-sets="astyle1"/>
<xsl:attribute-set name="subjectlink" use-attribute-sets="astyle1"/>
<xsl:attribute-set name="forumresultlink" use-attribute-sets="astyle1"/>
<xsl:attribute-set name="searchtitlefont" use-attribute-sets="mainfont"/>

<xsl:template name="SEARCH_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_search_title"/></title>
</xsl:template>

<xsl:template name="SEARCH_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<xsl:choose>
							<xsl:when test="SEARCH/SEARCHRESULTS/SEARCHTERM != ''">
								<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_search_inforesults"/></b>
									<xsl:choose>
										<xsl:when test="SEARCH/SEARCHRESULTS/SEARCHTERM='.'"><xsl:value-of select="$m_search_infonotalpha"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="SEARCH/SEARCHRESULTS/SEARCHTERM"/></xsl:otherwise>
									</xsl:choose>
								</font>
							</xsl:when>
							<xsl:otherwise>
								<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_search_infoblurb"/></b></font>1
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="SEARCH_SIDEBAR">
</xsl:template>
	
<xsl:template match="ARTICLERESULT">
	<tr valign="top">
		<xsl:choose>
			<xsl:when test="PRIMARYSITE!=1">
				<td>
					<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/SHORTNAME" mode="result"/>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td>
					<xsl:apply-templates select="H2G2ID"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
		<td bgcolor="#000000">
			<xsl:apply-templates select="SUBJECT" mode="articleresult">
				<xsl:with-param name="link">yes</xsl:with-param>
			</xsl:apply-templates>
		</td>
		<td>
			<img src="{$imagesource}t.gif" width="8" height="1" alt=""/>
			<xsl:apply-templates select="STATUS"/>
		</td>
		<td>
			<xsl:apply-templates select="SCORE"/>
		</td>
	</tr>
</xsl:template>

<xsl:template match="FORUMRESULT">
	<tr valign="top">
		<td>
			<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
			<xsl:apply-templates select="SUBJECT" mode="forumresult"/>
		</td>
		<td>
			<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
		</td>
		<td>
			<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
		</td>
		<xsl:choose>
			<xsl:when test="PRIMARYSITE!=1">
				<td>
					<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=current()/SITEID]/SHORTNAME" mode="result"/>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td>
					<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
</xsl:template>

<xsl:template match="USERRESULT">
	<tr valign="top">
		<td colspan="4">
			<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="USERNAME"/>
			</font>
			<br/>
		</td>
	</tr>
</xsl:template>
	
<xsl:template name="SEARCH_PRENEXT">
	<b>
		<font xsl:use-attribute-sets="nullsmallfont">
			<xsl:apply-templates select="SKIP"/>
			<xsl:apply-templates select="MORE"/>
		</font>
	</b>
</xsl:template>
	
<xsl:template match="SEARCHRESULTS">
	<xsl:choose>
		<xsl:when test="ARTICLERESULT|FORUMRESULT|USERRESULT">
			<table width="100%" cellspacing="1" cellpadding="0" border="0">
				<tr>
					<td colspan="4" bgcolor="#000000">
						<img src="{$imagesource}t.gif" width="1" height="5" alt=""/>
						<br clear="all"/>
						<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
						<xsl:call-template name="SEARCH_PRENEXT"/>
						<br clear="all"/>
						<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
						<br clear="all"/>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="ARTICLERESULT">
						<xsl:if test="ARTICLERESULT[PRIMARYSITE=1]">
							<tr>
								<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
									<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
								</td>
							</tr>
<!--						<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_search_resultsfoundin"/><xsl:value-of select="$m_sitetitle"/>:</b>
										<br/>
										<br/>
									</font>
								</td>
							</tr> -->
							<tr>
								<td width="88" bgcolor="#000000">
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsIDColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="104" height="10" alt=""/>
								</td>
								<td width="100%" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="335" height="10" alt=""/>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="335" height="10" alt=""/>
								</td>
								<td width="88" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="8" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsStatusColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="100" height="10" alt=""/>
								</td>
								<td width="88" bgcolor="#000000">
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsScoreColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="75" height="10" alt=""/>
								</td>
							</tr>
							<xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE=1]">
								<xsl:sort select="STATUS"/>
							</xsl:apply-templates>
							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="1" height="7" alt=""/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="ARTICLERESULT[PRIMARYSITE!=1]">
							<tr>
								<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
									<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
								</td>
							</tr>
<!--							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_search_resultsfoundout"/></b>
										<br/>
									</font>
								</td>
							</tr> -->
							<tr>
								<td colspan="4">
									<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
								</td>
							</tr>
							<tr valign="top">
								<td width="88" bgcolor="#000000">
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSiteColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="104" height="10" alt=""/>
								</td>
								<td width="100%" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="335" height="10" alt=""/>
								</td>
								<td width="88" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="8" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsStatusColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="100" height="10" alt=""/>
								</td>
								<td width="88" bgcolor="#000000">
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsScoreColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="75" height="10" alt=""/>
								</td>
							</tr>
							<xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE!=1]"/>
							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="1" height="7" alt=""/>
								</td>
							</tr>
						</xsl:if>
					</xsl:when>
					<xsl:when test="FORUMRESULT">
						<xsl:if test="FORUMRESULT[PRIMARYSITE=1]">
							<tr>
								<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
									<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
								</td>
							</tr>
<!--								<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_search_resultsfoundin"/><xsl:value-of select="$m_sitetitle"/>:</b>
										<br/>
									</font>
								</td>
							</tr> -->
							<tr>
								<td width="100%" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="352" height="10" alt=""/>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="613" height="10" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
								</td>
							</tr>
							<xsl:apply-templates select="FORUMRESULT[PRIMARYSITE=1]"/>
							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="1" height="7" alt=""/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="FORUMRESULT[PRIMARYSITE!=1]">
							<tr>
								<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
									<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
								</td>
							</tr>
<!--							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_search_resultsfoundout"/></b>
										<br/>
									</font>
								</td>
							</tr> -->
							<tr>
								<td width="100%" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="526" height="10" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
								</td>
								<td width="88" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="8" height="1" alt=""/>
									<font xsl:use-attribute-sets="smallfont">
										<b>
											<xsl:value-of select="$m_SearchResultsSiteColumnName"/>
										</b>
									</font>
									<br clear="all"/>
									<img src="{$imagesource}t.gif" width="88" height="10" alt=""/>
								</td>
							</tr>
							<xsl:apply-templates select="FORUMRESULT[PRIMARYSITE!=1]"/>
							<tr>
								<td colspan="4">
									<img src="{$imagesource}t.gif" width="1" height="7" alt=""/>
								</td>
							</tr>
						</xsl:if>
					</xsl:when>
					<xsl:when test="USERRESULT">
						<tr>
							<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
								<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
							</td>
						</tr>
						<tr>
							<td width="100%" bgcolor="#000000">
								<img src="{$imagesource}t.gif" width="352" height="10" alt=""/>
								<br clear="all"/>
								<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
								<font xsl:use-attribute-sets="smallfont">
									<b>
										<xsl:value-of select="$m_SearchResultsSubjectColumnName"/>
									</b>
								</font>
								<br clear="all"/>
								<img src="{$imagesource}t.gif" width="613" height="10" alt=""/>
							</td>
							<td width="1" bgcolor="#000000">
								<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
							</td>
							<td width="1" bgcolor="#000000">
								<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
							</td>
							<td width="1" bgcolor="#000000">
								<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
							</td>
						</tr>
						<xsl:apply-templates select="USERRESULT"/>
						<tr>
							<td colspan="4">
								<img src="{$imagesource}t.gif" width="1" height="7" alt=""/>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<tr>
					<td colspan="4" background="{$imagesource}dotted_line_inv.jpg">
						<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" bgcolor="#000000">
						<img src="{$imagesource}t.gif" width="1" height="5" alt=""/>
						<br clear="all"/>
						<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
						<xsl:call-template name="SEARCH_PRENEXT"/>
						<br clear="all"/>
						<img src="{$imagesource}t.gif" width="1" height="25" alt=""/>
						<br clear="all"/>
					</td>
				</tr>
			</table>
		</xsl:when>
		<xsl:when test="string-length(SEARCHTERM)=0"/>
		<xsl:otherwise>
			<font xsl:use-attribute-sets="subheaderfont">
				<br/>
				<img src="{$imagesource}t.gif" width="10" height="5" alt=""/>
				<b>
					<xsl:value-of select="$m_noresults"/>
				</b>
				<br/>
				<br/>
			</font>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:call-template name="m_searchfailed"/>
				<br/>
				<br/>
			</font>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="extraalphaprocessing">
	<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
</xsl:template>
	
<xsl:template name="SEARCH_MAINBODY">
	<!-- Editing -->
	<table width="100%" cellspacing="0" cellpadding="3" border="0">
		<tr>
			<td><br/>
				<xsl:apply-templates select="SEARCH/SEARCHRESULTS"/>
				<table width="100%" cellspacing="1" cellpadding="0" border="0">
					<tr>
						<td bgcolor="#000000">
							<img src="{$imagesource}t.gif" width="619" height="1" alt=""/>
						</td>
					</tr>
					<tr>
						<td>
							<form xsl:use-attribute-sets="SearchFormAtts" name="advsearch">
								<table width="472" cellpadding="0" cellspacing="10" border="0">
									<tr>
										<td colspan="2">
											<xsl:if test="not(SEARCH/SEARCHRESULTS/SEARCHTERM='')">
												<!-- If a term has already been searched for -->
												<font xsl:use-attribute-sets="subheaderfont">
													<b><xsl:value-of select="$m_search_againq"/></b>
												</font>
											</xsl:if>
										</td>
									</tr>
									<tr>
										<td>
											<input type="Radio" xsl:use-attribute-sets="SearchTypeArticles" ONCLICK="document.advsearch.showapproved.disabled=false; document.advsearch.showsubmitted.disabled=false; document.advsearch.shownormal.disabled=false;">
											<xsl:if test="SEARCH/SEARCHRESULTS[@TYPE='ARTICLE'] or SEARCH/FUNCTIONALITY/SEARCHARTICLES[SELECTED=1]">
											<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
											</input>
											<!-- Attribute sets added -->
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_searchtheguide"/>
											</font>
										</td>
										<td>
											<xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHARTICLES">
												<xsl:with-param name="whichchild" select="1"/>
												<xsl:with-param name="disabled">
													<xsl:choose><xsl:when test="SEARCH/SEARCHRESULTS[@TYPE='ARTICLE']">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>
												</xsl:with-param>
											</xsl:apply-templates>
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_editedentries"/>
											</font>
										</td>
									</tr>
									<tr>
										<td>
											<input type="Radio" xsl:use-attribute-sets="SearchTypeForums" ONCLICK="document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;">
											<xsl:if test="SEARCH/SEARCHRESULTS[@TYPE='FORUM'] or SEARCH/FUNCTIONALITY/SEARCHFORUMS[SELECTED=1]">
											<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
											</input>
											<!-- Brunel specific - ie shading out which sections to search in -->
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_searchforums"/>
											</font>
											<xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHFORUMS" mode="searchforumids"/>
										</td>
										<td>
											<xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHARTICLES">
												<xsl:with-param name="whichchild" select="3"/>
												<xsl:with-param name="disabled">
													<xsl:choose><xsl:when test="SEARCH/SEARCHRESULTS[@TYPE='ARTICLE']">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>
												</xsl:with-param>
											</xsl:apply-templates>
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_recommendedentries"/>
											</font>
										</td>
									</tr>
									<tr>
										<td>
											<input type="Radio" xsl:use-attribute-sets="SearchTypeFriends" ONCLICK="document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;">
											<xsl:if test="SEARCH/SEARCHRESULTS[@TYPE='USER'] or SEARCH/FUNCTIONALITY/SEARCHUSERS[SELECTED=1]">
											<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
											</input>
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_searchforafriend"/>
											</font>
										</td>
										<td>
											<xsl:apply-templates select="SEARCH/FUNCTIONALITY/SEARCHARTICLES">
												<xsl:with-param name="whichchild" select="2"/>
												<xsl:with-param name="disabled">
													<xsl:choose><xsl:when test="SEARCH/SEARCHRESULTS[@TYPE='ARTICLE']">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>
												</xsl:with-param>
											</xsl:apply-templates>
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_guideentries"/>
											</font>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<font xsl:use-attribute-sets="mainfont">
												<xsl:value-of select="$m_searchfor"/>
											</font>
										</td>
									</tr>
									<tr>
										<td>
											<xsl:call-template name="SearchFormMain"/>
										</td>
										<td>
											<xsl:call-template name="SearchFormSubmitImage">
												<xsl:with-param name="imagesrc" select="concat($imagesource, 'go_red.gif')"/>
											</xsl:call-template>
										</td>
									</tr>
									<tr>
										<td width="236">
											<img src="{$imagesource}t.gif" width="236" height="1" alt=""/>
										</td>
										<td width="236">
											<img src="{$imagesource}t.gif" width="236" height="1" alt=""/>
										</td>
									</tr>
								</table>
							</form>
						</td>
					</tr>
					<tr>
						<td background="{$imagesource}dotted_line_inv.jpg">
							<img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0"/>
						</td>
					</tr>
					<tr>
						<td>
							<img src="{$imagesource}t.gif" width="1" height="12" alt=""/>
						</td>
					</tr>
					<tr>
						<td>
							<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
							<font xsl:use-attribute-sets="subheaderfont">
								<b>
									<xsl:value-of select="$m_oruseindex"/>
								</b>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<font xsl:use-attribute-sets="alphaindexfont">
								<img src="{$imagesource}t.gif" width="1" height="18" alt=""/>
								<br clear="all"/>
								<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
								<xsl:call-template name="alphaindex" />
								<br clear="all"/>
								<img src="{$imagesource}t.gif" width="1" height="4" alt=""/>
								<br clear="all"/>
								<img src="{$imagesource}t.gif" width="10" height="1" alt=""/>
								<b><xsl:text disable-output-escaping="yes">*&amp;nbsp;</xsl:text></b>
							</font>
							<font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_aplhaindex_notletter"/></font>
						</td>
					</tr>
				</table>
			<br /><br />
			</td>
		</tr>
	</table>
</xsl:template>

<!-- STUFF ADDED THIS EXISTS IN BASE!!!! -->
<!-- SearchFormAtts specifies the attributes that MUST appear on a search <form> element -->
<xsl:attribute-set name="SearchFormAtts">
	<xsl:attribute name="METHOD">GET</xsl:attribute>
	<xsl:attribute name="action"><xsl:value-of select="$root"/>Search</xsl:attribute>
</xsl:attribute-set>
	
<!--The following specifies the attributes that MUST appear on an <input> element for an Article/Friends/Forums search-->
<xsl:attribute-set name="SearchTypeArticles">
	<xsl:attribute name="NAME">searchtype</xsl:attribute>
	<xsl:attribute name="value">article</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="SearchTypeForums">
	<xsl:attribute name="NAME">searchtype</xsl:attribute>
	<xsl:attribute name="value">forum</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="SearchTypeFriends">
	<xsl:attribute name="NAME">searchtype</xsl:attribute>
	<xsl:attribute name="value">USER</xsl:attribute>
</xsl:attribute-set>

<!-- ******************************************************************************************** -->
<!-- ******************************************************************************************** -->
<!--                        Overwritable attribute sets and Variables                                  -->
<!-- ******************************************************************************************** -->
<!-- ******************************************************************************************** -->
<!-- These attribute sets are always copied or overridden in HTMLOutput -->
<!-- The following all specify which font size, face and style to use for each result fragment, by default they are the same as mainfont, but this can be overridden if required -->
<xsl:attribute-set name="statusstyle" use-attribute-sets="mainfont"/>
<xsl:attribute-set name="subjectstyle" use-attribute-sets="mainfont"/>
<xsl:attribute-set name="scorestyle" use-attribute-sets="mainfont"/>
<xsl:attribute-set name="h2g2idstyle" use-attribute-sets="mainfont"/>
<xsl:attribute-set name="shortnamestyle" use-attribute-sets="mainfont"/>
<xsl:attribute-set name="useridstyle" use-attribute-sets="mainfont"/>

<!-- h2g2idlink and subjectlink contains skin-specific attributes that are used on the H2G2ID <a> tag, typically this would include a class attribute -->
<xsl:attribute-set name="h2g2idlink"/>
<xsl:attribute-set name="subjectlink"/>
<xsl:attribute-set name="forumresultlink"/>

<!-- The search form text input may require extra presentation info, eg size, style, this appears in textsearchatts in HTMLOutputs -->
<xsl:attribute-set name="textsearchatts"/>
	
<!-- 	morelink specifies how the 'previous' and 'next results' text is presented -->
<xsl:attribute-set name="morelink" use-attribute-sets="astyle1"/>

<!-- 	By default astyle1 contains nothing but might contain class or ID information in a specific skin	-->
<xsl:attribute-set name="astyle1"/>
<xsl:attribute-set name="searchtitlefont"/>

<!-- ********************************************************************************************************* -->
<!-- ********************************************************************************************************* -->
<!--	Secure templates, these cannot be overridden, they contain core DNA programmatic information as well as 
		references to attribute sets and variables defined in HTMLOutput or text files -->
<!-- *********************************************************************************************************** -->
<!-- ********************************************************************************************************* -->
<!--
<xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL">
Context:	Always a child of /H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES
Purpose: decide whether a checkbox is ticked or not
-->
<xsl:template match="SHOWAPPROVED | SHOWSUBMITTED | SHOWNORMAL">
	<xsl:if test=".=1">
		<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
	</xsl:if>
</xsl:template>

<!--
<xsl:template match="SEARCHARTICLES">
Context:	Always a child of /H2G2/SEARCH/FUNCTIONALITY
Purpose: Creates an input checkbox used in deciding where to search on H2G2
-->
<xsl:template match="SEARCHARTICLES">
	<xsl:param name="whichchild"/>
	<xsl:param name="disabled">0</xsl:param>
	<INPUT TYPE="checkbox" VALUE="1">
		<xsl:attribute name="NAME"><xsl:choose><xsl:when test="$whichchild=1">showapproved</xsl:when><xsl:when test="$whichchild=2">shownormal</xsl:when><xsl:when test="$whichchild=3">showsubmitted</xsl:when></xsl:choose></xsl:attribute>
		<xsl:if test="$disabled=1"><xsl:attribute name="DISABLED">DISABLED</xsl:attribute></xsl:if>
		<xsl:apply-templates select="./*[$whichchild]"/>
	</INPUT>
</xsl:template>

<!--
<xsl:template match="SEARCHARTICLES" mode="hidden">
Context:	Always a child of /H2G2/SEARCH/FUNCTIONALITY
Purpose: Used if no distinction between the edited, recommended and normal guide is required
-->
<xsl:template match="SEARCHARTICLES" mode="hidden">
	<xsl:param name="whichchild"/>
	<INPUT TYPE="hidden" VALUE="1">
		<xsl:attribute name="NAME"><xsl:choose><xsl:when test="$whichchild=1">showapproved</xsl:when><xsl:when test="$whichchild=2">shownormal</xsl:when><xsl:when test="$whichchild=3">showsubmitted</xsl:when></xsl:choose></xsl:attribute>
	</INPUT>
</xsl:template>

<!--
<xsl:template name="SearchFormSubmitText">
Context: H2G2 (always)
Purpose: Generic Submit button with a textual value
-->
<xsl:template name="SearchFormSubmitText">
	<xsl:param name="text"/>
	<INPUT TYPE="SUBMIT" NAME="dosearch" VALUE="{$text}"/>
</xsl:template>

<!--
<xsl:template name="SearchFormSubmitText">
Context: H2G2 (always)
Purpose: Generic Submit button rendered as an image
-->
<xsl:template name="SearchFormSubmitImage">
	<xsl:param name="imagesrc"/>
	<INPUT TYPE="image" NAME="dosearch" src="{$imagesrc}" value="{$m_searchtheguide}" border="0"/>
</xsl:template>

<!--
<xsl:template name="SearchFormMain / searchforfriends / searchforforums">
Context: H2G2 (always)
Purpose: Generic Textual <input> elements used to search the site/ users/ forums
-->
<xsl:template name="SearchFormMain">
	<INPUT TYPE="TEXT" NAME="searchstring" xsl:use-attribute-sets="textsearchatts">
		<xsl:attribute name="VALUE"><xsl:value-of select="SEARCH/SEARCHRESULTS/SEARCHTERM"/></xsl:attribute>
	</INPUT>
</xsl:template>

<xsl:template name="searchforfriends">
	<xsl:value-of select="$m_searchfor"/>
	<INPUT TYPE="TEXT" NAME="searchstring"/>
</xsl:template>

<xsl:template name="searchforforums">
	<xsl:value-of select="$m_searchfor"/>
	<INPUT TYPE="TEXT" NAME="searchstring"/>
</xsl:template>

<!--
<xsl:template match="MORE / SKIP">
Context: Always a child of /H2G2/SEARCH/SEARCHRESULTS. 
Obligatory: Yes
Purpose: Renders a link to previous/ next pages of a search result
-->
<xsl:template match="MORE[parent::SEARCHRESULTS]">
	<xsl:choose>
		<xsl:when test=". = 1">
			<a xsl:use-attribute-sets="morelink">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(../SKIP) + number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if></xsl:attribute>
				<xsl:value-of select="$m_nextresults"/>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_nomoreresults"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="SKIP[parent::SEARCHRESULTS]">
	<xsl:choose>
		<xsl:when test="(. &gt; 0)">
			<a xsl:use-attribute-sets="morelink">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(.) - number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if></xsl:attribute>
				<xsl:value-of select="$m_prevresults"/>
			</a>
			<font color="#ffffff"><xsl:copy-of select="$skipdivider"/></font>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_noprevresults"/>
			<font color="#ffffff"><xsl:copy-of select="$skipdivider"/></font>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
<xsl:template match="H2G2ID"/>
Context: Always a child of ARTICLERESULT
Purpose: Creates a link to a DNA article, the a link can include any site specific attribute, as can the parent font tag
-->
<xsl:template match="H2G2ID[parent::ARTICLERESULT]">
	<font xsl:use-attribute-sets="h2g2idstyle">
		<a xsl:use-attribute-sets="h2g2idlink">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="."/></xsl:attribute>
				A<xsl:value-of select="."/>
		</a>
	</font>
</xsl:template>

<!--
<xsl:template match="SUBJECT"/>
Context: Always a child of ARTICLERESULT
Purpose: Displays the SUBJECT of an article result, can optionally be displayed as a link 
-->
<xsl:template match="SUBJECT" mode="articleresult">
	<xsl:param name="link" select="'no'"/>
	<font xsl:use-attribute-sets="subjectstyle">
		<xsl:choose>
			<xsl:when test="$link='yes'">
				<a xsl:use-attribute-sets="subjectlink">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="../H2G2ID"/></xsl:attribute>
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</font>
</xsl:template>

<!--
<xsl:template match="STATUS"/>
Context: Always a child of ARTICLERESULT
Purpose: Appropriate when Site is split up into edited, recommended or normal sections - displays where the article result is in this process
-->
<xsl:template match="STATUS">
	<font xsl:use-attribute-sets="statusstyle">
		<xsl:choose>
			<xsl:when test=".=1">
				<xsl:value-of select="$m_EditedEntryStatusName"/>
			</xsl:when>
			<xsl:when test=".=9">
				<xsl:value-of select="$m_HelpPageStatusName"/>
			</xsl:when>
			<xsl:when test=".=4 or .=6 or .=11 or .=12 or .=13">
				<xsl:value-of select="$m_RecommendedEntryStatusName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_NormalEntryStatusName"/>
			</xsl:otherwise>
		</xsl:choose>
	</font>
</xsl:template>

<!--
<xsl:template match="SCORE"/>
Context: Always a child of ARTICLERESULT
Purpose:Display of the score a search result returns, ie how appropriate it is to the search criteria
-->
<xsl:template match="SCORE">
	<font xsl:use-attribute-sets="scorestyle">
		<xsl:value-of select="."/>%
	</font>
</xsl:template>

<!--
<xsl:template match="SHORTNAME"/>
Context: Always a child of ARTICLERESULT
Purpose: 
-->
<xsl:template match="SHORTNAME" mode="result">
	<font xsl:use-attribute-sets="shortnamestyle">
		<xsl:value-of select="."/>
	</font>
</xsl:template>

<!--
<xsl:template match="USERNAME"/>
Context: Always a child of USERRESULT
Purpose:Display a user as a link to his space
-->
<xsl:template match="USERNAME[parent::USERRESULT]">
	<font xsl:use-attribute-sets="useridstyle">
		<a xsl:use-attribute-sets="h2g2idlink">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="../USERID"/></xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</font>
</xsl:template>

<!--
<xsl:template match="SUBJECT"/>
Context: Always a child of USERRESULT
Purpose: Display the Forum subject as a link
-->
<xsl:template match="SUBJECT" mode="forumresult">
	<font xsl:use-attribute-sets="subjectstyle">
		<A href="{$root}F{../FORUMID}?thread={../THREADID}&amp;post={../POSTID}#p{../POSTID}" xsl:use-attribute-sets="forumresultlink">
				<xsl:choose>
					<xsl:when test="string-length(.) &gt; 0">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_nosubject"/>
					</xsl:otherwise>
				</xsl:choose>
		</A>
	</font>
</xsl:template>

</xsl:stylesheet>
