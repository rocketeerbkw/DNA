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
  
    <xsl:if test="//PARAMS/PARAM[NAME = 's_success']/VALUE = 'true'">
      <p class="dna-no-error">The opening times have been successfully updated.</p>
    </xsl:if> 
      
    <div class="dna-mb-intro">
      <h2>Opening Times</h2>

      <p>Using the following options, select which times users can post to your messageboard.</p>

      <p>
        <strong>Please note:</strong> all times are in Greenwich Mean Time (GMT) and do not take into account British Summer Time (BST).
        Therefore when the clocks go backward/forward 1 hour, you will need to manually change these times accordingly.
      </p>
    </div>

    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <form action="MessageBoardSchedule?s_success=true" method="post" class="dna-mb-opentime">
        <input type="hidden" value="update" name="action"/>
          <div class="dna-box">
            <h3>Opening Hours</h3>
        
			      <div><xsl:apply-templates select="SITETOPICSSCHEDULE"/></div>
          </div>
          <xsl:call-template name="submitbuttons">
            <xsl:with-param name="cancelUrl" select="'mbadmin?s_mode=admin'" />
          </xsl:call-template>  
      </form>
    </div>
	</xsl:template>
	
	<xsl:template match="SITETOPICSSCHEDULE">
      <div id="dna-mb-openallday">
        <p>
            <input type="radio" id="twentyfourseven" value="twentyfourseven" name="updatetype">
              <xsl:if test="not(SCHEDULE/EVENT)">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="twentyfourseven">Open 24/7</label>
        </p>
      </div>

      <div id="dna-mb-openSame">
        <p>
          <input type="radio" name="updatetype" value="sameeveryday" id="sameeveryday"></input>
          <label for="sameeveryday">Open at the same time every day</label>
        </p>

        <p>
          <input type="hidden" id="7ClosedAllDay"/>
          <label for="recurrenteventopenhours">
            Opens <span class="dna-off">hour</span>
          </label>
          <select name="recurrenteventopenhours" id="recurrenteventopenhours">
            <xsl:call-template name="hours">
              <xsl:with-param name="selected" select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = 7]/@HOURS"/>
            </xsl:call-template>
          </select>
          <label for="recurrenteventopenminutes" class="dna-off">Opens minutes</label>
          <select name="recurrenteventopenminutes" id="recurrenteventopenminutes">
            <xsl:call-template name="minutes">
              <xsl:with-param name="selected" select="SCHEDULE/EVENT[@ACTION = 0]/TIME[@DAYTYPE = 7]/@MINUTES"/>
            </xsl:call-template>
          </select>
        </p>
        
        <p>
          <label for="recurrenteventclosehours">
            Closes <span class="dna-off">hour</span>
          </label>
          <select name="recurrenteventclosehours" id="recurrenteventclosehours">
            <xsl:call-template name="hours">
              <xsl:with-param name="selected" select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = 7]/@HOURS"/>
            </xsl:call-template>
          </select>
          <label for="recurrenteventcloseminutes" class="dna-off">Closes minutes</label>
          <select name="recurrenteventcloseminutes" id="recurrenteventcloseminutes">
            <xsl:call-template name="minutes">
              <xsl:with-param name="selected" select="SCHEDULE/EVENT[@ACTION = 1]/TIME[@DAYTYPE = 7]/@MINUTES"/>
            </xsl:call-template>
          </select>
        </p>
      </div>


      <div id="dna-mb-openDiff">
        <p>
          <input type="radio" name="updatetype" value="eachday" id="eachday">
            <xsl:if test="SCHEDULE/EVENT">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
          </input>
          <label for="eachday">Open at different times each day</label>
        </p>
      
        <table>
        <xsl:call-template name="writeDay">
		  	<xsl:with-param name="dayNumber" select="1"/>
				<xsl:with-param name="dayName" select="'SUNDAY'"/>
			  <xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '1']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '1']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '1']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '1']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'odd'"/>
			</xsl:call-template>
        <xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="2"/>
				<xsl:with-param name="dayName" select="'MONDAY'"/>
        <xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '2']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '2']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '2']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '2']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'even'"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="3"/>
				<xsl:with-param name="dayName" select="'TUESDAY'"/>
				<xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '3']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '3']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '3']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '3']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'odd'"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="4"/>
				<xsl:with-param name="dayName" select="'WEDNESDAY'"/>
				<xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '4']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '4']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '4']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '4']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'even'"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="5"/>
				<xsl:with-param name="dayName" select="'THURSDAY'"/>
				<xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '5']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '5']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '5']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '5']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'odd'"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="6"/>
				<xsl:with-param name="dayName" select="'FRIDAY'"/>
				<xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '6']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '6']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '6']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '6']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'even'"/>
			</xsl:call-template>
			<xsl:call-template name="writeDay">
				<xsl:with-param name="dayNumber" select="7"/>
				<xsl:with-param name="dayName" select="'SATURDAY'"/>
				<xsl:with-param name="open-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '7']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="open-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '0']/TIME[@DAYTYPE = '7']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="close-hours"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '7']/@HOURS"/></xsl:with-param>
				<xsl:with-param name="close-min"><xsl:value-of select="SCHEDULE/EVENT[@ACTION = '1']/TIME[@DAYTYPE = '7']/@MINUTES"/></xsl:with-param>
        <xsl:with-param name="bg" select="'odd'"/>
			</xsl:call-template>
      </table>
      </div>
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
			00</option>
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
		<xsl:param name="open-hours"/>
		<xsl:param name="open-min"/>
    <xsl:param name="close-hours"/>
    <xsl:param name="close-min"/>
    <xsl:param name="bg"/>
		
    
    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="$bg"/>
      </xsl:attribute>
      <th><h4><xsl:value-of select="$dayName"/></h4></th>
      <td>
        <div class="closed dna-off">
        <input type="checkbox" name="" value="" id="closedallday-{$dayNumber}" >
          <xsl:if test="$open-hours = 0 and $open-min =0 and $close-hours = 0 and $close-min = 0">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
        <label for="closedallday-{$dayNumber}">Closed all day</label>
        </div>
      </td>
      <td>
        
        <input type="hidden" name="eventaction" value="0"/>
        <input type="hidden" name="eventdaytype" value="{$dayNumber}"/>
        <label for="openhours-{$dayNumber}">Opens <span class="dna-off">hour</span></label>
        <select name="eventhours" id="openhours-{$dayNumber}">
          <xsl:call-template name="hours">
            <xsl:with-param name="selected" select="$open-hours"/>
          </xsl:call-template>
        </select>
        <label for="openMinutes-{$dayNumber}" class="dna-off">Opens minutes</label>
        <select name="eventminutes" id="openMinutes-{$dayNumber}">
          <xsl:call-template name="minutes">
            <xsl:with-param name="selected" select="$open-min"/>
          </xsl:call-template>
        </select>
      </td>
      <td>
        <input type="hidden" name="eventaction" value="1"/>
        <input type="hidden" name="eventdaytype" value="{$dayNumber}"/>
        <label for="closeHours-{$dayNumber}">Closes <span class="dna-off">hour</span></label>
        <select name="eventhours" id="closeHours-{$dayNumber}">
          <xsl:call-template name="hours">
            <xsl:with-param name="selected" select="$close-hours"/>
          </xsl:call-template>
        </select>
        <label for="closeMinutes-{$dayNumber}" class="dna-off">Closes minutes</label>
        <select name="eventminutes" id="closeMinutes-{$dayNumber}">
          <xsl:call-template name="minutes">
            <xsl:with-param name="selected" select="$close-min"/>
          </xsl:call-template>
        </select>
      </td>
    </tr>
	</xsl:template>

</xsl:stylesheet>
