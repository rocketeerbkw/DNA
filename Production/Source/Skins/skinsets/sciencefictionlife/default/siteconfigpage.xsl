<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">

]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-siteconfigpage.xsl"/>
	<xsl:variable name="configfields"><![CDATA[<MULTI-INPUT>


					<ELEMENT NAME='PROMO1'></ELEMENT>
					<ELEMENT NAME='CONNECTED_WITH'></ELEMENT>
					<ELEMENT NAME='SAYING_WHAT'></ELEMENT>
					<ELEMENT NAME='SEARCH_BOX'></ELEMENT>
					<ELEMENT NAME='ALSO_BBC'></ELEMENT>
					<ELEMENT NAME='ALSO_WEB'></ELEMENT>

				</MULTI-INPUT>]]></xsl:variable>
				
				 
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SITECONFIG-EDITOR_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">SITECONFIG-EDITOR_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">siteconfigpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:if test="$test_IsEditor">

			<xsl:apply-templates select="ERROR" mode="c_siteconfig"/>
			
			<xsl:choose>
		 		<xsl:when test="not(SITECONFIG-EDIT/MULTI-STAGE[descendant::MULTI-ELEMENT!=''])">
					<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
					<input type="hidden" name="_msxml" value="{$configfields}"/>
					<input type="submit" value="initialise siteconfig" />
					</form>
					
				</xsl:when>
				<xsl:otherwise>
				
					<xsl:apply-templates select="SITECONFIG-EDIT" mode="c_siteconfig"/>
				</xsl:otherwise>
			</xsl:choose>

	</xsl:if>
	
	
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">

		<input type="hidden" name="_msfinish" value="yes"/>
		<!--  <input type="hidden" name="skin" value="purexml"/>  --> 
		<input type="hidden" name="_msxml" value="{$configfields}"/>
		<input type="submit" name="bob" value="submit"/>
		<input type="submit" name="_mscancel" value="preview"/>

		<br/>
		<br/>

		<!-- PROMO1 -->
		<table border="1" cellspacing="2" cellpadding="2">
			<tr>
				<td valign="top">
					<b>Feature 1: This content will be used if alternative content is not defined using TypedArticle</b>
					<br/>
					<textarea type="text" name="PROMO1" rows="5" cols="60">
						<xsl:choose>
							<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROMO1'">
								<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO1']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</td>
				<td valign="top">
					<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO1']/VALUE" />
				</td>
			</tr>
		</table>
		
		<!-- SEARCH BOX -->
		<table border="1" cellspacing="2" cellpadding="2">
			<tr>
				<td valign="top">
					<b>Search box:</b>
					<br/>
					<textarea type="text" name="search_box" rows="5" cols="60">
						<xsl:choose>
							<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'SEARCH_BOX'">
								<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SEARCH_BOX']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</td>
				<td valign="top">
					<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SEARCH_BOX']/VALUE" />
				</td>
			</tr>
		</table>


		<!-- CONNECTED WITH  -->
		<!-- <table border="1" cellspacing="2" cellpadding="2">
			<tr>
				<td valign="top">
				<b>Associate Articles:</b>
				<br/>
					<textarea type="text" name="CONNECTED_WITH" rows="5" cols="60">
						<xsl:choose>
							<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'CONNECTED_WITH'">
								<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CONNECTED_WITH']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</td>
				<td valign="top">
					<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CONNECTED_WITH']/VALUE" />
				</td>
			</tr>
		</table> -->

		<!-- WHO'S SAYING WHAT  -->
		<table border="1" cellspacing="2" cellpadding="2">
			<tr>
				<td valign="top">
				<b>Who's Saying What:</b>
				<br/>
					<textarea type="text" name="SAYING_WHAT" rows="5" cols="60">
						<xsl:choose>
							<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'SAYING_WHAT'">
								<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SAYING_WHAT']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</td>
				<td valign="top">
					<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SAYING_WHAT']/VALUE" />
				</td>
			</tr>
		</table>

		<!-- LIST OF ARTICLES FOR DROP DOWN  -->
		<table border="1" cellspacing="2" cellpadding="2">
			<tr>
				<td valign="top">
				<b>List of articles for drop down:</b><br />
				&lt;option value="348832"&gt;Article Title&lt;/option&gt;
				<br/>
					<textarea type="text" name="ARTICLE_LIST" rows="5" cols="60">
						<xsl:choose>
							<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'ARTICLE_LIST'">
								<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ARTICLE_LIST']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</td>
				<td valign="top">
					<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ARTICLE_LIST']/VALUE" />
				</td>
			</tr>
		</table>


		
	
	
	

		<!-- EDIT BUTTON -->
		<!-- <xsl:apply-templates select="." mode="t_configeditbutton"/> -->
		<!--input type="hidden" name="skin" value="purexml"/-->
		<input type="submit" name="bob" value="submit"/>
		<input type="submit" name="_mscancel" value="preview"/>
	</xsl:template>
	
	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
	
	<xsl:template match="ERROR" mode="r_siteconfig">
		<xsl:apply-imports/>
	</xsl:template>

</xsl:stylesheet>