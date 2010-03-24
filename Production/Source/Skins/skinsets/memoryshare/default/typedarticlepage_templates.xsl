<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">



<!-- 
#############################################################
PROFILE FORM
#############################################################
-->
<!-- form used for create/edit profile:  TYPE = 3001 -->
<xsl:template name="PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$user_intro_fields}"/>
	<input type="hidden" name="type" value="3001"/>
	<input type="hidden" name="TITLE">
	<xsl:attribute name="value">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
	</xsl:attribute>
	</input>
	<input type="hidden" name="ARTICLECLASS" value="_profile"/>

	<div id="topPage">
		<div class="innerWide">
			<div id="shortDescForm">
				<h2>Your Memories</h2>									
				<p>
					<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>
				</p>
				<!--[FIXME: redundant]
				<input type="hidden" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				-->

				<label for="description">
					A short description about yourself
					<em class="alert">
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							Please write something about yourself
						</xsl:if>
					</em>
				</label><br/>
				<textarea name="body" id="description" cols="30" rows="6" maxlength="450" wrap="virtual">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>			

				<div class="submitRow">
					<xsl:call-template name="SUBMIT_BUTTONS" />
				</div>
			</div>
		</div>
	</div>
	<div class="tear"><hr/></div>
	<div class="barStrong"><div class="clr"><hr/></div></div>
    <xsl:call-template name="SEARCH_RSS_FEED"/>
</xsl:template>




