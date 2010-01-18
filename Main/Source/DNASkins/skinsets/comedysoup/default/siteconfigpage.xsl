<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-siteconfigpage.xsl"/>
	<xsl:variable name="configfields"><![CDATA[<MULTI-INPUT><ELEMENT NAME='TOPPICKS'></ELEMENT><ELEMENT NAME='INTROTEXT'></ELEMENT><ELEMENT NAME='BBCTHREE'></ELEMENT><ELEMENT NAME='PROGRAMMECHALLENGESCONFIG'></ELEMENT><ELEMENT NAME='EMBEDEDVIDEOCONFIG'></ELEMENT><ELEMENT NAME='RSSCONFIG'></ELEMENT><ELEMENT NAME='POPULARCHALLENGES'></ELEMENT><ELEMENT NAME='SOUPDEJOUR'></ELEMENT><ELEMENT NAME='OTHERPROGRAMMECHALLENGES'></ELEMENT><ELEMENT NAME='PROGRAMMECHALLENGESPROMO1'></ELEMENT><ELEMENT NAME='PROGRAMMECHALLENGESPROMO2'></ELEMENT><ELEMENT NAME='PROGRAMMECHALLENGESPROMO3'></ELEMENT><ELEMENT NAME='ASSETLIBRARYHELP'></ELEMENT><ELEMENT NAME='POPULARRAWMATERIAL'></ELEMENT></MULTI-INPUT>]]></xsl:variable>
						
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
			<xsl:with-param name="message">SITECONFIG-EDITOR_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">siteconfigpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		
		<p><a href="{$root}Siteconfig?_msxml={$configfields}">Initialise fields</a><br />
		<!-- Site - <xsl:value-of select="SITECONFIG-EDIT/URLNAME"/> --></p>
		
		<xsl:apply-templates select="ERROR" mode="c_siteconfig"/>
		<xsl:apply-templates select="SITECONFIG-EDIT" mode="c_siteconfig"/>
		
	</xsl:template>
	
	<xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="_msxml" value="{$configfields}"/>
		<!-- <input type="hidden" name="skin" value="purexml"/> -->
		
    <h2><label>Top Picks</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="toppicks" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TOPPICKS'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'TOPPICKS']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='toppicks']/VALUE" /></td>
		</tr>
		</table>

    
    <h2>
      <label>Intro Text</label>
    </h2>
    <table>
      <tr>
        <td style="padding-left:10px;">
          <textarea name="introtext" rows="8" cols="40">
            <xsl:choose>
              <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'INTROTEXT'">
                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'INTROTEXT']/VALUE-EDITABLE"/>
              </xsl:when>
              <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
            </xsl:choose>
          </textarea>
        </td>
        <td valign="top">
          <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='introtext']/VALUE" />
        </td>
      </tr>
    </table>

    
		<h2><label>BBC THREE promo</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="bbcthree" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'BBCTHREE'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'BBCTHREE']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='BBCTHREE']/VALUE" /></td>
		</tr>
		</table>
		
    
		<h2><label>Programme Challenges Config</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="programmechallengesconfig" rows="8" cols="80" style="width:600px;">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROGRAMMECHALLENGESCONFIG'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'PROGRAMMECHALLENGESCONFIG']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
		</tr>
		</table>
		
		
		<h2><label>Popular Challenges</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="popularchallenges" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'POPULARCHALLENGES'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'POPULARCHALLENGES']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='POPULARCHALLENGES']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Embedded Video Config</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="embededvideoconfig" rows="8" cols="80" style="width:600px;">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'EMBEDEDVIDEOCONFIG'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'EMBEDEDVIDEOCONFIG']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
		</tr>
		</table>

		<h2><label>RSS Config</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="rssconfig" rows="8" cols="80" style="width:600px;">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'RSSCONFIG'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'RSSCONFIG']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
		</tr>
		</table>
		
		<h2><label>Soup de Jour</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="SOUPDEJOUR" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'SOUPDEJOUR'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'SOUPDEJOUR']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SOUPDEJOUR']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Other Programme Challenges</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="otherprogrammechallenges" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'OTHERPROGRAMMECHALLENGES'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'OTHERPROGRAMMECHALLENGES']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='OTHERPROGRAMMECHALLENGES']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Programme Challenges Promo 1</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="programmechallengespromo1" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROGRAMMECHALLENGESPROMO1'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'PROGRAMMECHALLENGESPROMO1']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROGRAMMECHALLENGESPROMO1']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Programme Challenges Promo 2</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="programmechallengespromo2" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROGRAMMECHALLENGESPROMO2'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'PROGRAMMECHALLENGESPROMO2']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROGRAMMECHALLENGESPROMO2']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Programme Challenges Promo 3</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="programmechallengespromo3" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROGRAMMECHALLENGESPROMO3'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'PROGRAMMECHALLENGESPROMO3']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROGRAMMECHALLENGESPROMO3']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Asset Library Help</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="assetlibraryhelp" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'ASSETLIBRARYHELP'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'ASSETLIBRARYHELP']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ASSETLIBRARYHELP']/VALUE" /></td>
		</tr>
		</table>
		
		<h2><label>Popular Raw Material</label></h2>
		<table>
		<tr>
			<td style="padding-left:10px;">
				<textarea name="popularrawmaterial" rows="8" cols="40">
					<xsl:choose>
						<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'POPULARRAWMATERIAL'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'POPULARRAWMATERIAL']/VALUE-EDITABLE"/></xsl:when>
						<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
					</xsl:choose>
				</textarea>
		</td>
			<td valign="top"><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='POPULARRAWMATERIAL']/VALUE" /></td>
		</tr>
		</table>
		
		<!-- <input type="submit" name="_mscancel" value="preview"/> -->
		<xsl:apply-templates select="." mode="t_configeditbutton"/>
	</xsl:template>
	
	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
	<xsl:template match="ERROR" mode="r_siteconfig">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
