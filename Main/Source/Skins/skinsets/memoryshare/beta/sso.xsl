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
	<xsl:import href="../../../base/sso.xsl"/>

	<!-- Magnetic North - override signin/signout links to take you back to where you were (without an extra roundtrip) -->
	<xsl:variable name="sso_signinlink" select="concat($sso_resources, $sso_script, '?c=login&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root, $referrer)"/>
	<xsl:variable name="sso_signoutlink" select="concat($sso_resources, $sso_script, '?c=signout&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root, $referrer)"/>

	<xsl:variable name="idURL">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = 'NARTHUR5' or (not(contains(/H2G2/SERVERNAME, 'NARTHUR')) and not(contains(/H2G2/SERVERNAME, 'NMSDNA0')))">
				<xsl:text>https://id.stage.bbc.co.uk/</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>https://id.bbc.co.uk/</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="id_ptrt">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = 'PC-S052330'">
				<xsl:text>http%3A%2F%2Fops-dev14.national.core.bbc.co.uk%3A6666</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = 'OPS-DNA1'">
				<xsl:text>http%3A%2F%2Fdnarelease.national.core.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = 'NMSDNA0'">
				<xsl:text>http%3A%2F%2Fwww.stage.bbc.co.uk</xsl:text>
			</xsl:when>	
			<xsl:when test="/H2G2/SERVERNAME = 'NARTHUR5'">
				<xsl:text>http%3A%2F%2Fwww.stage.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>http%3A%2F%2Fwww.bbc.co.uk</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="root_encoded">
    	<xsl:call-template name="library_string_urlencodeid">
    		<xsl:with-param name="string" select="$root"/>
    	</xsl:call-template>		
	</xsl:variable>
	
	<xsl:variable name="policy_encoded">
    	<xsl:call-template name="library_string_urlencodeid">
    		<xsl:with-param name="string" select="/H2G2/SITE/IDENTITYPOLICY"/>
    	</xsl:call-template>		
	</xsl:variable>	
	
	<xsl:variable name="id_params">
		<xsl:value-of select="concat('target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, $referrer)" />
	</xsl:variable>
	
	<xsl:variable name="id_params_decoded">
		<xsl:value-of select="concat('target_resource=', /H2G2/SITE/IDENTITYPOLICY, '&amp;ptrt=', $id_ptrt, $root, $referrer)" />
	</xsl:variable>
	
	<xsl:variable name="lastchar">
		<xsl:value-of select="substring($id_params_decoded, string-length($id_params_decoded))" />
	</xsl:variable> 	
	
	<xsl:variable name="id_loginpath">
		<xsl:choose>
			<xsl:when test="not(/H2G2/VIEWING-USER/IDENTITY)">
				<xsl:text>users/login?</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>users/dash/more?</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="id_signinlink">
		<xsl:value-of select="concat($idURL, $id_loginpath, $id_params)" />
	</xsl:variable>	
	
	<xsl:variable name="id_registerlink">
		<xsl:value-of select="concat($idURL, 'users/register?', $id_params)" />
	</xsl:variable>
	
	<xsl:variable name="id_settingslink">
		<xsl:value-of select="concat($idURL, 'users/dash?', $id_params)" />
	</xsl:variable>
	
	<xsl:variable name="id_morelink">
		<xsl:choose>
			<xsl:when test="$lastchar = '/'">
				<xsl:value-of select="concat($idURL, 'users/dash/more?', $id_params, 'SSO')" />
			</xsl:when>	
			<xsl:otherwise>
				<xsl:value-of select="concat($idURL, 'users/dash/more?', $id_params, '/SSO')" />
			</xsl:otherwise>
		</xsl:choose>			
	</xsl:variable>	
	
	<xsl:variable name="id_signoutlink">
		<xsl:value-of select="concat($idURL, 'users/logout?', $id_params)" />
	</xsl:variable>
	
	<xsl:variable name="signinlink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="$sso_signinlink" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$id_signinlink" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="registerlink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="$sso_registerlink" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$id_registerlink" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:variable name="userdetailslink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="$sso_managelink" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($root, 'userdetails')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="sso_statusbar">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<!-- Magnetic North Removed - 11/02/09 -->
			<!-- link rel="StyleSheet" href="{$sso_asset_root}/includes/service_statbar.css" type="text/css"/-->
			<xsl:choose>
				<xsl:when test="$sso_statbar_type='normal'">
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERNAME"><!-- Check if this works in SSO -->
								<ul>
									<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 0">
										<li id="ms-logged-in">
											<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
										</li>
									</xsl:if>
									<li>
										<xsl:if test="($test_OwnerIsViewer = 1) and (/H2G2/@TYPE='MOREPAGES')">
											<xsl:attribute name="class">current-page</xsl:attribute>
										</xsl:if>
										<a href="{$root}MA{/H2G2/VIEWING-USER/USER/USERID}?type=2&amp;s_filter=articles&amp;show=8">Your memories</a>
									</li>
									<li>
										<xsl:if test="(/H2G2/USER-DETAILS-FORM/USERID = /H2G2/VIEWING-USER/USER/USERID) and (/H2G2/@TYPE='USERDETAILS')">
											<xsl:attribute name="class">current-page</xsl:attribute>
										</xsl:if>
										<a href="{$root}userdetails" title="Your Preferences">Your preferences</a>
									</li>
									<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 0">
										<li>
											<a href="{$sso_signoutlink}" title="Log out">Log out</a>
										</li>
									</xsl:if>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<ul>
									<xsl:choose>
										<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
											<li id="ms-not-logged-in">
												Not logged in
											</li>
											<li>
												<a>
													<xsl:attribute name="href">
														<xsl:choose>
															<xsl:when test="(/H2G2/@TYPE='TYPED-ARTICLE') and (/H2G2/ERROR/@TYPE='UNREGISTERED')">
																<xsl:call-template name="sso_typedarticle_signin2"/>
																<xsl:if test="count(/H2G2/PARAMS/PARAM)">
																	<xsl:for-each select="/H2G2/PARAMS/PARAM">
																		<xsl:text>&amp;</xsl:text>
																		<xsl:value-of select="NAME" />
																		<xsl:text>=</xsl:text>
																		<xsl:value-of select="VALUE" />
																	</xsl:for-each>
																</xsl:if>														
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$signinlink" />
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:text>Login</xsl:text>
												</a>
											</li>
											<li>
												<a href="{$registerlink}">Register</a>
											</li>
										</xsl:when>
										<xsl:otherwise>
											<li class="blq-hide">Please use the sign in links above to sign in or register.</li>
										</xsl:otherwise>
									</xsl:choose>
								</ul>
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
											<a href="{$registerlink}">
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
												<a href="{$signinlink}">
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


