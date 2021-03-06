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

  <xsl:template match="H2G2[@TYPE = 'COMMENTSLIST']" mode="page">

    <xsl:call-template name="objects_links_breadcrumb">
      <xsl:with-param name="pagename" >Comments-list </xsl:with-param>
    </xsl:call-template>

	<xsl:variable name="pagetype">
      <xsl:choose>
        <xsl:when test="/H2G2/COMMENTSLIST/FILTERBY = 'ContactFormPosts'">Contact</xsl:when>
        <xsl:otherwise>Comment</xsl:otherwise>
      </xsl:choose>
	</xsl:variable>
    <div class="dna-mb-intro blq-clearfix">
      <fieldset>
        <label for="s_forum">
          <b>Forum Id: </b>
          <xsl:value-of select="/H2G2/COMMENTSLIST/@FORUMID"/>
        </label>
        <br />
        <br />
        <label for="s_title">
          <b>Forum Title: </b>
          <xsl:value-of select="/H2G2/COMMENTSLIST/@FORUMTITLE"/>
        </label>
        <br />
        <br />
        <label for="s_sitename">
          <b>Site Name: </b>
          <xsl:value-of select="/H2G2/COMMENTSLIST/@SITENAME"/>
        </label>
      </fieldset>
      <p>
        List of <xsl:value-of select="$pagetype"/>s for the <xsl:value-of select="$pagetype"/> forum <b>
          <xsl:value-of select="/H2G2/COMMENTSLIST/@FORUMTITLE"/>
        </b> that belongs to the site <b>
          <xsl:value-of select="/H2G2/COMMENTSLIST/@SITENAME"/>
        </b>
      </p>
    </div>
    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <div class="dna-main dna-main-full">
        <div class="dna-box">
          <h3>
			<xsl:value-of select="$pagetype"/> list count : <xsl:value-of select="/H2G2/COMMENTSLIST/TOTALCOUNT"/>
          </h3>
          <xsl:apply-templates select="COMMENTSLIST" mode="library_pagination_commentslist" />
          <div class="dna-fl dna-main-full">
            <table class="dna-dashboard-activity dna-dashboard-comments">
              <thead>
                <tr>
                  <th class="date">Date</th>
                  <th>Post</th>
                  <th>Posted By</th>
                  <xsl:if test="not /H2G2/PARAMS/PARAM/NAME = 's_displaycontactformposts'">
                  <th>ComplaintUri</th>
                  </xsl:if>
                </tr>
              </thead>
              <tbody>
              	<xsl:choose>
	              	<xsl:when test="/H2G2/PARAMS/PARAM/NAME = 's_displaycontactformposts'">
	              		<xsl:apply-templates select="/H2G2/COMMENTSLIST/COMMENTS/COMMENT" mode="object_contacts_contact" />
	              	</xsl:when>
	              	<xsl:otherwise>
	              		<xsl:apply-templates select="/H2G2/COMMENTSLIST/COMMENTS/COMMENT" mode="object_comments_comment" />
	              	</xsl:otherwise>
              	</xsl:choose>
              </tbody>
            </table>
          </div>
          <xsl:apply-templates select="COMMENTSLIST" mode="library_pagination_commentslist" />
        </div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
