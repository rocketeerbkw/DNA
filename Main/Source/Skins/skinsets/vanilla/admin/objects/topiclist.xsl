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
          <a href="topicbuilder?s_mode=delete&amp;s_topicid={TOPICID}&amp;editkey={EDITKEY}#dna-preview-delete-topic-{TOPICID}" class="dna-link-overlay">
            <xsl:value-of select="TITLE"/>
          </a>
        </xsl:when>
        <xsl:when test="TOPICSTATUS='1'">
          <a href="topicbuilder?s_mode=archive&amp;s_topicid={TOPICID}&amp;editkey={EDITKEY}#dna-preview-archive-topic-{TOPICID}" class="dna-link-overlay">
            <xsl:value-of select="TITLE"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a href="topicbuilder?s_mode=unarchive&amp;s_topicid={TOPICID}&amp;editkey={EDITKEY}#dna-preview-unarchive-topic-{TOPICID}" class="dna-link-overlay">
            <xsl:value-of select="TITLE"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="TOPIC" mode="object_topiclist_design">
    <li><a href="topicbuilder"><xsl:value-of select="TITLE"/></a></li>
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
    <xsl:variable name="topicPosition" select="count(preceding-sibling::*) + 1"/>
     
    <h5><xsl:value-of select="FRONTPAGEELEMENT/TITLE" /></h5>
      
    <p class="dna-link-edit"><a href="?s_edittopic={TOPICID}&amp;s_mode=topic#dna-preview-topic-edit-{TOPICID}" class="dna-link-overlay">Edit Topic</a></p>
    
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
    
    <p class="dna-topic-position">
      <label for="topic_{TOPICID}_position">Position:</label> <input id="topic_{TOPICID}_position" name="topic_{TOPICID}_position" value="{FRONTPAGEELEMENT/POSITION}" class="dna-topic-pos"/>
    </p>
  </xsl:template>

  <xsl:template match="FRONTPAGEELEMENT/TEXT" mode="frontpage_element-text">
    <p><xsl:value-of select="." disable-output-escaping="yes"/></p>
  </xsl:template>
  

  
  <xsl:template name="object_topic_edit">
    <xsl:param name="topicid">
    </xsl:param>
    

      <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatetopic&amp;s_success_topics=true#dna-s-topics" method="post" id="dna-add-topic-{$topicid}" name="frm-add-topic-{$topicid}">
        <input type="hidden" name="topiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/EDITKEY}"></input>
        <input type="hidden" name="fptopiceditkey" value="{/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/EDITKEY}"></input>
        <input type="hidden" id="topicid" name="topicid" value="{$topicid}"></input>


        <div id="dna-preview-edittopic-step1-{$topicid}" >
          <xsl:attribute name="class"><xsl:if test="//PARAMS/PARAM[NAME = 's_step']/VALUE = '2' or //PARAMS/PARAM[NAME = 's_step']/VALUE = '3'">dna-off</xsl:if></xsl:attribute> 
          
            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span>Step 1 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit <span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic <span>Step 1 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>
          
            <p>Add the text which shall appear on the topic promo, found on the messageboard homepage.</p>
            <p>
              <label for="fp_title-{$topicid}">Title of topic promo:</label>
              <input type="text" name="fp_title" id="fp_title-{$topicid}" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID = $topicid]/FRONTPAGEELEMENT/TITLE}"/>
              <span class="dna-fnote">
                <strong>Example:</strong> Our Couples for 2009
              </span>
            </p>

            <p>
              <label for="fp_text-{$topicid}">Enter the text to explain what this topic is about:</label>
              <textarea name="fp_text" id="fp_text-{$topicid}" cols="50" rows="5"><xsl:text>&#x0A;</xsl:text><xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEXT"/></textarea>
              <span class="dna-fnote">
                <strong>Example:</strong> Who's got a good chance this year? Who'll be waltzing off in the first few shows?
              </span>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <a href="?s_mode=topic&amp;s_step=2&amp;s_edittopic={$topicid}#dna-preview-edittopic-step2-{$topicid}" class="dna-btn-link" id="dna-btn-next-1-{$topicid}">Next</a>
                </li>
                <li>
                  <a href="messageboardadmin_design?s_mode=design" class="dna-btn-link dna-btn-cancel">Cancel</a>
                </li>
              </ul>
            </div>
          </div>


          <div id="dna-preview-edittopic-step2-{$topicid}">
            <xsl:attribute name="class">
              <xsl:if test="//PARAMS/PARAM[NAME = 's_step']/VALUE != '2' or not(//PARAMS/PARAM[NAME = 's_step'])">dna-off</xsl:if>
            </xsl:attribute>

            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span>Step 2 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit <span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic <span>Step 2 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>


            <p>You can choose to add an image to your topic promo. If you do not wish to add an image, simply click Next.</p>
            <p>
              <label for="fp_imagename-{$topicid}">Image Address (image size: 206 X 116 pixels):</label>
              <input type="text" name="fp_imagename" id="fp_imagename-{$topicid}" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGENAME}"/>
              <span class="dna-fnote">
                <strong>Example:</strong> ricky_erin.jpg
              </span>
            </p>
            <p>
              <label for="fp_imagealttext-{$topicid}">Enter the alt text for this image:</label>
              <input type="text" name="fp_imagealttext" id="fp_imagealttext-{$topicid}" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/IMAGEALTTEXT}" />
              <span class="dna-fnote">
                <strong>Example:</strong> Erin and Rick
              </span>
            </p>
            <p class="dna-turn-img-off">
              <input type="checkbox" name="fp_templatetype" id="fp_templatetype-{$topicid}" value="turnimageoff">
                <xsl:if test="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/FRONTPAGEELEMENT/TEMPLATETYPE != 2">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
              <label for="fp_templatetype-{$topicid}">To turn off the image for this topic promo, please select this box</label>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <a href="?s_mode=topic&amp;s_step=1&amp;s_edittopic={$topicid}#dna-preview-edittopic-step1-{$topicid}" class="dna-btn-link" id="dna-btn-back-2-{$topicid}">Back</a>
                </li>
                <li>
                  <a href="?s_mode=topic&amp;s_step=3&amp;s_edittopic={$topicid}#dna-preview-edittopic-step3-{$topicid}" class="dna-btn-link" id="dna-btn-next-2-{$topicid}">Next</a>
                </li>
                <li>
                  <a href="messageboardadmin_design?s_mode=design" class="dna-btn-link dna-btn-cancel">Cancel</a>
                </li>
              </ul>
            </div>
          </div>


          <div id="dna-preview-edittopic-step3-{$topicid}">
            <xsl:attribute name="class"><xsl:if test="//PARAMS/PARAM[NAME = 's_step']/VALUE != '3' or not(//PARAMS/PARAM[NAME = 's_step'])">dna-off</xsl:if></xsl:attribute>

            <xsl:choose>
              <xsl:when test="$topicid = 0">
                <h4>
                  Add Topic <span>Step 3 of 3</span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <h4>
                  Edit <span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic  <span>Step 3 of 3</span>
                </h4>
              </xsl:otherwise>
            </xsl:choose>


            <p>Add the text which shall appear on the topic page itself.</p>
            <p>
              <label for="topictitle-{$topicid}">Title of topic page:</label>
              <input type="text" name="topictitle" id="topictitle-{$topicid}" value="{/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/TITLE}" />
              <span class="dna-fnote">
                <strong>Example:</strong> Our Couples for 2009
              </span>
            </p>
            <p>
              <label for="topictext-{$topicid}">Enter the text to explain what this topic page is about:</label>
              <textarea name="topictext" id="topictext-{$topicid}" cols="50" rows="5"><xsl:text>&#x0A;</xsl:text><xsl:value-of select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID=$topicid]/DESCRIPTION/GUIDE/BODY"/></textarea>
              <span class="dna-fnote">
                <strong>Example:</strong> Who's will your favourite dancers be this year? Let the speculations begin...
              </span>
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <a href="?s_mode=topic&amp;s_step=2&amp;s_edittopic={$topicid}#dna-preview-edittopic-step2-{$topicid}" class="dna-btn-link" id="dna-btn-back-3-{$topicid}">Back</a>
                </li>
                <li>
                  <input type="submit" name="submit" value="Save" id="dna-btn-next-3-{$topicid}" />
                </li>
                <li>
                  <a href="messageboardadmin_design?s_mode=design" class="dna-btn-link dna-btn-cancel">Cancel</a>
                </li>
              </ul>
            </div>
          </div>

        </form>
      

  </xsl:template>

  <xsl:template match="TOPIC" mode="object_topic_overlay">
    <xsl:variable name="archiveId" select="TOPICID" />
   
      <div id="dna-preview-archive-topic-{TOPICID}">
        <xsl:attribute name="class">
          dna-preview-box <xsl:if test="//PARAMS/PARAM[NAME = 's_mode']/VALUE != 'archive' or //PARAMS/PARAM[NAME = 's_topicid']/VALUE != $archiveId or not(//PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
        </xsl:attribute>
        
        <h4>Archive<span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic</h4>

        <form action="topicbuilder?cmd=delete" method="post" id="dna-topic-archive" name="frm-topic-archive-{TOPICID}">
          <input type="hidden" name="topiceditkey" value="{EDITKEY}"></input>
          <input type="hidden" id="topicid" name="topicid" value="{TOPICID}"></input>

          <p>Are you sure you wish to archive '<xsl:value-of select="TITLE"/>'?</p>

          <div class="dna-buttons">
            <ul>
              <li>
                <input type="submit" name="submit" value="Yes" />
              </li>
              <li>
                <a href="topicbuilder?s_mode=admin" class="dna-btn-link dna-btn-cancel">Cancel</a>
              </li>
            </ul>
          </div>
        </form>
      </div>

      <div id="dna-preview-unarchive-topic-{TOPICID}">
        <xsl:variable name="unarchiveId" select="TOPICID" />
        
        
        <xsl:attribute name="class">
          dna-preview-box <xsl:if test="//PARAMS/PARAM[NAME = 's_mode']/VALUE != 'unarchive' or //PARAMS/PARAM[NAME = 's_topicid']/VALUE != $unarchiveId or not(//PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
        </xsl:attribute>

        <h4>Unarchive<span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic</h4>

        <form action="topicbuilder?cmd=unarchive" method="post" id="dna-topic-unarchive" name="frm-topic-unarchive-{TOPICID}">
          <input type="hidden" name="topiceditkey" value="{EDITKEY}"></input>
          <input type="hidden" id="topicid" name="topicid" value="{TOPICID}"></input>

          <p>Are you sure you wish to unarchive '<xsl:value-of select="TITLE"/>'?</p>

         
          <div class="dna-buttons">
            <ul>
              <li>
                <input type="submit" name="submit" value="Yes" />
              </li>
              <li>
                <a href="topicbuilder?s_mode=admin" class="dna-btn-link dna-btn-cancel">Cancel</a>
              </li>
            </ul>
          </div>
        </form>
      </div>

      <div id="dna-preview-delete-topic-{TOPICID}">
        <xsl:variable name="unarchiveId" select="TOPICID" />
        
        <xsl:attribute name="class">
          dna-preview-box <xsl:if test="//PARAMS/PARAM[NAME = 's_mode']/VALUE != 'delete' or not(//PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
        </xsl:attribute>

        <h4>Delete <span class="dna-off"><xsl:value-of select="TITLE"/></span> Topic</h4>

        <form action="topicbuilder?cmd=delete" method="post" id="dna-topic-delete" name="frm-topic-delete-{TOPICID}">
          <input type="hidden" name="topiceditkey" value="{EDITKEY}"></input>
          <input type="hidden" id="topicid" name="topicid" value="{TOPICID}"></input>

          <p>Are you sure you wish to delete '<xsl:value-of select="TITLE"/>'?</p>

          <div class="dna-buttons">
            <ul>
              <li>
                <input type="submit" name="submit" value="Yes" />
              </li>
              <li>
                <a href="topicbuilder?s_mode=admin" class="dna-btn-link dna-btn-cancel">Cancel</a>
              </li>
            </ul>
          </div>

        </form>
      </div>

  </xsl:template>
</xsl:stylesheet>
