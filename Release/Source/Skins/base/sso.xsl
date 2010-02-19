<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="createtype"><![CDATA[<MULTI-INPUT>
								<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
							</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="sso_assets" select="concat($sso_resources, $sso_assets_path)"/>
	<!-- sso_resources: the server - stored in site.xsl 	-->
	<xsl:variable name="sso_statbar_type" select="'normal'"/>
	<xsl:variable name="sso_serviceid_path">/signon/ssodemo1</xsl:variable>
	<xsl:variable name="sso_assets_path">
		<xsl:choose>
			<xsl:when test="$sso_statbar_type='kids'">/signon/ssodemo_kids1</xsl:when>
			<xsl:otherwise>/signon/ssodemo1</xsl:otherwise>
		</xsl:choose>
	
	</xsl:variable>
	<xsl:variable name="sso_serviceid_link">ssodemo1</xsl:variable>
	<xsl:variable name="sso_username" select="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME"/>
	<xsl:variable name="sso_error" select="/H2G2/VIEWING-USER/SSO/SSOERROR"/>
	
	<xsl:variable name="sso_ptrt" select="concat('SSO?s_return=', $referrer)"/>
	
	<xsl:variable name="sso_rootlogin" select="concat($sso_resources, $sso_script, '?c=login&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root)"/>
	<xsl:variable name="sso_rootregister" select="concat($sso_resources, $sso_script, '?c=register&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root)"/>
	<xsl:variable name="sso_signinlink" select="concat($sso_resources, $sso_script, '?c=login&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root, $sso_ptrt)"/>
	<xsl:variable name="sso_registerlink" select="concat($sso_resources, $sso_script, '?service=', $sso_serviceid_link, '&amp;c=register&amp;ptrt=', $sso_redirectserver, $root, $sso_ptrt)"/>
	<xsl:variable name="sso_managelink">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
				<xsl:value-of select="$sso_resources"/>
				<xsl:value-of select="$sso_script"/>?c=rd&amp;service=<xsl:value-of select="$sso_serviceid_link"/>&amp;ptrt=<xsl:value-of select="$sso_redirectserver"/>
				<xsl:value-of select="$root"/>U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>&amp;s_sync=1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sso_resources"/>
				<xsl:value-of select="$sso_script"/>?c=rd&amp;service=<xsl:value-of select="$sso_serviceid_link"/>&amp;ptrt=<xsl:value-of select="$sso_redirectserver"/>
				<xsl:value-of select="$root"/>SSO%3Fpa=changeddetails</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sso_signoutlink" select="concat($sso_resources, $sso_script, '?c=signout&amp;service=', $sso_serviceid_link, '&amp;ptrt=', $sso_redirectserver, $root, 'SSO')"/>
	<xsl:variable name="sso_articletype">
		<xsl:if test="/H2G2/ERROR/ARTICLETYPE">
			<xsl:value-of select="concat('%26pt=type%26type=', /H2G2/ERROR/ARTICLETYPE)"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="sso_noarticlesigninlink"> 
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage', $sso_articletype)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($id_signinlink, 'UserEdit')" />
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sso_noarticleregisterlink"> 
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=editpage', $sso_articletype)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($id_registerlink, 'UserEdit')" />
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="sso_novotesigninlink" select="concat($sso_rootlogin, 'SSO%3Fpa=vote%26pt=votetype%26votetype=', /H2G2/VOTING-PAGE/VOTETYPE, '%26pt=voteid%26voteid=', /H2G2/VOTING-PAGE/VOTEID, '%26pt=voteresp%26voteresp=', /H2G2/VOTING-PAGE/RESPONSE, $sso_extravoteparams)"/>
	<xsl:variable name="sso_novoteregisterlink" select="concat($sso_rootregister, 'SSO%3Fpa=vote%26pt=votetype%26votetype=', /H2G2/VOTING-PAGE/VOTETYPE, '%26pt=voteid%26voteid=', /H2G2/VOTING-PAGE/VOTEID, '%26pt=voteresp%26voteresp=', /H2G2/VOTING-PAGE/RESPONSE, $sso_extravoteparams)"/>
	<xsl:variable name="sso_articleratesigninlink" select="concat($sso_rootlogin, 'SSO%3Fpa=article%26pt=dnaid%26dnaid=', /H2G2/ARTCLE/ARTICLEINFO/H2G2ID)"/>
	<xsl:variable name="sso_articlerateregisterlink" select="concat($sso_rootregister, 'SSO%3Fpa=article%26pt=dnaid%26dnaid=', /H2G2/ARTCLE/ARTICLEINFO/H2G2ID)"/>
	<xsl:variable name="sso_postcodeentrysigninlink" select="concat($sso_rootlogin, 'SSO%3Fpa=postcodeentry')"/>
	<xsl:variable name="sso_postcodeentryregisterlink" select="concat($sso_rootregister, 'SSO%3Fpa=postcodeentry')"/>
	<xsl:variable name="sso_extravoteparams"/>
	<xsl:variable name="sso_noclubsigninlink" select="concat($sso_rootlogin, 'SSO%3Fpa=createclub')"/>
	<xsl:variable name="sso_noclubregisterlink" select="concat($sso_rootregister, 'SSO%3Fpa=createclub')"/>
	<xsl:variable name="test_postcode" select="/H2G2/POSTCODER/RESULT_LIST/RESULT/POSTCODE"/>
	<xsl:variable name="sso_extranoticeparams">
		<xsl:if test="$test_postcode">
			<xsl:value-of select="concat('%26pt=noticepc%26noticepc=', $test_postcode)"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="sso_nonoticesigninlink" select="concat($sso_rootlogin, 'SSO%3Fpa=addnotice%26pt=noticetype%26noticetype=', /H2G2/NOTICEBOARD/NOTICETYPE, $sso_extranoticeparams)"/>
	<xsl:variable name="sso_nonoticeregisterlink" select="concat($sso_rootregister, 'SSO%3Fpa=addnotice%26pt=noticetype%26noticetype=', /H2G2/NOTICEBOARD/NOTICETYPE, $sso_extranoticeparams)"/>

	<!-- ** Identity variables ** If I'd known what was involved I would've structured this completely differently. -->

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
				<xsl:text>http%3A%2F%2Fdna-staging.bbc.co.uk</xsl:text>
			</xsl:when>	
			<xsl:when test="/H2G2/SERVERNAME = 'NARTHUR5'">
				<xsl:text>http%3A%2F%2Fextdev.bbc.co.uk</xsl:text>
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
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/@ID = '67'">
				<!--  this is to return 606 users from registration to the edit profile page -->
				<xsl:choose>
					<xsl:when test="$lastchar = '/'">
						<xsl:value-of select="concat($idURL, 'users/register?', $id_params, 'SSO')" />
					</xsl:when>	
					<xsl:otherwise>
						<xsl:value-of select="concat($idURL, 'users/register?', $id_params, '/SSO')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($idURL, 'users/register?', $id_params)" />
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	<xsl:variable name="id_settingslink">
		<xsl:value-of select="concat($idURL, 'users/dash?', $id_params)" />
		<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
			<xsl:text>&amp;cbbc=true</xsl:text>
		</xsl:if>		
	</xsl:variable>
	
	<xsl:variable name="id_morelink">
		<xsl:value-of select="concat($idURL, 'users/dash/more?', $id_params)" />
		<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
			<xsl:text>&amp;cbbc=true</xsl:text>
		</xsl:if>		
	</xsl:variable>	
	
	<xsl:variable name="id_signoutlink">
		<xsl:value-of select="concat($idURL, 'users/logout?', $id_params)" />
	</xsl:variable>
	
	<xsl:variable name="id_stringlimit" select="40"/>
	
	<xsl:variable name="sso_nopostsigninlink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forum%26forum=', /H2G2/POSTTHREADUNREG/@FORUMID, '%26pt=thread%26thread=', /H2G2/POSTTHREADUNREG/@THREADID, '%26pt=post%26post=', /H2G2/POSTTHREADUNREG/@POSTID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$id_signinlink" />
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="sso_nopostregisterlink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forum%26forum=', /H2G2/POSTTHREADUNREG/@FORUMID, '%26pt=thread%26thread=', /H2G2/POSTTHREADUNREG/@THREADID, '%26pt=post%26post=', /H2G2/POSTTHREADUNREG/@POSTID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($idURL, 'users/register?target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, $referrer)" />
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable> 
	
	<xsl:variable name="signinlink">
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="$sso_signinlink" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$id_signinlink" />
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
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
				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
					<xsl:text>&amp;cbbc=true</xsl:text>
				</xsl:if>				
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

	<xsl:template name="sso_editalerts_register">
		<xsl:param name="itemType"/>
		<xsl:param name="isOwner"/>
		<xsl:param name="itemId"/>
		<xsl:param name="itemId2"/>
		<xsl:variable name="returnInfo">&amp;s_itemType=<xsl:value-of select="$itemType" />&amp;s_itemId=<xsl:value-of select="$itemId" />&amp;s_itemId2=<xsl:value-of select="$itemId2" /></xsl:variable>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2/EMAIL-SUBSCRIPTION/SUBSCRIPTION[@ITEMTYPE = $itemType]">
						<xsl:value-of select="concat($root, 'AlertGroups')"/>
					
					</xsl:when>
					<xsl:when test="/H2G2/FORUMTHREADPOSTS[@GROUPALERTID]">
						<xsl:value-of select="concat($root, 'AlertGroups')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($root, 'AlertGroups?cmd=add&amp;s_mode=confirm&amp;itemtype=', $itemType, '&amp;itemid=', $itemId, $returnInfo)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
							<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=alertgroups%26pt=itemtype%26itemtype=', $itemType, '%26pt=itemid%26itemid=', $itemId, '%26s_mode=confirm', '%26pt=forumid%26forumid=', /H2G2/FORUMTHREADPOSTS/@FORUMID, '%26s_mode=confirm')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=alertgroups%26pt=cmd%26cmd=add%26pt=itemtype%26itemtype=', $itemType, '%26pt=itemid%26itemid=', $itemId, '%26s_mode=confirm')"/>
						</xsl:otherwise>
					</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_editalerts_signin">
		<xsl:param name="itemType"/>
		<xsl:param name="isOwner"/>
		<xsl:param name="itemId"/>
		<xsl:param name="itemId2" />
		<xsl:variable name="returnInfo">&amp;s_itemType=<xsl:value-of select="$itemType" />&amp;s_itemId=<xsl:value-of select="$itemId" />&amp;s_itemId2=<xsl:value-of select="$itemId2" /></xsl:variable>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">			
				<xsl:choose>
					<xsl:when test="/H2G2/EMAIL-SUBSCRIPTION/SUBSCRIPTION[@ITEMTYPE = $itemType]">
						<xsl:value-of select="concat($root, 'AlertGroups')"/>					
					</xsl:when>
					<xsl:when test="/H2G2/FORUMTHREADPOSTS[@GROUPALERTID]">
						<xsl:value-of select="concat($root, 'AlertGroups')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($root, 'AlertGroups?cmd=add&amp;s_mode=confirm&amp;itemtype=', $itemType, '&amp;itemid=', $itemId, $returnInfo)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=alertgroups%26pt=itemtype%26itemtype=', $itemType, '%26pt=itemid%26itemid=', $itemId, '%26s_mode=confirm', '%26pt=forumid%26forumid=', /H2G2/FORUMTHREADPOSTS/@FORUMID, '%26s_mode=confirm')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=alertgroups%26pt=cmd%26cmd=add%26pt=itemtype%26itemtype=', $itemType, '%26pt=itemid%26itemid=', $itemId, '%26s_mode=confirm')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sso_addcommenttsp_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', DEFAULTFORUMID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=addcommenttsp%26pt=forum%26forum=', DEFAULTFORUMID)"/>	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--(not id and template is called)-->
	<xsl:template name="sso_addcommenttsp_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', DEFAULTFORUMID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=addcommenttsp%26pt=forum%26forum=', DEFAULTFORUMID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sso_articlerating_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forum%26forum=', ../@FORUMID, '%26pt=thread%26thread=', ../@THREADID, '%26pt=post%26post=', @POSTID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_articlerating_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='MULTIPOSTS' or @TYPE='USERPAGE' or @TYPE='MESSAGEFRAME']">
						<xsl:value-of select="concat($root, 'AddThread?inreplyto=', @POSTID)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forum%26forum=', ../@FORUMID, '%26pt=thread%26thread=', ../@THREADID, '%26pt=post%26post=', @POSTID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Create a Notice (not id and template is called)-->
	<xsl:template name="sso_notice_register">
		<xsl:param name="type" select="'notice'"/>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'NoticeBoard?acreate=acreate&amp;type=', $type)"/>
				<xsl:if test="$test_postcode">
					<xsl:value-of select="concat('&amp;postcode=', $test_postcode)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=addnotice%26pt=noticetype%26noticetype=', $type)"/>
				<xsl:if test="$test_postcode">
					<xsl:value-of select="concat('%26pt=noticepc%26noticepc=', $test_postcode)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sso_notice_signin">
		<xsl:param name="type" select="'notice'"/>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'NoticeBoard?acreate=acreate&amp;type=', $type)"/>
				<xsl:if test="$test_postcode">
					<xsl:value-of select="concat('&amp;postcode=', $test_postcode)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=addnotice%26pt=noticetype%26noticetype=', $type)"/>
				<xsl:if test="$test_postcode">
					<xsl:value-of select="concat('%26pt=noticepc%26noticepc=', $test_postcode)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Create a post (Multiposts page) -->
	<xsl:template match="POST" mode="sso_post_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='MULTIPOSTS' or @TYPE='USERPAGE' or @TYPE='MESSAGEFRAME' or @TYPE='JOURNAL']">
						<xsl:value-of select="concat($root, 'AddThread?inreplyto=', @POSTID)"/>
					</xsl:when>
					
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forum%26forum=', ../@FORUMID, '%26pt=thread%26thread=', ../@THREADID, '%26pt=post%26post=', @POSTID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- reply to -->
	<xsl:template match="POST|FIRSTPOST|LASTPOST" mode="sso_post_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='MULTIPOSTS' or @TYPE='USERPAGE' or @TYPE='MESSAGEFRAME' or @TYPE='JOURNAL']">
						<xsl:value-of select="concat($root, 'AddThread?inreplyto=', @POSTID)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="(/H2G2/SITE/IDENTITYSIGNIN = 0)">
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forum%26forum=', ../@FORUMID, '%26pt=thread%26thread=', ../@THREADID, '%26pt=post%26post=', @POSTID)"/>	
					</xsl:when>
					<xsl:otherwise>
		          		<xsl:value-of select="concat($idURL, $id_loginpath,'target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, 'AddThread%3Finreplyto=', @POSTID)" />
          				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
          					<xsl:text>&amp;cbbc=true</xsl:text>
          				</xsl:if>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Leave a comment (article page or threads page) -->
	<xsl:template name="sso_addcomment_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='THREADS']">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1]/POST)">
						<xsl:value-of select="concat($root, 'Addthread?inreplyto=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST[1]/@POSTID, '&amp;action=A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1])">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID, '&amp;action=A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<!-- Added as 'add first comment' didn't return people to the article page -->
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADS)">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='THREADS']">
						<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1]/POST)">
						<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=gb%26pt=post%26post=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST[1]/@POSTID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADS)">
						<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID, '%26pt=post%26post=0%26pt=thread%26thread=0')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sso_addcomment_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='THREADS']">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1]/POST)">
						<xsl:value-of select="concat($root, 'Addthread?inreplyto=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST[1]/@POSTID, '&amp;action=A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1])">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID, '&amp;action=A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<!-- Added as 'add first comment' didn't return people to the article page -->
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADS)">
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='THREADS']">
						<xsl:choose>
							<xsl:when test="(/H2G2/SITE/IDENTITYSIGNIN = 0)">
								<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($idURL, $id_loginpath, 'target_resource=', $policy_encoded, '&amp;ptrt=', $id_ptrt, $root_encoded, 'AddThread?forum=', /H2G2/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2I)" />
		          				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
		          					<xsl:text>&amp;cbbc=true</xsl:text>
		          				</xsl:if>								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS[@GUESTBOOK=1]/POST)">
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=gb%26pt=post%26post=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST[1]/@POSTID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="(/H2G2[@TYPE='ARTICLE']) and (/H2G2/ARTICLEFORUM/FORUMTHREADS)">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID, '%26pt=post%26post=0%26pt=thread%26thread=0')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="/H2G2/FORUMSOURCE">
										<!-- worried this might affect something if I alter it so am doing a test  -->
										<xsl:value-of select="concat($idURL, $id_loginpath, 'target_resource=', $policy_encoded, /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" />
										<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
											<xsl:text>&amp;cbbc=true</xsl:text>
										</xsl:if>										
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($idURL, $id_loginpath, 'target_resource=', $policy_encoded,'&amp;ptrt=', $id_ptrt, $root_encoded, 'AddThread%3Fforum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
										<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
											<xsl:text>&amp;cbbc=true</xsl:text>
										</xsl:if>										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($idURL, $id_loginpath, 'target_resource=', $policy_encoded,'&amp;ptrt=', $id_ptrt, $root_encoded, 'AddThread%3Fpa=postforum%26pt=forumtype%26forumtype=art%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
								<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
									<xsl:text>&amp;cbbc=true</xsl:text>
								</xsl:if>								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Leave a comment (User page) -->
	<xsl:template name="sso_message_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=user%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--(not id and template is called)-->
	<xsl:template name="sso_message_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0 ">
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=user%26pt=forum%26forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($idURL, $id_loginpath, 'target_resource=', $policy_encoded,'&amp;ptrt=', $id_ptrt, $root_encoded, 'AddThread%3Fforum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
						<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
							<xsl:text>&amp;cbbc=true</xsl:text>
						</xsl:if>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Leave a private message -->
	<xsl:template name="sso_pf_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=pm%26pt=forum%26forum=', /H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sso_pf_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=postforum%26pt=forumtype%26forumtype=pm%26pt=forum%26forum=', /H2G2/PRIVATEFORUM/FORUMTHREADS/@FORUMID, '%26pt=article%26article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Create a club (these templates are not called anywhere) -->
	<xsl:template name="sso_club_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'G?action=new')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=createclub')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_club_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'G?action=new')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=createclub')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_club_support_register">
	<xsl:param name="pollid"><xsl:choose>
	<xsl:when test="/H2G2/@TYPE='POLL'"><xsl:value-of select="/H2G2/VOTING-PAGE/POLL/@POLLID"/></xsl:when>
	<xsl:when test="/H2G2/@TYPE='CLUB'"><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:otherwise>
	</xsl:choose></xsl:param>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'poll?cmd=vote&amp;pollid=', $pollid, '&amp;response=1&amp;userstatustype=1')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=supportclub%26pt=cmd%26cmd=vote%26pt=pollid%26pollid=', $pollid, '%26pt=response%26response=1%26pt=userstatustype%26userstatustype=1')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_club_support_signin">
	<xsl:param name="pollid"><xsl:choose>
	<xsl:when test="/H2G2/@TYPE='POLL'"><xsl:value-of select="/H2G2/VOTING-PAGE/POLL/@POLLID"/></xsl:when>
	<xsl:when test="/H2G2/@TYPE='CLUB'"><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:otherwise>
	</xsl:choose></xsl:param>
	
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'poll?cmd=vote&amp;pollid=', $pollid, '&amp;response=1&amp;userstatustype=1')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=supportclub%26pt=cmd%26cmd=vote%26pt=pollid%26pollid=', $pollid, '%26pt=response%26response=1%26pt=userstatustype%26userstatustype=1')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_club_oppose_register">
	<xsl:param name="pollid"><xsl:choose>
	<xsl:when test="/H2G2/@TYPE='POLL'"><xsl:value-of select="/H2G2/VOTING-PAGE/POLL/@POLLID"/></xsl:when>
	<xsl:when test="/H2G2/@TYPE='CLUB'"><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:otherwise>
	</xsl:choose></xsl:param>		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'poll?cmd=vote&amp;pollid=', $pollid, '&amp;response=0&amp;userstatustype=1')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=opposeclub%26pt=cmd%26cmd=vote%26pt=pollid%26pollid=', $pollid, '%26pt=response%26response=0%26pt=userstatustype%26userstatustype=1')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_club_oppose_signin">
	<xsl:param name="pollid"><xsl:choose>
	<xsl:when test="/H2G2/@TYPE='POLL'"><xsl:value-of select="/H2G2/VOTING-PAGE/POLL/@POLLID"/></xsl:when>
	<xsl:when test="/H2G2/@TYPE='CLUB'"><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="/H2G2/CLUB/POLL-LIST/POLL/@POLLID"/></xsl:otherwise>
	</xsl:choose></xsl:param>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'poll?cmd=vote&amp;pollid=', $pollid, '&amp;response=0&amp;userstatustype=1')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=opposeclub%26pt=cmd%26cmd=vote%26pt=pollid%26pollid=', $pollid, '%26pt=response%26response=0%26pt=userstatustype%26userstatustype=1')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Create a useredit article -->
	<xsl:template name="sso_useredit_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'useredit')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($id_signinlink, 'useredit')"/>
						<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
							<xsl:text>&amp;cbbc=true</xsl:text>
						</xsl:if>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sso_useredit_register">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'useredit')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=editpage')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Create a typed article -->
	<xsl:template name="sso_typedarticle_register">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'TypedArticle?acreate=new')"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('&amp;type=', $type)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootregister, 'SSO%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sso_typedarticle_signin">
		<!-- its a template as their needs to be a param variable for the type, it cannot hold the full, can change text easily as well -->
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'TypedArticle?acreate=new')"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('&amp;type=', $type)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="id_typedarticle_signin">
		<!-- its a template as their needs to be a param variable for the type, it cannot hold the full, can change text easily as well -->
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:value-of select="concat($root, 'TypedArticle?acreate=new')"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('&amp;type=', $type)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Having to code defensively here as not sure what the id migration for 606 can affect -->
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/@ID = 67">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat($signinlink, '%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
								<xsl:if test="$type">
									<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
								</xsl:if>							
							</xsl:when>	
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$lastchar = '/'">
										<xsl:value-of select="concat($signinlink, 'TypedArticle%3Facreate=new')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($signinlink, '/TypedArticle%3Facreate=new')"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
									<xsl:text>&amp;cbbc=true</xsl:text>
								</xsl:if>								
							</xsl:otherwise>					
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($signinlink, '%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
						<xsl:if test="$type">
							<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
  
	<xsl:template name="sso_statusbar-admin">
	    <xsl:choose>
	      <xsl:when test="(/H2G2/SITE/IDENTITYSIGNIN = 0)">
	        <xsl:call-template name = "sso_statusbar"/>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:call-template name="identity_statusbar"/>
	      </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
  
	<xsl:template name="sso_statusbar">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<link rel="StyleSheet" href="{$sso_assets}/includes/service_statbar.css" type="text/css"/>
			<xsl:choose>
				<xsl:when test="$sso_statbar_type='normal'">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<xsl:choose>
							<xsl:when test="$sso_username">
								<!-- One -->
								<tr class="ssoOne">
									<td width="220">
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
										<font size="-1">
								Hello <strong>
												<xsl:value-of select="$sso_username"/>
											</strong>
										</font>
									</td>
									<td>
										<img src="/f/t.gif" width="1" height="22" alt=""/>
									</td>
									<td>
										<font size="-2">
											<a href="{$sso_resources}{$sso_script}?c=notme&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO?s_return={$referrer}" class="ssoStatusdark">
									I'm not <xsl:value-of select="$sso_username"/>
											</a>
										</font>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_assets}/images/other/statbar_diag_slim_l.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center" class="ssoTwo" background="{$sso_assets}/images/other/statbar_bg.gif" style="background:top url({$sso_assets}/images/other/statbar_bg.gif) repeat-x;">
										<img src="/f/t.gif" width="1" height="4" alt=""/>
										<br/>
										<font size="-2">
											<strong>
												<a class="ssoStatuslight">
													<xsl:attribute name="href"><xsl:value-of select="$sso_managelink"/></xsl:attribute>Retrieve my details</a>
											</strong>
										</font>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_assets}/images/other/statbar_diag_slim_r.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center">
										<font size="-2">
											<strong>
												<a href="{$sso_signoutlink}" class="ssoStatusdark">Sign out</a>
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
							</xsl:when>
							<xsl:otherwise>
								<!--slimline unrecognised status bar here-->
								<tr>
									<td class="ssoThree" width="10" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/corners/statbar_light_bl.gif" width="10" height="10" alt="" border="0"/>
									</td>
									<td class="ssoThree">
										<img src="/f/t.gif" height="1" alt=""/>
									</td>
									<td class="ssoOne" width="1" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/other/statbar_slim_middle.gif" height="30" width="21" alt="" border="0"/>
									</td>
									<td class="ssoOne">
										<img src="/f/t.gif" height="1" alt=""/>
									</td>
									<td align="right" class="ssoOne" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/corners/statbar_dark_br.gif" width="10" height="10" alt="" border="0"/>
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
														<img src="{$sso_assets}/images/buttons/create_membership_slim.gif" alt="Create your membership" border="0"/>
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
													<a href="{$sso_signinlink}">
														<img src="{$sso_assets}/images/buttons/signin_slim.gif" alt="Sign in" border="0"/>
													</a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</table>
				</xsl:when>
				<xsl:when test="$sso_statbar_type='kids'">
					<link rel="StyleSheet" href="{$sso_resources}/signon/sso_includes/singlesignon_kids_statbar.css" type="text/css"/>
					<xsl:choose>
						<xsl:when test="$sso_username">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr class="statbar">
									<td>
										<img src="{$sso_assets}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_assets}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
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
												<img src="{$sso_assets}/images/buttons/mydetails_cd.gif" width="82" height="22" alt="My details" />
											</a>
											<a href="{$sso_signoutlink}">
												<img src="{$sso_assets}/images/buttons/signout_bg.gif" width="70" height="22" alt="" class="adjacentButton" />
											</a>
										</div>
									</td>
								</tr>
								<!--full rec statbar bottom-->
								<tr class="statbar">
									<td>
										<img src="{$sso_assets}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_assets}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<table width="100%" cellspacing="0" cellpadding="0">
							<!--full rec statbar top-->
								<tr>
									<td class="reg" colspan="2">
										<img src="{$sso_assets}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td rowspan="3" width="1">
										<img src="/f/t.gif" width="1" height="1" alt="" />
									</td>
									<td align="right" class="rtn" colspan="2">
										<img src="{$sso_assets}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
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
												<img src="{$sso_assets}/images/buttons/becomeamember_slim_reg.gif" alt="Become a member" />
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
													<img src="{$sso_assets}/images/buttons/signin_slim_rtn.gif" alt="Sign in" />
												</a>
											</div>
										</td>
									</tr>
									<!--full rec statbar bottom-->
									<tr>
										<td class="reg" colspan="2">
											<img src="{$sso_assets}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
										</td>
										<td align="right" class="rtn" colspan="2">
											<img src="{$sso_assets}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
										</td>
									</tr>
								</table>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="identity_statusbar">
		<xsl:param name="h2g2class" />
		<div id="identitywrap">
			<div id="identitylogin">
				<xsl:if test="/H2G2/SITE/@ID = '1' and $h2g2class">
					<xsl:attribute name="class">
						<xsl:value-of select="$h2g2class" />
					</xsl:attribute>
				</xsl:if>
		        <xsl:choose>
		          <xsl:when test="not(/H2G2/VIEWING-USER/USER/USERID)">
			          <xsl:choose>
			          	<xsl:when test="not(/H2G2/VIEWING-USER/IDENTITY)">
			          		<a class="id-signin">
			          			<xsl:attribute name="href">
			          				<xsl:value-of select="$id_signinlink" />
			          				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
			          					<xsl:text>&amp;cbbc=true</xsl:text>
			          				</xsl:if>
			          			</xsl:attribute>
			          			<span>Sign in</span>
			          		</a>
			           		<p>or 
					           <a>			            		
					           	<xsl:attribute name="href">
			          				<xsl:value-of select="$registerlink" />
			          			</xsl:attribute>register</a> 
	          				to join or start a new 
	          				<xsl:choose>
	          					<xsl:when test="/H2G2/SITE/@ID = '1'">
	          						<xsl:text>conversation</xsl:text>
	          					</xsl:when>
	          					<xsl:otherwise>
	          						<xsl:text>discussion</xsl:text>
	          					</xsl:otherwise>
	          				</xsl:choose>.
	          				</p> 		          		
			          	</xsl:when>
			            <!-- User has not accepted T&Cs -->
			            <xsl:otherwise>
			            	<img src="http://www.bbc.co.uk/dnaimages/boards/images/identity_logo.gif" width="20" height="17" alt="" />
			            	<p class="idtransitional"><a>
			            		<xsl:attribute name="href">
			          				<xsl:value-of select="$signinlink" />
			          			</xsl:attribute>
			          			<xsl:text>Click here</xsl:text>
			          		</a> to complete your registration.	</p>	          			
			            </xsl:otherwise>		          	
			          </xsl:choose> 
		          </xsl:when>         
		          <xsl:otherwise>
					<img src="http://www.bbc.co.uk/dnaimages/boards/images/identity_logo.gif" width="20" height="17" alt="" />
					<ul>
						<li>
							<xsl:choose>
								<xsl:when test="string-length(normalize-space(/H2G2/VIEWING-USER/USER/USERNAME)) &lt; $id_stringlimit"> 
									<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="truncatestring"><xsl:value-of select="substring(/H2G2/VIEWING-USER/USER/USERNAME, 1, $id_stringlimit)" /></xsl:variable>
									<xsl:value-of select="concat($truncatestring, '...')" />
								</xsl:otherwise>
							</xsl:choose>
						</li>  
						<li>|</li>
						<li><a>
							<xsl:attribute name="href">
								<xsl:value-of select="$id_settingslink" />
		         				<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'kids')">
		          					<xsl:text>&amp;cbbc=true</xsl:text>
		          				</xsl:if>									
							</xsl:attribute>
							Settings </a></li>  
						<li>|</li>
						<li><a href="{$id_signoutlink}">Sign Out</a></li>
					</ul>	
					<xsl:if test="not(/H2G2/SITE/@ID = '67' or /H2G2/SITE/@ID = '1' or /H2G2/SITE/@ID = '66')">
						<ul id="iddiscussions">
							<li><a href="{$root}MP{VIEWING-USER/USER/USERID}">
								<xsl:text>Your discussions</xsl:text>
							</a></li>
						</ul>        
					</xsl:if>       
		          </xsl:otherwise>
		        </xsl:choose>
	        </div>
        </div>	
	</xsl:template>
	
	
	<!-- Need to store these in a common directory  -->
	<xsl:template name="library_string_urlencodeid">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="starts-with($string, 'http://')">
				<xsl:call-template name="library_string_searchandreplaceid">
					<xsl:with-param name="str" select="concat('http%3A%2F%2F', substring-after($string, 'http://'))"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($string, 'https://')">
				<xsl:call-template name="library_string_searchandreplaceid">
					<xsl:with-param name="str" select="concat('https%3A%2F%2F', substring-after($string, 'https://'))"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="library_string_searchandreplaceid">
					<xsl:with-param name="str" select="$string"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template name="library_string_searchandreplaceid">

		<xsl:param name="str" />
		<xsl:param name="search" />
		<xsl:param name="replace" />

		<xsl:choose>
			<xsl:when test="contains($str, $search)">

				<xsl:value-of select="substring-before($str, $search)"/>

				<xsl:value-of select="$replace"/>

				<xsl:call-template name="library_string_searchandreplaceid">
					<xsl:with-param name="str" select="substring-after($str, $search)" />
					<xsl:with-param name="search" select="$search"/>
					<xsl:with-param name="replace" select="$replace"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>	
	<!--xsl:when test="$sso_error">
					<tr class="ssoOne">
						<td width="3">
							<img src="/f/t.gif" width="3" height="3" alt=""/>
						</td>
						<td width="15">
							<img src="/f/t.gif" width="15" height="1" alt=""/>
						</td>
						<td>
							<img src="/f/t.gif" width="1" height="1" alt=""/>
						</td>
						<td width="100">
							<img src="/f/t.gif" width="100" height="1" alt=""/>
						</td>
						<td width="15">
							<img src="/f/t.gif" width="15" height="1" alt=""/>
						</td>
						<td width="3">
							<img src="/f/t.gif" width="3" height="1" alt=""/>
						</td>
					</tr>
					
					<tr>
						<td rowspan="2">
							<img src="/f/t.gif" width="1" height="1" alt=""/>
						</td>
						<td colspan="4" class="ssoStatusshadow">
							<img src="/f/t.gif" width="1" height="1" alt=""/>
						</td>
						<td rowspan="2">
							<img src="/f/t.gif" width="1" height="1" alt=""/>
						</td>
					</tr>
					
					<tr class="ssoTwo">
						<td>
							<img src="/f/t.gif" width="1" height="25" alt=""/>
						</td>
						<td class="ssoStatuslight">
							<font size="-1">Sorry, we have a <font size="3">
									<strong>technical problem</strong>
								</font>. You won't be able to sign in right now.</font>
						</td>
						<td align="right">
							<font size="-2">
								<a href="{$sso_resources}/signon/sso_popups/techproblem.shtml?{$sso_serviceid_path}" onclick="popwin(this.href,this.target,300,400,'scroll','resize'); return false;" target="popwin" class="ssoStatuslight">Tell me more</a>
							</font>
						</td>
						<td>&nbsp;</td>
					</tr>
				</xsl:when-->
</xsl:stylesheet>
