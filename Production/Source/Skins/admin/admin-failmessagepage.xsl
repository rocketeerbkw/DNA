<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="failmessageparameters"><![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='FORUMID'/>
		<REQUIRED NAME='THREADID'/>
		<REQUIRED NAME='POSTID'/>
		<REQUIRED NAME='EMAILTYPE'><VALIDATE TYPE='NEQ' VALUE='none'/></REQUIRED>
		<REQUIRED NAME='CUSTOMTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='EMAILTEXTPREVIEW' ESCAPED='1'/>
		<REQUIRED NAME='INTERNALNOTES'><VALIDATE TYPE='EMPTY'/></REQUIRED>
	</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="m_stagetwosubmit">Next</xsl:variable>
	<xsl:variable name="m_laststagesubmit">Finish</xsl:variable>
	<!--
	<xsl:template name="FAILMESSAGE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="FAILMESSAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA - Fail Message
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="FAILMESSAGE_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="FAILMESSAGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Fail Message
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="FAILMESSAGE_MAINBODY">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Mainbody template
	-->
	<xsl:template name="FAILMESSAGE_MAINBODY">
		<font size="2">
			<xsl:apply-templates select="FAILMESSAGE" mode="errormessages"/>
			<xsl:apply-templates select="FAILMESSAGE" mode="failureform"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="failureform">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE
	Purpose:	 Template that selects which stage of the fail message process you are at
	-->
	<xsl:template match="FAILMESSAGE" mode="failureform">
		<form action="FailMessage" METHOD="GET">
			<input type="hidden" name="forumid" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'FORUMID']/VALUE}"/>
			<input type="hidden" name="threadid" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'THREADID']/VALUE}"/>
			<input type="hidden" name="postid" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'POSTID']/VALUE}"/>
			<input type="hidden" name="_msxml" value="{$failmessageparameters}"/>
			<xsl:choose>
				<xsl:when test="MULTI-STAGE/@FINISH = 'YES'">
					<xsl:apply-templates select="." mode="finished_failureform"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@STAGE = 1">
					<xsl:apply-templates select="." mode="stageone_failureform"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@STAGE = 2">
					<xsl:apply-templates select="." mode="stagetwo_failureform"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@STAGE = 3">
					<xsl:apply-templates select="." mode="stagethree_failureform"/>
				</xsl:when>
			</xsl:choose>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="finished_failureform">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE
	Purpose:	 Text that appears when the message has been failed
	-->
	<xsl:template match="FAILMESSAGE" mode="finished_failureform">
		<strong>The message has been failed</strong>
		<br/>
		<br/>
		<a href="{$root}F{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'FORUMID']/VALUE}?thread={MULTI-STAGE/MULTI-REQUIRED[@NAME = 'THREADID']/VALUE}&amp;post={MULTI-STAGE/MULTI-REQUIRED[@NAME = 'POSTID']/VALUE}">Back to the board</a>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="stageone_failureform">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE
	Purpose:	 Form for the first stage of the failure process
	-->
	<xsl:template match="FAILMESSAGE" mode="stageone_failureform">
		<input type="hidden" name="_msstage" value="1"/>
		<select name="emailtype">
			<option value="None" selected="1">Failure reason:</option>
			<option value="OffensiveInsert">Offensive</option>
			<option value="LibelInsert">Libellous</option>
			<option value="URLInsert">Unsuitable/Broken URL</option>
			<option value="PersonalInsert">Personal Details</option>
			<option value="AdvertInsert">Advertising</option>
			<option value="CopyrightInsert">Copyright Material</option>
			<option value="PoliticalInsert">Contempt Of Court</option>
			<option value="IllegalInsert">Illegal Activity</option>
			<option value="SpamInsert">Spam</option>
			<option value="CustomInsert">Custom (enter below)</option>
		</select>
		<br/>
		Internal notes:
		<br/>
		<textarea cols="60" rows="4" name="internalnotes">
			<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'INTERNALNOTES']/VALUE"/>
		</textarea>
		<br/>
		<input type="submit" name="next" value="Next"/>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="stagetwo_failureform">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE
	Purpose:	 Form for the second stage of the failure process
	-->
	<xsl:template match="FAILMESSAGE" mode="stagetwo_failureform">
		<input type="hidden" name="_msstage" value="2"/>
		<input type="hidden" name="emailtype" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTYPE']/VALUE}"/>
		<input type="hidden" name="internalnotes" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'INTERNALNOTES']/VALUE}"/>
		<xsl:if test="not(MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTYPE']/VALUE = 'CustomInsert')">
			<input type="hidden" name="_msfinish" value="yes"/>
		</xsl:if>
		Email text:
		<br/>
		<textarea readonly="1" cols="60" rows="10">
			<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTEXTPREVIEW']/VALUE-EDITABLE"/>
		</textarea>
		<br/>
		<xsl:if test="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTYPE']/VALUE = 'CustomInsert'">
			Add comment here:
			<br/>
			<textarea name="customtext" cols="60" rows="4">
				<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'CUSTOMTEXT']/VALUE"/>
			</textarea>
		</xsl:if>
		<br/>
		<xsl:choose>
			<xsl:when test="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTYPE']/VALUE = 'CustomInsert'">
				<input type="submit" name="next" value="{$m_stagetwosubmit}"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="submit" name="finish" value="{$m_laststagesubmit}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="stagethree_failureform">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE
	Purpose:	 Form for the third stage of the failure process
	-->
	<xsl:template match="FAILMESSAGE" mode="stagethree_failureform">
		<input type="hidden" name="_msstage" value="3"/>
		<input type="hidden" name="emailtype" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTYPE']/VALUE}"/>
		<input type="hidden" name="internalnotes" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'INTERNALNOTES']/VALUE}"/>
		<input type="hidden" name="customtext" value="{MULTI-STAGE/MULTI-REQUIRED[@NAME = 'CUSTOMTEXT']/VALUE}"/>
		<input type="hidden" name="_msfinish" value="yes"/>
		Email text:
		<br/>
		<textarea readonly="1" cols="60" rows="10">
			<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME = 'EMAILTEXTPREVIEW']/VALUE-EDITABLE"/>
		</textarea>
		<br/>
		<input type="submit" name="finish" value="{$m_laststagesubmit}"/>
	</xsl:template>
	<!--
	<xsl:template match="FAILMESSAGE" mode="errormessages">
	Author:		Andy Harris
	Context:      H2G2/FAILEMESSAGE
	Purpose:	 Template which deals with error messages
	-->
	<xsl:template match="FAILMESSAGE" mode="errormessages">
		<xsl:if test="MULTI-STAGE/MULTI-REQUIRED[ERRORS] or MULTI-STAGE/MULTI-ELEMENT[ERRORS]">
			<xsl:variable name="errormessages">
				<xsl:for-each select="MULTI-STAGE/MULTI-REQUIRED[ERRORS]">
					<xsl:for-each select="ERRORS/ERROR">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="MULTI-STAGE/MULTI-ELEMENT[ERRORS]">
					<xsl:for-each select="ERRORS/ERROR">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:variable>
			<xsl:apply-templates select="msxsl:node-set($errormessages)/ERROR" mode="errormessage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="errormessage">
	Author:		Andy Harris
	Context:      H2G2/FAILMESSAGE/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR or H2G2/FAILMESSAGE/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR
	Purpose:	 Creates the text for the error messages 
	-->
	<xsl:template match="ERROR" mode="errormessage">
		<xsl:value-of select="@TYPE"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
