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
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="page">
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename"> manage your entries/stories</xsl:with-param>
		</xsl:call-template>	
	
		<div class="dna-mb-intro">
			<form action="commentforumlist" method="get">
				<fieldset>
					<label for="dnahostpageurl">Enter BBC URL to filter including <strong>http:// </strong></label>
					<input type="text" name="dnahostpageurl" id="dnahostpageurl">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL">
									<xsl:value-of select="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"/>
								</xsl:when>
								<xsl:otherwise>http://www.bbc.co.uk/</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
					
					<span class="dna-buttons">
						<input type="submit" value="Filter Site"/>
					</span>
				</fieldset>
			</form>
			
			<p>Forum list count: <strong><xsl:value-of select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT"/></strong></p>
		</div>
		
		<xsl:if test="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT != 0">
			<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
				<div class="dna-fl dna-main-full">
					<div class="dna-box">
						<ul class="pagination cfl-pagination">
							<xsl:call-template name="cfl-skip-show"/>
						</ul>
						<div class="dna-fl dna-main-full">
							<table class="dna-dashboard-activity dna-dashboard-cfl">
								<xsl:apply-templates select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM" />
							</table>
							<xsl:choose>
								<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'MaxItemsInPriorityModeration']/VALUE = 0">
									<p>* Please note forums will remain in priority moderation until forum has closed.</p>
								</xsl:when>
								<xsl:otherwise>
									<p>* Please note forums will be removed from priority moderation after <xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'MaxItemsInPriorityModeration']/VALUE" /> posts.</p>
								</xsl:otherwise>
							</xsl:choose>
							
							
						</div>
						<ul class="pagination cfl-pagination">
							<xsl:call-template name="cfl-skip-show"/>
						</ul>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="COMMENTFORUM">
		<tr>
			<xsl:call-template name="objects_stripe" />			
			<th>Host Page URL:</th>
			<td colspan="4">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="HOSTPAGEURL"/>
					</xsl:attribute>
					<xsl:value-of select="HOSTPAGEURL"/>
				</a>
			</td>
		</tr>
		<tr>
			<xsl:call-template name="objects_stripe" />	
			<th>Details</th>
			<th>Mod Status</th>
			<th>Close Date</th>
			<th>Open/Close</th>
			<th>Priority Moderation*</th>
		</tr>
		<tr>
			<xsl:call-template name="objects_stripe" />	   
			<td>
				<h4 class="blq-hide">Entry number <xsl:value-of select="position() + ancestor::COMMENTFORUMLIST/@SKIP " /> </h4>
				<ul>
					<li><strong>Title: </strong><xsl:value-of select="TITLE"/></li>
					<li><strong>Forum ID: </strong><xsl:value-of select="@FORUMID"/></li>
					<li><strong>UID: </strong><xsl:value-of select="@UID"/></li>
					<li><strong>Comment count: </strong><xsl:value-of select="@FORUMPOSTCOUNT"/></li>
				</ul>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<ul>
							<li>
								<label for="dnanewmodstatus1{@UID}">Reactive</label>
								<input type="radio" name="dnanewmodstatus" value="reactive" id="dnanewmodstatus1{@UID}">
									<xsl:if test="MODSTATUS=1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="dnanewmodstatus2{@UID}">Post Moderated</label>
								<input type="radio" name="dnanewmodstatus" value="postmod" id="dnanewmodstatus2{@UID}">
									<xsl:if test="MODSTATUS=2">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input> 
							</li>
							<li>
								<label for="dnanewmodstatus3{@UID}">Pre Moderated</label>
								<input type="radio" name="dnanewmodstatus" value="premod" id="dnanewmodstatus3{@UID}">
									<xsl:if test="MODSTATUS=3">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
						</ul> 
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
							
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<label for="dnanewforumclosedate{@UID}">Format: YYYYMMDD</label>
						<input type="text" name="dnanewforumclosedate" id="dnanewforumclosedate{@UID}" class="cfl-cell-input" value="{CLOSEDATE/DATE/@YEAR}{CLOSEDATE/DATE/@MONTH}{CLOSEDATE/DATE/@DAY}" />
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<ul>
							<li>
								<label for="dnanewcanwrite1{@UID}">Open</label>
								<input type="radio" name="dnanewcanwrite" value="1" id="dnanewcanwrite1{@UID}">
									<xsl:if test="@CANWRITE=1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="dnanewcanwrite0{@UID}">Close</label>
								<input type="radio" name="dnanewcanwrite" value="0" id="dnanewcanwrite0{@UID}">
									<xsl:if test="@CANWRITE=0">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
						</ul>
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<label for="dnafastmod{@UID}" class="blq-hide">Fast Moderation</label>
						<select name="dnafastmod" id="dnafastmod{@UID}">
							<xsl:if test="FASTMOD='1'">
								<option value="enabled"><xsl:attribute name="selected">selected</xsl:attribute>Enabled</option>
								<option value="disabled">Disabled</option>
							</xsl:if>
							<xsl:if test="FASTMOD='0'">
								<option value="enabled">Enabled</option>
								<option value="disabled"><xsl:attribute name="selected">selected</xsl:attribute>Disabled</option>
							</xsl:if>
						</select>
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
		</tr>
	 </xsl:template>

	<xsl:template name="cfl-skip-show">
		<xsl:param name="comments_per_page" select="/H2G2/COMMENTFORUMLIST/@SHOW"/>
		<xsl:param name="page_count" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>
		<xsl:param name="page_label" select="1"/>
		
		<xsl:variable name="skip" select="/H2G2/COMMENTFORUMLIST/@SKIP" />
		<xsl:variable name="show" select="/H2G2/COMMENTFORUMLIST/@SHOW" />
		<xsl:variable name="total_list_count" select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT" />
		<xsl:variable name="page_count_total" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>
		<xsl:variable name="current_page" select="($skip div $show) + 1"/>
		
		<!-- set for navigation range -->
		<xsl:variable name="nav_range" select="10" />
		<xsl:variable name="nav_start" select="floor(($current_page - 1) div $nav_range) * $nav_range"/>
		<xsl:variable name="nav_end" select="$nav_start + $nav_range"/>
		
		<xsl:if test="$page_label = 1">
			<li class="pagenum">Page <strong><xsl:value-of select="$current_page"/></strong> of <strong><xsl:value-of select="$page_count_total"/></strong></li>
		</xsl:if> 
		<xsl:if test="$page_label = 1">
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > 1">
						<a href="commentforumlist?dnaskip=0&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">first page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>first page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > 1">
						<a href="commentforumlist?dnaskip={$skip - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">previous page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&lt; previous page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > $nav_range">
						<a href="commentforumlist?dnaskip={($nav_start - 1) * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
							&lt;&lt; <xsl:value-of select="concat('previous ',$nav_range)" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						&lt;&lt; <xsl:value-of select="concat('previous ',$nav_range)" />
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:if>
		
		<xsl:if test="($page_count > 0) and ($page_label &lt;= $nav_end)">
			<xsl:if test="($page_label > $nav_start) and ($page_label &lt;= $nav_end)">
				<li>
					<a href="commentforumlist?dnaskip={($page_label * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
						<xsl:value-of select="$page_label" />
					</a>
				</li>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="$page_label &lt;= $nav_start">
					<xsl:call-template name="cfl-skip-show">
						<xsl:with-param name="page_count" select="$page_count_total - $nav_start"/>
						<xsl:with-param name="page_label" select="$nav_start + 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cfl-skip-show">
						<xsl:with-param name="page_count" select="$page_count - 1"/>
						<xsl:with-param name="page_label" select="$page_label + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		
		<xsl:if test="$page_label = ($nav_end + 1)">
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $current_page">
						<a href="commentforumlist?dnaskip={$current_page * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">next page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>next page &gt;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $nav_end">
						<a href="commentforumlist?dnaskip={$nav_end * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
							<xsl:value-of select="concat('next ',$nav_range)" /> &gt;&gt;
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('next ',$nav_range)" /> &gt;&gt;
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $current_page">
						<a href="commentforumlist?dnaskip={($page_count_total * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">last page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>last page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
