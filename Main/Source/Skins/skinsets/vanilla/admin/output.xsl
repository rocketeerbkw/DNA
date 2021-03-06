<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Kick off stylesheet called directly by DNA 
        </doc:purpose>
        <doc:context>
            n/a
        </doc:context>
        <doc:notes>
            Bridges the jump between the old skin architecture and the new.
            Combines the Messageboard admin tool and the Host Dashboard skins.
        </doc:notes>
    </doc:documentation>
	
	<xsl:include href="includes.xsl"/>
	
	<xsl:output
		method="html"
		version="4.0"
		omit-xml-declaration="yes"
		standalone="yes"
		indent="yes"
		encoding="UTF-8"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	/>
	
	<xsl:variable name="smileys" select="''"/>
    
	<xsl:template match="H2G2">
	<xsl:choose>
		<xsl:when test="ERROR[@TYPE='Access Denied']">
			<xsl:apply-templates select="/H2G2[@TYPE != 'ERROR']/ERROR" mode="page"/>
		</xsl:when>
		<xsl:otherwise>
		<html xml:lang="en-GB" lang="en-GB">
			<head profile="http://dublincore.org/documents/dcq-html/">
				<title>
					<xsl:choose>
						<xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
							<xsl:apply-templates select="." mode="objects_browsertitle"/>
							<xsl:call-template name="objects_browsertitle" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('BBC - ', /H2G2/SITECONFIG/BOARDNAME, ' messageboards - Boards Admin')"/>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
       
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
					<xsl:choose>
						<xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
							<meta http-equiv="refresh" content="0;url={$host}{$root}/hostdashboard" />
						</xsl:when>
						<xsl:otherwise>
							<meta http-equiv="refresh" content="0;url={$host}{$root}/mbadmin?s_mode=admin" />
						</xsl:otherwise>
					</xsl:choose>
		        </xsl:if>
		        
				<meta name="description" content="" />
				<meta name="keywords" content="" />
				<link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
				<link type="image/x-icon" href="/favicon.ico" rel="icon"/>
				<meta name="DCTERMS.created" content="2006-09-15T12:00:00Z" />
				<meta name="DCTERMS.modified" content="2006-09-15T12:35:00Z" />

				<xsl:choose>
					<xsl:when test="SITE/IDENTITYSIGNIN = 1">
						<xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:comment>#set var="blq_https" value="1"</xsl:comment>
				<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
				
				<script type="text/javascript" src="/dnaimages/dna_messageboard/javascript/admin.js"><xsl:text> </xsl:text></script>
				<link type="text/css" rel="stylesheet" href="/dnaimages/dna_messageboard/style/admin.css"/>
			</head>
			
			<body>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="@TYPE='ERROR' or @TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN'">
							<xsl:text>boardsadmin</xsl:text> 
						</xsl:when>
						<xsl:otherwise>dna-dashboard</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$dashboardtype" />
				</xsl:attribute>
				<xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
				
				<div id="blq-local-nav" class="nav blq-clearfix">
					<xsl:apply-templates select="." mode="objects_title"/>
					<xsl:call-template name="objects_title" />
					<xsl:call-template name="objects_links_tabs" />
				</div>
   
				<div id="blq-content">
					<xsl:if test="/H2G2[@TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN' or @TYPE = 'MESSAGEBOARDSCHEDULE']">
						<xsl:choose>
							<xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
								<xsl:call-template name="emergency-stop"><xsl:with-param name="type" select="'SITE'" /></xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="emergency-stop"><xsl:with-param name="type" select="'BOARD'" /></xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					
					<xsl:apply-templates select="/H2G2[@TYPE != 'ERROR']/ERROR" mode="page"/>
					<xsl:apply-templates select="/H2G2/RESULT" mode="page"/>
					<xsl:apply-templates select="." mode="page"/>
				</div>

				<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>
			
			</body>
		</html>
		</xsl:otherwise>
	</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="emergency-stop">
		<xsl:param name="type"></xsl:param>
		<div class="dna-emergency-stop">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/SITECLOSED[@EMERGENCYCLOSED = '0']">
					<p>
						<a href="{$root}/MessageBoardSchedule?action=CloseSite&amp;confirm=1" class="dna-stop">
						<strong>CLOSE <xsl:value-of select="$type"/>
						</strong>
						Board closed to all new posts,<br />except from editor accounts
						</a>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<a href="{$root}/MessageBoardSchedule?action=OpenSite&amp;confirm=1" class="dna-go">
						<strong>RE-OPEN <xsl:value-of select="@type"/></strong>
						Allow all posts to this messageboard
						</a>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
    
</xsl:stylesheet>