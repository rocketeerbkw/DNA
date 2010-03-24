<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<!-- IL start -->
<xsl:attribute-set name="iNEWREGISTER_InputLoginName1" use-attribute-sets="iNEWREGISTER_InputLoginName">
	<xsl:attribute name="size">27</xsl:attribute>
	<xsl:attribute name="style">width:200px;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_InputLoginNameFT" use-attribute-sets="iNEWREGISTER_InputLoginName">
	<xsl:attribute name="size">30</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_Password1" use-attribute-sets="iNEWREGISTER_Password">
	<xsl:attribute name="size">27</xsl:attribute>
	<xsl:attribute name="style">width:200px;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_PasswordFT" use-attribute-sets="iNEWREGISTER_Password">
	<xsl:attribute name="size">30</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_Password21" use-attribute-sets="iNEWREGISTER_Password2">
	<xsl:attribute name="size">27</xsl:attribute>
	<xsl:attribute name="style">width:200px;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_Email1" use-attribute-sets="iNEWREGISTER_Email">
	<xsl:attribute name="size">27</xsl:attribute>
	<xsl:attribute name="style">width:200px;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_Register1" use-attribute-sets="iNEWREGISTER_Register">
<!--
	<xsl:attribute name="type">Image</xsl:attribute>
	<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>sign_in_red.gif</xsl:attribute>
	<xsl:attribute name="alt">Sign-In</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
-->
</xsl:attribute-set>

<xsl:attribute-set name="iNEWREGISTER_Login1" use-attribute-sets="iNEWREGISTER_Login">
<!--
	<xsl:attribute name="type">Image</xsl:attribute>
	<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>proceed_red.gif</xsl:attribute>
	<xsl:attribute name="alt">Proceed</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
-->
</xsl:attribute-set>

<xsl:attribute-set name="as_m_noconnectionerror">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>
<!-- IL end -->

<xsl:template name="NEWREGISTER_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_logintitle"/></title>
</xsl:template>

<xsl:template name="NEWREGISTER_BAR">
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
							<xsl:when test="/H2G2/NEWREGISTER/@COMMAND='fasttrack'"><font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:call-template name="m_login_noaccnt"/></b></font></xsl:when>
							<xsl:otherwise><font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:call-template name="m_login_accnt"/></b></font></xsl:otherwise>
						</xsl:choose>	
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="NEWREGISTER_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">
			<xsl:choose>
				<xsl:when test="/H2G2/NEWREGISTER/@COMMAND='fasttrack'"><xsl:value-of select="$m_loginhead"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$m_registrationsubject"/></xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="NEWREGISTER_MAINBODY">
	<xsl:choose>
		<xsl:when test="NEWREGISTER[@STATUS='ASSOCIATED']|NEWREGISTER[@STATUS='LOGGEDIN']">
			<xsl:choose>
				<xsl:when test="NEWREGISTER/REGISTER-PASSTHROUGH">
				<xsl:choose>
					<xsl:when test="NEWREGISTER/FIRSTTIME=0">
						<table cellspacing="10" cellpadding="0" border="0"><tr><td><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_welcome"/></font><br/></td></tr></table>
					</xsl:when>
					<xsl:otherwise>
						<table cellspacing="10" cellpadding="0" border="0"><tr><td><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_welcomenew"/></font><br/></td></tr></table>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="NEWREGISTER/REGISTER-PASSTHROUGH" mode="completed"/>
				</xsl:when>
				<xsl:when test="NEWREGISTER[FIRSTTIME=0]">
					<meta http-equiv="REFRESH"><xsl:attribute name="content">0;url=U<xsl:value-of select="NEWREGISTER/USERID"/></xsl:attribute></meta>
					<table cellspacing="10" cellpadding="0" border="0"><tr><td><font xsl:use-attribute-sets="mainfont"><xsl:call-template name="m_regwaittransfer"/></font><br/></td></tr></table>
				</xsl:when>
				<xsl:otherwise>
					<meta http-equiv="REFRESH"><xsl:attribute name="content">0;url=Welcome</xsl:attribute></meta>
					<table cellspacing="10" cellpadding="0" border="0"><tr><td><font xsl:use-attribute-sets="mainfont"><xsl:call-template name="m_regwaitwelcomepage"/></font><br/></td></tr></table>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$test_registererror">
			<xsl:copy-of select="$m_registernouser"/>
		</xsl:when>
		<xsl:otherwise>
			 <!--xsl:apply-templates select="NEWREGISTER"/-->
			 <xsl:choose>
				<xsl:when test="NEWREGISTER[@COMMAND='normal']">
					<xsl:copy-of select="$m_dnaregistertext"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$m_dnasignintext"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- IL start -->
