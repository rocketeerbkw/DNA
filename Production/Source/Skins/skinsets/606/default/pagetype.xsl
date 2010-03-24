<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	+++++++++++++++++++++++PAGE TYPE CHECKING++++++++++++++++++++++++
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->
	<xsl:template name="type-check">
		<xsl:param name="content"/>
		<xsl:param name="mod"/>
   
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='ADDJOURNAL'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ADDJOURNAL_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ADDJOURNAL_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ADDJOURNAL_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ADDJOURNAL_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ADDJOURNAL_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ADDTHREAD'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ADDTHREAD_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ADDTHREAD_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ADDTHREAD_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ADDTHREAD_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ADDTHREAD_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTCHECK'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ARTCHECK_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ARTCHECK_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ARTCHECK_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ARTICLE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ARTICLE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ARTICLE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ARTICLE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ARTICLE_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="ARTICLE_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLESEARCHPHRASE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="ARTICLESEARCHPHRASE_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH'">
        <xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ARTICLESEARCH_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ARTICLESEARCH_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ARTICLESEARCH_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ARTICLESEARCH_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ARTICLESEARCH_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="ARTICLESEARCH_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CATEGORY'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CATEGORY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CATEGORY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CATEGORY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CATEGORY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CATEGORY_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="CATEGORY_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CATEGORYLIST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CATEGORYLIST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CATEGORYLIST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CATEGORYLIST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CATEGORYLIST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CATEGORYLIST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CLUB'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CLUB_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CLUB_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CLUB_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CLUB_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CLUB_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="CLUB_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CLUBLIST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CLUBLIST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CLUBLIST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CLUBLIST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CLUBLIST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CLUBLIST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='COMING-UP'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="COMING-UP_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="COMING-UP_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="COMING-UP_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="COMING-UP_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='DIAGNOSE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DIAGNOSE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DIAGNOSE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="DIAGNOSE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="DIAGNOSE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="DIAGNOSE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='DISTRESSMESSAGESADMIN'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DISTRESSMESSAGESADMIN_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DISTRESSMESSAGESADMIN_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="DISTRESSMESSAGESADMIN_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="DISTRESSMESSAGESADMIN_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="DISTRESSMESSAGESADMIN_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EDITCATEGORY'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="EDITCATEGORY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="EDITCATEGORY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="EDITCATEGORY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="EDITCATEGORY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="EDITCATEGORY_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EDITREVIEW'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="EDITREVIEW_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="EDITREVIEW_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="EDITREVIEW_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="EDITREVIEW_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="EDITREVIEW_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EDIT-RECENT-POST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="EDITRECENTPOST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="EDITRECENTPOST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="EDITRECENTPOST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="EDITRECENTPOST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="EDITRECENTPOST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EMAILALERTGROUPS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="EMAILALERTGROUPS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="EMAILALERTGROUPS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="EMAILALERTGROUPS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="EMAILALERTGROUPS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="EMAILALERTGROUPS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EMAILALERTPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="EMAILALERTPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="EMAILALERTPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="EMAILALERTPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="EMAILALERTPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="EMAILALERTPAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ERROR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ERROR_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="ERROR_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ERROR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ERROR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ERROR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FAILMESSAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="FAILMESSAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="FAILMESSAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FAILMESSAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FAILMESSAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FAILMESSAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FASTCATEGORYLIST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="FASTCATEGORYLIST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="FASTCATEGORYLIST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FASTCATEGORYLIST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FASTCATEGORYLIST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FASTCATEGORYLIST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="FRONTPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="FRONTPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FRONTPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FRONTPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FRONTPAGE_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="FRONTPAGE_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$content = 'XHTML'">
						<xsl:call-template name="FRONTPAGE_XHTML"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGE-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FRONTPAGE_MAINBODY"/>
						<xsl:call-template name="FRONTPAGE_EDITOR"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FRONTPAGE-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FRONTPAGE-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGETOPICELEMENTBUILDER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="FRONTPAGETOPICELEMENTBUILDER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="FRONTPAGETOPICELEMENTBUILDER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FRONTPAGETOPICELEMENTBUILDER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FRONTPAGETOPICELEMENTBUILDER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FRONTPAGETOPICELEMENTBUILDER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGE-LAYOUT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="FRONTPAGE-LAYOUT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="FRONTPAGE-LAYOUT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="FRONTPAGE-LAYOUT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="FRONTPAGE-LAYOUT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="FRONTPAGE-LAYOUT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='GROUP-MANAGEMENT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="GROUP-MANAGEMENT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="GROUP-MANAGEMENT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="GROUP-MANAGEMENT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="GROUP-MANAGEMENT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="GROUP-MANAGEMENT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='INDEX'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="INDEX_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="INDEX_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="INDEX_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="INDEX_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="INDEX_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="INDEX_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>					
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='INFO'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="INFO_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="INFO_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="INFO_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="INFO_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="INFO_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="INFO_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='INSPECT-USER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="INSPECT-USER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="INSPECT-USER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="INSPECT-USER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="INSPECT-USER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="INSPECT-USER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='JOURNAL'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="JOURNAL_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="JOURNAL_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="JOURNAL_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="JOURNAL_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="JOURNAL_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="JOURNAL_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='KEYARTICLE-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="KEYARTICLE-EDITOR_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="KEYARTICLE-EDITOR_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="KEYARTICLE-EDITOR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="KEYARTICLE-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="KEYARTICLE-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='LOGOUT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="LOGOUT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="LOGOUT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="LOGOUT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="LOGOUT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="LOGOUT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!--xsl:when test="/H2G2/@TYPE='MANAGE-FAST-MOD'">
				<xsl:choose>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MANAGE-FAST-MOD_MAINBODY"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when-->
			<xsl:when test="/H2G2/@TYPE='MANAGELINKS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MANAGELINKS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MANAGELINKS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MANAGELINKS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MANAGELINKS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MANAGELINKS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MEDIAASSET'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MEDIAASSET_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MEDIAASSET_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MEDIAASSET_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MEDIAASSET_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MEDIAASSET_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>							
			<xsl:when test="/H2G2/@TYPE='MEDIAASSETSEARCHPHRASE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MEDIAASSETSEARCHPHRASE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MEDIAASSETSEARCHPHRASE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MEDIAASSETSEARCHPHRASE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MEDIAASSETSEARCHPHRASE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MEDIAASSETSEARCHPHRASE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>		
			<xsl:when test="/H2G2/@TYPE='MEDIAASSET-MODERATION'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MEDIAASSET-MODERATION_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MEDIAASSET-MODERATION_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MEDIAASSET-MODERATION_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MEDIAASSET-MODERATION_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MEDIAASSET-MODERATION_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>					
			<xsl:when test="/H2G2/@TYPE='MESSAGEBOARDADMIN'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MESSAGEBOARDADMIN_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MESSAGEBOARDADMIN_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MESSAGEBOARDADMIN_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MESSAGEBOARDADMIN_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MESSAGEBOARDADMIN_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MESSAGEBOARDPROMOPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MESSAGEBOARDPROMOPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MESSAGEBOARDPROMOPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MESSAGEBOARDPROMOPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MESSAGEBOARDPROMOPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MESSAGEBOARDPROMOPAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MESSAGEBOARDSCHEDULE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MESSAGEBOARDSCHEDULE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MESSAGEBOARDSCHEDULE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MESSAGEBOARDSCHEDULE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MESSAGEBOARDSCHEDULE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MESSAGEBOARDSCHEDULE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MESSAGEBOARDTRANSFER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MESSAGEBOARDTRANSFER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MESSAGEBOARDTRANSFER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MESSAGEBOARDTRANSFER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MESSAGEBOARDTRANSFER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MESSAGEBOARDTRANSFER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MOD-EMAIL-MANAGEMENT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MOD-EMAIL-MANAGEMENT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MOD-EMAIL-MANAGEMENT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MOD-EMAIL-MANAGEMENT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MOD-EMAIL-MANAGEMENT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MOD-EMAIL-MANAGEMENT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MODERATOR-MANAGEMENT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MODERATOR-MANAGEMENT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MODERATOR-MANAGEMENT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MODERATOR-MANAGEMENT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MODERATOR-MANAGEMENT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MODERATOR-MANAGEMENT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MANAGE-FAST-MOD'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MANAGE-FAST-MOD_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MANAGE-FAST-MOD_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MANAGE-FAST-MOD_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MANAGE-FAST-MOD_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MANAGE-FAST-MOD_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MONTH'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MONTHSUMMARY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MONTHSUMMARY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MONTHSUMMARY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MONTHSUMMARY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MONTHSUMMARY_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MOREPAGES'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MOREPAGES_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MOREPAGES_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MOREPAGES_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MOREPAGES_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MOREPAGES_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="MOREPAGES_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MOREPOSTS'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='pop'">
						<xsl:choose>
							<xsl:when test="$content = 'HEADER'">
								<xsl:call-template name="MYCONVERSATIONS_HEADER"/>
							</xsl:when>
							<xsl:when test="$content = 'SUBJECT'">
								<xsl:call-template name="DEFAULT_SUBJECT"/>
							</xsl:when>
							<xsl:when test="$content = 'MAINBODY'">
								<xsl:call-template name="MYCONVERSATIONS_MAINBODY"/>
							</xsl:when>
							<xsl:when test="$content = 'CSS'">
								<xsl:call-template name="MYCONVERSATIONS_CSS"/>
							</xsl:when>
							<xsl:when test="$content = 'JAVASCRIPT'">
								<xsl:call-template name="MYCONVERSATIONS_JAVASCRIPT"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$content = 'HEADER'">
								<xsl:call-template name="MOREPOSTS_HEADER"/>
							</xsl:when>
							<xsl:when test="$content = 'SUBJECT'">
								<xsl:call-template name="MOREPOSTS_SUBJECT"/>
							</xsl:when>
							<xsl:when test="$content = 'MAINBODY'">
								<xsl:call-template name="MOREPOSTS_MAINBODY"/>
							</xsl:when>
							<xsl:when test="$content = 'CSS'">
								<xsl:call-template name="MOREPOSTS_CSS"/>
							</xsl:when>
							<xsl:when test="$content = 'JAVASCRIPT'">
								<xsl:call-template name="MOREPOSTS_JAVASCRIPT"/>
							</xsl:when>
							<xsl:when test="$content = 'RSS1'">
								<xsl:call-template name="MOREPOSTS_RSS1">
									<xsl:with-param name="mod" select="$mod"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="MULTIPOSTS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="MULTIPOSTS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="MULTIPOSTS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="MULTIPOSTS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="MULTIPOSTS_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="MULTIPOSTS_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWEMAIL'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NEWEMAIL_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NEWEMAIL_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NEWEMAIL_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NEWEMAIL_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NEWEMAIL_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWREGISTER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NEWREGISTER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NEWREGISTER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NEWREGISTER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NEWREGISTER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NEWREGISTER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWUSERS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NEWUSERS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NEWUSERS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NEWUSERS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NEWUSERS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NEWUSERS_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="NEWUSERS_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NICKNAME-MODERATION'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NICKNAME-MODERATION_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NICKNAME-MODERATION_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NICKNAME-MODERATION_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NICKNAME-MODERATION_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NICKNAME-MODERATION_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NOTICEBOARD'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NOTICEBOARD_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NOTICEBOARD_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NOTICEBOARD_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NOTICEBOARD_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NOTICEBOARD_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NOTICEBOARDLIST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NOTICEBOARDLIST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NOTICEBOARDLIST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NOTICEBOARDLIST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NOTICEBOARDLIST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NOTICEBOARDLIST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NOTFOUND'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="NOTFOUND_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="NOTFOUND_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="NOTFOUND_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="NOTFOUND_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="NOTFOUND_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ONLINE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="ONLINE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="ONLINE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="ONLINE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="ONLINE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='POLL'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="POLL_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="POLL_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="POLL_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="POLL_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="POLL_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='POSTCODE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="POSTCODE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="POSTCODE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="POSTCODE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="POSTCODE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="POSTCODE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='POST-MODERATION'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="POST-MODERATION_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="POST-MODERATION_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="POST-MODERATION_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="POST-MODERATION_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="POST-MODERATION_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='PROFANITYADMIN'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="PROFANITYADMIN_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="PROFANITYADMIN_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="PROFANITYADMIN_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="PROFANITYADMIN_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="PROFANITYADMIN_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='RECOMMEND-ENTRY'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="RECOMMEND-ENTRY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="RECOMMEND-ENTRY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="RECOMMEND-ENTRY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="RECOMMEND-ENTRY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="RECOMMEND-ENTRY_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='REGISTER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="REGISTER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="REGISTER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="REGISTER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="REGISTER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="REGISTER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='REGISTER-CONFIRMATION'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="REGISTER-CONFIRMATION_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="REGISTER-CONFIRMATION_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="REGISTER-CONFIRMATION_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="REGISTER-CONFIRMATION_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="REGISTER-CONFIRMATION_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='RESERVED-ARTICLES'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="RESERVED-ARTICLES_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="RESERVED-ARTICLES_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="RESERVED-ARTICLES_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="RESERVED-ARTICLES_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="RESERVED-ARTICLES_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='REVIEWFORUM'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="REVIEWFORUM_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="REVIEWFORUM_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="REVIEWFORUM_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="REVIEWFORUM_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="REVIEWFORUM_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="REVIEWFORUM_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SCOUT-RECOMMENDATIONS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SCOUT-RECOMMENDATIONS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SCOUT-RECOMMENDATIONS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SCOUT-RECOMMENDATIONS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SCOUT-RECOMMENDATIONS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SCOUT-RECOMMENDATIONS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SEARCH'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SEARCH_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SEARCH_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SEARCH_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SEARCH_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SEARCH_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SHAREANDENJOY'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SHAREANDENJOY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SHAREANDENJOY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SHAREANDENJOY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SHAREANDENJOY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SHAREANDENJOY_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SIMPLEPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SIMPLEPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SIMPLEPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SIMPLEPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SIMPLEPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SIMPLEPAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SITEADMIN-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SITEADMIN-EDITOR_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SITEADMIN-EDITOR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SITEADMIN-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SITEADMIN-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SITECHANGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SITECHANGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SITECHANGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SITECHANGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SITECHANGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SITECONFIG-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SITECONFIG-EDITOR_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SITECONFIG-EDITOR_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SITECONFIG-EDITOR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SITECONFIG-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SITECONFIG-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SITECONFIGPREVIEW-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SITECONFIGPREVIEW-EDITOR_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SITECONFIGPREVIEW-EDITOR_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SITECONFIGPREVIEW-EDITOR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SITECONFIGPREVIEW-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SITECONFIGPREVIEW-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SITEOPTIONS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SITEOPTIONS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SITEOPTIONS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SITEOPTIONS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SITEOPTIONS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SITEOPTIONS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>			
			<xsl:when test="/H2G2/@TYPE='SUB-ALLOCATION'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SUB-ALLOCATION_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SUB-ALLOCATION_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SUB-ALLOCATION_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SUB-ALLOCATION_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SUB-ALLOCATION_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SUBBED-ARTICLE-STATUS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SUBBED-ARTICLE-STATUS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SUBBED-ARTICLE-STATUS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SUBBED-ARTICLE-STATUS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SUBBED-ARTICLE-STATUS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SUBSCRIBE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SUBSCRIBE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SUBSCRIBE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SUBSCRIBE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SUBSCRIBE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SUBSCRIBE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SUBMITREVIEWFORUM'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SUBMITREVIEWFORUM_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SUBMITREVIEWFORUM_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SUBMITREVIEWFORUM_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SUBMITREVIEWFORUM_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SUBMITREVIEWFORUM_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SYSTEMMESSAGEMAILBOX'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="SYSTEMMESSAGEMAILBOX_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="SYSTEMMESSAGEMAILBOX_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="SYSTEMMESSAGEMAILBOX_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="SYSTEMMESSAGEMAILBOX_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="SYSTEMMESSAGEMAILBOX_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TAGITEM'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="TAGITEM_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="TAGITEM_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY' and /H2G2/TAGITEM-PAGE[@MODE='EDITOR']">
						<xsl:call-template name="TAGITEM_EDITOR"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TAGITEM_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TAGITEM_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TAGITEM_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TEAMLIST'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="TEAMLIST_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="TEAMLIST_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TEAMLIST_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TEAMLIST_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TEAMLIST_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TEXTBOXELEMENTPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="TEXTBOXELEMENTPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="TEXTBOXELEMENTPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TEXTBOXELEMENTPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TEXTBOXELEMENTPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TEXTBOXELEMENTPAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='THREADSEARCHPHRASE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="THREADSEARCHPHRASE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="THREADSEARCHPHRASE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="THREADSEARCHPHRASE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="THREADSEARCHPHRASE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="THREADSEARCHPHRASE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='THREADS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="THREADS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="THREADS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="THREADS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="THREADS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="THREADS_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="THREADS_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TOPFIVE-EDITOR'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TOPFIVE-EDITOR_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TOPFIVE-EDITOR_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TOPFIVE-EDITOR_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TOPICBUILDER'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="TOPICBUILDER_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="TOPICBUILDER_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TOPICBUILDER_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TOPICBUILDER_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TOPICBUILDER_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="TYPED-ARTICLE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="TYPED-ARTICLE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="TYPED-ARTICLE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="TYPED-ARTICLE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="TYPED-ARTICLE_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'XHTML'">
						<xsl:call-template name="TYPED-ARTICLE_XHTML"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='URLFILTERADMIN'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="URLFILTERADMIN_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="URLFILTERADMIN_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="URLFILTERADMIN_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="URLFILTERADMIN_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="URLFILTERADMIN_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USER-COMPLAINT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERCOMPLAINT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERCOMPLAINT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERCOMPLAINT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERCOMPLAINT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERS-HOMEPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERS-HOMEPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERS-HOMEPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERS-HOMEPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERS-HOMEPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERS-HOMEPAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERDETAILS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERDETAILS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERDETAILS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERDETAILS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERDETAILS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERDETAILS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USER-DETAILS-PAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USER-DETAILS-PAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USER-DETAILS-PAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USER-DETAILS-PAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USER-DETAILS-PAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USER-DETAILS-PAGE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USEREDIT'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USEREDIT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USEREDIT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USEREDIT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USEREDIT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USEREDIT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERMYCLUBS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERMYCLUBS_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERMYCLUBS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERMYCLUBS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERMYCLUBS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERMYCLUBS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERPAGE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERPAGE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERPAGE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERPAGE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERPAGE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERPAGE_JAVASCRIPT"/>
					</xsl:when>
					<xsl:when test="$content = 'RSS1'">
						<xsl:call-template name="USERPAGE_RSS1">
							<xsl:with-param name="mod" select="$mod"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERPRIVACY'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="USERPRIVACY_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERPRIVACY_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERPRIVACY_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERPRIVACY_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERPRIVACY_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERSTATISTICS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="USERSTATISTICS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="USERSTATISTICS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="USERSTATISTICS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="USERSTATISTICS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='VOTE'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="VOTE_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="VOTE_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="VOTE_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="VOTE_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="VOTE_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='WATCHED-USERS'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="WATCHED-USERS_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="WATCHED-USERS_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="WATCHED-USERS_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="WATCHED-USERS_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CONTENTSIGNIFADMIN'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CONTENTSIGNIFADMIN_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CONTENTSIGNIFADMIN_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CONTENTSIGNIFADMIN_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CONTENTSIGNIFADMIN_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CONTENTSIGNIFADMIN_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CONTENTSIGNIF'">
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="CONTENTSIGNIF_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="CONTENTSIGNIF_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="CONTENTSIGNIF_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="CONTENTSIGNIF_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="CONTENTSIGNIF_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
      <xsl:when test="/H2G2/@TYPE='MODERATION-HISTORY'">
        <xsl:choose>
          <xsl:when test="$content = 'HEADER'">
            <xsl:call-template name="MODERATIONHISTORY_HEADER"/>
          </xsl:when>
          <xsl:when test="$content = 'SUBJECT'">
            <xsl:call-template name="MODERATIONHISTORY_SUBJECT"/>
          </xsl:when>
          <xsl:when test="$content = 'MAINBODY'">
            <xsl:call-template name="MODERATIONHISTORY_MAINBODY"/>
          </xsl:when>
          <xsl:when test="$content = 'CSS'">
            <xsl:call-template name="MODERATIONHISTORY_CSS"/>
          </xsl:when>
          <xsl:when test="$content = 'JAVASCRIPT'">
            <xsl:call-template name="MODERATIONHISTORY_JAVASCRIPT"/>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="/H2G2/@TYPE='SERVERTOOBUSY'">
        <xsl:choose>
        <xsl:when test="$content = 'MAINBODY'">
          <xsl:call-template name="SERVERTOOBUSY_MAINBODY"/>
        </xsl:when>
        </xsl:choose>
      </xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$content = 'HEADER'">
						<xsl:call-template name="DEFAULT_HEADER"/>
					</xsl:when>
					<xsl:when test="$content = 'SUBJECT'">
						<xsl:call-template name="DEFAULT_SUBJECT"/>
					</xsl:when>
					<xsl:when test="$content = 'MAINBODY'">
						<xsl:call-template name="DEFAULT_MAINBODY"/>
					</xsl:when>
					<xsl:when test="$content = 'CSS'">
						<xsl:call-template name="DEFAULT_CSS"/>
					</xsl:when>
					<xsl:when test="$content = 'JAVASCRIPT'">
						<xsl:call-template name="DEFAULT_JAVASCRIPT"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  <xsl:template name="FRONTPAGE_XHTML"/>
  <xsl:template name="TYPED-ARTICLE_XHTML"/>
  <xsl:template name="MOREPAGES_RSS1"/>
</xsl:stylesheet>
