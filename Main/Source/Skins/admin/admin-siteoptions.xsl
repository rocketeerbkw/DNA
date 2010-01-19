<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:variable name="CURRENTSITE"><xsl:value-of select="/H2G2/PROCESSINGSITE/SITE/@ID"/></xsl:variable><!-- N.B. CURRENTSITE is the site being changed -->
<xsl:variable name="CURRENTSITEURLNAME"><xsl:value-of select="/H2G2/PROCESSINGSITE/SITE/SHORTNAME"/></xsl:variable>
<xsl:variable name="adminimagesource">http://www.bbc.co.uk/dnaimages/adminsystem/images/</xsl:variable>

	<xsl:template name="SITEOPTIONS_JAVASCRIPT">
		<script type="text/javascript">

		</script>
	</xsl:template>

	<xsl:template name="SITEOPTIONS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				DNA Administration - Site Options - <xsl:value-of select="$CURRENTSITEURLNAME"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
<xsl:template name="SITEOPTIONS_MAINBODY">
	<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
					<div id="subNavText">
						<h4> DNA Administration - <xsl:value-of select="$CURRENTSITEURLNAME"/></h4>
		</div>
	</div>
	<br/>
<div id="contentArea">
<div class="centralAreaRight">
	<div class="header">
		<img src="{$adminimagesource}t_l.gif" alt=""/>
	</div>
<div class="centralArea">

  <xsl:if test="$test_IsEditor">
    <form method="post" action="siteoptions">
    	<xsl:if test="CURRENTSITEURLNAME = 'moderation'">
	    	<xsl:apply-templates select="EDITABLESITES" mode="editsiteoptions"/>
    	</xsl:if>
    	
      <xsl:for-each select="SITEOPTIONS[@SITEID = $CURRENTSITE]/SITEOPTION[not(SECTION = preceding-sibling::SITEOPTION/SECTION)]">
        <xsl:variable name="section" select="./SECTION"/>
        <table cellpadding="0" cellspacing="0" border="0" class="adminMenu" style="width:720px;">
        <tr class="adminSecondHeader">
        <td width="10%" class="adminMenuTime">STATUS</td>
        
        
        <td width="35%"><xsl:value-of select="translate($CURRENTSITEURLNAME, $lowercase, $uppercase)"/>&nbsp;<xsl:value-of select="translate($section, $lowercase, $uppercase)"/>&nbsp;OPTIONS</td>
        <td width="55%" class="adminMenuTime">DESCRIPTION</td>
        </tr>


        <xsl:apply-templates select="parent::*/SITEOPTION[SECTION = $section and SITEID = $CURRENTSITE]" mode="definedforsite"/>
        <xsl:apply-templates select="parent::*/SITEOPTION[SECTION = $section and DEFINITION = 1]" mode="undefinedforsite"/>
        </table>
      </xsl:for-each>
      <br/>
      <input type="submit" name="cmd" value="Update" class="buttonThreeD" style="width:180px;"/>
    </form>
  </xsl:if>

  <xsl:if test="$superuser = 1 and not(//PARAMS/PARAM[NAME='s_global'])">
    <br/>
    <a href="siteoptions?siteid={$CURRENTSITE}&amp;s_global=1">Show Global Options</a>
    <br/>
  </xsl:if>
  
  <xsl:if test="$superuser = 1 and //PARAMS/PARAM[NAME='s_global']">
    <hr/>

    <h3>Default DNA Options</h3><br/>
      <h4><strong><font color="red">&nbsp;&nbsp;Warning, changing these settings will effect every single DNA site</font></strong></h4>
    <form method="post" action="siteoptions">
      <xsl:for-each select="SITEOPTIONS[@DEFAULTS = 1]/SITEOPTION[not(SECTION = preceding-sibling::SITEOPTION/SECTION)]">
        <xsl:variable name="section" select="./SECTION"/>


       <table cellpadding="0" cellspacing="0" border="0" class="adminMenu" style="width:720px;">
        <tr class="adminSecondHeader">
        <td width="10%" class="adminMenuTime">STATUS</td>
        
        
        <td width="35%"><xsl:value-of select="translate($section, $lowercase, $uppercase)"/> DEFAULTS FOR DNA</td>
        <td width="55%" class="adminMenuTime">DESCRIPTION</td>
        </tr>

        <xsl:apply-templates select="parent::*/SITEOPTION[SECTION = $section]">
          <xsl:with-param name="siteid" select="0"/>
          <xsl:with-param name="defined" select="1"/>
        </xsl:apply-templates>
	</table>
      </xsl:for-each>
      <br/>
      <input type="submit" name="cmd" value="Update" class="buttonThreeD" style="width:180px;"/>
      <!--<input type="submit" name="cmd" value="update"/>-->
    </form>    
  </xsl:if>
  </div>
