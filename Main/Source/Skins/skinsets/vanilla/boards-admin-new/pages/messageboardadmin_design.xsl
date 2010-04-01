<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'MBADMINDESIGN']" mode="page">
		<div class="full">
			<h2>Messageboard Design</h2>
			<p>Below is a preview of your messageboard, indicating which areas you can edit. Once you are finished click the <strong>Save</strong> button. To cancel any changes you have made, click the <strong>Cancel</strong> button.</p>
			<h3>Your message board</h3>
			<div class="mbpreview">
				<div id="mbpreview-header">
					<p>
						<xsl:choose>
							<xsl:when test="SITECONFIG/SITECONFIGPREVIEW/HEADER_COLOUR">Header colour is <xsl:value-of select="SITECONFIG/SITECONFIGPREVIEW/HEADER_COLOUR"/>.</xsl:when>
							<xsl:otherwise>Header colour is default blue.</xsl:otherwise>
						</xsl:choose>
						<a href="#mbpreview-editheader" class="overlay button">Edit header colour</a>
					</p>
					<p>
						<a href="http://www.bbc.co.uk/includes/blq/resources/help/img/explore_colours.jpg" target="_blank">Click here to see Barlesque header colour options.</a>
					</p>
				</div>
				<div id="mbpreview-banner" class="solidbg">
					<a href="#mbpreview-insertbanner" class="overlay">Insert your own banner (SSSI)</a>
				</div>
				<div id="mbpreview-topnav" class="dashborder">
					<a href="#mbpreview-addtopnav" class="overlay">+ Add top navigation (SSSI)</a>
				</div>
				<div>
					<div id="mbpreview-left">
						<div id="mbpreview-leftnav" class="dashborder">
							<a href="#mbpreview-addnav" class="overlay">+ Add navigation (SSSI)</a>
						</div>
						<div id="mbpreview-topics" class="solidborder">
							<h4>Messageboard Topics</h4>
							<xsl:choose>
								<xsl:when test="SITECONFIG">
								<!--<xsl:when test="SITECONFIG/SITECONFIGPREVIEW/TOPICLAYOUT">-->
									<xsl:apply-templates select="FRONTPAGELAYOUTCOMPONENTS/TOPICLIST" mode="object_topiclist"/>
								</xsl:when>
								<xsl:otherwise>
									<p class="info">Topics will automatically appear when you add a new topic (right).</p>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<div id="mbpreview-defaultlinks" class="solidborder">
							<ul>
								<li>My Discussions</li>
								<li>House Rules</li>
								<li>FAQs</li>
							</ul>
						</div>
					</div>
					<div id="mbpreview-middle">
						<div id="mbpreview-welcome" class="solidbg">
							<a href="#mbpreview-addwelcome" class="overlay">+ Add welcome message</a>
						</div>
						<xsl:choose>
							<xsl:when test="SITECONFIG">
							<!--<xsl:when test="SITECONFIG/SITECONFIGPREVIEW/TOPICLAYOUT)">-->
								<xsl:apply-templates select="FRONTPAGELAYOUTCOMPONENTS/TOPICLIST" mode="object_topiclist_elements"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="FRONTPAGELAYOUTCOMPONENTS/TOPICLIST" mode="object_topiclist_setup"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<div id="mbpreview-right">
						<div id="mbpreview-about" class="noborder">
							<h4 class="darker">About this Board</h4>
							<a href="#mbpreview-addtext" class="overlay">+ Add introductory/about text</a>
						</div>
						<div id="mbpreview-recent" class="noborder">
							<h4 class="lighter">Recent Discussions</h4>
							<p class="info">
								Recent discussions will be automatically generated when your messageboard is live.
							</p>
						</div>
						<div id="mbpreview-more" class="dashborder">
							<a href="#mbpreview-addmodules" class="overlay">+ Add more modules to this column</a>
						</div>
					</div>
				</div>
				<div class="clear">
					<div class="dashborder" id="mbpreview-socialtoolbar">
						<a href="#mbpreview-addtoolbar" class="overlay">+ Add Social Media toolbar (e.g. Facebook, Digg, Delicious etc.)</a>
					</div>
				</div>
				<div id="mbpreview-footer">
					<p>
						<xsl:choose>
							<xsl:when test="SITECONFIG/SITECONFIGPREVIEW/FOOTER/COLOUR">Footer colour is <xsl:value-of select="SITECONFIG/SITECONFIGPREVIEW/FOOTER/COLOUR"/>.</xsl:when>
							<xsl:otherwise>Footer colour is default dark grey.</xsl:otherwise>
						</xsl:choose>
						<a href="#mbpreview-editfooter" class="overlay button wide">Edit footer</a>
					</p>
					<p>
						<a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_footer_colour.shtml" target="_blank">Click here to see Barlesque footer colour options.</a>
					</p>
				</div>
			</div>
			<xsl:call-template name="lightboxes"/>
		</div>
	</xsl:template>

</xsl:stylesheet>
