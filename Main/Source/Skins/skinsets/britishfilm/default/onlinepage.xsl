<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-onlinepopup.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ONLINE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ONLINE_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">onlinepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	<div id="mainbansec">
		<div class="banartical"><h3>Members currently signed into this site: <strong><xsl:value-of select="count(/H2G2/ONLINEUSERS/ONLINEUSER)"/></strong></h3></div>
		<div class="clear"></div>
		<div class="searchline"><div></div></div>
	</div>
				
	
	<div class="mainbodysec">
		<div class="bodysec" id="onlinepage">
		
		<h4 id="membername">MEMBER NAME</h4>
		<ul class="bodylist">
			<xsl:for-each select="/H2G2/ONLINEUSERS/ONLINEUSER">
			<li>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="position() mod 2 != 0">odd</xsl:when>
						<xsl:otherwise>even</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<a href="U{USER/USERID}"><xsl:value-of select="USER/USERNAME"/></a>
			</li>
			</xsl:for-each>
		</ul>
		
			
		</div><!-- / bodysec -->	
		<div class="additionsec">	
	
			<div class="rhpromo">	
				<h3>NOT SIGNED UP YET?</h3>
				<p>Create your own member page and join in to comment, debate and create...</p>
				
				<ul class="arrow">
				<li><strong><a href="{$sso_registerlink}">
						SIGN ME UP
					</a></strong></li>
				</ul>
				
				
			</div>
			
		</div><!-- /  additionsec -->	
		 
		 
	<div class="clear"></div>
	</div><!-- / mainbodysec -->
	
	<xsl:call-template name="ADVANCED_SEARCH" />
	
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ORDERFORM Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="r_orderform">
	Use: Container for the 'Order by' form
	-->
	<xsl:template match="ONLINEUSERS" mode="r_orderform">
		<xsl:copy-of select="$m_onlineorderby"/>
		<xsl:apply-templates select="@ORDER-BY" mode="t_idbutton"/>
		<xsl:copy-of select="$m_onlineidradiolabel"/>
		<xsl:apply-templates select="@ORDER-BY" mode="t_namebutton"/>
		<xsl:value-of select="$m_onlinenameradiolabel"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ONLINEUSERS Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="id_online">
	Use: Container for online list ordered by id
	-->
	<xsl:template match="ONLINEUSER" mode="id_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="name_online">
	Use: Container for online list ordered by name
	-->
	<xsl:template match="ONLINEUSER" mode="name_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="default_online">
	Use: Container for default online list
	-->
	<xsl:template match="ONLINEUSER" mode="default_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSER" mode="r_online">
	Use: Display information for each username link in the list
	-->
	<xsl:template match="ONLINEUSER" mode="r_online">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fONLINEUSERS_c_orderform"/>
	Use: Attribute set for the form element
	-->
	<xsl:attribute-set name="fONLINEUSERS_c_orderform"/>
	<!-- 
	<xsl:attribute-set name="iORDERBY_t_idbutton"/>
	Use: Attribute set for the id radio button element
	-->
	<xsl:attribute-set name="iORDERBY_t_idbutton"/>
	<!-- 
	<xsl:attribute-set name="iORDERBY_t_namebutton"/>
	Use: Attribute set for the name radio button element
	-->
	<xsl:attribute-set name="iORDERBY_t_namebutton"/>
</xsl:stylesheet>
