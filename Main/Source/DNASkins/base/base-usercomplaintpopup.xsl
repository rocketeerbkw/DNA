<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <!--
	<xsl:template name="USERCOMPLAINT_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
  <xsl:template name="USERCOMPLAINT_HEADER">
    <xsl:apply-templates mode="header" select=".">
      <xsl:with-param name="title">
        <xsl:value-of select="$m_usercomplaintpopuptitle"/>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="c_complaint">
    <xsl:choose>
      <xsl:when test="ERROR">
        <xsl:apply-templates select="." mode="error_complaint"/>
      </xsl:when>
      <xsl:when test="MESSAGE/@TYPE='SUBMIT-SUCCESSFUL'">
        <xsl:apply-templates select="." mode="success_complaint"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="form_complaint"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_introduction">
    <xsl:call-template name="m_complaintpopupseriousnessproviso"/>
    <!-- then insert any messages requested within the form XML -->
    <xsl:choose>
      <xsl:when test="MESSAGE/@TYPE='ALREADY-HIDDEN'">
        <xsl:value-of select="$m_contentalreadyhiddenmessage"/>
      </xsl:when>
      <xsl:when test="MESSAGE/@TYPE='DELETED'">
        <xsl:value-of select="$m_contentcancelledmessage"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- otherwise insert some appropriate preamble -->
        <xsl:choose>
          <xsl:when test="@TYPE='ARTICLE'">
            <xsl:copy-of select="$m_articlecomplaintdescription"/>
          </xsl:when>
          <xsl:when test="@TYPE='POST'">
            <xsl:copy-of select="$m_postingcomplaintdescription"/>
          </xsl:when>
          <xsl:when test="@TYPE='GENERAL'">
            <xsl:copy-of select="$m_generalcomplaintdescription"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$m_generalcomplaintdescription"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="c_form">
    <form method="post" action="{$root}UserComplaint" name="UserComplaintForm" id="UserComplaintForm" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_c_form">
      <input type="hidden" name="Type">
        <xsl:attribute name="value">
          <xsl:value-of select="@TYPE"/>
        </xsl:attribute>
      </input>
      <xsl:if test="POST-ID">
        <input type="hidden" name="PostID">
          <xsl:attribute name="value">
            <xsl:value-of select="POST-ID"/>
          </xsl:attribute>
        </input>
      </xsl:if>
      <xsl:if test="H2G2-ID">
        <input type="hidden" name="h2g2ID">
          <xsl:attribute name="value">
            <xsl:value-of select="H2G2-ID"/>
          </xsl:attribute>
        </input>
      </xsl:if>
      <xsl:if test="URL">
        <input type="hidden" name="URL">
          <xsl:attribute name="value">
            <xsl:value-of select="URL"/>
          </xsl:attribute>
        </input>
      </xsl:if>
      <xsl:apply-templates select="." mode="r_form"/>
    </form>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="c_hidepost">
    <xsl:if test="@TYPE='POST' and $test_IsEditor=1">
      <xsl:apply-templates select="." mode="r_hidepost"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_hidepostcheck">
    <input type="checkbox" name="HidePost" value="1" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_hidepostcheck"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_textarea">
    <textarea name="ComplaintText" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_textarea">
      <xsl:value-of select="$m_defaultcomplainttext"/>
    </textarea>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_email">
    <input name="EmailAddress" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_email"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_submit">
    <input xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_submit"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_next">
    <input xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_next" src="{$imagesource}next_button.gif"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_cancel">
    <input xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_cancel"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_close">
      <image xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_close"/>
  </xsl:template>
  <xsl:template match="USER-COMPLAINT-FORM" mode="error_complaint">
    <p>
      <xsl:choose>
        <xsl:when test="ERROR/@TYPE = 'EMAILNOTALLOWED'">
          <p>
            You have been restricted from using the online complaints system. If you wish to report a defamatory or illegal post or other serious breach of the BBC Editorial Guidelines, please write to:
          </p>
          <p>
            <b>
              Central Communities Team<br/>
              Broadcast Centre<br/>
              201 Wood Lane<br/>
              London<br/>
              W12 7TP<br/>
            </b>
          </p>
          <p>
            Please make a note of the <xsl:choose>
              <xsl:when test="@TYPE ='ARTICLE'">
                article number <b>
                  <xsl:value-of select="H2G2-ID"/>
                </b>
              </xsl:when>
              <xsl:when test="@TYPE='POST'">
                post number <b>
                  <xsl:value-of select="POST-ID"/>
                </b>
              </xsl:when>
              <xsl:when test="@TYPE='GENERAL'">
                URL <b>
                  <xsl:value-of select="URL"/>
                </b>
              </xsl:when>
              <xsl:otherwise>
                item
              </xsl:otherwise>
            </xsl:choose> and include it in your complaint. If you would like a response, please ensure that you include your full name, address and post code.
          </p>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="ERROR"/>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_c_form">
    <xsl:attribute name="onSubmit">return checkUserComplaintForm()</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_hidepostcheck"/>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_textarea">
    <xsl:attribute name="wrap">virtual</xsl:attribute>
    <xsl:attribute name="id">ComplaintText</xsl:attribute>
    <xsl:attribute name="cols">70</xsl:attribute>
    <xsl:attribute name="rows">15</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
    <xsl:attribute name="type">text</xsl:attribute>
    <xsl:attribute name="size">20</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
    <xsl:attribute name="type">submit</xsl:attribute>
    <xsl:attribute name="name">Submit</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformsubmitbuttonlabel"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_next">
    <xsl:attribute name="type">submit</xsl:attribute>
    <xsl:attribute name="name">Submit</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformnextbuttonlabel"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
    <xsl:attribute name="type">button</xsl:attribute>
    <xsl:attribute name="name">Cancel</xsl:attribute>
    <xsl:attribute name="onClick">window.close()</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformcancelbuttonlabel"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
    <xsl:attribute name="type">button</xsl:attribute>
    <xsl:attribute name="name">Close</xsl:attribute>
    <xsl:attribute name="value">Close</xsl:attribute>
    <xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
