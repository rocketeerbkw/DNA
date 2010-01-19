<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<xsl:template name="URLFILTERADMIN_JAVASCRIPT">
	<script language="Javascript">
		<![CDATA[
		function CloseAndReloadParent()
		{
			window.opener.location.reload()
			window.opener.focus()
			this.window.close()
		}
		function SetEdited(id)
		{
			var elem = document.getElementById(id);
			elem.value = 1;
		}
		]]>
	</script>
	</xsl:template>

	<xsl:template name="URLFILTERADMIN_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				URL Filter Admin
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>
	<xsl:template name="URLFILTERADMIN_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA Administration - URL Filter Admin
			</xsl:with-param>
		</xsl:apply-templates>

	</xsl:template>
	
<xsl:template name="URLFILTERADMIN_MAINBODY">
	<xsl:call-template name="sso_statusbar-admin"/>
	<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
					<div id="subNavText">
						<h4> DNA Administration - URL Filter Admin</h4>
		</div>
	</div>
	<br/>
<div id="contentArea">
<div class="centralAreaRight">
	<div class="header">
		<img src="{$adminimagesource}t_l.gif" alt=""/>
	</div>
<div class="centralArea">
<form action="urlfilteradmin" method="post">
<select name="s_siteid">
<option>Select DNA Site</option>
<xsl:for-each select="/H2G2/EDITABLESITES/SITE">
<xsl:sort select="NAME"/>
<option value="{@ID}">
<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE=@ID">
	<xsl:attribute name="selected">selected</xsl:attribute>
</xsl:if>
<xsl:value-of select="NAME"/>
</option>
</xsl:for-each>
</select>
<br />
<input type="Submit" value="Change Site"  class="buttonThreeD" style="width:180px;"/>
</form>
<br clear="all" />

		<xsl:variable name="action" select="URLFILTERADMIN/ACTION"/>
		<xsl:choose>
			<xsl:when test="$action = 'addallowedurl'">
				<xsl:call-template name="addallowedurl"/>
			</xsl:when>
			<xsl:when test="$action = 'importallowedurls'">
				<xsl:call-template name="importallowedurls"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="listallowedurls"/>
			</xsl:otherwise>
		</xsl:choose>
		
  </div>
<div class="footer">

</div>	
</div>							
</div>
		
</xsl:template>

<xsl:template name="URLFILTERADMIN_CSS">

<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/admin.css"/>
</xsl:template>

<!-- not used for now -->
<xsl:template name="addallowedurl">
	<form action="urlfilteradmin" method="post">
	<input type="hidden" name="action" value="addallowedurl"/>
	<xsl:variable name="siteid" select="/H2G2/URLFILTERADMIN/ACTION/@SITEID"/>
	<xsl:value-of select="$siteid"/>
	<table>
	<thead>
		<tr>
			<th>URL</th>
		</tr>
	</thead>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>
	<tr>
		<td><input type="text" name="allowedurl"/>
		<input type="hidden" value="0" name="urlid"/>
		<input type="hidden" name="siteid" value="{$siteid}"/></td>
	</tr>	
	</table>
	<p><input type="submit" name="Process" value="Update" class="buttonThreeD"/></p>
	</form>	
</xsl:template>

<xsl:template name="importallowedurls">
	<table border="0" cellpadding="0" cellspacing="0" class="adminMenu" style="width:500px;">
		<tr class="adminSecondHeader">
			<td>Import Allowed URL</td>
		</tr>
	</table>
	<form action="urlfilteradmin" method="post">
	<input type="hidden" value="importallowedurls" name="action"/>
	<input type="hidden" name="siteid" value="{/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE}" />
	<input type="hidden" name="s_siteid" value="{/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE}" />
	<p>
	<textarea name="urlfilterlist" cols="30" rows="10" style="width:500px;"></textarea>
	</p>
	<p><input type="submit" name="Process" value="Process" class="buttonThreeD"/></p>
	</form>
	
</xsl:template>

<xsl:template name="listallowedurls">
	<form action="urlfilteradmin" method="post">
	<input type="hidden" value="updateallowedurl" name="action"/>
	<xsl:for-each select="/H2G2/URLFILTERADMIN/URLFILTER-LISTS/URLFILTER-LIST">
		<xsl:variable name="siteid" select="@SITEID"/>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE=$siteid">
		<table id="tbl{generate-id(.)}" border="0" cellpadding="0" cellspacing="0" class="adminMenu">
			<tr class="adminSecondHeader">
				<td>Allowed URL: Site <xsl:value-of select="$siteid"/> - <xsl:value-of select="/H2G2/EDITABLESITES/SITE[@ID = $siteid]/NAME"/></td>
				<td>Actions</td>
				<td style="font-size:70%;"><a href="urlfilteradmin?action=importallowedurls&amp;s_siteid={@SITEID}"><![CDATA[<< ]]>Add allowed URLs</a></td>
			</tr>
			<xsl:for-each select="ALLOWEDURL">
			<tr>
				<td>
					<input type="text" onchange="javascript:SetEdited('{generate-id(.)}')" name="allowedurl" style="width:300px;">
						<xsl:attribute name="value">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</input>
					<input type="hidden" name="allowedurlid">
						<xsl:attribute name="value">
							<xsl:value-of select="@ID"/>
						</xsl:attribute>
					</input>
					<input type="hidden" value="0" name="allowedurledited" id="{generate-id(.)}"/>
					<input type="hidden" value="{$siteid}" name="siteid"/>
					<input type="hidden" value="{$siteid}" name="s_siteid"/>

				</td>
				<td>
					Delete:<input type="checkbox" name="delete" onchange="javascript:SetEdited('{generate-id(.)}')"/>
				</td>
			</tr>
			</xsl:for-each>
		</table>
			</xsl:if>
	</xsl:for-each>
		<xsl:variable name="s_siteid" select="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE"/>
		<xsl:choose>
		<xsl:when test="count(/H2G2/URLFILTERADMIN/URLFILTER-LISTS/URLFILTER-LIST[@SITEID = $s_siteid]/ALLOWEDURL) > 0">
		<p><input type="submit" value="Update" name="Process" class="buttonThreeD"/></p>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="/H2G2/URLFILTERADMIN/RESULT/SUCCESS = 1">
				<p>Updated.</p>
			</xsl:when>
			<xsl:otherwise>
				<p>No URLs</p>
				<p><a href="urlfilteradmin?action=importallowedurls&amp;s_siteid={$s_siteid}">Add allowed URLs</a></p>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
		</xsl:choose>
			</form>
</xsl:template>

</xsl:stylesheet>