<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="assetfields"><![CDATA[<MULTI-INPUT>

									<REQUIRED NAME='FILE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='CAPTION'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='MIMETYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='MEDIAASSETDESCRIPTION'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='TERMSANDCONDITIONS'><VALIDATE TYPE='EMPTY'/>/REQUIRED>
	</MULTI-INPUT>]]></xsl:variable>
	<!--
	<xsl:template name="MULTIPOSTS_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MEDIAASSET_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>Asset uploader</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="MEDIAASSET_CSS">
		<link type="text/css" rel="stylesheet" href="http://sandbox0.bu.bbc.co.uk/tw/soup/mediaassets.css"/>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="c_mediaassetindex">	
		<xsl:apply-templates select="." mode="r_mediaassetindex"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_mediaasset">
		<xsl:choose>
			<xsl:when test="@FINISH = 'YES'">
				<xsl:choose>
					<xsl:when test="MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=1">
						<xsl:apply-templates select="." mode="uploaded_mediaasset"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="uploadedmanual_mediaasset"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<form enctype="multipart/form-data" name="mediaassetdetails" method="post" action="{$root}MediaAsset">
					<input type="hidden" name="_msxml" value="{$assetfields}"/>
					<input type="hidden" name="_msfinish" value="yes"/>
					<xsl:apply-templates select="." mode="create_mediaasset"/>
					<input type="hidden" name="termsandconditions">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE"/>
					</input>
					<input type="hidden" name="contenttype" value="{MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE}"/>
					<xsl:if test="not(MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=1)">
						<input type="hidden" name="manualupload" value="1"/>
					</xsl:if>
					<input type="hidden" name="addtolibrary" value="1"/>
					<input type="hidden" name="action" value="{../ACTION}"/>
					<input type="hidden" name="id" value="{../ID}"/>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_filetoupload">
		<xsl:if test="MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=1">
			<xsl:apply-templates select="." mode="r_filetoupload"/>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_filetoupload">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="r_filetoupload">
		<input name="file" type="file" xsl:use-attribute-sets="iMULTI-STAGE_r_filetoupload">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='FILE']/VALUE-EDITABLE"/>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_caption">
		<xsl:apply-templates select="." mode="r_caption"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_caption"/>
	<xsl:template match="MULTI-STAGE" mode="r_caption">
		<textarea name="caption" cols="50" rows="2" xsl:use-attribute-sets="iMULTI-STAGE_r_caption">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='CAPTION']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_assetdesc">
		<xsl:apply-templates select="." mode="r_assetdesc"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_assetdesc"/>
	<xsl:template match="MULTI-STAGE" mode="r_assetdesc">
		<textarea name="mediaassetdescription" cols="50" rows="5" xsl:use-attribute-sets="iMULTI-STAGE_r_assetdesc">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETDESCRIPTION']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_assettags">
		<xsl:apply-templates select="." mode="r_assettags"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_assettags"/>
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<textarea name="mediaassetkeyphrases" cols="50" rows="1" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_assettandc">
		<xsl:apply-templates select="." mode="r_assettandc"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_assettandc"/>
	<xsl:template match="MULTI-STAGE" mode="r_assettandc">
		<input type="checkbox" name="termsandconditions" align="left" xsl:use-attribute-sets="iMULTI-STAGE_r_assettandc">
			<xsl:if test="MULTI-REQUIRED[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 'on'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_assetsubmit">
		<xsl:apply-templates select="." mode="r_assetsubmit"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_assetsubmit"/>
	<xsl:template match="MULTI-STAGE" mode="r_assetsubmit">
		<input type="submit" value="Finish" xsl:use-attribute-sets="iMULTI-STAGE_r_assetsubmit"/>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_assetfilename">
		<xsl:if test="(MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=2 or MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=2)">
			<xsl:apply-templates select="." mode="r_assetfilename"/>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-REQUIRED_r_assetfilename"/>
	<xsl:template match="MULTI-REQUIRED" mode="r_assetfilename">
		<textarea name="filename" cols="50" rows="1" xsl:use-attribute-sets="iMULTI-REQUIRED_r_assetfilename">
			<xsl:value-of select="VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_mediaassetmimetype">
		<xsl:if test="not(/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE/MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=1)">
			<xsl:apply-templates select="." mode="r_mediaassetmimetype"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="MULTI-REQUIRED" mode="r_mediaassetmimetype">
	<xsl:choose>

		<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE/MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=2">

		<select name="mimetype">
			<option value="mp2">MP2</option>			
			<option value="mp3">MP3</option>			
			<option value="wav">WAV</option>		
		</select>
		</xsl:when>
		<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE/MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE=3">

		<select name="mimetype">
			<option value="avi">AVI</option>			
			<option value="wmv">WMV (Windows Media Video)</option>			
			<option value="mov">MOV</option>
			<option value="mp1">MP1</option>			
		</select>
		</xsl:when>
	</xsl:choose>
	</xsl:template>
	
	<xsl:template match="MEDIAASSET" mode="c_displayasset">
		<xsl:if test="not(../MULTI-STAGE/@FINISH='YES') and not(../ACTION='showusersassets')">
			<xsl:apply-templates select="." mode="r_displayasset"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="@MEDIAASSETID" mode="c_preview">
		<xsl:apply-templates select="." mode="r_preview"/>
	</xsl:template>
	<xsl:variable name="suffix">
	
	<xsl:call-template name="chooseassetsuffix">
		<xsl:with-param name="mimetype" select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE"></xsl:with-param>
	</xsl:call-template>
	</xsl:variable>
	<xsl:template match="@MEDIAASSETID" mode="r_preview">
		<img src="{$mediaassetmediapath}{.}_preview.{$suffix}" alt="{../DESCRIPTION}" xsl:use-attribute-sets="imgaMEDIAASSETID_r_preview" border="0"/>
	</xsl:template>
	<xsl:variable name="mediaassetmediapath" select="concat($assetlibrary, /H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/FTPPATH)"/>
	<xsl:attribute-set name="imgaMEDIAASSETID_r_preview">
	</xsl:attribute-set>
	<xsl:template match="@MEDIAASSETID" mode="c_download">
		<xsl:apply-templates select="." mode="r_download"/>
	</xsl:template>
	<xsl:template match="@MEDIAASSETID" mode="r_download">
	<xsl:variable name="uma_download">
			<xsl:choose>
			<xsl:when test="../CONTENTTYPE=1">
				<xsl:text>Download image</xsl:text>
			</xsl:when>
			<xsl:when test="../CONTENTTYPE=2">
				<xsl:text>Download audio</xsl:text>
			</xsl:when>
			<xsl:when test="../CONTENTTYPE=3">
				<xsl:text>Download video</xsl:text>
			</xsl:when>
		</xsl:choose>	
	</xsl:variable>
	<xsl:variable name="suffix">
		<xsl:call-template name="chooseassetsuffix">
			<xsl:with-param name="mimetype" select="../MIMETYPE"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
		<a href="{$mediaassetmediapath}{.}_raw.{$suffix}" xsl:use-attribute-sets="maASSETID_r_download">
			<xsl:copy-of select="$uma_download"/>
		</a>
	</xsl:template>
	<xsl:template match="USER" mode="c_previewauthor">
		<xsl:apply-templates select="." mode="r_previewauthor"/>
	</xsl:template>
	<xsl:template match="USER" mode="r_previewauthor">
		<a href="{$root}u{USERID}" xsl:use-attribute-sets="mUSER_r_previewauthor">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mUSER_r_previewauthor"/>
	<xsl:variable name="m_download">Download asset</xsl:variable>
	<xsl:attribute-set name="maASSETID_r_download"/>
	<xsl:template match="PHRASES" mode="c_displayasset">
		<xsl:apply-templates select="." mode="r_displayasset"/>
	</xsl:template>

	
	<xsl:template match="PHRASE" mode="c_displayasset">
		<xsl:apply-templates select="." mode="r_displayasset"/>
	</xsl:template>
	<xsl:template match="PHRASE" mode="r_displayasset">
		<a href="{$root}MediaAssetSearchPhrase?contenttype={../../CONTENTTYPE}&amp;phrase={TERM}" xsl:use-attribute-sets="mPHRASE_r_displayasset">
			<xsl:value-of select="TERM"/>
		</a>
	</xsl:template>
	<xsl:template match="PARAMS" mode="c_backlink">
		<xsl:apply-templates select="." mode="r_backlink"/>
	</xsl:template>
	<xsl:variable name="m_mediaassetlinktomasp">Back to search results</xsl:variable>
	<xsl:template match="PARAMS" mode="r_backlink">
		<xsl:variable name="tags">
			<xsl:for-each select="PARAM[NAME='s_tag']">
				<xsl:value-of select="concat('?phrase=', VALUE)"/>
			</xsl:for-each>
		</xsl:variable>
		<a href="{$root}MediaAssetSearchPhrase{$tags}">
			<xsl:copy-of select="m_mediaassetlinktomasp"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mPHRASE_r_displayasset"/>
	<xsl:template match="MEDIAASSETBUILDER" mode="c_uploadimage">
		<form name="createmediaasset" method="post" action="{$root}MediaAsset">
			<input type="hidden" name="contenttype" value="1"/>
			<input type="hidden" name="action" value="create"/>
			<input type="hidden" name="addtolibrary" value="1"/>
			<xsl:apply-templates select="." mode="r_uploadimage"/>
		</form>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="c_uploadaudio">
		<form name="manualupload" method="post" action="{$root}MediaAsset">
			<input type="hidden" name="contenttype" value="2"/>
			<input type="hidden" name="action" value="create"/>
			<input type="hidden" name="addtolibrary" value="1"/>
			<input type="hidden" name="manualupload" value="1"/>
			<xsl:apply-templates select="." mode="r_uploadaudio"/>
		</form>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="c_uploadvideo">
		<form name="manualupload" method="post" action="{$root}MediaAsset">
			<input type="hidden" name="contenttype" value="3"/>
			<input type="hidden" name="action" value="create"/>
			<input type="hidden" name="addtolibrary" value="1"/>
			<input type="hidden" name="manualupload" value="1"/>
			<xsl:apply-templates select="." mode="r_uploadvideo"/>
		</form>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadimage">
		<input type="submit" value="upload an image" xsl:use-attributes-sets="iMEDIAASSETBUILDER_r_uploadimage"/>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadaudio">
		<input type="submit" value="upload an audio file" xsl:use-attributes-sets="iMEDIAASSETBUILDER_r_uploadaudio"/>
	</xsl:template>
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadvideo">
		<input type="submit" value="upload a video file" xsl:use-attributes-sets="iMEDIAASSETBUILDER_r_uploadvideo"/>
	</xsl:template>
	<xsl:attribute-set name="iMEDIAASSETBUILDER_r_uploadimage"/>
	<xsl:attribute-set name="iMEDIAASSETBUILDER_r_uploadaudio"/>
	<xsl:attribute-set name="iMEDIAASSETBUILDER_r_uploadvideo"/>
	<xsl:template match="MEDIAASSETINFO" mode="c_uma">
		<xsl:if test="(ACTION='showusersassets')">
			<xsl:apply-templates select="." mode="r_uma"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MEDIAASSET" mode="c_uma">
		<xsl:apply-templates select="." mode="r_uma"/>
	</xsl:template>
</xsl:stylesheet>
