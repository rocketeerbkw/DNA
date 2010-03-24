<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-noticeboardpage.xsl"/>
	<xsl:template name="NOTICEBOARD_MAINBODY">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="NOTICEBOARD" mode="c_display"/>
			<xsl:apply-templates select="NOTICEBOARD" mode="c_create"/>
		</font>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_create">
		<xsl:apply-templates select="/H2G2/NOTICEBOARD/ERROR" mode="c_noticeboard"/>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<xsl:template match="ERROR" mode="r_noticeboard">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="full_display">
		<b>Welcome to the <xsl:value-of select="LOCALAREAINFO/TITLE"/> notice board</b>
		<br/>
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="." mode="t_createnotice"/>
			<br/>
			<xsl:apply-templates select="." mode="t_createevent"/>
			<br/>
			<xsl:apply-templates select="." mode="c_createalert"/>
			<xsl:apply-templates select="." mode="t_createwanted"/>
			<br/>
			<xsl:apply-templates select="." mode="t_createoffer"/>
			<b>Notices</b>
			<br/>
			<xsl:apply-templates select="NOTICES" mode="c_noticeboard"/>
			<b>Events</b>
			<br/>
			<xsl:apply-templates select="EVENTS" mode="c_eventsboard"/>
		</font>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_createalert">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="NOTICES" mode="full_noticeboard">
		<xsl:apply-templates select="NOTICE" mode="c_noticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICES" mode="empty_noticeboard">
		<xsl:copy-of select="$m_emptynotices"/>
	</xsl:template>
	<xsl:template match="EVENTS" mode="full_eventsboard">
		<xsl:apply-templates select="EVENT" mode="c_eventsboard"/>
	</xsl:template>
	<xsl:template match="EVENTS" mode="empty_eventsboard">
		<xsl:copy-of select="$m_emptyevents"/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************           NOTICES         ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="NOTICE" mode="notice_noticeboard">
		<table border="1">
			<tr>
				<td>
					<b>Notice</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
					Date:<xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						<xsl:apply-templates select="USER/USERNAME" mode="c_notice"/>
	
		Title: <xsl:value-of select="TITLE"/>
						<br/>
		Body: 
		<xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="NOTICEVOTES" mode="c_notice"/>
		[<xsl:value-of select="NOTICEVOTES/VISIBLE"/>] others support this<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_notice">
		User: <xsl:apply-imports/>
		says:<br/>
	</xsl:template>
	<xsl:template match="NOTICEVOTES" mode="r_notice">
		Votes:<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_editnotice">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_moderatehistorynotice">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_complainnotice">
		If you think this notice contravenes our house rules, <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************           EVENTS          ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="NOTICE" mode="event_noticeboard">
		<table border="1">
			<tr>
				<td>
					<b>Event</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						User: <xsl:apply-templates select="USER/USERNAME" mode="c_event"/>
						
						Date closing: <xsl:apply-templates select="DATECLOSING" mode="c_dateofevent"/>
						
						Title: <xsl:value-of select="TITLE"/>
						<br/>			
						Body: <xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_event">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="r_dateofevent">
		<xsl:apply-templates select="DATE"/>
		<br/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************           ALERTS          ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="NOTICE" mode="alert_noticeboard">
		<table border="1">
			<tr>
				<td>
					<b>Alert</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						Date: <xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						Date closing<xsl:apply-templates select="DATECLOSING" mode="c_dateofalert"/>
						<br/>
						Title:<b>
							<xsl:value-of select="TITLE"/>
						</b>
						<br/>
						Body: <xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="r_dateofalert">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************           WANTED          ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="NOTICE" mode="wanted_noticeboard">
		<table border="1">
			<tr>
				<td>
					<b>Wanted</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						Date: <xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						
						User: <xsl:apply-templates select="USER/USERNAME" mode="c_wanted"/>
						<br/>
						Title: <b>
							<xsl:value-of select="TITLE"/>
						</b>
						<br/>
						Body:<xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_wanted">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************           OFFERS          ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="NOTICE" mode="offer_noticeboard">
		<table border="1">
			<tr>
				<td>
					<b>Offered</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						
						Date: <xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						Username: <xsl:apply-templates select="USER/USERNAME" mode="c_offer"/>
						<br/>
						Title:<b>
							<xsl:value-of select="TITLE"/>
						</b>
						<br/>
						Body:<xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_offer">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- ********************************************************************************** -->
	<!-- **********************          EVENTS           ********************************** -->
	<!-- ********************************************************************************** -->
	<xsl:template match="EVENT" mode="r_eventsboard">
		<xsl:variable name="currenteventdate" select="concat(DATECLOSING/DATE/@DAY, DATECLOSING/DATE/@MONTH, DATECLOSING/DATE/@YEAR)"/>
		<xsl:choose>
			<xsl:when test="preceding-sibling::EVENT/DATECLOSING/DATE[concat(@DAY, @MONTH, @YEAR) = $currenteventdate]">
				<!-- If the preceding EVENT is the same as the current one -->
			</xsl:when>
			<xsl:otherwise>
				<br/>
				<b>
					<xsl:apply-templates select="DATECLOSING/DATE"/>
				</b>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Andy I think this is dodgy XSLT!!!!!! -->
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- **************************                Create a Notice                  **************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<xsl:variable name="noticefields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="eventfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										<ELEMENT NAME='YEAR'></ELEMENT>
										<ELEMENT NAME='MONTH'></ELEMENT>
										<ELEMENT NAME='DAY'></ELEMENT>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="alertfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										<ELEMENT NAME='YEAR'></ELEMENT>
										<ELEMENT NAME='MONTH'></ELEMENT>
										<ELEMENT NAME='DAY'></ELEMENT>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="wantedfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="offerfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
										<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:template match="NOTICEBOARD" mode="notice_form">
		<input type="hidden" name="_msfinish" value="yes"/>
		<xsl:apply-templates select="." mode="c_noticepreview"/>
		<b>Title</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_noticesubject"/>
		<br/>
		<b>Body</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_noticebody"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitnotice"/>
		<xsl:apply-templates select="." mode="c_submitpreviewoffer"/>
		<xsl:apply-templates select="." mode="t_returntonoticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitnotice">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewnotice">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="event_form">
		<input type="hidden" name="_msfinish" value="yes"/>
		<xsl:apply-templates select="." mode="c_eventpreview"/>
		<b>Title</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_eventsubject"/>
		<br/>
		<b>Body</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_eventbody"/>
		<br/>
		<br/>
			Date : <xsl:call-template name="DateInput">
			<xsl:with-param name="setday">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='DAY']/VALUE"/>
			</xsl:with-param>
			<xsl:with-param name="setmonth">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='MONTH']/VALUE"/>
			</xsl:with-param>
			<xsl:with-param name="setyear">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='YEAR']/VALUE"/>
			</xsl:with-param>
		</xsl:call-template>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitevent"/>
		<xsl:apply-templates select="." mode="c_submitpreviewevent"/>
		<xsl:apply-templates select="." mode="t_returntonoticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitevent">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewevent">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="alert_form">
		<xsl:apply-templates select="." mode="c_alertpreview"/>
		<input type="hidden" name="_msfinish" value="yes"/>
		<b>Title</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_alertsubject"/>
		<br/>
		<b>Body</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_alertbody"/>
		<br/>
		<br/>
			Date : <xsl:call-template name="DateInput">
			<xsl:with-param name="setday">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='DAY']/VALUE"/>
			</xsl:with-param>
			<xsl:with-param name="setmonth">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='MONTH']/VALUE"/>
			</xsl:with-param>
			<xsl:with-param name="setyear">
				<xsl:value-of select="NOTICEBOARD/MULTI-STAGE/MULTI-ELEMENT[@NAME='YEAR']/VALUE"/>
			</xsl:with-param>
		</xsl:call-template>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitalert"/>
		<xsl:apply-templates select="." mode="c_submitpreviewalert"/>
		<xsl:apply-templates select="." mode="t_returntonoticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitalert">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewalert">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="wanted_form">
		<input type="hidden" name="_msfinish" value="yes"/>
		<xsl:apply-templates select="." mode="c_wantedpreview"/>
		<b>Title</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_wantedsubject"/>
		<br/>
		<b>Body</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_wantedbody"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitwanted"/>
		<xsl:apply-templates select="." mode="c_submitpreviewwanted"/>
		<xsl:apply-templates select="." mode="t_returntonoticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitwanted">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewwanted">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="offer_form">
		<input type="hidden" name="_msfinish" value="yes"/>
		<xsl:apply-templates select="." mode="c_offerpreview"/>
		<b>Title</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_offersubject"/>
		<br/>
		<b>Body</b>
		<br/>
		<xsl:apply-templates select="MULTI-STAGE" mode="t_offerbody"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitoffer"/>
		<xsl:apply-templates select="." mode="c_submitpreviewoffer"/>
		<xsl:apply-templates select="." mode="t_returntonoticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitoffer">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewoffer">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitnotice"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewnotice"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitevent"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewevent"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitalert"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewalert"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitwanted"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewwanted"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitoffer"/>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewoffer"/>
	<xsl:template name="DateInput">
		<xsl:param name="setday">01</xsl:param>
		<xsl:param name="setmonth">01</xsl:param>
		<xsl:param name="setyear">2003</xsl:param>
	Day 
	<select name="day">
			<option value="{$setday}">
				<xsl:value-of select="$setday"/>
			</option>
			<option value="01">01</option>
			<option value="02">02</option>
			<option value="03">03</option>
			<option value="04">04</option>
			<option value="05">05</option>
			<option value="06">06</option>
			<option value="07">07</option>
			<option value="08">08</option>
			<option value="09">09</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17">17</option>
			<option value="18">18</option>
			<option value="19">19</option>
			<option value="20">20</option>
			<option value="21">21</option>
			<option value="22">22</option>
			<option value="23">23</option>
			<option value="24">24</option>
			<option value="25">25</option>
			<option value="26">26</option>
			<option value="27">27</option>
			<option value="28">28</option>
			<option value="29">29</option>
			<option value="30">30</option>
			<option value="31">31</option>
		</select>
	 Month 
	<select name="month">
			<option value="{$setmonth}">
				<xsl:value-of select="$setmonth"/>
			</option>
			<option value="01">01</option>
			<option value="02">02</option>
			<option value="03">03</option>
			<option value="04">04</option>
			<option value="05">05</option>
			<option value="06">06</option>
			<option value="07">07</option>
			<option value="08">08</option>
			<option value="09">09</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
		</select>
	 Year 
	<select name="year" value="{$setyear}">
			<option value="{$setyear}">
				<xsl:value-of select="$setyear"/>
			</option>
			<option value="2003">2003</option>
			<option value="2004">2004</option>
			<option value="2005">2005</option>
			<option value="2006">2006</option>
			<option value="2007">2007</option>
			<option value="2008">2008</option>
			<option value="2009">2009</option>
			<option value="2010">2010</option>
			<option value="2011">2011</option>
			<option value="2012">2012</option>
			<option value="2013">2013</option>
		</select>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_noticepreview">
		<xsl:apply-templates select="NOTICES/NOTICE" mode="notice_noticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_eventpreview">
		<xsl:apply-templates select="NOTICES/NOTICE" mode="event_noticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_alertpreview">
		<xsl:apply-templates select="NOTICES/NOTICE" mode="alert_noticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_wantedpreview">
		<xsl:apply-templates select="NOTICES/NOTICE" mode="wanted_noticeboard"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_offerpreview">
		<xsl:apply-templates select="NOTICES/NOTICE" mode="offer_noticeboard"/>
	</xsl:template>
	<!-- ************************************************************************************************* -->
	<!-- ************************************************************************************************* -->
	<!-- *******************                    Page with single notice               ************************ -->
	<!-- ************************************************************************************************* -->
	<!-- ************************************************************************************************* -->
	<xsl:template match="NOTICEBOARD" mode="single_display">
		<xsl:apply-templates select="EVENTS" mode="c_single"/>
	</xsl:template>
	<xsl:template match="EVENTS" mode="r_single">
		<xsl:apply-templates select="EVENT" mode="c_single"/>
	</xsl:template>
	<xsl:template match="EVENT" mode="r_single">
		<table border="1">
			<tr>
				<td>
					<b>Notice</b>
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						Date posted: <xsl:apply-templates select="DATEPOSTED/DATE"/>
						<br/>
						Dateclosing:<xsl:apply-templates select="DATECLOSING/DATE"/>
						<br/>
						User: <xsl:apply-templates select="USER/USERNAME" mode="c_single"/>
						<br/>
						Title: <xsl:value-of select="TITLE"/>
						<br/>
						Body: 
						<xsl:apply-templates select="GUIDE/BODY"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_complainnotice"/>
						<br/>
						<xsl:apply-templates select="POSTID" mode="c_editnotice"/>
						<xsl:apply-templates select="POSTID" mode="c_moderatehistorynotice"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_single">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
