<?xml version="1.0"  encoding='iso-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

  <xsl:template name="MOREARTICLESUBSCRIPTIONS_HEADER"/>
  <xsl:template name="MOREARTICLESUBSCRIPTIONS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        Subscribed Articles
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="MOREUSERSUBSCRIPTIONS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
		  <xsl:if test="$ownerisviewer=1">
			  Your Subscribed Users
		  </xsl:if>
		  <xsl:if test="not($ownerisviewer=1)">
			  <xsl:value-of select="/H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USER/USERNAME"/>'s Subscribed Users
		  </xsl:if>		  
	  </xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>

  <xsl:template name="BLOCKEDUSERSUBSCRIPTIONS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
        Blocked Users
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="MORESUBSCRIBINGUSERS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
		  <xsl:if test="$ownerisviewer=1">
			 Users Subscribed to You
		  </xsl:if>
		  <xsl:if test="not($ownerisviewer=1)">
				  Users Subscribed to <xsl:value-of select="/H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST/USER/USERNAME"/>
		  </xsl:if>
	  </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="MORELINKSUBSCRIPTIONS_SUBJECT">
    <xsl:call-template name="SUBJECTHEADER">
      <xsl:with-param name="text">
		  <xsl:if test="$ownerisviewer=1">
			  Your Subscribed to Users Bookmarks
		  </xsl:if>
		  <xsl:if test="not($ownerisviewer=1)">
			  <xsl:value-of select="/H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST/USER/USERNAME"/>'s Subscribed to Users Bookmarks
		  </xsl:if>		  
	  </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

	<xsl:variable name="mas-userid">
		<xsl:value-of select="/H2G2/MOREARTICLESUBSCRIPTIONS/@USERID|/H2G2/MOREUSERSUBSCRIPTIONS/@USERID|/H2G2/BLOCKEDUSERSUBSCRIPTIONS/@USERID|/H2G2/MORESUBSCRIBINGUSERS/@USERID|/H2G2/MORELINKSUBSCRIPTIONS/@USERID"/>
	</xsl:variable>

	<xsl:template name="MORESUBSCRIBINGUSERS_MAINBODY">
    <xsl:apply-templates select="/H2G2" mode="mus-navbar"/>
	<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
	<xsl:apply-templates select="/H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST" mode="subscribing-table"/>
    <xsl:apply-templates select="/H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST" mode="previousnext"/>
  </xsl:template>

  <xsl:template match="SUBSCRIBINGUSERS-LIST" mode="previousnext">
    <div class="morepages">
      <xsl:if test="@SKIP &gt; 0">
        <a href="{$root}MSU{$mas-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
      </xsl:if>
      <xsl:if test="@MORE=1">
        <a href="{$root}MSU{$mas-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
      </xsl:if>
    </div>

  </xsl:template>

  <xsl:template match="BLOCKEDUSERSUBSCRIPTIONS-LIST" mode="previousnext">
    <div class="morepages">
      <xsl:if test="@SKIP &gt; 0">
        <a href="{$root}BUS{$mas-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
      </xsl:if>
      <xsl:if test="@MORE=1">
        <a href="{$root}BUS{$mas-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
      </xsl:if>
    </div>
  </xsl:template>

    <xsl:template match="USERSUBSCRIPTION-LIST" mode="previousnext">
      <div class="morepages">
        <xsl:if test="@SKIP &gt; 0">
          <a href="{$root}MUS{$mas-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
        </xsl:if>
        <xsl:if test="@MORE=1">
          <a href="{$root}MUS{$mas-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
        </xsl:if>
      </div>
    </xsl:template>

  <xsl:template match="SUBSCRIBINGUSERS-LIST" mode="subscribing-table">
    <div class="subscribing-users">
      <table>
		  <xsl:if test="$ownerisviewer=1">
			  <col class="msu-action"/>
		  </xsl:if>
        <col class="msu-userid"/>
        <col class="msu-username"/>
        <tr>
			<xsl:if test="$ownerisviewer=1">
				<th>Action</th>
			</xsl:if>
			<th>ID</th>
          <th>Username</th>
        </tr>
        <xsl:apply-templates select="USERS/USER" mode="subscribing-table"/>
      </table>
    </div>
  </xsl:template>
  
  <xsl:template name="MOREARTICLESUBSCRIPTIONS_MAINBODY">
    <xsl:apply-templates select="/H2G2" mode="mus-navbar"/>
	<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
	<xsl:apply-templates select="/H2G2/MOREARTICLESUBSCRIPTIONS/ARTICLESUBSCRIPTIONLIST/ARTICLES" mode="subscription-table"/>
    <xsl:apply-templates select="/H2G2/MOREARTICLESUBSCRIPTIONS/ARTICLESUBSCRIPTIONLIST" mode="previousnext"/>
  </xsl:template>
  
  <xsl:template match="ARTICLESUBSCRIPTIONLIST" mode="previousnext">
    <div class="morepages">
    <xsl:if test="@SKIP &gt; 0">
      <a href="{$root}MAS{$mas-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Newer Entries</a>&nbsp;
    </xsl:if>
    <xsl:if test="@COUNT = @SHOW">
      <a href="{$root}MAS{$mas-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Older Entries &gt;&gt;</a>&nbsp;
    </xsl:if>
    </div>
    <div class="morepages">
		<xsl:if test="$ownerisviewer=1">
			<a href="{$root}MUS{$mas-userid}">Manage your subscription list</a>
		</xsl:if>
	</div>
  </xsl:template>

  <xsl:template name="BLOCKEDUSERSUBSCRIPTIONS_MAINBODY">
	<xsl:apply-templates select="/H2G2" mode="mus-navbar"/>
	<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
	<xsl:apply-templates select="/H2G2/BLOCKEDUSERSUBSCRIPTIONS/ACTIONRESULT" mode="bus-action"/>
    <xsl:apply-templates select="/H2G2/BLOCKEDUSERSUBSCRIPTIONS" mode="blocked-table"/>
    <xsl:apply-templates select="/H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST" mode="previousnext"/>
  </xsl:template>

  <xsl:template match="BLOCKEDUSERSUBSCRIPTIONS" mode="blocked-table">
    <div class="blockedusers">
      <table>
		  <xsl:if test="$ownerisviewer=1">
			  <col class="bus-unblock"/>
		  </xsl:if>
        <col class="bus-userid"/>
        <col class="bus-username"/>
        <tr>
			<xsl:if test="$ownerisviewer=1">
				<th>Action</th>
			</xsl:if>
			<th>ID</th>
          <th>Username</th>
        </tr>
        <xsl:apply-templates select="BLOCKEDUSERSUBSCRIPTIONS-LIST/USERS/USER" mode="blocked-table"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="USER" mode="blocked-table">
    <tr>
		<xsl:if test="$ownerisviewer=1">
			<td>
				<a href="{$root}BUS{$mas-userid}?dnaaction=unblockusersubscription&amp;blockedid={USERID}">unblock</a>
			</td>
		</xsl:if>
      <td>
        <a href="{$root}U{USERID}">U<xsl:value-of select="USERID"/>
      </a>
      </td>
      <td>
        <xsl:value-of select="USERNAME"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="MOREUSERSUBSCRIPTIONS_MAINBODY">
    <xsl:apply-templates select="/H2G2" mode="mus-navbar"/>
	<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
	<xsl:apply-templates select="/H2G2/MOREUSERSUBSCRIPTIONS/ACTIONRESULT" mode="mus-action"/>
    <xsl:apply-templates select="/H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST" mode="subscription-table"/>
    <xsl:apply-templates select="/H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST" mode="previousnext"/>
  </xsl:template>

  <xsl:template match="H2G2" mode="mus-navbar">
    <ul class="mus-navbar">
      <li>
         <xsl:if test="@TYPE='MOREARTICLESUBSCRIPTIONS'">
          <xsl:attribute name="class">mus-navselected</xsl:attribute>
        </xsl:if>
       <a href="{$root}MAS{$mas-userid}">Subscribed Articles</a>
      </li>
      <li>
        <xsl:if test="@TYPE='MOREUSERSUBSCRIPTIONS'">
          <xsl:attribute name="class">mus-navselected</xsl:attribute>
        </xsl:if>
              <a href="{$root}MUS{$mas-userid}">Subscribed Users</a>
      </li>
		<li>
			<xsl:if test="@TYPE='MORELINKSUBSCRIPTIONS'">
				<xsl:attribute name="class">mus-navselected</xsl:attribute>
			</xsl:if>
			<a href="{$root}MLS{$mas-userid}">Subscribed to Users Bookmarks</a>
		</li>
        <li>
          <xsl:if test="@TYPE='MORESUBSCRIBINGUSERS'">
            <xsl:attribute name="class">mus-navselected</xsl:attribute>
          </xsl:if>
			<xsl:if test="$ownerisviewer=1">
				<a href="{$root}MSU{$mas-userid}">Users Subscribed to You</a>
			</xsl:if>
			<xsl:if test="not($ownerisviewer=1)">
				<a href="{$root}MSU{$mas-userid}">Users Subscribed to U<xsl:value-of select="$mas-userid"/></a>
			</xsl:if>
		</li>
		<xsl:if test="$mas-userid = number(/H2G2/VIEWING-USER/USER/USERID)">
			<li>
          <xsl:if test="@TYPE='BLOCKEDUSERSUBSCRIPTIONS'">
            <xsl:attribute name="class">mus-navselected</xsl:attribute>
          </xsl:if>
          <a href="{$root}BUS{$mas-userid}">Blocked Users</a>
        </li>
        <xsl:apply-templates select="MORESUBSCRIBINGUSERS|MOREUSERSUBSCRIPTIONS|BLOCKEDUSERSUBSCRIPTIONS|MOREARTICLESUBSCRIPTIONS" mode="navbar"/>
      </xsl:if>
   </ul>
  </xsl:template>

  <xsl:template match="MORESUBSCRIBINGUSERS|MOREUSERSUBSCRIPTIONS|BLOCKEDUSERSUBSCRIPTIONS|MOREARTICLESUBSCRIPTIONS" mode="navbar">
      <li>
        <xsl:choose>
          <xsl:when test="@ACCEPTSUBSCRIPTIONS=1">
            You are currently accepting subscriptions. <a href="{$root}BUS{$mas-userid}?dnaaction=blocksubscriptions">Block All Subscriptions</a>
          </xsl:when>
          <xsl:otherwise>
            You have blocked users from subscribing to you. <a href="{$root}BUS{$mas-userid}?dnaaction=acceptsubscriptions">Allow Subscriptions</a>
          </xsl:otherwise>
        </xsl:choose>
      </li>
  </xsl:template>
  <xsl:template match="ACTIONRESULT" mode="bus-action">
    <div class="mus-actionresult">
      <xsl:choose>
        <xsl:when test="@ACTION='blockuser'">
          <p>
            You have added the following <xsl:choose>
              <xsl:when test="count(USER) &gt; 1">users</xsl:when>
              <xsl:otherwise>user</xsl:otherwise>
            </xsl:choose> to your block list:
          </p>
          <div class="usersubscriptions">
            <table>
				<xsl:if test="$ownerisviewer=1">
					<col class="mus-unsubscribe"/>
				</xsl:if>
				<col class="mus-userid"/>
              <col class="mus-username"/>
              <tr>
				  <xsl:if test="$ownerisviewer=1">
					  <th>Action</th>
				  </xsl:if>
				  <th>ID</th>
                <th>Username</th>
              </tr>
              <xsl:apply-templates select="USER" mode="bus-user-actions"/>
            </table>
          </div>
        </xsl:when>
        <xsl:when test="@ACTION='unblockuser'">
          <p>
            You have removed the following <xsl:choose>
              <xsl:when test="count(USER) &gt; 1">users</xsl:when>
              <xsl:otherwise>user</xsl:otherwise>
            </xsl:choose> from your block list:
          </p>
          <div class="usersubscriptions">
            <table>
				<xsl:if test="$ownerisviewer=1">
					<col class="mus-unsubscribe"/>
				</xsl:if>
				<col class="mus-userid"/>
              <col class="mus-username"/>
              <tr>
				  <xsl:if test="$ownerisviewer=1">
					  <th>Action</th>
				  </xsl:if>
				  <th>ID</th>
                <th>Username</th>
              </tr>
              <xsl:apply-templates select="USER" mode="bus-user-actions"/>
            </table>
          </div>
        </xsl:when>
        <xsl:when test="@ACTION='blocksubscriptions'">

        </xsl:when>
        <xsl:when test="@ACTION='unblocksubscriptions'">

        </xsl:when>
      </xsl:choose>
    </div>

  </xsl:template>

  <xsl:template match="USER" mode="bus-user-actions">
    <tr>
		<xsl:if test="$ownerisviewer=1">
			<td>
				<xsl:choose>
					<xsl:when test="../@ACTION='blockuser'">
						<a href="{$root}BUS{$mas-userid}?dnaaction=unblockusersubscription&amp;blockedid={USERID}">unblock</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$root}BUS{$mas-userid}?dnaaction=blockusersubscription&amp;blockedid={USERID}">block</a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:if>
		<td>
			<a href="{$root}U{USERID}">
			U<xsl:value-of select="USERID"/>
			</a>
		</td>
		<td>
			<xsl:value-of select="USERNAME"/>
		</td>
    </tr>
  </xsl:template>
  
  <xsl:template match="ACTIONRESULT" mode="mus-action">
    <div class="mus-actionresult">
      <xsl:choose>
        <xsl:when test="@ACTION='subscribe'">
          
              <p>You have added the following <xsl:choose>
                <xsl:when test="count(USER) &gt; 1">users</xsl:when>
                <xsl:otherwise>user</xsl:otherwise>
              </xsl:choose> to your subscription list:</p>
          <div class="usersubscriptions">
            <table>
				<xsl:if test="$ownerisviewer=1">
					<col class="mus-unsubscribe"/>
				</xsl:if>
				<col class="mus-userid"/>
				<col class="mus-username"/>
				<tr>
					<xsl:if test="$ownerisviewer=1">
						<th>Action</th>
					</xsl:if>
					<th>ID</th>
					<th>Username</th>
				</tr>
				<xsl:apply-templates select="USER" mode="mus-user-actions"/>
            </table>
          </div>
        </xsl:when>
        <xsl:when test="@ACTION='unsubscribe'">
          <p>
            You have removed the following <xsl:choose>
              <xsl:when test="count(USER) &gt; 1">users</xsl:when>
              <xsl:otherwise>user</xsl:otherwise>
            </xsl:choose> from your subscription list:
          </p>
          <div class="usersubscriptions">
            <table>
				<xsl:if test="$ownerisviewer=1">
					<col class="mus-resubscribe"/>
				</xsl:if>
				<col class="mus-userid"/>
              <col class="mus-username"/>
              <tr>
				  <xsl:if test="$ownerisviewer=1">
					  <th>Action</th>
				  </xsl:if>
				 <th>ID</th>
                <th>Username</th>
              </tr>
              <xsl:apply-templates select="USER" mode="mus-user-actions"/>
            </table>
          </div>
        </xsl:when>
        <xsl:when test="@ACTION='blocksubscriptions'">
          You have blocked other users from subscribing to your articles.
        </xsl:when>
        <xsl:when test="@ACTION='acceptsubscriptions'">You are now allowing other users to subscribe to your articles</xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="USER" mode="mus-user-actions">
    <tr>
		<xsl:if test="$ownerisviewer=1">
			<td>
				<xsl:choose>
				  <xsl:when test="../@ACTION='unsubscribe'">
					  <a href="{$root}MUS{$mas-userid}?dnaaction=subscribe&amp;subscribedtoid={USERID}">resubscribe</a>
				  </xsl:when>
				  <xsl:otherwise>
					  <a href="{$root}MUS{$mas-userid}?dnaaction=unsubscribe&amp;subscribedtoid={USERID}">remove</a>
				  </xsl:otherwise>
			  </xsl:choose>
			</td>
		</xsl:if>
		<td>
			<a href="{$root}U{USERID}">U<xsl:value-of select="USERID"/>
			</a>
		</td>
      <td>
        <xsl:value-of select="USERNAME"/>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="USERSUBSCRIPTION-LIST" mode="subscription-table">
    <div class="usersubscriptions">
    <table>
		<xsl:if test="$ownerisviewer=1">
			<col class="mus-action"/>
		</xsl:if>
		<col class="mus-userid" />
		<col class="mus-username" />
		<tr>
			<xsl:if test="$ownerisviewer=1">
				<th>Action</th>
			</xsl:if>
			<th>ID</th>
			<th>Username</th>
		</tr>
		<xsl:apply-templates select="USERS/USER" mode="subscription-table"/>
    </table>
    </div>
  </xsl:template>

  <xsl:template match="USER" mode="subscription-table">
    <tr>
		<xsl:if test="$ownerisviewer=1">
			<td>
				<a href="{$root}MUS{$mas-userid}?subscribedtoid={USERID}&amp;dnaaction=unsubscribe">remove</a>
			</td>
		</xsl:if>
		<td>
			<a href="{$root}U{USERID}">U<xsl:value-of select="USERID"/>
			</a>
		</td>
		<td>
			<xsl:value-of select="USERNAME"/>
		</td>
    </tr>
  </xsl:template>

  <xsl:template match="USER" mode="subscribing-table">
    <tr>
		<xsl:if test="$ownerisviewer=1">
			<td>
				<a href="{$root}BUS{$mas-userid}?blockedid={USERID}&amp;dnaaction=blockusersubscription">remove and block</a>
			</td>
		</xsl:if>
		<td>
			<a href="{$root}U{USERID}">
			U<xsl:value-of select="USERID"/>
			</a>
      </td>
      <td>
        <xsl:value-of select="USERNAME"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="MORELINKSUBSCRIPTIONS_MAINBODY">
    <xsl:apply-templates select="/H2G2" mode="mus-navbar"/>
    <xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
    <xsl:apply-templates select="/H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST" mode="subscription-table"/>
    <xsl:apply-templates select="/H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST" mode="previousnext"/>
  </xsl:template>


  <xsl:template match="USERSUBSCRIPTIONLINKS-LIST" mode="previousnext">
    <div class="morepages">
      <xsl:if test="@SKIP &gt; 0">
        <a href="{$root}MLS{$mas-userid}?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
      </xsl:if>
      <xsl:if test="@MORE=1">
        <a href="{$root}MLS{$mas-userid}?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
      </xsl:if>
    </div>

  </xsl:template>

  <xsl:template match="USERSUBSCRIPTIONLINKS-LIST" mode="subscription-table">
    <div class="usersubscriptions">
      <table>
        <tr>
          <th>ID</th>
          <th>Title</th>
          <th>CreatedBy</th>
          <th>Created</th>
        </tr>
        <xsl:apply-templates select="LINK" mode="subscription-table"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="LINK" mode="subscription-table">
    <tr>
      <td>
        <a href="{$root}@DNAUID">
          <xsl:value-of select="@DNAUID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="DESCRIPTION"/>
      </td>
      <td>
        <!-- Display user name -->
        <xsl:apply-templates select="SUBMITTER/USER"/>
      </td>
      <td>
        <xsl:apply-templates select="DATELINKED/DATE"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="ERROR" mode="errormessage">
		<p>
			<xsl:value-of select="@TYPE"/> - 
			<xsl:value-of select="ERRORMESSAGE"/>
		</p>
	</xsl:template>

  <xsl:template name="MOREARTICLESUBSCRIPTIONS_CSS"/>
  <xsl:template name="MOREARTICLESUBSCRIPTIONS_JAVASCRIPT"/>
</xsl:stylesheet> 