<!-- 
#############################################################
ARTICLE (MEMORY) FORM
#############################################################
-->
<!-- form used for creating an article (poll with comments) -->
<xsl:template name="ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USER_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<input type="hidden" name="_msxml" value="{$article_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<!--[FIXME: remove or change value?]
	<input type="hidden" name="polltype1" value="3"/>
	-->
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	<!--
	
	-->
	<!--
	<input type="hidden" name="skin" value="purexml"/>
	-->
	<input type="hidden" name="haskeyphrases" value="1"/>

	<input type="hidden" name="ARTICLECLASS" value="_memory"/>
	<xsl:choose>
		<xsl:when test="$article_subtype = 'staff_memory' and $test_IsAdminUser">
			<input type="hidden" name="TYPEOFARTICLE" value="_staff_memory"/>
		</xsl:when>
		<xsl:otherwise>
			<input type="hidden" name="TYPEOFARTICLE" value="_user_memory"/>
		</xsl:otherwise>
	</xsl:choose>
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	
	<xsl:call-template name="AUTO_HIDDEN_FIELDS">
		<xsl:with-param name="keyword" select="$client_keyword"/>
		<xsl:with-param name="visibletag" select="$client_visibletag"/>
	</xsl:call-template>

	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->

	<div id="topPage">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<h2>Edit memory</h2>
			</xsl:when>
			<xsl:otherwise>
				<h2>Add memory</h2>
			</xsl:otherwise>
		</xsl:choose>
		<div class="innerWide">
			<p>
				Your Memory is an account of something that happened to you at a 
				certain time and in a certain place. 
				You need to give it a <strong>Title</strong>, tell us <strong>What happened</strong> 
				(you can include links here if you wish, but please refer to <a href="{$root}help">Memoryshare FAQs</a> for advice on this), 
				<strong>When it happened</strong> and <strong>Where you were</strong>. 
				Giving us this information, together with keywords, will let others find your memory 
				when they are searching memories by dates, places and events. 				
				</p>
			<p>
				<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>
				<!--[FIXME: do we need this?]
				<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				-->
			</p>
		</div>
	</div>
	<div class="tear"><hr/></div>
	
	<div class="padWrapper" id="addMemForm">		
		<div class="inner3_4_wide">
			<!-- staff memories can have an alternative name (e.g. celebrity) -->
			<xsl:if test="$test_IsAdminUser">
				<label for="altname" class="bld">Added on behalf of</label><br/>
				<input type="text" name="altname" id="altname" class="txtWide" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='ALTNAME']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>
			</xsl:if>
		
			<label for="title" class="bld">
				Title
				<em class="alert">
					<xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="validate">
						<xsl:with-param name="msg">Please enter a title.</xsl:with-param>
						<xsl:with-param name="cancel" select="@CANCEL"/>
					</xsl:apply-templates>
				</em>
			</label><br/>
			<input type="text" name="title" id="title" class="txtWide" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input><br/>

			<label for="body" class="bld">
				What happened?
				<em class="alert">
					<xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="validate">
						<xsl:with-param name="msg">Please enter your memory text.</xsl:with-param>
						<xsl:with-param name="cancel" select="@CANCEL"/>
					</xsl:apply-templates>
				</em>
			</label><br/>
			<textarea name="body" rows="8" class="txtWide" id="body">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
			</textarea>
			
			<!--start embedded_mediasset_stuff -->
			<xsl:if test="$typedarticle_embed ='yes' and ($typedarticle_embed_admin_only = 'no' or $test_IsAdminUser)">
				<fieldset id="mediaassetFS">
					<input type="hidden" name="hasasset" id="hasasset" value="1"/>
					<input type="hidden" name="manualupload" id="manualupload" value="1"/>
					<input type="hidden" name="externallink" id="externallink" value="1"/>
					
					<xsl:choose>
						<!-- only let admin users edit media assets irrespective of settings -->
						<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
							<xsl:variable name="s_ma_add" select="/H2G2/PARAMS/PARAM[NAME='s_ma_add']/VALUE"/>
							<xsl:choose>
								<xsl:when test="(MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE != '' and (not($s_ma_add) or $s_ma_add != 'yes')) or not($test_IsAdminUser)">
									<input type="hidden" name="externallinkurl" value="{MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE}"/>
									<input type="hidden" class="checkbox" name="termsandconditions" value="1"/>

									<label for="externallinkurl" class="bld">Embed media</label><br/>
									<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
									<br/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$typedarticle_embed_edit_add = 'yes'">
										<input type="hidden" name="s_ma_add" value="yes"/>
										<label for="externallinkurl" class="bld">Embed media</label><br/>
										<input type="text" name="externallinkurl" id="externallinkurl" class="txtWide" maxlength="128">
											<xsl:attribute name="value">
												<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
											</xsl:attribute>
										</input><br/>
										<xsl:if test="$typedarticle_embed_tc = 'yes'">
											<input type="checkbox" class="checkbox" name="termsandconditions" id="termsandconditions" value="1">
												<xsl:if test="MULTI-ELEMENT[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 1">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											<xsl:text> </xsl:text>
											<label for="termsandconditions">I have the rights etc</label>
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<label for="externallinkurl" class="bld">Embed media</label><br/>
							<input type="text" name="externallinkurl" id="externallinkurl" class="txtWide" maxlength="128">
								<xsl:attribute name="value">
									<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
								</xsl:attribute>
							</input><br/>
							<xsl:if test="$typedarticle_embed_tc = 'yes'">
								<input type="checkbox" class="checkbox" name="termsandconditions" id="termsandconditions" value="1">
									<xsl:if test="MULTI-ELEMENT[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<xsl:text> </xsl:text>
								<label for="termsandconditions">I have the rights etc</label>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</fieldset>
			</xsl:if>			
			<!--end embedded_mediasset_stuff -->
	
			<!-- date validation messages -->
			<xsl:variable name="dateValidationMessages">
				<xsl:apply-templates select="MULTI-REQUIRED[@NAME='STARTDATE']" mode="validate">
					<xsl:with-param name="msg">Please enter a valid start date.</xsl:with-param>
					<xsl:with-param name="cancel" select="@CANCEL"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="MULTI-REQUIRED[@NAME='ENDDATE']" mode="validate">
					<xsl:with-param name="msg">Please enter a valid end date.</xsl:with-param>
					<xsl:with-param name="cancel" select="@CANCEL"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="MULTI-REQUIRED[@NAME='STARTDAY']" mode="validate">
					<xsl:with-param name="msg"><xsl:value-of select="MULTI-REQUIRED[@NAME='STARTDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/>.</xsl:with-param>
					<xsl:with-param name="cancel" select="@CANCEL"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="MULTI-REQUIRED[@NAME='ENDDAY']" mode="validate">
					<xsl:with-param name="msg"><xsl:value-of select="MULTI-REQUIRED[@NAME='ENDDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/>.</xsl:with-param>
					<xsl:with-param name="cancel" select="@CANCEL"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:variable name="datemode">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE">
						<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="date_range_type">
							<xsl:call-template name="GET_DATE_RANGE_TYPE">
								<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
								<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
								<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
								<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
								<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
								<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
								<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
								<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
								<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:choose>
							<xsl:when test="$date_range_type = 1">Specific</xsl:when>
							<xsl:when test="$date_range_type = 2">Daterange</xsl:when>
							<xsl:when test="$date_range_type = 3">Fuzzydate</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">Nodate</xsl:when>
									<xsl:otherwise>Specific</xsl:otherwise><!-- default to Specific -->
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<script language="javascript" type="text/javascript">
				var dfnOverride = '<xsl:value-of select="$datemode"/>';
			</script>

			<!-- cascading date input complexity -->
			<noscript>
				<fieldset id="dateSelector">
					<legend>
						Date of memory
						<xsl:if test="$dateValidationMessages">
							<em class="alert"><xsl:value-of select="$dateValidationMessages"/></em>
						</xsl:if>
					</legend>

					<input type="radio" name="s_datemode" id="s_datemodeSpecific" class="radio" value="Specific" onclick="javascript:datefieldsWriteTypedArticle('Specific')">
						<xsl:if test="$datemode='Specific' or not(/H2G2/PARAMS/PARAM[NAME='s_datemode'])">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input><xsl:text> </xsl:text>
					<label for="s_datemodeSpecific" class="radioLabel">My memory is of a specific date (e.g. 14/10/1986)</label><br/>

					<input type="radio" name="s_datemode" id="s_datemodeDaterange" class="radio" value="Daterange" onclick="javascript:datefieldsWriteTypedArticle('Daterange')">
						<xsl:if test="$datemode='Daterange'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input><xsl:text> </xsl:text>
					<label for="s_datemodeDaterange" class="radioLabel">My memory is of a specific date range (e.g. 10/04/1972 to 16/04/1973)</label><br/>

					<input type="radio" name="s_datemode" id="s_datemodeFuzzydate" class="radio" value="Fuzzydate" onclick="javascript:datefieldsWriteTypedArticle('Fuzzydate')">
						<xsl:if test="$datemode='Fuzzydate'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input><xsl:text> </xsl:text>
					<label for="s_datemodeFuzzydate" class="radioLabel">My memory is of an approximate date range (e.g. 10/04/1972 to 16/04/1973 for a duration of 10 days)</label><br/>

					<input type="radio" name="s_datemode" id="s_datemodeNodate" class="radio" value="Nodate" onclick="javascript:datefieldsWriteTypedArticle('Nodate')">
						<xsl:if test="$datemode='Nodate'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input><xsl:text> </xsl:text>
					<label for="s_datemodeNodate" class="radioLabel">I don't know the date of my memory</label><br/>

					<noscript>
						<p class="rAlign">
							<input type="submit" name="acreatecancelled" value="Enter dates &gt;" class="submit"/>
						</p>
					</noscript>
				</fieldset>
			</noscript>
			
			<script language="javascript" type="text/javascript">
				<xsl:call-template name="DATEFIELDS_DATE_JS_VARS">
					<xsl:with-param name="startdate" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="startday" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
					<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
				</xsl:call-template>
				<!--
				<xsl:call-template name="DATEFIELDS_NODATE_JS_STR"/>
				<xsl:call-template name="DATEFIELDS_FUZZYDATE_JS_STR">
					<xsl:with-param name="startdate" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="startday" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
					<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
				</xsl:call-template>
				<xsl:call-template name="DATEFIELDS_DATERANGE_JS_STR">
					<xsl:with-param name="startdate" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="startday" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="datesearchtype">no</xsl:with-param>
					<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
				</xsl:call-template>
				<xsl:call-template name="DATEFIELDS_SPECIFIC_JS_STR">
					<xsl:with-param name="startdate" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
					<xsl:with-param name="startday" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
					<xsl:with-param name="startmonth" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
					<xsl:with-param name="startyear" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
					<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
				</xsl:call-template>
				-->
			</script>
	
			<div class="js" id="jsDateWrapper">
				<fieldset id="dateTypeSelector">
					<legend>Date of memory</legend>
					<div class="formRow">
						<div id="dateInfo0"></div>
						<input type="radio" class="radio" name="s_datemodeR" id="s_datemodeSpecific" value="Specific" onclick="setDateType(this.value)" checked="checked"/>
						<label for="s_datemodeSpecific" id="s_datemodeSpecificLabel">Specific date (e.g. <span class="egOpen"><em class="egOpen">25th October 1976</em> <em class="egOpen">25/10/1976</em> <em class="egOpen">Oct 76</em> <em class="egOpen">1976</em></span>)</label><br/>
						<div id="dateFields1">
							<input type="text" id="sidate" name="s_idate"/>
							<div id="dateInfo1"></div>
						</div>
					</div>

					<div class="formRow">
						<input type="radio" class="radio" name="s_datemodeR" id="s_datemodeDaterange" value="Daterange" onclick="setDateType(this.value)"/>
						<label for="s_datemodeDaterange" id="s_datemodeDaterangeLabel">Date range (e.g <span class="egOpen"><em class="egOpen">7th September 2002 - 2nd February 2003</em> <em class="egOpen">07/09/2002 - 02/02/2003</em> <em class="egOpen">Sep 2002 - 02/02/2003</em> <em class="egOpen">September 2002 - Feb 2003</em> <em class="egOpen">2002 - 2003</em></span>)</label><br/>
						<div id="dateFields2">
							<input type="text" id="sidater1" name="s_idater1"/>
							<span> to </span>
							<input type="text" id="sidater2" name="s_idater2"/>
							<div id="dateInfo2"></div>
						</div>
					</div>

					<div class="formRow">
						<input type="radio" class="radio" name="s_datemodeR" id="s_datemodeFuzzydate" value="Fuzzydate" onclick="setDateType(this.value)"/>
						<label for="s_datemodeFuzzydate" id="s_datemodeFuzzydateLabel">Approximate date (e.g <span class="egOpen"><em class="egOpen">4 months between 2002 and 2003</em> <em class="egOpen">2 weeks between Jan 2002 and Feb 2003</em> <em class="egOpen">5 days between 01/02/2003 and 14/02/2003</em></span>)</label><br/>
						<div id="dateFields3">
							<input type="text" size="2" name="s_itimeintervalf" id="sitimeintervalf"/>
							<xsl:text> </xsl:text>
							<select name="s_idurationtypef" id="sidurationtypef">
								<option value="1">days</option>
								<option value="7">weeks</option>
								<option value="30">months</option>								
							</select>
							<span> between </span>
							<input type="text" id="sidatef1" name="s_idatef1"/>
							<span> and </span>
							<input type="text" id="sidatef2" name="s_idatef2"/>
							<div id="dateInfo3"></div>
						</div>
					</div>
					
					<div class="formRow">
						<input type="radio" class="radio" name="s_datemodeR" id="s_datemodeNodate" value="Nodate" onclick="setDateType(this.value)"/>
						<label for="s_datemodeNodate">I don't know the date</label><br/>
						<div id="dateFields4"></div>
					</div>
				</fieldset>
			</div>
			
			<!-- div into which javascript strings containing datefield markup is written into -->
			<div id="datefields">
				<noscript>
					<xsl:choose>
						<xsl:when test="$datemode='Nodate'">
							<div id="datefieldsNodate" class="noscript">
								<xsl:call-template name="DATEFIELDS_NODATE"/>
							</div>
						</xsl:when>
						<xsl:when test="$datemode='Fuzzydate'">
							<div id="datefieldsDaterange" class="noscript">
								<xsl:call-template name="DATEFIELDS_FUZZYDATE">
									<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
									<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
									<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
									<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
									<xsl:with-param name="endate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
									<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
									<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
									<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
									<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
									<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
								</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:when test="$datemode='Daterange'">
							<div id="datefieldsDaterange" class="noscript">
								<xsl:call-template name="DATEFIELDS_DATERANGE">
									<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
									<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
									<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
									<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
									<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
									<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
									<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
									<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
									<xsl:with-param name="datesearchtype">no</xsl:with-param>
									<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
								</xsl:call-template>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div id="datefieldsSpecific" class="noscript">
								<xsl:call-template name="DATEFIELDS_SPECIFIC">
									<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
									<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
									<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
									<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
									<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
								</xsl:call-template>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</noscript>
			</div>
		</div>

		<fieldset id="locationList">
			<legend class="inner">
				Where were you?
				<em class="alert">
					<xsl:apply-templates select="MULTI-ELEMENT[@NAME='LOCATION']" mode="validate">
						<xsl:with-param name="msg">Please provide a location.</xsl:with-param>
						<xsl:with-param name="cancel" select="@CANCEL"/>
					</xsl:apply-templates>
				</em>
				<span>If you were in the UK, select the BBC site relevant to the location of your memory - see more in 
					Memoryshare FAQs.
				</span>
			</legend>

			<script type="text/javascript">
			<![CDATA[ 
				writeTabNav();
			]]>
			</script>

			<xsl:variable name="mapUrl" select="concat($flashsource, 'locationMap.swf')"/>

			<div id="flashMapTarg">
				<script language="JavaScript" type="text/javascript">
					var mapUrl = "<xsl:value-of select="$mapUrl"/>";
					var mapWidth = 437;
					var mapHeight = 350;
				</script>
				<script language="JavaScript" type="text/javascript">
				<![CDATA[
				    if (bbcjs.plugins.flashVersion >= 8) {
						var wilmap = new bbcjs.plugins.FlashMovie(mapUrl);
						wilmap.version = 8;
						wilmap.width = mapWidth;
						wilmap.height = mapHeight;
						wilmap.id = 'WILMap';
						wilmap.name = 'WILMap';
						wilmap.allowScriptAccess = 'always';
						wilmap.loop = true; // taking this out will break the map in certain circs.

						// fnHideItem("noFlashContent");
						bbcjs.addOnLoadItem('fnHideItem("noFlashContent")');
						
						wilmap.embed();
						// myEmbed(wilmap);
						
						// put this in to overcome javascript error in IE
						// which occurs when flash uses ExternalInterface
						WILMap = document.getElementById("WILMap");
				    }
				]]>                    
				</script>
			</div>

			<xsl:call-template name="GENERATE_COMBINED_LOCATION_RADIOS_NON_FLASH_CONTENT">
				<xsl:with-param name="selectedValue" select="MULTI-ELEMENT[@NAME='LOCATION']/VALUE"/>
			</xsl:call-template>
			
			<!--[FIXME: previous version of the div.inner3_4 below; can be deleted if the div below is OK]
			<div class="inner">
				<label for="locationuser">Other/More specific Location</label>
				<input type="text" name="locationuser" id="locationuser">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
			</div>
			-->
			<div class="inner3_4">
				<!-- moved from utils.xsl -->
				<!--[FIXME: remove radio]
				<fieldset>
					<legend>Other location</legend>
					<div class="row">
						<input type="radio" class="radio" name="location" id="otherLocation" value="_location-Other Other _location-location location">
							<xsl:if test="MULTI-ELEMENT[@NAME='LOCATION']/VALUE-EDITABLE = '_location-Other Other _location-location location'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label for="otherLocation">Other location</label>
					</div>
				</fieldset>
				-->
				
				<label for="locationuser" class="bld">Tell us more (e.g France, Paris or England, Portsmouth)</label><br/>
				<input type="text" name="locationuser" id="locationuser" class="txtWide">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>
			</div>
    		</fieldset>
    
		<div class="inner">
			<fieldset id="keywordBlock">
				<label for="keywords">
					<strong>Keywords</strong><br/>
					Keywords may relate to a place or event or activity. 
					You can add one or more keywords, separating them with a <xsl:value-of select="$keyword_sep_name"/> e.g. Glastonbury<xsl:value-of select="$keyword_sep_char"/>festival<xsl:value-of select="$keyword_sep_char"/>rain
					<em class="alert">
						<xsl:apply-templates select="MULTI-ELEMENT[@NAME='KEYWORDS']" mode="validate">
							<xsl:with-param name="msg">Please enter one or more keywords.</xsl:with-param>
							<xsl:with-param name="cancel" select="@CANCEL"/>
						</xsl:apply-templates>
					</em>
				</label>
				<textarea name="keywords" id="keywords" rows="4">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
				</textarea>
			</fieldset>

			<!-- submit buttons -->
			<div class="addMemSubmit">
				<script language="javascript" type="text/javascript">
					var articlesearchroot = '<xsl:value-of select="$articlesearchroot"/>';
				</script>
				<script language="javascript" type="text/javascript">
				<![CDATA[
					document.write('<input type="button" name="acancel" value="Cancel" class="submit" onclick="document.location=\'' + articlesearchroot + '\'"/> ');
				]]>
				</script>
				<noscript>
					<a href="{$articlesearchroot}" class="cancelLink">Cancel</a>
				</noscript>
				<input type="submit" name="apreview" value="Preview" class="submit"/><xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
						<input type="submit" name="aupdate" value="Publish" class="submit"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="submit" name="acreate" value="Publish" class="submit"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</div>
	<xsl:call-template name="SEARCH_RSS_FEED"/>
