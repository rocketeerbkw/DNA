<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EDITOR_PAGE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITOR_PAGE</xsl:with-param>
	<xsl:with-param name="pagename">formeditorpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
<div class="form-wrapper">
		<!-- FORM HEADER -->
		<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your <xsl:value-of select="$article_type_group" /></strong>
				</xsl:element>
			</div>
		</xsl:if>

		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
				
		<!-- FORM BOX -->
		
		<a name="edit" id="edit"></a>
	    <input type="hidden" name="_msfinish" value="yes"/>

        <input type="hidden" name="_msxml" value="{$editorfields}"/>
   <!-- THIS IS THE ARTICLE TYPE DROPDOWN BOX -->
   <!-- ARTICLE TYPE -->
	<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td><xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>type:</b></xsl:element></td>
		<td>
		<xsl:apply-templates select="." mode="r_articletype"> 
		<xsl:with-param name="group" select="$article_type_group" />
		<xsl:with-param name="user" select="$article_type_user" />
		</xsl:apply-templates> 
		</td>
		</tr>
		
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR">
			<font color="#FF0000">* <b>page title:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>page title:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
       </td>
		<td><xsl:apply-templates select="." mode="t_articletitle"/></td>
		</tr>

		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='MAINTITLE']/ERRORS/ERROR">
			<font color="#FF0000">* <b>title:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>title:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td><input type="text" name="MAINTITLE" value="{MULTI-ELEMENT[@NAME='MAINTITLE']/VALUE-EDITABLE}" /></td>