<div class="footer">

</div>	
</div>							
</div>
</xsl:template>

<xsl:template match="SITEOPTION" mode="definedforsite">
  <xsl:apply-templates select=".">
    <xsl:with-param name="siteid" select="./SITEID"/>
    <xsl:with-param name="defined" select="1"/>
  </xsl:apply-templates>
</xsl:template>
  
<xsl:template match="SITEOPTION" mode="undefinedforsite">
	<xsl:apply-templates select=".">
    <xsl:with-param name="siteid" select="$CURRENTSITE"/>
	  <xsl:with-param name="defined" select="0"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="SITEOPTION">
	<xsl:param name="siteid"/> 
	<xsl:param name="defined"/> 
	
	<xsl:if test="TYPE = 0">
		<xsl:apply-templates select="." mode="type_int">
      <xsl:with-param name="siteid" select="$siteid"/>
      <xsl:with-param name="defined" select="$defined"/>
    </xsl:apply-templates>
	</xsl:if>

  <xsl:if test="TYPE = 1">
    <xsl:apply-templates select="." mode="type_bool">
      <xsl:with-param name="siteid" select="$siteid"/>
      <xsl:with-param name="defined" select="$defined"/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:if test="TYPE = 2">
    <xsl:apply-templates select="." mode="type_string">
      <xsl:with-param name="siteid" select="$siteid"/>
      <xsl:with-param name="defined" select="$defined"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="SITEOPTION" mode="type_int">
	<xsl:param name="siteid"/> 
	<xsl:param name="defined"/>

  <xsl:variable name="so"> <xsl:value-of select="concat('so_', $siteid,'_',SECTION,'_',NAME)"/></xsl:variable>
  <xsl:variable name="sov"><xsl:value-of select="concat('sov_',$siteid,'_',SECTION,'_',NAME)"/></xsl:variable>

  <!-- Need this hidden field to tell DNA that this option for this site is being updated -->
  <input type="hidden" name="{$so}" value="0"/>

  <xsl:variable name="bgcolor">
    <xsl:if test="$defined = 1">green</xsl:if>
    <xsl:if test="$defined = 0">red</xsl:if>
  </xsl:variable>
  

		<tr>
	    <td scope="row" class="siteOptDesc"><xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
        On <input type="radio" name="{$so}" value="1">
          <xsl:if test="$defined = 1">
            <xsl:attribute name="checked"/>
          </xsl:if>
        </input><br/>
        Off  <input type="radio" name="{$so}" value="0">
                  <xsl:if test="$defined = 0">
            <xsl:attribute name="checked"/>
          </xsl:if>
          </input>
      </td>
		  <td style="border-bottom:1px dotted #000000;">  <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
		  <xsl:value-of select="NAME"/><br/>
		  <input type="text" name="{$sov}" value="{VALUE}"/>
		  </td>
		  <td class="siteOptDesc"> <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
		  <xsl:value-of select="DESCRIPTION"/></td>
	  </tr>
</xsl:template>

