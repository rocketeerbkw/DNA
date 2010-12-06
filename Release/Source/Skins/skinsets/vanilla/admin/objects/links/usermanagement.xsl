<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_usermanagement">
		<ul class="dna-list-links">
			<li><a href="/dna/moderation/admin/userlist">Look up user</a></li>
			<li><a href="/dna/moderation/us">Look up users' <xsl:value-of select="$dashboardposttype" />s</a></li>
			<li><a href="/dna/moderation/moderatormanagement">Add user status</a></li>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>