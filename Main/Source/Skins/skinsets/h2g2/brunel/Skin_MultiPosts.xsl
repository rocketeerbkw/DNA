<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">
<!--

<xsl:attribute-set name="maINREPLYTO_multiposts1">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maINREPLYTO_multiposts2">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maFIRSTCHILD_multiposts1">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maFIRSTCHILD_multiposts2">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maPOSTID_ReplyToPost">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maPOSTID_moderation">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maPOSTID_editpost">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="maHIDDEN_multiposts">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>

-->

<xsl:template name="MULTIPOSTS_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_multiposts_title"/></title>
</xsl:template>

<xsl:template name="MULTIPOSTS_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:value-of select="$m_multiposts_head"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MULTIPOSTS_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="barcolour">000000</xsl:with-param>
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="68" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:apply-templates select="FORUMSOURCE"/></b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MULTIPOSTS_MAINBODY">
			<div align="right">
				<xsl:choose>				
					<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 1">
						<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')  or ($superuser = 1)">
							<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=closethread">
							<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_close.gif" alt="Close this thread" width="137" height="23" border="0" vspace="5" hspace="5"/></a>							</xsl:if>				
					</xsl:when>
					<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 0">
					<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_closed.gif" alt="This thread has been closed" width="183" height="23" border="0" vspace="5" hspace="5"/>				
						<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')  or ($superuser = 1)">
							<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=reopenthread">
							<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_open.gif" alt="Open this thread" width="139" height="23" border="0" vspace="5" hspace="0"/></a><br clear="all"/>
							<p><font face="verdana, helvetica, sans-serif" size="2" color="#ffffff"><b>(If you are an editor you will still see the reply buttons)</b></font></p>
						</xsl:if>
					</xsl:when>					
				</xsl:choose>
			</div>		
<xsl:call-template name="showthreadintro"/>
<!--
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr><td background="{$imagesource}dotted_line_ssml_inv.gif"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
		</table>	
-->
		<table width="100%" cellspacing="0" cellpadding="10" border="0">
			<tr>
				<td>
					<xsl:call-template name="sidebarforumnav"/>
				</td>
			</tr>
		</table>
	<xsl:apply-templates select="FORUMTHREADPOSTS">
		<xsl:with-param name="ptype" select="'single'" />
	</xsl:apply-templates>
	<xsl:call-template name="forumgadgetkey"/>
	<table width="100%" cellspacing="0" cellpadding="10" border="0">
		<tr>
			<td>
					<xsl:call-template name="sidebarforumnav"/><br clear="all" />
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_inv.jpg">
								<img src="{$imagesource}t.gif" width="600" height="9" alt="" />
							</td>
						</tr>
					</table>
				<br clear="all" />
				<xsl:call-template name="subscribethreadposts"/>
				<br /><br /><br /><br />
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="MULTIPOSTS_SIDEBAR">
</xsl:template>

<xsl:template match="FORUMTHREADPOSTS">
	<xsl:param name="ptype" select="'frame'" />
	<xsl:apply-templates select="POST">
		<xsl:with-param name="ptype"><xsl:value-of select="$ptype" /></xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="subscribethreadposts">
	<xsl:if test="$registered=1">
		<font xsl:use-attribute-sets="mainfont"><b>
			<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" />
			<xsl:choose>
				<xsl:when test="SUBSCRIBE-STATE[@THREAD='1']">
					<a class="norm" target="_top" href="{$root}FSB{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={FORUMTHREADPOSTS/@SKIPTO}&amp;show={FORUMTHREADPOSTS/@COUNT}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADPOSTS/@FORUMID}%3Fthread={FORUMTHREADPOSTS/@THREADID}%26amp;skip={FORUMTHREADPOSTS/@SKIPTO}%26amp;show={FORUMTHREADPOSTS/@COUNT}"><xsl:value-of select="$m_clickunsubscribe"/></a>
				</xsl:when>
				<xsl:otherwise>
					<a class="norm" target="_top" href="{$root}FSB{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={FORUMTHREADPOSTS/@SKIPTO}&amp;show={FORUMTHREADPOSTS/@COUNT}&amp;cmd=subscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{FORUMTHREADPOSTS/@FORUMID}%3Fthread={FORUMTHREADPOSTS/@THREADID}%26amp;skip={FORUMTHREADPOSTS/@SKIPTO}%26amp;show={FORUMTHREADPOSTS/@COUNT}"><xsl:value-of select="$m_clicksubscribe"/></a>
				</xsl:otherwise>
			</xsl:choose>
		</b></font>
	</xsl:if>
