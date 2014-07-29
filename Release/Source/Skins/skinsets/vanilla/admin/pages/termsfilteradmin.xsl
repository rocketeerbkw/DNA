<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<xsl:template match="H2G2[@TYPE = 'TERMSFILTERADMIN']" mode="page">
    
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >Terms Filter Admin</xsl:with-param>
		</xsl:call-template>
    <div class="dna-mb-intro blq-clearfix">
      View and edit terms filter lists for moderation class - 
      <select onchange="location.href='termsfilteradmin?modclassid=' + this.options[this.selectedIndex].value;">
      	<option value="0">All Terms in All Mod Classes</option>
        <xsl:apply-templates select="TERMSFILTERADMIN/MODERATION-CLASSES/MODERATION-CLASS" mode="lefthandNav_terms"/>
      </select>

      <xsl:call-template name="refresh-cache" />

    </div>
    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <div class="dna-fl dna-main-full">
        <div class="dna-box">
          <h3>
            <xsl:choose>
				<xsl:when test="TERMSFILTERADMIN/TERMSLIST[@MODCLASSID = 0]">
					All terms across all mod classes
				</xsl:when>
				<xsl:otherwise>
					Terms for "<xsl:value-of select="TERMSFILTERADMIN/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = /H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID]/NAME"/>"
				</xsl:otherwise>
			</xsl:choose>
        </h3>
          <xsl:apply-templates select="TERMSFILTERADMIN/TERMSLIST" mode="termsList"/>
        </div>
      </div>
    </div>
	</xsl:template>

  <xsl:template match="MODERATION-CLASS" mode="lefthandNav_terms">
    <option value="{@CLASSID}">
      <xsl:if test="(/H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID= @CLASSID)">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <a href="termsfilteradmin?modclassid={@CLASSID}">
        <xsl:value-of select="NAME"/>
      </a>
    </option>
  </xsl:template>

  <xsl:template match="TERMSLIST" mode="termsList">
    
    <table class="dna-termslist">
      <thead>
        <tr>
          <th>
            <xsl:call-template name="sortTerms">
              <xsl:with-param name="sortBy">Term</xsl:with-param>
            </xsl:call-template>
          </th>
			<xsl:if test="/H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID != 0">
          <th>Action</th>
			</xsl:if>
          <th>Reason</th>
          <th>User</th>
          <th>
            <xsl:call-template name="sortTerms">
              <xsl:with-param name="sortBy">Date</xsl:with-param>
            </xsl:call-template>
          </th>
          <th colspan="2">&#160;</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="TERMDETAILS" mode="termadmin"/>
      </tbody>
    </table>
    <p>
      <a href="termsfilterimport?s_modclassid={@MODCLASSID}">Import More Terms</a>
    </p>
  </xsl:template>

  <xsl:template match="TERMDETAILS"  mode="termadmin">
    <tr>
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">odd</xsl:attribute>
      </xsl:if>
      <td>
        <strong>
          <xsl:value-of select="@TERM"/>
        </strong>
      </td>
		<xsl:if test="/H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID != 0">
			<td>
				<xsl:choose>
					<xsl:when test="@ACTION = 'Refer'">
						<img src="/dnaimages/dna_messageboard/img/icons/post_REFERRED.png" width="30" height="30" alt="Send message to moderation" title="Send message to moderation" />
					</xsl:when>
					<xsl:when test="@ACTION = 'ReEdit'">
						<img src="/dnaimages/dna_messageboard/img/icons/post_FAILED.png" width="30" height="30" alt="Ask user to re-edit word" title="Ask user to re-edit word" />
					</xsl:when>
					<xsl:otherwise>
						-
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</xsl:if>
      <td>
        <xsl:choose>
          <xsl:when test="REASON = 'Reason Unknown'">
            -
          </xsl:when>
          <xsl:otherwise>
            <span class="dna-termslist-reason" title="{REASON}">
              <xsl:call-template name="fixedLines">
                <xsl:with-param name="originalString" select="REASON" />
                <xsl:with-param name="charsPerLine" select="33" />
                <xsl:with-param name="lines" select="1" />
              </xsl:call-template>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="USERNAME = 'no username'">
            -
          </xsl:when>
          <xsl:otherwise>
            <a href="memberdetails?userid={@USERID}">
              <xsl:value-of select="USERNAME"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <!--<xsl:choose>
          <xsl:when test="REASON = 'Reason Unknown'">
            -
          </xsl:when>
          <xsl:otherwise>-->
            <xsl:value-of select="UPDATEDDATE/DATE/@RELATIVE"/>
          <!--</xsl:otherwise>
        </xsl:choose>-->
        
      </td>
      <td>
      	<xsl:choose>
      		<xsl:when test="@MODCLASSID = 0">
      			<a href="termsfilterimport?s_termid={@ID}&amp;modclassid=0&amp;s_modclassid=0">edit</a>
      		</xsl:when>
      		<xsl:otherwise>
      			<a href="termsfilterimport?s_termid={@ID}&amp;modclassid={@MODCLASSID}&amp;s_modclassid={@MODCLASSID}">edit</a>
      		</xsl:otherwise>
      	</xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="refresh-cache">
    <xsl:param name="type"></xsl:param>
    <div class="dna-refresh-cache">
        <p>
          <a href="termsfilteradmin?action=REFRESHCACHE" style="font-size:10pt" onclick="return confirm('Are you sure?\r\nThis will cause the live filters to be refreshed.');">Refresh Live Cache</a>
        </p>
    </div>
  </xsl:template>

  <xsl:template name="fixedLines">
    <xsl:param name="originalString" />
    <xsl:param name="charsPerLine" />
    <xsl:param name="lines" select="1"/>
    <xsl:param name="newString" select="''" />



    <xsl:choose>
      <xsl:when test="string-length($originalString) > $charsPerLine">
        <xsl:choose>
          <xsl:when test="$lines > 1">
            <!-- get last space within char limit -->
            <xsl:variable name="currentLineIndex">
              <xsl:call-template name="lastIndexOf">
                <xsl:with-param name="string" select="substring($originalString, 1, $charsPerLine -1)" />
                <xsl:with-param name="char" select="' '" />
              </xsl:call-template>
            </xsl:variable>

            <!-- call text to keep -->
            <xsl:variable name="currentLineText">
              <xsl:choose>
                <xsl:when test="$currentLineIndex = 0">
                  <xsl:value-of select="substring($originalString, 1, $charsPerLine)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring($originalString, 1, $currentLineIndex)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="newline">
              <xsl:text> </xsl:text>
            </xsl:variable>


            <xsl:variable name="newCurrentLineText">
              <xsl:value-of disable-output-escaping="no" select="concat(concat($newString, $currentLineText), $newline)"/>
            </xsl:variable>

            <!-- call self to get next line -->
            <xsl:call-template name="fixedLines">
              <xsl:with-param name="originalString" select="substring-after($originalString, $currentLineText)" />
              <xsl:with-param name="charsPerLine" select="$charsPerLine" />
              <xsl:with-param name="lines" select="$lines -1" />
              <xsl:with-param name="newString" select="$newCurrentLineText"/>
            </xsl:call-template>

          </xsl:when>
          <xsl:otherwise>
            <!-- last line -->
            <!-- get last space within char limit -->
            <xsl:variable name="lastSpaceIndex">
              <xsl:call-template name="lastIndexOf">
                <xsl:with-param name="string" select="substring($originalString, 1, $charsPerLine -3)" />
                <xsl:with-param name="char" select="' '" />
              </xsl:call-template>
            </xsl:variable>

            <!-- check if there is a space within max size-->
            <xsl:variable name="lastLineIndex">
              <xsl:choose>
                <xsl:when test="$lastSpaceIndex = $charsPerLine">
                  <xsl:value-of select="$charsPerLine - 3"/>
                </xsl:when>
                <xsl:when test="$lastSpaceIndex = 0">
                  <xsl:value-of select="$charsPerLine - 3"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$lastSpaceIndex" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- output string -->
            <xsl:value-of disable-output-escaping="no" select="concat(concat($newString, substring($originalString, 1, $lastLineIndex)), '...')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of disable-output-escaping="no" select="concat($newString, $originalString)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="lastIndexOf">
    <!-- declare that it takes two parameters 
	  - the string and the char -->
    <xsl:param name="string" />
    <xsl:param name="char" />
    <xsl:param name="length" select="0" />
    <xsl:choose>

      <!-- if the string contains the character... -->
      <xsl:when test="contains($string, $char)">
        <!-- call the template recursively... -->
        <xsl:call-template name="lastIndexOf">
          <!-- with the string being the string after the character-->
          <xsl:with-param name="string" select="substring-after($string, $char)" />
          <!-- and the character being the same as before -->
          <xsl:with-param name="char" select="$char" />
          <xsl:with-param name="length" select="$length + string-length(substring-before($string, $char)) + 1" />
        </xsl:call-template>
      </xsl:when>
      <!-- otherwise, return the value of the string -->
      <xsl:otherwise>
        <xsl:value-of select="$length" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sortTerms">
    <!-- declare that it takes two parameters 
	  - the string and the char -->
    <xsl:param name="sortBy" />
    <xsl:param name="sortByEnum">
      <xsl:choose>
        <!-- if the string contains the character... -->
        <xsl:when test="$sortBy ='Term'">Term</xsl:when>
        <!-- otherwise, return the value of the string -->
        <xsl:otherwise>Created</xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="sortDirection">
      <xsl:choose>
        <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_sortDirection']/VALUE = 'Descending'">Ascending</xsl:when>
        <xsl:otherwise>Descending</xsl:otherwise>
      </xsl:choose>        
    </xsl:param>

      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="concat('termsfilteradmin?modclassid=', /H2G2/TERMSFILTERADMIN/TERMSLIST/@MODCLASSID, '&amp;s_sortDirection=',$sortDirection, '&amp;s_sortBy=', $sortByEnum)"/> 
        </xsl:attribute>
        <xsl:value-of select="$sortBy"/>
      </a>
  </xsl:template>

</xsl:stylesheet>
