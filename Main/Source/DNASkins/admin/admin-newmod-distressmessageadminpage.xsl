<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template name="DISTRESSMESSAGESADMIN_MAINBODY">
	Author:	Andy Harris
	Context:     	/H2G2
	Purpose:	Main body template
	-->
	<xsl:template name="DISTRESSMESSAGESADMIN_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">distressmessages?s_classview=<xsl:value-of select="@CLASSID"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<div id="mainContent">
			<xsl:apply-templates select="DISTRESSMESSAGES" mode="messageslist"/>
		</div>
	</xsl:template>
	<xsl:template match="DISTRESSMESSAGES" mode="messageslist">
		<table id="moderate-nickname-table" cellspacing="0">
			<thead>
				<tr>
					<td>
						<xsl:text>Id</xsl:text>
					</td>
					<td>
						<xsl:text>Title</xsl:text>
					</td>
					<td>
						<xsl:text>Text</xsl:text>
					</td>
					<td>
						<xsl:text>ACTIONS</xsl:text>
					</td>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="DISTRESSMESSAGE" mode="message"/>
			</tbody>
		</table>
		<xsl:apply-templates select="." mode="messageform"/>
	</xsl:template>
	<xsl:template match="DISTRESSMESSAGE" mode="message">
		<xsl:if test="MODCLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">
			<tr>
				<xsl:if test="position() mod 2 = 0">
					<xsl:attribute name="class">evenRow</xsl:attribute>
				</xsl:if>
				<td>
					<xsl:value-of select="@ID"/>
				</td>
				<td>
					<xsl:value-of select="SUBJECT"/>
				</td>
				<td>
					<xsl:value-of select="TEXT"/>
				</td>
				<td>
					<form action="distressmessages" method="post">
						<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
						<input type="hidden" name="action" value="remove"/>
						<input type="hidden" name="modclassid" value="{MODCLASSID}"/>
						<input type="hidden" name="messageid" value="{@ID}"/>
						<input type="submit" name="remove" value="remove"/>
					</form>
					<form action="distressmessages" method="post">
						<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
						<input type="hidden" name="s_view" value="edit"/>
						<input type="hidden" name="s_messageid" value="{@ID}"/>
						<input type="submit" name="edit" value="edit"/>
					</form>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template match="DISTRESSMESSAGES" mode="messageform">
		<form action="distressmessages" method="post" id="distressForm">
			<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'edit'">
					<input type="hidden" name="action" value="edit"/>
					<input type="hidden" name="messageid" value="{/H2G2/PARAMS/PARAM[NAME = 's_messageid']/VALUE}"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="hidden" name="action" value="add"/>
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="modclassid" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<div id="distressSubject">
				<label for="subject">
					<xsl:text>Title</xsl:text>
				</label>
				<input type="text" name="subject" size="50">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'edit'">
						<xsl:attribute name="value"><xsl:value-of select="DISTRESSMESSAGE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_messageid']/VALUE]/SUBJECT"/></xsl:attribute>
					</xsl:if>
				</input>
			</div>
			<div id="distressText">
				<label for="text">
					<xsl:text>Text</xsl:text>
				</label>
				<textarea rows="15" cols="50" name="text">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'edit'">
							<xsl:value-of select="DISTRESSMESSAGE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_messageid']/VALUE]/TEXT"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>&nbsp;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</textarea>
			</div>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'edit'">
					<input type="submit" name="edit" value="edit"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="submit" name="add" value="add"/>
				</xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>
</xsl:stylesheet>
