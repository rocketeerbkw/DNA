<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="CATEGORY_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_cat_title"/></title>
</xsl:template>

<xsl:template name="CATEGORY_TITLEDATA">
	<font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/></b></font>
	<br clear="ALL" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="ALL" />
</xsl:template>

<xsl:template name="CATEGORY_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:apply-templates select="HIERARCHYDETAILS/ANCESTRY"/></b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="CATEGORY_MAINBODY">
	<!-- xsl:if test="HIERARCHYDETAILS/DESCRIPTION!=''">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				<td width="100%" background="{$imagesource}dotted_line_sml.jpg"><img src="{$imagesource}t.gif" width="611" height="5" alt="" /></td>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:apply-templates select="HIERARCHYDETAILS/DESCRIPTION"/></font></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
		</table>
	</xsl:if -->
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				<td width="100%" background="{$imagesource}dotted_line_sml.jpg"><img src="{$imagesource}t.gif" width="611" height="5" alt="" /></td>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
			<tr>
				<td>
				<font xsl:use-attribute-sets="mainfont" class="postxt">
				<xsl:apply-templates select="HIERARCHYDETAILS/ARTICLE/GUIDE"/><br/>
					<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR') or  ($superuser = 1)">				
						<br/><strong><a class="pos" href="UserEdit{HIERARCHYDETAILS/ARTICLE/ARTICLEINFO/H2G2ID}">Edit the description above</a></strong><br />
					</xsl:if>
				</font>
				</td>
			</tr>			
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
		</table>
		

	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td align="left"><br />
				<xsl:choose>
					<xsl:when test="HIERARCHYDETAILS">
						<xsl:apply-templates select="HIERARCHYDETAILS" mode="CATEGORY" />
					</xsl:when>
					<xsl:otherwise>
						<UL>
							<xsl:call-template name="applytofragment">
								<xsl:with-param name="fragment" select="$categoryroot"/>
							</xsl:call-template>
						</UL>
					</xsl:otherwise>
				</xsl:choose>
				<table width="100%" cellspacing="14" cellpadding="0" border="0">
					<tr>
						<td background="{$imagesource}dotted_line_inv.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
					</tr>
				</table>
				<table width="250" cellpadding="0" cellspacing="14" border="0">
					<form method="GET" action="Search" target="_top">
						<tr>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_cat_cantfindq"/></font></td>
						</tr>
						<tr>
							<td colspan="2"><font xsl:use-attribute-sets="mainfont"><b><xsl:value-of select="$m_searchsubject"/></b></font></td>
						</tr>
						<tr>
							<td width="185"><input type="text" name="searchstring" value="" title="Keywords to Search for" size="21" style="width:185;" /><input type="hidden" name="searchtype" value="goosearch" /></td>
							<td width="23"><input type="IMAGE" src="{$imagesource}go_red.gif" name="go" value="Go" border="0" /></td>
						</tr>
					</form>
				</table>
				<br /><br /><br />
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="EDITCATEGORY_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="10" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<xsl:apply-templates select="EDITCATEGORY" mode="topbar"/>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="EDITCATEGORY" mode="topbar">
<font xsl:use-attribute-sets="catfontheader"><B><xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/></B></font>
<font xsl:use-attribute-sets="mainfont" class="postxt">
<A class="pos"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=renamesubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/></xsl:attribute><br/><xsl:call-template name="m_EditCatRenameSubjectButton"/></A>
<br/>

<xsl:apply-templates select="HIERARCHYDETAILS/DESCRIPTION">
<xsl:with-param name="iscategory">0</xsl:with-param>
</xsl:apply-templates>


<hr/>


<xsl:variable name="action">
<xsl:choose>
<xsl:when test="ACTIVENODE/@TYPE">
&amp;action=navigate<xsl:value-of select="ACTIVENODE/@TYPE"/>
</xsl:when>
<xsl:otherwise>
&amp;action=navigatesubject
</xsl:otherwise>
</xsl:choose>
</xsl:variable>


