<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
 
 	<xsl:template match="COMMENT" mode="object_contacts_contact">
		<tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>		
			<td>
				<xsl:apply-templates select="DATEPOST" mode="library_time_shortformat" />
				<span class="date">
					<xsl:apply-templates select="DATEPOST" mode="library_date_shortformat" />
				</span>
				<xsl:value-of select="CREATED/AGO"/>
			</td>
			
			<td>
				<xsl:apply-templates select="TEXT" mode="library_Richtext" />
			</td>
			
			<td>
				<xsl:value-of select="USER/SITESPECIFICDISPLAYNAME"/>
				<xsl:value-of select="USER/DISPLAYNAME"/>
			</td>
		</tr>
	</xsl:template>
	   
	<xsl:template match="COMMENT" mode="object_comments_comment">
		<tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>		
			<td>
				<xsl:apply-templates select="DATEPOST" mode="library_time_shortformat" />
				<span class="date">
					<xsl:apply-templates select="DATEPOST" mode="library_date_shortformat" />
				</span>
				<xsl:value-of select="CREATED/AGO"/>
			</td>
			
			<td>
				<xsl:apply-templates select="TEXT" mode="library_GuideML"/>
				<br/>
				and is 
				<b><xsl:choose>
					<xsl:when test="ISEDITORPICK='false'"> not an editor pick </xsl:when>
					<xsl:otherwise> an editor pick </xsl:otherwise>
				</xsl:choose> </b>
			</td>
			
			<td>
				<xsl:value-of select="USER/SITESPECIFICDISPLAYNAME"/>
				<xsl:value-of select="USER/DISPLAYNAME"/>
			</td>
			
			<td>
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:choose>	
							<xsl:when test="COMPLAINTURI = ''">
								<xsl:value-of select="COMPLAINTURI" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="COMPLAINTURI" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="COMPLAINTURI"/>
				</a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
