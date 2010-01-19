<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userdetailspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERDETAILS_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USERDETAILS_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">userdetailspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<font xsl:use-attribute-sets="mainfont">
	
	<xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails"/>
			
	<xsl:choose>
		<!-- USER SELECTED 'ADD BIOG' FORM BUTTON-->
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_next_page']/VALUE = 'add_biog'">
			<meta http-equiv="REFRESH"><xsl:attribute name="content">0;url=<xsl:value-of select="$root"/>U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>?s_next_page=add_biog</xsl:attribute></meta>
			
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
						<div class="whattodotitle"><strong>Please wait while your profile page is created.</strong></div>
						<div class="topboxcopy"><strong><A class="rightcol" href="url={$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_next_page=add_biog">Click here</A></strong> if nothing happens after a few seconds.</div> </td>
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
		</xsl:when>
		
		<!-- USER SELECTED 'LEAVE, GO TO PROFILE' BUTTON-->
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_next_page']/VALUE = 'my_profile'">	
			<meta http-equiv="REFRESH"><xsl:attribute name="content">0;url=<xsl:value-of select="$root"/>U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/></xsl:attribute></meta>
			
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
						<div class="whattodotitle"><strong>Please wait while your profile page is created.</strong></div>
						<div class="topboxcopy"><strong><A class="rightcol" href="url={$root}U{/H2G2/VIEWING-USER/USER/USERID}">Click here</A></strong> if nothing happens after a few seconds.</div> </td>
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
		
		</xsl:when>
		
		<xsl:otherwise>
			<table width="635" border="0" cellspacing="0" cellpadding="0" class="submistablebg topmargin">
		        <tr> 
		          <td colspan="3" width="635" valign="bottom"><img src="{$imagesource}furniture/submission/submissiontop.gif" width="635" height="57" alt="" class="tiny" /></td>
		        </tr>
		        <tr> 
		          <td width="88" valign="top" class="subleftcolbg"><img src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88" height="29" alt="" /></td>
		          <td width="459" valign="top"> 
		            <!-- steps -->
		            <table border="0" cellspacing="0" cellpadding="0" class="steps4">
		            <tr><td class="currentStep">&nbsp;</td></tr>
		            </table>
		            
					<h1 class="image"><img src="{$imagesource}furniture/title_welcome_to_fn.gif" width="459" height="29" alt="welcome to Film Network" /></h1>
					<p class="textmedium">As a member, you now have your own profile page where you can keep a list of your favourite films on Film Network, track discussions you take part in and receive messages from other members.</p>
					
					<p class="textmedium">If you are involved in making films, in any capacity (e.g. director, cast, crew), we recommend that you add the following elements to your profile page (you don't have to fill it all in now):</p>
					
					<ul class="textmedium">
						<li>a filmmaking biography</li>
						<li>credit pages, listing projects you've worked on</li>
						<li>a specialism and place, which will include you in our people directory</li>
					</ul>
					
					<p class="textmedium">If you have a film screening on Film Network, we recommend you do this as it allows people who see your film to find out more about you.</p> 
		
			      	<div class="formBtnLink">
						<form method="post" action="{$root}UserDetails" xsl:use-attribute-sets="fUSER-DETAILS-FORM_c_registered">
							<input type="hidden" name="cmd" value="submit"/>
							<input type="hidden" name="PrefSkin" xsl:use-attribute-sets="mUSER-DETAILS-FORM_c_registered_prefskin"/>
							<input type="hidden" name="OldEmail" value="{USER-DETAILS-FORM/EMAIL-ADDRESS}"/>
							<input type="hidden" name="NewEmail" value="{USER-DETAILS-FORM/EMAIL-ADDRESS}"/>
							<input type="hidden" name="Password"/>
							<input type="hidden" name="NewPassword"/>
							<input type="hidden" name="PasswordConfirm"/>
							<input type="hidden" name="Username" xsl:use-attribute-sets="iUSER-DETAILS-FORM_t_inputusername"/>
							<input type="hidden" name="PrefUserMode" value="0"/>
							<input type="hidden" name="s_next_page" value="add_biog"/>
							<input type="image" name="submit" src="{$imagesource}furniture/btnlink_add_biog.gif" width="452" height="14" alt="add biog, credits and specialism to my profile page" border="0" />						
						</form>
						
						<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_upgradeuser']/VALUE = '1'">
							<!-- user has come from userprofile page so is a mode=1-->
							<a href="{root}U{/H2G2/VIEWING-USER/USER/USERID}"><img src="{$imagesource}furniture/btnlink_leave.gif" width="334" height="14" alt="leave and take me to my profile page" id="btn_publisgNotes" /></a>
						</xsl:when>
						<xsl:otherwise>
							<!-- user is starting the registration process so is mode=0 so they need to change to a mode=1 -->
							<form method="post" action="{$root}UserDetails" xsl:use-attribute-sets="fUSER-DETAILS-FORM_c_registered">
							<input type="hidden" name="cmd" value="submit"/>
							<input type="hidden" name="PrefSkin" xsl:use-attribute-sets="mUSER-DETAILS-FORM_c_registered_prefskin"/>
							<input type="hidden" name="OldEmail" value="{USER-DETAILS-FORM/EMAIL-ADDRESS}"/>
							<input type="hidden" name="NewEmail" value="{USER-DETAILS-FORM/EMAIL-ADDRESS}"/>
							<input type="hidden" name="Password"/>
							<input type="hidden" name="NewPassword"/>
							<input type="hidden" name="PasswordConfirm"/>
							<input type="hidden" name="Username" xsl:use-attribute-sets="iUSER-DETAILS-FORM_t_inputusername"/>
							<input type="hidden" name="PrefUserMode" value="1"/>
							<input type="hidden" name="s_next_page" value="my_profile"/>
							<input type="image" name="submit" src="{$imagesource}furniture/btnlink_leave.gif" width="334" height="14" alt="leave and take me to my profile page" id="btn_publisgNotes" />						
							</form>
						</xsl:otherwise>	
					</xsl:choose>
					</div>
				</td>
		          <td width="88" valign="top"  class="subrightcolbg"><img src="/f/t.gif" class="tiny" width="88" height="30" alt="" /></td>
		        </tr>
		        <tr> 
		          <td height="10" class="subrowbotbg"></td>
		          <td class="subrowbotbg"></td>
		          <td class="subrowbotbg"></td>
		        </tr>
		      </table>
			
		</xsl:otherwise>
	</xsl:choose>
			
	</font>
					
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-UNREG" mode="r_userdetails">
	Use: Presentation of the user details form if the viewer is unregistered
	-->
	<xsl:template match="USER-DETAILS-UNREG" mode="r_userdetails">
		<xsl:apply-templates select="MESSAGE"/>
		<xsl:call-template name="m_unregprefsmessage"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="normal_registered">
	Use: Presentation of the user details form
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="normal_registered">
		
<!-- 		<strong>site suffix: </strong>
		<INPUT type="text" name="sitesuffix" value="{PREFERENCES/SITESUFFIX}"/><br/> -->
		<xsl:value-of select="$m_nickname"/>
		<xsl:apply-templates select="." mode="t_inputusername"/>
		<br/>
		<xsl:apply-templates select="." mode="c_skins"/>
		<xsl:apply-templates select="." mode="c_usermode"/>
		<xsl:apply-templates select="." mode="c_forumstyle"/>
		<xsl:apply-templates select="." mode="t_submituserdetails"/>
		<br/>
		<xsl:apply-templates select="." mode="c_returntouserpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">
	Use: Presentation for choosing the skins
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">
		<xsl:value-of select="$m_skin"/>
		<xsl:apply-templates select="." mode="t_skinlist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
	Use: Presentation of the user mode drop down
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
		<xsl:value-of select="$m_usermode"/>
		<xsl:apply-templates select="." mode="t_usermodelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
	Use: Presentation of the forum style dropdown
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
		<xsl:value-of select="$m_forumstyle"/>
		<xsl:apply-templates select="." mode="t_forumstylelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
	Use: Presentation if the viewer is a restricted user
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
		<xsl:call-template name="m_restricteduserpreferencesmessage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
	Use: Links back to the user page
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	Use: Extra presentation attributes for the user details form <form> element
	-->
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername"/>
	Use: Extra presentation attributes for the input screen name input box
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername"/>
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
	Use: Extra presentation attributes for the user details form submit button
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails" />
</xsl:stylesheet>