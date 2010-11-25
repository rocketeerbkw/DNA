<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

	<doc:documentation>
		<doc:purpose>
			Coverts FORM to form tag
		</doc:purpose>
		<doc:context>
			Applied by _common/_library/GuideML.xsl
		</doc:context>
		<doc:notes>

		</doc:notes>
	</doc:documentation>

	<xsl:template match="FORM | form" mode="library_GuideML">
		<form>
			<xsl:if test="@NAME | @name">
				<xsl:attribute name="name">
					<xsl:value-of select="@NAME | @name"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
		</form>
	</xsl:template>

</xsl:stylesheet>