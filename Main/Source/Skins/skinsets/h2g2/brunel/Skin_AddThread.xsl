<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">


<xsl:attribute-set name="iPOSTTHREADFORM_Subject">
	<xsl:attribute name="tabindex">1</xsl:attribute>
	<xsl:attribute name="type">text</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="ADDTHREAD_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_posttoaforum"/></title>
	<xsl:call-template name="EnhEditorJS" />
</xsl:template>

<xsl:template name="ADDTHREAD_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:choose><xsl:when test="POSTTHREADUNREG"><xsl:value-of select="$m_greetingshiker"/></xsl:when><xsl:otherwise><xsl:value-of select="$m_posttoaforum"/></xsl:otherwise></xsl:choose></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="ADDTHREAD_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="barcolour">000000</xsl:with-param>
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont"><b> 	
							<xsl:if test="/H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED = 1">
								<p style="color:#ffffff; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This message has been blocked as it contains a word which other users may find offensive. Please edit your message and post it again.</p>
							</xsl:if>		
							<xsl:choose>
								<xsl:when test="/H2G2/POSTTHREADFORM/@THREADID = 0">
									<xsl:value-of select="$m_thread_postconv"/>
								</xsl:when>
								<xsl:when test="/H2G2/POSTTHREADFORM/RETURNTO">
									<xsl:value-of select="$m_thread_replyto"/>
									<A class="norm">
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="/H2G2/POSTTHREADFORM/RETURNTO/H2G2ID"/></xsl:attribute>
										<xsl:value-of select="$m_returntoentry"/>
									</A>
								</xsl:when>
								<xsl:when test="/H2G2/POSTTHREADFORM/@INREPLYTO &gt; 0">
									<xsl:value-of select="$m_thread_replyto"/>
									<A class="norm">
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID"/>&amp;post=<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>#p<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/></xsl:attribute>
										<xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/>
									</A>
								</xsl:when>
								<xsl:when test="/H2G2/POSTTHREADUNREG">
									<xsl:value-of select="$m_thread_curunable"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$m_thread_replyto"/>
									<A class="norm">
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/></xsl:attribute>
										<xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="ADDTHREAD_MAINBODY">
	<td width="100%" bgcolor="#000000" class="postable">
		<table width="100%" cellspacing="0" cellpadding="8" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="textfont">
<xsl:call-template name="showaddthreadintro"/>
						<xsl:choose>
							<xsl:when test="ERROR">
								<xsl:choose>
									<xsl:when test="ERROR/@TYPE='REVIEWFORUM'"><xsl:call-template name="m_thread_postnotallowspecific" /></xsl:when>
									<xsl:when test="ERROR/@TYPE='BADREVIEWFORUM'"><xsl:value-of select="$m_thread_postnotallow"/></xsl:when>
									<xsl:when test="ERROR/@TYPE='DBERROR'"><xsl:value-of select="$m_thread_dberror"/></xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="POSTTHREADFORM" />
								<xsl:apply-templates select="POSTTHREADUNREG"/>
								<xsl:apply-templates select="POSTPREMODERATED"/>
							</xsl:otherwise>
						</xsl:choose>
						<br /><br />
					</font>
				</td>
			</tr>
		</table>
		<xsl:if test="POSTTHREADFORM">
			<script type="text/javascript" language="JavaScript">
				<xsl:comment>
					var domPath = document.theForm.body;
				//</xsl:comment>
			</script>
		</xsl:if>
	</td>
</xsl:template>

<!-- IL start -->
<xsl:attribute-set name="iPOSTTHREADFORM_Subject">
	<xsl:attribute name="size">39</xsl:attribute>
	<xsl:attribute name="style">width:300px;</xsl:attribute>
</xsl:attribute-set>
<!-- IL end-->

<xsl:template match="POSTTHREADFORM">
	<xsl:if test="PREVIEWBODY">
		<table width="100%" cellpadding="0" cellspacing="6" border="0">
			<xsl:choose>
<!-- IL start -->
				<xsl:when test="$test_HasPreviewBody">
<!-- IL end -->
					<tr>
						<td colspan="2"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_previewurpost"/></b></font></td>
					</tr>
					<tr>
						<td><font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:value-of select="$m_whatpostlooklike"/></font></td>
						<td align="right"><font xsl:use-attribute-sets="smallfont" class="postxt"><a href="#reply" class="pos"><b><xsl:value-of select="$m_jumptoreply"/></b></a></font></td>
					</tr>
					<tr>
						<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
					</tr>
					<tr>
						<td colspan="2">
							<font xsl:use-attribute-sets="textfont">
								<img src="{$imagesource}t.gif" width="1" height="10" alt="" /><br clear="all" />
								<xsl:value-of select="$m_fsubject"/>
								<b><xsl:value-of select="SUBJECT"/></b>
								<br />
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<xsl:value-of select="$m_postedsoon"/>
<!-- IL start -->
									<xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="UserName">
										<xsl:with-param name="useFont">0</xsl:with-param>
									</xsl:apply-templates>
<!-- IL end -->
								</font>
								<br />
								<xsl:apply-templates select="PREVIEWBODY" />
								<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="10" alt="" />
							</font>
						</td>
					</tr>
				</xsl:when>
			</xsl:choose>
			<tr>
				<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
			</tr>
		</table>
	</xsl:if>
	<table width="611" cellpadding="5" cellspacing="1" border="0">
<!-- IL start -->
		<form xsl:use-attribute-sets="fPOSTTHREADFORM">
<!-- IL end -->
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
<!-- IL start -->
						<xsl:if test="$test_PreviewError">
							<B>
								<xsl:apply-templates select="PREVIEWERROR"/>
							</B>
							<BR/>
						</xsl:if>
