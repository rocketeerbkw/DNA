<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

  <xsl:template match="TOPIC" mode="object_topiclist_elements">
    <div id="mbpreview-topics">
      <ul>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '1col'">topicpreview onecol</xsl:when>
            <xsl:otherwise>topicpreview twocol</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:for-each select=".">
          <li>
            <xsl:if test="position() mod 2 = 0">
              <xsl:attribute name="class">even</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="." mode="object_topic_admin"/>
          </li>
        </xsl:for-each>
        
      </ul>
    </div>
  </xsl:template>


  <xsl:template match="TOPIC" mode="object_topiclist">
    <div>
      <xsl:choose>
        <xsl:when test="TOPICSTATUS='0'">
          <a href="topicbuilder?cmd=delete&amp;topicid={TOPICID}&amp;editkey={EDITKEY}" onclick="return confirm('Are you sure you wish to archive this topic?');"><xsl:value-of select="TITLE"/></a>
        </xsl:when>
        <xsl:when test="TOPICSTATUS='1'">
          <a href="topicbuilder?cmd=delete&amp;topicid={TOPICID}&amp;editkey={EDITKEY}" onclick="return confirm('Are you sure you wish to delete this topic?');">
            <xsl:value-of select="TITLE"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a href="topicbuilder?cmd=unarchive&amp;topicid={TOPICID}&amp;editkey={EDITKEY}" onclick="return confirm('Are you sure you wish to unarchive this topic?');">
            <xsl:value-of select="TITLE"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>


    </div>
  </xsl:template>
	
	<xsl:template match="TOPICLIST" mode="object_topiclist_setup">
		<div id="mbpreview-topics" class="dashborder">
			<h4>Choose topic layout</h4>
			<p>Before you begin adding topics to your messageboard, please choose the layout you would like to display them in (this can be changed later)</p>
			<form action="#" method="get" class="vertform">
				<div>
					<input type="radio" name="layout" value="2col" id="layout-2col"/>
					<label for="layout-2col">2 Columns</label>
					<p>This layout consists of topic promos being displayed in 2 columns. It also allows you to add images to your topic promo.</p>
				</div>
				<div>
					<input type="radio" name="layout" value="1col" id="layout-1col"/>
					<label for="layout-1col">1 Column</label>
					<p>This layout consists of topic promos displayed in 1 column.</p>
				</div>
			</form>
		</div>
	</xsl:template>

  <xsl:template match="TOPIC" mode="object_topic_admin">
    
      
   <xsl:value-of select="FRONTPAGEELEMENT/TITLE" />
    <a href="messageboardadmin_design?s_edittopic={TOPICID}">Edit Topic</a>
    <xsl:if test="FRONTPAGEELEMENT/TEMPLATE = 2">
      <xsl:if test="FRONTPAGEELEMENT/IMAGENAME and FRONTPAGEELEMENT/IMAGENAME != ''">
        <div class="topicimage">
            <img src="{FRONTPAGEELEMENT/IMAGENAME}" alt="{FRONTPAGEELEMENT/IMAGEALTTEXT}" width="206" height="116"/>
        </div>
      </xsl:if>
    </xsl:if>
    
      <p class="replies">
        xxx replies
      </p>

      <p>
        <xsl:apply-templates select="FRONTPAGEELEMENT/TEXT" mode="library_GuideML" />
      </p>
    <div>
      Position: <input name="topic_{TOPICID}_position" value="{FRONTPAGEELEMENT/POSITION}" size="2"/>
    </div>
      
  </xsl:template>

  <xsl:template name="object_topic_edit">
    <xsl:param name="topicid"></xsl:param>
    <div id="mbpreview-edittopic" class="mbpreview-box">
      <form action="messageboardadmin_design?cmd=updatetopic" method="post">
        <input type="hidden" name="topiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/EDITKEY}"></input>
        <input type="hidden" name="fptopiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/EDITKEY}"></input>
        <input type="hidden" name="topicid" value="{$topicid}"></input>
        <div id="mbpreview-edittopic-step1">
          <xsl:choose>
            <xsl:when test="$topicid = 0">
              <h4>Create Topic</h4>
            </xsl:when>
            <xsl:otherwise>
              <h4>Edit Topic</h4>
            </xsl:otherwise>
          </xsl:choose>
          
          <div class="mbpreview-edittopic steptext">Step 1 of 3</div>
          <p>Add the text which shall appear on the topic promo, found on the messageboard homepage.</p>
          <p>
          <div>
            <label for="fp_title">Title of topic promo:</label>
          </div>
          <div>
            <input type="text" name="fp_title" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/TITLE}" size="50"/>
          </div>
            Example: Our Couples for 2009
          </p>
          <p>
            <div>
              <label for="fp_text">Enter the text to explain what this topic is about:</label>
            </div>
            <div>
              <textarea name="fp_text" cols="50" rows="2">
                <xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEXT"/>
              </textarea>
            </div>
            Example: Who's got a good chance this year? Who'll be waltzing off in the first few shows?
          </p>
        </div>
        <div id="mbpreview-edittopic-step2">
          <xsl:choose>
            <xsl:when test="$topicid = 0">
              <h4>Create Topic</h4>
            </xsl:when>
            <xsl:otherwise>
              <h4>Edit Topic</h4>
            </xsl:otherwise>
          </xsl:choose>
          <div class="mbpreview-edittopic steptext">Step 2 of 3</div>
          <p>You can choose to add an image to your topic promo. If uou do not wish to add an image, simply click Next.</p>
          <p>
            <div>
              <label for="fp_imagename">Image Address (image size: 206 X 116 pixels):</label>
            </div>
            <div>
              <input type="text" name="fp_imagename" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGENAME}" size="50"/>
            </div>
            Example: ricky_erin.jpg
          </p>
          <p>
            <div>
              <label for="fp_imagealttext">Enter the alt text for this image:</label>
            </div>
            <div>
              <input type="text" name="fp_imagealttext" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGEALTTEXT}" size="50"/>
            </div>
            Example: Erin and Rick
          </p>
          <p>
            <div>
              <label for="fp_imagealttext">Turn Off Image</label>
            </div>
            <div>
              <input type="checkbox" name="fp_templatetype" value="turnimageoff">
                <xsl:if test="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEMPLATETYPE != 2">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </div>
            To turn off the image for this topic promo, please select this box
          </p>
        </div>
        <div id="mbpreview-edittopic-step3">
          <xsl:choose>
            <xsl:when test="$topicid = 0">
              <h4>Create Topic</h4>
            </xsl:when>
            <xsl:otherwise>
              <h4>Edit Topic</h4>
            </xsl:otherwise>
          </xsl:choose>
          <div class="mbpreview-edittopic steptext">Step 3 of 3</div>
          <p>Add the text which shall appear on the topic page itself.</p>
          <p>
            <div>
              <label for="topictitle">Title of topic page:</label>
            </div>
            <div>
              <input type="text" name="topictitle" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/TITLE}" size="50"/>
            </div>
            Example: Our Couples for 2009
          </p>
          <p>
            <div>
              <label for="topictext">Enter the text to explain what this topic page is about:</label>
            </div>
            <div>
              <textarea name="topictext" cols="50" rows="2">
                <xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/DESCRIPTION/GUIDE/BODY"/>
              </textarea>
            </div>
            Example: Who's will your favourite dancers be this year? Let the speculations begin...
          </p>
        </div>
        <xsl:call-template name="submitbuttons"/>
      </form>
    </div>
    
  </xsl:template>
</xsl:stylesheet>