<xsl:apply-templates select="HIERARCHYDETAILS/ANCESTRY">
<xsl:with-param name="iscategory">0</xsl:with-param>
<xsl:with-param name="activenode"><xsl:if test="ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/></xsl:if><xsl:if test="ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/></xsl:if></xsl:with-param>
<xsl:with-param name="action" select="$action"/>
</xsl:apply-templates>
<hr/>


</font>
</xsl:template>



<xsl:template match="EDITCATEGORY">
<xsl:variable name="action">
<xsl:choose>
<xsl:when test="ACTIVENODE/@TYPE">
&amp;action=navigate<xsl:value-of select="ACTIVENODE/@TYPE"/>
</xsl:when>
<xsl:otherwise>
&amp;action=navigatesubject
</xsl:otherwise>
</xsl:choose>
</xsl:variable>


<font xsl:use-attribute-sets="catfont">
<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=addsubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/></xsl:attribute><xsl:call-template name="m_EditCatAddSubjectButton"/></A>
<br/>
<xsl:choose>
<xsl:when test="ACTIVENODE/@TYPE='article'">
<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=storearticle&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the article here');</xsl:attribute>Store the article "<xsl:value-of select="ACTIVENODE"/>" here</A>
</xsl:when>
<xsl:when test="ACTIVENODE/@TYPE='alias'">
<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=storealias&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/>&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the link here');</xsl:attribute>Move the link "<xsl:value-of select="ACTIVENODE"/>" here</A>
</xsl:when>
<xsl:when test="ACTIVENODE/@TYPE='subject'">
<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=storesubject&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the subject here');</xsl:attribute>Store the subject "<xsl:value-of select="ACTIVENODE"/>" here</A>
<br/>
<A class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=doaddalias&amp;nodeid=<xsl:value-of select="HIERARCHYDETAILS/@NODEID"/>&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('You are about to store the link here');</xsl:attribute>Store the link "<xsl:value-of select="ACTIVENODE"/>" here</A>
</xsl:when>
</xsl:choose>




<!-- add your own messages here if you don't want the default ones-->

<xsl:if test="ERROR">
	<br/>
	<xsl:choose>
	<xsl:when test="ERROR/@TYPE='9'">
	<font xsl:use-attribute-sets="xmlerrorfont">
	That subject already exists
	</font>
	</xsl:when>
	<xsl:otherwise>
	<font xsl:use-attribute-sets="xmlerrorfont">
	<xsl:value-of select="ERROR"/>
	</font>
	</xsl:otherwise>
	</xsl:choose>
</xsl:if>

<xsl:apply-templates select="EDITINPUT">
<xsl:with-param name="nodeid"><xsl:value-of select="HIERARCHYDETAILS/@NODEID"/></xsl:with-param>
<xsl:with-param name="displayname"><xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/></xsl:with-param>
</xsl:apply-templates>
<hr/>

<xsl:if test="HIERARCHYDETAILS/@ISROOT=0">
Add an article to this subject
<FORM METHOD="GET" ACTION="EditCategory">
Article ID: <INPUT TYPE="TEXT" NAME="h2g2id"/>
<INPUT TYPE="HIDDEN" NAME="nodeid" VALUE="{HIERARCHYDETAILS/@NODEID}"/>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="doaddarticle"/>
<INPUT TYPE="SUBMIT" NAME="button" VALUE="Store Article"/>
</FORM>
</xsl:if>
<hr/>

<xsl:apply-templates select="HIERARCHYDETAILS/MEMBERS">
<xsl:with-param name="columnlen"><xsl:choose><xsl:when test="count(HIERARCHYDETAILS/MEMBERS/*) &lt; $catcolcount"><xsl:value-of select="$catcolcount"/></xsl:when><xsl:otherwise><xsl:value-of select="floor(count(HIERARCHYDETAILS/MEMBERS/*) div 2)"/></xsl:otherwise></xsl:choose></xsl:with-param>
<xsl:with-param name="numitems"><xsl:value-of select="count(HIERARCHYDETAILS/MEMBERS/*)"/></xsl:with-param>
<xsl:with-param name="iscategory">0</xsl:with-param>
<xsl:with-param name="activenode"><xsl:if test="ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="ACTIVENODE/@ACTIVEID"/></xsl:if><xsl:if test="ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="ACTIVENODE/@DELNODE"/></xsl:if></xsl:with-param>
<xsl:with-param name="action" select="$action"/>
</xsl:apply-templates>