<xsl:template match="NEWREGISTER[@COMMAND='normal']">
	<table width="100%" cellspacing="0" cellpadding="4" border="0">
		<tr>
			<td align="left">
				<form xsl:use-attribute-sets="fNEWREGISTER">
					<xsl:call-template name="retain_register_details_HI"/>
					<xsl:apply-templates select="." mode="HiddenInputsNormal"/>
					<xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
					<table width="100%" cellspacing="10" cellpadding="0" border="0">
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td><font xsl:use-attribute-sets="mainfont" color="#33ff00"><b><xsl:call-template name="register-mainerror"/></b></font></td>
						</tr>
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
					<table width="100%" cellspacing="10" cellpadding="0" border="0">
						<tr>
							<td width="20"><img src="{$imagesource}t.gif" width="20" height="1" alt="" /></td>
							<td width="140"><img src="{$imagesource}t.gif" width="140" height="1" alt="" /></td>
							<td width="100%"><img src="{$imagesource}t.gif" width="420" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="subheaderfont"><b>1.</b></font></td>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_a"/></font></td>
						</tr>
						<tr>
							<td rowspan="4"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_atitle"/></b></font> </td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_InputLoginName1"/></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2" background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="subheaderfont"><b>2.</b></font></td>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_b"/></font></td>
						</tr>
						<tr>
							<td rowspan="4"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_btitle"/></b></font> </td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_Password1"/></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2" background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="subheaderfont"><b>3.</b></font></td>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_c"/></font></td>
						</tr>
						<tr>
							<td rowspan="4"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_ctitle"/></b></font> </td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_Password21"/></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2" background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="subheaderfont"><b>4.</b></font></td>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_d"/></font></td>
						</tr>
						<tr>
							<td rowspan="4"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_dtitle"/></b></font> </td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_Email1"/></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2" background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="subheaderfont"><b>5.</b></font></td>
							<td colspan="2">
							<input xsl:use-attribute-sets="iNEWREGISTER_Terms">
								<xsl:call-template name="check_terms_box"/>
							</input>
							<font xsl:use-attribute-sets="mainfont"> <xsl:call-template name="m_agreetoterms"/><br />
						<input xsl:use-attribute-sets="iNEWREGISTER_Remember"/><xsl:value-of select="$m_login_e"/></font></td>
						</tr>
						<tr>
							<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="20" alt="" /></td>
						</tr>
						<tr>
							<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
							<td colspan="2"><input xsl:use-attribute-sets="iNEWREGISTER_Register1"/>
<!-- CANCEL BUTTON????-->							
							<!-- <img src="{$imagesource}t.gif" width="15" height="1" alt="" /><input type="Image" src="{$imagesource}cancel_red.gif" alt="Cancel" border="0" /> -->
							</td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="30" alt="" /></td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="NEWREGISTER[@COMMAND='fasttrack']">
	<table width="100%" cellspacing="0" cellpadding="4" border="0">
		<tr>
			<td align="left">
				<form method="POST" action="{$bbcregscript}">
					<xsl:apply-templates select="." mode="HiddenInputsFasttrack"/>
					<xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
					<table width="100%" cellspacing="10" cellpadding="0" border="0">
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td><font xsl:use-attribute-sets="mainfont" color="#33ff00"><b><xsl:call-template name="register-mainerror"/></b></font></td>
						</tr>
						<tr>
							<td><font xsl:use-attribute-sets="mainfont"><xsl:call-template name="m_bbcloginblurb"/></font></td>
						</tr>
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
					<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
					<table width="380" cellspacing="10" cellpadding="0" border="0">
						<tr>
							<td width="80"><img src="{$imagesource}t.gif" width="80" height="1" alt="" /></td>
							<td width="300"><img src="{$imagesource}t.gif" width="300" height="1" alt="" /></td>
						</tr>
						<tr>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_username"/></b></font></td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_InputLoginNameFT"/></td>
						</tr>
						<tr>
							<td><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_login_password"/></b></font></td>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_PasswordFT"/></td>
						</tr>
						<tr>
							<td rowspan="7"><img src="{$imagesource}t.gif" width="80" height="1" alt="" /></td>
							<td><font xsl:use-attribute-sets="smallfont"><a href="{$root}UserDetails?unregcmd=yes" class="norm"><xsl:value-of select="$m_login_forgotpwd"/></a></font></td>
						</tr>
						<tr>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_Remember"/><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_login_e"/></font></td>
						</tr>
						<xsl:if test="@STATUS='NOTERMS'">
							<tr>
								<td><INPUT TYPE="CHECKBOX" NAME="terms" VALUE="1"/><xsl:text> </xsl:text><font xsl:use-attribute-sets="mainfont"><b><xsl:call-template name="m_agreetoterms"/></b></font></td>
							</tr>
						</xsl:if>
