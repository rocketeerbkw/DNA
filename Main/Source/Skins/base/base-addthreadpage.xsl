<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<!--
	<xsl:template name="ADDTHREAD_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ADDTHREAD_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_posttoaforum"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="ADDTHREAD_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="ADDTHREAD_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="POSTTHREADUNREG">
						<xsl:value-of select="$m_greetingshiker"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_posttoaforum"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="ADDTHREADINTRO" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/ADDTHREADINTRO
	Purpose:	 Calls the container for the INTRO (if there is one)
	-->
	<xsl:template match="ADDTHREADINTRO" mode="c_addthread">
		<xsl:apply-templates select="." mode="r_addthread"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/ERROR
	Purpose:	 Calls the container for the ERROR (if there is one)
	-->
	<xsl:template match="ERROR" mode="c_addthread">
		<xsl:apply-templates select="." mode="r_addthread"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/ERROR
	Purpose:	 Chooses the correct text for the ERROR
	-->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:choose>
			<xsl:when test="@TYPE='REVIEWFORUM'">
			Sorry but you have attempted to add a post to the <xsl:value-of select="REVIEWFORUM/REVIEWFORUMNAME"/> Forum. This is not allowed.
			</xsl:when>
			<xsl:when test="@TYPE='BADREVIEWFORUM'">
			You have attempted to post to a review forum this is not allowed.
			</xsl:when>
			<xsl:when test="@TYPE='DBERROR'">
			There was a database error
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Calls the container for the POSTTHREADFORM object
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_addthread">
		<xsl:if test="not(../ERROR)">
			<xsl:apply-templates select="." mode="r_addthread"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADUNREG" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADUNREG
	Purpose:	 Calls the container for the POSTTHREADUNREG object
	-->
	<xsl:template match="POSTTHREADUNREG" mode="c_addthread">
		<xsl:if test="not(../ERROR)">
			<xsl:apply-templates select="." mode="r_addthread"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="c_addthread">
	Author:		Tom Whitehouse / Andy Harris
	Context:      /H2G2/POSTPREMODERATED
	Purpose:	 Calls the container for the POSTPREMODERATED object
	-->
	<xsl:template match="POSTPREMODERATED" mode="c_addthread">
		<xsl:if test="not(../ERROR)">
			<xsl:choose>
				<xsl:when test="@AUTOSINBIN = 1">
					<xsl:apply-templates select="." mode="r_autopremod"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="r_addthread"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
  <!--
	<xsl:template match="POSTQUEUED" mode="c_addthread">
	Author:		Jim Lynn
	Context:      /H2G2/POSTPREMODERATED
	Purpose:	 Calls the container for the POSTPREMODERATED object
	-->
  <xsl:template match="POSTQUEUED" mode="c_addthread">
    <xsl:if test="not(../ERROR)">
      <xsl:apply-templates select="." mode="r_addthread"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="PROMPTSETUSERNAME" mode="c_addthread">
	Author:		Jim Lynn
	Context:      /H2G2/VIEWING-USER/USER/PROMPTSETUSERNAME
	Purpose:	 Calls the container for the PROMPTSETUSERNAME object
	-->
  <xsl:template match="PROMPTSETUSERNAME" mode="c_addthread">
    <xsl:if test="not(../ERROR)">
      <xsl:apply-templates select="." mode="r_addthread"/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template match="POSTTHREADFORM" mode="c_preview">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Calls the container for the POSTTHREADFORM preview object
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_preview">
		<xsl:apply-templates select="." mode="r_preview"/>
	</xsl:template>
	<!--
	<xsl:template match="PREVIEWERROR" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/PREVIEWERROR
	Purpose:	 Calls the container for the PREVIEWERROR object
	-->
	<xsl:template match="PREVIEWERROR" mode="c_addthread">
		<xsl:apply-templates select="." mode="r_addthread"/>
	</xsl:template>
	<!--
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/PREVIEWERROR
	Purpose:	 Calls the correct text for the type of PREVIEWERROR
	-->
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
		<xsl:choose>
			<xsl:when test="@TYPE = 'TOOLONG'">
				<xsl:value-of select="$m_postingtoolong"/>
			</xsl:when>
			<xsl:when test="@TYPE = 'TOOMANYSMILEYS'">
				<xsl:value-of select="$m_PostTooManySmileys"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="c_previewbody">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Calls the container for the POSTTHREADFORM preview object
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_previewbody">
		<xsl:if test="PREVIEWBODY">
			<xsl:apply-templates select="." mode="r_previewbody"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="t_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/VIEWING-USER/USER/USERID
	Purpose:	 Creates the USERNAME link 
	-->
	<xsl:template match="USERID" mode="t_addthread">
		<a use-attribute-sets="mUSERID_UserName" href="{$root}U{.}">
			<xsl:apply-templates select="../USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="PREVIEWBODY" mode="t_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/PREVIEWBODY
	Purpose:	 Calls the GuideML for the PREVIEWBODY 
	-->
	<xsl:template match="PREVIEWBODY" mode="t_addthread">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="c_form">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Calls the container for the POSTTHREADFORM form 
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_form">
		<form method="post" action="{$root}AddThread" name="theForm" xsl:use-attribute-sets="fPOSTTHREADFORM_c_contententry">
			<xsl:apply-templates select="." mode="r_form"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="c_contententry">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the form element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_contententry">
		<!--input type="hidden" name="skin" value="purexml"/-->
		<input type="hidden" name="threadid" value="{@THREADID}"/>
		<input type="hidden" name="forum" value="{@FORUMID}"/>
		<input type="hidden" name="inreplyto" value="{@INREPLYTO}"/>
		<xsl:if test="/H2G2/POSTTHREADFORM/ACTION">
			<input type="hidden" name="action" value="{/H2G2/POSTTHREADFORM/ACTION}"/>
		</xsl:if>
		<xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="r_contententry"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_subjectfield">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the subject field element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_subjectfield">
		<input type="text" xsl:use-attribute-sets="iPOSTTHREADFORM_t_subjectfield" name="subject"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_bodyfield">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the body field element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_bodyfield">
		<textarea name="body" xsl:use-attribute-sets="iPOSTTHREADFORM_t_bodyfield">
			<xsl:value-of select="BODY"/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_previewpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the preview button element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_previewpost">
		<input name="preview" xsl:use-attribute-sets="iPOSTTHREADFORM_t_previewpost"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_submitpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Creates the submit button element for the POSTTHREADFORM
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_submitpost">
    <input name="post" xsl:use-attribute-sets="iPOSTTHREADFORM_t_submitpost"/>
    <!--<input type="hidden" name="skin" value="purexml"/>-->
  </xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_returntoconversation">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Chooses the 'Return to...' link
	-->
	<xsl:template match="POSTTHREADFORM" mode="t_returntoconversation">
		<xsl:choose>
			<xsl:when test="ACTION">
				<a href="{$root}{ACTION}" xsl:use-attribute-sets="mPOSTTHREADFORM_t_returntoconversation">
					<xsl:choose>
						<xsl:when test="starts-with(ACTION, 'A')">
							<xsl:copy-of select="$m_returntoconv"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$m_returntoclub"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:when>
			<xsl:when test="@INREPLYTO &gt; 0">
				<xsl:apply-templates select="@FORUMID" mode="ReturnToConv"/>
			</xsl:when>
			<xsl:when test="RETURNTO">
				<xsl:apply-templates select="RETURNTO"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@FORUMID" mode="ReturnToConv1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="t_returntoconversation">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM/RETURNTO/H2G2ID
	Purpose:	 Creates the 'Return to Entry' link
	-->
	<xsl:template match="RETURNTO/H2G2ID">
		<a xsl:use-attribute-sets="mRETURNTOH2G2ID">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="."/></xsl:attribute>
			<xsl:copy-of select="$m_returntoentry"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@FORUMID" mode="ReturnToConv1">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM/@FORUMID
	Purpose:	 Creates the 'Return to Conversation' link
	-->
	<xsl:template match="@FORUMID" mode="ReturnToConv1">
		<a xsl:use-attribute-sets="maFORUMID_ReturnToConv1">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="../@INREPLYTO"/>#p<xsl:value-of select="../@INREPLYTO"/></xsl:attribute>
			<xsl:copy-of select="$m_returntoconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@FORUMID" mode="ReturnToConv">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM/@FORUMID
	Purpose:	 Creates the 'Return to Conversation' link
	-->
	<xsl:template match="@FORUMID" mode="ReturnToConv">
		<a xsl:use-attribute-sets="maFORUMID_ReturnToConv">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="../@INREPLYTO"/>#p<xsl:value-of select="../@INREPLYTO"/></xsl:attribute>
			<xsl:copy-of select="$m_returntoconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="INREPLYTO" mode="c_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM/@INREPLYTO
	Purpose:	 Calls the @INREPLYTO container
	-->
	<xsl:template match="INREPLYTO" mode="c_addthread">
		<xsl:apply-templates select="." mode="r_addthread"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADUNREG
	Purpose:	 Calls the correct POSTTHREADUNREG error message
	-->
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
		<xsl:choose>
			<xsl:when test="@RESTRICTED = 1">
				<xsl:call-template name="m_cantpostrestricted"/>
			</xsl:when>
			<xsl:when test="@REGISTERED = 1">
				<xsl:call-template name="m_cantpostnoterms"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="m_cantpostnotregistered"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTTHREADFORM" mode="c_premoderationmessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTTHREADFORM
	Purpose:	 Calls the correct PREMODERATION message
	-->
	<xsl:template match="POSTTHREADFORM" mode="c_premoderationmessage">
		<xsl:choose>
			<xsl:when test="PREMODERATION[@USER=1]">
				<xsl:apply-templates select="." mode="user_premoderationmessage"/>
			</xsl:when>
			<xsl:when test="PREMODERATION=1">
				<xsl:apply-templates select="." mode="site_premoderationmessage"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
		<xsl:attribute name="size">25</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
		<xsl:attribute name="cols">45</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$alt_previewmess"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$alt_postmess"/></xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:template match="POSTTHREADFORM" mode="c_tags">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_tags"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="POSTTHREADFORM" mode="t_tagsinput">
		
		<input name="phrase" xsl:use-attribute-sets="iPOSTTHREADFORM_t_tagsinput"/>
	</xsl:template>
	<xsl:attribute-set name="iPOSTTHREADFORM_t_tagsinput">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="value">	
			<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)]">
				<xsl:value-of select="NAME"/>
				<xsl:if test="not(position() = last())">
					<xsl:text> </xsl:text>
				</xsl:if>			
		</xsl:for-each>
		</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template match="PHRASE" mode="c_addthread">
		<xsl:apply-templates select="." mode="r_addthread"/>
	</xsl:template>
	
</xsl:stylesheet>