</font>


</xsl:template>

<xsl:template name="EDITCATEGORY_MAINBODY">
<br/>
<xsl:apply-templates select="EDITCATEGORY"/>
</xsl:template>

<xsl:template name="CATEGORY_SIDEBAR">
</xsl:template>

<xsl:template match="HIERARCHYDETAILS" mode="CATEGORY">
	<xsl:apply-templates select="MEMBERS">
		<xsl:with-param name="columnlen">
			<xsl:choose>
				<xsl:when test="count(MEMBERS/*) &lt; $catcolcount">
					<xsl:value-of select="$catcolcount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor(count(MEMBERS/*) div 2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
		<xsl:with-param name="numitems">
			<xsl:value-of select="count(MEMBERS/*)"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="HIERARCHYDETAILS/DESCRIPTION">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:apply-templates/>
	<xsl:if test="$iscategory=0">
		<a class="pos"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?action=renamedesc&amp;nodeid=<xsl:value-of select="../@NODEID"/></xsl:attribute><br /><xsl:call-template name="m_EditCatRenameDesc"/></a>
	</xsl:if>
</xsl:template>

<xsl:template match="A[ancestor::DESCRIPTION]">
 	<a>
 		<xsl:attribute name="class">pos</xsl:attribute>
 		<xsl:call-template name="dolinkattributes"/>
 		<xsl:apply-templates/>
 	</a>
</xsl:template>

<xsl:template match="ANCESTRY">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:param name="activenode"/>
	<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
	<xsl:for-each select="ANCESTOR">
		<xsl:choose>
			<xsl:when test="$iscategory=1">
				<a class="pos"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>C<xsl:value-of select="NODEID"/></xsl:attribute><xsl:value-of select="NAME"/></a> / 
			</xsl:when>
			<xsl:otherwise>
				<a class="pos"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/></xsl:attribute><xsl:value-of select="NAME"/></a> / 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:value-of select="../DISPLAYNAME"/>
</xsl:template>

