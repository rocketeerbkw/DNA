<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="MANAGELINKS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MANAGELINKS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_managelinks"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MANAGELINKS_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MANAGELINKS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_managelinks"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="USERLINKS" mode="c_view">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template match="USERLINKS" mode="c_view">
		<xsl:choose>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'links'">
				<xsl:apply-templates select="." mode="links_view"/>
			</xsl:when>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'clublinks'">
				<xsl:apply-templates select="../CLUBLINKS" mode="clublinks_view"/>
			</xsl:when>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'editlinks'">
				<xsl:apply-templates select="." mode="edit_view"/>
			</xsl:when>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'editclublinks'">
				<xsl:apply-templates select="../CLUBLINKS" mode="editclub_view"/>
			</xsl:when>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'deletefolder'">
				<xsl:apply-templates select="." mode="deletefolder_view"/>
			</xsl:when>
			<xsl:when test="../PARAMS/PARAM[NAME = 's_view']/VALUE = 'changename'">
				<xsl:apply-templates select="." mode="changefoldername_view"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="folders_view"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Folders View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="LINKS" mode="c_privateuserfolders">
		<xsl:apply-templates select="." mode="r_privateuserfolders"/>
	</xsl:template>
	<xsl:template match="LINKS" mode="c_publicuserfolders">
		<xsl:apply-templates select="." mode="r_publicuserfolders"/>
	</xsl:template>
	<xsl:template match="EDITABLECLUBS" mode="c_clubfolders">
		<xsl:apply-templates select="." mode="r_clubfolders"/>
	</xsl:template>
	<xsl:template match="GROUP" mode="c_privateuserfolder">
		<xsl:if test="LINK[@PRIVATE = 1]">
			<xsl:apply-templates select="." mode="r_privateuserfolder"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="GROUP" mode="c_publicuserfolder">
		<xsl:if test="LINK[@PRIVATE = 0]">
			<xsl:apply-templates select="." mode="r_publicuserfolder"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="GROUP" mode="t_privategroupsubject">
		<a href="{$root}managelinks?linkgroup={NAME}&amp;s_view=links&amp;s_type=private" xsl:use-attribute-sets="mGROUP_t_groupsubject">
			<xsl:choose>
				<xsl:when test="NAME = ''">
					<xsl:copy-of select="$m_defaultfoldername"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NAME"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<xsl:template match="GROUP" mode="t_publicgroupsubject">
		<a href="{$root}managelinks?linkgroup={NAME}&amp;s_view=links&amp;s_type=public" xsl:use-attribute-sets="mGROUP_t_groupsubject">
			<xsl:choose>
				<xsl:when test="NAME = ''">
					<xsl:copy-of select="$m_defaultfoldername"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NAME"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<xsl:template match="GROUP" mode="t_privategroupcount">
		<xsl:value-of select="count(LINK[@PRIVATE = 1])"/>
	</xsl:template>
	<xsl:template match="GROUP" mode="t_publicgroupcount">
		<xsl:value-of select="count(LINK[@PRIVATE = 0])"/>
	</xsl:template>
	<xsl:template match="CLUB" mode="c_clubfolder">
		<xsl:apply-templates select="." mode="r_clubfolder"/>
	</xsl:template>
	<xsl:template match="NAME" mode="t_clubgroup">
		<a xsl:use-attribute-sets="mNAME_t_clubgroup">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>managelinks?clubid=<xsl:value-of select="../@CLUBID"/>&amp;clubgroup=&amp;s_view=clublinks</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="t_clubgroupcount">
		<xsl:value-of select="/H2G2/CLUBLINKGROUPS/CLUB[@CLUBID = current()/@CLUBID]/GROUP/@COUNT"/>
		<xsl:if test="not(/H2G2/CLUBLINKGROUPS/CLUB[@CLUBID = current()/@CLUBID])">0</xsl:if>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Folders View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++Links View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="USERLINKS" mode="t_back">
		<a href="{$root}managelinks?s_view=folders">
			<xsl:copy-of select="$m_backtofolders"/>
		</a>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_currentgroup">
		<xsl:for-each select="GROUP">
			<xsl:if test="@CURRENT = 1">
				<xsl:choose>
					<xsl:when test="NAME=''">
						<xsl:copy-of select="$m_defaultfoldername"/>
						(<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE"/>)
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="NAME"/>
						(<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE"/>)
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="GROUP" mode="c_linksview">
		<xsl:if test="@CURRENT = 1">
			<xsl:apply-templates select="." mode="r_linksview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="LINK" mode="c_linksview">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'private'">
				<xsl:if test="@PRIVATE = 1">
					<xsl:apply-templates select="." mode="r_linksview"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'public'">
				<xsl:if test="@PRIVATE = 0">
					<xsl:apply-templates select="." mode="r_linksview"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="LINK" mode="t_subject">
		<xsl:variable name="href">
			<xsl:choose>
				<xsl:when test="@TYPE='club'">
					<xsl:value-of select="@DNAID"/>
				</xsl:when>
				<xsl:when test="@TYPE='category'">
					<xsl:value-of select="@DNAID"/>
				</xsl:when>
				<xsl:when test="@TYPE='userpage'">
					<xsl:value-of select="@BIO"/>
				</xsl:when>
				<xsl:when test="@TYPE='article'">
					<xsl:value-of select="@DNAID"/>
				</xsl:when>
				<xsl:when test="@TYPE='reviewforum'">
					<xsl:value-of select="@DNAID"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<a href="{$root}{$href}" xsl:use-attribute-sets="mLINK_t_subject">
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<xsl:template match="LINK" mode="t_clippingtype">
		<xsl:choose>
			<xsl:when test="@TYPE='club'">club</xsl:when>
			<xsl:when test="@TYPE='category'">category</xsl:when>
			<xsl:when test="@TYPE='userpage'">userpage</xsl:when>
			<xsl:when test="@TYPE='article'">article</xsl:when>
			<xsl:when test="@TYPE='reviewforum'">review forum</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="LINK" mode="t_editlink">
		<a href="{$root}managelinks?linkgroup={../NAME}&amp;s_linkid={@LINKID}&amp;s_view=editlinks&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_editlink">
			<xsl:copy-of select="$m_editlink"/>
		</a>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_changefoldername">
		<a href="{$root}managelinks?linkgroup={GROUP[@CURRENT = 1]/NAME}&amp;s_view=changename&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_changefoldername">
			<xsl:copy-of select="$m_changefoldername"/>
		</a>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_deletefolder">
		<a href="{$root}managelinks?linkgroup={GROUP[@CURRENT = 1]/NAME}&amp;s_view=deletefolder&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_deletefolder">
			<xsl:copy-of select="$m_deletefolder"/>
		</a>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_editfolder">
		<a href="{$root}managelinks?linkgroup={GROUP[@CURRENT = 1]/NAME}&amp;s_view=editlinks&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_editfolder">
			<xsl:copy-of select="$m_editfolder"/>
		</a>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Links View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++ClubLinks View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="CLUBLINKS" mode="t_back">
		<a href="{$root}managelinks?s_view=folders">
			<xsl:copy-of select="$m_backtofolders"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUBLINKS" mode="t_currentclub">
		<xsl:value-of select="CLUBNAME"/>
	</xsl:template>
	<xsl:template match="GROUP" mode="c_clublinksview">
		<xsl:if test="@CURRENT = 1">
			<xsl:apply-templates select="." mode="r_clublinksview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="LINK" mode="c_clublinksview">
		<xsl:apply-templates select="." mode="r_clublinksview"/>
	</xsl:template>
	<xsl:template match="CLUBLINKS" mode="c_editclubfolder">
		<xsl:if test="GROUP">
			<xsl:apply-templates select="." mode="r_editclubfolder"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBLINKS" mode="r_editclubfolder">
		<a xsl:use-attribute-sets="mLINKS_t_editfolder">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>managelinks?clubid=<xsl:value-of select="@CLUBID"/>&amp;clubgroup=&amp;s_view=editclublinks</xsl:attribute>
			<xsl:copy-of select="$m_editfolder"/>
		</a>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Links View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++Edit Link View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="GROUP" mode="c_editview">
		<xsl:if test="@CURRENT = 1">
			<xsl:apply-templates select="." mode="r_editview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="LINK" mode="c_editview">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_linkid']">
				<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_linkid']/VALUE = @LINKID">
					<xsl:apply-templates select="." mode="r_editview"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'private'">
						<xsl:if test="@PRIVATE = 1">
							<xsl:apply-templates select="." mode="r_editview"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'public'">
						<xsl:if test="@PRIVATE = 0">
							<xsl:apply-templates select="." mode="r_editview"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_finishediting">
		<a href="{$root}managelinks?linkgroup={GROUP[@CURRENT = 1]/NAME}&amp;s_view=links&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_finishediting">
			<xsl:copy-of select="$m_finishediting"/>
		</a>
	</xsl:template>
	<xsl:template match="LINK" mode="t_deletesubmit">
		<form action="{$root}ManageLinks" xsl:xsl:use-attribute-sets="mLINK_t_deletesubmit">
			<input type="hidden" name="linkid" value="{@LINKID}"/>
			<input type="hidden" name="linkgroup" value="{../NAME}"/>
			<input name="deletelinks" xsl:use-attribute-sets="iLINK_t_deletesubmit"/>
			<input type="hidden" name="s_view" value="links"/>
			<input type="hidden" name="s_type" value="{/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}"/>
		</form>
	</xsl:template>
	<xsl:attribute-set name="fLINK_t_deletesubmit"/>
	<xsl:attribute-set name="iLINK_t_deletesubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Delete</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="LINK" mode="c_changepublicfolder">
		<form action="{$root}ManageLinks" xsl:xsl:use-attribute-sets="mLINK_c_changepublicfolder">
			<input type="hidden" name="linkid" value="{@LINKID}"/>
			<input type="hidden" name="linkgroup" value="{../NAME}"/>
			<xsl:apply-templates select="." mode="r_changepublicfolder"/>
			<input type="hidden" name="s_view" value="links"/>
			<input type="hidden" name="s_type" value="{/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}"/>
		</form>
	</xsl:template>
	<xsl:template match="LINK" mode="t_publicfolderlist">
		<select name="newgroup" xsl:use-attribute-sets="sLINK_t_publicfolderlist">
			<option xsl:use-attribute-sets="oLINK_t_publicfolderlist">Select Folder</option>
			<xsl:for-each select="../../GROUP">
				<xsl:if test="LINK[@PRIVATE = 0]">
					<option xsl:use-attribute-sets="oLINK_t_publicfolderlist">
						<xsl:attribute name="value"><xsl:choose><xsl:when test="NAME = ''"><xsl:copy-of select="$m_defaultfoldername"/></xsl:when><xsl:otherwise><xsl:value-of select="NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:choose>
							<xsl:when test="NAME = ''">
								<xsl:copy-of select="$m_defaultfoldername"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="NAME"/>
							</xsl:otherwise>
						</xsl:choose>
					</option>
				</xsl:if>
			</xsl:for-each>
			<option xsl:use-attribute-sets="oLINK_t_publicfolderlist">++++++++++</option>
			<option value="New Folder" xsl:use-attribute-sets="oLINK_t_publicfolderlist">New Folder</option>
		</select>
	</xsl:template>
	<xsl:template match="LINK" mode="t_publicsubmit">
		<input name="movelinks" xsl:use-attribute-sets="iLINK_t_publicsubmit"/>
		<input type="hidden" name="changepublic" value="1"/>
		<input type="hidden" name="privlinkid" value="{@LINKID}"/>
		<input type="hidden" name="curprivacy" value="{@PRIVATE}"/>
	</xsl:template>
	<xsl:template match="LINK" mode="c_changeprivatefolder">
		<form action="{$root}ManageLinks" xsl:xsl:use-attribute-sets="mLINK_c_changeprivatefolder">
			<input type="hidden" name="linkid" value="{@LINKID}"/>
			<input type="hidden" name="linkgroup" value="{../NAME}"/>
			<xsl:apply-templates select="." mode="r_changeprivatefolder"/>
			<input type="hidden" name="s_view" value="links"/>
			<input type="hidden" name="s_type" value="{/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}"/>
		</form>
	</xsl:template>
	<xsl:template match="LINK" mode="t_privatefolderlist">
		<select name="newgroup" xsl:use-attribute-sets="sLINK_t_privatefolderlist">
			<option xsl:use-attribute-sets="oLINK_t_privatefolderlist">Select Folder</option>
			<xsl:for-each select="../../GROUP">
				<xsl:if test="LINK[@PRIVATE = 1]">
					<option xsl:use-attribute-sets="oLINK_t_privatefolderlist">
						<xsl:attribute name="value"><xsl:choose><xsl:when test="NAME = ''"><xsl:copy-of select="$m_defaultfoldername"/></xsl:when><xsl:otherwise><xsl:value-of select="NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:choose>
							<xsl:when test="NAME = ''">
								<xsl:copy-of select="$m_defaultfoldername"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="NAME"/>
							</xsl:otherwise>
						</xsl:choose>
					</option>
				</xsl:if>
			</xsl:for-each>
			<option xsl:use-attribute-sets="oLINK_t_privatefolderlist">++++++++++</option>
			<option value="New Folder" xsl:use-attribute-sets="oLINK_t_privatefolderlist">New Folder</option>
		</select>
	</xsl:template>
	<xsl:template match="LINK" mode="t_privatesubmit">
		<input name="movelinks" xsl:use-attribute-sets="iLINK_t_privatesubmit"/>
		<input type="hidden" name="changepublic" value="1"/>
		<input type="hidden" name="newprivlinkid" value="{@LINKID}"/>
		<input type="hidden" name="curprivacy" value="{@PRIVATE}"/>
		<input type="hidden" name="privlinkid" value="{@LINKID}"/>
	</xsl:template>
	<xsl:template match="LINK" mode="c_changeclubfolder">
		<form action="{$root}ManageLinks" xsl:xsl:use-attribute-sets="mLINK_c_changeclubfolder">
			<input type="hidden" name="linkid" value="{@LINKID}"/>
			<input type="hidden" name="linkgroup" value="{../NAME}"/>
			<xsl:apply-templates select="." mode="r_changeclubfolder"/>
			<input type="hidden" name="s_view" value="links"/>
			<input type="hidden" name="s_type" value="{/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}"/>
		</form>
	</xsl:template>
	<xsl:template match="LINK" mode="t_clubfolderlist">
		<select name="clubid" xsl:use-attribute-sets="sLINK_t_clubfolderlist">
			<option xsl:use-attribute-sets="oLINK_t_clubfolderlist">Select Folder</option>
			<xsl:for-each select="/H2G2/EDITABLECLUBS/CLUB">
				<option xsl:use-attribute-sets="oLINK_t_clubfolderlist">
					<xsl:attribute name="value"><xsl:value-of select="@CLUBID"/></xsl:attribute>
					<xsl:value-of select="NAME"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
	<xsl:template match="LINK" mode="t_clubsubmit">
		<input name="copyselectedtoclub" xsl:use-attribute-sets="iLINK_t_clubsubmit"/>
		<input type="hidden" name="changepublic" value="1"/>
		<input type="hidden" name="newprivlinkid" value="{@LINKID}"/>
		<input type="hidden" name="curprivacy" value="{@PRIVATE}"/>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Edit Folder View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++Edit Club Folder View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="GROUP" mode="c_clubeditview">
		<xsl:if test="@CURRENT = 1">
			<xsl:apply-templates select="." mode="r_clubeditview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="LINK" mode="c_clubeditview">
		<xsl:apply-templates select="." mode="r_clubeditview"/>
	</xsl:template>
	<xsl:template match="CLUBLINKS" mode="t_finishediting">
		<a xsl:use-attribute-sets="mLINKS_t_finishediting">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>managelinks?clubid=<xsl:value-of select="@CLUBID"/>&amp;clubgroup=&amp;s_view=clublinks</xsl:attribute>
			<xsl:copy-of select="$m_finishediting"/>
		</a>
	</xsl:template>
	<xsl:template match="LINK" mode="t_clubdeletesubmit">
		<form action="{$root}ManageLinks" xsl:xsl:use-attribute-sets="mLINK_t_clubdeletesubmit">
			<input type="hidden" name="linkid" value="{@LINKID}"/>
			<input type="hidden" name="clubid" value="{../../@CLUBID}"/>
			<input type="hidden" name="clubgroup" value=""/>
			<input name="deletelinks" xsl:use-attribute-sets="iLINK_t_clubdeletesubmit"/>
			<input type="hidden" name="s_view" value="editclublinks"/>
		</form>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Edit Club Folder View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++Delete Folder View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="LINKS" mode="t_delete">
		<a xsl:use-attribute-sets="mLINKS_t_delete">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>managelinks?
				<xsl:for-each select="GROUP"><xsl:if test="@CURRENT = 1"><xsl:for-each select="LINK"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'private'"><xsl:if test="@PRIVATE = 1">
										&amp;linkid=<xsl:value-of select="@LINKID"/></xsl:if></xsl:when><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'public'"><xsl:if test="@PRIVATE = 0">
										&amp;linkid=<xsl:value-of select="@LINKID"/></xsl:if></xsl:when></xsl:choose></xsl:for-each></xsl:if></xsl:for-each>				
				&amp;deletelinks=delete
			</xsl:attribute>
			<xsl:copy-of select="$m_agree"/>
		</a>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_cancel">
		<a href="{$root}managelinks?linkgroup={GROUP[@CURRENT = 1]/NAME}&amp;s_view=editlinks&amp;s_type={/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE}" xsl:use-attribute-sets="mLINKS_t_cancel">
			<xsl:copy-of select="$m_cancel"/>
		</a>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Delete Folder View+++++++++++++++++++++++++++++++++-->
	<!--++++++++++++++++++++++++++++++Change Folder Name View+++++++++++++++++++++++++++++++++-->
	<xsl:template match="LINKS" mode="c_changename">
		<form action="managelinks" xsl:use-attribute-sets="fLINKS_c_changename">
			<input type="hidden" name="movelinks" value="Move"/>
			<xsl:for-each select="GROUP">
				<xsl:if test="@CURRENT = 1">
					<xsl:for-each select="LINK">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'private'">
								<xsl:if test="@PRIVATE = 1">
									<input type="hidden" name="linkid">
										<xsl:attribute name="value"><xsl:value-of select="@LINKID"/></xsl:attribute>
									</input>
								</xsl:if>
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'public'">
								<xsl:if test="@PRIVATE = 0">
									<input type="hidden" name="linkid">
										<xsl:attribute name="value"><xsl:value-of select="@LINKID"/></xsl:attribute>
									</input>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates select="." mode="r_changename"/>
		</form>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_nameinput">
		<input name="newgroup" xsl:use-attribute-sets="iLINKS_t_nameinput">
			<xsl:attribute name="value"/>
		</input>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_submitname">
		<input xsl:use-attribute-sets="iLINKS_t_submitname"/>
	</xsl:template>
	<!--++++++++++++++++++++++++++++++Change Folder Name View+++++++++++++++++++++++++++++++++-->
	<xsl:attribute-set name="mLINK_t_subject" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mNAME_t_clubgroup" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_editlink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_changefoldername" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_finishediting" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_deletefolder" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_delete" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_cancel" use-attribute-sets="userpagelinks"/>
</xsl:stylesheet>
