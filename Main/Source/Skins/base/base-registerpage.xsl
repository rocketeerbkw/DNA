<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="extravoteurlparams"/>
	<!--
	<xsl:template name="CLUB_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="NEWREGISTER_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">register</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="CLUB_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="NEWREGISTER_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_registrationsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="NEWREGISTER" mode="c_page">
		<xsl:choose>
			<xsl:when test="POSTCODE">
				<form action="{$root}SSO" method="post">
					<input type="hidden" name="ssoc" value="postcode"/>
					<xsl:apply-templates select="." mode="postcode_page"/>
				</form>
			</xsl:when>
			<xsl:when test="@STATUS='ASSOCIATED' or @STATUS='LOGGEDIN' or REGISTER-PASSTHROUGH">
				<xsl:choose>
					<xsl:when test="REGISTER-PASSTHROUGH">
						<xsl:apply-templates select="." mode="passthrough_page"/>
					</xsl:when>
					<xsl:when test="FIRSTTIME=0">
						<xsl:apply-templates select="." mode="welcomeback_page"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="welcome_page"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
      <xsl:when test="@STATUS = 'NOTSIGNEDIN' or @STATUS = 'NOTLOGGEDIN'">
        <xsl:apply-templates select="." mode="notsignedin_page"/>
      </xsl:when>
      <xsl:when test="@STATUS = 'RESTRICTED'">
        <xsl:apply-templates select="." mode="restricted_page"/>
      </xsl:when>
    </xsl:choose>
	</xsl:template>
	<xsl:template match="BADPOSTCODE" mode="c_error">
		<xsl:apply-templates select="." mode="r_error"/>
	</xsl:template>
	<xsl:template match="POSTCODE" mode="c_insertpostcode">
		<xsl:apply-templates select="." mode="r_insertpostcode"/>
	</xsl:template>
	<xsl:template match="POSTCODE" mode="t_postcodeinput">
		<input type="text" name="postcode"/>
	</xsl:template>
	<xsl:template match="POSTCODE" mode="t_postcodesubmit">
		<input type="submit" value="submit"/>
	</xsl:template>
	<xsl:template match="NEWREGISTER" mode="t_metaredirectuserpage">
		<meta http-equiv="refresh" content="0;url={$root}U{USERID}"/>
	</xsl:template>
	<xsl:template match="NEWREGISTER" mode="t_metaredirectwelcomepage">
		<meta http-equiv="refresh" content="0;url={$root}Welcome"/>
	</xsl:template>
	<xsl:template match="NEWREGISTER" mode="t_passthroughmessage">
		<xsl:choose>
			<xsl:when test="FIRSTTIME=0">
				<xsl:call-template name="m_passthroughwelcomeback"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="m_passthroughnewuser"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="c_pagetype">
		<xsl:choose>
			<xsl:when test="@ACTION='editdetails'">
				<xsl:apply-templates select="." mode="editdetails_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='postforum'">
				<xsl:apply-templates select="." mode="postforum_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='createclub'">
				<xsl:apply-templates select="." mode="createclub_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='supportclub'">
				<xsl:apply-templates select="." mode="supportclub_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='opposeclub'">
				<xsl:apply-templates select="." mode="opposeclub_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='editpage'">
				<xsl:apply-templates select="." mode="createarticle_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='vote'">
				<xsl:apply-templates select="." mode="vote_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='addnotice'">
				<xsl:apply-templates select="." mode="addnotice_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='articlepoll'">
				<xsl:apply-templates select="." mode="articlepoll_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='postcodeentry'">
				<xsl:apply-templates select="." mode="postcodeentry_pagetype"/>
			</xsl:when>
			<xsl:when test="@ACTION='addcommenttsp'">
				<xsl:apply-templates select="." mode="addcommenttsp_pagetype"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="editdetails_pagetype">
		<xsl:copy-of select="$m_detailsedited"/>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
		<xsl:choose>
			<xsl:when test="PARAM[@NAME='forumtype']='gb'">
				<a href="{$root}AddThread?inreplyto={PARAM[@NAME='post']}&amp;action=A{PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:copy-of select="$m_ptclicktoleaveguestbookmessage"/>
				</a>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='forumtype']='pm'">
				<a href="{$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:copy-of select="$m_ptclicktoleaveprivatemessage"/>
				</a>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='article']">
				<a href="{$root}AddThread?forum={PARAM[@NAME='forum']}&amp;article={PARAM[@NAME='article']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktostartnewconv"/>
				</a>
			</xsl:when>
			<xsl:when test="PARAM[@NAME='post']=0">
				<a href="{$root}AddThread?forum={PARAM[@NAME='forum']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktostartnewconv"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}AddThread?inreplyto={PARAM[@NAME='post']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_completed">
					<xsl:value-of select="$m_ptclicktowritereply"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="createclub_pagetype">
		<a href="{$root}G?action=new">
			<xsl:copy-of select="$m_ptcreateclub"/>
		</a>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="supportclub_pagetype">
		<a href="{$root}poll?cmd=vote&amp;pollid={PARAM[@NAME='pollid']}&amp;response={PARAM[@NAME='response']}&amp;userstatustype={PARAM[@NAME='userstatustype']}">
			<xsl:copy-of select="$m_ptsupportclub"/>
		</a>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="opposeclub_pagetype">
		<a href="{$root}poll?cmd=vote&amp;pollid={PARAM[@NAME='pollid']}&amp;response={PARAM[@NAME='response']}&amp;userstatustype={PARAM[@NAME='userstatustype']}">
			<xsl:copy-of select="$m_ptopposeclub"/>
		</a>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="createarticle_pagetype">
		<xsl:choose>
			<xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='type']">
				<a href="{$root}TypedArticle?acreate=new&amp;_msxml={$createtype}&amp;type={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='type']}">
					<xsl:copy-of select="$m_clicktowritearticle"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}TypedArticle?acreate=new&amp;_msxml={$createtype}&amp;type=1">
					<xsl:copy-of select="$m_clicktowritearticle"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="vote_pagetype">
		<a href="{$root}vote?action=add&amp;voteid={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='voteid']}&amp;response={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='voteresp']}&amp;type={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='votetype']}{$extravoteurlparams}">
			<xsl:copy-of select="$m_slicksubmitvote"/>
		</a>
	</xsl:template>
	<xsl:variable name="m_noticetype">
		<xsl:choose>
			<xsl:when test="string-length(/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']) &gt; 0">
				<xsl:value-of select="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']"/>
			</xsl:when>
			<xsl:otherwise>notice</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_linktoaddnotice">
		<xsl:choose>
			<xsl:when test="string-length(/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']) &gt; 0">
				<xsl:choose>
					<xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']='event'">Click here to advertise your event</xsl:when>
					<xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']='wanted'">Click here to create your find help notice</xsl:when>
					<xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='noticetype']='offer'">Click here to create your offer help notice</xsl:when>
					<xsl:otherwise>Click here to post a notice</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>Click here to create your notice</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="addnotice_pagetype">
		<xsl:variable name="postcode">
			<xsl:if test="PARAM[@NAME='noticepc']">
				<xsl:value-of select="concat('&amp;postcode=', PARAM[@NAME='noticepc'])"/>
			</xsl:if>
		</xsl:variable>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat($root, 'NoticeBoard?acreate=acreate&amp;type=', PARAM[@NAME='noticetype'], $postcode)"/>
				<xsl:for-each select="/H2G2/PARAMS/PARAM">
					<xsl:value-of select="concat('&amp;', NAME, '=', VALUE)"/>
				</xsl:for-each>
			</xsl:attribute>
			<xsl:copy-of select="$m_linktoaddnotice"/>
		</a>
	</xsl:template>
  <xsl:template match="NEWREGISTER" mode="notsignedin_page">
    <table width="100%" border="0" cellspacing="10" cellpadding="0">
      <tr>
        <td class="ssoPromo">
          <font size="-1">
            <xsl:choose>
              <xsl:when test="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME">
                You are not currently signed in to this site. <a href="{$sso_signinlink}">Sign in</a>.
              </xsl:when>
              <xsl:otherwise>We were unable to sign you in at this time</xsl:otherwise>
            </xsl:choose>
          </font>
        </td>
      </tr>
      <tr>
        <td>
          <a href="{$root}">
            <img src="{$sso_assets}/images/buttons/servicespecific/go_back_to_service.gif" alt="Go Back to homepage" border="0"/>
          </a>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template match="NEWREGISTER" mode="restricted_page">
		<table width="100%" border="0" cellspacing="10" cellpadding="0">
			<tr>
				<td class="ssoPromo">
					<font size="-1">
            You have been restricted from accessing this BBC website.
          </font>
				</td>
			</tr>
			<tr>
				<td>
					<a href="{$root}">
						<img src="{$sso_assets}/images/buttons/servicespecific/go_back_to_service.gif" alt="Go Back to homepage" border="0"/>
					</a>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="ERROR" mode="c_error">
		<xsl:apply-templates select="." mode="r_error"/>
	</xsl:template>
	<xsl:template match="ERROR" mode="r_error">
		<table width="100%" border="0" cellspacing="10" cellpadding="0">
			<tr>
				<td class="ssoPromo">
					<font size="-1">
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME">You are not currently signed in to this site. <a href="{$sso_signinlink}">Sign in</a>.</xsl:when>
							<xsl:otherwise>We were unable to sign you in at this time</xsl:otherwise>
						</xsl:choose>
					</font>
				</td>
			</tr>
			<tr>
				<td>
					<a href="{$root}">
						<img src="{$sso_assets}/images/buttons/servicespecific/go_back_to_service.gif" alt="Go Back to homepage" border="0"/>
					</a>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:attribute-set name="mREGISTER-PASSTHROUGH_articlepoll_pagetype"/>
	<xsl:variable name="m_linktoarticlepoll">Click here to return to the article</xsl:variable>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="articlepoll_pagetype">
		<a href="{$root}A{/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='dnaid']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_articlepoll_pagetype">
			<xsl:copy-of select="$m_linktoarticlepoll"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mREGISTER-PASSTHROUGH_addcommenttsp_pagetype"/>
	<xsl:variable name="m_linktoaddcommenttsp">Click here to start your discussion</xsl:variable>
	<xsl:template match="REGISTER-PASSTHROUGH" mode="addcommenttsp_pagetype">
		<a href="{$root}AddThread?forum={/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='forum']}" xsl:use-attribute-sets="mREGISTER-PASSTHROUGH_addcommenttsp_pagetype">
			<xsl:copy-of select="$m_linktoaddcommenttsp"/>
		</a>

	</xsl:template>
</xsl:stylesheet>