</xsl:template>




<!-- 
#############################################################
EDITORIAL ARTICLE FORM
#############################################################
-->
<!-- form used for creating an editorial article -->
<!--						
This page is for editors to set up article to pull in a dynamic list.
The article will not have any comments or ratings.
The article will be status 1 so will not appear on your members page
-->
<xsl:template name="EDITORIAL_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$editorial_article_fields}"/>
	
	<!--[FIXME: do we need this?]
	<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	-->
	
	<!-- form -->
	<div id="topPage">
		<div class="innerWide">
			<div id="shortDescForm">
				<h2>Editorial Article</h2>									
				<p>
					<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>
				</p>

				<label for="title" class="bld">
					title
					<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<em class="alert">Please enter a title</em>
					</xsl:if>
				</label><br/>
				<input type="text" name="TITLE" id="title" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>

				<label for="introtext" class="bld">Intro Text</label><br/>
				<input type="text" name="INTROTEXT" id="introtext">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='INTROTEXT']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>

				<label for="description" class="bld">
					Body
					<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<em class="alert">Please enter your article text</em>
					</xsl:if>
				</label><br/>
				<textarea name="body" rows="20" id="description">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>

				<div class="submitRow">
					<xsl:call-template name="SUBMIT_BUTTONS" />
				</div>
			</div>
		</div>
	</div>
