<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-mediaassetpage.xsl"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MEDIAASSET_CSS">
	</xsl:template>

	<xsl:template name="MEDIAASSET_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">MEDIAASSET_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">mediaassetpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<xsl:apply-templates select="/H2G2/ERROR" mode="t_errorpage"/>
		<xsl:apply-templates select="MULTI-REQUIRED/ERRORS"/>
	
		<xsl:choose>
			<xsl:when test="MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='update']">
				<xsl:apply-templates select="MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="update"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- View/Download an Asset -->
				<xsl:choose>
					<!-- licence agreement -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE='licence'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence"/>
					</xsl:when>
					<!-- user accepted agreement - it is downloading -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='yes'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence_accepted"/>
					</xsl:when>
					<!-- user declined agreement  -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='no'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence_declined"/>
					</xsl:when>
					<xsl:otherwise>
					<!-- View an Asset -->
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="c_displayasset"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- upload index page -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE='index'">
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER" mode="c_mediaassetindex"/>
		</xsl:if>
		
		<!-- upload form -->
		<xsl:if test="not(MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='update'])">
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="c_mediaasset"/>
		</xsl:if>
		
		
		<!-- User articles with mediaassets -->
		<xsl:apply-templates select="MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO[ACTION='showusersarticleswithassets']"/> 
		
		<!-- 
			Uploaded Media Assets
				Page showing all assets a user has uploads
				e.g http://dnadev.bu.bbc.co.uk/dna/comedysoup/UMA1090497698
		
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO" mode="c_uma"/>
		-->
	</xsl:template>


	<!--
	EDITOR'S EDIT ASSET FUNCTIONS
	-->
	<xsl:variable name="updateexternallylinkedassetfields">
		<![CDATA[<MULTI-INPUT>
			<REQUIRED NAME='CAPTION'></REQUIRED>
			<REQUIRED NAME='CONTENTTYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='HIDDEN'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='MEDIAASSETDESCRIPTION'></REQUIRED>
			<REQUIRED NAME='MEDIAASSETKEYPHRASES'></REQUIRED>
			<REQUIRED NAME='HIDDEN'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='MIMETYPE'></REQUIRED>
			<REQUIRED NAME='EXTERNALLINKURL'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<!--
			<ELEMENT NAME='TERMSANDCONDITIONS'></ELEMENT>
			<ELEMENT NAME='ORIGINYEAR'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINMONTH'><VALIDATE TYPE=''/></ELEMENT>
			<ELEMENT NAME='ORIGINDAY'><VALIDATE TYPE=''/></ELEMENT>		
			-->
			
		</MULTI-INPUT>]]>
	</xsl:variable>


	<!---
	UPDATE ASSET FORM
	-->
	<xsl:template match="MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="update">
		<div id="topPage">
			<h2>Edit media asset</h2>
			<div class="innerWide">
				<p>
					Media asset attached to <a href="{$root}A{/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/UPDATEH2G2ID}">this memory</a>
				</p>
				<p>
					<xsl:apply-templates select="/H2G2/ERROR" mode="t_errorpage"/>
					<xsl:apply-templates select="MULTI-REQUIRED/ERRORS"/>
				</p>
			</div>
		</div>
		<div class="tear"><hr/></div>

		<div class="padWrapper" id="addMemForm">		
			<div class="inner3_4">
				<form name="mediaassetdetails" method="post" action="{$root}MediaAsset">
					<input type="hidden" name="_msxml" value="{$updateexternallylinkedassetfields }"/>
					<input type="hidden" name="addtolibrary" value="0"/>
					<input type="hidden" name="_msfinish" value="yes"/>
					<input type="hidden" name="manualupload" value="1"/>
					<input type="hidden" name="s_articleid" value="{/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/UPDATEH2G2ID}"/>
					<input type="hidden" name="externallink" value="1"/>
					<input type="hidden" name="caption">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='CAPTION']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="hidden" name="contenttype">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='CONTENTTYPE']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="hidden" name="mediaassetdescription">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETDESCRIPTION']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="hidden" name="mediaassetkeyphrases">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="hidden" name="mimetype">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='MIMETYPE']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>

					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_mediaasset_updated'] and not(MULTI-REQUIRED/ERRORS/ERROR)">			
						<p>
						<span class="challenge">MediaAsset <strong><xsl:value-of select="../ID"/></strong> updated.</span>
						<!--
						<br/>
						<xsl:choose>
							<xsl:when test="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE = 0">
								Asset has been <strong>PASSED</strong>
							</xsl:when>
							<xsl:when test="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE = 1">
								Asset has been <strong>FAILED</strong>
							</xsl:when>
						</xsl:choose>
						-->
						<!--
						<br/>
						Mime-type set to <strong><xsl:value-of select="MULTI-REQUIRED[@NAME='MIMETYPE']/VALUE-EDITABLE"/></strong>
						-->
						</p>
					</xsl:if>
					<p>
						<label for="externallinkurl" class="bld">
							Embed media
							<em class="alert">
								<xsl:apply-templates select="MULTI-REQUIRED[@NAME='EXTERNALLINKURL']" mode="validate">
									<xsl:with-param name="msg">Please enter an embeded media url.</xsl:with-param>
								</xsl:apply-templates>
							</em>
						</label><br/>
						<input type="text" name="externallinkurl" id="externallinkurl" class="txtWide" maxlength="128">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input><br/>
					</p>
					<!--
					<p>
						MimeType:<br/>
						<xsl:call-template name="MimeTypeInput">
							<xsl:with-param name="setmimetype">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='MIMETYPE']/VALUE-EDITABLE"/>
							</xsl:with-param>
						</xsl:call-template>
					</p>
					-->
					<!--
					<p>
						Origin Date :
						<xsl:call-template name="OriginDateInput">
							<xsl:with-param name="setday"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINDAY']/VALUE"/></xsl:with-param>
							<xsl:with-param name="setmonth"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINMONTH']/VALUE"/></xsl:with-param>
							<xsl:with-param name="setyear"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINYEAR']/VALUE"/></xsl:with-param>
						</xsl:call-template>
					</p>
					-->
					<!--
					<p>
						Hidden Status:<br/>
						<xsl:call-template name="HiddenStatusInput">
							<xsl:with-param name="setstatus">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE"/>
							</xsl:with-param>
						</xsl:call-template>
					</p>
					-->
					<input type="hidden" name="updatedatauploaded" value="{../UPDATEDATAUPLOADED}"/>
					<input type="hidden" name="action" value="{../ACTION}"/>
					<input type="hidden" name="h2g2id" value="{../UPDATEH2G2ID}"/>
					<input type="hidden" name="id" value="{../ID}"/>
					<input type="hidden" name="s_mediaasset_updated" value="1"/>
					<p>
						<input type="submit" value="Update"/>
					</p>
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articleid']">
						<p>
							<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME='s_articleid']/VALUE}">Back to <xsl:value-of select="$m_article"/></a>
						</p>
					</xsl:if>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="MimeTypeInput">
		<xsl:param name="setmimetype"/>

		<select name="mimetype">
			<option value="">----</option>
			<option value="bmp">
				<xsl:if test="$setmimetype = 'image/bmp' or $setmimetype = 'bmp'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				image/bmp (bmp)
			</option>
			<option value="gif">
				<xsl:if test="$setmimetype = 'image/gif' or $setmimetype = 'gif'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				image/gif (gif)
			</option>
			<option value="jpg">
				<xsl:if test="$setmimetype = 'image/jpeg' or $setmimetype = 'jpg'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				image/jpeg (jpg)
			</option>
			<option value="png">
				<xsl:if test="$setmimetype = 'image/png' or $setmimetype = 'png'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				image/png (png)
			</option>
			<option value="aud">
				<xsl:if test="$setmimetype = 'audio/aud' or $setmimetype = 'aud'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/aud (aud)
			</option>
			<option value="mp1">
				<xsl:if test="$setmimetype = 'audio/mp1' or $setmimetype = 'mp1'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/mp1 (mp1)
			</option>
			<option value="mp2">
				<xsl:if test="$setmimetype = 'audio/mp2' or $setmimetype = 'mp2'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/mp2 (mp2)
			</option>
			<option value="mp3">
				<xsl:if test="$setmimetype = 'audio/mp3' or $setmimetype = 'mp3'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/mp3 (mp3)
			</option>
			<option value="ra">
				<xsl:if test="$setmimetype = 'audio/x-pn-realaudio' or $setmimetype = 'ra'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/x-pn-realaudio (ra)
			</option>
			<option value="wav">
				<xsl:if test="$setmimetype = 'audio/x-wav' or $setmimetype = 'wav'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/x-wav (wav)
			</option>
			<option value="wma">
				<xsl:if test="$setmimetype = 'audio/x-ms-wma' or $setmimetype = 'wma'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				audio/x-ms-wma (wma)
			</option>
			<option value="avi">
				<xsl:if test="$setmimetype = 'video/avi' or $setmimetype = 'avi'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				video/avi (avi)
			</option>
			<option value="mov">
				<xsl:if test="$setmimetype = 'video/quicktime' or $setmimetype = 'mov'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				video/quicktime (mov)
			</option>
			<option value="mpg">
				<xsl:if test="$setmimetype = 'video/mpeg' or $setmimetype = 'mpg'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				video/mpeg (mpg)
			</option>
			<option value="rm">
				<xsl:if test="$setmimetype = 'application/vnd.rn-realmedia' or $setmimetype = 'rm'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				application/vnd.rn-realmedia (rm)
			</option>
			<option value="wmv">
				<xsl:if test="$setmimetype = 'video/x-ms-wmv' or $setmimetype = 'wmv'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				video/x-ms-wmv (wmv)
			</option>
			<option value="swf">
				<xsl:if test="$setmimetype = 'application/x-shockwave-flash' or $setmimetype = 'swf'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				application/x-shockwave-flash (swf)
			</option>
			<option value="flv">
				<xsl:if test="$setmimetype = 'video/x-flv' or $setmimetype = 'flv'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				video/x-flv (flv)
			</option>		
		</select>
	</xsl:template>

	<xsl:template name="HiddenStatusInput">
		<xsl:param name="setstatus" />
		<select name="hidden">
			<option value="">----</option>
			<option value="0">
				<xsl:if test="$setstatus = 0">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				0 - Passed / Visible
			</option>
			<option value="1">
				<xsl:if test="$setstatus = 1">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				1 - Failed
			</option>
			<!--
			<option value="2">
				<xsl:if test="$setstatus = 2">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				2 - Refered / Hidden
			</option>
			-->
			<!--
			<option value="3">
				<xsl:if test="$setstatus = 3">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				3 - In Moderation
			</option>
			-->
		</select>
	</xsl:template>

	<xsl:template name="OriginDateInput">
		<xsl:param name="setday">31</xsl:param>
		<xsl:param name="setmonth">12</xsl:param>
		<xsl:param name="setyear">2005</xsl:param>
		Day 
		<select name="originday">
			<option value="{$setday}"><xsl:value-of select="$setday"/></option>
			<option value="01">01</option>
			<option value="02">02</option>
			<option value="03">03</option>
			<option value="04">04</option>
			<option value="05">05</option>
			<option value="06">06</option>
			<option value="07">07</option>
			<option value="08">08</option>
			<option value="09">09</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			<option value="19">19</option>
			<option value="20">20</option>
			<option value="21">21</option>
			<option value="22">22</option>
			<option value="23">23</option>
			<option value="24">24</option>
			<option value="25">25</option>
			<option value="26">26</option>
			<option value="27">27</option>
			<option value="28">28</option>
			<option value="29">29</option>
			<option value="30">30</option>
			<option value="31">31</option>
		</select>
		 Month 
		<select name="originmonth">
			<option value="{$setmonth}"><xsl:value-of select="$setmonth"/></option>
			<option value="01">01</option>
			<option value="02">02</option>
			<option value="03">03</option>
			<option value="04">04</option>
			<option value="05">05</option>
			<option value="06">06</option>
			<option value="07">07</option>
			<option value="08">08</option>
			<option value="09">09</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
		</select>
		 Year 
		<select name="originyear" value="{$setyear}">
			<option value="{$setyear}"><xsl:value-of select="$setyear"/></option>
			<option value="2006">2007</option>
			<option value="2006">2006</option>
			<option value="2005">2005</option>
			<option value="2004">2004</option>
			<option value="2003">2003</option>
			<option value="2002">2002</option>
			<option value="2001">2001</option>
			<option value="2000">2000</option>
			<option value="1999">1999</option>
			<option value="1998">1998</option>
			<option value="1997">1997</option>
			<option value="1996">1996</option>
			<option value="1995">1995</option>
		</select>
	</xsl:template>	
</xsl:stylesheet>
