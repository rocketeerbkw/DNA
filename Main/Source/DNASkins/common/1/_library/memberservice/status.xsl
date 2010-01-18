<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            pagination
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
           working with the show, to and from, calculate the querystring
           
           this desperately needs to be split into its component parts correctly:
           
           logic layer 
            - work out the FORUMTHREAD type, its skip, step or from and to values and compute them into
              a collection of useful parameters for the skin.
              
           site layer
            - take params and work into relelvant links etc
            
            NOTE: If the site is Barlesque-ed, then the Barlesque header will handle all this 
             
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="VIEWING-USER" mode="library_memberservice_status">
        <xsl:param name="ptrt" >
            <xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
        </xsl:param>
        
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin">
                <xsl:choose>
	                <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
	                  <strong>
	                      <xsl:value-of select="USER/USERNAME"/>
	                  </strong>
	                  
	                  <a class="dna-settings">
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_memberservice_settingsurl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Settings</xsl:text>
	                  </a>
	                  <span class="blq-hide">.</span> 
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_memberservice_logouturl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Log out</xsl:text>
	                  </a>
	                  <span class="blq-hide">.</span> 
	                </xsl:when>
	                <xsl:otherwise>
	                  <strong>
	                      <xsl:value-of select="USER/USERNAME"/>
	                  </strong>
	                  
	                  <a class="dna-settings">
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_identity_settingsurl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Settings</xsl:text>
	                  </a>
	                  <span class="blq-hide">.</span> 
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_identity_logouturl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Log out</xsl:text>
	                  </a>
	                  <span class="blq-hide">.</span> 
	                </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="unauthorised">
                <xsl:choose>
                 <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
                  <strong>
                      <xsl:value-of select="SIGNINNAME"/>
                  </strong>
                  
                  <a class="dna-settings">
                      <xsl:attribute name="href">
                          <xsl:apply-templates select="." mode="library_memberservice_settingsurl" >
                              <xsl:with-param name="ptrt" select="$ptrt" />
                          </xsl:apply-templates>
                      </xsl:attribute>
                      <xsl:text>Settings</xsl:text>
                  </a>
                  <span class="blq-hide">.</span> 
                  <a>
                      <xsl:attribute name="href">
                          <xsl:apply-templates select="." mode="library_memberservice_logouturl" >
                              <xsl:with-param name="ptrt" select="$ptrt" />
                          </xsl:apply-templates>
                      </xsl:attribute>
                      <xsl:text>Log out</xsl:text>
                  </a>
                  <span class="blq-hide">.</span> 
                </xsl:when>
                 <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 1">
                  <strong>
                      <xsl:value-of select="SIGNINNAME"/>
                  </strong>
                  
                  <a class="dna-settings">
                      <xsl:attribute name="href">
                          <xsl:apply-templates select="." mode="library_identity_policyurl" >
                              <xsl:with-param name="ptrt" select="$ptrt" />
                          </xsl:apply-templates>
                      </xsl:attribute>
                      <xsl:text>Click here to complete your registration</xsl:text>
                  </a>
                  <span class="blq-hide">.</span> 
                  <a>
                      <xsl:attribute name="href">
                          <xsl:apply-templates select="." mode="library_identity_logouturl" >
                              <xsl:with-param name="ptrt" select="$ptrt" />
                          </xsl:apply-templates>
                      </xsl:attribute>
                      <xsl:text>Log out</xsl:text>
                  </a>
                  <span class="blq-hide">.</span> 
                </xsl:when>                
               </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="loggedout">
               <xsl:choose>
	               <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_memberservice_loginurl">
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Log in</xsl:text>
	                  </a>
	                  <span class="blq-hide"> or </span>
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_memberservice_registerurl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Register</xsl:text>
	                  </a>
	                </xsl:when>
	                <xsl:otherwise>
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_identity_loginurl">
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Log in</xsl:text>
	                  </a>
	                  <span class="blq-hide"> or </span>
	                  <a>
	                      <xsl:attribute name="href">
	                          <xsl:apply-templates select="." mode="library_identity_registerurl" >
	                              <xsl:with-param name="ptrt" select="$ptrt" />
	                          </xsl:apply-templates>
	                      </xsl:attribute>
	                      <xsl:text>Register</xsl:text>
	                  </a>	                
	                </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
        
        
    </xsl:template>
    
</xsl:stylesheet>