</xsl:template>


<xsl:template name="AUTO_HIDDEN_FIELDS">
	<xsl:param name="keyword"/>
	<xsl:param name="visibletag"/>
	
	<!--[FIXME: take out this guard?]
	<xsl:if test="$client_keyword != $vanilla_client_keyword">
	-->
		<xsl:choose>
			<!-- when in edit mode echo back the article's client keyword, if any.
				 otherwise use the viewing users client
			-->
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<input type="hidden" name="client" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='CLIENT']/VALUE-EDITABLE}"/>
				<xsl:if test="$typedarticle_visibletag = 'yes'">
					<input type="hidden" name="visibleclient" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='VISIBLECLIENT']/VALUE-EDITABLE}"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="client" value="{$keyword}"/>
				<xsl:if test="$typedarticle_visibletag = 'yes'">
					<input type="hidden" name="visibleclient" value="{$visibletag}"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	<!--[FIXME: take out this guard?]
	</xsl:if>
	-->
</xsl:template>

<!-- 
#############################################################
SUBMIT BUTTONS
#############################################################
-->
<!-- preview, create and edit buttons -->
<xsl:template name="SUBMIT_BUTTONS">
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	<xsl:apply-templates select="." mode="c_articleeditbutton"/>
	<xsl:apply-templates select="." mode="c_articlecreatebutton"/>

	<!-- force user to preview before submitting by only presenting submit button when previewing and when no errors -->
	<!--[FIXME: not needed?]
	<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' and not(*/ERRORS)">
		<xsl:apply-templates select="." mode="c_articleeditbutton"/>
		<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
	</xsl:if>
	-->
