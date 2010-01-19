<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:properties common="true"/>
        <doc:purpose>
            Declares any additional Javascript files skin developer wishes to include on a page by page basis
        </doc:purpose>
        <doc:context>
            Applied by index.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>

    <xsl:template match="javascript/file" mode="structure">


        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="$configuration/assetPaths/images"/>
                <xsl:value-of select="."/>
            </xsl:attribute>
        </script>

    </xsl:template>
</xsl:stylesheet>
