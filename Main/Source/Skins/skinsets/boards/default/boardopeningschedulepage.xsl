<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:key name="samedayevents" match="TIME" use="@DAYTYPE"/>
	<!--
	<xsl:template name="MESSAGEBOARDSCHEDULE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MESSAGEBOARDSCHEDULE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA - Opening/Closing Schedule 
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDSCHEDULE_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MESSAGEBOARDSCHEDULE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Opening/Closing Schedule
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDSCHEDULE_JAVASCRIPT">
	Author:		Andy Harris and Wendy Mann (later addition)
	Context:      H2G2
	Purpose:	 The Javascript for the blocking out unselected areas of the form (later addition the script to change the "open for..." bits)
	-->
	<xsl:template name="MESSAGEBOARDSCHEDULE_JAVASCRIPT">
		<script src="http://www.bbc.co.uk/dnaimages/boards/includes/openclose.js"/>
		<script type="text/javascript">
			<xsl:comment>
				function closeAllDay(eventObj)
				{
					if(eventObj.checked)
					{
						var selectArray = eventObj.parentNode.parentNode.cells[2].getElementsByTagName('SELECT'); 
						for (i=0; i &lt; selectArray.length; i++)
						{
							selectArray[i].selectedIndex = 0;
						}
						var selectArray = eventObj.parentNode.parentNode.cells[3].getElementsByTagName('SELECT'); 
						for (i=0; i &lt; selectArray.length; i++)
						{
							selectArray[i].selectedIndex = 0;	
						}
					}
					else
					{
						alert('If you want the site to close during this day please update the opening and closing times before updating.');
					}
				}
			</xsl:comment>
		</script>
	</xsl:template>
	<!--
	<xsl:template match="SCHEDULE" mode="setactivelink">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE  
	Purpose:	 Creates the link for opening and closing the forums immeadiately
	-->
	<xsl:template match="SCHEDULE" mode="setactivelink">
		<xsl:choose>
			<xsl:when test="EVENT[@ACTIVE=0]">
				<a href="{$root}MessageBoardSchedule?action=setactive">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/emergency_reopen.gif" width="131" height="46" alt="Board re-opened" border="0"/>
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}MessageBoardSchedule?action=setinactive">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/emergency_stop.gif" width="131" height="46" alt="Stop the board - emergency closure" border="0"/>
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="SITETOPICSEMERGENCYCLOSED" mode="setactivelink">
	Author:		James Conway
	Context:    H2G2/SITETOPICSSCHEDULE/SITETOPICSEMERGENCYCLOSED
	Purpose:	 Creates the link for the emergency opening or closure of a site's topic forums (via the site's TopicsClosed flag).
	-->
	<xsl:template match="SITETOPICSEMERGENCYCLOSED" mode="setactivelink">
		<xsl:choose>
			<xsl:when test=".=1">
				<a href="{$root}MessageBoardSchedule?action=setsitetopicsactive">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/emergency_reopen.gif" width="131" height="46" alt="Board re-opened" border="0"/>
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}MessageBoardSchedule?action=setsitetopicsinactive">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/emergency_stop.gif" width="131" height="46" alt="Stop the board - emergency closure" border="0"/>
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="backtosettings">
		<a href="{$root}MessageBoardSchedule?action=display">Back to Settings</a>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDSCHEDULE_MAINBODY">
	Author:		Andy Harris
	Context:    H2G2  
	Purpose:	 Mainbody template for the content area
	-->
	<xsl:template name="MESSAGEBOARDSCHEDULE_MAINBODY">
		<xsl:apply-templates select="SITETOPICSSCHEDULE/SCHEDULE" mode="sitetopicsschedule"/>
	</xsl:template>
	<!--
	<xsl:template match="SCHEDULE" mode="sitetopicsschedule">
	Author:		James Conway
	Context:    H2G2/SITETOPICSCHEDULE/SCHEDULE
	Purpose:	 Selects the correct page of the scheduling process
	-->
	<xsl:template match="SCHEDULE" mode="sitetopicsschedule">
		<xsl:choose>
			<xsl:when test="../SCHEDULING-REQUEST='CREATE'">
				<xsl:apply-templates select="." mode="processcreate_sitetopicsschedule"/>
			</xsl:when>
			<xsl:when test="../SCHEDULING-REQUEST='SETSITETOPICSINACTIVE'">
				<xsl:apply-templates select="." mode="confirmsitetopicsinactive_boardschedule"/>
			</xsl:when>
			<xsl:when test="../SCHEDULING-REQUEST='CONFIRMEDSETSITETOPICSINACTIVE'">
				<xsl:apply-templates select="." mode="setsitetopicsinactive_boardschedule"/>
			</xsl:when>
			<xsl:when test="../SCHEDULING-REQUEST='SETSITETOPICSACTIVE'">
				<xsl:apply-templates select="." mode="confirmsitetopicsactive_boardschedule"/>
			</xsl:when>
			<xsl:when test="../SCHEDULING-REQUEST='CONFIRMEDSETSITETOPICSACTIVE'">
				<xsl:apply-templates select="." mode="setsitetopicsactive_boardschedule"/>
			</xsl:when>
			<xsl:when test="../SCHEDULING-REQUEST='DISPLAY'">
				<xsl:apply-templates select="." mode="display_sitetopicsschedule"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="processcreate_sitetopicsschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Edit opening times</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<xsl:apply-templates select="." mode="setactivelink"/>
					<br/>
					<br/>
		You have set the boards to have these opening times:
		<br/>
					<br/>
					<xsl:apply-templates select="." mode="times"/>
					<br/>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div style="padding:10px;margin-left:280px;">
						<div class="buttonThreeD">
							<xsl:apply-templates select="." mode="backtosettings"/>
						</div>
					</div>
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="times">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Selects the correct type of timing used on the forum
	-->
	<xsl:template match="FORUMSCHEDULES" mode="times">
		<xsl:choose>
			<xsl:when test="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = 7] and not(SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = 7])">
				<xsl:apply-templates select="." mode="all_times"/>
			</xsl:when>
			<xsl:when test="SCHEDULE/EVENT/TIME[@DAYTYPE = 7]">
				<xsl:apply-templates select="." mode="same_times"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="different_times"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="all_times">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Text that appears if the forums are set to be open 24/7
	-->
	<xsl:template match="FORUMSCHEDULES" mode="all_times">
		These boards are open 24/7		
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="same_times">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Text that appears if the boards are set to be open the same times every day
	-->
	<xsl:template match="FORUMSCHEDULES" mode="same_times">
		These boards are open at the same times each day:
		<br/>
		Open: <xsl:value-of select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = 7]/@HOURS"/>:<xsl:value-of select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = 7]/@MINUTES"/>
		<br/>
		Close: <xsl:value-of select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = 7]/@HOURS"/>:<xsl:value-of select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = 7]/@MINUTES"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="different_times">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Text that appears if the boards are set to be open at different times each day
	-->
	<xsl:template match="FORUMSCHEDULES" mode="different_times">
		These boards are open at different times each day:
		<br/>
		<br/>
		<b>Monday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">0</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Tuesday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">1</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Wednesday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">2</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Thursday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">3</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Friday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">4</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Saturday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">5</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<br/>
		<b>Sunday</b>
		<br/>
		<xsl:apply-templates select="." mode="openingtimes">
			<xsl:with-param name="daynumber">6</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="openingtimes">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Creates the actual opening time text for the above template
	-->
	<xsl:template match="FORUMSCHEDULES" mode="openingtimes">
		<xsl:param name="daynumber">0</xsl:param>
		<xsl:choose>
			<xsl:when test="SCHEDULE/EVENT/TIME[@DAYTYPE = $daynumber]">
				Open: <xsl:value-of select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = $daynumber]/@HOURS"/>:<xsl:value-of select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = $daynumber]/@MINUTES"/>
				<br/>
				Close: <xsl:value-of select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = $daynumber]/@HOURS"/>:<xsl:value-of select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = $daynumber]/@MINUTES"/>
			</xsl:when>
			<xsl:otherwise>
				Closed all day
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="confirmsitetopicsinactive_boardschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Emergency closure</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea" id="openingWarning">
					<span id="headingHighlight">Are you sure you want to stop users from posting to the message boards immediately?</span>
					<br/>
					<br/>
		This should only be for emergencies, such as <br/>
					<ul>
						<li class="adminText">Spam attacks</li>
						<li class="adminText">Repeated posting of information made confidential by a court order</li>
					</ul>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="{$root}MessageBoardSchedule?action=display">&lt;&lt; Back</a>
						</div>
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="{$root}MessageBoardSchedule?action=setsitetopicsinactive&amp;confirm=1">Close Boards &gt;&gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="setsitetopicsinactive_boardschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Emergency closure</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea" id="openingWarning">
					The board has been closed
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div style="margin:10px 10px 10px 120px;">
						<div class="buttonThreeD">
							<xsl:apply-templates select="." mode="backtosettings"/>
						</div>
					</div>
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="confirmsitetopicsactive_boardschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Emergency closure</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea" id="openingWarning">
		Are you sure you want to reopen the board for posting?		
		<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="{$root}MessageBoardSchedule?action=display">&lt;&lt; Back</a>
						</div>
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="{$root}MessageBoardSchedule?action=setsitetopicsactive&amp;confirm=1">Open Boards &gt;&gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SCHEDULE" mode="setsitetopicsactive_boardschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Emergency closure</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea" id="openingWarning">
					The board has been re-opened
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div style="margin:10px 10px 10px 320px;">
						<div class="buttonThreeD">
							<xsl:apply-templates select="." mode="backtosettings"/>
						</div>
					</div>
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:variable name="scheduledevents_dateorder_asc">
		<xsl:for-each select="/H2G2/SITETOPICSSCHEDULE/SCHEDULE/EVENT">
			<xsl:sort select="TIME/@DAYTYPE" data-type="number" order="ascending"/>
			<xsl:sort select="TIME/@HOURS" data-type="number" order="ascending"/>
			<xsl:sort select="TIME/@MINUTES" data-type="number" order="ascending"/>
			<xsl:sort select="TIME/@ACTION" data-type="number" order="ascending"/>
			
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<!--
	<xsl:template match="SCHEDULE" mode="display_sitetopicsschedule">
	Author:		James Conway
	Context:    H2G2/SITETOPICSCHEDULE/SCHEDULE
	Purpose:	 Produces the form that allows you to set the opening and closing times for the forums
	-->
	<xsl:template match="SCHEDULE" mode="display_sitetopicsschedule">
		<div id="subNav" style="background:#f4ebe4 url(http://www.bbc.co.uk/dnaimages/adminsystem/images/icon_opening.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Opening Times / Edit opening times</h1>
			</div>
		</div>		
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<div id="emergency">
						<xsl:apply-templates select="../SITETOPICSEMERGENCYCLOSED" mode="setactivelink"/>
					</div>
					<p id="instructional">All times are in GMT</p>
					<form method="post" action="{$root}MessageBoardSchedule">
						<input type="hidden" name="action" value="update"/>
						
						<input type="radio" name="updatetype" value="twentyfourseven" id="twentyfourseven">
							<xsl:if test="not(EVENT)">
								<xsl:attribute name="checked">1</xsl:attribute>
							</xsl:if>
						</input>
						<label for="twentyfourseven">Open 24/7</label>						
						
						<br/>
						<br/>
						
						<input type="radio" name="updatetype" value="sameeveryday" id="sameeveryday">
							<!--xsl:attribute name="onClick">sameeverydaySelected();</xsl:attribute -->
						</input>
						<label for="sameeveryday">Open at the same time every day</label>
						<input type="hidden" id="7ClosedAllDay"/>

						<br/>
						<br/>
						
						<table id="sameTime" border="0" cellspacing="0" cellpadding="0" width="415" summary="Table contains drop-downs to set the opening and closing hours for every day">
							<tr>
								<td width="145">
									Opens: <input type="hidden" id="7ClosedAllDay"/>
									<xsl:call-template name="recurringeventhours">
										<xsl:with-param name="name">recurrenteventopenhours</xsl:with-param>
										<xsl:with-param name="close">0</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="recurringeventminutes">
										<xsl:with-param name="name">recurrenteventopenminutes</xsl:with-param>
									</xsl:call-template>
								</td>
								<td width="145">
									Closes: 
									<xsl:call-template name="recurringeventhours">
										<xsl:with-param name="name">recurrenteventclosehours</xsl:with-param>
										<xsl:with-param name="close">1</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="recurringeventminutes">
										<xsl:with-param name="name">recurrenteventcloseminutes</xsl:with-param>
									</xsl:call-template>
								</td>
								<td width="125">
									<div id="7Time_div">&nbsp;</div>
								</td>
							</tr>
						</table>
												
						<br/>
						<br/>
						
						<input type="radio" name="updatetype" value="eachday" id="eachday">
							<xsl:if test="EVENT">
								<xsl:attribute name="checked">1</xsl:attribute>
							</xsl:if>
							<!-- xsl:attribute name="onClick">eachdaySelected();</xsl:attribute -->
						</input>
						<label for="eachday">Open at different times each day</label>
			
						<div id="SiteTopicsOpenCloseTimes">
							<table  id="differentTime" border="0" cellspacing="0" cellpadding="0" width="635" summary="Table contains drop-downs to set the opening and closing hours for each day">
								<xsl:choose>
									<xsl:when test="EVENT">
										<xsl:for-each select="msxsl:node-set($scheduledevents_dateorder_asc)/EVENT[position() mod 2= 1]">
											<tr>
												<xsl:apply-templates select=".|following-sibling::EVENT[position() &lt; 2]" mode="display_sitetopicsschedule"/>
											</tr>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<!-- no events so make defaults -->
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">1</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">2</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">3</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">4</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">5</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">6</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="differenttimedailydefault">
											<xsl:with-param name="dayweek">7</xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</table>
						</div>

						<!-- button type="button" onClick="return createNewEvent();">
							New Event
						</button -->
						
						<br/>
						<br/>
					
						<div class="footer">
							<div class="shadedDivider">
								<hr/>
							</div>
							<span class="buttonLeftA">
								<div class="buttonThreeD">
									<a href="{$root}messageboardadmin">&lt; &lt; Back</a>
								</div>
							</span>
							<input type="submit" name="submit" value="Save Opening Times &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br/>
							<br/>
							<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/b_l.gif" alt=""/>
						</div>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="differenttimedailydefault">
		<xsl:param name="dayweek"/>
		<tr>
			<th class="adminTH" scope="row" width="100">
				<xsl:choose>
					<xsl:when test="$dayweek=1">SUNDAY</xsl:when>
					<xsl:when test="$dayweek=2">MONDAY</xsl:when>
					<xsl:when test="$dayweek=3">TUESDAY</xsl:when>
					<xsl:when test="$dayweek=4">WEDNESDAY</xsl:when>
					<xsl:when test="$dayweek=5">THURSDAY</xsl:when>
					<xsl:when test="$dayweek=6">FRIDAY</xsl:when>
					<xsl:when test="$dayweek=7">SATURDAY</xsl:when>
				</xsl:choose>
			</th>
			<td width="120">
				<input type="checkbox" onClick="return closeAllDay(this);"/><xsl:text> Closed all day</xsl:text>
			</td>
			<td width="145">Opens: 
				<input type="hidden" name="eventdaytype">
					<xsl:attribute name="value"><xsl:value-of select="$dayweek"/></xsl:attribute>
				</input>
				<xsl:call-template name="recurringeventhours">
					<xsl:with-param name="name">eventhours</xsl:with-param>
					<xsl:with-param name="close">0</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="recurringeventminutes">
					<xsl:with-param name="name">eventminutes</xsl:with-param>
				</xsl:call-template>
				<input type="hidden" name="eventaction" value="0"/>
			</td>
			<td width="145">
				Closes: 
				<input type="hidden" name="eventdaytype">
					<xsl:attribute name="value"><xsl:value-of select="$dayweek"/></xsl:attribute>
				</input>
				<xsl:call-template name="recurringeventhours">
					<xsl:with-param name="name">eventhours</xsl:with-param>
					<xsl:with-param name="close">1</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="recurringeventminutes">
					<xsl:with-param name="name">eventminutes</xsl:with-param>
				</xsl:call-template>
				<input type="hidden" name="eventaction" value="1"/>
			</td>
			<td width="125">
				<div id="0Time_div">&nbsp;</div>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="EVENT" mode="display_sitetopicsschedule">
	Author:		James Conway
	Context:	H2G2/SITETOPICSCHEDULE/SCHEDULE/EVENT
	Purpose:	Creates...
	-->
	<xsl:template match="EVENT[position() mod 2 = 1]" mode="display_sitetopicsschedule">
		<th class="adminTH" scope="row" width="100"><xsl:apply-templates select="TIME/@DAYTYPE" mode="dayofweekdisplay"/></th>
		<td width="120">
			<xsl:call-template name="closedallday">
				<xsl:with-param name="daytype"><xsl:value-of select="TIME/@DAYTYPE"/></xsl:with-param>
			</xsl:call-template>
		</td>
		<xsl:apply-templates select="." mode="display_sitetopicsevent"/>
	</xsl:template>
	<xsl:template name="closedallday">
		<xsl:param name="daytype"/>
		<input type="checkbox" onClick="return closeAllDay(this);">
			<xsl:if test="not(key('samedayevents', $daytype)/@HOURS > 1)">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input><xsl:text> Closed all day</xsl:text>
	</xsl:template>
	<xsl:template match="EVENT" mode="display_sitetopicsschedule">
		<xsl:apply-templates select="TIME/@DAYTYPE" mode="dayofweekinput"/>
		<xsl:apply-templates select="." mode="display_sitetopicsevent"/>
	</xsl:template>
	<xsl:template match="EVENT[@ACTION=0]" mode="display_sitetopicsevent">
		<td width="145">
			<xsl:apply-templates select="@ACTION" mode="display_sitetopicsevent"/>
			<xsl:apply-templates select="TIME/@HOURS"/>
			<xsl:apply-templates select="TIME/@MINUTES"/>
		</td>		
	</xsl:template>
	<xsl:template match="EVENT[@ACTION=1]" mode="display_sitetopicsevent">
		<td width="120">
			<xsl:apply-templates select="@ACTION" mode="display_sitetopicsevent"/>
			<xsl:apply-templates select="TIME/@HOURS"/>
			<xsl:apply-templates select="TIME/@MINUTES"/>
		</td>		
	</xsl:template>
	<xsl:template match="@ACTION[.=0]" mode="display_sitetopicsevent">
		<span>Opens: </span>
		<input type="hidden" name="eventaction" value="0"/>
	</xsl:template>
	<xsl:template match="@ACTION[.=1]" mode="display_sitetopicsevent">
		<span>Closes: </span>
		<input type="hidden" name="eventaction" value="1"/>
	</xsl:template>
	<!--
	<xsl:template match="@DAYTYPE" mode="display_sitetopicsschedule">
	Author:		James Conway
	Context:	H2G2/SITETOPICSCHEDULE/SCHEDULE/EVENT/TIME/@DAYTYPE
	Purpose:	Creates...
	-->
	<xsl:template match="@DAYTYPE[.=1]" mode="dayofweekdisplay">
		<b>SUNDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=1]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="1"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=2]" mode="dayofweekdisplay">
		<b>MONDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=2]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="2"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=3]" mode="dayofweekdisplay">
		<b>TUESDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=3]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="3"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=4]" mode="dayofweekdisplay">
		<b>WEDNESDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=4]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="4"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=5]" mode="dayofweekdisplay">
		<b>THURSDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=5]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="5"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=6]" mode="dayofweekdisplay">
		<b>FRIDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=6]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="6"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=7]" mode="dayofweekdisplay">
		<b>SATURDAY</b>
		<xsl:apply-templates select="." mode="dayofweekinput"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE[.=7]" mode="dayofweekinput">
		<input type="hidden" name="eventdaytype" value="7"/>
	</xsl:template>
	<xsl:template match="@DAYTYPE">
		<select name="eventdaytype">
			<option value="1">
				<xsl:if test=".=1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Sunday
			</option>
			<option value="2">
				<xsl:if test=".=2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Monday
			</option>
			<option value="3">
				<xsl:if test=".=3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Tuesday
			</option>
			<option value="4">
				<xsl:if test=".=4"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Wednesday
			</option>
			<option value="5">
				<xsl:if test=".=5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Thursday
			</option>
			<option value="6">
				<xsl:if test=".=6"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Friday
			</option>
			<option value="7">
				<xsl:if test=".=7"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Saturday
			</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="@HOURS" mode="display_sitetopicsschedule">
	Author:		James Conway
	Context:	H2G2/SITETOPICSCHEDULE/SCHEDULE/EVENT/TIME/@HOURS
	Purpose:	Creates...
	-->
	<xsl:template match="@HOURS">
		<select name="eventhours">
			<option value="0">
				<xsl:if test=".=0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				0
			</option>
			<option value="1">
				<xsl:if test=".=1"><xsl:attribute name="selected">selected</xsl:attribute>	</xsl:if>
				1
			</option>
			<option value="2">
				<xsl:if test=".=2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				2
			</option>
			<option value="3">
				<xsl:if test=".=3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				3
			</option>
			<option value="4">
				<xsl:if test=".=4"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				4
			</option>
			<option  value="5">
				<xsl:if test=".=5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				5
			</option>
			<option  value="6">
				<xsl:if test=".=6"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				6
			</option>
			<option value="7">
				<xsl:if test=".=7"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				7
			</option>
			<option value="8">
				<xsl:if test=".=8"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				8
			</option>
			<option value="9">
				<xsl:if test=".=9"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				9
			</option>
			<option value="10">
				<xsl:if test=".=10"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				10
			</option>
			<option value="11">
				<xsl:if test=".=11"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				11
			</option>
			<option value="12">
				<xsl:if test=".=12"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				12
			</option>
			<option  value="13">
				<xsl:if test=".=13"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				13
			</option>
			<option  value="14">
				<xsl:if test=".=14"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				14
			</option>
			<option  value="15">
				<xsl:if test=".=15"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				15
			</option>
			<option value="16">
				<xsl:if test=".=16"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				16
			</option>
			<option value="17">
				<xsl:if test=".=17"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				17
			</option>
			<option value="18">
				<xsl:if test=".=18"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				18
			</option>
			<option value="19">
				<xsl:if test=".=19"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				19
			</option>
			<option value="20">
				<xsl:if test=".=20"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				20
			</option>
			<option value="21">
				<xsl:if test=".=21"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				21
			</option>
			<option value="22">
				<xsl:if test=".=22"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				22
			</option>
			<option value="23">
				<xsl:if test=".=23"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				23
			</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="@MINUTES" mode="display_sitetopicsschedule">
	Author:		James Conway
	Context:	H2G2/SITETOPICSCHEDULE/SCHEDULE/EVENT/TIME/@MINUTES
	Purpose:	Creates...
	-->
	<xsl:template match="@MINUTES">
		<select name="eventminutes">
			<option value="0">
				<xsl:if test=".=0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				00
			</option>
			<option value="15">
				<xsl:if test=".=15"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				15
			</option>
			<option value="30">
				<xsl:if test=".=30"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				30
			</option>
			<option value="45">
				<xsl:if test=".=45"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				45
			</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="@ACTION">
	Author:		James Conway
	Context:	H2G2/SITETOPICSCHEDULE/SCHEDULE/EVENT/@ACTION
	Purpose:	Creates...
	-->
	<xsl:template match="@ACTION">
		<select name="eventaction">
			<option value="0">
				<xsl:if test=".=0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Open
			</option>
			<option value="1">
				<xsl:if test=".=1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				Closed
			</option>
		</select>
	</xsl:template>
	<xsl:template match="EVENT" mode="alldayradio">
		<xsl:variable name="daytype"><xsl:value-of select="TIME/@DAYTYPE"/></xsl:variable>
		
		<xsl:value-of select="count(TIME)"/>

		<input type="checkbox" onClick="return closeAllDay(this);">
		</input>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSCHEDULES" mode="alldayradio">
	Author:		Andy Harris
	Context:    H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES  
	Purpose:	 Create the radio button to select 'open all day' for each day of the week
	-->
	<xsl:template match="FORUMSCHEDULES" mode="alldayradio">
		<xsl:param name="daynumber">0</xsl:param>
		<input type="checkbox" name="{$daynumber}ClosedAllDay" id="{$daynumber}ClosedAllDay" onClick="findTime('{$daynumber}HoursOpen_select', '{$daynumber}MinsOpen_select', '{$daynumber}HoursClose_select', '{$daynumber}MinsClose_select', '{$daynumber}Time_div', '{$daynumber}ClosedAllDay');" value="1">
			<xsl:if test="SCHEDULE/EVENT and not(SCHEDULE/EVENT/TIME[@DAYTYPE = 7]) and not(SCHEDULE/EVENT/TIME[@DAYTYPE = $daynumber])">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template name="recurringeventhours">
		<xsl:param name="name"/>
		<xsl:param name="close"/>
		<select>
			<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
			<option value="0">0</option>
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8">8</option>
			<option value="9" ><xsl:if test="$close=0"><xsl:attribute name="selected">1</xsl:attribute></xsl:if>9</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
			<option value="13">13</option>
			<option value="14">14</option>
			<option value="15">15</option>
			<option value="16">16</option>
			<option value="17"><xsl:if test="$close=1"><xsl:attribute name="selected">1</xsl:attribute></xsl:if>17</option>
			<option value="18">18</option>
			<option value="19">19</option>
			<option value="20">20</option>
			<option value="21">21</option>
			<option value="22">22</option>
			<option value="23">23</option>
		</select>
	</xsl:template>
	<xsl:template name="recurringeventminutes">
		<xsl:param name="name"/>
		<select>
			<xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
			<option value="0" selected="selected">0</option>
			<option value="15">15</option>
			<option value="30">30</option>
			<option value="45">45</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template name="selecttimefromxml">
	Author:		Andy Harris
	Context:     
	Purpose:	 Creates the drop downs to select the opening times for the various days
	-->
	<xsl:template name="selecttimefromxml">
		<xsl:param name="day">7</xsl:param>
		<xsl:param name="action">Open</xsl:param>
		<xsl:param name="actionflag">
			<xsl:choose>
				<xsl:when test="$action = 'Open'">1</xsl:when>
				<xsl:when test="$action = 'Close'">0</xsl:when>
			</xsl:choose>
		</xsl:param>
		<select id="{$day}Hours{$action}_select" onClick="findTime('{$day}HoursOpen_select', '{$day}MinsOpen_select', '{$day}HoursClose_select', '{$day}MinsClose_select', '{$day}Time_div', '{$day}ClosedAllDay');">
			<xsl:attribute name="name"><xsl:choose><xsl:when test="$day = 7">Hours<xsl:value-of select="$action"/></xsl:when><xsl:otherwise><xsl:value-of select="$day"/>Hours<xsl:value-of select="$action"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<option value="00">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='00']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>00</option>
			<option value="01">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='01']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>01</option>
			<option value="02">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='02']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>02</option>
			<option value="03">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='03']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>03</option>
			<option value="04">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='04']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>04</option>
			<option value="05">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='05']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>05</option>
			<option value="06">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='06']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>06</option>
			<option value="07">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='07']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>07</option>
			<option value="08">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='08']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>08</option>
			<option value="09">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='09']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>09</option>
			<option value="10">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='10']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>10</option>
			<option value="11">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='11']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>11</option>
			<option value="12">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='12']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>12</option>
			<option value="13">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='13']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>13</option>
			<option value="14">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='14']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>14</option>
			<option value="15">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='15']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>15</option>
			<option value="16">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='16']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>16</option>
			<option value="17">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='17']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>17</option>
			<option value="18">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='18']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>18</option>
			<option value="19">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='19']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>19</option>
			<option value="20">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='20']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>20</option>
			<option value="21">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='21']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>21</option>
			<option value="22">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='22']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>22</option>
			<option value="23">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@HOURS='23']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>23</option>
		</select>
		<select id="{$day}Mins{$action}_select" onClick="findTime('{$day}HoursOpen_select', '{$day}MinsOpen_select', '{$day}HoursClose_select', '{$day}MinsClose_select', '{$day}Time_div', '{$day}ClosedAllDay');">
			<xsl:attribute name="name"><xsl:choose><xsl:when test="$day = 7">Mins<xsl:value-of select="$action"/></xsl:when><xsl:otherwise><xsl:value-of select="$day"/>Mins<xsl:value-of select="$action"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<option value="00">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@MINUTES='00']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>00</option>
			<option value="15">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@MINUTES='15']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>15</option>
			<option value="30">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@MINUTES='30']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>30</option>
			<option value="45">
				<xsl:for-each select="/H2G2/MESSAGEBOARDSCHEDULE/FORUMSCHEDULES/SCHEDULE/EVENT[TIME/@DAYTYPE = $day][@ACTION = $actionflag]">
					<xsl:if test="TIME/@DAYTYPE = $day and TIME[@MINUTES='45']">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
				</xsl:for-each>45</option>
		</select>
	</xsl:template>
</xsl:stylesheet>
