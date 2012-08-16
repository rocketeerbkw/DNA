<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0" 
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
    exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Hacked to output Barlesque - proper Vanilla Integration will remedy this.
        </doc:notes>
    </doc:documentation>

    <xsl:template match="/H2G2[@TYPE = 'USER-COMPLAINT'] | /H2G2[@TYPE = 'USERCOMPLAINTPAGE']" mode="page">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"></xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-Hant" lang="zh-Hant">
            <head profile="http://dublincore.org/documents/dcq-html/">
                
                <title>BBC 中文網 - 投訴</title>
                
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <meta name="description" content="" />
                <meta name="keywords" content="" />
                
                <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
                <meta name="dcterms.created" content="2006-09-15T12:00:00Z" />
                <meta name="dcterms.modified" content="2006-09-15T12:35:00Z" />
                
                <link rel="index" href="/a-z/" />
                <link rel="help" href="/help/" />
                <link rel="copyright" href="/terms/" />
                <link rel="icon" href="/favicon.ico" type="image/x-icon" />
                
                <xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
                
                <link rel="stylesheet" href="/dnaimages/components/barlesque_thin/style/complaints.css" type="text/css" />
				<link rel="stylesheet" href="/worldservice/comments/zh-hant_complaints.css" type="text/css" />

            	<script type="text/javascript" src="/dnaimages/javascript/DNA.js"/>
            	
            	<script type="text/javascript">
            		gloader.load(["glow", "1", "glow.forms"]);
            	</script>
                
                <style type="text/css">
                    
                    /* Hack barlesque to make thin version */
                    #blq-container {background:transparent url(/dnaimages/components/barlesque_thin/img/body_bg_popup.png) repeat-y center top;}
                    #blq-accesslinks, #blq-masthead, #blq-footer, #blq-main { width:654px;}
                    #blq-main { background:#dbdbdb; padding:0 0 14px 0; color:#5F5F5F;}
                </style>
                
                <!--[if IE 6]>
                    <style type="text/css">
                    /*Force layout to counter ie6 float bug*/
                    p.options label {margin:3px 0 0 0; border:1px solid #fff;}
                    p.options input {float: none;}
                    </style>
                    <![endif]-->
                
            </head>
            <body>
                
                <div id="blq-container">
                    <div id="blq-main">
                        
                        <h1>BBC 中文網 - 投訴</h1>
                        
                        <xsl:apply-templates select="USER-COMPLAINT-FORM | USERCOMPLAINT | ERROR" mode="input_user-complaint-form" />
                        
                    </div>	
                    
                </div>	
            </body>
        </html>
        
        
    </xsl:template>

</xsl:stylesheet>