<xsl:template match="SITEOPTION" mode="type_bool">
	<xsl:param name="siteid"/> 
	<xsl:param name="defined"/>
  
  <xsl:variable name="so"> <xsl:value-of select="concat('so_', $siteid,'_',SECTION,'_',NAME)"/></xsl:variable>
  <xsl:variable name="sov"><xsl:value-of select="concat('sov_',$siteid,'_',SECTION,'_',NAME)"/></xsl:variable>

  <!-- Need this hidden field to tell DNA that this option for this site is being updated -->
  <input type="hidden" name="{$so}" value="0"/>
  
  <xsl:variable name="bgcolor">
    <xsl:if test="$defined = 1">green</xsl:if>
    <xsl:if test="$defined = 0">red</xsl:if>
  </xsl:variable>


    <tr>
	    <td scope="row" class="siteOptDesc"><xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute>
        On <input type="radio" name="{$so}" value="1">
          <xsl:if test="$defined = 1">
            <xsl:attribute name="checked"/>
          </xsl:if>
        </input><br/>
        Off  <input type="radio" name="{$so}" value="0">
                  <xsl:if test="$defined = 0">
            <xsl:attribute name="checked"/>
          </xsl:if>
          </input>
      </td>
		  <td style="border-bottom:1px dotted #000000;"><xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute><xsl:value-of select="NAME"/><br/>
		          <input type="checkbox" name="{$sov}" value="1">
          <xsl:if test="VALUE = 1">
            <xsl:attribute name="checked"/>
          </xsl:if>
        </input>
		  </td>
		  <td class="adminMenuTime"><xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/></xsl:attribute><xsl:value-of select="DESCRIPTION"/></td>
    </tr>

</xsl:template>

  <xsl:template match="SITEOPTION" mode="type_string">
    <xsl:param name="siteid"/>
    <xsl:param name="defined"/>

    <xsl:variable name="so">
      <xsl:value-of select="concat('so_', $siteid,'_',SECTION,'_',NAME)"/>
    </xsl:variable>
    <xsl:variable name="sov">
      <xsl:value-of select="concat('sov_',$siteid,'_',SECTION,'_',NAME)"/>
    </xsl:variable>

    <!-- Need this hidden field to tell DNA that this option for this site is being updated -->
    <input type="hidden" name="{$so}" value="0"/>

    <xsl:variable name="bgcolor">
      <xsl:if test="$defined = 1">green</xsl:if>
      <xsl:if test="$defined = 0">red</xsl:if>
    </xsl:variable>


    <tr>
      <td scope="row" class="siteOptDesc">
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
        On <input type="radio" name="{$so}" value="1">
          <xsl:if test="$defined = 1">
            <xsl:attribute name="checked"/>
          </xsl:if>
        </input><br/>
        Off  <input type="radio" name="{$so}" value="0">
          <xsl:if test="$defined = 0">
            <xsl:attribute name="checked"/>
          </xsl:if>
        </input>
      </td>
      <td style="border-bottom:1px dotted #000000;">
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
        <xsl:value-of select="NAME"/>
        <br/>
        <input type="text" name="{$sov}" value="{VALUE}"/>
      </td>
      <td class="siteOptDesc">
        <xsl:attribute name="bgcolor">
          <xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
        <xsl:value-of select="DESCRIPTION"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="EDITABLESITES" mode="editsiteoptions">
	<select id="editablesites" name="siteid">
		<xsl:apply-templates select="SITE" mode="editsiteoptions">
			<xsl:sort select="SHORTNAME" data-type="text" order="ascending"/>
		</xsl:apply-templates>
	</select>
	<br/>
    	<input type="submit" value="Change Site" class="buttonThreeD" style="width:180px;"/>
</xsl:template>

<xsl:template match="SITE" mode="editsiteoptions">
	<option value="{@ID}">
		<xsl:if test="@ID = /H2G2/PROCESSINGSITE/SITE/@ID">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="SHORTNAME"/>
	</option>
</xsl:template>

</xsl:stylesheet>