<!-- Not Used yet	 - do later!!!!
						<tr>
							<td><font xsl:use-attribute-sets="mainfont"><b>After Login/Registration proceed to:</b></font></td>
						</tr>
						<tr>
							<td background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td><input type="Radio" name="next" /><font xsl:use-attribute-sets="mainfont"> Add Entry</font><br />
								<input type="Radio" name="next" /><font xsl:use-attribute-sets="mainfont"> Reply to <a href="#" class="norm">Conversation</a></font><br />
								<input type="Radio" name="next" /><font xsl:use-attribute-sets="mainfont"> Personal Space</font>
							</td>
						</tr> -->
						<tr>
							<td background="{$imagesource}dotted_line_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
						</tr>
						<tr>
							<td><input xsl:use-attribute-sets="iNEWREGISTER_Login1"/></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="30" alt="" /></td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
</xsl:template>
<!-- IL end -->

<xsl:template match="NEWREGISTER[@COMMAND='returning']">
	<table width="100%" cellspacing="0" cellpadding="4" border="0">
		<tr>
			<td align="left">
<font xsl:use-attribute-sets="mainfont">
<xsl:call-template name="m_returninguserblurb"/>
		 <font color="red">
		 <xsl:call-template name="register-mainerror"/>
		 </font>
		 <br/>
<FORM METHOD="POST" ACTION="{$bbcregscript}">
<INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
<INPUT TYPE="HIDDEN" NAME="cmd" VALUE="returning"/>
<xsl:apply-templates select="REGISTER-PASSTHROUGH"/>
<TABLE BORDER="0">
<TR>
<TD><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_loginname"/></b></font></TD><TD><INPUT TYPE="TEXT" NAME="loginname" VALUE="{LOGINNAME}"/></TD>
</TR>
<TR>
<TD><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_bbcpassword"/></b></font></TD><TD><INPUT TYPE="password" NAME="password"/></TD>
</TR>
<TR>
<TD><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_confirmbbcpassword"/></b></font></TD><TD><INPUT TYPE="password" NAME="password2"/></TD>
</TR>
<TR><TD COLSPAN="2"><HR/>
		 <font color="red">
		 <xsl:call-template name="register-associateerror"/>
</font>
<br/>
</TD></TR>
<TR>
<TD><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_emailaddr"/></b></font></TD><TD><INPUT TYPE="TEXT" NAME="email" VALUE="{EMAIL}"/></TD>
</TR>
<TR>
<TD><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_h2g2password"/></b></font></TD><TD><INPUT TYPE="PASSWORD" NAME="h2g2password"/></TD>
</TR>
<TR>
<TD></TD><TD><INPUT TYPE="CHECKBOX" NAME="remember" VALUE="1"/><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_alwaysremember"/></b></font></TD>
</TR>
<TR><TD COLSPAN="2">
					<font xsl:use-attribute-sets="mainfont"><b><FONT SIZE="2"><xsl:call-template name="m_terms"/></FONT></b></font>
</TD></TR>
<TR>
<TD></TD><TD><INPUT TYPE="CHECKBOX" NAME="terms" VALUE="1"/><xsl:text> </xsl:text><font xsl:use-attribute-sets="mainfont"><b><xsl:call-template name="m_agreetoterms"/></b></font></TD>
</TR>
<TR>
<TD></TD><TD><INPUT TYPE="SUBMIT" NAME="submit" VALUE="{$m_newreactivatebutton}"/></TD>
</TR>
</TABLE>
</FORM>
</font>
</td>
</tr>
</table>
</xsl:template>


</xsl:stylesheet>