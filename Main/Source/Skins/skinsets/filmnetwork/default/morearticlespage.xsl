<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morearticlespage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="MOREPAGES_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MOREPAGES_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">morearticlespage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textmedium"><a><xsl:choose>
	<xsl:when test="$ownerisviewer = 1"><xsl:attribute name="href">
	<xsl:value-of select="concat($root,'U',VIEWING-USER/USER/USERID)" /></xsl:attribute><strong>my profile</strong>
	</xsl:when>
	<xsl:otherwise><xsl:attribute name="href"><xsl:value-of select="concat($root,'U',/H2G2/PAGE-OWNER/USER/USERID)" /></xsl:attribute><strong><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" />'s profile</strong></xsl:otherwise>
	</xsl:choose></a> |</span> <span class="textxlarge"><xsl:choose>
				<xsl:when test="ARTICLES/ARTICLE-LIST/@TYPE='USER-RECENT-APPROVED'">
					all my filmography
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
					all my credits
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					all my magazine features
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
					all my submissions
				</xsl:when>
			</xsl:choose></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
<!-- head section -->
	<!-- content top -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
			<td width="635" height="100" valign="top" class="darkboxbg">
			<div class="biogname"><a class="biogname1" href="{$root}U{/H2G2/PAGE-OWNER/USER/USERID}"><strong><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" /></strong></a></div>
			<div class="whattodotitle"><strong><xsl:choose>
				<xsl:when test="ARTICLES/ARTICLE-LIST/@TYPE='USER-RECENT-APPROVED'">
					all my filmography
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
					all my credits
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					all my magazine features
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
					all my submissions
				</xsl:when>
			</xsl:choose></strong></div>
			<div class="topboxcopy"><xsl:choose>
				<xsl:when test="ARTICLES/ARTICLE-LIST/@TYPE='USER-RECENT-APPROVED'">
					Below is a list of your films published on Film Network. 
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
					Below is a list of your credits published on Film Network.
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					Below is a list of your magazine features published on Film Network.
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
					Below is a list of your submissions to Film Network. These submissions are only visible to you and not other members.
				</xsl:when>
			</xsl:choose></div></td>
	  </tr>
	</table>
	<!-- END content top -->
	<!-- angle section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top"><img src="{$imagesource}furniture/topangle.gif" width="635" height="62" alt="" /></td>
		</tr>
	</table>
	<!-- END angle section -->



<!-- END head section -->		
<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td height="300" valign="top">
<!-- LEFT COL MAIN CONTENT -->
<!-- previous / page x of x / next table -->
<table width="371" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="371" height="2"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
  </tr>
  <tr>
  	<td height="8"></td>
  </tr>
  <tr>
    <td width="371" valign="top">
      <table width="371" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="60"><div class="textmedium"><strong><xsl:apply-templates select="ARTICLES" mode="r_previouspages"/></strong></div></td>
          <td align="center" width="251"><!-- <div class="textmedium"><strong>page 1 of 10</strong></div> --></td>
          <td align="right" width="60"><div class="textmedium"><strong><xsl:apply-templates select="ARTICLES" mode="r_morepages"/></strong></div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="371" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
  </tr>
</table>
<!-- END previous / page x of x / next table -->

<!-- ARTICLE table -->
<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/> 
<!-- END ARTICLE table -->

<!-- previous / page x of x / next table -->
	<table width="371" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="371" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
	  </tr>
	  <tr>
		<td width="371" valign="top">
		  <table width="371" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td width="60"><div class="textmedium"><strong><xsl:apply-templates select="ARTICLES" mode="r_previouspages"/></strong></div></td>
			  <td align="center" width="251"><!-- <div class="textmedium"><strong>page 1 of 10</strong></div> --></td>
			  <td align="right" width="60"><div class="textmedium"><strong><xsl:apply-templates select="ARTICLES" mode="r_morepages"/></strong></div></td>
			</tr>
		  </table></td>
	  </tr>
	  <tr>
		<td width="371" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
	  </tr>
	</table>
<!-- END previous / page x of x / next table -->
<!-- back to my profile rollover -->
	<div class="finalsubmit"><a><xsl:attribute name="href">	
	<xsl:value-of select="concat($root,'U',PAGE-OWNER/USER/USERID)" /></xsl:attribute>
	<xsl:choose>
	<xsl:when test="$ownerisviewer = 1">
	<div class="textmedium"><strong>back to my profile</strong>&nbsp;<xsl:copy-of select="$next.arrow" /></div>
	</xsl:when>
	<xsl:otherwise><strong>back to <xsl:value-of select="concat(PAGE-OWNER/USER/FIRSTNAMES,' ',PAGE-OWNER/USER/LASTNAME)" />'s profile</strong>&nbsp;<xsl:copy-of select="$next.arrow" /></xsl:otherwise>
	</xsl:choose>
	<!-- <img src="{$imagesource}furniture/backprofile1.gif" width="286" height="22" name="backprofile" alt="back to my profile" /> --></a></div>
