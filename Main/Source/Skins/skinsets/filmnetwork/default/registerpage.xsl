<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-registerpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="NEWREGISTER_MAINBODY">
<!-- 	first time = <xsl:value-of select="/H2G2/NEWREGISTER/FIRSTTIME" /> -->
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">NEWREGISTER_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">registerpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<br />
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="NEWREGISTER" mode="c_page"/>
		</font>
	</xsl:template>
	
	
	<!--
	<xsl:template match="NEWREGISTER" mode="postcode_page">
	Use: Page for inserting a user's postcode
	 -->
	<xsl:template match="NEWREGISTER" mode="postcode_page">
		<xsl:apply-templates select="POSTCODE" mode="c_insertpostcode"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTCODE" mode="r_insertpostcode">
	Use: Incorrect postcode message
	 -->
	<xsl:template match="POSTCODE" mode="r_insertpostcode">
		<b>Please enter your postcode:</b>
		<xsl:apply-templates select="BADPOSTCODE" mode="c_error"/>
		<br/>
		<xsl:apply-templates select="." mode="t_postcodeinput"/>
		<xsl:apply-templates select="." mode="t_postcodesubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="BADPOSTCODE" mode="r_error">
	Use: Page that redirects the viewer's userpage
	 -->
	<xsl:template match="BADPOSTCODE" mode="r_error">
		You entered an incorrect postcode, please try again:
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="welcomeback_page">
	Use: Page that redirects the viewer's userpage
	 -->
	<xsl:template match="NEWREGISTER" mode="welcomeback_page">
	 <xsl:apply-templates select="." mode="t_metaredirectuserpage"/> 
		<xsl:copy-of select="$m_regwaittransfer"/> 
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="welcome_page">
	Updated: Alisatir
	Use: Page that redirects to the 'welcome to film network page' where a user can choose what tyoe of user they are
	 -->
	 <xsl:template match="NEWREGISTER" mode="welcome_page">
	 <meta http-equiv="refresh" content="0;url={$root}UserDetails"/>
	 
	 	<!-- incase meta refresh does not work -->
		<table width="371" border="0" cellspacing="0" cellpadding="5">
		<tr>
		<td height="10"></td></tr>
		</table>
		<table width="635" border="0" cellspacing="0" cellpadding="0">
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
					<div class="whattodotitle"><strong>Please wait while we complete your membership.</strong></div>
					<div class="topboxcopy"><strong><A class="rightcol" href="url={$root}UserDetails">Click here</A></strong> if nothing happens after a few seconds.</div> </td>
				</tr>
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
	</xsl:template>
	 
	<!--
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
	Use: Displayed as the interim page between Single Sign on and whatever it was the user 
	was doing before single sign on       
	 -->
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
				

		<!-- <xsl:apply-templates select="." mode="t_passthroughmessage"/> -->
		<!-- <xsl:call-template name="m_passthroughwelcomeback"/>
		<xsl:call-template name="m_passthroughnewuser"/> -->
		
		<xsl:choose>
			<xsl:when test="FIRSTTIME=0">
				<xsl:apply-templates select="REGISTER-PASSTHROUGH" mode="c_pagetype"/>
			</xsl:when>
			<xsl:otherwise>
			<!--  takes them to the start of the registration process -->
			 <meta http-equiv="refresh" content="0;url={$root}UserDetails"/>
			</xsl:otherwise>
		</xsl:choose> 
		
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to addthread page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	
		 	<!-- incase meta refresh does not work -->
		<table width="371" border="0" cellspacing="0" cellpadding="5">
		<tr>
		<td height="10"></td></tr>
		</table>
		<table width="635" border="0" cellspacing="0" cellpadding="0">
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
					
	
		<xsl:choose>
			<xsl:when test="PARAM[@NAME='forumtype']='gb'">
			
			<meta http-equiv="refresh" content="0;url={$root}AddThread?inreplyto={PARAM[@NAME='post']}&amp;action=A{PARAM[@NAME='article']}"/>
					<div class="whattodotitle"><strong><a href="{$root}AddThread?inreplyto={PARAM[@NAME='post']}&amp;action=A{PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:copy-of select="$m_ptclicktoleaveguestbookmessage"/>
				</a></strong></div>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='forumtype']='pm'">
			<meta http-equiv="refresh" content="0;url={$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}"/>
				<div class="whattodotitle"><strong><a href="{$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:copy-of select="$m_ptclicktoleaveprivatemessage"/>
				</a></strong></div>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='article']">
		<meta http-equiv="refresh" content="0;url={$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}"/>
				<div class="whattodotitle"><strong><a href="{$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktostartnewconv"/>
				</a></strong></div>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='post']=0">
			<meta http-equiv="refresh" content="0;url={$root}AddThread?forum={PARAM[@NAME='forum']}"/>
				<div class="whattodotitle"><strong><a href="{$root}AddThread?forum={PARAM[@NAME='forum']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktostartnewconv"/>
				</a></strong></div>
			</xsl:when>
			<xsl:otherwise>
			<meta http-equiv="refresh" content="0;url={$root}AddThread?inreplyto={PARAM[@NAME='post']}"/>
				<div class="whattodotitle"><strong><a href="{$root}AddThread?inreplyto={PARAM[@NAME='post']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktowritereply"/>
				</a></strong></div>
				</xsl:otherwise>
		</xsl:choose>
		</td>
				</tr>
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
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to create an article page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="createarticle_pagetype">
	<!-- incase meta refresh does not work -->
		<table width="371" border="0" cellspacing="0" cellpadding="5">
		<tr>
		<td height="10"></td></tr>
		</table>
		<table width="635" border="0" cellspacing="0" cellpadding="0">
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
	<div class="whattodotitle"><strong>Taking you back to your submission</strong></div>
		<meta http-equiv="refresh" content="0;url={$root}TypedArticle?acreate=new&amp;_msxml={$createtype}&amp;type={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='type']}"/>
		</td>
				</tr>
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
	</xsl:template>
		<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="articlepoll_pagetype">
	Use: Provides link back to add notice page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="articlepoll_pagetype">
	<!-- incase meta refresh does not work -->
		<table width="371" border="0" cellspacing="0" cellpadding="5">
		<tr>
		<td height="10"></td></tr>
		</table>
		<table width="635" border="0" cellspacing="0" cellpadding="0">
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
	<div class="whattodotitle"><strong>Returning you to the rating page</strong></div>
		<meta http-equiv="refresh" content="0;url={$root}A{/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='dnaid']}"/>
			</td>
				</tr>
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
	</xsl:template>
	
</xsl:stylesheet>
