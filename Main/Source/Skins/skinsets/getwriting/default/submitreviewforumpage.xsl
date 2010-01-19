<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-submitreviewforumpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="SUBMITREVIEWFORUM_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">SUBMITREVIEWFORUM_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">submitreviewforupage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:choose>
	<xsl:when test="SUBMIT-REVIEW-FORUM/NEW-THREAD">
	
	</xsl:when>
	<xsl:otherwise>
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<div class="PageContent">
	<div class="titleBars" id="titleCreative">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	SUBMIT FOR REVIEW
	</xsl:element>
	</div>
	<br/>
	<xsl:apply-templates select="SUBMIT-REVIEW-FORUM" mode="c_srfpage"/>
	</div>
		
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">

		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.submitreview.tips" />
		</div>
		</xsl:element>
		
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	
	</xsl:otherwise>
	</xsl:choose>

	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="reviewforums_srfpage">
	Use: Container for the text and calls to the form and any error messages
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="reviewforums_srfpage">
	
		<xsl:apply-templates select="ERROR" mode="c_errormessage"/>
		<xsl:apply-templates select="." mode="c_submitform"/>
		<br/>
		<!-- <xsl:copy-of select="$m_srffinaltext"/> -->
		
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="r_errormessage">
	Use: Container for any error messages that appear with the submission form
	-->
	<xsl:template match="ERROR" mode="r_errormessage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="r_errormessage">
	Use: Container for the submission form
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="r_submitform">
	<!--  
		<input type="hidden" name="skin" value="purexml"/> 
		<xsl:apply-templates select="REVIEWFORUMS" mode="t_forumselect"/>
	--> 
	<xsl:param name="pagetype" select="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE"/>
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	<input type="hidden" name="reviewforumid" value="{msxsl:node-set($type)/type[@number=$pagetype or @selectnumber=$pagetype]/@reviewforumid}"/>

	<div class="box2">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		You are submitting the work<br/>
		</xsl:element>
		<div class="heading1">
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:value-of select="ARTICLE" />
		</xsl:element>
		</div>
	</div>
	<div class="boxsection">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>INTRODUCTION</strong><br/>
		Don't paste your creative work here! 
		</xsl:element>
		<br/>
		<xsl:apply-templates select="." mode="t_responsetext"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submit"/>
	</div>
	
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="newthread_srfpage">
	Use: Container for the new thread message
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="newthread_srfpage">


	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
	Use: Container for the error message without submission form
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
		<xsl:apply-templates select="ERROR" mode="c_error"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
	Use: Container for the bad h2g2 id error message
	-->
	<xsl:template match="ERROR" mode="badh2g2id_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_badh2g2idlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="badrfid_error">
	Use: Container for the bad review forum id error message
	-->
	<xsl:template match="ERROR" mode="badrfid_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_badrfidlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="default_error">
	Use: Container for any default error messages
	-->
	<xsl:template match="ERROR" mode="default_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_defaultlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="movedthread_srfpage">
	Use: Container for the thread moved message
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="movedthread_srfpage">

	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<p>The Work, <a href="A{MOVEDTHREAD/H2G2ID}"><xsl:value-of select="MOVEDTHREAD/SUBJECT" /></a> has been successfully removed from the Review Forum '<a href="RF{MOVEDTHREAD/REVIEWFORUM/@ID}"><xsl:value-of select="MOVEDTHREAD/REVIEWFORUM/REVIEWFORUMNAME" /></a>'.</p>
	
	<p>The relevant Review Conversation has been moved to the Conversation Forum for the Work itself, and the Work will no longer appear in any Review Forums. </p>
	</xsl:element>	
	
	</xsl:template>
<!--
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_submitform">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM
	Purpose:	 Calls the container for the form object
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_submitform">
		<form method="POST" action="{$root}SubmitReviewForum" xsl:use-attribute-sets="fSUBMIT-REVIEW-FORUM_c_submitform">
			<input type="HIDDEN" name="action" value="submitarticle"/>
			<input type="HIDDEN" name="h2g2id" value="{ARTICLE/@H2G2ID}"/>
			<xsl:apply-templates select="." mode="r_submitform"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMS" mode="t_forumselect">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/REVIEWFORUMS
	Purpose:	 Creates the select review forum dropdown
	-->
	<xsl:template match="REVIEWFORUMS" mode="t_forumselect">
		<select name="reviewforumid" xsl:use-attribute-sets="sREVIEWFORUMS_t_forumselect">
			<option value="{FORUMNAME/@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">
				<xsl:value-of select="$m_dropdownpleasechooseone"/>
			</option>
			<option value="{FORUMNAME/@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">-----------------</option>
			<xsl:for-each select="FORUMNAME">
				<xsl:sort select="."/>
				<option value="{@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">
					<xsl:if test="@SELECTED">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="."/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="oREVIEWFORUMS_t_forumselect"/>
	Use: Attribute set for the option element
	-->
	<xsl:attribute-set name="oREVIEWFORUMS_t_forumselect"/>
	<!-- 
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_responsetext">
	Use: Attribute set for the textarea element
	-->
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_responsetext">
		<xsl:attribute name="cols">45</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_submit">
	Use: Attribute set for the submit element
	-->
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_submit"  use-attribute-sets="form.submit" />

</xsl:stylesheet>