<!-- END back to my profile rollover -->
<!-- END LEFT COL MAIN CONTENT -->
			</td>
            <td><!-- 20px spacer column --></td>
            
          <td valign="top"> 
			&nbsp;

          </td>
          </tr>
        </table>
  
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE-LIST Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
	Description: Presentation of the object holding the list of articles
	 -->
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
	
		<xsl:choose>
		<!-- status 1 -->
			<xsl:when test="@TYPE='USER-RECENT-APPROVED'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					<!-- All magazine features -->
						<xsl:for-each select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID=63]">
							<xsl:choose>
								<xsl:when test="position(  ) mod 2 = 0">
									<div class="even">
										<xsl:call-template name="USER_FEATURES_ENTRY" />
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="odd">
										<xsl:call-template name="USER_FEATURES_ENTRY" />
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
					<!-- All my Filmography -->
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<!-- if an editor display all film network recent approval-->
								<xsl:for-each select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE[SITEID= $site_number]">		
									<xsl:choose>
										<xsl:when test="position(  ) mod 2 = 0">
											<div class="even">
												<xsl:call-template name="USER_FILMOGRAPHY_ENTRY" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<div class="odd">
												<xsl:call-template name="USER_FILMOGRAPHY_ENTRY" />
											</div>
										</xsl:otherwise>
									</xsl:choose>		
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<!-- otherwise (if not editor) only display all film network recent approval that are films (i.e EXTRAINFO/TYPE@ID begins with a 3)-->
							<xsl:for-each select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE[SITEID= $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=3]]">		
									<xsl:choose>
										<xsl:when test="position(  ) mod 2 = 0">
											<div class="even">
												<xsl:call-template name="USER_FILMOGRAPHY_ENTRY" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<div class="odd">
												<xsl:call-template name="USER_FILMOGRAPHY_ENTRY" />
											</div>
										</xsl:otherwise>
									</xsl:choose>		
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- NOT status 1-->
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
				<!-- All my Credits -->
				<xsl:for-each select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE[SITEID=$site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=7]]">
					<xsl:choose>
						<xsl:when test="position(  ) mod 2 = 0">
							<div class="even">
								<xsl:call-template name="USER_CREDITS_ENTRY" />
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="odd">
								<xsl:call-template name="USER_CREDITS_ENTRY" />
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
				<!-- All my Credits -->
				<ul class="submmissions">
					<xsl:for-each select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE[SITEID = $site_number][(EXTRAINFO/TYPE/@ID[substring(.,1,1)=3] and EXTRAINFO/TYPE/@ID!=3001) or EXTRAINFO/TYPE/@ID[substring(.,1,1)=5]]">
						<xsl:choose>
							<xsl:when test="position(  ) mod 2 = 0">
							<li class="even">
								<xsl:call-template name="USER_SUBMISSIONS_ENTRY" />
							</li>
							</xsl:when>
							<xsl:otherwise>
							<li class="odd">
								<xsl:call-template name="USER_SUBMISSIONS_ENTRY" />
							</li>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</ul>
			</xsl:when>			
		</xsl:choose>
		
		<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		type:<xsl:value-of select="@TYPE" /><br />
		more:<xsl:value-of select="@MORE" /><br />
		skipto:<xsl:value-of select="@SKIPTO" /><br />
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>article title</th>
			<th>type</th>
			<th>status</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="ARTICLE">
			<tr>
			<td><xsl:value-of select="../@SKIPTO + position()"/></td>
			<td><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS" /></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
		</div>
		
		</xsl:if>
	</xsl:template>

	
	<!-- 
	<xsl:template match="ARTICLES" mode="r_previouspages">
	Use: Creates a 'More recent' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_previouspages">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"> -->
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@SKIPTO &gt; 0]">
		<xsl:copy-of select="$previous.arrow" />&nbsp;<a>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(ARTICLE-LIST/@SKIPTO) - number(ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="@WHICHSET"/>
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
					&amp;s_iscredit=yes
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					&amp;s_isfeature=yes
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
					&amp;s_issubmission=yes
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:copy-of select="$m_newerentries"/>
		</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_newerentries"/>
		</xsl:otherwise>
		</xsl:choose>
	<!-- </xsl:element> -->
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLES" mode="r_morepages">
	Use: Creates a 'Older' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_morepages">
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@MORE=1]">
			<a>
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(ARTICLE-LIST/@SKIPTO) + number(ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="@WHICHSET"/>
			<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_iscredit']/VALUE = 'yes'">
					&amp;s_iscredit=yes
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_isfeature']/VALUE = 'yes'">
					&amp;s_isfeature=yes
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_issubmission']/VALUE = 'yes'">
					&amp;s_issubmission=yes
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:copy-of select="$m_olderentries"/>
		</a><xsl:text>  </xsl:text><xsl:copy-of select="$next.arrow" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_olderentries"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
	Use: Creates a link to load a morepages page showing only cancelled entries
		  created by the viewer
	-->
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
		<div class="boxactionback1">
		<div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
		</xsl:element>
		</div>
		</div>
	</xsl:template>
	
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1">
		<a href="{$root}U{@USERID}" xsl:use-attribute-sets="mARTICLES_t_backtouserpage">
			<xsl:copy-of select="$m_FromMAToPSText"/>
		</a>		
		</div>
		</xsl:element>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