<xsl:template match="MEMBERS">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:param name="activenode"/>
	<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
	<xsl:param name="columnlen">120</xsl:param>
	<xsl:param name="numitems">120</xsl:param>
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr valign="top">
			<td align="left">
				<font xsl:use-attribute-sets="mainfont">
				<ul style="list-style:square;color:#FFFF00">
				<xsl:apply-templates select="SUBJECTMEMBER[number(@SORTORDER) &lt; $columnlen]|ARTICLEMEMBER[number(@SORTORDER) &lt; $columnlen]|NODEALIASMEMBER[number(@SORTORDER) &lt; $columnlen]">
					<xsl:sort select="@SORTORDER" data-type="number" order="ascending"/>
					<xsl:with-param name="iscategory" select="$iscategory"/>
					<xsl:with-param name="activenode" select="$activenode"/>
					<xsl:with-param name="action" select="$action"/>
				</xsl:apply-templates>
				</ul>
				</font>
			</td>
			<td align="left">
				<font xsl:use-attribute-sets="mainfont">
				<ul style="list-style:square;color:#FFFF00">
					<xsl:apply-templates select="SUBJECTMEMBER[number(@SORTORDER) &gt; ($columnlen)-1]|ARTICLEMEMBER[number(@SORTORDER) &gt; ($columnlen)-1]|NODEALIASMEMBER[number(@SORTORDER) &gt; $columnlen]">
						<xsl:sort select="@SORTORDER" data-type="number" order="ascending"/>
						<xsl:with-param name="iscategory" select="$iscategory"/>
						<xsl:with-param name="activenode" select="$activenode"/>
						<xsl:with-param name="action" select="$action"/>
					</xsl:apply-templates>
				</ul>
				</font>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="MEMBERS/SUBJECTMEMBER">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:param name="activenode"/>
	<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
	<li>
		<xsl:variable name="linkto">
			<xsl:choose>
				<xsl:when test="$iscategory=1">C<xsl:value-of select="NODEID"/></xsl:when>
				<xsl:otherwise>editcategory?nodeid=<xsl:value-of select="NODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><xsl:value-of select="NAME"/></a><font style="color:#ffffff"></font>
			</xsl:when>
			<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><b><xsl:value-of select="NAME"/></b></a><font style="color:#ffffff"> [1]</font>
			</xsl:when>
			<xsl:otherwise>
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><b><xsl:value-of select="NAME"/></b></a><font style="color:#ffffff"> [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/>]</font>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$iscategory=0">
			<br/>
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatesubject&amp;activenode=<xsl:value-of select="NODEID"/></xsl:attribute><xsl:call-template name="m_movesubject"/></a>
			<xsl:call-template name="m_EditCatDots"/>
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delsubject&amp;activenode=<xsl:value-of select="NODEID"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute><xsl:call-template name="m_editcatDeleteSubject"/></a>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="MEMBERS/ARTICLEMEMBER">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:param name="activenode"/>
	<li>
		<xsl:choose>
			<xsl:when test="string-length(SECTION) &gt; 0">
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>?section=<xsl:value-of select="SECTION"/></xsl:attribute><xsl:value-of select="NAME"/> (<xsl:value-of select="SECTIONDESCRIPTION"/>)</a>
			</xsl:when>
			<xsl:otherwise>
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:value-of select="NAME"/></a>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$iscategory=0">
			<br/>
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatearticle&amp;activenode=<xsl:value-of select="H2G2ID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/></xsl:attribute><xsl:call-template name="m_editcatMoveArticle"/></a>........
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delarticle&amp;activenode=<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete?');</xsl:attribute><xsl:call-template name="m_editcatDeleteArticle"/></a>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="MEMBERS/NODEALIASMEMBER">
	<xsl:param name="iscategory">1</xsl:param>
	<xsl:param name="activenode"/>
	<xsl:param name="action">&amp;action=navigatesubject</xsl:param>
	<xsl:variable name="linkto">
		<xsl:choose>
			<xsl:when test="$iscategory=1">C<xsl:value-of select="LINKNODEID"/></xsl:when>
			<xsl:otherwise>editcategory?nodeid=<xsl:value-of select="LINKNODEID"/><xsl:value-of select="$activenode"/><xsl:value-of select="$action"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<li>
		<xsl:choose>
			<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 0">
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><i><xsl:value-of select="NAME"/></i></a><font style="color:#ffffff"></font>
			</xsl:when>
			<xsl:when test="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT) = 1">
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><b><i><xsl:value-of select="NAME"/></i></b></a><font style="color:#ffffff"> [1]</font>
			</xsl:when>
			<xsl:otherwise>
				<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$linkto"/></xsl:attribute><b><i><xsl:value-of select="NAME"/></i></b></a><font style="color:#ffffff"> [<xsl:value-of select="number(NODECOUNT)+number(ARTICLECOUNT)+number(ALIASCOUNT)"/>]</font>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$iscategory=0">
			<br/>
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=0&amp;action=navigatealias&amp;activenode=<xsl:value-of select="LINKNODEID"/>&amp;delnode=<xsl:value-of select="../../@NODEID"/></xsl:attribute><xsl:call-template name="m_editcatMoveSubjectLink"/></a>........
			<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>editcategory?nodeid=<xsl:value-of select="../../@NODEID"/>&amp;action=delalias&amp;activenode=<xsl:value-of select="LINKNODEID"/></xsl:attribute>
			<xsl:attribute name="onclick">return window.confirm('Are you sure you want to delete');</xsl:attribute><xsl:call-template name="m_editcatDeleteSubjectLink"/></a>
		</xsl:if>
	</li>
</xsl:template>

</xsl:stylesheet>