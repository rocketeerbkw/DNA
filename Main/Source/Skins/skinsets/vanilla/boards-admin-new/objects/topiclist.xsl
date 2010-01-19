<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	exclude-result-prefixes="msxsl doc">
	
	<xsl:template match="TOPICLIST" mode="object_topiclist">
		
	</xsl:template>
	
	<xsl:template match="TOPICLIST" mode="object_topiclist_setup">
		<div id="mbpreview-topics" class="dashborder">
			<h4>Choose topic layout</h4>
			<p>Before you begin adding topics to your messageboard, please choose the layout you would like to display them in (this can be changed later)</p>
			<form action="#" method="get" class="vertform">
				<div>
					<input type="radio" name="layout" value="2col" id="layout-2col"/>
					<label for="layout-2col">2 Columns</label>
					<p>This layout consists of topic promos being displayed in 2 columns. It also allows you to add images to your topic promo.</p>
				</div>
				<div>
					<input type="radio" name="layout" value="1col" id="layout-1col"/>
					<label for="layout-1col">1 Column</label>
					<p>This layout consists of topic promos displayed in 1 column.</p>
				</div>
			</form>
		</div>
	</xsl:template>
	
	<xsl:template match="TOPICLIST" mode="object_topiclist_elements">
		<div id="mbpreview-topics">
			<ul>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="/H2G2/SITECONFIG/TOPICLAYOUT = '1col'">topicpreview onecol</xsl:when>
						<xsl:otherwise>topicpreview twocol</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:for-each select="TOPIC">
					<li>
						<xsl:if test="position() mod 2 = 0">
							<xsl:attribute name="class">even</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="." mode="object_topic"/>
					</li>
				</xsl:for-each>
				<li>
					<xsl:if test="count(TOPIC) mod 2 = 1">
						<xsl:attribute name="class">even</xsl:attribute>
					</xsl:if>
					<a href="#mbpreview-addtopic" class="overlay">+ Add topic</a>
				</li>
				<li class="noborder">
					<div>
						<p>
							<a href="#" class="overlay">Edit topic layout</a>
						</p>
						<p>
							<a href="#" class="overlay">Edit topic order</a>
						</p>
					</div>
				</li>
			</ul>
		</div>
	</xsl:template>

</xsl:stylesheet>