<!-- IL end -->
						<xsl:call-template name="postpremoderationmessage"/>
						<table width="580" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="320"><img src="{$imagesource}t.gif" width="320" height="1" alt="" /></td>
								<td width="10" rowspan="2"><img src="{$imagesource}t.gif" width="10" height="1" alt="" /></td>
								<td width="250"><img src="{$imagesource}t.gif" width="250" height="1" alt="" /></td>
							</tr>
							<tr>
								<td colspan="3"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><a name="reply" /><xsl:value-of select="$m_fsubject"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="612" height="4" alt="" /></td>
							</tr>
							<tr>
								<td colspan="2">
<!-- IL start -->
									<xsl:apply-templates select="." mode="HiddenInputs"/>
									<xsl:apply-templates select="." mode="Subject"/>
<!-- IL end -->
								</td>
								<td><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:call-template name="m_threadeditorhelp" /></b></font></td>
							</tr>
						</table>
					</font>
				</td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:choose><xsl:when test="@INREPLYTO=0"><xsl:value-of select="$m_fposting"/></xsl:when><xsl:otherwise><xsl:value-of select="$m_freply"/></xsl:otherwise></xsl:choose></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="1" height="4" alt="" /><br clear="all" />
					<textarea tabindex="2" cols="70" rows="15" wrap="virtual" name="body" style="width:600;"><xsl:value-of select="BODY"/></textarea>
					<img src="{$imagesource}t.gif" width="1" height="2" alt="" /><br />
					<font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:call-template name="m_enhemoticonhelp" /></font>
				</td>
			</tr>
			<tr>
				<td>
					<table width="599" cellpadding="0" cellspacing="0" border="0">
						<tr valign="top">
							<td width="99"><input tabindex="3" type="submit" name="preview" value="Preview" alt="Preview" border="0" /><!--<input type="Image" src="{$imagesource}preview_inv.gif" name="preview" value="Preview" alt="Preview" border="0" />--><br clear="all" />
								<img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
								<input type="submit" tabindex="4" name="post" value="{$alt_postmess}" border="0" /><!--<input type="Image" src="{$imagesource}publish_inv.gif" name="post" value="Publish" border="0" alt="Publish" />--><br clear="all" />
								<img src="{$imagesource}t.gif" width="1" height="5" alt="" />
							</td>
							<td width="500" align="right">
								<script type="text/javascript" language="JavaScript">
									<xsl:comment>
										drawEmoticons(checkType());
									//</xsl:comment>
								</script>
								<noscript>
									<font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:value-of select="$m_enherrornojs"/></font>
								</noscript>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="611" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
						</tr>
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td>
						</tr>
						<tr>
							<td>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
<!-- IL start -->
									<xsl:copy-of select="$m_UserEditWarning"/>
									<xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
<!-- IL end -->
								</font>
							</td>
						</tr>
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td>
						</tr>
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
		</form>
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont" class="postxt">
<!-- IL start -->
					<xsl:apply-templates select="." mode="ReturnTo"/>
<!-- IL end -->
					<br />
				</font>
			</td>
		</tr>
	</table>
	<xsl:if test="INREPLYTO">
		<table width="100%" cellpadding="0" cellspacing="6" border="0">
			<xsl:choose>
				<xsl:when test="INREPLYTO">
					<tr>
						<td colspan="2"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_postedby"/></b><xsl:apply-templates select="INREPLYTO" mode="username" /></font></td>
					</tr>
					<tr>
						<td><font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:value-of select="$m_thread_replytothismsg"/></font></td>
						<td align="right"><font xsl:use-attribute-sets="smallfont" class="postxt"><nobr><a href="#reply" class="pos"><b><xsl:value-of select="$m_jumptoreply"/></b></a></nobr></font></td>
					</tr>
					<tr>
						<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
					</tr>
					<tr>
						<td colspan="2">
							<font xsl:use-attribute-sets="textfont">
								<img src="{$imagesource}t.gif" width="1" height="10" alt="" /><br clear="all" />
								<xsl:apply-templates select="INREPLYTO/BODY"/>
								<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="10" alt="" />
							</font>
						</td>
					</tr>
				</xsl:when>
<!-- IL start -->
			</xsl:choose>
			<tr>
				<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
			</tr>
		</table>
	</xsl:if>
</xsl:template>

<!-- IL start -->
<!--xsl:template name="postpremoderationmessage">
	<xsl:choose>
		<xsl:when test="PREMODERATION[@USER=1]">
			<xsl:call-template name="m_postyouarepremoderated"/>
		</xsl:when>
		<xsl:when test="PREMODERATION=1">
			<xsl:call-template name="m_postpremodblurb"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="RETURNTO/H2G2ID">
	<A class="pos">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="."/></xsl:attribute>
		<xsl:value-of select="$m_returntoentry"/>
	</A>
</xsl:template-->
<!-- IL end -->


<xsl:template match="POSTTHREADUNREG">
<font xsl:use-attribute-sets="mainfont" class="postxt">
	<xsl:choose>
		<xsl:when test="@RESTRICTED = 1"><xsl:call-template name="m_cantpostrestricted" /></xsl:when>
		<xsl:when test="@REGISTERED = 1"><xsl:call-template name="m_cantpostnoterms" /></xsl:when>
		<xsl:otherwise><xsl:call-template name="m_cantpostnotregistered" /></xsl:otherwise>
	</xsl:choose>
</font>
	<br/><br/><br/><br/>
</xsl:template>

<xsl:template match="POSTPREMODERATED">
	<xsl:call-template name="m_posthasbeenpremoderated" />
</xsl:template>

</xsl:stylesheet>
