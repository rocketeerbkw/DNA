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
	
	<xsl:template match="H2G2[@TYPE = 'USERLIST']" mode="page">
    
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >user list</xsl:with-param>
		</xsl:call-template>    
    
    <div class="dna-mb-intro">
      <h2>DNA Member List</h2>
      Search for users of your site below and view details as well as modify their moderation status.
    </div>

    <div class="dna-main blq-clearfix">
      <div class="dna-userlist dna-main-full">
        <div style="float:left;clear:both">
          <h4>Search Details</h4>
          <form action="UserList" method="get">
            <div>
              <h5>Search:</h5>
              <input type="text" id="searchText" name="searchText" width="100">
                
                <xsl:attribute name="value">
                  <xsl:value-of select="/H2G2/MEMBERLIST/@SEARCHTEXT"/>
                </xsl:attribute>
              </input>
            </div>
            <div>
              <h5>Search By:</h5>
              <div class="searchTypeRadio">
                <label for="searchType_0">User ID</label>
                <input id="searchType_0" type="radio" name="usersearchtype" value="0">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </input>
              </div>
              <div class="searchTypeRadio">
                    <label for="searchType_1">Email</label>
                    <input id="searchType_1" type="radio" name="usersearchtype" value="1">
                      <xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '1'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
              </div>
              <div class="searchTypeRadio">
                    <label for="searchType_2">User Name</label>
                    <input id="searchType_2" type="radio" name="usersearchtype" value="2">
                      <xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '2'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
              </div>
              <div class="searchTypeRadio">
                    <label for="searchType_3">IP Address</label>
                    <input id="searchType_3" type="radio" name="usersearchtype" value="3">
                      <xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '3'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
              </div>
              <div class="searchTypeRadio">
                    <label for="searchType_4">BBCUID</label>
                    <input id="searchType_4" type="radio" name="usersearchtype" value="4">
                      <xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '4'">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
              </div>
              <div class="searchTypeRadio">
                <label for="searchType_5">Login Name</label>
                <input id="searchType_5" type="radio" name="usersearchtype" value="5">
                  <xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '5'">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                </input>
              </div>
            </div>
            <div>
              <span class="dna-buttons"><input type="submit" value="Search" /></span>
            </div>
          </form>
          <br />
          <xsl:choose>
            <xsl:when test="/H2G2/MEMBERLIST/@SEARCHTEXT != ''">
              <xsl:choose>
                <xsl:when test="/H2G2/MEMBERLIST/@COUNT = '0'">
                  No users found matching these details.
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </div>
        <xsl:choose>
          <xsl:when test="/H2G2/MEMBERLIST/@SEARCHTEXT != ''">
            <xsl:choose>
              <xsl:when test="/H2G2/MEMBERLIST/@COUNT != '0'">
                <xsl:apply-templates select="/H2G2/MEMBERLIST" />
              </xsl:when>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
        
      </div>
    </div>

  </xsl:template>

  <xsl:template match="MEMBERLIST">
    <form action="UserList?searchText={@SEARCHTEXT}&amp;usersearchType={@USERSEARCHTYPE}" method="post" id="modStatusForm">
      
      <div style="float:left;clear:both;padding-top:10px;padding-bottom:10px;width:100%">
      <h3>Users Found:</h3>
        <table class="userListTable">
          <tr>
            <th>
              All
              <input type="checkbox" name="applyToAll" id="applyToAll" />
            </th>
            <th>User ID</th>
            <th>User Name</th>
            <th>Login Name</th>
            <th>Email</th>
            <th>Status</th>
            <th>Site</th>
            <th>Identity User ID</th>
            <th>Active</th>
          </tr>
          <xsl:apply-templates select="/H2G2/MEMBERLIST/USERACCOUNTS/USERACCOUNT" />
          <tfoot>
            <tr>
              <td colspan="10">
                <xsl:value-of select="/H2G2/MEMBERLIST/@COUNT"/> users found.
              </td>

            </tr>
          </tfoot>
        </table>
      </div>
      <div style="float:left;clear:both;padding-top:10px;padding-bottom:10px">
        <h3>Moderation Actions</h3>
        <div style="float:left;">

          <div style="clear:both;">
            <div style="clear:both;">
              <label for="userStatusDescription">Moderation Status</label>
              <select id="userStatusDescription" name="userStatusDescription">
                <option value="Standard" selected="selected">Standard</option>
                <option value="Premoderate">Premoderate</option>
                <option value="Postmoderate">Postmoderate</option>
                <option value="Restricted">Banned</option>
                <xsl:if test="//H2G2/VIEWING-USER/USER/STATUS = '2'">
                  <option value="Deactivate">Deactivate</option>
                </xsl:if>
              </select>
            </div>
            <div id="durationContainer">
              <label for="duration">Duration:</label>
              <select id="duration" name="duration">
                <option value="0" selected="selected">no limit</option>
                <option value="1440">1 day</option>
                <option value="10080">1 week</option>
                <option value="20160">2 weeks</option>
                <option value="40320">1 month</option>
              </select>
            </div>
            <div id="hideAllPostsContainer">
              <input type="Checkbox" name="hideAllPosts" id="hideAllPosts" /> Hide all content
            </div>
          </div>
          <div style="clear:both;">
            <label for="reasonChange">Reason for change:</label>
            <textarea id="reasonChange" name="reasonChange" cols="50" rows="5">
              <xsl:text>&#x0A;</xsl:text>
            </textarea>
          </div>
          <span class="dna-buttons">
            <input type="submit" value="Apply action to marked accounts" id="ApplyAction" name="ApplyAction"></input>
          </span>
        </div>
        <div style="float:left;">
          Alternatively:<br />
          <span class="dna-buttons">
            <input type="submit" style="height: 24px;" id="ApplyNickNameReset" value="Reset Username to marked accounts" name="ApplyNickNameReset" />
          </span>
        </div>
      
    
    </div>
    </form>
  </xsl:template>

  <xsl:template match="USERACCOUNT">
    <tr>
      <td align="right">
        <input type="checkbox" name="applyTo|{@USERID}|{SITEID}" id="applyTo|{@USERID}|{SITEID}" class="applyToCheckBox"/>
      </td>
      <td>
        
        <xsl:value-of  select="@USERID"/>
        
      </td>
      <td>
        <a href="MemberDetails?userid={@USERID}" title="View users details">
        <xsl:value-of  select="USERNAME"/>
        </a>
      </td>
      <td>
        <xsl:value-of  select="LOGINNAME"/>
      </td>
      <td>
        <xsl:value-of  select="EMAIL"/>
      </td>
      <td align="center">
        <xsl:choose>
          <xsl:when test="ACTIVE = '1'">
            <img alt="{USERSTATUSDESCRIPTION}" src="/dnaimages/moderation/images/icons/status{PREFSTATUS}.gif" />
            <xsl:choose>
              <xsl:when test="PREFSTATUSDURATION != '0'">
                <br />
                <xsl:choose>
                  <xsl:when test="PREFSTATUSDURATION = '1440'">
                    (1 Day)
                  </xsl:when>
                  <xsl:when test="PREFSTATUSDURATION = '10080'">
                    (1 Week)
                  </xsl:when>
                  <xsl:when test="PREFSTATUSDURATION = '20160'">
                    (2 Weeks)
                  </xsl:when>
                  <xsl:when test="PREFSTATUSDURATION = '40320'">
                    (1 Month)
                  </xsl:when>
                  
                </xsl:choose>
                    
                
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <img alt="Inactive" src="/dnaimages/moderation/images/icons/status4.gif" />
          </xsl:otherwise>
        </xsl:choose>
        
      </td>
      <td align="center">
        <xsl:value-of  select="SHORTNAME"/> (<xsl:value-of  select="SITEID"/>)
      </td>
      <td>
        <xsl:value-of  select="IDENTITYUSERID"/> 
      </td>
      <td align="center">
        <xsl:value-of  select="ACTIVE"/>
      </td>
    </tr>
  </xsl:template>
 

</xsl:stylesheet>
