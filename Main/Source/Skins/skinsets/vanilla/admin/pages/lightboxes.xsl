<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	exclude-result-prefixes="msxsl doc">
	
<xsl:template name="lightboxes">
	<div id="dna-lightboxes">
		<div id="dna-preview-editheader">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'header' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>
      
      <h4>Edit header colour</h4>
			<p>Change the colour of the <em>Explore the BBC</em> button found in your messageboard header:</p>
			<form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				<ul>

        <li>
					<input type="radio" name="HEADER_COLOUR" value="blue" id="mbnav-blue">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'blue' or not(SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR)">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-blue" class="dna-blue">Blue</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="sky" id="mbnav-sky">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'sky'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-sky" class="dna-sky">Sky</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="teal" id="mbnav-teal">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'teal'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-teal" class="dna-teal">Teal</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="lime" id="mbnav-lime">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'lime'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-lime" class="dna-lime">Lime</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="green" id="mbnav-green">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'green'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-green" class="dna-green">Green</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="aqua" id="mbnav-aqua">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'aqua'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-aqua" class="dna-aqua">Aqua</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="khaki" id="mbnav-khaki">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'khaki'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-khaki" class="dna-khaki">Khaki</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="magenta" id="mbnav-magenta">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'magenta'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-magenta" class="dna-magenta">Magenta</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="rose" id="mbnav-rose">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'rose'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-rose" class="dna-rose">Rose</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="purple" id="mbnav-purple">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'purple'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
          <label for="mbnav-purple" class="dna-purple">Purple</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="red" id="mbnav-red">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'red'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-red" class="dna-red">Red</label>
				</li>
				<li>
					<input type="radio" name="HEADER_COLOUR" value="orange" id="mbnav-orange">
						<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR= 'orange'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<label for="mbnav-orange" class="dna-orange">Orange</label>
				</li>
        </ul>
				
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-insertbanner">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'banner' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>
      
      <h4>Insert your own banner</h4>
			<p>To insert your own banner banner you need to include theURL to a Server Side Include (SSI) which contains the banner.</p>
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <p>
        <label for="mbbanner">URL:</label>
				<input type="text" name="BANNER_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI}" id="mbbanner"/>
				<span class="dna-fnote"><strong>Example:</strong> /includes/blq/include_blq_banner.ssi</span>
        </p>
          
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-addtopnav">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'topnav' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add horizontal navigation</h4>
			<p>To add your own navigation you need to include the URL to a Server Side Include (SSI) which contains the navigation.</p>
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <p>
          <label for="mbtopnav">URL:</label>
				  <input type="text" name="HORIZONTAL_NAV_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI}" id="mbtopnav"/>
          <span class="dna-fnote"><strong>Example:</strong> /includes/blq/include_blq_navigation.ssi</span>
       </p>
        
       <xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-addnav">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'lnav' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add left hand navigation</h4>
			<p>To add your own navigation you need to include the URL to a Server Side Include (SSI) which contains the navigation.</p>
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <p>
          <label for="mbleftnav">URL:</label>
				  <input type="text" name="LEFT_NAV_SSI" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI}" id="mbleftnav"/>
          <span class="dna-fnote"><strong>Example:</strong> /includes/blq/include_blq_left-navigation.ssi</span>
        </p>
        
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-addwelcome">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'welcome' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add welcome message</h4>
			<p>Add your own welcome message to greet your users.</p>
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <p>
					<label for="mbwelcome">Welcome message:</label>
					<input type="text" name="WELCOME_MESSAGE"  id="mbwelcome" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE}"/>
          <span class="dna-fnote"><strong>Example:</strong> Welcome to the Strictly Messageboard</span>
        </p>
        
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>


    <div id="dna-preview-editfooter">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'footer' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Edit footer</h4>
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
         
          <div id="dna-footer-color">
            <p>Change the colour of your footer:</p>
            <ul>
              <li>
                <input type="radio" name="FOOTER_COLOUR" value="default" id="mbfootercolor-default">
                  <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'default' or not(SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR)">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="mbfootercolor-default" class="dna-grey">Default (grey)</label>
              </li>
              <li>
                <input type="radio" name="FOOTER_COLOUR" value="black" id="mbfootercolor-black">
                  <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'black'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="mbfootercolor-black" class="dna-black">Black</label>
              </li>
              <li>
                <input type="radio" name="FOOTER_COLOUR" value="white" id="mbfootercolor-white">
                  <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR = 'white'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="mbfootercolor-white" class="dna-white">White</label>
              </li>
            </ul>

            <p class="dna-fnote">
              <strong>Note:</strong> You can also <a href="#" class="dna-add-footer-links">add links to your footer</a>.
            </p>
          </div>

          <div id="dna-footer-links">
            <p>You can add additional links to the footer.</p>
            <p>Please input the links you would like to add:</p>
            
            <ul>
              <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/LINKS/LINK">
                <xsl:variable name="id">
                  <xsl:value-of select="." />
                </xsl:variable>

                <li>
                  <label for="mb-url-{$id}">Link URL:</label>
                  <input type="text" name="FOOTER_LINK" value="{.}" id="mb-url-{$id}" class="right"/>
                </li>
              </xsl:for-each>
            </ul>
            <p class="dna-fnote">
              <strong>Example:</strong> &lt;!--#set var="blq_footer_link_url_1" value="/site_url1/"--&gt;
            </p>

            <p class="dna-fnote">
              <strong>Note:</strong> Additional information on adding footer links can be found in this guide to <a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_footer_links.shtml">custom footer links</a> (external link).
            </p>
          </div>
        
        <xsl:call-template name="submitbuttons"/>
        </form>
    </div>

    <div id="dna-preview-addtext">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'about' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add introductory / about text</h4>
		
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
				
        <p>
					<label for="mbabouttext">Add the introductory text, which will give some brief information about the messageboard:</label>
					<textarea name="ABOUT_MESSAGE" rows="5" cols="40" id="mbabouttext"><xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE"/></textarea>
          <span class="dna-fnote"><strong>Example:</strong> This messageboard is the beating heart of the Strictly community where you talk to us and each other.</span>
				</p>

        <p>
					<label for="mbopeningtimes">Add the text, which will state the messageboards opening and closing times:</label>
					<textarea name="OPENCLOSETIMES_TEXT" rows="2" cols="40" id="mbopeningtimes"><xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT"/></textarea>
          <span class="dna-fnote"><strong>Example:</strong> Opening hours: 8am until 12pm every day</span>
        </p>
        
        <xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-addmodules">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'modules' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add more modules</h4>
			<p>To add more modules to the right hand column of your messageboard, add the URL to a Server Side Include (SSI) which contains the module.</p>
      
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        
        <xsl:variable name="nLinks" select="count(SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK)" />
     
        <ul>
          <xsl:choose>
            <xsl:when test="$nLinks = 0 ">
              <li>
                <label for="mb-url-link1">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link1" />
              </li>
              <li>
                <label for="mb-url-link2">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link2" />
              </li>
              <li>
                <label for="mb-url-link3">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link3" />
              </li>
              <li>
                <label for="mb-url-link4">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link4" />
              </li>
            </xsl:when>
            
            <xsl:when test="$nLinks = 1 ">
              <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
                <xsl:variable name="id">
                  <xsl:value-of select="." />
                </xsl:variable>
                <li>
                  <label for="mb-url-{$id}">Link URL:</label>
                  <input type="text" name="MODULE_LINK" value="{.}" id="mb-url-{$id}" />
                </li>
              </xsl:for-each>
              <li>
                <label for="mb-url-link1">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link1" />
              </li>
              <li>
                <label for="mb-url-link2">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link2" />
              </li>
              <li>
                <label for="mb-url-link3">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link3" />
              </li>
            </xsl:when>

            <xsl:when test="$nLinks = 2 ">
              <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
                <xsl:variable name="id">
                  <xsl:value-of select="." />
                </xsl:variable>
                <li>
                  <label for="mb-url-{$id}">Link URL:</label>
                  <input type="text" name="MODULE_LINK" value="{.}" id="mb-url-{$id}" />
                </li>
              </xsl:for-each>
              <li>
                <label for="mb-url-link1">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link1" />
              </li>
              <li>
                <label for="mb-url-link2">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link2" />
              </li>
            </xsl:when>
            <xsl:when test="$nLinks = 3">
              <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
                <xsl:variable name="id">
                  <xsl:value-of select="." />
                </xsl:variable>
                <li>
                  <label for="mb-url-{$id}">Link URL:</label>
                  <input type="text" name="MODULE_LINK" value="{.}" id="mb-url-{$id}" />
                </li>
              </xsl:for-each>
              <li>
                <label for="mb-url-link1">Link URL:</label>
                <input type="text" name="MODULE_LINK" value="" id="mb-url-link1" />
              </li>
            </xsl:when>
            <xsl:when test="$nLinks = 4">
              <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
                <xsl:variable name="id">
                  <xsl:value-of select="." />
                </xsl:variable>
                <li>
                  <label for="mb-url-{$id}">Link URL:</label>
                  <input type="text" name="MODULE_LINK" value="{.}" id="mb-url-{$id}" />
                </li>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>         
        </ul>
        <p class="dna-fnote">
          <strong>Example:</strong> /includes/blq/include_blq_other.sssi
          </p>
      
        <xsl:call-template name="submitbuttons"/>
      </form>
		</div>

    <div id="dna-preview-addtoolbar">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'toolbar' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>

      <h4>Add Social Media toolbar</h4>
			<p>To add the social media toolbar to your messagebaord, select the checkbox below:</p>
			
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <input type="hidden" name="SOCIALTOOLBAR_SUBMIT" value="1"></input>
				
        <p>
        <input type="checkbox" name="SOCIALTOOLBAR" value="1" id="mbsocialtoolbar">
					<xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label for="mbsocialtoolbar">Show social media toolbar - <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR"/></label>
        </p>
        
				<xsl:call-template name="submitbuttons"/>
			</form>
		</div>

    <div id="dna-preview-edittopiclayout">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'layout' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>
      
      <h4>Edit topic Layout</h4>
      <p>Choose the layout options you would like:</p>
      
      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
        <ul>
        <li>
          <input type="radio" name="topiclayout" value="2col" id="layout-2col">
           <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '2col'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
          </input>
          <label for="layout-2col" class="dna-tl-2c">2 Columns<br/>This layout consists of topic promo's being displayed in 2 columns.</label>
        </li>
        <li>
          <input type="radio" name="topiclayout" value="1col" id="layout-1col">
            <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '1col'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
          </input>
          <label for="layout-1col" class="dna-tl-1c">1 Column<br />This layout consists of topic promo's being displayed in 1 column.</label>
        </li>
        </ul>
        
        <xsl:call-template name="submitbuttons"/>
      </form>
    </div>
	</div>


    <div id="dna-preview-addrecentdiscussions">
      <xsl:attribute name="class">
        dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'discussions' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
      </xsl:attribute>
    
    <h4>Recent Discussions</h4>
    <p>
      For messageboards aimed at people under 16
      years old, you may turn off the Recent
      Discussions module. This option is for <strong>under 16
      messageboards only</strong> - the module is
      compulsory for all others.
    </p>
    <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatepreview" method="post">
      <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>
      <input type="hidden" name="RECENTDISCUSSIONS_SUBMIT" value="1"></input>
     
      <p>
        <input type="checkbox" name="RECENTDISCUSSIONS" value="1" id="mbRECENTDISCUSSIONS">
          <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/RECENTDISCUSSIONS = 'true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="mbRECENTDISCUSSIONS">Include recent discussions?</label>
       </p>
      
      <xsl:call-template name="submitbuttons"/>
    </form>
  </div>
</xsl:template>

<xsl:template name="submitbuttons">
	<div class="dna-buttons">
		<ul>
      <li>
        <input type="submit" name="submit" value="Save" />
      </li>
      <li>
        <a href="mbadmin?s_mode=admin" class="dna-btn-link dna-btn-cancel">Cancel</a>
      </li>
    </ul>
  </div>
</xsl:template>

</xsl:stylesheet>
