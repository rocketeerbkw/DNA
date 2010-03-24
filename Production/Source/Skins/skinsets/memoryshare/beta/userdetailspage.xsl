<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">
	<xsl:import href="../../../base/base-userdetailspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERDETAILS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Your preferences</xsl:text>
			</xsl:with-param>
			<xsl:with-param name="rsstype">SEARCH</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="USERDETAILS_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">USERDETAILS_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">userdetailspage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<!--[FIXME: remove]
		<h3>Preferences</h3>
		<xsl:call-template name="SEARCH_RSS_FEED"/>
		-->

		<div id="ms-preferences">
			<div id="ms-pref-header"><xsl:comment> ms-pref-header </xsl:comment></div>
			<div id="ms-pref-content">
				<h2>Preferences</h2>
				<!--p>
					This is an introduction to changing your preferences. It spans 12 columns and is
					intended 26px from left and right. This is an introduction to adding your own memories.
					It spans 12 columns and is intended 26px from left and right.
				</p-->
				<div id="ms-preferences-inner">
					<div id="ms-pref-inner-header"><xsl:comment> ms-pref-inner-header </xsl:comment></div>

					<xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails" />
					<xsl:apply-templates select="USER-DETAILS-FORM" mode="c_registered" />

					<div class="std-ruler" id="pref-newsletters">
						<hr />
						<xsl:call-template name="SUBSCRIBE_NEWSLETTERFORM">
							<xsl:with-param name="useDefaults">yes</xsl:with-param>
							<xsl:with-param name="hostOverride">yes</xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="UNSUBSCRIBE_NEWSLETTERFORM">
							<xsl:with-param name="useDefaults">yes</xsl:with-param>
							<xsl:with-param name="hostOverride">yes</xsl:with-param>
						</xsl:call-template>
						<div class="clearer"><xsl:comment> clearer </xsl:comment></div>
					</div>						
					<div id="ms-pref-inner-footer"><xsl:comment> ms-pref-inner-footer </xsl:comment></div>
				</div>
			</div>
			<div id="ms-pref-footer"><xsl:comment> ms-pref-footer </xsl:comment></div>
		</div>
		<!--xsl:call-template name="SEARCH_RSS_FEED"/-->
	</xsl:template>	<!-- override from base -->

	<xsl:template match="USER-DETAILS-FORM" mode="c_registered">
		<xsl:choose>
			<xsl:when test="$restricted = 0">
				<form method="get" action="{$root}UserDetails" xsl:use-attribute-sets="fUSER-DETAILS-FORM_c_registered" id="contactMeForm">
					<xsl:comment> Steve - this DIV is only here to make the page valid XHTML, can just hide it once CSS is sorted </xsl:comment>
					<div>
						<input name="cmd" type="hidden" value="submit"/>
						<input type="hidden" name="PrefSkin" xsl:use-attribute-sets="mUSER-DETAILS-FORM_c_registered_prefskin"/>
						<!--[FIXME: do we need this?]
						<input type="hidden" name="Username" value="{PREFERENCES/USERNAME}"/>
						-->
						<!--[used for optin radios]
						<input type="hidden" name="PrefUserMode" value="{PREFERENCES/USER-MODE}"/>
						-->
						<input type="hidden" name="PrefForumStyle" value="{PREFERENCES/FORUM-STYLE}"/>
						<input name="OldEmail" type="hidden" value="{EMAIL-ADDRESS}"/>
						<input name="NewEmail" type="hidden" value="{EMAIL-ADDRESS}"/>
						<input type="hidden" name="Password"/>
						<input type="hidden" name="NewPassword"/>
						<input type="hidden" name="PasswordConfirm"/>

						<input type="hidden" name="s_saved" value="1"/>
					</div>
					<xsl:apply-templates select="." mode="normal_registered"/>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="restricted_registered"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="m_unregprefsmessage">
		<div id="pref-main">
			<h2>You're not logged in</h2>
			<p>
				Please <a href="{$sso_signinlink}" title="sign in">log in</a> to change your nickname.
			</p>
		</div>
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
		<div id="pref-main">
			<h2><xsl:value-of select="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME"/></h2>
			<p>
				From time to time, we contact people who send in memories and ask them to participate in radio or TV programmes. If you are happy to be contacted for such purposes please select the option below. We will not contact you unnecessarily, and will not pass your email address to others outside the BBC.
			</p>
			<p class="pref-form-inputs">
				<input type="radio" class="radio" name="PrefUserMode" id="contactMe" value="1">
					<xsl:if test="/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE/text() = 1">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label for="contactMe">
					I am happy to be contacted by BBC journalists about my memories at my email address <xsl:value-of select="/H2G2/USER-DETAILS-FORM/EMAIL-ADDRESS"/>
				</label>
			</p>
			<p class="pref-form-inputs">
				<input type="radio" class="radio" name="PrefUserMode" id="doNotContact" value="0">
					<xsl:if test="/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE/text() = 0">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label for="doNotContact">I do not want to be contacted by BBC journalists about my memories.</label>
			</p>
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
					<h3>Your nickname</h3>
					<p>Your nickname will appear next to your memory. It doesn't have to be unique, but you should try to ensure that your name is recognisable as your own, to avoid the confusion that would arise from having two people posting with the same name. It's a good idea to change it if you want to stand out from the crowd - but it's totally up to you.</p>
					<p class="pref-form-inputs">
						<xsl:apply-templates select="." mode="t_inputusername"/>
					</p>
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_saved']">
						<div class="formRow">
							<strong>Your changes have been saved.</strong>
						</div>
					</xsl:if>
					<p class="pref-form-inputs">
						<!--input type="submit" class="submit" value="Submit" name="submit"/-->
						<input type="image" src="/memoryshare/assets/images/save-preferences-button.png" name="save_preferences" id="submit" />
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p class="pref-form-inputs">
						<!--input type="submit" class="submit" value="Submit" name="submit"/-->
						<input type="image" src="/memoryshare/assets/images/save-preferences-button.png" name="save_preferences" id="submit" />
					</p>				
					<h3>Your email</h3>
				</xsl:otherwise>
			</xsl:choose>
			<p>
				The email address you have provided is <strong>
					<xsl:value-of select="/H2G2/USER-DETAILS-FORM/EMAIL-ADDRESS"/>
				</strong><br/>
				To amend this please go to <a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
							<xsl:value-of select="$sso_managelink" />
						</xsl:when>	
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER">
									<xsl:value-of select="$id_settingslink" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$id_morelink" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>	
					</xsl:choose>
				</xsl:attribute>
				settings</a>.
			</p>
		</div>
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
		<!--[FIXME: remove]
		<xsl:apply-templates select="." mode="t_usermodelist"/>
		-->
		
		<label for="optinY" class="radioLabel">Yes</label>
		<input type="radio" name="PrefUserMode" id="optinY" value="1">
			<xsl:if test="/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE/text() = 1">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
		<label for="optinN" class="radioLabel">No</label>
		<input type="radio" name="PrefUserMode" id="optinN" value="0">
			<xsl:if test="/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE/text() = 0">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
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
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER-DETAILS-FORM_r_returntouserpage">
			&lt;&lt; Back to Your memories
		</a>
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
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername">
		<xsl:attribute name="id">nickname</xsl:attribute>
		<xsl:attribute name="name">Username</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="USERNAME"/></xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
	Use: Extra presentation attributes for the user details form submit button
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>

	<xsl:template match="USER-DETAILS-FORM" mode="t_inputusername">
		<xsl:choose>
			<xsl:when test="$premoderated = 1">
				<xsl:value-of select="USERNAME"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="text" name="Username" class="txt" xsl:use-attribute-sets="iUSER-DETAILS-FORM_t_inputusername"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
