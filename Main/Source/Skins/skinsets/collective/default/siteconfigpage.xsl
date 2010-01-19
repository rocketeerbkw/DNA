<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">

]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
        xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
        xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:s="urn:schemas-microsoft-com:xml-data"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-siteconfigpage.xsl"/>
        <xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
        <xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
        <xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
        <xsl:variable name="configfields">
                <![CDATA[
                        <MULTI-INPUT>
	<ELEMENT NAME='ISSUENUMBER'></ELEMENT>
	<ELEMENT NAME='WIN'></ELEMENT>
	<ELEMENT NAME='LASTWEEKWIN'></ELEMENT>
	<ELEMENT NAME='CREATEPAGE'></ELEMENT>
	<ELEMENT NAME='WRITEREVIEW'></ELEMENT>
	<ELEMENT NAME='MUSICFEATURE'></ELEMENT>
	<ELEMENT NAME='PROMO1'></ELEMENT>
	<ELEMENT NAME='PROMO2'></ELEMENT>
	<ELEMENT NAME='PROMO3'></ELEMENT>
	<ELEMENT NAME='FILMFEATURE'></ELEMENT>
	<ELEMENT NAME='MORECULTUREFEATURE'></ELEMENT>
	<ELEMENT NAME='TALKFEATURE'></ELEMENT>
	<ELEMENT NAME='ALBUMWEEK'></ELEMENT>
	<ELEMENT NAME='CINEMAWEEK'></ELEMENT>
	<ELEMENT NAME='MORECULTURE'></ELEMENT>
	<ELEMENT NAME='MOREALBUM'></ELEMENT>
	<ELEMENT NAME='MORECINEMA'></ELEMENT>
	<ELEMENT NAME='MORECULTUREREVIEWS'></ELEMENT>
	<ELEMENT NAME='ARCHIVEPICK'></ELEMENT>
	<ELEMENT NAME='PLAYLIST'></ELEMENT>
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
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">SITECONFIG-EDITOR_MAINBODY test variable =
                                        <xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">siteconfigpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:if test="$test_IsEditor">
                        <xsl:apply-templates mode="c_siteconfig" select="ERROR"/>
                        <xsl:choose>
                                <xsl:when
                                        test="not(SITECONFIG-EDIT/MULTI-STAGE[descendant::MULTI-ELEMENT!=''])">
                                        <form action="siteconfig" method="post"
                                                xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
                                                <input name="_msxml" type="hidden" value="{$configfields}"/>
                                                <input type="submit" value="initialise siteconfig"/>
                                        </form>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:apply-templates mode="c_siteconfig" select="SITECONFIG-EDIT"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:if>
        </xsl:template>
        <xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">
                <input name="_msfinish" type="hidden" value="yes"/>
                <!--  <input type="hidden" name="skin" value="purexml"/>  -->
                <input name="_msxml" type="hidden" value="{$configfields}"/>
                <input name="bob" type="submit" value="submit"/>
                <input name="_mscancel" type="submit" value="preview"/>
                <br/>
                <br/>
                <!-- ISSUENUMBER -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>issuenumber:</b>
                                        <br/>
                                        <textarea cols="60" name="ISSUENUMBER" rows="2" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'ISSUENUMBER'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ISSUENUMBER']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ISSUENUMBER']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- WIN -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>Win:</b>
                                        <br/>
                                        <textarea cols="60" name="WIN" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'WIN'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='WIN']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='WIN']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- LASTWEEKWIN -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>Last weeks winners:</b>
                                        <br/>
                                        <textarea cols="60" name="LASTWEEKWIN" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'LASTWEEKWIN'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='LASTWEEKWIN']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                        <br/>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='LASTWEEKWIN']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- CREATE PAGE -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>Create page:</b>
                                        <br/>
                                        <textarea cols="60" name="CREATEPAGE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'CREATEPAGE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CREATEPAGE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CREATEPAGE']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- WRITEREVIEW -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>write a review:</b>
                                        <br/>
                                        <textarea cols="60" name="WRITEREVIEW" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'WRITEREVIEW'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='WRITEREVIEW']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='WRITEREVIEW']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- PROMO1 -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>feature1:</b>
                                        <br/>
                                        <textarea cols="60" name="PROMO1" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROMO1'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO1']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO1']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- PROMO2 -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>feature2:</b>
                                        <br/>
                                        <textarea cols="60" name="PROMO2" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROMO2'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO2']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO2']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- PROMO3 -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>feature3:</b>
                                        <br/>
                                        <textarea cols="60" name="PROMO3" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PROMO3'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO3']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PROMO3']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- MUSIC FEATURE -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>music feature:</b>
                                        <br/>
                                        <textarea cols="60" name="MUSICFEATURE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MUSICFEATURE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MUSICFEATURE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MUSICFEATURE']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- FILM FEATURE -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>film feature:</b>
                                        <br/>
                                        <textarea cols="60" name="FILMFEATURE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'FILMFEATURE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='FILMFEATURE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='FILMFEATURE']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- MORE CULTURE FEATURE -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>more culture feature:</b>
                                        <br/>
                                        <textarea cols="60" name="MORECULTUREFEATURE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MORECULTUREFEATURE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTUREFEATURE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTUREFEATURE']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- TALK FEATURE FEATURE -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>talk promo feature:</b>
                                        <br/>
                                        <textarea cols="60" name="TALKFEATURE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TALKFEATURE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TALKFEATURE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TALKFEATURE']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- ALBUM OF THE WEEK  -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>album of the week:</b>
                                        <br/>
                                        <textarea cols="60" name="ALBUMWEEK" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'ALBUMWEEK'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ALBUMWEEK']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ALBUMWEEK']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- CINEMA OF THE WEEK -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>cinema of the week:</b>
                                        <br/>
                                        <textarea cols="60" name="CINEMAWEEK" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'CINEMAWEEK'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CINEMAWEEK']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CINEMAWEEK']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- MORE CULTURE OF THE WEEK -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>more culture of the week:</b>
                                        <br/>
                                        <textarea cols="60" name="MORECULTURE" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MORECULTURE'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTURE']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTURE']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- MORE ALBUMS OF THE WEEK -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>more albums of the week:</b>
                                        <br/>
                                        <textarea cols="60" name="MOREALBUM" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MOREALBUM'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MOREALBUM']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MOREALBUM']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- MORE CINEMA OF THE WEEK -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>more cinema of the week :</b>
                                        <br/>
                                        <textarea cols="60" name="MORECINEMA" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MORECINEMA'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECINEMA']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECINEMA']/VALUE"/>
                                </td>
                        </tr>
                </table>
                <!-- MORE CULTURE REVIEWS -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>more culture reviews :</b>
                                        <br/>
                                        <textarea cols="60" name="MORECULTUREREVIEWS" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MORECULTUREREVIEWS'">
                                                       <xsl:value-of
                                                       select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTUREREVIEWS']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MORECULTUREREVIEWS']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
                <!-- ARCHIVE PICK -->
                <table border="1" cellpadding="2" cellspacing="2">
                        <tr>
                                <td valign="top">
                                        <b>archive pick:</b>
                                        <br/>
                                        <textarea cols="60" name="ARCHIVEPICK" rows="5" type="text">
                                                <xsl:choose>
                                                       <xsl:when
                                                       test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'ARCHIVEPICK'">
                                                               <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ARCHIVEPICK']/VALUE-EDITABLE"
                                                       />
                                                       </xsl:when>
                                                       <xsl:otherwise>Please initialise the site config
                                                       information</xsl:otherwise>
                                                </xsl:choose>
                                        </textarea>
                                </td>
                                <td valign="top">
                                        <xsl:apply-templates
                                                select="MULTI-STAGE/MULTI-ELEMENT[@NAME='ARCHIVEPICK']/VALUE"
                                        />
                                </td>
                        </tr>
                </table>
        <!-- PLAYLIST -->
        <table border="1" cellpadding="2" cellspacing="2">
                <tr>
                        <td valign="top">
                                <b>playlist:</b>
                                <br/>
                                <textarea cols="60" name="PLAYLIST" rows="5" type="text">
                                        <xsl:choose>
                                                <xsl:when
                                                        test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'PLAYLIST'">
                                                        <xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PLAYLIST']/VALUE-EDITABLE"
                                                        />
                                                </xsl:when>
                                                <xsl:otherwise>Please initialise the site config
                                                        information</xsl:otherwise>
                                        </xsl:choose>
                                </textarea>
                        </td>
                        <td valign="top">
                                <xsl:apply-templates
                                        select="MULTI-STAGE/MULTI-ELEMENT[@NAME='PLAYLIST']/VALUE"
                                />
                        </td>
                </tr>
        </table>
                <!-- EDIT BUTTON -->
                <!--xsl:apply-templates select="." mode="t_configeditbutton"/-->
                <!--input type="hidden" name="skin" value="purexml"/-->
                <input name="bob" type="submit" value="submit"/>
                <input name="_mscancel" type="submit" value="preview"/>
        </xsl:template>
        <xsl:template match="ERROR" mode="r_siteconfig">
                <xsl:apply-imports/>
        </xsl:template>
</xsl:stylesheet>