</tr>
	
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='SUBTITLE']/ERRORS/ERROR">
			<font color="#FF0000">* <b>sub title:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>sub title:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td><input type="text" name="SUBTITLE" value="{MULTI-ELEMENT[@NAME='SUBTITLE']/VALUE-EDITABLE}" /></td>
		</tr>


		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='AUTHOR']/ERRORS/ERROR">
			<font color="#FF0000">* <b>artist/author:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>artist/author:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td><input type="text" name="AUTHOR" value="{MULTI-ELEMENT[@NAME='AUTHOR']/VALUE-EDITABLE}" /></td></tr>
			
		<tr>	
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='LABEL']/ERRORS/ERROR">
			<font color="#FF0000">* <b>label/publisher:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>artist/author:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td><input type="text" name="LABEL" value="{MULTI-ELEMENT[@NAME='LABEL']/VALUE-EDITABLE}" /></td></tr>


		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='PICTURENAME']/ERRORS/ERROR">
			<font color="#FF0000">* <b>picture name:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>picture name:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td>
		<xsl:choose>
			<xsl:when test="/H2G2/TYPED-ARTICLE-EDIT-FORM and $current_article_type=1">
			<input type="text" name="PICTURENAME" value="{/H2G2/TYPED-ARTICLE-EDIT-FORM/ARTICLE/GUIDE/FURNITURE/PICTURE/@NAME}"/></xsl:when>
			<xsl:otherwise>
			<input type="text" name="PICTURENAME" value="{MULTI-ELEMENT[@NAME='PICTURENAME']/VALUE-EDITABLE}" />
			</xsl:otherwise>
		</xsl:choose>
		</td>
		</tr>
		
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='PICTUREWIDTH']/ERRORS/ERROR">
			<font color="#FF0000">* <b>picture width:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>picture width:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="/H2G2/TYPED-ARTICLE-EDIT-FORM and $current_article_type=1">
				<input type="text" name="PICTUREWIDTH" value="{/H2G2/TYPED-ARTICLE-EDIT-FORM/ARTICLE/GUIDE/FURNITURE/PICTURE/@WIDTH}"/></xsl:when>
				<xsl:otherwise>
				<input type="text" name="PICTUREWIDTH" value="{MULTI-ELEMENT[@NAME='PICTUREWIDTH']/VALUE-EDITABLE}" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
		</tr>
				
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='PICTUREHEIGHT']/ERRORS/ERROR">
			<font color="#FF0000">* <b>picture height:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>picture height:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="/H2G2/TYPED-ARTICLE-EDIT-FORM and $current_article_type=1">
				<input type="text" name="PICTUREHEIGHT" value="{/H2G2/TYPED-ARTICLE-EDIT-FORM/ARTICLE/GUIDE/FURNITURE/PICTURE/@HEIGHT}"/></xsl:when>
				<xsl:otherwise>
				<input type="text" name="PICTUREHEIGHT" value="{MULTI-ELEMENT[@NAME='PICTUREHEIGHT']/VALUE-EDITABLE}" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
		</tr>
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='PICTUREALT']/ERRORS/ERROR">
			<font color="#FF0000">* <b>picture alt text:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>picture alt text:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="/H2G2/TYPED-ARTICLE-EDIT-FORM and $current_article_type=1">
				<input type="text" name="PICTUREALT" value="{/H2G2/TYPED-ARTICLE-EDIT-FORM/ARTICLE/GUIDE/FURNITURE/PICTURE/@ALT}"/></xsl:when>
				<xsl:otherwise>
				<input type="text" name="PICTUREALT" value="{MULTI-ELEMENT[@NAME='PICTUREALT']/VALUE-EDITABLE}" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
		</tr>
		
		<tr>
		<td colspan="2">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='SNIPPETS']/ERRORS/ERROR">
			<font color="#FF0000">* <b>snippets:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>snippets:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		</td>
		</tr>
		<tr>
		<td colspan="2">
		
		<textarea cols="50" rows="15" name="SNIPPETS" id="SNIPPETS" >
		<xsl:choose>
		<!-- pre-populate the form GuideML -->
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;SNIPPET&gt;
&lt;IMG NAME="icons/beige/icon_listen.gif" ALT="listen to" WIDTH="20" HEIGHT="20" ALIGN="left"/&gt;&lt;TEXT&gt;listen to:&lt;/TEXT&gt;
&lt;BODY&gt;&lt;LINK HREF="http://www.bbc.co.uk/collective/audio/skalpelfeature.ram" UINDEX="0" TYPE="logo"&gt;skalpel interview feature&lt;/LINK&gt;&lt;LINK HREF="http://www.bbc.co.uk/collective/audio/skalpelfeature.ram" UINDEX="1" TYPE="logo"&gt;skalpel interview feature&lt;/LINK&gt;&lt;LINK HREF="http://www.bbc.co.uk/collective/audio/skalpelfeature.ram" UINDEX="2" TYPE="logo"&gt;skalpel interview feature&lt;/LINK&gt;&lt;/BODY&gt;
&lt;/SNIPPET&gt;
&lt;SNIPPET&gt;&lt;IMG NAME="icons/beige/icon_listen.gif" ALT="listen to" WIDTH="20" HEIGHT="20" ALIGN="left"/&gt;
&lt;BODY&gt;listen to&lt;LINK HREF="http://www.bbc.co.uk/collective/audio/skalpelfeature.ram" UINDEX="0"&gt; skalpel interview feature&lt;/LINK&gt;&lt;/BODY&gt;
&lt;/SNIPPET&gt;</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="MULTI-ELEMENT[@NAME='SNIPPETS']/VALUE-EDITABLE"/>
		</xsl:otherwise>
		</xsl:choose>
		</textarea>
		
		</td>
		</tr>

		
	<tr>
	<td colspan="2">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='TAGLINE']/ERRORS/ERROR">
			<font color="#FF0000">* <b>tag line:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>tag line:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</td>
	</tr>
	<tr>		
	<td colspan="2">
	<textarea name="TAGLINE" ID="TAGLINE" cols="50" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='TAGLINE']/VALUE-EDITABLE"/>
	</textarea>
	</td>
	</tr>
		
		
	<tr>
	<td colspan="2">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR">
			<font color="#FF0000">* <b>body:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>body:</b>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</td>
	</tr>	
	<tr>	
	<td colspan="2">
	<textarea name="BODY" ID="BODY" cols="50" rows="20">
	<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
	</textarea>
	</td>
	</tr>
	<tr>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='EDITORNAME']/ERRORS/ERROR">
			<font color="#FF0000">* <b>editor name:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>editor name:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td>
	<input type="text" name="EDITORNAME" value="{MULTI-ELEMENT[@NAME='EDITORNAME']/VALUE-EDITABLE}" /></td>
	</tr>

	<tr>	
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='EDITORDNAID']/ERRORS/ERROR">
			<font color="#FF0000">* <b>editor DNAID:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>editor DNAID:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td>
	<td>
	<input type="text" name="EDITORDNAID" value="{MULTI-ELEMENT[@NAME='EDITORDNAID']/VALUE-EDITABLE}" /></td>
	</tr>
	
	<tr>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='PUBLISHDATE']/ERRORS/ERROR">
			<font color="#FF0000">* <b>publish date:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>publish date:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td>
	<td>
	<input type="text" name="PUBLISHDATE" value="{MULTI-ELEMENT[@NAME='PUBLISHDATE']/VALUE-EDITABLE}" />
	</td></tr>
	

	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='BOLDINFO']/ERRORS/ERROR">
			<font color="#FF0000">* <b>boldinfo:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>boldinfo:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td>
