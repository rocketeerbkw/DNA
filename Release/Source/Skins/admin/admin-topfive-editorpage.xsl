<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:template name="TOPFIVE-EDITOR_MAINBODY">
		<xsl:apply-templates select="TOP-FIVE-LISTS"/>
		<form method="POST" action="{$root}TopFiveEditor">
      <table>
        <tr>
          <td>List Name:</td>
          <td>
            <INPUT TYPE="text" name="editgroup" value="{TOP-FIVE-EDIT/@NAME}"/>
          </td>
          <td>Change name to add a new top five group. Must have at least one item in group.</td>
        </tr>
        <tr>
          <td>Description:</td>
          <td>
            <input type="text" name="description" value="{TOP-FIVE-EDIT/DESCRIPTION}"/>
          </td>
          <td></td>
        </tr>
        <tr>
          <td/>
          <td>
            <input type="radio" name="type" value="article">
              <xsl:if test="TOP-FIVE-EDIT[@TYPE='ARTICLE']">
                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              </xsl:if>
            </input> Articles
            <BR/><input type="radio" name="type" value="forum">
              <xsl:if test="TOP-FIVE-EDIT[@TYPE='FORUM']">
                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              </xsl:if>
            </input> Forums
          </td>
        </tr>
      </table>
      <table>
        <th>Article H2G2ID / ForumID</th>
        <th>ThreadID ( optional) </th>
        <th>Title / Info </th>
        <xsl:if test="count(TOP-FIVE-EDIT/FORUM|TOP-FIVE-EDIT/H2G2) &lt; 20 and /H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE='start'">
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>
              <a href="{$root}TopFiveEditor?editgroup={TOP-FIVE-EDIT/@NAME}&amp;type={TOP-FIVE-EDIT/@TYPE}&amp;fetch=1">
                Add New Items at end of list
              </a>
            </td>

          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>Leave ThreadID blank for article lists or to include whole forum</td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>
              To add more than five new entries, add the first five and press the Update Group button to add the next five up to maximum of 20.
            </td>
          </tr>
        </xsl:if>
        <xsl:apply-templates select="TOP-FIVE-EDIT/FORUM|TOP-FIVE-EDIT/H2G2"/>
        <xsl:if test="count(TOP-FIVE-EDIT/FORUM|TOP-FIVE-EDIT/H2G2) &lt; 20 and not(/H2G2/PARAMS/PARAM[NAME='s_sort']/VALUE = 'start')">
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>
              <a href="{$root}TopFiveEditor?editgroup={TOP-FIVE-EDIT/@NAME}&amp;type={TOP-FIVE-EDIT/@TYPE}&amp;fetch=1&amp;s_sort=start">
                Add New Items at start of list
              </a>
            </td>
            
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>Leave ThreadID blank for article lists or to include whole forum</td>
          </tr>
          <tr>
            <td>
              <input type="text" name="id" value=""/>
            </td>
            <td>
              <input type="text" name="threadid" value=""/>
            </td>
            <td>
              To add more than five new entries, add the first five and press the Update Group button to add the next five up to maximum of 20.
            </td>
          </tr>
        </xsl:if>
          <tr>
            <td colspan="3">
              <input type="submit" name="update" value="Update group"/>
              <input type="submit" name="delete" value="Delete group"/>
            </td>
          </tr>
      </table>
		</form>
		<xsl:apply-templates select="TOP-FIVES"/>
	</xsl:template>

	<xsl:template match="TOP-FIVE-LISTS">
   Here are your current lists (not all of these will be editable)<br/>
		<xsl:for-each select="LIST">
			<a href="{$root}TopFiveEditor?editgroup={GROUPNAME}&amp;type={TYPE}&amp;fetch=1">
				<xsl:value-of select="GROUPNAME"/>
			</a>
			<br/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="TOP-FIVE-EDIT/FORUM">
    <tr>
      <td>
        <input type="text" name="id" value="{@FORUMID}"/>
      </td>
      <td>
        <input type="text" name="threadid" value="{@THREAD}"/>
      </td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
	</xsl:template>
  
	<xsl:template match="TOP-FIVE-EDIT/H2G2">
    <tr>
      <td>
        <input type="text" name="id" value="{@H2G2ID}"/>
      </td>
      <td>
        <input type="text" name="threadid" value=""/>
      </td>
      <td>
        <xsl:value-of select="."/>
      </td>
    </tr>
	</xsl:template>
</xsl:stylesheet>