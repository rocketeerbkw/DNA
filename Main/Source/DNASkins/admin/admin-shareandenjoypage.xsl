<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="SHAREANDENJOY_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_shareandenjoytitle"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SHAREANDENJOY_MAINBODY">
		<br/>
		<!-- First put up any error messages -->
		<xsl:choose>
			<xsl:when test="SHAREANDENJOY[@STATUS='BADEMAIL']">
				<xsl:call-template name="m_sharebademail"/>
			</xsl:when>
			<xsl:when test="SHAREANDENJOY[@STATUS='NOMESSAGE']">
				<xsl:call-template name="m_sharenomessage"/>
			</xsl:when>
			<xsl:when test="SHAREANDENJOY[@STATUS='ALREADYJOINED']">
				<xsl:call-template name="m_sharealreadyjoined"/>
			</xsl:when>
			<xsl:when test="SHAREANDENJOY[@STATUS='ALREADYASKED']">
				<xsl:call-template name="m_sharealreadyasked"/>
			</xsl:when>
			<xsl:when test="SHAREANDENJOY[@STATUS='UNREGISTERED']">
				<xsl:call-template name="m_shareunregistered"/>
			</xsl:when>
			<xsl:when test="SHAREANDENJOY[@STATUS='SUCCESS']">
				<xsl:call-template name="m_sharesuccess"/>
			</xsl:when>
		</xsl:choose>
		<!-- Now put up the form if appropriate -->
		<xsl:if test="SHAREANDENJOY[@STATUS='INITIAL']">
			<xsl:call-template name="m_shareandenjoyintro"/>
		</xsl:if>
		<xsl:if test="SHAREANDENJOY[contains('INITIAL.NOMESSAGE.BADEMAIL.ALREADYJOINED.ALREADYASKED',@STATUS)]">
			<FORM METHOD="POST" action="{$root}ShareAndEnjoy">
				<xsl:value-of select="$m_emailaddress"/>
				<INPUT TYPE="TEXT" NAME="email" VALUE="{SHAREANDENJOY/EMAILADDRESS}"/>
				<br/>
				<xsl:value-of select="$m_welcomemessage"/>
				<br/>
				<TEXTAREA ROWS="10" COLS="50" NAME="welcome">
					<xsl:value-of select="SHAREANDENJOY/MESSAGE"/>
				</TEXTAREA>
				<br/>
				<INPUT TYPE="SUBMIT" NAME="invite" VALUE="{$alt_inviteuser}"/>
				<!--<br/><INPUT TYPE="TEXT" NAME="skin" VALUE=""/>-->
			</FORM>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>