</xsl:template>

<xsl:template name="sidebarforumnav">
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr valign="top">
			<td width="150">
				<xsl:if test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT &gt; /H2G2/FORUMTHREADPOSTS/@COUNT">
				<font xsl:use-attribute-sets="smallfont">
					<font xsl:use-attribute-sets="nullsmallfont">
						<xsl:call-template name="messagenavbuttons">
							<xsl:with-param name="skipto"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@SKIPTO"/></xsl:with-param>
							<xsl:with-param name="count"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@COUNT"/></xsl:with-param>
							<xsl:with-param name="forumid"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@FORUMID"/></xsl:with-param>
							<xsl:with-param name="threadid"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@THREADID"/></xsl:with-param>
							<xsl:with-param name="more"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@MORE"/></xsl:with-param>
						</xsl:call-template>
					</font>
					<xsl:value-of select="$skipdivider"/>
					<img src="{$imagesource}t.gif" width="150" height="1" alt="" />
				</font>
				</xsl:if>
			</td>
			<td width="50%">
				<xsl:if test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT &gt; /H2G2/FORUMTHREADPOSTS/@COUNT">
				<xsl:call-template name="forumpostblocks">
					<xsl:with-param name="forum" select="/H2G2/FORUMTHREADPOSTS/@FORUMID"/>
					<xsl:with-param name="thread" select="/H2G2/FORUMTHREADPOSTS/@THREADID"/>
					<xsl:with-param name="skip" select="0"/>
					<xsl:with-param name="show" select="/H2G2/FORUMTHREADPOSTS/@COUNT"/>
					<xsl:with-param name="total" select="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/>
					<xsl:with-param name="this" select="/H2G2/FORUMTHREADPOSTS/@SKIPTO"/>
					<xsl:with-param name="url" select="'F'"/>
					<xsl:with-param name="objectname" select="'Postings'"/>
					<xsl:with-param name="target"></xsl:with-param>
					<xsl:with-param name="blocklimit" select="20"/>
				</xsl:call-template>
				</xsl:if>
						<!--	<img src="{$imagesource}t.gif" width="320" height="1" alt="" /> -->
			</td>
			<td width="50%" valign="top" align="right">
				<font xsl:use-attribute-sets="smallfont"><b>
					<!--<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" />-->
					<xsl:choose>
						<xsl:when test="/H2G2/FORUMSOURCE/REVIEWFORUM">
							<a class="norm" href="{$root}RF{/H2G2/FORUMSOURCE/REVIEWFORUM/@ID}?entry=0">
								<xsl:value-of select="$m_articlelisttext"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a class="norm" href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?showthread={/H2G2/FORUMTHREADPOSTS/@THREADID}">
								<xsl:value-of select="$m_returntothreadspage"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</b>
					<xsl:for-each select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/preceding-sibling::THREAD[1]">
					<br/><b><a href="{$root}F{@FORUMID}?thread={@THREADID}">&lt;&lt; <xsl:value-of select="SUBJECT"/></a></b></xsl:for-each>
					<xsl:for-each select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/following-sibling::THREAD[1]">
					<br/><b><a href="{$root}F{@FORUMID}?thread={@THREADID}"><xsl:value-of select="SUBJECT"/> &gt;&gt;</a></b></xsl:for-each><br/>
					
					<!--<hr/>
					<select name="forum">
					<xsl:for-each select="/H2G2/FORUMTHREADS/THREAD">
					<option value="1"><xsl:value-of select="@INDEX"/>: <xsl:value-of select="SUBJECT"/></option>
					</xsl:for-each>
					</select>-->
				</font>							
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:attribute-set name="as_skiptoprevious">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="as_skiptonext">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="messagenavbuttons">
	<xsl:param name="skipto">0</xsl:param>
	<xsl:param name="count">0</xsl:param>
	<xsl:param name="forumid">0</xsl:param>
	<xsl:param name="threadid">0</xsl:param>
	<xsl:param name="more">0</xsl:param>
	<b>
		<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="navbuttons">
			<xsl:with-param name="URL" select="'F'"/>
			<xsl:with-param name="skiptoprevious"><xsl:value-of select="$m_prevlist"/></xsl:with-param>
			<xsl:with-param name="skiptonext"><xsl:value-of select="$m_nextlist"/></xsl:with-param>
			<xsl:with-param name="skiptopreviousfaded"><xsl:value-of select="$m_prevlist"/></xsl:with-param>
			<xsl:with-param name="skiptonextfaded"><xsl:value-of select="$m_nextlist"/></xsl:with-param>
			<xsl:with-param name="navbuttonsspacer"><font color="#ffffff"><xsl:value-of select="$skipdivider"/></font></xsl:with-param>
			<xsl:with-param name="showendpoints" select="false()"/>
		</xsl:apply-templates>
	</b>
