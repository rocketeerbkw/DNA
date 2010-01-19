<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="CHALLENGE">

	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>
	
	<!-- FORM -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$challengefields}"/>
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<a name="edit" id="edit"></a>
	<div class="PageContent">
	<div class="titleBars" id="titleChallenge">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
		<!-- START A NEW CHALLENGE -->
		NO MORE CHALLENGES
		</xsl:when>
		<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'">
		<!-- EDIT YOUR CHALLENGE -->
		REMOVE YOUR CHALLENGE
		</xsl:when>
		</xsl:choose>
	<br/>
	</xsl:element>
	</div>
	
	


	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor"><!-- $test_IsEditor -->

	<div class="box6">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<span class="requiredtext">* = required field</span>
	</xsl:element>
	</div>


	<div class="box2">
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	TITLE OF YOUR CHALLENGE HERE <xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="c_error"/>
	</xsl:element>
   </div>

	<xsl:apply-templates select="." mode="t_articletitle"/>
	<br/>
	<br/>
	
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	DEADLINE 
	</xsl:element>
	</div>
	
	<select name="CHALLENGEDAY">
	<xsl:variable name="days" select="30" />
	<xsl:call-template name="calendar.days">
	<xsl:with-param name="count" select="1" />
	</xsl:call-template>
	</select>
	
	<select name="CHALLENGEMONTH">
	<option value="January">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='January'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	January</option>
	<option value="February">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='February'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	February</option>
	<option value="March">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='March'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	March</option>
	<option value="April">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='April'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	April</option>
	<option value="May">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='May'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	May</option>
	<option value="June">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='June'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	June</option>
	<option value="July">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='July'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	July</option>
	<option value="August">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='August'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	August</option>
	<option value="September">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='September'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	September</option>
	<option value="October">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='October'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	October</option>
	<option value="November">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='November'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	November</option>
	<option value="December">
	<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEMONTH']/VALUE-EDITABLE='December'">
	<xsl:attribute name="selected">selected</xsl:attribute>
	</xsl:if>
	December</option>
	</select>
	
	<select name="CHALLENGEYEAR">
		<option value="2004">
		<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEYEAR']/VALUE-EDITABLE='2004'">
		<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		2004</option>
		<option value="2005">
		<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEYEAR']/VALUE-EDITABLE='2005'">
		<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		2005</option>
		<option value="2006">
		<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEYEAR']/VALUE-EDITABLE='2006'">
		<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		2006</option>
	</select>
	<xsl:text> </xsl:text>
	
	<span class="headinggeneric">
	<input type="checkbox" name="NODEADLINE" value="yes">
	<xsl:if test="MULTI-ELEMENT[@NAME='NODEADLINE']/VALUE-EDITABLE='yes'">
	<xsl:attribute name="checked">checked</xsl:attribute>
	</xsl:if>
	</input>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">no deadline</xsl:element>
	</span>
	<br/><br/>
	
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	SET WORD LIMIT 
	</xsl:element>
	</div>

	<input type="text" name="WORDLIMIT" value="{MULTI-ELEMENT[@NAME='WORDLIMIT']/VALUE-EDITABLE}" />

	<br/>
	<br/>
		
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	CHALLENGE <xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_error"/>
	</xsl:element>
	</div>
	
	<xsl:apply-templates select="." mode="t_articlebody"/>
	
	<br/>
	<br/>
	<a name="publish" id="publish"></a>
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	<xsl:apply-templates select="." mode="c_articleeditbutton"/>
	<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
	<xsl:apply-templates select="." mode="c_deletearticle"/>

	</div>
	
	
	<!-- ################ end removed for site pulldown ################ -->
	</xsl:when>
	<xsl:otherwise>
	<div class="headinggeneric">
	<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'"><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	TITLE OF YOUR CHALLENGE 
	</xsl:element>
	</xsl:if>
	</div>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
	<br/>
	<br/>
	<a name="publish" id="publish"></a>
	<xsl:apply-templates select="." mode="c_deletearticle"/>
	
	</xsl:otherwise>
	</xsl:choose>
	</div>
	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
	<div class="rightnavbox">
	
	<a href="{$root}dailyflash?s_print=1&amp;s_type=pop" target="printpopup" onClick="popwin(this.href, this.target, 575, 600, 'scroll', 'resize'); return false;"><xsl:copy-of select="$button.seeexample" /></a>
	
	<xsl:copy-of select="$form.challenge.tips" />
	</div>
	</xsl:element>
		<br/>
		
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	

	
</xsl:template>

<xsl:template name="calendar.days">
<xsl:param name="count" />

<option value="{$count}">
<xsl:if test="MULTI-ELEMENT[@NAME='CHALLENGEDAY']/VALUE-EDITABLE=$count">
<xsl:attribute name="selected">selected</xsl:attribute>
</xsl:if>
<xsl:value-of select="$count" /></option>

<xsl:if test="$count!=31">
<xsl:call-template name="calendar.days">
<xsl:with-param name="count" select="$count + 1" />
</xsl:call-template>
</xsl:if>

</xsl:template>
	
</xsl:stylesheet>
