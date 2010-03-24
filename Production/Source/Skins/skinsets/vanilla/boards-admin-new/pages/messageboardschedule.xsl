<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'MESSAGEBOARDSCHEDULE']" mode="page">
		<div class="left">
			<h2>Opening Hours</h2>
			<p>Using the following options, select which times users can post to your messageboard. </p>
			<p>
				<strong>Please note:</strong> all times are in Greenwich Mean Time (GMT) and do not take into account British Summer Time (BST). 
				Therefore when the clocks go backward/forward 1 hour, you will need to manually change these times accordingly.
			</p>
		</div>
		<div class="main">
			<xsl:apply-templates select="SITETOPICSSCHEDULE"/>
		</div>
	</xsl:template>
	
	<xsl:template match="SITETOPICSSCHEDULE">
		<form action="#" method="post">
			<input type="hidden" value="update" name="action"/>
			<div>
				<input type="radio" id="twentyfourseven" value="twentyfourseven" name="updatetype">
					<xsl:if test="not(SCHEDULE/EVENT)"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
				</input>
				<label for="twentyfourseven">Open 24/7</label>
			</div>
			<div>
				<input type="radio" name="updatetype" value="sameeveryday" id="sameeveryday">
					<!-- TODO: I don't know what test to put here!! -->
					<xsl:if test="false()"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
				</input>
				<label for="sameeveryday">Open at the same time every day</label>
			</div>
			<div class="form supplemental">
				<label for="sameeveryday-open">Opens:</label>
				<select name="recurrenteventopenhours" id="sameeveryday-open">
					<xsl:call-template name="hours"/>
				</select>
				<select name="recurrenteventopenminutes">
					<xsl:call-template name="minutes"/>
				</select>
				<label for="sameeveryday-close">Closes:</label>
				<select name="recurrenteventclosehours" id="sameeveryday-close">
					<xsl:call-template name="hours"/>
				</select>
				<select name="recurrenteventcloseminutes">
					<xsl:call-template name="minutes"/>
				</select>
			</div>
			<div>
				<input type="radio" name="updatetype" value="eachday" id="eachday">
					<!-- TODO: I don't know what test to put here!! -->
					<xsl:if test="false()"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
				</input>
				<label for="eachday">Open different times each day</label>
			</div>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="1"/>
				<xsl:with-param name="dayName" select="'MONDAY'"/>
				<!-- TODO: what test goes here? -->
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="2"/>
				<xsl:with-param name="dayName" select="'TUESDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="3"/>
				<xsl:with-param name="dayName" select="'WEDNESDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="4"/>
				<xsl:with-param name="dayName" select="'THURSDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="5"/>
				<xsl:with-param name="dayName" select="'FRIDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="6"/>
				<xsl:with-param name="dayName" select="'SATURDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="7"/>
				<xsl:with-param name="dayName" select="'SUNDAY'"/>
				<xsl:with-param name="hours-selected" select="9"/>
				<xsl:with-param name="minutes-selected" select="0"/>
			</xsl:call-template>
			<div class="buttons">
				<input type="submit" name="submit" value="Save" class="mbpreview-button"/>
				<input type="button" name="cancel" value="Cancel" class="mbpreview-button panel-close"/>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template name="hours">
		<xsl:param name="selected"/>
		<option value="0">
			<xsl:if test="$selected = 0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			0</option>
		<option value="1">
			<xsl:if test="$selected = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			1</option>
		<option value="2">
			<xsl:if test="$selected = 2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			2</option>
		<option value="3">
			<xsl:if test="$selected = 3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			3</option>
		<option value="4">
			<xsl:if test="$selected = 4"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			4</option>
		<option value="5">
			<xsl:if test="$selected = 5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			5</option>
		<option value="6">
			<xsl:if test="$selected = 6"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			6</option>
		<option value="7">
			<xsl:if test="$selected = 7"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			7</option>
		<option value="8">
			<xsl:if test="$selected = 8"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			8</option>
		<option value="9">
			<xsl:if test="$selected = 9"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			9</option>
		<option value="10">
			<xsl:if test="$selected = 10"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			10</option>
		<option value="11">
			<xsl:if test="$selected = 11"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			11</option>
		<option value="12">
			<xsl:if test="$selected = 12"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			12</option>
		<option value="13">
			<xsl:if test="$selected = 13"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			13</option>
		<option value="14">
			<xsl:if test="$selected = 14"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			14</option>
		<option value="15">
			<xsl:if test="$selected = 15"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			15</option>
		<option value="16">
			<xsl:if test="$selected = 16"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			16</option>
		<option value="17">
			<xsl:if test="$selected = 17"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			17</option>
		<option value="18">
			<xsl:if test="$selected = 18"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			18</option>
		<option value="19">
			<xsl:if test="$selected = 19"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			19</option>
		<option value="20">
			<xsl:if test="$selected = 20"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			20</option>
		<option value="21">
			<xsl:if test="$selected = 21"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			21</option>
		<option value="22">
			<xsl:if test="$selected = 22"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			22</option>
		<option value="23">
			<xsl:if test="$selected = 23"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			23</option>
	</xsl:template>
	
	<xsl:template name="minutes">
		<xsl:param name="selected"/>
		<option value="0">
			<xsl:if test="$selected = 0"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			0</option>
		<option value="15">
			<xsl:if test="$selected = 15"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			15</option>
		<option value="30">
			<xsl:if test="$selected = 30"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			30</option>
		<option value="45">
			<xsl:if test="$selected = 45"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			45</option>
	</xsl:template>
	
	<xsl:template name="writeDay">
		<xsl:param name="dayName"/>
		<xsl:param name="dayNumber"/>
		<xsl:param name="hours-selected"/>
		<xsl:param name="minutes-selected"/>
		<div class="form supplemental clear">
			<div class="inline first">
				<label><xsl:value-of select="$dayName"/></label>
			</div>
			<div class="inline">
				<input type="checkbox" name="" value="" id="closedallday-{$dayNumber}"/> 
				<label for="closedallday-{$dayNumber}">Closed all day</label>
			</div>
			<div class="inline">
				<input type="hidden" name="eventdaytype" value="{$dayNumber}"/>
				<label for="openhours-{$dayNumber}">Opens:</label>
				<select name="eventhours" id="openhours-{$dayNumber}">
					<xsl:call-template name="hours">
						<xsl:with-param name="selected" select="$hours-selected"/>
					</xsl:call-template>
				</select>
				<select name="eventminutes">
					<xsl:call-template name="minutes">
						<xsl:with-param name="selected" select="$minutes-selected"/>
					</xsl:call-template>
				</select>
			</div>
			<div class="inline">
				<input type="hidden" name="eventdaytype" value="{$dayNumber}"/>
				<label for="closehours-{$dayNumber}">Closes:</label>
				<select name="eventhours" id="closehours-{$dayNumber}">
					<xsl:call-template name="hours">
						<xsl:with-param name="selected" select="$hours-selected"/>
					</xsl:call-template>
				</select>
				<select name="eventminutes">
					<xsl:call-template name="minutes">
						<xsl:with-param name="selected" select="$minutes-selected"/>
					</xsl:call-template>
				</select>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
