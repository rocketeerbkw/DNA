<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

  <xsl:template match="TOPIC" mode="object_topiclist_elements">

    <xsl:for-each select=".">
      <li class="dna-box-border">
        <xsl:apply-templates select="." mode="object_topic_admin"/>
      </li>
    </xsl:for-each>
    
  </xsl:template>


  <xsl:template match="TOPIC" mode="object_topiclist">
    <li>
      <xsl:choose>
        <xsl:when test="TOPICSTATUS='0'">
          <a href="topicbuilder?cmd=delete&amp;topicid={TOPICID}&amp;editkey={EDITKEY}" onclick="return confirm('Are you sure you wish to archive this topic?');">
            <xsl:value-of select="TITLE"/>
          </a>
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
    </li>
  </xsl:template>
	
	<xsl:template match="TOPICLIST" mode="object_topiclist_setup">
		<div id="dna-preview-topics">
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
    <h5><xsl:value-of select="FRONTPAGEELEMENT/TITLE" /></h5>
      
    <p class="dna-link-edit"><a href="?s_edittopic={TOPICID}&amp;s_mode=topic#dna-preview-edittopic" class="dna-link-overlay">Edit Topic</a></p>
    
    <xsl:if test="FRONTPAGEELEMENT/TEMPLATE = 2">
      <xsl:if test="FRONTPAGEELEMENT/IMAGENAME and FRONTPAGEELEMENT/IMAGENAME != ''">
        <p>
            <img src="{FRONTPAGEELEMENT/IMAGENAME}" alt="{FRONTPAGEELEMENT/IMAGEALTTEXT}" width="206" height="116"/>
        </p>
      </xsl:if>
    </xsl:if>
    
    <xsl:apply-templates select="FRONTPAGEELEMENT/TEXT" mode="frontpage_element-text" />

    <p class="dna-replies">
      <xsl:value-of select="FORUMPOSTCOUNT"/> replies
    </p>
    
    <p class="dna-off">
      <label for="topic_{TOPICID}_position">Position:</label> <input id="topic_{TOPICID}_position" name="topic_{TOPICID}_position" value="{FRONTPAGEELEMENT/POSITION}" class="dna-topic-pos"/>
    </p>
  </xsl:template>

  <xsl:template match="FRONTPAGEELEMENT/TEXT" mode="frontpage_element-text">
    <p><xsl:value-of select="." disable-output-escaping="yes"/></p>
  </xsl:template>
  

  
  <xsl:template name="object_topic_edit">
    <xsl:param name="topicid"></xsl:param>
    
      <form action="messageboardadmin_design?cmd=updatetopic" method="post" id="dna-add-topic">
        <input type="hidden" name="topiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/EDITKEY}"></input>
        <input type="hidden" name="fptopiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/EDITKEY}"></input>
        <input type="hidden" id="topicid" name="topicid" value="{$topicid}"></input>

        
        <div id="dna-preview-edittopic" class="dna-preview-box">
          <div id="dna-preview-edittopic-step1" >
            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span class="dna-topic-step">Step 1 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit Topic <span class="dna-topic-step">Step 1 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>


            <p>Add the text which shall appear on the topic promo, found on the messageboard homepage.</p>
            <p>
              <label for="fp_title">Title of topic promo:</label>
              <input type="text" name="fp_title" id="fp_title" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/TITLE}"/>
              <span class="dna-fnote">
                <strong>Example:</strong> Our Couples for 2009
              </span>
            </p>

            <p>
              <label for="fp_text">Enter the text to explain what this topic is about:</label>
              <textarea name="fp_text" id="fp_text" cols="50" rows="2">
                <xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEXT"/>
              </textarea>
              <span class="dna-fnote">
                <strong>Example:</strong> Who's got a good chance this year? Who'll be waltzing off in the first few shows?
              </span>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <a href="?s_mode=topic2&amp;s_edittopic={$topicid}#dna-preview-edittopic-step2" class="dna-btn-link" id="dna-btn-next-1">Next</a>
                </li>
                <li>
                  <a href="messageboardadmin?s_mode=admin" class="dna-btn-link">Cancel</a>
                </li>
              </ul>
            </div>
          </div>


          <div id="dna-preview-edittopic-step2">
            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span class="dna-topic-step">Step 2 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit Topic <span class="dna-topic-step">Step 2 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>


            <p>You can choose to add an image to your topic promo. If you do not wish to add an image, simply click Next.</p>
            <p>
              <label for="fp_imagename">Image Address (image size: 206 X 116 pixels):</label>
              <input type="text" name="fp_imagename" id="fp_imagename" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGENAME}"/>
              <span class="dna-fnote">
                <strong>Example:</strong> ricky_erin.jpg
              </span>
            </p>
            <p>
              <label for="fp_imagealttext">Enter the alt text for this image:</label>
              <input type="text" name="fp_imagealttext" id="fp_imagealttext" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGEALTTEXT}" />
              <span class="dna-fnote">
                <strong>Example:</strong> Erin and Rick
              </span>
            </p>
            <p class="dna-turn-img-off">
              <input type="checkbox" name="fp_templatetype" id="fp_templatetype" value="turnimageoff">
                <xsl:if test="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEMPLATETYPE != 2">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
              <label for="fp_templatetype">To turn off the image for this topic promo, please select this box</label>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <a href="?s_mode=topic3#dna-preview-edittopic-step3" class="dna-btn-link" id="dna-btn-next-2">Next</a>
                </li>
                <li>
                  <a href="messageboardadmin?s_mode=admin" class="dna-btn-link">Cancel</a>
                </li>
              </ul>
            </div>
          </div>


          <div id="dna-preview-edittopic-step3">
            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span class="dna-topic-step">Step 3 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit Topic <span class="dna-topic-step">Step 3 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>


            <p>Add the text which shall appear on the topic page itself.</p>
            <p>
              <label for="topictitle">Title of topic page:</label>
              <input type="text" name="topictitle" id="topictitle" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/TITLE}" />
              <span class="dna-fnote">
                <strong>Example:</strong> Our Couples for 2009
              </span>
            </p>
            <p>
              <label for="topictext">Enter the text to explain what this topic page is about:</label>
              <textarea name="topictext" id="topictext" ols="50" rows="2">
                <xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/DESCRIPTION/GUIDE/BODY"/>
              </textarea>
              <span class="dna-fnote">
                <strong>Example:</strong> Who's will your favourite dancers be this year? Let the speculations begin...
              </span>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <input type="submit" name="submit" value="Save" id="dna-btn-next-3" />
                </li>
                <li>
                  <a href="messageboardadmin?s_mode=admin" class="dna-btn-link">Cancel</a>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </form>

  </xsl:template>
</xsl:stylesheet>