</tr>
	<tr>
	<td colspan="2">
	<textarea name="BOLDINFO" ID="BOLDINFO" cols="50" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='BOLDINFO']/VALUE-EDITABLE"/>
	</textarea></td></tr>


	<tr><td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='BOTTOMTEXT']/ERRORS/ERROR">
			<font color="#FF0000">* <b>bottom text:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>bottom text:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
	<tr>
	   <td colspan="2">
		<textarea name="BOTTOMTEXT" ID="BOTTOMTEXT" cols="50" rows="8">
		<xsl:value-of select="MULTI-ELEMENT[@NAME='BOTTOMTEXT']/VALUE-EDITABLE"/>
		</textarea>
		</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Description:</b></xsl:element><br />
	<textarea name="DESCRIPTION" ID="DESCRIPTION" cols="50" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
</textarea><br /><br />
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Keywords:</b></xsl:element><br />
	<textarea name="KEYWORDS" ID="KEYWORDS" cols="50" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
</textarea>
	</td>
	</tr>
	<tr>
		<td colspan="2">
		<!-- ALISTAIR: RADIO BUTTON -->
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Conversations/Comments:</strong><br />
		<input type="radio" name="ARTICLEFORUMSTYLE" value="0" checked="checked" /> Conversations - FORUMTHREAD<br />
		<input type="radio" name="ARTICLEFORUMSTYLE" value="1" /> Comments - FORUMTHREADPOSTS
		</xsl:element>
		<!-- ALISTAIR: /END RADIO BUTTON -->
		</td>
	</tr>
		</table>


	<!--EDIT BUTTONS --> 
	
	<!-- STATUS -->
	<div>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/>
	</div>
	
	<!-- HIDE ARTICLE -->
	<div><xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_hidearticle"/></div>
	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
	

		</td>
		<td valign="top">
		
		<table border="0" cellspacing="0" cellpadding="2">
		<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='WHATDOYOUTHINK']/ERRORS/ERROR">
			<font color="#FF0000">* <b>what do you think?:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>what do you think:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
			</td>
			</tr>
			<tr>
			<td>
			<textarea name="WHATDOYOUTHINK" ID="WHATDOYOUTHINK" cols="40" rows="8">
				<xsl:choose>
				<!-- pre-populate the form GuideML -->
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">Have you listen to the FULL tracks? What did you think?</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="MULTI-ELEMENT[@NAME='WHATDOYOUTHINK']/VALUE-EDITABLE"/>
				</xsl:otherwise>
				</xsl:choose>
			</textarea></td>
		</tr>
	<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='LIKETHIS']/ERRORS/ERROR">
			<font color="#FF0000">* <b>like this try this:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>like this try this:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
	<tr><td>
	<textarea name="LIKETHIS" ID="LIKETHIS" cols="40" rows="8">
		<xsl:choose>
			<!-- pre-populate the form GuideML -->
			<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK TYPE="logo" DNAID="A1364203"&gt;artist&lt;/LINK&gt;&lt;LINK TYPE="logo" DNAID="A1364203"&gt;artist&lt;/LINK&gt;&lt;LINK TYPE="logo" DNAID="A1291754"&gt;artist&lt;/LINK&gt;</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="MULTI-ELEMENT[@NAME='LIKETHIS']/VALUE-EDITABLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</textarea></td></tr>

	<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='USEFULLINKS']/ERRORS/ERROR">
			<font color="#FF0000">* <b>useful links:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>useful links:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
	<tr>
	<td>
	<textarea name="USEFULLINKS" ID="USEFULLINKS" cols="40" rows="8">
		<xsl:choose>
	<!-- pre-populate the form GuideML -->
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK HREF="http://www.thedelays.co.uk/" POPUP="1"&gt;www.thedelays.co.uk&lt;/LINK&gt;</xsl:when>
	<!-- preview -->
		<xsl:otherwise>
		<xsl:value-of select="MULTI-ELEMENT[@NAME='USEFULLINKS']/VALUE-EDITABLE"/>
		</xsl:otherwise>
		</xsl:choose>
	</textarea>
	</td></tr>
		<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='SEEALSO']/ERRORS/ERROR">
			<font color="#FF0000">* <b>see also:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>see also:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
			<tr>
			<td>
			<textarea name="SEEALSO" ID="SEEALSO" cols="40" rows="8">
				<xsl:choose>
				<!-- pre-populate the form GuideML -->
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK TYPE="icon" DNAID=""&gt;&lt;IMG NAME="040116/sm_delays.jpg" WIDTH="64" HEIGHT="36" ALIGN="left" ALT="delays" /&gt;delays&lt;/LINK&gt; 
&lt;DESCRIPTION&gt;interview&lt;/DESCRIPTION&gt;
&lt;LINK TYPE="logo" DNAID="A2283095"&gt;type link here&lt;/LINK&gt;</xsl:when>
				<xsl:otherwise>
				<xsl:value-of select="MULTI-ELEMENT[@NAME='SEEALSO']/VALUE-EDITABLE"/>
				</xsl:otherwise>
				</xsl:choose>
			</textarea>
			</td></tr>
	<tr>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='RELATEDCONVERSATIONS']/ERRORS/ERROR">
			<font color="#FF0000">* <b>related member conversations:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>related member conversations:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
	<tr>
	<td>
	<textarea name="RELATEDCONVERSATIONS" ID="RELATEDCONVERSATIONS" cols="40" rows="8">
		<xsl:choose>
		<!-- pre-populate the form GuideML -->
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK TYPE="logo" DNAID="A2228348"&gt;delays gig&lt;/LINK&gt;&lt;TYPE&gt;by sharp9&lt;/TYPE&gt;</xsl:when>
		<!-- get the value of the usefulinks tag -->		
		<xsl:otherwise>
			<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDCONVERSATIONS']/VALUE-EDITABLE"/></xsl:otherwise>
		</xsl:choose>
	</textarea>
	</td></tr>	
	<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='RELATEDREVIEWS']/ERRORS/ERROR">
			<font color="#FF0000">* <b>related member reviews:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>related member reviews:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>
	<tr>
	<td>
	<textarea name="RELATEDREVIEWS" ID="RELATEDREVIEWS" cols="40" rows="8">
		<xsl:choose>
		<!-- pre-populate the form GuideML -->
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK TYPE="logo" DNAID="A2228348"&gt;delays gig&lt;/LINK&gt;&lt;TYPE&gt;by sharp9&lt;/TYPE&gt;</xsl:when>
		<!-- get the value of the usefulinks tag -->		
		<xsl:otherwise>
			<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDREVIEWS']/VALUE-EDITABLE"/></xsl:otherwise>
		</xsl:choose>
	</textarea>
	</td></tr>

	<tr><td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='ALSOONBBC']/ERRORS/ERROR">
			<font color="#FF0000">* <b>also on bbc.co.uk:</b></font>
			</xsl:when>
			<xsl:otherwise>
			<b>also on bbc.co.uk:</b>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:element>
	</td></tr>	
		<tr><td>
		<textarea name="ALSOONBBC" ID="ALSOONBBC" cols="40" rows="8">
				<xsl:choose>
				<!-- pre-populate the form GuideML -->
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK TYPE="logo" HREF="http://www.bbc.co.uk/6music/artists/delays/"&gt;delays&lt;/LINK&gt;&lt;TYPE&gt;on 6music&lt;/TYPE&gt;</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="MULTI-ELEMENT[@NAME='ALSOONBBC']/VALUE-EDITABLE"/>
				</xsl:otherwise>
				</xsl:choose>
			</textarea>
		</td></tr>	
		</table>
		
		
		</td>
		</tr>
	</table>
	</div>
	</xsl:template>
	
</xsl:stylesheet>
