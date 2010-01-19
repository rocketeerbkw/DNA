<?xml version='1.0' encoding='ISO-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="REVIEWFORUM_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></title>
</xsl:template>

<xsl:template name="REVIEWFORUM_SUBJECT">
		<xsl:choose>
			<xsl:when test="REVIEWFORUM/ERROR">
				<xsl:call-template name="ERROR_SUBJECT"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:call-template name="SUBJECTHEADER">
				<xsl:with-param name="text"><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></xsl:with-param>
			</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<xsl:template name="REVIEWFORUM_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
				<tr>
					<td width="100%">	<img src="{$imagesource}t.gif" width="439" height="5" alt="" /></td>
					<td width="200"><img src="{$imagesource}t.gif" width="200" height="5" alt="" /></td>
				</tr>
				<tr valign="top">
					<td align="left">
						<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
						<font xsl:use-attribute-sets="textsmallfont"><xsl:text> </xsl:text></font>
					</td>
					<td><img src="{$imagesource}t.gif" height="28" alt="" /></td>
				</tr>
				<tr>
					<td align="left" valign="bottom" colspan="2">
						<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
						<font xsl:use-attribute-sets="textheaderfont"><b><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></b></font>
					</td>
				</tr>
				<tr>
					<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td>
				</tr>
			</table>	
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="REVIEWFORUM_MAINBODY">
	<table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td>
				<font xsl:use-attribute-sets="textfont" >
					<xsl:choose>
						<xsl:when test="REVIEWFORUM/REVIEWFORUMTHREADS">
							<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" />
							<xsl:if test=".//FOOTNOTE">
								<blockquote>
									<font xsl:use-attribute-sets="textsmallfont">
										<hr xsl:use-attribute-sets="nu_hr" />
										<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
									</font>
								</blockquote>
							</xsl:if>
						</xsl:when>
						<xsl:when test="REVIEWFORUM/ERROR">
							<xsl:call-template name="DEFAULT_ERROR">
								<xsl:with-param name="Message" select="REVIEWFORUM/ERROR/MESSAGE"/>
								<xsl:with-param name="LinkBody" select="REVIEWFORUM/ERROR/LINK"/>
								<xsl:with-param name="LinkHref" select="REVIEWFORUM/ERROR/LINK/@HREF"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<br /><br />
				</font>
			</td>
		</tr>
	</table>
	<xsl:if test="not(/H2G2/ARTICLE)">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" style="margin:0px;">
			<tr valign="top">
				<td width="100%" bgcolor="#000000">
					<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS"/>
					<br /><br />
				</td>
			</tr>
		</table>
	</xsl:if>
</xsl:template>

<xsl:template name="REVIEWFORUM_SIDEBAR">
	<xsl:if test="/H2G2/ARTICLE">
	<table width="200" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
		<xsl:choose>	
			<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
				<tr valign="top">
					<td width="1" rowspan="3"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="1" bgcolor="#000000" class="postable"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="197">
						<table width="197" cellspacing="5" cellpadding="0" border="0" bgcolor="#000000" class="postable">
							<tr>
								<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
									<a class="pos">
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/>EditReview?id=<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute>
										<xsl:value-of select="$m_reviewforumdata_edit"/>
									</a>
								</b></font></td>
							</tr>
						</table>
					</td>
					<td width="1" rowspan="3" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				</tr>
				<tr>
					<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				</tr>
			</xsl:when>
			<xsl:otherwise> 
			<tr valign="top">
					<td width="1" rowspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="1" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="197" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="197" height="1" alt="" /></td>
					<td width="1" rowspan="2" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				</tr>
			</xsl:otherwise>
		</xsl:choose> 
		<tr valign="top">
			<td bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="260" alt="" /></td>
			<td>
				<table width="197" cellspacing="0" cellpadding="3" border="0" background="">
					<tr>
						<td colspan="3" bgcolor="#333333" style="background:#CCCCCC"><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:value-of select="$m_rf_datahead"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="191" height="1" alt="" /></td>
					</tr>
					<tr>
						<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					</tr>
					<tr valign="top">
						<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
						<td>
							<font xsl:use-attribute-sets="smallfont">
								<b><xsl:value-of select="$m_rf_subhead_name"/></b><br /><br />
								<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
								<br /><br />
							</font>
						</td>
						<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
					</tr>
					<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
					<tr valign="top">
						<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
						<td>
							<font xsl:use-attribute-sets="smallfont">
								<b><xsl:value-of select="$m_rf_subhead_url"/></b><br /><br />
								<xsl:value-of select="REVIEWFORUM/URLFRIENDLYNAME"/>
								<br /><br />
							</font>
						</td>
						<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
					</tr>
					<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
					<xsl:choose>
						<xsl:when test="REVIEWFORUM/RECOMMENDABLE=1">
							<tr valign="top">
								<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
								<td>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_rf_subhead_reccomend"/></b><br /><br />
										<xsl:value-of select="$m_rf_subhead_reccomendy"/><br /><br />
									</font>
								</td>
								<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
							</tr>
							<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
							<tr valign="top">
								<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
								<td>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_rf_subhead_incubate"/></b><br /><br />
										<xsl:value-of select="REVIEWFORUM/INCUBATETIME"/><xsl:value-of select="$m_rf_subhead_incubated"/>
										<br /><br />
									</font>
								</td>
								<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
							</tr>
							<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
						</xsl:when>
						<xsl:otherwise>
							<tr valign="top">
								<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
								<td>
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_rf_subhead_reccomend"/></b><br /><br />
										<xsl:value-of select="$m_rf_subhead_reccomendn"/><br /><br />
									</font>
								</td>
								<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
							</tr>
							<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
						<tr valign="top">
							<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
							<td>
								<font xsl:use-attribute-sets="smallfont">
									<b><xsl:value-of select="$m_reviewforumdata_h2g2id"/></b><br /><br />
									<a class="norm"><xsl:attribute name="HREF">A<xsl:value-of select="REVIEWFORUM/H2G2ID"/></xsl:attribute>A<xsl:value-of select="REVIEWFORUM/H2G2ID"/></a>
									<br /><br />
								</font>
							</td>
							<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
						</tr>
						<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
					</xsl:if>
					<tr>
						<td width="14"><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
						<td width="161"><img src="{$imagesource}t.gif" width="161" height="3" alt="" /></td>
						<td width="4"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br /><br />
	</xsl:if>
