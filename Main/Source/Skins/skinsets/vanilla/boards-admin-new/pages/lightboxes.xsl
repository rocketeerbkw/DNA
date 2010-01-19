<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	exclude-result-prefixes="msxsl doc">
	
<xsl:template name="lightboxes">
	<div id="mb-lightboxes">
		<div id="mbpreview-editheader" class="mbpreview-box">
			<h4>Edit header colour</h4>
			<p>You may change the colour of your messageboard's Barlesque header. Please select which colour you would like: </p>
			<form action="" method="post">
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="blue" id="mbnav-blue">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'blue' or not(SITECONFIG/BLQ-NAV-COLOR)">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-blue">Blue (default)</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="sky" id="mbnav-sky">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'sky'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-sky">Sky</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="teal" id="mbnav-teal">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'teal'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-tesl">Teal</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="lime" id="mbnav-lime">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'lime'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-lime">lime</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="green" id="mbnav-green">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'green'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-green">Green</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="aqua" id="mbnav-aqua">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'aqua'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-aqua">Aqua</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="khaki" id="mbnav-khaki">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'khaki'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-khaki">Khaki</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="magenta" id="mbnav-magenta">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'magenta'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-magenta">Magenta</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="rose" id="mbnav-rose">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'rose'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-rose">Rose</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="purple" id="mbnav-purple">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'purple'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-purple">Purple</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="red" id="mbnav-red">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'red'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-red">Red</label>
				</div>
				<div>
					<input type="radio" name="BLQ-NAV-COLOR" value="orange" id="mbnav-orange">
						<xsl:if test="SITECONFIG/BLQ-NAV-COLOR = 'orange'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-orange">Orange</label>
				</div>
				<p class="info"><strong>Note:</strong> you may also wish to change the colour of the Barlesque footer, at the bottom of this page.</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-insertbanner" class="mbpreview-box">
			<h4>Insert your own banner</h4>
			<p>You may add your own page banner to your messageboard. To do this you will need to include the absolute URL to a Server Side Include (SSI) which generates the banner.</p>
			<form action="" method="post">
				<label for="mbbanner">URL:</label>
				<input type="text" name="HEADER" value="{SITECONFIG/HEADER}" id="mbbanner"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/banner.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addtopnav" class="mbpreview-box">
			<h4>Add top navigation</h4>
			<p>You can add your own top navigation to your messageboard. To do this you will need to include the absolute URL to a Server Side Include (SSI) which generates the navigation.</p>
			<form action="" method="post">
				<label for="mbtopnav">URL:</label>
				<input type="text" name="NAVHORIZONTAL" value="{SITECONFIG/NAVHORIZONTAL}" id="mbtopnav"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/topnav.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addnav" class="mbpreview-box">
			<h4>Add left-hand navigation</h4>
			<p>You can add your own left-hand navigation to your messageboard. To do this you will need to include the absolute URL to a Server Side Include (SSI) which generates the navigation.</p>
			<form action="" method="post">
				<label for="mbleftnav">URL:</label>
				<input type="text" name="LHN1" value="{SITECONFIG/LHN1}" id="mbleftnav"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/leftnav.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addwelcome" class="mbpreview-box">
			<h4>Add welcome message</h4>
			<p>Add your own welcome message to greet your users.</p>
			<form action="" method="post">
				<div>
					<label for="mbwelcome">Welcome message:</label>
				</div>
				<div>
					<input type="text" name="WELCOMEMESSAGE" value="{SITECONFIG/WELCOMEMESSAGE}" size="50"/>
				</div>
				<p class="info"><strong>Example:</strong> Welcome to the Strictly Messageboard!</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addtopic" class="mbpreview-box">
			<p>test test test</p>
		</div>
		<div id="mbpreview-editfooter" class="mbpreview-box">
			<h4>Edit footer</h4>
			<p>You may change the colour of your messageboard footer, as well as adding up to four additional links.</p>
			<form action="" method="post" class="mbfooter">
				<div class="half">
					<h5>Step 1</h5>
					<p class="strong">Choose footer colour</p>
					<div>
						<input type="radio" name="BLQ-FOOTER-COLOR" value="default" id="mbfootercolor-default">
							<xsl:if test="SITECONFIG/BLQ-FOOTER-COLOR = 'default' or not(SITECONFIG/BLQ-FOOTER-COLOR)">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label for="mbfootercolour-default">Default (grey)</label>
					</div>
					<div>
						<input type="radio" name="BLQ-FOOTER-COLOR" value="black" id="mbfootercolor-black">
							<xsl:if test="SITECONFIG/BLQ-FOOTER-COLOR = 'black'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label for="mbfootercolour-default">Black</label>
					</div>
					<div>
						<input type="radio" name="BLQ-FOOTER-COLOR" value="white" id="mbfootercolor-white">
							<xsl:if test="SITECONFIG/BLQ-FOOTER-COLOR = 'white'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<label for="mbfootercolour-default">White</label>
					</div>
				</div>
				<div class="half">
					<h5>Step 2 <span>(optional)</span></h5>
					<p class="strong">Add additional links</p>
					<p>If you wish, you may add up to 4 additional links to the footer. Please input the links you would like to add, and their text descriptions:</p>
					<div>
						<label for="mb-url1">Link URL 1:</label>
						<input type="text" name="BLQ-FOOTER-LINK-URL-1" value="{SITECONFIG/BLQ-FOOTER-LINK-URL-1}" id="mb-url1" class="right"/>
					</div>
					<div class="pad">
						<label for="mb-text1">Link text 1:</label>
						<input type="text" name="BLQ-FOOTER-LINK-TEXT-1" value="{SITECONFIG/BLQ-FOOTER-LINK-TEXT-1}" id="mb-text1" class="right"/>
					</div>
					<div>
						<label for="mb-url2">Link URL 2:</label>
						<input type="text" name="BLQ-FOOTER-LINK-URL-2" value="{SITECONFIG/BLQ-FOOTER-LINK-URL-2}" id="mb-url2" class="right"/>
					</div>
					<div class="pad">
						<label for="mb-text2">Link text 2:</label>
						<input type="text" name="BLQ-FOOTER-LINK-TEXT-2" value="{SITECONFIG/BLQ-FOOTER-LINK-TEXT-2}" id="mb-text2" class="right"/>
					</div>
					<div>
						<label for="mb-url3">Link URL 3:</label>
						<input type="text" name="BLQ-FOOTER-LINK-URL-3" value="{SITECONFIG/BLQ-FOOTER-LINK-URL-3}" id="mb-url3" class="right"/>
					</div>
					<div class="pad">
						<label for="mb-text3">Link text 3:</label>
						<input type="text" name="BLQ-FOOTER-LINK-TEXT-3" value="{SITECONFIG/BLQ-FOOTER-LINK-TEXT-3}" id="mb-text3" class="right"/>
					</div>
					<div>
						<label for="mb-url4">Link URL 4:</label>
						<input type="text" name="BLQ-FOOTER-LINK-URL-4" value="{SITECONFIG/BLQ-FOOTER-LINK-URL-4}" id="mb-url4" class="right"/>
					</div>
					<div class="pad">
						<label for="mb-text4">Link text 4:</label>
						<input type="text" name="BLQ-FOOTER-LINK-TEXT-4" value="{SITECONFIG/BLQ-FOOTER-LINK-TEXT-4}" id="mb-text4" class="right"/>
					</div>
					<p class="info"><strong>Example:</strong> URL - /site_url1/ Text - My Local Link</p>
					<p class="info"><strong>Note:</strong> Additional information on adding footer links can be found in this guide to <a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_footer_links.shtml" target="_blank">custom footer links</a> (external link).</p>
				</div>
				<div class="clear">
					<xsl:call-template name="submitbuttons"/>
				</div>
			</form>
		</div>
		<div id="mbpreview-addtext" class="mbpreview-box">
			<h4>Add introductory / about text</h4>
			<p>To help users orientate themselves, you can customise the text which gives them a brief introduction to the board. </p>
			<form action="" method="post">
				<div>
					<label for="mbabouttext">Add the introductory text which will give some brief information about the messageboard.</label>
				</div>
				<div>
					<textarea name="ABOUTMESSAGE" value="{SITECONFIG/ABOUTMESSAGE}" rows="5" cols="40" id="mbabouttext">&#160;</textarea>
				</div>
				<p class="info"><strong>Example:</strong> This messageboard is the beating heart of the Strictly community, where you talk to us and each other.</p>
				<div>
					<label for="mbopeningtimes">Add a textual description of the opening times for this board, N.B. the opening times described here need to reflect those set in the messageboard Admin area.</label>
				</div>
				<div>
					<textarea name="OPENINGTIMES" value="{SITECONFIG/OPENINGTIMES}" rows="2" cols="40" id="mbopeningtimes">&#160;</textarea>
				</div>
				<p class="info"><strong>Example:</strong> Opening hours: 8am - 10pm Monday to Friday, 9am-6pm Saturday &#38; Sunday.</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addmodules" class="mbpreview-box">
			<h4>Add further right-hand modules</h4>
			<p>You may add up to an additional 4 modules to the right-hand side of your messageboard. </p>
		</div>
		<div id="mbpreview-addtoolbar" class="mbpreview-box">
			<h4>Add Social Media toolbar</h4>
			<p>Choose whether or not you wish the standard Social Media toolbar to appear on your messageboard. </p>
			<p><a href="http://www.bbc.co.uk/includes/blq/include/help/global_features/test_bookmarks.shtml" target="_blank">Click here</a> for more information about the standard toolbar (external link)</p>
			<form action="" method="post">
				<input type="checkbox" name="SOCIALMEDIATOOLBAR" value="1" id="mbsocialtoolbar">
					<xsl:if test="SITECONFIG/SOCIALMEDIATOOLBAR = '1'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label for="mbsocialtoolbar">Add Social Media toolbar?</label>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
	</div>
</xsl:template>

<xsl:template name="submitbuttons">
	<div class="buttons">
		<input type="submit" name="submit" value="Save" class="mbpreview-button"/>
		<input type="button" name="cancel" value="Cancel" class="mbpreview-button panel-close"/>
	</div>
</xsl:template>

</xsl:stylesheet>