</xsl:template>

<xsl:template match="FORUMTHREADPOSTS/POST">
	<xsl:param name="ptype" select="'frame'"/>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td>
				<table width="100%" cellspacing="10" cellpadding="0" border="0" bgcolor="#000000" class="postable">
					<tr valign="top">
						<td align="left" rowspan="3" width="100%"><img src="{$imagesource}t.gif" width="554" height="1" alt="" /><br clear="all" />
							<font xsl:use-attribute-sets="textfont">
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr valign="top">
										<td width="100%">							
											<a name="pi{count(preceding-sibling::POST) + 1 + number(../@SKIPTO)}">
											<a name="p{@POSTID}">
											<font xsl:use-attribute-sets="textfont"><b><xsl:call-template name="postsubjectnolink" /></b></font>
											</a>
											</a>
											<br clear="all" /><img src="{$imagesource}t.gif" width="500" height="1" alt="" />
										</td>
										<td width="60" align="right">
											<font xsl:use-attribute-sets="smallfont" class="postxt">
												<xsl:apply-templates select="." mode="postnumber"/>
											</font>
											<br clear="all" /><img src="{$imagesource}t.gif" width="60" height="1" alt="" />
										</td>
									</tr>
								</table>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<xsl:value-of select="$m_posted"/>
										<xsl:apply-templates select="DATEPOSTED/DATE"/>
										<xsl:if test="not(@HIDDEN &gt; 0)">
											<xsl:value-of select="$m_by"/>
											<xsl:apply-templates select="USER" mode="showonline">
											<xsl:with-param name="symbol"><img src="{$imagesource}online.gif" alt="Online Now"/></xsl:with-param>
											</xsl:apply-templates>
											<xsl:choose>
											<xsl:when test="USER/EDITOR=1">
											<b><i><xsl:apply-templates select="USER/USERNAME" mode="UserResult">
												<xsl:with-param name="attributes"	>
													<attribute name="target" value="_top"/>
													<attribute name="class" value="pos"/>
												</xsl:with-param>
											</xsl:apply-templates></i></b>
											</xsl:when>
											<xsl:otherwise>
											<xsl:apply-templates select="USER/USERNAME" mode="UserResult">
												<xsl:with-param name="attributes">
													<attribute name="target" value="_top"/>
													<attribute name="class" value="pos"/>
												</xsl:with-param>
											</xsl:apply-templates>
											</xsl:otherwise>
											</xsl:choose>
									</xsl:if>
								</font>
								<br/>
								<!--<font xsl:use-attribute-sets="smallfont" class="postxt">
									<xsl:if test="@INREPLYTO">
										<xsl:value-of select="$m_inreplyto"/>
										<xsl:apply-templates select="@INREPLYTO" mode="multiposts"/>
									</xsl:if>
									<xsl:if test="@INREPLYTO and @FIRSTCHILD"><xsl:value-of select="$skipdivider"/></xsl:if>
									<xsl:if test="@FIRSTCHILD">
										<xsl:value-of select="$m_readthe"/>
										<xsl:apply-templates select="@FIRSTCHILD" mode="multiposts"/>
									</xsl:if>
								</font>
								<br /> -->
								<xsl:call-template name="showpostbody"/>
								<br /><br />
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td>
											<font xsl:use-attribute-sets="textfont">
												<xsl:apply-templates select="@POSTID" mode="ReplyToPost">
												</xsl:apply-templates>
											</font>
										</td>
										<td align="right">
											<font xsl:use-attribute-sets="smallfont" class="postxt"><b>
												<xsl:choose>
													<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR'">
														<xsl:apply-templates select="@POSTID" mode="moderation"/>
														<xsl:value-of select="$skipdivider"/>
														<xsl:apply-templates select="@POSTID" mode="editpost"/>
													</xsl:when>
													<xsl:otherwise><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></xsl:otherwise>
												</xsl:choose>

											</b></font>
										</td>
									</tr>
								</table>
							</font>
						</td>
						<td width="38" align="right"><img src="{$imagesource}t.gif" width="38" height="1" alt="" /><br clear="all" />
							 <nobr>
								<xsl:apply-templates select="@POSTID" mode="CreateAnchor"/>
								<xsl:choose>
									<xsl:when test="@PREVINDEX">
										<xsl:apply-templates select="@PREVINDEX" mode="multiposts">
											<xsl:with-param name="ptype" select="$ptype"/>
											<xsl:with-param name="embodiment">
												<img width="14" height="14" src="{$imagesource}conv/post_up.gif" border="0" hspace="2" alt="Previous Post"/>
											</xsl:with-param>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<img width="14" height="14" src="{$imagesource}conv/post_noup.gif" border="0" hspace="2" alt="No Previous Post"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="@NEXTINDEX">
										<xsl:apply-templates select="@NEXTINDEX" mode="multiposts">
											<xsl:with-param name="ptype" select="$ptype"/>
											<xsl:with-param name="embodiment">
												<img width="14" height="14" src="{$imagesource}conv/post_down.gif" border="0" hspace="2" alt="Next Post"/>
											</xsl:with-param>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<img width="14" height="14" src="{$imagesource}conv/post_nodown.gif" border="0" hspace="2" alt="No Next Post"/>
									</xsl:otherwise>
								</xsl:choose>
							</nobr>
							<br clear="all" /> 
						</td>
					</tr>
					<tr>
						<td valign="bottom" align="right">
							<xsl:if test="@HIDDEN=0">
								<xsl:apply-templates select="@HIDDEN" mode="multiposts">
									<xsl:with-param name="embodiment">
										<img width="16" height="16" src="{$imagesource}conv/complaint.gif" border="0" vspace="0" alt="{$alt_gadget_complaint}"/>
									</xsl:with-param>
								</xsl:apply-templates>		
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td valign="bottom" align="right">
							<xsl:call-template name="forumgadget"><xsl:with-param name="ptype">{$ptype}</xsl:with-param></xsl:call-template>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td bgcolor="#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="forumgadget">
	<xsl:param name="ptype" select="'frame'"/>
	<table width="38" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td><img src="{$imagesource}conv/nav_11.gif" width="12" height="12" alt="" border="0" /></td>
			<td>
				<xsl:choose>
					<xsl:when test="@INREPLYTO">
						<xsl:choose>
							<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
								<a>
									<xsl:attribute name="HREF">#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_12_on.gif" width="14" height="12" alt="{$alt_gadget_parent}" border="0" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if>
									<xsl:attribute name="HREF">
										<xsl:value-of select="$root"/>
										<xsl:choose>
											<xsl:when test="$ptype='frame'">FLR</xsl:when>
											<xsl:otherwise>F</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@INREPLYTO" />#p<xsl:value-of select="@INREPLYTO" />
									</xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_12_on.gif" width="14" height="12" alt="{$alt_gadget_parent}" border="0" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}conv/nav_12_off.gif" width="14" height="12" alt="{$alt_gadget_parent}" border="0" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><img src="{$imagesource}conv/nav_13.gif" width="12" height="12" alt="" border="0" /></td>
		</tr>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="@PREVSIBLING">
						<xsl:choose>
							<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
								<a>
									<xsl:attribute name="HREF">#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_21_on.gif" width="12" height="13" alt="{$alt_gadget_oldersib}" border="0" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if>
									<xsl:attribute name="HREF">
										<xsl:value-of select="$root"/>
										<xsl:choose>
											<xsl:when test="$ptype='frame'">F</xsl:when>
											<xsl:otherwise>F</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" />#p<xsl:value-of select="@PREVSIBLING" />
									</xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_21_on.gif" width="12" height="13" alt="{$alt_gadget_oldersib}" border="0" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}conv/nav_21_off.gif" width="12" height="13" alt="{$alt_gadget_oldersib}" border="0" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><img src="{$imagesource}conv/nav_22.gif" width="14" height="13" alt="{$alt_gadget_this}" border="0" /></td>
			<td>
				<xsl:choose>
					<xsl:when test="@NEXTSIBLING">
						<xsl:choose>
							<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
								<a>
									<xsl:attribute name="HREF">#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_23_on.gif" width="12" height="13" alt="{$alt_gadget_youngsib}" border="0" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if>
									<xsl:attribute name="HREF">
										<xsl:value-of select="$root"/>
										<xsl:choose>
											<xsl:when test="$ptype='frame'">FLR</xsl:when>
											<xsl:otherwise>F</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" />#p<xsl:value-of select="@NEXTSIBLING" />
									</xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_23_on.gif" width="12" height="13" alt="{$alt_gadget_youngsib}" border="0" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}conv/nav_23_off.gif" width="12" height="13" alt="{$alt_gadget_youngsib}" border="0" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<tr>
			<td><img src="{$imagesource}pixel_white.gif" width="12" height="13" alt="" /></td>
			<td>
				<xsl:choose>
					<xsl:when test="@FIRSTCHILD">
						<xsl:choose>
							<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
								<a>
									<xsl:attribute name="HREF">#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_32_on.gif" width="14" height="13" alt="{$alt_gadget_gchild}" border="0" />
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if>
									<xsl:attribute name="HREF">
										<xsl:value-of select="$root"/>
										<xsl:choose>
											<xsl:when test="$ptype='frame'">FLR</xsl:when>
											<xsl:otherwise>F</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@FIRSTCHILD" />#p<xsl:value-of select="@FIRSTCHILD" />
									</xsl:attribute>
									<xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute>
									<img src="{$imagesource}conv/nav_32_on.gif" width="14" height="13" alt="{$alt_gadget_gchild}" border="0" />
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}conv/nav_32_off.gif" width="14" height="13" alt="{$alt_gadget_gchild}" border="0" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><img src="{$imagesource}pixel_white.gif" width="12" height="13" alt="" /></td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="postsubjectnolink">
	<font xsl:use-attribute-sets="textfont">
		<xsl:choose>
			<xsl:when test="SUBJECT=''">&lt;<xsl:value-of select="$m_nosubject"/>&gt;</xsl:when>
			<xsl:otherwise><xsl:value-of select="SUBJECT" /></xsl:otherwise>
		</xsl:choose>
	</font>
