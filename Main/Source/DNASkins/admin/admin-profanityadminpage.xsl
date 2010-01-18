<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="PROFANITYADMIN_HEADER">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="PROFANITYADMIN_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA - Profanity Admin
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="PROFANITYADMIN_SUBJECT">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="PROFANITYADMIN_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Profanity Admin
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="PROFANITYADMIN_CSS">
	Author:		Wendy Mann
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="PROFANITYADMIN_CSS">
		<style type="text/css"> 
			@import "http://www.bbc.co.uk/dnaimages/boards/includes/fonts.css" ;
		</style>
		<link href="http://www.bbc.co.uk/dnaimages/adminsystem/includes/dna_admin.css" rel="stylesheet" type="text/css"/>
		<style type="text/css">
			#lhn {width: 190px; float:left;}
			#lhn {padding: 5px; margin:3px;}
			#lhn li.selected {background:#dddddd;}
			
			#mainArea {width:540px; float:left; padding: 5px; margin:3px; border-left: 1px solid #0000cc;}
			#mainArea th {width:200px;}
		</style>
	</xsl:template>
	<!--
=================================================
=================================================
	PROFANITYADMIN templates 
=================================================
=================================================
-->
	<xsl:variable name="modClass">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_class']/VALUE">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_class']/VALUE"/>
			</xsl:when>
			<xsl:when test="not(/H2G2/PROFANITYADMIN/ACTION/@MODCLASSID = 0)">
				<xsl:value-of select="/H2G2/PROFANITYADMIN/ACTION/@MODCLASSID"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="PROFANITYADMIN_MAINBODY">
		<div id="topNav">
			<div id="bbcLogo">
				<img src="{$dnaAdminImgPrefix}/images/config_system/shared/bbc_logo.gif" alt="BBC"/>
			</div>
			<h1>DNA admin</h1>
		</div>
		<div style="width:770px; float:left;">
			<xsl:call-template name="sso_statusbar-admin"/>
			<div id="subNav" style="background:#f4ebe4 url({$dnaAdminImgPrefix}/images/config_system/shared/icon_mod_man.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h2>Profinity Admin</h2>
				</div>
			</div>
			<ul id="lhn">
				<p style="margin-bottom:10px; color:#000000; font-weight:bold;">Moderation Classes</p>
				<xsl:apply-templates select="PROFANITYADMIN/MODERATION-CLASSES/MODERATION-CLASS" mode="lefthandNav"/>
			</ul>
			<div id="mainArea">
				<xsl:apply-templates select="PROFANITYADMIN" mode="mainContent"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="MODERATION-CLASS" mode="lefthandNav">
		<li>
			<xsl:if test="($modClass = @CLASSID)">
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
			<a href="{$root}profanityadmin?s_class={@CLASSID}">
				<xsl:value-of select="NAME"/>
			</a>
		</li>
	</xsl:template>
	<xsl:template match="PROFANITYADMIN" mode="mainContent">
		<xsl:choose>
			<xsl:when test="ACTION = 'addprofanities'">
				<xsl:apply-templates select="PROFANITY-LISTS" mode="profanityAdd"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_update']/VALUE = 'yes'">
				<xsl:apply-templates select="PROFANITY-LISTS" mode="profanityUpdate"/>
			</xsl:when>
			<xsl:when test="ACTION = 'importprofanities'">
				<xsl:apply-templates select="PROFANITY-LISTS" mode="profanityImport"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="PROFANITY-LISTS" mode="profanityList"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template match="PROFANITY-LISTS" mode="profanityList">
		<xsl:apply-templates select="PROFANITY-LIST[@MODCLASSID = $modClass]" mode="profanityList"/>
		<br/>
		<a href="profanityadmin?action=addprofanities&amp;modclassid={$modClass}" class="buttonThreeD">Add a new profanity</a>
		<a href="profanityadmin?action=importprofanities&amp;modclassid={$modClass}" class="buttonThreeD">Add several profanities</a>
	</xsl:template>
  
	<xsl:template match="PROFANITY-LIST" mode="profanityList">
		<table>
			<thead>
				<tr>
					<th>Profanity</th>
					<th>Action</th>
					<th colspan="2">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
        <xsl:for-each select="PROFANITY">
          <xsl:sort select="."/>
          <xsl:call-template name="PROFANITY"/>
        </xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
  
	<xsl:template name="PROFANITY">
		<tr>
			<td>
				<xsl:value-of select="."/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="@REFER = 1">
						<p style="font-style:italic; color:#000000;">Send message to moderation</p>
					</xsl:when>
					<xsl:otherwise>
						<p style="font-style:italic; color:#000000;">Ask user to re-edit word</p>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<a href="{$root}profanityadmin?action=updateprofanities&amp;s_profanityid={@ID}&amp;modclassid={../@MODCLASSID}&amp;s_update=yes">edit</a>
			</td>
			<td>
				<a href="{$root}profanityadmin?action=updateprofanities&amp;profanity={.}&amp;profanityid={@ID}&amp;profanityedited=1&amp;modclassid={../@MODCLASSID}&amp;delete=on">delete</a>
			</td>
		</tr>
	</xsl:template>
  
	<xsl:template match="PROFANITY-LISTS" mode="profanityAdd">
		Add Profanity
		<form action="profanityadmin" method="post" xmlns="">
			<input type="hidden" name="action" value="addprofanities"/>
			<input type="hidden" value="0" name="profanityid"/>
			<input type="hidden" name="modclassid" value="{/H2G2/PROFANITYADMIN/ACTION/@MODCLASSID}"/>
			<table>
				<thead>
					<tr>
						<th>Profanity</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<input type="text" name="profanity"/>
						</td>
						<td>
							<select name="refer">
								<option value="off">Ask user to re-edit word</option>
								<option value="on">Send message to moderation</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="submit" name="Process" value="Submit word" class="buttonThreeD"/>
		</form>
	</xsl:template>
  
	<xsl:template match="PROFANITY-LISTS" mode="profanityUpdate">
		Update Profanity
		<form action="profanityadmin" method="post" xmlns="">
			<input type="hidden" name="action" value="updateprofanities"/>
			<input type="hidden" value="{/H2G2/PARAMS/PARAM[NAME='s_profanityid']/VALUE}" name="profanityid"/>
			<input type="hidden" name="modclassid" value="{/H2G2/PROFANITYADMIN/ACTION/@MODCLASSID}"/>
			<input type="hidden" name="profanityedited" value="1"/>
			<table>
				<thead>
					<tr>
						<th>Profanity</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<input type="text" name="profanity" value="{PROFANITY-LIST[@MODCLASSID = /H2G2/PROFANITYADMIN/ACTION/@MODCLASSID]/PROFANITY[@ID = /H2G2/PARAMS/PARAM[NAME='s_profanityid']/VALUE]}"/>
						</td>
						<td>
							<select name="refer">
								<option value="off">
									<xsl:if test="PROFANITY-LIST[@MODCLASSID = /H2G2/PROFANITYADMIN/ACTION/@MODCLASSID]/PROFANITY[@ID = /H2G2/PARAMS/PARAM[NAME='s_profanityid']/VALUE]/@REFER = 0">
										<xsl:attribute name="selected">1</xsl:attribute>
									</xsl:if>
									<xsl:text>Ask user to re-edit word</xsl:text>
								</option>
								<option value="on">
									<xsl:if test="PROFANITY-LIST[@MODCLASSID = /H2G2/PROFANITYADMIN/ACTION/@MODCLASSID]/PROFANITY[@ID = /H2G2/PARAMS/PARAM[NAME='s_profanityid']/VALUE]/@REFER = 1">
										<xsl:attribute name="selected">1</xsl:attribute>
									</xsl:if>
									<xsl:text>Send message to moderation</xsl:text>
								</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="submit" name="Process" value="Submit word" class="buttonThreeD"/>
		</form>
    
	</xsl:template>
	<xsl:template match="PROFANITY-LISTS" mode="profanityImport">
    <table>
      <tr>
        <td>
          <b>Add several profanities</b>
        </td>
      </tr>
      <tr>
        <td>Format: Profanity, ReferValue e.g.</td>
      </tr>
      <tr>
        <td>
          profanity1,0<BR/>
          profanity2,0
        </td>
      </tr>
      <tr>
        <td>
          <form action="profanityadmin" method="post">
            <input type="hidden" value="importprofanities" name="action"/>
            <input type="hidden" name="modclassid" value="{/H2G2/PROFANITYADMIN/ACTION/@MODCLASSID}"/>
            <textarea name="profanitylist" cols="50" rows="20"/>
            <input type="submit" name="Process" value="Submit list" class="buttonThreeD"/>
          </form>
        </td>
      </tr>
    </table>
	</xsl:template>
</xsl:stylesheet>
