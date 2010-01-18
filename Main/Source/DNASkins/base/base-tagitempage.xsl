<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="tagitempagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="mNODE_t_taggednodename" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mNODE_t_removetag" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mNODE_t_movetag" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mTAGITEM-PAGE_r_addtonode" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mITEM-PAGE_t_backtoobject" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mANCESTOR_r_tagitem" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mACTION_t_objectadded" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mACTION_t_nodeaddedto" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mACTION_t_nodefrom" use-attribute-sets="tagitempagelinks"/>
	<xsl:attribute-set name="mACTION_t_nodeto" use-attribute-sets="tagitempagelinks"/>
	<xsl:variable name="m_tagitembacktoarticle">Back to article page</xsl:variable>
	<xsl:variable name="m_tagitembacktoclub">Back to club page</xsl:variable>
	<xsl:variable name="m_tagitembacktouserpage">Back to userpage</xsl:variable>
	<xsl:variable name="m_addarticletonode">Add this article to a node in the taxonomy</xsl:variable>
	<xsl:variable name="m_addclubtonode">Add this club to a node in the taxonomy</xsl:variable>
	<xsl:variable name="m_adduserpagetonode">Add this userpage to a node in the taxonomy</xsl:variable>
	<xsl:variable name="m_movetaggedarticle">Move</xsl:variable>
	<xsl:variable name="m_movetaggedclub">Move</xsl:variable>
	<xsl:variable name="m_removetaggednode">Remove</xsl:variable>
	<xsl:variable name="m_articlenotyettagged">This article has not been tagged to the taxonomy yet</xsl:variable>
	<xsl:variable name="m_clubnotyettagged">This club has not been tagged to the taxonomy yet</xsl:variable>
	<xsl:variable name="m_userpagenotyettagged">This userpage has not been tagged to the taxonomy yet</xsl:variable>
	<!--
	<xsl:template name="TAGITEM_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TAGITEM_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_h2g2journaltitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="TAGITEM_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TAGITEM_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">Categorise article</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="TAGGEDNODES" mode="c_tagitem">
		<xsl:choose>
			<xsl:when test="NODE">
				<xsl:apply-templates select="." mode="full_tagitem"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_tagitem"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="TAGGEDNODES" mode="empty_tagitem">
		<xsl:choose>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
				<xsl:copy-of select="$m_articlenotyettagged"/>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
				<xsl:copy-of select="$m_clubnotyettagged"/>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
				<xsl:copy-of select="$m_userpagenotyettagged"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="NODE" mode="c_tagitem">
		<xsl:apply-templates select="." mode="r_tagitem"/>
	</xsl:template>
	<xsl:template match="NODE" mode="t_taggednodename">
		<a href="{$root}C{@ID}" xsl:use-attribute-sets="mNODE_t_taggednodename">
			<xsl:value-of select="@NAME"/>
		</a>
	</xsl:template>
	<xsl:template match="NODE" mode="t_removetag">
		<a href="{$root}TagItem?action=remove&amp;tagitemtype={/H2G2/TAGITEM-PAGE/ITEM/@TYPE}&amp;tagitemid={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;tagorigin={@ID}" xsl:use-attribute-sets="mNODE_t_removetag">
			<xsl:copy-of select="$m_removetaggednode"/>
		</a>
	</xsl:template>
	<xsl:template match="NODE" mode="t_movetag">
		<xsl:choose>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
				<a href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;tagmode=2&amp;nodeid={@ID}&amp;delnode={@ID}" xsl:use-attribute-sets="mNODE_t_movetag">
					<xsl:copy-of select="$m_movetaggedarticle"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
				<a href="{$root}editcategory?action=navigateclub&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;tagmode=2&amp;nodeid={@ID}&amp;delnode={@ID}" xsl:use-attribute-sets="mNODE_t_movetag">
					<xsl:copy-of select="$m_movetaggedclub"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
				move tagged user page
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- These can be used when startnode is part of the XML!! -->
	<!--xsl:template match="ITEMLIMIT" mode="c_addtonode">
		<xsl:param name="startnode"/>
		<xsl:if test="(@COUNT &lt; @LIMIT) and ($registered=1)">
			<xsl:apply-templates select="." mode="r_addtonode">
				<xsl:with-param name="startnode" select="$startnode"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template-->
	<!--xsl:template match="ITEMLIMIT" mode="r_addtonode">
		<xsl:param name="startnode"/>
		<xsl:choose>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
				<a href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
					<xsl:copy-of select="$m_addarticletonode"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
				<a href="{$root}editcategory?action=navigateclub&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
					<xsl:copy-of select="$m_addclubtonode"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
				<a href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
					<xsl:copy-of select="$m_adduserpagetonode"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template-->
	<xsl:template name="ok_addtonode"></xsl:template>
	<xsl:template name="signedout_addtonode"></xsl:template>
	<xsl:template name="full_addtonode"></xsl:template>
	<xsl:template name="c_addtonode">
		<xsl:param name="startnode">1</xsl:param>
		<xsl:param name="nodetype">1</xsl:param>
		<xsl:choose>
			<xsl:when test="(/H2G2/TAGITEM-PAGE/TAGGEDNODES/TAGLIMITS/ITEMLIMIT[@NODETYPE=$nodetype][@COUNT &lt; @LIMIT]) or not(/H2G2/TAGITEM-PAGE/TAGLIMITS)">
				<xsl:choose>
					<xsl:when test="$registered = 1">
						<xsl:call-template name="ok_addtonode">
							<xsl:with-param name="addnodelink">
								<xsl:choose>
									<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
										<a href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
											<xsl:copy-of select="$m_addarticletonode"/>
										</a>
									</xsl:when>
									<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
										<a href="{$root}editcategory?action=navigateclub&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
											<xsl:copy-of select="$m_addclubtonode"/>
										</a>
									</xsl:when>
									<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
										<a href="{$root}editcategory?action=navigatearticle&amp;activenode={/H2G2/TAGITEM-PAGE/ITEM/@ID}&amp;nodeid={$startnode}&amp;tagmode=1" xsl:use-attribute-sets="mTAGITEM-PAGE_r_addtonode">
											<xsl:copy-of select="$m_adduserpagetonode"/>
										</a>
									</xsl:when>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="nodetype" select="$nodetype"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="signedout_addtonode">
							<xsl:with-param name="nodetype" select="$nodetype"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="full_addtonode">
					<xsl:with-param name="nodetype" select="$nodetype"/>
				</xsl:call-template>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="r_addtonode"/>
	<xsl:template match="ITEM" mode="t_backtoobject">
		<xsl:choose>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
				<a href="{$root}A{@ID}" xsl:use-attribute-sets="mITEM-PAGE_t_backtoobject">
					<xsl:copy-of select="$m_tagitembacktoarticle"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
				<a href="{$root}G{@ID}" xsl:use-attribute-sets="mITEM-PAGE_t_backtoobject">
					<xsl:copy-of select="$m_tagitembacktoclub"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
				<a href="{$root}A{@ID}" xsl:use-attribute-sets="mITEM-PAGE_t_backtoobject">
					<xsl:copy-of select="$m_tagitembacktouserpage"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ANCESTRY" mode="c_tagitem">
		<xsl:apply-templates select="." mode="r_tagitem"/>
	</xsl:template>
	<xsl:template match="ANCESTOR" mode="c_tagitem">
		<xsl:apply-templates select="." mode="r_tagitem"/>
	</xsl:template>
	<xsl:template match="ANCESTOR" mode="r_tagitem">
		<a href="{$root}C{NODEID}" xsl:use-attribute-sets="mANCESTOR_r_tagitem">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<xsl:template match="ERROR" mode="c_tagitem">
		<xsl:apply-templates select="." mode="r_tagitem"/>
	</xsl:template>
	<xsl:template match="ERROR" mode="r_tagitem">
		<xsl:choose>
			<xsl:when test=". = 'NoTypeIDGiven'">Article type not recognised</xsl:when>
			<xsl:when test=". = 'NoItemIDGiven'">Article ID not recognised</xsl:when>
			<xsl:when test=". = 'UserNotAuthorised'">You are not authorised to do this</xsl:when>
			<xsl:when test=". = 'FailedToGetAction'">Failed to get action</xsl:when>
			<xsl:when test=". = 'InvalidActionGiven'">Invalid action given</xsl:when>
			<xsl:when test=". = 'FailedToFindNodes'">Failed to find nodes</xsl:when>
			<xsl:when test=". = 'TypeIDItemIDIncorrect'">Type ID Item ID Incorrect</xsl:when>
			<xsl:when test=". = 'FailedCheckingUser'">Failed to check user</xsl:when>
			<xsl:when test=". = 'InvalidNodeIDToAdd'">Invalid node ID to add</xsl:when>
			<xsl:when test=". = 'FailedGettingParentInfo'">failed getting parent info</xsl:when>
			<xsl:when test=". = 'ItemAlreadyExists'">This item has already been classified here</xsl:when>
			<xsl:when test=". = 'FailedToAddNode'">Failed to add node</xsl:when>
			<xsl:when test=". = 'UnknownTypeID'">Unknown article type</xsl:when>
			<xsl:when test=". = 'FailedToGetNodeDetails'">Failed to get node details</xsl:when>
			<xsl:when test=". = 'InvalidNodeIDToRemove'">Invalid nodeid to remove</xsl:when>
			<xsl:when test=". = 'ItemDoesNotExist'">Item does not exist</xsl:when>
			<xsl:when test=". = 'FailedToRemoveNode'">Failed to remove node</xsl:when>
			<xsl:when test=". = 'InvalidNodeIDToMoveFrom'">Invalid node id to remove from</xsl:when>
			<xsl:when test=". = 'InvalidNodeIDToMoveTo'">Invalid node id to remove to</xsl:when>
			<xsl:when test=". = 'UserNotAllowedToAdd'">You are not allowed to add</xsl:when>
			<xsl:when test=". = 'ItemDoesNotExistToMove'">Item does not exist to move</xsl:when>
			<xsl:when test=". = 'ItemAlreadyExistsInDestination'">Item already exists</xsl:when>
			<xsl:when test=". = 'FailedToMoveItem'">Failed to move item</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ACTION" mode="c_actionresult">
		<xsl:choose>
			<xsl:when test="@RESULT='AddSucceeded'">
				<xsl:apply-templates select="." mode="added_actionresult"/>
			</xsl:when>
			<xsl:when test="@RESULT='AddFailed' and @REASON='ItemAlreadyExists'">
				<xsl:apply-templates select="." mode="notadded_actionresult"/>
			</xsl:when>
			<xsl:when test="@RESULT='AddFailed' and @REASON='TaggingLimitReached'">
				<xsl:apply-templates select="." mode="notadded_limitreached"/>
			</xsl:when>
			<xsl:when test="@RESULT='RemoveSucceeded'">
				<xsl:apply-templates select="." mode="removed_actionresult"/>
			</xsl:when>
			<xsl:when test="@RESULT='RemoveFailed'">
				<xsl:apply-templates select="." mode="notremoved_actionresult"/>
			</xsl:when>
			<xsl:when test="@RESULT='MoveFailed'">
				<xsl:apply-templates select="." mode="notmoved_actionresult"/>
			</xsl:when>
			<xsl:when test="@RESULT='MoveSucceeded'">
				<xsl:apply-templates select="." mode="moved_actionresult"/>
			</xsl:when>
		</xsl:choose>
		<!--xsl:apply-templates select="." mode="r_actionresult"/-->
	</xsl:template>
	<xsl:template match="ACTION" mode="t_activeobject">
		<xsl:choose>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE &lt; 1000">
				<a href="{$root}A{../ITEM/@ID}" xsl:use-attribute-sets="mACTION_t_objectadded">
					<xsl:value-of select="../ITEM/@SUBJECT"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=1001">
				<a href="{$root}G{../ITEM/@ID}" xsl:use-attribute-sets="mACTION_t_objectadded">
					<xsl:value-of select="../ITEM/@SUBJECT"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/TAGITEM-PAGE/ITEM/@TYPE=3001">
				<a href="{$root}A{../ITEM/@ID}" xsl:use-attribute-sets="mACTION_t_objectadded">
					<xsl:value-of select="../ITEM/@SUBJECT"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ACTION" mode="t_activenode">
		<a href="{$root}C{@NODE}" xsl:use-attribute-sets="mACTION_t_nodeaddedto">
			<xsl:value-of select="@NODENAME"/>
		</a>
	</xsl:template>
	<xsl:template match="ACTION" mode="t_nodefrom">
		<a href="{$root}C{@FROMID}" xsl:use-attribute-sets="mACTION_t_nodefrom">
			<xsl:value-of select="/H2G2/TAGITEM-PAGE/TAGGEDNODES/NODE[@ID=current()/@NODETO]/@NAME"/>
		</a>
	</xsl:template>
	<xsl:template match="ACTION" mode="t_nodeto">
		<a href="{$root}C{@NODETO}" xsl:use-attribute-sets="mACTION_t_nodeto">
			<xsl:value-of select="/H2G2/TAGITEM-PAGE/TAGGEDNODES/NODE[@ID=current()/@FROMID]/@NAME"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