</xsl:template>

<xsl:template name="forumgadgetkey">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td colspan="9">
				<img src="{$imagesource}t.gif" width="639" height="1" alt="" />
			</td>
		</tr>
		<tr valign="top">
			<td width="14">
				<img src="{$imagesource}t.gif" width="14" height="1" alt="" />
			</td>
			<td width="40">
				<img src="{$imagesource}t.gif" width="40" height="5" alt="" /><br clear="all" />
				<font face="arial, helvetica, sans-serif" size="2" class="postxt"><b><xsl:value-of select="$m_gadget_key"/></b></font>
			</td>
			<td width="17">
				<img src="{$imagesource}dotted_line_vert.gif" width="17" height="65" alt="" border="0" />
			</td>
			<td width="74">
				<img src="{$imagesource}conv/nav_example.gif" width="74" height="63" alt="{$alt_gadget_example}" border="0" />
			</td>
			<td width="220">
				<img src="{$imagesource}t.gif" width="220" height="5" alt="" /><br clear="all" />
				<font face="arial, helvetica, sans-serif" size="1" class="postxt"><xsl:value-of select="$m_gadget_a"/><br /><xsl:value-of select="$m_gadget_b"/><br /><xsl:value-of select="$m_gadget_c"/><br /><xsl:value-of select="$m_gadget_d"/><br /></font>
			</td>
			<td width="17">
				<img src="{$imagesource}dotted_line_vert.gif" width="17" height="65" alt="" border="0" />
			</td>
			<td width="16">
				<img src="{$imagesource}conv/complaint.gif" width="16" height="16" alt="{$alt_gadget_complaint}" border="0" vspace="8" />
			</td>
			<td width="100%">
				<img src="{$imagesource}t.gif" width="227" height="10" alt="" /><br clear="all" />
				<font face="arial, helvetica, sans-serif" size="1" class="postxt"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="$m_gadget_complaint"/></font>
			</td>
			<td width="14">
				<img src="{$imagesource}t.gif" width="14" height="1" alt="" />
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="showthreadintro">
<xsl:if test="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/THREADINTRO">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="14" rowspan="5"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				<td width="100%" background="{$imagesource}dotted_line_sml.jpg"><img src="{$imagesource}t.gif" width="611" height="5" alt="" /></td>
				<td width="14" rowspan="5"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/THREADINTRO"/></font></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
			<tr>
				<td width="100%" background="{$imagesource}dotted_line_sml.jpg"><img src="{$imagesource}t.gif" width="611" height="5" alt="" /></td>
			</tr>
		</table>
</xsl:if>
</xsl:template>


</xsl:stylesheet>
