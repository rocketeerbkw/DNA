<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/sso.xsl"/>


	<xsl:template name="sso_statusbar">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<link rel="StyleSheet" href="{$sso_asset_root}/includes/service_statbar.css" type="text/css"/>
			<xsl:choose>
				<xsl:when test="$sso_statbar_type='normal'">
						<xsl:choose>
							<xsl:when test="$sso_username">
								<table width="359" cellpadding="0" cellspacing="0" border="0">
								<!-- One -->
								<tr class="ssoOne">
									<td width="120">
										<img src="/f/t.gif" width="220" height="1" alt=""/>
									</td>
									<td width="14">
										<img src="/f/t.gif" width="14" height="1" alt=""/>
									</td>
									<td>
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td width="23">
										<img src="/f/t.gif" width="23" height="1" alt=""/>
									</td>
									<td width="120">
										<img src="/f/t.gif" width="120" height="1" alt=""/>
									</td>
									<td width="23">
										<img src="/f/t.gif" width="23" height="1" alt=""/>
									</td>
									<td width="58">
										<img src="/f/t.gif" width="58" height="1" alt=""/>
									</td>
								</tr>
								<tr class="ssoOne">
									<td align="right" class="ssoStatusdark">
										<font size="-2"> Hello <strong> <xsl:value-of select="$sso_username"/></strong></font>
									</td>
									<td>
										<img src="/f/t.gif" width="1" height="22" alt=""/>
									</td>
									<td>
											<a href="{$sso_resources}{$sso_script}?c=notme&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO?s_return={$referrer}" class="ssoStatusdark">
									I'm not <xsl:value-of select="$sso_username"/>
											</a>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_asset_root}/images/shim.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center" class="ssoTwo">
										<!--[FIXME: remove]
										<img src="/f/t.gif" width="1" height="4" alt=""/><br/>
										-->
										<font size="-2"><strong><a class="ssoStatuslight" href="{$sso_managelink}"><img src="{$sso_asset_root}/images/buttons/retrieveMyDetails.gif" alt="Retrieve my details"/></a></strong></font>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_asset_root}/images/shim.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center">
										<font size="-2">
											<strong>
												<a href="{$sso_signoutlink}" class="ssoStatusdark">
													<img src="{$sso_asset_root}/images/buttons/signout_sb.gif" alt="Sign Out"/>
												</a>
											</strong>
										</font>
									</td>
								</tr>
								<!-- One shadow -->
								<tr>
									<td colspan="3" class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td class="ssoTwo">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
								<!-- Two -->
								<tr>
									<td colspan="7" class="ssoTwo">
										<img src="/f/t.gif" width="1" height="2" alt=""/>
									</td>
								</tr>
								<!-- Two shadow -->
								<tr>
									<td colspan="7" class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
								<!-- Three -->
								<tr>
									<td colspan="7" class="ssoThree">
										<img src="/f/t.gif" width="1" height="2" alt=""/>
									</td>
								</tr>
								</table>
							</xsl:when>
							<xsl:otherwise>
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<!--slimline unrecognised status bar here-->
								<tr>
									<td class="ssoThree" width="100" valign="bottom" rowspan="2">
										<img src="{$sso_asset_root}/images/shim.gif" width="100" height="10" alt="" border="0"/>
									</td>
									<td class="ssoThree">
										<img src="{$sso_asset_root}/images/other/stat_shim_l.gif" height="1" alt=""/>
									</td>
									<td class="ssoOne" width="1" valign="bottom" rowspan="2">
										<img src="{$sso_asset_root}/images/shim.gif" height="25" width="21" alt="" border="0"/>
									</td>
									<td class="ssoOne">
										<img src="{$sso_asset_root}/images/other/stat_shim_r.gif" height="1" alt=""/>
									</td>
									<td align="right" class="ssoOne" valign="bottom" rowspan="2">
										<img src="{$sso_asset_root}/images/shim.gif" width="10" height="1" alt="" border="0"/>
									</td>
								</tr>
								<tr>
									<td class="ssoThree">
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td nowrap="nowrap" class="ssoStatuslight">
													<font size="-1">
														<strong>New visitors:&nbsp;</strong>
													</font>
												</td>
												<td>
													<a href="{$sso_registerlink}">
														<!--[FIXME: Should be 'Create your membership]
														<img src="{$sso_assets}/images/buttons/create_membership_slim.gif" alt="Create your membership" border="0"/>
														-->
														<img src="{$sso_asset_root}/images/buttons/becomeAMember.gif" alt="Become a member" border="0"/>
													</a>
												</td>
											</tr>
										</table>
									</td>
									<td class="ssoOne">
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td class="ssoStatusdark">
													<font size="-1">
														<strong>Returning members:&nbsp;</strong>
													</font>
												</td>
												<td>
													<a href="{$signinlink}">
														<!--[FIXME: overridden]
														<img src="{$sso_assets}/images/buttons/signin_slim.gif" alt="Sign in" border="0"/>
														-->
														<img src="{$sso_asset_root}/images/buttons/signin_sb.gif" alt="Sign in" border="0"/>
													</a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								</table>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				<xsl:when test="$sso_statbar_type='kids'">
					<link rel="StyleSheet" href="{$sso_resources}/signon/sso_includes/singlesignon_kids_statbar.css" type="text/css"/>
					<xsl:choose>
						<xsl:when test="$sso_username">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr class="statbar">
									<td>
										<img src="{$sso_asset_root}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_asset_root}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>
								<!--full rec statbar content-->
								<tr class="statbar">
									<td>
										<div class="contentFullLastRow">
											<font size="3" class="ssoNormal">
												<xsl:text>Hello </xsl:text>
												<strong>
													<xsl:value-of select="$sso_username"/>
												</strong>
											</font> 
											<font size="-2">
												<a href="{$sso_resources}{$sso_script}?c=notme&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO?s_return={$referrer}" class="ssoStatusdark">If you are not <xsl:value-of select="$sso_username"/> click here</a>
											</font>
										</div>
									</td>
									<td align="right">
										<div class="contentRightLastRow">
											<a href="{$sso_managelink}">
												<img src="{$sso_asset_root}/images/buttons/mydetails_cd.gif" width="82" height="22" alt="My details" />
											</a>
											<a href="{$sso_signoutlink}">
												<img src="{$sso_asset_root}/images/buttons/signout_bg.gif" width="70" height="22" alt="" class="adjacentButton" />
											</a>
										</div>
									</td>
								</tr>
								<!--full rec statbar bottom-->
								<tr class="statbar">
									<td>
										<img src="{$sso_asset_root}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_asset_root}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<table width="100%" cellspacing="0" cellpadding="0">
							<!--full rec statbar top-->
								<tr>
									<td class="reg" colspan="2">
										<img src="{$sso_asset_root}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td rowspan="3" width="1">
										<img src="/f/t.gif" width="1" height="1" alt="" />
									</td>
									<td align="right" class="rtn" colspan="2">
										<img src="{$sso_asset_root}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>

								<!--full rec statbar content-->
								<tr>
									<td class="reg" align="right">
										<div class="contentFullLastRow">
											<font size="2" class="ssoNormal">
												<strong>New?</strong>
											</font>
										</div>
									</td>
									<td class="reg">
										<div class="contentRightLastRow">
											<a href="{$sso_registerlink}">
												<img src="{$sso_asset_root}/images/buttons/becomeamember_slim_reg.gif" alt="Become a member" />
											</a>
										</div>
									</td>
									<td class="rtn" align="right">
										<div class="contentFullLastRow">
											<font size="2" class="ssoNormal">
												<strong>Returning members:</strong>
											</font>
										</div>
									</td>
										<td class="rtn">
											<div class="contentRightLastRow">
												<a href="{$sso_signinlink}">
													<img src="{$sso_asset_root}/images/buttons/signin_slim_rtn.gif" alt="Sign in" />
												</a>
											</div>
										</td>
									</tr>
									<!--full rec statbar bottom-->
									<tr>
										<td class="reg" colspan="2">
											<img src="{$sso_asset_root}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
										</td>
										<td align="right" class="rtn" colspan="2">
											<img src="{$sso_asset_root}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
										</td>
									</tr>
								</table>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>


