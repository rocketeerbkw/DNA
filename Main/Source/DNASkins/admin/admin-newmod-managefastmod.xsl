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
		<xsl:template name="MANAGE-FAST-MOD_MAINBODY">
		Author:	Andy Harris
		Context:     	/H2G2
		Purpose:	Main body template
	-->
	<xsl:template name="MANAGE-FAST-MOD_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">managefastmod?s_classview=<xsl:value-of select="@CLASSID"/>&amp;site=<xsl:value-of select="/H2G2/MANAGE-FAST-MOD/SITE/URLNAME"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<div id="mainContent">
			<xsl:apply-templates select="SITE-LIST" mode="site_dropdown_form"/>
			<xsl:apply-templates select="MANAGE-FAST-MOD" mode="crumbtrail"/>
			<xsl:apply-templates select="MANAGE-FAST-MOD/FEEDBACK" mode="fastmod_feedback_strip"/>
			<xsl:apply-templates select="MANAGE-FAST-MOD/MANAGEABLE-TOPICS" mode="topic_list"/>
		</div>
	</xsl:template>
	<!-- 
		<xsl:template match="SITE-LIST" mode="site_dropdown_form">
		Author:	Andy Harris
		Context:     	/H2G2/SITE-LIST
		Purpose:	This create the dropdown of sites for the navigation. It filters based on the currently select moderation class view
	-->
	<xsl:template match="SITE-LIST" mode="site_dropdown_form">
		<form action="managefastmod" method="post" id="site-select-form">
			<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<label id="site-select">
				<xsl:text>Select site:</xsl:text>
			</label>
			<select name="siteid">
				<xsl:apply-templates select="SITE" mode="site_dropdown"/>
			</select>
			<input type="submit" name="submit" value="Go"/>
		</form>
	</xsl:template>
	<!-- 
		<xsl:template match="SITE" mode="site_dropdown">
		Author:	Andy Harris
		Context:     	/H2G2/SITE-LIST
		Purpose:	This is the template that does the filtering by moderation class
	-->
	<xsl:template match="SITE" mode="site_dropdown">
		<xsl:if test="CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">
			<option value="{ID}">
				<xsl:if test="ID = /H2G2/MANAGE-FAST-MOD/SITE/@ID">
					<xsl:attribute name="selected"/>
				</xsl:if>
				<xsl:value-of select="SHORTNAME"/>
			</option>
		</xsl:if>
	</xsl:template>
	<!-- 
		<xsl:template match="MANAGE-FAST-MOD" mode="crumbtrail">
		Author:	Andy Harris
		Context:     	/H2G2/MANAGE-FAST-MOD
		Purpose:	This displays the crumbtrail on the top of the page
	-->
	<xsl:template match="MANAGE-FAST-MOD" mode="crumbtrail">
		<p class="crumbtrail">
			<a href="moderate?newstyle=1">
				<xsl:text>Main</xsl:text>
			</a>
			<xsl:text> &gt; manage </xsl:text>
			<span class="fastmodCrumb">fast-mod</span>
			<xsl:text> topics</xsl:text>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="FEEDBACK" mode="fastmod_feedback_strip">
		Author:	Andy Harris
		Context:     	/H2G2/MANAGE-FAST-MOD/FEEDBACK
		Purpose:	This displays the feedback strip of topics changed
	-->
	<xsl:template match="FEEDBACK" mode="fastmod_feedback_strip">
		<p id="feedback-strip">
			<xsl:choose>
				<xsl:when test="RECORDSUPDATED = -1">No changes have been made</xsl:when>
				<xsl:when test="RECORDSUPDATED = 1">1 topic has been changed</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="RECORDSUPDATED"/>
					<xsl:text> topics have been changed</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="MANAGEABLE-TOPICS" mode="topic_list">
		Author:	Andy Harris
		Context:     	/H2G2/MANAGE-FAST-MOD/MANAGEABLE-TOPICS
		Purpose:	This builds the form and the table for the list of TOPICs which can have their fastmod status changed
	-->
	<xsl:template match="MANAGEABLE-TOPICS" mode="topic_list">
		<form action="managefastmod" method="post">
			<input type="hidden" name="c" value="update"/>
			<input type="hidden" name="siteid">
				<xsl:attribute name="value"><xsl:value-of select="../SITE/@ID"/></xsl:attribute>
			</input>
			<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<div id="table-container">
				<table id="topic-list" cellspacing="0">
					<thead>
						<tr>
							<td colspan="2">
								<xsl:text>Topics</xsl:text>
							</td>
						</tr>
					</thead>
					<tbody>
						<xsl:choose>
							<xsl:when test="TOPICLIST/TOPIC">
								<xsl:apply-templates select="TOPICLIST/TOPIC" mode="topic_list"/>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<td>
										<p>
											<xsl:text>No topics to display</xsl:text>
										</p>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</div>
			<div id="processButtons">
				<input type="submit" name="submit" value="Update"/>
			</div>
		</form>
	</xsl:template>
	<!-- 
		<xsl:template match="MANAGEABLE-TOPICS" mode="topic_list">
		Author:	Andy Harris
		Context:     	/H2G2/MANAGE-FAST-MOD/MANAGEABLE-TOPICS/TOPIC
		Purpose:	This displays the TOPIC information and creates the checkbox
	-->
	<xsl:template match="TOPIC" mode="topic_list">
		<tr>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">evenRow</xsl:attribute>
			</xsl:if>
			<td>
				<xsl:value-of select="TITLE"/>
			</td>
			<td>
				<label class="fast-mod-check">fast-mod</label>
				<input type="checkbox">
					<xsl:if test="FASTMOD = 1">
						<xsl:attribute name="checked"/>
					</xsl:if>
					<xsl:attribute name="name">check<xsl:value-of select="FORUMID"/></xsl:attribute>
				</input>
				<input type="hidden" name="forumid">
					<xsl:attribute name="value"><xsl:value-of select="FORUMID"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="name">oldfastmod<xsl:value-of select="FORUMID"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="FASTMOD"/></xsl:attribute>
				</input>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
