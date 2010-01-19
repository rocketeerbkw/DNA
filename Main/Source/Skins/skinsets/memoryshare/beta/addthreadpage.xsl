<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addthreadpage.xsl"/>
	<!--
	ADDTHREAD_MAINBODY
	
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ADDTHREAD_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Comment</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="ADDTHREAD_MAINBODY">
	
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ADDTHREAD_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<div id="topPage">
			<div class="innerWide">
				<div id="shortDescForm">
					<h2>Post a comment</h2>									
		
					<!--[FIXME: is this necessary?]
					<xsl:choose>
						<xsl:when test="POSTPREMODERATED">
							<h3>Thanks for your comment</h3>
						</xsl:when>
						<xsl:when test="POSTTHREADFORM/PREVIEWBODY">
							<h3>preview your comment</h3>
							<p>You can edit your comment below - when you're happy with it, click publish</p>
						</xsl:when>
						<xsl:otherwise>
							<h3>write a comment</h3>
							<p>Type your comment in the box below and click 'preview' to see what it will look like</p>
						</xsl:otherwise>
					</xsl:choose>
					-->
					<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/>
					<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
					<xsl:apply-templates select="POSTTHREADFORM" mode="c_form"/>
					<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
					<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
					<xsl:apply-templates select="ERROR" mode="c_addthread"/>
				</div>
			</div>
		</div>
		<div class="tear"><hr/></div>
	</xsl:template>
	<!-- 
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
	Use: Presentation of an introduction to a particular thread - defined in the article XML
	-->
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						POSTTHREADFORM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
	Use: The presentation of the form that generates a post. It has a preview area - ie what the post
	will look like when submitted, and a form area.
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
			<p>
			You are commenting on <a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></a>
			</p>
			<xsl:apply-templates select="." mode="c_preview"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
	Use: The presentation of the preview - this can either be an error or a normal display
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_preview"> 
		<xsl:apply-templates select="PREVIEWERROR" mode="c_addthread"/>
		<xsl:apply-templates select="." mode="c_previewbody"/>
	</xsl:template>
	<!-- 
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Use: presentation of the preview if it is an error
	-->
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
		<p><xsl:apply-imports/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
		<div class="commenth">Comment by <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="t_addthread"/></div>
		<div class="commentbox">
			<p class="posted"><xsl:copy-of select="$m_postedsoon2"/></p>
			<p>
				<xsl:variable name="body_rendered">
					<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
				</xsl:variable>
				<xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
				<!--
				<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
				-->
			</p>
		</div>
		
		<!--
		<div class="compreview">
			<p>
				<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
			</p>
		</div>
		-->
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
		<xsl:apply-templates select="." mode="c_premoderationmessage"/>
		<xsl:apply-templates select="." mode="c_contententry"/>
		
		<p><xsl:apply-templates select="." mode="t_returntoconversation"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
		<p><xsl:copy-of select="$m_userpremodmessage"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
		<p><xsl:copy-of select="$m_PostSitePremod"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
	<xsl:template match="INREPLYTO" mode="r_addthread">
		<p><b><xsl:value-of select="$m_messageisfrom"/></b><xsl:value-of select="USERNAME"/><br/>
		<xsl:apply-templates select="BODY"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	
		<xsl:if test="/H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED = 1">
			<p class="errortext alert">This comment has been blocked as it contains a word which other users may find offensive. Please edit your comment and post it again.<br/>&nbsp;<br/></p>
		</xsl:if>
	
		<xsl:apply-templates select="SECONDSBEFOREREPOST"/>
		<input type="hidden" name="subject" value="{/H2G2/FORUMSOURCE/ARTICLE/SUBJECT}"/>
		
		<label for="description">comment</label><br/>
		<textarea name="body" id="description" rows="4" virtual="wrap">
			<xsl:value-of select="BODY"/>
		</textarea>		
		
		<div class="rAlign">
			<input value="Preview" type="submit" name="preview" class="submit" />
			<input value="Publish" type="submit" name="post" class="submit" />
		</div>
	</xsl:template>
	
	
	<xsl:template match="SECONDSBEFOREREPOST">
	<script type="text/javascript">
	function countDown() {
		var minutesSpan = document.getElementById("minuteValue");
		var secondsSpan = document.getElementById("secondValue");
		
		var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
		var seconds = new Number(secondsSpan.childNodes[0].nodeValue);
			
		var inSeconds = (minutes*60) + seconds;
		var timeNow = inSeconds - 1;			
			
		if (timeNow >= 0){
			var scratchPad = timeNow / 60;
			var minutesNow = Math.floor(scratchPad);
			var secondsNow = (timeNow - (minutesNow * 60));			
				
			var minutesText = document.createTextNode(minutesNow);
			var secondsText = document.createTextNode(secondsNow);
			
			minutesSpan.removeChild(minutesSpan.childNodes[0]);
			secondsSpan.removeChild(secondsSpan.childNodes[0]);
				
			minutesSpan.appendChild(minutesText);
			secondsSpan.appendChild(secondsText);
		}
	}
	</script>
	
	
		<xsl:variable name="minutestowait">
			<xsl:value-of select="floor(/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST div 60)" />
		</xsl:variable>
		
		<xsl:variable name="secondsstowait">
			<xsl:value-of select="/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST mod 60" />
		</xsl:variable>
	
		<p id="countdown"><strong>You must wait  <span id="minuteValue"><xsl:value-of select="$minutestowait"/></span> minutes  <span id="secondValue"><xsl:value-of select="$secondsstowait"/></span> secs before you can post again</strong></p>
	</xsl:template>
	
	
	
	<!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>

	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield"/>
	
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost"/>

	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost"/>

	<!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Use: Message displayed if reply is attempted when unregistered
	 -->
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
		<p><xsl:apply-imports/></p>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
		<div class="bodysec2 bodytxt">
			<xsl:call-template name="m_posthasbeenpremoderated"/>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
	Use: Presentation of the 'Post has been auto premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
		<div class="bodysec2 bodytxt">
			<xsl:call-template name="m_posthasbeenautopremoderated"/>
		</div>
	</xsl:template>
	
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:apply-imports/>
	</xsl:template>


	<!--- override from base-addthreadpage.xsl -->
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

</xsl:stylesheet>
