<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_useful">
		<!-- all live links -->
		<ul class="dna-list-links">
			<xsl:if test="$dashboardtype = 'blog' or $dashboardtype = 'all'">
				<li><a href="https://confluence.dev.bbc.co.uk/display/blogs/Blogs+Platform">Blogs team wiki</a></li>
			</xsl:if>
			<li><a href="http://wikis.gateway.bbc.co.uk/confluence/display/mod/Moderation+Services">Moderation services wiki</a></li>
			<li><a href="http://www.bbc.co.uk/guidelines/editorialguidelines/page/guidance-moderation-summary">Editorial policy guidance for hosts</a></li>	
			<xsl:if test="$dashboardtype = 'blog' or $dashboardtype = 'all'">
				<li><a href="http://www.bbc.co.uk/blogs">Blogs help pages</a></li>
			</xsl:if>
			<xsl:if test="$dashboardtype = 'messageboard' or $dashboardtype = 'all'">
				<li><a href="http://www.bbc.co.uk//messageboards">Messageboard help pages</a></li>
			</xsl:if>
			<li><a href="{$moderationemail}">Contact Moderation Services team</a></li>		
			<li><a href="https://confluence.dev.bbc.co.uk/display/DNA/DNA">DNA team wiki</a></li> <!-- or http://wikis.gateway.bbc.co.uk/confluence/display/DNA/DNA? -->
			<li><a href="http://wikis.gateway.bbc.co.uk/confluence/pages/viewpageattachments.action?pageId=159711330">DNA Hosts' handbooks</a></li>
      <xsl:if test="$dashboardtype = 'twitter' or $dashboardtype = 'all'">
        <li><a href="https://confluence.dev.bbc.co.uk/display/spstweet/Tweet+Module+Admin+Console+User+Guide">Twitter module admin user guide</a></li>
      </xsl:if>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>