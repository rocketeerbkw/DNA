<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-typedarticle.xsl"/>
	
	<xsl:variable name="userintrofields">
			<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'></REQUIRED>
			<ELEMENT NAME='BIOGLINKS1TITLE'></ELEMENT>
			<ELEMENT NAME='BIOGLINKS1URL'></ELEMENT>
			<ELEMENT NAME='BIOGLINKS2TITLE'></ELEMENT>
			<ELEMENT NAME='BIOGLINKS2URL'></ELEMENT>
			<ELEMENT NAME='BIOGLINKS3TITLE'></ELEMENT>
			<ELEMENT NAME='BIOGLINKS3URL'></ELEMENT>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="articlefields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='GRAPHICTITLE'></ELEMENT>
			<ELEMENT NAME='COL2'></ELEMENT>
		</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="categoryarticlefields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY' EI='add'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE' EI='add'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='GRAPHICTITLE'></ELEMENT>
			<ELEMENT NAME='COL2'></ELEMENT>
		</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="imagearticlefields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='FILE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='MEDIAASSETKEYPHRASES'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='ORIGINYEAR'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINMONTH'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINDAY'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS1TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS1URL'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS2TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS2URL'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS3TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS3URL'></ELEMENT>
			<ELEMENT NAME='REFERENCES'></ELEMENT>
			<ELEMENT NAME='SUBMISSIONAGREEMENT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='POLLTYPE1'></ELEMENT>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT_DESC' EI='add'></ELEMENT>
			<ELEMENT NAME='PCCAT' EI='add'></ELEMENT>
			<ELEMENT NAME='MEDIAASSETID' EI='add'></ELEMENT>
		   </MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="audioarticlefields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='FILE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='MEDIAASSETKEYPHRASES'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='ORIGINYEAR'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINMONTH'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINDAY'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='DURATION_MINS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DURATION_SECS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS1TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS1URL'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS2TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS2URL'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS3TITLE'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS3URL'></ELEMENT>
			<ELEMENT NAME='REFERENCES'></ELEMENT>
			<ELEMENT NAME='SUBMISSIONAGREEMENT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='POLLTYPE1'></ELEMENT>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT_DESC' EI='add'></ELEMENT>
			<ELEMENT NAME='SUBMISSION_METHOD' EI='add'></ELEMENT>
			<ELEMENT NAME='PCCAT' EI='add'></ELEMENT>
			<ELEMENT NAME='MEDIAASSETID' EI='add'></ELEMENT>
		   </MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="videoarticlefields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='FILE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='MEDIAASSETKEYPHRASES'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='ORIGINYEAR'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINMONTH'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINDAY'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='DURATION_MINS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DURATION_SECS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='ASPECTRATIO' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS1'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS2'></ELEMENT>
			<ELEMENT NAME='RELATEDLINKS3'></ELEMENT>
			<ELEMENT NAME='REFERENCES'></ELEMENT>
			<ELEMENT NAME='SUBMISSIONAGREEMENT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='POLLTYPE1'></ELEMENT>
			<ELEMENT NAME='EXTERNALLINKURL'></ELEMENT>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT' EI='add'></ELEMENT>
			<ELEMENT NAME='STRONG_CONTENT_DESC' EI='add'></ELEMENT>
			<ELEMENT NAME='SUBMISSION_METHOD' EI='add'></ELEMENT>
			<ELEMENT NAME='PCCAT' EI='add'></ELEMENT>
			<ELEMENT NAME='MEDIAASSETID' EI='add'></ELEMENT>
		   </MULTI-INPUT>]]>
	</xsl:variable>
	
	<!-- NOTES - CONTACT are editorial only -->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">TYPED-ARTICLE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<xsl:apply-templates select="PARSEERRORS" mode="c_typedarticle"/>
		<xsl:apply-templates select="ERROR" mode="c_typedarticle"/>
		<xsl:apply-templates select="DELETED" mode="c_article"/>
		<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
		
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_article">
	
		<input type="hidden" name="DATECREATED" value="{/H2G2/DATE/@SORT}"/>
		<input type="hidden" name="_msfinish" value="yes"/>
		<!-- <input type="hidden" name="skin" value="purexml"/> -->
		<!-- preview -->
		<xsl:apply-templates select="." mode="c_preview"/>
		
		
		<xsl:choose>
			<!-- create / edit biog  -->
			<xsl:when test="$current_article_type=3001">
				<xsl:call-template name="PROFILE_FORM" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='audio' or /H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='video'">
				<!-- CHOOSE TO EMAIL OR POST -->
				<xsl:call-template name="EMAIL_OR_POST" />
			</xsl:when>
			<xsl:when test="$contenttype=1 or $contenttype=2 or $contenttype=3">
				<!-- MEDIA ASSET ARTICLE -->
				<xsl:call-template name="MEDIA_ASSET_FORM" />
			</xsl:when>
			<xsl:when test="$current_article_type=4001">
				<xsl:call-template name="CATEGORY_ARTICLE_FORM" />
			</xsl:when>
			<xsl:otherwise>
				<!-- EDITORIAL ARTICLE -->
				<xsl:choose>
					<xsl:when test="$current_article_type = 1">
					<h1>Editorial Article</h1>
					</xsl:when>
					<xsl:when test="$current_article_type = 3">
					<h1>Asset Library Article</h1>
					</xsl:when>
				</xsl:choose>
				
				<xsl:call-template name="EDITORIAL_ARTICLE_FORM" />
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$test_IsEditor">
		<div class="editbox" style="margin-top:10px;">
			<!-- Editors Tools -->
			<xsl:apply-templates select="." mode="c_permissionchange"/>
			<xsl:apply-templates select="." mode="c_articlestatus"/>
			<xsl:apply-templates select="." mode="c_articletype"/>
			<xsl:apply-templates select="." mode="c_makearchive"/>
			<xsl:apply-templates select="." mode="c_deletearticle"/>
			<xsl:apply-templates select="." mode="c_hidearticle"/>
			<xsl:apply-templates select="." mode="c_poll"/>
			<xsl:apply-templates select="." mode="t_strongcontent"/>
			<xsl:apply-templates select="." mode="t_strongcontentdescription"/>	
		</div>
		</xsl:if>
		
	</xsl:template>
	
	
	
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assetupload">
	Use: Presentation of the 'upload an asset' box
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assetupload">
		<xsl:choose>
			<xsl:when test="$contenttype=1">
				<div class="formRow">
					<label for="upload">Choose an image to upload*</label><br />
					<xsl:apply-templates select="." mode="t_imageuploadfield"/>
				</div>
			</xsl:when>
			<xsl:when test="$contenttype=2"/>
			<xsl:when test="$contenttype=3"/>
		</xsl:choose>
		
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-REQUIRED" mode="r_taassetmimetype">
	Use: Presentation of the 'Select a mimetype' object
	-->
	<xsl:template match="MULTI-REQUIRED" mode="r_taassetmimetype">
		<xsl:if test="not($contenttype=1)">
			<div class="formRow">
					<label for="mediaType">What are you submitting?</label><br />
					<xsl:apply-templates select="." mode="c_tamimetypeselect"/>
				</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="MULTI-REQUIRED" mode="r_tamimetypeselect">
		<xsl:choose>
			<xsl:when test="$contenttypepath=2">
				<select name="mimetype">
					<option value="rm">RM (Real Media)</option>			
					<option value="ra">RA (Real Audio)</option>			
					<option value="wma">WMA (Windows Media Audio)</option>		
				</select>
			</xsl:when>
			<xsl:when test="$contenttypepath=3">
				<select name="mimetype">
					<option value="rm">RM (Real Media)</option>			
					<option value="wmv">WMV (Windows Media Video)</option>				
				</select>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assettags">	
	Use: presentation of the 'choose some tags' box
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<xsl:variable name="pccat">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_pccat']/VALUE"/></xsl:when>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/PCCAT"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/PCCAT"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="is_programme_challenge">
			<xsl:choose>
				<xsl:when test="$pccat!=0 and /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="programme_challenge_name" select=" /H2G2/SITECONFIG/PROGRAMMECHALLENGESCONFIG/PROGRAMMECHALLENGE[@CATEGORY=$pccat]/DISPLAYNAME"/>

		<xsl:variable name="assettags">
			<xsl:choose>
				<!-- only insert if it is in fact a prog challenge and there are no existing tags -->
				<xsl:when test="$is_programme_challenge and not(MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE)">
					<!-- enquote if prog challenge name contains a space -->
					<xsl:choose>
						<xsl:when test="contains($programme_challenge_name, ' ')">
							&quot;<xsl:value-of select="$programme_challenge_name"/>&quot;
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$programme_challenge_name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
				
		<div class="formRow">
			<label for="keyPhrases">Add some key phrases to this
			<xsl:choose>
				<xsl:when test="$contenttype=1">image*</xsl:when>
				<xsl:otherwise>media*</xsl:otherwise>
			</xsl:choose>
			<em>
			(<a href="http://www.bbc.co.uk/comedysoup/keyphrases.shtml" onclick="popupwindow('http://www.bbc.co.uk/comedysoup/keyphrases.shtml', 'KeyphrasesPopup', 'status=1,resizable=1,scrollbars=1,width=620,height=250');return false;">what are key phrases?</a>)</em></label><br />
			<input type="hidden" name="HasKeyPhrases" value="1"/>
			<textarea name="mediaassetkeyphrases" cols="50" rows="4" id="keyPhrases" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">
			<xsl:value-of select="normalize-space($assettags)"/>
			</textarea>		
		</div>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_copyright">	
	Use: Presentation of the copyright checkbox
	-->
	<xsl:template match="MULTI-STAGE" mode="r_copyright">	
		Agreement of Copyright:<br/>
		link to all terms and conditions etc...<br/>
		<xsl:apply-imports/> yes, I agree<br/>
		<br/>
	</xsl:template>
	
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
	Use: Presentation of the article edit permissions functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
		<p>
			Editable by:			
			<ul>
				<li>
					<xsl:apply-templates select="." mode="t_permissionowner"/> Owner only
				</li>
				<li>
					<xsl:apply-templates select="." mode="t_permissionall"/> Everybody
				</li>
			</ul>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
	Use: Presentation of the article status functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
		<br/>
		Article status:
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE='10' or /H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE='11' or /H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE='12'">
				<input type="text" name="status" value="3" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:when>
			<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
				<input type="text" name="status" value="1" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="text" name="status" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
	Use: Presentation of the article type functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
		Article type: <xsl:apply-templates select="." mode="t_articletype"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
	Use: Presentation of the archive article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
		<br/>Archive this forum?: <xsl:apply-templates select="." mode="t_makearchive"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_preview">
		<div id="preview" style="border-top:2px solid #f00;border-bottom:2px solid #f00;padding:10px 0;">
		
		<xsl:choose>
			<xsl:when test="$article_type_group = 'mediasset'">
				<xsl:call-template name="MEDIA_ASSET_ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'editorial'">
				<xsl:call-template name="EDITORIAL_ARTICLE" />
			</xsl:when>
			<!-- preview profile - not in design
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE=3001">
				<xsl:call-template name="USERPAGE_MAINBODY" />
			</xsl:when>
			-->
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/><br/>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
	Use: Presentation of the delete article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
	Use: Presentation of the hide article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
		Hide this article: <xsl:apply-templates select="." mode="t_hidearticle"/>
		<br/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_authorlist">
	Use: Presentation of the authorlist functionality
	 -->
	<!--
		<xsl:template match="MULTI-STAGE" mode="r_authorlist">
		Authors: <xsl:apply-templates select="." mode="t_authorlist"/>
	</xsl:template>
	-->
	
	
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_strongcontent">
	Use: Enable a article with a mediaasset to be flagged as having strong content
	 -->
	<xsl:template match="MULTI-STAGE" mode="t_strongcontent">
		<xsl:if test="$contenttype=1 or $contenttype=2 or $contenttype=3">
			Strong Content: 
			<input type="checkbox" name="STRONG_CONTENT"><br />
				<xsl:if test="MULTI-ELEMENT[@NAME='STRONG_CONTENT']/VALUE-EDITABLE = 'on'">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>	
			</input>
		</xsl:if>	
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_strongcontent_description">
	Use: Enable a article with a mediaasset to be flagged as having strong content
	 -->
	<xsl:template match="MULTI-STAGE" mode="t_strongcontentdescription">
		<xsl:if test="$contenttype=1 or $contenttype=2 or $contenttype=3">
			Strong Content description:<br />
			<textarea name="STRONG_CONTENT_DESC" cols="50" rows="2">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='STRONG_CONTENT_DESC']/VALUE-EDITABLE"/>
			</textarea>
		</xsl:if>	
	</xsl:template>
	

	<!--
	<xsl:template match="ERROR" mode="r_typedarticle">
	Use: Presentation information for the error reports
	 -->
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO">
			<h1><img src="{$imagesource}h1_uploadexceeded.gif" alt="upload limit exceeded" width="266" height="26" /></h1>
				<xsl:variable name="day" select="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/NEXTLIMITSTARTDATE/DATE/@DAY"/>
				<xsl:variable name="formattedday">
				<xsl:choose>
					<xsl:when test="$day=1 or $day=21 or $day=31">
						<xsl:value-of select="$day"/>st
					</xsl:when>
					<xsl:when test="$day=2 or $day=22">
						<xsl:value-of select="$day"/>nd
					</xsl:when>
					<xsl:when test="$day=3 or $day=23">
						<xsl:value-of select="$day"/>rd
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$day"/>th
					</xsl:otherwise>
				</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="filesize">
					<xsl:choose> 
						<xsl:when test="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/FILELENGTH &gt; 1000000"><!--- bigger than 1MB so display as MB -->
							<xsl:value-of select="format-number(/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/FILELENGTH div 1000000, '0.##')"/>mb
						</xsl:when>
						<xsl:otherwise><!--- less than 1MB so display as K -->
							<xsl:value-of select="floor(/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/FILELENGTH div 1000)"/>k
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:choose>
					<!-- no space left this week -->
					<xsl:when test="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/TOTALUPLOADSIZE &gt; 10000000">
						<p>There is a weekly upload quota of 10mb on Comedy Soup.<br />
						You have reached your limit for this week.</p>
			
						<p>You have uploaded <xsl:value-of select="format-number(/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/TOTALUPLOADSIZE div 1000000, '0.##')"/>mb so far this week and this image is <xsl:value-of select="$filesize"/>.				
						
						You can upload images again on the <xsl:value-of select="$formattedday"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/NEXTLIMITSTARTDATE/DATE/@MONTHNAME"/> when your upload allowance will start again.</p>
					</xsl:when>
					<!-- little bit of space left -->
					<xsl:otherwise>
						<p>There is a weekly upload quota of 10mb on Comedy Soup.<br />
						You have uploaded <xsl:value-of select="format-number(/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/TOTALUPLOADSIZE div 1000000, '0.##')"/>mb so far this week and this image is <xsl:value-of select="$filesize"/>.</p>
				
						<p>You can reduce the size of your image file and try sending it again, or you can wait until <xsl:value-of select="$formattedday"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/EXCEEDEDUPLOADLIMITERRORINFO/NEXTLIMITSTARTDATE/DATE/@MONTHNAME"/> when your upload allowance will start again.</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/ERROR/@CODE='BAD-INPUT-FILE'">
			<div class="warningBox">
					<p class="warning">
					<strong>ERROR</strong><br />
					
					The media file you tried to submit is missing or incorrect.<br />
					<xsl:if test="$current_article_type = 10">
					<br/>If you tried to submit an image, please make sure it is below 1.5mb in size.
					</xsl:if>
					</p>
				</div>
			
			
			

			
			
			</xsl:when>
			<xsl:otherwise>
				<div id="displayXMLerror">
					<xsl:apply-templates select="*|@*|text()"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	<xsl:template match="ERROR" mode="r_typedarticle">
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	
	<div class="textmedium">
	<span class="alert"><strong>You may have forgotten to fill in one of the required fields. Fields with a red star are required. Please fill them in and click 'next'.</strong></span><br />
	<xsl:apply-templates select="*|@*|text()"/><br />
	<strong>
		
	</strong>
	</div>
	
	</xsl:when>
	<xsl:otherwise>
	<div class="textmedium">
	<strong><span class="alert">error</span></strong><br />
	<strong class="alert">
		You may have forgotten to fill in one of the required fields. Fields with a red star are required. Please fill them in and click 'next'.
	</strong>
	</div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	-->
	
	
	
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
		This article has been deleted. If you want to restore any deleted articles you can view them <xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_poll">
	Use: Template invoked for the 'create a poll' functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_poll">
		<xsl:apply-templates select="." mode="c_content_rating"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_content_rating">
	Use: Create a poll box
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_content_rating">
		<xsl:text>Create a poll for this article: </xsl:text>
		<xsl:apply-templates select="." mode="t_content_rating_box"/>
		<br/>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="t_imageuploadfield">
		<input name="file" type="file" size="32" maxlength="255" value="tttttttt"  xsl:use-attribute-sets="iMULTI-STAGE_t_imageuploadfield"/>
	</xsl:template>
	
	
	<!--
	<xsl:attribute-set name="fMULTI-STAGE_c_article">
	Use: attributes for the typedarticle form element
	 -->
	<xsl:attribute-set name="fMULTI-STAGE_c_article">
		<xsl:attribute name="name">typedarticleForm</xsl:attribute>
		<xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="iMULTI-STAGE_r_copyright"/>
	<xsl:attribute-set name="iMULTI-STAGE_r_assettags"/>
	
	<!--
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
	Use: attributes for the input field for uploading images
	 -->
	<xsl:attribute-set name="iMULTI-STAGE_t_imageuploadfield">
		<xsl:attribute name="id">upload</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
	Use: attributes for the input field for an article's title
	 -->
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
		<xsl:attribute name="id">title</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
	Use: attributes for the textarea for an article's body
	 -->
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="id">articlebody</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionowner"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionall"/>
	<!--<xsl:attribute-set name="mMULTI-STAGE_t_authorlist"/>-->
</xsl:stylesheet>
