<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userdetailspage.xsl"/>
	<xsl:template name="USERDETAILS_CSS">
		<link rel="StyleSheet" href="http://www.bbc.co.uk/signon/sso_includes/singlesignon.css" type="text/css"/>
		<link rel="StyleSheet" href="{$sso_assets}/includes/service.css" type="text/css"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERDETAILS_MAINBODY">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = '0'">
				<xsl:choose>
					<xsl:when test="/H2G2/USER-DETAILS-FORM/MESSAGE/@TYPE = 'detailsupdated'">
						<table width="635" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td class="ssoTwo">
									<img src="/f/t.gif" width="15" height="1" alt=""/>
								</td>
								<td class="ssoTwo">
									<table width="100%" cellpadding="0" cellspacing="0">
										<!-- Change additional details page -->
										<tr>
											<td/>
											<td colspan="6">
												<img src="/f/t.gif" width="1" height="5" alt=""/>
												<br/>
												<img src="{$sso_assets}/images/other/icon_add-details.gif" width="33" height="34" alt=""/>
												<font size="3">
												
													<xsl:text>Your </xsl:text>
													<strong>change</strong>
													<xsl:text> has been </xsl:text>
													<strong>saved</strong>
												</font>
												<br/>&nbsp;</td>
										</tr>
										<!--Top corners-->
										<tr>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_tl.gif" width="15" height="15" alt=""/>
											</td>
											<td class="ssoFormbox" colspan="5">
												<img src="/f/t.gif" width="1" height="8" alt=""/>
											</td>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_tr.gif" width="15" height="15" alt=""/>
											</td>
										</tr>
										<tr class="ssoFormbox">
											<td colspan="3">&nbsp;</td>
											<td valign="top" align="right">
												<xsl:choose>
														<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE">
															<a href="{$homepage}">
															<img src="{$sso_assets}/images/buttons/servicespecific/take_me_to_service.gif" alt="Take me to messageboard" border="0"/>
														</a>
														</xsl:when>
														<xsl:otherwise>
															<a href="{$sso_managelink}">
													<img src="{$sso_assets}/images/buttons/makemorechanges.gif" alt="Make more changes" border="0"/>
												</a>
														</xsl:otherwise>
													</xsl:choose>
											
											
											
											
												
												<br/>&nbsp;</td>
											<td colspan="3">&nbsp;</td>
										</tr>
										<tr class="ssoFormbox">
											<td colspan="3">&nbsp;</td>
											<td valign="top" align="right">
												<a href="{$homepage}">
													<img src="{$sso_assets}/images/buttons/orexit.gif" alt="Or Exit" border="0"/>
												</a>
											</td>
											<td/>
											<td valign="top">
												&nbsp;
											</td>
											<td/>
										</tr>
										<tr>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_bl.gif" width="15" height="15" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="185" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="15" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="160" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="15" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="170" height="1" alt=""/>
											</td>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_br.gif" width="15" height="15" alt=""/>
											</td>
										</tr>
										<!--/Common Footer-->
									</table>
									<!-- End content table -->
									<div align="right">
								&nbsp;
							</div>
								</td>
								<td class="ssoTwo">
									<img src="/f/t.gif" width="15" height="1" alt=""/>
								</td>
							</tr>
							<!-- Two shadow -->
							<tr>
								<td colspan="3" class="ssoStatusshadow">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
								</td>
							</tr>
							<!-- Three -->
							<tr>
								<td colspan="3" class="ssoThree">
									<img src="/f/t.gif" width="1" height="2" alt=""/>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="/H2G2/VIEWING-USER/USER/REGION/text() and /H2G2/PARAMS/PARAM[NAME='s_sync'] and /H2G2/PARAMS/PARAM[NAME='s_return']">
						<meta http-equiv="refresh" content="0;url={$root}{/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE}"/>
						<p>You are now signed into bbc.co.uk</p>
						<p>The page will automatically take you back to the messageboard, or you can use the following link</p>
						<p>
							<a href="{$root}{/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE}">Return to the messageboard</a>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<!-- Surrounding table -->
						<table width="635" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td class="ssoTwo">
									<img src="/f/t.gif" width="15" height="1" alt=""/>
								</td>
								<td class="ssoTwo">
									<table width="100%" cellpadding="0" cellspacing="0">
										<!-- Change additional details page -->
										<tr>
											<td/>
											<td colspan="6">
												<img src="/f/t.gif" width="1" height="5" alt=""/>
												<br/>
												<img src="{$sso_assets}/images/other/icon_add-details.gif" width="33" height="34" alt=""/>
												<font size="3">
													<strong>Change Your Nickname and set your Region</strong>
												</font>
												<br/>&nbsp;</td>
										</tr>
										<!--Top corners-->
										<tr>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_tl.gif" width="15" height="15" alt=""/>
											</td>
											<td class="ssoFormbox" colspan="5">
												<img src="/f/t.gif" width="1" height="8" alt=""/>
											</td>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_tr.gif" width="15" height="15" alt=""/>
											</td>
										</tr>
										<xsl:choose>
											<xsl:when test="/H2G2/USER-DETAILS-UNREG">
												<tr class="ssoFormbox">
													<td/>
													<td valign="top" align="right" colspan="3">
														<font size="3">
															<strong>
																<xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails"/>
															</strong>
														</font>
													</td>
													<td/>
													<td valign="top">&nbsp;</td>
													<td/>
												</tr>
											</xsl:when>
											<xsl:otherwise>
												<tr class="ssoFormbox">
													<td/>
													<td valign="top" align="right">
														<font size="3">
															<strong>
																<label for="fn_l">Membername</label> -</strong>
														</font>
													</td>
													<td/>
													<td valign="top">
														<xsl:value-of select="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME"/>
													</td>
													<td/>
													<td valign="top">
										&nbsp;
									</td>
													<td/>
												</tr>
												<!-- Dashed line rows -->
												<tr>
													<td colspan="7" class="ssoFormbox">
														<div class="dashedFormbox">&nbsp;</div>
													</td>
												</tr>
												<xsl:apply-templates select="USER-DETAILS-FORM" mode="c_registered"/>
											</xsl:otherwise>
										</xsl:choose>
										<!--bottom corners and colwidth control-->
										<tr>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_bl.gif" width="15" height="15" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="185" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="15" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="160" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="15" height="1" alt=""/>
											</td>
											<td class="ssoFormbox">
												<img src="/f/t.gif" width="170" height="1" alt=""/>
											</td>
											<td>
												<img src="{$sso_assets}/images/corners/fmbox_br.gif" width="15" height="15" alt=""/>
											</td>
										</tr>
										<!--/Common Footer-->
									</table>
									<!-- End content table -->
									<div align="right">
								&nbsp;
							</div>
								</td>
								<td class="ssoTwo">
									<img src="/f/t.gif" width="15" height="1" alt=""/>
								</td>
							</tr>
							<!-- Two shadow -->
							<tr>
								<td colspan="3" class="ssoStatusshadow">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
								</td>
							</tr>
							<!-- Three -->
							<tr>
								<td colspan="3" class="ssoThree">
									<img src="/f/t.gif" width="1" height="2" alt=""/>
								</td>
							</tr>
						</table>
						<!-- End surrounding table -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				identity
			</xsl:otherwise>
		</xsl:choose>
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
		<!--<xsl:apply-templates select="." mode="c_skins"/>
		<xsl:apply-templates select="." mode="c_usermode"/>
		<xsl:apply-templates select="." mode="c_forumstyle"/>
		<xsl:value-of select="$m_nickname"/>
		<xsl:apply-templates select="." mode="c_returntouserpage"/>-->
		<tr class="ssoFormbox">
			<td/>
			<td valign="top" align="right">
				<font size="3">
					<strong>
						<label for="ln_l">Nickname</label> -</strong>
				</font>
			</td>
			<td/>
			<td valign="top">
				<!--<input type="hidden" name="skin" value="purexml"/>-->
				<!--<input type="hidden" name="s_returnto" value="{$root}userdetails?s_view=success"/>-->
				<xsl:apply-templates select="." mode="t_inputusername"/>
			</td>
			<td/>
			<td valign="top">
				<div id="ln_txt">
					<font size="-2">This is the name that will appear on the messageboards.</font>
				</div>
			</td>
			<td/>
		</tr>
		<tr class="ssoFormbox">
			<td/>
			<td valign="top" align="right">
				<font size="3">
					<strong>
						<label for="ln_l">Region</label> -</strong>
				</font>
			</td>
			<td/>
			<td valign="top">
				<!--<input type="hidden" name="skin" value="purexml"/>-->
				<!--<input type="hidden" name="s_returnto" value="{$root}userdetails?s_view=success"/>-->
				<!--input name="region" value="{/H2G2/VIEWING-USER/USER/REGION}"/-->
				<select name="region" size="1">
					<option value="">Please select your region</option>
					<option/>
					<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[NAME != 'England' and NAME != 'Channel Islands']">
						<xsl:sort select="NAME" data-type="text" order="ascending"/>
						<option value="{NAME}">
							<xsl:if test="NAME = /H2G2/VIEWING-USER/USER/REGION">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="NAME"/>
						</option>
					</xsl:for-each>
				</select>
			</td>
			<td/>
			<td valign="top">
				<!--div id="ln_txt">
					<font size="-2">
						<a href="">Find out what region you are in</a>
					</font>
				</div-->
				<xsl:text> </xsl:text>
			</td>
			<td/>
		</tr>
		<!-- Dashed line rows -->
		<tr>
			<td colspan="7" class="ssoFormbox">
				<div class="dashedFormbox">&nbsp;</div>
			</td>
		</tr>
		<!-- End change addtional details page -->
		<tr class="ssoFormbox">
			<td colspan="3">&nbsp;</td>
			<td valign="top" align="right">
				<xsl:apply-templates select="." mode="t_submituserdetails"/>
				<br/>&nbsp;</td>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr class="ssoFormbox">
			<td colspan="3">&nbsp;</td>
			<td valign="top" align="right">
				<a href="{$homepage}">
					<img src="{$sso_assets}/images/buttons/orcancel.gif" alt="Or Cancel" border="0"/>
				</a>
			</td>
			<td/>
			<td valign="top">
				<div id="cancel_txt">
					<font size="-2">Only hit 'cancel', if you don't want to make any changes.</font>
				</div>
			</td>
			<td/>
		</tr>
	</xsl:template>
	<!--This is a really horrible bug fix for the need to cover the fact that the boards skin is called 'boards' but
			the site is called something else and so the default value for the prefskin hidden field is dodgy-->
	<xsl:attribute-set name="mUSER-DETAILS-FORM_c_registered_prefskin">
		<xsl:attribute name="value">england</xsl:attribute>
	</xsl:attribute-set>
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
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails">
		<xsl:attribute name="value">Save Changes</xsl:attribute>
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="$sso_assets"/>/images/buttons/savechanges_1.gif</xsl:attribute>
		<xsl:attribute name="id">button</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="alt">Save my changes</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
