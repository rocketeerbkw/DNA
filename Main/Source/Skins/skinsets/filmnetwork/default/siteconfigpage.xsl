<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-siteconfigpage.xsl"/>
        <xsl:variable name="configfields">
                <![CDATA[
	<MULTI-INPUT>
	        <ELEMENT NAME='MOSTWATCHED'></ELEMENT>
        	        <ELEMENT NAME='SUBMITFILM'></ELEMENT>
                                     <ELEMENT NAME='RECENTRELEASES'></ELEMENT>
	        <ELEMENT NAME='INDUSTRYPANELFAVOURITES'></ELEMENT>
	        <ELEMENT NAME='NEWSLETTER'></ELEMENT>
	        <ELEMENT NAME='DISCUSSIONSPROMO'></ELEMENT>
	        <ELEMENT NAME='FILMMAKERSINDEX'></ELEMENT>
	        <ELEMENT NAME='LEFTHANDNAV'></ELEMENT>
	        <ELEMENT NAME='PULSESURVEY'></ELEMENT>
	</MULTI-INPUT>
                ]]>
        </xsl:variable>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="SITECONFIG-EDITOR_MAINBODY">
                <font size="2">
                        <a href="{$root}Siteconfig?_msxml={$configfields}">Initialise fields</a>
                        <br/> Site - <xsl:value-of select="SITECONFIG-EDIT/URLNAME"/>
                        <xsl:apply-templates mode="c_siteconfig" select="ERROR"/>
                        <xsl:apply-templates mode="c_siteconfig" select="SITECONFIG-EDIT"/>
                </font>
        </xsl:template>
        <xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">
                <table>
                        <tr>
                                <td>
                                        <input name="_msfinish" type="hidden" value="yes"/>
                                        <input name="_msxml" type="hidden" value="{$configfields}"/> Most watched shorts: <br/>
                                        <textarea cols="40" name="mostwatched" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MOSTWATCHED'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'MOSTWATCHED']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MOSTWATCHED']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <br/>
                <br/>
                <table>
                        <tr>
                                <td> Submit Film Gif: <br/>
                                        <textarea cols="40" name="submitfilm" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'SUBMITFILM'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'SUBMITFILM']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/></td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='SUBMITFILM']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <br/>
                <br/>
                <table>
                        <tr>
                                <td> Recent Releases: <br/>
                                        <textarea cols="40" name="recentreleases" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'RECENTRELEASES'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'RECENTRELEASES']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/></td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE/DRAMA"/>
                                        <img alt="" class="tiny" height="5" src="f/t.gif" width="1"/>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE/COMEDY"/>
                                        <img alt="" class="tiny" height="5" src="f/t.gif" width="1"/>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE/DOCUMENTARY"/>
                                        <img alt="" class="tiny" height="5" src="f/t.gif" width="1"/>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE/EXPERIMENTAL"/>
                                        <img alt="" class="tiny" height="5" src="f/t.gif" width="1"/>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='RECENTRELEASES']/VALUE/ANIMATION"/>
                                </td>
                        </tr>
                </table>
                <table>
                        <tr>
                                <td> Industry Panel Favourites: <br/>
                                        <textarea cols="40" name="industrypanelfavourites" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'INDUSTRYPANELFAVOURITES'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'INDUSTRYPANELFAVOURITES']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='INDUSTRYPANELFAVOURITES']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <table>
                        <tr>
                                <td> Newsletter: <br/>
                                        <textarea cols="40" name="newsletter" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'NEWSLETTER'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'NEWSLETTER']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='NEWSLETTER']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <table>
                        <tr>
                                <td> Discussions Promo: <br/>
                                        <textarea cols="40" name="discussionspromo" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'DISCUSSIONSPROMO'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'DISCUSSIONSPROMO']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='DISCUSSIONSPROMO']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <table>
                        <tr>
                                <td> Filmmakers Guide Index: <br/>
                                        <textarea cols="40" name="filmmakersindex" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'FILMMAKERSINDEX'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'FILMMAKERSINDEX']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='FILMMAKERSINDEX']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <table>
                        <tr>
                                <td>Left Hand Nav:<br/>
                                        <textarea cols="40" name="lefthandnav" rows="8">
                                                <xsl:choose>
                                                        <xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'LEFTHANDNAV'">
                                                                <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'LEFTHANDNAV']/VALUE-EDITABLE"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>Please initialise the site config information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                        <xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='LEFTHANDNAV']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- PULSE SURVEY -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td>pulse survey:<br/>
                                        <input type="checkbox" name="PULSESURVEY">
                                                <xsl:if test="/H2G2/SITECONFIG/PULSESURVEY = 'on'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                        </input>
                                        <br />
                                </td>
                                <td></td>
                                <td></td>
                        </tr>
                </table>
                <input name="_mscancel" type="submit" value="preview"/>
                <xsl:apply-templates mode="t_configeditbutton" select="."/>
        </xsl:template>
        <xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
        <xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
        <xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
        <xsl:template match="ERROR" mode="r_siteconfig">
                <xsl:apply-imports/>
        </xsl:template>
</xsl:stylesheet>
