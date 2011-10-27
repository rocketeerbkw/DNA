<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">

  <xsl:template match="H2G2[@TYPE = 'MODERATOR-MANAGEMENT']" mode="page">
    <form id="moderatormanagement" name="moderatormanagement" method="GET" action="moderatormanagement">
    <xsl:call-template name="objects_links_breadcrumb">
      <xsl:with-param name="pagename" > Moderator Management</xsl:with-param>
    </xsl:call-template>
    <div class="dna-mb-intro blq-clearfix">
      <xsl:choose>
        <xsl:when test="$modview = 'modmanagement_addmoderator'">
          <!--xsl:apply-templates select="LASTACTION" mode="modmanagement_addmoderator"/-->
            <p>Enter a user's ID, username or email address into the search field and click the 'FIND' button. Select 'manage user' beside the desired user to give that user privileges. If your search is unsuccessful, try again using different search criteria.</p>
        </xsl:when>
        <xsl:when test="$modview = 'all'">
          <!--xsl:apply-templates select="LASTACTION" mode="ALL"/-->

          <p>
            Click the 'CREATE <xsl:value-of select="translate(/H2G2/MODERATOR-LIST/@GROUPNAME,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />' button to add a moderator. To remove <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members, check the relevant checkbox(es) and click the 'REMOVE <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/>' button. To give moderators access to a class or site, check the relevant checkbox(es), select the appropriate class or site, and click 'GO'.
            <br/><input class="buttonThreeD" type="submit" id="finduser" name="newmoderator" value="Create New {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="modmanagement_addmoderator()"/>
            </p>
        </xsl:when>
        <xsl:when test="$modview = 'class'">
          <xsl:apply-templates select="LASTACTION" mode="CLASS"/>

          <p>
            Click the 'CREATE <xsl:value-of select="translate(/H2G2/MODERATOR-LIST/@GROUPNAME,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />' button to add a moderator. To remove <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members access to the class or to remove <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members from the system, check the relevant checkbox(es) and then click either 'REMOVE ACCESS TO CLASS' or 'REMOVE <xsl:value-of select="translate(/H2G2/MODERATOR-LIST/@GROUPNAME,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />'.
            <br/><input class="buttonThreeD" type="submit" id="finduser" name="newmoderator" value="Create New {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="modmanagement_addmoderator()"/>
          </p>
        </xsl:when>
        <xsl:when test="$modview = 'site'">
          <xsl:apply-templates select="LASTACTION" mode="SITE"/>

          <p>
            Click the 'CREATE <xsl:value-of select="translate(/H2G2/MODERATOR-LIST/@GROUPNAME,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />' button to add a moderator. To remove <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/>' direct access to the site or to remove moderators from the system, check the relevant checkbox(es) and then click either'REMOVE DIRECT ACCESS TO SITE' or 'REMOVE <xsl:value-of select="translate(/H2G2/MODERATOR-LIST/@GROUPNAME,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />'.
            <br/><input class="buttonThreeD" type="submit" id="finduser" name="newmoderator" value="Create New {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="modmanagement_addmoderator()"/>
            </p>
        </xsl:when>
        <xsl:when test="$modview = 'user'">
          <xsl:apply-templates select="LAST-ACTION" mode="USER"/>
            <p>Check the relevant checkbox(es) to give the moderator access to a class or direct access to a site. Class access gives the moderator access to all sites in that class, while direct site access only gives access to an individual site. Class access will overwrite any prior direct site access given to moderator.</p>
        </xsl:when>
      </xsl:choose>

    </div>
      <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
        <h3>
          <xsl:choose>
            <xsl:when test="$modview = 'addmoderator'">
                Create New <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> - Find a User

            </xsl:when>
            <xsl:when test="$modview = 'all'">
                <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members in <span class="allLabel">All Classes &amp; Sites</span>

            </xsl:when>
            <xsl:when test="$modview = 'class'">
                <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members in the 
                  <xsl:value-of select="MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = $modviewid]/NAME"/> Class

            </xsl:when>
            <xsl:when test="$modview = 'site'">
                <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members in the 
                  <xsl:value-of select="SITE-LIST/SITE[@ID = $modviewid]/NAME"/> Site

            </xsl:when>
            <xsl:when test="$modview = 'user'">
                <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> Details
            </xsl:when>
          </xsl:choose>
        </h3>

            <input type="hidden" name="manage" id="manage" value="{/H2G2/MODERATOR-LIST/@GROUPNAME}"/>
            <div class="dna-fl">
              <div class="dna-box">
                <xsl:call-template name="SELECTOR"/>
              </div>
            </div>
            <div class="dna-fl dna-half dna-main ">
              <div class="dna-box">
                <xsl:choose>
                  <xsl:when test="$modview = 'addmoderator'">
                    <xsl:call-template name="addmoderator"/>
                  </xsl:when>
                  <xsl:when test="$modview = 'all'">
                    <xsl:apply-templates select="MODERATOR-LIST" mode="ALL"/>
                  </xsl:when>
                  <xsl:when test="$modview = 'class'">
                    <xsl:apply-templates select="MODERATOR-LIST" mode="CLASS"/>
                  </xsl:when>
                  <xsl:when test="$modview = 'site'">
                    <xsl:apply-templates select="MODERATOR-LIST" mode="SITE"/>
                  </xsl:when>
                  <xsl:when test="$modview = 'user'">
                    <xsl:apply-templates select="MODERATOR-LIST" mode="USER"/>
                  </xsl:when>
                  <xsl:otherwise>
                    |<xsl:value-of select="$modview"/>|
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </div>
          
      </div>
    </form>
  </xsl:template>

  <!--
	<xsl:template name="ACCESSCONTROLS">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Displays access controls for ALL view
	-->
  <xsl:template name="ACCESSCONTROLS">
        Give Access to
        <select id="accessobject" name="accessobject" onchange="access(this)">
          <option value="">-- Select --</option>
          <optgroup label="Classes" onchange="classaccess()">
            <xsl:apply-templates select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS" mode="OPTION"/>
          </optgroup>
          <optgroup label="Sites" onchange="siteaccess()">
            <!-- xsl:apply-templates select="msxsl:node-set($sorted_sites)/sites[SITE]" mode="OPTION"/ -->
          </optgroup>
        </select>
        <input class="buttonThreeD" type="submit" name="giveaccess" value="GO"/>
      <input class="buttonThreeD" type="submit" name="removeallaccess" value="Remove {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="javascript:return(confirm('{$remModAllText}'))"/>
    

  </xsl:template>

  <!--
	<xsl:template name="MODERATION-CLASSES">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list container for moderators classes
	-->
  <xsl:template match="MODERATION-CLASSES" mode="USER">
    <div id="userClasses">
      <h4 class="classView">Access to Classes</h4>
      <ul>
        <xsl:apply-templates select="MODERATION-CLASS" mode="USER"/>
      </ul>
    </div>
  </xsl:template>
  <!--
	<xsl:template name="LASTACTION">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the last action feedback
	-->
  <xsl:template match="LASTACTION[/H2G2/@TYPE = 'MODERATOR-MANAGEMENT']">
    <div id="lastaction">
      <xsl:choose>
        <xsl:when test="@TYPE = 'REMOVEDUSERS' and REMOVEDUSERS/@REMOVEDFROM = 'class'">
          <xsl:value-of select="count(REMOVEDUSERS/USER)"/> moderator
          <xsl:choose>
            <xsl:when test="count(REMOVEDUSERS/USER) &gt; 1">s'</xsl:when>
            <xsl:otherwise>'s</xsl:otherwise>
          </xsl:choose>
          access privileges have been removed.
        </xsl:when>
        <xsl:when test="@TYPE = 'REMOVEDUSERS' and REMOVEDUSERS/@REMOVEDFROM = 'site'">
          <xsl:value-of select="count(REMOVEDUSERS/USER)"/> moderator
          <xsl:choose>
            <xsl:when test="count(REMOVEDUSERS/USER) &gt; 1">s'</xsl:when>
            <xsl:otherwise>'s</xsl:otherwise>
          </xsl:choose>
          direct access privileges have been removed.
        </xsl:when>
        <xsl:when test="@TYPE = 'REMOVEDUSERS' and REMOVEDUSERS/@REMOVEDFROM = 'all'">
          <xsl:value-of select="count(REMOVEDUSERS/USER)"/> moderator
          <xsl:choose>
            <xsl:when test="count(REMOVEDUSERS/USER) &gt; 1">s have</xsl:when>
            <xsl:otherwise>has</xsl:otherwise>
          </xsl:choose>
          been removed.
        </xsl:when>
        <xsl:when test="@TYPE = 'modmanagement_addmoderator' and MODERATOR-ADDED">New moderator has been created.</xsl:when>
        <xsl:when test="@TYPE = 'UPDATEUSER' and $modview = 'user'">Moderator details have been updated.</xsl:when>
        <xsl:when test="@TYPE = 'GIVEACCESS' and $modview = 'all'">
          <xsl:value-of select="count(USERS/USER)"/> moderator
          <xsl:choose>
            <xsl:when test="count(USERS/USER) &gt; 1">s'</xsl:when>
            <xsl:otherwise>'s</xsl:otherwise>
          </xsl:choose>
          access rights have been updated.
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>
  <!--
	<xsl:template name="MODERATION-CLASS">
	Author:		Darren Shukri
	Context:	H2G2/MODERATION-CLASSES
	Purpose:	Creates classes in select object
	-->
  <xsl:template match="MODERATION-CLASS" mode="OPTION">
    <option value="{@CLASSID}">
      <xsl:value-of select="NAME"/>
    </option>
  </xsl:template>
  <!--
	<xsl:template name="MODERATION-CLASS">
	Author:		Darren Shukri
	Context:	H2G2/MODERATION-CLASSES
	Purpose:	Creates list of classes for moderator
	-->
  <xsl:template match="MODERATION-CLASS" mode="USER">
    <li>
      <xsl:choose>
        <xsl:when test="count(preceding-sibling::MODERATION-CLASS) mod 2 = 1">
          <xsl:attribute name="class">odd</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <label for="{generate-id()}">
        <input id="{generate-id()}" type="checkbox" name="toclass" value="{@CLASSID}">
          <xsl:if test="@CLASSID = /H2G2/MODERATOR-LIST/MODERATOR[USER/USERID = $modviewid]/CLASSES/CLASSID">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>&#160;<xsl:value-of select="NAME"/>
      </label>
      <!--xsl:if test="@CLASSID = /H2G2/MODERATOR-LIST/MODERATOR[USER/USERID = $modviewid]/CLASSES/CLASSID">
				<ul class="classChildren">
					<xsl:apply-templates select="msxsl:node-set($sorted_sites)/sites/SITE[CLASSID=current()/@CLASSID]" mode="SUBLIST"/>
				</ul>
			</xsl:if-->
    </li>
  </xsl:template>
  <!--
	<xsl:template name="SITE-LIST">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list container for moderator sites
	-->
  <xsl:template match="sites">
    <div id="userSites">
      <h4 class="siteView">Direct Access to Sites</h4>
      <ul>
        <xsl:apply-templates select="SITE" mode="USER"/>
      </ul>
    </div>
  </xsl:template>
  <!--
	<xsl:template name="SITE">
	Author:		Darren Shukri
	Context:	H2G2/SITE-LIST
	Purpose:	Creates classes in select object
	-->
  <xsl:template match="SITE" mode="OPTION">
    <option value="{@ID}">
      <xsl:value-of select="NAME"/>
    </option>
  </xsl:template>
  <!--
	<xsl:template name="SITE">
	Author:		Darren Shukri
	Context:	H2G2/SITE-LIST
	Purpose:	Creates list of sites for moderator
	-->
  <xsl:template match="SITE" mode="USER">
    <li>
      <xsl:choose>
        <xsl:when test="count(preceding-sibling::SITE) mod 2 = 0">
          <xsl:attribute name="class">stripeOne</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">stripeTwo</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <label for="{generate-id()}">
        <xsl:if test="../../MODERATOR[USER/USERID = $modviewid]/CLASSES/CLASSID = CLASSID">
          <xsl:attribute name="class">disabled</xsl:attribute>
        </xsl:if>
        <input id="{generate-id()}" type="checkbox" name="tosite" value="{@ID}">
          <xsl:choose>
            <xsl:when test="@ID = ../../MODERATOR[USER/USERID = $modviewid]/SITES/SITE/@SITEID">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:when>
            <xsl:when test="../../MODERATOR[USER/USERID = $modviewid]/CLASSES/CLASSID = CLASSID">
              <xsl:attribute name="checked">checked</xsl:attribute>
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:when>
          </xsl:choose>
        </input>&#160;<xsl:value-of select="NAME"/>
      </label>
    </li>
  </xsl:template>
  <!--
	<xsl:template name="SITE">
	Author:		Darren Shukri
	Context:	$sorted_sites/sites
	Purpose:	Creates sublist of sites which belong to a particular class
	-->
  <xsl:template match="SITE" mode="SUBLIST">
    <li>
      <xsl:value-of select="NAME"/>
    </li>
  </xsl:template>
  <!--
	<xsl:template name="SITES">
	Author:		Darren Shukri
	Context:	H2G2/MODERATOR-LIST/MODERATOR
	Purpose:	Calls in the list of sites to which a moderator has access
	-->
  <xsl:template match="SITES" mode="MODERATOR">
    <xsl:apply-templates select="SITE" mode="MODERATOR"/>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR-LIST">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list of moderators
	-->
  <xsl:template match="MODERATOR-LIST" mode="ALL">
    <input id="viewtype" type="hidden" name="s_view" value="all"/>
    <input type="hidden" name="s_viewid" value="0"/>
    <xsl:call-template name="ACCESSCONTROLS"/>
    <div id="modControls">
      <table cellspacing="0">
        <thead>
          <tr>
            <th>&#160;</th>
            <th>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$query"/>
                  <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_toggleall'])">&amp;s_toggleall=1</xsl:if>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
                    <xsl:attribute name="title">Unchecks all boxes</xsl:attribute>Select None
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="title">Checks all boxes</xsl:attribute>Select All
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </th>
            <th>User ID</th>
            <th>Username</th>
            <th>Class Access</th>
            <th>Direct Site Access</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <xsl:apply-templates select="MODERATOR" mode="ALL"/>
          </tr>
        </tbody>
      </table>
    </div>
    <!--<xsl:call-template name="ACCESSCONTROLS"/>-->
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR-LIST">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list of moderators for selected class
	-->
  <xsl:template match="MODERATOR-LIST" mode="CLASS">
    <input class="buttonThreeD" type="submit" name="removeaccess" value="Remove Access to CLASS" onclick="javascript:return(confirm('{$remModClassText}'))"/>
    <input class="buttonThreeD" type="submit" name="removeallaccess" value="Remove {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="javascript:return( confirm('{$remModAllText}'))"/>
    <input id="viewtype" type="hidden" name="s_view" value="class"/>
    <input type="hidden" name="s_viewid" value="{$modviewid}"/>
    <input type="hidden" name="classid" value="{$modviewid}"/>
    <div id="modControls">
      <table cellspacing="0">
        <thead>
          <tr>
            <th>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$query"/>
                  <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_toggleall'])">&amp;s_toggleall=1</xsl:if>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
                    <xsl:attribute name="title">Unchecks all boxes</xsl:attribute>Select None
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="title">Checks all boxes</xsl:attribute>Select All
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </th>
            <th>User ID</th>
            <th>Username</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="MODERATOR[CLASSES/CLASSID = $modviewid]" mode="CLASS"/>
          <xsl:if test="count(MODERATOR[CLASSES/CLASSID = $modviewid]) = 0">
            <tr>
              <td class="noData" colspan="3">
                <xsl:value-of select="$noData"/>
              </td>
            </tr>
          </xsl:if>
        </tbody>
      </table>
    </div>
    <input class="buttonThreeD" type="submit" name="removeaccess" value="Remove Access to CLASS" onclick="javascript:return(confirm('{$remModClassText}'))"/>
    <input class="buttonThreeD" type="submit" name="removeallaccess" value="Remove {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="javascript:return( confirm('{$remModAllText}'))"/>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR-LIST">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list of moderators for selected site
	-->
  <xsl:template match="MODERATOR-LIST" mode="SITE">
    <input class="buttonThreeD" type="submit" name="removeaccess" value="Remove Direct Access to Site" onclick="javascript:return(confirm('{$remModSiteText}'))"/>
    <input class="buttonThreeD" type="submit" name="removeallaccess" value="Remove {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="javascript:return( confirm('{$remModAllText}'))"/>
    <input id="viewtype"  type="hidden" name="s_view" value="site"/>
    <input type="hidden" name="s_viewid" value="{$modviewid}"/>
    <input type="hidden" name="siteid" value="{$modviewid}"/>

    <div id="modControls">
      <table cellspacing="0">
        <thead>
          <tr>
            <th>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$query"/>
                  <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_toggleall'])">&amp;s_toggleall=1</xsl:if>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
                    <xsl:attribute name="title">Unchecks all boxes</xsl:attribute>Select None
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="title">Checks all boxes</xsl:attribute>Select All
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </th>
            <th>ID</th>
            <th>Name</th>
            <th>Access Granted Through</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="MODERATOR[SITES/SITE/@SITEID = $modviewid]" mode="SITE"/>
          <xsl:if test="count(MODERATOR[SITES/SITE/@SITEID = $modviewid]) = 0">
            <tr>
              <td class="noData" colspan="4">
                <xsl:value-of select="$noData"/>
              </td>
            </tr>
          </xsl:if>
        </tbody>
      </table>
    </div>
    <input class="buttonThreeD" type="submit" name="removeaccess" value="Remove Direct Access to Site" onclick="javascript:return(confirm('{$remModSiteText}'))"/>
    <input class="buttonThreeD" type="submit" name="removeallaccess" value="Remove {/H2G2/MODERATOR-LIST/@GROUPNAME}" onclick="javascript:return( confirm('{$remModAllText}'))"/>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR-LIST">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the moderator view
	-->
  <xsl:template match="MODERATOR-LIST" mode="USER">
    <a class="buttonThreeD" href="{$root}moderatormanagement?manage={/H2G2/MODERATOR-LIST/@GROUPNAME}" id="cancelButton">cancel</a>
    <input class="buttonThreeD" type="submit" name="updateuser" value="save"/>
    <xsl:if test="/H2G2/LASTACTION/@TYPE = 'modmanagement_addmoderator' and /H2G2/LASTACTION/MODERATOR-ADDED">
      <a class="buttonThreeD" href="?updateuser=save+&amp;+create+another&amp;s_view=all&amp;s_viewid=0&amp;accessobject=&amp;finduser=Create+New+Moderator&amp;userid={$modviewid}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">save &amp; create another</a>
    </xsl:if>
    <br/>
    <input type="hidden" name="s_view" value="{$modview}"/>
    <input type="hidden" name="s_viewid" value="{$modviewid}"/>
    <input type="hidden" name="userid" value="{$modviewid}"/>
    <div id="modControls">
      <xsl:choose>
        <xsl:when test="MODERATOR[USER/USERID = $modviewid]">
          <xsl:apply-templates select="MODERATOR[USER/USERID = $modviewid]" mode="USER"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/H2G2/FOUNDUSERS/USER[USERID = $modviewid]" mode="USER"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="/H2G2/MODERATION-CLASSES" mode="USER"/>
      <!-- xsl:apply-templates select="msxsl:node-set($sorted_sites)/sites"/ -->
    </div>
    <a class="buttonThreeD" href="{$root}/moderatormanagement" id="cancelButton">cancel</a>
    <input class="buttonThreeD" type="submit" name="updateuser" value="save"/>
    <xsl:if test="/H2G2/LASTACTION/@TYPE = 'modmanagement_addmoderator' and /H2G2/LASTACTION/MODERATOR-ADDED">
      <a class="buttonThreeD" href="?updateuser=save+&amp;+create+another&amp;s_view=all&amp;s_viewid=0&amp;accessobject=&amp;finduser=Create+New+Moderator&amp;userid={$modviewid}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">save &amp; create another</a>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates table rows of all moderators
	-->
  <xsl:template match="MODERATOR" mode="ALL">
    <tr>
      <xsl:choose>
        <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
          <xsl:attribute name="class">selectedRow</xsl:attribute>
        </xsl:when>
        <xsl:when test="count(preceding-sibling::MODERATOR) mod 2 = 0">
          <xsl:attribute name="class">stripeOne</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">stripeTwo</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <td class="empty">
        <xsl:if test="count(SITES/SITE) &lt; 1 and count(CLASSES/CLASSID) &lt; 1">
          <xsl:attribute name="title">This moderator is not assigned to any classes/sites.</xsl:attribute>!
        </xsl:if>
      </td>
      <td>
        <input type="checkbox" name="userid" value="{USER/USERID}" onchange="modmanagement_hilightRow(this)" onclick="this.blur();this.focus()/*required for IE*/" onkeyup="this.blur();this.focus()/*required for IE*/">
          <xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </td>
      <td>
        <a href="{$root}moderatormanagement?s_view=user&amp;s_viewid={USER/USERID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">
          <xsl:value-of select="USER/USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USER/USERNAME"/>
      </td>
      <td>
        <xsl:apply-templates select="CLASSES" mode="MODERATOR"/>
      </td>
      <td>
        <xsl:apply-templates select="SITES" mode="MODERATOR"/>
      </td>
    </tr>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates table rows of CLASS moderators
	-->
  <xsl:template match="MODERATOR" mode="CLASS">
    <tr>
      <xsl:choose>
        <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
          <xsl:attribute name="class">selectedRow</xsl:attribute>
        </xsl:when>
        <xsl:when test="count(preceding-sibling::MODERATOR[CLASSES/CLASSID = $modviewid]) mod 2 = 0">
          <xsl:attribute name="class">stripeOne</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">stripeTwo</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <td>
        <input type="checkbox" name="userid" value="{USER/USERID}" onchange="modmanagement_hilightRow(this)" onclick="this.blur();this.focus()/*required for IE*/" onkeyup="this.blur();this.focus()/*required for IE*/">
          <xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </td>
      <td>
        <a href="{$root}moderatormanagement?s_view=user&amp;s_viewid={USER/USERID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">
          <xsl:value-of select="USER/USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USER/USERNAME"/>
      </td>
    </tr>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates table rows of SITE moderators
	-->
  <xsl:template match="MODERATOR" mode="SITE">
    <tr>
      <xsl:choose>
        <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
          <xsl:attribute name="class">selectedRow</xsl:attribute>
        </xsl:when>
        <xsl:when test="count(preceding-sibling::MODERATOR[SITES/SITE/@SITEID = $modviewid]) mod 2 = 1">
          <xsl:attribute name="class">odd</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <td>
        <input type="checkbox" name="userid" value="{USER/USERID}" onchange="modmanagement_hilightRow(this)" onclick="this.blur();this.focus()/*required for IE*/" onkeyup="this.blur();this.focus()/*required for IE*/">
          <xsl:choose>
            <xsl:when test="SITES/SITE[@SITEID = $modviewid]/@CLASSID&gt; -1">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_toggleall']">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </input>
      </td>
      <td>
        <a href="{$root}moderatormanagement?s_view=user&amp;s_viewid={USER/USERID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">
          <xsl:value-of select="USER/USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USER/USERNAME"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="SITES/SITE[@SITEID = $modviewid]/@CLASSID &gt; -1">
            <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = current()/SITES/SITE[@SITEID = $modviewid]/@CLASSID]/NAME"/>
          </xsl:when>
          <xsl:otherwise>Direct access through site</xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <!--
	<xsl:template name="MODERATOR">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates table of moderator data
	-->
  <xsl:template match="MODERATOR" mode="USER">
    <table id="userTable">
      <tr>
        <td class="userField">Username:</td>
        <td class="userValue">
          <xsl:value-of select="USER/USERNAME"/>
        </td>
      </tr>
      <tr>
        <td class="userField">User ID:</td>
        <td class="userValue">
          <xsl:value-of select="USER/USERID"/>
        </td>
      </tr>
      <tr>
        <td class="userField">Email Address:</td>
        <td class="userValue">
          <xsl:value-of select="USER/EMAIL-ADDRESS"/>
        </td>
      </tr>
    </table>
  </xsl:template>


  <xsl:template match="FOUNDUSERS/USER" mode="USER">
    <table id="userTable">
      <tr>
        <td class="userField">Username:</td>
        <td class="userValue">
          <xsl:value-of select="USERNAME"/>
        </td>
      </tr>
      <tr>
        <td class="userField">User ID:</td>
        <td class="userValue">
          <xsl:value-of select="USERID"/>
        </td>
      </tr>
      <tr>
        <td class="userField">Email Address:</td>
        <td class="userValue">
          <xsl:value-of select="EMAIL-ADDRESS"/>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!--
	<xsl:template name="CLASSES">
	Author:		Darren Shukri
	Context:	H2G2/MODERATOR-LIST/MODERATOR
	Purpose:	populates class data for moderator
	-->
  <xsl:template match="CLASSES" mode="MODERATOR">
    <xsl:apply-templates select="CLASSID" mode="MODERATOR"/>
    <xsl:if test="count(CLASSID) = 0">
      <span class="unassigned">unassigned</span>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template name="CLASSID">
	Author:		Darren Shukri
	Context:	H2G2/MODERATOR-LIST/MODERATOR
	Purpose:	populates class data for moderator
	-->
  <xsl:template match="CLASSID" mode="MODERATOR">
    <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = current()]/NAME"/>
    <xsl:if test="count(following-sibling::CLASSID) &gt; 0">
      <br/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="SITE" mode="MODERATOR">
    <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()/@SITEID]/NAME"/>
    <xsl:if test="count(following-sibling::SITE) &gt; 0">
      <br/>
    </xsl:if>
  </xsl:template>

  <!--
	<xsl:template name="REMOVEDUSERS">
	Author:		Darren Shukri
	Context:	H2G2/
	Purpose:	reports last successful action
	-->
  <xsl:template match="REMOVEDUSERS" mode="ALL">
    <xsl:choose>
      <xsl:when test="count(USER) = 1">
        Moderator <xsl:value-of select="concat(USER/USERNAME,' (',USER/USERID,')')"/> has been
        removed<br/>
      </xsl:when>
      <xsl:otherwise>
        The following moderators have been removed:<br/>
        <xsl:for-each select="USER">
          <xsl:value-of select="concat(USERNAME,' (',USERID,')')"/>
          <br/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
	<xsl:template name="modmanagement_addmoderator">
	Author:		Darren Shukri
	Context:	H2G2/
	Purpose:	Form to locate prospective moderators
	-->
  <xsl:template name="addmoderator">
    <input type="hidden" name="s_view" value="addmoderator"/>
    <input type="hidden" name="s_viewid" value="0"/>
    <label for="{generate-id()}">
      Enter user's ID or email address:  <input id="{generate-id()}" name="email" value="{EMAIL}"/>
    </label>
    <input class="buttonThreeD" name="finduser" type="submit" value="Find"/>
    <xsl:if test="/H2G2/FOUNDUSERS/USER">
      <table id="foundUsers" class="modTable {$modview}View">
        <caption id="resultsCaption">Search Results:</caption>
        <thead>
          <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email Address</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <xsl:choose>
            <xsl:when test="ERROR/@TYPE=1">
              <tr>
                <td class="noData" colspan="4">No results found. Please try again using different search criteria.</td>
              </tr>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="/H2G2/FOUNDUSERS/USER"/>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </table>
    </xsl:if>
  </xsl:template>
  <!--
	<xsl:template name="FOUNDUSERS/USER">
	Author:		Darren Shukri
	Context:	H2G2/modmanagement_addmoderator
	Purpose:	Form to locate prospective moderators
	-->
  <xsl:template match="FOUNDUSERS/USER">
    <tr>
      <xsl:choose>
        <xsl:when test="count(preceding-sibling::USER) mod 2 = 1">
          <xsl:attribute name="class">odd</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <td>
        <a href="{$root}U{USERID}">
          <xsl:value-of select="USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USERNAME"/>
      </td>
      <td>
        <xsl:value-of select="EMAIL"/>
      </td>
      <td>
        <a href="?modmanagement_addmoderator=Add+Selected+User&amp;userid={USERID}&amp;s_view=user&amp;s_viewid={USERID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}&amp;finduser=1&amp;email={USERID}">manage user status</a>
      </td>
    </tr>
  </xsl:template>
  <!---
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 BEGIN SITE/CLASS SELECTOR MECHANISM
	 
	 It should be possible to externalise this as a separate template at some point
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -->
  <!--
	<xsl:variable name="sorted_sites"/>
	Author:		Darren Shukri
	Scope:		Global
	Purpose:	Site list sorted by name
	-->
  <xsl:variable name="sorted_sites">
    <xsl:copy-of select="key('moderators', $modviewid)"/>
    <sites>
      <xsl:choose>
        <xsl:when test="(($modview = 'class') or ($modview = 'createnewemail'))">
          <xsl:for-each select="/H2G2/SITE-LIST/SITE[CLASSID = $modviewid]">
            <xsl:sort select="NAME"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$modview = 'site'">
          <xsl:for-each select="/H2G2/SITE-LIST/SITE[CLASSID = /H2G2/SITE-LIST/SITE[@ID=$modviewid]/CLASSID]">
            <xsl:sort select="NAME"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$modview =  'editinsert'">
          <xsl:for-each select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $modviewid]/SITEID]">
            <xsl:sort select="NAME"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$modview =  'editemail'">
          <xsl:for-each select="/H2G2/SITE-LIST/SITE[CLASSID = /H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $modviewid]/MODCLASSID]">
            <xsl:sort select="NAME"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="/H2G2/SITE-LIST/SITE">
            <xsl:sort select="NAME"/>
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </sites>
  </xsl:variable>


  <!--
	<xsl:template name="SELECTOR">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Constructs the moderation class/site selector page element
	-->
  <xsl:template name="SELECTOR">
    <div id="selector" class="{$modview}View">
      <xsl:apply-templates select="MODERATION-CLASSES" mode="LIST"/>
    </div>
  </xsl:template>
  <!--
	<xsl:template name="MODERATION-CLASSES">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the list container for moderation classes
	-->
  <xsl:template match="MODERATION-CLASSES" mode="LIST">
    <ul id="modClasses">
      <xsl:if test="contains(/H2G2/@TYPE,'MODERATOR')">
        <li>
          <xsl:choose>
            <xsl:when test="($modview = 'all') or ($modview = 'user') or ($modview = 'modmanagement_addmoderator')">
              <xsl:attribute name="id">activeClass</xsl:attribute>
              
            </xsl:when>
            <xsl:otherwise>
              <a href="{$root}moderatormanagement?manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">All Classes &amp; Sites</a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:if>
      <li>
        <ul id="modTypes">
          <xsl:apply-templates select="MODERATION-CLASS" mode="LIST-ITEM"/>
        </ul>
      </li>
    </ul>
  </xsl:template>
  <!--
	<xsl:template name="MODERATION-CLASS">
	Author:		Darren Shukri
	Context:	H2G2/MODERATION-CLASSES
	Purpose:	Creates the list of moderation classes
	-->
  <xsl:template match="MODERATION-CLASS" mode="LIST-ITEM">
    <li>
      <xsl:choose>
        <xsl:when test="(($modview = 'editemail') and (@CLASSID = /H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $modviewid]/MODCLASSID))
							   or (($modview = 'createnewemail') and (@CLASSID = $modviewid))
							   or (($modview = 'class') and (@CLASSID = $modviewid))">
          <xsl:attribute name="id">activeClass</xsl:attribute>
          <span id="activeClassText">
            <xsl:value-of select="NAME"/>
          </span>
          <!-- xsl:apply-templates select="msxsl:node-set($sorted_sites)/sites[SITE]" mode="LIST"/ -->
        </xsl:when>
        <xsl:when test="(($modview = 'editinsert') and (@CLASSID = /H2G2/SITE-LIST/SITE[@ID= /H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $modviewid]/@SITEID]/CLASSID))
							   or (($modview = 'createinsert') and (@CLASSID = /H2G2/SITE-LIST/SITE[@ID = $modviewid]/CLASSID))
							   or (($modview = 'site') and (current()/@CLASSID = /H2G2/SITE-LIST/SITE[@ID = $modviewid]/CLASSID))">
          <xsl:attribute name="id">activeClass2</xsl:attribute>
          <a href="?s_view=class&amp;view=class&amp;s_viewid={@CLASSID}&amp;viewid={@CLASSID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}" title="{DESCRIPTION}" id="activeClass2text">
            <xsl:value-of select="NAME"/>
          </a>
          <!-- xsl:apply-templates select="msxsl:node-set($sorted_sites)/sites[SITE]" mode="LIST"/ -->
        </xsl:when>
        <xsl:otherwise>
          <a href="?s_view=class&amp;view=class&amp;s_viewid={@CLASSID}&amp;viewid={@CLASSID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}" title="{DESCRIPTION}">
            <xsl:value-of select="NAME"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>
  <!--
	<xsl:template name="sites">
	Author:		Darren Shukri
	Context:	$sorted_sites
	Purpose:	Creates the list container for Associated Sites
	-->
  <xsl:template match="sites" mode="LIST">

    <ul id="modSites">
      <xsl:apply-templates select="SITE" mode="LIST-ITEM"/>
    </ul>
  </xsl:template>
  <!--
	<xsl:template name="SITE">
	Author:		Darren Shukri
	Context:	$sorted_sites/sites
	Purpose:	Populates the list of sites
	-->
  <xsl:template match="SITE" mode="LIST-ITEM">
    <li>
      <xsl:if test="not(/H2G2/MODERATOR-LIST/MODERATOR[SITES/SITE/@SITEID = current()/@ID])">
        <xsl:attribute name="class">empty</xsl:attribute>
        <!--span title="The site '{NAME}' does not have or inherit any moderators."> ! </span-->
      </xsl:if>
      <xsl:choose>
        <xsl:when test="((@ID = $modviewid) and ($modview = 'site')) or ((@ID = $modviewid) and ($modview = 'createinsert'))">
          <xsl:attribute name="id">activeSite</xsl:attribute>
          <xsl:value-of select="NAME"/>
        </xsl:when>
        <xsl:otherwise>
          <a href="?s_view=site&amp;view=site&amp;s_viewid={@ID}&amp;viewid={@ID}&amp;manage={/H2G2/MODERATOR-LIST/@GROUPNAME}">
            <xsl:value-of select="NAME"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>
  <!---
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 END SITE/CLASS SELECTOR MECHANISM
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -->

  <xsl:variable name="assetroot">/dnaimages/adminsystem/includes/</xsl:variable>
  <xsl:variable name="modview">
    <xsl:choose>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']">
        <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>all</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="modviewid">
    <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_viewid']/VALUE"/>
  </xsl:variable>
  <!-- Text strings for use in javascript confirmation dialogues -->
  <xsl:variable name="remModSiteText">
    Remove the selected '+modmanagement_counted()+' selected <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members direct access privileges to the <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $modviewid]/NAME"/> site?
  </xsl:variable>
  <xsl:variable name="remModClassText">
    Remove the '+modmanagement_counted()+' selected <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members access privileges to the <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = $modviewid]/NAME"/> class?
  </xsl:variable>
  <xsl:variable name="remModAllText">
    Remove the '+modmanagement_counted()+' selected <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> from the ModerationManagement system?
  </xsl:variable>
  <xsl:variable name="noData">
    No <xsl:value-of select="/H2G2/MODERATOR-LIST/@GROUPNAME"/> members found for this <xsl:value-of select="$modview"/>.
  </xsl:variable>
  <!--
	<xsl:key name="moderators"/>
	Author:		Darren Shukri
	Scope:		Global
	Purpose:	Moderators indexed by USER/USERID
	-->
  <xsl:key name="moderators" match="/H2G2/MODERATOR-LIST/MODERATOR" use="USER/USERID"/>
  <xsl:variable name="query" select="concat('?s_view=',$modview,'&amp;s_viewid=',$modviewid,'&amp;manage=',/H2G2/MODERATOR-LIST/@GROUPNAME)"/>
  <xsl:variable name="dnaAdminImgPrefix" select="'/dnaimages/adminsystem/images/'"/>


</xsl:stylesheet>
