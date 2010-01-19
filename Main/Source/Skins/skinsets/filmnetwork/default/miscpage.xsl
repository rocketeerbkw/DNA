<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-miscpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	LOGOUT_MAINBODY Page - Level  template
	Use: Page presented after you logout
	-->
	<xsl:template name="LOGOUT_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">LOGOUT_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge">signed out</span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
	  		<!-- head section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					<div class="biogname"><strong>signed out</strong></div>
						<img src="/f/t.gif" width="1" height="8" alt="" />
					<div class="topboxcopy">You have just signed out. The next time you visit on this computer we won't automatically recognise you.
</div> </td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="20"></td>
	  </tr>
	</table>


		<table width="371" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
				<div class="textmedium">
						<xsl:call-template name="m_logoutblurb"/>
					</div>
				</td>
			</tr>
		</table>
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="60"></td>
	  </tr>
	</table>

	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SIMPLEPAGE_MAINBODY Page - Level  template
	Use: Usually consists of a simple message / GuideML article
	-->
	<xsl:template name="SIMPLEPAGE_MAINBODY"><br />
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="textmedium">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="ARTICLE/GUIDE"/>
						<xsl:apply-templates select="ARTICLE/USERACTION" mode="t_simplepage"/> 
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NOTFOUND_MAINBODY Page - Level  template
	Use: Page presented when an incorrect URL is entered 
	-->
	<xsl:template name="NOTFOUND_MAINBODY">
	<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge">page not found</span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
	  		<!-- head section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					<div class="biogname"><strong>page not found</strong></div>
						<img src="/f/t.gif" width="1" height="8" alt="" />
					<div class="topboxcopy">Sorry, we can't find the page you're looking for. If you clicked on a link please <a class="rightcol" href="mailto:filmnetwork.support@bbc.co.uk">email us</a> and let us know. If you typed in a URL check that it's correct.
</div> </td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="20"></td>
	  </tr>
	</table>
	<!-- <table width="371" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="textmedium">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:copy-of select="$m_notfoundbody"/>
					</font>
				</td>
			</tr>
		</table> -->
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	ERROR_MAINBODY Page - Level  template
	Use: Page displayed when user makes certain errors
	-->
	<xsl:template name="ERROR_MAINBODY">
<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge"><strong>error</strong></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
	  		<!-- head section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					<div class="biogname">error</div>
						<img src="/f/t.gif" width="1" height="8" alt="" />
					<!-- <div class="topboxcopy">Sorry, we can't find the page you're looking for. If you clicked on a link please <a class="rightcol" href="mailto:filmnetwork.support@bbc.co.uk">email us</a> and let us know. If you typed in a URL check that it's correct.
</div>  --></td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="20"></td>
	  </tr>
	</table>
	<table width="371" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="textmedium">
				<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="ERROR" mode="t_errorpage"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SUBSCRIBE_MAINBODY Page - Level  template
	Use: Page displayed after user subscribes to a conversation / article
	-->
	<xsl:template name="SUBSCRIBE_MAINBODY">
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="body">
				<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="SUBSCRIBE-RESULT" mode="t_subscribepage"/>
						<br/><br/>
						<xsl:apply-templates select="RETURN-TO" mode="t_subscribepage"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SITECHANGE_MAINBODY Page - Level  template
	Use: Page displayed when user tries to leave a 'walled garden' site 
	-->
	<xsl:template name="SITECHANGE_MAINBODY">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:copy-of select="$m_sitechangemessage"/>
		</font>
	</xsl:template>


	
</xsl:stylesheet>