</xsl:template>

<xsl:template name="REVIEWFORUM_MIDDLE">
<xsl:if test="/H2G2/ARTICLE">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" style="margin:0px;">
		<tr valign="top">
			<xsl:call-template name="nuskin-dummynav"/>
			<td width="100%" bgcolor="#000000">
				<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS"/>
				<br /><br />
			</td>
		</tr>
	</table>
</xsl:if>
</xsl:template>

<xsl:template match="REVIEWFORUM/REVIEWFORUMTHREADS">
	<xsl:variable name="var_orderby">
		<xsl:choose>
			<xsl:when test="@ORDERBY=1">dateentered</xsl:when>
			<xsl:when test="@ORDERBY=2">lastposted</xsl:when>
			<xsl:when test="@ORDERBY=3">authorid</xsl:when>
			<xsl:when test="@ORDERBY=4">authorname</xsl:when>
			<xsl:when test="@ORDERBY=5">entry</xsl:when>
			<xsl:when test="@ORDERBY=6">subject</xsl:when>
			<xsl:otherwise>dateentered</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="op_dir">
		<xsl:choose>
			<xsl:when test="@DIR=1">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
		<tr>
			<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="6" border="0" bgcolor="#333333" style="background:#CCCCCC">
		<tr>
			<td>
				<font xsl:use-attribute-sets="smallfont" class="postxt">
					<b><xsl:value-of select="$m_rf_entrev"/></b>
				</font>
				<br clear="all" />
				<img src="{$imagesource}t.gif" width="628" height="1" alt="" />
			</td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<xsl:if test="/H2G2/NOGUIDE">
					<font xsl:use-attribute-sets="nullsmallfont">
						<xsl:call-template name="threadnavbuttons">
							<xsl:with-param name="URL">RF</xsl:with-param>
							<xsl:with-param name="ID" select="../@ID"/>
							<xsl:with-param name="ExtraParameters">?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/></xsl:with-param>
							<xsl:with-param name="showconvs"><xsl:value-of select="$alt_rf_showconvs"/></xsl:with-param>
							<xsl:with-param name="shownewest"><xsl:value-of select="$alt_rf_shownewest"/></xsl:with-param>
							<xsl:with-param name="alreadynewestconv"><xsl:value-of select="$alt_rf_alreadynewestconv"/></xsl:with-param>
							<xsl:with-param name="nonewconvs"><xsl:value-of select="$alt_rf_nonewconvs"/></xsl:with-param>
							<xsl:with-param name="showoldestconv"><xsl:value-of select="$alt_rf_showoldestconv"/></xsl:with-param>
							<xsl:with-param name="noolderconv"><xsl:value-of select="$alt_rf_noolderconv"/></xsl:with-param>
							<xsl:with-param name="showingoldest"><xsl:value-of select="$alt_rf_showingoldest"/></xsl:with-param>
						</xsl:call-template>
						<br/>
						<xsl:call-template name="forumpostblocks">
							<xsl:with-param name="forum"></xsl:with-param>
							<xsl:with-param name="skip" select="0"/>
							<xsl:with-param name="show" select="@COUNT"/>
							<xsl:with-param name="total" select="@TOTALTHREADS"/>
							<xsl:with-param name="this" select="@SKIPTO"/>
							<xsl:with-param name="url">RF<xsl:value-of select="../@ID"/>?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/></xsl:with-param>
							<xsl:with-param name="objectname" select="'Entries'"/>
							<xsl:with-param name="target"></xsl:with-param>
						</xsl:call-template>
					</font>
				</xsl:if>
				<a><xsl:attribute name="id"><xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute></a>
			</td>
		</tr>
		<xsl:choose>
			<xsl:when test="THREAD">		
				<tr>
					<td>
						<font xsl:use-attribute-sets="smallfont"><xsl:value-of select="$m_rf_entrevblurb"/></font><br />
						<table width="100%" cellspacing="0" cellpadding="0" border="0">
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
									<tr>
										<td colspan="7" background="{$imagesource}dotted_line_inv.jpg">
											<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td colspan="6" background="{$imagesource}dotted_line_inv.jpg">
											<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
							<tr>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=5">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selecth2g2id"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_h2g2id"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=6">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selectsubject"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_subject"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=1">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selectdateentered"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_dateentered"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=2">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selectlastposted"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_lastposted"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=4">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selectauthor"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_author"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<td align="left">
									<font xsl:use-attribute-sets="smallfont">
										<xsl:choose>
											<xsl:when test="@ORDERBY=3">
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_selectauthorid"/></A> 
											</xsl:when>
											<xsl:otherwise>
												<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute><xsl:call-template name="m_rft_authorid"/></A> 
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
								<xsl:choose>
									<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
										<td>
											<font xsl:use-attribute-sets="xsmallfont">
												<xsl:text disable-output-escaping="yes">&amp;nbsp</xsl:text>	
											</font>
										</td>
									</xsl:when>
								</xsl:choose>
							</tr>
							<xsl:choose>
								<xsl:when test="THREAD">
									<xsl:for-each select="THREAD">
										<tr>
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>A<xsl:value-of select="H2G2ID"/>&nbsp;&nbsp;</A>
												</font>
											</td>
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm">
														<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
														<xsl:call-template name="TRUNCATE">
															<xsl:with-param name="longtext"><xsl:apply-templates mode="nosubject" select="SUBJECT" /></xsl:with-param>
															<xsl:with-param name="maxlength">58</xsl:with-param>
														</xsl:call-template>
													</A>
												</font>
											</td>
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm"><xsl:attribute name="HREF">F<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" /></xsl:attribute><xsl:value-of select="DATEENTERED/DATE/@RELATIVE"/></A>
												</font>
											</td>
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;latest=1</xsl:attribute><xsl:apply-templates select="DATEPOSTED" /></A>
												</font>
											</td> 
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/></xsl:attribute><xsl:apply-templates select="AUTHOR/USER/USERNAME" mode="truncated"/></A>
												</font>
											</td>
											<td>
												<font xsl:use-attribute-sets="xsmallfont">
													<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/></xsl:attribute>U<xsl:value-of select="AUTHOR/USER/USERID"/></A>
												</font>
											</td>
											<xsl:choose>
												<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
													<td>
														<font xsl:use-attribute-sets="xsmallfont">
															<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>SubmitReviewForum?action=removethread&amp;rfid=<xsl:value-of select="../../@ID"/>&amp;h2g2id=<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('Remove entry from Review Forum?');</xsl:attribute><img src="{$imagesource}perspace/unsubscribe2.gif" width="6" height="6" alt="Remove" border="0" /></A>
														</font>
													</td>
												</xsl:when>
											</xsl:choose>
										</tr>
									</xsl:for-each>
									<xsl:choose>
										<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
											<tr>
												<td colspan="7" background="{$imagesource}dotted_line_inv.jpg">
													<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td colspan="6" background="{$imagesource}dotted_line_inv.jpg">
													<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="smallfont"><b>
							<xsl:if test="not(/H2G2/NOGUIDE)">
								<xsl:if test="@MORE=1">
									<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?entry=0&amp;skip=0&amp;show=25&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/></xsl:attribute><xsl:value-of select="$m_clickmorereviewentries"/></A>
									<xsl:value-of select="$skipdivider"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$registered=1">
								<xsl:call-template name="subscribearticleforum">
									<xsl:with-param name="ForumID" select="@FORUMID"/>
									<xsl:with-param name="ID" select="../@ID"/>
									<xsl:with-param name="URL">RF</xsl:with-param>
									<xsl:with-param name="Desc" select="$alt_returntoreviewforum"/>
									<xsl:with-param name="Notify" select="$m_notifynewentriesinreviewforum"/>
									<xsl:with-param name="DeNotify"><xsl:value-of select="$m_stopnotifynewentriesreviewforum"/></xsl:with-param>
								</xsl:call-template>
								<xsl:value-of select="$skipdivider"/>
							</xsl:if>
							<img src="{$imagesource}perspace/unsubscribe2.gif" width="6" height="6" alt="Remove" border="0" /> = <xsl:call-template name="m_removefromreviewforum"/>
						</b></font>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>
						<font xsl:use-attribute-sets="smallfont">
							<b><xsl:value-of select="$m_rftnoarticlesinreviewforum"/></b>
						</font>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</table>
</xsl:template>

</xsl:stylesheet>
