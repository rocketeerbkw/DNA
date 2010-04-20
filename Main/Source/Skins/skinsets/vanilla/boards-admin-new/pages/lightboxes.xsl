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
			<form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="blue" id="mbnav-blue">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'blue' or not(SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR)">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-blue">Blue (default)</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="sky" id="mbnav-sky">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'sky'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-sky">Sky</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="teal" id="mbnav-teal">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'teal'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-tesl">Teal</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="lime" id="mbnav-lime">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'lime'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-lime">lime</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="green" id="mbnav-green">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'green'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-green">Green</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="aqua" id="mbnav-aqua">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'aqua'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-aqua">Aqua</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="khaki" id="mbnav-khaki">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'khaki'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-khaki">Khaki</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="magenta" id="mbnav-magenta">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'magenta'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-magenta">Magenta</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="rose" id="mbnav-rose">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'rose'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-rose">Rose</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="purple" id="mbnav-purple">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'purple'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-purple">Purple</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="red" id="mbnav-red">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'red'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-red">Red</label>
				</div>
				<div>
					<input type="radio" name="HEADER_COLOUR" value="orange" id="mbnav-orange">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'orange'">
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
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<label for="mbbanner">URL:</label>
				<input type="text" name="BANNER_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI}" id="mbbanner"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/banner.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addtopnav" class="mbpreview-box">
			<h4>Add top navigation</h4>
			<p>You can add your own top navigation to your messageboard. To do this you will need to include the absolute URL to a Server Side Include (SSI) which generates the navigation.</p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<label for="mbtopnav">URL:</label>
				<input type="text" name="HORIZONTAL_NAV_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI}" id="mbtopnav"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/topnav.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addnav" class="mbpreview-box">
			<h4>Add left-hand navigation</h4>
			<p>You can add your own left-hand navigation to your messageboard. To do this you will need to include the absolute URL to a Server Side Include (SSI) which generates the navigation.</p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<label for="mbleftnav">URL:</label>
				<input type="text" name="LEFT_NAV_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI}" id="mbleftnav"/>
				<p class="info"><strong>Example:</strong> /strictlycomedancing/includes/leftnav.sssi</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addwelcome" class="mbpreview-box">
			<h4>Add welcome message</h4>
			<p>Add your own welcome message to greet your users.</p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<div>
					<label for="mbwelcome">Welcome message:</label>
				</div>
				<div>
					<input type="text" name="WELCOME_MESSAGE" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE}" size="50"/>
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
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <div class="half">
          <h5>Step 1</h5>
          <p class="strong">Choose footer colour</p>
          <div>
            <input type="radio" name="FOOTER_COLOUR" value="default" id="mbfootercolor-default">
              <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'default' or not(SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR)">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="mbfootercolour-default">Default (grey)</label>
          </div>
          <div>
            <input type="radio" name="FOOTER_COLOUR" value="black" id="mbfootercolor-black">
              <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'black'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="mbfootercolour-default">Black</label>
          </div>
          <div>
            <input type="radio" name="FOOTER_COLOUR" value="white" id="mbfootercolor-white">
              <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'white'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="mbfootercolour-default">White</label>
          </div>
        </div>
        <div class="half">
          <h5>
            Step 2 <span>(optional)</span>
          </h5>
          <p class="strong">Add additional links</p>
          <p>If you wish, you may add up to 4 additional links to the footer. Please input the links you would like to add, and their text descriptions:</p>
          <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/LINKS/LINK">
            <div>
              <label for="mb-url1">Link URL:</label>
              <input type="text" name="FOOTER_LINK" value="{.}" id="mb-url1" class="right"/>
            </div>
            
          </xsl:for-each>
            <div>
              <label for="mb-url1">Link URL:</label>
              <input type="text" name="FOOTER_LINK" value="" id="mb-url1" class="right"/>
            </div>
            <p class="info">
              <strong>Example:</strong> URL - /site_url1/ Text - My Local Link
            </p>
            <p class="info">
              <strong>Note:</strong> Additional information on adding footer links can be found in this guide to <a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_footer_links.shtml" target="_blank">custom footer links</a> (external link).
            </p>
          </div>
        
        <div class="clear">
          <xsl:call-template name="submitbuttons"/>
        </div>
      </form>
		</div>
		<div id="mbpreview-addtext" class="mbpreview-box">
			<h4>Add introductory / about text</h4>
			<p>To help users orientate themselves, you can customise the text which gives them a brief introduction to the board. </p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<div>
					<label for="mbabouttext">Add the introductory text which will give some brief information about the messageboard.</label>
				</div>
				<div>
					<textarea name="ABOUT_MESSAGE" rows="5" cols="40" id="mbabouttext"><xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE"/></textarea>
				</div>
				<p class="info"><strong>Example:</strong> This messageboard is the beating heart of the Strictly community, where you talk to us and each other.</p>
				<div>
					<label for="mbopeningtimes">Add a textual description of the opening times for this board, N.B. the opening times described here need to reflect those set in the messageboard Admin area.</label>
				</div>
				<div>
					<textarea name="OPENCLOSETIMES_TEXT" rows="2" cols="40" id="mbopeningtimes"><xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT"/></textarea>
				</div>
				<p class="info"><strong>Example:</strong> Opening hours: 8am - 10pm Monday to Friday, 9am-6pm Saturday &#38; Sunday.</p>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
		<div id="mbpreview-addmodules" class="mbpreview-box">
			<h4>Add further right-hand modules</h4>
			<p>You may add up to an additional 4 modules to the right-hand side of your messageboard. </p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
          <div>
            <label for="mb-url1">Link URL:</label>
            <input type="text" name="MODULE_LINK" value="{.}" id="mb-url1" class="right"/>
          </div>

        </xsl:for-each>
        <div>
          <label for="mb-url1">Link URL:</label>
          <input type="text" name="MODULE_LINK" value="" id="mb-url1" class="right"/>
        </div>
      
      <div class="clear">
        <xsl:call-template name="submitbuttons"/>
      </div>
      </form>
		</div>
		<div id="mbpreview-addtoolbar" class="mbpreview-box">
			<h4>Add Social Media toolbar</h4>
			<p>Choose whether or not you wish the standard Social Media toolbar to appear on your messageboard. </p>
			<p><a href="http://www.bbc.co.uk/includes/blq/include/help/global_features/test_bookmarks.shtml" target="_blank">Click here</a> for more information about the standard toolbar (external link)</p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <input type="hidden" name="SOCIALTOOLBAR_SUBMIT" value="1"></input>
				<input type="checkbox" name="SOCIALTOOLBAR" value="1" id="mbsocialtoolbar">
					<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label for="mbsocialtoolbar">Add Social Media toolbar?</label>
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>
    <div id="mbpreview-addrecentdiscussions" class="mbpreview-box">
      <h4>Add Recent Discussions</h4>
      <p>Choose whether or not you wish to see the recent discussions. </p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <input type="hidden" name="RECENTDISCUSSIONS_SUBMIT" value="1"></input>
        <input type="checkbox" name="RECENTDISCUSSIONS" value="1" id="mbRECENTDISCUSSIONS">
          <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/RECENTDISCUSSIONS = 'true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="mbsocialtoolbar">Add recent discussions?</label>
        <xsl:call-template name="submitbuttons"/>
      </form>
    </div>

    <div id="mbpreview-edittopiclayout" class="mbpreview-box">
      <h4>Edit Topic Layout</h4>
      <p>Choose the layout options youw would like: </p>
      <form action="messageboardadmin_design?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <div>
          <input type="radio" name="topiclayout" value="2col" id="layout-2col">
           <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '2col'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
          </input>
          <label for="layout-2col">2 Columns</label>
          <p>This layout consists of topic promos being displayed in 2 columns. It also allows you to add images to your topic promo.</p>
        </div>
        <div>
          <input type="radio" name="topiclayout" value="1col" id="layout-1col">
            <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '1col'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
          </input>
          <label for="layout-1col">1 Column</label>
          <p>This layout consists of topic promos displayed in 1 column.</p>
        </div>
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
