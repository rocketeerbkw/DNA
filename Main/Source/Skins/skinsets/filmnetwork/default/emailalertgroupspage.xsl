<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-emailalertgroupspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="EMAILALERTGROUPS_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">EMAILALERTGROUPS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">emailalertgroupspage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@CODE='UserNotLoggedIn' or /H2G2/ERROR/@CODE='UserNotAuthorised'">
				<table class="confirmBox">
					<tr>
						<td>
							<div class="biogname"><strong>my alerts</strong></div>	
						</td>
					</tr>
					<tr>
						<td>
							<h1>An error has occured</h1>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="/H2G2/ERROR" mode="error_emailalertgroups"/>
						</td>
					</tr>
				</table>
				<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif" width="635" height="27" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'stopalerts'">
				<xsl:choose>
					<xsl:when test="ALERTGROUPS/*">
						<xsl:apply-templates select="ALERTGROUPS" mode="edit_emailalertgroups"/>
					</xsl:when>
					<xsl:otherwise>
						<table class="confirmBox confirmBoxMargin">
							<tr>
								<td>
									<div class="biogname"><strong>my alerts</strong></div>	
								</td>
							</tr>
							<tr>
								<td>
									<p>You are currently not subscribed to any email alerts</p>
								</td>
							</tr>
						</table>
						<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif" width="635" height="27" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'confirm'">
				<xsl:apply-templates select="ALERTGROUPS" mode="confirmation_emailalertgroups"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ALERTGROUPS" mode="c_emailalertgroups"/>			
			</xsl:otherwise>
		</xsl:choose>
		<strong>
			<a href="{$root}U{ALERTGROUPS/@USERID}" class="backToProfile">back to my profile&nbsp;<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" /></a>
		</strong>
		<br />
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='stopalerts'">
			<strong>
				<a href="sitehelpemailalerts" class="backToProfile">more about email alerts&nbsp;<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" /></a>
			</strong>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ALERTGROUPS" mode="error_emailalertgroups">
		<h1>An error has occurred</h1>
		<xsl:apply-templates select="/H2G2/ERROR" mode="error_emailalertgroups"/>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="edit_emailalertgroups">
		<table class="confirmBox confirmBoxMargin">
			<tr>
				<td>
					<div class="biogname"><strong>my email alerts</strong></div>	
				</td>
			</tr>
			<tr>
				<td>
					<p>You can turn all Film Network email alerts on and off below</p>
				</td>
			</tr>
		</table>
		<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif" width="635" height="27" />
            		<!-- Only do if an alert exists -->
            		<xsl:if test="GROUPALERT">
                		<form action="{root}AlertGroups" method="post">
                    			<input type="hidden" name="cmd" value="editgroup" />
                    			<!-- <input type="hidden" name="owneditems" value="0" /> -->
                    			<input type="hidden" name="alerttype" value="normal" />
					<div class="toggleAlerts">
						<input type="radio" name="notifytype" value="email">
                            						<xsl:if test="GROUPALERT/NOTIFYTYPE=1">
                            							<xsl:attribute name="checked">true</xsl:attribute>
                            						</xsl:if>
						</input>
						&nbsp;<strong>turn email alerts on</strong>
					</div>
                				<br />
					<div class="toggleAlerts">
						<input type="radio" name="notifytype" value="disabled">
                            					<xsl:if test="GROUPALERT/NOTIFYTYPE=3">
                            						<xsl:attribute name="checked">true</xsl:attribute>
                            					</xsl:if>
						</input> 
						&nbsp;<strong>turn email alerts off</strong>
					</div>
                				<br />
                			<input type="image" src="http://www.bbc.co.uk/filmnetwork/images/furniture/change_button.gif" alt="Change" name="Change"/>
                		</form>
            			<br />
            			<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" />
               	</xsl:if>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="summary_emailalertgroups">
		<!-- Introductory text -->
		<h1>email alert manager</h1>
		<table class="confirmBox">
			<tr>
				<td>
					<div class="biogname"><strong>My email alerts</strong></div>	
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="GROUPALERT">
					<tr>
						<td>
							<p>You have signed up to receive the following email alerts.<br />
								Alerts are sent once a day, unless there are no changes to tell you about. </p>
						</td>
					</tr>
					<tr>
						<td>
							<p>Click 'remove alert' to stop receiving specific email alerts.</p>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="/H2G2/ALERTGROUPS/GROUPALERT/NOTIFYTYPE = 1">
									<p><strong>Alerts are on</strong> - <a href="{$root}alertgroups?s_view=stopalerts">stop all Film Network
										alerts.</a></p>
								</xsl:when>
								<xsl:when test="/H2G2/ALERTGROUPS/GROUPALERT">
									<p><strong>Alerts are off</strong> - <a href="{$root}alertgroups?s_view=stopalerts">start all Film Network
										alerts.</a></p>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td>
							<p>
								<strong><a href="{$root}sitehelpemailalerts">more about email alerts</a></strong>
							</p>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>
							<p>If you sign up to email alerts you will receive an email every time a comment or message is left on a strand that you have subscribed to.</p>
						</td>
					</tr>
					<tr>
						<td>
							<p>Email alerts are available for:<br />
								-messages left on your profile page<br />
								-responses to messages you have left on someone else's profile page<br />
								-new comments added to a film page<br />
								-new comments added in a discussion</p>
						</td>
					</tr>
					<tr>
						<td>
							<p>All the email alerts you have subscribed to will be listed below. You currently have no alerts set.</p>
						</td>
					</tr>
					<tr>
						<td>
							<p>
								<strong><a href="{$root}sitehelpemailalerts">more about email alerts</a></strong>
							</p>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</table>
		<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif" width="635" height="27" />
		
		<table width="371" border="0" cellspacing="0" cellpadding="0" class="alertsList">
			<tr class="space"></tr>
			<!-- List of alerts -->
			<xsl:apply-templates select="." mode="c_alertsummary"/>
			<tr class="space">
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="full_alertsummary">
		<xsl:apply-templates select="GROUPALERT" mode="t_alertsummary"/>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="empty_alertsummary">
		<!--<p>
			<strong>You have no alerts set.</strong>
		</p>-->
	</xsl:template>
		
	<xsl:template match="GROUPALERT" mode="t_alertsummary">
		<tr>
			<xsl:choose>
				<xsl:when test="position(  ) mod 2 = 0">
					<xsl:attribute name="class">
						evenAlerts
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						oddAlerts
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			 <td>
				<ul>
					<li>
						<strong><a>
							<xsl:attribute name="href">
								<xsl:choose>
									<!-- Issue / Location -->
									<xsl:when test="ITEMTYPE=1">
										C<xsl:value-of select="ITEMID"/>
									</xsl:when>
									<!-- Article -->
									<xsl:when test="ITEMTYPE=2">
										A<xsl:value-of select="ITEMID"/>
									</xsl:when>
									<!-- Campaign -->
									<xsl:when test="ITEMTYPE=3">
										G<xsl:value-of select="ITEMID"/>
									</xsl:when>
									<!-- Forum -->
									<xsl:when test="ITEMTYPE=4">
										F<xsl:value-of select="ITEMID"/>?thread=<xsl:value-of select="ITEMID2"/>
									</xsl:when>
									<!-- Thread -->
									<xsl:when test="ITEMTYPE=5">
										T<xsl:value-of select="ITEMID"/>
									</xsl:when>
									<!-- User -->
									<xsl:when test="ITEMTYPE=7">
										U<xsl:value-of select="ITEMID"/>
									</xsl:when>
									<!-- Link -->
									<xsl:when test="ITEMTYPE=9">
										A<xsl:value-of select="ITEMID"/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="NAME = ''">
									<xsl:text>All Messages</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="NAME"/>
								</xsl:otherwise>
							</xsl:choose>
						</a></strong>
					</li>
				</ul>
				<a href="alertgroups?cmd=remove&amp;groupid={GROUPID}" class="removeLink">
					<xsl:text>remove alert</xsl:text>
				</a>
			</td>
		</tr>
	</xsl:template>
	
	<!--<xsl:template match="ALERTGROUPS" mode="edit_emailalertgroups">
		<xsl:apply-templates select="." mode="c_editpage"/>
		<p>
			<xsl:text>Go to </xsl:text>
			<a href="{$root}AlertGroups">My alerts</a>
		</p>
	</xsl:template>-->
	
	<xsl:template match="ALERTGROUPS" mode="owner_editpage">
		<h2>Alerts on your pages</h2>
		<xsl:apply-templates select="." mode="c_editform"/>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="other_editpage">
		<h2>Alerts on other pages</h2>
		<xsl:apply-templates select="." mode="c_editform"/>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="r_editform">
		<h3>Alert by:</h3>
		<p>
			<xsl:apply-templates select="." mode="t_emailoption"/>
			<xsl:text> Email</xsl:text>
		</p>
		<p>
			<xsl:apply-templates select="." mode="t_messageoption"/>
			<xsl:text> Private Message</xsl:text>
		</p>
		<p>
			<xsl:apply-templates select="." mode="t_disabledoption"/>
			<xsl:text> Disabled</xsl:text>
		</p>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	
	<xsl:template match="ALERTGROUPS" mode="confirmation_emailalertgroups">
		<table class="confirmBox confirmBoxMargin">
			<tr>
				<td>
					<div class="biogname"><strong>email alert on</strong></div>	
				</td>
			</tr>
			<tr>
				<td>
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_origin']/VALUE = 'discussion'">
							<p>You will now receive an email alert when someone posts to this discussion.</p>
						</xsl:when>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_origin']/VALUE = 'reply'">
							<p>You will now receive an email alert when this person replies to this message.</p>
						</xsl:when>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_origin']/VALUE = 'film'">
							<p>You will now receive an email alert every time a new comment is left on  <xsl:apply-templates
									select="/H2G2/ALERTACTION" mode="t_pagelink"/>.</p>
						</xsl:when>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_origin']/VALUE = 'message'">
							<p>You will now receive an email alert each time a message is left on your profile page.</p>							
						</xsl:when>
						<xsl:otherwise>
							<p>Email alert set.</p>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td>
					<p>To turn off email alerts see <a href="{$root}AlertGroups">my email alerts</a></p>
				</td>
			</tr>
		</table>
		<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif" width="635" height="27" />
		<br />
	</xsl:template>
	
</xsl:stylesheet>
