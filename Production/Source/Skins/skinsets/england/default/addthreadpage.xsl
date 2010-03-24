<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addthreadpage.xsl"/>
	<xsl:template name="ADDTHREAD_JAVASCRIPT">
		<script type="text/javascript">
	function check(location) {
		if (confirm("Are you sure?")) {
			location.href = "<xsl:value-of select="$returnlocation"/>";
		}
		else {
			location.href = "#";
		}
	}
	
	function countDown() {
		var minutesSpan = document.getElementById("minuteValue");
		var secondsSpan = document.getElementById("secondValue");
		
		var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
		var seconds = new Number(secondsSpan.childNodes[0].nodeValue);
			
		var inSeconds = (minutes*60) + seconds;
		var timeNow = inSeconds - 1;			
			
		if (timeNow >= 0){
			var scratchPad = timeNow / 60;
			var minutesNow = Math.floor(scratchPad);
			var secondsNow = (timeNow - (minutesNow * 60));			
				
			var minutesText = document.createTextNode(minutesNow);
			var secondsText = document.createTextNode(secondsNow);
			
			minutesSpan.removeChild(minutesSpan.childNodes[0]);
			secondsSpan.removeChild(secondsSpan.childNodes[0]);
				
			minutesSpan.appendChild(minutesText);
			secondsSpan.appendChild(secondsText);
		}
	}
	</script>
	</xsl:template>
	<xsl:variable name="returnlocation">
		<xsl:choose>
			<xsl:when test="@INREPLYTO &gt; 0">
				<xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID"/>&amp;post=<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>#p<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>
			</xsl:when>
			<xsl:when test="RETURNTO">
				<xsl:value-of select="$root"/>A<xsl:value-of select="/H2G2/POSTTHREADFORM/RETURNTO/H2G2ID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID"/>&amp;post=<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>#p<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	ADDTHREAD_MAINBODY
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ADDTHREAD_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<tr>
				<td id="crumbtrail">
					<h5>You are here &gt; 
						<a href="{$homepage}">
							<!--xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/-->
							<xsl:text>BBC England Messageboard</xsl:text>
						</a>
						<!-- &gt; <a href="{$root}F{/H2G2/POSTTHREADFORM/@FORUMID}">
							<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
						</a-->
						<xsl:choose>
							<xsl:when test="POSTTHREADFORM/@INREPLYTO = 0"> &gt; Start a new discussion</xsl:when>
							<xsl:otherwise>
								&gt; 
								<a href="{$root}F{/H2G2/POSTTHREADFORM/@FORUMID}?thread={POSTTHREADFORM/@THREADID}">
									<xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/>
								</a>  
								&gt; Reply to a post
							</xsl:otherwise>
						</xsl:choose>
					</h5>
				</td>
			</tr>
			<tr>
				<td class="pageheader">
					<table width="635" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td id="subject">
								<h1>
									<xsl:choose>
										<xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
											<!-- When it is start a new discussion... -->
											Start a new discussion
										</xsl:when>
										<xsl:otherwise>
											<!-- When it is a reply... -->
											Reply to a message
										</xsl:otherwise>
									</xsl:choose>
								</h1>
							</td>
							<td id="rulesHelp">
								<p>
									<a href="{$houserulespopupurl}" onclick="popupwindow('{$houserulespopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">House rules</a>  | <a href="{$faqpopupurl}" onclick="popupwindow('{$faqpopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,toolbar=1,width=550,height=380');return false;" target="popwin" title="This link opens in a new popup window">Help</a>
								</p>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width="635" align="right">
					<table width="630" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td valign="top">
								<table width="500" cellpadding="0" cellspacing="0" border="0" id="contentForm">
									<tr>
										<td id="tablenavbarForm" width="500">
											<p>
												<xsl:choose>
													<xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
														<!-- When it is start a new discussion... -->
														<xsl:choose>
															<xsl:when test="string-length(/H2G2/POSTTHREADFORM/BODY) = 0 or /H2G2/PARAMS/PARAM[NAME='s_edit']">
																To create a new discussion, just fill out the form below
															</xsl:when>
															<xsl:otherwise>
																If you are not satisfied with your message, you can click 'edit' to go back
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<!-- When it is a reply... -->
														<xsl:choose>
															<xsl:when test="not(/H2G2/POSTTHREADFORM/PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
																<!-- When you're back editing the message again -->
																Just fill out the form below.  If you want to include the message you are replying to, click on 'Add original message'
															</xsl:when>
															<xsl:otherwise>
																<!-- When you're not.. -->
																If you are unhappy with the message, click 'Edit' to change it
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</p>
										</td>
									</tr>
									<tr>
										<td valign="top" width="500" id="formArea">
											<!-- xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/ -->
											<xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
											<xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
											<xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
											<xsl:apply-templates select="ERROR" mode="c_addthread"/>
										</td>
									</tr>
									<tr>
										<td id="previewArea">
											<xsl:choose>
												<xsl:when test="not(/H2G2/POSTTHREADFORM/PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
													<xsl:choose>
														<xsl:when test="/H2G2/POSTTHREADFORM/@INREPLYTO = 0">
															<span style="visibility:hidden">.</span>
														</xsl:when>
														<xsl:otherwise>
															<xsl:apply-templates select="/H2G2/POSTTHREADFORM/INREPLYTO" mode="c_addthread"/>
														</xsl:otherwise>
													</xsl:choose>
													<!--xsl:choose>
														<xsl:when test="POSTTHREADFORM/PREVIEWBODY">
															<div style="margin-top:5px;margin-bottom:5px;">
																<font size="5">Your message will look like this</font>
															</div>
														</xsl:when>
														<xsl:otherwise>
															<div style="margin-top:5px;margin-bottom:5px;">
																<font size="5">Start a new discussion</font>
															</div>
														</xsl:otherwise>
													</xsl:choose-->
												</xsl:when>
												<xsl:otherwise>
													<span style="visibility:hidden">.</span>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</table>
							</td>
							<td valign="top" width="130" id="promoArea">
								<xsl:choose>
									<xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
										<!-- When it is start a new discussion... -->
										<br/>
										<br/>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="getting involved" title="getting involved" align="top" border="0"/>
													</a> How to <a href="http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">start a discussion<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_writing.gif" width="15" height="15" alt="writing messages" title="writing messages" align="top" border="0"/>
													</a>&nbsp; <a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">Rules and guidelines</a>
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="messageboard features" title="messageboard features" align="top" border="0"/>
													</a> Add <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">smileys <img src="http://www.bbc.co.uk/dnaimages/boards/images/f_biggrin.gif" width="16" height="16" alt="smiley" align="top" border="0"/>
													</a> to messages <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="messageboard features" title="messageboard features" align="top" border="0"/>
													</a> Add <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">web links</a> to messages <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<!-- When it is a reply... -->
										<br/>
										<br/>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="getting involved" title="getting involved" align="top" border="0"/>
													</a> How to <a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">reply to messages<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="messageboard features" title="messageboard features" align="top" border="0"/>
													</a> Add <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">smileys <img src="http://www.bbc.co.uk/dnaimages/boards/images/f_biggrin.gif" width="16" height="16" alt="smiley" align="top" border="0"/>
													</a> to messages <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="messageboard features" title="messageboard features" align="top" border="0"/>
													</a> Add <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">web links</a> to messages <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_writing.gif" width="15" height="15" alt="writing messages" title="writing messages" align="top" border="0"/>
													</a>&nbsp; <a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">Rules and guidelines</a>
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!-- 
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
	Use: Presentation of an introduction to a particular thread - defined in the article XML
	-->
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						POSTTHREADFORM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
	Use: The presentation of the form that generates a post. It has a preview area - ie what the post
	will look like when submitted, and a form area.
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
	Use: The presentation of the preview - this can either be an error or a normal display
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
		<xsl:apply-templates select="PREVIEWERROR" mode="c_addthread"/>
		<xsl:apply-templates select="." mode="c_previewbody"/>
	</xsl:template>
	<!-- 
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Use: presentation of the preview if it is an error
	-->
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
		<tr>
			<td class="body">
				<xsl:apply-imports/>
			</td>
		</tr>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_edit'])  and not(/H2G2/POSTTHREADFORM/QUOTEADDED = 1)">
			<table cellpadding="0" cellspacing="0" border="0" id="previewTableTwo">
				<tr>
					<th>
						<p>Your message looks like this:</p>
						<p class="instructional">
							<xsl:choose>
								<xsl:when test="string(/H2G2/SITECONFIG/EXTEXTPREVIEW)">
									<xsl:value-of select="/H2G2/SITECONFIG/EXTEXTPREVIEW"/>
								</xsl:when>
								<xsl:otherwise>
										If you are satisfied with your message, proceed by clicking on Post message.
									</xsl:otherwise>
							</xsl:choose>
						</p>
						<xsl:if test="SECONDSBEFOREREPOST">
							<p>
								<xsl:attribute name="class"><xsl:choose><xsl:when test="@POSTEDBEFOREREPOSTTIMEELAPSED">countdownWarning</xsl:when><xsl:otherwise>countdown</xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:text>You must wait </xsl:text>
								<span id="minuteValue">
									<xsl:number value="floor(SECONDSBEFOREREPOST div 60)"/>
								</span>
								<xsl:text> minutes </xsl:text>
								<span id="secondValue">
									<xsl:number value="SECONDSBEFOREREPOST - floor(SECONDSBEFOREREPOST div 60)*60"/>
								</span>
								<xsl:text> secs before you can post again</xsl:text>
							</p>
						</xsl:if>
					</th>
				</tr>
				<tr>
					<td class="postPreview">
						<xsl:if test="/H2G2/POSTTHREADFORM/@INREPLYTO = 0">
							<p class="strong">
								<xsl:choose>
									<xsl:when test="string-length(SUBJECT) = 0">
											No Discussion Title
										</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="SUBJECT"/>
									</xsl:otherwise>
								</xsl:choose>
							</p>
						</xsl:if>
						<div class="postContentOne">
							<xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
						</div>
						<xsl:if test="$test_IsEditor">
							<p class="strong">
								<xsl:text>Discussion tags: </xsl:text>
								<xsl:apply-templates select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE" mode="c_addthread"/>
							</p>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right">
						<div class="buttonsTwo">
							<xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/>
							&nbsp;
							<input type="image" src="{$imagesource}edit_button.gif" alt="Edit" width="94" height="23" name="preview"/>
							&nbsp;
							<xsl:apply-templates select="." mode="t_submitpost"/>
						</div>
						<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE">
							<input type="hidden" name="phrase" value="{TERM}"/>
						</xsl:for-each>
						<input type="hidden" name="s_edit" value="yes"/>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_form">
		<!--<input type="hidden" name="skin" value="purexml"/>-->
		<xsl:if test="@PROFANITYTRIGGERED = 1">
			<input type="hidden" name="profanitytriggered" value="1"/>
		</xsl:if>
		<xsl:apply-templates select="." mode="c_preview"/>
		<xsl:apply-templates select="." mode="c_premoderationmessage"/>
		<xsl:apply-templates select="." mode="c_contententry"/>
		<!-- xsl:copy-of select="$m_UserEditHouseRulesDiscl"/ -->
	</xsl:template>
	<!-- NAUGHTY - - - needed to overrride base functionality -->
	<xsl:template match="RETURNTO/H2G2ID">
		<a xsl:use-attribute-sets="mRETURNTOH2G2ID">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/></xsl:attribute>
			<xsl:copy-of select="$m_returntoconv"/>
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
		<xsl:copy-of select="$m_userpremodmessage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
		<xsl:copy-of select="$m_PostSitePremod"/>
	</xsl:template>
	<!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
	<xsl:template match="INREPLYTO" mode="r_addthread">
		<table cellpadding="0" cellspacing="0" border="0" id="previewTable">
			<tr>
				<th>
					<p>You are replying to:</p>
				</th>
			</tr>
			<tr>
				<td class="post">
					<p>
						<a name="p{@POSTID}">
							<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;#p{@POSTID}">Message</a>
						</a>  posted by <xsl:value-of select="USERNAME"/>
						<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>
					</p>
					<div class="postContentOne">
						<xsl:apply-templates select="BODY"/>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
		<xsl:choose>
			<xsl:when test="not(PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
				<table cellpadding="0" cellspacing="0" border="0" class="message">
					<tr>
						<td>
							<xsl:if test="@PROFANITYTRIGGERED = 1">
								<p style="color:#000000; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">You have used at least one word which fails our profanity filter.  Please edit your message or it will not be posted.</p>
							</xsl:if>
							<xsl:if test="@INREPLYTO = 0">
								<br/>
								<h3>Your discussion title:</h3>
								<p class="instructional">
									<xsl:choose>
										<xsl:when test="string(/H2G2/SITECONFIG/EXTEXTTITLE)">
											<xsl:value-of select="/H2G2/SITECONFIG/EXTEXTTITLE"/>
										</xsl:when>
										<xsl:otherwise>
										Write a short snappy title to kick off a discussion. e.g. What's the best gig you've been to?
									</xsl:otherwise>
									</xsl:choose>
								</p>
								<xsl:apply-templates select="." mode="t_subjectfield"/>
								<br/>
								<br/>
							</xsl:if>
							<!--<td>
							<font xsl:use-attribute-sets="mainfont">
								<xsl:copy-of select="$m_UserEditWarning"/>
							</font>
						</td>-->
							<xsl:if test="SECONDSBEFOREREPOST">
								<p>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="@POSTEDBEFOREREPOSTTIMEELAPSED">countdownWarning</xsl:when><xsl:otherwise>countdown</xsl:otherwise></xsl:choose></xsl:attribute>
									<xsl:text>You must wait </xsl:text>
									<span id="minuteValue">
										<xsl:number value="floor(SECONDSBEFOREREPOST div 60)"/>
									</span>
									<xsl:text> minutes </xsl:text>
									<span id="secondValue">
										<xsl:number value="SECONDSBEFOREREPOST - floor(SECONDSBEFOREREPOST div 60)*60"/>
									</span>
									<xsl:text> secs before you can post again</xsl:text>
								</p>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@INREPLYTO = 0">
									<h3>Type your message in the box below:</h3>
									<p class="instructional">
										<xsl:choose>
											<xsl:when test="string(/H2G2/SITECONFIG/EXTEXTBODY)">
												<xsl:value-of select="/H2G2/SITECONFIG/EXTEXTBODY"/>
											</xsl:when>
											<xsl:otherwise>
												To create paragraphs, just press Return on your keyboard when needed.
											</xsl:otherwise>
										</xsl:choose>
									</p>
								</xsl:when>
								<xsl:otherwise>
									<br/>
									<h3>Type your message in the box below</h3>
									<p class="instructional">
										<xsl:choose>
											<xsl:when test="string(/H2G2/SITECONFIG/EXTEXTBODY)">
												<xsl:value-of select="/H2G2/SITECONFIG/EXTEXTBODY"/>
											</xsl:when>
											<xsl:otherwise>
												To create paragraphs, just press Return on your keyboard when needed.
											</xsl:otherwise>
										</xsl:choose>
									</p>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="." mode="t_bodyfield"/>
							<xsl:apply-templates select="." mode="c_tags"/>
							<xsl:apply-templates select="." mode="r_regiontags"/>
							<xsl:choose>
								<xsl:when test="@INREPLYTO = 0">
									<div class="buttonsTwo">
										<table width="405">
											<tr>
												<td>
													<!--xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/-->
													<a href="{$root}TSP">
														<xsl:copy-of select="$m_returntoconv"/>
													</a>
												</td>
												<td align="right">
													<xsl:apply-templates select="." mode="t_previewpost"/>
												</td>
											</tr>
											<tr>
												<td colspan="2" align="right">
													<xsl:apply-templates select="." mode="t_submitpost"/>
												</td>
											</tr>
										</table>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="buttonsTwo">
										<table width="410">
											<tr>
												<td align="right">
													<xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/>
													&nbsp;
													<input type="image" src="{$imagesource}add_original_message_button.gif" alt="Add original message" width="180" height="23" name="AddQuote" value="Add Quote"/>
													&nbsp;
													<xsl:apply-templates select="." mode="t_previewpost"/>
												</td>
											</tr>
											<tr>
												<td align="right">
													<xsl:apply-templates select="." mode="t_submitpost"/>
												</td>
											</tr>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="subject" value="{/H2G2/POSTTHREADFORM/SUBJECT}"/>
				<input type="hidden" name="body" value="{/H2G2/POSTTHREADFORM/BODY}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="mRETURNTOH2G2ID">
		<xsl:attribute name="onclick">check(this);</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="maFORUMID_ReturnToConv">
		<xsl:attribute name="onclick">check(this);</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="maFORUMID_ReturnToConv1">
		<xsl:attribute name="onclick">check(this);</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
		<xsl:attribute name="size">40</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>preview_button.gif</xsl:attribute>
		<xsl:attribute name="alt">Preview</xsl:attribute>
		<xsl:attribute name="value">Preview Message</xsl:attribute>
		<xsl:attribute name="name">preview</xsl:attribute>
		<xsl:attribute name="width">108</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>post_message_button.gif</xsl:attribute>
		<xsl:attribute name="alt">Post message button</xsl:attribute>
		<xsl:attribute name="width">149</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Use: Message displayed if reply is attempted when unregistered
	 -->
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
		<tr>
			<td>
				<xsl:apply-imports/>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
		<xsl:call-template name="m_posthasbeenpremoderated"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
	Use: Presentation of the 'Post has been auto premoderated' text
	 -->
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
		<xsl:call-template name="m_posthasbeenautopremoderated"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
	<xsl:template match="ERROR" mode="r_addthread">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="POSTTHREADFORM" mode="r_tags">
		<xsl:if test="THREADPHRASELIST/PHRASES/PHRASE">
			<p>
				<xsl:text>Current discussion tags: </xsl:text>
				<xsl:for-each select="THREADPHRASELIST/PHRASES/PHRASE">
					<xsl:value-of select="NAME"/>
					<xsl:if test="not(position() = last())">, </xsl:if>
				</xsl:for-each>
				<br/>
				<br/>
			</p>
		</xsl:if>
		<p>
			<em>Discussion tags:</em>
			<br/>
			<xsl:text>Help other users find your discussion by writing 3 or 4 descriptive words separated with a space</xsl:text>
			<br/>
			<xsl:apply-templates select="." mode="t_tagsinput"/>
		</p>
	</xsl:template>
	<xsl:template match="POSTTHREADFORM" mode="r_regiontags">
		<xsl:variable name="defaultRegion">
			<xsl:choose>
				<xsl:when test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM = /H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='England' or NAME='Channel Islands')]/TERM">
					<!-- When the search phrase term is a sitekeyphrase  -->
					<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM[. = /H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='England' or NAME='Channel Islands')]/TERM]"/>
				</xsl:when>
				<xsl:when test="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE/NAME = /H2G2/VIEWING-USER/USER/REGION">
					<!-- When a person has a region set -->
					<xsl:value-of select="/H2G2/VIEWING-USER/USER/REGION"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="/H2G2/POSTTHREADFORM/INREPLYTO"/>
			<xsl:when test="(/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM = /H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='England' or NAME='Channel Islands')]/TERM)">
				<input type="hidden" name="phrase" value="{$defaultRegion}"/>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:text>Please choose the region in which you want your message to appear.</xsl:text>
					<br/>
					<select name="phrase" size="1">
						<option value="">Please select your region</option>
						<option/>
						<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='England' or NAME='Channel Islands')]">
							<xsl:sort select="NAME" data-type="text" order="ascending"/>
							<option value="{TERM}">
								<xsl:if test="(TERM = $defaultRegion) or (NAME = $defaultRegion)">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<!-- When the name is the same as the region and any of the keyphrases are not the same as the term -->
								<xsl:value-of select="NAME"/>
							</option>
						</xsl:for-each>
					</select>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="PHRASE" mode="r_addthread">
		<xsl:value-of select="NAME[not(. = msxsl:node-set($list_of_regions)/region)]"/>
		<!--xsl:value-of select="NAME[not(contains($list_of_regions, $thisRegion))]"/-->
		<xsl:if test="following-sibling::PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)]">, </xsl:if>
	</xsl:template>
</xsl:stylesheet>