</xsl:template>

<!-- submit buttons attributes -->
<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">preview</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>
	
<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<!-- max characters -->
<xsl:variable name="maxcharacters_textinput_value">56</xsl:variable>
<xsl:template name="maxcharacters_textinput_text">
	<div class="inputinfo">56 characters max</div>
</xsl:template>
<xsl:template name="maxcharacters_textinput_text2">
	<div class="inputinfo2">56 characters max</div>
</xsl:template>


<!-- VALIDATION -->
<xsl:template match="MULTI-REQUIRED | MULTI-ELEMENT" mode="validate">
	<xsl:param name="msg"/>
	<xsl:param name="cancel"/>

	<xsl:if test="not($cancel='YES')">
		<xsl:if test="ERRORS/ERROR/@TYPE">
			<xsl:value-of select="$msg"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>


<!-- 
	DATE FIELDS
	[FIXME: does this have to be duplicated in articlesearch?
	is there some way consolidate the two?]
-->
<!--
<xsl:template name="DATEFIELDS_SPECIFIC">
	<p>
		<input type="hidden" name="timeinterval" id="timeinterval" value="1"/>
		<label for="startday">Date</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_DATERANGE">
	<p>
		<label for="startday">Between</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="endday">and</label>
		<select name="endday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="endmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="endyear" size="4" id="endyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_FUZZYDATE">
	<p>
		<label for="startday">Somewhere between</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="endday">and</label>
		<select name="endday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="endmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="endyear" size="4" id="endyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="timeinterval" class="radioLabel">lasting</label>

		<input type="text" size="2" name="timeinterval" id="timeinterval">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
		days
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_NODATE">
	<p>
		Please note that your memory will now not be available within the 
		timeline for people to view as you have not associated a date with it. 
	</p>
</xsl:template>
-->
</xsl:stylesheet>


